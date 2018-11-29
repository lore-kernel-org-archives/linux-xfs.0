Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:40609 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726192AbeK3I1W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Nov 2018 03:27:22 -0500
Date: Fri, 30 Nov 2018 08:20:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Non-blocking socket stuck for multiple seconds on
 xfs_reclaim_inodes_ag()
Message-ID: <20181129212031.GT6311@dastard>
References: <CABWYdi1YZp+baxpON2R6mP09pjkUz5D-OE7Z2KmwVGycYTN-AA@mail.gmail.com>
 <20181129021800.GQ6311@dastard>
 <20181129143647.GA8246@sbohrer-cf-dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181129143647.GA8246@sbohrer-cf-dell>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shawn Bohrer <sbohrer@cloudflare.com>
Cc: Ivan Babrou <ivan@cloudflare.com>, linux-xfs@vger.kernel.org

On Thu, Nov 29, 2018 at 08:36:48AM -0600, Shawn Bohrer wrote:
> Hi Dave,
> 
> I've got a few follow up questions below based on your response about
> this.
> 
> On Thu, Nov 29, 2018 at 01:18:00PM +1100, Dave Chinner wrote:
> > On Wed, Nov 28, 2018 at 04:36:25PM -0800, Ivan Babrou wrote:
> > > The catalyst of our issue is terrible disks. It's not uncommon to see
> > > the following stack in hung task detector:
> > > 
> > > Nov 15 21:55:13 21m21 kernel: INFO: task some-task:156314 blocked for
> > > more than 10 seconds.
> > > Nov 15 21:55:13 21m21 kernel:       Tainted: G           O
> > > 4.14.59-cloudflare-2018.7.5 #1
> > > Nov 15 21:55:13 21m21 kernel: "echo 0 >
> > > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > Nov 15 21:55:13 21m21 kernel: some-task     D11792 156314 156183 0x00000080
> > > Nov 15 21:55:13 21m21 kernel: Call Trace:
> > > Nov 15 21:55:13 21m21 kernel:  ? __schedule+0x21a/0x820
> > > Nov 15 21:55:13 21m21 kernel:  schedule+0x28/0x80
> > > Nov 15 21:55:13 21m21 kernel:  schedule_preempt_disabled+0xa/0x10
> > > Nov 15 21:55:13 21m21 kernel:  __mutex_lock.isra.2+0x16a/0x490
> > > Nov 15 21:55:13 21m21 kernel:  ? xfs_reclaim_inodes_ag+0x265/0x2d0
> > > Nov 15 21:55:13 21m21 kernel:  xfs_reclaim_inodes_ag+0x265/0x2d0
> > > Nov 15 21:55:13 21m21 kernel:  ? kmem_cache_alloc+0x14d/0x1b0
> > > Nov 15 21:55:13 21m21 kernel:  ? radix_tree_gang_lookup_tag+0xc4/0x130
> > > Nov 15 21:55:13 21m21 kernel:  ? __list_lru_walk_one.isra.5+0x33/0x130
> > > Nov 15 21:55:13 21m21 kernel:  xfs_reclaim_inodes_nr+0x31/0x40
> > > Nov 15 21:55:13 21m21 kernel:  super_cache_scan+0x156/0x1a0
> > > Nov 15 21:55:13 21m21 kernel:  shrink_slab.part.51+0x1d2/0x3a0
> > > Nov 15 21:55:13 21m21 kernel:  shrink_node+0x113/0x2e0
> > > Nov 15 21:55:13 21m21 kernel:  do_try_to_free_pages+0xb3/0x310
> > > Nov 15 21:55:13 21m21 kernel:  try_to_free_pages+0xd2/0x190
> > > Nov 15 21:55:13 21m21 kernel:  __alloc_pages_slowpath+0x3a3/0xdc0
> > > Nov 15 21:55:13 21m21 kernel:  ? ip_output+0x5c/0xc0
> > > Nov 15 21:55:13 21m21 kernel:  ? update_curr+0x141/0x1a0
> > > Nov 15 21:55:13 21m21 kernel:  __alloc_pages_nodemask+0x223/0x240
> > > Nov 15 21:55:13 21m21 kernel:  skb_page_frag_refill+0x93/0xb0
> > > Nov 15 21:55:13 21m21 kernel:  sk_page_frag_refill+0x19/0x80
> > > Nov 15 21:55:13 21m21 kernel:  tcp_sendmsg_locked+0x247/0xdc0
> > > Nov 15 21:55:13 21m21 kernel:  tcp_sendmsg+0x27/0x40
> > > Nov 15 21:55:13 21m21 kernel:  sock_sendmsg+0x36/0x40
> > > Nov 15 21:55:13 21m21 kernel:  sock_write_iter+0x84/0xd0
> > > Nov 15 21:55:13 21m21 kernel:  __vfs_write+0xdd/0x140
> > > Nov 15 21:55:13 21m21 kernel:  vfs_write+0xad/0x1a0
> > > Nov 15 21:55:13 21m21 kernel:  SyS_write+0x42/0x90
> > > Nov 15 21:55:13 21m21 kernel:  do_syscall_64+0x60/0x110
> > > Nov 15 21:55:13 21m21 kernel:  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> > > 
> > > Here "some-task" is trying to send some bytes over network and it's
> > > stuck in direct reclaim. Naturally, kswapd is not keeping up with its
> > > duties.
> > 
> > That's not kswapd causing the problem here, that's direct reclaim.
> 
> It is understood that the above is direct reclaim.  When this happens
> kswapd is also blocked as below.  As I'm sure you can imagine many
> other tasks get blocked in direct reclaim as well.

