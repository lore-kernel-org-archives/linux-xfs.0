Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 913CCC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:30:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7048C6112E
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235226AbhIRBcG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 21:32:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235000AbhIRBcE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Sep 2021 21:32:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6480A6112E;
        Sat, 18 Sep 2021 01:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631928641;
        bh=ghQyIojs0oJBpJGFHFcVwqdNgIwSqZCx+7VhlP3lctM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qKc3x1YSkLChlL95aw3kZ5OeLvXGIPC/uDfCVVrFwifoVBUTOUTP9LwdHqXiXO/0W
         Ef5S9elUie0v6eHF4sAqdwDHWz9r7jzc2jxXn7YSZN8t8XdLGQBOJ31bZerQIS7nL5
         A6MASNAEDW6BKlESFpYSoMxZKD3cfmnFFlxDigH15YvuwEPMDDtvF3ChC1jXBrYcrg
         i8TOdt5zyrd7s04qNb8v0IVIg0dppZD0VoGZ8fazMYGD3u3yBten9sWwQCzxCnLJ00
         RZgwlAPw2rK0hp/TQwtP6/N+PxQo/QSWuxRPzbkyNaCYoXz2mBhaoJw8kYbbXi50OT
         4DGBpzh5a5ezw==
Subject: [PATCH 2/2] xfs: port the defer ops capture and continue to resource
 capture
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 17 Sep 2021 18:30:41 -0700
Message-ID: <163192864113.417887.5635394728171508101.stgit@magnolia>
In-Reply-To: <163192863018.417887.1729794799105892028.stgit@magnolia>
References: <163192863018.417887.1729794799105892028.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When log recovery tries to recover a transaction that had log intent
items attached to it, it has to save certain parts of the transaction
state (reservation, dfops chain, inodes with no automatic unlock) so
that it can finish single-stepping the recovered transactions before
finishing the chains.

This is done with the xfs_defer_ops_capture and xfs_defer_ops_continue
functions.  Right now they open-code this functionality, so let's port
this to the formalized resource capture structure that we introduced in
the previous patch.  This enables us to hold up to two inodes and two
buffers during log recovery, the same way we do for regular runtime.

