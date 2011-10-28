Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9SA3hG8145499 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 05:03:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 63C08FCE493
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 03:03:42 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	2EoUyhJ7lcCP4ZvX for <xfs@oss.sgi.com>;
	Fri, 28 Oct 2011 03:03:42 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RJjHp-00037v-Js
	for xfs@oss.sgi.com; Fri, 28 Oct 2011 10:03:41 +0000
Message-Id: <20111028100341.572429627@bombadil.infradead.org>
Date: Fri, 28 Oct 2011 05:54:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 33/45] xfs: reclaim clean dquots first
References: <20111028095423.796574703@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-quota-fix-shrinker-2
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

Always try to reclaim clean dquots before doing I/O in the dquot shrinker.
This is still a bit suboptimal compared to how e.g. the inode shrinker
works, but it is required for the removal of the global delwri lists.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_qm.c |   35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2011-10-27 22:40:08.594173542 +0200
+++ xfs/fs/xfs/xfs_qm.c	2011-10-27 22:40:09.097172140 +0200
@@ -1599,7 +1599,8 @@ xfs_qm_init_quotainos(
 
 STATIC bool
 xfs_qm_dqreclaim_one(
-	struct xfs_dquot	*dqp)
+	struct xfs_dquot	*dqp,
+	bool			write_dirty)
 {
 	struct xfs_mount	*mp = dqp->q_mount;
 	int			error;
@@ -1642,23 +1643,18 @@ xfs_qm_dqreclaim_one(
 	 * dirty dquots.
 	 */
 	if (XFS_DQ_IS_DIRTY(dqp)) {
+		if (!write_dirty)
+			goto out_busy;
+
 		trace_xfs_dqreclaim_dirty(dqp);
 
-		/*
-		 * We flush it delayed write, so don't bother releasing the
-		 * freelist lock.
-		 */
-		error = xfs_qm_dqflush(dqp, 0);
+		mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
+		error = xfs_qm_dqflush(dqp, SYNC_WAIT);
 		if (error) {
 			xfs_warn(mp, "%s: dquot %p flush failed",
 				 __func__, dqp);
 		}
-
-		/*
-		 * Give the dquot another try on the freelist, as the
-		 * flushing will take some time.
-		 */
-		goto out_busy;
+		mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
 	}
 	xfs_dqfunlock(dqp);
 
@@ -1698,7 +1694,7 @@ xfs_qm_shake(
 	struct shrink_control	*sc)
 {
 	int			nr_to_scan = sc->nr_to_scan;
-	struct xfs_dquot	*dqp;
+	struct xfs_dquot	*dqp, *n;
 
 	if ((sc->gfp_mask & (__GFP_FS|__GFP_WAIT)) != (__GFP_FS|__GFP_WAIT))
 		return 0;
@@ -1706,16 +1702,27 @@ xfs_qm_shake(
 	if (!nr_to_scan)
 		goto out;
 
+	/*
+	 * We first try to reclaim only clean dquots, and only if we have to
+	 * start writing dirty ones.
+	 */
 	mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
+	list_for_each_entry_safe(dqp, n, &xfs_Gqm->qm_dqfrlist, q_freelist) {
+		if (nr_to_scan-- <= 0)
+			goto out_unlock;
+		xfs_qm_dqreclaim_one(dqp, false);
+	}
+
 	while (!list_empty(&xfs_Gqm->qm_dqfrlist)) {
 		if (nr_to_scan-- <= 0)
 			break;
 		dqp = list_first_entry(&xfs_Gqm->qm_dqfrlist, struct xfs_dquot,
 				       q_freelist);
 
-		if (!xfs_qm_dqreclaim_one(dqp))
+		if (!xfs_qm_dqreclaim_one(dqp, true))
 			list_move_tail(&dqp->q_freelist, &xfs_Gqm->qm_dqfrlist);
 	}
+out_unlock:
 	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
 out:
 	return (xfs_Gqm->qm_dqfrlist_cnt / 100) * sysctl_vfs_cache_pressure;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
