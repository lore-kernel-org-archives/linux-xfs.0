Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A034B652
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295064; cv=none; b=KawbDLXiOS3SoMV+bCnnvmuAv3XyY8R5RWH470TCxw4QjDXkvNiiwzQdsUePHrrgnSfIo9vFdhqrrvnrydluCZg7TKwm+oPZZOTmSoqdIdDAANPkzwEtHZiEWv1AstdW4FziS1oOFIFmQ+TjyFPP7s5ZZ15FjKu5SQok+mTlS9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295064; c=relaxed/simple;
	bh=ExvKZGrXxXA8E8ls91Mu31tKkoWSf0UyWmVkgxdnyTc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hvwo9TxX/c85uu7D5t801jqiiwz3bvWt3Ok4DACJ2edoTYp6oYDnLgMvaQ83i8pombQKR6PKnlpxNC5QgKYUaKFp3Z/lRpNxTUU7QcjsHJ/ZMOcUyY5H9LEHuAHGyWNJD9f9ktqc/oAf/OoWQvlqiSUPiTkYSZjQmdbvWhaXnGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k0EEWGMp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k0EEWGMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5887FC433C7;
	Wed, 13 Mar 2024 01:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295064;
	bh=ExvKZGrXxXA8E8ls91Mu31tKkoWSf0UyWmVkgxdnyTc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=k0EEWGMpWRDG4EKqb8w5yn5CWIKLXPD9uGU3E/btvcUUZ8aT5xWVVIqfiU7E7M806
	 XagsCamU7MnC6t8Rt6p3+4VkW928hiCUVlDzrxL/chc3TEDt48uFNdQwnOA7JCIY/x
	 XshxLSe5DKfWY5g5stCRL3Gus51JYjd/umGCVKFumKRgZTKiGoxaNU4oRcBwT4vukN
	 8YM19oZzORzbV1bmnJKA7mLpOOWo0w27eJMnyV8SHuCPHOQrDInUyAAeo2PKPMjeK4
	 gIbiC98UUq2bXMgdqN8VpkzxC8BEIGHl2YUJsPupHiq0/MtRKPgZf60gpcqjnjbwUa
	 sRtSU815pnlJw==
Date: Tue, 12 Mar 2024 18:57:43 -0700
Subject: [PATCH 18/67] xfs: automatic freeing of freshly allocated unwritten
 space
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029431454.2061787.4416062787087228019.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
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
---
 libxfs/defer_item.c |   10 +++--
 libxfs/xfs_alloc.c  |  104 +++++++++++++++++++++++++++++++++++++++++++++++++--
 libxfs/xfs_alloc.h  |   12 ++++++
 3 files changed, 119 insertions(+), 7 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 8731d1834be1..b8afda0ceb58 100644
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
+				xefi->xefi_blockcount, &oinfo,
+				XFS_AG_RESV_NONE);
+	}
 
 	/*
 	 * Don't free the XEFI if we need a new transaction to complete
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 0a2404466f69..463381be7863 100644
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
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 6b95d1d8a853..851cafbd6449 100644
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
 

