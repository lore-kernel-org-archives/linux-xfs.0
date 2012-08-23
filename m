Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N53LJT135050 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:21 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	BAouNBBDqyBVXaUe for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:06 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PaK-0003GJ-PW
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:01 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PaA-0003e6-O1
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 036/102] xfs: split tail_lsn assignments from log space wakeups
Date: Thu, 23 Aug 2012 15:01:54 +1000
Message-Id: <1345698180-13612-37-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

Upstream commit: 09a423a3d6c70905f1090f01aadb8e6abff527ce

Currently xfs_log_move_tail has a tail_lsn argument that is horribly
overloaded: it may contain either an actual lsn to assign to the log tail,
0 as a special case to use the last sync LSN, or 1 to indicate that no tail
LSN assignment should be performed, and we should opportunisticly wake up
at one task waiting for log space even if we did not move the LSN.

Remove the tail lsn assigned from xfs_log_move_tail and make the two callers
use xlog_assign_tail_lsn instead of the current variant of partially using
the code in xfs_log_move_tail and partially opencoding it.  Note that means
we grow an addition lock roundtrip on the AIL lock for each bulk update
or delete, which is still far less than what we had before introducing the
bulk operations.  If this proves to be a problem we can still add a variant
of xlog_assign_tail_lsn that expects the lock to be held already.

Also rename the remainder of xfs_log_move_tail to xfs_log_space_wake as
that name describes its functionality much better.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_log.c       |   74 ++++++++++++++++++++----------------------------
 fs/xfs/xfs_log.h       |    5 ++--
 fs/xfs/xfs_log_priv.h  |    1 -
 fs/xfs/xfs_trans_ail.c |   45 +++++++----------------------
 4 files changed, 45 insertions(+), 80 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 42d8a5d..6907c82 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -792,37 +792,35 @@ xfs_log_write(
 	return error;
 }
 
+/*
+ * Wake up processes waiting for log space after we have moved the log tail.
+ *
+ * If opportunistic is set wake up one waiter even if we do not have enough
+ * free space by our strict accounting.
+ */
 void
