Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9SA3fIU145402 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 05:03:41 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2DC51203857
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 03:03:39 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	E9ZFIZYlqUORSBnH for <xfs@oss.sgi.com>;
	Fri, 28 Oct 2011 03:03:39 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RJjHn-00032B-Ji
	for xfs@oss.sgi.com; Fri, 28 Oct 2011 10:03:39 +0000
Message-Id: <20111028100339.562764081@bombadil.infradead.org>
Date: Fri, 28 Oct 2011 05:54:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 22/45] xfs: remove XFS_DQ_INACTIVE
References: <20111028095423.796574703@bombadil.infradead.org>
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


---
 fs/xfs/xfs_dquot.c |   25 +++++++++++++--------
 fs/xfs/xfs_qm.c    |   61 +++++------------------------------------------------
 fs/xfs/xfs_quota.h |    4 ---
 3 files changed, 23 insertions(+), 67 deletions(-)

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2011-10-27 22:40:02.770171231 +0200
+++ xfs/fs/xfs/xfs_dquot.c	2011-10-27 22:40:03.314171810 +0200
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
@@ -1364,22 +1372,21 @@ xfs_qm_dqpurge(
 
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
+
+	xfs_qm_dqdestroy(dqp);
 	return (0);
 }
 
Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2011-10-27 22:40:02.254174248 +0200
+++ xfs/fs/xfs/xfs_qm.c	2011-10-27 22:40:03.314171810 +0200
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
@@ -1727,8 +1697,6 @@ again:
 		 * both the dquot and the freelistlock.
 		 */
 		if (dqp->dq_flags & XFS_DQ_WANT) {
-			ASSERT(! (dqp->dq_flags & XFS_DQ_INACTIVE));
-
 			trace_xfs_dqreclaim_want(dqp);
 			XQM_STATS_INC(xqmstats.xs_qm_dqwants);
 			restarts++;
@@ -1736,23 +1704,6 @@ again:
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
--- xfs.orig/fs/xfs/xfs_quota.h	2011-10-27 22:40:01.238188776 +0200
+++ xfs/fs/xfs/xfs_quota.h	2011-10-27 22:40:03.322220265 +0200
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
