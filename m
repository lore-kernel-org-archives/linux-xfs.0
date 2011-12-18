Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBIFoHlZ215259 for <xfs@oss.sgi.com>; Sun, 18 Dec 2011 09:50:17 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	8Q78BExMMfINQIHk for <xfs@oss.sgi.com>;
	Sun, 18 Dec 2011 07:50:15 -0800 (PST)
Date: Sun, 18 Dec 2011 10:50:15 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] xfs: log all dirty inodes in xfs_fs_sync_fs
Message-ID: <20111218155015.GC17626@infradead.org>
References: <20111218154936.GA17626@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111218154936.GA17626@infradead.org>
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
Cc: Paul Anderson <pha@umich.edu>, Sean Thomas Caron <scaron@umich.edu>

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
--- xfs.orig/fs/xfs/xfs_sync.c	2011-12-14 05:33:06.436599621 -0800
+++ xfs/fs/xfs/xfs_sync.c	2011-12-14 05:38:49.084743337 -0800
@@ -336,6 +336,29 @@ xfs_sync_fsdata(
 	return error;
 }
 
+int
+xfs_log_inode(
+	struct xfs_inode	*ip,
+	struct xfs_perag	*pag,
+	int			flags)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			error;
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
@@ -359,6 +382,16 @@ xfs_quiesce_data(
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
+	xfs_inode_ag_iterator(mp, xfs_log_inode, 0);
+
 	xfs_qm_sync(mp, SYNC_TRYLOCK);
 	xfs_qm_sync(mp, SYNC_WAIT);
 
Index: xfs/fs/xfs/xfs_sync.h
===================================================================
--- xfs.orig/fs/xfs/xfs_sync.h	2011-10-17 00:28:57.255149593 -0700
+++ xfs/fs/xfs/xfs_sync.h	2011-12-14 05:39:23.187891918 -0800
@@ -34,6 +34,8 @@ void xfs_quiesce_attr(struct xfs_mount *
 
 void xfs_flush_inodes(struct xfs_inode *ip);
 
+int xfs_log_inode(struct xfs_inode *ip, struct xfs_perag *pag, int flags);
+
 int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
 int xfs_reclaim_inodes_count(struct xfs_mount *mp);
 void xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
Index: xfs/fs/xfs/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/xfs_super.c	2011-12-14 05:33:07.193262189 -0800
+++ xfs/fs/xfs/xfs_super.c	2011-12-14 05:38:56.108038623 -0800
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
@@ -913,7 +892,7 @@ xfs_fs_write_inode(
 		 * ->sync_fs call do that for thus, which reduces the number
 		 * of synchronous log forces dramatically.
 		 */
-		error = xfs_log_inode(ip);
+		error = xfs_log_inode(ip, NULL, 0);
 		if (error)
 			goto out;
 		return 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
