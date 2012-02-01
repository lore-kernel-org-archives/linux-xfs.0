Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q11E0jxm253169 for <xfs@oss.sgi.com>; Wed, 1 Feb 2012 08:00:45 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	OIUWIGk2urMhNMw2 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Feb 2012 06:00:41 -0800 (PST)
Message-Id: <20120201140040.093762788@bombadil.infradead.org>
Date: Wed, 01 Feb 2012 08:57:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/7] xfs: remove the per-filesystem list of dquots
References: <20120201135719.202171828@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-quota-remove-mplist
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

Instead of keeping a separate per-filesystem list of dquots we can walk
the radix tree for the two places where we need to iterate all quota
structures.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_dquot.c |   35 ++----
 fs/xfs/xfs_dquot.h |    2 
 fs/xfs/xfs_qm.c    |  287 +++++++++++++++++++++++------------------------------
 fs/xfs/xfs_qm.h    |    4 
 4 files changed, 143 insertions(+), 185 deletions(-)

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2012-02-01 12:24:50.577664301 +0100
+++ xfs/fs/xfs/xfs_dquot.c	2012-02-01 12:26:36.210425373 +0100
@@ -44,10 +44,9 @@
  *
  * ip->i_lock
  *   qi->qi_tree_lock
- *     qi->qi_dqlist_lock
- *       dquot->q_qlock (xfs_dqlock() and friends)
- *         dquot->q_flush (xfs_dqflock() and friends)
- *         qi->qi_lru_lock
+ *     dquot->q_qlock (xfs_dqlock() and friends)
+ *       dquot->q_flush (xfs_dqflock() and friends)
+ *       qi->qi_lru_lock
  *
  * If two dquots need to be locked the order is user before group/project,
  * otherwise by the lowest id first, see xfs_dqlock2.
@@ -740,11 +739,6 @@ restart:
 		XQM_STATS_INC(xqmstats.xs_qm_dquot_dups);
 		goto restart;
 	}
-	/*
-	 * Attach this dquot to this filesystem's list of all dquots,
-	 * kept inside the mount structure in m_quotainfo field
-	 */
-	mutex_lock(&mp->m_quotainfo->qi_dqlist_lock);
 
 	/*
 	 * We return a locked dquot to the caller, with a reference taken
@@ -752,9 +746,7 @@ restart:
 	xfs_dqlock(dqp);
 	dqp->q_nrefs = 1;
 
-	list_add(&dqp->q_mplist, &mp->m_quotainfo->qi_dqlist);
 	mp->m_quotainfo->qi_dquots++;
-	mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
 	mutex_unlock(&mp->m_quotainfo->qi_tree_lock);
 
  dqret:
@@ -1038,16 +1030,23 @@ xfs_dqlock2(
 
 /*
  * Take a dquot out of the mount's dqlist as well as the hashlist.  This is
- * called via unmount as well as quotaoff, and the purge will always succeed.
+ * called via unmount as well as quotaoff.
  */
