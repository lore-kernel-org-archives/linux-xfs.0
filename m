Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1F9ilN3047250 for <xfs@oss.sgi.com>; Mon, 15 Feb 2010 03:44:49 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3EE6D1D040D
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2010 01:46:05 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id m39FVWscEl4jUFTM for
	<xfs@oss.sgi.com>; Mon, 15 Feb 2010 01:46:05 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NgxWm-0000FD-RY
	for xfs@oss.sgi.com; Mon, 15 Feb 2010 09:46:04 +0000
Message-Id: <20100215094604.640912740@bombadil.infradead.org>
Date: Mon, 15 Feb 2010 04:44:48 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/4] [PATCH 3/4] xfs: remove wrapper for the fsync file
	operation
References: <20100215094445.528696829@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fsync-cleanup
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Currently the fsync file operation is divided into a low-level routine doing
all the work and one that implements the Linux file operation and does minimal
argument wrapping.  This is a leftover from the days of the vnode operations
layer and can be removed to simplify the code a bit, as well as preparing for
the implementation of an optimized fdatasync which needs to look at the
Linux inode state.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2010-02-15 10:18:58.640023657 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_file.c	2010-02-15 10:28:07.311260422 +0100
@@ -35,6 +35,7 @@
 #include "xfs_dir2_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_inode_item.h"
 #include "xfs_bmap.h"
 #include "xfs_error.h"
 #include "xfs_rw.h"
@@ -96,6 +97,120 @@ xfs_iozero(
 	return (-status);
 }
 
+/*
+ * We ignore the datasync flag here because a datasync is effectively
+ * identical to an fsync. That is, datasync implies that we need to write
+ * only the metadata needed to be able to access the data that is written
+ * if we crash after the call completes. Hence if we are writing beyond
+ * EOF we have to log the inode size change as well, which makes it a
+ * full fsync. If we don't write beyond EOF, the inode core will be
+ * clean in memory and so we don't need to log the inode, just like
+ * fsync.
+ */
+STATIC int
+xfs_file_fsync(
+	struct file		*file,
+	struct dentry		*dentry,
+	int			datasync)
+{
+	struct xfs_inode	*ip = XFS_I(dentry->d_inode);
+	struct xfs_trans	*tp;
+	int			error = 0;
+	int			log_flushed = 0;
+
+	xfs_itrace_entry(ip);
+
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		return -XFS_ERROR(EIO);
+
+	xfs_iflags_clear(ip, XFS_ITRUNCATED);
+
+	/*
+	 * We always need to make sure that the required inode state is safe on
+	 * disk.  The inode might be clean but we still might need to force the
+	 * log because of committed transactions that haven't hit the disk yet.
+	 * Likewise, there could be unflushed non-transactional changes to the
+	 * inode core that have to go to disk and this requires us to issue
+	 * a synchronous transaction to capture these changes correctly.
+	 *
+	 * This code relies on the assumption that if the i_update_core field
+	 * of the inode is clear and the inode is unpinned then it is clean
+	 * and no action is required.
+	 */
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+
+	if (ip->i_update_core) {
+		/*
+		 * Kick off a transaction to log the inode core to get the
+		 * updates.  The sync transaction will also force the log.
+		 */
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
+		tp = xfs_trans_alloc(ip->i_mount, XFS_TRANS_FSYNC_TS);
+		error = xfs_trans_reserve(tp, 0,
+				XFS_FSYNC_TS_LOG_RES(ip->i_mount), 0, 0, 0);
+		if (error) {
+			xfs_trans_cancel(tp, 0);
+			return -error;
+		}
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+		/*
+		 * Note - it's possible that we might have pushed ourselves out
+		 * of the way during trans_reserve which would flush the inode.
+		 * But there's no guarantee that the inode buffer has actually
+		 * gone out yet (it's delwri).	Plus the buffer could be pinned
+		 * anyway if it's part of an inode in another recent
+		 * transaction.	 So we play it safe and fire off the
+		 * transaction anyway.
+		 */
+		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+		xfs_trans_ihold(tp, ip);
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+		xfs_trans_set_sync(tp);
+		error = _xfs_trans_commit(tp, 0, &log_flushed);
+
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	} else {
+		/*
+		 * Timestamps/size haven't changed since last inode flush or
+		 * inode transaction commit.  That means either nothing got
+		 * written or a transaction committed which caught the updates.
+		 * If the latter happened and the transaction hasn't hit the
+		 * disk yet, the inode will be still be pinned.  If it is,
+		 * force the log.
+		 */
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
+		if (xfs_ipincount(ip)) {
+			if (ip->i_itemp->ili_last_lsn) {
+				error = _xfs_log_force_lsn(ip->i_mount,
+						ip->i_itemp->ili_last_lsn,
+						XFS_LOG_SYNC, &log_flushed);
+			} else {
+				error = _xfs_log_force(ip->i_mount,
+						XFS_LOG_SYNC, &log_flushed);
+			}
+		}
+	}
+
+	if (ip->i_mount->m_flags & XFS_MOUNT_BARRIER) {
+		/*
+		 * If the log write didn't issue an ordered tag we need
+		 * to flush the disk cache for the data device now.
+		 */
+		if (!log_flushed)
+			xfs_blkdev_issue_flush(ip->i_mount->m_ddev_targp);
+
+		/*
+		 * If this inode is on the RT dev we need to flush that
+		 * cache as well.
+		 */
+		if (XFS_IS_REALTIME_INODE(ip))
+			xfs_blkdev_issue_flush(ip->i_mount->m_rtdev_targp);
+	}
+
+	return -error;
+}
+
 STATIC ssize_t
 xfs_file_aio_read(
 	struct kiocb		*iocb,
@@ -755,7 +870,8 @@ write_retry:
 			mutex_lock(&inode->i_mutex);
 		xfs_ilock(ip, iolock);
 
-		error2 = xfs_fsync(ip);
+		error2 = -xfs_file_fsync(file, file->f_path.dentry,
+					 (file->f_flags & __O_SYNC) ? 0 : 1);
 		if (!error)
 			error = error2;
 	}
