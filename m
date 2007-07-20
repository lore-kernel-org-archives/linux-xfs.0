Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jul 2007 21:12:15 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6K4CAbm027829
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2007 21:12:11 -0700
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id B56871801056F
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2007 23:12:13 -0500 (CDT)
Message-ID: <46A0361D.3090103@sandeen.net>
Date: Thu, 19 Jul 2007 23:12:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 3/7] - pick single default inode cluster 
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Remove scaling of inode "clusters" based on machine memory;
small cluster cut-point was an unrealistic 32MB and was
probably never tested.

Removes another user of xfs_physmem.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux/fs/xfs/xfs_ialloc.h
===================================================================
--- linux.orig/fs/xfs/xfs_ialloc.h
+++ linux/fs/xfs/xfs_ialloc.h
@@ -30,14 +30,9 @@ struct xfs_trans;
 #define	XFS_IALLOC_BLOCKS(mp)	(mp)->m_ialloc_blks
 
 /*
- * For small block file systems, move inodes in clusters of this size.
- * When we don't have a lot of memory, however, we go a bit smaller
- * to reduce the number of AGI and ialloc btree blocks we need to keep
- * around for xfs_dilocate().  We choose which one to use in
- * xfs_mount_int().
+ * Move inodes in clusters of this size.
  */
 #define	XFS_INODE_BIG_CLUSTER_SIZE	8192
-#define	XFS_INODE_SMALL_CLUSTER_SIZE	4096
 #define	XFS_INODE_CLUSTER_SIZE(mp)	(mp)->m_inode_cluster_size
 
 /*
Index: linux/fs/xfs/xfs_mount.c
===================================================================
--- linux.orig/fs/xfs/xfs_mount.c
+++ linux/fs/xfs/xfs_mount.c
@@ -885,15 +885,12 @@ xfs_mountfs(
 	mp->m_writeio_blocks = 1 << (mp->m_writeio_log - sbp->sb_blocklog);
 
 	/*
-	 * Set the inode cluster size based on the physical memory
-	 * size.  This may still be overridden by the file system
+	 * Set the inode cluster size.
+	 * This may still be overridden by the file system
 	 * block size if it is larger than the chosen cluster size.
 	 */
-	if (xfs_physmem <= btoc(32 * 1024 * 1024)) { /* <= 32 MB */
-		mp->m_inode_cluster_size = XFS_INODE_SMALL_CLUSTER_SIZE;
-	} else {
-		mp->m_inode_cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
-	}
+	mp->m_inode_cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
+
 	/*
 	 * Set whether we're using inode alignment.
 	 */
