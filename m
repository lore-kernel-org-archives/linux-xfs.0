Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56981 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754925AbcJQXVI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 19:21:08 -0400
Subject: Re: [PATCH RFC] xfs: drop SYNC_WAIT from xfs_reclaim_inodes_ag during
 slab reclaim
References: <06aade22-b29e-f55e-7f00-39154f220aa6@fb.com>
 <20161015223454.GS23194@dastard>
 <20161017002427.GA70229@clm-mbp.masoncoding.com>
 <20161017015251.GU23194@dastard>
 <e0c37926-a670-98b6-4bd7-b438def130bd@fb.com>
 <20161017223057.GV23194@dastard>
From: Chris Mason <clm@fb.com>
Message-ID: <f6dadb97-4233-4bbf-3edc-4985c7727548@fb.com>
Date: Mon, 17 Oct 2016 19:20:56 -0400
MIME-Version: 1.0
In-Reply-To: <20161017223057.GV23194@dastard>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org



On 10/17/2016 06:30 PM, Dave Chinner wrote:
> On Mon, Oct 17, 2016 at 09:30:05AM -0400, Chris Mason wrote:
>> On 10/16/2016 09:52 PM, Dave Chinner wrote:
>>> On Sun, Oct 16, 2016 at 08:24:33PM -0400, Chris Mason wrote:
>>>> On Sun, Oct 16, 2016 at 09:34:54AM +1100, Dave Chinner wrote:
>>>> This one hurts the most.  While kswapd is waiting for IO, all the
>>>> other reclaim he might have been doing is backing up.
>>>
>>> Which says two things: the journal tail pushing nor the background
>>> inode reclaim threads are keeping up with dirty inode writeback
>>> demand. Without knowing why that is occurring, we cannot solve the
>>> problem.
>>>
>>>> The other common path is the pag->pag_ici_reclaim_lock lock in
>>>> xfs_reclaim_inodes_ag.  It goes through the trylock loop, didn't
>>>> free enough, and then waits on the locks for real.
>>>
>>> Which is the "prevent hundreds of threads from all issuing inode
>>> writeback concurrently" throttling. Working as designed.
>>
>> Ok, I think we're just not on the same page about how kswapd is
>> designed.
>
> Chris, I understand perfectly well what kswapd is and how it is
> supposed to work. I also understand how shrinkers work and how they
> are supposed to interact with page reclaim - my dirty paws are all
> over the shrinker infrastructure (context specific shrinkers,
> NUMA, GFP_NOFS anti-windup mechanisms, cgroup, etc).

Dave, I'm just trying break down the conversation to a series common 
ground vocabulary that I know you understand.

I'll come back with a workload in .c form.  You can run the workload and 
decide for yourself if the shrinkers are incorrectly bottlencecking the 
system.

>
>> The main throttling mechanism is to slow down the creation of new
>> dirty pages via balance_dirty_pages().
>
> I'm also the guy who architected the IO-less dirty page throttling
> infrastructure so there's not much you can teach me about that,
> either. Indeed, the XFS behaviour that you want to remove implements
> a similar (but much more complex) feedback mechanism as the IO-less
> dirty throttle.
>
>> IO is avoided from inside kswapd because there's only one kswapd
>> per-numa node.  It is trying to take a global view of the freeable
>> memory in the node, instead of focusing on any one individual page.
>
> kswapd is also the "get out of gaol free" thread for reclaim when
> the memory pressure is entirely filesystem bound and so direct
> reclaim skips all filesystem reclaim because GFP_NOFS is being
> asserted. This happens a lot in XFS.....
>
> The result of this is that only in kswapd context (i.e. GFP_KERNEL,
> PF_KSWAPD shrinker context) can we do the things necessary to
> /guarantee forwards reclaim progress/.  That means kswapd might
> sometimes be slow, but if we don't allow the shrinker to block from
> time to time then there's every chance that reclaim will not make
> progress.
>

Sure, if the shrinker blocked from time to time, I wouldn't be sending 
this email.

>> Shrinkers are a little different because while individual shrinkers
>> have a definition of dirty, the general concept doesn't.  kswapd
>> calls into the shrinkers to ask them to be smaller.
>
> Well, that's not exactly what the shrinkers are being asked to do.
> Speaking as the guy who designed the current shrinker API, shrinkers
> are being asked to /scan their subsystem/ and take actions that will
> /allow/ memory to be reclaimed. Not all shrinkers sit in front of
> slab caches - some sit on hardware related pools and trigger early
> garbage collection of completed commands and queues. e.g. the DRI
> subsystem shrinkers. Shrinkers are for more than just slab caches
> these days - they are a general "memory pressure notification"
> mechanism and need to be thought of as such rather than a traditional
> "slab cache shrinker".

Yes, which is why its so important that a single individual shrinker not 
block all the other shrinkers from happening.

