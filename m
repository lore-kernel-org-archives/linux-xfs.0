Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Jul 2008 01:38:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m688cU1k012142
	for <xfs@oss.sgi.com>; Tue, 8 Jul 2008 01:38:30 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AE5542C7411
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2008 01:39:35 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id yLPPKBtiWZMIg74P for <xfs@oss.sgi.com>; Tue, 08 Jul 2008 01:39:35 -0700 (PDT)
Date: Tue, 8 Jul 2008 04:39:34 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 12 Veliciraptors again w/x4 card (~1gbyte/sec aggregate read)!
In-Reply-To: <alpine.DEB.1.10.0807080429440.17980@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0807080438560.17980@p34.internal.lan>
References: <alpine.DEB.1.10.0807071424100.4694@p34.internal.lan> <4872A2F4.2010604@dgreaves.com> <alpine.DEB.1.10.0807080429440.17980@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Greaves <david@dgreaves.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com



On Tue, 8 Jul 2008, Justin Piszcz wrote:

>
>
> On Tue, 8 Jul 2008, David Greaves wrote:
>
>> Justin Piszcz wrote:
>>> Each PCI-e x1 card has 1 veliciraptor on it now.
>>> Got an x4 card wit 4 sata ports:
>> 
>> Useful - which card?
>> 
>> David
>> 
>> 
>
> StarTech 4 Port PCI Express x4 SATA II Card Model PEXSATA24E
>
> Justin.
>
>
>
Chipset: Marvell 88SX7042
SATA Connectivity: Use four internal ports at the same time or two 
internal and two external ports

Which is fully supported in the latest kernels (didn't try an old kernel):

linux-2.6.25.10/drivers/ata/sata_mv.c

   /* Marvell 7042 support */
   { PCI_VDEVICE(MARVELL, 0x7042), chip_7042 },
