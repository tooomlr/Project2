#!/bin/bash

INTERVAL=300

#abnormal fluctuations : 10% change in price
THRESHOLD=10

ENDPOINT="https://api.binance.com/api/v3/ticker/price"
symbol="BTCUSDT"
WEBPAGE_URL="https://www.page.html/"

# Set Binance API key and API secret 
API_KEY=""
API_SECRET=""

#Set Telegram Key 
ID_TELEGRAM=""
TOKEN=""

while true; do
response=$(curl -s "$ENDPOINT?symbol=$symbol")
  btc_price=$(echo "$response" | jq -r '.price')

  # Check if the BTC price has changed by more than the threshold

  change=$(echo "($btc_price/$prev_price-1)*100" | bc -l)
  if [ $(echo "$change > $THRESHOLD" | bc) -eq 1 ]; then
  echo "$symbol: $change" >> abnormal_fluctuations.txt

  #Send message to telegram
  message="BTC price has changed by more than $THRESHOLD%. Check out $WEBPAGE_URL for more information."
  curl --data chat_id=$ID_TELEGRAM --data-urlencode "text= $message" "https://api.telegram.org/bot$TOKEN/sendMessage?parse_mode=HTML" 
fi
  
  prev_price=$btc_price

  sleep $INTERVAL
done