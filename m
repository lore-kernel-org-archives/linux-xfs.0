Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7R3ANml058859 for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 22:10:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F37811552AF0
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 20:11:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id YRKjOGHyuUSluSUB for
	<xfs@oss.sgi.com>; Wed, 26 Aug 2009 20:11:16 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MgVOO-0002FQ-LD
	for xfs@oss.sgi.com; Thu, 27 Aug 2009 03:11:16 +0000
Date: Wed, 26 Aug 2009 23:11:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: merge fsync and O_SYNC handling
Message-ID: <20090827031116.GA6147@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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

The guarantees for O_SYNC are exactly the same as the ones we need to
make for an fsync call (and given that Linux O_SYNC is O_DSYNC the
equivalent is fdadatasync, but we treat both the same in XFS), except
with a range data writeout.  Jan Kara has started unifying these two
path for filesystems using the generic helpers, and I've started to
look at XFS.

The actual transaction commited by xfs_fsync and xfs_write_sync_logforce
has a different transaction number, but actually is exactly the same.
We'll only use the fsync transaction going forward.  One major difference
is that xfs_write_sync_logforce never issues a cache flush unless we
commit a transaction causing that as a side-effect, which is an obvious
bug in the O_SYNC handling.  Second all the locking and i_update_size
vs i_update_core changes from 978b7237123d007b9fa983af6e0e2fa8f97f9934
never made it to xfs_write_sync_logforce, so we add them back.

To make xfs_fsync easily usable from the O_SYNC path, the filemap_fdatawait
call is moved up to xfs_file_fsync, so that we don't wait on the whole
file after we already waited for our portion in xfs_write.

We'll also use a plain call to filemap_write_and_wait_range instead
of the previous sync_page_rang which did it in two steps including
an half-hearted inode write out that doesn't help us.

Once we're done with this also remove the now useless i_update_size
tracking.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_file.c	2009-08-26 20:00:27.761855441 -0300
+++ linux-2.6/fs/xfs/linux-2.6/xfs_file.c	2009-08-26 20:00:42.321855172 -0300
@@ -172,12 +172,21 @@ xfs_file_release(
  */
 STATIC int
 xfs_file_fsync(
-	struct file	*filp,
-	struct dentry	*dentry,
-	int		datasync)
+	struct file		*file,
+	struct dentry		*dentry,
+	int			datasync)
 {
-	xfs_iflags_clear(XFS_I(dentry->d_inode), XFS_ITRUNCATED);
-	return -xfs_fsync(XFS_I(dentry->d_inode));
+	struct inode		*inode = dentry->d_inode;
+	struct xfs_inode	*ip = XFS_I(inode);
+	int			error;
+
+	/* capture size updates in I/O completion before writing the inode. */
+	error = filemap_fdatawait(inode->i_mapping);
+	if (error)
+		return error;
+
+	xfs_iflags_clear(ip, XFS_ITRUNCATED);
+	return -xfs_fsync(ip);
 }
 
 STATIC int
Index: linux-2.6/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_lrw.c	2009-08-26 20:00:27.765856089 -0300
+++ linux-2.6/fs/xfs/linux-2.6/xfs_lrw.c	2009-08-26 23:11:50.861855574 -0300
@@ -812,18 +812,21 @@ write_retry:
 
 	/* Handle various SYNC-type writes */
 	if ((file->f_flags & O_SYNC) || IS_SYNC(inode)) {
+		loff_t end = pos + ret - 1;
 		int error2;
 
 		xfs_iunlock(xip, iolock);
 		if (need_i_mutex)
 			mutex_unlock(&inode->i_mutex);
-		error2 = sync_page_range(inode, mapping, pos, ret);
+
+		error2 = filemap_write_and_wait_range(mapping, pos, end);
 		if (!error)
 			error = error2;
 		if (need_i_mutex)
 			mutex_lock(&inode->i_mutex);
 		xfs_ilock(xip, iolock);
-		error2 = xfs_write_sync_logforce(mp, xip);
+
+		error2 = xfs_fsync(xip);
 		if (!error)
 			error = error2;
 	}
