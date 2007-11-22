Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Nov 2007 16:41:36 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAM0fSxN013840
	for <xfs@oss.sgi.com>; Wed, 21 Nov 2007 16:41:29 -0800
Date: Thu, 22 Nov 2007 11:41:32 +1100
From: David Chinner <dgc@sgi.com>
Subject: [PATCH 7/9] Use radix_tree_gang_lookup_range for cluster lookups
Message-ID: <20071122004132.GM114266761@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>

Use radix_tree_gang_lookup_range() for inode cluster lookups

Now that we have an efficent lookup method for the radix tree,
convert cluster lookups to use it. Factor out the common
lookup, add some debug checking to it and call it where needed.

For sanity, we need to hold the radix tree lock in read
mode across the entire set of locking operations done to
ensure we can operate on the inodes. This does increase
the length of time we hold the lock in read mode, but we'll
correct that with another patch.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_inode.c |   83 +++++++++++++++++++++++++++++++++++------------------
 1 file changed, 56 insertions(+), 27 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2007-11-22 10:33:53.993326524 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2007-11-22 10:33:55.877085717 +1100
@@ -2165,6 +2165,37 @@ STATIC_INLINE int xfs_inode_clean(xfs_in
 		(ip->i_update_core == 0));
 }
 
+/* lookup all the inodes in the cluster */
+STATIC int
+xfs_icluster_lookup(
+	xfs_mount_t	*mp,
+	xfs_perag_t	*pag,
+	xfs_ino_t	ino,
+	xfs_inode_t	**ilist,
+	int		clsize)
+{
+	unsigned long		first_index, last_index, mask;
+	int			nr_found;
+
+	mask = ~(clsize - 1);
+	first_index = XFS_INO_TO_AGINO(mp, ino) & mask;
+	last_index = (XFS_INO_TO_AGINO(mp, ino + clsize) & mask) - 1;
+	nr_found = radix_tree_gang_lookup_range(&pag->pag_ici_root,
+				(void**)ilist, first_index, last_index,
+				clsize);
+	ASSERT(nr_found <= clsize);
+#ifdef DEBUG
+{	int		i;
+	xfs_inode_t	*iq;
+	for (i = 0; i < nr_found; i++) {
+		iq = ilist[i];
+		ASSERT((XFS_INO_TO_AGINO(mp, iq->i_ino) & mask) == first_index);
+	}
+}
+#endif
+	return nr_found;
+}
+
 STATIC void
 xfs_ifree_cluster(
 	xfs_inode_t	*free_ip,
@@ -2178,7 +2209,7 @@ xfs_ifree_cluster(
 	int			i, j, found, pre_flushed;
 	xfs_daddr_t		blkno;
 	xfs_buf_t		*bp;
-	xfs_inode_t		*ip, **ip_found;
+	xfs_inode_t		*ip, **ip_found, **ilist;
 	xfs_inode_log_item_t	*iip;
 	xfs_log_item_t		*lip;
 	xfs_perag_t		*pag = xfs_get_perag(mp, inum);
@@ -2195,8 +2226,10 @@ xfs_ifree_cluster(
 	}
 
 	ip_found = kmem_alloc(ninodes * sizeof(xfs_inode_t *), KM_NOFS);
+	ilist = kmem_alloc(ninodes * sizeof(xfs_inode_t *), KM_NOFS);
 
 	for (j = 0; j < nbufs; j++, inum += ninodes) {
+		int nr_found;
 		blkno = XFS_AGB_TO_DADDR(mp, XFS_INO_TO_AGNO(mp, inum),
 					 XFS_INO_TO_AGBNO(mp, inum));
 
@@ -2213,24 +2246,23 @@ xfs_ifree_cluster(
 		 * and fail, we need some other form of interlock
 		 * here.
 		 */
+		read_lock(&pag->pag_ici_lock);
+		nr_found = xfs_icluster_lookup(mp, pag, inum, ilist, ninodes);
+		if (nr_found == 0) {
+			read_unlock(&pag->pag_ici_lock);
+			continue;
+		}
 		found = 0;
-		for (i = 0; i < ninodes; i++) {
-			read_lock(&pag->pag_ici_lock);
-			ip = radix_tree_lookup(&pag->pag_ici_root,
-					XFS_INO_TO_AGINO(mp, (inum + i)));
+		for (i = 0; i < nr_found; i++) {
+			ip = ilist[i];
 
 			/* Inode not in memory or we found it already,
 			 * nothing to do
 			 */
-			if (!ip || xfs_iflags_test(ip, XFS_ISTALE)) {
-				read_unlock(&pag->pag_ici_lock);
+			if (!ip || xfs_iflags_test(ip, XFS_ISTALE))
 				continue;
-			}
-
-			if (xfs_inode_clean(ip)) {
-				read_unlock(&pag->pag_ici_lock);
+			if (xfs_inode_clean(ip))
 				continue;
-			}
 
 			/* If we can get the locks then add it to the
 			 * list, otherwise by the time we get the bp lock
@@ -2251,7 +2283,6 @@ xfs_ifree_cluster(
 						ip_found[found++] = ip;
 					}
 				}
-				read_unlock(&pag->pag_ici_lock);
 				continue;
 			}
 
@@ -2269,8 +2300,8 @@ xfs_ifree_cluster(
 					xfs_iunlock(ip, XFS_ILOCK_EXCL);
 				}
 			}
-			read_unlock(&pag->pag_ici_lock);
 		}
+		read_unlock(&pag->pag_ici_lock);
 
 		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, blkno, 
 					mp->m_bsize * blks_per_cluster,
@@ -2324,6 +2355,7 @@ xfs_ifree_cluster(
 	}
 
 	kmem_free(ip_found, ninodes * sizeof(xfs_inode_t *));
+	kmem_free(ilist, ninodes * sizeof(xfs_inode_t *));
 	xfs_put_perag(mp, pag);
 }
 
@@ -3013,6 +3045,7 @@ xfs_iflush_fork(
 	return 0;
 }
 
+
 STATIC int
 xfs_iflush_cluster(
 	xfs_inode_t	*ip,
@@ -3020,39 +3053,35 @@ xfs_iflush_cluster(
 {
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_perag_t		*pag = xfs_get_perag(mp, ip->i_ino);
-	unsigned long		first_index, mask;
+	unsigned long		inodes_per_cluster;
 	int			ilist_size;
-	xfs_inode_t		*ilist;
+	xfs_inode_t		**ilist;
 	xfs_inode_t		*iq;
 	xfs_inode_log_item_t	*iip;
 	int			nr_found;
 	int			clcount = 0;
 	int			bufwasdelwri;
+	int			i;
 
 	ASSERT(pag->pagi_inodeok);
 	ASSERT(pag->pag_ici_init);
 
-	ilist_size = XFS_INODE_CLUSTER_SIZE(mp) * sizeof(xfs_inode_t *);
+	inodes_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog;
+	ilist_size = inodes_per_cluster * sizeof(xfs_inode_t *);
 	ilist = kmem_alloc(ilist_size, KM_MAYFAIL);
 	if (!ilist)
 		return 0;
 
-	mask = ~(((XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog)) - 1);
-	first_index = XFS_INO_TO_AGINO(mp, ip->i_ino) & mask;
 	read_lock(&pag->pag_ici_lock);
-	/* really need a gang lookup range call here */
-	nr_found = radix_tree_gang_lookup(&pag->pag_ici_root, (void**)&ilist,
-					first_index,
-					XFS_INODE_CLUSTER_SIZE(mp));
+	nr_found = xfs_icluster_lookup(mp, pag, ip->i_ino, ilist,
+							inodes_per_cluster);
 	if (nr_found == 0)
 		goto out_free;
 
-	for (iq = &ilist[0]; iq < &ilist[nr_found]; iq++) {
+	for (i = 0; i < nr_found; i++) {
+		iq = ilist[i];
 		if (iq == ip)
 			continue;
-		/* if the inode lies outside this cluster, we're done. */
-		if ((XFS_INO_TO_AGINO(mp, iq->i_ino) & mask) != first_index)
-			break;
 		/*
 		 * Do an un-protected check to see if the inode is dirty and
 		 * is a candidate for flushing.  These checks will be repeated
