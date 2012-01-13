Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0DMguWQ166388 for <xfs@oss.sgi.com>; Fri, 13 Jan 2012 16:42:56 -0600
Date: Fri, 13 Jan 2012 16:42:52 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 07/11] xfs: replace i_pin_wait with a bit waitqueue
Message-ID: <20120113224252.GC16386@sgi.com>
References: <20111218200003.557507716@bombadil.infradead.org>
	<20111218200131.916691346@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111218200131.916691346@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, Dec 18, 2011 at 03:00:10PM -0500, Christoph Hellwig wrote:
> Replace i_pin_wait, which is only used during synchronous inode flushing
> with a bit waitqueue.  This trades off a much smaller inode against
> slightly slower wakeup performance, and saves 12 (32-bit) or 20 (64-bit)
> bytes in the XFS inode.
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

> 
> ---
>  fs/xfs/xfs_inode.c      |   27 +++++++++++++++++++++------
>  fs/xfs/xfs_inode.h      |    3 ++-
>  fs/xfs/xfs_inode_item.c |    2 +-
>  fs/xfs/xfs_super.c      |    1 -
>  4 files changed, 24 insertions(+), 9 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_inode.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_inode.c	2011-11-30 12:59:08.843047205 +0100
> +++ xfs/fs/xfs/xfs_inode.c	2011-11-30 12:59:10.296372665 +0100
> @@ -2037,7 +2037,7 @@ xfs_idestroy_fork(
>   * once someone is waiting for it to be unpinned.
>   */
>  static void
> -xfs_iunpin_nowait(
> +xfs_iunpin(
>  	struct xfs_inode	*ip)
>  {
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
> @@ -2049,14 +2049,29 @@ xfs_iunpin_nowait(
>  
>  }
>  
> +static void
> +__xfs_iunpin_wait(
> +	struct xfs_inode	*ip)
> +{
> +	wait_queue_head_t *wq = bit_waitqueue(&ip->i_flags, __XFS_IPINNED_BIT);
> +	DEFINE_WAIT_BIT(wait, &ip->i_flags, __XFS_IPINNED_BIT);
> +
> +	xfs_iunpin(ip);
> +
> +	do {
> +		prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
> +		if (xfs_ipincount(ip))
> +			io_schedule();
> +	} while (xfs_ipincount(ip));
> +	finish_wait(wq, &wait.wait);
> +}
> +
>  void
>  xfs_iunpin_wait(
>  	struct xfs_inode	*ip)
>  {
> -	if (xfs_ipincount(ip)) {
> -		xfs_iunpin_nowait(ip);
> -		wait_event(ip->i_ipin_wait, (xfs_ipincount(ip) == 0));
> -	}
> +	if (xfs_ipincount(ip))
> +		__xfs_iunpin_wait(ip);
>  }
>  
>  /*
> @@ -2415,7 +2430,7 @@ xfs_iflush(
>  	 * out for us if they occur after the log force completes.
>  	 */
>  	if (!(flags & SYNC_WAIT) && xfs_ipincount(ip)) {
> -		xfs_iunpin_nowait(ip);
> +		xfs_iunpin(ip);
>  		xfs_ifunlock(ip);
>  		return EAGAIN;
>  	}
> Index: xfs/fs/xfs/xfs_inode.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_inode.h	2011-11-30 12:59:08.846380520 +0100
> +++ xfs/fs/xfs/xfs_inode.h	2011-11-30 12:59:10.296372665 +0100
> @@ -238,7 +238,6 @@ typedef struct xfs_inode {
>  	mrlock_t		i_lock;		/* inode lock */
>  	mrlock_t		i_iolock;	/* inode IO lock */
>  	atomic_t		i_pincount;	/* inode pin count */
> -	wait_queue_head_t	i_ipin_wait;	/* inode pinning wait queue */
>  	spinlock_t		i_flags_lock;	/* inode i_flags lock */
>  	/* Miscellaneous state. */
>  	unsigned long		i_flags;	/* see defined flags below */
> @@ -367,6 +366,8 @@ xfs_set_projid(struct xfs_inode *ip,
>  #define XFS_IDIRTY_RELEASE	(1 << 6) /* dirty release already seen */
>  #define __XFS_IFLOCK_BIT	7	 /* inode is being flushed right now */
>  #define XFS_IFLOCK		(1 << __XFS_IFLOCK_BIT)
> +#define __XFS_IPINNED_BIT	8	 /* wakeup key for zero pin count */
> +#define XFS_IPINNED		(1 << __XFS_IPINNED_BIT)
>  
>  /*
>   * Per-lifetime flags need to be reset when re-using a reclaimable inode during
> Index: xfs/fs/xfs/xfs_inode_item.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_inode_item.c	2011-11-30 12:59:08.846380520 +0100
> +++ xfs/fs/xfs/xfs_inode_item.c	2011-11-30 12:59:10.296372665 +0100
> @@ -555,7 +555,7 @@ xfs_inode_item_unpin(
>  	trace_xfs_inode_unpin(ip, _RET_IP_);
>  	ASSERT(atomic_read(&ip->i_pincount) > 0);
>  	if (atomic_dec_and_test(&ip->i_pincount))
> -		wake_up(&ip->i_ipin_wait);
> +		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
>  }
>  
>  /*
> Index: xfs/fs/xfs/xfs_super.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_super.c	2011-11-30 12:59:08.846380520 +0100
> +++ xfs/fs/xfs/xfs_super.c	2011-11-30 12:59:10.296372665 +0100
> @@ -828,7 +828,6 @@ xfs_fs_inode_init_once(
>  	/* xfs inode */
>  	atomic_set(&ip->i_pincount, 0);
>  	spin_lock_init(&ip->i_flags_lock);
> -	init_waitqueue_head(&ip->i_ipin_wait);
>  
>  	mrlock_init(&ip->i_lock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
>  		     "xfsino", ip->i_ino);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
