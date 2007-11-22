Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Nov 2007 16:43:02 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAM0gqkb014381
	for <xfs@oss.sgi.com>; Wed, 21 Nov 2007 16:42:55 -0800
Date: Thu, 22 Nov 2007 11:42:58 +1100
From: David Chinner <dgc@sgi.com>
Subject: [PATCH 8/9] Convert inode cache locking to RCU
Message-ID: <20071122004257.GN114266761@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>

Use RCU locking on the inode radix trees

To make use of the efficient radix tree gang lookups for
inode cluster operations we had to increase the time we hold
the radix tree read lock for. This will affect performance
somewhat.

Given that all the lookups are done on a radix tree and we
already have mechanisms to determine if an inode is valid
or not during lookup, we can pretty easily move this across
to lockless lookups using RCU.

The wrinkle is that the current read lock is used to synchronise
inode reclaim and lookup. Luckily, we have the inode flags lock
which is used in the same places as we need for this synchronisation
and hence the code can be easily changed to use this lock for
reclaim/lookup synchronisation.

Also, we can avoid growing the xfs_inode structure to place the
rcuhead structure for the rcu_call() on inode destruction by
reusing the reclaim list listhead structure. We can safely do
this because the inode has been removed from the reclaim list
before the reclaim code calls xfs_idestroy(). This is effectively
the same trick as used in the dentry cache to avoid growing the
dentry structure.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_ag.h       |    2 
 fs/xfs/xfs_iget.c     |  107 ++++++++++++++++++++++++++++++--------------------
 fs/xfs/xfs_inode.c    |   47 ++++++++++++---------
 fs/xfs/xfs_inode.h    |   14 +++++-
 fs/xfs/xfs_mount.c    |    2 
 fs/xfs/xfs_vnodeops.c |    8 ---
 6 files changed, 108 insertions(+), 72 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_iget.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_iget.c	2007-11-22 10:33:53.993326524 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_iget.c	2007-11-22 10:33:57.724849511 +1100
@@ -40,6 +40,37 @@
 #include "xfs_utils.h"
 
 /*
+ * Attempt to move the inode out of the IRECLAIMABLE state.
+ * Must be called under rcu_read_lock() and with the ip->i_flags_lock
+ * held for synchronisation with xfs_ireclaim_finish().
+ */
+STATIC int
+xfs_iget_reclaim_check(
+	xfs_inode_t	*ip,
+	int		flags)
+{
+	/*
+	 * If IRECLAIM is set this inode is on its way out of the system, we
+	 * need to pause and try again.
+	 */
+	if (__xfs_iflags_test(ip, XFS_IRECLAIM))
+		return EAGAIN;
+	ASSERT(__xfs_iflags_test(ip, XFS_IRECLAIMABLE));
+
+	/*
+	 * If lookup is racing with unlink, then we should return an error
+	 * immediately so we don't remove it from the reclaim list and
+	 * potentially leak the inode.
+	 */
+
+	if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE))
+		return ENOENT;
+
+	__xfs_iflags_clear(ip, XFS_IRECLAIMABLE);
+	return 0;
+}
+
+/*
  * Look up an inode by number in the given file system.
  * The inode is looked up in the cache held in each AG.
  * If the inode is found in the cache, attach it to the provided
@@ -94,7 +125,7 @@ xfs_iget_core(
 	agino = XFS_INO_TO_AGINO(mp, ino);
 
 again:
-	read_lock(&pag->pag_ici_lock);
+	rcu_read_lock();
 	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
 
 	if (ip != NULL) {
@@ -103,52 +134,44 @@ again:
 		 * we need to pause and try again.
 		 */
 		if (xfs_iflags_test(ip, XFS_INEW)) {
-			read_unlock(&pag->pag_ici_lock);
+			rcu_read_unlock();
 			delay(1);
 			XFS_STATS_INC(xs_ig_frecycle);
 
 			goto again;
 		}
 
