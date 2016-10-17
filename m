Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47519 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755187AbcJQNai (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 09:30:38 -0400
Subject: Re: [PATCH RFC] xfs: drop SYNC_WAIT from xfs_reclaim_inodes_ag during
 slab reclaim
References: <06aade22-b29e-f55e-7f00-39154f220aa6@fb.com>
 <20161015223454.GS23194@dastard>
 <20161017002427.GA70229@clm-mbp.masoncoding.com>
 <20161017015251.GU23194@dastard>
From: Chris Mason <clm@fb.com>
Message-ID: <e0c37926-a670-98b6-4bd7-b438def130bd@fb.com>
Date: Mon, 17 Oct 2016 09:30:05 -0400
MIME-Version: 1.0
In-Reply-To: <20161017015251.GU23194@dastard>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org



On 10/16/2016 09:52 PM, Dave Chinner wrote:
> On Sun, Oct 16, 2016 at 08:24:33PM -0400, Chris Mason wrote:
>> On Sun, Oct 16, 2016 at 09:34:54AM +1100, Dave Chinner wrote:
>>> On Fri, Oct 14, 2016 at 08:27:24AM -0400, Chris Mason wrote:
>>>>
>>>> Hi Dave,
>>>>
>>>> This is part of a series of patches we're growing to fix a perf
>>>> regression on a few straggler tiers that are still on v3.10.  In this
>>>> case, hadoop had to switch back to v3.10 because v4.x is as much as 15%
>>>> slower on recent kernels.
>>>>
>>>> Between v3.10 and v4.x, kswapd is less effective overall.  This leads
>>>> more and more procs to get bogged down in direct reclaim Using SYNC_WAIT
>>>> in xfs_reclaim_inodes_ag().
>>>>
>>>> Since slab shrinking happens very early in direct reclaim, we've seen
>>>> systems with 130GB of ram where hundreds of procs are stuck on the xfs
>>>> slab shrinker fighting to walk a slab 900MB in size.  They'd have better
>>>> luck moving on to the page cache instead.
>>>
>>> We've already scanned the page cache for direct reclaim by the time
>>> we get to running the shrinkers. Indeed, the amount of work the
>>> shrinkers do is directly controlled by the amount of work done
>>> scanning the page cache beforehand....
>>>
>>>> Also, we're going into direct reclaim much more often than we should
>>>> because kswapd is getting stuck on XFS inode locks and writeback.
>>>
>>> Where and what locks, exactly?
>>
>> This is from v4.0, because all of my newer hosts are trying a
>> variety of patched kernels.  But the traces were very similar on
>> newer kernels:
>>
>> # cat /proc/282/stack
>> [<ffffffff812ea2cd>] xfs_buf_submit_wait+0xbd/0x1d0
>> [<ffffffff812ea6e4>] xfs_bwrite+0x24/0x60
>> [<ffffffff812f18a4>] xfs_reclaim_inode+0x304/0x320
>> [<ffffffff812f1b17>] xfs_reclaim_inodes_ag+0x257/0x370
>> [<ffffffff812f2613>] xfs_reclaim_inodes_nr+0x33/0x40
>> [<ffffffff81300fb9>] xfs_fs_free_cached_objects+0x19/0x20
>> [<ffffffff811bb13b>] super_cache_scan+0x18b/0x190
>> [<ffffffff8115acc6>] shrink_slab.part.40+0x1f6/0x380
>> [<ffffffff8115e9da>] shrink_zone+0x30a/0x320
>> [<ffffffff8115f94f>] kswapd+0x51f/0x9e0
>> [<ffffffff810886b2>] kthread+0xd2/0xf0
>> [<ffffffff81770d88>] ret_from_fork+0x58/0x90
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> This one hurts the most.  While kswapd is waiting for IO, all the
>> other reclaim he might have been doing is backing up.
>
> Which says two things: the journal tail pushing nor the background
> inode reclaim threads are keeping up with dirty inode writeback
> demand. Without knowing why that is occurring, we cannot solve the
> problem.
>
>> The other common path is the pag->pag_ici_reclaim_lock lock in
>> xfs_reclaim_inodes_ag.  It goes through the trylock loop, didn't
>> free enough, and then waits on the locks for real.
>
> Which is the "prevent hundreds of threads from all issuing inode
> writeback concurrently" throttling. Working as designed.

Ok, I think we're just not on the same page about how kswapd is 
designed.  So instead of worrying about some crusty old kernel, lets 
talk about that for a minute.  I'm not trying to explain kswapd to you, 
just putting what I'm seeing from the shrinker in terms of how kswapd 
deals with dirty pages:

LRUs try to keep the dirty pages away from kswapd in hopes that 
background writeback will clean them instead of kswapd.

When system memory pressure gets bad enough, kswapd will call pageout(). 
  This includes a check for congested bdis where it will skip the IO 
because it doesn't want to wait on busy resources.

The main throttling mechanism is to slow down the creation of new dirty 
pages via balance_dirty_pages().

IO is avoided from inside kswapd because there's only one kswapd 
per-numa node.  It is trying to take a global view of the freeable 
memory in the node, instead of focusing on any one individual page.

Shrinkers are a little different because while individual shrinkers have 
a definition of dirty, the general concept doesn't.  kswapd calls into 
the shrinkers to ask them to be smaller.

With dirty pages, kswapd will start IO but not wait on it.
With the xfs shrinker, kswapd does synchronous IO to write a single 
inode in xfs_buf_submit_wait().

With congested BDIs, kswapd will skip the IO and wait for progress after 
running through a good chunk of pages.  With the xfs shrinker, kswapd 
will synchronously wait for progress on a single FS, even if there are 
dozens of other filesystems around.

For the xfs shrinker, the mechanism to throttle new dirty inodes on a 
single FS is stalling every process in the system in direct reclaim?

>
>> XFS is also limiting the direct reclaim speed of all the other
>> slabs.  We have 15 drives, each with its own filesystem.  But end
>> result of the current system is to bottleneck behind whichever FS is
>> slowest at any given moment.
>
> So why is the filesystem slow in 4.0 and not slow at all in 3.10?
>

It's not that v3.10 is fast.  It's just faster.  v4.x is faster in a 
bunch of other ways, but this one part of v3.10 isn't slowing down the 
system as much as this one part of v4.x

> And how does a 4.8 kernel compare, given there were major changes to
> the mm/ subsystem in this release? i.e. are you chasing a mm/
> problem that has already been solved?

We don't think it's already solved in v4.8, but we're setting up a test 
to confirm that.  I'm working on a better simulation of the parts we're 
tripping over so I can model this outside of production.  I definitely 
agree that something is wrong in MM land too, we have to clamp down on 
the dirty ratios much more than we should to keep kswapd from calling 
pageout().

We can dive into workload specifics too, but I'd rather do that against 
simulations where I can try individual experiments more quickly.  The 
reason it takes me a week to get hard numbers is because the workload is 
very inconsistent.  The only way to get a good comparison is to put the 
test kernel on roughly 30 machines and then average major metrics over a 
period of days.  Just installing the kernel takes almost a day because I 
can only reboot one machine every 20 minutes.

-chris
