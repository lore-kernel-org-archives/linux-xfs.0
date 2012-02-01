Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q11E0hH9253124 for <xfs@oss.sgi.com>; Wed, 1 Feb 2012 08:00:43 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	4nPiDJd7CGXiYr8s (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Feb 2012 06:00:40 -0800 (PST)
Message-Id: <20120201140039.890810863@bombadil.infradead.org>
Date: Wed, 01 Feb 2012 08:57:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/7] xfs: use per-filesystem radix trees for dquot lookup
References: <20120201135719.202171828@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-quota-radix-tree
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

Replace the global hash tables for looking up in-memory dquot structures
with per-filesystem radix trees to allow scaling to a large number of
in-memory dquot structures.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_dquot.c      |  175 ++++++++++--------------------------------------
 fs/xfs/xfs_dquot.h      |   12 ---
 fs/xfs/xfs_qm.c         |   95 ++------------------------
 fs/xfs/xfs_qm.h         |   19 ++---
 fs/xfs/xfs_quota_priv.h |   11 ---
 fs/xfs/xfs_trace.h      |    4 -
 6 files changed, 58 insertions(+), 258 deletions(-)

Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2012-02-01 12:24:27.234457429 +0100
+++ xfs/fs/xfs/xfs_qm.c	2012-02-01 12:25:23.134154595 +0100
@@ -54,9 +54,6 @@ struct xfs_qm	*xfs_Gqm;
 kmem_zone_t	*qm_dqzone;
 kmem_zone_t	*qm_dqtrxzone;
 
-STATIC void	xfs_qm_list_init(xfs_dqlist_t *, char *, int);
-STATIC void	xfs_qm_list_destroy(xfs_dqlist_t *);
-
 STATIC int	xfs_qm_init_quotainos(xfs_mount_t *);
 STATIC int	xfs_qm_init_quotainfo(xfs_mount_t *);
 STATIC int	xfs_qm_shake(struct shrinker *, struct shrink_control *);
