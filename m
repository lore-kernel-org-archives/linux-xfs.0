Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o31Ce5Gp120197 for <xfs@oss.sgi.com>; Thu, 1 Apr 2010 07:40:05 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D873B1532CDD
	for <xfs@oss.sgi.com>; Thu,  1 Apr 2010 05:41:50 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	UeDL2rfwcBb8fsW7 for <xfs@oss.sgi.com>;
	Thu, 01 Apr 2010 05:41:50 -0700 (PDT)
Received: from dastard (unverified [121.44.229.111])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	19168966-1927428
	for <xfs@oss.sgi.com>; Thu, 01 Apr 2010 23:11:48 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1NxJiU-0002Hx-O0
	for xfs@oss.sgi.com; Thu, 01 Apr 2010 23:41:46 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NxJiU-0001nj-ES
	for xfs@oss.sgi.com; Thu, 01 Apr 2010 23:41:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/8] xfs: remove duplicate code from dquot reclaim
Date: Thu,  1 Apr 2010 23:41:29 +1100
Message-Id: <1270125691-29266-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1270125691-29266-1-git-send-email-david@fromorbit.com>
References: <1270125691-29266-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

The dquot shaker and the free-list reclaim code use exactly the same
algorithm but the code is duplicated and slightly different in each
case. Make the shaker code use the single dquot reclaim code to
remove the code duplication.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_trace.h |    2 -
 fs/xfs/quota/xfs_qm.c        |  269 ++++++++++++------------------------------
 2 files changed, 78 insertions(+), 193 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index cde032b..915004f 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -653,8 +653,6 @@ DEFINE_EVENT(xfs_dquot_class, name, \
 	TP_PROTO(struct xfs_dquot *dqp), \
 	TP_ARGS(dqp))
 DEFINE_DQUOT_EVENT(xfs_dqadjust);
-DEFINE_DQUOT_EVENT(xfs_dqshake_dirty);
-DEFINE_DQUOT_EVENT(xfs_dqshake_unlink);
 DEFINE_DQUOT_EVENT(xfs_dqreclaim_want);
 DEFINE_DQUOT_EVENT(xfs_dqreclaim_dirty);
 DEFINE_DQUOT_EVENT(xfs_dqreclaim_unlink);
diff --git a/fs/xfs/quota/xfs_qm.c b/fs/xfs/quota/xfs_qm.c
index 8558273..e9c2de2 100644
--- a/fs/xfs/quota/xfs_qm.c
+++ b/fs/xfs/quota/xfs_qm.c
@@ -1926,53 +1926,46 @@ xfs_qm_init_quotainos(
 }
 
 
+
 /*
- * Traverse the freelist of dquots and attempt to reclaim a maximum of
- * 'howmany' dquots. This operation races with dqlookup(), and attempts to
- * favor the lookup function ...
- * XXXsup merge this with qm_reclaim_one().
+ * Just pop the least recently used dquot off the freelist and
+ * recycle it. The returned dquot is locked.
  */