+		/*
+		 * Determine if the inode is queued for reclaim or being
+		 * reclaimed.  This is trickier now we are under RCU locking.
+		 *
+		 * Basically, xfs_ireclaim_finish() uses the i_flags_lock to
+		 * atomically move the inode out of the IRECLAIMABLE state and
+		 * inode the IRECLAIM state, so we have to use the same lock to
+		 * do an equivalent set of tests and move the inode out of the
+		 * IRECLAIMABLE state.
+		 */
 		old_inode = ip->i_vnode;
 		if (old_inode == NULL) {
-			/*
-			 * If IRECLAIM is set this inode is
-			 * on its way out of the system,
-			 * we need to pause and try again.
-			 */
-			if (xfs_iflags_test(ip, XFS_IRECLAIM)) {
-				read_unlock(&pag->pag_ici_lock);
-				delay(1);
+			spin_lock(&ip->i_flags_lock);
+			error = xfs_iget_reclaim_check(ip, flags);
+			spin_unlock(&ip->i_flags_lock);
+			rcu_read_unlock();
+			if (error) {
 				XFS_STATS_INC(xs_ig_frecycle);
-
-				goto again;
-			}
-			ASSERT(xfs_iflags_test(ip, XFS_IRECLAIMABLE));
-
-			/*
-			 * If lookup is racing with unlink, then we
-			 * should return an error immediately so we
-			 * don't remove it from the reclaim list and
-			 * potentially leak the inode.
-			 */
-			if ((ip->i_d.di_mode == 0) &&
-			    !(flags & XFS_IGET_CREATE)) {
-				read_unlock(&pag->pag_ici_lock);
+				if (error == EAGAIN) {
+					delay(1);
+					goto again;
+				}
 				xfs_put_perag(mp, pag);
-				return ENOENT;
+				return error;
 			}
-
-			xfs_itrace_exit_tag(ip, "xfs_iget.alloc");
-
-			XFS_STATS_INC(xs_ig_found);
-			xfs_iflags_clear(ip, XFS_IRECLAIMABLE);
-			read_unlock(&pag->pag_ici_lock);
-
 			XFS_MOUNT_ILOCK(mp);
 			list_del_init(&ip->i_reclaim);
 			XFS_MOUNT_IUNLOCK(mp);
 
+			XFS_STATS_INC(xs_ig_found);
+			xfs_itrace_exit_tag(ip, "xfs_iget.alloc");
 			goto finish_inode;
 
 		} else if (inode != old_inode) {
@@ -156,7 +179,7 @@ again:
 			 * try again.
 			 */
 			if (old_inode->i_state & (I_FREEING | I_CLEAR)) {
-				read_unlock(&pag->pag_ici_lock);
+				rcu_read_unlock();
 				delay(1);
 				XFS_STATS_INC(xs_ig_frecycle);
 
@@ -174,7 +197,7 @@ again:
 		/*
 		 * Inode cache hit
 		 */
-		read_unlock(&pag->pag_ici_lock);
+		rcu_read_unlock();
 		XFS_STATS_INC(xs_ig_found);
 
 finish_inode:
@@ -194,7 +217,7 @@ finish_inode:
 	/*
 	 * Inode cache miss
 	 */
-	read_unlock(&pag->pag_ici_lock);
+	rcu_read_unlock();
 	XFS_STATS_INC(xs_ig_missed);
 
 	/*
@@ -237,14 +260,14 @@ finish_inode:
 	}
 	mask = ~(((XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog)) - 1);
 	first_index = agino & mask;
-	write_lock(&pag->pag_ici_lock);
+	spin_lock(&pag->pag_ici_lock);
 	/*
 	 * insert the new inode
 	 */
 	error = radix_tree_insert(&pag->pag_ici_root, agino, ip);
 	if (unlikely(error)) {
 		BUG_ON(error != -EEXIST);
-		write_unlock(&pag->pag_ici_lock);
+		spin_unlock(&pag->pag_ici_lock);
 		radix_tree_preload_end();
 		xfs_idestroy(ip);
 		XFS_STATS_INC(xs_ig_dup);
@@ -257,7 +280,7 @@ finish_inode:
 	ip->i_udquot = ip->i_gdquot = NULL;
 	xfs_iflags_set(ip, XFS_INEW);
 
-	write_unlock(&pag->pag_ici_lock);
+	spin_unlock(&pag->pag_ici_lock);
 	radix_tree_preload_end();
 
 	/*
@@ -378,9 +401,9 @@ xfs_inode_incore(xfs_mount_t	*mp,
 	xfs_perag_t	*pag;
 
 	pag = xfs_get_perag(mp, ino);
-	read_lock(&pag->pag_ici_lock);
+	rcu_read_lock();
 	ip = radix_tree_lookup(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ino));
-	read_unlock(&pag->pag_ici_lock);
+	rcu_read_unlock();
 	xfs_put_perag(mp, pag);
 
 	/* the returned inode must match the transaction */
@@ -491,9 +514,9 @@ xfs_iextract(
 	xfs_perag_t	*pag = xfs_get_perag(mp, ip->i_ino);
 	xfs_inode_t	*iq;
 
-	write_lock(&pag->pag_ici_lock);
+	spin_lock(&pag->pag_ici_lock);
 	radix_tree_delete(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino));
-	write_unlock(&pag->pag_ici_lock);
+	spin_unlock(&pag->pag_ici_lock);
 	xfs_put_perag(mp, pag);
 
 	/*
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2007-11-22 10:33:55.877085717 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2007-11-22 10:33:57.728849000 +1100
@@ -2169,13 +2169,16 @@ STATIC_INLINE int xfs_inode_clean(xfs_in
 STATIC int
 xfs_icluster_lookup(
 	xfs_mount_t	*mp,
-	xfs_perag_t	*pag,
 	xfs_ino_t	ino,
 	xfs_inode_t	**ilist,
 	int		clsize)
 {
-	unsigned long		first_index, last_index, mask;
-	int			nr_found;
+	unsigned long	first_index, last_index, mask;
+	int		nr_found;
+	xfs_perag_t	*pag = xfs_get_perag(mp, ino);
+
+	ASSERT(pag->pagi_inodeok);
+	ASSERT(pag->pag_ici_init);
 
 	mask = ~(clsize - 1);
 	first_index = XFS_INO_TO_AGINO(mp, ino) & mask;
@@ -2183,6 +2186,7 @@ xfs_icluster_lookup(
 	nr_found = radix_tree_gang_lookup_range(&pag->pag_ici_root,
 				(void**)ilist, first_index, last_index,
 				clsize);
+	xfs_put_perag(mp, pag);
 	ASSERT(nr_found <= clsize);
 #ifdef DEBUG
 {	int		i;
@@ -2212,7 +2216,6 @@ xfs_ifree_cluster(
 	xfs_inode_t		*ip, **ip_found, **ilist;
 	xfs_inode_log_item_t	*iip;
 	xfs_log_item_t		*lip;
-	xfs_perag_t		*pag = xfs_get_perag(mp, inum);
 
 	if (mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp)) {
 		blks_per_cluster = 1;
@@ -2246,10 +2249,10 @@ xfs_ifree_cluster(
 		 * and fail, we need some other form of interlock
 		 * here.
 		 */
-		read_lock(&pag->pag_ici_lock);
-		nr_found = xfs_icluster_lookup(mp, pag, inum, ilist, ninodes);
+		rcu_read_lock();
+		nr_found = xfs_icluster_lookup(mp, inum, ilist, ninodes);
 		if (nr_found == 0) {
-			read_unlock(&pag->pag_ici_lock);
+			rcu_read_unlock();
 			continue;
 		}
 		found = 0;
@@ -2301,7 +2304,7 @@ xfs_ifree_cluster(
 				}
 			}
 		}
-		read_unlock(&pag->pag_ici_lock);
+		rcu_read_unlock();
 
 		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, blkno, 
 					mp->m_bsize * blks_per_cluster,
@@ -2356,7 +2359,6 @@ xfs_ifree_cluster(
 
 	kmem_free(ip_found, ninodes * sizeof(xfs_inode_t *));
 	kmem_free(ilist, ninodes * sizeof(xfs_inode_t *));
-	xfs_put_perag(mp, pag);
 }
 
 /*
@@ -2754,8 +2756,18 @@ xfs_idestroy_fork(
  * This is called free all the memory associated with an inode.
  * It must free the inode itself and any buffers allocated for
  * if_extents/if_data and if_broot.  It must also free the lock
- * associated with the inode.
+ * associated with the inode. This uses RCU callbacks to do the
+ * freeing of memory so that the iradix cache can use RCU read side
+ * locking.
  */
+STATIC void
+xfs_idestroy_callback(
+	struct rcu_head	*head)
+{
+	xfs_inode_t *ip = container_of(head, xfs_inode_t, i_rcu);
+	kmem_zone_free(xfs_inode_zone, ip);
+}
+
 void
 xfs_idestroy(
 	xfs_inode_t	*ip)
@@ -2811,10 +2823,9 @@ xfs_idestroy(
 		}
 		xfs_inode_item_destroy(ip);
 	}
-	kmem_zone_free(xfs_inode_zone, ip);
+	call_rcu(&ip->i_rcu, xfs_idestroy_callback);
 }
 
