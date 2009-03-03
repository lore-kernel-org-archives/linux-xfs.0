Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n23JnFNR031610 for <xfs@oss.sgi.com>; Tue, 3 Mar 2009 13:49:16 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0FC5A1C14534
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2009 11:48:48 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 31qQh3NhwdF6iC3L for
	<xfs@oss.sgi.com>; Tue, 03 Mar 2009 11:48:48 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Leabg-0003cw-NH
	for xfs@oss.sgi.com; Tue, 03 Mar 2009 19:48:48 +0000
Message-Id: <20090303194848.533949000@bombadil.infradead.org>
Date: Tue, 03 Mar 2009 14:48:35 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3] xfs: prevent lockdep false positive in xfs_iget_cache_miss
References: <20090303194834.264998000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-iget-fix-lockdep-false-positive
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

The inode can't be locked by anyone else as we just created it a few
lines above and it's not been added to any lookup data structure yet.

So use a trylock that must succeed to get around the lockdep warnings.


Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
Reviewed-by: Felix Blyakher <felixb@sgi.com>

Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2009-03-03 18:02:56.262853671 +0100
+++ xfs/fs/xfs/xfs_iget.c	2009-03-03 18:08:44.681880431 +0100
@@ -246,9 +246,6 @@ xfs_iget_cache_miss(
 		goto out_destroy;
 	}
 
-	if (lock_flags)
-		xfs_ilock(ip, lock_flags);
-
 	/*
 	 * Preload the radix tree so we can insert safely under the
 	 * write spinlock. Note that we cannot sleep inside the preload
@@ -256,7 +253,16 @@ xfs_iget_cache_miss(
 	 */
 	if (radix_tree_preload(GFP_KERNEL)) {
 		error = EAGAIN;
-		goto out_unlock;
+		goto out_destroy;
+	}
+
+	/*
+	 * Because the inode hasn't been added to the radix-tree yet it can't
+	 * be found by another thread, so we can do the non-sleeping lock here.
+	 */
+	if (lock_flags) {
+		if (!xfs_ilock_nowait(ip, lock_flags))
+			BUG();
 	}
 
 	mask = ~(((XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog)) - 1);
@@ -284,7 +290,6 @@ xfs_iget_cache_miss(
 out_preload_end:
 	write_unlock(&pag->pag_ici_lock);
 	radix_tree_preload_end();
-out_unlock:
 	if (lock_flags)
 		xfs_iunlock(ip, lock_flags);
 out_destroy:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
