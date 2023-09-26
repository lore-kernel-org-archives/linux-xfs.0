Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FD56E7F14C
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 00:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjI0APE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 20:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbjI0ANC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 20:13:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB973A5CB
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:32:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8020BC433C7;
        Tue, 26 Sep 2023 23:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695771130;
        bh=zQc41z6cGFYy7VjekKVwFr4tiTd9jTJLnc+K2zh1cVI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=rCFuCZgifjExg7EOEO+d6eZv0BFkBwlMFH3O6H9PhO6YXyUpek39musrLVCyHjqyS
         3ZxNMdRUdWeL7C1RAOZ2a4oRjeqDnpJL69GytZpuDvNKUiy3INvwNNCyv0pOsjau2p
         JmdR2G2/t05LHZAddhnv/MmI4xp052MEFPXvvOSoJHiE075KXkRWSiZCEdgYjCMeTp
         xlQ5Eht5cX7Hk7jX4+e2wSJiLX/XsJk2/Wip5H046VYu8dVGIZoN9XHaYzZB6PQgSV
         d7XUYcWxcs5KzAJXfzscAXxUDvjMxOnDDF+bQtMv7mB25Z2grnpHcx5FSyg0vyelyH
         nb6bY2yqqNgSQ==
Date:   Tue, 26 Sep 2023 16:32:09 -0700
Subject: [PATCH 4/7] xfs: automatic freeing of freshly allocated unwritten
 space
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577059209.3312911.11197509089553101214.stgit@frogsfrogsfrogs>
In-Reply-To: <169577059140.3312911.17578000557997208473.stgit@frogsfrogsfrogs>
References: <169577059140.3312911.17578000557997208473.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

As mentioned in the previous commit, online repair wants to allocate
space to write out a new metadata structure, and it also wants to hedge
against system crashes during repairs by logging (and later cancelling)
EFIs to free the space if we crash before committing the new data
structure.

Therefore, create a trio of functions to schedule automatic reaping of
freshly allocated unwritten space.  xfs_alloc_schedule_autoreap creates
a paused EFI representing the space we just allocated.  Once the
allocations are made and the autoreaps scheduled, we can start writing
to disk.

If the writes succeed, xfs_alloc_cancel_autoreap marks the EFI work
items as stale and unpauses the pending deferred work item.  Assuming
that's done in the same transaction that commits the new structure into
the filesystem, we guarantee that either the new object is fully
visible, or that all the space gets reclaimed.

If the writes succeed but only part of an extent was used, repair must
call the same _cancel_autoreap function to kill the first EFI and then
log a new EFI to free the unused space.  The first EFI is already
committed, so it cannot be changed.

For full extents that aren't used, xfs_alloc_commit_autoreap will
unpause the EFI, which results in the space being freed during the next
_defer_finish cycle.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c |  104 +++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_alloc.h |   12 +++++
 fs/xfs/xfs_extfree_item.c |   11 +++--
 3 files changed, 120 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 295d11a27f632..c1ee1862cc1af 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2501,14 +2501,15 @@ xfs_defer_agfl_block(
  * Add the extent to the list of extents to be free at transaction end.
  * The list is maintained sorted (by block number).
  */
-int
-xfs_free_extent_later(
+static int
+__xfs_free_extent_later(
 	struct xfs_trans		*tp,
 	xfs_fsblock_t			bno,
 	xfs_filblks_t			len,
 	const struct xfs_owner_info	*oinfo,
 	enum xfs_ag_resv_type		type,
-	bool				skip_discard)
+	bool				skip_discard,
+	struct xfs_defer_pending	**dfpp)
 {
 	struct xfs_extent_free_item	*xefi;
 	struct xfs_mount		*mp = tp->t_mountp;
@@ -2556,10 +2557,105 @@ xfs_free_extent_later(
 			XFS_FSB_TO_AGBNO(tp->t_mountp, bno), len);
 
 	xfs_extent_free_get_group(mp, xefi);
-	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_FREE, &xefi->xefi_list);
+	*dfpp = xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_FREE, &xefi->xefi_list);
 	return 0;
 }
 
