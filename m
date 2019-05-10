Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36102 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727767AbfEJUSo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 May 2019 16:18:44 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 10/11] libxfs: reorder trans.c to match xfs_trans.c
Date: Fri, 10 May 2019 15:18:29 -0500
Message-Id: <1557519510-10602-11-git-send-email-sandeen@redhat.com>
In-Reply-To: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Reorder the functions in libxfs/trans.c to more closely match
the order in the kernel's xfs_trans.c.  It's not 1:1 but much
closer now, and the forward declarations can be removed as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/trans.c | 251 +++++++++++++++++++++++++++------------------------------
 1 file changed, 121 insertions(+), 130 deletions(-)

diff --git a/libxfs/trans.c b/libxfs/trans.c
index f199d15..4d83ec5 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -12,19 +12,10 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-#include "xfs_inode_buf.h"
-#include "xfs_inode_fork.h"
-#include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_defer.h"
 
-static void xfs_trans_free_items(struct xfs_trans *tp);
-STATIC struct xfs_trans *xfs_trans_dup(struct xfs_trans *tp);
-static int xfs_trans_reserve(struct xfs_trans *tp, struct xfs_trans_res *resp,
-		uint blocks, uint rtextents);
-static int __xfs_trans_commit(struct xfs_trans *tp, bool regrant);
-
 /*
  * Simple transaction interface
  */
@@ -43,79 +34,6 @@ xfs_trans_init(
 }
 
 /*
- * Add the given log item to the transaction's list of log items.
- */
-void
-xfs_trans_add_item(
-	struct xfs_trans	*tp,
-	struct xfs_log_item	*lip)
-{
-	ASSERT(lip->li_mountp == tp->t_mountp);
-	ASSERT(lip->li_ailp == tp->t_mountp->m_ail);
-	ASSERT(list_empty(&lip->li_trans));
-	ASSERT(!test_bit(XFS_LI_DIRTY, &lip->li_flags));
-
-	list_add_tail(&lip->li_trans, &tp->t_items);
-}
-
-/*
- * Unlink and free the given descriptor.
- */
-void
-xfs_trans_del_item(
-	struct xfs_log_item	*lip)
-{
-	clear_bit(XFS_LI_DIRTY, &lip->li_flags);
-	list_del_init(&lip->li_trans);
-}
-
-/*
- * Roll from one trans in the sequence of PERMANENT transactions to
- * the next: permanent transactions are only flushed out when
- * committed with XFS_TRANS_RELEASE_LOG_RES, but we still want as soon
- * as possible to let chunks of it go to the log. So we commit the
- * chunk we've been working on and get a new transaction to continue.
- */
-int
-xfs_trans_roll(
-	struct xfs_trans	**tpp)
-{
-	struct xfs_trans	*trans = *tpp;
-	struct xfs_trans_res	tres;
-	int			error;
-
-	/*
-	 * Copy the critical parameters from one trans to the next.
-	 */
-	tres.tr_logres = trans->t_log_res;
-	tres.tr_logcount = trans->t_log_count;
-
-	*tpp = xfs_trans_dup(trans);
-
-	/*
-	 * Commit the current transaction.
-	 * If this commit failed, then it'd just unlock those items that
-	 * are marked to be released. That also means that a filesystem shutdown
-	 * is in progress. The caller takes the responsibility to cancel
-	 * the duplicate transaction that gets returned.
-	 */
-	error = __xfs_trans_commit(trans, true);
-	if (error)
-		return error;
-
-	/*
-	 * Reserve space in the log for the next transaction.
-	 * This also pushes items in the "AIL", the list of logged items,
-	 * out to disk if they are taking up space at the tail of the log
-	 * that we want to use.  This requires that either nothing be locked
-	 * across this call, or that anything that is locked be logged in
-	 * the prior and the next transactions.
-	 */
-	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-	return xfs_trans_reserve(*tpp, &tres, 0, 0);
-}
-
-/*
  * Free the transaction structure.  If there is more clean up
  * to do when the structure is freed, add it here.
  */
@@ -277,6 +195,21 @@ xfs_trans_alloc(
 }
 
 /*
+ * Allocate a transaction that can be rolled.  Since userspace doesn't have
+ * a need for log reservations, we really only tr_itruncate to get the
+ * permanent log reservation flag to avoid blowing asserts.
+ */
+int
+libxfs_trans_alloc_rollable(
+	struct xfs_mount	*mp,
+	unsigned int		blocks,
+	struct xfs_trans	**tpp)
+{
+	return xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, blocks,
+			0, 0, tpp);
+}
+
+/*
  * Create an empty transaction with no reservation.  This is a defensive
  * mechanism for routines that query metadata without actually modifying
  * them -- if the metadata being queried is somehow cross-linked (think a
@@ -299,44 +232,6 @@ xfs_trans_alloc_empty(
 }
 
 /*
- * Allocate a transaction that can be rolled.  Since userspace doesn't have
- * a need for log reservations, we really only tr_itruncate to get the
- * permanent log reservation flag to avoid blowing asserts.
- */
-int
-xfs_trans_alloc_rollable(
-	struct xfs_mount	*mp,
-	unsigned int		blocks,
-	struct xfs_trans	**tpp)
-{
-	return libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, blocks,
-			0, 0, tpp);
-}
-
-void
-xfs_trans_cancel(
-	struct xfs_trans	*tp)
-{
-#ifdef XACT_DEBUG
-	struct xfs_trans	*otp = tp;
-#endif
-	if (tp == NULL)
-		goto out;
-
-	if (tp->t_flags & XFS_TRANS_PERM_LOG_RES)
-		xfs_defer_cancel(tp);
-
-	xfs_trans_free_items(tp);
-	xfs_trans_free(tp);
-
-out:
-#ifdef XACT_DEBUG
-	fprintf(stderr, "## cancelled transaction %p\n", otp);
-#endif
-	return;
-}
-
-/*
  * Record the indicated change to the given field for application
  * to the file system's superblock when the transaction commits.
  * For now, just store the change in the transaction structure.
@@ -383,19 +278,46 @@ _("Transaction block reservation exceeded! %u > %u\n"),
 	tp->t_flags |= (XFS_TRANS_SB_DIRTY | XFS_TRANS_DIRTY);
 }
 
+/*
+ * Add the given log item to the transaction's list of log items.
+ */
+void
+xfs_trans_add_item(
+	struct xfs_trans	*tp,
+	struct xfs_log_item	*lip)
+{
+	ASSERT(lip->li_mountp == tp->t_mountp);
+	ASSERT(lip->li_ailp == tp->t_mountp->m_ail);
+	ASSERT(list_empty(&lip->li_trans));
+	ASSERT(!test_bit(XFS_LI_DIRTY, &lip->li_flags));
+
+	list_add_tail(&lip->li_trans, &tp->t_items);
+}
+
+/*
+ * Unlink and free the given descriptor.
+ */
+void
+xfs_trans_del_item(
+	struct xfs_log_item	*lip)
+{
+	clear_bit(XFS_LI_DIRTY, &lip->li_flags);
+	list_del_init(&lip->li_trans);
+}
+
+/* Detach and unlock all of the items in a transaction */
 static void
