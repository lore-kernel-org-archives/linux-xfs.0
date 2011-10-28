Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9SA3iTE145554 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 05:03:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5AF5DFCE488
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 03:03:41 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	YoPQRoLTuPdvDWR6 for <xfs@oss.sgi.com>;
	Fri, 28 Oct 2011 03:03:41 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RJjHp-00037O-EC
	for xfs@oss.sgi.com; Fri, 28 Oct 2011 10:03:41 +0000
Message-Id: <20111028100341.388182220@bombadil.infradead.org>
Date: Fri, 28 Oct 2011 05:54:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 32/45] xfs: use a normal shrinker for the dquot freelist
References: <20111028095423.796574703@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-quota-fix-shrinker
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

Stop reusing dquots from the freelist when allocating new ones directly, and
implement a shrinker that actually follows the specifications for the
interface.  The shrinker implementation is still highly suboptimal at this
point, but we can gradually work on it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/kmem.h         |    6 -
 fs/xfs/xfs_dquot.c    |  103 ++++---------------
 fs/xfs/xfs_qm.c       |  271 ++++++++++++++++----------------------------------
 fs/xfs/xfs_qm.h       |    9 -
 fs/xfs/xfs_qm_stats.c |    4 
 fs/xfs/xfs_trace.h    |    2 
 6 files changed, 120 insertions(+), 275 deletions(-)

Index: xfs/fs/xfs/kmem.h
===================================================================
--- xfs.orig/fs/xfs/kmem.h	2011-10-27 22:39:33.216674214 +0200
+++ xfs/fs/xfs/kmem.h	2011-10-27 22:40:08.594173542 +0200
@@ -115,10 +115,4 @@ kmem_zone_destroy(kmem_zone_t *zone)
 extern void *kmem_zone_alloc(kmem_zone_t *, unsigned int __nocast);
 extern void *kmem_zone_zalloc(kmem_zone_t *, unsigned int __nocast);
 
-static inline int
-kmem_shake_allow(gfp_t gfp_mask)
-{
-	return ((gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS));
-}
-
 #endif /* __XFS_SUPPORT_KMEM_H__ */
Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2011-10-27 22:40:08.124671538 +0200
+++ xfs/fs/xfs/xfs_qm.c	2011-10-27 22:40:08.594173542 +0200
@@ -50,7 +50,6 @@
  */
 struct mutex	xfs_Gqm_lock;
 struct xfs_qm	*xfs_Gqm;
-uint		ndquot;
 
 kmem_zone_t	*qm_dqzone;
 kmem_zone_t	*qm_dqtrxzone;
@@ -93,7 +92,6 @@ xfs_Gqm_init(void)
 		goto out_free_udqhash;
 
 	hsize /= sizeof(xfs_dqhash_t);
-	ndquot = hsize << 8;
 
 	xqm = kmem_zalloc(sizeof(xfs_qm_t), KM_SLEEP);
 	xqm->qm_dqhashmask = hsize - 1;
@@ -137,7 +135,6 @@ xfs_Gqm_init(void)
 		xqm->qm_dqtrxzone = qm_dqtrxzone;
 
 	atomic_set(&xqm->qm_totaldquots, 0);
-	xqm->qm_dqfree_ratio = XFS_QM_DQFREE_RATIO;
 	xqm->qm_nrefs = 0;
 	return xqm;
 
@@ -1600,214 +1597,130 @@ xfs_qm_init_quotainos(
 	return 0;
 }
 
