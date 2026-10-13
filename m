Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735DB3BCD2B
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871362; cv=none; b=COkWzvocxY2ebnFThNwsjLb49J1w9bIADqdFeSp1NCvTlOJ8PvItppf3PEccvtXh00/RbFWZkuiYAc4kjHfFKhGzuEQisWl4NxVKEw6Jh+jlHqNGD+Y7VhM+T7Sqg850Wygq6p1sw4wiZP4MlfBJLnpwG1urYAD+Gh36vvvQTU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871362; c=relaxed/simple;
	bh=o+M50sKMIe/bxTJxcNrBAYYpmIBp4sPX0uf689dDDmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjRKXgz5qMSojfBw1mWvwfwmgzjQRT5i/3fsBCZh5+RoC4ZpCi1HifRNCyswFPJYZogbUfVUCAWCOspz/zNYPp04Mili2QnW2oQaGja2JP4XT4kAr3BICnaC3E5brtvJ7TRONZWhGusK9B1Vcl+5NAOds0wYHjsI8/SfT9yrUaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ngTYYQGT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ngTYYQGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3391F000FF;
	Tue, 13 Oct 2026 06:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871361;
	bh=BBCPGPxXESJxWvB1nDl7pCGzgPHxnBMapj2XFrR6dys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ngTYYQGTBYZQd/TxE+tYWB0m6F8mfQUbMiEihLCMDRQDSVIo60GATJWKP64zRzMv0
	 siOs8fEu7KiSVKqD+4USdN8Kn/7NY9eWSd7SgSkumNU51bDkMcW45igFsB+xGsnta/
	 G7x5qul+NWfb7JbMcyZ7fYSxMjjj1LzlSx0Vtj97YFPrbfsWnKNPVNOC+GYedHMz6V
	 3Jyh+yy34D7felM7dvhBn3mqNa5bCRXHUOFtaIqB+1/XGB1qsPJlc9fBkyuANiRXug
	 TyDCerKGC1Z9CuzF1cr9FX8GKAWvfaZ8ExlXXrhWtzrIq2jLV4ZHsEX9utMTblntTY
	 fxkCuezIEY+DQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 26/48] xfs: validate bmap update intents during recovery
Date: Tue, 13 Oct 2026 17:01:16 +1100
Message-ID: <20261013060204.3138690-27-dgc@kernel.org>
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