@@ -68,37 +65,9 @@ STATIC int	xfs_qm_shake(struct shrinker
 STATIC struct xfs_qm *
 xfs_Gqm_init(void)
 {
-	xfs_dqhash_t	*udqhash, *gdqhash;
 	xfs_qm_t	*xqm;
-	size_t		hsize;
-	uint		i;
-
-	/*
-	 * Initialize the dquot hash tables.
-	 */
-	udqhash = kmem_zalloc_greedy(&hsize,
-				     XFS_QM_HASHSIZE_LOW * sizeof(xfs_dqhash_t),
-				     XFS_QM_HASHSIZE_HIGH * sizeof(xfs_dqhash_t));
-	if (!udqhash)
-		goto out;
-
-	gdqhash = kmem_zalloc_large(hsize);
-	if (!gdqhash)
-		goto out_free_udqhash;
-
-	hsize /= sizeof(xfs_dqhash_t);
 
 	xqm = kmem_zalloc(sizeof(xfs_qm_t), KM_SLEEP);
-	xqm->qm_dqhashmask = hsize - 1;
-	xqm->qm_usr_dqhtable = udqhash;
-	xqm->qm_grp_dqhtable = gdqhash;
-	ASSERT(xqm->qm_usr_dqhtable != NULL);
-	ASSERT(xqm->qm_grp_dqhtable != NULL);
-
-	for (i = 0; i < hsize; i++) {
-		xfs_qm_list_init(&(xqm->qm_usr_dqhtable[i]), "uxdqh", i);
-		xfs_qm_list_init(&(xqm->qm_grp_dqhtable[i]), "gxdqh", i);
-	}
 
 	/*
 	 * dquot zone. we register our own low-memory callback.
@@ -123,11 +92,6 @@ xfs_Gqm_init(void)
 	atomic_set(&xqm->qm_totaldquots, 0);
 	xqm->qm_nrefs = 0;
 	return xqm;
-
- out_free_udqhash:
-	kmem_free_large(udqhash);
- out:
-	return NULL;
 }
 
 /*
@@ -137,22 +101,9 @@ STATIC void
 xfs_qm_destroy(
 	struct xfs_qm	*xqm)
 {
-	int		hsize, i;
-
 	ASSERT(xqm != NULL);
 	ASSERT(xqm->qm_nrefs == 0);
 
-	hsize = xqm->qm_dqhashmask + 1;
-	for (i = 0; i < hsize; i++) {
-		xfs_qm_list_destroy(&(xqm->qm_usr_dqhtable[i]));
-		xfs_qm_list_destroy(&(xqm->qm_grp_dqhtable[i]));
-	}
-	kmem_free_large(xqm->qm_usr_dqhtable);
-	kmem_free_large(xqm->qm_grp_dqhtable);
-	xqm->qm_usr_dqhtable = NULL;
-	xqm->qm_grp_dqhtable = NULL;
-	xqm->qm_dqhashmask = 0;
-
 	kmem_free(xqm);
 }
 
@@ -763,14 +714,6 @@ xfs_qm_dqdetach(
 }
 
 /*
- * The hash chains and the mplist use the same xfs_dqhash structure as
- * their list head, but we can take the mplist qh_lock and one of the
- * hash qh_locks at the same time without any problem as they aren't
- * related.
- */
-static struct lock_class_key xfs_quota_mplist_class;
-
-/*
  * This initializes all the quota information that's kept in the
  * mount structure
  */
@@ -803,9 +746,12 @@ xfs_qm_init_quotainfo(
 		return error;
 	}
 
+	INIT_RADIX_TREE(&qinf->qi_uquota_tree, GFP_NOFS);
+	INIT_RADIX_TREE(&qinf->qi_gquota_tree, GFP_NOFS);
+	mutex_init(&qinf->qi_tree_lock);
+
 	INIT_LIST_HEAD(&qinf->qi_dqlist);
 	mutex_init(&qinf->qi_dqlist_lock);
-	lockdep_set_class(&qinf->qi_dqlist_lock, &xfs_quota_mplist_class);
 
 	INIT_LIST_HEAD(&qinf->qi_lru_list);
 	qinf->qi_lru_count = 0;
@@ -925,30 +871,6 @@ xfs_qm_destroy_quotainfo(
 	mp->m_quotainfo = NULL;
 }
 
-
-
-/* ------------------- PRIVATE STATIC FUNCTIONS ----------------------- */
-
-/* ARGSUSED */
-STATIC void
-xfs_qm_list_init(
-	xfs_dqlist_t	*list,
-	char		*str,
-	int		n)
-{
-	mutex_init(&list->qh_lock);
-	INIT_LIST_HEAD(&list->qh_list);
-	list->qh_version = 0;
-	list->qh_nelems = 0;
-}
-
-STATIC void
-xfs_qm_list_destroy(
-	xfs_dqlist_t	*list)
-{
-	mutex_destroy(&(list->qh_lock));
-}
-
 /*
  * Create an inode and return with a reference already taken, but unlocked
  * This is how we create quota inodes
@@ -1593,10 +1515,10 @@ xfs_qm_dqfree_one(
 	struct xfs_mount	*mp = dqp->q_mount;
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
 
-	mutex_lock(&dqp->q_hash->qh_lock);
-	list_del_init(&dqp->q_hashlist);
-	dqp->q_hash->qh_version++;
-	mutex_unlock(&dqp->q_hash->qh_lock);
+	mutex_lock(&mp->m_quotainfo->qi_tree_lock);
+	radix_tree_delete(XFS_DQUOT_TREE(mp, dqp->q_core.d_flags),
+			  be32_to_cpu(dqp->q_core.d_id));
+	mutex_unlock(&mp->m_quotainfo->qi_tree_lock);
 
 	mutex_lock(&qi->qi_dqlist_lock);
 	list_del_init(&dqp->q_mplist);
@@ -1634,7 +1556,6 @@ xfs_qm_dqreclaim_one(
 		return;
 	}
 
-	ASSERT(dqp->q_hash);
 	ASSERT(!list_empty(&dqp->q_mplist));
 
 	/*
Index: xfs/fs/xfs/xfs_qm.h
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.h	2012-02-01 12:22:12.345188187 +0100
+++ xfs/fs/xfs/xfs_qm.h	2012-02-01 12:24:50.577664301 +0100
@@ -32,12 +32,6 @@ extern kmem_zone_t	*qm_dqzone;
 extern kmem_zone_t	*qm_dqtrxzone;
 
 /*
- * Dquot hashtable constants/threshold values.
- */
-#define XFS_QM_HASHSIZE_LOW		(PAGE_SIZE / sizeof(xfs_dqhash_t))
-#define XFS_QM_HASHSIZE_HIGH		((PAGE_SIZE * 4) / sizeof(xfs_dqhash_t))
-
-/*
  * This defines the unit of allocation of dquots.
  * Currently, it is just one file system block, and a 4K blk contains 30
  * (136 * 30 = 4080) dquots. It's probably not worth trying to make
@@ -48,15 +42,10 @@ extern kmem_zone_t	*qm_dqtrxzone;
  */
 #define XFS_DQUOT_CLUSTER_SIZE_FSB	(xfs_filblks_t)1
 
-typedef xfs_dqhash_t	xfs_dqlist_t;
-
 /*
  * Quota Manager (global) structure. Lives only in core.
  */
 typedef struct xfs_qm {
-	xfs_dqlist_t	*qm_usr_dqhtable;/* udquot hash table */
-	xfs_dqlist_t	*qm_grp_dqhtable;/* gdquot hash table */
-	uint		 qm_dqhashmask;	 /* # buckets in dq hashtab - 1 */
 	atomic_t	 qm_totaldquots; /* total incore dquots */
 	uint		 qm_nrefs;	 /* file systems with quota on */
 	kmem_zone_t	*qm_dqzone;	 /* dquot mem-alloc zone */
@@ -68,6 +57,9 @@ typedef struct xfs_qm {
  * The mount structure keeps a pointer to this.
  */
 typedef struct xfs_quotainfo {
+	struct radix_tree_root qi_uquota_tree;
+	struct radix_tree_root qi_gquota_tree;
+	struct mutex qi_tree_lock;
 	xfs_inode_t	*qi_uquotaip;	 /* user quota inode */
 	xfs_inode_t	*qi_gquotaip;	 /* group quota inode */
 	struct list_head qi_lru_list;
@@ -96,6 +88,11 @@ typedef struct xfs_quotainfo {
 	struct shrinker  qi_shrinker;
 } xfs_quotainfo_t;
 
+#define XFS_DQUOT_TREE(mp, type) \
+	((type & XFS_DQ_USER) ? \
+	 &((mp)->m_quotainfo->qi_uquota_tree) : \
+	 &((mp)->m_quotainfo->qi_gquota_tree))
+
 
 extern void	xfs_trans_mod_dquot(xfs_trans_t *, xfs_dquot_t *, uint, long);
 extern int	xfs_trans_reserve_quota_bydquots(xfs_trans_t *, xfs_mount_t *,
Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2012-02-01 12:22:12.341854872 +0100
+++ xfs/fs/xfs/xfs_dquot.c	2012-02-01 12:24:50.577664301 +0100
@@ -43,7 +43,7 @@
  * Lock order:
  *
  * ip->i_lock
- *   qh->qh_lock
+ *   qi->qi_tree_lock
  *     qi->qi_dqlist_lock
  *       dquot->q_qlock (xfs_dqlock() and friends)
  *         dquot->q_flush (xfs_dqflock() and friends)
@@ -602,60 +602,6 @@ error0:
 }
 
 /*
- * Lookup a dquot in the incore dquot hashtable. We keep two separate
- * hashtables for user and group dquots; and, these are global tables
- * inside the XQM, not per-filesystem tables.
- * The hash chain must be locked by caller, and it is left locked
- * on return. Returning dquot is locked.
- */
-STATIC int
-xfs_qm_dqlookup(
-	xfs_mount_t		*mp,
-	xfs_dqid_t		id,
-	xfs_dqhash_t		*qh,
-	xfs_dquot_t		**O_dqpp)
-{
-	xfs_dquot_t		*dqp;
-
-	ASSERT(mutex_is_locked(&qh->qh_lock));
-
-	/*
-	 * Traverse the hashchain looking for a match
-	 */
-	list_for_each_entry(dqp, &qh->qh_list, q_hashlist) {
-		/*
-		 * We already have the hashlock. We don't need the
-		 * dqlock to look at the id field of the dquot, since the
-		 * id can't be modified without the hashlock anyway.
-		 */
-		if (be32_to_cpu(dqp->q_core.d_id) != id || dqp->q_mount != mp)
-			continue;
-
-		trace_xfs_dqlookup_found(dqp);
-
-		xfs_dqlock(dqp);
-		if (dqp->dq_flags & XFS_DQ_FREEING) {
-			*O_dqpp = NULL;
-			xfs_dqunlock(dqp);
-			return -1;
-		}
-
-		dqp->q_nrefs++;
-
-		/*
-		 * move the dquot to the front of the hashchain
-		 */
-		list_move(&dqp->q_hashlist, &qh->qh_list);
-		trace_xfs_dqlookup_done(dqp);
-		*O_dqpp = dqp;
-		return 0;
-	}
-
-	*O_dqpp = NULL;
-	return 1;
-}
-
-/*
  * Given the file system, inode OR id, and type (UDQUOT/GDQUOT), return a
  * a locked dquot, doing an allocation (if requested) as needed.
  * When both an inode and an id are given, the inode's id takes precedence.
@@ -672,9 +618,8 @@ xfs_qm_dqget(
 	uint		flags,	  /* DQALLOC, DQSUSER, DQREPAIR, DOWARN */
 	xfs_dquot_t	**O_dqpp) /* OUT : locked incore dquot */
 {
+	struct radix_tree_root *tree = XFS_DQUOT_TREE(mp, type);
 	xfs_dquot_t	*dqp;
-	xfs_dqhash_t	*h;
-	uint		version;
 	int		error;
 
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
@@ -683,7 +628,6 @@ xfs_qm_dqget(
 	    (! XFS_IS_GQUOTA_ON(mp) && type == XFS_DQ_GROUP)) {
 		return (ESRCH);
 	}
-	h = XFS_DQ_HASH(mp, id, type);
 
 #ifdef DEBUG
 	if (xfs_do_dqerror) {
@@ -707,34 +651,29 @@ xfs_qm_dqget(
 #endif
 
 restart:
-	mutex_lock(&h->qh_lock);
+	mutex_lock(&mp->m_quotainfo->qi_tree_lock);
+	dqp = radix_tree_lookup(tree, id);
+	if (dqp) {
+		xfs_dqlock(dqp);
+		if (dqp->dq_flags & XFS_DQ_FREEING) {
+			xfs_dqunlock(dqp);
+			mutex_unlock(&mp->m_quotainfo->qi_tree_lock);
+			trace_xfs_dqget_freeing(dqp);
+			delay(1);
+			goto restart;
+		}
 
-	/*
-	 * Look in the cache (hashtable).
-	 * The chain is kept locked during lookup.
-	 */
-	switch (xfs_qm_dqlookup(mp, id, h, O_dqpp)) {
-	case -1:
-		XQM_STATS_INC(xqmstats.xs_qm_dquot_dups);
-		mutex_unlock(&h->qh_lock);
-		delay(1);
-		goto restart;
-	case 0:
+		dqp->q_nrefs++;
+		mutex_unlock(&mp->m_quotainfo->qi_tree_lock);
+
+		trace_xfs_dqget_hit(dqp);
 		XQM_STATS_INC(xqmstats.xs_qm_dqcachehits);
-		/*
-		 * The dquot was found, moved to the front of the chain,
-		 * taken off the freelist if it was on it, and locked
-		 * at this point. Just unlock the hashchain and return.
-		 */
-		ASSERT(*O_dqpp);
-		ASSERT(XFS_DQ_IS_LOCKED(*O_dqpp));
-		mutex_unlock(&h->qh_lock);
-		trace_xfs_dqget_hit(*O_dqpp);
-		return 0;	/* success */
-	default:
-		XQM_STATS_INC(xqmstats.xs_qm_dqcachemisses);
-		break;
+		*O_dqpp = dqp;
+		return 0;
 	}
+	mutex_unlock(&mp->m_quotainfo->qi_tree_lock);
+
+	XQM_STATS_INC(xqmstats.xs_qm_dqcachemisses);
 
 	/*
 	 * Dquot cache miss. We don't want to keep the inode lock across
@@ -745,12 +684,6 @@ restart:
 	 */
 	if (ip)
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	/*
-	 * Save the hashchain version stamp, and unlock the chain, so that
-	 * we don't keep the lock across a disk read
-	 */
-	version = h->qh_version;
-	mutex_unlock(&h->qh_lock);
 
 	error = xfs_qm_dqread(mp, id, type, flags, &dqp);
 
@@ -760,9 +693,6 @@ restart:
 	if (error)
 		return error;
 
-	/*
-	 * Dquot lock comes after hashlock in the lock ordering
-	 */
 	if (ip) {
 		/*
 		 * A dquot could be attached to this inode by now, since
@@ -795,46 +725,21 @@ restart:
 		}
 	}
 
-	/*
-	 * Hashlock comes after ilock in lock order
-	 */
-	mutex_lock(&h->qh_lock);
-	if (version != h->qh_version) {
-		xfs_dquot_t *tmpdqp;
+	mutex_lock(&mp->m_quotainfo->qi_tree_lock);
+	error = -radix_tree_insert(tree, id, dqp);
+	if (unlikely(error)) {
+		WARN_ON(error != EEXIST);
+
 		/*
-		 * Now, see if somebody else put the dquot in the
-		 * hashtable before us. This can happen because we didn't
-		 * keep the hashchain lock. We don't have to worry about
-		 * lock order between the two dquots here since dqp isn't
-		 * on any findable lists yet.
+		 * Duplicate found. Just throw away the new dquot and start
+		 * over.
 		 */
-		switch (xfs_qm_dqlookup(mp, id, h, &tmpdqp)) {
-		case 0:
-		case -1:
-			/*
-			 * Duplicate found, either in cache or on its way out.
-			 * Just throw away the new dquot and start over.
-			 */
-			if (tmpdqp)
-				xfs_qm_dqput(tmpdqp);
-			mutex_unlock(&h->qh_lock);
-			xfs_qm_dqdestroy(dqp);
-			XQM_STATS_INC(xqmstats.xs_qm_dquot_dups);
-			goto restart;
-		default:
-			break;
-		}
+		mutex_unlock(&mp->m_quotainfo->qi_tree_lock);
+		trace_xfs_dqget_dup(dqp);
+		xfs_qm_dqdestroy(dqp);
+		XQM_STATS_INC(xqmstats.xs_qm_dquot_dups);
+		goto restart;
 	}
-
-	/*
-	 * Put the dquot at the beginning of the hash-chain and mp's list
-	 * LOCK ORDER: hashlock, freelistlock, mplistlock, udqlock, gdqlock ..
-	 */
-	ASSERT(mutex_is_locked(&h->qh_lock));
-	dqp->q_hash = h;
-	list_add(&dqp->q_hashlist, &h->qh_list);
-	h->qh_version++;
-
 	/*
 	 * Attach this dquot to this filesystem's list of all dquots,
 	 * kept inside the mount structure in m_quotainfo field
@@ -850,7 +755,8 @@ restart:
 	list_add(&dqp->q_mplist, &mp->m_quotainfo->qi_dqlist);
 	mp->m_quotainfo->qi_dquots++;
 	mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
-	mutex_unlock(&h->qh_lock);
+	mutex_unlock(&mp->m_quotainfo->qi_tree_lock);
+
  dqret:
 	ASSERT((ip == NULL) || xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	trace_xfs_dqget_miss(dqp);
@@ -1139,7 +1045,6 @@ xfs_qm_dqpurge(
 	struct xfs_dquot	*dqp)
 {
 	struct xfs_mount	*mp = dqp->q_mount;
-	struct xfs_dqhash	*qh = dqp->q_hash;
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
 
 	xfs_dqlock(dqp);
@@ -1186,10 +1091,10 @@ xfs_qm_dqpurge(
 	xfs_dqfunlock(dqp);
 	xfs_dqunlock(dqp);
 
-	mutex_lock(&qh->qh_lock);
-	list_del_init(&dqp->q_hashlist);
-	qh->qh_version++;
-	mutex_unlock(&qh->qh_lock);
+	mutex_lock(&mp->m_quotainfo->qi_tree_lock);
+	radix_tree_delete(XFS_DQUOT_TREE(mp, dqp->q_core.d_flags),
+			  be32_to_cpu(dqp->q_core.d_id));
+	mutex_unlock(&mp->m_quotainfo->qi_tree_lock);
 
 	mutex_lock(&qi->qi_dqlist_lock);
 	list_del_init(&dqp->q_mplist);
Index: xfs/fs/xfs/xfs_dquot.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.h	2012-02-01 12:22:12.341854872 +0100
+++ xfs/fs/xfs/xfs_dquot.h	2012-02-01 12:24:50.577664301 +0100
@@ -29,16 +29,6 @@
  * when quotas are off.
  */
 
-/*
- * The hash chain headers (hash buckets)
- */
-typedef struct xfs_dqhash {
-	struct list_head  qh_list;
-	struct mutex	  qh_lock;
-	uint		  qh_version;	/* ever increasing version */
-	uint		  qh_nelems;	/* number of dquots on the list */
-} xfs_dqhash_t;
-
 struct xfs_mount;
 struct xfs_trans;
 
@@ -49,8 +39,6 @@ typedef struct xfs_dquot {
 	uint		 dq_flags;	/* various flags (XFS_DQ_*) */
 	struct list_head q_lru;		/* global free list of dquots */
 	struct list_head q_mplist;	/* mount's list of dquots */
-	struct list_head q_hashlist;	/* gloabl hash list of dquots */
-	xfs_dqhash_t	*q_hash;	/* the hashchain header */
 	struct xfs_mount*q_mount;	/* filesystem this relates to */
 	struct xfs_trans*q_transp;	/* trans this belongs to currently */
 	uint		 q_nrefs;	/* # active refs from inodes */
Index: xfs/fs/xfs/xfs_quota_priv.h
===================================================================
--- xfs.orig/fs/xfs/xfs_quota_priv.h	2012-02-01 12:05:07.000000000 +0100
+++ xfs/fs/xfs/xfs_quota_priv.h	2012-02-01 12:24:50.577664301 +0100
@@ -24,17 +24,6 @@
  */
 #define XFS_DQITER_MAP_SIZE	10
 
-/*
- * Hash into a bucket in the dquot hash table, based on <mp, id>.
- */
-#define XFS_DQ_HASHVAL(mp, id) (((__psunsigned_t)(mp) + \
-				 (__psunsigned_t)(id)) & \
-				(xfs_Gqm->qm_dqhashmask - 1))
-#define XFS_DQ_HASH(mp, id, type)   (type == XFS_DQ_USER ? \
-				     (xfs_Gqm->qm_usr_dqhtable + \
-				      XFS_DQ_HASHVAL(mp, id)) : \
-				     (xfs_Gqm->qm_grp_dqhtable + \
-				      XFS_DQ_HASHVAL(mp, id)))
 #define XFS_IS_DQUOT_UNINITIALIZED(dqp) ( \
 	!dqp->q_core.d_blk_hardlimit && \
 	!dqp->q_core.d_blk_softlimit && \
Index: xfs/fs/xfs/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trace.h	2012-02-01 12:06:55.000000000 +0100
+++ xfs/fs/xfs/xfs_trace.h	2012-02-01 12:24:50.580997617 +0100
@@ -741,10 +741,10 @@ DEFINE_DQUOT_EVENT(xfs_dqalloc);
 DEFINE_DQUOT_EVENT(xfs_dqtobp_read);
 DEFINE_DQUOT_EVENT(xfs_dqread);
 DEFINE_DQUOT_EVENT(xfs_dqread_fail);
-DEFINE_DQUOT_EVENT(xfs_dqlookup_found);
-DEFINE_DQUOT_EVENT(xfs_dqlookup_done);
 DEFINE_DQUOT_EVENT(xfs_dqget_hit);
 DEFINE_DQUOT_EVENT(xfs_dqget_miss);
+DEFINE_DQUOT_EVENT(xfs_dqget_freeing);
+DEFINE_DQUOT_EVENT(xfs_dqget_dup);
 DEFINE_DQUOT_EVENT(xfs_dqput);
 DEFINE_DQUOT_EVENT(xfs_dqput_wait);
 DEFINE_DQUOT_EVENT(xfs_dqput_free);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
