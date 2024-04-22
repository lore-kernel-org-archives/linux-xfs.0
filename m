Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C20E153BC0
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713803975; cv=none; b=TqVywN6hZ30ITe7Ta6s2Q5YJKXmdpm28+C+6t3c8LdgzqOmHs1GQKeQCmKBSDpYcnLSKr6x7oXDmlVsOJ6vPji8qPcZGY23GgW/BZ/vuCtzqyfzqXMUJG651dF4UD/5eAa5NPUBuPA8R1+rfly/boKvA1GGNYGb5ozS9xFi3sVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713803975; c=relaxed/simple;
	bh=TCDWdU2kk64+/UO/U7tkxE2s2HydYSPZQdY+3tpk0Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDggO9JH5Iv6bEzqlY9X7SsmG/DTY2RiQuy8iSQru97V30lVjmalO8qeQwDmbve9/pP8/eolrYGLEXNdqBKscpUabGijGP11YEpfokXSho+qrowsBUi9Fxjp7ic55lhcjjPoCdiUKb6cPUa8gzeqQ9v9Ao1DLLL0w044Xvhpvvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TDbCK1Bk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TDbCK1Bk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1A5C32781;
	Mon, 22 Apr 2024 16:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713803975;
	bh=TCDWdU2kk64+/UO/U7tkxE2s2HydYSPZQdY+3tpk0Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TDbCK1BkT7oMopfe344NIRBzTLVUpgrvK3ltDKYUZp+WOu8+u7AKeK1y4T1pPG9jc
	 8XAIVpF71MUxDN6lQ5fh0V0od8b39Cn4BUqC52L+bZUoSP0RnXv6dwI1k7cm+IkgMZ
	 x06W0SZhVC9wj0RTNVbdHimasJ7WjeNO6pVRxSN11IyFt/dQQOJgKi9TzA9dnLeDU/
	 M1IiJLXhqRmebfptVgwsUcklQOinTG7PUspIIVsjwYqUKS+Z+RzGTffrLGiMUA7wt/
	 RiSDVg8G2qc4HLxBWX0IWhUMQUjYObOuYqkl2IupKDWu7RAo3zq4zhmjsSIaglCNdT
	 3YRgffmf/Beaw==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 18/67] xfs: automatic freeing of freshly allocated unwritten space
Date: Mon, 22 Apr 2024 18:25:40 +0200
Message-ID: <20240422163832.858420-20-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: e3042be36c343207b7af249a09f50b4e37e9fda4

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

For full extents that aren't used, xfs_alloc_commit_autoreap will
unpause the EFI, which results in the space being freed during the next
_defer_finish cycle.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/defer_item.c |  10 +++--
 libxfs/xfs_alloc.c  | 104 ++++++++++++++++++++++++++++++++++++++++++--
 libxfs/xfs_alloc.h  |  12 +++++
 3 files changed, 119 insertions(+), 7 deletions(-)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 8731d1834..c4a16c7ce 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -101,7 +101,7 @@ xfs_extent_free_finish_item(
 	struct xfs_owner_info		oinfo = { };
 	struct xfs_extent_free_item	*xefi;
 	xfs_agblock_t			agbno;
-	int				error;
+	int				error = 0;
 
 	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
 
@@ -112,8 +112,12 @@ xfs_extent_free_finish_item(
 		oinfo.oi_flags |= XFS_OWNER_INFO_BMBT_BLOCK;
 
 	agbno = XFS_FSB_TO_AGBNO(tp->t_mountp, xefi->xefi_startblock);
-	error = xfs_free_extent(tp, xefi->xefi_pag, agbno,
-			xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE);
+
+	if (!(xefi->xefi_flags & XFS_EFI_CANCELLED)) {
+		error = xfs_free_extent(tp, xefi->xefi_pag, agbno,
+			xefi->xefi_blockcount, &oinfo,
+			XFS_AG_RESV_NONE);
+	}
 
 	/*
 	 * Don't free the XEFI if we need a new transaction to complete
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 0a2404466..463381be7 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2518,14 +2518,15 @@ xfs_defer_agfl_block(
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
@@ -2573,10 +2574,105 @@ xfs_free_extent_later(
 			XFS_FSB_TO_AGBNO(tp->t_mountp, bno), len);
 
 	xfs_extent_free_get_group(mp, xefi);
-	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_FREE, &xefi->xefi_list);
+	*dfpp = xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_FREE, &xefi->xefi_list);
+	return 0;
+}
+
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
 	return 0;
 }
 
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
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 6b95d1d8a..851cafbd6 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
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
 
-- 
2.44.0

