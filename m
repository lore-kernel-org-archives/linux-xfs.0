Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 28 May 2008 12:21:43 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4SJLfoO007551
	for <xfs@oss.sgi.com>; Wed, 28 May 2008 12:21:41 -0700
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD788119D7AB
	for <xfs@oss.sgi.com>; Wed, 28 May 2008 12:22:32 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com with ESMTP id KsT72ZZ5UZjyBMjl for <xfs@oss.sgi.com>; Wed, 28 May 2008 12:22:32 -0700 (PDT)
Message-ID: <483DB0EC.3090403@redhat.com>
Date: Wed, 28 May 2008 15:22:20 -0400
From: Chris Snook <csnook@redhat.com>
MIME-Version: 1.0
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan> <483D7CE8.4000600@redhat.com> <alpine.DEB.1.10.0805281329450.29755@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0805281329450.29755@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com

Justin Piszcz wrote:
> 
> 
> On Wed, 28 May 2008, Chris Snook wrote:
> 
>> Justin Piszcz wrote:
>>> Hardware:
>>>
>>> 1. Utilized (6) 400 gigabyte sata hard drives.
>>> 2. Everything is on PCI-e (965 chipset & a 2port sata card)
>>>
>>> Used the following 'optimizations' for all tests.
>>>
>>> # Set read-ahead.
>>> echo "Setting read-ahead to 64 MiB for /dev/md3"
>>> blockdev --setra 65536 /dev/md3
>>>
>>> # Set stripe-cache_size for RAID5.
>>> echo "Setting stripe_cache_size to 16 MiB for /dev/md3"
>>> echo 16384 > /sys/block/md3/md/stripe_cache_size
>>>
>>> # Disable NCQ on all disks.
>>> echo "Disabling NCQ on all disks..."
>>> for i in $DISKS
>>> do
>>>   echo "Disabling NCQ on $i"
>>>   echo 1 > /sys/block/"$i"/device/queue_depth
>>> done
>>
>> Given that one of the greatest benefits of NCQ/TCQ is with parity 
>> RAID, I'd be fascinated to see how enabling NCQ changes your results.  
>> Of course, you'd want to use a single SATA controller with a known 
>> good NCQ implementation, and hard drives known to not do stupid things 
>> like disable readahead when NCQ is enabled.
> Only/usually on multi-threaded jobs/tasks, yes?

Generally, yes, but there's caching and readahead at various layers in 
software that can expose the benefit on certain single-threaded 
workloads as well.

> Also, I turn off NCQ on all of my hosts that has it enabled by default 
> because
> there are many bugs that occur when NCQ is on, they are working on it in 
> the
> libata layer but IMO it is not safe at all for running SATA disks w/NCQ as
> with it on I have seen drives drop out of the array (with it off, no 
> problems).
> 

Are you using SATA drives with RAID-optimized firmware?  Most SATA 
manufacturers have variants of their drives for a few dollars more that 
have firmware that provides bounded latency for error recovery 
operations, for precisely this reason.

-- Chris
