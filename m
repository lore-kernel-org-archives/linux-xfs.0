Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 15:12:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97MCNIs011248
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 15:12:24 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49D31A0129C
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 15:14:02 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id M8fRCzZBmND97NIX for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 15:14:02 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKoY-0002dR-Hz
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 09:13:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/8] XFS: move the AIl traversal over to a consistent interface
Date: Wed,  8 Oct 2008 09:13:53 +1100
Message-Id: <1223417638-10050-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1223417638-10050-1-git-send-email-david@fromorbit.com>
References: <1223417638-10050-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

With the new cursor interface, it makes sense to make all the
traversing code use the cursor interface and make the old one go
away. This means more of the AIL interfacing is done by passing
struct xfs_ail pointers around the place instead of struct
xfs_mount pointers.

We can replace the use of xfs_trans_first_ail() in
xfs_log_need_covered() as it is only checking if the AIL is empty.
We can do that with a call to xfs_trans_ail_tail() instead, where a
zero LSN returned indicates and empty AIL...

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_log.c         |    4 +-
 fs/xfs/xfs_log_recover.c |   15 +++---
 fs/xfs/xfs_trans.h       |    1 -
 fs/xfs/xfs_trans_ail.c   |  117 ++++++++++++++++-----------------------------
 fs/xfs/xfs_trans_priv.h  |   13 +++--
 5 files changed, 58 insertions(+), 92 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 67c127a..b19a082 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -909,7 +909,7 @@ xfs_log_need_covered(xfs_mount_t *mp)
 	spin_lock(&log->l_icloglock);
 	if (((log->l_covered_state == XLOG_STATE_COVER_NEED) ||
 		(log->l_covered_state == XLOG_STATE_COVER_NEED2))
-			&& !xfs_trans_first_ail(mp, NULL)
+			&& !xfs_trans_ail_tail(mp->m_ail)
 			&& xlog_iclogs_empty(log)) {
 		if (log->l_covered_state == XLOG_STATE_COVER_NEED)
 			log->l_covered_state = XLOG_STATE_COVER_DONE;
@@ -946,7 +946,7 @@ xlog_assign_tail_lsn(xfs_mount_t *mp)
 	xfs_lsn_t tail_lsn;
 	xlog_t	  *log = mp->m_log;
 
-	tail_lsn = xfs_trans_tail_ail(mp);
+	tail_lsn = xfs_trans_ail_tail(mp->m_ail);
 	spin_lock(&log->l_grant_lock);
 	if (tail_lsn != 0) {
 		log->l_tail_lsn = tail_lsn;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 5aef7c6..83f53ca 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2728,8 +2728,7 @@ xlog_recover_do_efd_trans(
 	 */
 	mp = log->l_mp;
 	spin_lock(&mp->m_ail_lock);
-	xfs_trans_ail_cursor_init(mp->m_ail, &cur);
-	lip = xfs_trans_first_ail(mp, &cur);
+	lip = xfs_trans_ail_cursor_first(mp->m_ail, &cur, 0);
 	while (lip != NULL) {
 		if (lip->li_type == XFS_LI_EFI) {
 			efip = (xfs_efi_log_item_t *)lip;
@@ -2744,7 +2743,7 @@ xlog_recover_do_efd_trans(
 				break;
 			}
 		}
-		lip = xfs_trans_next_ail(mp, &cur);
+		lip = xfs_trans_ail_cursor_next(mp->m_ail, &cur);
 	}
 	xfs_trans_ail_cursor_done(mp->m_ail, &cur);
 	spin_unlock(&mp->m_ail_lock);
@@ -3061,8 +3060,7 @@ xlog_recover_process_efis(
 	mp = log->l_mp;
 	spin_lock(&mp->m_ail_lock);
 
-	xfs_trans_ail_cursor_init(mp->m_ail, &cur);
-	lip = xfs_trans_first_ail(mp, &cur);
+	lip = xfs_trans_ail_cursor_first(mp->m_ail, &cur, 0);
 	while (lip != NULL) {
 		/*
 		 * We're done when we see something other than an EFI.
@@ -3070,7 +3068,8 @@ xlog_recover_process_efis(
 		 */
 		if (lip->li_type != XFS_LI_EFI) {
 #ifdef DEBUG
-			for (; lip; lip = xfs_trans_next_ail(mp, &cur))
+			for (; lip;
+			       lip = xfs_trans_ail_cursor_next(mp->m_ail, &cur))
 				ASSERT(lip->li_type != XFS_LI_EFI);
 #endif
 			break;
@@ -3081,7 +3080,7 @@ xlog_recover_process_efis(
 		 */
 		efip = (xfs_efi_log_item_t *)lip;
 		if (efip->efi_flags & XFS_EFI_RECOVERED) {
-			lip = xfs_trans_next_ail(mp, &cur);
+			lip = xfs_trans_ail_cursor_next(mp->m_ail, &cur);
 			continue;
 		}
 
@@ -3090,7 +3089,7 @@ xlog_recover_process_efis(
 		spin_lock(&mp->m_ail_lock);
 		if (error)
 			goto out;
-		lip = xfs_trans_next_ail(mp, &cur);
+		lip = xfs_trans_ail_cursor_next(mp->m_ail, &cur);
 	}
 out:
 	xfs_trans_ail_cursor_done(mp->m_ail, &cur);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 1d89d50..ae2ae3e 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -971,7 +971,6 @@ void		xfs_trans_cancel(xfs_trans_t *, int);
 int		xfs_trans_ail_init(struct xfs_mount *);
 void		xfs_trans_ail_destroy(struct xfs_mount *);
 void		xfs_trans_push_ail(struct xfs_mount *, xfs_lsn_t);
-xfs_lsn_t	xfs_trans_tail_ail(struct xfs_mount *);
 void		xfs_trans_unlocked_item(struct xfs_mount *,
 					xfs_log_item_t *);
 xfs_log_busy_slot_t *xfs_trans_add_busy(xfs_trans_t *tp,
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 7b8bfcf..286934d 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -50,20 +50,20 @@ STATIC void xfs_ail_check(struct xfs_ail *, xfs_log_item_t *);
  * lsn of the last item in the AIL.
  */
 xfs_lsn_t
-xfs_trans_tail_ail(
-	xfs_mount_t	*mp)
+xfs_trans_ail_tail(
+	struct xfs_ail	*ailp)
 {
 	xfs_lsn_t	lsn;
 	xfs_log_item_t	*lip;
 
-	spin_lock(&mp->m_ail_lock);
-	lip = xfs_ail_min(mp->m_ail);
+	spin_lock(&ailp->xa_mount->m_ail_lock);
+	lip = xfs_ail_min(ailp);
 	if (lip == NULL) {
 		lsn = (xfs_lsn_t)0;
 	} else {
 		lsn = lip->li_lsn;
 	}
-	spin_unlock(&mp->m_ail_lock);
+	spin_unlock(&ailp->xa_mount->m_ail_lock);
 
 	return lsn;
 }
@@ -111,7 +111,7 @@ xfs_trans_push_ail(
  * We don't link the push cursor because it is embedded in the struct
  * xfs_ail and hence easily findable.
  */
-void
+STATIC void
 xfs_trans_ail_cursor_init(
 	struct xfs_ail		*ailp,
 	struct xfs_ail_cursor	*cur)
@@ -143,7 +143,7 @@ xfs_trans_ail_cursor_set(
  * If the cursor was invalidated (inidicated by a lip of 1),
  * restart the traversal.
  */
-STATIC struct xfs_log_item *
+struct xfs_log_item *
 xfs_trans_ail_cursor_next(
 	struct xfs_ail		*ailp,
 	struct xfs_ail_cursor	*cur)
@@ -157,30 +157,6 @@ xfs_trans_ail_cursor_next(
 }
 
 /*
- * Invalidate any cursor that is pointing to this item. This is
- * called when an item is removed from the AIL. Any cursor pointing
- * to this object is now invalid and the traversal needs to be
- * terminated so it doesn't reference a freed object. We set the
- * cursor item to a value of 1 so we can distinguish between an
- * invalidation and the end of the list when getting the next item
- * from the cursor.
- */
-STATIC void
-xfs_trans_ail_cursor_clear(
-	struct xfs_ail		*ailp,
-	struct xfs_log_item	*lip)
-{
-	struct xfs_ail_cursor	*cur;
-
-	/* need to search all cursors */
-	for (cur = &ailp->xa_cursors; cur; cur = cur->next) {
-		if (cur->item == lip)
-			cur->item = (struct xfs_log_item *)
-					((__psint_t)cur->item | 1);
-	}
-}
-
-/*
  * Now that the traversal is complete, we need to remove the cursor
  * from the list of traversing cursors. Avoid removing the embedded
  * push cursor, but use the fact it is alway present to make the
@@ -208,31 +184,55 @@ xfs_trans_ail_cursor_done(
 }
 
 /*
+ * Invalidate any cursor that is pointing to this item. This is
+ * called when an item is removed from the AIL. Any cursor pointing
+ * to this object is now invalid and the traversal needs to be
+ * terminated so it doesn't reference a freed object. We set the
+ * cursor item to a value of 1 so we can distinguish between an
+ * invalidation and the end of the list when getting the next item
+ * from the cursor.
+ */
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
+			cur->item = (struct xfs_log_item *)
+					((__psint_t)cur->item | 1);
+	}
+}
+
+/*
  * Return the item in the AIL with the current lsn.
  * Return the current tree generation number for use
  * in calls to xfs_trans_next_ail().
  */
-STATIC xfs_log_item_t *
-xfs_trans_first_push_ail(
+xfs_log_item_t *
+xfs_trans_ail_cursor_first(
 	struct xfs_ail		*ailp,
 	struct xfs_ail_cursor	*cur,
 	xfs_lsn_t		lsn)
 {
 	xfs_log_item_t		*lip;
 
+	xfs_trans_ail_cursor_init(ailp, cur);
 	lip = xfs_ail_min(ailp);
-	xfs_trans_ail_cursor_set(ailp, cur, lip);
 	if (lsn == 0)
-		return lip;
+		goto out;
 
 	list_for_each_entry(lip, &ailp->xa_ail, li_ail) {
-		if (XFS_LSN_CMP(lip->li_lsn, lsn) >= 0) {
-			xfs_trans_ail_cursor_set(ailp, cur, lip);
-			return lip;
-		}
+		if (XFS_LSN_CMP(lip->li_lsn, lsn) >= 0)
+			break;
 	}
-
-	return NULL;
+	lip = NULL;
+out:
+	xfs_trans_ail_cursor_set(ailp, cur, lip);
+	return lip;
 }
 
 /*
@@ -254,7 +254,7 @@ xfsaild_push(
 
 	spin_lock(&mp->m_ail_lock);
 	xfs_trans_ail_cursor_init(ailp, cur);
-	lip = xfs_trans_first_push_ail(ailp, cur, *last_lsn);
+	lip = xfs_trans_ail_cursor_first(ailp, cur, *last_lsn);
 	if (!lip || XFS_FORCED_SHUTDOWN(mp)) {
 		/*
 		 * AIL is empty or our push has reached the end.
@@ -552,39 +552,6 @@ xfs_trans_delete_ail(
 
 
 /*
- * Return the item in the AIL with the smallest lsn.
- * Return the current tree generation number for use
- * in calls to xfs_trans_next_ail().
- */
-xfs_log_item_t *
-xfs_trans_first_ail(
-	struct xfs_mount	*mp,
-	struct xfs_ail_cursor	*cur)
-{
-	xfs_log_item_t		*lip;
-	struct xfs_ail		*ailp = mp->m_ail;
-
-	lip = xfs_ail_min(ailp);
-	xfs_trans_ail_cursor_set(ailp, cur, lip);
-
-	return lip;
-}
-
-/*
- * Grab the next item in the AIL from the cursor passed in.
- */
-xfs_log_item_t *
-xfs_trans_next_ail(
-	struct xfs_mount	*mp,
-	struct xfs_ail_cursor	*cur)
-{
-	struct xfs_ail		*ailp = mp->m_ail;
-
-	return xfs_trans_ail_cursor_next(ailp, cur);
-}
-
-
-/*
  * The active item list (AIL) is a doubly linked list of log
  * items sorted by ascending lsn.  The base of the list is
  * a forw/back pointer pair embedded in the xfs mount structure.
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index f114d38..aa58535 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -90,14 +90,15 @@ void			xfs_trans_update_ail(struct xfs_mount *mp,
 void			xfs_trans_delete_ail(struct xfs_mount *mp,
 				     struct xfs_log_item *lip)
 				     __releases(mp->m_ail_lock);
-struct xfs_log_item	*xfs_trans_first_ail(struct xfs_mount *mp,
-					struct xfs_ail_cursor *cur);
-struct xfs_log_item	*xfs_trans_next_ail(struct xfs_mount *mp,
-					struct xfs_ail_cursor *cur);
 
-void xfs_trans_ail_cursor_init(struct xfs_ail *ailp,
+xfs_lsn_t		xfs_trans_ail_tail(struct xfs_ail *ailp);
+
+struct xfs_log_item	*xfs_trans_ail_cursor_first(struct xfs_ail *ailp,
+					struct xfs_ail_cursor *cur,
+					xfs_lsn_t lsn);
+struct xfs_log_item	*xfs_trans_ail_cursor_next(struct xfs_ail *ailp,
 					struct xfs_ail_cursor *cur);
-void xfs_trans_ail_cursor_done(struct xfs_ail *ailp,
+void			xfs_trans_ail_cursor_done(struct xfs_ail *ailp,
 					struct xfs_ail_cursor *cur);
 
 long	xfsaild_push(struct xfs_ail *, xfs_lsn_t *);
-- 
1.5.6.5
