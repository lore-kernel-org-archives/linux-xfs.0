Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 21:06:15 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0L55qO4013858
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 21:05:55 -0800
Date: Mon, 21 Jan 2008 16:06:03 +1100
From: David Chinner <dgc@sgi.com>
Subject: [patch] remove xfs_icluster
Message-ID: <20080121050603.GE155259@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Remove the xfs_icluster structure and replace with a radix tree lookup.

We don't need to keep a list of inodes in each cluster around anymore
as we can look them up quickly when we need to. The only time we need
to do this now is during inode writeback.

Factor the inode cluster writeback code out of xfs_iflush and convert
it to use radix_tree_gang_lookup() instead of walking a list of
inodes built when we first read in the inodes.

This remove 3 pointers from each xfs_inode structure and the xfs_icluster
structure per inode cluster. Hence we reduce the cache footprint of the
xfs_inodes by between 5-10% depending on cluster sparseness.

To be truly efficient we need a radix_tree_gang_lookup_range() call
to stop searching once we are past the end of the cluster instead
of trying to find a full cluster's worth of inodes.

Before (ia64):

$ cat /sys/slab/xfs_inode/object_size
536

After:

$ cat /sys/slab/xfs_inode/object_size
512

Version 2:
- rebase on current patch series

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/linux-2.6/xfs_ksyms.c |    1 
 fs/xfs/xfs_iget.c            |   49 -------
 fs/xfs/xfs_inode.c           |  266 ++++++++++++++++++++++++-------------------
 fs/xfs/xfs_inode.h           |   16 --
 fs/xfs/xfs_vfsops.c          |    5 
 fs/xfs/xfsidbg.c             |    4 
 6 files changed, 154 insertions(+), 187 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_iget.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_iget.c	2008-01-21 15:19:50.210423275 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_iget.c	2008-01-21 15:59:58.916853279 +1100
@@ -78,7 +78,6 @@ xfs_iget_core(
 	xfs_inode_t	*ip;
 	xfs_inode_t	*iq;
 	int		error;
-	xfs_icluster_t	*icl, *new_icl = NULL;
 	unsigned long	first_index, mask;
 	xfs_perag_t	*pag;
 	xfs_agino_t	agino;
@@ -229,11 +228,9 @@ finish_inode:
 	}
 
 	/*
-	 * This is a bit messy - we preallocate everything we _might_
-	 * need before we pick up the ici lock. That way we don't have to
-	 * juggle locks and go all the way back to the start.
+	 * Preload the radix tree so we can insert safely under the
+	 * write spinlock.
 	 */
-	new_icl = kmem_zone_alloc(xfs_icluster_zone, KM_SLEEP);
 	if (radix_tree_preload(GFP_KERNEL)) {
 		delay(1);
 		goto again;
@@ -241,17 +238,6 @@ finish_inode:
 	mask = ~(((XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog)) - 1);
 	first_index = agino & mask;
 	write_lock(&pag->pag_ici_lock);
-
-	/*
-	 * Find the cluster if it exists
-	 */
-	icl = NULL;
-	if (radix_tree_gang_lookup(&pag->pag_ici_root, (void**)&iq,
-							first_index, 1)) {
-		if ((XFS_INO_TO_AGINO(mp, iq->i_ino) & mask) == first_index)
-			icl = iq->i_cluster;
-	}
-
 	/*
 	 * insert the new inode
 	 */
@@ -266,30 +252,13 @@ finish_inode:
 	}
 
 	/*
-	 * These values _must_ be set before releasing ihlock!
+	 * These values _must_ be set before releasing the radix tree lock!
 	 */
 	ip->i_udquot = ip->i_gdquot = NULL;
 	xfs_iflags_set(ip, XFS_INEW);
 
-	ASSERT(ip->i_cluster == NULL);
-
-	if (!icl) {
-		spin_lock_init(&new_icl->icl_lock);
-		INIT_HLIST_HEAD(&new_icl->icl_inodes);
-		icl = new_icl;
-		new_icl = NULL;
-	} else {
-		ASSERT(!hlist_empty(&icl->icl_inodes));
-	}
-	spin_lock(&icl->icl_lock);
-	hlist_add_head(&ip->i_cnode, &icl->icl_inodes);
-	ip->i_cluster = icl;
-	spin_unlock(&icl->icl_lock);
-
 	write_unlock(&pag->pag_ici_lock);
 	radix_tree_preload_end();
