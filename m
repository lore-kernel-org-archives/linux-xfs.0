Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Sep 2008 07:56:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8DEuXUv022221
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:56:33 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 772917A75CF
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:58:01 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id rW025al6IJzKzBFg for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:58:01 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KeWZS-0002O7-A0
	for xfs@oss.sgi.com; Sun, 14 Sep 2008 00:57:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/8] XFS: Finish removing the mount pointer from the AIL API
Date: Sun, 14 Sep 2008 00:57:57 +1000
Message-Id: <1221317877-8333-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1221317877-8333-1-git-send-email-david@fromorbit.com>
References: <1221317877-8333-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Change all the remaining AIL API functions that are passed
struct xfs_mount pointers to pass pointers directly to the
struct xfs_ail being used. With this conversion, all external
access to the AIL is via the struct xfs_ail. Hence the operation
and referencing of the AIL is almost entirely independent of
the xfs_mount that is using it - it is now much more tightly
tied to the log and the items it is tracking in the log than
it is tied to the xfs_mount.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/quota/xfs_dquot.c      |   15 +++++++--------
 fs/xfs/quota/xfs_dquot_item.c |    8 +++++---
 fs/xfs/xfs_buf_item.c         |   26 +++++++++-----------------
 fs/xfs/xfs_extfree_item.c     |   35 ++++++++++-------------------------
 fs/xfs/xfs_iget.c             |    4 +++-
 fs/xfs/xfs_inode.c            |    8 ++++----
 fs/xfs/xfs_inode_item.c       |   29 ++++++++++++-----------------
 fs/xfs/xfs_log.c              |    2 +-
 fs/xfs/xfs_log_recover.c      |   13 +++++--------
 fs/xfs/xfs_trans.c            |    6 ++----
 fs/xfs/xfs_trans.h            |    3 ---
 fs/xfs/xfs_trans_ail.c        |   41 +++++++++++++++++++++--------------------
 fs/xfs/xfs_trans_buf.c        |    7 +++----
 fs/xfs/xfs_trans_priv.h       |   15 +++++++++------
 14 files changed, 91 insertions(+), 121 deletions(-)

diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index 29a7aa7..d738d37 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -1321,8 +1321,10 @@ xfs_qm_dqflush_done(
 	xfs_dq_logitem_t	*qip)
 {
 	xfs_dquot_t		*dqp;
+	struct xfs_ail		*ailp;
 
 	dqp = qip->qli_dquot;
+	ailp = qip->qli_item.li_ailp;
 
 	/*
 	 * We only want to pull the item from the AIL if its
@@ -1335,15 +1337,12 @@ xfs_qm_dqflush_done(
 	if ((qip->qli_item.li_flags & XFS_LI_IN_AIL) &&
 	    qip->qli_item.li_lsn == qip->qli_flush_lsn) {
 
-		spin_lock(&dqp->q_mount->m_ail->xa_lock);
-		/*
-		 * xfs_trans_delete_ail() drops the AIL lock.
-		 */
+		/* xfs_trans_ail_delete() drops the AIL lock. */
+		spin_lock(&ailp->xa_lock);
 		if (qip->qli_item.li_lsn == qip->qli_flush_lsn)
-			xfs_trans_delete_ail(dqp->q_mount,
-					     (xfs_log_item_t*)qip);
+			xfs_trans_ail_delete(ailp, (xfs_log_item_t*)qip);
 		else
-			spin_unlock(&dqp->q_mount->m_ail->xa_lock);
+			spin_unlock(&ailp->xa_lock);
 	}
 
 	/*
@@ -1373,7 +1372,7 @@ xfs_dqunlock(
 	mutex_unlock(&(dqp->q_qlock));
 	if (dqp->q_logitem.qli_dquot == dqp) {
 		/* Once was dqp->q_mount, but might just have been cleared */
-		xfs_trans_unlocked_item(dqp->q_logitem.qli_item.li_mountp,
+		xfs_trans_unlocked_item(dqp->q_logitem.qli_item.li_ailp,
 					(xfs_log_item_t*)&(dqp->q_logitem));
 	}
 }