+int
+xfs_free_extent_later(
+	struct xfs_trans		*tp,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
+	const struct xfs_owner_info	*oinfo,
+	enum xfs_ag_resv_type		type,
+	bool				skip_discard)
+{
+	struct xfs_defer_pending	*dontcare = NULL;
+
+	return __xfs_free_extent_later(tp, bno, len, oinfo, type, skip_discard,
+			&dontcare);
+}
+
+/*
+ * Set up automatic freeing of unwritten space in the filesystem.
+ *
+ * This function attached a paused deferred extent free item to the
+ * transaction.  Pausing means that the EFI will be logged in the next
+ * transaction commit, but the pending EFI will not be finished until the
+ * pending item is unpaused.
+ *
+ * If the system goes down after the EFI has been persisted to the log but
+ * before the pending item is unpaused, log recovery will find the EFI, fail to
+ * find the EFD, and free the space.
+ *
+ * If the pending item is unpaused, the next transaction commit will log an EFD
+ * without freeing the space.
+ *
+ * Caller must ensure that the tp, fsbno, len, oinfo, and resv flags of the
+ * @args structure are set to the relevant values.
+ */
+int
+xfs_alloc_schedule_autoreap(
+	const struct xfs_alloc_arg	*args,
+	bool				skip_discard,
+	struct xfs_alloc_autoreap	*aarp)
+{
+	int				error;
+
+	error = __xfs_free_extent_later(args->tp, args->fsbno, args->len,
+			&args->oinfo, args->resv, skip_discard, &aarp->dfp);
+	if (error)
+		return error;
+
+	xfs_defer_item_pause(args->tp, aarp->dfp);
+	return 0;
+}
+
+/*
+ * Cancel automatic freeing of unwritten space in the filesystem.
+ *
+ * Earlier, we created a paused deferred extent free item and attached it to
+ * this transaction so that we could automatically roll back a new space
+ * allocation if the system went down.  Now we want to cancel the paused work
+ * item by marking the EFI stale so we don't actually free the space, unpausing
+ * the pending item and logging an EFD.
+ *
+ * The caller generally should have already mapped the space into the ondisk
+ * filesystem.  If the reserved space was partially used, the caller must call
+ * xfs_free_extent_later to create a new EFI to free the unused space.
+ */
+void
+xfs_alloc_cancel_autoreap(
+	struct xfs_trans		*tp,
+	struct xfs_alloc_autoreap	*aarp)
+{
+	struct xfs_defer_pending	*dfp = aarp->dfp;
+	struct xfs_extent_free_item	*xefi;
+
+	if (!dfp)
+		return;
+
+	list_for_each_entry(xefi, &dfp->dfp_work, xefi_list)
+		xefi->xefi_flags |= XFS_EFI_STALE;
+
+	xfs_defer_item_unpause(tp, dfp);
+}
+
+/*
+ * Commit automatic freeing of unwritten space in the filesystem.
+ *
+ * This unpauses an earlier _schedule_autoreap and commits to freeing the
+ * allocated space.  Call this if none of the reserved space was used.
+ */
+void
+xfs_alloc_commit_autoreap(
+	struct xfs_trans		*tp,
+	struct xfs_alloc_autoreap	*aarp)
+{
+	if (aarp->dfp)
+		xfs_defer_item_unpause(tp, aarp->dfp);
+}
+
 #ifdef DEBUG
 /*
  * Check if an AGF has a free extent record whose length is equal to
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 6b95d1d8a8537..60d04dc13cc76 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -255,6 +255,18 @@ void xfs_extent_free_get_group(struct xfs_mount *mp,
 #define XFS_EFI_SKIP_DISCARD	(1U << 0) /* don't issue discard */
 #define XFS_EFI_ATTR_FORK	(1U << 1) /* freeing attr fork block */
 #define XFS_EFI_BMBT_BLOCK	(1U << 2) /* freeing bmap btree block */
+#define XFS_EFI_STALE		(1U << 3) /* dont actually free the space */
+
+struct xfs_alloc_autoreap {
+	struct xfs_defer_pending	*dfp;
+};
+
+int xfs_alloc_schedule_autoreap(const struct xfs_alloc_arg *args,
+		bool skip_discard, struct xfs_alloc_autoreap *aarp);
+void xfs_alloc_cancel_autoreap(struct xfs_trans *tp,
+		struct xfs_alloc_autoreap *aarp);
+void xfs_alloc_commit_autoreap(struct xfs_trans *tp,
+		struct xfs_alloc_autoreap *aarp);
 
 extern struct kmem_cache	*xfs_extfree_item_cache;
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 9e7b58f3566c0..98c2667d369e8 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -392,9 +392,14 @@ xfs_trans_free_extent(
 	trace_xfs_bmap_free_deferred(tp->t_mountp, xefi->xefi_pag->pag_agno, 0,
 			agbno, xefi->xefi_blockcount);
 
-	error = __xfs_free_extent(tp, xefi->xefi_pag, agbno,
-			xefi->xefi_blockcount, &oinfo, xefi->xefi_agresv,
-			xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
+	if (xefi->xefi_flags & XFS_EFI_STALE) {
+		error = 0;
+	} else {
+		error = __xfs_free_extent(tp, xefi->xefi_pag, agbno,
+				xefi->xefi_blockcount, &oinfo,
+				xefi->xefi_agresv,
+				xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
+	}
 
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the

