Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF85480345
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871358; cv=none; b=WmWUXAs37kBtbyUNrvSSStTULGuUR4nj8KLo2178YaxITORnq2/Gd2BYTEjUIjEN3hKkyyoSjJKnrxSJiaQ4RxQPuX58DTMAteTN390e0FPCMminHL0vzVoX4pW4XTDuAdYg07ndXFXrJ7TPw0Gusnx2/kTwSKx8Ka1jBbrMEE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871358; c=relaxed/simple;
	bh=EUeuVFsTcewBRkU5Tcq0/AbLwfP3FvRFmHoptFXkFwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqPH0c77QLO7j9V2xsqSLvBRlfCJePX7VXH6lzyO46+7J6KIy1f8kUxea8HL+YJf7WWcJFAjLz/lplvPUdZt/XNAdIYdmebu03WWsWg0hL5Gk37GGT6tN34fTnl/ZDFnbvkrld8/4pzkOHRWHhTTzZSF4rXCxVmSCnyvzNF1IlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lxai3Wyd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lxai3Wyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B441F000FF;
	Tue, 13 Oct 2026 06:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871356;
	bh=4mAq5OZN11mZUR6qHfTd9EaGN+BAnyyyJ3xohLee2qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lxai3WydJaaSQpqFhpE4EJsCqzs5rxm4XrSsY1OK0+4FKl9APzMa/6XxS4/D1wHi4
	 WOgcv6OFJ2TQuTsinw1Y16XWbOVPPHAsfhLB/Mzx/S8bPB1bSJsgqKMTPV5VS55a30
	 Oeuvs9aaMXY0pdOeusUXWyA/4jHqL3zWhoM1fMpQRAv6iTzaIjWBW/ptqj9blIdCI6
	 ld/WuqFzsnF8bED/gd57/QNVgvQPJ3BN9GQPx2KMwY5/8PjBwLCFlh+u2f4poQa7Hi
	 aYzurUxtxITJV6yiCVZ25UIQgRcwpo7dH4oZ4Ilq+0fkYNH8TkOuLIbef+hvgvvb2o
	 RQ8LKykLGV97g==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 22/48] xfs: validate rmap update intents during recovery
Date: Tue, 13 Oct 2026 17:01:12 +1100
Message-ID: <20261013060204.3138690-23-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013060204.3138690-1-dgc@kernel.org>
References: <20261013060204.3138690-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An rmap update intent is a single region item whose length depends on its
extent count, and whose extents carry rmap owner, offset and state that
recovery must trust. These were only checked during intent replay, after the
item had been decoded and queued.

Validate the region length as it is decoded, and validate the rmap extents in
->validate_item(). The rmap map extent has fixed width fields, so there is a
single on-disk format and no conversion is required. The commit handlers and
intent replay can then trust the item, so the redundant checks are removed from
them. This is shared by the data and realtime rmap update items.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_rmap_item.c | 119 ++++++++++++++++++++++++++---------------
 1 file changed, 77 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index be2d5d6fe863..def068cef09d 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -578,23 +578,10 @@ xfs_rmap_recover_work(
 	int				i;
 	int				error = 0;
 
-	/*
-	 * First check the validity of the extents described by the
-	 * RUI.  If any are bad, then assume that all are bad and
-	 * just toss the RUI.
-	 */
-	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
-		if (!xfs_rui_validate_map(mp, isrt,
-					&ruip->rui_format.rui_extents[i])) {
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					&ruip->rui_format,
-					sizeof(ruip->rui_format));
-			return -EFSCORRUPTED;
-		}
-
+	/* The extents were validated when the rui was recovered. */
+	for (i = 0; i < ruip->rui_format.rui_nextents; i++)
 		xfs_rui_recover_work(mp, dfp, isrt,
 				&ruip->rui_format.rui_extents[i]);
-	}
 
 	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);
 	if (isrt)