-xfs_log_move_tail(xfs_mount_t	*mp,
-		  xfs_lsn_t	tail_lsn)
+xfs_log_space_wake(
+	struct xfs_mount	*mp,
+	bool			opportunistic)
 {
-	xlog_ticket_t	*tic;
-	xlog_t		*log = mp->m_log;
-	int		need_bytes, free_bytes;
+	struct xlog_ticket	*tic;
+	struct log		*log = mp->m_log;
+	int			need_bytes, free_bytes;
 
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return;
 
-	if (tail_lsn == 0)
-		tail_lsn = atomic64_read(&log->l_last_sync_lsn);
-
-	/* tail_lsn == 1 implies that we weren't passed a valid value.  */
-	if (tail_lsn != 1)
-		atomic64_set(&log->l_tail_lsn, tail_lsn);
-
 	if (!list_empty_careful(&log->l_writeq)) {
-#ifdef DEBUG
-		if (log->l_flags & XLOG_ACTIVE_RECOVERY)
-			panic("Recovery problem");
-#endif
+		ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
+
 		spin_lock(&log->l_grant_write_lock);
 		free_bytes = xlog_space_left(log, &log->l_grant_write_head);
 		list_for_each_entry(tic, &log->l_writeq, t_queue) {
 			ASSERT(tic->t_flags & XLOG_TIC_PERM_RESERV);
 
-			if (free_bytes < tic->t_unit_res && tail_lsn != 1)
+			if (free_bytes < tic->t_unit_res && !opportunistic)
 				break;
-			tail_lsn = 0;
+			opportunistic = false;
 			free_bytes -= tic->t_unit_res;
 			trace_xfs_log_regrant_write_wake_up(log, tic);
 			wake_up(&tic->t_wait);
@@ -831,10 +829,8 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 	}
 
 	if (!list_empty_careful(&log->l_reserveq)) {
-#ifdef DEBUG
-		if (log->l_flags & XLOG_ACTIVE_RECOVERY)
-			panic("Recovery problem");
-#endif
+		ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
+
 		spin_lock(&log->l_grant_reserve_lock);
 		free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
 		list_for_each_entry(tic, &log->l_reserveq, t_queue) {
@@ -842,9 +838,9 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 				need_bytes = tic->t_unit_res*tic->t_cnt;
 			else
 				need_bytes = tic->t_unit_res;
-			if (free_bytes < need_bytes && tail_lsn != 1)
+			if (free_bytes < need_bytes && !opportunistic)
 				break;
-			tail_lsn = 0;
+			opportunistic = false;
 			free_bytes -= need_bytes;
 			trace_xfs_log_grant_wake_up(log, tic);
 			wake_up(&tic->t_wait);
@@ -899,21 +895,7 @@ xfs_log_need_covered(xfs_mount_t *mp)
 	return needed;
 }
 
-/******************************************************************************
- *
- *	local routines
- *
- ******************************************************************************
- */
-
-/* xfs_trans_tail_ail returns 0 when there is nothing in the list.
- * The log manager must keep track of the last LR which was committed
- * to disk.  The lsn of this LR will become the new tail_lsn whenever
- * xfs_trans_tail_ail returns 0.  If we don't do this, we run into
- * the situation where stuff could be written into the log but nothing
- * was ever in the AIL when asked.  Eventually, we panic since the
- * tail hits the head.
- *
+/*
  * We may be holding the log iclog lock upon entering this routine.
  */
 xfs_lsn_t
@@ -923,10 +905,17 @@ xlog_assign_tail_lsn(
 	xfs_lsn_t		tail_lsn;
 	struct log		*log = mp->m_log;
 
+	/*
+	 * To make sure we always have a valid LSN for the log tail we keep
+	 * track of the last LSN which was committed in log->l_last_sync_lsn,
+	 * and use that when the AIL was empty and xfs_ail_min_lsn returns 0.
+	 *
+	 * If the AIL has been emptied we also need to wake any process
+	 * waiting for this condition.
+	 */
 	tail_lsn = xfs_ail_min_lsn(mp->m_ail);
 	if (!tail_lsn)
 		tail_lsn = atomic64_read(&log->l_last_sync_lsn);
-
 	atomic64_set(&log->l_tail_lsn, tail_lsn);
 	return tail_lsn;
 }
@@ -2807,9 +2796,8 @@ xlog_ungrant_log_space(xlog_t	     *log,
 
 	trace_xfs_log_ungrant_exit(log, ticket);
 
-	xfs_log_move_tail(log->l_mp, 1);
-}	/* xlog_ungrant_log_space */
-
+	xfs_log_space_wake(log->l_mp, true);
+}
 
 /*
  * Flush iclog to disk if this is the last reference to the given iclog and
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 78c9039..e9ef054 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -160,8 +160,9 @@ int	  xfs_log_mount(struct xfs_mount	*mp,
 			xfs_daddr_t		start_block,
 			int		 	num_bblocks);
 int	  xfs_log_mount_finish(struct xfs_mount *mp);
-void	  xfs_log_move_tail(struct xfs_mount	*mp,
-			    xfs_lsn_t		tail_lsn);
+xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
+void	  xfs_log_space_wake(struct xfs_mount	*mp,
+			     bool		opportunistic);
 int	  xfs_log_notify(struct xfs_mount	*mp,
 			 struct xlog_in_core	*iclog,
 			 xfs_log_callback_t	*callback_entry);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 2d3b6a4..785905e 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -545,7 +545,6 @@ typedef struct log {
 #define XLOG_FORCED_SHUTDOWN(log)	((log)->l_flags & XLOG_IO_ERROR)
 
 /* common routines */
-extern xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
 extern int	 xlog_recover(xlog_t *log);
 extern int	 xlog_recover_finish(xlog_t *log);
 extern void	 xlog_pack_data(xlog_t *log, xlog_in_core_t *iclog, int);
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 409ac37..db5cd1b 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -694,15 +694,15 @@ xfs_trans_unlocked_item(
 	 * at the tail, it doesn't matter what result we get back.  This
 	 * is slightly racy because since we were just unlocked, we could
 	 * go to sleep between the call to xfs_ail_min and the call to
-	 * xfs_log_move_tail, have someone else lock us, commit to us disk,
+	 * xfs_log_space_wake, have someone else lock us, commit to us disk,
 	 * move us out of the tail of the AIL, and then we wake up.  However,
-	 * the call to xfs_log_move_tail() doesn't do anything if there's
+	 * the call to xfs_log_space_wake() doesn't do anything if there's
 	 * not enough free space to wake people up so we're safe calling it.
 	 */
 	min_lip = xfs_ail_min(ailp);
 
 	if (min_lip == lip)
-		xfs_log_move_tail(ailp->xa_mount, 1);
+		xfs_log_space_wake(ailp->xa_mount, true);
 }	/* xfs_trans_unlocked_item */
 
 /*
@@ -736,7 +736,6 @@ xfs_trans_ail_update_bulk(
 	xfs_lsn_t		lsn) __releases(ailp->xa_lock)
 {
 	xfs_log_item_t		*mlip;
-	xfs_lsn_t		tail_lsn;
 	int			mlip_changed = 0;
 	int			i;
 	LIST_HEAD(tmp);
@@ -761,22 +760,12 @@ xfs_trans_ail_update_bulk(
 	}
 
 	xfs_ail_splice(ailp, cur, &tmp, lsn);
+	spin_unlock(&ailp->xa_lock);
 
-	if (!mlip_changed) {
-		spin_unlock(&ailp->xa_lock);
-		return;
+	if (mlip_changed && !XFS_FORCED_SHUTDOWN(ailp->xa_mount)) {
+		xlog_assign_tail_lsn(ailp->xa_mount);
+		xfs_log_space_wake(ailp->xa_mount, false);
 	}
-
-	/*
-	 * It is not safe to access mlip after the AIL lock is dropped, so we
-	 * must get a copy of li_lsn before we do so.  This is especially
-	 * important on 32-bit platforms where accessing and updating 64-bit
-	 * values like li_lsn is not atomic.
-	 */
-	mlip = xfs_ail_min(ailp);
-	tail_lsn = mlip->li_lsn;
-	spin_unlock(&ailp->xa_lock);
-	xfs_log_move_tail(ailp->xa_mount, tail_lsn);
 }
 
 /*
@@ -807,7 +796,6 @@ xfs_trans_ail_delete_bulk(
 	int			nr_items) __releases(ailp->xa_lock)
 {
 	xfs_log_item_t		*mlip;
-	xfs_lsn_t		tail_lsn;
 	int			mlip_changed = 0;
 	int			i;
 
@@ -834,23 +822,12 @@ xfs_trans_ail_delete_bulk(
 		if (mlip == lip)
 			mlip_changed = 1;
 	}
+	spin_unlock(&ailp->xa_lock);
 
-	if (!mlip_changed) {
-		spin_unlock(&ailp->xa_lock);
-		return;
+	if (mlip_changed && !XFS_FORCED_SHUTDOWN(ailp->xa_mount)) {
+		xlog_assign_tail_lsn(ailp->xa_mount);
+		xfs_log_space_wake(ailp->xa_mount, false);
 	}
-
-	/*
-	 * It is not safe to access mlip after the AIL lock is dropped, so we
-	 * must get a copy of li_lsn before we do so.  This is especially
-	 * important on 32-bit platforms where accessing and updating 64-bit
-	 * values like li_lsn is not atomic. It is possible we've emptied the
-	 * AIL here, so if that is the case, pass an LSN of 0 to the tail move.
-	 */
-	mlip = xfs_ail_min(ailp);
-	tail_lsn = mlip ? mlip->li_lsn : 0;
-	spin_unlock(&ailp->xa_lock);
-	xfs_log_move_tail(ailp->xa_mount, tail_lsn);
 }
 
 /*
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
