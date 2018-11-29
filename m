Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:29946 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726795AbeK2NVr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Nov 2018 08:21:47 -0500
Date: Thu, 29 Nov 2018 13:18:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Non-blocking socket stuck for multiple seconds on
 xfs_reclaim_inodes_ag()
Message-ID: <20181129021800.GQ6311@dastard>
References: <CABWYdi1YZp+baxpON2R6mP09pjkUz5D-OE7Z2KmwVGycYTN-AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABWYdi1YZp+baxpON2R6mP09pjkUz5D-OE7Z2KmwVGycYTN-AA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ivan Babrou <ivan@cloudflare.com>
Cc: linux-xfs@vger.kernel.org, Shawn Bohrer <sbohrer@cloudflare.com>

On Wed, Nov 28, 2018 at 04:36:25PM -0800, Ivan Babrou wrote:
> Hello,
> 
> We're experiencing some interesting issues with memory reclaim, both
> kswapd and direct reclaim.
> 
> A typical machine is 2 x NUMA with 128GB of RAM and 6 XFS filesystems.
> Page cache is around 95GB and dirty pages hover around 50MB, rarely
> jumping up to 1GB.

What is your workload?

> The catalyst of our issue is terrible disks. It's not uncommon to see
> the following stack in hung task detector:
> 
> Nov 15 21:55:13 21m21 kernel: INFO: task some-task:156314 blocked for
> more than 10 seconds.
> Nov 15 21:55:13 21m21 kernel:       Tainted: G           O
> 4.14.59-cloudflare-2018.7.5 #1
> Nov 15 21:55:13 21m21 kernel: "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Nov 15 21:55:13 21m21 kernel: some-task     D11792 156314 156183 0x00000080
> Nov 15 21:55:13 21m21 kernel: Call Trace:
> Nov 15 21:55:13 21m21 kernel:  ? __schedule+0x21a/0x820
> Nov 15 21:55:13 21m21 kernel:  schedule+0x28/0x80
> Nov 15 21:55:13 21m21 kernel:  schedule_preempt_disabled+0xa/0x10
> Nov 15 21:55:13 21m21 kernel:  __mutex_lock.isra.2+0x16a/0x490
> Nov 15 21:55:13 21m21 kernel:  ? xfs_reclaim_inodes_ag+0x265/0x2d0
> Nov 15 21:55:13 21m21 kernel:  xfs_reclaim_inodes_ag+0x265/0x2d0
> Nov 15 21:55:13 21m21 kernel:  ? kmem_cache_alloc+0x14d/0x1b0
> Nov 15 21:55:13 21m21 kernel:  ? radix_tree_gang_lookup_tag+0xc4/0x130
> Nov 15 21:55:13 21m21 kernel:  ? __list_lru_walk_one.isra.5+0x33/0x130
> Nov 15 21:55:13 21m21 kernel:  xfs_reclaim_inodes_nr+0x31/0x40
> Nov 15 21:55:13 21m21 kernel:  super_cache_scan+0x156/0x1a0
> Nov 15 21:55:13 21m21 kernel:  shrink_slab.part.51+0x1d2/0x3a0
> Nov 15 21:55:13 21m21 kernel:  shrink_node+0x113/0x2e0
> Nov 15 21:55:13 21m21 kernel:  do_try_to_free_pages+0xb3/0x310
> Nov 15 21:55:13 21m21 kernel:  try_to_free_pages+0xd2/0x190
> Nov 15 21:55:13 21m21 kernel:  __alloc_pages_slowpath+0x3a3/0xdc0
> Nov 15 21:55:13 21m21 kernel:  ? ip_output+0x5c/0xc0
> Nov 15 21:55:13 21m21 kernel:  ? update_curr+0x141/0x1a0
> Nov 15 21:55:13 21m21 kernel:  __alloc_pages_nodemask+0x223/0x240
> Nov 15 21:55:13 21m21 kernel:  skb_page_frag_refill+0x93/0xb0
> Nov 15 21:55:13 21m21 kernel:  sk_page_frag_refill+0x19/0x80
> Nov 15 21:55:13 21m21 kernel:  tcp_sendmsg_locked+0x247/0xdc0
> Nov 15 21:55:13 21m21 kernel:  tcp_sendmsg+0x27/0x40
> Nov 15 21:55:13 21m21 kernel:  sock_sendmsg+0x36/0x40
> Nov 15 21:55:13 21m21 kernel:  sock_write_iter+0x84/0xd0
> Nov 15 21:55:13 21m21 kernel:  __vfs_write+0xdd/0x140
> Nov 15 21:55:13 21m21 kernel:  vfs_write+0xad/0x1a0
> Nov 15 21:55:13 21m21 kernel:  SyS_write+0x42/0x90
> Nov 15 21:55:13 21m21 kernel:  do_syscall_64+0x60/0x110
> Nov 15 21:55:13 21m21 kernel:  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> 
> Here "some-task" is trying to send some bytes over network and it's
> stuck in direct reclaim. Naturally, kswapd is not keeping up with its
> duties.

