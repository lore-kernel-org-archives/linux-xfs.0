Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41052 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752729AbcKNU41 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2016 15:56:27 -0500
Subject: Re: [PATCH RFC] xfs: drop SYNC_WAIT from xfs_reclaim_inodes_ag during
 slab reclaim
References: <06aade22-b29e-f55e-7f00-39154f220aa6@fb.com>
 <20161015223454.GS23194@dastard>
 <20161017002427.GA70229@clm-mbp.masoncoding.com>
 <20161017015251.GU23194@dastard>
 <e0c37926-a670-98b6-4bd7-b438def130bd@fb.com>
 <20161017223057.GV23194@dastard>
 <f6dadb97-4233-4bbf-3edc-4985c7727548@fb.com>
 <20161018020324.GA23194@dastard>
 <20161114005951.GB2127@clm-mbp.thefacebook.com>
 <20161114072708.GN28922@dastard>
From: Chris Mason <clm@fb.com>
Message-ID: <1f19925d-6ba8-9bde-b3a8-0bdade80f564@fb.com>
Date: Mon, 14 Nov 2016 15:56:14 -0500
MIME-Version: 1.0
In-Reply-To: <20161114072708.GN28922@dastard>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 11/14/2016 02:27 AM, Dave Chinner wrote:
> On Sun, Nov 13, 2016 at 08:00:04PM -0500, Chris Mason wrote:
>> On Tue, Oct 18, 2016 at 01:03:24PM +1100, Dave Chinner wrote:
>>
>> [ Long stalls from xfs_reclaim_inodes_ag ]
>>
>>> XFS has *1* tunable that can change the behaviour of metadata
>>> writeback. Please try it.
>>
>> [ weeks go by, so this email is insanely long ]
>>
>> Testing all of this was slow going because two of the three test
>> boxes I had with the hadoop configuration starting having hardware
>> problems.  The good news is that while I was adjusting the
>> benchmark, we lined up access to a bunch of duplicate boxes, so I
>> can now try ~20 different configurations in parallel.
>>
>> My rough benchmark is here:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/simoop.git
>>
>> The command line I ended up using was:
>>
>> simoop -t 512 -m 190 -M 128 -C 28 -r 60000 -f 70 -T 20 -R1 -W 1 -i
>> 60 -w 300 -D 2 /hammer/*
>
> There's a lightly tested patch below that should do the trick.
>
> After 5 minutes on a modified simoop cli on a single filesystem,
> 4.9-rc4+for-next:
>
> $ ./simoop -t 128 -m 50 -M 128 -C 14 -r 60000 -f 2 -T 20 -R1 -W 1 -i 60 -w 300 -D 2 /mnt/scratch
> ....
> Run time: 300 seconds
> Read latency (p50: 3,174,400) (p95: 4,530,176) (p99: 18,055,168)
> Write latency (p50: 14,991,360) (p95: 28,672,000) (p99: 33,325,056)
> Allocation latency (p50: 1,771,520) (p95: 17,530,880) (p99: 23,756,800)
> work rate = 4.75/sec (avg 5.24/sec) (p50: 5.79) (p95: 6.99) (p99: 6.99)
> alloc stall rate = 94.42/sec (avg: 51.63) (p50: 51.60) (p95: 59.12) (p99: 59.12)
>
> With the patch below:
>
> Run time: 300 seconds
> Read latency (p50: 3,043,328) (p95: 3,649,536) (p99: 4,710,400)
> Write latency (p50: 21,004,288) (p95: 27,557,888) (p99: 29,130,752)
> Allocation latency (p50: 280,064) (p95: 680,960) (p99: 863,232)
> work rate = 4.08/sec (avg 4.76/sec) (p50: 5.39) (p95: 6.93) (p99: 6.93)
> alloc stall rate = 0.08/sec (avg: 0.02) (p50: 0.00) (p95: 0.01) (p99: 0.01)
>
> Stall rate went to zero and stayed there at the 120s mark of the
> warmup. Note the p99 difference for read and allocation latency,
> too.
>
> I'll post some graphs tomorrow from my live PCP telemetry that
> demonstrate the difference in behaviour better than any words...

Thanks Dave, this is definitely better.  But at least for the multi-disk 
setup, it's not quite there yet.

Your patch:
___
Run time: 15535 seconds
Read latency (p50: 22,708,224) (p95: 34,668,544) (p99: 41,746,432)
Write latency (p50: 21,200,896) (p95: 34,799,616) (p99: 41,877,504)
Allocation latency (p50: 11,550,720) (p95: 31,424,512) (p99: 39,518,208)
work rate = 7.48/sec (avg 8.41/sec) (p50: 8.69) (p95: 9.57) (p99: 9.87)
alloc stall rate = 14.08/sec (avg: 14.85) (p50: 15.74) (p95: 19.74) 
(p99: 22.04)

Original patch:
___
Run time: 15474 seconds
Read latency (p50: 20,414,464) (p95: 29,786,112) (p99: 34,275,328)
Write latency (p50: 15,155,200) (p95: 25,591,808) (p99: 31,621,120)
Allocation latency (p50: 7,675,904) (p95: 22,970,368) (p99: 29,523,968)
work rate = 8.33/sec (avg 10.54/sec) (p50: 10.54) (p95: 10.58) (p99: 10.58)
alloc stall rate = 37.08/sec (avg: 21.73) (p50: 23.16) (p95: 24.68) 
(p99: 25.00)

v4.8
___
Run time: 15492 seconds
Read latency (p50: 22,642,688) (p95: 35,848,192) (p99: 43,712,512)
Write latency (p50: 21,200,896) (p95: 35,454,976) (p99: 43,450,368)
Allocation latency (p50: 12,599,296) (p95: 34,144,256) (p99: 41,615,360)
work rate = 9.77/sec (avg 8.15/sec) (p50: 8.37) (p95: 9.29) (p99: 9.55)
alloc stall rate = 8.33/sec (avg: 33.65) (p50: 34.52) (p95: 37.40) (p99: 
37.96)

One thing that might have been too far buried in my email yesterday. 
The read/write latencies include the time to start threads, that's not 
just IO in there.

I've had this running all day, but the differences stabilized after 5-10 
minutes.  Everyone's p99s trend higher as the day goes on, but the 
percentage difference stays about the same.

I think the difference between mine and yours is we didn't quite get the 
allocation stalls down to zero, so making tasks wait for the shrinker 
shows up in the end numbers.

For your patch, the stalls from xfs_reclaim_inodes_ag() were about the 
same as the unpatched kernel yesterday.  We still had long tails in the 
30 second+ category.

I did a trace on vmscan:mm_vmscan_direct_reclaim_begin, and 91% of the 
allocation stalls were:

order=0 may_writepage=1 gfp_flags=GFP_HIGHUSER_MOVABLE|__GFP_ZERO 
classzone_idx=3

These are all page faults, either during read() syscalls or when simoop 
was touching all the pages in its mmap()'d area (-M from the cmdline)

One detail I didn't give yesterday was these are all using deadline as 
the IO scheduler.

-chris
