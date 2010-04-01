Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o31Ce5Xj120196 for <xfs@oss.sgi.com>; Thu, 1 Apr 2010 07:40:05 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD9451532CDA
	for <xfs@oss.sgi.com>; Thu,  1 Apr 2010 05:41:49 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	XGoWuUU9j3jY746H for <xfs@oss.sgi.com>;
	Thu, 01 Apr 2010 05:41:49 -0700 (PDT)
Received: from dastard (unverified [121.44.229.111])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	19168964-1927428
	for <xfs@oss.sgi.com>; Thu, 01 Apr 2010 23:11:48 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1NxJiU-0002I5-SF
	for xfs@oss.sgi.com; Thu, 01 Apr 2010 23:41:46 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NxJiU-0001pQ-IJ
	for xfs@oss.sgi.com; Thu, 01 Apr 2010 23:41:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/8] xfs: convert the dquot free list to use list heads
Date: Thu,  1 Apr 2010 23:41:31 +1100
Message-Id: <1270125691-29266-9-git-send-email-david@fromorbit.com>
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

Convert the dquot free list on the filesystem to use listhead
infrastructure rather than the roll-your-own in the quota code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/quota/xfs_dquot.c      |   75 +++++++++++---------------
 fs/xfs/quota/xfs_dquot.h      |    5 +-
 fs/xfs/quota/xfs_qm.c         |  119 ++++++++++++-----------------------------
 fs/xfs/quota/xfs_qm.h         |   19 +------
 fs/xfs/quota/xfs_qm_stats.c   |    2 +-
 fs/xfs/quota/xfs_quota_priv.h |   17 ------
 6 files changed, 72 insertions(+), 165 deletions(-)

diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index ad64ab6..02dac0a 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -101,7 +101,7 @@ xfs_qm_dqinit(
 	 * No need to re-initialize these if this is a reclaimed dquot.
 	 */
 	if (brandnewdquot) {
-		dqp->dq_flnext = dqp->dq_flprev = dqp;
+		INIT_LIST_HEAD(&dqp->q_freelist);
 		mutex_init(&dqp->q_qlock);
 		init_waitqueue_head(&dqp->q_pinwait);
 
@@ -119,20 +119,20 @@ xfs_qm_dqinit(
 		 * Only the q_core portion was zeroed in dqreclaim_one().
 		 * So, we need to reset others.
 		 */
-		 dqp->q_nrefs = 0;
-		 dqp->q_blkno = 0;
-		 INIT_LIST_HEAD(&dqp->q_mplist);
-		 INIT_LIST_HEAD(&dqp->q_hashlist);
-		 dqp->q_bufoffset = 0;
-		 dqp->q_fileoffset = 0;
-		 dqp->q_transp = NULL;
-		 dqp->q_gdquot = NULL;
-		 dqp->q_res_bcount = 0;
-		 dqp->q_res_icount = 0;
-		 dqp->q_res_rtbcount = 0;
-		 atomic_set(&dqp->q_pincount, 0);
-		 dqp->q_hash = NULL;
-		 ASSERT(dqp->dq_flnext == dqp->dq_flprev);
+		dqp->q_nrefs = 0;
+		dqp->q_blkno = 0;
+		INIT_LIST_HEAD(&dqp->q_mplist);
+		INIT_LIST_HEAD(&dqp->q_hashlist);
+		dqp->q_bufoffset = 0;
+		dqp->q_fileoffset = 0;
+		dqp->q_transp = NULL;
+		dqp->q_gdquot = NULL;
+		dqp->q_res_bcount = 0;
+		dqp->q_res_icount = 0;
+		dqp->q_res_rtbcount = 0;
+		atomic_set(&dqp->q_pincount, 0);
+		dqp->q_hash = NULL;
+		ASSERT(list_empty(&dqp->q_freelist));
 
 		trace_xfs_dqreuse(dqp);
 	}
@@ -158,7 +158,7 @@ void
 xfs_qm_dqdestroy(
 	xfs_dquot_t	*dqp)
 {
-	ASSERT(! XFS_DQ_IS_ON_FREELIST(dqp));
+	ASSERT(list_empty(&dqp->q_freelist));
 
 	mutex_destroy(&dqp->q_qlock);
 	sv_destroy(&dqp->q_pinwait);
@@ -775,8 +775,8 @@ xfs_qm_dqlookup(
 
 			xfs_dqlock(dqp);
 			if (dqp->q_nrefs == 0) {
-				ASSERT (XFS_DQ_IS_ON_FREELIST(dqp));
-				if (! xfs_qm_freelist_lock_nowait(xfs_Gqm)) {
+				ASSERT(!list_empty(&dqp->q_freelist));
+				if (!mutex_trylock(&xfs_Gqm->qm_dqfrlist_lock)) {
 					trace_xfs_dqlookup_want(dqp);
 
 					/*
@@ -786,7 +786,7 @@ xfs_qm_dqlookup(
 					 */
 					dqp->dq_flags |= XFS_DQ_WANT;
 					xfs_dqunlock(dqp);
-					xfs_qm_freelist_lock(xfs_Gqm);
+					mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
 					xfs_dqlock(dqp);
 					dqp->dq_flags &= ~(XFS_DQ_WANT);
 				}
@@ -801,27 +801,20 @@ xfs_qm_dqlookup(
 
 			if (flist_locked) {
 				if (dqp->q_nrefs != 0) {
-					xfs_qm_freelist_unlock(xfs_Gqm);
+					mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
 					flist_locked = B_FALSE;
 				} else {
-					/*
-					 * take it off the freelist
-					 */
+					/* take it off the freelist */
 					trace_xfs_dqlookup_freelist(dqp);
-					XQM_FREELIST_REMOVE(dqp);
-					/* xfs_qm_freelist_print(&(xfs_Gqm->
-							qm_dqfreelist),
-							"after removal"); */
+					list_del_init(&dqp->q_freelist);
+					xfs_Gqm->qm_dqfrlist_cnt--;
 				}
 			}
 
-			/*
-			 * grab a reference
-			 */
 			XFS_DQHOLD(dqp);
 
 			if (flist_locked)
-				xfs_qm_freelist_unlock(xfs_Gqm);
+				mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
 			/*
 			 * move the dquot to the front of the hashchain
 			 */
@@ -1075,10 +1068,10 @@ xfs_qm_dqput(
 	 * drop the dqlock and acquire the freelist and dqlock
 	 * in the right order; but try to get it out-of-order first
 	 */
-	if (! xfs_qm_freelist_lock_nowait(xfs_Gqm)) {
+	if (!mutex_trylock(&xfs_Gqm->qm_dqfrlist_lock)) {
 		trace_xfs_dqput_wait(dqp);
 		xfs_dqunlock(dqp);
-		xfs_qm_freelist_lock(xfs_Gqm);
+		mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
 		xfs_dqlock(dqp);
 	}
 
@@ -1089,10 +1082,8 @@ xfs_qm_dqput(
 		if (--dqp->q_nrefs == 0) {
 			trace_xfs_dqput_free(dqp);
 
-			/*
-			 * insert at end of the freelist.
-			 */
-			XQM_FREELIST_INSERT(&(xfs_Gqm->qm_dqfreelist), dqp);
+			list_add_tail(&dqp->q_freelist, &xfs_Gqm->qm_dqfrlist);
+			xfs_Gqm->qm_dqfrlist_cnt++;
 
 			/*
 			 * If we just added a udquot to the freelist, then
@@ -1107,10 +1098,6 @@ xfs_qm_dqput(
 				xfs_dqlock(gdqp);
 				dqp->q_gdquot = NULL;
 			}
-
-			/* xfs_qm_freelist_print(&(xfs_Gqm->qm_dqfreelist),
-			   "@@@@@++ Free list (after append) @@@@@+");
-			   */
 		}
 		xfs_dqunlock(dqp);
 
@@ -1122,7 +1109,7 @@ xfs_qm_dqput(
 			break;
 		dqp = gdqp;
 	}
-	xfs_qm_freelist_unlock(xfs_Gqm);
+	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
 }
 
 /*
@@ -1396,7 +1383,7 @@ xfs_qm_dqpurge(
 		return (1);
 	}
 
-	ASSERT(XFS_DQ_IS_ON_FREELIST(dqp));
+	ASSERT(!list_empty(&dqp->q_freelist));
 
 	/*
 	 * If we're turning off quotas, we have to make sure that, for
@@ -1450,7 +1437,7 @@ xfs_qm_dqpurge(
 	 * XXX Move this to the front of the freelist, if we can get the
 	 * freelist lock.
 	 */
-	ASSERT(XFS_DQ_IS_ON_FREELIST(dqp));
+	ASSERT(!list_empty(&dqp->q_freelist));
 
 	dqp->q_mount = NULL;
 	dqp->q_hash = NULL;
diff --git a/fs/xfs/quota/xfs_dquot.h b/fs/xfs/quota/xfs_dquot.h
index 169b3c2..56fb21d 100644
--- a/fs/xfs/quota/xfs_dquot.h
+++ b/fs/xfs/quota/xfs_dquot.h
@@ -50,8 +50,6 @@ struct xfs_trans;
  * iterations because of locking considerations.
  */
 typedef struct xfs_dqmarker {
-	struct xfs_dquot*dqm_flnext;	/* link to freelist: must be first */
-	struct xfs_dquot*dqm_flprev;
 	uint		 dqm_flags;	/* various flags (XFS_DQ_*) */
 } xfs_dqmarker_t;
 
@@ -60,8 +58,9 @@ typedef struct xfs_dqmarker {
  */
 typedef struct xfs_dquot {
 	xfs_dqmarker_t	 q_lists;	/* list ptrs, q_flags (marker) */
+	struct list_head q_freelist;	/* global free list of dquots */
 	struct list_head q_mplist;	/* mount's list of dquots */
-	struct list_head q_hashlist;	/* mount's list of dquots */
+	struct list_head q_hashlist;	/* gloabl hash list of dquots */
 	xfs_dqhash_t	*q_hash;	/* the hashchain header */
 	struct xfs_mount*q_mount;	/* filesystem this relates to */
 	struct xfs_trans*q_transp;	/* trans this belongs to currently */
diff --git a/fs/xfs/quota/xfs_qm.c b/fs/xfs/quota/xfs_qm.c
index 891666f..456b72e 100644
--- a/fs/xfs/quota/xfs_qm.c
+++ b/fs/xfs/quota/xfs_qm.c
@@ -67,9 +67,6 @@ static cred_t	xfs_zerocr;
 STATIC void	xfs_qm_list_init(xfs_dqlist_t *, char *, int);
 STATIC void	xfs_qm_list_destroy(xfs_dqlist_t *);
 
-STATIC void	xfs_qm_freelist_init(xfs_frlist_t *);
-STATIC void	xfs_qm_freelist_destroy(xfs_frlist_t *);
-
 STATIC int	xfs_qm_init_quotainos(xfs_mount_t *);
 STATIC int	xfs_qm_init_quotainfo(xfs_mount_t *);
 STATIC int	xfs_qm_shake(int, gfp_t);
@@ -148,7 +145,9 @@ xfs_Gqm_init(void)
 	/*
 	 * Freelist of all dquots of all file systems
 	 */
-	xfs_qm_freelist_init(&(xqm->qm_dqfreelist));
+	INIT_LIST_HEAD(&xqm->qm_dqfrlist);
+	xqm->qm_dqfrlist_cnt = 0;
+	mutex_init(&xqm->qm_dqfrlist_lock);
 
 	/*
 	 * dquot zone. we register our own low-memory callback.
@@ -193,6 +192,7 @@ STATIC void
 xfs_qm_destroy(
 	struct xfs_qm	*xqm)
 {
+	struct xfs_dquot *dqp, *n;
 	int		hsize, i;
 
 	ASSERT(xqm != NULL);
@@ -208,7 +208,21 @@ xfs_qm_destroy(
 	xqm->qm_usr_dqhtable = NULL;
 	xqm->qm_grp_dqhtable = NULL;
 	xqm->qm_dqhashmask = 0;
-	xfs_qm_freelist_destroy(&(xqm->qm_dqfreelist));
+
+	/* frlist cleanup */
+	mutex_lock(&xqm->qm_dqfrlist_lock);
+	list_for_each_entry_safe(dqp, n, &xqm->qm_dqfrlist, q_freelist) {
+		xfs_dqlock(dqp);
+#ifdef QUOTADEBUG
+		cmn_err(CE_DEBUG, "FREELIST destroy 0x%p", dqp);
+#endif
+		list_del_init(&dqp->q_freelist);
+		xfs_Gqm->qm_dqfrlist_cnt--;
+		xfs_dqunlock(dqp);
+		xfs_qm_dqdestroy(dqp);
+	}
+	mutex_unlock(&xqm->qm_dqfrlist_lock);
+	mutex_destroy(&xqm->qm_dqfrlist_lock);
 #ifdef DEBUG
 	mutex_destroy(&qcheck_lock);
 #endif
@@ -260,7 +274,7 @@ STATIC void
 xfs_qm_rele_quotafs_ref(
 	struct xfs_mount *mp)
 {
-	xfs_dquot_t	*dqp, *nextdqp;
+	xfs_dquot_t	*dqp, *n;
 
 	ASSERT(xfs_Gqm);
 	ASSERT(xfs_Gqm->qm_nrefs > 0);
@@ -268,26 +282,24 @@ xfs_qm_rele_quotafs_ref(
 	/*
 	 * Go thru the freelist and destroy all inactive dquots.
 	 */
-	xfs_qm_freelist_lock(xfs_Gqm);
+	mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
 
-	for (dqp = xfs_Gqm->qm_dqfreelist.qh_next;
-	     dqp != (xfs_dquot_t *)&(xfs_Gqm->qm_dqfreelist); ) {
+	list_for_each_entry_safe(dqp, n, &xfs_Gqm->qm_dqfrlist, q_freelist) {
 		xfs_dqlock(dqp);
-		nextdqp = dqp->dq_flnext;
 		if (dqp->dq_flags & XFS_DQ_INACTIVE) {
 			ASSERT(dqp->q_mount == NULL);
 			ASSERT(! XFS_DQ_IS_DIRTY(dqp));
 			ASSERT(list_empty(&dqp->q_hashlist));
 			ASSERT(list_empty(&dqp->q_mplist));
-			XQM_FREELIST_REMOVE(dqp);
+			list_del_init(&dqp->q_freelist);
+			xfs_Gqm->qm_dqfrlist_cnt--;
 			xfs_dqunlock(dqp);
 			xfs_qm_dqdestroy(dqp);
 		} else {
 			xfs_dqunlock(dqp);
 		}
-		dqp = nextdqp;
 	}
-	xfs_qm_freelist_unlock(xfs_Gqm);
+	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
 
 	/*
 	 * Destroy the entire XQM. If somebody mounts with quotaon, this'll
@@ -1943,9 +1955,9 @@ xfs_qm_dqreclaim_one(void)
 
 	/* lockorder: hashchainlock, freelistlock, mplistlock, dqlock, dqflock */
 startagain:
-	xfs_qm_freelist_lock(xfs_Gqm);
+	mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
 
-	FOREACH_DQUOT_IN_FREELIST(dqp, &(xfs_Gqm->qm_dqfreelist)) {
+	list_for_each_entry(dqp, &xfs_Gqm->qm_dqfrlist, q_freelist) {
 		struct xfs_mount *mp = dqp->q_mount;
 		xfs_dqlock(dqp);
 
@@ -1961,7 +1973,7 @@ startagain:
 			trace_xfs_dqreclaim_want(dqp);
 
 			xfs_dqunlock(dqp);
-			xfs_qm_freelist_unlock(xfs_Gqm);
+			mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
 			if (++restarts >= XFS_QM_RECLAIM_MAX_RESTARTS)
 				return NULL;
 			XQM_STATS_INC(xqmstats.xs_qm_dqwants);
@@ -1978,7 +1990,8 @@ startagain:
 			ASSERT(! XFS_DQ_IS_DIRTY(dqp));
 			ASSERT(list_empty(&dqp->q_hashlist));
 			ASSERT(list_empty(&dqp->q_mplist));
-			XQM_FREELIST_REMOVE(dqp);
+			list_del_init(&dqp->q_freelist);
+			xfs_Gqm->qm_dqfrlist_cnt--;
 			xfs_dqunlock(dqp);
 			dqpout = dqp;
 			XQM_STATS_INC(xqmstats.xs_qm_dqinact_reclaims);
@@ -2042,7 +2055,7 @@ startagain:
 			mutex_unlock(&dqp->q_hash->qh_lock);
 			xfs_dqfunlock(dqp);
 			xfs_dqunlock(dqp);
-			xfs_qm_freelist_unlock(xfs_Gqm);
+			mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
 			if (restarts++ >= XFS_QM_RECLAIM_MAX_RESTARTS)
 				return NULL;
 			goto startagain;
@@ -2057,7 +2070,8 @@ startagain:
 		mp->m_quotainfo->qi_dqreclaims++;
 		list_del_init(&dqp->q_hashlist);
 		dqp->q_hash->qh_version++;
-		XQM_FREELIST_REMOVE(dqp);
+		list_del_init(&dqp->q_freelist);
+		xfs_Gqm->qm_dqfrlist_cnt--;
 		dqpout = dqp;
 		mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
 		mutex_unlock(&dqp->q_hash->qh_lock);
@@ -2070,7 +2084,7 @@ dqfunlock:
 			return NULL;
 	}
 
-	xfs_qm_freelist_unlock(xfs_Gqm);
+	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
 	return dqpout;
 }
 
@@ -2115,7 +2129,7 @@ xfs_qm_shake(
 	if (!xfs_Gqm)
 		return 0;
 
-	nfree = xfs_Gqm->qm_dqfreelist.qh_nelems; /* free dquots */
+	nfree = xfs_Gqm->qm_dqfrlist_cnt; /* free dquots */
 	/* incore dquots in all f/s's */
 	ndqused = atomic_read(&xfs_Gqm->qm_totaldquots) - nfree;
 
@@ -2555,66 +2569,3 @@ xfs_qm_vop_create_dqattach(
 	}
 }
 
-/* ------------- list stuff -----------------*/
-STATIC void
-xfs_qm_freelist_init(xfs_frlist_t *ql)
-{
-	ql->qh_next = ql->qh_prev = (xfs_dquot_t *) ql;
-	mutex_init(&ql->qh_lock);
-	ql->qh_version = 0;
-	ql->qh_nelems = 0;
-}
-
-STATIC void
-xfs_qm_freelist_destroy(xfs_frlist_t *ql)
-{
-	xfs_dquot_t	*dqp, *nextdqp;
-
-	mutex_lock(&ql->qh_lock);
-	for (dqp = ql->qh_next;
-	     dqp != (xfs_dquot_t *)ql; ) {
-		xfs_dqlock(dqp);
-		nextdqp = dqp->dq_flnext;
-#ifdef QUOTADEBUG
-		cmn_err(CE_DEBUG, "FREELIST destroy 0x%p", dqp);
-#endif
-		XQM_FREELIST_REMOVE(dqp);
-		xfs_dqunlock(dqp);
-		xfs_qm_dqdestroy(dqp);
-		dqp = nextdqp;
-	}
-	mutex_unlock(&ql->qh_lock);
-	mutex_destroy(&ql->qh_lock);
-
-	ASSERT(ql->qh_nelems == 0);
-}
-
-STATIC void
-xfs_qm_freelist_insert(xfs_frlist_t *ql, xfs_dquot_t *dq)
-{
-	dq->dq_flnext = ql->qh_next;
-	dq->dq_flprev = (xfs_dquot_t *)ql;
-	ql->qh_next = dq;
-	dq->dq_flnext->dq_flprev = dq;
-	xfs_Gqm->qm_dqfreelist.qh_nelems++;
-	xfs_Gqm->qm_dqfreelist.qh_version++;
-}
-
-void
-xfs_qm_freelist_unlink(xfs_dquot_t *dq)
-{
-	xfs_dquot_t *next = dq->dq_flnext;
-	xfs_dquot_t *prev = dq->dq_flprev;
-
-	next->dq_flprev = prev;
-	prev->dq_flnext = next;
-	dq->dq_flnext = dq->dq_flprev = dq;
-	xfs_Gqm->qm_dqfreelist.qh_nelems--;
-	xfs_Gqm->qm_dqfreelist.qh_version++;
-}
-
-void
-xfs_qm_freelist_append(xfs_frlist_t *ql, xfs_dquot_t *dq)
-{
-	xfs_qm_freelist_insert((xfs_frlist_t *)ql->qh_prev, dq);
-}
diff --git a/fs/xfs/quota/xfs_qm.h b/fs/xfs/quota/xfs_qm.h
index 91bd053..c9446f1 100644
--- a/fs/xfs/quota/xfs_qm.h
+++ b/fs/xfs/quota/xfs_qm.h
@@ -72,17 +72,6 @@ extern kmem_zone_t	*qm_dqtrxzone;
 #define XFS_QM_MAX_DQCLUSTER_LOGSZ	3
 
 typedef xfs_dqhash_t	xfs_dqlist_t;
-/*
- * The freelist head. The first two fields match the first two in the
- * xfs_dquot_t structure (in xfs_dqmarker_t)
- */
-typedef struct xfs_frlist {
-       struct xfs_dquot *qh_next;
-       struct xfs_dquot *qh_prev;
-       struct mutex	 qh_lock;
-       uint		 qh_version;
-       uint		 qh_nelems;
-} xfs_frlist_t;
 
 /*
  * Quota Manager (global) structure. Lives only in core.
@@ -91,7 +80,9 @@ typedef struct xfs_qm {
 	xfs_dqlist_t	*qm_usr_dqhtable;/* udquot hash table */
 	xfs_dqlist_t	*qm_grp_dqhtable;/* gdquot hash table */
 	uint		 qm_dqhashmask;	 /* # buckets in dq hashtab - 1 */
-	xfs_frlist_t	 qm_dqfreelist;	 /* freelist of dquots */
+	struct list_head qm_dqfrlist;	 /* freelist of dquots */
+	struct mutex	 qm_dqfrlist_lock;
+	int		 qm_dqfrlist_cnt;
 	atomic_t	 qm_totaldquots; /* total incore dquots */
 	uint		 qm_nrefs;	 /* file systems with quota on */
 	int		 qm_dqfree_ratio;/* ratio of free to inuse dquots */
@@ -177,10 +168,6 @@ extern int		xfs_qm_scall_getqstat(xfs_mount_t *, fs_quota_stat_t *);
 extern int		xfs_qm_scall_quotaon(xfs_mount_t *, uint);
 extern int		xfs_qm_scall_quotaoff(xfs_mount_t *, uint);
 
-/* list stuff */
-extern void		xfs_qm_freelist_append(xfs_frlist_t *, xfs_dquot_t *);
-extern void		xfs_qm_freelist_unlink(xfs_dquot_t *);
-
 #ifdef DEBUG
 extern int		xfs_qm_internalqcheck(xfs_mount_t *);
 #else
diff --git a/fs/xfs/quota/xfs_qm_stats.c b/fs/xfs/quota/xfs_qm_stats.c
index 83e7ea3..3d1fc79 100644
--- a/fs/xfs/quota/xfs_qm_stats.c
+++ b/fs/xfs/quota/xfs_qm_stats.c
@@ -55,7 +55,7 @@ static int xqm_proc_show(struct seq_file *m, void *v)
 			ndquot,
 			xfs_Gqm? atomic_read(&xfs_Gqm->qm_totaldquots) : 0,
 			xfs_Gqm? xfs_Gqm->qm_dqfree_ratio : 0,
-			xfs_Gqm? xfs_Gqm->qm_dqfreelist.qh_nelems : 0);
+			xfs_Gqm? xfs_Gqm->qm_dqfrlist_cnt : 0);
 	return 0;
 }
 
diff --git a/fs/xfs/quota/xfs_quota_priv.h b/fs/xfs/quota/xfs_quota_priv.h
index 3a1b9aa..3eeee2e 100644
--- a/fs/xfs/quota/xfs_quota_priv.h
+++ b/fs/xfs/quota/xfs_quota_priv.h
@@ -40,13 +40,6 @@
 #define XFS_QI_IWARNLIMIT(mp)	((mp)->m_quotainfo->qi_iwarnlimit)
 #define XFS_QI_QOFFLOCK(mp)	((mp)->m_quotainfo->qi_quotaofflock)
 
-#define xfs_qm_freelist_lock(qm) \
-	mutex_lock(&((qm)->qm_dqfreelist.qh_lock))
-#define xfs_qm_freelist_lock_nowait(qm) \
-	mutex_trylock(&((qm)->qm_dqfreelist.qh_lock))
-#define xfs_qm_freelist_unlock(qm) \
-	mutex_unlock(&((qm)->qm_dqfreelist.qh_lock))
-
 /*
  * Hash into a bucket in the dquot hash table, based on <mp, id>.
  */
@@ -72,16 +65,6 @@
 	!dqp->q_core.d_rtbcount && \
 	!dqp->q_core.d_icount)
 
-#define FOREACH_DQUOT_IN_FREELIST(dqp, qlist)	\
-for ((dqp) = (qlist)->qh_next; (dqp) != (xfs_dquot_t *)(qlist); \
-     (dqp) = (dqp)->dq_flnext)
-
-#define XQM_FREELIST_INSERT(h, dqp)	\
-	 xfs_qm_freelist_append(h, dqp)
-
-#define XQM_FREELIST_REMOVE(dqp)	\
-	 xfs_qm_freelist_unlink(dqp)
-
 #define XFS_DQ_IS_LOGITEM_INITD(dqp)	((dqp)->q_logitem.qli_dquot == (dqp))
 
 #define XFS_QM_DQP_TO_DQACCT(tp, dqp)	(XFS_QM_ISUDQ(dqp) ? \
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