-trans_committed(
-	xfs_trans_t		*tp)
+xfs_trans_free_items(
+	struct xfs_trans	*tp)
 {
 	struct xfs_log_item	*lip, *next;
 
 	list_for_each_entry_safe(lip, next, &tp->t_items, li_trans) {
 		xfs_trans_del_item(lip);
-
 		if (lip->li_type == XFS_LI_BUF)
-			buf_item_done((xfs_buf_log_item_t *)lip);
+			buf_item_unlock((xfs_buf_log_item_t *)lip);
 		else if (lip->li_type == XFS_LI_INODE)
-			inode_item_done((xfs_inode_log_item_t *)lip);
+			inode_item_unlock((xfs_inode_log_item_t *)lip);
 		else {
 			fprintf(stderr, _("%s: unrecognised log item type\n"),
 				progname);
@@ -404,19 +326,19 @@ trans_committed(
 	}
 }
 
-/* Detach and unlock all of the items in a transaction */
 static void
-xfs_trans_free_items(
-	struct xfs_trans	*tp)
+trans_committed(
+	xfs_trans_t		*tp)
 {
 	struct xfs_log_item	*lip, *next;
 
 	list_for_each_entry_safe(lip, next, &tp->t_items, li_trans) {
 		xfs_trans_del_item(lip);
+
 		if (lip->li_type == XFS_LI_BUF)
-			buf_item_unlock((xfs_buf_log_item_t *)lip);
+			buf_item_done((xfs_buf_log_item_t *)lip);
 		else if (lip->li_type == XFS_LI_INODE)
-			inode_item_unlock((xfs_inode_log_item_t *)lip);
+			inode_item_done((xfs_inode_log_item_t *)lip);
 		else {
 			fprintf(stderr, _("%s: unrecognised log item type\n"),
 				progname);
@@ -492,3 +414,72 @@ xfs_trans_commit(
 {
 	return __xfs_trans_commit(tp, false);
 }
+
+void
+xfs_trans_cancel(
+	struct xfs_trans	*tp)
+{
+#ifdef XACT_DEBUG
+	struct xfs_trans	*otp = tp;
+#endif
+	if (tp == NULL)
+		goto out;
+
+	if (tp->t_flags & XFS_TRANS_PERM_LOG_RES)
+		xfs_defer_cancel(tp);
+
+	xfs_trans_free_items(tp);
+	xfs_trans_free(tp);
+
+out:
+#ifdef XACT_DEBUG
+	fprintf(stderr, "## cancelled transaction %p\n", otp);
+#endif
+	return;
+}
+
+/*
+ * Roll from one trans in the sequence of PERMANENT transactions to
+ * the next: permanent transactions are only flushed out when
+ * committed with XFS_TRANS_RELEASE_LOG_RES, but we still want as soon
+ * as possible to let chunks of it go to the log. So we commit the
+ * chunk we've been working on and get a new transaction to continue.
+ */
+int
+xfs_trans_roll(
+	struct xfs_trans	**tpp)
+{
+	struct xfs_trans	*trans = *tpp;
+	struct xfs_trans_res	tres;
+	int			error;
+
+	/*
+	 * Copy the critical parameters from one trans to the next.
+	 */
+	tres.tr_logres = trans->t_log_res;
+	tres.tr_logcount = trans->t_log_count;
+
+	*tpp = xfs_trans_dup(trans);
+
+	/*
+	 * Commit the current transaction.
+	 * If this commit failed, then it'd just unlock those items that
+	 * are marked to be released. That also means that a filesystem shutdown
+	 * is in progress. The caller takes the responsibility to cancel
+	 * the duplicate transaction that gets returned.
+	 */
+	error = __xfs_trans_commit(trans, true);
+	if (error)
+		return error;
+
+	/*
+	 * Reserve space in the log for the next transaction.
+	 * This also pushes items in the "AIL", the list of logged items,
+	 * out to disk if they are taking up space at the tail of the log
+	 * that we want to use.  This requires that either nothing be locked
+	 * across this call, or that anything that is locked be logged in
+	 * the prior and the next transactions.
+	 */
+	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+	return xfs_trans_reserve(*tpp, &tres, 0, 0);
+}
-- 
1.8.3.1