>
> IOWs, the actions that shrinkers take may not directly free memory,
> but they may result in memory becoming reclaimable in the near
> future e.g. writing back dirty inodes doesn't free memory - it can
> actually create memory demand - but it does then allow the inodes
> and their backing buffers to be reclaimed once the inodes are clean.
>
> To allow such generic implementations to exist, shrinkers are
> allowed to block just like the page cache reclaim is allowed to
> block. Blocking should be as limited as possible, but it is allowed
> as it may be necessary to guarantee progress.
>
> The difference here is that page cache reclaim has a far more
> context in which to make decisions on whether to block or not.
> Shrinkers have a gfp mask, and nothing else. i.e shrinkers are not
> given enough context by the mm subsystem to make smart decisions on
> how much they are allowed to block. e.g. GFP_NOFS means no
> filesystem shrinker can run, even though the memory allocation may
> be coming from a different fs and there's no possibility of a
> deadlock.
>
> I've been talking about this with the mm/ guys and what we can do
> differently to pass more context to the shrinkers (e.g. task based
> reclaim context structures rather than GFP_* flags passed on the
> stack) so we can be smarter in the shrinkers about what we can and
> can't do.
>
>> With dirty pages, kswapd will start IO but not wait on it.
>> With the xfs shrinker, kswapd does synchronous IO to write a single
>> inode in xfs_buf_submit_wait().
>
> That's because there is /no other throttling mechanism/ for shrinker
> controlled slab caches. We can't throttle at allocation time because
> we have no mechanism for either counting or limiting the number of
> dirty objects in a slab caches, like we do the page cache. We have
> /limited/ control via the size of the filesystem journal (which is
> why I've been asking for that information!), but realistically the
> only solid, reliable method we have to prevent excessive dirty inode
> accumulation in large memory machines with multiple filesystems and
> slow disks is to throttle memory allocation to the rate at which we
> can reclaim inodes.
>
> This prevents the sorts of situations we were regularly seeing 7-8
> years ago where a freeze (for a snapshot) or unmount could take
> /hours/ because we have built up hundreds of thousands of dirty
> inodes in cache over a period of days because the slow SATA RAID6
> array can only do 50 write IOPS.....
>
> i.e. there are many, many good reasons for why XFS treats inode
> reclaim the way it does. I don't expect you to understand all the
> issues that we are preventing by throttling memory allocation like
> this, but I do expect you to respect the fact it's done for very
> good reasons.
>
>> With congested BDIs, kswapd will skip the IO and wait for progress
>> after running through a good chunk of pages.  With the xfs shrinker,
>> kswapd will synchronously wait for progress on a single FS, even if
>> there are dozens of other filesystems around.
>
> Yes, that can happen but, again, this behaviour indicates something
> else is wrong and the system is out of whack in some way.  In the
> normal case, kswapd will only block on IO long enough for the other
> other async threads run through inode writeback and clean inode
> reclaim as efficiently as possible. By the time that the shrinker
> wakes up after blocking on an IO, it should either have clean inodes
> to reclaim or nothing more to do.
>
> What you are reporting is equivalent to having pageout() run and do
> all the writeback (badly) instead of the bdi flusher threads doing
> all the writeback (efficiently). pageout() is a /worst case/
> behaviour we try very hard to avoid and when it occurs it is
> generally indicative of some other problem or imbalance. Same goes
> here for the inode shrinker.

Yes!  But the big difference is that pageout() already has a backoff for 
congestion.  The xfs shrinker doesn't.

>
>> For the xfs shrinker, the mechanism to throttle new dirty inodes on
>> a single FS is stalling every process in the system in direct
>> reclaim?
>
> We're not throttling dirty inodes - we are throttling memory
> allocation because that's the only hammer we have to prevent
> excessive buildup of dirty of inodes that have already been
> allocated.
>
> We can't do that throttling when we dirty inodes because that
> happens in transaction context holding locked objects and blocking
> there waiting on inode writeback progress will cause journal
> deadlocks....
>
> This stuff is way more complex than just "have cache, will shrink".

Actually we can easily throttle after common metadata operations that 
dirty inodes.  There aren't many, and the throttling can be done after 
the transaction locks are dropped.

>
>> We don't think it's already solved in v4.8, but we're setting up a
>> test to confirm that.  I'm working on a better simulation of the
>> parts we're tripping over so I can model this outside of production.
>> I definitely agree that something is wrong in MM land too, we have
>> to clamp down on the dirty ratios much more than we should to keep
>> kswapd from calling pageout().
>
> Having pageout() run is pretty indicative of instantaneous memory
> demand being significantly higher than the IO throughput of the
> storage subsystem and the only reclaimable memory in the system
> being dirty filesystem caches. i.e. background writeback is not
> keeping up memory demand and dirtying rates for some reason. The
> general rule of thumb is that if getting pageout() is occurring then
> the IO subsystem is about to die a horrible death of random IO.
>
> If you're taking great lengths to avoid pageout() from being called,
> then it's no surprise to me that your workload is, instead,
> triggering the equivalent "oh shit, we're in real trouble here"
> behaviour in XFS inode cache reclaim.  I also wonder, after turning
> down the dirty ratios, if you've done other typical writeback tuning
> tweaks like speeding up XFS's periodic metadata writeback to clean
> inodes faster in the absence of journal pressure.

No, we haven't.  I'm trying really hard to avoid the need for 50 billion 
tunables when the shrinkers are so clearly doing the wrong thing.

>
> It's detailed information like this that I've been asking for -
> there's good reasons I've asked for that information, and any
> further discussion will just be a waste of my time without all the
> details I've already asked for.

I'll send reproduction workloads.  It'll take a few days to nail them 
down, but it'll be much easier to talk about than all of hadoop.

-chris
