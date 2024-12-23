Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1152F1AE01E
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992032; cv=none; b=iUG8XsRg6ITl58A1jT62SWxr4c8OHXkDnY4KmeCc3MFHGo99AmRO5NHz9cuyjfI6XTBHy7w5IOWqM9iG+Tyay3XuD/r/110NYMUrsV5f7dGH00fKQjcoZ2SEsQCagTeE8PTybX0KlWdax+hLZGbwv8oN81eHKo17NmKVOY9scEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992032; c=relaxed/simple;
	bh=oprBTl2sogd5RKvCXB0DN0OOIKVmcsI+60Xl49elaFc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nfsKJA7faw2qftXGm2LV7t0jheWJlRvkrjae8ufGJTzwnt4Lr7L66eSb3uSiGN+dSFa0TC+9aoRtUVuje+UUHFCFcg1Ssh0fMIMKwysYj61eckC4nESLvt6oM8ucB/SI7/42l2U7SbrO3ct2YzFOkOPNzNWNcgdyn5ZEDCZOCnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fgfyAI7J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fgfyAI7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C25BC4CED3;
	Mon, 23 Dec 2024 22:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992031;
	bh=oprBTl2sogd5RKvCXB0DN0OOIKVmcsI+60Xl49elaFc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fgfyAI7Jo6aT383L7Ak5w8J3jeWU/tsEALr5D2ASqrf8+BwlweP5BPcz6RL3yT2ye
	 MC3ddXHJ6QT2fi/GWsD4Tt63FI2s8+44vUFpaYJ9+KcDPVEZTUeUkWHn7JxlfrAER6
	 oIazvoVBD8L9audNKvwrguRhY9YTDfj0aasCjQr8FEJLxu0BNdZ/FbtX+TPk7pgpmB
	 XiW/DMqV54tgrEifE1LS+DbcKKYCv/aaeZg5gHBq6ILcoRDqV3yBoyeLTlSP1akkgF
	 xkBIJsdEIfu+FLQpCuVkeHzKk78BzbuvEpP+c7hchGGtJ57UaiGgLx+7SuZHbWPlRk
	 UIu6iR3QgQxxw==
Date: Mon, 23 Dec 2024 14:13:51 -0800
Subject: [PATCH 08/51] libxfs: port userspace deferred log item to handle
 rtgroups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498943926.2297565.11437968883658093474.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make the userspace log items to handle rt groups correctly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/defer_item.c |   73 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 49 insertions(+), 24 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index eee84ffbe625d5..9db0e471cba69c 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -77,6 +77,17 @@ xfs_extent_free_create_done(
 	return NULL;
 }
 
+static inline const struct xfs_defer_op_type *
+xefi_ops(
+	struct xfs_extent_free_item	*xefi)
+{
+	if (xfs_efi_is_realtime(xefi))
+		return &xfs_rtextent_free_defer_type;
+	if (xefi->xefi_agresv == XFS_AG_RESV_AGFL)
+		return &xfs_agfl_free_defer_type;
+	return &xfs_extent_free_defer_type;
+}
+
 /* Add this deferred EFI to the transaction. */
 void
 xfs_extent_free_defer_add(
@@ -86,14 +97,11 @@ xfs_extent_free_defer_add(
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 
+	trace_xfs_extent_free_defer(mp, xefi);
+
 	xefi->xefi_group = xfs_group_intent_get(mp, xefi->xefi_startblock,
-			XG_TYPE_AG);
-	if (xefi->xefi_agresv == XFS_AG_RESV_AGFL)
-		*dfpp = xfs_defer_add(tp, &xefi->xefi_list,
-				&xfs_agfl_free_defer_type);
-	else
-		*dfpp = xfs_defer_add(tp, &xefi->xefi_list,
-				&xfs_extent_free_defer_type);
+			xfs_efi_is_realtime(xefi) ? XG_TYPE_RTG : XG_TYPE_AG);
+	*dfpp = xfs_defer_add(tp, &xefi->xefi_list, xefi_ops(xefi));
 }
 
 /* Cancel a free extent. */
