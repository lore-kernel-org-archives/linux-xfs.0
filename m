Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Aug 2007 16:13:22 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l78NDDbm013676
	for <xfs@oss.sgi.com>; Wed, 8 Aug 2007 16:13:15 -0700
Date: Thu, 9 Aug 2007 09:13:10 +1000
From: David Chinner <dgc@sgi.com>
Subject: [PATCH 4 of 4] Per Allocation Group inode radix trees
Message-ID: <20070808231310.GS12413810@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

One of the big problems with the hash of radix trees is that they
require 64 bit inode number indexing and hence would prevent the use
of 64 bit inodes on a 32 bit platform.

Also, the hashing only provides limited parallelism as inodes in
different allocation groups that can be operated on in parallel in
all other might shared the same radix tree. The hash sizing is
also uses relatively basic heuristics for sizing that were
provided just to get "sufficient" trees rather than a more
optimal number.

By moving to a radix tree per AG, we can use the agino number as
the index rather than the inode number, thereby rducing the radix
tree key to 32 bits enabling this to be used for 64 bit inodes
on 32 bit machines. In doing so, we also grately reduce the
sparseness of the radix trees because the agino is a more
compact representation of the inode location than the inode number.

It also provides inherent parallelism in the same manner as the rest
of XFS without the need for heuristics.  i.e. we parallelise
operations by keeping structures and operations within AGs. This
removes the need for the ihashsize mount parameter altogether
as the inode caches should never need size hints anymore.

Signed-off-by: Dave Chinner <dgc@sgi.com>

---
 fs/xfs/linux-2.6/xfs_export.c |    4 -
 fs/xfs/xfs_ag.h               |    4 +
 fs/xfs/xfs_buf_item.c         |    1 
 fs/xfs/xfs_clnt.h             |    1 
 fs/xfs/xfs_dir2_block.c       |    1 
 fs/xfs/xfs_dir2_data.c        |    1 
 fs/xfs/xfs_dir2_node.c        |    1 
 fs/xfs/xfs_dir2_sf.c          |    1 
 fs/xfs/xfs_error.c            |    1 
 fs/xfs/xfs_extfree_item.c     |    1 
 fs/xfs/xfs_iget.c             |  158 +++++++++++++++---------------------------
 fs/xfs/xfs_inode.c            |   18 ++--
 fs/xfs/xfs_inode.h            |   22 -----
 fs/xfs/xfs_mount.c            |   20 ++---
 fs/xfs/xfs_mount.h            |   22 ++++-
 fs/xfs/xfs_rename.c           |    1 
 fs/xfs/xfs_trans_ail.c        |    1 
 fs/xfs/xfs_trans_extfree.c    |    1 
 fs/xfs/xfs_vfsops.c           |   16 ----
 fs/xfs/xfs_vnodeops.c         |    9 +-
 fs/xfs/xfsidbg.c              |  103 ---------------------------
 21 files changed, 121 insertions(+), 266 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_ag.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_ag.h	2007-08-01 10:36:25.763324913 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_ag.h	2007-08-01 15:43:34.078954812 +1000
@@ -197,6 +197,10 @@ typedef struct xfs_perag
 #endif
 	xfs_perag_busy_t *pagb_list;	/* unstable blocks */
 	atomic_t        pagf_fstrms;    /* # of filestreams active in this AG */
+
+	int		pag_ici_init;	/* incore inode cache initialised */
+	rwlock_t	pag_ici_lock;	/* incore inode lock */
+	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
 } xfs_perag_t;
 
 #define	XFS_AG_MAXLEVELS(mp)		((mp)->m_ag_maxlevels)
