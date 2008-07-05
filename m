Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 05 Jul 2008 16:23:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m65NNnxT019229
	for <xfs@oss.sgi.com>; Sat, 5 Jul 2008 16:23:49 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D23CDA2A47
	for <xfs@oss.sgi.com>; Sat,  5 Jul 2008 16:24:52 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id Z8rKcLFEXweaZrX0 for <xfs@oss.sgi.com>; Sat, 05 Jul 2008 16:24:52 -0700 (PDT)
Date: Sat, 5 Jul 2008 19:24:52 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
In-Reply-To: <48700228.7060904@shaw.ca>
Message-ID: <alpine.DEB.1.10.0807051923380.23222@p34.internal.lan>
References: <fa.u8J+BqAcxU1mg8ob9pMBJaAHBPo@ifi.uio.no> <486FBFAB.5050303@shaw.ca> <alpine.DEB.1.10.0807051527210.8002@p34.internal.lan> <48700228.7060904@shaw.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>



On Sat, 5 Jul 2008, Robert Hancock wrote:

> Justin Piszcz wrote:
>>> Can you post your dmesg from bootup with the controller/drive detection?
>
> So you've got 6 drives in the machine. Intel chipsets normally seem pretty 
> robust with AHCI.
>
> Are you certain that your machine has enough power to run all those drives 
> properly? We've seen in a number of cases that power fluctuations or noise 
> can cause these kinds of errors.

I have a 650watt PSU (nice antec one) and the power draw of the box is 
~148watts w/ veliciraptors, ~250 when fully load all 4 cores + all 12 
disks writing.  I have turned off the irqbalance daemon and I am going to 
see if the problem re-occurs.

Justin.