-void
+int
 xfs_qm_dqpurge(
-	struct xfs_dquot	*dqp)
+	struct xfs_dquot	*dqp,
+	int			flags)
 {
 	struct xfs_mount	*mp = dqp->q_mount;
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
 
 	xfs_dqlock(dqp);
+	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0) {
+		xfs_dqlock(dqp);
+		return EAGAIN;
+	}
+
+	dqp->dq_flags |= XFS_DQ_FREEING;
 
 	/*
 	 * If we're turning off quotas, we have to make sure that, for
@@ -1091,16 +1090,9 @@ xfs_qm_dqpurge(
 	xfs_dqfunlock(dqp);
 	xfs_dqunlock(dqp);
 
-	mutex_lock(&mp->m_quotainfo->qi_tree_lock);
 	radix_tree_delete(XFS_DQUOT_TREE(mp, dqp->q_core.d_flags),
 			  be32_to_cpu(dqp->q_core.d_id));
-	mutex_unlock(&mp->m_quotainfo->qi_tree_lock);
-
-	mutex_lock(&qi->qi_dqlist_lock);
-	list_del_init(&dqp->q_mplist);
-	qi->qi_dqreclaims++;
 	qi->qi_dquots--;
-	mutex_unlock(&qi->qi_dqlist_lock);
 
 	/*
 	 * We move dquots to the freelist as soon as their reference count
@@ -1113,6 +1105,7 @@ xfs_qm_dqpurge(
 	mutex_unlock(&qi->qi_lru_lock);
 
 	xfs_qm_dqdestroy(dqp);
+	return 0;
 }
 
 /*
Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2012-02-01 12:25:23.134154595 +0100
+++ xfs/fs/xfs/xfs_qm.c	2012-02-01 12:26:36.210425373 +0100
@@ -308,172 +308,157 @@ xfs_qm_unmount_quotas(
 }
 
 /*
- * Flush all dquots of the given file system to disk. The dquots are
- * _not_ purged from memory here, just their data written to disk.
+ * The quota lookup is done in batches to keep the amount of lock traffic and
+ * radix tree lookups to a minimum. The batch size is a trade off between
+ * lookup reduction and stack usage.
  */
+#define XFS_DQ_LOOKUP_BATCH	32
+
 STATIC int
