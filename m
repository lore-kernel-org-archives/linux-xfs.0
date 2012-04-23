Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3N5xO0Z127429 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 00:59:24 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	vmHLEU2ntnAswIdC for <xfs@oss.sgi.com>;
	Sun, 22 Apr 2012 22:59:22 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SMCIy-0001Zh-F7
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:20 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SMCIo-0004XO-C9
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/37] xfs: allow assigning the tail lsn with the AIL lock held
Date: Mon, 23 Apr 2012 15:58:33 +1000
Message-Id: <1335160747-17254-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1335160747-17254-1-git-send-email-david@fromorbit.com>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_log.c        |   31 +++++++++++++++++++++++--------
 fs/xfs/xfs_log.h        |    1 +
 fs/xfs/xfs_trans_ail.c  |   22 +++++++++++++++-------
 fs/xfs/xfs_trans_priv.h |    1 +
 4 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 6db1fef..418d5d7 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -916,27 +916,42 @@ xfs_log_need_covered(xfs_mount_t *mp)
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
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 2c622be..748d312 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -152,6 +152,7 @@ int	  xfs_log_mount(struct xfs_mount	*mp,
 			int		 	num_bblocks);
 int	  xfs_log_mount_finish(struct xfs_mount *mp);
 xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
+xfs_lsn_t xlog_assign_tail_lsn_locked(struct xfs_mount *mp);
 void	  xfs_log_space_wake(struct xfs_mount *mp);
 int	  xfs_log_notify(struct xfs_mount	*mp,
 			 struct xlog_in_core	*iclog,
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 1dead07..77acc53 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
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
 
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 8ab2ced..46a1ebd 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -102,6 +102,7 @@ xfs_trans_ail_delete(
 
 void			xfs_ail_push(struct xfs_ail *, xfs_lsn_t);
 void			xfs_ail_push_all(struct xfs_ail *);
+struct xfs_log_item	*xfs_ail_min(struct xfs_ail  *ailp);
 xfs_lsn_t		xfs_ail_min_lsn(struct xfs_ail *ailp);
 
 struct xfs_log_item *	xfs_trans_ail_cursor_first(struct xfs_ail *ailp,
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
