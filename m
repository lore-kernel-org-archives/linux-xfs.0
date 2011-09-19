Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8JEttil255964 for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 09:55:55 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 994521C24507
	for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 07:55:53 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	EJaEjwzl1F20b5G2 for <xfs@oss.sgi.com>;
	Mon, 19 Sep 2011 07:55:53 -0700 (PDT)
Date: Mon, 19 Sep 2011 10:55:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3 v2] xfs: unlock the inode before log force in xfs_fsync
Message-ID: <20110919145551.GA16282@infradead.org>
References: <20110918204748.547510183@bombadil.infradead.org>
	<20110918204909.860669185@bombadil.infradead.org>
	<20110918225903.GC15688@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110918225903.GC15688@dastard>
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

Only read the LSN we need to push to with the ilock held, and then release
it before we do the log force to improve concurrency.

This also removes the only direct caller of _xfs_trans_commit, thus
allowing it to be merged into the plain xfs_trans_commit again.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/xfs_file.c	2011-09-18 16:34:03.995780628 -0400
+++ xfs/fs/xfs/xfs_file.c	2011-09-19 10:47:07.679732387 -0400
@@ -137,6 +137,7 @@ xfs_file_fsync(
 	struct xfs_trans	*tp;
 	int			error = 0;
 	int			log_flushed = 0;
+	xfs_lsn_t		lsn = 0;
 
 	trace_xfs_file_fsync(ip);
 
@@ -214,9 +215,9 @@ xfs_file_fsync(
 		 */
 		xfs_trans_ijoin(tp, ip);
 		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		xfs_trans_set_sync(tp);
-		error = _xfs_trans_commit(tp, 0, &log_flushed);
+		error = xfs_trans_commit(tp, 0);
 
+		lsn = ip->i_itemp->ili_last_lsn;
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	} else {
 		/*
@@ -227,14 +228,14 @@ xfs_file_fsync(
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
--- xfs.orig/fs/xfs/xfs_trans.c	2011-09-18 16:31:44.255777336 -0400
+++ xfs/fs/xfs/xfs_trans.c	2011-09-19 10:46:47.181231805 -0400
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
--- xfs.orig/fs/xfs/xfs_trans.h	2011-09-18 16:31:44.271777154 -0400
+++ xfs/fs/xfs/xfs_trans.h	2011-09-19 10:46:47.081232193 -0400
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