-STATIC int
-xfs_qm_shake_freelist(
-	int howmany)
+STATIC xfs_dquot_t *
+xfs_qm_dqreclaim_one(void)
 {
-	int		nreclaimed;
-	xfs_dqhash_t	*hash;
-	xfs_dquot_t	*dqp, *nextdqp;
+	xfs_dquot_t	*dqpout;
+	xfs_dquot_t	*dqp;
 	int		restarts;
-	int		nflushes;
 
-	if (howmany <= 0)
-		return 0;
-
-	nreclaimed = 0;
 	restarts = 0;
-	nflushes = 0;
+	dqpout = NULL;
 
-#ifdef QUOTADEBUG
-	cmn_err(CE_DEBUG, "Shake free 0x%x", howmany);
-#endif
-	/* lock order is : hashchainlock, freelistlock, mplistlock */
- tryagain:
+	/* lockorder: hashchainlock, freelistlock, mplistlock, dqlock, dqflock */
+startagain:
 	xfs_qm_freelist_lock(xfs_Gqm);
 
-	for (dqp = xfs_Gqm->qm_dqfreelist.qh_next;
-	     ((dqp != (xfs_dquot_t *) &xfs_Gqm->qm_dqfreelist) &&
-	      nreclaimed < howmany); ) {
+	FOREACH_DQUOT_IN_FREELIST(dqp, &(xfs_Gqm->qm_dqfreelist)) {
 		struct xfs_mount *mp = dqp->q_mount;
 		xfs_dqlock(dqp);
 
 		/*
 		 * We are racing with dqlookup here. Naturally we don't
-		 * want to reclaim a dquot that lookup wants.
+		 * want to reclaim a dquot that lookup wants. We release the
+		 * freelist lock and start over, so that lookup will grab
+		 * both the dquot and the freelistlock.
 		 */
 		if (dqp->dq_flags & XFS_DQ_WANT) {
+			ASSERT(! (dqp->dq_flags & XFS_DQ_INACTIVE));
+
+			trace_xfs_dqreclaim_want(dqp);
+
 			xfs_dqunlock(dqp);
 			xfs_qm_freelist_unlock(xfs_Gqm);
 			if (++restarts >= XFS_QM_RECLAIM_MAX_RESTARTS)
-				return nreclaimed;
+				return NULL;
 			XQM_STATS_INC(xqmstats.xs_qm_dqwants);
-			goto tryagain;
+			goto startagain;
 		}
 
 		/*
@@ -1985,19 +1978,22 @@ xfs_qm_shake_freelist(
 			ASSERT(! XFS_DQ_IS_DIRTY(dqp));
 			ASSERT(dqp->HL_PREVP == NULL);
 			ASSERT(list_empty(&dqp->q_mplist));
+			XQM_FREELIST_REMOVE(dqp);
+			xfs_dqunlock(dqp);
+			dqpout = dqp;
 			XQM_STATS_INC(xqmstats.xs_qm_dqinact_reclaims);
-			nextdqp = dqp->dq_flnext;
-			goto off_freelist;
+			break;
 		}
 
+		ASSERT(dqp->q_hash);
 		ASSERT(!list_empty(&dqp->q_mplist));
+
 		/*
 		 * Try to grab the flush lock. If this dquot is in the process of
 		 * getting flushed to disk, we don't want to reclaim it.
 		 */
 		if (!xfs_dqflock_nowait(dqp)) {
 			xfs_dqunlock(dqp);
-			dqp = dqp->dq_flnext;
 			continue;
 		}
 
@@ -2010,21 +2006,21 @@ xfs_qm_shake_freelist(
 		if (XFS_DQ_IS_DIRTY(dqp)) {
 			int	error;
 
-			trace_xfs_dqshake_dirty(dqp);
+			trace_xfs_dqreclaim_dirty(dqp);
 
 			/*
 			 * We flush it delayed write, so don't bother
-			 * releasing the mplock.
+			 * releasing the freelist lock.
 			 */
 			error = xfs_qm_dqflush(dqp, 0);
 			if (error) {
 				xfs_fs_cmn_err(CE_WARN, mp,
-			"xfs_qm_dqflush_all: dquot %p flush failed", dqp);
+			"xfs_qm_dqreclaim: dquot %p flush failed", dqp);
 			}
 			xfs_dqunlock(dqp); /* dqflush unlocks dqflock */
-			dqp = dqp->dq_flnext;
 			continue;
 		}
+
 		/*
 		 * We're trying to get the hashlock out of order. This races
 		 * with dqlookup; so, we giveup and goto the next dquot if
@@ -2033,64 +2029,83 @@ xfs_qm_shake_freelist(
 		 * waiting for the freelist lock.
 		 */
 		if (!mutex_trylock(&dqp->q_hash->qh_lock)) {
-			xfs_dqfunlock(dqp);
-			xfs_dqunlock(dqp);
-			dqp = dqp->dq_flnext;
-			continue;
+			restarts++;
+			goto dqfunlock;
 		}
 		/*
 		 * This races with dquot allocation code as well as dqflush_all
 		 * and reclaim code. So, if we failed to grab the mplist lock,
 		 * giveup everything and start over.
 		 */
-		hash = dqp->q_hash;
-		ASSERT(hash);
 		if (!mutex_trylock(&mp->m_quotainfo->qi_dqlist_lock)) {
-			/* XXX put a sentinel so that we can come back here */
+			restarts++;
+			mutex_unlock(&dqp->q_hash->qh_lock);
 			xfs_dqfunlock(dqp);
 			xfs_dqunlock(dqp);
-			mutex_unlock(&hash->qh_lock);
 			xfs_qm_freelist_unlock(xfs_Gqm);
-			if (++restarts >= XFS_QM_RECLAIM_MAX_RESTARTS)
-				return nreclaimed;
-			goto tryagain;
+			if (restarts++ >= XFS_QM_RECLAIM_MAX_RESTARTS)
+				return NULL;
+			goto startagain;
 		}
 
-		trace_xfs_dqshake_unlink(dqp);
 
-#ifdef QUOTADEBUG
-		cmn_err(CE_DEBUG, "Shake 0x%p, ID 0x%x\n",
-			dqp, be32_to_cpu(dqp->q_core.d_id));
-#endif
+		trace_xfs_dqreclaim_unlink(dqp);
+
 		ASSERT(dqp->q_nrefs == 0);
-		nextdqp = dqp->dq_flnext;
-		XQM_HASHLIST_REMOVE(hash, dqp);
 		list_del_init(&dqp->q_mplist);
 		mp->m_quotainfo->qi_dquots--;
 		mp->m_quotainfo->qi_dqreclaims++;
-		xfs_dqfunlock(dqp);
-		mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
-		mutex_unlock(&hash->qh_lock);
-
- off_freelist:
+		XQM_HASHLIST_REMOVE(dqp->q_hash, dqp);
 		XQM_FREELIST_REMOVE(dqp);
+		dqpout = dqp;
+		mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
+		mutex_unlock(&dqp->q_hash->qh_lock);
+dqfunlock:
+		xfs_dqfunlock(dqp);
 		xfs_dqunlock(dqp);
-		nreclaimed++;
-		XQM_STATS_INC(xqmstats.xs_qm_dqshake_reclaims);
-		xfs_qm_dqdestroy(dqp);
-		dqp = nextdqp;
+		if (dqpout)
+			break;
+		if (restarts >= XFS_QM_RECLAIM_MAX_RESTARTS)
+			return NULL;
 	}
+
 	xfs_qm_freelist_unlock(xfs_Gqm);
-	return nreclaimed;
+	return dqpout;
 }
 
+/*
+ * Traverse the freelist of dquots and attempt to reclaim a maximum of
+ * 'howmany' dquots. This operation races with dqlookup(), and attempts to
+ * favor the lookup function ...
+ */
+STATIC int
+xfs_qm_shake_freelist(
+	int	howmany)
+{
+	int		nreclaimed = 0;
+	xfs_dquot_t	*dqp;
+
+	if (howmany <= 0)
+		return 0;
+
+	while (nreclaimed < howmany) {
+		dqp = xfs_qm_dqreclaim_one();
+		if (!dqp)
+			return nreclaimed;
+		xfs_qm_dqdestroy(dqp);
+		nreclaimed++;
+	}
+	return nreclaimed;
+}
 
 /*
  * The kmem_shake interface is invoked when memory is running low.
  */
 /* ARGSUSED */
 STATIC int
-xfs_qm_shake(int nr_to_scan, gfp_t gfp_mask)
+xfs_qm_shake(
+	int	nr_to_scan,
+	gfp_t	gfp_mask)
 {
 	int	ndqused, nfree, n;
 
@@ -2115,134 +2130,6 @@ xfs_qm_shake(int nr_to_scan, gfp_t gfp_mask)
 }
 
 
-/*
- * Just pop the least recently used dquot off the freelist and
- * recycle it. The returned dquot is locked.
- */
-STATIC xfs_dquot_t *
-xfs_qm_dqreclaim_one(void)
-{
-	xfs_dquot_t	*dqpout;
-	xfs_dquot_t	*dqp;
-	int		restarts;
-	int		nflushes;
-
-	restarts = 0;
-	dqpout = NULL;
-	nflushes = 0;
-
-	/* lockorder: hashchainlock, freelistlock, mplistlock, dqlock, dqflock */
- startagain:
-	xfs_qm_freelist_lock(xfs_Gqm);
-
-	FOREACH_DQUOT_IN_FREELIST(dqp, &(xfs_Gqm->qm_dqfreelist)) {
-		struct xfs_mount *mp = dqp->q_mount;
-		xfs_dqlock(dqp);
-
-		/*
-		 * We are racing with dqlookup here. Naturally we don't
-		 * want to reclaim a dquot that lookup wants. We release the
-		 * freelist lock and start over, so that lookup will grab
-		 * both the dquot and the freelistlock.
-		 */
-		if (dqp->dq_flags & XFS_DQ_WANT) {
-			ASSERT(! (dqp->dq_flags & XFS_DQ_INACTIVE));
-
-			trace_xfs_dqreclaim_want(dqp);
-
-			xfs_dqunlock(dqp);
-			xfs_qm_freelist_unlock(xfs_Gqm);
-			if (++restarts >= XFS_QM_RECLAIM_MAX_RESTARTS)
-				return NULL;
-			XQM_STATS_INC(xqmstats.xs_qm_dqwants);
-			goto startagain;
-		}
-
-		/*
-		 * If the dquot is inactive, we are assured that it is
-		 * not on the mplist or the hashlist, and that makes our
-		 * life easier.
-		 */
-		if (dqp->dq_flags & XFS_DQ_INACTIVE) {
-			ASSERT(mp == NULL);
-			ASSERT(! XFS_DQ_IS_DIRTY(dqp));
-			ASSERT(dqp->HL_PREVP == NULL);
-			ASSERT(list_empty(&dqp->q_mplist));
-			XQM_FREELIST_REMOVE(dqp);
-			xfs_dqunlock(dqp);
-			dqpout = dqp;
-			XQM_STATS_INC(xqmstats.xs_qm_dqinact_reclaims);
-			break;
-		}
-
-		ASSERT(dqp->q_hash);
-		ASSERT(!list_empty(&dqp->q_mplist));
-
-		/*
-		 * Try to grab the flush lock. If this dquot is in the process of
-		 * getting flushed to disk, we don't want to reclaim it.
-		 */
-		if (!xfs_dqflock_nowait(dqp)) {
-			xfs_dqunlock(dqp);
-			continue;
-		}
-
-		/*
-		 * We have the flush lock so we know that this is not in the
-		 * process of being flushed. So, if this is dirty, flush it
-		 * DELWRI so that we don't get a freelist infested with
-		 * dirty dquots.
-		 */
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
-				xfs_fs_cmn_err(CE_WARN, mp,
-			"xfs_qm_dqreclaim: dquot %p flush failed", dqp);
-			}
-			xfs_dqunlock(dqp); /* dqflush unlocks dqflock */
-			continue;
-		}
-
-		if (!mutex_trylock(&mp->m_quotainfo->qi_dqlist_lock)) {
-			xfs_dqfunlock(dqp);
-			xfs_dqunlock(dqp);
-			continue;
-		}
-
-		if (!mutex_trylock(&dqp->q_hash->qh_lock))
-			goto mplistunlock;
-
-		trace_xfs_dqreclaim_unlink(dqp);
-
-		ASSERT(dqp->q_nrefs == 0);
-		list_del_init(&dqp->q_mplist);
-		mp->m_quotainfo->qi_dquots--;
-		mp->m_quotainfo->qi_dqreclaims++;
-		XQM_HASHLIST_REMOVE(dqp->q_hash, dqp);
-		XQM_FREELIST_REMOVE(dqp);
-		dqpout = dqp;
-		mutex_unlock(&dqp->q_hash->qh_lock);
- mplistunlock:
-		mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
-		xfs_dqfunlock(dqp);
-		xfs_dqunlock(dqp);
-		if (dqpout)
-			break;
-	}
-
-	xfs_qm_freelist_unlock(xfs_Gqm);
-	return dqpout;
-}
-
-
 /*------------------------------------------------------------------*/
 
 /*
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