Index: 2.6.x-xfs-new/fs/xfs/xfs_iget.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_iget.c	2007-08-01 15:43:30.375434934 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_iget.c	2007-08-01 15:43:34.078954812 +1000
@@ -40,60 +40,13 @@
 #include "xfs_utils.h"
 
 /*
- * Initialize the inode hash table for the newly mounted file system.
- * Choose an initial table size based on user specified value, else
- * use a simple algorithm using the maximum number of inodes as an
- * indicator for table size, and clamp it between one and some large
- * number of pages.
- */
-void
-xfs_ihash_init(xfs_mount_t *mp)
-{
-	uint		i;
-
-	if (!mp->m_ihsize || mp->m_ihsize > 128) {
-		/* default to (2*cpus) - 1 or 15. */
-		mp->m_ihsize = (2 * num_online_cpus()) - 1;
-		mp->m_ihsize = min_t(size_t, 15, mp->m_ihsize);
-		printk("mp->m_ihsize %ld\n", mp->m_ihsize);
-	}
-
-	mp->m_ihash = kmem_zalloc_greedy((size_t *)&mp->m_ihsize,
-					 NBPC * sizeof(xfs_ihash_t),
-					 mp->m_ihsize * sizeof(xfs_ihash_t),
-					 KM_SLEEP | KM_MAYFAIL | KM_LARGE);
-	mp->m_ihsize /= sizeof(xfs_ihash_t);
-	for (i = 0; i < mp->m_ihsize; i++) {
-		rwlock_init(&(mp->m_ihash[i].ih_lock));
-		INIT_RADIX_TREE(&(mp->m_ihash[i].ih_root), GFP_ATOMIC);
-	}
-}
-
-/*
- * Free up structures allocated by xfs_ihash_init, at unmount time.
- */
-void
-xfs_ihash_free(xfs_mount_t *mp)
-{
-	kmem_free(mp->m_ihash, mp->m_ihsize * sizeof(xfs_ihash_t));
-	mp->m_ihash = NULL;
-}
-
-/*
  * Look up an inode by number in the given file system.
- * The inode is looked up in the hash table for the file system
- * represented by the mount point parameter mp.  Each bucket of
- * the hash table is guarded by an individual semaphore.
- *
- * If the inode is found in the hash table, its corresponding vnode
- * is obtained with a call to vn_get().  This call takes care of
- * coordination with the reclamation of the inode and vnode.  Note
- * that the vmap structure is filled in while holding the hash lock.
- * This gives us the state of the inode/vnode when we found it and
- * is used for coordination in vn_get().
+ * The inode is looked up in the cache held in each AG.
+ * If the inode is found in the cache, attach it to the provided
+ * vnode.
  *
- * If it is not in core, read it in from the file system's device and
- * add the inode into the hash table.
+ * If it is not in core, read it in from the file system's device,
+ * add it to the cache and attach the provided vnode.
  *
  * The inode is locked according to the value of the lock_flags parameter.
  * This flag parameter indicates how and if the inode's IO lock and inode lock
@@ -121,29 +74,37 @@ xfs_iget_core(
 	xfs_inode_t	**ipp,
 	xfs_daddr_t	bno)
 {
-	xfs_ihash_t	*ih;
 	xfs_inode_t	*ip;
 	xfs_inode_t	*iq;
 	bhv_vnode_t	*inode_vp;
-	ulong		version;
 	int		error;
 	xfs_icluster_t	*icl, *new_icl = NULL;
 	unsigned long	first_index, mask;
+	xfs_perag_t	*pag;
+	xfs_agino_t	agino;
 
-
-	ih = XFS_IHASH(mp, ino);
+	/* the radix tree exists only in inode capable AGs */
+	if (XFS_INO_TO_AGNO(mp, ino) >= mp->m_maxagi)
+		return EINVAL;
+
+	/* get the perag structure and ensure that it's inode capable */
+	pag = xfs_get_perag(mp, ino);
+	if (!pag->pagi_inodeok)
+		return EINVAL;
+	ASSERT(pag->pag_ici_init);
+	agino = XFS_INO_TO_AGINO(mp, ino);
 
 again:
-	read_lock(&ih->ih_lock);
+	read_lock(&pag->pag_ici_lock);
+	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
 
-	ip = (xfs_inode_t *)radix_tree_lookup(&ih->ih_root, (unsigned long)ino);
 	if (ip != NULL) {
 		/*
 		 * If INEW is set this inode is being set up
 		 * we need to pause and try again.
 		 */
 		if (xfs_iflags_test(ip, XFS_INEW)) {
-			read_unlock(&ih->ih_lock);
+			read_unlock(&pag->pag_ici_lock);
 			delay(1);
 			XFS_STATS_INC(xs_ig_frecycle);
 
@@ -158,7 +119,7 @@ again:
 			 * we need to pause and try again.
 			 */
 			if (xfs_iflags_test(ip, XFS_IRECLAIM)) {
-				read_unlock(&ih->ih_lock);
+				read_unlock(&pag->pag_ici_lock);
 				delay(1);
 				XFS_STATS_INC(xs_ig_frecycle);
 
@@ -174,7 +135,8 @@ again:
 			 */
 			if ((ip->i_d.di_mode == 0) &&
 			    !(flags & XFS_IGET_CREATE)) {
-				read_unlock(&ih->ih_lock);
+				read_unlock(&pag->pag_ici_lock);
+				xfs_put_perag(mp, pag);
 				return ENOENT;
 			}
 
@@ -188,7 +150,7 @@ again:
 			 * xfs_iunpin()
 			 */
 			if (xfs_ipincount(ip)) {
-				read_unlock(&ih->ih_lock);
+				read_unlock(&pag->pag_ici_lock);
 				xfs_log_force(mp, 0,
 					XFS_LOG_FORCE|XFS_LOG_SYNC);
 				XFS_STATS_INC(xs_ig_frecycle);
@@ -201,8 +163,7 @@ again:
 			XFS_STATS_INC(xs_ig_found);
 
 			xfs_iflags_clear(ip, XFS_IRECLAIMABLE);
-			version = ih->ih_version;
-			read_unlock(&ih->ih_lock);
+			read_unlock(&pag->pag_ici_lock);
 
 			XFS_MOUNT_ILOCK(mp);
 			list_del_init(&ip->i_reclaim);
@@ -217,7 +178,7 @@ again:
 			 * try again.
 			 */
 			if (inode->i_state & (I_FREEING | I_CLEAR)) {
-				read_unlock(&ih->ih_lock);
+				read_unlock(&pag->pag_ici_lock);
 				delay(1);
 				XFS_STATS_INC(xs_ig_frecycle);
 
@@ -233,19 +194,17 @@ again:
 		}
 
 		/*
-		 * Inode cache hit: if ip is not at the front of
-		 * its hash chain, move it there now.
-		 * Do this with the lock held for update, but
-		 * do statistics after releasing the lock.
+		 * Inode cache hit
 		 */
-		version = ih->ih_version;
-		read_unlock(&ih->ih_lock);
+		read_unlock(&pag->pag_ici_lock);
 		XFS_STATS_INC(xs_ig_found);
 
 finish_inode:
 		if (ip->i_d.di_mode == 0) {
-			if (!(flags & XFS_IGET_CREATE))
+			if (!(flags & XFS_IGET_CREATE)) {
+				xfs_put_perag(mp, pag);
 				return ENOENT;
+			}
 			xfs_iocore_inode_reinit(ip);
 		}
 
@@ -259,11 +218,9 @@ finish_inode:
 	}
 
 	/*
-	 * Inode cache miss: save the hash chain version stamp and unlock
-	 * the chain, so we don't deadlock in vn_alloc.
+	 * Inode cache miss
 	 */
-	version = ih->ih_version;
-	read_unlock(&ih->ih_lock);
+	read_unlock(&pag->pag_ici_lock);
 	XFS_STATS_INC(xs_ig_missed);
 
 	/*
@@ -272,25 +229,27 @@ finish_inode:
 	 */
 	error = xfs_iread(mp, tp, ino, &ip, bno,
 			  (flags & XFS_IGET_BULKSTAT) ? XFS_IMAP_BULKSTAT : 0);
-	if (error)
+	if (error) {
+		xfs_put_perag(mp, pag);
 		return error;
+	}
 
 	vn_trace_exit(vp, "xfs_iget.alloc", (inst_t *)__return_address);
 
 	xfs_inode_lock_init(ip, vp);
 	xfs_iocore_inode_init(ip);
-
 	if (lock_flags)
 		xfs_ilock(ip, lock_flags);
 
 	if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE)) {
 		xfs_idestroy(ip);
+		xfs_put_perag(mp, pag);
 		return ENOENT;
 	}
 
 	/*
 	 * This is a bit messy - we preallocate everything we _might_
-	 * need before we pick up the hash lock. That way we donnn't have to
+	 * need before we pick up the ici lock. That way we don't have to
 	 * juggle locks and go all the way back to the start.
 	 */
 	new_icl = (xfs_icluster_t *)kmem_zone_alloc(xfs_icluster_zone, KM_SLEEP);
@@ -299,14 +258,15 @@ finish_inode:
 		goto again;
 	}
 	mask = ~(((XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog)) - 1);