-	if (new_icl)
-		kmem_zone_free(xfs_icluster_zone, new_icl);
 
 	/*
 	 * Link ip to its mount and thread it on the mount's inode list.
@@ -528,18 +497,6 @@ xfs_iextract(
 	xfs_put_perag(mp, pag);
 
 	/*
-	 * Remove from cluster list
-	 */
-	mp = ip->i_mount;
-	spin_lock(&ip->i_cluster->icl_lock);
-	hlist_del(&ip->i_cnode);
-	spin_unlock(&ip->i_cluster->icl_lock);
-
-	/* was last inode in cluster? */
-	if (hlist_empty(&ip->i_cluster->icl_inodes))
-		kmem_zone_free(xfs_icluster_zone, ip->i_cluster);
-
-	/*
 	 * Remove from mount's inode list.
 	 */
 	XFS_MOUNT_ILOCK(mp);
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2008-01-21 15:44:22.397197239 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2008-01-21 15:59:58.920852765 +1100
@@ -55,7 +55,6 @@
 
 kmem_zone_t *xfs_ifork_zone;
 kmem_zone_t *xfs_inode_zone;
-kmem_zone_t *xfs_icluster_zone;
 
 /*
  * Used in xfs_itruncate().  This is the maximum number of extents
@@ -2994,6 +2993,151 @@ xfs_iflush_fork(
 	return 0;
 }
 
+STATIC int
+xfs_iflush_cluster(
+	xfs_inode_t	*ip,
+	xfs_buf_t	*bp)
+{
+	xfs_mount_t		*mp = ip->i_mount;
+	xfs_perag_t		*pag = xfs_get_perag(mp, ip->i_ino);
+	unsigned long		first_index, mask;
+	int			ilist_size;
+	xfs_inode_t		*ilist;
+	xfs_inode_t		*iq;
+	xfs_inode_log_item_t	*iip;
+	int			nr_found;
+	int			clcount = 0;
+	int			bufwasdelwri;
+
+	ASSERT(pag->pagi_inodeok);
+	ASSERT(pag->pag_ici_init);
+
+	ilist_size = XFS_INODE_CLUSTER_SIZE(mp) * sizeof(xfs_inode_t *);
+	ilist = kmem_alloc(ilist_size, KM_MAYFAIL);
+	if (!ilist)
+		return 0;
+
+	mask = ~(((XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog)) - 1);
+	first_index = XFS_INO_TO_AGINO(mp, ip->i_ino) & mask;
+	read_lock(&pag->pag_ici_lock);
+	/* really need a gang lookup range call here */
+	nr_found = radix_tree_gang_lookup(&pag->pag_ici_root, (void**)&ilist,
+					first_index,
+					XFS_INODE_CLUSTER_SIZE(mp));
+	if (nr_found == 0)
+		goto out_free;
+
+	for (iq = &ilist[0]; iq < &ilist[nr_found]; iq++) {
+		if (iq == ip)
+			continue;
+		/* if the inode lies outside this cluster, we're done. */
+		if ((XFS_INO_TO_AGINO(mp, iq->i_ino) & mask) != first_index)
+			break;
+		/*
+		 * Do an un-protected check to see if the inode is dirty and
+		 * is a candidate for flushing.  These checks will be repeated
+		 * later after the appropriate locks are acquired.
+		 */
+		iip = iq->i_itemp;
+		if ((iq->i_update_core == 0) &&
+		    ((iip == NULL) ||
+		     !(iip->ili_format.ilf_fields & XFS_ILOG_ALL)) &&
+		      xfs_ipincount(iq) == 0) {
+			continue;
+		}
+
+		/*
+		 * Try to get locks.  If any are unavailable or it is pinned,
+		 * then this inode cannot be flushed and is skipped.
+		 */
+
+		if (!xfs_ilock_nowait(iq, XFS_ILOCK_SHARED))
+			continue;
+		if (!xfs_iflock_nowait(iq)) {
+			xfs_iunlock(iq, XFS_ILOCK_SHARED);
+			continue;
+		}
+		if (xfs_ipincount(iq)) {
+			xfs_ifunlock(iq);
+			xfs_iunlock(iq, XFS_ILOCK_SHARED);
+			continue;
+		}
+
+		/*
+		 * arriving here means that this inode can be flushed.  First
+		 * re-check that it's dirty before flushing.
+		 */
+		iip = iq->i_itemp;
+		if ((iq->i_update_core != 0) || ((iip != NULL) &&
+		     (iip->ili_format.ilf_fields & XFS_ILOG_ALL))) {
+			int error;
+			error = xfs_iflush_int(iq, bp);
+			if (error) {
+				xfs_iunlock(iq, XFS_ILOCK_SHARED);
+				goto cluster_corrupt_out;
+			}
+			clcount++;
+		} else {
+			xfs_ifunlock(iq);
+		}
+		xfs_iunlock(iq, XFS_ILOCK_SHARED);
+	}
+
+	if (clcount) {
+		XFS_STATS_INC(xs_icluster_flushcnt);
+		XFS_STATS_ADD(xs_icluster_flushinode, clcount);
+	}
+
+out_free:
+	read_unlock(&pag->pag_ici_lock);
+	kmem_free(ilist, ilist_size);
+	return 0;
+
+
+cluster_corrupt_out:
+	/*
+	 * Corruption detected in the clustering loop.  Invalidate the
+	 * inode buffer and shut down the filesystem.
+	 */
+	read_unlock(&pag->pag_ici_lock);
+	/*
+	 * Clean up the buffer.  If it was B_DELWRI, just release it --
+	 * brelse can handle it with no problems.  If not, shut down the
+	 * filesystem before releasing the buffer.
+	 */
+	bufwasdelwri = XFS_BUF_ISDELAYWRITE(bp);
+	if (bufwasdelwri)
+		xfs_buf_relse(bp);
+
+	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+
+	if (!bufwasdelwri) {
+		/*
+		 * Just like incore_relse: if we have b_iodone functions,
+		 * mark the buffer as an error and call them.  Otherwise
+		 * mark it as stale and brelse.
+		 */
+		if (XFS_BUF_IODONE_FUNC(bp)) {
+			XFS_BUF_CLR_BDSTRAT_FUNC(bp);
+			XFS_BUF_UNDONE(bp);
+			XFS_BUF_STALE(bp);
+			XFS_BUF_SHUT(bp);
+			XFS_BUF_ERROR(bp,EIO);
+			xfs_biodone(bp);
+		} else {
+			XFS_BUF_STALE(bp);
+			xfs_buf_relse(bp);
+		}
+	}
+
+	/*
+	 * Unlocks the flush lock
+	 */
+	xfs_iflush_abort(iq);
+	kmem_free(ilist, ilist_size);
+	return XFS_ERROR(EFSCORRUPTED);
+}
+
 /*
  * xfs_iflush() will write a modified inode's changes out to the
  * inode's on disk home.  The caller must have the inode lock held
@@ -3013,13 +3157,8 @@ xfs_iflush(
 	xfs_dinode_t		*dip;
 	xfs_mount_t		*mp;
 	int			error;
-	/* REFERENCED */
-	xfs_inode_t		*iq;
-	int			clcount;	/* count of inodes clustered */
-	int			bufwasdelwri;
-	struct hlist_node	*entry;
-	enum { INT_DELWRI = (1 << 0), INT_ASYNC = (1 << 1) };
 	int			noblock = (flags == XFS_IFLUSH_ASYNC_NOBLOCK);