With this patch applied, we'll be ready to support atomic extent swap
which holds two inodes; and logged xattrs which holds one inode and one
xattr leaf buffer.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c  |   86 +++++++++++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_defer.h  |   14 +++----
 fs/xfs/xfs_bmap_item.c     |    2 +
 fs/xfs/xfs_extfree_item.c  |    2 +
 fs/xfs/xfs_log_recover.c   |   12 ++----
 fs/xfs/xfs_refcount_item.c |    2 +
 fs/xfs/xfs_rmap_item.c     |    2 +
 7 files changed, 79 insertions(+), 41 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 7c6490f3e537..136a367d7b16 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -650,10 +650,11 @@ xfs_defer_move(
  */
 static struct xfs_defer_capture *
 xfs_defer_ops_capture(
-	struct xfs_trans		*tp,
-	struct xfs_inode		*capture_ip)
+	struct xfs_trans		*tp)
 {
 	struct xfs_defer_capture	*dfc;
+	unsigned short			i;
+	int				error;
 
 	if (list_empty(&tp->t_dfops))
 		return NULL;
@@ -677,27 +678,48 @@ xfs_defer_ops_capture(
 	/* Preserve the log reservation size. */
 	dfc->dfc_logres = tp->t_log_res;
 
+	error = xfs_defer_save_resources(&dfc->dfc_held, tp);
+	if (error) {
+		/*
+		 * Resource capture should never fail, but if it does, we
+		 * still have to shut down the log and release things
+		 * properly.
+		 */
+		xfs_force_shutdown(tp->t_mountp, SHUTDOWN_CORRUPT_INCORE);
+	}
+
 	/*
-	 * Grab an extra reference to this inode and attach it to the capture
-	 * structure.
+	 * Grab extra references to the inodes and buffers because callers are
+	 * expected to release their held references after we commit the
+	 * transaction.
 	 */
-	if (capture_ip) {
-		ihold(VFS_I(capture_ip));
-		dfc->dfc_capture_ip = capture_ip;
+	for (i = 0; i < dfc->dfc_held.dr_inos; i++) {
+		ASSERT(xfs_isilocked(dfc->dfc_held.dr_ip[i], XFS_ILOCK_EXCL));
+		ihold(VFS_I(dfc->dfc_held.dr_ip[i]));
 	}
 
+	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
+		xfs_buf_hold(dfc->dfc_held.dr_bp[i]);
+
 	return dfc;
 }
 
 /* Release all resources that we used to capture deferred ops. */
 void
-xfs_defer_ops_release(
+xfs_defer_ops_capture_free(
 	struct xfs_mount		*mp,
 	struct xfs_defer_capture	*dfc)
 {
+	unsigned short			i;
+
 	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
-	if (dfc->dfc_capture_ip)
-		xfs_irele(dfc->dfc_capture_ip);
+
+	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
+		xfs_buf_relse(dfc->dfc_held.dr_bp[i]);
+
+	for (i = 0; i < dfc->dfc_held.dr_inos; i++)
+		xfs_irele(dfc->dfc_held.dr_ip[i]);
+
 	kmem_free(dfc);
 }
 
@@ -712,24 +734,21 @@ xfs_defer_ops_release(
 int
 xfs_defer_ops_capture_and_commit(
 	struct xfs_trans		*tp,
-	struct xfs_inode		*capture_ip,
 	struct list_head		*capture_list)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_defer_capture	*dfc;
 	int				error;
 
-	ASSERT(!capture_ip || xfs_isilocked(capture_ip, XFS_ILOCK_EXCL));
-
 	/* If we don't capture anything, commit transaction and exit. */
-	dfc = xfs_defer_ops_capture(tp, capture_ip);
+	dfc = xfs_defer_ops_capture(tp);
 	if (!dfc)
 		return xfs_trans_commit(tp);
 
 	/* Commit the transaction and add the capture structure to the list. */
 	error = xfs_trans_commit(tp);
 	if (error) {
-		xfs_defer_ops_release(mp, dfc);
+		xfs_defer_ops_capture_free(mp, dfc);
 		return error;
 	}
 
@@ -747,17 +766,19 @@ void
 xfs_defer_ops_continue(
 	struct xfs_defer_capture	*dfc,
 	struct xfs_trans		*tp,
-	struct xfs_inode		**captured_ipp)
+	struct xfs_defer_resources	*dres)
 {
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
 	/* Lock and join the captured inode to the new transaction. */
-	if (dfc->dfc_capture_ip) {
-		xfs_ilock(dfc->dfc_capture_ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, dfc->dfc_capture_ip, 0);
-	}
-	*captured_ipp = dfc->dfc_capture_ip;
+	if (dfc->dfc_held.dr_inos == 2)
+		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
+				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
+	else if (dfc->dfc_held.dr_inos == 1)
+		xfs_ilock(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL);
+	xfs_defer_restore_resources(tp, &dfc->dfc_held);
+	memcpy(dres, &dfc->dfc_held, sizeof(struct xfs_defer_resources));
 
 	/* Move captured dfops chain and state to the transaction. */
 	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
@@ -765,3 +786,26 @@ xfs_defer_ops_continue(
 
 	kmem_free(dfc);
 }
+
+/* Release the resources captured and continued during recovery. */
+void
+xfs_defer_resources_rele(
+	struct xfs_defer_resources	*dres)
+{
+	unsigned short			i;
+
+	for (i = 0; i < dres->dr_inos; i++) {
+		xfs_iunlock(dres->dr_ip[i], XFS_ILOCK_EXCL);
+		xfs_irele(dres->dr_ip[i]);
+		dres->dr_ip[i] = NULL;
+	}
+
+	for (i = 0; i < dres->dr_bufs; i++) {
+		xfs_buf_relse(dres->dr_bp[i]);
+		dres->dr_bp[i] = NULL;
+	}
+
+	dres->dr_inos = 0;
+	dres->dr_bufs = 0;
+	dres->dr_ordered = 0;
+}
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index e095abb96f1a..7952695c7c41 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -107,11 +107,7 @@ struct xfs_defer_capture {
 	/* Log reservation saved from the transaction. */
 	unsigned int		dfc_logres;
 
-	/*
-	 * An inode reference that must be maintained to complete the deferred
-	 * work.
-	 */
-	struct xfs_inode	*dfc_capture_ip;
+	struct xfs_defer_resources dfc_held;
 };
 
 /*
@@ -119,9 +115,11 @@ struct xfs_defer_capture {
  * This doesn't normally happen except log recovery.
  */
 int xfs_defer_ops_capture_and_commit(struct xfs_trans *tp,
-		struct xfs_inode *capture_ip, struct list_head *capture_list);
+		struct list_head *capture_list);
 void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp,
-		struct xfs_inode **captured_ipp);
-void xfs_defer_ops_release(struct xfs_mount *mp, struct xfs_defer_capture *d);
+		struct xfs_defer_resources *dres);
+void xfs_defer_ops_capture_free(struct xfs_mount *mp,
+		struct xfs_defer_capture *d);
+void xfs_defer_resources_rele(struct xfs_defer_resources *dres);
 
 #endif /* __XFS_DEFER_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 03159970133f..e66c85a75104 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -532,7 +532,7 @@ xfs_bui_item_recover(
 	 * Commit transaction, which frees the transaction and saves the inode
 	 * for later replay activities.
 	 */
-	error = xfs_defer_ops_capture_and_commit(tp, ip, capture_list);
+	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
 	if (error)
 		goto err_unlock;
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 3f8a0713573a..8f12931b0cbb 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -637,7 +637,7 @@ xfs_efi_item_recover(
 
 	}
 
-	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
+	return xfs_defer_ops_capture_and_commit(tp, capture_list);
 
 abort_error:
 	xfs_trans_cancel(tp);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 10562ecbd9ea..53366cc0bc9e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2466,11 +2466,11 @@ xlog_finish_defer_ops(
 {
 	struct xfs_defer_capture *dfc, *next;
 	struct xfs_trans	*tp;
-	struct xfs_inode	*ip;
 	int			error = 0;
 
 	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
 		struct xfs_trans_res	resv;
+		struct xfs_defer_resources dres;
 
 		/*
 		 * Create a new transaction reservation from the captured
@@ -2494,13 +2494,9 @@ xlog_finish_defer_ops(
 		 * from recovering a single intent item.
 		 */
 		list_del_init(&dfc->dfc_list);
-		xfs_defer_ops_continue(dfc, tp, &ip);
-
+		xfs_defer_ops_continue(dfc, tp, &dres);
 		error = xfs_trans_commit(tp);
-		if (ip) {
-			xfs_iunlock(ip, XFS_ILOCK_EXCL);
-			xfs_irele(ip);
-		}
+		xfs_defer_resources_rele(&dres);
 		if (error)
 			return error;
 	}
@@ -2520,7 +2516,7 @@ xlog_abort_defer_ops(
 
 	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
 		list_del_init(&dfc->dfc_list);
-		xfs_defer_ops_release(mp, dfc);
+		xfs_defer_ops_capture_free(mp, dfc);
 	}
 }
 /*
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 46904b793bd4..61bbbe816b5e 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -557,7 +557,7 @@ xfs_cui_item_recover(
 	}
 
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
-	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
+	return xfs_defer_ops_capture_and_commit(tp, capture_list);
 
 abort_error:
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 5f0695980467..181cd24d2ba9 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -587,7 +587,7 @@ xfs_rui_item_recover(
 	}
 
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
-	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
+	return xfs_defer_ops_capture_and_commit(tp, capture_list);
 
 abort_error:
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);