-xfs_qm_dqflush_all(
-	struct xfs_mount	*mp)
-{
-	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	int			recl;
-	struct xfs_dquot	*dqp;
-	int			error;
+xfs_qm_dquot_walk(
+	struct xfs_mount	*mp,
+	int			type,
+	int			(*execute)(struct xfs_dquot *dqp, int flags),
+	int			flags)
+{
+	struct radix_tree_root	*tree = XFS_DQUOT_TREE(mp, type);
+	uint32_t		first_index;
+	int			last_error = 0;
+	int			skipped;
+	int			nr_found;
+
+restart:
+	skipped = 0;
+	first_index = 0;
+	nr_found = 0;
 
-	if (!q)
-		return 0;
-again:
-	mutex_lock(&q->qi_dqlist_lock);
-	list_for_each_entry(dqp, &q->qi_dqlist, q_mplist) {
-		xfs_dqlock(dqp);
-		if ((dqp->dq_flags & XFS_DQ_FREEING) ||
-		    !XFS_DQ_IS_DIRTY(dqp)) {
-			xfs_dqunlock(dqp);
-			continue;
-		}
+	mutex_lock(&mp->m_quotainfo->qi_tree_lock);
+	do {
+		struct xfs_dquot *batch[XFS_DQ_LOOKUP_BATCH];
+		int		error = 0;
+		int		i;
+
+		nr_found = radix_tree_gang_lookup(tree, (void **)batch,
+					first_index, XFS_DQ_LOOKUP_BATCH);
+		if (!nr_found)
+			break;
 
-		/* XXX a sentinel would be better */
-		recl = q->qi_dqreclaims;
-		if (!xfs_dqflock_nowait(dqp)) {
-			/*
-			 * If we can't grab the flush lock then check
-			 * to see if the dquot has been flushed delayed
-			 * write.  If so, grab its buffer and send it
-			 * out immediately.  We'll be able to acquire
-			 * the flush lock when the I/O completes.
-			 */
-			xfs_dqflock_pushbuf_wait(dqp);
+		for (i = 0; i < nr_found; i++) {
+			struct xfs_dquot *dqp = batch[i];
+
+			first_index = be32_to_cpu(dqp->q_core.d_id) + 1;
+
+			error = execute(batch[i], flags);
+			if (error == EAGAIN) {
+				skipped++;
+				continue;
+			}
+			if (error && last_error != EFSCORRUPTED)
+				last_error = error;
+		}
+		/* bail out if the filesystem is corrupted.  */
+		if (error == EFSCORRUPTED) {
+			skipped = 0;
+			break;
 		}
-		/*
-		 * Let go of the mplist lock. We don't want to hold it
-		 * across a disk write.
-		 */
-		mutex_unlock(&q->qi_dqlist_lock);
-		error = xfs_qm_dqflush(dqp, 0);
-		xfs_dqunlock(dqp);
-		if (error)
-			return error;
 
-		mutex_lock(&q->qi_dqlist_lock);
-		if (recl != q->qi_dqreclaims) {
-			mutex_unlock(&q->qi_dqlist_lock);
-			/* XXX restart limit */
-			goto again;
+		if (need_resched()) {
+			mutex_unlock(&mp->m_quotainfo->qi_tree_lock);
+			cond_resched();
+			mutex_lock(&mp->m_quotainfo->qi_tree_lock);
 		}
+	} while (nr_found);
+	mutex_unlock(&mp->m_quotainfo->qi_tree_lock);
+
+	if (skipped) {
+		delay(1);
+		goto restart;
 	}
 
-	mutex_unlock(&q->qi_dqlist_lock);
-	/* return ! busy */
-	return 0;
+	return last_error;
 }
 
-/*
- * Release the group dquot pointers the user dquots may be
- * carrying around as a hint. mplist is locked on entry and exit.
- */
-STATIC void
-xfs_qm_detach_gdquots(
-	struct xfs_mount	*mp)
+STATIC int
+xfs_qm_flush_one(
+	struct xfs_dquot	*dqp,
+	int			flags)
 {
-	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	struct xfs_dquot	*dqp, *gdqp;
+	int			error = 0;
 
- again:
-	ASSERT(mutex_is_locked(&q->qi_dqlist_lock));
-	list_for_each_entry(dqp, &q->qi_dqlist, q_mplist) {
-		xfs_dqlock(dqp);
-		if (dqp->dq_flags & XFS_DQ_FREEING) {
-			xfs_dqunlock(dqp);
-			mutex_unlock(&q->qi_dqlist_lock);
-			delay(1);
-			mutex_lock(&q->qi_dqlist_lock);
-			goto again;
-		}
+	xfs_dqlock(dqp);
+	if (dqp->dq_flags & XFS_DQ_FREEING)
+		goto out_unlock;
+	if (!XFS_DQ_IS_DIRTY(dqp))
+		goto out_unlock;
 
-		gdqp = dqp->q_gdquot;
-		if (gdqp)
-			dqp->q_gdquot = NULL;
-		xfs_dqunlock(dqp);
+	if (!xfs_dqflock_nowait(dqp))
+		xfs_dqflock_pushbuf_wait(dqp);
 
-		if (gdqp)
-			xfs_qm_dqrele(gdqp);
-	}
+	error = xfs_qm_dqflush(dqp, flags);
+
+out_unlock:
+	xfs_dqunlock(dqp);
+	return error;
 }
 
 /*
- * Go through all the incore dquots of this file system and take them
- * off the mplist and hashlist, if the dquot type matches the dqtype
- * parameter. This is used when turning off quota accounting for
- * users and/or groups, as well as when the filesystem is unmounting.
+ * Release the group dquot pointer the user dquot may be carrying around
+ * as a hint.
  */
 STATIC int
-xfs_qm_dqpurge_int(
+xfs_qm_detach_gdquot(
+	struct xfs_dquot	*dqp,
+	int			flags)
+{
+	struct xfs_dquot	*gdqp;
+
+	xfs_dqlock(dqp);
+	/* XXX(hch): should we bother with freeeing dquots here? */
+	if (dqp->dq_flags & XFS_DQ_FREEING) {
+		xfs_dqunlock(dqp);
+		return 0;
+	}
+	gdqp = dqp->q_gdquot;
+	if (gdqp) {
+		xfs_dqlock(gdqp);
+		dqp->q_gdquot = NULL;
+	}
+	xfs_dqunlock(dqp);
+	if (gdqp)
+		xfs_qm_dqput(gdqp);
+	return 0;
+}
+
+/*
+ * Purge the dquot cache.
+ *
+ * None of the dquots should really be busy at this point.
+ */
+int
+xfs_qm_dqpurge_all(
 	struct xfs_mount	*mp,
 	uint			flags)
 {
-	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	struct xfs_dquot	*dqp, *n;
-	uint			dqtype;
-	int			nmisses = 0;
-	LIST_HEAD		(dispose_list);
+	int			error = 0;
 
-	if (!q)
+	if (!mp->m_quotainfo)
 		return 0;
 
-	dqtype = (flags & XFS_QMOPT_UQUOTA) ? XFS_DQ_USER : 0;
-	dqtype |= (flags & XFS_QMOPT_PQUOTA) ? XFS_DQ_PROJ : 0;
-	dqtype |= (flags & XFS_QMOPT_GQUOTA) ? XFS_DQ_GROUP : 0;
-
-	mutex_lock(&q->qi_dqlist_lock);
-
 	/*
 	 * In the first pass through all incore dquots of this filesystem,
 	 * we release the group dquot pointers the user dquots may be
 	 * carrying around as a hint. We need to do this irrespective of
 	 * what's being turned off.
 	 */
-	xfs_qm_detach_gdquots(mp);
-
-	/*
-	 * Try to get rid of all of the unwanted dquots.
-	 */
-	list_for_each_entry_safe(dqp, n, &q->qi_dqlist, q_mplist) {
-		xfs_dqlock(dqp);
-		if ((dqp->dq_flags & dqtype) != 0 &&
-		    !(dqp->dq_flags & XFS_DQ_FREEING)) {
-			if (dqp->q_nrefs == 0) {
-				dqp->dq_flags |= XFS_DQ_FREEING;
-				list_move_tail(&dqp->q_mplist, &dispose_list);
-			} else
-				nmisses++;
-		}
-		xfs_dqunlock(dqp);
-	}
-	mutex_unlock(&q->qi_dqlist_lock);
-
-	list_for_each_entry_safe(dqp, n, &dispose_list, q_mplist)
-		xfs_qm_dqpurge(dqp);
-
-	return nmisses;
-}
-
-int
-xfs_qm_dqpurge_all(
-	xfs_mount_t	*mp,
-	uint		flags)
-{
-	int		ndquots;
+	xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_detach_gdquot, 0);
 
-	/*
-	 * Purge the dquot cache.
-	 * None of the dquots should really be busy at this point.
-	 */
-	if (mp->m_quotainfo) {
-		while ((ndquots = xfs_qm_dqpurge_int(mp, flags))) {
-			delay(ndquots * 10);
-		}
-	}
-	return 0;
+	if (!error && (flags & XFS_QMOPT_UQUOTA))
+		error = xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge, 0);
+	if (!error && (flags & XFS_QMOPT_GQUOTA))
+		error = xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_dqpurge, 0);
+	if (!error && (flags & XFS_QMOPT_PQUOTA))
+		error = xfs_qm_dquot_walk(mp, XFS_DQ_PROJ, xfs_qm_dqpurge, 0);
+	return error;
 }
 
 STATIC int
@@ -750,15 +735,10 @@ xfs_qm_init_quotainfo(
 	INIT_RADIX_TREE(&qinf->qi_gquota_tree, GFP_NOFS);
 	mutex_init(&qinf->qi_tree_lock);
 
-	INIT_LIST_HEAD(&qinf->qi_dqlist);
-	mutex_init(&qinf->qi_dqlist_lock);
-
 	INIT_LIST_HEAD(&qinf->qi_lru_list);
 	qinf->qi_lru_count = 0;
 	mutex_init(&qinf->qi_lru_lock);
 
-	qinf->qi_dqreclaims = 0;
-
 	/* mutex used to serialize quotaoffs */
 	mutex_init(&qinf->qi_quotaofflock);
 
@@ -855,9 +835,6 @@ xfs_qm_destroy_quotainfo(
 	 */
 	xfs_qm_rele_quotafs_ref(mp);
 
-	ASSERT(list_empty(&qi->qi_dqlist));
-	mutex_destroy(&qi->qi_dqlist_lock);
-
 	if (qi->qi_uquotaip) {
 		IRELE(qi->qi_uquotaip);
 		qi->qi_uquotaip = NULL; /* paranoia */
@@ -1330,12 +1307,6 @@ xfs_qm_quotacheck(
 	ASSERT(mp->m_quotainfo->qi_uquotaip || mp->m_quotainfo->qi_gquotaip);
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
-	/*
-	 * There should be no cached dquots. The (simplistic) quotacheck
-	 * algorithm doesn't like that.
-	 */
-	ASSERT(list_empty(&mp->m_quotainfo->qi_dqlist));
-
 	xfs_notice(mp, "Quotacheck needed: Please wait.");
 
 	/*
@@ -1374,12 +1345,15 @@ xfs_qm_quotacheck(
 	} while (!done);
 
 	/*
-	 * We've made all the changes that we need to make incore.
-	 * Flush them down to disk buffers if everything was updated
-	 * successfully.
+	 * We've made all the changes that we need to make incore.  Flush them
+	 * down to disk buffers if everything was updated successfully.
 	 */
-	if (!error)
-		error = xfs_qm_dqflush_all(mp);
+	if (!error && XFS_IS_UQUOTA_ON(mp))
+		error = xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_flush_one, 0);
+	if (!error && XFS_IS_GQUOTA_ON(mp))
+		error = xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_flush_one, 0);
+	if (!error && XFS_IS_PQUOTA_ON(mp))
+		error = xfs_qm_dquot_walk(mp, XFS_DQ_PROJ, xfs_qm_flush_one, 0);
 
 	/*
 	 * We can get this error if we couldn't do a dquot allocation inside
@@ -1518,13 +1492,8 @@ xfs_qm_dqfree_one(
 	mutex_lock(&mp->m_quotainfo->qi_tree_lock);
 	radix_tree_delete(XFS_DQUOT_TREE(mp, dqp->q_core.d_flags),
 			  be32_to_cpu(dqp->q_core.d_id));
-	mutex_unlock(&mp->m_quotainfo->qi_tree_lock);
-
-	mutex_lock(&qi->qi_dqlist_lock);
-	list_del_init(&dqp->q_mplist);
 	qi->qi_dquots--;
-	qi->qi_dqreclaims++;
-	mutex_unlock(&qi->qi_dqlist_lock);
+	mutex_unlock(&mp->m_quotainfo->qi_tree_lock);
 
 	xfs_qm_dqdestroy(dqp);
 }
Index: xfs/fs/xfs/xfs_qm.h
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.h	2012-02-01 12:24:50.577664301 +0100
+++ xfs/fs/xfs/xfs_qm.h	2012-02-01 12:26:36.210425373 +0100
@@ -65,11 +65,7 @@ typedef struct xfs_quotainfo {
 	struct list_head qi_lru_list;
 	struct mutex	 qi_lru_lock;
 	int		 qi_lru_count;
-	struct list_head qi_dqlist;	 /* all dquots in filesys */
-	struct mutex	 qi_dqlist_lock;
 	int		 qi_dquots;
-	int		 qi_dqreclaims;	 /* a change here indicates
-					    a removal in the dqlist */
 	time_t		 qi_btimelimit;	 /* limit for blks timer */
 	time_t		 qi_itimelimit;	 /* limit for inodes timer */
 	time_t		 qi_rtbtimelimit;/* limit for rt blks timer */
Index: xfs/fs/xfs/xfs_dquot.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.h	2012-02-01 12:24:50.577664301 +0100
+++ xfs/fs/xfs/xfs_dquot.h	2012-02-01 12:26:36.210425373 +0100
@@ -121,7 +121,7 @@ extern int		xfs_qm_dqread(struct xfs_mou
 					uint, struct xfs_dquot	**);
 extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
 extern int		xfs_qm_dqflush(xfs_dquot_t *, uint);
-extern void		xfs_qm_dqpurge(xfs_dquot_t *);
+extern int		xfs_qm_dqpurge(xfs_dquot_t *, int);
 extern void		xfs_qm_dqunpin_wait(xfs_dquot_t *);
 extern void		xfs_qm_adjust_dqtimers(xfs_mount_t *,
 					xfs_disk_dquot_t *);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