+	enum { INT_DELWRI = (1 << 0), INT_ASYNC = (1 << 1) };
 
 	XFS_STATS_INC(xs_iflush_count);
 
@@ -3138,9 +3277,8 @@ xfs_iflush(
 	 * First flush out the inode that xfs_iflush was called with.
 	 */
 	error = xfs_iflush_int(ip, bp);
-	if (error) {
+	if (error)
 		goto corrupt_out;
-	}
 
 	/*
 	 * If the buffer is pinned then push on the log now so we won't
@@ -3153,70 +3291,9 @@ xfs_iflush(
 	 * inode clustering:
 	 * see if other inodes can be gathered into this write
 	 */
-	spin_lock(&ip->i_cluster->icl_lock);
-	ip->i_cluster->icl_buf = bp;
-
-	clcount = 0;
-	hlist_for_each_entry(iq, entry, &ip->i_cluster->icl_inodes, i_cnode) {
-		if (iq == ip)
-			continue;
-
-		/*
-		 * Do an un-protected check to see if the inode is dirty and
-		 * is a candidate for flushing.  These checks will be repeated
-		 * later after the appropriate locks are acquired.
-		 */
-		iip = iq->i_itemp;
-		if ((iq->i_update_core == 0) &&
-		    ((iip == NULL) ||
-		     !(iip->ili_format.ilf_fields & XFS_ILOG_ALL)) &&
-		      xfs_ipincount(iq) == 0) {
-			continue;
-		}
-
-		/*
-		 * Try to get locks.  If any are unavailable,
-		 * then this inode cannot be flushed and is skipped.
-		 */
-
-		/* get inode locks (just i_lock) */
-		if (xfs_ilock_nowait(iq, XFS_ILOCK_SHARED)) {
-			/* get inode flush lock */
-			if (xfs_iflock_nowait(iq)) {
-				/* check if pinned */
-				if (xfs_ipincount(iq) == 0) {
-					/* arriving here means that
-					 * this inode can be flushed.
-					 * first re-check that it's
-					 * dirty
-					 */
-					iip = iq->i_itemp;
-					if ((iq->i_update_core != 0)||
-					    ((iip != NULL) &&
-					     (iip->ili_format.ilf_fields & XFS_ILOG_ALL))) {
-						clcount++;
-						error = xfs_iflush_int(iq, bp);
-						if (error) {
-							xfs_iunlock(iq,
-								    XFS_ILOCK_SHARED);
-							goto cluster_corrupt_out;
-						}
-					} else {
-						xfs_ifunlock(iq);
-					}
-				} else {
-					xfs_ifunlock(iq);
-				}
-			}
-			xfs_iunlock(iq, XFS_ILOCK_SHARED);
-		}
-	}
-	spin_unlock(&ip->i_cluster->icl_lock);
-
-	if (clcount) {
-		XFS_STATS_INC(xs_icluster_flushcnt);
-		XFS_STATS_ADD(xs_icluster_flushinode, clcount);
-	}
+	error = xfs_iflush_cluster(ip, bp);
+	if (error)
+		goto cluster_corrupt_out;
 
 	if (flags & INT_DELWRI) {
 		xfs_bdwrite(mp, bp);
@@ -3230,52 +3307,11 @@ xfs_iflush(
 corrupt_out:
 	xfs_buf_relse(bp);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-	xfs_iflush_abort(ip);
-	/*
-	 * Unlocks the flush lock
-	 */
-	return XFS_ERROR(EFSCORRUPTED);
-
 cluster_corrupt_out:
-	/* Corruption detected in the clustering loop.  Invalidate the
-	 * inode buffer and shut down the filesystem.
-	 */
-	spin_unlock(&ip->i_cluster->icl_lock);
-
-	/*
-	 * Clean up the buffer.  If it was B_DELWRI, just release it --
-	 * brelse can handle it with no problems.  If not, shut down the
-	 * filesystem before releasing the buffer.
-	 */
-	if ((bufwasdelwri= XFS_BUF_ISDELAYWRITE(bp))) {
-		xfs_buf_relse(bp);
-	}
-
-	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-
-	if(!bufwasdelwri)  {
-		/*
-		 * Just like incore_relse: if we have b_iodone functions,
-		 * mark the buffer as an error and call them.  Otherwise
-		 * mark it as stale and brelse.
-		 */
-		if (XFS_BUF_IODONE_FUNC(bp)) {
-			XFS_BUF_CLR_BDSTRAT_FUNC(bp);
-			XFS_BUF_UNDONE(bp);
-			XFS_BUF_STALE(bp);
-			XFS_BUF_SHUT(bp);
-			XFS_BUF_ERROR(bp,EIO);
-			xfs_biodone(bp);
-		} else {
-			XFS_BUF_STALE(bp);
-			xfs_buf_relse(bp);
-		}
-	}
-
-	xfs_iflush_abort(iq);
 	/*
 	 * Unlocks the flush lock
 	 */
+	xfs_iflush_abort(ip);
 	return XFS_ERROR(EFSCORRUPTED);
 }
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.h	2008-01-21 15:44:33.275799218 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.h	2008-01-21 15:59:58.924852251 +1100
@@ -133,19 +133,6 @@ typedef struct dm_attrs_s {
 } dm_attrs_t;
 
 /*
- * This is the xfs inode cluster structure.  This structure is used by
- * xfs_iflush to find inodes that share a cluster and can be flushed to disk at
- * the same time.
- */
-typedef struct xfs_icluster {
-	struct hlist_head	icl_inodes;	/* list of inodes on cluster */
-	xfs_daddr_t		icl_blkno;	/* starting block number of
-						 * the cluster */
-	struct xfs_buf		*icl_buf;	/* the inode buffer */
-	spinlock_t		icl_lock;	/* inode list lock */
-} xfs_icluster_t;
-
-/*
  * This is the xfs in-core inode structure.
  * Most of the on-disk inode is embedded in the i_d field.
  *
@@ -252,8 +239,6 @@ typedef struct xfs_inode {
 	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
 
 	xfs_icdinode_t		i_d;		/* most of ondisk inode */
-	xfs_icluster_t		*i_cluster;	/* cluster list header */
-	struct hlist_node	i_cnode;	/* cluster link node */
 
 	xfs_fsize_t		i_size;		/* in-memory size */
 	xfs_fsize_t		i_new_size;	/* size when write completes */
@@ -598,7 +583,6 @@ void		xfs_inobp_check(struct xfs_mount *
 #define	xfs_inobp_check(mp, bp)
 #endif /* DEBUG */
 
-extern struct kmem_zone	*xfs_icluster_zone;
 extern struct kmem_zone	*xfs_ifork_zone;
 extern struct kmem_zone	*xfs_inode_zone;
 extern struct kmem_zone	*xfs_ili_zone;
Index: 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.c	2008-01-21 15:19:50.210423275 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c	2008-01-21 15:59:58.928851738 +1100
@@ -113,9 +113,6 @@ xfs_init(void)
 	xfs_ili_zone =
 		kmem_zone_init_flags(sizeof(xfs_inode_log_item_t), "xfs_ili",
 					KM_ZONE_SPREAD, NULL);
-	xfs_icluster_zone =
-		kmem_zone_init_flags(sizeof(xfs_icluster_t), "xfs_icluster",
-					KM_ZONE_SPREAD, NULL);
 
 	/*
 	 * Allocate global trace buffers.
@@ -153,7 +150,6 @@ xfs_cleanup(void)
 	extern kmem_zone_t	*xfs_inode_zone;
 	extern kmem_zone_t	*xfs_efd_zone;
 	extern kmem_zone_t	*xfs_efi_zone;
-	extern kmem_zone_t	*xfs_icluster_zone;
 
 	xfs_cleanup_procfs();
 	xfs_sysctl_unregister();
@@ -189,7 +185,6 @@ xfs_cleanup(void)
 	kmem_zone_destroy(xfs_efi_zone);
 	kmem_zone_destroy(xfs_ifork_zone);
 	kmem_zone_destroy(xfs_ili_zone);
-	kmem_zone_destroy(xfs_icluster_zone);
 }
 
 /*
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2008-01-21 15:19:50.226421221 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_ksyms.c	2008-01-21 15:59:58.928851738 +1100
@@ -211,7 +211,6 @@ EXPORT_SYMBOL(xfs_bulkstat);
 EXPORT_SYMBOL(xfs_bunmapi);
 EXPORT_SYMBOL(xfs_bwrite);
 EXPORT_SYMBOL(xfs_change_file_space);
-EXPORT_SYMBOL(xfs_icluster_zone);
 EXPORT_SYMBOL(xfs_dev_is_read_only);
 EXPORT_SYMBOL(xfs_dir_ialloc);
 EXPORT_SYMBOL(xfs_error_report);
Index: 2.6.x-xfs-new/fs/xfs/xfsidbg.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfsidbg.c	2008-01-21 15:19:50.226421221 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfsidbg.c	2008-01-21 15:59:58.944849682 +1100
@@ -6465,10 +6465,6 @@ xfsidbg_xnode(xfs_inode_t *ip)
 	qprintf(" dir trace 0x%p\n", ip->i_dir_trace);
 #endif  
 	kdb_printf("\n");
-	kdb_printf("icluster 0x%p cnext 0x%p cprev 0x%p\n",
-		ip->i_cluster,
-		ip->i_cnode.next,
-		ip->i_cnode.pprev);
 	xfs_xnode_fork("data", &ip->i_df);
 	xfs_xnode_fork("attr", ip->i_afp);
 	kdb_printf("\n");
