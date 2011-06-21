Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5L09Nos200418 for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 19:09:23 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F08181730B3C
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 17:09:21 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	zDACk8abMRSMej3L for <xfs@oss.sgi.com>;
	Mon, 20 Jun 2011 17:09:21 -0700 (PDT)
Date: Tue, 21 Jun 2011 10:09:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix filesystsem freeze race in xfs_trans_alloc
Message-ID: <20110621000919.GH32466@dastard>
References: <20110620072350.GA19765@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110620072350.GA19765@infradead.org>
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

On Mon, Jun 20, 2011 at 03:23:51AM -0400, Christoph Hellwig wrote:
> As pointed out by Jan xfs_trans_alloc can race with a concurrent filesystem
> free when it sleeps during the memory allocation.  Fix this by moving the
> wait_for_freeze call after the memory allocation.  This means moving the
> freeze into the low-level _xfs_trans_alloc helper, which thus grows a new
> argument.  Also fix up some comments in that area while at it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_fsops.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_fsops.c	2011-06-17 14:18:52.185725030 +0200
> +++ xfs/fs/xfs/xfs_fsops.c	2011-06-18 16:28:04.557624784 +0200
> @@ -626,7 +626,7 @@ xfs_fs_log_dummy(
>  	xfs_trans_t	*tp;
>  	int		error;
>  
> -	tp = _xfs_trans_alloc(mp, XFS_TRANS_DUMMY1, KM_SLEEP);
> +	tp = _xfs_trans_alloc(mp, XFS_TRANS_DUMMY1, KM_SLEEP, false);
>  	error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
>  					XFS_DEFAULT_LOG_COUNT);
>  	if (error) {
> Index: xfs/fs/xfs/xfs_iomap.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_iomap.c	2011-06-17 14:18:52.195725031 +0200
> +++ xfs/fs/xfs/xfs_iomap.c	2011-06-18 16:28:04.560958118 +0200
> @@ -688,8 +688,7 @@ xfs_iomap_write_unwritten(
>  		 * the same inode that we complete here and might deadlock
>  		 * on the iolock.
>  		 */
> -		xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
> -		tp = _xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE, KM_NOFS);
> +		tp = _xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE, KM_NOFS, true);
>  		tp->t_flags |= XFS_TRANS_RESERVE;
>  		error = xfs_trans_reserve(tp, resblks,
>  				XFS_WRITE_LOG_RES(mp), 0,
> Index: xfs/fs/xfs/xfs_trans.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_trans.h	2011-06-17 14:18:52.209058363 +0200
> +++ xfs/fs/xfs/xfs_trans.h	2011-06-18 16:28:04.560958118 +0200
> @@ -448,7 +448,7 @@ typedef struct xfs_trans {
>   * XFS transaction mechanism exported interfaces.
>   */
>  xfs_trans_t	*xfs_trans_alloc(struct xfs_mount *, uint);
> -xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint, uint);
> +xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint, uint, bool);
>  xfs_trans_t	*xfs_trans_dup(xfs_trans_t *);
>  int		xfs_trans_reserve(xfs_trans_t *, uint, uint, uint,
>  				  uint, uint);
> Index: xfs/fs/xfs/xfs_mount.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_mount.c	2011-06-17 14:18:52.222391695 +0200
> +++ xfs/fs/xfs/xfs_mount.c	2011-06-18 16:28:04.560958118 +0200
> @@ -1566,15 +1566,9 @@ xfs_fs_writable(xfs_mount_t *mp)
>  }
>  
>  /*
> - * xfs_log_sbcount
> - *
>   * Called either periodically to keep the on disk superblock values
>   * roughly up to date or from unmount to make sure the values are
>   * correct on a clean unmount.
> - *
> - * Note this code can be called during the process of freezing, so
> - * we may need to use the transaction allocator which does not not
> - * block when the transaction subsystem is in its frozen state.
>   */
>  int
>  xfs_log_sbcount(
> @@ -1596,7 +1590,13 @@ xfs_log_sbcount(
>  	if (!xfs_sb_version_haslazysbcount(&mp->m_sb))
>  		return 0;
>  
> -	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_COUNT, KM_SLEEP);
> +	/*
> +	 * We can be called during the process of freezing, so make sure
> +	 * we go ahead even if the frozen for new transactions.  We will
> +	 * always use a sync transaction in the freeze path to make sure
> +	 * the transaction has completed by the time we return.
> +	 */
> +	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_COUNT, KM_SLEEP, false);
>  	error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
>  					XFS_DEFAULT_LOG_COUNT);
>  	if (error) {
> Index: xfs/fs/xfs/xfs_trans.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_trans.c	2011-06-09 11:51:01.000000000 +0200
> +++ xfs/fs/xfs/xfs_trans.c	2011-06-18 16:28:24.970957084 +0200
> @@ -566,31 +566,24 @@ xfs_trans_init(
>  
>  /*
>   * This routine is called to allocate a transaction structure.
> + *
>   * The type parameter indicates the type of the transaction.  These
>   * are enumerated in xfs_trans.h.
> - *
> - * Dynamically allocate the transaction structure from the transaction
> - * zone, initialize it, and return it to the caller.
>   */
> -xfs_trans_t *
> -xfs_trans_alloc(
> -	xfs_mount_t	*mp,
> -	uint		type)
> -{
> -	xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
> -	return _xfs_trans_alloc(mp, type, KM_SLEEP);
> -}
> -
> -xfs_trans_t *
> +struct xfs_trans *
>  _xfs_trans_alloc(
> -	xfs_mount_t	*mp,
> -	uint		type,
> -	uint		memflags)
> +	struct xfs_mount	*mp,
> +	uint			type,
> +	uint			memflags,
> +	bool			wait_for_freeze)
>  {
> -	xfs_trans_t	*tp;
> +	struct xfs_trans	*tp;
>  
>  	atomic_inc(&mp->m_active_trans);
>  
> +	if (wait_for_freeze)
> +		xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
> +
>  	tp = kmem_zone_zalloc(xfs_trans_zone, memflags);
>  	tp->t_magic = XFS_TRANS_MAGIC;
>  	tp->t_type = type;
> @@ -600,6 +593,14 @@ _xfs_trans_alloc(
>  	return tp;
>  }
>  
> +struct xfs_trans *
> +xfs_trans_alloc(
> +	struct xfs_mount	*mp,
> +	uint			type)
> +{
> +	return _xfs_trans_alloc(mp, type, KM_SLEEP, true);
> +}
> +

The only thing I'd suggest is making xfs_trans_alloc()
an inline function now that it's a simple wrapper. Otherwise looks
good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
