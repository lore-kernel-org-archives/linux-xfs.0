Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 28 May 2008 10:31:57 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4SHVrVU027981
	for <xfs@oss.sgi.com>; Wed, 28 May 2008 10:31:53 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67C821747517
	for <xfs@oss.sgi.com>; Wed, 28 May 2008 10:32:44 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id PkO5G838xwkAtQAz for <xfs@oss.sgi.com>; Wed, 28 May 2008 10:32:44 -0700 (PDT)
Date: Wed, 28 May 2008 13:32:44 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Performance Characteristics of All Linux RAIDs
 (mdadm/bonnie++)
In-Reply-To: <483D7CE8.4000600@redhat.com>
Message-ID: <alpine.DEB.1.10.0805281329450.29755@p34.internal.lan>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan> <483D7CE8.4000600@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Snook <csnook@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com



On Wed, 28 May 2008, Chris Snook wrote:

> Justin Piszcz wrote:
>> Hardware:
>> 
>> 1. Utilized (6) 400 gigabyte sata hard drives.
>> 2. Everything is on PCI-e (965 chipset & a 2port sata card)
>> 
>> Used the following 'optimizations' for all tests.
>> 
>> # Set read-ahead.
>> echo "Setting read-ahead to 64 MiB for /dev/md3"
>> blockdev --setra 65536 /dev/md3
>> 
>> # Set stripe-cache_size for RAID5.
>> echo "Setting stripe_cache_size to 16 MiB for /dev/md3"
>> echo 16384 > /sys/block/md3/md/stripe_cache_size
>> 
>> # Disable NCQ on all disks.
>> echo "Disabling NCQ on all disks..."
>> for i in $DISKS
>> do
>>   echo "Disabling NCQ on $i"
>>   echo 1 > /sys/block/"$i"/device/queue_depth
>> done
>
> Given that one of the greatest benefits of NCQ/TCQ is with parity RAID, I'd 
> be fascinated to see how enabling NCQ changes your results.  Of course, you'd 
> want to use a single SATA controller with a known good NCQ implementation, 
> and hard drives known to not do stupid things like disable readahead when NCQ 
> is enabled.
Only/usually on multi-threaded jobs/tasks, yes?

Also, I turn off NCQ on all of my hosts that has it enabled by default because
there are many bugs that occur when NCQ is on, they are working on it in the
libata layer but IMO it is not safe at all for running SATA disks w/NCQ as
with it on I have seen drives drop out of the array (with it off, no problems).
