Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37529 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752269AbcKPDEF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 22:04:05 -0500
Date: Tue, 15 Nov 2016 22:03:52 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH RFC] xfs: drop SYNC_WAIT from xfs_reclaim_inodes_ag
 during slab reclaim
Message-ID: <20161116030344.GA7746@clm-mbp.masoncoding.com>
References: <20161017223057.GV23194@dastard>
 <f6dadb97-4233-4bbf-3edc-4985c7727548@fb.com>
 <20161018020324.GA23194@dastard>
 <20161114005951.GB2127@clm-mbp.thefacebook.com>
 <20161114072708.GN28922@dastard>
 <1f19925d-6ba8-9bde-b3a8-0bdade80f564@fb.com>
 <20161114235801.GO28922@dastard>
 <20161115055416.GP28922@dastard>
 <77e23f2d-04f6-beb1-4515-6513a82b0686@fb.com>
 <20161116013009.GQ28922@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Disposition: inline
In-Reply-To: <20161116013009.GQ28922@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 16, 2016 at 12:30:09PM +1100, Dave Chinner wrote:
>On Tue, Nov 15, 2016 at 02:00:47PM -0500, Chris Mason wrote:
>> On 11/15/2016 12:54 AM, Dave Chinner wrote:
>> >On Tue, Nov 15, 2016 at 10:58:01AM +1100, Dave Chinner wrote:
>> >>On Mon, Nov 14, 2016 at 03:56:14PM -0500, Chris Mason wrote:
>> >There have been 1.2 million inodes reclaimed from the cache, but
>> >there have only been 20,000 dirty inode buffer writes. Yes, that's
>> >written 440,000 dirty inodes - the inode write clustering is
>> >capturing about 22 inodes per write - but the inode writeback load
>> >is minimal at about 10 IO/s. XFS inode reclaim is not blocking
>> >significantly on dirty inodes.
>>
>> I think our machines are different enough that we're not seeing the
>> same problems.  Or at least we're seeing different sides of the
>> problem.
>>
>> We have 130GB of ram and on average about 300-500MB of XFS slab,
>> total across all 15 filesystems.  Your inodes are small and cuddly,
>> and I'd rather have more than less.  I see more with simoop than we
>> see in prod, but either way its a reasonable percentage of system
>> ram considering the horrible things being done.
>
>So I'm running on 16GB RAM and have 100-150MB of XFS slab.
>Percentage wise, the inode cache is a larger portion of memory than
>in your machines. I can increase the number of files to increase it
>further, but I don't think that will change anything.

I think the way to see what I'm seeing would be to drop the number of IO 
threads (-T) and bump both -m and -M.  Basically less inode working set 
and more memory working set.

>> Both patched (yours or mine) and unpatched, XFS inode reclaim is
>> keeping up.   With my patch in place, tracing during simoop does
>> show more kswapd prio=1 scanning than unpatched, so I'm clearly
>> stretching the limits a little more.  But we've got 30+ days of
>> uptime in prod on almost 60 machines.  The oom rate is roughly in
>> line with v3.10, and miles better than v4.0.
>
>IOWs, you have a workaround that keeps your production systems
>running. That's fine for your machines that are running this load,
>but it's not working well for any of the other other loads I've
>looked at.  That is, removing the throttling from the XFS inode
>shrinker causes instability and adverse reclaim of the inode cache
>in situations where the maintaining a working set in memory is
>required for performance.

We agree on all of this much more than not.  Josef has spent a lot of 
time recently on shrinkers (w/btrfs but the ideas are similar), and I'm 
wrapping duct tape around workloads until the overall architecture is 
less fragile.

Using slab for metadata in an FS like btrfs where dirty metadata is 
almost unbounded is a huge challenge in the current framework.  Ext4 is 
moving to dramatically bigger logs, so it would eventually have the same 
problems.

>
>Indeed, one of the things I noticed with the simoops workload
>running the shrinker patches is that it no longer kept either the
>inode cache or the XFS metadata cache in memory long enough for the
>du to run without requiring IO. i.e. the caches no longer maintained
>the working set of objects needed to optimise a regular operation
>and the du scans took a lot longer.

