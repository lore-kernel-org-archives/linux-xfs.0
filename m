Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 31 Jul 2008 20:40:43 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m713eehY021042
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2008 20:40:40 -0700
Received: from yw-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 810B419666B6
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2008 20:41:52 -0700 (PDT)
Received: from yw-out-1718.google.com (yw-out-1718.google.com [74.125.46.152]) by cuda.sgi.com with ESMTP id r5kzdGuea4uzCD98 for <xfs@oss.sgi.com>; Thu, 31 Jul 2008 20:41:52 -0700 (PDT)
Received: by yw-out-1718.google.com with SMTP id 5so417263ywm.32
        for <xfs@oss.sgi.com>; Thu, 31 Jul 2008 20:41:52 -0700 (PDT)
Date: Thu, 31 Jul 2008 22:41:50 -0500
From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: 12 Veliciraptors again w/x4 card (~1gbyte/sec aggregate read)!
Message-ID: <20080801034150.GA32026@sewage.raw-sewage.fake>
References: <alpine.DEB.1.10.0807071424100.4694@p34.internal.lan> <4872A2F4.2010604@dgreaves.com> <alpine.DEB.1.10.0807080429440.17980@p34.internal.lan> <alpine.DEB.1.10.0807080438560.17980@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0807080438560.17980@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: David Greaves <david@dgreaves.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jul 08, 2008 at 04:39:34AM -0400, Justin Piszcz wrote:
> On Tue, 8 Jul 2008, Justin Piszcz wrote:
>> On Tue, 8 Jul 2008, David Greaves wrote:
>>> Justin Piszcz wrote:
>>>> Each PCI-e x1 card has 1 veliciraptor on it now.
>>>> Got an x4 card wit 4 sata ports:
>>> Useful - which card?
>>
>> StarTech 4 Port PCI Express x4 SATA II Card Model PEXSATA24E
>>
>>
> Chipset: Marvell 88SX7042
> SATA Connectivity: Use four internal ports at the same time or two internal 
> and two external ports
>
> Which is fully supported in the latest kernels (didn't try an old kernel):
>
> linux-2.6.25.10/drivers/ata/sata_mv.c
>
>   /* Marvell 7042 support */
>   { PCI_VDEVICE(MARVELL, 0x7042), chip_7042 },

How have that card and the array attached to it been doing since you
originally posted this?

Doesn't that HighPoint 23xx card also use the Marvell 88SX7042 chip?
I remember seeing the threads about the HighPoint card silently
corrupting data by silently writing over parts of the disk(s) with
its own info.  I'm guessing that's not a "feature" of the Marvell
chip, but still... admittedly irrational fear here :)

It would be nice if that Supermicro 8-port SATA card (AOC-SAT2-MV8)
was available in PCIe... I wonder if it's possible to just graft
multiple SiI 3132 controllers (2 SATA each) on a single PCIe card?