That's not kswapd causing the problem here, that's direct reclaim.

> It seems to me that our terrible disks sometimes take a pause to think
> about the meaning of life for a few seconds.

You've probably got lots of dirty inodes backed up waiting for IO.

How big are xfs inode slab caches (slabinfo output, please)? How big are the logs
on the filesystems on the machine (xfs_info output, please)?

> During that time XFS
> shrinker is stuck, which drives the whole system out of free memory
> and in turns triggers direct reclaim.

It happens the other way around. What you have here is direct
reclaim trying to get the reclaim lock for a given AG to be able to
reclaim inodes from it. direct reclaim only gets stuck here when all
AGs are already being reclaimed from (i.e. already under direct
reclaim).

> One solution to this is to not go into direct reclaim by keeping more
> free pages with vm.watermark_scale_factor,  but I'd like to discard
> this and argue that we're going to hit direct reclaim at some point
> anyway.

Right, but the problem is that the mm/ subsystem allows effectively
unbound direct reclaim concurrency. At some point, having tens to
hundreds of direct reclaimers all trying to write dirty inodes to
disk causes catastrophic IO breakdown and everything grinds to a
halt forever. We have to prevent that breakdown from occurring.

i.e. we have to throttle direct reclaim to before it reaches IO
breakdown /somewhere/. The memory reclaim subsystem does not do it,
so we have to do it in XFS itself. The problem here is that if we
ignore direct reclaim (i.e do nothing rather than block waiting on
reclaim progress) then the mm/ reclaim algorithms will eventually
think they aren't making progress and unleash the OOM killer.

> The solution I have in mind for this is not to try to write anything
> to (disastrously terrible) storage in shrinkers. We have 95GB of page
> cache readily available for reclaim and it seems a lot cheaper to grab
> that.

The mm/ subsystem tries to keep a balance between page cache and
shrinker controlled caches. /proc/sys/vm/vfs_cache_pressure
controls the balance between page cache and inode/dentry cache
reclaim pressure..

> That brings me to the first question around memory subsystem: are
> shrinkers supposed to flush any dirty data?

No shrinker does that, but if they wanted to they would be perfectly
within their right to write back data.

XFS is writing back /metadata/ here because direct reclaim is
putting excessive pressure on the inode cache and not allowing the
background cleaners to do their job.

> My gut feeling is that
> they should not do that, because there's already writeback mechanism
> with own tunables for limits to take care of that. If a system runs
> out of memory reclaimable without IO and dirty pages are under limit,
> it's totally fair to OOM somebody.
> 
> It's totally possible that I'm wrong about this feeling, but either
> way I think docs need an update on this matter:
> 
> * https://elixir.bootlin.com/linux/v4.14.55/source/Documentation/filesystems/vfs.txt
> 
>   nr_cached_objects: called by the sb cache shrinking function for the
>   filesystem to return the number of freeable cached objects it contains.

You are assuming that "freeable" means "instantly freeable object",
not "unreferenced object that can be freed in the near future". We
use the latter definition in the shrinkers, not the former.

