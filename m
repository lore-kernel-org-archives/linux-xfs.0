Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q03LrmMX080438 for <xfs@oss.sgi.com>; Tue, 3 Jan 2012 15:53:49 -0600
Date: Tue, 3 Jan 2012 15:53:45 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 01/11] xfs: remove xfs_itruncate_data
Message-ID: <20120103215345.GA6390@sgi.com>
References: <20111218200003.557507716@bombadil.infradead.org>
	<20111218200130.784802192@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111218200130.784802192@bombadil.infradead.org>
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

Hey Christoph,

On Sun, Dec 18, 2011 at 03:00:04PM -0500, Christoph Hellwig wrote:
> This wrapper isn't overly useful, not to say rather confusing.
> 
> Around the call to xfs_itruncate_extents it does:
> 
>  - add tracing
>  - add a few asserts in debug builds
>  - conditionally update the inode size in two places
>  - log the inode
> 
> Both the tracing and the inode logging can be moved to xfs_itruncate_extents
> as they are useful for the attribute fork as well - in fact the attr code
> already does an equivalent xfs_trans_log_inode call just after calling
> xfs_itruncate_extents.
>
> The conditional size updates are a mess, and there
> was no reason to do them in two places anyway, as the first one was
> conditional on the inode having extents - but without extents we
> xfs_itruncate_extents would be a no-op and the placement wouldn't matter
> anyway.
>
> Instead move the size assignments and the asserts that make sense
> to the callers that want it.
> 
> As a side effect of this clean up xfs_setattr_size by introducing variables
> for the old and new inode size, and moving the size updates into a common
> place.
>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.  I had some minor questions below.
Reviewed-by: Ben Myers <bpm@sgi.com>
 
> ---
>  fs/xfs/xfs_attr.c        |    4 -
>  fs/xfs/xfs_inode.c       |  124 +++--------------------------------------------
>  fs/xfs/xfs_inode.h       |    2 
>  fs/xfs/xfs_iops.c        |   47 +++++++++++------
>  fs/xfs/xfs_qm_syscalls.c |    9 +++
>  fs/xfs/xfs_trace.h       |    4 -
>  fs/xfs/xfs_vnodeops.c    |   17 +++++-
>  7 files changed, 65 insertions(+), 142 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_attr.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_attr.c	2011-11-30 12:58:07.820044461 +0100
> +++ xfs/fs/xfs/xfs_attr.c	2011-11-30 12:58:51.519807719 +0100
> @@ -827,10 +827,6 @@ xfs_attr_inactive(xfs_inode_t *dp)
>  	if (error)
>  		goto out;
>  
> -	/*
> -	 * Commit the last in the sequence of transactions.
> -	 */
> -	xfs_trans_log_inode(trans, dp, XFS_ILOG_CORE);
>  	error = xfs_trans_commit(trans, XFS_TRANS_RELEASE_LOG_RES);
>  	xfs_iunlock(dp, XFS_ILOCK_EXCL);
>  
> Index: xfs/fs/xfs/xfs_inode.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_inode.c	2011-11-30 12:58:07.830044408 +0100
> +++ xfs/fs/xfs/xfs_inode.c	2011-11-30 12:58:51.519807719 +0100
> @@ -1166,52 +1166,6 @@ xfs_ialloc(
>  }
>  
>  /*
> - * Check to make sure that there are no blocks allocated to the
> - * file beyond the size of the file.  We don't check this for
> - * files with fixed size extents or real time extents, but we
> - * at least do it for regular files.
> - */
> -#ifdef DEBUG
> -STATIC void
> -xfs_isize_check(
> -	struct xfs_inode	*ip,
> -	xfs_fsize_t		isize)
> -{
> -	struct xfs_mount	*mp = ip->i_mount;
> -	xfs_fileoff_t		map_first;
> -	int			nimaps;
> -	xfs_bmbt_irec_t		imaps[2];
> -	int			error;
> -
> -	if (!S_ISREG(ip->i_d.di_mode))
> -		return;
> -
> -	if (XFS_IS_REALTIME_INODE(ip))
> -		return;
> -
> -	if (ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)
> -		return;
> -
> -	nimaps = 2;
> -	map_first = XFS_B_TO_FSB(mp, (xfs_ufsize_t)isize);
> -	/*
> -	 * The filesystem could be shutting down, so bmapi may return
> -	 * an error.
> -	 */
> -	error = xfs_bmapi_read(ip, map_first,
> -			 (XFS_B_TO_FSB(mp,
> -			       (xfs_ufsize_t)XFS_MAXIOFFSET(mp)) - map_first),
> -			 imaps, &nimaps, XFS_BMAPI_ENTIRE);
> -	if (error)
> -		return;
> -	ASSERT(nimaps == 1);
> -	ASSERT(imaps[0].br_startblock == HOLESTARTBLOCK);
> -}
> -#else	/* DEBUG */
> -#define xfs_isize_check(ip, isize)
> -#endif	/* DEBUG */
> -
> -/*

You've tossed xfs_isize_check in the round filer, but you didn't mention
that in your commit message.  Isn't this still useful code?

>   * Free up the underlying blocks past new_size.  The new size must be smaller
>   * than the current size.  This routine can be used both for the attribute and
>   * data fork, and does not modify the inode size, which is left to the caller.
> @@ -1258,6 +1212,8 @@ xfs_itruncate_extents(
>  	ASSERT(ip->i_itemp->ili_lock_flags == 0);
>  	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
>  
> +	trace_xfs_itruncate_extents_start(ip, new_size);
> +
>  	/*
>  	 * Since it is possible for space to become allocated beyond
>  	 * the end of the file (in a crash where the space is allocated
> @@ -1325,6 +1281,14 @@ xfs_itruncate_extents(
>  			goto out;
>  	}
>  
> +	/*
> +	 * Always re-log the inode so that our permanent transaction can keep
> +	 * on rolling it forward in the log.
> +	 */
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);

