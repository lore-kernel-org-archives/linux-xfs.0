Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 09:59:57 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8QGxoSd023277
	for <linux-xfs@oss.sgi.com>; Wed, 26 Sep 2007 09:59:52 -0700
Date: Wed, 26 Sep 2007 12:59:49 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
In-Reply-To: <20070926165412.GE30287@p15145560.pureserver.info>
Message-ID: <Pine.LNX.4.64.0709261258180.24646@p34.internal.lan>
References: <20070923093841.GH19983@p15145560.pureserver.info>
 <18166.25242.174049.175729@base.ty.sabi.co.UK> <20070926145417.GC30287@p15145560.pureserver.info>
 <Pine.LNX.4.64.0709261227260.15219@p34.internal.lan>
 <20070926165412.GE30287@p15145560.pureserver.info>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ralf Gross <Ralf-Lists@ralfgross.de>
Cc: linux-xfs@oss.sgi.com



On Wed, 26 Sep 2007, Ralf Gross wrote:

> Justin Piszcz schrieb:
>>>
>>>  /sbin/blockdev --setra 16384  /dev/sdc
>>>
>>> was the key to ~400 MB/s read performance.
>>
>> Nice, what do you get for write speed?
>
> Still 170-200 MB/s. The command above just tunes the read ahead value.
>
> Ralf
>
>

Yes, I understand; what is the equivalent tweak for HW RAID? I have tried 
to tweak some HW RAIDS (3ware 9550SX's) with ~10 drives and one can set 
the read ahead for better reads but writes are still slow, that 3ware 
'tuning' doc always get passed around but it never helps much at least in 
my testing.

I wonder where the bottleneck lies.

Justin.
