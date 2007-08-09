Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Aug 2007 04:42:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l79Bg6bm006452
	for <xfs@oss.sgi.com>; Thu, 9 Aug 2007 04:42:09 -0700
Date: Thu, 9 Aug 2007 21:42:04 +1000
From: David Chinner <dgc@sgi.com>
Subject: [PATCH 3 of 4] Convert xfs_icluster lists to use list.h
Message-ID: <20070809114204.GF12413810@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Convert the xfs_icluster inode list to use hlist constructs.
Use a hlist as we only need a single list head pointer and that
keeps the memory usage of these structures down.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_iget.c  |   61 +++++++++++++----------------------------------------
 fs/xfs/xfs_inode.c |    6 ++++-
 fs/xfs/xfs_inode.h |    5 +---
 fs/xfs/xfsidbg.c   |    4 +--
 4 files changed, 24 insertions(+), 52 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.h	2007-08-09 13:03:53.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.h	2007-08-09 18:14:29.650646277 +1000
@@ -178,7 +178,7 @@ extern void xfs_iocore_inode_reinit(stru
  * the same time.
  */
 typedef struct xfs_icluster {
-	struct xfs_inode	*icl_ip;
+	struct hlist_head	icl_inodes;	/* list of inodes on cluster */
 	xfs_daddr_t		icl_blkno;	/* starting block number of
 						 * the cluster */
 	struct xfs_buf		*icl_buf;	/* the inode buffer */
@@ -296,8 +296,7 @@ typedef struct xfs_inode {
 
 	xfs_icdinode_t		i_d;		/* most of ondisk inode */
 	xfs_icluster_t		*i_cluster;	/* cluster list header */
-	struct xfs_inode	*i_cnext;	/* cluster link forward */
-	struct xfs_inode	*i_cprev;	/* cluster link backward */
+	struct hlist_node	i_cnode;	/* cluster link node */
 
 	xfs_fsize_t		i_size;		/* in-memory size */
 	/* Trace buffers per inode. */
Index: 2.6.x-xfs-new/fs/xfs/xfs_iget.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_iget.c	2007-08-09 13:03:53.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_iget.c	2007-08-09 18:15:16.832572205 +1000
@@ -290,31 +290,21 @@ finish_inode:
 	ip->i_udquot = ip->i_gdquot = NULL;
 	xfs_iflags_set(ip, XFS_INEW);
 
-	ASSERT(ip->i_cluster == NULL && ip->i_cprev == NULL &&
-	       ip->i_cnext == NULL);
+	ASSERT(ip->i_cluster == NULL);
 
-	if (icl) {
-		/* insert this inode into the doubly-linked list
-		 * where icl points. lock the icl to protect against
-		 * others traversing the icl list */
-		spin_lock(&icl->icl_lock);
-		ASSERT(icl->icl_ip != NULL);
-		iq = icl->icl_ip;
-		ip->i_cprev = iq->i_cprev;
-		iq->i_cprev->i_cnext = ip;
-		iq->i_cprev = ip;
-		ip->i_cnext = iq;
-		icl->icl_ip = ip;
-		ip->i_cluster = icl;
-		spin_unlock(&icl->icl_lock);
-	} else {
-		ip->i_cnext = ip;
-		ip->i_cprev = ip;
-		ip->i_cluster = new_icl;
-		new_icl->icl_ip = ip;
+	if (!icl) {
 		spin_lock_init(&new_icl->icl_lock);
+		INIT_HLIST_HEAD(&new_icl->icl_inodes);
+		icl = new_icl;
 		new_icl = NULL;
+	} else {
+		ASSERT(!hlist_empty(&icl->icl_inodes));
 	}
+	spin_lock(&icl->icl_lock);
+	hlist_add_head(&ip->i_cnode, &icl->icl_inodes);
+	ip->i_cluster = icl;
+	spin_unlock(&icl->icl_lock);
+
 	write_unlock(&pag->pag_ici_lock);
 	radix_tree_preload_end();
 	if (new_icl)
@@ -579,33 +569,12 @@ xfs_iextract(
 	 */
 	mp = ip->i_mount;
 	spin_lock(&ip->i_cluster->icl_lock);
-	if (unlikely(ip->i_cnext == ip)) {
-		/*
-		 * Last inode in cluster object.
-		 *
-		 * We've been removed from the inode radix tree, and
-		 * we are the last inode to reference the cluster.
-		 * We can simply drop our loks and free it at this point
-		 * because nothing can find us or the cluster.
-		 */
-		ASSERT(ip->i_cnext == ip && ip->i_cprev == ip);
-		ASSERT(ip->i_cluster != NULL);
+	hlist_del(&ip->i_cnode);
+	spin_unlock(&ip->i_cluster->icl_lock);
 
-		spin_unlock(&ip->i_cluster->icl_lock);
+	/* was last inode in cluster? */
+	if (hlist_empty(&ip->i_cluster->icl_inodes))
 		kmem_zone_free(xfs_icluster_zone, ip->i_cluster);
-	} else {
-		/* delete one inode from a non-empty list */
-		iq = ip->i_cnext;
-		iq->i_cprev = ip->i_cprev;
-		ip->i_cprev->i_cnext = iq;
-		if (ip->i_cluster->icl_ip == ip) {
-			ip->i_cluster->icl_ip = iq;
-		}
-		spin_unlock(&ip->i_cluster->icl_lock);
-		ip->i_cluster = __return_address;
-		ip->i_cprev = __return_address;
-		ip->i_cnext = __return_address;
-	}
 
 	/*
 	 * Remove from mount's inode list.
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2007-08-09 13:03:53.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2007-08-09 18:11:14.059874991 +1000
@@ -3050,6 +3050,7 @@ xfs_iflush(
 	xfs_inode_t		*iq;
 	int			clcount;	/* count of inodes clustered */
 	int			bufwasdelwri;
+	struct hlist_node	*entry;
 	enum { INT_DELWRI = (1 << 0), INT_ASYNC = (1 << 1) };
 
 	XFS_STATS_INC(xs_iflush_count);
@@ -3168,7 +3169,10 @@ xfs_iflush(
 	ip->i_cluster->icl_buf = bp;
 
 	clcount = 0;
-	for (iq = ip->i_cnext; iq != ip; iq = iq->i_cnext) {
+	hlist_for_each_entry(iq, entry, &ip->i_cluster->icl_inodes, i_cnode) {
+		if (iq == ip)
+			continue;
+
 		/*
 		 * Do an un-protected check to see if the inode is dirty and
 		 * is a candidate for flushing.  These checks will be repeated
Index: 2.6.x-xfs-new/fs/xfs/xfsidbg.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfsidbg.c	2007-08-09 13:03:53.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfsidbg.c	2007-08-09 18:16:46.581017645 +1000
@@ -6755,8 +6755,8 @@ xfsidbg_xnode(xfs_inode_t *ip)
 	kdb_printf("\n");
 	kdb_printf("icluster 0x%p cnext 0x%p cprev 0x%p\n",
 		ip->i_cluster,
-		ip->i_cnext,
-		ip->i_cprev);
+		ip->i_cnode.next,
+		ip->i_cnode.pprev);
 	xfs_xnode_fork("data", &ip->i_df);
 	xfs_xnode_fork("attr", ip->i_afp);
 	kdb_printf("\n");
