Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q11E0hDJ253138 for <xfs@oss.sgi.com>; Wed, 1 Feb 2012 08:00:44 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	rLj7AOcXY9P6rAuN (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Feb 2012 06:00:40 -0800 (PST)
Message-Id: <20120201140039.512547202@bombadil.infradead.org>
Date: Wed, 01 Feb 2012 08:57:21 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/7] xfs: per-filesystem dquot LRU lists
References: <20120201135719.202171828@bombadil.infradead.org>
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

This patch temporarily stops tracking the system-wide counting of dquots
on the LRU lists for /proc/fs/xfs/xqm, which will be added back later in
the series.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_dquot.c    |   37 +++++++++++++++--------------
 fs/xfs/xfs_dquot.h    |    2 -
 fs/xfs/xfs_qm.c       |   62 +++++++++++++++++++++-----------------------------
 fs/xfs/xfs_qm.h       |    7 +++--
 fs/xfs/xfs_qm_stats.c |    2 -
 5 files changed, 52 insertions(+), 58 deletions(-)

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2012-02-01 12:22:02.135243499 +0100
+++ xfs/fs/xfs/xfs_dquot.c	2012-02-01 12:22:12.341854872 +0100
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
 
@@ -858,7 +858,6 @@ restart:
 	return (0);
 }
 
-
 /*
  * Release a reference to the dquot (decrement ref-count)
  * and unlock it. If there is a group quota attached to this
@@ -884,12 +883,13 @@ recurse:
 
 	trace_xfs_dqput_free(dqp);
 
-	mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
-	if (list_empty(&dqp->q_freelist)) {
-		list_add_tail(&dqp->q_freelist, &xfs_Gqm->qm_dqfrlist);
-		xfs_Gqm->qm_dqfrlist_cnt++;
+	mutex_lock(&dqp->q_mount->m_quotainfo->qi_lru_lock);
+	if (list_empty(&dqp->q_lru)) {
+		list_add_tail(&dqp->q_lru,
+			      &dqp->q_mount->m_quotainfo->qi_lru_list);
+		dqp->q_mount->m_quotainfo->qi_lru_count++;
 	}
-	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
+	mutex_unlock(&dqp->q_mount->m_quotainfo->qi_lru_lock);
 
 	/*
 	 * If we just added a udquot to the freelist, then we want to release
@@ -1140,6 +1140,7 @@ xfs_qm_dqpurge(
 {
 	struct xfs_mount	*mp = dqp->q_mount;
 	struct xfs_dqhash	*qh = dqp->q_hash;
+	struct xfs_quotainfo	*qi = mp->m_quotainfo;
 
 	xfs_dqlock(dqp);
 
@@ -1190,21 +1191,21 @@ xfs_qm_dqpurge(
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
-	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
+	mutex_lock(&qi->qi_lru_lock);
+	ASSERT(!list_empty(&dqp->q_lru));
+	list_del_init(&dqp->q_lru);
+	qi->qi_lru_count--;
+	mutex_unlock(&qi->qi_lru_lock);
 
 	xfs_qm_dqdestroy(dqp);
 }
Index: xfs/fs/xfs/xfs_dquot.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.h	2012-02-01 12:22:02.000000000 +0100
+++ xfs/fs/xfs/xfs_dquot.h	2012-02-01 12:22:12.341854872 +0100
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
--- xfs.orig/fs/xfs/xfs_qm.c	2012-02-01 12:22:08.051878113 +0100
+++ xfs/fs/xfs/xfs_qm.c	2012-02-01 12:24:27.234457429 +0100
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
@@ -156,12 +142,6 @@ xfs_qm_destroy(
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
@@ -827,6 +807,10 @@ xfs_qm_init_quotainfo(
 	mutex_init(&qinf->qi_dqlist_lock);
 	lockdep_set_class(&qinf->qi_dqlist_lock, &xfs_quota_mplist_class);
 
+	INIT_LIST_HEAD(&qinf->qi_lru_list);
+	qinf->qi_lru_count = 0;
+	mutex_init(&qinf->qi_lru_lock);
+
 	qinf->qi_dqreclaims = 0;
 
 	/* mutex used to serialize quotaoffs */
@@ -894,6 +878,9 @@ xfs_qm_init_quotainfo(
 		qinf->qi_rtbwarnlimit = XFS_QM_RTBWARNLIMIT;
 	}
 
+	qinf->qi_shrinker.shrink = xfs_qm_shake;
+	qinf->qi_shrinker.seeks = DEFAULT_SEEKS;
+	register_shrinker(&qinf->qi_shrinker);
 	return 0;
 }
 