With simoop, du is supposed to do IO.  It's crazy to expect to be able 
to scan all the inodes on a huge FS (or 15 of them) and keep it all in 
cache along with everything else hadoop does.  I completely agree there 
are cases where having the working set in ram is valid, just simoop 
isn't one ;)

>
>That's why on the vanilla kernels the inode cache footprint went
>through steep sided valleys - reclaim would trash the inode cache,
>but the metadata cache stayed intact and so all the inodes were
>imemdiately pulled from there again and populated back into the
>inode cache. With the patches to remove the XFS shrinker blocking,
>the pressure was moved to other caches like the metadata cache, and
>so the clean inode buffers were reclaimed instead. Hence when the
>inodes were reclaimed, IO was necessary to re-read the inodes during
>the du scan, and hence the cache growth was also slow.
>
>That's what removing the blocking from the shrinker causes the
>overall work rate to go down - it results in the cache not
>maintaining a working set of inodes and so increases the IO load and
>that then slows everything down.

At least on my machines, it made the overall work rate go up.  Both 
simoop and prod are 10-15% faster.  We have one other workload (gluster) 
where I have no idea if it'll help or hurt, but it'll probably be 
January before I have benchmark numbers from them.  I think it'll help, 
they do have more of a real working set in page cache, but it still 
breaks down to random IO over time.

[ snipping out large chunks, lots to agree with in here ]

>We fixed this by decoupling incoming process dirty page throttling
>from the mechanism of cleaning of dirty pages. We now have a queue
>of incoming processes that wait in turn for a number of pages to be
>cleaned, and when that threshold is cleaned by the background
>flusher threads, they are woken and on they go. it's efficient,
>reliable, predictable and, above all, is completely workload
>independent. We haven't had a "system is completely unresponsive
>because I did a large write" problem since we made this
>architectural change - we solved the catastrophic overload problem
>one and for all.(*)

(*) Agree Jens' patches are pushing io scheduling help higher up the 
stack.  It's a big win, but not directly for reclaim.

>
>Direct memory reclaim is doing exactly what the old dirty page
>throttle did - it is taking direct action and relying the underlying
>reclaim mechanisms to throttle overload situations. Just like the
>request queue throttling in the old dirty page code, the memory
>reclaim subsystem is unable to behave sanely when large amounts of
>concurrent pressure is put on it. The throttling happens too late,
>too unpredictably, and too randomly for it to be controllable and
>stable. And the result of that is that application see
>non-deterministic long-tail latencies once memory reclaim starts.
>
>We've already got background reclaim threads - kswapd - and there
>are already hooks for throttling direct reclaim
>(throttle_direct_reclaim()). The problem is that direct reclaim
>throttling only kicks in once we are very near to low memory limits,
>so it doesn't prevent concurency and load from being presented to
>the underlying reclaim mechanism until it's already too late.
>
>IMO, direct reclaim should be replaced with a queuing mechanism and
>deferral to kswapd to clean pages.  Every time kswapd completes a
>batch of freeing, it can check if it's freed enough to allow the
>head of the queue to make progress. If it has, then it can walk down
>the queue waking processes until all the pages it just freed have
>been accounted for.
>
>If we want to be truly fair, this queuing should occur at the
>allocation entry points, not the direct reclaim entry point. i.e if
>we are in a reclaim situation, go sit in the queue until you're told
>we have memory for you and then run allocation.
>
>Then we can design page scanning and shrinkers for maximum
>efficiency, to be fully non-blocking, and to never have to directly
>issue or wait for IO completion. They can all feed back reclaim
>state to a central backoff mechanism which can sleep to alleviate
>situations where reclaim cannot be done without blocking. This
>allows us to constrain reclaim to a well controlled set of
>background threads that we can scale according to observed need.
>

Can't argue here.  The middle ground today is Josef's LRU ideas so that 
slab reclaim has hopes of doing the most useful work instead of just 
writing things and hoping for the best.  It can either be a band-aid or 
a building block depending on how you look at it, but it can help either 
way.

Moving forward, I think I can manage to carry the one line patch in code 
that hasn't measurably changed in years.  We'll get it tested in a 
variety of workloads and come back with more benchmarks for the great 
slab rework coming soon to a v5.x kernel near you.

-chris