diff --git a/fs/xfs/quota/xfs_dquot_item.c b/fs/xfs/quota/xfs_dquot_item.c
index 478077c..b2f0394 100644
--- a/fs/xfs/quota/xfs_dquot_item.c
+++ b/fs/xfs/quota/xfs_dquot_item.c
@@ -568,14 +568,16 @@ xfs_qm_qoffend_logitem_committed(
 	xfs_lsn_t lsn)
 {
 	xfs_qoff_logitem_t	*qfs;
+	struct xfs_ail		*ailp;
 
 	qfs = qfe->qql_start_lip;
-	spin_lock(&qfs->qql_item.li_mountp->m_ail->xa_lock);
+	ailp = qfs->qql_item.li_ailp;
+	spin_lock(&ailp->xa_lock);
 	/*
 	 * Delete the qoff-start logitem from the AIL.
-	 * xfs_trans_delete_ail() drops the AIL lock.
+	 * xfs_trans_ail_delete() drops the AIL lock.
 	 */
-	xfs_trans_delete_ail(qfs->qql_item.li_mountp, (xfs_log_item_t *)qfs);
+	xfs_trans_ail_delete(ailp, (xfs_log_item_t *)qfs);
 	kmem_free(qfs);
 	kmem_free(qfe);
 	return (xfs_lsn_t)-1;
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index c170421..ce80e2c 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -375,7 +375,7 @@ xfs_buf_item_unpin(
 	xfs_buf_log_item_t	*bip,
 	int			stale)
 {
-	xfs_mount_t	*mp;
+	struct xfs_ail	*ailp;
 	xfs_buf_t	*bp;
 	int		freed;
 
@@ -387,7 +387,7 @@ xfs_buf_item_unpin(
 	xfs_buftrace("XFS_UNPIN", bp);
 
 	freed = atomic_dec_and_test(&bip->bli_refcount);
-	mp = bip->bli_item.li_mountp;
+	ailp = bip->bli_item.li_ailp;
 	xfs_bunpin(bp);
 	if (freed && stale) {
 		ASSERT(bip->bli_flags & XFS_BLI_STALE);
@@ -399,17 +399,17 @@ xfs_buf_item_unpin(
 		xfs_buftrace("XFS_UNPIN STALE", bp);
 		/*
 		 * If we get called here because of an IO error, we may
-		 * or may not have the item on the AIL. xfs_trans_delete_ail()
+		 * or may not have the item on the AIL. xfs_trans_ail_delete()
 		 * will take care of that situation.
-		 * xfs_trans_delete_ail() drops the AIL lock.
+		 * xfs_trans_ail_delete() drops the AIL lock.
 		 */
 		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
 			xfs_buf_do_callbacks(bp, (xfs_log_item_t *)bip);
 			XFS_BUF_SET_FSPRIVATE(bp, NULL);
 			XFS_BUF_CLR_IODONE_FUNC(bp);
 		} else {
-			spin_lock(&mp->m_ail->xa_lock);
-			xfs_trans_delete_ail(mp, (xfs_log_item_t *)bip);
+			spin_lock(&ailp->xa_lock);
+			xfs_trans_ail_delete(ailp, (xfs_log_item_t *)bip);
 			xfs_buf_item_relse(bp);
 			ASSERT(XFS_BUF_FSPRIVATE(bp, void *) == NULL);
 		}
@@ -1117,28 +1117,20 @@ xfs_buf_iodone(
 	xfs_buf_t		*bp,
 	xfs_buf_log_item_t	*bip)
 {
-	struct xfs_mount	*mp;
-	struct xfs_ail		*ailp;
+	struct xfs_ail		*ailp = bip->bli_item.li_ailp;
 
 	ASSERT(bip->bli_buf == bp);
-
-	mp = bip->bli_item.li_mountp;
-	ailp = bip->bli_item.li_ailp;
-
 	/*
 	 * If we are forcibly shutting down, this may well be
 	 * off the AIL already. That's because we simulate the
 	 * log-committed callbacks to unpin these buffers. Or we may never
 	 * have put this item on AIL because of the transaction was
-	 * aborted forcibly. xfs_trans_delete_ail() takes care of these.
+	 * aborted forcibly. xfs_trans_ail_delete() takes care of these.
 	 *
 	 * Either way, AIL is useless if we're forcing a shutdown.
 	 */
 	spin_lock(&ailp->xa_lock);
-	/*
-	 * xfs_trans_delete_ail() drops the AIL lock.
-	 */
-	xfs_trans_delete_ail(mp, (xfs_log_item_t *)bip);
+	xfs_trans_ail_delete(ailp, (xfs_log_item_t *)bip);
 
 #ifdef XFS_TRANS_DEBUG
 	kmem_free(bip->bli_orig);
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index dab5737..05a4bdd 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -108,17 +108,12 @@ xfs_efi_item_pin(xfs_efi_log_item_t *efip)
 STATIC void
 xfs_efi_item_unpin(xfs_efi_log_item_t *efip, int stale)
 {
-	xfs_mount_t		*mp;
-	struct xfs_ail		*ailp;
+	struct xfs_ail		*ailp = efip->efi_item.li_ailp;
 
-	mp = efip->efi_item.li_mountp;
-	ailp = efip->efi_item.li_ailp;
 	spin_lock(&ailp->xa_lock);
 	if (efip->efi_flags & XFS_EFI_CANCELED) {
-		/*
-		 * xfs_trans_delete_ail() drops the AIL lock.
-		 */
-		xfs_trans_delete_ail(mp, (xfs_log_item_t *)efip);
+		/* xfs_trans_ail_delete() drops the AIL lock. */
+		xfs_trans_ail_delete(ailp, (xfs_log_item_t *)efip);
 		xfs_efi_item_free(efip);
 	} else {
 		efip->efi_flags |= XFS_EFI_COMMITTED;
@@ -136,12 +131,9 @@ xfs_efi_item_unpin(xfs_efi_log_item_t *efip, int stale)
 STATIC void
 xfs_efi_item_unpin_remove(xfs_efi_log_item_t *efip, xfs_trans_t *tp)
 {
-	xfs_mount_t		*mp;
-	struct xfs_ail		*ailp;
+	struct xfs_ail		*ailp = efip->efi_item.li_ailp;
 	xfs_log_item_desc_t	*lidp;
 
-	mp = efip->efi_item.li_mountp;
-	ailp = efip->efi_item.li_ailp;
 	spin_lock(&ailp->xa_lock);
 	if (efip->efi_flags & XFS_EFI_CANCELED) {
 		/*
@@ -149,11 +141,9 @@ xfs_efi_item_unpin_remove(xfs_efi_log_item_t *efip, xfs_trans_t *tp)
 		 */
 		lidp = xfs_trans_find_item(tp, (xfs_log_item_t *) efip);
 		xfs_trans_free_item(tp, lidp);
-		/*
-		 * pull the item off the AIL.
-		 * xfs_trans_delete_ail() drops the AIL lock.
-		 */
-		xfs_trans_delete_ail(mp, (xfs_log_item_t *)efip);
+
+		/* xfs_trans_ail_delete() drops the AIL lock. */
+		xfs_trans_ail_delete(ailp, (xfs_log_item_t *)efip);
 		xfs_efi_item_free(efip);
 	} else {
 		efip->efi_flags |= XFS_EFI_COMMITTED;
@@ -350,12 +340,9 @@ void
 xfs_efi_release(xfs_efi_log_item_t	*efip,
 		uint			nextents)
 {
-	xfs_mount_t		*mp;
-	struct xfs_ail		*ailp;
+	struct xfs_ail		*ailp = efip->efi_item.li_ailp;
 	int			extents_left;
 
-	mp = efip->efi_item.li_mountp;
-	ailp = efip->efi_item.li_ailp;
 	ASSERT(efip->efi_next_extent > 0);
 	ASSERT(efip->efi_flags & XFS_EFI_COMMITTED);
 
@@ -364,10 +351,8 @@ xfs_efi_release(xfs_efi_log_item_t	*efip,
 	efip->efi_next_extent -= nextents;
 	extents_left = efip->efi_next_extent;
 	if (extents_left == 0) {
-		/*
-		 * xfs_trans_delete_ail() drops the AIL lock.
-		 */
-		xfs_trans_delete_ail(mp, (xfs_log_item_t *)efip);
+		/* xfs_trans_ail_delete() drops the AIL lock. */
+		xfs_trans_ail_delete(ailp, (xfs_log_item_t *)efip);
 		xfs_efi_item_free(efip);
 	} else {
 		spin_unlock(&ailp->xa_lock);
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index cd17db9..aceeb7c 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -38,6 +38,8 @@
 #include "xfs_ialloc.h"
 #include "xfs_quota.h"
 #include "xfs_utils.h"
+#include "xfs_trans_priv.h"
+#include "xfs_inode_item.h"
 
 /*
  * Check the validity of the inode we just found it the cache
@@ -615,7 +617,7 @@ xfs_iunlock(
 		 * it is in the AIL and anyone is waiting on it.  Don't do
 		 * this if the caller has asked us not to.
 		 */
-		xfs_trans_unlocked_item(ip->i_mount,
+		xfs_trans_unlocked_item(ip->i_itemp->ili_item.li_ailp,
 					(xfs_log_item_t*)(ip->i_itemp));
 	}
 	xfs_ilock_trace(ip, 3, lock_flags, (inst_t *)__return_address);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 884f22f..44671dd 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2712,17 +2712,17 @@ xfs_idestroy(
 		 * inode still in the AIL. If it is there, we should remove
 		 * it to prevent a use-after-free from occurring.
 		 */
-		xfs_mount_t	*mp = ip->i_mount;
 		xfs_log_item_t	*lip = &ip->i_itemp->ili_item;
+		struct xfs_ail	*ailp = lip->li_ailp;
 
 		ASSERT(((lip->li_flags & XFS_LI_IN_AIL) == 0) ||
 				       XFS_FORCED_SHUTDOWN(ip->i_mount));
 		if (lip->li_flags & XFS_LI_IN_AIL) {
-			spin_lock(&mp->m_ail->xa_lock);
+			spin_lock(&ailp->xa_lock);
 			if (lip->li_flags & XFS_LI_IN_AIL)
-				xfs_trans_delete_ail(mp, lip);
+				xfs_trans_ail_delete(ailp, lip);
 			else
-				spin_unlock(&mp->m_ail->xa_lock);
+				spin_unlock(&ailp->xa_lock);
 		}
 		xfs_inode_item_destroy(ip);
 		ip->i_itemp = NULL;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 47594f4..aa9bf05 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -977,9 +977,8 @@ xfs_iflush_done(
 	xfs_buf_t		*bp,
 	xfs_inode_log_item_t	*iip)
 {
-	xfs_inode_t	*ip;
-
-	ip = iip->ili_inode;
+	xfs_inode_t		*ip = iip->ili_inode;
+	struct xfs_ail		*ailp = iip->ili_item.li_ailp;
 
 	/*
 	 * We only want to pull the item from the AIL if it is
@@ -992,15 +991,12 @@ xfs_iflush_done(
 	 */
 	if (iip->ili_logged &&
 	    (iip->ili_item.li_lsn == iip->ili_flush_lsn)) {
-		spin_lock(&ip->i_mount->m_ail->xa_lock);
+		spin_lock(&ailp->xa_lock);
 		if (iip->ili_item.li_lsn == iip->ili_flush_lsn) {
-			/*
-			 * xfs_trans_delete_ail() drops the AIL lock.
-			 */
-			xfs_trans_delete_ail(ip->i_mount,
-					     (xfs_log_item_t*)iip);
+			/* xfs_trans_ail_delete() drops the AIL lock. */
+			xfs_trans_ail_delete(ailp, (xfs_log_item_t*)iip);
 		} else {
-			spin_unlock(&ip->i_mount->m_ail->xa_lock);
+			spin_unlock(&ailp->xa_lock);
 		}
 	}
 
@@ -1032,21 +1028,20 @@ void
 xfs_iflush_abort(
 	xfs_inode_t		*ip)
 {
-	xfs_inode_log_item_t	*iip;
+	xfs_inode_log_item_t	*iip = ip->i_itemp;
 	xfs_mount_t		*mp;
 
 	iip = ip->i_itemp;
 	mp = ip->i_mount;
 	if (iip) {
+		struct xfs_ail	*ailp = iip->ili_item.li_ailp;
 		if (iip->ili_item.li_flags & XFS_LI_IN_AIL) {
-			spin_lock(&mp->m_ail->xa_lock);
+			spin_lock(&ailp->xa_lock);
 			if (iip->ili_item.li_flags & XFS_LI_IN_AIL) {
-				/*
-				 * xfs_trans_delete_ail() drops the AIL lock.
-				 */
-				xfs_trans_delete_ail(mp, (xfs_log_item_t *)iip);
+				/* xfs_trans_ail_delete() drops the AIL lock. */
+				xfs_trans_ail_delete(ailp, (xfs_log_item_t *)iip);
 			} else
-				spin_unlock(&mp->m_ail->xa_lock);
+				spin_unlock(&ailp->xa_lock);
 		}
 		iip->ili_logged = 0;
 		/*
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 1fb22f8..ccf5ea6 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1381,7 +1381,7 @@ xlog_grant_push_ail(xfs_mount_t	*mp,
      */
     if (threshold_lsn &&
 	!XLOG_FORCED_SHUTDOWN(log))
-	    xfs_trans_push_ail(mp, threshold_lsn);
+	    xfs_trans_ail_push(log->l_ailp, threshold_lsn);
 }	/* xlog_grant_push_ail */
 
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b9c1331..37c2bf9 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2686,9 +2686,9 @@ xlog_recover_do_efi_trans(
 
 	spin_lock(&log->l_ailp->xa_lock);
 	/*
-	 * xfs_trans_update_ail() drops the AIL lock.
+	 * xfs_trans_ail_update() drops the AIL lock.
 	 */
-	xfs_trans_update_ail(mp, (xfs_log_item_t *)efip, lsn);
+	xfs_trans_ail_update(log->l_ailp, (xfs_log_item_t *)efip, lsn);
 	return 0;
 }
 
@@ -2707,13 +2707,12 @@ xlog_recover_do_efd_trans(
 	xlog_recover_item_t	*item,
 	int			pass)
 {
-	xfs_mount_t		*mp;
 	xfs_efd_log_format_t	*efd_formatp;
 	xfs_efi_log_item_t	*efip = NULL;
 	xfs_log_item_t		*lip;
 	__uint64_t		efi_id;
 	struct xfs_ail_cursor	cur;
-	struct xfs_ail		*ailp;
+	struct xfs_ail		*ailp = log->l_ailp;
 
 	if (pass == XLOG_RECOVER_PASS1) {
 		return;
@@ -2730,8 +2729,6 @@ xlog_recover_do_efd_trans(
 	 * Search for the efi with the id in the efd format structure
 	 * in the AIL.
 	 */
-	mp = log->l_mp;
-	ailp = log->l_ailp;
 	spin_lock(&ailp->xa_lock);
 	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
 	while (lip != NULL) {
@@ -2739,10 +2736,10 @@ xlog_recover_do_efd_trans(
 			efip = (xfs_efi_log_item_t *)lip;
 			if (efip->efi_format.efi_id == efi_id) {
 				/*
-				 * xfs_trans_delete_ail() drops the
+				 * xfs_trans_ail_delete() drops the
 				 * AIL lock.
 				 */
-				xfs_trans_delete_ail(mp, lip);
+				xfs_trans_ail_delete(ailp, lip);
 				xfs_efi_item_free(efip);
 				spin_lock(&ailp->xa_lock);
 				break;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 5163e12..ad137ef 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1387,7 +1387,6 @@ xfs_trans_chunk_committed(
 
 	lidp = licp->lic_descs;
 	for (i = 0; i < licp->lic_unused; i++, lidp++) {
-		struct xfs_mount	*mp;
 		struct xfs_ail		*ailp;
 
 		if (xfs_lic_isfree(licp, i)) {
@@ -1426,7 +1425,6 @@ xfs_trans_chunk_committed(
 		 * This would cause the earlier transaction to fail
 		 * the test below.
 		 */
-		mp = lip->li_mountp;
 		ailp = lip->li_ailp;
 		spin_lock(&ailp->xa_lock);
 		if (XFS_LSN_CMP(item_lsn, lip->li_lsn) > 0) {
@@ -1435,9 +1433,9 @@ xfs_trans_chunk_committed(
 			 * and update the position of the item in
 			 * the AIL.
 			 *
-			 * xfs_trans_update_ail() drops the AIL lock.
+			 * xfs_trans_ail_update() drops the AIL lock.
 			 */
-			xfs_trans_update_ail(mp, lip, item_lsn);
+			xfs_trans_ail_update(ailp, lip, item_lsn);
 		} else {
 			spin_unlock(&ailp->xa_lock);
 		}
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index d6a9c5c..ce28294 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -979,9 +979,6 @@ void		xfs_trans_cancel(xfs_trans_t *, int);
 int		xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
 int		xfs_trans_ail_init(struct xfs_mount *);
 void		xfs_trans_ail_destroy(struct xfs_mount *);
-void		xfs_trans_push_ail(struct xfs_mount *, xfs_lsn_t);
-void		xfs_trans_unlocked_item(struct xfs_mount *,
-					xfs_log_item_t *);
 xfs_log_busy_slot_t *xfs_trans_add_busy(xfs_trans_t *tp,
 					xfs_agnumber_t ag,
 					xfs_extlen_t idx);
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index e06b62f..929fb58 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -86,16 +86,16 @@ xfs_trans_ail_tail(
  * any of the objects, so the lock is not needed.
  */
 void
-xfs_trans_push_ail(
-	xfs_mount_t		*mp,
-	xfs_lsn_t		threshold_lsn)
+xfs_trans_ail_push(
+	struct xfs_ail	*ailp,
+	xfs_lsn_t	threshold_lsn)
 {
-	xfs_log_item_t		*lip;
+	xfs_log_item_t	*lip;
 
-	lip = xfs_ail_min(mp->m_ail);
-	if (lip && !XFS_FORCED_SHUTDOWN(mp)) {
-		if (XFS_LSN_CMP(threshold_lsn, mp->m_ail->xa_target) > 0)
-			xfsaild_wakeup(mp->m_ail, threshold_lsn);
+	lip = xfs_ail_min(ailp);
+	if (lip && !XFS_FORCED_SHUTDOWN(ailp->xa_mount)) {
+		if (XFS_LSN_CMP(threshold_lsn, ailp->xa_target) > 0)
+			xfsaild_wakeup(ailp, threshold_lsn);
 	}
 }
 
@@ -373,7 +373,7 @@ xfsaild_push(
  */
 void
 xfs_trans_unlocked_item(
-	xfs_mount_t	*mp,
+	struct xfs_ail	*ailp,
 	xfs_log_item_t	*lip)
 {
 	xfs_log_item_t	*min_lip;
@@ -385,7 +385,7 @@ xfs_trans_unlocked_item(
 	 * over some potentially valid data.
 	 */
 	if (!(lip->li_flags & XFS_LI_IN_AIL) ||
-	    XFS_FORCED_SHUTDOWN(mp)) {
+	    XFS_FORCED_SHUTDOWN(ailp->xa_mount)) {
 		return;
 	}
 
@@ -401,10 +401,10 @@ xfs_trans_unlocked_item(
 	 * the call to xfs_log_move_tail() doesn't do anything if there's
 	 * not enough free space to wake people up so we're safe calling it.
 	 */
-	min_lip = xfs_ail_min(mp->m_ail);
+	min_lip = xfs_ail_min(ailp);
 
 	if (min_lip == lip)
-		xfs_log_move_tail(mp, 1);
+		xfs_log_move_tail(ailp->xa_mount, 1);
 }	/* xfs_trans_unlocked_item */
 
 
@@ -421,12 +421,11 @@ xfs_trans_unlocked_item(
  * is dropped before returning.
  */
 void
-xfs_trans_update_ail(
-	xfs_mount_t	*mp,
+xfs_trans_ail_update(
+	struct xfs_ail	*ailp,
 	xfs_log_item_t	*lip,
 	xfs_lsn_t	lsn) __releases(ailp->xa_lock)
 {
-	struct xfs_ail		*ailp = mp->m_ail;
 	xfs_log_item_t		*dlip = NULL;
 	xfs_log_item_t		*mlip;	/* ptr to minimum lip */
 
@@ -446,7 +445,7 @@ xfs_trans_update_ail(
 	if (mlip == dlip) {
 		mlip = xfs_ail_min(ailp);
 		spin_unlock(&ailp->xa_lock);
-		xfs_log_move_tail(mp, mlip->li_lsn);
+		xfs_log_move_tail(ailp->xa_mount, mlip->li_lsn);
 	} else {
 		spin_unlock(&ailp->xa_lock);
 	}
@@ -470,11 +469,10 @@ xfs_trans_update_ail(
  * is dropped before returning.
  */
 void
-xfs_trans_delete_ail(
-	xfs_mount_t	*mp,
+xfs_trans_ail_delete(
+	struct xfs_ail	*ailp,
 	xfs_log_item_t	*lip) __releases(ailp->xa_lock)
 {
-	struct xfs_ail		*ailp = mp->m_ail;
 	xfs_log_item_t		*dlip;
 	xfs_log_item_t		*mlip;
 
@@ -491,7 +489,8 @@ xfs_trans_delete_ail(
 		if (mlip == dlip) {
 			mlip = xfs_ail_min(ailp);
 			spin_unlock(&ailp->xa_lock);
-			xfs_log_move_tail(mp, (mlip ? mlip->li_lsn : 0));
+			xfs_log_move_tail(ailp->xa_mount,
+						(mlip ? mlip->li_lsn : 0));
 		} else {
 			spin_unlock(&ailp->xa_lock);
 		}
@@ -501,6 +500,8 @@ xfs_trans_delete_ail(
 		 * If the file system is not being shutdown, we are in
 		 * serious trouble if we get to this stage.
 		 */
+		struct xfs_mount	*mp = ailp->xa_mount;
+
 		spin_unlock(&ailp->xa_lock);
 		if (!XFS_FORCED_SHUTDOWN(mp)) {
 			xfs_cmn_err(XFS_PTAG_AILDELETE, CE_ALERT, mp,
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 4e855b5..8ee2f8c 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -527,9 +527,8 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 			lip = XFS_BUF_FSPRIVATE(bp, xfs_log_item_t *);
 			if (lip->li_type == XFS_LI_BUF) {
 				bip = XFS_BUF_FSPRIVATE(bp,xfs_buf_log_item_t*);
-				xfs_trans_unlocked_item(
-						bip->bli_item.li_mountp,
-						lip);
+				xfs_trans_unlocked_item(bip->bli_item.li_ailp,
+							lip);
 			}
 		}
 		xfs_buf_relse(bp);
@@ -626,7 +625,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 	 * tell the AIL that the buffer is being unlocked.
 	 */
 	if (bip != NULL) {
-		xfs_trans_unlocked_item(bip->bli_item.li_mountp,
+		xfs_trans_unlocked_item(bip->bli_item.li_ailp,
 					(xfs_log_item_t*)bip);
 	}
 
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 32f67fa..dc10af4 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -82,12 +82,15 @@ struct xfs_ail {
 /*
  * From xfs_trans_ail.c
  */
-void			xfs_trans_update_ail(struct xfs_mount *mp,
-				     struct xfs_log_item *lip, xfs_lsn_t lsn)
-				     __releases(mp->m_ail_lock);
-void			xfs_trans_delete_ail(struct xfs_mount *mp,
-				     struct xfs_log_item *lip)
-				     __releases(mp->m_ail_lock);
+void			xfs_trans_ail_update(struct xfs_ail *ailp,
+					struct xfs_log_item *lip, xfs_lsn_t lsn)
+					__releases(ailp->xa_lock);
+void			xfs_trans_ail_delete(struct xfs_ail *ailp,
+					struct xfs_log_item *lip)
+					__releases(ailp->xa_lock);
+void			xfs_trans_ail_push(struct xfs_ail *, xfs_lsn_t);
+void			xfs_trans_unlocked_item(struct xfs_ail *,
+					xfs_log_item_t *);
 
 xfs_lsn_t		xfs_trans_ail_tail(struct xfs_ail *ailp);
 
-- 
1.5.6