@@ -746,34 +733,92 @@ xlog_recover_rui_commit_pass2(
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_rui_log_item		*ruip;
 	struct xfs_rui_log_format	*rui_formatp;
-	size_t				len;
 
 	rui_formatp = item->ri_buf[0].iov_base;
 
-	if (item->ri_buf[0].iov_len < xfs_rui_log_format_sizeof(0)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+	ruip = xfs_rui_init(mp, ITEM_TYPE(item), rui_formatp->rui_nextents);
+	xfs_rui_copy_format(&ruip->rui_format, rui_formatp);
+	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
+
+	xlog_recover_intent_item(log, &ruip->rui_item, lsn,
+			&xfs_rmap_update_defer_type);
+	return 0;
+}
+
+/*
+ * The rui is a single region whose length must match its extent count. The
+ * rmap map extent has fixed width fields, so there is a single on-disk format.
+ * This is shared by the data and realtime rui items, which have identical
+ * formats.
+ */
+static int
+xlog_recover_rui_validate_region(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	int				region_index)
+{
+	struct xfs_rui_log_format	*rui_formatp =
+		item->ri_buf[region_index].iov_base;
+	size_t				len = item->ri_buf[region_index].iov_len;
+	uint32_t			nextents;
+
+	if (len < xfs_rui_log_format_sizeof(0)) {
+		xfs_warn(log->l_mp, "RUI: bad item region length %zu recovered.",
+				len);
 		return -EFSCORRUPTED;
 	}
 
-	len = xfs_rui_log_format_sizeof(rui_formatp->rui_nextents);
-	if (item->ri_buf[0].iov_len != len) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+	/*
+	 * Bound the extent count before the exact size check below so a corrupt
+	 * count cannot overflow the size calculation. This limit is a fuzzy
+	 * upper bound to prevent overflow; the size check that follows enforces
+	 * the precise length.
+	 */
+	nextents = rui_formatp->rui_nextents;
+	if (nextents == 0 ||
+	    nextents > XLOG_MAX_REGION_SIZE / sizeof(struct xfs_map_extent)) {
+		xfs_warn(log->l_mp, "RUI: bad extent count %u recovered.",
+				nextents);
 		return -EFSCORRUPTED;
 	}
 
-	ruip = xfs_rui_init(mp, ITEM_TYPE(item), rui_formatp->rui_nextents);
-	xfs_rui_copy_format(&ruip->rui_format, rui_formatp);
-	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
+	if (len != xfs_rui_log_format_sizeof(nextents)) {
+		xfs_warn(log->l_mp,
+			"RUI: item region length %zu does not match %u extents recovered.",
+			len, nextents);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
+/* Validate the rmap update extents in the rui. */
+static int
+xlog_recover_rui_validate_item(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_rui_log_format	*rui_formatp = item->ri_buf[0].iov_base;
+	bool				isrt = ITEM_TYPE(item) == XFS_LI_RUI_RT;
+	uint32_t			i;
+
+	for (i = 0; i < rui_formatp->rui_nextents; i++) {
+		if (!xfs_rui_validate_map(log->l_mp, isrt,
+					&rui_formatp->rui_extents[i])) {
+			xfs_warn(log->l_mp, "RUI: bad extent %u recovered.", i);
+			return -EFSCORRUPTED;
+		}
+	}
 
-	xlog_recover_intent_item(log, &ruip->rui_item, lsn,
-			&xfs_rmap_update_defer_type);
 	return 0;
 }
 
 const struct xlog_recover_item_ops xlog_rui_item_ops = {
 	.item_type		= XFS_LI_RUI,
+	.min_hdr_len		= sizeof(struct xfs_rui_log_format),
+	.validate_nregions	= xlog_recover_single_region,
+	.validate_region	= xlog_recover_rui_validate_region,
+	.validate_item		= xlog_recover_rui_validate_item,
 	.commit_pass2		= xlog_recover_rui_commit_pass2,
 };
 
@@ -788,23 +833,9 @@ xlog_recover_rtrui_commit_pass2(
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_rui_log_item		*ruip;
 	struct xfs_rui_log_format	*rui_formatp;
-	size_t				len;
 
 	rui_formatp = item->ri_buf[0].iov_base;
 
-	if (item->ri_buf[0].iov_len < xfs_rui_log_format_sizeof(0)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
-		return -EFSCORRUPTED;
-	}
-
-	len = xfs_rui_log_format_sizeof(rui_formatp->rui_nextents);
-	if (item->ri_buf[0].iov_len != len) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
-		return -EFSCORRUPTED;
-	}
-
 	ruip = xfs_rui_init(mp, ITEM_TYPE(item), rui_formatp->rui_nextents);
 	xfs_rui_copy_format(&ruip->rui_format, rui_formatp);
 	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
@@ -829,6 +860,10 @@ xlog_recover_rtrui_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_rtrui_item_ops = {
 	.item_type		= XFS_LI_RUI_RT,
+	.min_hdr_len		= sizeof(struct xfs_rui_log_format),
+	.validate_nregions	= xlog_recover_single_region,
+	.validate_region	= xlog_recover_rui_validate_region,
+	.validate_item		= xlog_recover_rui_validate_item,
 	.commit_pass2		= xlog_recover_rtrui_commit_pass2,
 };
 
-- 
2.55.0

