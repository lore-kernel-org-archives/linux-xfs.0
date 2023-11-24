Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717C42C86B
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IIKjw5+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC58C433C7;
	Fri, 24 Nov 2023 23:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700869677;
	bh=ssWx+9c9CBzQYpj41inq3TNdsdKs1bgf8pdZaw7t1Us=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IIKjw5+72kpjH0OrCAL20yubu5fUjdHjMcF8NppBnMMkW/qflipXQjejWzfFPGFaD
	 wdwrce4J+xD2BkIN8I1Wu67jtAyRid42dkYw+FvTOlwWmVtBK8AMichoeotaXCaecz
	 yLXa5kcjA8Cdp7nlRP3F/EuHGAdwU6lw3NAafz6PrFdRQNrmFBQrIjYYtXRFtaN77I
	 tcrVuRuG7fcwVRf5JUHJrQBiIyyTAq4Cl4OhoDlMB2gDhlxCk+G8vvo82TRQU4r50I
	 xhhYTwVqoc+xUw5X8MI+n3cqQg/lZco0s9xdeuI4ePjJH2k2oYPGrepIXrMpBDQyLF
	 qQkgH9ZdS7etw==
Date: Fri, 24 Nov 2023 15:47:56 -0800
Subject: [PATCH 4/7] xfs: automatic freeing of freshly allocated unwritten
 space
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170086926192.2768790.6648304136876480355.stgit@frogsfrogsfrogs>
In-Reply-To: <170086926113.2768790.10021834422326302654.stgit@frogsfrogsfrogs>
References: <170086926113.2768790.10021834422326302654.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
 fs/xfs/xfs_extfree_item.c |   10 +++-
 3 files changed, 118 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index c35224ad9428a..4940f9377f21a 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2522,14 +2522,15 @@ xfs_defer_agfl_block(
  * Add the extent to the list of extents to be free at transaction end.
  * The list is maintained sorted (by block number).
  */
-int
-xfs_free_extent_later(
+static int
+xfs_defer_extent_free(
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
@@ -2577,10 +2578,105 @@ xfs_free_extent_later(
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
+	return xfs_defer_extent_free(tp, bno, len, oinfo, type, skip_discard,
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
+	error = xfs_defer_extent_free(args->tp, args->fsbno, args->len,
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
+		xefi->xefi_flags |= XFS_EFI_CANCELLED;
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
index 6b95d1d8a8537..851cafbd64494 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -255,6 +255,18 @@ void xfs_extent_free_get_group(struct xfs_mount *mp,
 #define XFS_EFI_SKIP_DISCARD	(1U << 0) /* don't issue discard */
 #define XFS_EFI_ATTR_FORK	(1U << 1) /* freeing attr fork block */
 #define XFS_EFI_BMBT_BLOCK	(1U << 2) /* freeing bmap btree block */
+#define XFS_EFI_CANCELLED	(1U << 3) /* dont actually free the space */
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
index 9e7b58f3566c0..4af5b3b338b19 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -381,7 +381,7 @@ xfs_trans_free_extent(
 	uint				next_extent;
 	xfs_agblock_t			agbno = XFS_FSB_TO_AGBNO(mp,
 							xefi->xefi_startblock);
-	int				error;
+	int				error = 0;
 
 	oinfo.oi_owner = xefi->xefi_owner;
 	if (xefi->xefi_flags & XFS_EFI_ATTR_FORK)
@@ -392,9 +392,11 @@ xfs_trans_free_extent(
 	trace_xfs_bmap_free_deferred(tp->t_mountp, xefi->xefi_pag->pag_agno, 0,
 			agbno, xefi->xefi_blockcount);
 
-	error = __xfs_free_extent(tp, xefi->xefi_pag, agbno,
-			xefi->xefi_blockcount, &oinfo, xefi->xefi_agresv,
-			xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
+	if (!(xefi->xefi_flags & XFS_EFI_CANCELLED))
+		error = __xfs_free_extent(tp, xefi->xefi_pag, agbno,
+				xefi->xefi_blockcount, &oinfo,
+				xefi->xefi_agresv,
+				xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
 
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the

