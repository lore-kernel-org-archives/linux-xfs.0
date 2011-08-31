Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7VKcL0h226683 for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 15:38:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 809BC1E81C23
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 13:38:20 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	iAfH2sU220TTdYFB for <xfs@oss.sgi.com>;
	Wed, 31 Aug 2011 13:38:20 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QyrYC-00071z-1E
	for xfs@oss.sgi.com; Wed, 31 Aug 2011 20:38:20 +0000
Message-Id: <20110831203819.983355724@bombadil.infradead.org>
Date: Wed, 31 Aug 2011 16:36:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 09/14] xfs: nest the qm_dqfrlist_lock insise the dquot qlock
References: <20110831203647.455809764@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-change-quota-freelist-lock-ordering
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

Make sure the xfs_qm_dqput fast path works without trylock loops by nesting
the freelist lock inside the dquot qlock, and do the trylock in dquot reclaim
and purge instead.  Document our new lock ordering now that it has settled.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2011-08-31 10:17:41.829108522 +0200
+++ xfs/fs/xfs/xfs_dquot.c	2011-08-31 10:20:33.594112076 +0200
@@ -39,20 +39,20 @@
 #include "xfs_qm.h"
 #include "xfs_trace.h"
 
-
 /*
-   LOCK ORDER
+ * Lock ordering:
+ *
+ * ip->i_lock
+ *   qh->qh_lock
+ *     qi->qi_dqlist_lock
+ *       dquot->q_qlock
+ *         dquot->q_flush
+ *         xfs_Gqm->qm_dqfrlist_lock
+ *
+ * If two dquots need to be locked the order is user before group/project,
+ * otherwise by the lowest id first, see xfs_dqlock2.
+ */
 
-   inode lock		    (ilock)
-   dquot hash-chain lock    (hashlock)
-   xqm dquot freelist lock  (freelistlock
-   mount's dquot list lock  (mplistlock)
-   user dquot lock - lock ordering among dquots is based on the uid or gid
-   group dquot lock - similar to udquots. Between the two dquots, the udquot
-		      has to be locked first.
-   pin lock - the dquot lock must be held to take this lock.
-   flush lock - ditto.
-*/
 
 #ifdef DEBUG
 xfs_buftarg_t *xfs_dqerror_target;
@@ -980,69 +980,49 @@ restart:
  */
 void
 xfs_qm_dqput(
-	xfs_dquot_t	*dqp)
+	struct xfs_dquot	*dqp)
 {
-	xfs_dquot_t	*gdqp;
+	struct xfs_dquot	*gdqp;
 
 	ASSERT(dqp->q_nrefs > 0);
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 
 	trace_xfs_dqput(dqp);
 
-	if (dqp->q_nrefs != 1) {
-		dqp->q_nrefs--;
+recurse:
+	if (--dqp->q_nrefs > 0) {
 		xfs_dqunlock(dqp);
 		return;
 	}
 
-	/*
-	 * drop the dqlock and acquire the freelist and dqlock
-	 * in the right order; but try to get it out-of-order first
-	 */
-	if (!mutex_trylock(&xfs_Gqm->qm_dqfrlist_lock)) {
-		trace_xfs_dqput_wait(dqp);
-		xfs_dqunlock(dqp);
-		mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
-		xfs_dqlock(dqp);
-	}
-
-	while (1) {
-		gdqp = NULL;
+	trace_xfs_dqput_free(dqp);
 
-		/* We can't depend on nrefs being == 1 here */
-		if (--dqp->q_nrefs == 0) {
-			trace_xfs_dqput_free(dqp);
-
-			if (list_empty(&dqp->q_freelist)) {
-				list_add_tail(&dqp->q_freelist, &xfs_Gqm->qm_dqfrlist);
-				xfs_Gqm->qm_dqfrlist_cnt++;
-			}
+	mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
+	if (list_empty(&dqp->q_freelist)) {
+		list_add_tail(&dqp->q_freelist, &xfs_Gqm->qm_dqfrlist);
+		xfs_Gqm->qm_dqfrlist_cnt++;
+	}
+	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
 
-			/*
-			 * If we just added a udquot to the freelist, then
-			 * we want to release the gdquot reference that
-			 * it (probably) has. Otherwise it'll keep the
-			 * gdquot from getting reclaimed.
-			 */
-			if ((gdqp = dqp->q_gdquot)) {
-				/*
-				 * Avoid a recursive dqput call
-				 */
-				xfs_dqlock(gdqp);
-				dqp->q_gdquot = NULL;
-			}
-		}
-		xfs_dqunlock(dqp);
+	/*
+	 * If we just added a udquot to the freelist, then we want to release
+	 * the gdquot reference that it (probably) has. Otherwise it'll keep
+	 * the gdquot from getting reclaimed.
+	 */
+	gdqp = dqp->q_gdquot;
+	if (gdqp) {
+		xfs_dqlock(gdqp);
+		dqp->q_gdquot = NULL;
+	}
+	xfs_dqunlock(dqp);
 
-		/*
-		 * If we had a group quota inside the user quota as a hint,
-		 * release it now.
-		 */
-		if (! gdqp)
-			break;
+	/*
+	 * If we had a group quota hint, release it now.
+	 */
+	if (gdqp) {
 		dqp = gdqp;
+		goto recurse;
 	}
-	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
 }
 
 /*
Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2011-08-31 10:20:16.401169019 +0200
+++ xfs/fs/xfs/xfs_qm.c	2011-08-31 10:20:33.594112076 +0200
@@ -1669,7 +1669,9 @@ xfs_qm_dqreclaim_one(void)
 restart:
 	list_for_each_entry(dqp, &xfs_Gqm->qm_dqfrlist, q_freelist) {
 		struct xfs_mount *mp = dqp->q_mount;
-		xfs_dqlock(dqp);
+
+		if (!xfs_dqlock_nowait(dqp))
+			continue;
 
 		/*
 		 * This dquot has already been grabbed by dqlookup.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
