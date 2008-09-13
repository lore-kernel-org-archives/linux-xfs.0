Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Sep 2008 07:56:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8DEuXBs022230
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:56:34 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C31087A75CF
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:58:03 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id uk8fJflVQjG25hAA for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:58:03 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KeWZS-0002O2-6a
	for xfs@oss.sgi.com; Sun, 14 Sep 2008 00:57:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/8] XFS: Given the log a pointer to the AIL
Date: Sun, 14 Sep 2008 00:57:55 +1000
Message-Id: <1221317877-8333-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1221317877-8333-1-git-send-email-david@fromorbit.com>
References: <1221317877-8333-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

When we need to go from the log to the AIL, we have
to go via the xfs_mount. Add a xfs_ail pointer to the log
so we can go directly to the AIL associated with the log.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_log.c         |    3 ++-
 fs/xfs/xfs_log_priv.h    |    1 +
 fs/xfs/xfs_log_recover.c |   42 +++++++++++++++++++++++-------------------
 3 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index d3d7042..1fb22f8 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -544,6 +544,7 @@ xfs_log_mount(
 		cmn_err(CE_WARN, "XFS: AIL initialisation failed: error %d", error);
 		goto error;
 	}
+	mp->m_log->l_ailp = mp->m_ail;
 
 	/*
 	 * skip log recovery on a norecovery mount.  pretend it all
@@ -880,7 +881,7 @@ xfs_log_need_covered(xfs_mount_t *mp)
 	spin_lock(&log->l_icloglock);
 	if (((log->l_covered_state == XLOG_STATE_COVER_NEED) ||
 		(log->l_covered_state == XLOG_STATE_COVER_NEED2))
-			&& !xfs_trans_ail_tail(mp->m_ail)
+			&& !xfs_trans_ail_tail(log->l_ailp)
 			&& xlog_iclogs_empty(log)) {
 		if (log->l_covered_state == XLOG_STATE_COVER_NEED)
 			log->l_covered_state = XLOG_STATE_COVER_DONE;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index c8a5b22..641c8f3 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -404,6 +404,7 @@ typedef struct xlog_in_core {
 typedef struct log {
 	/* The following fields don't need locking */
 	struct xfs_mount	*l_mp;	        /* mount point */
+	struct xfs_ail		*l_ailp;	/* AIL log is working with */
 	struct xfs_buf		*l_xbuf;        /* extra buffer for log
 						 * wrapping */
 	struct xfs_buftarg	*l_targ;        /* buftarg of log */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a2d6d78..b9c1331 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -54,7 +54,7 @@ STATIC void	xlog_recover_insert_item_backq(xlog_recover_item_t **q,
 					       xlog_recover_item_t *item);
 #if defined(DEBUG)
 STATIC void	xlog_recover_check_summary(xlog_t *);
