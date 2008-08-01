Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Aug 2008 01:11:38 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m718BYBO019934
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2008 01:11:34 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C260E1967F12
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2008 01:12:46 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id 8LxbVS60esK6GoHG for <xfs@oss.sgi.com>; Fri, 01 Aug 2008 01:12:46 -0700 (PDT)
Date: Fri, 1 Aug 2008 04:12:45 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 12 Veliciraptors again w/x4 card (~1gbyte/sec aggregate read)!
In-Reply-To: <20080801034150.GA32026@sewage.raw-sewage.fake>
Message-ID: <alpine.DEB.1.10.0808010410340.13630@p34.internal.lan>
References: <alpine.DEB.1.10.0807071424100.4694@p34.internal.lan> <4872A2F4.2010604@dgreaves.com> <alpine.DEB.1.10.0807080429440.17980@p34.internal.lan> <alpine.DEB.1.10.0807080438560.17980@p34.internal.lan> <20080801034150.GA32026@sewage.raw-sewage.fake>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matt Garman <matthew.garman@gmail.com>
Cc: David Greaves <david@dgreaves.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com



On Thu, 31 Jul 2008, Matt Garman wrote:

> On Tue, Jul 08, 2008 at 04:39:34AM -0400, Justin Piszcz wrote:
>> On Tue, 8 Jul 2008, Justin Piszcz wrote:
>>> On Tue, 8 Jul 2008, David Greaves wrote:
>>>> Justin Piszcz wrote:
>>>>> Each PCI-e x1 card has 1 veliciraptor on it now.
>>>>> Got an x4 card wit 4 sata ports:
>>>> Useful - which card?
>>>
>>> StarTech 4 Port PCI Express x4 SATA II Card Model PEXSATA24E
>>>
>>>
>> Chipset: Marvell 88SX7042
>> SATA Connectivity: Use four internal ports at the same time or two internal
>> and two external ports
>>
>> Which is fully supported in the latest kernels (didn't try an old kernel):
>>
>> linux-2.6.25.10/drivers/ata/sata_mv.c
>>
>>   /* Marvell 7042 support */
>>   { PCI_VDEVICE(MARVELL, 0x7042), chip_7042 },
>
> How have that card and the array attached to it been doing since you
> originally posted this?
No problems to report yet, working well, I wish I had multiple x4 or x16 
slots and use those instead of x1 cards (the mobo would need to support 
the I/O as well)..

>
> Doesn't that HighPoint 23xx card also use the Marvell 88SX7042 chip?
I read remeber 'locked' 64kb read problem but not any corruption issue.

> I remember seeing the threads about the HighPoint card silently
> corrupting data by silently writing over parts of the disk(s) with
Also I MD5SUM -c (verify) 100-150GiB of data daily or so to make sure it 
is OK, so far, no problems.

> its own info.  I'm guessing that's not a "feature" of the Marvell
> chip, but still... admittedly irrational fear here :)
Have not seen it yet.

>
> It would be nice if that Supermicro 8-port SATA card (AOC-SAT2-MV8)
> was available in PCIe... I wonder if it's possible to just graft
> multiple SiI 3132 controllers (2 SATA each) on a single PCIe card?
Yes, I asked Supermicro about it and they never mailed me back about a 
PCIe version..

That's a good question, I suppose if it was easy it would have already 
been done?

Justin.
