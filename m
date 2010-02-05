Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o15Lf9sP164056 for <xfs@oss.sgi.com>; Fri, 5 Feb 2010 15:41:09 -0600
Subject: Re: [PATCH 02/10] xfs: Use delayed write for inodes rather than
	async V2
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1265153104-29680-3-git-send-email-david@fromorbit.com>
References: <1265153104-29680-1-git-send-email-david@fromorbit.com>
	<1265153104-29680-3-git-send-email-david@fromorbit.com>
Date: Fri, 05 Feb 2010 15:38:44 -0600
Message-ID: <1265405924.2714.117.camel@doink1>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, 2010-02-03 at 10:24 +1100, Dave Chinner wrote:
> We currently do background inode flush asynchronously, resulting in
> inodes being written in whatever order the background writeback
> issues them. Not only that, there are also blocking and non-blocking
> asynchronous inode flushes, depending on where the flush comes from.
> 
> This patch completely removes asynchronous inode writeback. It
> removes all the strange writeback modes and replaces them with
> either a synchronous flush or a non-blocking delayed write flush.
> That is, inode flushes will only issue IO directly if they are
> synchronous, and background flushing may do nothing if the operation
> would block (e.g. on a pinned inode or buffer lock).
> 
> Delayed write flushes will now result in the inode buffer sitting in
> the delwri queue of the buffer cache to be flushed by either an AIL
> push or by the xfsbufd timing out the buffer. This will allow
> accumulation of dirty inode buffers in memory and allow optimisation
> of inode cluster writeback at the xfsbufd level where we have much
> greater queue depths than the block layer elevators. We will also
> get adjacent inode cluster buffer IO merging for free when a later
> patch in the series allows sorting of the delayed write buffers
> before dispatch.
> 
> This effectively means that any inode that is written back by
> background writeback will be seen as flush locked during AIL
> pushing, and will result in the buffers being pushed from there.
> This writeback path is currently non-optimal, but the next patch
> in the series will fix that problem.
> 
> A side effect of this delayed write mechanism is that background
> inode reclaim will no longer directly flush inodes, nor can it wait
> on the flush lock. The result is that inode reclaim must leave the
> inode in the reclaimable state until it is clean. Hence attempts to
> reclaim a dirty inode in the background will simply skip the inode
> until it is clean and this allows other mechanisms (i.e. xfsbufd) to
> do more optimal writeback of the dirty buffers. As a result, the
> inode reclaim code has been rewritten so that it no longer relies on
> the ambiguous return values of xfs_iflush() to determine whether it
> is safe to reclaim an inode.
> 
> Portions of this patch are derived from patches by Christoph
> Hellwig.
> 
> Version 2:
> - cleanup reclaim code as suggested by Christoph
> - log background reclaim inode flush errors
> - just pass sync flags to xfs_iflush

I now see that the missing "break;" in the previous patch
doesn't matter as long as this patch is also applied...

This change looks right to me, and it's pretty cool
to see where you're headed with it.  I wasn't quite
following a few weeks back when you and Christoph
were discussing this.

I have a few comments on the comments, below.  Maybe
you could either confirm or correct what I say below.

> Signed-off-by: Dave Chinner <david@fromorbit.com>

Reviewed-by: Alex Elder <aelder@sgi.com>

> ---
>  fs/xfs/linux-2.6/xfs_super.c |    4 +-
>  fs/xfs/linux-2.6/xfs_sync.c  |  104 ++++++++++++++++++++++++++++++-----------
>  fs/xfs/xfs_inode.c           |   75 ++----------------------------
>  fs/xfs/xfs_inode.h           |   10 ----
>  fs/xfs/xfs_inode_item.c      |   10 +++-
>  fs/xfs/xfs_mount.c           |   13 +++++-
>  6 files changed, 102 insertions(+), 114 deletions(-)
> 

. . .

> diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
> index 98b8937..a9f6d20 100644
> --- a/fs/xfs/linux-2.6/xfs_sync.c
> +++ b/fs/xfs/linux-2.6/xfs_sync.c

. . .

> @@ -719,21 +720,42 @@ __xfs_inode_clear_reclaim_tag(

Regardless of the state, if the inode has a flush underway
we requeue.

>   *	shutdown		EIO		unpin and reclaim
>   *	clean, unpinned		0		reclaim
>   *	stale, unpinned		0		reclaim
> - *	clean, pinned(*)	0		unpin and reclaim
> - *	stale, pinned		0		unpin and reclaim
> - *	dirty, async		0		block on flush lock, reclaim
> - *	dirty, sync flush	0		block on flush lock, reclaim
> + *	clean, pinned(*)	0		requeue
> + *	stale, pinned		EAGAIN		requeue

Actually, if it's pinned (clean or stale) then we either
unpin and reclaim (if synchronous) or requeue (otherwise),
i.e.:

*    clean, pinned, async(*)    N/A       requeue
*    stale, pinned, async(*)    N/A       requeue
*    clean, pinned, sync flush  0         unpin and reclaim
*    stale, pinned, sync flush  EAGAIN    unpin and reclaim 

> + *	dirty, delwri ok	0		requeue
> + *	dirty, delwri blocked	EAGAIN		requeue
> + *	dirty, sync flush	0		reclaim
>   *
>   * (*) dgc: I don't think the clean, pinned state is possible but it gets
>   * handled anyway given the order of checks implemented.
>   *
> + * As can be seen from the table, the return value of xfs_iflush() is not
> + * sufficient to correctly decide the reclaim action here. The checks in
> + * xfs_iflush() might look like duplicates, but they are not.
> + *
> + * Also, because we get the flush lock first, we know that any inode that has
> + * been flushed delwri has had the flush completed by the time we check that
> + * the inode is clean. The clean inode check needs to be done before flushing
> + * the inode delwri otherwise we would loop forever requeuing clean inodes as
> + * we cannot tell apart a successful delwri flush and a clean inode from the
> + * return value of xfs_iflush().
> + *
> + * Note that because the inode is flushed delayed write by background
> + * writeback, the flush lock may already be held here and waiting on it can
> + * result in very long latencies. Hence for sync reclaims, where we wait on the
> + * flush lock, the caller should push out delayed write inodes first before
> + * trying to reclaim them to minimise the amount of time spent waiting. For
> + * background relaim, we just requeue the inode for the next pass.
> + *
>   * Hence the order of actions after gaining the locks should be:
>   *	bad		=> reclaim
>   *	shutdown	=> unpin and reclaim
> - *	pinned		=> unpin
> + *	pinned, delwri	=> requeue
> + *	pinned, sync	=> unpin
>   *	stale		=> reclaim
>   *	clean		=> reclaim
> - *	dirty		=> flush, wait and reclaim
> + *	dirty, delwri	=> flush and requeue
> + *	dirty, sync	=> flush, wait and reclaim
>   */
>  STATIC int
>  xfs_reclaim_inode(

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