@@ -159,6 +167,32 @@ const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 	.cancel_item	= xfs_extent_free_cancel_item,
 };
 
+STATIC int
+xfs_rtextent_free_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
+	struct list_head		*item,
+	struct xfs_btree_cur		**state)
+{
+	struct xfs_extent_free_item	*xefi = xefi_entry(item);
+	int				error;
+
+	error = xfs_rtfree_blocks(tp, to_rtg(xefi->xefi_group),
+			xefi->xefi_startblock, xefi->xefi_blockcount);
+	if (error != -EAGAIN)
+		xfs_extent_free_cancel_item(item);
+	return error;
+}
+
+const struct xfs_defer_op_type xfs_rtextent_free_defer_type = {
+	.name		= "rtextent_free",
+	.create_intent	= xfs_extent_free_create_intent,
+	.abort_intent	= xfs_extent_free_abort_intent,
+	.create_done	= xfs_extent_free_create_done,
+	.finish_item	= xfs_rtextent_free_finish_item,
+	.cancel_item	= xfs_extent_free_cancel_item,
+};
+
 /*
  * AGFL blocks are accounted differently in the reserve pools and are not
  * inserted into the busy extent list.
@@ -496,14 +530,16 @@ xfs_bmap_update_create_done(
 	return NULL;
 }
 
-/* Take an active ref to the AG containing the space we're mapping. */
+/* Take a passive ref to the group containing the space we're mapping. */
 static inline void
 xfs_bmap_update_get_group(
 	struct xfs_mount	*mp,
 	struct xfs_bmap_intent	*bi)
 {
+	enum xfs_group_type	type = XG_TYPE_AG;
+
 	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
-		return;
+		type = XG_TYPE_RTG;
 
 	/*
 	 * Bump the intent count on behalf of the deferred rmap and refcount
@@ -513,7 +549,7 @@ xfs_bmap_update_get_group(
 	 * remains nonzero across the transaction roll.
 	 */
 	bi->bi_group = xfs_group_intent_get(mp, bi->bi_bmap.br_startblock,
-			XG_TYPE_AG);
+				type);
 }
 
 /* Add this deferred BUI to the transaction. */
@@ -522,8 +558,6 @@ xfs_bmap_defer_add(
 	struct xfs_trans	*tp,
 	struct xfs_bmap_intent	*bi)
 {
-	trace_xfs_bmap_defer(bi);
-
 	xfs_bmap_update_get_group(tp->t_mountp, bi);
 
 	/*
@@ -536,20 +570,11 @@ xfs_bmap_defer_add(
 	 */
 	if (bi->bi_type == XFS_BMAP_MAP)
 		bi->bi_owner->i_delayed_blks += bi->bi_bmap.br_blockcount;
+
+	trace_xfs_bmap_defer(bi);
 	xfs_defer_add(tp, &bi->bi_list, &xfs_bmap_update_defer_type);
 }
 
-/* Release an active AG ref after finishing mapping work. */
-static inline void
-xfs_bmap_update_put_group(
-	struct xfs_bmap_intent	*bi)
-{
-	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
-		return;
-
-	xfs_group_intent_put(bi->bi_group);
-}
-
 /* Cancel a deferred bmap update. */
 STATIC void
 xfs_bmap_update_cancel_item(
@@ -560,7 +585,7 @@ xfs_bmap_update_cancel_item(
 	if (bi->bi_type == XFS_BMAP_MAP)
 		bi->bi_owner->i_delayed_blks -= bi->bi_bmap.br_blockcount;
 
-	xfs_bmap_update_put_group(bi);
+	xfs_group_intent_put(bi->bi_group);
 	kmem_cache_free(xfs_bmap_intent_cache, bi);
 }
 

