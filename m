Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB1IBxsV155195 for <xfs@oss.sgi.com>; Tue, 1 Dec 2009 12:12:01 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 28D4F4C88F0
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2009 10:12:30 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Zrx8TQGmh03U1Xxy for
	<xfs@oss.sgi.com>; Tue, 01 Dec 2009 10:12:30 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NFXDB-0004JJ-O3
	for xfs@oss.sgi.com; Tue, 01 Dec 2009 18:12:29 +0000
Date: Tue, 1 Dec 2009 13:12:29 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH V2] xfs: check for not fully initialized inodes in xfs_ireclaim
Message-ID: <20091201181229.GA11982@infradead.org>
References: <20091112190657.GA32110@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091112190657.GA32110@infradead.org>
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

Add an assert for inodes not added to the inode cache in xfs_ireclaim, to make
sure we're not going to introduce something like the famous nfsd inode cache
bug again.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2009-11-26 19:10:47.206253628 +0100
+++ xfs/fs/xfs/xfs_iget.c	2009-12-01 19:09:43.310004091 +0100
@@ -514,17 +514,21 @@ xfs_ireclaim(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 
 	XFS_STATS_INC(xs_ig_reclaims);
 
 	/*
-	 * Remove the inode from the per-AG radix tree.  It doesn't matter
-	 * if it was never added to it because radix_tree_delete can deal
-	 * with that case just fine.
+	 * Remove the inode from the per-AG radix tree.
+	 *
+	 * Because radix_tree_delete won't complain even if the item was never
+	 * added to the tree assert that it's been there before to catch
+	 * problems with the inode life time early on.
 	 */
 	pag = xfs_get_perag(mp, ip->i_ino);
 	write_lock(&pag->pag_ici_lock);
-	radix_tree_delete(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino));
+	if (!radix_tree_delete(&pag->pag_ici_root, agino))
+		ASSERT(0);
 	write_unlock(&pag->pag_ici_lock);
 	xfs_put_perag(mp, pag);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
