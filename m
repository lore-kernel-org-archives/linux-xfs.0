Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o31Ce7Ew120222 for <xfs@oss.sgi.com>; Thu, 1 Apr 2010 07:40:07 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A41BC1532CDA
	for <xfs@oss.sgi.com>; Thu,  1 Apr 2010 05:41:52 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	rV3ekbYdytxVZPST for <xfs@oss.sgi.com>;
	Thu, 01 Apr 2010 05:41:52 -0700 (PDT)
Received: from dastard (unverified [121.44.229.111])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	19168967-1927428
	for <xfs@oss.sgi.com>; Thu, 01 Apr 2010 23:11:49 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1NxJiU-0002Hv-MR
	for xfs@oss.sgi.com; Thu, 01 Apr 2010 23:41:46 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NxJiK-0001nh-De
	for xfs@oss.sgi.com; Thu, 01 Apr 2010 23:41:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/8] xfs: convert the per-mount dquot list to use list heads
Date: Thu,  1 Apr 2010 23:41:28 +1100
Message-Id: <1270125691-29266-6-git-send-email-david@fromorbit.com>
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

Convert the dquot list on the filesytesm to use listhead
infrastructure rather than the roll-your-own in the quota code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/quota/xfs_dquot.c       |   21 +++---
 fs/xfs/quota/xfs_dquot.h       |    2 +-
 fs/xfs/quota/xfs_qm.c          |  155 +++++++++++++++++++++-------------------
 fs/xfs/quota/xfs_qm.h          |    4 +-
 fs/xfs/quota/xfs_qm_syscalls.c |    2 +-
 fs/xfs/quota/xfs_quota_priv.h  |   25 -------
 6 files changed, 97 insertions(+), 112 deletions(-)

diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index 5f79dd7..838289b 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -121,8 +121,9 @@ xfs_qm_dqinit(
 		 */
 		 dqp->q_nrefs = 0;
 		 dqp->q_blkno = 0;
-		 dqp->MPL_NEXT = dqp->HL_NEXT = NULL;
-		 dqp->HL_PREVP = dqp->MPL_PREVP = NULL;
+		 INIT_LIST_HEAD(&dqp->q_mplist);
+		 dqp->HL_NEXT = NULL;
+		 dqp->HL_PREVP = NULL;
 		 dqp->q_bufoffset = 0;
 		 dqp->q_fileoffset = 0;
 		 dqp->q_transp = NULL;
@@ -772,7 +773,7 @@ xfs_qm_dqlookup(
 			/*
 			 * All in core dquots must be on the dqlist of mp
 			 */
-			ASSERT(dqp->MPL_PREVP != NULL);
+			ASSERT(!list_empty(&dqp->q_mplist));
 
 			xfs_dqlock(dqp);
 			if (dqp->q_nrefs == 0) {
@@ -1039,7 +1040,7 @@ xfs_qm_dqget(
 	 * Attach this dquot to this filesystem's list of all dquots,
 	 * kept inside the mount structure in m_quotainfo field
 	 */
-	xfs_qm_mplist_lock(mp);
+	mutex_lock(&mp->m_quotainfo->qi_dqlist_lock);
 
 	/*
 	 * We return a locked dquot to the caller, with a reference taken
@@ -1047,9 +1048,9 @@ xfs_qm_dqget(
 	xfs_dqlock(dqp);
 	dqp->q_nrefs = 1;
 
-	XQM_MPLIST_INSERT(&(XFS_QI_MPL_LIST(mp)), dqp);
-
-	xfs_qm_mplist_unlock(mp);
+	list_add(&dqp->q_mplist, &mp->m_quotainfo->qi_dqlist);
+	mp->m_quotainfo->qi_dquots++;
+	mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
 	mutex_unlock(&h->qh_lock);
  dqret:
 	ASSERT((ip == NULL) || xfs_isilocked(ip, XFS_ILOCK_EXCL));
@@ -1389,7 +1390,7 @@ xfs_qm_dqpurge(
 	xfs_dqhash_t	*thishash;
 	xfs_mount_t	*mp = dqp->q_mount;
 
-	ASSERT(XFS_QM_IS_MPLIST_LOCKED(mp));
+	ASSERT(mutex_is_locked(&mp->m_quotainfo->qi_dqlist_lock));
 	ASSERT(mutex_is_locked(&dqp->q_hash->qh_lock));
 
 	xfs_dqlock(dqp);
@@ -1454,7 +1455,9 @@ xfs_qm_dqpurge(
 
 	thishash = dqp->q_hash;
 	XQM_HASHLIST_REMOVE(thishash, dqp);
-	XQM_MPLIST_REMOVE(&(XFS_QI_MPL_LIST(mp)), dqp);
+	list_del_init(&dqp->q_mplist);
+	mp->m_quotainfo->qi_dqreclaims++;
+	mp->m_quotainfo->qi_dquots--;
 	/*
 	 * XXX Move this to the front of the freelist, if we can get the
 	 * freelist lock.
diff --git a/fs/xfs/quota/xfs_dquot.h b/fs/xfs/quota/xfs_dquot.h
index a0f7da5..6992a67 100644
--- a/fs/xfs/quota/xfs_dquot.h
+++ b/fs/xfs/quota/xfs_dquot.h
@@ -57,7 +57,6 @@ struct xfs_trans;
 typedef struct xfs_dqmarker {
 	struct xfs_dquot*dqm_flnext;	/* link to freelist: must be first */
 	struct xfs_dquot*dqm_flprev;
-	xfs_dqlink_t	 dqm_mplist;	/* link to mount's list of dquots */
 	xfs_dqlink_t	 dqm_hashlist;	/* link to the hash chain */
 	uint		 dqm_flags;	/* various flags (XFS_DQ_*) */
 } xfs_dqmarker_t;
@@ -67,6 +66,7 @@ typedef struct xfs_dqmarker {
  */
 typedef struct xfs_dquot {
 	xfs_dqmarker_t	 q_lists;	/* list ptrs, q_flags (marker) */
+	struct list_head q_mplist;	/* mount's list of dquots */
 	xfs_dqhash_t	*q_hash;	/* the hashchain header */
 	struct xfs_mount*q_mount;	/* filesystem this relates to */
 	struct xfs_trans*q_transp;	/* trans this belongs to currently */
diff --git a/fs/xfs/quota/xfs_qm.c b/fs/xfs/quota/xfs_qm.c
index 417e61e..8558273 100644
--- a/fs/xfs/quota/xfs_qm.c
+++ b/fs/xfs/quota/xfs_qm.c
@@ -84,21 +84,25 @@ extern struct mutex	qcheck_lock;
 #endif
 
 #ifdef QUOTADEBUG
-#define XQM_LIST_PRINT(l, NXT, title) \
-{ \
-	xfs_dquot_t	*dqp; int i = 0; \
-	cmn_err(CE_DEBUG, "%s (#%d)", title, (int) (l)->qh_nelems); \
-	for (dqp = (l)->qh_next; dqp != NULL; dqp = dqp->NXT) { \
-		cmn_err(CE_DEBUG, "   %d.  \"%d (%s)\"   " \
-				  "bcnt = %d, icnt = %d, refs = %d", \
-			++i, (int) be32_to_cpu(dqp->q_core.d_id), \
-			DQFLAGTO_TYPESTR(dqp),	     \
-			(int) be64_to_cpu(dqp->q_core.d_bcount), \
-			(int) be64_to_cpu(dqp->q_core.d_icount), \
-			(int) dqp->q_nrefs);  } \
+static void
+xfs_qm_dquot_list_print(
+	struct xfs_mount *mp)
+{
+	xfs_dquot_t	*dqp;
+	int		i = 0;
+
+	list_for_each_entry(dqp, &mp->m_quotainfo->qi_dqlist_lock, qi_mplist) {
+		cmn_err(CE_DEBUG, "   %d. \"%d (%s)\"   "
+				  "bcnt = %lld, icnt = %lld, refs = %d",
+			i++, be32_to_cpu(dqp->q_core.d_id),
+			DQFLAGTO_TYPESTR(dqp),
+			(long long)be64_to_cpu(dqp->q_core.d_bcount),
+			(long long)be64_to_cpu(dqp->q_core.d_icount),
+			dqp->q_nrefs);
+	}
 }
 #else
-#define XQM_LIST_PRINT(l, NXT, title) do { } while (0)
+static void xfs_qm_dquot_list_print(struct xfs_mount *mp) { }
 #endif
 
 /*
@@ -274,7 +278,7 @@ xfs_qm_rele_quotafs_ref(
 			ASSERT(dqp->q_mount == NULL);
 			ASSERT(! XFS_DQ_IS_DIRTY(dqp));
 			ASSERT(dqp->HL_PREVP == NULL);
-			ASSERT(dqp->MPL_PREVP == NULL);
+			ASSERT(list_empty(&dqp->q_mplist));
 			XQM_FREELIST_REMOVE(dqp);
 			xfs_dqunlock(dqp);
 			xfs_qm_dqdestroy(dqp);
@@ -461,8 +465,8 @@ xfs_qm_dqflush_all(
 		return 0;
 	niters = 0;
 again:
-	xfs_qm_mplist_lock(mp);
-	FOREACH_DQUOT_IN_MP(dqp, mp) {
+	mutex_lock(&mp->m_quotainfo->qi_dqlist_lock);
+	list_for_each_entry(dqp, &mp->m_quotainfo->qi_dqlist, q_mplist) {
 		xfs_dqlock(dqp);
 		if (! XFS_DQ_IS_DIRTY(dqp)) {
 			xfs_dqunlock(dqp);
@@ -470,7 +474,7 @@ again:
 		}
 
 		/* XXX a sentinel would be better */
-		recl = XFS_QI_MPLRECLAIMS(mp);
+		recl = mp->m_quotainfo->qi_dqreclaims;
 		if (!xfs_dqflock_nowait(dqp)) {
 			/*
 			 * If we can't grab the flush lock then check
@@ -485,21 +489,21 @@ again:
 		 * Let go of the mplist lock. We don't want to hold it
 		 * across a disk write.
 		 */
-		xfs_qm_mplist_unlock(mp);
+		mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
 		error = xfs_qm_dqflush(dqp, sync_mode);
 		xfs_dqunlock(dqp);
 		if (error)
 			return error;
 
-		xfs_qm_mplist_lock(mp);
-		if (recl != XFS_QI_MPLRECLAIMS(mp)) {
-			xfs_qm_mplist_unlock(mp);
+		mutex_lock(&mp->m_quotainfo->qi_dqlist_lock);
+		if (recl != mp->m_quotainfo->qi_dqreclaims) {
+			mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
 			/* XXX restart limit */
 			goto again;
 		}
 	}
 
-	xfs_qm_mplist_unlock(mp);
+	mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
 	/* return ! busy */
 	return 0;
 }
@@ -515,9 +519,8 @@ xfs_qm_detach_gdquots(
 	int		nrecl;
 
  again:
-	ASSERT(XFS_QM_IS_MPLIST_LOCKED(mp));
-	dqp = XFS_QI_MPLNEXT(mp);
-	while (dqp) {
+	ASSERT(mutex_is_locked(&mp->m_quotainfo->qi_dqlist_lock));
+	list_for_each_entry(dqp, &mp->m_quotainfo->qi_dqlist, q_mplist) {
 		xfs_dqlock(dqp);
 		if ((gdqp = dqp->q_gdquot)) {
 			xfs_dqlock(gdqp);
@@ -530,15 +533,14 @@ xfs_qm_detach_gdquots(
 			 * Can't hold the mplist lock across a dqput.
 			 * XXXmust convert to marker based iterations here.
 			 */
-			nrecl = XFS_QI_MPLRECLAIMS(mp);
-			xfs_qm_mplist_unlock(mp);
+			nrecl = mp->m_quotainfo->qi_dqreclaims;
+			mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
 			xfs_qm_dqput(gdqp);
 
-			xfs_qm_mplist_lock(mp);
-			if (nrecl != XFS_QI_MPLRECLAIMS(mp))
+			mutex_lock(&mp->m_quotainfo->qi_dqlist_lock);
+			if (nrecl != mp->m_quotainfo->qi_dqreclaims)
 				goto again;
 		}
-		dqp = dqp->MPL_NEXT;
 	}
 }
 
@@ -553,10 +555,9 @@ xfs_qm_dqpurge_int(
 	xfs_mount_t	*mp,
 	uint		flags) /* QUOTAOFF/UMOUNTING/UQUOTA/PQUOTA/GQUOTA */
 {
-	xfs_dquot_t	*dqp;
+	xfs_dquot_t	*dqp, *n;
 	uint		dqtype;
 	int		nrecl;
-	xfs_dquot_t	*nextdqp;
 	int		nmisses;
 
 	if (mp->m_quotainfo == NULL)
@@ -566,7 +567,7 @@ xfs_qm_dqpurge_int(
 	dqtype |= (flags & XFS_QMOPT_PQUOTA) ? XFS_DQ_PROJ : 0;
 	dqtype |= (flags & XFS_QMOPT_GQUOTA) ? XFS_DQ_GROUP : 0;
 
-	xfs_qm_mplist_lock(mp);
+	mutex_lock(&mp->m_quotainfo->qi_dqlist_lock);
 
 	/*
 	 * In the first pass through all incore dquots of this filesystem,
@@ -578,28 +579,25 @@ xfs_qm_dqpurge_int(
 
       again:
 	nmisses = 0;
-	ASSERT(XFS_QM_IS_MPLIST_LOCKED(mp));
+	ASSERT(mutex_is_locked(&mp->m_quotainfo->qi_dqlist_lock));
 	/*
 	 * Try to get rid of all of the unwanted dquots. The idea is to
 	 * get them off mplist and hashlist, but leave them on freelist.
 	 */
-	dqp = XFS_QI_MPLNEXT(mp);
-	while (dqp) {
+	list_for_each_entry_safe(dqp, n, &mp->m_quotainfo->qi_dqlist, q_mplist) {
 		/*
 		 * It's OK to look at the type without taking dqlock here.
 		 * We're holding the mplist lock here, and that's needed for
 		 * a dqreclaim.
 		 */
-		if ((dqp->dq_flags & dqtype) == 0) {
-			dqp = dqp->MPL_NEXT;
+		if ((dqp->dq_flags & dqtype) == 0)
 			continue;
-		}
 
 		if (!mutex_trylock(&dqp->q_hash->qh_lock)) {
-			nrecl = XFS_QI_MPLRECLAIMS(mp);
-			xfs_qm_mplist_unlock(mp);
+			nrecl = mp->m_quotainfo->qi_dqreclaims;
+			mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
 			mutex_lock(&dqp->q_hash->qh_lock);
-			xfs_qm_mplist_lock(mp);
+			mutex_lock(&mp->m_quotainfo->qi_dqlist_lock);
 
 			/*
 			 * XXXTheoretically, we can get into a very long
@@ -607,7 +605,7 @@ xfs_qm_dqpurge_int(
 			 * No one can be adding dquots to the mplist at
 			 * this point, but somebody might be taking things off.
 			 */
-			if (nrecl != XFS_QI_MPLRECLAIMS(mp)) {
+			if (nrecl != mp->m_quotainfo->qi_dqreclaims) {
 				mutex_unlock(&dqp->q_hash->qh_lock);
 				goto again;
 			}
@@ -617,11 +615,9 @@ xfs_qm_dqpurge_int(
 		 * Take the dquot off the mplist and hashlist. It may remain on
 		 * freelist in INACTIVE state.
 		 */
-		nextdqp = dqp->MPL_NEXT;
 		nmisses += xfs_qm_dqpurge(dqp);
-		dqp = nextdqp;
 	}
-	xfs_qm_mplist_unlock(mp);
+	mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
 	return nmisses;
 }
 
@@ -934,18 +930,19 @@ xfs_qm_sync(
 	restarts = 0;
 
   again:
-	xfs_qm_mplist_lock(mp);
+	mutex_lock(&mp->m_quotainfo->qi_dqlist_lock);
 	/*
 	 * dqpurge_all() also takes the mplist lock and iterate thru all dquots
 	 * in quotaoff. However, if the QUOTA_ACTIVE bits are not cleared
 	 * when we have the mplist lock, we know that dquots will be consistent
 	 * as long as we have it locked.
 	 */
-	if (! XFS_IS_QUOTA_ON(mp)) {
-		xfs_qm_mplist_unlock(mp);
+	if (!XFS_IS_QUOTA_ON(mp)) {
+		mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
 		return 0;
 	}
-	FOREACH_DQUOT_IN_MP(dqp, mp) {
+	ASSERT(mutex_is_locked(&mp->m_quotainfo->qi_dqlist_lock));
+	list_for_each_entry(dqp, &mp->m_quotainfo->qi_dqlist, q_mplist) {
 		/*
 		 * If this is vfs_sync calling, then skip the dquots that
 		 * don't 'seem' to be dirty. ie. don't acquire dqlock.
@@ -969,7 +966,7 @@ xfs_qm_sync(
 		}
 
 		/* XXX a sentinel would be better */
-		recl = XFS_QI_MPLRECLAIMS(mp);
+		recl = mp->m_quotainfo->qi_dqreclaims;
 		if (!xfs_dqflock_nowait(dqp)) {
 			if (flags & SYNC_TRYLOCK) {
 				xfs_dqunlock(dqp);
@@ -989,7 +986,7 @@ xfs_qm_sync(
 		 * Let go of the mplist lock. We don't want to hold it
 		 * across a disk write
 		 */
-		xfs_qm_mplist_unlock(mp);
+		mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
 		error = xfs_qm_dqflush(dqp, flags);
 		xfs_dqunlock(dqp);
 		if (error && XFS_FORCED_SHUTDOWN(mp))
@@ -997,17 +994,17 @@ xfs_qm_sync(
 		else if (error)
 			return error;
 
-		xfs_qm_mplist_lock(mp);
-		if (recl != XFS_QI_MPLRECLAIMS(mp)) {
+		mutex_lock(&mp->m_quotainfo->qi_dqlist_lock);
+		if (recl != mp->m_quotainfo->qi_dqreclaims) {
 			if (++restarts >= XFS_QM_SYNC_MAX_RESTARTS)
 				break;
 
-			xfs_qm_mplist_unlock(mp);
+			mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
 			goto again;
 		}
 	}
 
-	xfs_qm_mplist_unlock(mp);
+	mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
 	return 0;
 }
 
@@ -1052,8 +1049,9 @@ xfs_qm_init_quotainfo(
 		return error;
 	}
 
-	xfs_qm_list_init(&qinf->qi_dqlist, "mpdqlist", 0);
-	lockdep_set_class(&qinf->qi_dqlist.qh_lock, &xfs_quota_mplist_class);
+	INIT_LIST_HEAD(&qinf->qi_dqlist);
+	mutex_init(&qinf->qi_dqlist_lock);
+	lockdep_set_class(&qinf->qi_dqlist_lock, &xfs_quota_mplist_class);
 
 	qinf->qi_dqreclaims = 0;
 
@@ -1150,7 +1148,8 @@ xfs_qm_destroy_quotainfo(
 	 */
 	xfs_qm_rele_quotafs_ref(mp);
 
-	xfs_qm_list_destroy(&qi->qi_dqlist);
+	ASSERT(list_empty(&qi->qi_dqlist));
+	mutex_destroy(&qi->qi_dqlist_lock);
 
 	if (qi->qi_uquotaip) {
 		IRELE(qi->qi_uquotaip);
@@ -1754,7 +1753,7 @@ xfs_qm_quotacheck(
 	 * There should be no cached dquots. The (simplistic) quotacheck
 	 * algorithm doesn't like that.
 	 */
-	ASSERT(XFS_QI_MPLNDQUOTS(mp) == 0);
+	ASSERT(list_empty(&mp->m_quotainfo->qi_dqlist));
 
 	cmn_err(CE_NOTE, "XFS quotacheck %s: Please wait.", mp->m_fsname);
 
@@ -1825,7 +1824,7 @@ xfs_qm_quotacheck(
 	mp->m_qflags &= ~(XFS_OQUOTA_CHKD | XFS_UQUOTA_CHKD);
 	mp->m_qflags |= flags;
 
-	XQM_LIST_PRINT(&(XFS_QI_MPL_LIST(mp)), MPL_NEXT, "++++ Mp list +++");
+	xfs_qm_dquot_list_print(mp);
 
  error_return:
 	if (error) {
@@ -1960,6 +1959,7 @@ xfs_qm_shake_freelist(
 	for (dqp = xfs_Gqm->qm_dqfreelist.qh_next;
 	     ((dqp != (xfs_dquot_t *) &xfs_Gqm->qm_dqfreelist) &&
 	      nreclaimed < howmany); ) {
+		struct xfs_mount *mp = dqp->q_mount;
 		xfs_dqlock(dqp);
 
 		/*
@@ -1981,16 +1981,16 @@ xfs_qm_shake_freelist(
 		 * life easier.
 		 */
 		if (dqp->dq_flags & XFS_DQ_INACTIVE) {
-			ASSERT(dqp->q_mount == NULL);
+			ASSERT(mp == NULL);
 			ASSERT(! XFS_DQ_IS_DIRTY(dqp));
 			ASSERT(dqp->HL_PREVP == NULL);
-			ASSERT(dqp->MPL_PREVP == NULL);
+			ASSERT(list_empty(&dqp->q_mplist));
 			XQM_STATS_INC(xqmstats.xs_qm_dqinact_reclaims);
 			nextdqp = dqp->dq_flnext;
 			goto off_freelist;
 		}
 
-		ASSERT(dqp->MPL_PREVP);
+		ASSERT(!list_empty(&dqp->q_mplist));
 		/*
 		 * Try to grab the flush lock. If this dquot is in the process of
 		 * getting flushed to disk, we don't want to reclaim it.
@@ -2018,7 +2018,7 @@ xfs_qm_shake_freelist(
 			 */
 			error = xfs_qm_dqflush(dqp, 0);
 			if (error) {
-				xfs_fs_cmn_err(CE_WARN, dqp->q_mount,
+				xfs_fs_cmn_err(CE_WARN, mp,
 			"xfs_qm_dqflush_all: dquot %p flush failed", dqp);
 			}
 			xfs_dqunlock(dqp); /* dqflush unlocks dqflock */
@@ -2045,7 +2045,7 @@ xfs_qm_shake_freelist(
 		 */
 		hash = dqp->q_hash;
 		ASSERT(hash);
-		if (! xfs_qm_mplist_nowait(dqp->q_mount)) {
+		if (!mutex_trylock(&mp->m_quotainfo->qi_dqlist_lock)) {
 			/* XXX put a sentinel so that we can come back here */
 			xfs_dqfunlock(dqp);
 			xfs_dqunlock(dqp);
@@ -2064,10 +2064,12 @@ xfs_qm_shake_freelist(
 #endif
 		ASSERT(dqp->q_nrefs == 0);
 		nextdqp = dqp->dq_flnext;
-		XQM_MPLIST_REMOVE(&(XFS_QI_MPL_LIST(dqp->q_mount)), dqp);
 		XQM_HASHLIST_REMOVE(hash, dqp);
+		list_del_init(&dqp->q_mplist);
+		mp->m_quotainfo->qi_dquots--;
+		mp->m_quotainfo->qi_dqreclaims++;
 		xfs_dqfunlock(dqp);
-		xfs_qm_mplist_unlock(dqp->q_mount);
+		mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
 		mutex_unlock(&hash->qh_lock);
 
  off_freelist:
@@ -2134,6 +2136,7 @@ xfs_qm_dqreclaim_one(void)
 	xfs_qm_freelist_lock(xfs_Gqm);
 
 	FOREACH_DQUOT_IN_FREELIST(dqp, &(xfs_Gqm->qm_dqfreelist)) {
+		struct xfs_mount *mp = dqp->q_mount;
 		xfs_dqlock(dqp);
 
 		/*
@@ -2161,10 +2164,10 @@ xfs_qm_dqreclaim_one(void)
 		 * life easier.
 		 */
 		if (dqp->dq_flags & XFS_DQ_INACTIVE) {
-			ASSERT(dqp->q_mount == NULL);
+			ASSERT(mp == NULL);
 			ASSERT(! XFS_DQ_IS_DIRTY(dqp));
 			ASSERT(dqp->HL_PREVP == NULL);
-			ASSERT(dqp->MPL_PREVP == NULL);
+			ASSERT(list_empty(&dqp->q_mplist));
 			XQM_FREELIST_REMOVE(dqp);
 			xfs_dqunlock(dqp);
 			dqpout = dqp;
@@ -2173,7 +2176,7 @@ xfs_qm_dqreclaim_one(void)
 		}
 
 		ASSERT(dqp->q_hash);
-		ASSERT(dqp->MPL_PREVP);
+		ASSERT(!list_empty(&dqp->q_mplist));
 
 		/*
 		 * Try to grab the flush lock. If this dquot is in the process of
@@ -2201,14 +2204,14 @@ xfs_qm_dqreclaim_one(void)
 			 */
 			error = xfs_qm_dqflush(dqp, 0);
 			if (error) {
-				xfs_fs_cmn_err(CE_WARN, dqp->q_mount,
+				xfs_fs_cmn_err(CE_WARN, mp,
 			"xfs_qm_dqreclaim: dquot %p flush failed", dqp);
 			}
 			xfs_dqunlock(dqp); /* dqflush unlocks dqflock */
 			continue;
 		}
 
-		if (! xfs_qm_mplist_nowait(dqp->q_mount)) {
+		if (!mutex_trylock(&mp->m_quotainfo->qi_dqlist_lock)) {
 			xfs_dqfunlock(dqp);
 			xfs_dqunlock(dqp);
 			continue;
@@ -2220,13 +2223,15 @@ xfs_qm_dqreclaim_one(void)
 		trace_xfs_dqreclaim_unlink(dqp);
 
 		ASSERT(dqp->q_nrefs == 0);
-		XQM_MPLIST_REMOVE(&(XFS_QI_MPL_LIST(dqp->q_mount)), dqp);
+		list_del_init(&dqp->q_mplist);
+		mp->m_quotainfo->qi_dquots--;
+		mp->m_quotainfo->qi_dqreclaims++;
 		XQM_HASHLIST_REMOVE(dqp->q_hash, dqp);
 		XQM_FREELIST_REMOVE(dqp);
 		dqpout = dqp;
 		mutex_unlock(&dqp->q_hash->qh_lock);
  mplistunlock:
-		xfs_qm_mplist_unlock(dqp->q_mount);
+		mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
 		xfs_dqfunlock(dqp);
 		xfs_dqunlock(dqp);
 		if (dqpout)
diff --git a/fs/xfs/quota/xfs_qm.h b/fs/xfs/quota/xfs_qm.h
index 495564b..91bd053 100644
--- a/fs/xfs/quota/xfs_qm.h
+++ b/fs/xfs/quota/xfs_qm.h
@@ -106,7 +106,9 @@ typedef struct xfs_qm {
 typedef struct xfs_quotainfo {
 	xfs_inode_t	*qi_uquotaip;	 /* user quota inode */
 	xfs_inode_t	*qi_gquotaip;	 /* group quota inode */
-	xfs_dqlist_t	 qi_dqlist;	 /* all dquots in filesys */
+	struct list_head qi_dqlist;	 /* all dquots in filesys */
+	struct mutex	 qi_dqlist_lock;
+	int		 qi_dquots;
 	int		 qi_dqreclaims;	 /* a change here indicates
 					    a removal in the dqlist */
 	time_t		 qi_btimelimit;	 /* limit for blks timer */
diff --git a/fs/xfs/quota/xfs_qm_syscalls.c b/fs/xfs/quota/xfs_qm_syscalls.c
index 5d0ee8d..7275e51 100644
--- a/fs/xfs/quota/xfs_qm_syscalls.c
+++ b/fs/xfs/quota/xfs_qm_syscalls.c
@@ -442,7 +442,7 @@ xfs_qm_scall_getqstat(
 			IRELE(gip);
 	}
 	if (mp->m_quotainfo) {
-		out->qs_incoredqs = XFS_QI_MPLNDQUOTS(mp);
+		out->qs_incoredqs = mp->m_quotainfo->qi_dquots;
 		out->qs_btimelimit = XFS_QI_BTIMELIMIT(mp);
 		out->qs_itimelimit = XFS_QI_ITIMELIMIT(mp);
 		out->qs_rtbtimelimit = XFS_QI_RTBTIMELIMIT(mp);
diff --git a/fs/xfs/quota/xfs_quota_priv.h b/fs/xfs/quota/xfs_quota_priv.h
index 8286b28..6f4bbae 100644
--- a/fs/xfs/quota/xfs_quota_priv.h
+++ b/fs/xfs/quota/xfs_quota_priv.h
@@ -29,7 +29,6 @@
 
 #define XFS_DQ_IS_ADDEDTO_TRX(t, d)	((d)->q_transp == (t))
 
-#define XFS_QI_MPLRECLAIMS(mp)	((mp)->m_quotainfo->qi_dqreclaims)
 #define XFS_QI_UQIP(mp)		((mp)->m_quotainfo->qi_uquotaip)
 #define XFS_QI_GQIP(mp)		((mp)->m_quotainfo->qi_gquotaip)
 #define XFS_QI_DQCHUNKLEN(mp)	((mp)->m_quotainfo->qi_dqchunklen)
@@ -41,19 +40,6 @@
 #define XFS_QI_IWARNLIMIT(mp)	((mp)->m_quotainfo->qi_iwarnlimit)
 #define XFS_QI_QOFFLOCK(mp)	((mp)->m_quotainfo->qi_quotaofflock)
 
-#define XFS_QI_MPL_LIST(mp)	((mp)->m_quotainfo->qi_dqlist)
-#define XFS_QI_MPLNEXT(mp)	((mp)->m_quotainfo->qi_dqlist.qh_next)
-#define XFS_QI_MPLNDQUOTS(mp)	((mp)->m_quotainfo->qi_dqlist.qh_nelems)
-
-#define xfs_qm_mplist_lock(mp) \
-	mutex_lock(&(XFS_QI_MPL_LIST(mp).qh_lock))
-#define xfs_qm_mplist_nowait(mp) \
-	mutex_trylock(&(XFS_QI_MPL_LIST(mp).qh_lock))
-#define xfs_qm_mplist_unlock(mp) \
-	mutex_unlock(&(XFS_QI_MPL_LIST(mp).qh_lock))
-#define XFS_QM_IS_MPLIST_LOCKED(mp) \
-	mutex_is_locked(&(XFS_QI_MPL_LIST(mp).qh_lock))
-
 #define xfs_qm_freelist_lock(qm) \
 	mutex_lock(&((qm)->qm_dqfreelist.qh_lock))
 #define xfs_qm_freelist_lock_nowait(qm) \
@@ -88,8 +74,6 @@
 
 #define HL_PREVP	dq_hashlist.ql_prevp
 #define HL_NEXT		dq_hashlist.ql_next
-#define MPL_PREVP	dq_mplist.ql_prevp
-#define MPL_NEXT	dq_mplist.ql_next
 
 
 #define _LIST_REMOVE(h, dqp, PVP, NXT)				\
@@ -116,9 +100,6 @@
 		 (h)->qh_nelems++;				\
 	 }
 
-#define FOREACH_DQUOT_IN_MP(dqp, mp) \
-	for ((dqp) = XFS_QI_MPLNEXT(mp); (dqp) != NULL; (dqp) = (dqp)->MPL_NEXT)
-
 #define FOREACH_DQUOT_IN_FREELIST(dqp, qlist)	\
 for ((dqp) = (qlist)->qh_next; (dqp) != (xfs_dquot_t *)(qlist); \
      (dqp) = (dqp)->dq_flnext)
@@ -129,16 +110,10 @@ for ((dqp) = (qlist)->qh_next; (dqp) != (xfs_dquot_t *)(qlist); \
 #define XQM_FREELIST_INSERT(h, dqp)	\
 	 xfs_qm_freelist_append(h, dqp)
 
-#define XQM_MPLIST_INSERT(h, dqp)	\
-	 _LIST_INSERT(h, dqp, MPL_PREVP, MPL_NEXT)
-
 #define XQM_HASHLIST_REMOVE(h, dqp)	\
 	 _LIST_REMOVE(h, dqp, HL_PREVP, HL_NEXT)
 #define XQM_FREELIST_REMOVE(dqp)	\
 	 xfs_qm_freelist_unlink(dqp)
-#define XQM_MPLIST_REMOVE(h, dqp)	\
-	{ _LIST_REMOVE(h, dqp, MPL_PREVP, MPL_NEXT); \
-	  XFS_QI_MPLRECLAIMS((dqp)->q_mount)++; }
 
 #define XFS_DQ_IS_LOGITEM_INITD(dqp)	((dqp)->q_logitem.qli_dquot == (dqp))
 
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
