Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0P94pGd226550 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 03:04:53 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1DA27105607B
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 01:07:14 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id qB6JhcmxdazEhV0S for
	<xfs@oss.sgi.com>; Tue, 25 Jan 2011 01:07:14 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Pherq-0006BR-Cl
	for xfs@oss.sgi.com; Tue, 25 Jan 2011 09:07:14 +0000
Message-Id: <20110125090714.355476519@bombadil.infradead.org>
Date: Tue, 25 Jan 2011 04:06:21 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3] xfs: add lockdep annotations for the rt inodes
References: <20110125090618.432370964@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-rtinode-lockdep
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

The rt bitmap and summary inodes do not participate in the normal inode
locking protocol.  Instead the rt bitmap inode can be locked in any
transaction involving rt allocations, and the both of the rt inodes can
be locked at the same time.  Add specific lockdep subclasses for the rt
inodes to prevent lockdep from blowing up.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-01-24 16:02:40.000000000 +0100
+++ xfs/fs/xfs/xfs_bmap.c	2011-01-24 16:03:03.416004409 +0100
@@ -2354,7 +2354,7 @@ xfs_bmap_rtalloc(
 	 * Lock out other modifications to the RT bitmap inode.
 	 */
 	error = xfs_trans_iget(mp, ap->tp, mp->m_sb.sb_rbmino, 0,
-			       XFS_ILOCK_EXCL, &ip);
+			       XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP, &ip);
 	if (error)
 		return error;
 	ASSERT(ip == mp->m_rbmip);
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2011-01-24 16:02:30.000000000 +0100
+++ xfs/fs/xfs/xfs_inode.h	2011-01-24 16:02:46.885004130 +0100
@@ -409,28 +409,35 @@ static inline void xfs_ifunlock(xfs_inod
 /*
  * Flags for lockdep annotations.
  *
- * XFS_I[O]LOCK_PARENT - for operations that require locking two inodes
- * (ie directory operations that require locking a directory inode and
- * an entry inode).  The first inode gets locked with this flag so it
- * gets a lockdep subclass of 1 and the second lock will have a lockdep
- * subclass of 0.
+ * XFS_LOCK_PARENT - for directory operations that require locking a
+ * parent directory inode and a child entry inode.  The parent gets locked
+ * with this flag so it gets a lockdep subclass of 1 and the child entry
+ * lock will have a lockdep subclass of 0.
+ *
+ * XFS_LOCK_RTBITMAP/XFS_LOCK_RTSUM - the realtime device bitmap and summary
+ * inodes do not participate in the normal lock order, and thus have their
+ * own subclasses.
  *
  * XFS_LOCK_INUMORDER - for locking several inodes at the some time
  * with xfs_lock_inodes().  This flag is used as the starting subclass
  * and each subsequent lock acquired will increment the subclass by one.
- * So the first lock acquired will have a lockdep subclass of 2, the
- * second lock will have a lockdep subclass of 3, and so on. It is
+ * So the first lock acquired will have a lockdep subclass of 4, the
+ * second lock will have a lockdep subclass of 5, and so on. It is
  * the responsibility of the class builder to shift this to the correct
  * portion of the lock_mode lockdep mask.
  */
 #define XFS_LOCK_PARENT		1
-#define XFS_LOCK_INUMORDER	2
+#define XFS_LOCK_RTBITMAP	2
+#define XFS_LOCK_RTSUM		3
+#define XFS_LOCK_INUMORDER	4
 
 #define XFS_IOLOCK_SHIFT	16
 #define	XFS_IOLOCK_PARENT	(XFS_LOCK_PARENT << XFS_IOLOCK_SHIFT)
 
 #define XFS_ILOCK_SHIFT		24
 #define	XFS_ILOCK_PARENT	(XFS_LOCK_PARENT << XFS_ILOCK_SHIFT)
+#define	XFS_ILOCK_RTBITMAP	(XFS_LOCK_RTBITMAP << XFS_ILOCK_SHIFT)
+#define	XFS_ILOCK_RTSUM		(XFS_LOCK_RTSUM << XFS_ILOCK_SHIFT)
 
 #define XFS_IOLOCK_DEP_MASK	0x00ff0000
 #define XFS_ILOCK_DEP_MASK	0xff000000
Index: xfs/fs/xfs/xfs_rtalloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rtalloc.c	2011-01-24 16:02:30.000000000 +0100
+++ xfs/fs/xfs/xfs_rtalloc.c	2011-01-24 16:02:46.889004409 +0100
@@ -1972,8 +1972,10 @@ xfs_growfs_rt(
 		/*
 		 * Lock out other callers by grabbing the bitmap inode lock.
 		 */
-		if ((error = xfs_trans_iget(mp, tp, mp->m_sb.sb_rbmino, 0,
-						XFS_ILOCK_EXCL, &ip)))
+		error = xfs_trans_iget(mp, tp, mp->m_sb.sb_rbmino, 0,
+				       XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP,
+				       &ip);
+		if (error)
 			goto error_cancel;
 		ASSERT(ip == mp->m_rbmip);
 		/*
@@ -1986,8 +1988,9 @@ xfs_growfs_rt(
 		/*
 		 * Get the summary inode into the transaction.
 		 */
-		if ((error = xfs_trans_iget(mp, tp, mp->m_sb.sb_rsumino, 0,
-						XFS_ILOCK_EXCL, &ip)))
+		error = xfs_trans_iget(mp, tp, mp->m_sb.sb_rsumino, 0,
+				       XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM, &ip);
+		if (error)
 			goto error_cancel;
 		ASSERT(ip == mp->m_rsumip);
 		/*
@@ -2160,8 +2163,9 @@ xfs_rtfree_extent(
 	/*
 	 * Synchronize by locking the bitmap inode.
 	 */
-	if ((error = xfs_trans_iget(mp, tp, mp->m_sb.sb_rbmino, 0,
-					XFS_ILOCK_EXCL, &ip)))
+	error = xfs_trans_iget(mp, tp, mp->m_sb.sb_rbmino, 0,
+			       XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP, &ip);
+	if (error)
 		return error;
 #if defined(__KERNEL__) && defined(DEBUG)
 	/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
