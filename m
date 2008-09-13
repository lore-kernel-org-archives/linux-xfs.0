Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Sep 2008 07:56:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8DEuaEu022259
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:56:36 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A50D7126C1A9
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:58:05 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id kB4uWS5gfH9t7zMD for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:58:05 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KeWZR-0002Np-VQ
	for xfs@oss.sgi.com; Sun, 14 Sep 2008 00:57:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/8] XFS: Use a cursor for AIL traversal.
Date: Sun, 14 Sep 2008 00:57:51 +1000
Message-Id: <1221317877-8333-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1221317877-8333-1-git-send-email-david@fromorbit.com>
References: <1221317877-8333-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

To replace the current generation number ensuring sanity of the AIL
traversal, replace it with an external cursor that is linked to the
AIL.

Basically, we store the next item in the cursor whenever we want to
drop the AIL lock to do something to the current item.  When we
regain the lock. the current item may already be free, so we can't
reference it, but the next item in the traversal is already held in
the cursor.

When we move or delete an object, we search all the active cursors
and if there is an item match we clear the cursor(s) that point to
the object. This forces the traversal to restart transparently.

We don't invalidate the cursor on insert because the cursor still
points to a valid item. If the intem is inserted between the current
item and the cursor it does not matter; the traversal is considered
to be past the insertion point so it will be picked up in the next
traversal.