-STATIC void	xlog_recover_check_ail(xfs_mount_t *, xfs_log_item_t *, 
+STATIC void	xlog_recover_check_ail(struct xfs_ail *, xfs_log_item_t *,
 					struct xfs_ail_cursor *);
 #else
 #define	xlog_recover_check_summary(log)
@@ -2684,7 +2684,7 @@ xlog_recover_do_efi_trans(
 	efip->efi_next_extent = efi_formatp->efi_nextents;
 	efip->efi_flags |= XFS_EFI_COMMITTED;
 
-	spin_lock(&mp->m_ail->xa_lock);
+	spin_lock(&log->l_ailp->xa_lock);
 	/*
 	 * xfs_trans_update_ail() drops the AIL lock.
 	 */
@@ -2713,6 +2713,7 @@ xlog_recover_do_efd_trans(
 	xfs_log_item_t		*lip;
 	__uint64_t		efi_id;
 	struct xfs_ail_cursor	cur;
+	struct xfs_ail		*ailp;
 
 	if (pass == XLOG_RECOVER_PASS1) {
 		return;
@@ -2730,8 +2731,9 @@ xlog_recover_do_efd_trans(
 	 * in the AIL.
 	 */
 	mp = log->l_mp;
-	spin_lock(&mp->m_ail->xa_lock);
-	lip = xfs_trans_ail_cursor_first(mp->m_ail, &cur, 0);
+	ailp = log->l_ailp;
+	spin_lock(&ailp->xa_lock);
+	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
 	while (lip != NULL) {
 		if (lip->li_type == XFS_LI_EFI) {
 			efip = (xfs_efi_log_item_t *)lip;
@@ -2742,14 +2744,14 @@ xlog_recover_do_efd_trans(
 				 */
 				xfs_trans_delete_ail(mp, lip);
 				xfs_efi_item_free(efip);
-				spin_lock(&mp->m_ail->xa_lock);
+				spin_lock(&ailp->xa_lock);
 				break;
 			}
 		}
-		lip = xfs_trans_ail_cursor_next(mp->m_ail, &cur);
+		lip = xfs_trans_ail_cursor_next(ailp, &cur);
 	}
-	xfs_trans_ail_cursor_done(mp->m_ail, &cur);
-	spin_unlock(&mp->m_ail->xa_lock);
+	xfs_trans_ail_cursor_done(ailp, &cur);
+	spin_unlock(&ailp->xa_lock);
 }
 
 /*
@@ -3039,13 +3041,13 @@ abort_error:
 #if defined(DEBUG)
 STATIC void
 xlog_recover_check_ail(
-	xfs_mount_t		*mp,
+	struct xfs_ail		*ailp,
 	xfs_log_item_t		*lip,
 	struct xfs_ail_cursor	*cur)
 {
 	do {
 		ASSERT(lip->li_type != XFS_LI_EFI);
-		lip = xfs_trans_ail_cursor_next(mp->m_ail, cur);
+		lip = xfs_trans_ail_cursor_next(ailp, cur);
 	} while (lip != NULL);
 }
 #endif	/* DEBUG */
@@ -3077,17 +3079,19 @@ xlog_recover_process_efis(
 	xfs_mount_t		*mp;
 	int			error = 0;
 	struct xfs_ail_cursor	cur;
+	struct xfs_ail		*ailp;
 
 	mp = log->l_mp;
-	spin_lock(&mp->m_ail->xa_lock);
+	ailp = log->l_ailp;
+	spin_lock(&ailp->xa_lock);
 
-	lip = xfs_trans_ail_cursor_first(mp->m_ail, &cur, 0);
+	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
 	while (lip != NULL) {
 		/*
 		 * We're done when we see something other than an EFI.
 		 */
 		if (lip->li_type != XFS_LI_EFI) {
-			xlog_recover_check_ail(mp, lip, &cur);
+			xlog_recover_check_ail(ailp, lip, &cur);
 			break;
 		}
 
@@ -3096,20 +3100,20 @@ xlog_recover_process_efis(
 		 */
 		efip = (xfs_efi_log_item_t *)lip;
 		if (efip->efi_flags & XFS_EFI_RECOVERED) {
-			lip = xfs_trans_ail_cursor_next(mp->m_ail, &cur);
+			lip = xfs_trans_ail_cursor_next(ailp, &cur);
 			continue;
 		}
 
-		spin_unlock(&mp->m_ail->xa_lock);
+		spin_unlock(&ailp->xa_lock);
 		error = xlog_recover_process_efi(mp, efip);
-		spin_lock(&mp->m_ail->xa_lock);
+		spin_lock(&ailp->xa_lock);
 		if (error)
 			goto out;
-		lip = xfs_trans_ail_cursor_next(mp->m_ail, &cur);
+		lip = xfs_trans_ail_cursor_next(ailp, &cur);
 	}
 out:
-	xfs_trans_ail_cursor_done(mp->m_ail, &cur);
-	spin_unlock(&mp->m_ail->xa_lock);
+	xfs_trans_ail_cursor_done(ailp, &cur);
+	spin_unlock(&ailp->xa_lock);
 	return error;
 }
 
-- 
1.5.6
