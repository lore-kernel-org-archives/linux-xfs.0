Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2D8rBlY230775 for <xfs@oss.sgi.com>; Tue, 13 Mar 2012 03:53:11 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	OpBZFsP84eeOFNRW (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Mar 2012 01:53:09 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1S7NTg-0002cH-Ly
	for xfs@oss.sgi.com; Tue, 13 Mar 2012 08:53:08 +0000
Message-Id: <20120313085308.631894051@bombadil.infradead.org>
Date: Tue, 13 Mar 2012 04:52:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/5] xfs: per-filesystem dquot LRU lists
References: <20120313085232.134690907@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-quota-per-mount-lru-2
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

Replace the global dquot lru lists with a per-filesystem one.

Note that the shrinker isn't wire up to the per-superblock VFS shrinker
infrastructure as would have problems summing up and splitting the counts
for inodes and dquots.  I don't think this is a major problem as the quota
cache isn't as interwinded with the inode cache as the dentry cache is,
because an inode that is dropped from the cache will generally release
a dquot reference, but most of the time it won't be the last one.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_dquot.c |   85 +++++++++++++++++++++++++++--------------------------
 fs/xfs/xfs_dquot.h |    2 -
 fs/xfs/xfs_qm.c    |   59 +++++++++++++++---------------------
 fs/xfs/xfs_qm.h    |    7 ++--
 4 files changed, 74 insertions(+), 79 deletions(-)

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2012-03-12 14:04:41.123336674 +0100
+++ xfs/fs/xfs/xfs_dquot.c	2012-03-13 09:37:23.186787717 +0100
@@ -47,7 +47,7 @@
  *     qi->qi_dqlist_lock
  *       dquot->q_qlock (xfs_dqlock() and friends)
  *         dquot->q_flush (xfs_dqflock() and friends)
- *         xfs_Gqm->qm_dqfrlist_lock
+ *         qi->qi_lru_lock
  *
  * If two dquots need to be locked the order is user before group/project,
  * otherwise by the lowest id first, see xfs_dqlock2.