Hence traversal restarts pretty much disappear altogether with this
method of traversal, which should substantially reduce the overhead
of pushing on a busy AIL.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_log.c         |    4 +-
 fs/xfs/xfs_log_recover.c |   46 ++++++-------
 fs/xfs/xfs_trans_ail.c   |  171 +++++++++++++++++++++++++++++++---------------
 fs/xfs/xfs_trans_priv.h  |   52 +++++++++++---
 4 files changed, 180 insertions(+), 93 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index ff2ac20..a3e0dd5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -872,7 +872,7 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 int
 xfs_log_need_covered(xfs_mount_t *mp)
 {
-	int		needed = 0, gen;
+	int		needed = 0;
 	xlog_t		*log = mp->m_log;
 
 	if (!xfs_fs_writable(mp))
@@ -881,7 +881,7 @@ xfs_log_need_covered(xfs_mount_t *mp)
 	spin_lock(&log->l_icloglock);
 	if (((log->l_covered_state == XLOG_STATE_COVER_NEED) ||
 		(log->l_covered_state == XLOG_STATE_COVER_NEED2))
-			&& !xfs_trans_first_ail(mp, &gen)
+			&& !xfs_trans_first_ail(mp, NULL)
 			&& xlog_iclogs_empty(log)) {
 		if (log->l_covered_state == XLOG_STATE_COVER_NEED)
 			log->l_covered_state = XLOG_STATE_COVER_DONE;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 82d46ce..d967baf 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -54,10 +54,11 @@ STATIC void	xlog_recover_insert_item_backq(xlog_recover_item_t **q,
 					       xlog_recover_item_t *item);
 #if defined(DEBUG)
 STATIC void	xlog_recover_check_summary(xlog_t *);
-STATIC void	xlog_recover_check_ail(xfs_mount_t *, xfs_log_item_t *, int);
+STATIC void	xlog_recover_check_ail(xfs_mount_t *, xfs_log_item_t *, 
+					struct xfs_ail_cursor *);
 #else
 #define	xlog_recover_check_summary(log)
-#define	xlog_recover_check_ail(mp, lip, gen)
+#define	xlog_recover_check_ail(mp, lip, cur)
 #endif
 
 
@@ -2710,8 +2711,8 @@ xlog_recover_do_efd_trans(
 	xfs_efd_log_format_t	*efd_formatp;
 	xfs_efi_log_item_t	*efip = NULL;
 	xfs_log_item_t		*lip;
-	int			gen;
 	__uint64_t		efi_id;
+	struct xfs_ail_cursor	cur;
 
 	if (pass == XLOG_RECOVER_PASS1) {
 		return;
@@ -2730,7 +2731,8 @@ xlog_recover_do_efd_trans(
 	 */
 	mp = log->l_mp;
 	spin_lock(&mp->m_ail_lock);
-	lip = xfs_trans_first_ail(mp, &gen);
+	xfs_trans_ail_cursor_init(mp->m_ail, &cur);
+	lip = xfs_trans_first_ail(mp, &cur);
 	while (lip != NULL) {
 		if (lip->li_type == XFS_LI_EFI) {
 			efip = (xfs_efi_log_item_t *)lip;
@@ -2741,11 +2743,13 @@ xlog_recover_do_efd_trans(
 				 */
 				xfs_trans_delete_ail(mp, lip);
 				xfs_efi_item_free(efip);
-				return;
+				spin_lock(&mp->m_ail_lock);
+				break;
 			}
 		}
-		lip = xfs_trans_next_ail(mp, lip, &gen, NULL);
+		lip = xfs_trans_next_ail(mp, &cur);
 	}
+	xfs_trans_ail_cursor_done(mp->m_ail, &cur);
 	spin_unlock(&mp->m_ail_lock);
 }
 
@@ -3038,20 +3042,11 @@ STATIC void
 xlog_recover_check_ail(
 	xfs_mount_t		*mp,
 	xfs_log_item_t		*lip,
-	int			gen)
+	struct xfs_ail_cursor	*cur)
 {
-	int			orig_gen = gen;
-
 	do {
 		ASSERT(lip->li_type != XFS_LI_EFI);
-		lip = xfs_trans_next_ail(mp, lip, &gen, NULL);
-		/*
-		 * The check will be bogus if we restart from the
-		 * beginning of the AIL, so ASSERT that we don't.
-		 * We never should since we're holding the AIL lock
-		 * the entire time.
-		 */
-		ASSERT(gen == orig_gen);
+		lip = xfs_trans_next_ail(mp, cur);
 	} while (lip != NULL);
 }
 #endif	/* DEBUG */
@@ -3080,20 +3075,21 @@ xlog_recover_process_efis(
 {
 	xfs_log_item_t		*lip;
 	xfs_efi_log_item_t	*efip;
-	int			gen;
 	xfs_mount_t		*mp;
 	int			error = 0;
+	struct xfs_ail_cursor	cur;
 
 	mp = log->l_mp;
 	spin_lock(&mp->m_ail_lock);
 
-	lip = xfs_trans_first_ail(mp, &gen);
+	xfs_trans_ail_cursor_init(mp->m_ail, &cur);
+	lip = xfs_trans_first_ail(mp, &cur);
 	while (lip != NULL) {
 		/*
 		 * We're done when we see something other than an EFI.
 		 */
 		if (lip->li_type != XFS_LI_EFI) {
-			xlog_recover_check_ail(mp, lip, gen);
+			xlog_recover_check_ail(mp, lip, &cur);
 			break;
 		}
 
@@ -3102,17 +3098,19 @@ xlog_recover_process_efis(
 		 */
 		efip = (xfs_efi_log_item_t *)lip;
 		if (efip->efi_flags & XFS_EFI_RECOVERED) {
-			lip = xfs_trans_next_ail(mp, lip, &gen, NULL);
+			lip = xfs_trans_next_ail(mp, &cur);
 			continue;
 		}
 
 		spin_unlock(&mp->m_ail_lock);
 		error = xlog_recover_process_efi(mp, efip);
-		if (error)
-			return error;
 		spin_lock(&mp->m_ail_lock);
-		lip = xfs_trans_next_ail(mp, lip, &gen, NULL);
+		if (error)
+			goto out;
+		lip = xfs_trans_next_ail(mp, &cur);
 	}
+out:
+	xfs_trans_ail_cursor_done(mp->m_ail, &cur);
 	spin_unlock(&mp->m_ail_lock);
 	return error;
 }
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index db72b52..668f2af 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -98,6 +98,78 @@ xfs_trans_push_ail(
 	}
 }
 
+void
+xfs_trans_ail_cursor_init(
+	struct xfs_ail		*ailp,
+	struct xfs_ail_cursor	*cur)
+{
+	cur->item = NULL;
+	if (cur == &ailp->xa_cursors)
+		return;
+
+	cur->next = ailp->xa_cursors.next;
+	ailp->xa_cursors.next = cur;
+}
+
+/*
+ * Set the cursor to the next item, because when we look
+ * up the cursor the current item may have been freed.
+ */
+STATIC void
+xfs_trans_ail_cursor_set(
+	struct xfs_ail		*ailp,
+	struct xfs_ail_cursor	*cur,
+	struct xfs_log_item	*lip)
+{
+	if (lip)
+		cur->item = xfs_ail_next(ailp, lip);
+}
+
+STATIC struct xfs_log_item *
+xfs_trans_ail_cursor_next(
+	struct xfs_ail		*ailp,
+	struct xfs_ail_cursor	*cur)
+{
+	struct xfs_log_item	*lip = cur->item;
+
+	xfs_trans_ail_cursor_set(ailp, cur, lip);
+	return lip;
+}
+
+STATIC void
+xfs_trans_ail_cursor_clear(
+	struct xfs_ail		*ailp,
+	struct xfs_log_item	*lip)
+{
+	struct xfs_ail_cursor	*cur;
+
+	/* need to search all cursors */
+	for (cur = &ailp->xa_cursors; cur; cur = cur->next) {
+		if (cur->item == lip)
+			cur->item = NULL;
+	}
+}
+
+void
+xfs_trans_ail_cursor_done(
+	struct xfs_ail		*ailp,
+	struct xfs_ail_cursor	*done)
+{
+	struct xfs_ail_cursor	*prev = NULL;
+	struct xfs_ail_cursor	*cur;
+
+	done->item = NULL;
+	if (done == &ailp->xa_cursors)
+		return;
+	prev = &ailp->xa_cursors;
+	for (cur = prev->next; cur; prev = cur, cur = prev->next) {
+		if (cur == done) {
+			prev->next = cur->next;
+			break;
+		}
+	}
+}
+
 /*
  * Return the item in the AIL with the current lsn.
  * Return the current tree generation number for use
@@ -105,20 +177,23 @@ xfs_trans_push_ail(
  */
 STATIC xfs_log_item_t *
 xfs_trans_first_push_ail(
-	xfs_mount_t	*mp,
-	int		*gen,
-	xfs_lsn_t	lsn)
+	struct xfs_mount	*mp,
+	struct xfs_ail_cursor	*cur,
+	xfs_lsn_t		lsn)
 {
-	xfs_log_item_t	*lip;
+	struct xfs_ail		*ailp = mp->m_ail;
+	xfs_log_item_t		*lip;
 
-	lip = xfs_ail_min(mp->m_ail);
-	*gen = (int)mp->m_ail->xa_gen;
+	lip = xfs_ail_min(ailp);
+	xfs_trans_ail_cursor_set(ailp, cur, lip);
 	if (lsn == 0)
 		return lip;
 
-	list_for_each_entry(lip, &mp->m_ail->xa_ail, li_ail) {
-		if (XFS_LSN_CMP(lip->li_lsn, lsn) >= 0)
+	list_for_each_entry(lip, &ailp->xa_ail, li_ail) {
+		if (XFS_LSN_CMP(lip->li_lsn, lsn) >= 0) {
+			xfs_trans_ail_cursor_set(ailp, cur, lip);
 			return lip;
+		}
 	}
 
 	return NULL;
@@ -137,22 +212,21 @@ xfsaild_push(
 	xfs_lsn_t	target =  ailp->xa_target;
 	xfs_lsn_t	lsn;
 	xfs_log_item_t	*lip;
-	int		gen;
-	int		restarts;
 	int		flush_log, count, stuck;
 	xfs_mount_t	*mp = ailp->xa_mount;
-
-#define	XFS_TRANS_PUSH_AIL_RESTARTS	10
+	struct xfs_ail_cursor	*cur = &ailp->xa_cursors;
 
 	spin_lock(&mp->m_ail_lock);
-	lip = xfs_trans_first_push_ail(mp, &gen, *last_lsn);
+	xfs_trans_ail_cursor_init(ailp, cur);
+	lip = xfs_trans_first_push_ail(mp, cur, *last_lsn);
 	if (!lip || XFS_FORCED_SHUTDOWN(mp)) {
 		/*
 		 * AIL is empty or our push has reached the end.
 		 */
+		xfs_trans_ail_cursor_done(ailp, cur);
 		spin_unlock(&mp->m_ail_lock);
 		last_pushed_lsn = 0;
-		goto out;
+		return tout;
 	}
 
 	XFS_STATS_INC(xs_push_ail);
@@ -170,7 +244,7 @@ xfsaild_push(
 	 */
 	tout = 10;
 	lsn = lip->li_lsn;
-	flush_log = stuck = count = restarts = 0;
+	flush_log = stuck = count = 0;
 	while ((XFS_LSN_CMP(lip->li_lsn, target) < 0)) {
 		int	lock_result;
 		/*
@@ -245,13 +319,12 @@ xfsaild_push(
 		if (stuck > 100)
 			break;
 
-		lip = xfs_trans_next_ail(mp, lip, &gen, &restarts);
+		lip = xfs_trans_next_ail(mp, cur);
 		if (lip == NULL)
 			break;
-		if (restarts > XFS_TRANS_PUSH_AIL_RESTARTS)
-			break;
 		lsn = lip->li_lsn;
 	}
+	xfs_trans_ail_cursor_done(ailp, cur);
 	spin_unlock(&mp->m_ail_lock);
 
 	if (flush_log) {
@@ -275,8 +348,7 @@ xfsaild_push(
 		 */
 		tout += 20;
 		last_pushed_lsn = 0;
-	} else if ((restarts > XFS_TRANS_PUSH_AIL_RESTARTS) ||
-		   ((stuck * 100) / count > 90)) {
+	} else if ((stuck * 100) / count > 90) {
 		/*
 		 * Either there is a lot of contention on the AIL or we
 		 * are stuck due to operations in progress. "Stuck" in this
@@ -288,7 +360,6 @@ xfsaild_push(
 		 */
 		tout += 10;
 	}
-out:
 	*last_lsn = last_pushed_lsn;
 	return tout;
 }	/* xfsaild_push */
@@ -348,9 +419,6 @@ xfs_trans_unlocked_item(
  * we move in the AIL is the minimum one, update the tail lsn in the
  * log manager.
  *
- * Increment the AIL's generation count to indicate that the tree
- * has changed.
- *
  * This function must be called with the AIL lock held.  The lock
  * is dropped before returning.
  */
@@ -368,14 +436,13 @@ xfs_trans_update_ail(
 	if (lip->li_flags & XFS_LI_IN_AIL) {
 		dlip = xfs_ail_delete(mp->m_ail, lip);
 		ASSERT(dlip == lip);
+		xfs_trans_ail_cursor_clear(mp->m_ail, dlip);
 	} else {
 		lip->li_flags |= XFS_LI_IN_AIL;
 	}
 
 	lip->li_lsn = lsn;
-
 	xfs_ail_insert(mp->m_ail, lip);
-	mp->m_ail->xa_gen++;
 
 	if (mlip == dlip) {
 		mlip = xfs_ail_min(mp->m_ail);
@@ -415,11 +482,11 @@ xfs_trans_delete_ail(
 		mlip = xfs_ail_min(mp->m_ail);
 		dlip = xfs_ail_delete(mp->m_ail, lip);
 		ASSERT(dlip == lip);
+		xfs_trans_ail_cursor_clear(mp->m_ail, dlip);
 
 
 		lip->li_flags &= ~XFS_LI_IN_AIL;
 		lip->li_lsn = 0;
-		mp->m_ail->xa_gen++;
 
 		if (mlip == dlip) {
 			mlip = xfs_ail_min(mp->m_ail);
@@ -455,46 +522,29 @@ xfs_trans_delete_ail(
  */
 xfs_log_item_t *
 xfs_trans_first_ail(
-	xfs_mount_t	*mp,
-	int		*gen)
+	struct xfs_mount	*mp,
+	struct xfs_ail_cursor	*cur)
 {
-	xfs_log_item_t	*lip;
+	xfs_log_item_t		*lip;
+	struct xfs_ail		*ailp = mp->m_ail;
 
-	lip = xfs_ail_min(mp->m_ail);
-	*gen = (int)mp->m_ail->xa_gen;
+	lip = xfs_ail_min(ailp);
+	xfs_trans_ail_cursor_set(ailp, cur, lip);
 
 	return lip;
 }
 
 /*
- * If the generation count of the tree has not changed since the
- * caller last took something from the AIL, then return the elmt
- * in the tree which follows the one given.  If the count has changed,
- * then return the minimum elmt of the AIL and bump the restarts counter
- * if one is given.
+ * Grab the next item in the AIL from the cursor passed in.
  */
 xfs_log_item_t *
 xfs_trans_next_ail(
-	xfs_mount_t	*mp,
-	xfs_log_item_t	*lip,
-	int		*gen,
-	int		*restarts)
+	struct xfs_mount	*mp,
+	struct xfs_ail_cursor	*cur)
 {
-	xfs_log_item_t	*nlip;
+	struct xfs_ail		*ailp = mp->m_ail;
 
-	ASSERT(mp && lip && gen);
-	if (mp->m_ail->xa_gen == *gen) {
-		nlip = xfs_ail_next(mp->m_ail, lip);
-	} else {
-		nlip = xfs_ail_min(mp->m_ail);
-		*gen = (int)mp->m_ail->xa_gen;
-		if (restarts != NULL) {
-			XFS_STATS_INC(xs_push_ail_restarts);
-			(*restarts)++;
-		}
-	}
-
-	return (nlip);
+	return xfs_trans_ail_cursor_next(ailp, cur);
 }
 
 
@@ -517,6 +567,7 @@ xfs_trans_ail_init(
 	xfs_mount_t	*mp)
 {
 	struct xfs_ail	*ailp;
+	int		error;
 
 	ailp = kmem_zalloc(sizeof(struct xfs_ail), KM_MAYFAIL);
 	if (!ailp)
@@ -524,7 +575,15 @@ xfs_trans_ail_init(
 
 	ailp->xa_mount = mp;
 	INIT_LIST_HEAD(&ailp->xa_ail);
-	return xfsaild_start(ailp);
+	error = xfsaild_start(ailp);
+	if (error)
+		goto out_free_ailp;
+	mp->m_ail = ailp;
+	return 0;
+
+out_free_ailp:
+	kmem_free(ailp);
+	return error;
 }
 
 void
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 98317fd..c596e34 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -44,20 +44,30 @@ xfs_log_busy_slot_t		*xfs_trans_add_busy(xfs_trans_t *tp,
 						    xfs_extlen_t idx);
 
 /*
- * From xfs_trans_ail.c
+ * AIL traversal cursor.
+ *
+ * Rather than using a generation number for detecting changes in the ail, use
+ * a cursor that is protected by the ail lock. The aild cursor exists in the
+ * struct xfs_ail, but other traversals can declare it on the stack and link it
+ * to the ail list.
+ *
+ * When an object is deleted from or moved int the AIL, the cursor list is
+ * searched to see if the object is a designated cursor item. If it is, it is
+ * deleted from the cursor so taht the next time the cursor is used traversal
+ * will return to the start.
+ *
+ * This means a traversal colliding with a removal will cause a restart of the
+ * list scan, rather than any insertion or deletion anywhere in the list.
  */
-void			xfs_trans_update_ail(struct xfs_mount *mp,
-				     struct xfs_log_item *lip, xfs_lsn_t lsn)
-				     __releases(mp->m_ail_lock);
-void			xfs_trans_delete_ail(struct xfs_mount *mp,
-				     struct xfs_log_item *lip)
-				     __releases(mp->m_ail_lock);
-struct xfs_log_item	*xfs_trans_first_ail(struct xfs_mount *, int *);
-struct xfs_log_item	*xfs_trans_next_ail(struct xfs_mount *,
-				     struct xfs_log_item *, int *, int *);
+struct xfs_ail_cursor {
+	struct xfs_ail_cursor	*next;
+	struct xfs_log_item	*item;
+};
 
 /*
- * AIL push thread support
+ * Private AIL structures.
+ *
+ * Eventually we need to drive the locking in here as well.
  */
 struct xfs_ail {
 	struct xfs_mount	*xa_mount;
@@ -65,8 +75,28 @@ struct xfs_ail {
 	uint			xa_gen;
 	struct task_struct	*xa_task;
 	xfs_lsn_t		xa_target;
+	struct xfs_ail_cursor	xa_cursors;
 };
 
+/*
+ * From xfs_trans_ail.c
+ */
+void			xfs_trans_update_ail(struct xfs_mount *mp,
+				     struct xfs_log_item *lip, xfs_lsn_t lsn)
+				     __releases(mp->m_ail_lock);
+void			xfs_trans_delete_ail(struct xfs_mount *mp,
+				     struct xfs_log_item *lip)
+				     __releases(mp->m_ail_lock);
+struct xfs_log_item	*xfs_trans_first_ail(struct xfs_mount *mp,
+					struct xfs_ail_cursor *cur);
+struct xfs_log_item	*xfs_trans_next_ail(struct xfs_mount *mp,
+					struct xfs_ail_cursor *cur);
+
+void xfs_trans_ail_cursor_init(struct xfs_ail *ailp,
+					struct xfs_ail_cursor *cur);
+void xfs_trans_ail_cursor_done(struct xfs_ail *ailp,
+					struct xfs_ail_cursor *cur);
+
 long	xfsaild_push(struct xfs_ail *, xfs_lsn_t *);
 void	xfsaild_wakeup(struct xfs_ail *, xfs_lsn_t);
 int	xfsaild_start(struct xfs_ail *);
-- 
1.5.6
