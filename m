Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9U8t5vQ172419 for <xfs@oss.sgi.com>; Fri, 30 Oct 2009 03:55:05 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0273517FD4F1
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2009 01:55:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id hEtdRMGes9waLEpi for
	<xfs@oss.sgi.com>; Fri, 30 Oct 2009 01:55:16 -0700 (PDT)
Date: Fri, 30 Oct 2009 04:55:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: I/O completion handlers must use NOFS allocations
Message-ID: <20091030085516.GA30825@infradead.org>
References: <20091019040003.GA21115@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091019040003.GA21115@infradead.org>
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
To: xfs@oss.sgi.com
Cc: Thomas Neumann <tneumann@users.sourceforge.net>

Any chance to get a review for this one?

On Mon, Oct 19, 2009 at 12:00:03AM -0400, Christoph Hellwig wrote:
> When complention I/O requests we must not allow the memory allocator to
> recurse into the filesystem, as we might deadlock on waiting for the
> I/O completion otherwise.  The only thing currently allocting normal
> GFP_KERNEL memory is the allocation of the transaction structure for the
> unwritten extent conversion.  Add a memflags argument to _xfs_trans_alloc
> to allow controlling the allocator behaviour.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Thomas Neumann <tneumann@users.sourceforge.net>
> Tested-by: Thomas Neumann <tneumann@users.sourceforge.net>
> 
> Index: linux-2.6/fs/xfs/xfs_fsops.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_fsops.c	2009-10-16 23:08:25.170027882 +0200
> +++ linux-2.6/fs/xfs/xfs_fsops.c	2009-10-16 23:09:22.904256700 +0200
> @@ -611,7 +611,7 @@ xfs_fs_log_dummy(
>  	xfs_inode_t	*ip;
>  	int		error;
>  
> -	tp = _xfs_trans_alloc(mp, XFS_TRANS_DUMMY1);
> +	tp = _xfs_trans_alloc(mp, XFS_TRANS_DUMMY1, KM_SLEEP);
>  	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
>  	if (error) {
>  		xfs_trans_cancel(tp, 0);
> Index: linux-2.6/fs/xfs/xfs_iomap.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_iomap.c	2009-10-16 23:10:14.342278346 +0200
> +++ linux-2.6/fs/xfs/xfs_iomap.c	2009-10-16 23:12:08.148004392 +0200
> @@ -860,8 +860,15 @@ xfs_iomap_write_unwritten(
>  		 * set up a transaction to convert the range of extents
>  		 * from unwritten to real. Do allocations in a loop until
>  		 * we have covered the range passed in.
> +		 *
> +		 * Note that we opencoding the transaction allocation here
> +		 * to pass KM_NOFS - we can't risk to recurse back into
> +		 * the filesystem here as we might be asked to write out
> +		 * the same inode that we complete here and might deadlock
> +		 * on the iolock.
>  		 */
> -		tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
> +		xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
> +		tp = _xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE, KM_NOFS);
>  		tp->t_flags |= XFS_TRANS_RESERVE;
>  		error = xfs_trans_reserve(tp, resblks,
>  				XFS_WRITE_LOG_RES(mp), 0,
> Index: linux-2.6/fs/xfs/xfs_mount.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_mount.c	2009-10-16 23:08:25.147024815 +0200
> +++ linux-2.6/fs/xfs/xfs_mount.c	2009-10-16 23:09:25.127005437 +0200
> @@ -1471,7 +1471,7 @@ xfs_log_sbcount(
>  	if (!xfs_sb_version_haslazysbcount(&mp->m_sb))
>  		return 0;
>  
> -	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_COUNT);
> +	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_COUNT, KM_SLEEP);
>  	error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
>  					XFS_DEFAULT_LOG_COUNT);
>  	if (error) {
> Index: linux-2.6/fs/xfs/xfs_trans.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_trans.c	2009-10-16 23:08:25.117003816 +0200
> +++ linux-2.6/fs/xfs/xfs_trans.c	2009-10-16 23:08:58.202005942 +0200
> @@ -236,19 +236,20 @@ xfs_trans_alloc(
>  	uint		type)
>  {
>  	xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
> -	return _xfs_trans_alloc(mp, type);
> +	return _xfs_trans_alloc(mp, type, KM_SLEEP);
>  }
>  
>  xfs_trans_t *
>  _xfs_trans_alloc(
>  	xfs_mount_t	*mp,
> -	uint		type)
> +	uint		type,
> +	uint		memflags)
>  {
>  	xfs_trans_t	*tp;
>  
>  	atomic_inc(&mp->m_active_trans);
>  
> -	tp = kmem_zone_zalloc(xfs_trans_zone, KM_SLEEP);
> +	tp = kmem_zone_zalloc(xfs_trans_zone, memflags);
>  	tp->t_magic = XFS_TRANS_MAGIC;
>  	tp->t_type = type;
>  	tp->t_mountp = mp;
> Index: linux-2.6/fs/xfs/xfs_trans.h
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_trans.h	2009-10-16 23:08:25.127003692 +0200
> +++ linux-2.6/fs/xfs/xfs_trans.h	2009-10-16 23:09:04.726256000 +0200
> @@ -924,7 +924,7 @@ typedef struct xfs_trans {
>   * XFS transaction mechanism exported interfaces.
>   */
>  xfs_trans_t	*xfs_trans_alloc(struct xfs_mount *, uint);
> -xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint);
> +xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint, uint);
>  xfs_trans_t	*xfs_trans_dup(xfs_trans_t *);
>  int		xfs_trans_reserve(xfs_trans_t *, uint, uint, uint,
>  				  uint, uint);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
