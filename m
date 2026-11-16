Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871080;
	b=VtUngpHVtTWhfGnY0Mk1RAqzeqzA9VdwSoEjf7Rw9orRi0/7t7lvx4+QHmk0AIIipMNL
	 bh3yjokeLkfy5rFxB71djddHQCw4pNReTZQKCvXOMOIw4+MRd3/URFZhvCD5RU6ClmTdx
	 KKVTLrArG9VhRSbALF/OCgFvymwczcPiGEExV7nA62OVrXgfqbJpUXL0Az8oHTmzB6Cuu
	 4LMh7n4ftwVJnC8pLbKxnRKMIBRoL0Bo7iM0XmvrGfLwvNMndPSaVXE4WFk9FQQD0VZo3
	 CiSIOxnqsFPENRhdiw/Bce22oRYUqlSsvdcWHe/3oB+d7im/vsbk9eY+mcWP+C4tcbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=BBCPGPxXESJxWvB1nDl7pCGzgPHxnBMapj2XFrR6dys=;
	b=ZNfuR1nRkH/YMP0Vy6oPYXyjqCCc06tnmgUvxRMifjI7eYOOjT+wHqfHf4x2jjKHmDxC
	 uSJ5jm1xnHOp7FP/tRH9z193HZsCwy5IJvlCt1HPdN7sN+N4EHQC+BQTfmuoE0vlsveyL
	 hfFPzDLbWh6ZKMfAb4/fwboAy5aaD4uzl7QBXYZ/NxvR4cYo34c7bH+8Qge/ESprQZun2
	 6ooUbytHwxG26nsrLCXo/LEPIBeTJYiWE8Nrl7fAn/xcWcQgNtWQyAHgkenLRE6Y27uFl
	 srQO/rT6BfolvVphIAValPnu486Tfurl04Oxyru9zfESgpNQgeXkILk60K4LIG3qhUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GrkZ16Bc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB21606A883
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GrkZ16Bc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C131F000C5;
	Mon, 16 Nov 2026 23:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871080;
	bh=BBCPGPxXESJxWvB1nDl7pCGzgPHxnBMapj2XFrR6dys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GrkZ16BcqzykzRnucn84o1oYtoBrLPeWCFM30xoCTWPol9Q9uWIdEPkwb/pXIvSM9
	 pr4/J59rZA4TaDUfYqCB8V7a9n3j0wHRS+uhGDofigS2KarFprmWoExZ+yhOdaIsFg
	 B+FaLSaKnOlFNzrRcdtQnSd98BDG5/LtKdR/Z5qDUisg4Jpe8SkwL/W1l1+300QGGQ
	 LaKJzR18FHJnBZkfVJIKQRHZBCDTTPiiYW828UK67YdEUatFM8ktAfUsOA3rfzCGqR
	 zATyO8fnbYOSsC/mNRmQREsNh0BEBuO4LghLNsQaN4qWx7QGr8UmuiywezMQCA32o5
	 /z9/fQYc7RAyA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 36/59] xfs: validate bmap update intents during recovery
Date: Tue, 17 Nov 2026 10:14:53 +1100
Message-ID: <20261116231707.3625263-37-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116231707.3625263-1-dgc@kernel.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A bmap update intent is a single region item carrying one mapping operation
whose fork, owner and extent recovery must trust. These were only checked
during intent replay, after the item had been decoded and queued.

