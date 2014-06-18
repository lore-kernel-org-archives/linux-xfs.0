Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 206DD7F3F
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 06:49:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 954E1AC002
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 04:49:16 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	MvVTilDnufxKTg7s for <xfs@oss.sgi.com>;
	Wed, 18 Jun 2014 04:49:13 -0700 (PDT)
Date: Wed, 18 Jun 2014 21:48:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: two deadlock problems occur when kswapd writebacks XFS pages.
Message-ID: <20140618114858.GQ9508@dastard>
References: <53A0013A.1010100@jp.fujitsu.com> <20140617132609.GI9508@dastard>
	<53A15DC7.50001@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53A15DC7.50001@jp.fujitsu.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Cc: linux-mm@kvack.org, xfs@oss.sgi.com

On Wed, Jun 18, 2014 at 06:37:11PM +0900, Masayoshi Mizuma wrote:
> 
> On Tue, 17 Jun 2014 23:26:09 +1000 Dave Chinner wrote:
> >On Tue, Jun 17, 2014 at 05:50:02PM +0900, Masayoshi Mizuma wrote:
> >>I found two deadlock problems occur when kswapd writebacks XFS pages.
> >>I detected these problems on RHEL kernel actually, and I suppose these
> >>also happen on upstream kernel (3.16-rc1).
> >>
> >>1.
> >>
> >>A process (processA) has acquired read semaphore "xfs_cil.xc_ctx_lock"
> >>at xfs_log_commit_cil() and it is waiting for the kswapd. Then, a
> >>kworker has issued xlog_cil_push_work() and it is waiting for acquiring
> >>the write semaphore. kswapd is waiting for acquiring the read semaphore
> >>at xfs_log_commit_cil() because the kworker has been waiting before for
> >>acquiring the write semaphore at xlog_cil_push(). Therefore, a deadlock
> >>happens.
> >>
> >>The deadlock flow is as follows.
> >>
> >>   processA              | kworker                  | kswapd
> >>   ----------------------+--------------------------+----------------------
> >>| xfs_trans_commit      |                          |
> >>| xfs_log_commit_cil    |                          |
> >>| down_read(xc_ctx_lock)|                          |
> >>| xlog_cil_insert_items |                          |
> >>| xlog_cil_insert_format_items                     |
> >>| kmem_alloc            |                          |
> >>| :                     |                          |
> >>| shrink_inactive_list  |                          |
> >>| congestion_wait       |                          |
> >>| # waiting for kswapd..|                          |
> >>|                       | xlog_cil_push_work       |
> >>|                       | xlog_cil_push            |
> >>|                       | xfs_trans_commit         |
> >>|                       | down_write(xc_ctx_lock)  |
> >>|                       | # waiting for processA...|
> >>|                       |                          | shrink_page_list
> >>|                       |                          | xfs_vm_writepage
> >>|                       |                          | xfs_map_blocks
> >>|                       |                          | xfs_iomap_write_allocate
> >>|                       |                          | xfs_trans_commit
> >>|                       |                          | xfs_log_commit_cil
> >>|                       |                          | down_read(xc_ctx_lock)
> >>V(time)                 |                          | # waiting for kworker...
> >>   ----------------------+--------------------------+-----------------------
> >
> >Where's the deadlock here? congestion_wait() simply times out and
> >processA continues onward doing memory reclaim. It should continue
> >making progress, albeit slowly, and if it isn't then the allocation
> >will fail. If the allocation repeatedly fails then you should be
> >seeing this in the logs:
> >
> >XFS: possible memory allocation deadlock in <func> (mode:0x%x)
> >
> >If you aren't seeing that in the logs a few times a second and never
> >stopping, then the system is still making progress and isn't
> >deadlocked.
> 
> processA is stuck at following while loop. In this situation,
> too_many_isolated() always returns true because kswapd is also stuck...

How is this a filesystem problem, though? kswapd is not guaranteed
to make writeback progress It's *always* been able to stall waiting
on log space or transaction commit during writeback like this, and
filesystems are allowed to simply redirty pages to avoid deadlocks.

For those playing along at home, this is also the reason why
filesystems can't use mempools for writeback structures - they can't
guarantee forward progress in low memory situations and mempools
aren't a solution to memory allocation problems.

Here's a basic example for you:

Process A				kswapd

start transaction
allocate block
lock AGF 1
read btree block
allocate memory for btree buffer
<direct memory reclaim>
loop while (too many isolated)
    <blocks waiting on kswapd>

					shrink_page_list
					xfs_vm_writepage
					xfs_map_blocks
					xfs_iomap_write_allocate
					....
					start transaction
					<allocate block>
					lock AGF 1
					<blocks waiting on process A>

See how simple it is to prevent kswapd from making progress? I can
think of many, many other ways that XFS can prevent kswapd from
making progress and none of them are new....

> ---
> static noinline_for_stack unsigned long
> shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
>                      struct scan_control *sc, enum lru_list lru)
> {
> ...
>         while (unlikely(too_many_isolated(zone, file, sc))) {
>                 congestion_wait(BLK_RW_ASYNC, HZ/10);
> 
>                 /* We are about to die and free our memory. Return now. */
>                 if (fatal_signal_pending(current))
>                         return SWAP_CLUSTER_MAX;
>         }
> ---
> 
> On that point, this problem is similar to the problem fixed by
> the following commit.
> 
> 1f6d64829d xfs: block allocation work needs to be kswapd aware

Which has already proven to be the wrong thing to do. I'm ready to
revert that because of other performance and memory reclaim
regressions I've isolated to that patch. Indeed, it makes my test
VMs start to issue allocation deadlock warnings from XFS under
workloads that it's never had problems with before....

> So, the same solution, for example we add PF_KSWAPD to current->flags
> before calling kmem_alloc(), may fix this problem1...

That's just a nasty hack, not a solution.

What we need to know is exactly why we are getting stuck with too
many isolated pages, and why kswapd seems to be the only thing that
can "unisolate" them. Why isn't the bdi flusher thread making
progress cleaning pages?  Is it stuck in memory reclaim, too? Why do
we wait forever rather than failing, winding up the reclaim priority
and retrying?

I'm not going hack stuff into a filesystem when the problem really
looks like a direct reclaim throttling issue. We need to understand
exactly how reclaim is getting stuck here and then work out how
direct reclaim can avoid getting stuck. Especially in the context of
GFP_NOFS allocations...

> >>To fix this, should we up the read semaphore before calling kmem_alloc()
> >>at xlog_cil_insert_format_items() to avoid blocking the kworker? Or,
> >>should we the second argument of kmem_alloc() from KM_SLEEP|KM_NOFS
> >>to KM_NOSLEEP to avoid waiting for the kswapd. Or...
> >
> >Can't do that - it's in transaction context and so reclaim can't
> >recurse into the fs. Even if you do remove the flag, kmem_alloc()
> >will re-add the GFP_NOFS silently because of the PF_FSTRANS flag on
> >the task, so it won't affect anything...
> 
> I think kmem_alloc() doesn't re-add the GFP_NOFS if the second argument
> is set to KM_NOSLEEP. kmem_alloc() will re-add GFP_ATOMIC and __GFP_NOWARN.

The second argument is KM_SLEEP|KM_NOFS, so what it does when
KM_NOSLEEP is set is irrelevant to the discussion at hand.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
