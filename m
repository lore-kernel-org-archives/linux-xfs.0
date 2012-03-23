Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2N1mD1J071418 for <xfs@oss.sgi.com>; Thu, 22 Mar 2012 20:48:13 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	g5M28ieZE0o6URWe for <xfs@oss.sgi.com>;
	Thu, 22 Mar 2012 18:48:10 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SAtbo-0005KB-90
	for xfs@oss.sgi.com; Fri, 23 Mar 2012 12:48:04 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SAtbW-0003OU-CU
	for xfs@oss.sgi.com; Fri, 23 Mar 2012 12:47:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: move shutdown out of xfs_trans_ail_delete_bulk
Date: Fri, 23 Mar 2012 12:47:42 +1100
Message-Id: <1332467263-12985-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1332467263-12985-1-git-send-email-david@fromorbit.com>
References: <1332467263-12985-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

xfs_trans_ail_delete_bulk() can be called from different contexts so
if the itemis not in the AIL we need different shutdown for each
context.  Move the shutdown to the call locations to prepare for
changing the shutdown methods where appropriate.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c     |   12 ++++++++++--
 fs/xfs/xfs_dquot.c        |    9 ++++++---
 fs/xfs/xfs_dquot_item.c   |    5 ++++-
 fs/xfs/xfs_extfree_item.c |    7 ++++++-
 fs/xfs/xfs_iget.c         |    9 ++++++---
 fs/xfs/xfs_inode_item.c   |   16 +++++++++++++---
 fs/xfs/xfs_log_recover.c  |   12 +++++++-----
 fs/xfs/xfs_trans_ail.c    |   10 ++++++----
 fs/xfs/xfs_trans_priv.h   |    6 +++---
 9 files changed, 61 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index eac97ef..3e5f654 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -454,8 +454,13 @@ xfs_buf_item_unpin(
 			bp->b_fspriv = NULL;
 			bp->b_iodone = NULL;
 		} else {
+			int error;
+
 			spin_lock(&ailp->xa_lock);
-			xfs_trans_ail_delete(ailp, (xfs_log_item_t *)bip);
+			error = xfs_trans_ail_delete(ailp, lip);
+			if (error == EFSCORRUPTED)
+				xfs_force_shutdown(ailp->xa_mount,
+						   SHUTDOWN_CORRUPT_INCORE);
 			xfs_buf_item_relse(bp);
 			ASSERT(bp->b_fspriv == NULL);
 		}