Kswapd is allowed to block waiting for IO - it runs in GFP_KERNEL
context and so can both issue write back of dirty page cache pages
and wait for them to complete IO. With that reclaim context
(GFP_KERNEL) we can also issue and wait for IO from
the filesystem shrinkers.

Blocking kswapd is less than ideal; facebook hit this particular
"kswapd is blocked" issue to but their proposed "don't block kswapd
during inode reclaim" patch caused an increase in OOM kills on my
low memory test VMs as well as small, repeatable performance
regressions on my benchmark workloads so it wasn't merged.

> > > One solution to this is to not go into direct reclaim by keeping more
> > > free pages with vm.watermark_scale_factor,  but I'd like to discard
> > > this and argue that we're going to hit direct reclaim at some point
> > > anyway.
> > 
> > Right, but the problem is that the mm/ subsystem allows effectively
> > unbound direct reclaim concurrency. At some point, having tens to
> > hundreds of direct reclaimers all trying to write dirty inodes to
> > disk causes catastrophic IO breakdown and everything grinds to a
> > halt forever. We have to prevent that breakdown from occurring.
> > 
> > i.e. we have to throttle direct reclaim to before it reaches IO
> > breakdown /somewhere/. The memory reclaim subsystem does not do it,
> > so we have to do it in XFS itself. The problem here is that if we
> > ignore direct reclaim (i.e do nothing rather than block waiting on
> > reclaim progress) then the mm/ reclaim algorithms will eventually
> > think they aren't making progress and unleash the OOM killer.
> 
> Here is my naive question.  Why does kswapd block?  Wouldn't it make
> sense for kswapd to asynchronously start the xfs_reclaim_inodes
> process and then continue looking for other pages (perhaps page cache)
> that it can easily free?

kswapd blocks because it is the only thing that (almost) guarantees
forwards progress in memory reclaim. If the memory is full of dirty
pages, it *must* block and wait for writeback to complete and clean
the pages it needs to reclaim for the waiting allocators. If it does
not block, we trigger the OOM killer prematurely. i.e. waiting a
short time for IO to complete avoids false positive transient ENOMEM
detection.

> In my mind this might prevent us from ever getting to the point of
> direct reclaim.

Direct reclaim happens first. kswapd is only kicked when direct
reclaim isn't making enough progress - kswapd happens in the
background. The problem we have is that the primary memory
reclaimer is the thundering heard of direct reclaim, and kswapd can
then get stuck behind the thundering heard.

> And if we did get to that point then yes I can see
> that you might need to synchronously block all tasks in direct reclaim
> in xfs_reclaim_inodes to prevent the thundering herd problem.

We already had to deal with the thundering heard before kswapd
starts working.

> My other question is why does the mm/ reclaim algorithms think that
> that they need to force this metadata reclaim?  I think Ivan's main
> question was we have 95GB of page cache maybe 2-3GB of total slab
> memory in use, and maybe 1GB of dirty pages.

The kernel keeps a balance between the caches. If it scans 1% of
the page cache, it also needs to scan 1% of the other caches to keep
them in balance.

> Blocking the world for
> any disk I/O at this point seems insane when there is other quickly
> freeable memory.  I assume the answer is LRU?  Our page cache pages
> are newer or more frequently accesses then this filesystem metadata?

Not blocking for IO in the shrinkers is even worse. I made some mods
yesterday to make inode reclaim block less to do the same work
(more efficient IO dispatch == less waiting) and the only thing I
succeeded in doing is slowing down my benchmark workloads by 30-40%.

Why? because blocking less in inode reclaim meant that the memory
reclaim did more scanning, and so reclaimed /other caches faster/.
That meant it was trashing the working set in the xfs bufffer cache
(which holds all the metadata buffers) and so that cause a
substantial increase in metadata read IO on a /write-only workload/.
IOWs, metadata buffers were being reclaimed far too quickly because
I made inode cache reclaim faster.

All the caches must be balanced for the system to perform well
across a wide range of workloads. And it's an unfortunate fact that
the only way we can maintain that balance right now is via harsh
throttling of the inode cache. I'll keep trying to find a different
solution, but the reality is that memory reclaim subsystem has
fairly major limitations in what we can and can't do to maintain
balance across related and/or dependent caches....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
