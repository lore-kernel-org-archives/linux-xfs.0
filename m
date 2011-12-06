Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6LwumW003941 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 15:58:56 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F16EC1F45C00
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 13:58:54 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	WhjGFUyw9EwizRjc for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 13:58:54 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RY32M-0006Q9-EM
	for xfs@oss.sgi.com; Tue, 06 Dec 2011 21:58:54 +0000
Message-Id: <20111206215854.407041212@bombadil.infradead.org>
Date: Tue, 06 Dec 2011 16:58:16 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 10/19] xfs: remove XFS_DQ_INACTIVE
References: <20111206215806.844405397@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-XFS_DQ_INACTIVE
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

Free dquots when purging them during umount instead of keeping them around
on the freelist in a degraded state.  The out of order locking in
xfs_qm_dqpurge will be removed again later in this series.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

---
 fs/xfs/xfs_dquot.c |   28 ++++++++++++++----------
 fs/xfs/xfs_qm.c    |   61 +++++------------------------------------------------
 fs/xfs/xfs_quota.h |    4 ---
 3 files changed, 24 insertions(+), 69 deletions(-)

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2011-12-06 15:39:14.567014922 +0100
+++ xfs/fs/xfs/xfs_dquot.c	2011-12-06 15:40:48.533683330 +0100
@@ -1302,6 +1302,14 @@ xfs_qm_dqpurge(
 	ASSERT(mutex_is_locked(&mp->m_quotainfo->qi_dqlist_lock));
 	ASSERT(mutex_is_locked(&dqp->q_hash->qh_lock));
 
+	/*
+	 * XXX(hch): horrible locking order, will get cleaned up ASAP.
+	 */
+	if (!mutex_trylock(&xfs_Gqm->qm_dqfrlist_lock)) {
+		mutex_unlock(&dqp->q_hash->qh_lock);
+		return 1;
+	}
+
 	xfs_dqlock(dqp);
 	/*
 	 * We really can't afford to purge a dquot that is
@@ -1364,25 +1372,23 @@ xfs_qm_dqpurge(
 
 	list_del_init(&dqp->q_hashlist);
 	qh->qh_version++;
+
 	list_del_init(&dqp->q_mplist);
 	mp->m_quotainfo->qi_dqreclaims++;
 	mp->m_quotainfo->qi_dquots--;
-	/*
-	 * XXX Move this to the front of the freelist, if we can get the
-	 * freelist lock.
-	 */
-	ASSERT(!list_empty(&dqp->q_freelist));
 
-	dqp->q_mount = NULL;
-	dqp->q_hash = NULL;
-	dqp->dq_flags = XFS_DQ_INACTIVE;
-	memset(&dqp->q_core, 0, sizeof(dqp->q_core));
+	list_del_init(&dqp->q_freelist);
+	xfs_Gqm->qm_dqfrlist_cnt--;
+
 	xfs_dqfunlock(dqp);
 	xfs_dqunlock(dqp);
+
+	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
 	mutex_unlock(&qh->qh_lock);
-	return (0);
-}
 
+	xfs_qm_dqdestroy(dqp);
+	return 0;
+}
 
 /*
  * Give the buffer a little push if it is incore and
Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2011-12-06 15:38:33.840347499 +0100
+++ xfs/fs/xfs/xfs_qm.c	2011-12-06 15:40:10.733682629 +0100
@@ -154,12 +154,17 @@ STATIC void
 xfs_qm_destroy(
 	struct xfs_qm	*xqm)
 {
-	struct xfs_dquot *dqp, *n;
 	int		hsize, i;
 
 	ASSERT(xqm != NULL);
 	ASSERT(xqm->qm_nrefs == 0);
+
 	unregister_shrinker(&xfs_qm_shaker);
+
+	mutex_lock(&xqm->qm_dqfrlist_lock);
+	ASSERT(list_empty(&xqm->qm_dqfrlist));
+	mutex_unlock(&xqm->qm_dqfrlist_lock);
+
 	hsize = xqm->qm_dqhashmask + 1;
 	for (i = 0; i < hsize; i++) {
 		xfs_qm_list_destroy(&(xqm->qm_usr_dqhtable[i]));
@@ -171,17 +176,6 @@ xfs_qm_destroy(
 	xqm->qm_grp_dqhtable = NULL;
 	xqm->qm_dqhashmask = 0;
 
-	/* frlist cleanup */
-	mutex_lock(&xqm->qm_dqfrlist_lock);
-	list_for_each_entry_safe(dqp, n, &xqm->qm_dqfrlist, q_freelist) {
-		xfs_dqlock(dqp);
-		list_del_init(&dqp->q_freelist);
-		xfs_Gqm->qm_dqfrlist_cnt--;
-		xfs_dqunlock(dqp);
-		xfs_qm_dqdestroy(dqp);
-	}
-	mutex_unlock(&xqm->qm_dqfrlist_lock);
-	mutex_destroy(&xqm->qm_dqfrlist_lock);
 	kmem_free(xqm);
 }
 