Validate the region length as it is decoded, and validate the mapping in
->validate_item(). xfs_bui_validate() now takes the format structure so it can
run against the decoded region. The commit handler and intent replay can then
trust the item, so the redundant checks are removed from them.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_bmap_item.c | 77 +++++++++++++++++++++++++++++-------------
 1 file changed, 53 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 62be62342fea..37ada25109c9 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -418,15 +418,15 @@ xfs_bmap_update_abort_intent(
 static inline bool
 xfs_bui_validate(
 	struct xfs_mount		*mp,
-	struct xfs_bui_log_item		*buip)
+	struct xfs_bui_log_format	*bui_formatp)
 {
 	struct xfs_map_extent		*map;
 
 	/* Only one mapping operation per BUI... */
-	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
+	if (bui_formatp->bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
 		return false;
 
-	map = &buip->bui_format.bui_extents[0];
+	map = &bui_formatp->bui_extents[0];
 
 	if (map->me_flags & ~XFS_BMAP_EXTENT_FLAGS)
 		return false;
@@ -505,12 +505,7 @@ xfs_bmap_recover_work(
 	int				iext_delta;
 	int				error = 0;
 
-	if (!xfs_bui_validate(mp, buip)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				&buip->bui_format, sizeof(buip->bui_format));
-		return -EFSCORRUPTED;
-	}
-
+	/* The bui was validated when it was recovered. */
 	map = &buip->bui_format.bui_extents[0];
 	work = xfs_bui_recover_work(mp, dfp, &ip, map);
 	if (IS_ERR(work))
@@ -650,40 +645,74 @@ xlog_recover_bui_commit_pass2(
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_bui_log_item		*buip;
 	struct xfs_bui_log_format	*bui_formatp;
-	size_t				len;
 
 	bui_formatp = item->ri_buf[0].iov_base;
 
-	if (item->ri_buf[0].iov_len < xfs_bui_log_format_sizeof(0)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+	buip = xfs_bui_init(mp);
+	xfs_bui_copy_format(&buip->bui_format, bui_formatp);
+	atomic_set(&buip->bui_next_extent, bui_formatp->bui_nextents);
+
+	xlog_recover_intent_item(log, &buip->bui_item, lsn,
+			&xfs_bmap_update_defer_type);
+	return 0;
+}
+
+/*
+ * The bui is a single region with exactly one mapping operation, so its length
+ * must match a single extent.
+ */
+static int
+xlog_recover_bui_validate_region(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	int				region_index)
+{
+	struct xfs_bui_log_format	*bui_formatp =
+		item->ri_buf[region_index].iov_base;
+	size_t				len = item->ri_buf[region_index].iov_len;
+
+	if (len < xfs_bui_log_format_sizeof(0)) {
+		xfs_warn(log->l_mp, "BUI: bad item region length %zu recovered.",
+				len);
 		return -EFSCORRUPTED;
 	}
 
 	if (bui_formatp->bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+		xfs_warn(log->l_mp, "BUI: bad extent count %u recovered.",
+				bui_formatp->bui_nextents);
 		return -EFSCORRUPTED;
 	}
 
-	len = xfs_bui_log_format_sizeof(bui_formatp->bui_nextents);
-	if (item->ri_buf[0].iov_len != len) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+	if (len != xfs_bui_log_format_sizeof(bui_formatp->bui_nextents)) {
+		xfs_warn(log->l_mp,
+			"BUI: item region length %zu does not match %u extents recovered.",
+			len, bui_formatp->bui_nextents);
 		return -EFSCORRUPTED;
 	}
 
-	buip = xfs_bui_init(mp);
-	xfs_bui_copy_format(&buip->bui_format, bui_formatp);
-	atomic_set(&buip->bui_next_extent, bui_formatp->bui_nextents);
+	return 0;
+}
+
+/* Validate the bmap update mapping in the bui. */
+static int
+xlog_recover_bui_validate_item(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	if (!xfs_bui_validate(log->l_mp, item->ri_buf[0].iov_base)) {
+		xfs_warn(log->l_mp, "BUI: bad mapping recovered.");
+		return -EFSCORRUPTED;
+	}
 
-	xlog_recover_intent_item(log, &buip->bui_item, lsn,
-			&xfs_bmap_update_defer_type);
 	return 0;
 }
 
 const struct xlog_recover_item_ops xlog_bui_item_ops = {
 	.item_type		= XFS_LI_BUI,
+	.min_hdr_len		= sizeof(struct xfs_bui_log_format),
+	.validate_nregions	= xlog_recover_single_region,
+	.validate_region	= xlog_recover_bui_validate_region,
+	.validate_item		= xlog_recover_bui_validate_item,
 	.commit_pass2		= xlog_recover_bui_commit_pass2,
 };
 
-- 
2.55.0