@@ -913,6 +900,8 @@ xfs_qm_destroy_quotainfo(
 	ASSERT(qi != NULL);
 	ASSERT(xfs_Gqm != NULL);
 
+	unregister_shrinker(&qi->qi_shrinker);
+
 	/*
 	 * Release the reference that XQM kept, so that we know
 	 * when the XQM structure should be freed. We cannot assume
@@ -1624,6 +1613,7 @@ xfs_qm_dqreclaim_one(
 	struct list_head	*dispose_list)
 {
 	struct xfs_mount	*mp = dqp->q_mount;
+	struct xfs_quotainfo	*qi = mp->m_quotainfo;
 	int			error;
 
 	if (!xfs_dqlock_nowait(dqp))
@@ -1639,8 +1629,8 @@ xfs_qm_dqreclaim_one(
 		trace_xfs_dqreclaim_want(dqp);
 		XQM_STATS_INC(xqmstats.xs_qm_dqwants);
 
-		list_del_init(&dqp->q_freelist);
-		xfs_Gqm->qm_dqfrlist_cnt--;
+		list_del_init(&dqp->q_lru);
+		qi->qi_lru_count--;
 		return;
 	}
 
@@ -1688,8 +1678,8 @@ xfs_qm_dqreclaim_one(
 	xfs_dqunlock(dqp);
 
 	ASSERT(dqp->q_nrefs == 0);
-	list_move_tail(&dqp->q_freelist, dispose_list);
-	xfs_Gqm->qm_dqfrlist_cnt--;
+	list_move_tail(&dqp->q_lru, dispose_list);
+	qi->qi_lru_count--;
 
 	trace_xfs_dqreclaim_done(dqp);
 	XQM_STATS_INC(xqmstats.xs_qm_dqreclaims);
@@ -1701,7 +1691,7 @@ out_busy:
 	/*
 	 * Move the dquot to the tail of the list so that we don't spin on it.
 	 */
-	list_move_tail(&dqp->q_freelist, &xfs_Gqm->qm_dqfrlist);
+	list_move_tail(&dqp->q_lru, &qi->qi_lru_list);
 
 	trace_xfs_dqreclaim_busy(dqp);
 	XQM_STATS_INC(xqmstats.xs_qm_dqreclaim_misses);
@@ -1712,6 +1702,8 @@ xfs_qm_shake(
 	struct shrinker		*shrink,
 	struct shrink_control	*sc)
 {
+	struct xfs_quotainfo	*qi =
+		container_of(shrink, struct xfs_quotainfo, qi_shrinker);
 	int			nr_to_scan = sc->nr_to_scan;
 	LIST_HEAD		(dispose_list);
 	struct xfs_dquot	*dqp;
@@ -1721,24 +1713,23 @@ xfs_qm_shake(
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
--- xfs.orig/fs/xfs/xfs_qm.h	2012-02-01 12:22:02.000000000 +0100
+++ xfs/fs/xfs/xfs_qm.h	2012-02-01 12:22:12.345188187 +0100
@@ -57,9 +57,6 @@ typedef struct xfs_qm {
 	xfs_dqlist_t	*qm_usr_dqhtable;/* udquot hash table */
 	xfs_dqlist_t	*qm_grp_dqhtable;/* gdquot hash table */
 	uint		 qm_dqhashmask;	 /* # buckets in dq hashtab - 1 */
-	struct list_head qm_dqfrlist;	 /* freelist of dquots */
-	struct mutex	 qm_dqfrlist_lock;
-	int		 qm_dqfrlist_cnt;
 	atomic_t	 qm_totaldquots; /* total incore dquots */
 	uint		 qm_nrefs;	 /* file systems with quota on */
 	kmem_zone_t	*qm_dqzone;	 /* dquot mem-alloc zone */
@@ -73,6 +70,9 @@ typedef struct xfs_qm {
 typedef struct xfs_quotainfo {
 	xfs_inode_t	*qi_uquotaip;	 /* user quota inode */
 	xfs_inode_t	*qi_gquotaip;	 /* group quota inode */
+	struct list_head qi_lru_list;
+	struct mutex	 qi_lru_lock;
+	int		 qi_lru_count;
 	struct list_head qi_dqlist;	 /* all dquots in filesys */
 	struct mutex	 qi_dqlist_lock;
 	int		 qi_dquots;
@@ -93,6 +93,7 @@ typedef struct xfs_quotainfo {
 	xfs_qcnt_t	 qi_isoftlimit;	 /* default inode count soft limit */
 	xfs_qcnt_t	 qi_rtbhardlimit;/* default realtime blk hard limit */
 	xfs_qcnt_t	 qi_rtbsoftlimit;/* default realtime blk soft limit */
+	struct shrinker  qi_shrinker;
 } xfs_quotainfo_t;
 
 
Index: xfs/fs/xfs/xfs_qm_stats.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm_stats.c	2012-02-01 12:22:02.000000000 +0100
+++ xfs/fs/xfs/xfs_qm_stats.c	2012-02-01 12:22:12.345188187 +0100
@@ -45,7 +45,7 @@ static int xqm_proc_show(struct seq_file
 			0,
 			xfs_Gqm? atomic_read(&xfs_Gqm->qm_totaldquots) : 0,
 			0,
-			xfs_Gqm? xfs_Gqm->qm_dqfrlist_cnt : 0);
+			0);
 	return 0;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
