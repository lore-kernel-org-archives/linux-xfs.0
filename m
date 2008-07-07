Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Jul 2008 02:56:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m679uJVs030929
	for <xfs@oss.sgi.com>; Mon, 7 Jul 2008 02:56:19 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1650411E18B2
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2008 02:57:23 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id 0K4iLmBazVSY5BZW for <xfs@oss.sgi.com>; Mon, 07 Jul 2008 02:57:23 -0700 (PDT)
Date: Mon, 7 Jul 2008 05:57:23 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
In-Reply-To: <Pine.GSO.4.64.0807071138190.20863@shaka.acc.umu.se>
Message-ID: <alpine.DEB.1.10.0807070554270.32508@p34.internal.lan>
References: <fa.u8J+BqAcxU1mg8ob9pMBJaAHBPo@ifi.uio.no> <486FBFAB.5050303@shaw.ca> <alpine.DEB.1.10.0807051527210.8002@p34.internal.lan> <48700228.7060904@shaw.ca> <alpine.DEB.1.10.0807051923380.23222@p34.internal.lan>
 <Pine.GSO.4.64.0807071138190.20863@shaka.acc.umu.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mattias Wadenstein <maswan@acc.umu.se>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>



On Mon, 7 Jul 2008, Mattias Wadenstein wrote:

> On Sat, 5 Jul 2008, Justin Piszcz wrote:
>
>> 
>> 
>> On Sat, 5 Jul 2008, Robert Hancock wrote:
>> 
>>> Justin Piszcz wrote:
>>>>> Can you post your dmesg from bootup with the controller/drive detection?
>>> 
>>> So you've got 6 drives in the machine. Intel chipsets normally seem pretty 
>>> robust with AHCI.
>>> 
>>> Are you certain that your machine has enough power to run all those drives 
>>> properly? We've seen in a number of cases that power fluctuations or noise 
>>> can cause these kinds of errors.
>> 
>> I have a 650watt PSU (nice antec one) and the power draw of the box is 
>> ~148watts w/ veliciraptors, ~250 when fully load all 4 cores + all 12 disks 
>> writing.  I have turned off the irqbalance daemon and I am going to see if 
>> the problem re-occurs.
>
> Looking at the sum wattage number is really misleading for this. You need to 
> dig out the specs for how many amps it can provide on the different voltages 
> (5 and 12 volts). In particular, many modern PSUs have several separate 12V 
> rails, where one (or more, some have the 12V supply split into 3 or 4 parts!) 
> is used for CPU and GFX card power and usually only one is available for 
> disks.
>
> You can also have plenty of 12V left but run out of 5V, or the other way 
> around. I've spent quite some time trying to find a PSU that would handle 18 
> disks without costing too much. The splitting of the 12V power into separate 
> rails and a general lack of 5V compared to what the disks need according to 
> their specs just made it difficult, and I ended up bonding two PSUs together 
> (linking the ground together with some custom cabling) to get a stable 
> machine again.
>
> /Mattias Wadenstein
>

Good info here indeed but for my case it does not apply.  I used to have 
Raptor150s (12 of them on the same host) the ONLY thing that changed was 
the drives themselves.  And it used to use 150-250 watts (the 3.5" suck up 
a lot more power) the power cables are also exactly the same as they were 
on the Raptor 150s and I never had any issues.

I have two hosts, pretty much idential, I use the Antec TruePower Trio 650 
in each of them.

http://www.antec.com/us/productDetails.php?ProdID=23650

Justin.
