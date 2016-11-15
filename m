Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41235 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751762AbcKOTBG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 14:01:06 -0500
Subject: Re: [PATCH RFC] xfs: drop SYNC_WAIT from xfs_reclaim_inodes_ag during
 slab reclaim
References: <20161017002427.GA70229@clm-mbp.masoncoding.com>
 <20161017015251.GU23194@dastard>
 <e0c37926-a670-98b6-4bd7-b438def130bd@fb.com>
 <20161017223057.GV23194@dastard>
 <f6dadb97-4233-4bbf-3edc-4985c7727548@fb.com>
 <20161018020324.GA23194@dastard>
 <20161114005951.GB2127@clm-mbp.thefacebook.com>
 <20161114072708.GN28922@dastard>
 <1f19925d-6ba8-9bde-b3a8-0bdade80f564@fb.com>
 <20161114235801.GO28922@dastard> <20161115055416.GP28922@dastard>
From: Chris Mason <clm@fb.com>
Message-ID: <77e23f2d-04f6-beb1-4515-6513a82b0686@fb.com>
Date: Tue, 15 Nov 2016 14:00:47 -0500
MIME-Version: 1.0
In-Reply-To: <20161115055416.GP28922@dastard>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 11/15/2016 12:54 AM, Dave Chinner wrote:
> On Tue, Nov 15, 2016 at 10:58:01AM +1100, Dave Chinner wrote:
>> On Mon, Nov 14, 2016 at 03:56:14PM -0500, Chris Mason wrote:
> .....
>> So a single "stall event" blows out the p99 latencies really badly.
>> This is probably the single most important revelation about this
>> so far...
>>
>>> I think the difference between mine and yours is we didn't quite get
>>> the allocation stalls down to zero, so making tasks wait for the
>>> shrinker shows up in the end numbers.
>>
>> Right, but so far we haven't answered the obvious question: what
>> triggers the stall events?
>
> Our prime suspicion in all this has been that blocking on dirty
> inodes has been preventing the XFS inode cache shrinker from making
> progress. That does not appear to be the case at all here. From
> a half hour sample of my local workload:
>
>
>     Inode Clustering
>       xs_iflush_count.......         20119    <<<<<<
>       xs_icluster_flushcnt..         20000
>       xs_icluster_flushinode        440411
>     Vnode Statistics
>       vn_active.............        130903
>       vn_alloc..............             0
>       vn_get................             0
>       vn_hold...............             0
>       vn_rele...............       1217355
>       vn_reclaim............       1217355   <<<<<<<
>       vn_remove.............       1217355
>
> There have been 1.2 million inodes reclaimed from the cache, but
> there have only been 20,000 dirty inode buffer writes. Yes, that's
> written 440,000 dirty inodes - the inode write clustering is
> capturing about 22 inodes per write - but the inode writeback load
> is minimal at about 10 IO/s. XFS inode reclaim is not blocking
> significantly on dirty inodes.

I think our machines are different enough that we're not seeing the same 
problems.  Or at least we're seeing different sides of the problem.

We have 130GB of ram and on average about 300-500MB of XFS slab, total 
across all 15 filesystems.  Your inodes are small and cuddly, and I'd 
rather have more than less.  I see more with simoop than we see in prod, 
but either way its a reasonable percentage of system ram considering the 
horrible things being done.

Both patched (yours or mine) and unpatched, XFS inode reclaim is keeping 
up.   With my patch in place, tracing during simoop does show more 
kswapd prio=1 scanning than unpatched, so I'm clearly stretching the 
limits a little more.  But we've got 30+ days of uptime in prod on 
almost 60 machines.  The oom rate is roughly in line with v3.10, and 
miles better than v4.0.

One other difference is that I have 15 filesystems being shrunk in 
series, so my chances of hitting a long stall are much higher.  If I let 
bpf tracing on shrink_slab() latencies run for 600 seconds, I see v4.8 
called shrink_slab roughly 43,000 times.

It spent a total of 244 wall clock seconds in the shrinkers.  Giving us 
an average of .0056 seconds per call.  But 67 of those calls consumed 
243 of those seconds.  The other second of wall time was spread over the 
other 42,000+ calls.

On your machine, you can see the VM wreck your page cache and inode 
caches during the run.  This isn't too surprising because the pages are 
really use once.  We read a random file, we write a random file, and we 
should expect these pages to be gone before we ever use them again.  The 
real page cache working set of the load is:

number of workers * number of IO threads * 1MB or so for good streaming.

I've got simoop cranked a little harder than you, so my allocation 
stalls are in more of a steady state (20/second).  lru_pgs tends to 
shuffle between 12K and 13K per node for most of any tracing runs.

[ tracing analysis ]

>
> The XFS inode shrinker blocking plays no significant part in this
> series of events. yes, it contributes to /reclaim latency/, but it
> is not the cause of the catastrophic breakdown that results in
> kswapd emptying the page cache and the slab caches to accomodate the
> memory demand coming from userspace. We can fix the blocking
> problems with the XFS shrinker, but it's not the shrinker's job to
> stop this overload situation from happening.

My bigger concern with the blocking in the shrinker was more around the 
pile up of processes arguing about how to free a relatively small amount 
of ram.  The source of the overload for us is almost always going to be 
the users, and any little bit of capacity we give them back will get 
absorbed with added load.

>
> Indeed, I just ran the workload with my patch and captured an alloc
> stall in the same manner with the same tracing. It has the same
> "kswapd keeps being run and escalating reclaim until there's nothing
> left to reclaim" behaviour. kswapd never blocks in the XFS inode
> shrinker now, so the allocation latencies are all from direct
> reclaim doing work, which is exactly as it should be.
>
> The fact that we are seeing dirty page writeback from kswapd
> indicates that the memory pressure this workload generates from
> userspace is not being adequately throttled in
> throttle_direct_reclaim() to allow dirty writeback to be done in an
> efficient and timely manner. The memory reclaim throttling needs to
> back off more in overload situations like this - we need to slow
> down the incoming demand to the reclaim rate rather than just
> increasing pressure and hoping that kswapd doesn't burn up in a ball
> of OOM....

Johannes was addressing the dirty writeback from kswapd.  His first 
patch didn't make as big a difference as we hoped, but I've changed 
around simoop a bunch since then.  We'll try again.

-chris
