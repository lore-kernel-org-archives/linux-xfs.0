Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Sep 2008 07:56:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8DEuaqr022258
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:56:36 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84C5A7A75D5
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:58:05 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id K77I7OFg3Sw6SkGh for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:58:05 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KeWZS-0002Ny-51
	for xfs@oss.sgi.com; Sun, 14 Sep 2008 00:57:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/8] XFS: Move the AIL lock into the struct xfs_ail
Date: Sun, 14 Sep 2008 00:57:54 +1000
Message-Id: <1221317877-8333-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1221317877-8333-1-git-send-email-david@fromorbit.com>
References: <1221317877-8333-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Bring the ail lock inside the struct xfs_ail. This means
the AIL can be entirely manipulated via the struct xfs_ail rather
than needing both the struct xfs_mount and the struct xfs_ail.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/quota/xfs_dquot.c      |    4 +-
 fs/xfs/quota/xfs_dquot_item.c |    2 +-
 fs/xfs/xfs_buf_item.c         |    4 +-
 fs/xfs/xfs_extfree_item.c     |   12 ++++----
 fs/xfs/xfs_inode.c            |    4 +-
 fs/xfs/xfs_inode_item.c       |    8 +++---
 fs/xfs/xfs_log.c              |    1 -
 fs/xfs/xfs_log_recover.c      |   16 ++++++------
 fs/xfs/xfs_mount.h            |    1 -
 fs/xfs/xfs_trans.c            |    4 +-
 fs/xfs/xfs_trans_ail.c        |   56 +++++++++++++++++++++-------------------
 fs/xfs/xfs_trans_priv.h       |    5 ++-
 12 files changed, 59 insertions(+), 58 deletions(-)

diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index 8e30a10..29a7aa7 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -1335,7 +1335,7 @@ xfs_qm_dqflush_done(
 	if ((qip->qli_item.li_flags & XFS_LI_IN_AIL) &&
 	    qip->qli_item.li_lsn == qip->qli_flush_lsn) {
 
-		spin_lock(&dqp->q_mount->m_ail_lock);
+		spin_lock(&dqp->q_mount->m_ail->xa_lock);
 		/*
 		 * xfs_trans_delete_ail() drops the AIL lock.
 		 */
@@ -1343,7 +1343,7 @@ xfs_qm_dqflush_done(
 			xfs_trans_delete_ail(dqp->q_mount,
 					     (xfs_log_item_t*)qip);
 		else
-			spin_unlock(&dqp->q_mount->m_ail_lock);
+			spin_unlock(&dqp->q_mount->m_ail->xa_lock);
 	}
 
 	/*
diff --git a/fs/xfs/quota/xfs_dquot_item.c b/fs/xfs/quota/xfs_dquot_item.c
index f028644..478077c 100644
--- a/fs/xfs/quota/xfs_dquot_item.c
+++ b/fs/xfs/quota/xfs_dquot_item.c
@@ -570,7 +570,7 @@ xfs_qm_qoffend_logitem_committed(
 	xfs_qoff_logitem_t	*qfs;
 
 	qfs = qfe->qql_start_lip;
-	spin_lock(&qfs->qql_item.li_mountp->m_ail_lock);
+	spin_lock(&qfs->qql_item.li_mountp->m_ail->xa_lock);
 	/*
 	 * Delete the qoff-start logitem from the AIL.
 	 * xfs_trans_delete_ail() drops the AIL lock.
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 608c30c..7f1e266 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -408,7 +408,7 @@ xfs_buf_item_unpin(
 			XFS_BUF_SET_FSPRIVATE(bp, NULL);
 			XFS_BUF_CLR_IODONE_FUNC(bp);
 		} else {
-			spin_lock(&mp->m_ail_lock);
+			spin_lock(&mp->m_ail->xa_lock);
 			xfs_trans_delete_ail(mp, (xfs_log_item_t *)bip);
 			xfs_buf_item_relse(bp);
 			ASSERT(XFS_BUF_FSPRIVATE(bp, void *) == NULL);
@@ -1131,7 +1131,7 @@ xfs_buf_iodone(
 	 *
 	 * Either way, AIL is useless if we're forcing a shutdown.
 	 */
-	spin_lock(&mp->m_ail_lock);
+	spin_lock(&mp->m_ail->xa_lock);
 	/*
 	 * xfs_trans_delete_ail() drops the AIL lock.
 	 */
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 8aa28f7..f1dcd80 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -111,7 +111,7 @@ xfs_efi_item_unpin(xfs_efi_log_item_t *efip, int stale)
 	xfs_mount_t	*mp;
 
 	mp = efip->efi_item.li_mountp;
-	spin_lock(&mp->m_ail_lock);
+	spin_lock(&mp->m_ail->xa_lock);
 	if (efip->efi_flags & XFS_EFI_CANCELED) {
 		/*
 		 * xfs_trans_delete_ail() drops the AIL lock.
@@ -120,7 +120,7 @@ xfs_efi_item_unpin(xfs_efi_log_item_t *efip, int stale)
 		xfs_efi_item_free(efip);
 	} else {
 		efip->efi_flags |= XFS_EFI_COMMITTED;
-		spin_unlock(&mp->m_ail_lock);
+		spin_unlock(&mp->m_ail->xa_lock);
 	}
 }
 
@@ -138,7 +138,7 @@ xfs_efi_item_unpin_remove(xfs_efi_log_item_t *efip, xfs_trans_t *tp)
 	xfs_log_item_desc_t	*lidp;
 
 	mp = efip->efi_item.li_mountp;
-	spin_lock(&mp->m_ail_lock);
+	spin_lock(&mp->m_ail->xa_lock);
 	if (efip->efi_flags & XFS_EFI_CANCELED) {
 		/*
 		 * free the xaction descriptor pointing to this item
@@ -153,7 +153,7 @@ xfs_efi_item_unpin_remove(xfs_efi_log_item_t *efip, xfs_trans_t *tp)
 		xfs_efi_item_free(efip);
 	} else {
 		efip->efi_flags |= XFS_EFI_COMMITTED;
-		spin_unlock(&mp->m_ail_lock);
+		spin_unlock(&mp->m_ail->xa_lock);
 	}
 }
 
@@ -352,7 +352,7 @@ xfs_efi_release(xfs_efi_log_item_t	*efip,
 	ASSERT(efip->efi_next_extent > 0);
 	ASSERT(efip->efi_flags & XFS_EFI_COMMITTED);
 
-	spin_lock(&mp->m_ail_lock);
+	spin_lock(&mp->m_ail->xa_lock);
 	ASSERT(efip->efi_next_extent >= nextents);
 	efip->efi_next_extent -= nextents;
 	extents_left = efip->efi_next_extent;
@@ -363,7 +363,7 @@ xfs_efi_release(xfs_efi_log_item_t	*efip,
 		xfs_trans_delete_ail(mp, (xfs_log_item_t *)efip);
 		xfs_efi_item_free(efip);
 	} else {
-		spin_unlock(&mp->m_ail_lock);
+		spin_unlock(&mp->m_ail->xa_lock);
 	}
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 448f507..884f22f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2718,11 +2718,11 @@ xfs_idestroy(
 		ASSERT(((lip->li_flags & XFS_LI_IN_AIL) == 0) ||
 				       XFS_FORCED_SHUTDOWN(ip->i_mount));
 		if (lip->li_flags & XFS_LI_IN_AIL) {
-			spin_lock(&mp->m_ail_lock);
+			spin_lock(&mp->m_ail->xa_lock);
 			if (lip->li_flags & XFS_LI_IN_AIL)
 				xfs_trans_delete_ail(mp, lip);
 			else
-				spin_unlock(&mp->m_ail_lock);
+				spin_unlock(&mp->m_ail->xa_lock);
 		}
 		xfs_inode_item_destroy(ip);
 		ip->i_itemp = NULL;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 97c7452..291d30a 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -991,7 +991,7 @@ xfs_iflush_done(
 	 */
 	if (iip->ili_logged &&
 	    (iip->ili_item.li_lsn == iip->ili_flush_lsn)) {
-		spin_lock(&ip->i_mount->m_ail_lock);
+		spin_lock(&ip->i_mount->m_ail->xa_lock);
 		if (iip->ili_item.li_lsn == iip->ili_flush_lsn) {
 			/*
 			 * xfs_trans_delete_ail() drops the AIL lock.
@@ -999,7 +999,7 @@ xfs_iflush_done(
 			xfs_trans_delete_ail(ip->i_mount,
 					     (xfs_log_item_t*)iip);
 		} else {
-			spin_unlock(&ip->i_mount->m_ail_lock);
+			spin_unlock(&ip->i_mount->m_ail->xa_lock);
 		}
 	}
 
@@ -1038,14 +1038,14 @@ xfs_iflush_abort(
 	mp = ip->i_mount;
 	if (iip) {
 		if (iip->ili_item.li_flags & XFS_LI_IN_AIL) {
-			spin_lock(&mp->m_ail_lock);
+			spin_lock(&mp->m_ail->xa_lock);
 			if (iip->ili_item.li_flags & XFS_LI_IN_AIL) {
 				/*
 				 * xfs_trans_delete_ail() drops the AIL lock.
 				 */
 				xfs_trans_delete_ail(mp, (xfs_log_item_t *)iip);
 			} else
-				spin_unlock(&mp->m_ail_lock);
+				spin_unlock(&mp->m_ail->xa_lock);
 		}
 		iip->ili_logged = 0;
 		/*
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 70f5063..d3d7042 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -539,7 +539,6 @@ xfs_log_mount(
 	/*
 	 * Initialize the AIL now we have a log.
 	 */
-	spin_lock_init(&mp->m_ail_lock);
 	error = xfs_trans_ail_init(mp);
 	if (error) {
 		cmn_err(CE_WARN, "XFS: AIL initialisation failed: error %d", error);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 46ef060..a2d6d78 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2684,7 +2684,7 @@ xlog_recover_do_efi_trans(
 	efip->efi_next_extent = efi_formatp->efi_nextents;
 	efip->efi_flags |= XFS_EFI_COMMITTED;
 
-	spin_lock(&mp->m_ail_lock);
+	spin_lock(&mp->m_ail->xa_lock);
 	/*
 	 * xfs_trans_update_ail() drops the AIL lock.
 	 */
@@ -2730,7 +2730,7 @@ xlog_recover_do_efd_trans(
 	 * in the AIL.
 	 */
 	mp = log->l_mp;
-	spin_lock(&mp->m_ail_lock);
+	spin_lock(&mp->m_ail->xa_lock);
 	lip = xfs_trans_ail_cursor_first(mp->m_ail, &cur, 0);
 	while (lip != NULL) {
 		if (lip->li_type == XFS_LI_EFI) {
@@ -2742,14 +2742,14 @@ xlog_recover_do_efd_trans(
 				 */
 				xfs_trans_delete_ail(mp, lip);
 				xfs_efi_item_free(efip);
-				spin_lock(&mp->m_ail_lock);
+				spin_lock(&mp->m_ail->xa_lock);
 				break;
 			}
 		}
 		lip = xfs_trans_ail_cursor_next(mp->m_ail, &cur);
 	}
 	xfs_trans_ail_cursor_done(mp->m_ail, &cur);
-	spin_unlock(&mp->m_ail_lock);
+	spin_unlock(&mp->m_ail->xa_lock);
 }
 
 /*
@@ -3079,7 +3079,7 @@ xlog_recover_process_efis(
 	struct xfs_ail_cursor	cur;
 
 	mp = log->l_mp;
-	spin_lock(&mp->m_ail_lock);
+	spin_lock(&mp->m_ail->xa_lock);
 
 	lip = xfs_trans_ail_cursor_first(mp->m_ail, &cur, 0);
 	while (lip != NULL) {
@@ -3100,16 +3100,16 @@ xlog_recover_process_efis(
 			continue;
 		}
 
-		spin_unlock(&mp->m_ail_lock);
+		spin_unlock(&mp->m_ail->xa_lock);
 		error = xlog_recover_process_efi(mp, efip);
-		spin_lock(&mp->m_ail_lock);
+		spin_lock(&mp->m_ail->xa_lock);
 		if (error)
 			goto out;
 		lip = xfs_trans_ail_cursor_next(mp->m_ail, &cur);
 	}
 out:
 	xfs_trans_ail_cursor_done(mp->m_ail, &cur);
-	spin_unlock(&mp->m_ail_lock);
+	spin_unlock(&mp->m_ail->xa_lock);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a24b407..b9c24c3 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -228,7 +228,6 @@ extern void	xfs_icsb_sync_counters_locked(struct xfs_mount *, int);
 typedef struct xfs_mount {
 	struct super_block	*m_super;
 	xfs_tid_t		m_tid;		/* next unused tid for fs */
-	spinlock_t		m_ail_lock;	/* fs AIL mutex */
 	struct xfs_ail		*m_ail;		/* fs active log item list */
 	xfs_sb_t		m_sb;		/* copy of fs superblock */
 	spinlock_t		m_sb_lock;	/* sb counter lock */
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 4e1c22a..99ba0e2 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1425,7 +1425,7 @@ xfs_trans_chunk_committed(
 		 * the test below.
 		 */
 		mp = lip->li_mountp;
-		spin_lock(&mp->m_ail_lock);
+		spin_lock(&mp->m_ail->xa_lock);
 		if (XFS_LSN_CMP(item_lsn, lip->li_lsn) > 0) {
 			/*
 			 * This will set the item's lsn to item_lsn
@@ -1436,7 +1436,7 @@ xfs_trans_chunk_committed(
 			 */
 			xfs_trans_update_ail(mp, lip, item_lsn);
 		} else {
-			spin_unlock(&mp->m_ail_lock);
+			spin_unlock(&mp->m_ail->xa_lock);
 		}
 
 		/*
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 0591888..e06b62f 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2008 Dave Chinner
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -56,14 +57,14 @@ xfs_trans_ail_tail(
 	xfs_lsn_t	lsn;
 	xfs_log_item_t	*lip;
 
-	spin_lock(&ailp->xa_mount->m_ail_lock);
+	spin_lock(&ailp->xa_lock);
 	lip = xfs_ail_min(ailp);
 	if (lip == NULL) {
 		lsn = (xfs_lsn_t)0;
 	} else {
 		lsn = lip->li_lsn;
 	}
-	spin_unlock(&ailp->xa_mount->m_ail_lock);
+	spin_unlock(&ailp->xa_lock);
 
 	return lsn;
 }
@@ -214,14 +215,14 @@ xfsaild_push(
 	xfs_mount_t	*mp = ailp->xa_mount;
 	struct xfs_ail_cursor	*cur = &ailp->xa_cursors;
 
-	spin_lock(&mp->m_ail_lock);
+	spin_lock(&ailp->xa_lock);
 	lip = xfs_trans_ail_cursor_first(ailp, cur, *last_lsn);
 	if (!lip || XFS_FORCED_SHUTDOWN(mp)) {
 		/*
 		 * AIL is empty or our push has reached the end.
 		 */
 		xfs_trans_ail_cursor_done(ailp, cur);
-		spin_unlock(&mp->m_ail_lock);
+		spin_unlock(&ailp->xa_lock);
 		last_pushed_lsn = 0;
 		return tout;
 	}
@@ -256,7 +257,7 @@ xfsaild_push(
 		 * skip to the next item in the list.
 		 */
 		lock_result = IOP_TRYLOCK(lip);
-		spin_unlock(&mp->m_ail_lock);
+		spin_unlock(&ailp->xa_lock);
 		switch (lock_result) {
 		case XFS_ITEM_SUCCESS:
 			XFS_STATS_INC(xs_push_ail_success);
@@ -293,7 +294,7 @@ xfsaild_push(
 			break;
 		}
 
-		spin_lock(&mp->m_ail_lock);
+		spin_lock(&ailp->xa_lock);
 		/* should we bother continuing? */
 		if (XFS_FORCED_SHUTDOWN(mp))
 			break;
@@ -322,7 +323,7 @@ xfsaild_push(
 		lsn = lip->li_lsn;
 	}
 	xfs_trans_ail_cursor_done(ailp, cur);
-	spin_unlock(&mp->m_ail_lock);
+	spin_unlock(&ailp->xa_lock);
 
 	if (flush_log) {
 		/*
@@ -423,30 +424,31 @@ void
 xfs_trans_update_ail(
 	xfs_mount_t	*mp,
 	xfs_log_item_t	*lip,
-	xfs_lsn_t	lsn) __releases(mp->m_ail_lock)
+	xfs_lsn_t	lsn) __releases(ailp->xa_lock)
 {
-	xfs_log_item_t		*dlip=NULL;
+	struct xfs_ail		*ailp = mp->m_ail;
+	xfs_log_item_t		*dlip = NULL;
 	xfs_log_item_t		*mlip;	/* ptr to minimum lip */
 
-	mlip = xfs_ail_min(mp->m_ail);
+	mlip = xfs_ail_min(ailp);
 
 	if (lip->li_flags & XFS_LI_IN_AIL) {
-		dlip = xfs_ail_delete(mp->m_ail, lip);
+		dlip = xfs_ail_delete(ailp, lip);
 		ASSERT(dlip == lip);
-		xfs_trans_ail_cursor_clear(mp->m_ail, dlip);
+		xfs_trans_ail_cursor_clear(ailp, dlip);
 	} else {
 		lip->li_flags |= XFS_LI_IN_AIL;
 	}
 
 	lip->li_lsn = lsn;
-	xfs_ail_insert(mp->m_ail, lip);
+	xfs_ail_insert(ailp, lip);
 
 	if (mlip == dlip) {
-		mlip = xfs_ail_min(mp->m_ail);
-		spin_unlock(&mp->m_ail_lock);
+		mlip = xfs_ail_min(ailp);
+		spin_unlock(&ailp->xa_lock);
 		xfs_log_move_tail(mp, mlip->li_lsn);
 	} else {
-		spin_unlock(&mp->m_ail_lock);
+		spin_unlock(&ailp->xa_lock);
 	}
 
 
@@ -470,27 +472,28 @@ xfs_trans_update_ail(
 void
 xfs_trans_delete_ail(
 	xfs_mount_t	*mp,
-	xfs_log_item_t	*lip) __releases(mp->m_ail_lock)
+	xfs_log_item_t	*lip) __releases(ailp->xa_lock)
 {
+	struct xfs_ail		*ailp = mp->m_ail;
 	xfs_log_item_t		*dlip;
 	xfs_log_item_t		*mlip;
 
 	if (lip->li_flags & XFS_LI_IN_AIL) {
-		mlip = xfs_ail_min(mp->m_ail);
-		dlip = xfs_ail_delete(mp->m_ail, lip);
+		mlip = xfs_ail_min(ailp);
+		dlip = xfs_ail_delete(ailp, lip);
 		ASSERT(dlip == lip);
-		xfs_trans_ail_cursor_clear(mp->m_ail, dlip);
+		xfs_trans_ail_cursor_clear(ailp, dlip);
 
 
 		lip->li_flags &= ~XFS_LI_IN_AIL;
 		lip->li_lsn = 0;
 
 		if (mlip == dlip) {
-			mlip = xfs_ail_min(mp->m_ail);
-			spin_unlock(&mp->m_ail_lock);
+			mlip = xfs_ail_min(ailp);
+			spin_unlock(&ailp->xa_lock);
 			xfs_log_move_tail(mp, (mlip ? mlip->li_lsn : 0));
 		} else {
-			spin_unlock(&mp->m_ail_lock);
+			spin_unlock(&ailp->xa_lock);
 		}
 	}
 	else {
@@ -498,13 +501,11 @@ xfs_trans_delete_ail(
 		 * If the file system is not being shutdown, we are in
 		 * serious trouble if we get to this stage.
 		 */
-		if (XFS_FORCED_SHUTDOWN(mp))
-			spin_unlock(&mp->m_ail_lock);
-		else {
+		spin_unlock(&ailp->xa_lock);
+		if (!XFS_FORCED_SHUTDOWN(mp)) {
 			xfs_cmn_err(XFS_PTAG_AILDELETE, CE_ALERT, mp,
 		"%s: attempting to delete a log item that is not in the AIL",
 					__func__);
-			spin_unlock(&mp->m_ail_lock);
 			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		}
 	}
@@ -539,6 +540,7 @@ xfs_trans_ail_init(
 
 	ailp->xa_mount = mp;
 	INIT_LIST_HEAD(&ailp->xa_ail);
+	spin_lock_init(&ailp->xa_lock);
 	error = xfsaild_start(ailp);
 	if (error)
 		goto out_free_ailp;
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index c6ea7fe..32f67fa 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -76,6 +76,7 @@ struct xfs_ail {
 	struct task_struct	*xa_task;
 	xfs_lsn_t		xa_target;
 	struct xfs_ail_cursor	xa_cursors;
+	spinlock_t		xa_lock;
 };
 
 /*
@@ -111,9 +112,9 @@ xfs_trans_ail_copy_lsn(
 	xfs_lsn_t	*src)
 {
 	ASSERT(sizeof(xfs_lsn_t) == 8);	/* don't lock if it shrinks */
-	spin_lock(&ailp->xa_mount->m_ail_lock);
+	spin_lock(&ailp->xa_lock);
 	*dst = *src;
-	spin_unlock(&ailp->xa_mount->m_ail_lock);
+	spin_unlock(&ailp->xa_lock);
 }
 #else
 static inline void
-- 
1.5.6
