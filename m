Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1HJgb6E255999 for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 13:42:38 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B88B31DA838
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 11:43:56 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id dpKmhI0vBSZs3TxM for
	<xfs@oss.sgi.com>; Wed, 17 Feb 2010 11:43:56 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NhpoS-0007W6-Et
	for xfs@oss.sgi.com; Wed, 17 Feb 2010 19:43:56 +0000
Date: Wed, 17 Feb 2010 14:43:56 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/2] xfs: cleanup xfs_iunpin_wait/xfs_iunpin_nowait
Message-ID: <20100217194356.GA28758@infradead.org>
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

Remove the inode item pointer and ili_last_lsn checks in __xfs_iunpin_wait
as any pinned inode is guaranteed to have them valid.  After this the
xfs_iunpin_nowait case is nothing more than a xfs_log_force_lsn, as we
know that the caller has already checked the pincount.

Make xfs_iunpin_nowait the new low-level routine just doing the log force
and rewrite xfs_iunpin_wait around it.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2010-02-17 10:47:39.141254207 +0100
+++ xfs/fs/xfs/xfs_inode.c	2010-02-17 10:55:24.505255043 +0100
@@ -2467,47 +2467,31 @@ xfs_iunpin(
 }
 
 /*
- * This is called to unpin an inode. It can be directed to wait or to return
- * immediately without waiting for the inode to be unpinned.  The caller must
- * have the inode locked in at least shared mode so that the buffer cannot be
- * subsequently pinned once someone is waiting for it to be unpinned.
+ * This is called to unpin an inode.  The caller must have the inode locked
+ * in at least shared mode so that the buffer cannot be subsequently pinned
+ * once someone is waiting for it to be unpinned.
  */
-STATIC void
-__xfs_iunpin_wait(
-	xfs_inode_t	*ip,
-	int		wait)
+static void
+xfs_iunpin_nowait(
+	struct xfs_inode	*ip)
 {
-	xfs_inode_log_item_t	*iip = ip->i_itemp;
-
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
-	if (atomic_read(&ip->i_pincount) == 0)
-		return;
 
 	/* Give the log a push to start the unpinning I/O */
-	if (iip && iip->ili_last_lsn)
-		xfs_log_force_lsn(ip->i_mount, iip->ili_last_lsn, 0);
-	else
-		xfs_log_force(ip->i_mount, 0);
+	xfs_log_force_lsn(ip->i_mount, ip->i_itemp->ili_last_lsn, 0);
 
-	if (wait)
-		wait_event(ip->i_ipin_wait, (atomic_read(&ip->i_pincount) == 0));
 }
 
 void
 xfs_iunpin_wait(
-	xfs_inode_t	*ip)
+	struct xfs_inode	*ip)
 {
-	__xfs_iunpin_wait(ip, 1);
-}
-
-static inline void
-xfs_iunpin_nowait(
-	xfs_inode_t	*ip)
-{
-	__xfs_iunpin_wait(ip, 0);
+	if (xfs_ipincount(ip)) {
+		xfs_iunpin_nowait(ip);
+		wait_event(ip->i_ipin_wait, (xfs_ipincount(ip) == 0));
+	}
 }
 
-
 /*
  * xfs_iextents_copy()
  *

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