> My second question is conditional on the first one: if filesystems are
> supposed to flush dirty data in response to shrinkers, then how can I
> stop this, given my knowledge about combination of lots of available
> page cache and terrible disks?

Filesystems have more caches that just the page cache.

> I've tried two things to address this problem ad-hoc.
> 
> 1. Run the following systemtap script to trick shrinkers into thinking
> that XFS has nothing to free:
> 
> probe kernel.function("xfs_fs_nr_cached_objects").return {
>   $return = 0
> }
>
> That did the job and shrink_node latency dropped considerably, while
> calls to xfs_fs_free_cached_objects disappeared.

Which effectively turned off direct reclaim for XFS inodes. See
above - this just means that when you have no easily reclaimable
page cache the system will OOM kill rather than wait for inodes to
be reclaimed. i.e. it looks good until everything suddenly goes
wrong and then everything dies a horrible death.

> 2. Use vm.vfs_cache_pressure to do the same thing. This failed
> miserably, because of the following code in super_cache_count:
> 
>   if (sb->s_op && sb->s_op->nr_cached_objects)
>     total_objects = sb->s_op->nr_cached_objects(sb, sc);
> 
>   total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);
>   total_objects += list_lru_shrink_count(&sb->s_inode_lru, sc);
> 
>   total_objects = vfs_pressure_ratio(total_objects);
>   return total_objects;
> 
> XFS was doing its job cleaning up inodes with the background mechanims
> it has (m_reclaim_workqueue), but kernel also stopped cleaning up
> readily available inodes after XFS.

You mean the kernel stopped handing readily available inodes to XFS
to free.

ie. The VFS has to release unreferenced inodes before they are
handed to XFS to clean up and free. IOWs, I suspect you biased
vm.vfs_cache_pressure to turn off inode reclaim to effectively do
the same thing as above. However, by stopping the feed of
unreferenced inodes to XFS you stopped inode reclaim altogether and
that caused other problems.

What I suspect you want to do is bias vfs_cache_pressure the other
way, so that it /agressively/ feeds inode reclaim and so prevent
large numbers of inodes from building up in the cache. That way
reclaim won't have as many dirty inodes to block on when a sustained
memory shortage drives large amounts of direct reclaim into the
shrinkers...

> I'm not a kernel hacker and to be honest with you I don't even
> understand all the nuances here. All I know is:
> 
> 1. I have lots of page cache and terrible disks.
> 2. I want to reclaim page cache and never touch disks in response to
> memory reclaim.
> 3. Direct reclaim will happen at some point, somebody will want a big
> chunk of memory all at once.
> 4. I'm probably ok with reclaiming clean xfs inodes synchronously in
> reclaim path.
> 
> This brings me to my final question: what should I do to avoid latency
> in reclaim (direct or kswapd)?
> 
> To reiterate the importance of this issue: we see interactive
> applications with zero IO stall for multiple seconds in writes to
> non-blocking sockets and page faults on newly allocated memory, while
> 95GB of memory is in page cache.

It really just sounds like you are allowing too many dirty inodes to
build up in memory. You have a huge amount of memory but really slow
disks - that's just asking for idata and metadata writeback latency
problems.

It sounds like, you need to cause inode cleaning to happen
earlier/faster than it is happening now, because your disks are slow
and so you can't allow a big backlog to build up.  Reducing
/proc/sys/fs/xfs/xfssyncd_centisecs can get background metadata
writeback started earlier. As per Documentation/filesystems/xfs.txt:

  fs.xfs.xfssyncd_centisecs     (Min: 100  Default: 3000  Max: 720000)
        The interval at which the filesystem flushes metadata
        out to disk and runs internal cache cleanup routines.

If this doesn't help, then I'd suggest taht your config is simply
allowing too many dirty inodes to build up in memory.  With XFS, the
number of dirty inodes that can be held in memory at any point in
time is bound by the size of the XFS log in the filesystem. Hence if
you have hundreds of MB of journal space, then you can cache
hundreds of thousands of dirty inodes in memory and so can take tens
of minutes to write them back to slow disks. So if earlier writeback
doesn't help, I'd suggest that using smaller logs with your
filesystems is the only real option here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
