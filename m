Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4EHFprG234942 for <xfs@oss.sgi.com>; Thu, 14 May 2009 12:15:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 14878FAECAF
	for <xfs@oss.sgi.com>; Thu, 14 May 2009 10:20:45 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id tgShC5sqEJzlJv1Y for
	<xfs@oss.sgi.com>; Thu, 14 May 2009 10:20:45 -0700 (PDT)
Message-Id: <20090514171558.014747000@bombadil.infradead.org>
Date: Thu, 14 May 2009 13:12:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/7] xfs: split inode data writeback from xfs_sync_inodes_ag
References: <20090514171233.942489000@bombadil.infradead.org>
Content-Disposition: inline; filename=sync1.diff
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

From: Dave Chinner <david@fromorbit.com>

In many cases we only want to sync inode data. Start spliting the inode sync
into data sync and inode sync by factoring out the inode data flush.

[hch: minor cleanups]

Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-05-12 23:28:45.023811837 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2009-05-13 10:00:27.169659271 +0200
@@ -48,6 +48,34 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 
+
+STATIC int
+xfs_sync_inode_data(
+	struct xfs_inode	*ip,
+	int			flags)
+{
+	struct inode	*inode = VFS_I(ip);
+	struct address_space *mapping = inode->i_mapping;
+	int		error = 0;
+
+	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
+		if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED)) {
+			if (flags & SYNC_TRYLOCK)
+				goto out_wait;
+			xfs_ilock(ip, XFS_IOLOCK_SHARED);
+		}
+
+		error = xfs_flush_pages(ip, 0, -1, (flags & SYNC_WAIT) ?
+					0 : XFS_B_ASYNC, FI_NONE);
+		xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+	}
+
+ out_wait:
+	if (flags & SYNC_IOWAIT)
+		xfs_ioend_wait(ip);
+	return error;
+}
+
 /*
  * Sync all the inodes in the given AG according to the
  * direction given by the flags.
@@ -123,27 +151,10 @@ xfs_sync_inodes_ag(
 		 * If we have to flush data or wait for I/O completion
 		 * we need to hold the iolock.
 		 */
-		if (flags & SYNC_DELWRI) {
-			if (VN_DIRTY(inode)) {
-				if (flags & SYNC_TRYLOCK) {
-					if (xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
-						lock_flags |= XFS_IOLOCK_SHARED;
-				} else {
-					xfs_ilock(ip, XFS_IOLOCK_SHARED);
-					lock_flags |= XFS_IOLOCK_SHARED;
-				}
-				if (lock_flags & XFS_IOLOCK_SHARED) {
-					error = xfs_flush_pages(ip, 0, -1,
-							(flags & SYNC_WAIT) ? 0
-								: XFS_B_ASYNC,
-							FI_NONE);
-				}
-			}
-			if (VN_CACHED(inode) && (flags & SYNC_IOWAIT))
-				xfs_ioend_wait(ip);
-		}
-		xfs_ilock(ip, XFS_ILOCK_SHARED);
+		if (flags & SYNC_DELWRI)
+			error = xfs_sync_inode_data(ip, flags);
 
+		xfs_ilock(ip, XFS_ILOCK_SHARED);
 		if ((flags & SYNC_ATTR) && !xfs_inode_clean(ip)) {
 			if (flags & SYNC_WAIT) {
 				xfs_iflock(ip);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
