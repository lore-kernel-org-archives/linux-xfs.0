Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p619k5BB056031 for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 04:46:05 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB2B01EE3234
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2011 02:46:04 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	cOPMbGSwYPLdQSmC for <xfs@oss.sgi.com>;
	Fri, 01 Jul 2011 02:46:04 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QcaIW-0001u9-86
	for xfs@oss.sgi.com; Fri, 01 Jul 2011 09:46:04 +0000
Message-Id: <20110701094604.200765470@bombadil.infradead.org>
Date: Fri, 01 Jul 2011 05:43:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 09/27] xfs: fix filesystsem freeze race in xfs_trans_alloc
References: <20110701094321.936534538@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-freeze-race
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

As pointed out by Jan xfs_trans_alloc can race with a concurrent filesystem
freeze when it sleeps during the memory allocation.  Fix this by moving the
wait_for_freeze call after the memory allocation.  This means moving the
freeze into the low-level _xfs_trans_alloc helper, which thus grows a new
argument.  Also fix up some comments in that area while at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <david@fromorbit.com>

Index: xfs/fs/xfs/xfs_fsops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_fsops.c	2011-06-18 17:50:43.477373715 +0200
+++ xfs/fs/xfs/xfs_fsops.c	2011-06-20 09:17:00.933518761 +0200
@@ -626,7 +626,7 @@ xfs_fs_log_dummy(
 	xfs_trans_t	*tp;
 	int		error;
 
-	tp = _xfs_trans_alloc(mp, XFS_TRANS_DUMMY1, KM_SLEEP);
+	tp = _xfs_trans_alloc(mp, XFS_TRANS_DUMMY1, KM_SLEEP, false);
 	error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
 					XFS_DEFAULT_LOG_COUNT);
 	if (error) {
Index: xfs/fs/xfs/xfs_iomap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.c	2011-06-18 17:50:43.487373714 +0200
+++ xfs/fs/xfs/xfs_iomap.c	2011-06-20 09:17:00.933518761 +0200
@@ -688,8 +688,7 @@ xfs_iomap_write_unwritten(
 		 * the same inode that we complete here and might deadlock
 		 * on the iolock.
 		 */
-		xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
-		tp = _xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE, KM_NOFS);
+		tp = _xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE, KM_NOFS, true);
 		tp->t_flags |= XFS_TRANS_RESERVE;
 		error = xfs_trans_reserve(tp, resblks,
 				XFS_WRITE_LOG_RES(mp), 0,
Index: xfs/fs/xfs/xfs_trans.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.h	2011-06-18 17:50:43.497373713 +0200
+++ xfs/fs/xfs/xfs_trans.h	2011-06-21 10:57:04.908840421 +0200
@@ -447,8 +447,14 @@ typedef struct xfs_trans {
 /*
  * XFS transaction mechanism exported interfaces.
  */
-xfs_trans_t	*xfs_trans_alloc(struct xfs_mount *, uint);
-xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint, uint);
+xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint, uint, bool);
+
+static inline struct xfs_trans *
+xfs_trans_alloc(struct xfs_mount *mp, uint type)
+{
+	return _xfs_trans_alloc(mp, type, KM_SLEEP, true);
+}
+
 xfs_trans_t	*xfs_trans_dup(xfs_trans_t *);
 int		xfs_trans_reserve(xfs_trans_t *, uint, uint, uint,
 				  uint, uint);
Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2011-06-18 17:50:43.510707047 +0200
+++ xfs/fs/xfs/xfs_mount.c	2011-06-20 09:17:00.936852094 +0200
@@ -1566,15 +1566,9 @@ xfs_fs_writable(xfs_mount_t *mp)
 }
 
 /*
- * xfs_log_sbcount
- *
  * Called either periodically to keep the on disk superblock values
  * roughly up to date or from unmount to make sure the values are
  * correct on a clean unmount.
- *
- * Note this code can be called during the process of freezing, so
- * we may need to use the transaction allocator which does not not
- * block when the transaction subsystem is in its frozen state.
  */
 int
 xfs_log_sbcount(
@@ -1596,7 +1590,13 @@ xfs_log_sbcount(
 	if (!xfs_sb_version_haslazysbcount(&mp->m_sb))
 		return 0;
 
-	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_COUNT, KM_SLEEP);
+	/*
+	 * We can be called during the process of freezing, so make sure
+	 * we go ahead even if the frozen for new transactions.  We will
+	 * always use a sync transaction in the freeze path to make sure
+	 * the transaction has completed by the time we return.
+	 */
+	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_COUNT, KM_SLEEP, false);
 	error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
 					XFS_DEFAULT_LOG_COUNT);
 	if (error) {
Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2011-06-18 17:50:43.524040379 +0200
+++ xfs/fs/xfs/xfs_trans.c	2011-06-21 10:56:25.305509042 +0200
@@ -566,31 +566,24 @@ xfs_trans_init(
 
 /*
  * This routine is called to allocate a transaction structure.
+ *
  * The type parameter indicates the type of the transaction.  These
  * are enumerated in xfs_trans.h.
- *
- * Dynamically allocate the transaction structure from the transaction
- * zone, initialize it, and return it to the caller.
  */
-xfs_trans_t *
-xfs_trans_alloc(
-	xfs_mount_t	*mp,
-	uint		type)
-{
-	xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
-	return _xfs_trans_alloc(mp, type, KM_SLEEP);
-}
-
-xfs_trans_t *
+struct xfs_trans *
 _xfs_trans_alloc(
-	xfs_mount_t	*mp,
-	uint		type,
-	uint		memflags)
+	struct xfs_mount	*mp,
+	uint			type,
+	uint			memflags,
+	bool			wait_for_freeze)
 {
-	xfs_trans_t	*tp;
+	struct xfs_trans	*tp;
 
 	atomic_inc(&mp->m_active_trans);
 
+	if (wait_for_freeze)
+		xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
+
 	tp = kmem_zone_zalloc(xfs_trans_zone, memflags);
 	tp->t_magic = XFS_TRANS_MAGIC;
 	tp->t_type = type;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
