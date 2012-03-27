Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2RGkksm128345 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 11:46:46 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	L4SRki12RshOT91O (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Mar 2012 09:46:45 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1SCZXg-0007AY-KU
	for xfs@oss.sgi.com; Tue, 27 Mar 2012 16:46:44 +0000
Message-Id: <20120327164644.597749707@bombadil.infradead.org>
Date: Tue, 27 Mar 2012 12:44:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 03/10] xfs: allow assigning the tail lsn with the AIL lock held
References: <20120327164400.967415009@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-lockless-xlog_assign_tail_lsn
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

Provide a variant of xlog_assign_tail_lsn that has the AIL lock already
held.  By doing so we do an additional atomic_read + atomic_set under
the lock, which comes down to two instructions.

Switch xfs_trans_ail_update_bulk and xfs_trans_ail_delete_bulk to the
new version to reduce the number of lock roundtrips, and prepare for
a new addition that would require a third lock roundtrip in
xfs_trans_ail_delete_bulk.  This addition is also the reason for
slightly rearranging the conditionals and relying on xfs_log_space_wake
for checking that the filesystem has been shut down internally.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_log.c        |   31 +++++++++++++++++++++++--------
 fs/xfs/xfs_log.h        |    1 +
 fs/xfs/xfs_trans_ail.c  |   22 +++++++++++++++-------
 fs/xfs/xfs_trans_priv.h |    1 +
 4 files changed, 40 insertions(+), 15 deletions(-)

Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2012-03-16 12:44:55.880363918 +0100
+++ xfs/fs/xfs/xfs_log.c	2012-03-16 12:50:24.040370003 +0100
@@ -915,27 +915,42 @@ xfs_log_need_covered(xfs_mount_t *mp)
  * We may be holding the log iclog lock upon entering this routine.
  */
 xfs_lsn_t
-xlog_assign_tail_lsn(
+xlog_assign_tail_lsn_locked(
 	struct xfs_mount	*mp)
 {
-	xfs_lsn_t		tail_lsn;
 	struct log		*log = mp->m_log;
+	struct xfs_log_item	*lip;
+	xfs_lsn_t		tail_lsn;
+
+	assert_spin_locked(&mp->m_ail->xa_lock);
 
 	/*
 	 * To make sure we always have a valid LSN for the log tail we keep
 	 * track of the last LSN which was committed in log->l_last_sync_lsn,
-	 * and use that when the AIL was empty and xfs_ail_min_lsn returns 0.
-	 *
-	 * If the AIL has been emptied we also need to wake any process
-	 * waiting for this condition.
+	 * and use that when the AIL was empty.
 	 */
-	tail_lsn = xfs_ail_min_lsn(mp->m_ail);
-	if (!tail_lsn)
+	lip = xfs_ail_min(mp->m_ail);
+	if (lip)
+		tail_lsn = lip->li_lsn;
+	else
 		tail_lsn = atomic64_read(&log->l_last_sync_lsn);
 	atomic64_set(&log->l_tail_lsn, tail_lsn);
 	return tail_lsn;
 }
 
+xfs_lsn_t
+xlog_assign_tail_lsn(
+	struct xfs_mount	*mp)
+{
+	xfs_lsn_t		tail_lsn;
+
+	spin_lock(&mp->m_ail->xa_lock);
+	tail_lsn = xlog_assign_tail_lsn_locked(mp);
+	spin_unlock(&mp->m_ail->xa_lock);
+
+	return tail_lsn;
+}
+
 /*
  * Return the space in the log between the tail and the head.  The head
  * is passed in the cycle/bytes formal parms.  In the special case where
Index: xfs/fs/xfs/xfs_log.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log.h	2012-03-16 12:44:55.893697252 +0100
+++ xfs/fs/xfs/xfs_log.h	2012-03-16 12:47:09.127033055 +0100
@@ -152,6 +152,7 @@ int	  xfs_log_mount(struct xfs_mount	*mp
 			int		 	num_bblocks);
 int	  xfs_log_mount_finish(struct xfs_mount *mp);
 xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
+xfs_lsn_t xlog_assign_tail_lsn_locked(struct xfs_mount *mp);
 void	  xfs_log_space_wake(struct xfs_mount *mp);
 int	  xfs_log_notify(struct xfs_mount	*mp,
 			 struct xlog_in_core	*iclog,
Index: xfs/fs/xfs/xfs_trans_ail.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_ail.c	2012-03-16 12:44:55.917030586 +0100
+++ xfs/fs/xfs/xfs_trans_ail.c	2012-03-16 12:50:20.483703269 +0100
@@ -79,7 +79,7 @@ xfs_ail_check(
  * Return a pointer to the first item in the AIL.  If the AIL is empty, then
  * return NULL.
  */
-static xfs_log_item_t *
+xfs_log_item_t *
 xfs_ail_min(
 	struct xfs_ail  *ailp)
 {
@@ -667,11 +667,15 @@ xfs_trans_ail_update_bulk(
 
 	if (!list_empty(&tmp))
 		xfs_ail_splice(ailp, cur, &tmp, lsn);
-	spin_unlock(&ailp->xa_lock);
 
-	if (mlip_changed && !XFS_FORCED_SHUTDOWN(ailp->xa_mount)) {
-		xlog_assign_tail_lsn(ailp->xa_mount);
+	if (mlip_changed) {
+		if (!XFS_FORCED_SHUTDOWN(ailp->xa_mount))
+			xlog_assign_tail_lsn_locked(ailp->xa_mount);
+		spin_unlock(&ailp->xa_lock);
+
 		xfs_log_space_wake(ailp->xa_mount);
+	} else {
+		spin_unlock(&ailp->xa_lock);
 	}
 }
 
@@ -729,11 +733,15 @@ xfs_trans_ail_delete_bulk(
 		if (mlip == lip)
 			mlip_changed = 1;
 	}
-	spin_unlock(&ailp->xa_lock);
 
-	if (mlip_changed && !XFS_FORCED_SHUTDOWN(ailp->xa_mount)) {
-		xlog_assign_tail_lsn(ailp->xa_mount);
+	if (mlip_changed) {
+		if (!XFS_FORCED_SHUTDOWN(ailp->xa_mount))
+			xlog_assign_tail_lsn_locked(ailp->xa_mount);
+		spin_unlock(&ailp->xa_lock);
+
 		xfs_log_space_wake(ailp->xa_mount);
+	} else {
+		spin_unlock(&ailp->xa_lock);
 	}
 }
 
Index: xfs/fs/xfs/xfs_trans_priv.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_priv.h	2012-03-16 12:44:55.943697253 +0100
+++ xfs/fs/xfs/xfs_trans_priv.h	2012-03-16 12:49:31.993702371 +0100
@@ -102,6 +102,7 @@ xfs_trans_ail_delete(
 
 void			xfs_ail_push(struct xfs_ail *, xfs_lsn_t);
 void			xfs_ail_push_all(struct xfs_ail *);
+struct xfs_log_item	*xfs_ail_min(struct xfs_ail  *ailp);
 xfs_lsn_t		xfs_ail_min_lsn(struct xfs_ail *ailp);
 
 struct xfs_log_item *	xfs_trans_ail_cursor_first(struct xfs_ail *ailp,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
