Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Jun 2007 13:32:46 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5IKWgdo020729
	for <xfs@oss.sgi.com>; Mon, 18 Jun 2007 13:32:43 -0700
Date: Mon, 18 Jun 2007 07:07:39 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: XFS Tunables for High Speed Linux SW RAID5 Systems?
In-Reply-To: <20070618000502.GU86004887@sgi.com>
Message-ID: <Pine.LNX.4.64.0706180643560.31683@p34.internal.lan>
References: <Pine.LNX.4.64.0706151634130.26033@p34.internal.lan>
 <20070618000502.GU86004887@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, linux-raid@vger.kernel.org

Dave,

Questions inline and below.

On Mon, 18 Jun 2007, David Chinner wrote:

> On Fri, Jun 15, 2007 at 04:36:07PM -0400, Justin Piszcz wrote:
>> Hi,
>>
>> I was wondering if the XFS folks can recommend any optimizations for high
>> speed disk arrays using RAID5?
>
> [sysctls snipped]
>
> None of those options will make much difference to performance.
> mkfs parameters are the big ticket item here....
>
>
>> There is also vm/dirty tunable in /proc.
>
> That changes benchmark times by starting writeback earlier, but
> doesn't affect actual writeback speed.
>
>> I was wondering what are some things to tune for speed?  I've already
>> tuned the MD layer but is there anything with XFS I can also tune?
>>
>> echo "Setting read-ahead to 64MB for /dev/md3"
>> blockdev --setra 65536 /dev/md3
This proved to give the fastest performance, I have always used 4GB then 
recently 8GB of memory in the machine.

http://www.rhic.bnl.gov/hepix/talks/041019pm/schoen.pdf

See page 13.

>
> Why so large? That's likely to cause readahead thrashing problems
> under low memory....
>
>> echo "Setting stripe_cache_size to 16MB for /dev/md3"
>> echo 16384 > /sys/block/md3/md/stripe_cache_size
>>
>> (also set max_sectors_kb) to 128K (chunk size) and disable NCQ
>
> Why do that? You want XFS to issue large I/Os and the block layer
> to split them across all the disks. i.e. you are preventing full
> stripe writes from occurring by doing that.
I use a 128k stripe, what should I use for the max_sectors_kb? I read that 
128kb was optimal.

Can you please comment on all of the optimizations below?

#!/bin/bash

# source profile
. /etc/profile

echo "Optimizing RAID Arrays..."


# This step must come first.
# See: http://www.3ware.com/KB/article.aspx?id=11050

echo "Setting max_sectors_kb to chunk size of RAID5 arrays..."
for i in sdc sdd sde sdf sdg sdh sdi sdj sdk sdl
do
   echo "Setting /dev/$i to 128K..."
   echo 128 > /sys/block/"$i"/queue/max_sectors_kb
done

echo "Setting read-ahead to 64MB for /dev/md3"
blockdev --setra 65536 /dev/md3

echo "Setting stripe_cache_size to 16MB for /dev/md3"
echo 16384 > /sys/block/md3/md/stripe_cache_size

# if you use more than the default 64kb stripe with raid5
# this feature is broken so you need to limit it to 30MB/s
# neil has a patch, not sure when it will be merged.
echo "Setting minimum and maximum resync speed to 30MB/s..."
echo 30000 > /sys/block/md0/md/sync_speed_min
echo 30000 > /sys/block/md0/md/sync_speed_max
echo 30000 > /sys/block/md1/md/sync_speed_min
echo 30000 > /sys/block/md1/md/sync_speed_max
echo 30000 > /sys/block/md2/md/sync_speed_min
echo 30000 > /sys/block/md2/md/sync_speed_max
echo 30000 > /sys/block/md3/md/sync_speed_min
echo 30000 > /sys/block/md3/md/sync_speed_max

# Disable NCQ.
echo "Disabling NCQ..."
for i in sdc sdd sde sdf sdg sdh sdi sdj sdk sdl
do
   echo "Disabling NCQ on $i"
   echo 1 > /sys/block/"$i"/device/queue_depth
done
