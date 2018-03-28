#!/bin/bash

#login to azure
az login

#create the resource group
az group create --name Toxic-Cloud --location eastus

#create the kubernetes cluster.
az aks create -s Standard_DS1_v2 --resource-group Toxic-Cloud -l eastus --name cluster --node-count 3 --generate-ssh-keys

#initalize helm - may not be needed
heml init

#----------------------
#kubernetes setup
#provision mongodb
helm knstall stable/mongodb

#provision rabbitmq
helm install stable/rabbitmq

#spin up all the Order containers 
#remeber to change the values of env vars and ids of the various parts.
kubectl apply -f order_capture.yaml -f order_event_listener.yaml -f order_fulfill.yaml