-
 /*
  * Increment the pin count of the given buffer.
  * This value is protected by ipinlock spinlock in the mount structure.
@@ -3052,7 +3063,6 @@ xfs_iflush_cluster(
 	xfs_buf_t	*bp)
 {
 	xfs_mount_t		*mp = ip->i_mount;
-	xfs_perag_t		*pag = xfs_get_perag(mp, ip->i_ino);
 	unsigned long		inodes_per_cluster;
 	int			ilist_size;
 	xfs_inode_t		**ilist;
@@ -3063,17 +3073,14 @@ xfs_iflush_cluster(
 	int			bufwasdelwri;
 	int			i;
 
-	ASSERT(pag->pagi_inodeok);
-	ASSERT(pag->pag_ici_init);
-
 	inodes_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog;
 	ilist_size = inodes_per_cluster * sizeof(xfs_inode_t *);
 	ilist = kmem_alloc(ilist_size, KM_MAYFAIL);
 	if (!ilist)
 		return 0;
 
-	read_lock(&pag->pag_ici_lock);
-	nr_found = xfs_icluster_lookup(mp, pag, ip->i_ino, ilist,
+	rcu_read_lock();
+	nr_found = xfs_icluster_lookup(mp, ip->i_ino, ilist,
 							inodes_per_cluster);
 	if (nr_found == 0)
 		goto out_free;
@@ -3138,7 +3145,7 @@ xfs_iflush_cluster(
 	}
 
 out_free:
-	read_unlock(&pag->pag_ici_lock);
+	rcu_read_unlock();
 	kmem_free(ilist, ilist_size);
 	return 0;
 
@@ -3148,7 +3155,7 @@ cluster_corrupt_out:
 	 * Corruption detected in the clustering loop.  Invalidate the
 	 * inode buffer and shut down the filesystem.
 	 */
