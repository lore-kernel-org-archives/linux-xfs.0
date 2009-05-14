Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4EHFpur234936 for <xfs@oss.sgi.com>; Thu, 14 May 2009 12:15:53 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3ABF41D33B29
	for <xfs@oss.sgi.com>; Thu, 14 May 2009 10:15:58 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id NiUj9AtWO18a3qGv for
	<xfs@oss.sgi.com>; Thu, 14 May 2009 10:15:58 -0700 (PDT)
Message-Id: <20090514171558.494200000@bombadil.infradead.org>
Date: Thu, 14 May 2009 13:12:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/7] xfs: factor out inode validation for sync
References: <20090514171233.942489000@bombadil.infradead.org>
Content-Disposition: inline; filename=sync3.diff
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

Separate the validation of inodes found by the radix
tree walk from the radix tree lookup.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-05-14 16:19:52.080661336 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2009-05-14 16:20:34.251688779 +0200
@@ -49,6 +49,39 @@
 #include <linux/freezer.h>
 
 
+/* must be called with pag_ici_lock held and releases it */
+STATIC int
+xfs_sync_inode_valid(
+	struct xfs_inode	*ip,
+	struct xfs_perag	*pag)
+{
+	struct inode		*inode = VFS_I(ip);
+
+	/* nothing to sync during shutdown */
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+		read_unlock(&pag->pag_ici_lock);
+		return EFSCORRUPTED;
+	}
+
+	/*
+	 * If we can't get a reference on the inode, it must be in reclaim.
+	 * Leave it for the reclaim code to flush. Also avoid inodes that
+	 * haven't been fully initialised.
+	 */
+	if (!igrab(inode)) {
+		read_unlock(&pag->pag_ici_lock);
+		return ENOENT;
+	}
+	read_unlock(&pag->pag_ici_lock);
+
+	if (is_bad_inode(inode) || xfs_iflags_test(ip, XFS_INEW)) {
+		IRELE(ip);
+		return ENOENT;
+	}
+
+	return 0;
+}
+
 STATIC int
 xfs_sync_inode_data(
 	struct xfs_inode	*ip,
@@ -121,7 +154,6 @@ xfs_sync_inodes_ag(
 	int		last_error = 0;
 
 	do {
-		struct inode	*inode;
 		xfs_inode_t	*ip = NULL;
 
 		/*
@@ -150,27 +182,10 @@ xfs_sync_inodes_ag(
 			break;
 		}
 
-		/* nothing to sync during shutdown */
-		if (XFS_FORCED_SHUTDOWN(mp)) {
-			read_unlock(&pag->pag_ici_lock);
-			return 0;
-		}
-
-		/*
-		 * If we can't get a reference on the inode, it must be
-		 * in reclaim. Leave it for the reclaim code to flush.
-		 */
-		inode = VFS_I(ip);
-		if (!igrab(inode)) {
-			read_unlock(&pag->pag_ici_lock);
-			continue;
-		}
-		read_unlock(&pag->pag_ici_lock);
-
-		/* avoid new or bad inodes */
-		if (is_bad_inode(inode) ||
-		    xfs_iflags_test(ip, XFS_INEW)) {
-			IRELE(ip);
+		error = xfs_sync_inode_valid(ip, pag);
+		if (error) {
+			if (error == EFSCORRUPTED)
+				return 0;
 			continue;
 		}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