Index: linux-2.6/fs/xfs/xfs_rw.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_rw.c	2009-08-26 20:00:27.781857005 -0300
+++ linux-2.6/fs/xfs/xfs_rw.c	2009-08-26 23:10:19.805855442 -0300
@@ -88,90 +88,6 @@ xfs_write_clear_setuid(
 }
 
 /*
- * Handle logging requirements of various synchronous types of write.
- */
-int
-xfs_write_sync_logforce(
-	xfs_mount_t	*mp,
-	xfs_inode_t	*ip)
-{
-	int		error = 0;
-
-	/*
-	 * If we're treating this as O_DSYNC and we have not updated the
-	 * size, force the log.
-	 */
-	if (!(mp->m_flags & XFS_MOUNT_OSYNCISOSYNC) &&
-	    !(ip->i_update_size)) {
-		xfs_inode_log_item_t	*iip = ip->i_itemp;
-
-		/*
-		 * If an allocation transaction occurred
-		 * without extending the size, then we have to force
-		 * the log up the proper point to ensure that the
-		 * allocation is permanent.  We can't count on
-		 * the fact that buffered writes lock out direct I/O
-		 * writes - the direct I/O write could have extended
-		 * the size nontransactionally, then finished before
-		 * we started.  xfs_write_file will think that the file
-		 * didn't grow but the update isn't safe unless the
-		 * size change is logged.
-		 *
-		 * Force the log if we've committed a transaction
-		 * against the inode or if someone else has and
-		 * the commit record hasn't gone to disk (e.g.
-		 * the inode is pinned).  This guarantees that
-		 * all changes affecting the inode are permanent
-		 * when we return.
-		 */
-		if (iip && iip->ili_last_lsn) {
-			error = _xfs_log_force(mp, iip->ili_last_lsn,
-					XFS_LOG_FORCE | XFS_LOG_SYNC, NULL);
-		} else if (xfs_ipincount(ip) > 0) {
-			error = _xfs_log_force(mp, (xfs_lsn_t)0,
-					XFS_LOG_FORCE | XFS_LOG_SYNC, NULL);
-		}
-
-	} else {
-		xfs_trans_t	*tp;
-
-		/*
-		 * O_SYNC or O_DSYNC _with_ a size update are handled
-		 * the same way.
-		 *
-		 * If the write was synchronous then we need to make
-		 * sure that the inode modification time is permanent.
-		 * We'll have updated the timestamp above, so here
-		 * we use a synchronous transaction to log the inode.
-		 * It's not fast, but it's necessary.
-		 *
-		 * If this a dsync write and the size got changed
-		 * non-transactionally, then we need to ensure that
-		 * the size change gets logged in a synchronous
-		 * transaction.
-		 */
-		tp = xfs_trans_alloc(mp, XFS_TRANS_WRITE_SYNC);
-		if ((error = xfs_trans_reserve(tp, 0,
-						XFS_SWRITE_LOG_RES(mp),
-						0, 0, 0))) {
-			/* Transaction reserve failed */
-			xfs_trans_cancel(tp, 0);
-		} else {
-			/* Transaction reserve successful */
-			xfs_ilock(ip, XFS_ILOCK_EXCL);
-			xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-			xfs_trans_ihold(tp, ip);
-			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-			xfs_trans_set_sync(tp);
-			error = xfs_trans_commit(tp, 0);
-			xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		}
-	}
-
-	return error;
-}
-
-/*
  * Force a shutdown of the filesystem instantly while keeping
  * the filesystem consistent. We don't do an unmount here; just shutdown
  * the shop, make sure that absolutely nothing persistent happens to
Index: linux-2.6/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_vnodeops.c	2009-08-26 20:00:27.785856186 -0300
+++ linux-2.6/fs/xfs/xfs_vnodeops.c	2009-08-26 23:11:50.969355264 -0300
@@ -611,7 +611,7 @@ xfs_fsync(
 	xfs_inode_t	*ip)
 {
 	xfs_trans_t	*tp;
-	int		error;
+	int		error = 0;
 	int		log_flushed = 0, changed = 1;
 
 	xfs_itrace_entry(ip);
@@ -619,14 +619,9 @@ xfs_fsync(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return XFS_ERROR(EIO);
 
-	/* capture size updates in I/O completion before writing the inode. */
-	error = xfs_wait_on_pages(ip, 0, -1);
-	if (error)
-		return XFS_ERROR(error);
-
 	/*
 	 * We always need to make sure that the required inode state is safe on
-	 * disk.  The vnode might be clean but we still might need to force the
+	 * disk.  The inode might be clean but we still might need to force the
 	 * log because of committed transactions that haven't hit the disk yet.
 	 * Likewise, there could be unflushed non-transactional changes to the
 	 * inode core that have to go to disk and this requires us to issue
@@ -638,7 +633,7 @@ xfs_fsync(
 	 */
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 
-	if (!(ip->i_update_size || ip->i_update_core)) {
+	if (!ip->i_update_core) {
 		/*
 		 * Timestamps/size haven't changed since last inode flush or
 		 * inode transaction commit.  That means either nothing got
Index: linux-2.6/fs/xfs/xfs_rw.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_rw.h	2009-08-26 20:00:27.865855523 -0300
+++ linux-2.6/fs/xfs/xfs_rw.h	2009-08-26 20:00:43.065354759 -0300
@@ -68,7 +68,6 @@ xfs_get_extsz_hint(
  * Prototypes for functions in xfs_rw.c.
  */
 extern int xfs_write_clear_setuid(struct xfs_inode *ip);
-extern int xfs_write_sync_logforce(struct xfs_mount *mp, struct xfs_inode *ip);
 extern int xfs_bwrite(struct xfs_mount *mp, struct xfs_buf *bp);
 extern int xfs_bioerror(struct xfs_buf *bp);
 extern int xfs_bioerror_relse(struct xfs_buf *bp);
Index: linux-2.6/fs/xfs/xfs_trans.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_trans.h	2009-08-26 20:00:27.869855471 -0300
+++ linux-2.6/fs/xfs/xfs_trans.h	2009-08-26 23:10:19.865855381 -0300
@@ -68,7 +68,7 @@ typedef struct xfs_trans_header {
 #define XFS_TRANS_GROWFS		14
 #define XFS_TRANS_STRAT_WRITE		15
 #define XFS_TRANS_DIOSTRAT		16
-#define	XFS_TRANS_WRITE_SYNC		17
+/* 17 was XFS_TRANS_WRITE_SYNC */
 #define	XFS_TRANS_WRITEID		18
 #define	XFS_TRANS_ADDAFORK		19
 #define	XFS_TRANS_ATTRINVAL		20
Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c	2009-08-26 20:00:27.773855150 -0300
+++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c	2009-08-26 23:11:50.853994240 -0300
@@ -216,7 +216,6 @@ xfs_setfilesize(
 	if (ip->i_d.di_size < isize) {
 		ip->i_d.di_size = isize;
 		ip->i_update_core = 1;
-		ip->i_update_size = 1;
 		xfs_mark_inode_dirty_sync(ip);
 	}
 
Index: linux-2.6/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_iget.c	2009-08-26 20:00:27.873854932 -0300
+++ linux-2.6/fs/xfs/xfs_iget.c	2009-08-26 23:10:19.757855279 -0300
@@ -82,7 +82,6 @@ xfs_inode_alloc(
 	memset(&ip->i_df, 0, sizeof(xfs_ifork_t));
 	ip->i_flags = 0;
 	ip->i_update_core = 0;
-	ip->i_update_size = 0;
 	ip->i_delayed_blks = 0;
 	memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));
 	ip->i_size = 0;
Index: linux-2.6/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.h	2009-08-26 20:00:27.881855180 -0300
+++ linux-2.6/fs/xfs/xfs_inode.h	2009-08-26 23:11:50.961355085 -0300
@@ -261,7 +261,6 @@ typedef struct xfs_inode {
 	/* Miscellaneous state. */
 	unsigned short		i_flags;	/* see defined flags below */
 	unsigned char		i_update_core;	/* timestamps/size is dirty */
-	unsigned char		i_update_size;	/* di_size field is dirty */
 	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
 
 	xfs_icdinode_t		i_d;		/* most of ondisk inode */
Index: linux-2.6/fs/xfs/xfs_inode_item.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode_item.c	2009-08-26 20:00:27.889856056 -0300
+++ linux-2.6/fs/xfs/xfs_inode_item.c	2009-08-26 23:11:50.933355367 -0300
@@ -263,14 +263,6 @@ xfs_inode_item_format(
 	}
 
 	/*
-	 * We don't have to worry about re-ordering here because
-	 * the update_size field is protected by the inode lock
-	 * and we have that held in exclusive mode.
-	 */
-	if (ip->i_update_size)
-		ip->i_update_size = 0;
-
-	/*
 	 * Make sure to get the latest atime from the Linux inode.
 	 */
 	xfs_synchronize_atime(ip);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
