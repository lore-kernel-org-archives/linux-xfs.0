Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 May 2008 03:06:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4GA6FK3009735
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 03:06:18 -0700
Date: Fri, 16 May 2008 20:06:57 +1000
From: David Chinner <dgc@sgi.com>
Subject: [PATCH] Fix inode list allocation size in writeback.
Message-ID: <20080516100657.GV103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

We only need to allocate space for the number of inodes in
the cluster when writing back inodes, not every byte in the
inode cluster. This reduces the amount of memory needing to
be allocated to 256 bytes instead of 64k.

Somebody pass me the brown paper bag, please.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_inode.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2008-05-16 19:43:55.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2008-05-16 19:47:47.778141722 +1000
@@ -2913,6 +2913,7 @@ xfs_iflush_cluster(
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_perag_t		*pag = xfs_get_perag(mp, ip->i_ino);
 	unsigned long		first_index, mask;
+	unsigned long		inodes_per_cluster;
 	int			ilist_size;
 	xfs_inode_t		**ilist;
 	xfs_inode_t		*iq;
@@ -2924,7 +2925,8 @@ xfs_iflush_cluster(
 	ASSERT(pag->pagi_inodeok);
 	ASSERT(pag->pag_ici_init);
 
-	ilist_size = XFS_INODE_CLUSTER_SIZE(mp) * sizeof(xfs_inode_t *);
+	inodes_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog;
+	ilist_size = inodes_per_cluster * sizeof(xfs_inode_t *);
 	ilist = kmem_alloc(ilist_size, KM_MAYFAIL|KM_NOFS);
 	if (!ilist)
 		return 0;
@@ -2934,8 +2936,7 @@ xfs_iflush_cluster(
 	read_lock(&pag->pag_ici_lock);
 	/* really need a gang lookup range call here */
 	nr_found = radix_tree_gang_lookup(&pag->pag_ici_root, (void**)ilist,
-					first_index,
-					XFS_INODE_CLUSTER_SIZE(mp));
+					first_index, inodes_per_cluster);
 	if (nr_found == 0)
 		goto out_free;
 
