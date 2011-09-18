Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IKnBsn201709 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 15:49:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD4C4172085
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 13:49:10 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ANUw7AIPzL8tCs3T for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2011 13:49:10 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1R5OIX-0005x2-T7
	for xfs@oss.sgi.com; Sun, 18 Sep 2011 20:49:09 +0000
Message-Id: <20110918204909.860669185@bombadil.infradead.org>
Date: Sun, 18 Sep 2011 16:47:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3] xfs: unlock the inode before log force in xfs_fsync
References: <20110918204748.547510183@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-optimize-fsync-2
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

Only read the LSN we need to push to with the ilock held, and then release
it before we do the log force to improve concurrency.

This also removes the only direct caller of _xfs_trans_commit, thus
allowing it to be merged into the plain xfs_trans_commit again.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/xfs_file.c	2011-09-07 10:59:55.742961175 +0200
+++ xfs/fs/xfs/xfs_file.c	2011-09-07 11:08:12.830462974 +0200
@@ -137,6 +137,7 @@ xfs_file_fsync(
 	struct xfs_trans	*tp;
 	int			error = 0;
 	int			log_flushed = 0;
+	xfs_lsn_t		lsn = 0;
 
 	trace_xfs_file_fsync(ip);
 
@@ -214,8 +215,10 @@ xfs_file_fsync(
 		 */
 		xfs_trans_ijoin(tp, ip);
 		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		xfs_trans_set_sync(tp);
-		error = _xfs_trans_commit(tp, 0, &log_flushed);
+		error = xfs_trans_commit(tp, 0);
+
+		ASSERT(xfs_ipincount(ip));
+		lsn = ip->i_itemp->ili_last_lsn;
 
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	} else {
@@ -227,14 +230,14 @@ xfs_file_fsync(
 		 * disk yet, the inode will be still be pinned.  If it is,
 		 * force the log.
 		 */
-		if (xfs_ipincount(ip)) {
-			error = _xfs_log_force_lsn(mp,
-					ip->i_itemp->ili_last_lsn,
-					XFS_LOG_SYNC, &log_flushed);
-		}
+		if (xfs_ipincount(ip))
+			lsn = ip->i_itemp->ili_last_lsn;
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 	}
 
+	if (!error && lsn)
+		error = _xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, &log_flushed);
+
 	/*
 	 * If we only have a single device, and the log force about was
 	 * a no-op we might have to flush the data device cache here.
Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2011-09-07 10:59:55.702959720 +0200
+++ xfs/fs/xfs/xfs_trans.c	2011-09-07 11:06:20.686461455 +0200
@@ -1790,9 +1790,7 @@ xfs_trans_commit_cil(
 }
 
 /*
- * xfs_trans_commit
- *
- * Commit the given transaction to the log a/synchronously.
+ * Commit the given transaction to the log.
  *
  * XFS disk error handling mechanism is not based on a typical
  * transaction abort mechanism. Logically after the filesystem
@@ -1804,10 +1802,9 @@ xfs_trans_commit_cil(
  * Do not reference the transaction structure after this call.
  */
 int
-_xfs_trans_commit(
+xfs_trans_commit(
 	struct xfs_trans	*tp,
-	uint			flags,
-	int			*log_flushed)
+	uint			flags)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	xfs_lsn_t		commit_lsn = -1;
@@ -1866,7 +1863,7 @@ _xfs_trans_commit(
 	if (sync) {
 		if (!error) {
 			error = _xfs_log_force_lsn(mp, commit_lsn,
-				      XFS_LOG_SYNC, log_flushed);
+				      XFS_LOG_SYNC, NULL);
 		}
 		XFS_STATS_INC(xs_trans_sync);
 	} else {
Index: xfs/fs/xfs/xfs_trans.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.h	2011-09-07 10:59:55.722959398 +0200
+++ xfs/fs/xfs/xfs_trans.h	2011-09-07 11:05:11.766461375 +0200
@@ -487,10 +487,7 @@ void		xfs_trans_log_efd_extent(xfs_trans
 					 struct xfs_efd_log_item *,
 					 xfs_fsblock_t,
 					 xfs_extlen_t);
-int		_xfs_trans_commit(xfs_trans_t *,
-				  uint flags,
-				  int *);
-#define xfs_trans_commit(tp, flags)	_xfs_trans_commit(tp, flags, NULL)
+int		xfs_trans_commit(xfs_trans_t *, uint flags);
 void		xfs_trans_cancel(xfs_trans_t *, int);
 int		xfs_trans_ail_init(struct xfs_mount *);
 void		xfs_trans_ail_destroy(struct xfs_mount *);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