@@ -826,28 +942,6 @@ xfs_file_release(
 	return -xfs_release(XFS_I(inode));
 }
 
-/*
- * We ignore the datasync flag here because a datasync is effectively
- * identical to an fsync. That is, datasync implies that we need to write
- * only the metadata needed to be able to access the data that is written
- * if we crash after the call completes. Hence if we are writing beyond
- * EOF we have to log the inode size change as well, which makes it a
- * full fsync. If we don't write beyond EOF, the inode core will be
- * clean in memory and so we don't need to log the inode, just like
- * fsync.
- */
-STATIC int
-xfs_file_fsync(
-	struct file		*file,
-	struct dentry		*dentry,
-	int			datasync)
-{
-	struct xfs_inode	*ip = XFS_I(dentry->d_inode);
-
-	xfs_iflags_clear(ip, XFS_ITRUNCATED);
-	return -xfs_fsync(ip);
-}
-
 STATIC int
 xfs_file_readdir(
 	struct file	*filp,
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2010-02-15 10:18:58.647025822 +0100
+++ xfs/fs/xfs/xfs_vnodeops.c	2010-02-15 10:21:33.365253716 +0100
@@ -584,113 +584,6 @@ xfs_readlink(
 }
 
 /*
- * xfs_fsync
- *
- * This is called to sync the inode and its data out to disk.  We need to hold
- * the I/O lock while flushing the data, and the inode lock while flushing the
- * inode.  The inode lock CANNOT be held while flushing the data, so acquire
- * after we're done with that.
- */
-int
-xfs_fsync(
-	xfs_inode_t	*ip)
-{
-	xfs_trans_t	*tp;
-	int		error = 0;
-	int		log_flushed = 0;
-
-	xfs_itrace_entry(ip);
-
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-		return XFS_ERROR(EIO);
-
-	/*
-	 * We always need to make sure that the required inode state is safe on
-	 * disk.  The inode might be clean but we still might need to force the
-	 * log because of committed transactions that haven't hit the disk yet.
-	 * Likewise, there could be unflushed non-transactional changes to the
-	 * inode core that have to go to disk and this requires us to issue
-	 * a synchronous transaction to capture these changes correctly.
-	 *
-	 * This code relies on the assumption that if the update_* fields
-	 * of the inode are clear and the inode is unpinned then it is clean
-	 * and no action is required.
-	 */
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-
-	if (!ip->i_update_core) {
-		/*
-		 * Timestamps/size haven't changed since last inode flush or
-		 * inode transaction commit.  That means either nothing got
-		 * written or a transaction committed which caught the updates.
-		 * If the latter happened and the transaction hasn't hit the
-		 * disk yet, the inode will be still be pinned.  If it is,
-		 * force the log.
-		 */
-		xfs_iunlock(ip, XFS_ILOCK_SHARED);
-		if (xfs_ipincount(ip)) {
-			if (ip->i_itemp->ili_last_lsn) {
-				error = _xfs_log_force_lsn(ip->i_mount,
-						ip->i_itemp->ili_last_lsn,
-						XFS_LOG_SYNC, &log_flushed);
-			} else {
-				error = _xfs_log_force(ip->i_mount,
-						XFS_LOG_SYNC, &log_flushed);
-			}
-		}
-	} else	{
-		/*
-		 * Kick off a transaction to log the inode core to get the
-		 * updates.  The sync transaction will also force the log.
-		 */
-		xfs_iunlock(ip, XFS_ILOCK_SHARED);
-		tp = xfs_trans_alloc(ip->i_mount, XFS_TRANS_FSYNC_TS);
-		error = xfs_trans_reserve(tp, 0,
-				XFS_FSYNC_TS_LOG_RES(ip->i_mount), 0, 0, 0);
-		if (error) {
-			xfs_trans_cancel(tp, 0);
-			return error;
-		}
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-
-		/*
-		 * Note - it's possible that we might have pushed ourselves out
-		 * of the way during trans_reserve which would flush the inode.
-		 * But there's no guarantee that the inode buffer has actually
-		 * gone out yet (it's delwri).	Plus the buffer could be pinned
-		 * anyway if it's part of an inode in another recent
-		 * transaction.	 So we play it safe and fire off the
-		 * transaction anyway.
-		 */
-		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-		xfs_trans_ihold(tp, ip);
-		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		xfs_trans_set_sync(tp);
-		error = _xfs_trans_commit(tp, 0, &log_flushed);
-
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	}
-
-	if (ip->i_mount->m_flags & XFS_MOUNT_BARRIER) {
-		/*
-		 * If the log write didn't issue an ordered tag we need
-		 * to flush the disk cache for the data device now.
-		 */
-		if (!log_flushed)
-			xfs_blkdev_issue_flush(ip->i_mount->m_ddev_targp);
-
-		/*
-		 * If this inode is on the RT dev we need to flush that
-		 * cache as well.
-		 */
-		if (XFS_IS_REALTIME_INODE(ip))
-			xfs_blkdev_issue_flush(ip->i_mount->m_rtdev_targp);
-	}
-
-	return error;
-}
-
-/*
  * Flags for xfs_free_eofblocks
  */
 #define XFS_FREE_EOF_TRYLOCK	(1<<0)
Index: xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.h	2010-02-15 10:18:58.668254206 +0100
+++ xfs/fs/xfs/xfs_vnodeops.h	2010-02-15 10:21:33.379012621 +0100
@@ -21,7 +21,6 @@ int xfs_setattr(struct xfs_inode *ip, st
 #define XFS_ATTR_NOACL		0x08	/* Don't call xfs_acl_chmod */
 
 int xfs_readlink(struct xfs_inode *ip, char *link);
-int xfs_fsync(struct xfs_inode *ip);
 int xfs_release(struct xfs_inode *ip);
 int xfs_inactive(struct xfs_inode *ip);
 int xfs_lookup(struct xfs_inode *dp, struct xfs_name *name,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