Oh..  This is why it's ok not to log the inode core in
xfs_attr_inactive:  it calls xfs_itruncate_extents()...

> +
> +	trace_xfs_itruncate_extents_end(ip, new_size);
> +
>  out:
>  	*tpp = tp;
>  	return error;
> @@ -1338,74 +1302,6 @@ out_bmap_cancel:
>  	goto out;
>  }
>  
> -int
> -xfs_itruncate_data(
> -	struct xfs_trans	**tpp,
> -	struct xfs_inode	*ip,
> -	xfs_fsize_t		new_size)
> -{
> -	int			error;
> -
> -	trace_xfs_itruncate_data_start(ip, new_size);
> -
> -	/*
> -	 * The first thing we do is set the size to new_size permanently on
> -	 * disk.  This way we don't have to worry about anyone ever being able
> -	 * to look at the data being freed even in the face of a crash.
> -	 * What we're getting around here is the case where we free a block, it
> -	 * is allocated to another file, it is written to, and then we crash.
> -	 * If the new data gets written to the file but the log buffers
> -	 * containing the free and reallocation don't, then we'd end up with
> -	 * garbage in the blocks being freed.  As long as we make the new_size
> -	 * permanent before actually freeing any blocks it doesn't matter if
> -	 * they get written to.
> -	 */
> -	if (ip->i_d.di_nextents > 0) {
> -		/*
> -		 * If we are not changing the file size then do not update
> -		 * the on-disk file size - we may be called from
> -		 * xfs_inactive_free_eofblocks().  If we update the on-disk
> -		 * file size and then the system crashes before the contents
> -		 * of the file are flushed to disk then the files may be
> -		 * full of holes (ie NULL files bug).
> -		 */
> -		if (ip->i_size != new_size) {
> -			ip->i_d.di_size = new_size;
> -			ip->i_size = new_size;
> -			xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
> -		}
> -	}
> -
> -	error = xfs_itruncate_extents(tpp, ip, XFS_DATA_FORK, new_size);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * If we are not changing the file size then do not update the on-disk
> -	 * file size - we may be called from xfs_inactive_free_eofblocks().
> -	 * If we update the on-disk file size and then the system crashes
> -	 * before the contents of the file are flushed to disk then the files
> -	 * may be full of holes (ie NULL files bug).
> -	 */
> -	xfs_isize_check(ip, new_size);
> -	if (ip->i_size != new_size) {
> -		ip->i_d.di_size = new_size;
> -		ip->i_size = new_size;
> -	}
> -
> -	ASSERT(new_size != 0 || ip->i_delayed_blks == 0);

You didn't pull this assert along with 

> -	ASSERT(new_size != 0 || ip->i_d.di_nextents == 0);

this one into xfs_qm_scall_trunc_qfile.  Was that intentional?

> -
> -	/*
> -	 * Always re-log the inode so that our permanent transaction can keep
> -	 * on rolling it forward in the log.
> -	 */
> -	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
> -
> -	trace_xfs_itruncate_data_end(ip, new_size);
> -	return 0;
> -}
> -
>  /*
>   * This is called when the inode's link count goes to 0.
>   * We place the on-disk inode on a list in the AGI.  It
> Index: xfs/fs/xfs/xfs_inode.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_inode.h	2011-11-30 12:58:08.843372251 +0100
> +++ xfs/fs/xfs/xfs_inode.h	2011-11-30 12:58:51.523141034 +0100
> @@ -491,8 +491,6 @@ int		xfs_ifree(struct xfs_trans *, xfs_i
>  			   struct xfs_bmap_free *);
>  int		xfs_itruncate_extents(struct xfs_trans **, struct xfs_inode *,
>  				      int, xfs_fsize_t);
> -int		xfs_itruncate_data(struct xfs_trans **, struct xfs_inode *,
> -				   xfs_fsize_t);
>  int		xfs_iunlink(struct xfs_trans *, xfs_inode_t *);
>  
>  void		xfs_iext_realloc(xfs_inode_t *, int, int);
> Index: xfs/fs/xfs/xfs_iops.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_iops.c	2011-11-30 12:58:07.856710929 +0100
> +++ xfs/fs/xfs/xfs_iops.c	2011-11-30 12:58:51.523141034 +0100
> @@ -750,6 +750,7 @@ xfs_setattr_size(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct inode		*inode = VFS_I(ip);
>  	int			mask = iattr->ia_valid;
> +	xfs_off_t		oldsize, newsize;
>  	struct xfs_trans	*tp;
>  	int			error;
>  	uint			lock_flags;
> @@ -777,11 +778,13 @@ xfs_setattr_size(
>  		lock_flags |= XFS_IOLOCK_EXCL;
>  	xfs_ilock(ip, lock_flags);
>  
> +	oldsize = ip->i_size;
> +	newsize = iattr->ia_size;
> +
>  	/*
>  	 * Short circuit the truncate case for zero length files.
>  	 */
> -	if (iattr->ia_size == 0 &&
> -	    ip->i_size == 0 && ip->i_d.di_nextents == 0) {
> +	if (newsize == 0 && oldsize == 0 && ip->i_d.di_nextents == 0) {
>  		if (!(mask & (ATTR_CTIME|ATTR_MTIME)))
>  			goto out_unlock;
>  
> @@ -807,14 +810,14 @@ xfs_setattr_size(
>  	 * the inode to the transaction, because the inode cannot be unlocked
>  	 * once it is a part of the transaction.
>  	 */
> -	if (iattr->ia_size > ip->i_size) {
> +	if (newsize > oldsize) {
>  		/*
>  		 * Do the first part of growing a file: zero any data in the
>  		 * last block that is beyond the old EOF.  We need to do this
>  		 * before the inode is joined to the transaction to modify
>  		 * i_size.
>  		 */
> -		error = xfs_zero_eof(ip, iattr->ia_size, ip->i_size);
> +		error = xfs_zero_eof(ip, newsize, oldsize);
>  		if (error)
>  			goto out_unlock;
>  	}
> @@ -833,8 +836,8 @@ xfs_setattr_size(
>  	 * here and prevents waiting for other data not within the range we
>  	 * care about here.
>  	 */
> -	if (ip->i_size != ip->i_d.di_size && iattr->ia_size > ip->i_d.di_size) {
> -		error = xfs_flush_pages(ip, ip->i_d.di_size, iattr->ia_size, 0,
> +	if (oldsize != ip->i_d.di_size && newsize > ip->i_d.di_size) {
> +		error = xfs_flush_pages(ip, ip->i_d.di_size, newsize, 0,
>  					FI_NONE);
>  		if (error)
>  			goto out_unlock;
> @@ -845,8 +848,7 @@ xfs_setattr_size(
>  	 */
>  	inode_dio_wait(inode);
>  
> -	error = -block_truncate_page(inode->i_mapping, iattr->ia_size,
> -				     xfs_get_blocks);
> +	error = -block_truncate_page(inode->i_mapping, newsize, xfs_get_blocks);
>  	if (error)
>  		goto out_unlock;
>  
> @@ -857,7 +859,7 @@ xfs_setattr_size(
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	truncate_setsize(inode, iattr->ia_size);
> +	truncate_setsize(inode, newsize);
>  
>  	commit_flags = XFS_TRANS_RELEASE_LOG_RES;
>  	lock_flags |= XFS_ILOCK_EXCL;
> @@ -876,19 +878,30 @@ xfs_setattr_size(
>  	 * these flags set.  For all other operations the VFS set these flags
>  	 * explicitly if it wants a timestamp update.
>  	 */
> -	if (iattr->ia_size != ip->i_size &&
> -	    (!(mask & (ATTR_CTIME | ATTR_MTIME)))) {
> +	if (newsize != oldsize && (!(mask & (ATTR_CTIME | ATTR_MTIME)))) {
>  		iattr->ia_ctime = iattr->ia_mtime =
>  			current_fs_time(inode->i_sb);
>  		mask |= ATTR_CTIME | ATTR_MTIME;
>  	}
>  
> -	if (iattr->ia_size > ip->i_size) {
> -		ip->i_d.di_size = iattr->ia_size;
> -		ip->i_size = iattr->ia_size;
> -	} else if (iattr->ia_size <= ip->i_size ||
> -		   (iattr->ia_size == 0 && ip->i_d.di_nextents)) {
> -		error = xfs_itruncate_data(&tp, ip, iattr->ia_size);
> +	/*
> +	 * The first thing we do is set the size to new_size permanently on
> +	 * disk.  This way we don't have to worry about anyone ever being able
> +	 * to look at the data being freed even in the face of a crash.
> +	 * What we're getting around here is the case where we free a block, it
> +	 * is allocated to another file, it is written to, and then we crash.
> +	 * If the new data gets written to the file but the log buffers
> +	 * containing the free and reallocation don't, then we'd end up with
> +	 * garbage in the blocks being freed.  As long as we make the new size
> +	 * permanent before actually freeing any blocks it doesn't matter if
> +	 * they get written to.
> +	 */
> +	ip->i_d.di_size = newsize;
> +	ip->i_size = newsize;
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +
> +	if (newsize <= oldsize) {
> +		error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, newsize);
>  		if (error)
>  			goto out_trans_abort;

This newsize/oldsize section is really a nice cleanup.

>  
> Index: xfs/fs/xfs/xfs_qm_syscalls.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_qm_syscalls.c	2011-11-30 12:58:07.866710876 +0100
> +++ xfs/fs/xfs/xfs_qm_syscalls.c	2011-11-30 12:58:51.523141034 +0100
> @@ -31,6 +31,7 @@
>  #include "xfs_mount.h"
>  #include "xfs_bmap_btree.h"
>  #include "xfs_inode.h"
> +#include "xfs_inode_item.h"
>  #include "xfs_itable.h"
>  #include "xfs_bmap.h"
>  #include "xfs_rtalloc.h"
> @@ -263,13 +264,19 @@ xfs_qm_scall_trunc_qfile(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  

> -	error = xfs_itruncate_data(&tp, ip, 0);
> +	ip->i_d.di_size = 0;
> +	ip->i_size = 0;
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +
> +	error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, 0);

It it worth a comment that you log the size here because of the
possibility of another file being allocated these extents in the face of
a crash?

>  	if (error) {
>  		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
>  				     XFS_TRANS_ABORT);
>  		goto out_unlock;
>  	}
>  
> +	ASSERT(ip->i_d.di_nextents == 0);
> +
>  	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
>  
> Index: xfs/fs/xfs/xfs_trace.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_trace.h	2011-11-30 12:58:07.876710822 +0100
> +++ xfs/fs/xfs/xfs_trace.h	2011-11-30 12:58:51.523141034 +0100
> @@ -1090,8 +1090,8 @@ DECLARE_EVENT_CLASS(xfs_itrunc_class,
>  DEFINE_EVENT(xfs_itrunc_class, name, \
>  	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size), \
>  	TP_ARGS(ip, new_size))
> -DEFINE_ITRUNC_EVENT(xfs_itruncate_data_start);
> -DEFINE_ITRUNC_EVENT(xfs_itruncate_data_end);
> +DEFINE_ITRUNC_EVENT(xfs_itruncate_extents_start);
> +DEFINE_ITRUNC_EVENT(xfs_itruncate_extents_end);
>  
>  TRACE_EVENT(xfs_pagecache_inval,
>  	TP_PROTO(struct xfs_inode *ip, xfs_off_t start, xfs_off_t finish),
> Index: xfs/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_vnodeops.c	2011-11-30 12:58:07.893377397 +0100
> +++ xfs/fs/xfs/xfs_vnodeops.c	2011-11-30 12:58:51.526474350 +0100
> @@ -226,7 +226,14 @@ xfs_free_eofblocks(
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		xfs_trans_ijoin(tp, ip, 0);
>  
> -		error = xfs_itruncate_data(&tp, ip, ip->i_size);
> +		/*
> +		 * Do not update the on-disk file size.  If we update the
> +		 * on-disk file size and then the system crashes before the
> +		 * contents of the file are flushed to disk then the files
> +		 * may be full of holes (ie NULL files bug).
> +		 */
> +		error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK,
> +					      ip->i_size);
>  		if (error) {
>  			/*
>  			 * If we get an error at this point we simply don't
> @@ -670,13 +677,19 @@ xfs_inactive(
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		xfs_trans_ijoin(tp, ip, 0);
>  
> -		error = xfs_itruncate_data(&tp, ip, 0);
> +		ip->i_d.di_size = 0;
> +		ip->i_size = 0;
> +		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);

Maybe a comment here too?

> +
> +		error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, 0);
>  		if (error) {
>  			xfs_trans_cancel(tp,
>  				XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
>  			xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
>  			return VN_INACTIVE_CACHE;
>  		}
> +
> +		ASSERT(ip->i_d.di_nextents == 0);
>  	} else if (S_ISLNK(ip->i_d.di_mode)) {
>  
>  		/*
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
