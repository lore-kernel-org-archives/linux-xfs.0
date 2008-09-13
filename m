Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Sep 2008 07:56:43 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8DEuYCY022232
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:56:34 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 31185126C1A6
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:58:04 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id pVsXlEXTiyIgdYqK for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:58:04 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KeWZS-0002Ns-0l
	for xfs@oss.sgi.com; Sun, 14 Sep 2008 00:57:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/8] XFS: move the AIl traversal over to a consistent interface
Date: Sun, 14 Sep 2008 00:57:52 +1000
Message-Id: <1221317877-8333-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1221317877-8333-1-git-send-email-david@fromorbit.com>
References: <1221317877-8333-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_log_recover.c |   14 +++----
 fs/xfs/xfs_trans.h       |    1 -
 fs/xfs/xfs_trans_ail.c   |  102 +++++++++++++++-------------------------------
 fs/xfs/xfs_trans_priv.h  |   13 +++---
 5 files changed, 48 insertions(+), 86 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a3e0dd5..70f5063 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -881,7 +881,7 @@ xfs_log_need_covered(xfs_mount_t *mp)
 	spin_lock(&log->l_icloglock);
 	if (((log->l_covered_state == XLOG_STATE_COVER_NEED) ||
 		(log->l_covered_state == XLOG_STATE_COVER_NEED2))
-			&& !xfs_trans_first_ail(mp, NULL)
+			&& !xfs_trans_ail_tail(mp->m_ail)
 			&& xlog_iclogs_empty(log)) {
 		if (log->l_covered_state == XLOG_STATE_COVER_NEED)
 			log->l_covered_state = XLOG_STATE_COVER_DONE;
@@ -918,7 +918,7 @@ xlog_assign_tail_lsn(xfs_mount_t *mp)
 	xfs_lsn_t tail_lsn;
 	xlog_t	  *log = mp->m_log;
 
-	tail_lsn = xfs_trans_tail_ail(mp);
+	tail_lsn = xfs_trans_ail_tail(mp->m_ail);
 	spin_lock(&log->l_grant_lock);
 	if (tail_lsn != 0) {
 		log->l_tail_lsn = tail_lsn;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index d967baf..46ef060 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2731,8 +2731,7 @@ xlog_recover_do_efd_trans(
 	 */
 	mp = log->l_mp;
 	spin_lock(&mp->m_ail_lock);
-	xfs_trans_ail_cursor_init(mp->m_ail, &cur);
-	lip = xfs_trans_first_ail(mp, &cur);
+	lip = xfs_trans_ail_cursor_first(mp->m_ail, &cur, 0);
 	while (lip != NULL) {
 		if (lip->li_type == XFS_LI_EFI) {
 			efip = (xfs_efi_log_item_t *)lip;
@@ -2747,7 +2746,7 @@ xlog_recover_do_efd_trans(
 				break;
 			}
 		}
-		lip = xfs_trans_next_ail(mp, &cur);
+		lip = xfs_trans_ail_cursor_next(mp->m_ail, &cur);
 	}
 	xfs_trans_ail_cursor_done(mp->m_ail, &cur);
 	spin_unlock(&mp->m_ail_lock);
@@ -3046,7 +3045,7 @@ xlog_recover_check_ail(
 {
 	do {
 		ASSERT(lip->li_type != XFS_LI_EFI);
-		lip = xfs_trans_next_ail(mp, cur);
+		lip = xfs_trans_ail_cursor_next(mp->m_ail, cur);
 	} while (lip != NULL);
 }
 #endif	/* DEBUG */
@@ -3082,8 +3081,7 @@ xlog_recover_process_efis(
 	mp = log->l_mp;
 	spin_lock(&mp->m_ail_lock);
 
-	xfs_trans_ail_cursor_init(mp->m_ail, &cur);
-	lip = xfs_trans_first_ail(mp, &cur);
+	lip = xfs_trans_ail_cursor_first(mp->m_ail, &cur, 0);
 	while (lip != NULL) {
 		/*
 		 * We're done when we see something other than an EFI.
@@ -3098,7 +3096,7 @@ xlog_recover_process_efis(
 		 */
 		efip = (xfs_efi_log_item_t *)lip;
 		if (efip->efi_flags & XFS_EFI_RECOVERED) {
-			lip = xfs_trans_next_ail(mp, &cur);
+			lip = xfs_trans_ail_cursor_next(mp->m_ail, &cur);
 			continue;
 		}
 
@@ -3107,7 +3105,7 @@ xlog_recover_process_efis(
 		spin_lock(&mp->m_ail_lock);
 		if (error)
 			goto out;
-		lip = xfs_trans_next_ail(mp, &cur);
+		lip = xfs_trans_ail_cursor_next(mp->m_ail, &cur);
 	}
 out:
 	xfs_trans_ail_cursor_done(mp->m_ail, &cur);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 74c80bd..ead53bd 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -979,7 +979,6 @@ int		xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
 int		xfs_trans_ail_init(struct xfs_mount *);
 void		xfs_trans_ail_destroy(struct xfs_mount *);
 void		xfs_trans_push_ail(struct xfs_mount *, xfs_lsn_t);
-xfs_lsn_t	xfs_trans_tail_ail(struct xfs_mount *);
 void		xfs_trans_unlocked_item(struct xfs_mount *,
 					xfs_log_item_t *);
 xfs_log_busy_slot_t *xfs_trans_add_busy(xfs_trans_t *tp,
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 668f2af..0591888 100644
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
@@ -98,7 +98,7 @@ xfs_trans_push_ail(
 	}
 }
 
-void
+STATIC void
 xfs_trans_ail_cursor_init(
 	struct xfs_ail		*ailp,
 	struct xfs_ail_cursor	*cur)
@@ -125,7 +125,7 @@ xfs_trans_ail_cursor_set(
 		cur->item = xfs_ail_next(ailp, lip);
 }
 
-STATIC struct xfs_log_item *
+struct xfs_log_item *
 xfs_trans_ail_cursor_next(
 	struct xfs_ail		*ailp,
 	struct xfs_ail_cursor	*cur)
@@ -136,20 +136,6 @@ xfs_trans_ail_cursor_next(
 	return lip;
 }
 
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
-			cur->item = NULL;
-	}
-}
-
 void
 xfs_trans_ail_cursor_done(
 	struct xfs_ail		*ailp,
@@ -170,33 +156,45 @@ xfs_trans_ail_cursor_done(
 	}
 }
 
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
 /*
  * Return the item in the AIL with the current lsn.
  * Return the current tree generation number for use
  * in calls to xfs_trans_next_ail().
  */
-STATIC xfs_log_item_t *
-xfs_trans_first_push_ail(
-	struct xfs_mount	*mp,
+xfs_log_item_t *
+xfs_trans_ail_cursor_first(
+	struct xfs_ail		*ailp,
 	struct xfs_ail_cursor	*cur,
 	xfs_lsn_t		lsn)
 {
-	struct xfs_ail		*ailp = mp->m_ail;
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
+out:
+	xfs_trans_ail_cursor_set(ailp, cur, lip);
+	return lip;
 }
 
 /*
@@ -217,8 +215,7 @@ xfsaild_push(
 	struct xfs_ail_cursor	*cur = &ailp->xa_cursors;
 
 	spin_lock(&mp->m_ail_lock);
-	xfs_trans_ail_cursor_init(ailp, cur);
-	lip = xfs_trans_first_push_ail(mp, cur, *last_lsn);
+	lip = xfs_trans_ail_cursor_first(ailp, cur, *last_lsn);
 	if (!lip || XFS_FORCED_SHUTDOWN(mp)) {
 		/*
 		 * AIL is empty or our push has reached the end.
@@ -319,7 +316,7 @@ xfsaild_push(
 		if (stuck > 100)
 			break;
 
-		lip = xfs_trans_next_ail(mp, cur);
+		lip = xfs_trans_ail_cursor_next(ailp, cur);
 		if (lip == NULL)
 			break;
 		lsn = lip->li_lsn;
@@ -516,39 +513,6 @@ xfs_trans_delete_ail(
 
 
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
index c596e34..8b84167 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -87,14 +87,15 @@ void			xfs_trans_update_ail(struct xfs_mount *mp,
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
1.5.6