+STATIC bool
+xfs_qm_dqreclaim_one(
+	struct xfs_dquot	*dqp)
+{
+	struct xfs_mount	*mp = dqp->q_mount;
+	int			error;
 
+	/*
+	 * Move the dquot to the tail so that we don't spin on it.
+	 */
+	if (!xfs_dqlock_nowait(dqp))
+		goto out_busy;
 
-/*
- * Pop the least recently used dquot off the freelist and recycle it.
- */
-STATIC struct xfs_dquot *
-xfs_qm_dqreclaim_one(void)
-{
-	struct xfs_dquot	*dqp;
-	int			restarts = 0;
+	/*
+	 * This dquot has already been grabbed by dqlookup.
+	 * Remove it from the freelist and try again.
+	 */
+	if (dqp->q_nrefs) {
+		xfs_dqunlock(dqp);
 
-	mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
-restart:
-	list_for_each_entry(dqp, &xfs_Gqm->qm_dqfrlist, q_freelist) {
-		struct xfs_mount *mp = dqp->q_mount;
+		trace_xfs_dqreclaim_want(dqp);
+		XQM_STATS_INC(xqmstats.xs_qm_dqwants);
 
-		if (!xfs_dqlock_nowait(dqp))
-			continue;
+		list_del_init(&dqp->q_freelist);
+		xfs_Gqm->qm_dqfrlist_cnt--;
+		return true;
+	}
 
-		/*
-		 * This dquot has already been grabbed by dqlookup.
-		 * Remove it from the freelist and try again.
-		 */
-		if (dqp->q_nrefs) {
-			trace_xfs_dqreclaim_want(dqp);
-			XQM_STATS_INC(xqmstats.xs_qm_dqwants);
-
-			list_del_init(&dqp->q_freelist);
-			xfs_Gqm->qm_dqfrlist_cnt--;
-			restarts++;
-			goto dqunlock;
-		}
+	ASSERT(dqp->q_hash);
+	ASSERT(!list_empty(&dqp->q_mplist));
 
-		ASSERT(dqp->q_hash);
-		ASSERT(!list_empty(&dqp->q_mplist));
+	/*
+	 * Try to grab the flush lock. If this dquot is in the process of
+	 * getting flushed to disk, we don't want to reclaim it.
+	 */
+	if (!xfs_dqflock_nowait(dqp))
+		goto out_busy;
 
-		/*
-		 * Try to grab the flush lock. If this dquot is in the process
-		 * of getting flushed to disk, we don't want to reclaim it.
-		 */
-		if (!xfs_dqflock_nowait(dqp))
-			goto dqunlock;
+	/*
+	 * We have the flush lock so we know that this is not in the
+	 * process of being flushed. So, if this is dirty, flush it
+	 * DELWRI so that we don't get a freelist infested with
+	 * dirty dquots.
+	 */
+	if (XFS_DQ_IS_DIRTY(dqp)) {
+		trace_xfs_dqreclaim_dirty(dqp);
 
 		/*
-		 * We have the flush lock so we know that this is not in the
-		 * process of being flushed. So, if this is dirty, flush it
-		 * DELWRI so that we don't get a freelist infested with
-		 * dirty dquots.
+		 * We flush it delayed write, so don't bother releasing the
+		 * freelist lock.
 		 */
-		if (XFS_DQ_IS_DIRTY(dqp)) {
-			int	error;
-
-			trace_xfs_dqreclaim_dirty(dqp);
-
-			/*
-			 * We flush it delayed write, so don't bother
-			 * releasing the freelist lock.
-			 */
-			error = xfs_qm_dqflush(dqp, 0);
-			if (error) {
-				xfs_warn(mp, "%s: dquot %p flush failed",
-					__func__, dqp);
-			}
-			goto dqunlock;
+		error = xfs_qm_dqflush(dqp, 0);
+		if (error) {
+			xfs_warn(mp, "%s: dquot %p flush failed",
+				 __func__, dqp);
 		}
-		xfs_dqfunlock(dqp);
 
 		/*
-		 * Prevent lookups now that we are past the point of no return.
+		 * Give the dquot another try on the freelist, as the
+		 * flushing will take some time.
 		 */
-		dqp->dq_flags |= XFS_DQ_FREEING;
-		xfs_dqunlock(dqp);
-
-		mutex_lock(&dqp->q_hash->qh_lock);
-		list_del_init(&dqp->q_hashlist);
-		dqp->q_hash->qh_version++;
-		mutex_unlock(&dqp->q_hash->qh_lock);
-
-		mutex_lock(&mp->m_quotainfo->qi_dqlist_lock);
-		list_del_init(&dqp->q_mplist);
-		mp->m_quotainfo->qi_dquots--;
-		mp->m_quotainfo->qi_dqreclaims++;
-		mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
-
-		ASSERT(dqp->q_nrefs == 0);
-		list_del_init(&dqp->q_freelist);
-		xfs_Gqm->qm_dqfrlist_cnt--;
-
-		mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
-		return dqp;
-dqunlock:
-		xfs_dqunlock(dqp);
-		if (restarts >= XFS_QM_RECLAIM_MAX_RESTARTS)
-			break;
-		goto restart;
+		goto out_busy;
 	}
+	xfs_dqfunlock(dqp);
 
-	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
-	return NULL;
-}
+	/*
+	 * Prevent lookups now that we are past the point of no return.
+	 */
+	dqp->dq_flags |= XFS_DQ_FREEING;
+	xfs_dqunlock(dqp);
 
-/*
- * Traverse the freelist of dquots and attempt to reclaim a maximum of
- * 'howmany' dquots. This operation races with dqlookup(), and attempts to
- * favor the lookup function ...
- */
-STATIC int
-xfs_qm_shake_freelist(
-	int	howmany)
-{
-	int		nreclaimed = 0;
-	xfs_dquot_t	*dqp;
+	mutex_lock(&dqp->q_hash->qh_lock);
+	list_del_init(&dqp->q_hashlist);
+	dqp->q_hash->qh_version++;
+	mutex_unlock(&dqp->q_hash->qh_lock);
+
+	mutex_lock(&mp->m_quotainfo->qi_dqlist_lock);
+	list_del_init(&dqp->q_mplist);
+	mp->m_quotainfo->qi_dquots--;
+	mp->m_quotainfo->qi_dqreclaims++;
+	mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
+
+	ASSERT(dqp->q_nrefs == 0);
+	list_del_init(&dqp->q_freelist);
+	xfs_Gqm->qm_dqfrlist_cnt--;
+	XQM_STATS_INC(xqmstats.xs_qm_dqreclaims);
 
-	if (howmany <= 0)
-		return 0;
+	xfs_qm_dqdestroy(dqp);
+	return true;
 
-	while (nreclaimed < howmany) {
-		dqp = xfs_qm_dqreclaim_one();
-		if (!dqp)
-			return nreclaimed;
-		xfs_qm_dqdestroy(dqp);
-		nreclaimed++;
-	}
-	return nreclaimed;
+out_busy:
+	xfs_dqunlock(dqp);
+	return false;
 }
 
-/*
- * The kmem_shake interface is invoked when memory is running low.
- */
-/* ARGSUSED */
 STATIC int
 xfs_qm_shake(
-	struct shrinker	*shrink,
-	struct shrink_control *sc)
+	struct shrinker		*shrink,
+	struct shrink_control	*sc)
 {
-	int	ndqused, nfree, n;
-	gfp_t gfp_mask = sc->gfp_mask;
-
-	if (!kmem_shake_allow(gfp_mask))
-		return 0;
-	if (!xfs_Gqm)
-		return 0;
-
-	nfree = xfs_Gqm->qm_dqfrlist_cnt; /* free dquots */
-	/* incore dquots in all f/s's */
-	ndqused = atomic_read(&xfs_Gqm->qm_totaldquots) - nfree;
-
-	ASSERT(ndqused >= 0);
+	int			nr_to_scan = sc->nr_to_scan;
+	struct xfs_dquot	*dqp;
 
-	if (nfree <= ndqused && nfree < ndquot)
+	if ((sc->gfp_mask & (__GFP_FS|__GFP_WAIT)) != (__GFP_FS|__GFP_WAIT))
 		return 0;
 
-	ndqused *= xfs_Gqm->qm_dqfree_ratio;	/* target # of free dquots */
-	n = nfree - ndqused - ndquot;		/* # over target */
-
-	return xfs_qm_shake_freelist(MAX(nfree, n));
-}
-
-
-/*------------------------------------------------------------------*/
+	if (!nr_to_scan)
+		goto out;
 
-/*
- * Return a new incore dquot. Depending on the number of
- * dquots in the system, we either allocate a new one on the kernel heap,
- * or reclaim a free one.
- * Return value is B_TRUE if we allocated a new dquot, B_FALSE if we managed
- * to reclaim an existing one from the freelist.
- */
-boolean_t
-xfs_qm_dqalloc_incore(
-	xfs_dquot_t **O_dqpp)
-{
-	xfs_dquot_t	*dqp;
+	mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
+	while (!list_empty(&xfs_Gqm->qm_dqfrlist)) {
+		if (nr_to_scan-- <= 0)
+			break;
+		dqp = list_first_entry(&xfs_Gqm->qm_dqfrlist, struct xfs_dquot,
+				       q_freelist);
 
-	/*
-	 * Check against high water mark to see if we want to pop
-	 * a nincompoop dquot off the freelist.
-	 */
-	if (atomic_read(&xfs_Gqm->qm_totaldquots) >= ndquot) {
-		/*
-		 * Try to recycle a dquot from the freelist.
-		 */
-		if ((dqp = xfs_qm_dqreclaim_one())) {
-			XQM_STATS_INC(xqmstats.xs_qm_dqreclaims);
-			/*
-			 * Just zero the core here. The rest will get
-			 * reinitialized by caller. XXX we shouldn't even
-			 * do this zero ...
-			 */
-			memset(&dqp->q_core, 0, sizeof(dqp->q_core));
-			*O_dqpp = dqp;
-			return B_FALSE;
-		}
-		XQM_STATS_INC(xqmstats.xs_qm_dqreclaim_misses);
+		if (!xfs_qm_dqreclaim_one(dqp))
+			list_move_tail(&dqp->q_freelist, &xfs_Gqm->qm_dqfrlist);
 	}
-
-	/*
-	 * Allocate a brand new dquot on the kernel heap and return it
-	 * to the caller to initialize.
-	 */
-	ASSERT(xfs_Gqm->qm_dqzone != NULL);
-	*O_dqpp = kmem_zone_zalloc(xfs_Gqm->qm_dqzone, KM_SLEEP);
-	atomic_inc(&xfs_Gqm->qm_totaldquots);
-
-	return B_TRUE;
+	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
+out:
+	return (xfs_Gqm->qm_dqfrlist_cnt / 100) * sysctl_vfs_cache_pressure;
 }
 
-
 /*
  * Start a transaction and write the incore superblock changes to
  * disk. flags parameter indicates which fields have changed.
Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2011-10-27 22:40:07.534173092 +0200
+++ xfs/fs/xfs/xfs_dquot.c	2011-10-27 22:40:08.598176882 +0200
@@ -64,82 +64,6 @@ int xfs_dqerror_mod = 33;
 static struct lock_class_key xfs_dquot_other_class;
 
 /*
- * Allocate and initialize a dquot. We don't always allocate fresh memory;
- * we try to reclaim a free dquot if the number of incore dquots are above
- * a threshold.
- * The only field inside the core that gets initialized at this point
- * is the d_id field. The idea is to fill in the entire q_core
- * when we read in the on disk dquot.
- */
-STATIC xfs_dquot_t *
-xfs_qm_dqinit(
-	xfs_mount_t  *mp,
-	xfs_dqid_t   id,
-	uint	     type)
-{
-	xfs_dquot_t	*dqp;
-	boolean_t	brandnewdquot;
-
-	brandnewdquot = xfs_qm_dqalloc_incore(&dqp);
-	dqp->dq_flags = type;
-	dqp->q_core.d_id = cpu_to_be32(id);
-	dqp->q_mount = mp;
-
-	/*
-	 * No need to re-initialize these if this is a reclaimed dquot.
-	 */
-	if (brandnewdquot) {
-		INIT_LIST_HEAD(&dqp->q_freelist);
-		mutex_init(&dqp->q_qlock);
-		init_waitqueue_head(&dqp->q_pinwait);
-
-		/*
-		 * Because we want to use a counting completion, complete
-		 * the flush completion once to allow a single access to
-		 * the flush completion without blocking.
-		 */
-		init_completion(&dqp->q_flush);
-		complete(&dqp->q_flush);
-
-		trace_xfs_dqinit(dqp);
-	} else {
-		/*
-		 * Only the q_core portion was zeroed in dqreclaim_one().
-		 * So, we need to reset others.
-		 */
-		dqp->q_nrefs = 0;
-		dqp->q_blkno = 0;
-		INIT_LIST_HEAD(&dqp->q_mplist);
-		INIT_LIST_HEAD(&dqp->q_hashlist);
-		dqp->q_bufoffset = 0;
-		dqp->q_fileoffset = 0;
-		dqp->q_transp = NULL;
-		dqp->q_gdquot = NULL;
-		dqp->q_res_bcount = 0;
-		dqp->q_res_icount = 0;
-		dqp->q_res_rtbcount = 0;
-		atomic_set(&dqp->q_pincount, 0);
-		dqp->q_hash = NULL;
-		ASSERT(list_empty(&dqp->q_freelist));
-
-		trace_xfs_dqreuse(dqp);
-	}
-
-	/*
-	 * In either case we need to make sure group quotas have a different
-	 * lock class than user quotas, to make sure lockdep knows we can
-	 * locks of one of each at the same time.
-	 */
-	if (!(type & XFS_DQ_USER))
-		lockdep_set_class(&dqp->q_qlock, &xfs_dquot_other_class);
-
-	/*
-	 * log item gets initialized later
-	 */
-	return (dqp);
-}
-
-/*
  * This is called to free all the memory associated with a dquot
  */
 void
@@ -568,7 +492,32 @@ xfs_qm_dqread(
 	int			 error;
 	int			cancelflags = 0;
 
-	dqp = xfs_qm_dqinit(mp, id, type);
+
+	dqp = kmem_zone_zalloc(xfs_Gqm->qm_dqzone, KM_SLEEP);
+
+	dqp->dq_flags = type;
+	dqp->q_core.d_id = cpu_to_be32(id);
+	dqp->q_mount = mp;
+	INIT_LIST_HEAD(&dqp->q_freelist);
+	mutex_init(&dqp->q_qlock);
+	init_waitqueue_head(&dqp->q_pinwait);
+
+	/*
+	 * Because we want to use a counting completion, complete
+	 * the flush completion once to allow a single access to
+	 * the flush completion without blocking.
+	 */
+	init_completion(&dqp->q_flush);
+	complete(&dqp->q_flush);
+
+	/*
+	 * Make sure group quotas have a different lock class than user
+	 * quotas.
+	 */
+	if (!(type & XFS_DQ_USER))
+		lockdep_set_class(&dqp->q_qlock, &xfs_dquot_other_class);
+
+	atomic_inc(&xfs_Gqm->qm_totaldquots);
 
 	trace_xfs_dqread(dqp);
 
Index: xfs/fs/xfs/xfs_qm.h
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.h	2011-10-27 22:40:01.234172361 +0200
+++ xfs/fs/xfs/xfs_qm.h	2011-10-27 22:40:08.606225990 +0200
@@ -26,7 +26,6 @@
 struct xfs_qm;
 struct xfs_inode;
 
-extern uint		ndquot;
 extern struct mutex	xfs_Gqm_lock;
 extern struct xfs_qm	*xfs_Gqm;
 extern kmem_zone_t	*qm_dqzone;
@@ -38,12 +37,6 @@ extern kmem_zone_t	*qm_dqtrxzone;
 #define XFS_QM_RECLAIM_MAX_RESTARTS	4
 
 /*
- * Ideal ratio of free to in use dquots. Quota manager makes an attempt
- * to keep this balance.
- */
-#define XFS_QM_DQFREE_RATIO		2
-
-/*
  * Dquot hashtable constants/threshold values.
  */
 #define XFS_QM_HASHSIZE_LOW		(PAGE_SIZE / sizeof(xfs_dqhash_t))
@@ -74,7 +67,6 @@ typedef struct xfs_qm {
 	int		 qm_dqfrlist_cnt;
 	atomic_t	 qm_totaldquots; /* total incore dquots */
 	uint		 qm_nrefs;	 /* file systems with quota on */
-	int		 qm_dqfree_ratio;/* ratio of free to inuse dquots */
 	kmem_zone_t	*qm_dqzone;	 /* dquot mem-alloc zone */
 	kmem_zone_t	*qm_dqtrxzone;	 /* t_dqinfo of transactions */
 } xfs_qm_t;
@@ -143,7 +135,6 @@ extern int		xfs_qm_quotacheck(xfs_mount_
 extern int		xfs_qm_write_sb_changes(xfs_mount_t *, __int64_t);
 
 /* dquot stuff */
-extern boolean_t	xfs_qm_dqalloc_incore(xfs_dquot_t **);
 extern int		xfs_qm_dqpurge_all(xfs_mount_t *, uint);
 extern void		xfs_qm_dqrele_all_inodes(xfs_mount_t *, uint);
 
Index: xfs/fs/xfs/xfs_qm_stats.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm_stats.c	2011-10-27 22:39:33.264675954 +0200
+++ xfs/fs/xfs/xfs_qm_stats.c	2011-10-27 22:40:08.610173785 +0200
@@ -42,9 +42,9 @@ static int xqm_proc_show(struct seq_file
 {
 	/* maximum; incore; ratio free to inuse; freelist */
 	seq_printf(m, "%d\t%d\t%d\t%u\n",
-			ndquot,
+			INT_MAX,
 			xfs_Gqm? atomic_read(&xfs_Gqm->qm_totaldquots) : 0,
-			xfs_Gqm? xfs_Gqm->qm_dqfree_ratio : 0,
+			0,
 			xfs_Gqm? xfs_Gqm->qm_dqfrlist_cnt : 0);
 	return 0;
 }
Index: xfs/fs/xfs/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trace.h	2011-10-27 22:40:03.870173003 +0200
+++ xfs/fs/xfs/xfs_trace.h	2011-10-27 22:40:08.610173785 +0200
@@ -736,8 +736,6 @@ DEFINE_DQUOT_EVENT(xfs_dqreclaim_dirty);
 DEFINE_DQUOT_EVENT(xfs_dqreclaim_unlink);
 DEFINE_DQUOT_EVENT(xfs_dqattach_found);
 DEFINE_DQUOT_EVENT(xfs_dqattach_get);
-DEFINE_DQUOT_EVENT(xfs_dqinit);
-DEFINE_DQUOT_EVENT(xfs_dqreuse);
 DEFINE_DQUOT_EVENT(xfs_dqalloc);
 DEFINE_DQUOT_EVENT(xfs_dqtobp_read);
 DEFINE_DQUOT_EVENT(xfs_dqread);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