@@ -1030,6 +1035,7 @@ xfs_buf_iodone(
 	struct xfs_log_item	*lip)
 {
 	struct xfs_ail		*ailp = lip->li_ailp;
+	int			error;
 
 	ASSERT(BUF_ITEM(lip)->bli_buf == bp);
 
@@ -1045,6 +1051,8 @@ xfs_buf_iodone(
 	 * Either way, AIL is useless if we're forcing a shutdown.
 	 */
 	spin_lock(&ailp->xa_lock);
-	xfs_trans_ail_delete(ailp, lip);
+	error = xfs_trans_ail_delete(ailp, lip);
+	if (error == EFSCORRUPTED)
+		xfs_force_shutdown(ailp->xa_mount, SHUTDOWN_CORRUPT_INCORE);
 	xfs_buf_item_free(BUF_ITEM(lip));
 }
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 4be16a0..cd5bd4b 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -856,9 +856,12 @@ xfs_qm_dqflush_done(
 
 		/* xfs_trans_ail_delete() drops the AIL lock. */
 		spin_lock(&ailp->xa_lock);
-		if (lip->li_lsn == qip->qli_flush_lsn)
-			xfs_trans_ail_delete(ailp, lip);
-		else
+		if (lip->li_lsn == qip->qli_flush_lsn) {
+			int	error = xfs_trans_ail_delete(ailp, lip);
+			if (error == EFSCORRUPTED)
+				xfs_force_shutdown(ailp->xa_mount,
+						SHUTDOWN_CORRUPT_INCORE);
+		} else
 			spin_unlock(&ailp->xa_lock);
 	}
 
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 34baeae..69a098c 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -448,13 +448,16 @@ xfs_qm_qoffend_logitem_committed(
 	struct xfs_qoff_logitem	*qfe = QOFF_ITEM(lip);
 	struct xfs_qoff_logitem	*qfs = qfe->qql_start_lip;
 	struct xfs_ail		*ailp = qfs->qql_item.li_ailp;
+	int			error;
 
 	/*
 	 * Delete the qoff-start logitem from the AIL.
 	 * xfs_trans_ail_delete() drops the AIL lock.
 	 */
 	spin_lock(&ailp->xa_lock);
-	xfs_trans_ail_delete(ailp, (xfs_log_item_t *)qfs);
+	error = xfs_trans_ail_delete(ailp, (struct xfs_log_item *)qfs);
+	if (error == EFSCORRUPTED)
+		xfs_force_shutdown(ailp->xa_mount, SHUTDOWN_CORRUPT_INCORE);
 
 	kmem_free(qfs);
 	kmem_free(qfe);
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 35c2aff..4ccf2b6 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -62,9 +62,14 @@ __xfs_efi_release(
 	struct xfs_ail		*ailp = efip->efi_item.li_ailp;
 
 	if (!test_and_clear_bit(XFS_EFI_COMMITTED, &efip->efi_flags)) {
+		int	error;
+
 		spin_lock(&ailp->xa_lock);
 		/* xfs_trans_ail_delete() drops the AIL lock. */
-		xfs_trans_ail_delete(ailp, &efip->efi_item);
+		error = xfs_trans_ail_delete(ailp, &efip->efi_item);
+		if (error == EFSCORRUPTED)
+			xfs_force_shutdown(ailp->xa_mount,
+						SHUTDOWN_CORRUPT_INCORE);
 		xfs_efi_item_free(efip);
 	}
 }
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index bcc6c24..4700ba4 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -135,9 +135,12 @@ xfs_inode_free(
 				       XFS_FORCED_SHUTDOWN(ip->i_mount));
 		if (lip->li_flags & XFS_LI_IN_AIL) {
 			spin_lock(&ailp->xa_lock);
-			if (lip->li_flags & XFS_LI_IN_AIL)
-				xfs_trans_ail_delete(ailp, lip);
-			else
+			if (lip->li_flags & XFS_LI_IN_AIL) {
+				int	error = xfs_trans_ail_delete(ailp, lip);
+				if (error == EFSCORRUPTED)
+					xfs_force_shutdown(ailp->xa_mount,
+							SHUTDOWN_CORRUPT_INCORE);
+			} else
 				spin_unlock(&ailp->xa_lock);
 		}
 		xfs_inode_item_destroy(ip);
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 05d924e..b0a813f 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -837,7 +837,9 @@ xfs_iflush_done(
 	 */
 	if (need_ail) {
 		struct xfs_log_item *log_items[need_ail];
-		int i = 0;
+		int	i = 0;
+		int	error;
+
 		spin_lock(&ailp->xa_lock);
 		for (blip = lip; blip; blip = blip->li_bio_list) {
 			iip = INODE_ITEM(blip);
@@ -848,7 +850,10 @@ xfs_iflush_done(
 			ASSERT(i <= need_ail);
 		}
 		/* xfs_trans_ail_delete_bulk() drops the AIL lock. */
-		xfs_trans_ail_delete_bulk(ailp, log_items, i);
+		error = xfs_trans_ail_delete_bulk(ailp, log_items, i);
+		if (error == EFSCORRUPTED)
+			xfs_force_shutdown(ailp->xa_mount,
+						SHUTDOWN_CORRUPT_INCORE);
 	}
 
 
@@ -887,8 +892,13 @@ xfs_iflush_abort(
 		if (iip->ili_item.li_flags & XFS_LI_IN_AIL) {
 			spin_lock(&ailp->xa_lock);
 			if (iip->ili_item.li_flags & XFS_LI_IN_AIL) {
+				int	error;
 				/* xfs_trans_ail_delete() drops the AIL lock. */
-				xfs_trans_ail_delete(ailp, (xfs_log_item_t *)iip);
+				error = xfs_trans_ail_delete(ailp,
+							(xfs_log_item_t *)iip);
+				if (error == EFSCORRUPTED)
+					xfs_force_shutdown(ailp->xa_mount,
+							SHUTDOWN_CORRUPT_INCORE);
 			} else
 				spin_unlock(&ailp->xa_lock);
 		}
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 7c75c73..63df121 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2638,11 +2638,13 @@ xlog_recover_efd_pass2(
 		if (lip->li_type == XFS_LI_EFI) {
 			efip = (xfs_efi_log_item_t *)lip;
 			if (efip->efi_format.efi_id == efi_id) {
-				/*
-				 * xfs_trans_ail_delete() drops the
-				 * AIL lock.
-				 */
-				xfs_trans_ail_delete(ailp, lip);
+				int	error;
+
+				/* xfs_trans_ail_delete() drops the AIL lock. */
+				error = xfs_trans_ail_delete(ailp, lip);
+				if (error == EFSCORRUPTED)
+					xfs_force_shutdown(ailp->xa_mount,
+							SHUTDOWN_CORRUPT_INCORE);
 				xfs_efi_item_free(efip);
 				spin_lock(&ailp->xa_lock);
 				break;
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 1dead07..4c94a1f 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -694,9 +694,10 @@ xfs_trans_ail_update_bulk(
  * of traffic on the lock, especially during IO completion.
  *
  * This function must be called with the AIL lock held.  The lock is dropped
- * before returning.
+ * before returning. If EFSCORRUPTED is returned, the caller must shut down the
+ * filesystem.
  */
-void
+int
 xfs_trans_ail_delete_bulk(
 	struct xfs_ail		*ailp,
 	struct xfs_log_item	**log_items,
@@ -718,9 +719,9 @@ xfs_trans_ail_delete_bulk(
 				xfs_alert_tag(mp, XFS_PTAG_AILDELETE,
 		"%s: attempting to delete a log item that is not in the AIL",
 						__func__);
-				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+				return EFSCORRUPTED;
 			}
-			return;
+			return 0;
 		}
 
 		xfs_ail_delete(ailp, lip);
@@ -735,6 +736,7 @@ xfs_trans_ail_delete_bulk(
 		xlog_assign_tail_lsn(ailp->xa_mount);
 		xfs_log_space_wake(ailp->xa_mount);
 	}
+	return 0;
 }
 
 /*
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 8ab2ced..8ca636a 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -89,15 +89,15 @@ xfs_trans_ail_update(
 	xfs_trans_ail_update_bulk(ailp, NULL, &lip, 1, lsn);
 }
 
-void	xfs_trans_ail_delete_bulk(struct xfs_ail *ailp,
+int	xfs_trans_ail_delete_bulk(struct xfs_ail *ailp,
 				struct xfs_log_item **log_items, int nr_items)
 				__releases(ailp->xa_lock);
-static inline void
+static inline int
 xfs_trans_ail_delete(
 	struct xfs_ail	*ailp,
 	xfs_log_item_t	*lip) __releases(ailp->xa_lock)
 {
-	xfs_trans_ail_delete_bulk(ailp, &lip, 1);
+	return xfs_trans_ail_delete_bulk(ailp, &lip, 1);
 }
 
 void			xfs_ail_push(struct xfs_ail *, xfs_lsn_t);
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
