Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q049V7f7125057 for <xfs@oss.sgi.com>; Wed, 4 Jan 2012 03:31:07 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	s0IZeGDudwyEcfPb for <xfs@oss.sgi.com>;
	Wed, 04 Jan 2012 01:31:05 -0800 (PST)
Message-Id: <20120104093105.180405280@bombadil.infradead.org>
Date: Wed, 04 Jan 2012 04:30:17 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] xfs: log all dirty inodes in xfs_fs_sync_fs
References: <20120104093015.056917499@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-sync
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
To: stable@vger.kernel.org, xfs@oss.sgi.com

Since Linux 2.6.36 the writeback code has introduces various measures for
live lock prevention during sync().  Unfortunately some of these are
actively harmful for the XFS model, where the inode gets marked dirty for
metadata from the data I/O handler.

The older_than_this checks that are now more strictly enforced since

    writeback: avoid livelocking WB_SYNC_ALL writeback

by only calling into __writeback_inodes_sb and thus only sampling the
current cut off time once.  But on a slow enough devices the previous
asynchronous sync pass might not have fully completed yet, and thus XFS
might mark metadata dirty only after that sampling of the cut off time for
the blocking pass already happened.  I have not myself reproduced this
myself on a real system, but by introducing artificial delay into the
XFS I/O completion workqueues it can be reproduced easily.

Fix this by iterating over all XFS inodes in ->sync_fs and log all that
are dirty.  This might log inode that only got redirtied after the
previous pass, but given how cheap delayed logging of inodes is it
isn't a major concern for performance.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/xfs_sync.c	2011-12-18 23:35:30.909834592 +0100
+++ xfs/fs/xfs/xfs_sync.c	2011-12-18 23:36:40.823167508 +0100
@@ -336,6 +336,32 @@ xfs_sync_fsdata(
 	return error;
 }
 
+int
+xfs_log_dirty_inode(
+	struct xfs_inode	*ip,
+	struct xfs_perag	*pag,
+	int			flags)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			error;
+
+	if (!ip->i_update_core)
+		return 0;
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
+	error = xfs_trans_reserve(tp, 0, XFS_FSYNC_TS_LOG_RES(mp), 0, 0, 0);
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		return error;
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	return xfs_trans_commit(tp, 0);
+}
+
 /*
  * When remounting a filesystem read-only or freezing the filesystem, we have
  * two phases to execute. This first phase is syncing the data before we
@@ -359,6 +385,16 @@ xfs_quiesce_data(
 {
 	int			error, error2 = 0;
 
+	/*
+	 * Log all pending size and timestamp updates.  The vfs writeback
+	 * code is supposed to do this, but due to its overagressive
+	 * livelock detection it will skip inodes where appending writes
+	 * were written out in the first non-blocking sync phase if their
+	 * completion took long enough that it happened after taking the
+	 * timestamp for the cut-off in the blocking phase.
+	 */
+	xfs_inode_ag_iterator(mp, xfs_log_dirty_inode, 0);
+
 	xfs_qm_sync(mp, SYNC_TRYLOCK);
 	xfs_qm_sync(mp, SYNC_WAIT);
 
Index: xfs/fs/xfs/xfs_sync.h
===================================================================
--- xfs.orig/fs/xfs/xfs_sync.h	2011-12-18 16:47:25.000000000 +0100
+++ xfs/fs/xfs/xfs_sync.h	2011-12-18 23:36:45.119834149 +0100
@@ -34,6 +34,8 @@ void xfs_quiesce_attr(struct xfs_mount *
 
 void xfs_flush_inodes(struct xfs_inode *ip);
 
+int xfs_log_dirty_inode(struct xfs_inode *ip, struct xfs_perag *pag, int flags);
+
 int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
 int xfs_reclaim_inodes_count(struct xfs_mount *mp);
 void xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
Index: xfs/fs/xfs/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/xfs_super.c	2011-12-18 23:35:42.863167854 +0100
+++ xfs/fs/xfs/xfs_super.c	2011-12-18 23:36:42.963167495 +0100
@@ -869,27 +869,6 @@ xfs_fs_dirty_inode(
 }
 
 STATIC int
-xfs_log_inode(
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_trans	*tp;
-	int			error;
-
-	tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
-	error = xfs_trans_reserve(tp, 0, XFS_FSYNC_TS_LOG_RES(mp), 0, 0, 0);
-	if (error) {
-		xfs_trans_cancel(tp, 0);
-		return error;
-	}
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	return xfs_trans_commit(tp, 0);
-}
-
-STATIC int
 xfs_fs_write_inode(
 	struct inode		*inode,
 	struct writeback_control *wbc)
@@ -902,8 +881,6 @@ xfs_fs_write_inode(
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -XFS_ERROR(EIO);
-	if (!ip->i_update_core)
-		return 0;
 
 	if (wbc->sync_mode == WB_SYNC_ALL || wbc->for_kupdate) {
 		/*
@@ -913,11 +890,14 @@ xfs_fs_write_inode(
 		 * ->sync_fs call do that for thus, which reduces the number
 		 * of synchronous log forces dramatically.
 		 */
-		error = xfs_log_inode(ip);
+		error = xfs_log_dirty_inode(ip, NULL, 0);
 		if (error)
 			goto out;
 		return 0;
 	} else {
+		if (!ip->i_update_core)
+			return 0;
+
 		/*
 		 * We make this non-blocking if the inode is contended, return
 		 * EAGAIN to indicate to the caller that they did not succeed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