-	first_index = ino & mask;
-	write_lock(&ih->ih_lock);
+	first_index = agino & mask;
+	write_lock(&pag->pag_ici_lock);
 
 	/*
 	 * Find the cluster if it exists
 	 */
 	icl = NULL;
-	if (radix_tree_gang_lookup(&ih->ih_root, (void**)&iq, first_index, 1)) {
+	if (radix_tree_gang_lookup(&pag->pag_ici_root, (void**)&iq,
+							first_index, 1)) {
 		if ((iq->i_ino & mask) == first_index)
 			icl = iq->i_cluster;
 	}
@@ -314,13 +274,12 @@ finish_inode:
 	/*
 	 * insert the new inode
 	 */
-	error = radix_tree_insert(&ih->ih_root, (unsigned long)ino, (void *)ip);
+	error = radix_tree_insert(&pag->pag_ici_root, agino, ip);
 	if (unlikely(error)) {
 		BUG_ON(error != -EEXIST);
-		write_unlock(&ih->ih_lock);
+		write_unlock(&pag->pag_ici_lock);
 		radix_tree_preload_end();
 		xfs_idestroy(ip);
-		ASSERT(ih->ih_version != version);
 		XFS_STATS_INC(xs_ig_dup);
 		goto again;
 	}
@@ -328,9 +287,7 @@ finish_inode:
 	/*
 	 * These values _must_ be set before releasing ihlock!
 	 */
-	ip->i_hash = ih;
 	ip->i_udquot = ip->i_gdquot = NULL;
-	ih->ih_version++;
 	xfs_iflags_set(ip, XFS_INEW);
 
 	ASSERT(ip->i_cluster == NULL && ip->i_cprev == NULL &&
@@ -358,7 +315,7 @@ finish_inode:
 		spin_lock_init(&new_icl->icl_lock);
 		new_icl = NULL;
 	}
-	write_unlock(&ih->ih_lock);
+	write_unlock(&pag->pag_ici_lock);
 	radix_tree_preload_end();
 	if (new_icl)
 		kmem_zone_free(xfs_icluster_zone, new_icl);
@@ -380,6 +337,7 @@ finish_inode:
 	mp->m_inodes = ip;
 
 	XFS_MOUNT_IUNLOCK(mp);
+	xfs_put_perag(mp, pag);
 
  return_ip:
 	ASSERT(ip->i_df.if_ext_max ==
@@ -489,13 +447,14 @@ xfs_inode_incore(xfs_mount_t	*mp,
 		 xfs_ino_t	ino,
 		 xfs_trans_t	*tp)
 {
-	xfs_ihash_t	*ih;
 	xfs_inode_t	*ip;
+	xfs_perag_t	*pag;
 
-	ih = XFS_IHASH(mp, ino);
-	read_lock(&ih->ih_lock);
-	ip = (xfs_inode_t *) radix_tree_lookup(&ih->ih_root, (unsigned long)ino);
-	read_unlock(&ih->ih_lock);
+	pag = xfs_get_perag(mp, ino);
+	read_lock(&pag->pag_ici_lock);
+	ip = radix_tree_lookup(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ino));
+	read_unlock(&pag->pag_ici_lock);
+	xfs_put_perag(mp, pag);
 
 	/* the returned inode must match the transaction */
 	if (ip && (ip->i_transp != tp))
@@ -606,15 +565,14 @@ void
 xfs_iextract(
 	xfs_inode_t	*ip)
 {
-	xfs_ihash_t	*ih;
+	xfs_mount_t	*mp = ip->i_mount;
+	xfs_perag_t	*pag = xfs_get_perag(mp, ip->i_ino);
 	xfs_inode_t	*iq;
-	xfs_mount_t	*mp;
 
-	ih = ip->i_hash;
-	write_lock(&ih->ih_lock);
-	radix_tree_delete(&ih->ih_root, ip->i_ino);
-	ih->ih_version++;
-	write_unlock(&ih->ih_lock);
+	write_lock(&pag->pag_ici_lock);
+	radix_tree_delete(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino));
+	write_unlock(&pag->pag_ici_lock);
+	xfs_put_perag(mp, pag);
 
 	/*
 	 * Remove from cluster list
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.h	2007-08-01 15:43:30.379434415 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.h	2007-08-01 15:43:34.082954293 +1000
@@ -168,24 +168,10 @@ typedef struct xfs_iocore {
 extern void xfs_iocore_inode_init(struct xfs_inode *);
 extern void xfs_iocore_inode_reinit(struct xfs_inode *);
 
-
 /*
- * This is the type used in the xfs inode hash table.
- * An array of these is allocated for each mounted
- * file system to hash the inodes for that file system.
- */
-typedef struct xfs_ihash {
-	struct radix_tree_root	ih_root;
-	rwlock_t		ih_lock;
-	uint			ih_version;
-} xfs_ihash_t;
-
-#define XFS_IHASH(mp,ino) ((mp)->m_ihash + (((uint)((ino) >> 6)) % (mp)->m_ihsize))
-
-/*
- * This is the xfs inode cluster hash.  This hash is used by xfs_iflush to
- * find inodes that share a cluster and can be flushed to disk at the same
- * time.
+ * This is the xfs inode cluster structure.  This structure is used by
+ * xfs_iflush to find inodes that share a cluster and can be flushed to disk at
+ * the same time.
  */
 typedef struct xfs_icluster {
 	struct xfs_inode	*icl_ip;
@@ -219,7 +205,6 @@ typedef struct xfs_icluster {
  */
 
 typedef struct {
-	struct xfs_ihash	*ip_hash;	/* pointer to hash header */
 	struct xfs_inode	*ip_mnext;	/* next inode in mount list */
 	struct xfs_inode	*ip_mprev;	/* ptr to prev inode */
 	struct xfs_mount	*ip_mount;	/* fs mount struct ptr */
@@ -227,7 +212,6 @@ typedef struct {
 
 typedef struct xfs_inode {
 	/* Inode linking and identification information. */
-	struct xfs_ihash	*i_hash;	/* pointer to hash header */
 	struct xfs_inode	*i_mnext;	/* next inode in mount list */
 	struct xfs_inode	*i_mprev;	/* ptr to prev inode */
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.c	2007-08-01 15:43:30.391432860 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.c	2007-08-01 15:43:34.082954293 +1000
@@ -160,9 +160,6 @@ xfs_mount_free(
 	xfs_mount_t	*mp,
 	int		remove_bhv)
 {
-	if (mp->m_ihash)
-		xfs_ihash_free(mp);
-
 	if (mp->m_perag) {
 		int	agno;
 
@@ -394,12 +391,22 @@ xfs_initialize_perag(
 			pag->pagi_inodeok = 1;
 			if (index < max_metadata)
 				pag->pagf_metadata = 1;
+			if (!pag->pag_ici_init) {
+				rwlock_init(&pag->pag_ici_lock);
+				INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
+				pag->pag_ici_init = 1;
+			}
 		}
 	} else {
 		/* Setup default behavior for smaller filesystems */
 		for (index = 0; index < agcount; index++) {
 			pag = &mp->m_perag[index];
 			pag->pagi_inodeok = 1;
+			if (!pag->pag_ici_init) {
+				rwlock_init(&pag->pag_ici_lock);
+				INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
+				pag->pag_ici_init = 1;
+			}
 		}
 	}
 	return index;
@@ -1031,12 +1038,6 @@ xfs_mountfs(
 	xfs_trans_init(mp);
 
 	/*
-	 * Allocate and initialize the inode hash table for this
-	 * file system.
-	 */
-	xfs_ihash_init(mp);
-
-	/*
 	 * Allocate and initialize the per-ag data.
 	 */
 	init_rwsem(&mp->m_peraglock);
@@ -1187,7 +1188,6 @@ xfs_mountfs(
  error3:
 	xfs_log_unmount_dealloc(mp);
  error2:
-	xfs_ihash_free(mp);
 	for (agno = 0; agno < sbp->sb_agcount; agno++)
 		if (mp->m_perag[agno].pagb_list)
 			kmem_free(mp->m_perag[agno].pagb_list,
Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.h	2007-08-01 10:43:15.490092795 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.h	2007-08-01 15:43:34.082954293 +1000
@@ -57,10 +57,7 @@ struct log;
 struct bhv_vfs;
 struct bhv_vnode;
 struct xfs_mount_args;
-struct xfs_ihash;
-struct xfs_chash;
 struct xfs_inode;
-struct xfs_perag;
 struct xfs_iocore;
 struct xfs_bmbt_irec;
 struct xfs_bmap_free;
@@ -335,8 +332,6 @@ typedef struct xfs_mount {
 	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
 	lock_t			m_agirotor_lock;/* .. and lock protecting it */
 	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
-	size_t			m_ihsize;	/* size of next field */
-	struct xfs_ihash	*m_ihash;	/* fs private inode hash table*/
 	struct xfs_inode	*m_inodes;	/* active inode list */
 	struct list_head	m_del_inodes;	/* inodes to reclaim */
 	mutex_t			m_ilock;	/* inode list mutex */
@@ -458,7 +453,7 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_IDELETE	(1ULL << 18)	/* delete empty inode clusters*/
 #define XFS_MOUNT_SWALLOC	(1ULL << 19)	/* turn on stripe width
 						 * allocation */
-#define XFS_MOUNT_IHASHSIZE	(1ULL << 20)	/* inode hash table size */
+			     /*	(1ULL << 20)	-- currently unused */
 #define XFS_MOUNT_DIRSYNC	(1ULL << 21)	/* synchronous directory ops */
 #define XFS_MOUNT_COMPAT_IOSIZE	(1ULL << 22)	/* don't report large preferred
 						 * I/O size in stat() */
@@ -572,6 +567,21 @@ xfs_daddr_to_agbno(struct xfs_mount *mp,
 }
 
 /*
+ * perag get/put wrappers for eventual ref counting
+ */
+static inline xfs_perag_t *
+xfs_get_perag(struct xfs_mount *mp, xfs_ino_t ino)
+{
+	return &mp->m_perag[XFS_INO_TO_AGNO(mp, ino)];
+}
+
+static inline void
+xfs_put_perag(struct xfs_mount *mp, xfs_perag_t *pag)
+{
+	/* nothing to see here, move along */
+}
+
+/*
  * Per-cpu superblock locking functions
  */
 #ifdef HAVE_PERCPU_SB
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_export.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_export.c	2007-08-01 10:36:25.763324913 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_export.c	2007-08-01 15:43:34.094952738 +1000
@@ -17,10 +17,12 @@
  */
 #include "xfs.h"
 #include "xfs_types.h"
-#include "xfs_dmapi.h"
+#include "xfs_inum.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_export.h"
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_buf_item.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_buf_item.c	2007-08-01 10:36:25.775323355 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_buf_item.c	2007-08-01 15:43:34.094952738 +1000
@@ -23,6 +23,7 @@
 #include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
+#include "xfs_ag.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_buf_item.h"
Index: 2.6.x-xfs-new/fs/xfs/xfs_dir2_block.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_dir2_block.c	2007-08-01 15:06:25.800906516 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_dir2_block.c	2007-08-01 15:43:34.102951701 +1000
@@ -22,6 +22,7 @@
 #include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
+#include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
Index: 2.6.x-xfs-new/fs/xfs/xfs_dir2_data.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_dir2_data.c	2007-08-01 10:36:25.791321277 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_dir2_data.c	2007-08-01 15:43:34.106951182 +1000
@@ -22,6 +22,7 @@
 #include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
+#include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
Index: 2.6.x-xfs-new/fs/xfs/xfs_dir2_node.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_dir2_node.c	2007-08-01 10:36:25.791321277 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_dir2_node.c	2007-08-01 15:43:34.114950145 +1000
@@ -22,6 +22,7 @@
 #include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
+#include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
Index: 2.6.x-xfs-new/fs/xfs/xfs_dir2_sf.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_dir2_sf.c	2007-08-01 15:06:25.828902859 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_dir2_sf.c	2007-08-01 15:43:34.126948590 +1000
@@ -22,6 +22,7 @@
 #include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
+#include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
Index: 2.6.x-xfs-new/fs/xfs/xfs_error.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_error.c	2007-08-01 10:36:25.791321277 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_error.c	2007-08-01 15:43:34.126948590 +1000
@@ -22,6 +22,7 @@
 #include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
+#include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
Index: 2.6.x-xfs-new/fs/xfs/xfs_extfree_item.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_extfree_item.c	2007-08-01 10:36:25.791321277 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_extfree_item.c	2007-08-01 15:43:34.126948590 +1000
@@ -23,6 +23,7 @@
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_sb.h"
+#include "xfs_ag.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_trans_priv.h"
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2007-08-01 15:43:30.383433897 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2007-08-01 15:43:34.130948071 +1000
@@ -2182,10 +2182,10 @@ xfs_ifree_cluster(
 	int			i, j, found, pre_flushed;
 	xfs_daddr_t		blkno;
 	xfs_buf_t		*bp;
-	xfs_ihash_t		*ih;
 	xfs_inode_t		*ip, **ip_found;
 	xfs_inode_log_item_t	*iip;
 	xfs_log_item_t		*lip;
+	xfs_perag_t		*pag = xfs_get_perag(mp, inum);
 	SPLDECL(s);
 
 	if (mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp)) {
@@ -2220,20 +2220,20 @@ xfs_ifree_cluster(
 		 */
 		found = 0;
 		for (i = 0; i < ninodes; i++) {
-			ih = XFS_IHASH(mp, inum + i);
-			read_lock(&ih->ih_lock);
-			ip = (xfs_inode_t *)radix_tree_lookup(&ih->ih_root, inum + i);
+			read_lock(&pag->pag_ici_lock);
+			ip = radix_tree_lookup(&pag->pag_ici_root,
+					XFS_INO_TO_AGINO(mp, (inum + i)));
 
 			/* Inode not in memory or we found it already,
 			 * nothing to do
 			 */
 			if (!ip || xfs_iflags_test(ip, XFS_ISTALE)) {
-				read_unlock(&ih->ih_lock);
+				read_unlock(&pag->pag_ici_lock);
 				continue;
 			}
 
 			if (xfs_inode_clean(ip)) {
-				read_unlock(&ih->ih_lock);
+				read_unlock(&pag->pag_ici_lock);
 				continue;
 			}
 
@@ -2256,7 +2256,7 @@ xfs_ifree_cluster(
 						ip_found[found++] = ip;
 					}
 				}
-				read_unlock(&ih->ih_lock);
+				read_unlock(&pag->pag_ici_lock);
 				continue;
 			}
 
@@ -2274,8 +2274,7 @@ xfs_ifree_cluster(
 					xfs_iunlock(ip, XFS_ILOCK_EXCL);
 				}
 			}
-
-			read_unlock(&ih->ih_lock);
+			read_unlock(&pag->pag_ici_lock);
 		}
 
 		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, blkno, 
@@ -2330,6 +2329,7 @@ xfs_ifree_cluster(
 	}
 
 	kmem_free(ip_found, ninodes * sizeof(xfs_inode_t *));
+	xfs_put_perag(mp, pag);
 }
 
 /*
Index: 2.6.x-xfs-new/fs/xfs/xfs_rename.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_rename.c	2007-08-01 10:36:25.799320238 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_rename.c	2007-08-01 15:43:34.138947034 +1000
@@ -22,6 +22,7 @@
 #include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
+#include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
Index: 2.6.x-xfs-new/fs/xfs/xfs_trans_ail.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans_ail.c	2007-08-01 10:36:25.915305171 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_trans_ail.c	2007-08-01 15:43:34.146945997 +1000
@@ -22,6 +22,7 @@
 #include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
+#include "xfs_ag.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_trans_priv.h"
Index: 2.6.x-xfs-new/fs/xfs/xfs_trans_extfree.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans_extfree.c	2007-08-01 10:36:25.915305171 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_trans_extfree.c	2007-08-01 15:43:34.150945479 +1000
@@ -22,6 +22,7 @@
 #include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
+#include "xfs_ag.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_trans_priv.h"
Index: 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.c	2007-08-01 15:43:30.383433897 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c	2007-08-01 15:43:34.150945479 +1000
@@ -246,7 +246,6 @@ xfs_start_flags(
 			ap->logbufsize);
 		return XFS_ERROR(EINVAL);
 	}
-	mp->m_ihsize = ap->ihashsize;
 	mp->m_logbsize = ap->logbufsize;
 	mp->m_fsname_len = strlen(ap->fsname) + 1;
 	mp->m_fsname = kmem_alloc(mp->m_fsname_len, KM_SLEEP);
@@ -293,8 +292,6 @@ xfs_start_flags(
 		mp->m_readio_log = mp->m_writeio_log = ap->iosizelog;
 	}
 
-	if (ap->flags & XFSMNT_IHASHSIZE)
-		mp->m_flags |= XFS_MOUNT_IHASHSIZE;
 	if (ap->flags & XFSMNT_IDELETE)
 		mp->m_flags |= XFS_MOUNT_IDELETE;
 	if (ap->flags & XFSMNT_DIRSYNC)
@@ -1693,7 +1690,6 @@ xfs_vget(
 #define MNTOPT_BSDGROUPS    "bsdgroups"    /* group-ID from parent directory */
 #define MNTOPT_SYSVGROUPS   "sysvgroups"   /* group-ID from current process */
 #define MNTOPT_ALLOCSIZE    "allocsize"    /* preferred allocation size */
-#define MNTOPT_IHASHSIZE    "ihashsize"    /* size of inode hash table */
 #define MNTOPT_NORECOVERY   "norecovery"   /* don't run XFS recovery */
 #define MNTOPT_BARRIER	"barrier"	/* use writer barriers for log write and
 					 * unwritten extent conversion */
@@ -1819,15 +1815,6 @@ xfs_parseargs(
 			iosize = suffix_strtoul(value, &eov, 10);
 			args->flags |= XFSMNT_IOSIZE;
 			args->iosizelog = ffs(iosize) - 1;
-		} else if (!strcmp(this_char, MNTOPT_IHASHSIZE)) {
-			if (!value || !*value) {
-				cmn_err(CE_WARN,
-					"XFS: %s option requires an argument",
-					this_char);
-				return EINVAL;
-			}
-			args->flags |= XFSMNT_IHASHSIZE;
-			args->ihashsize = simple_strtoul(value, &eov, 10);
 		} else if (!strcmp(this_char, MNTOPT_GRPID) ||
 			   !strcmp(this_char, MNTOPT_BSDGROUPS)) {
 			vfsp->vfs_flag |= VFS_GRPID;
@@ -1986,9 +1973,6 @@ xfs_showargs(
 			seq_puts(m, xfs_infop->str);
 	}
 
-	if (mp->m_flags & XFS_MOUNT_IHASHSIZE)
-		seq_printf(m, "," MNTOPT_IHASHSIZE "=%d", (int)mp->m_ihsize);
-
 	if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
 		seq_printf(m, "," MNTOPT_ALLOCSIZE "=%dk",
 				(int)(1 << mp->m_writeio_log) >> 10);
Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2007-08-01 15:06:51.049608565 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2007-08-01 15:43:34.166943405 +1000
@@ -3859,7 +3859,7 @@ xfs_finish_reclaim(
 	int		locked,
 	int		sync_mode)
 {
-	xfs_ihash_t	*ih = ip->i_hash;
+	xfs_perag_t	*pag = xfs_get_perag(ip->i_mount, ip->i_ino);
 	bhv_vnode_t	*vp = XFS_ITOV_NULL(ip);
 	int		error;
 
@@ -3871,12 +3871,12 @@ xfs_finish_reclaim(
 	 * Once we have the XFS_IRECLAIM flag set it will not touch
 	 * us.
 	 */
-	write_lock(&ih->ih_lock);
+	write_lock(&pag->pag_ici_lock);
 	spin_lock(&ip->i_flags_lock);
 	if (__xfs_iflags_test(ip, XFS_IRECLAIM) ||
 	    (!__xfs_iflags_test(ip, XFS_IRECLAIMABLE) && vp == NULL)) {
 		spin_unlock(&ip->i_flags_lock);
-		write_unlock(&ih->ih_lock);
+		write_unlock(&pag->pag_ici_lock);
 		if (locked) {
 			xfs_ifunlock(ip);
 			xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -3885,7 +3885,8 @@ xfs_finish_reclaim(
 	}
 	__xfs_iflags_set(ip, XFS_IRECLAIM);
 	spin_unlock(&ip->i_flags_lock);
-	write_unlock(&ih->ih_lock);
+	write_unlock(&pag->pag_ici_lock);
+	xfs_put_perag(ip->i_mount, pag);
 
 	/*
 	 * If the inode is still dirty, then flush it out.  If the inode
Index: 2.6.x-xfs-new/fs/xfs/xfsidbg.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfsidbg.c	2007-08-01 15:43:30.387433378 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfsidbg.c	2007-08-01 15:43:34.170942886 +1000
@@ -147,7 +147,6 @@ static void	xfsidbg_xhelp(void);
 static void	xfsidbg_xiclog(xlog_in_core_t *);
 static void	xfsidbg_xiclogall(xlog_in_core_t *);
 static void	xfsidbg_xiclogcb(xlog_in_core_t *);
-static void	xfsidbg_xihash(xfs_mount_t *mp);
 static void	xfsidbg_xinodes(xfs_mount_t *);
 static void	xfsidbg_delayed_blocks(xfs_mount_t *);
 static void	xfsidbg_xinodes_quiesce(xfs_mount_t *);
@@ -1238,25 +1237,6 @@ static int	kdbm_xfs_xiclogcb(
 	return 0;
 }
 
-static int	kdbm_xfs_xihash(
-	int	argc,
-	const char **argv)
-{
-	unsigned long addr;
-	int nextarg = 1;
-	long offset = 0;
-	int diag;
-
-	if (argc != 1)
-		return KDB_ARGCOUNT;
-	diag = kdbgetaddrarg(argc, argv, &nextarg, &addr, &offset, NULL);
-	if (diag)
-		return diag;
-
-	xfsidbg_xihash((xfs_mount_t *) addr);
-	return 0;
-}
-
 static int	kdbm_xfs_xinodes(
 	int	argc,
 	const char **argv)
@@ -2131,15 +2111,11 @@ static void	printinode(struct inode *ip)
 		" i_mode = 0x%x  i_nlink = %d  i_rdev = 0x%x i_state = 0x%lx\n",
 					ip->i_mode, ip->i_nlink,
 					kdev_t_to_nr(ip->i_rdev), ip->i_state);
-	kdb_printf(" i_hash.nxt = 0x%p i_hash.pprv = 0x%p\n",
-                                        ip->i_hash.next, ip->i_hash.prev);
 #else
 	kdb_printf(
 		" i_mode = 0x%x  i_nlink = %d  i_rdev = 0x%x i_state = 0x%lx\n",
 					ip->i_mode, ip->i_nlink,
 					ip->i_rdev, ip->i_state);
-	kdb_printf(" i_hash.nxt = 0x%p i_hash.pprv = 0x%p\n",
-                                        ip->i_hash.next, ip->i_hash.pprev);
 #endif
 	kdb_printf(" i_list.nxt = 0x%p i_list.prv = 0x%p\n",
 					ip->i_list.next, ip->i_list.prev);
@@ -2681,8 +2657,6 @@ static struct xif xfsidbg_funcs[] = {
   {  "xictrc",	kdbm_xfs_xiclogtrace,	"<xlog_in_core_t>",
 				"Dump XFS in-core log trace" },
 #endif
-  {  "xihash",	kdbm_xfs_xihash,	"<xfs_mount_t>",
-				"Dump XFS inode hash statistics"},
 #ifdef XFS_ILOCK_TRACE
   {  "xilocktrc",kdbm_xfs_xilock_trace,	"<xfs_inode_t>",
 				"Dump XFS ilock trace" },
@@ -6610,7 +6584,7 @@ xfsidbg_xmount(xfs_mount_t *mp)
 		"BARRIER",	/* 0x20000 */
 		"IDELETE",	/* 0x40000 */
 		"SWALLOC",	/* 0x80000 */
-		"IHASHSIZE",	/* 0x100000 */
+		"UNUSED_100000", /* 0x100000 */
 		"DIRSYNC",	/* 0x200000 */
 		"COMPAT_IOSIZE",/* 0x400000 */
 		NULL
@@ -6642,8 +6616,6 @@ xfsidbg_xmount(xfs_mount_t *mp)
 		mp->m_rtdev_targp ? mp->m_rtdev_targp->bt_dev : 0);
 	kdb_printf("bsize %d agfrotor %d xfs_rotorstep %d agirotor %d\n",
 		mp->m_bsize, mp->m_agfrotor, xfs_rotorstep, mp->m_agirotor);
-	kdb_printf("ihash 0x%p ihsize %zu\n",
-		mp->m_ihash, mp->m_ihsize);
 	kdb_printf("inodes 0x%p ilock 0x%p ireclaims 0x%x\n",
 		mp->m_inodes, &mp->m_ilock, mp->m_ireclaims);
 	kdb_printf("readio_log 0x%x readio_blocks 0x%x ",
@@ -6717,73 +6689,6 @@ xfsidbg_xmount(xfs_mount_t *mp)
 
 }
 
-static void
-xfsidbg_xihash(xfs_mount_t *mp)
-{
-#if 0
-	xfs_ihash_t	*ih;
-	int		i;
-	int		j;
-	int		total;
-	int		numzeros;
-	xfs_inode_t	*ip;
-	int		*hist;
-	int		hist_bytes = mp->m_ihsize * sizeof(int);
-	int		hist2[21];
-
-	hist = (int *) kmalloc(hist_bytes, GFP_KERNEL);
-
-	if (hist == NULL) {
-		kdb_printf("xfsidbg_xihash: kmalloc(%d) failed!\n",
-							hist_bytes);
-		return;
-	}
-
-	for (i = 0; i < mp->m_ihsize; i++) {
-		ih = mp->m_ihash + i;
-		j = 0;
-		for (ip = ih->ih_next; ip != NULL; ip = ip->i_next)
-			j++;
-		hist[i] = j;
-	}
-
-	numzeros = total = 0;
-
-	for (i = 0; i < 21; i++)
-		hist2[i] = 0;
-
-	for (i = 0; i < mp->m_ihsize; i++)  {
-		kdb_printf("%d ", hist[i]);
-		total += hist[i];
-		numzeros += hist[i] == 0 ? 1 : 0;
-		if (hist[i] > 20)
-			j = 20;
-		else
-			j = hist[i];
-
-		if (! (j <= 20)) {
-			kdb_printf("xfsidbg_xihash: (j > 20)/%d @ line # %d\n",
-							j, __LINE__);
-			return;
-		}
-
-		hist2[j]++;
-	}
-
-	kdb_printf("\n");
-
-	kdb_printf("total inodes = %d, average length = %zu, adjusted average = %zu\n",
-		total, total / mp->m_ihsize,
-		total / (mp->m_ihsize - numzeros));
-
-	for (i = 0; i < 21; i++)  {
-		kdb_printf("%d - %d , ", i, hist2[i]);
-	}
-	kdb_printf("\n");
-	kfree(hist);
-#endif
-}
-
 /*
  * Command to print xfs inodes: kp xnode <addr>
  */
@@ -6799,10 +6704,8 @@ xfsidbg_xnode(xfs_inode_t *ip)
 		NULL
 	};
 
-	kdb_printf("hash 0x%p mount 0x%p\n",
-		ip->i_hash,
-		ip->i_mount);
-	kdb_printf("mnext 0x%p mprev 0x%p vnode 0x%p \n",
+	kdb_printf("mount 0x%p mnext 0x%p mprev 0x%p vnode 0x%p \n",
+		ip->i_mount,
 		ip->i_mnext,
 		ip->i_mprev,
 		XFS_ITOV_NULL(ip));
Index: 2.6.x-xfs-new/fs/xfs/xfs_clnt.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_clnt.h	2007-08-01 10:36:25.915305171 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_clnt.h	2007-08-01 15:43:34.174942368 +1000
@@ -89,7 +89,6 @@ struct xfs_mount_args {
 #define XFSMNT_IDELETE		0x08000000	/* inode cluster delete */
 #define XFSMNT_SWALLOC		0x10000000	/* turn on stripe width
 						 * allocation */
-#define XFSMNT_IHASHSIZE	0x20000000	/* inode hash table size */
 #define XFSMNT_DIRSYNC		0x40000000	/* sync creat,link,unlink,rename
 						 * symlink,mkdir,rmdir,mknod */
 #define XFSMNT_FLAGS2		0x80000000	/* more flags set in flags2 */