@@ -69,7 +69,7 @@ void
 xfs_qm_dqdestroy(
 	xfs_dquot_t	*dqp)
 {
-	ASSERT(list_empty(&dqp->q_freelist));
+	ASSERT(list_empty(&dqp->q_lru));
 
 	mutex_destroy(&dqp->q_qlock);
 	kmem_zone_free(xfs_Gqm->qm_dqzone, dqp);
@@ -497,7 +497,7 @@ xfs_qm_dqread(
 	dqp->dq_flags = type;
 	dqp->q_core.d_id = cpu_to_be32(id);
 	dqp->q_mount = mp;
-	INIT_LIST_HEAD(&dqp->q_freelist);
+	INIT_LIST_HEAD(&dqp->q_lru);
 	mutex_init(&dqp->q_qlock);
 	init_waitqueue_head(&dqp->q_pinwait);
 
@@ -844,38 +844,22 @@ restart:
 }
 
 
-/*
- * Release a reference to the dquot (decrement ref-count)
- * and unlock it. If there is a group quota attached to this
- * dquot, carefully release that too without tripping over
- * deadlocks'n'stuff.
- */
-void
-xfs_qm_dqput(
+STATIC void
+xfs_qm_dqput_final(
 	struct xfs_dquot	*dqp)
 {
+	struct xfs_quotainfo	*qi = dqp->q_mount->m_quotainfo;
 	struct xfs_dquot	*gdqp;
 
-	ASSERT(dqp->q_nrefs > 0);
-	ASSERT(XFS_DQ_IS_LOCKED(dqp));
-
-	trace_xfs_dqput(dqp);
-
-recurse:
-	if (--dqp->q_nrefs > 0) {
-		xfs_dqunlock(dqp);
-		return;
-	}
-
 	trace_xfs_dqput_free(dqp);
 
-	mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
-	if (list_empty(&dqp->q_freelist)) {
-		list_add_tail(&dqp->q_freelist, &xfs_Gqm->qm_dqfrlist);
-		xfs_Gqm->qm_dqfrlist_cnt++;
+	mutex_lock(&qi->qi_lru_lock);
+	if (list_empty(&dqp->q_lru)) {
+		list_add_tail(&dqp->q_lru, &qi->qi_lru_list);
+		qi->qi_lru_count++;
 		XFS_STATS_INC(xs_qm_dquot_unused);
 	}
-	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
+	mutex_unlock(&qi->qi_lru_lock);
 
 	/*
 	 * If we just added a udquot to the freelist, then we want to release
@@ -892,10 +876,29 @@ recurse:
 	/*
 	 * If we had a group quota hint, release it now.
 	 */
-	if (gdqp) {
-		dqp = gdqp;
-		goto recurse;
-	}
+	if (gdqp)
+		xfs_qm_dqput(gdqp);
+}
+
+/*
+ * Release a reference to the dquot (decrement ref-count) and unlock it.
+ *
+ * If there is a group quota attached to this dquot, carefully release that
+ * too without tripping over deadlocks'n'stuff.
+ */
+void
+xfs_qm_dqput(
+	struct xfs_dquot	*dqp)
+{
+	ASSERT(dqp->q_nrefs > 0);
+	ASSERT(XFS_DQ_IS_LOCKED(dqp));
+
+	trace_xfs_dqput(dqp);
+
+	if (--dqp->q_nrefs > 0)
+		xfs_dqunlock(dqp);
+	else
+		xfs_qm_dqput_final(dqp);
 }
 
 /*
@@ -1115,6 +1118,7 @@ xfs_qm_dqpurge(
 {
 	struct xfs_mount	*mp = dqp->q_mount;
 	struct xfs_dqhash	*qh = dqp->q_hash;
+	struct xfs_quotainfo	*qi = mp->m_quotainfo;
 
 	xfs_dqlock(dqp);
 
@@ -1165,22 +1169,22 @@ xfs_qm_dqpurge(
 	qh->qh_version++;
 	mutex_unlock(&qh->qh_lock);
 
-	mutex_lock(&mp->m_quotainfo->qi_dqlist_lock);
+	mutex_lock(&qi->qi_dqlist_lock);
 	list_del_init(&dqp->q_mplist);
-	mp->m_quotainfo->qi_dqreclaims++;
-	mp->m_quotainfo->qi_dquots--;
-	mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
+	qi->qi_dqreclaims++;
+	qi->qi_dquots--;
+	mutex_unlock(&qi->qi_dqlist_lock);
 
 	/*
 	 * We move dquots to the freelist as soon as their reference count
 	 * hits zero, so it really should be on the freelist here.
 	 */
-	mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
-	ASSERT(!list_empty(&dqp->q_freelist));
-	list_del_init(&dqp->q_freelist);
-	xfs_Gqm->qm_dqfrlist_cnt--;
+	mutex_lock(&qi->qi_lru_lock);
+	ASSERT(!list_empty(&dqp->q_lru));
+	list_del_init(&dqp->q_lru);
+	qi->qi_lru_count--;
 	XFS_STATS_DEC(xs_qm_dquot_unused);
-	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
+	mutex_unlock(&qi->qi_lru_lock);
 
 	xfs_qm_dqdestroy(dqp);
 }
Index: xfs/fs/xfs/xfs_dquot.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.h	2012-03-12 09:26:54.216721892 +0100
+++ xfs/fs/xfs/xfs_dquot.h	2012-03-13 09:36:10.070119695 +0100
@@ -47,7 +47,7 @@ struct xfs_trans;
  */
 typedef struct xfs_dquot {
 	uint		 dq_flags;	/* various flags (XFS_DQ_*) */
-	struct list_head q_freelist;	/* global free list of dquots */
+	struct list_head q_lru;		/* global free list of dquots */
 	struct list_head q_mplist;	/* mount's list of dquots */
 	struct list_head q_hashlist;	/* gloabl hash list of dquots */
 	xfs_dqhash_t	*q_hash;	/* the hashchain header */
Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2012-03-12 14:04:41.126670008 +0100
+++ xfs/fs/xfs/xfs_qm.c	2012-03-13 09:36:10.036786361 +0100
@@ -61,11 +61,6 @@ STATIC int	xfs_qm_init_quotainos(xfs_mou
 STATIC int	xfs_qm_init_quotainfo(xfs_mount_t *);
 STATIC int	xfs_qm_shake(struct shrinker *, struct shrink_control *);
 
-static struct shrinker xfs_qm_shaker = {
-	.shrink = xfs_qm_shake,
-	.seeks = DEFAULT_SEEKS,
-};
-
 /*
  * Initialize the XQM structure.
  * Note that there is not one quota manager per file system.
@@ -106,13 +101,6 @@ xfs_Gqm_init(void)
 	}
 
 	/*
-	 * Freelist of all dquots of all file systems
-	 */
-	INIT_LIST_HEAD(&xqm->qm_dqfrlist);
-	xqm->qm_dqfrlist_cnt = 0;
-	mutex_init(&xqm->qm_dqfrlist_lock);
-
-	/*
 	 * dquot zone. we register our own low-memory callback.
 	 */
 	if (!qm_dqzone) {
@@ -122,8 +110,6 @@ xfs_Gqm_init(void)
 	} else
 		xqm->qm_dqzone = qm_dqzone;
 
-	register_shrinker(&xfs_qm_shaker);
-
 	/*
 	 * The t_dqinfo portion of transactions.
 	 */
@@ -155,12 +141,6 @@ xfs_qm_destroy(
 	ASSERT(xqm != NULL);
 	ASSERT(xqm->qm_nrefs == 0);
 
-	unregister_shrinker(&xfs_qm_shaker);
-
-	mutex_lock(&xqm->qm_dqfrlist_lock);
-	ASSERT(list_empty(&xqm->qm_dqfrlist));
-	mutex_unlock(&xqm->qm_dqfrlist_lock);
-
 	hsize = xqm->qm_dqhashmask + 1;
 	for (i = 0; i < hsize; i++) {
 		xfs_qm_list_destroy(&(xqm->qm_usr_dqhtable[i]));
@@ -826,6 +806,10 @@ xfs_qm_init_quotainfo(
 	mutex_init(&qinf->qi_dqlist_lock);
 	lockdep_set_class(&qinf->qi_dqlist_lock, &xfs_quota_mplist_class);
 
+	INIT_LIST_HEAD(&qinf->qi_lru_list);
+	qinf->qi_lru_count = 0;
+	mutex_init(&qinf->qi_lru_lock);
+
 	qinf->qi_dqreclaims = 0;
 
 	/* mutex used to serialize quotaoffs */
@@ -893,6 +877,9 @@ xfs_qm_init_quotainfo(
 		qinf->qi_rtbwarnlimit = XFS_QM_RTBWARNLIMIT;
 	}
 
+	qinf->qi_shrinker.shrink = xfs_qm_shake;
+	qinf->qi_shrinker.seeks = DEFAULT_SEEKS;
+	register_shrinker(&qinf->qi_shrinker);
 	return 0;
 }
 
@@ -912,6 +899,8 @@ xfs_qm_destroy_quotainfo(
 	ASSERT(qi != NULL);
 	ASSERT(xfs_Gqm != NULL);
 
+	unregister_shrinker(&qi->qi_shrinker);
+
 	/*
 	 * Release the reference that XQM kept, so that we know
 	 * when the XQM structure should be freed. We cannot assume
@@ -1623,6 +1612,7 @@ xfs_qm_dqreclaim_one(
 	struct list_head	*dispose_list)
 {
 	struct xfs_mount	*mp = dqp->q_mount;
+	struct xfs_quotainfo	*qi = mp->m_quotainfo;
 	int			error;
 
 	if (!xfs_dqlock_nowait(dqp))
@@ -1638,8 +1628,8 @@ xfs_qm_dqreclaim_one(
 		trace_xfs_dqreclaim_want(dqp);
 		XFS_STATS_INC(xs_qm_dqwants);
 
-		list_del_init(&dqp->q_freelist);
-		xfs_Gqm->qm_dqfrlist_cnt--;
+		list_del_init(&dqp->q_lru);
+		qi->qi_lru_count--;
 		XFS_STATS_DEC(xs_qm_dquot_unused);
 		return;
 	}
@@ -1688,8 +1678,8 @@ xfs_qm_dqreclaim_one(
 	xfs_dqunlock(dqp);
 
 	ASSERT(dqp->q_nrefs == 0);
-	list_move_tail(&dqp->q_freelist, dispose_list);
-	xfs_Gqm->qm_dqfrlist_cnt--;
+	list_move_tail(&dqp->q_lru, dispose_list);
+	qi->qi_lru_count--;
 	XFS_STATS_DEC(xs_qm_dquot_unused);
 
 	trace_xfs_dqreclaim_done(dqp);
@@ -1702,7 +1692,7 @@ out_busy:
 	/*
 	 * Move the dquot to the tail of the list so that we don't spin on it.
 	 */
-	list_move_tail(&dqp->q_freelist, &xfs_Gqm->qm_dqfrlist);
+	list_move_tail(&dqp->q_lru, &qi->qi_lru_list);
 
 	trace_xfs_dqreclaim_busy(dqp);
 	XFS_STATS_INC(xs_qm_dqreclaim_misses);
@@ -1713,6 +1703,8 @@ xfs_qm_shake(
 	struct shrinker		*shrink,
 	struct shrink_control	*sc)
 {
+	struct xfs_quotainfo	*qi =
+		container_of(shrink, struct xfs_quotainfo, qi_shrinker);
 	int			nr_to_scan = sc->nr_to_scan;
 	LIST_HEAD		(dispose_list);
 	struct xfs_dquot	*dqp;
@@ -1722,24 +1714,23 @@ xfs_qm_shake(
 	if (!nr_to_scan)
 		goto out;
 
-	mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
-	while (!list_empty(&xfs_Gqm->qm_dqfrlist)) {
+	mutex_lock(&qi->qi_lru_lock);
+	while (!list_empty(&qi->qi_lru_list)) {
 		if (nr_to_scan-- <= 0)
 			break;
-		dqp = list_first_entry(&xfs_Gqm->qm_dqfrlist, struct xfs_dquot,
-				       q_freelist);
+		dqp = list_first_entry(&qi->qi_lru_list, struct xfs_dquot,
+				       q_lru);
 		xfs_qm_dqreclaim_one(dqp, &dispose_list);
 	}
-	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
+	mutex_unlock(&qi->qi_lru_lock);
 
 	while (!list_empty(&dispose_list)) {
-		dqp = list_first_entry(&dispose_list, struct xfs_dquot,
-				       q_freelist);
-		list_del_init(&dqp->q_freelist);
+		dqp = list_first_entry(&dispose_list, struct xfs_dquot, q_lru);
+		list_del_init(&dqp->q_lru);
 		xfs_qm_dqfree_one(dqp);
 	}
 out:
-	return (xfs_Gqm->qm_dqfrlist_cnt / 100) * sysctl_vfs_cache_pressure;
+	return (qi->qi_lru_count / 100) * sysctl_vfs_cache_pressure;
 }
 
 /*
Index: xfs/fs/xfs/xfs_qm.h
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.h	2012-03-12 14:04:41.126670008 +0100
+++ xfs/fs/xfs/xfs_qm.h	2012-03-13 09:36:10.046786362 +0100
@@ -56,9 +56,6 @@ typedef struct xfs_qm {
 	xfs_dqlist_t	*qm_usr_dqhtable;/* udquot hash table */
 	xfs_dqlist_t	*qm_grp_dqhtable;/* gdquot hash table */
 	uint		 qm_dqhashmask;	 /* # buckets in dq hashtab - 1 */
-	struct list_head qm_dqfrlist;	 /* freelist of dquots */
-	struct mutex	 qm_dqfrlist_lock;
-	int		 qm_dqfrlist_cnt;
 	uint		 qm_nrefs;	 /* file systems with quota on */
 	kmem_zone_t	*qm_dqzone;	 /* dquot mem-alloc zone */
 	kmem_zone_t	*qm_dqtrxzone;	 /* t_dqinfo of transactions */
@@ -71,6 +68,9 @@ typedef struct xfs_qm {
 typedef struct xfs_quotainfo {
 	xfs_inode_t	*qi_uquotaip;	 /* user quota inode */
 	xfs_inode_t	*qi_gquotaip;	 /* group quota inode */
+	struct list_head qi_lru_list;
+	struct mutex	 qi_lru_lock;
+	int		 qi_lru_count;
 	struct list_head qi_dqlist;	 /* all dquots in filesys */
 	struct mutex	 qi_dqlist_lock;
 	int		 qi_dquots;
@@ -91,6 +91,7 @@ typedef struct xfs_quotainfo {
 	xfs_qcnt_t	 qi_isoftlimit;	 /* default inode count soft limit */
 	xfs_qcnt_t	 qi_rtbhardlimit;/* default realtime blk hard limit */
 	xfs_qcnt_t	 qi_rtbsoftlimit;/* default realtime blk soft limit */
+	struct shrinker  qi_shrinker;
 } xfs_quotainfo_t;
 
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