-	read_unlock(&pag->pag_ici_lock);
+	rcu_read_unlock();
 	/*
 	 * Clean up the buffer.  If it was B_DELWRI, just release it --
 	 * brelse can handle it with no problems.  If not, shut down the
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.h	2007-11-22 10:33:53.997326012 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.h	2007-11-22 10:33:57.728849000 +1100
@@ -203,7 +203,12 @@ typedef struct xfs_inode {
 	struct xfs_inode	*i_mnext;	/* next inode in mount list */
 	struct xfs_inode	*i_mprev;	/* ptr to prev inode */
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
-	struct list_head	i_reclaim;	/* reclaim list */
+	union {
+		struct list_head i_reclaim;	/* reclaim list */
+		struct rcu_head	i_rcu;		/* rcu reclaim list */
+	} i_ru;
+#define i_reclaim	i_ru.i_reclaim
+#define i_rcu		i_ru.i_rcu
 	bhv_vnode_t		*i_vnode;	/* vnode backpointer */
 	struct xfs_dquot	*i_udquot;	/* user dquot */
 	struct xfs_dquot	*i_gdquot;	/* group dquot */
@@ -285,10 +290,15 @@ xfs_iflags_set(xfs_inode_t *ip, unsigned
 }
 
 static inline void
+__xfs_iflags_clear(xfs_inode_t *ip, unsigned short flags)
+{
+	ip->i_flags &= ~flags;
+}
+static inline void
 xfs_iflags_clear(xfs_inode_t *ip, unsigned short flags)
 {
 	spin_lock(&ip->i_flags_lock);
-	ip->i_flags &= ~flags;
+	__xfs_iflags_clear(ip, flags);
 	spin_unlock(&ip->i_flags_lock);
 }
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_ag.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_ag.h	2007-11-22 10:25:23.554538298 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_ag.h	2007-11-22 10:33:57.728849000 +1100
@@ -199,7 +199,7 @@ typedef struct xfs_perag
 	atomic_t        pagf_fstrms;    /* # of filestreams active in this AG */
 
 	int		pag_ici_init;	/* incore inode cache initialised */
