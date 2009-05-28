Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4SCJjaV253038 for <xfs@oss.sgi.com>; Thu, 28 May 2009 07:19:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4ED102B6899
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 05:19:48 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id iD4paDxlhIzIhWr8 for
	<xfs@oss.sgi.com>; Thu, 28 May 2009 05:19:48 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1M9eaJ-0000Jm-Kq
	for xfs@oss.sgi.com; Thu, 28 May 2009 12:19:47 +0000
Date: Thu, 28 May 2009 08:19:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 9/7] xfs: remove SYNC_BDFLUSH
Message-ID: <20090528121947.GB30037@infradead.org>
References: <20090514171233.942489000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090514171233.942489000@bombadil.infradead.org>
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

SYNC_BDFLUSH is a leftover from IRIX and rather misnamed for todays
code.  Make xfs_sync_fsdata and xfs_dq_sync use the SYNC_TRYLOCK flag
for not blocking on logs just as the inode sync code already does.

For xfs_sync_fsdata it's a trivial 1:1 replacement, but for xfs_qm_sync
I use the opportunity to decouple the non-blocking lock case from the
different flushing modes, similar to the inode sync code.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-05-27 13:02:57.426938830 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2009-05-27 13:07:53.227939055 +0200
@@ -350,7 +350,7 @@ xfs_sync_fsdata(
 	 * If this is xfssyncd() then only sync the superblock if we can
 	 * lock it without sleeping and it is not pinned.
 	 */
-	if (flags & SYNC_BDFLUSH) {
+	if (flags & SYNC_TRYLOCK) {
 		ASSERT(!(flags & SYNC_WAIT));
 
 		bp = xfs_getsb(mp, XFS_BUF_TRYLOCK);
@@ -415,7 +415,7 @@ xfs_quiesce_data(
 
 	/* push non-blocking */
 	xfs_sync_data(mp, 0);
-	xfs_qm_sync(mp, SYNC_BDFLUSH);
+	xfs_qm_sync(mp, SYNC_TRYLOCK);
 	xfs_filestream_flush(mp);
 
 	/* push and block */
@@ -565,8 +565,8 @@ xfs_sync_worker(
 		xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE);
 		xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
 		/* dgc: errors ignored here */
-		error = xfs_qm_sync(mp, SYNC_BDFLUSH);
-		error = xfs_sync_fsdata(mp, SYNC_BDFLUSH);
+		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
+		error = xfs_sync_fsdata(mp, SYNC_TRYLOCK);
 		if (xfs_log_need_covered(mp))
 			error = xfs_commit_dummy_trans(mp, XFS_LOG_FORCE);
 	}
Index: xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.c	2009-05-27 13:04:00.607842293 +0200
+++ xfs/fs/xfs/quota/xfs_qm.c	2009-05-27 13:10:21.688940102 +0200
@@ -905,11 +905,6 @@ xfs_qm_dqdetach(
 	}
 }
 
-/*
- * This is called to sync quotas. We can be told to use non-blocking
- * semantics by either the SYNC_BDFLUSH flag or the absence of the
- * SYNC_WAIT flag.
- */
 int
 xfs_qm_sync(
 	xfs_mount_t	*mp,
@@ -918,17 +913,13 @@ xfs_qm_sync(
 	int		recl, restarts;
 	xfs_dquot_t	*dqp;
 	uint		flush_flags;
-	boolean_t	nowait;
 	int		error;
 
 	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
 		return 0;
 
+	flush_flags = (flags & SYNC_WAIT) ? XFS_QMOPT_SYNC : XFS_QMOPT_DELWRI;
 	restarts = 0;
-	/*
-	 * We won't block unless we are asked to.
-	 */
-	nowait = (boolean_t)(flags & SYNC_BDFLUSH || (flags & SYNC_WAIT) == 0);
 
   again:
 	xfs_qm_mplist_lock(mp);
@@ -948,18 +939,10 @@ xfs_qm_sync(
 		 * don't 'seem' to be dirty. ie. don't acquire dqlock.
 		 * This is very similar to what xfs_sync does with inodes.
 		 */
-		if (flags & SYNC_BDFLUSH) {
-			if (! XFS_DQ_IS_DIRTY(dqp))
+		if (flags & SYNC_TRYLOCK) {
+			if (!XFS_DQ_IS_DIRTY(dqp))
 				continue;
-		}
-
-		if (nowait) {
-			/*
-			 * Try to acquire the dquot lock. We are NOT out of
-			 * lock order, but we just don't want to wait for this
-			 * lock, unless somebody wanted us to.
-			 */
-			if (! xfs_qm_dqlock_nowait(dqp))
+			if (!xfs_qm_dqlock_nowait(dqp))
 				continue;
 		} else {
 			xfs_dqlock(dqp);
@@ -976,7 +959,7 @@ xfs_qm_sync(
 		/* XXX a sentinel would be better */
 		recl = XFS_QI_MPLRECLAIMS(mp);
 		if (!xfs_dqflock_nowait(dqp)) {
-			if (nowait) {
+			if (flags & SYNC_TRYLOCK) {
 				xfs_dqunlock(dqp);
 				continue;
 			}
@@ -994,7 +977,6 @@ xfs_qm_sync(
 		 * Let go of the mplist lock. We don't want to hold it
 		 * across a disk write
 		 */
-		flush_flags = (nowait) ? XFS_QMOPT_DELWRI : XFS_QMOPT_SYNC;
 		xfs_qm_mplist_unlock(mp);
 		xfs_dqtrace_entry(dqp, "XQM_SYNC: DQFLUSH");
 		error = xfs_qm_dqflush(dqp, flush_flags);
Index: xfs/fs/xfs/linux-2.6/xfs_sync.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.h	2009-05-27 13:07:58.997814418 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.h	2009-05-27 13:08:19.922972203 +0200
@@ -29,9 +29,8 @@ typedef struct xfs_sync_work {
 	struct completion	*w_completion;
 } xfs_sync_work_t;
 
-#define SYNC_WAIT		0x0004	/* wait for i/o to complete */
-#define SYNC_BDFLUSH		0x0008	/* BDFLUSH is calling -- don't block */
-#define SYNC_TRYLOCK		0x0020  /* only try to lock inodes */
+#define SYNC_WAIT		0x0001	/* wait for i/o to complete */
+#define SYNC_TRYLOCK		0x0002  /* only try to lock inodes */
 
 int xfs_syncd_init(struct xfs_mount *mp);
 void xfs_syncd_stop(struct xfs_mount *mp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