@@ -232,34 +226,10 @@ STATIC void
 xfs_qm_rele_quotafs_ref(
 	struct xfs_mount *mp)
 {
-	xfs_dquot_t	*dqp, *n;
-
 	ASSERT(xfs_Gqm);
 	ASSERT(xfs_Gqm->qm_nrefs > 0);
 
 	/*
-	 * Go thru the freelist and destroy all inactive dquots.
-	 */
-	mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
-
-	list_for_each_entry_safe(dqp, n, &xfs_Gqm->qm_dqfrlist, q_freelist) {
-		xfs_dqlock(dqp);
-		if (dqp->dq_flags & XFS_DQ_INACTIVE) {
-			ASSERT(dqp->q_mount == NULL);
-			ASSERT(! XFS_DQ_IS_DIRTY(dqp));
-			ASSERT(list_empty(&dqp->q_hashlist));
-			ASSERT(list_empty(&dqp->q_mplist));
-			list_del_init(&dqp->q_freelist);
-			xfs_Gqm->qm_dqfrlist_cnt--;
-			xfs_dqunlock(dqp);
-			xfs_qm_dqdestroy(dqp);
-		} else {
-			xfs_dqunlock(dqp);
-		}
-	}
-	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
-
-	/*
 	 * Destroy the entire XQM. If somebody mounts with quotaon, this'll
 	 * be restarted.
 	 */
@@ -1728,8 +1698,6 @@ again:
 		 * both the dquot and the freelistlock.
 		 */
 		if (dqp->dq_flags & XFS_DQ_WANT) {
-			ASSERT(! (dqp->dq_flags & XFS_DQ_INACTIVE));
-
 			trace_xfs_dqreclaim_want(dqp);
 			XQM_STATS_INC(xqmstats.xs_qm_dqwants);
 			restarts++;
@@ -1737,23 +1705,6 @@ again:
 			goto dqunlock;
 		}
 
-		/*
-		 * If the dquot is inactive, we are assured that it is
-		 * not on the mplist or the hashlist, and that makes our
-		 * life easier.
-		 */
-		if (dqp->dq_flags & XFS_DQ_INACTIVE) {
-			ASSERT(mp == NULL);
-			ASSERT(! XFS_DQ_IS_DIRTY(dqp));
-			ASSERT(list_empty(&dqp->q_hashlist));
-			ASSERT(list_empty(&dqp->q_mplist));
-			list_del_init(&dqp->q_freelist);
-			xfs_Gqm->qm_dqfrlist_cnt--;
-			dqpout = dqp;
-			XQM_STATS_INC(xqmstats.xs_qm_dqinact_reclaims);
-			goto dqunlock;
-		}
-
 		ASSERT(dqp->q_hash);
 		ASSERT(!list_empty(&dqp->q_mplist));
 
Index: xfs/fs/xfs/xfs_quota.h
===================================================================
--- xfs.orig/fs/xfs/xfs_quota.h	2011-12-06 15:37:21.710346162 +0100
+++ xfs/fs/xfs/xfs_quota.h	2011-12-06 15:40:10.733682629 +0100
@@ -88,7 +88,6 @@ typedef struct xfs_dqblk {
 #define XFS_DQ_GROUP		0x0004		/* a group quota */
 #define XFS_DQ_DIRTY		0x0008		/* dquot is dirty */
 #define XFS_DQ_WANT		0x0010		/* for lookup/reclaim race */
-#define XFS_DQ_INACTIVE		0x0020		/* dq off mplist & hashlist */
 
 #define XFS_DQ_ALLTYPES		(XFS_DQ_USER|XFS_DQ_PROJ|XFS_DQ_GROUP)
 
@@ -97,8 +96,7 @@ typedef struct xfs_dqblk {
 	{ XFS_DQ_PROJ,		"PROJ" }, \
 	{ XFS_DQ_GROUP,		"GROUP" }, \
 	{ XFS_DQ_DIRTY,		"DIRTY" }, \
-	{ XFS_DQ_WANT,		"WANT" }, \
-	{ XFS_DQ_INACTIVE,	"INACTIVE" }
+	{ XFS_DQ_WANT,		"WANT" }
 
 /*
  * In the worst case, when both user and group quotas are on,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