-	rwlock_t	pag_ici_lock;	/* incore inode lock */
+	spinlock_t	pag_ici_lock;	/* incore inode lock */
 	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
 } xfs_perag_t;
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.c	2007-11-22 10:31:27.891999961 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.c	2007-11-22 10:33:57.732848488 +1100
@@ -334,7 +334,7 @@ xfs_initialize_perag_icache(
 	xfs_perag_t	*pag)
 {
 	if (!pag->pag_ici_init) {
-		rwlock_init(&pag->pag_ici_lock);
+		spin_lock_init(&pag->pag_ici_lock);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 		pag->pag_ici_init = 1;
 	}
Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2007-11-22 10:33:51.045703325 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2007-11-22 10:33:57.732848488 +1100
@@ -3671,24 +3671,22 @@ xfs_finish_reclaim(
 	int		locked,
 	int		sync_mode)
 {
-	xfs_perag_t	*pag = xfs_get_perag(ip->i_mount, ip->i_ino);
 	bhv_vnode_t	*vp = XFS_ITOV_NULL(ip);
 	int		error;
 
 	if (vp && VN_BAD(vp))
 		goto reclaim;
 
-	/* The hash lock here protects a thread in xfs_iget_core from
+	/*
+	 * The flags lock here protects a thread in xfs_iget_core from
 	 * racing with us on linking the inode back with a vnode.
 	 * Once we have the XFS_IRECLAIM flag set it will not touch
 	 * us.
 	 */
-	write_lock(&pag->pag_ici_lock);
 	spin_lock(&ip->i_flags_lock);
 	if (__xfs_iflags_test(ip, XFS_IRECLAIM) ||
 	    (!__xfs_iflags_test(ip, XFS_IRECLAIMABLE) && vp == NULL)) {
 		spin_unlock(&ip->i_flags_lock);
-		write_unlock(&pag->pag_ici_lock);
 		if (locked) {
 			xfs_ifunlock(ip);
 			xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -3697,8 +3695,6 @@ xfs_finish_reclaim(
 	}
 	__xfs_iflags_set(ip, XFS_IRECLAIM);
 	spin_unlock(&ip->i_flags_lock);
-	write_unlock(&pag->pag_ici_lock);
-	xfs_put_perag(ip->i_mount, pag);
 
 	/*
 	 * If the inode is still dirty, then flush it out.  If the inode
