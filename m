Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6FD3BCD2B
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871358; cv=none; b=X2JIfwTGoDyNMSdbztGbiieWyKDvAKqUbn6hrZtJGJqZf/79YIxQOWc0PJKhfNAfNZiUBH7loMZpWICpUWOpS3TgRkzD4u/pOhMw0UmvPLOS69O6rqc3pvORs1Ab7gpBoJoSQ5tEaslppeIK8AjsZll6E+Y09fRDkC6Nh8H5vWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871358; c=relaxed/simple;
	bh=MB4LwvOKVUOk7YvZgVkLVNBlneyNnlqZWGFQ4WmC+14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d83pLDuhVycmopb4pEpPOLWLTNNP2/+qeYp9EORzKZeJXDDZjTEpsEH7DwEgbuMXSgkZTVBvrGC+3Zrat0Nk6igw7hf8vo+veU0QDBt6F2aWjnUOyS3EgT+fB+t1Mn7o9Rxj5k7e2rjiXo6ilOcVDIYrKw+JuuY9ORTqYI91ccg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nfDy5nxf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nfDy5nxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128B41F00893;
	Tue, 13 Oct 2026 06:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871357;
	bh=d1L4pJ30IAlwtwaljxL56c3u/tUWJ0XWpZappeJh5ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nfDy5nxfanupvnA8lEMXcNQHnKtYCOeaLZi64YyBG8qY/8nUo3M/SAczfEGj/xC5E
	 CHDjExaDR4cJ6CjyZYmgtKFgEZn2Z1JWIROgpWTR1E0J+yf7vQ0knEa4azvHPvE/wR
	 LvQSraUd1bm3/JS4IhLXADmYZLTos8D0K860kPS8kn3llRt5LzIlIHVe2uXNjKZIOA
	 yfPzhH6UBPxvGB3Y6FBT8Ce8aYG14Jn/7Sud7inSdSXbUCygIr2AFZiJY9/Dy49igj
	 hRzSZVC6bYl84XD4s5l1o+FTfPfq/gijBvS2MAKW/nCM9VJ8OQ3Md+tiELujZEkryP
	 SsOj+JVat04Yw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 23/48] xfs: validate rmap update done items during recovery
Date: Tue, 13 Oct 2026 17:01:13 +1100
Message-ID: <20261013060204.3138690-24-dgc@kernel.org>
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

An rmap update done item is a single fixed size region, but recovery only
checked its length in the commit handler and never checked its padding.

Validate the region length and require the padding to be zero as the item is
decoded. The commit handlers can then trust the item, so the length check is
removed from them. This is shared by the data and realtime rmap update done
items.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_rmap_item.c | 44 ++++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index def068cef09d..3a353256a930 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -884,18 +884,45 @@ xlog_recover_rud_commit_pass2(
 	struct xfs_rud_log_format	*rud_formatp;
 
 	rud_formatp = item->ri_buf[0].iov_base;
-	if (item->ri_buf[0].iov_len != sizeof(struct xfs_rud_log_format)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
-				rud_formatp, item->ri_buf[0].iov_len);
+	xlog_recover_release_intent(log, XFS_LI_RUI, rud_formatp->rud_rui_id);
+	return 0;
+}
+
+/*
+ * The rud is a single fixed size region. This is shared by the data and
+ * realtime rud items, which have identical formats.
+ */
+static int
+xlog_recover_rud_validate_region(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	int				region_index)
+{
+	struct xfs_rud_log_format	*rud_formatp =
+		item->ri_buf[region_index].iov_base;
+
+	if (item->ri_buf[region_index].iov_len !=
+			sizeof(struct xfs_rud_log_format)) {
+		xfs_warn(log->l_mp, "RUD: bad item region length %zu recovered.",
+				item->ri_buf[region_index].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	/* The padding is always written as zero. */
+	if (rud_formatp->__pad != 0) {
+		xfs_warn(log->l_mp, "RUD: bad padding 0x%x recovered.",
+				rud_formatp->__pad);
 		return -EFSCORRUPTED;
 	}
 
-	xlog_recover_release_intent(log, XFS_LI_RUI, rud_formatp->rud_rui_id);
 	return 0;
 }
 
 const struct xlog_recover_item_ops xlog_rud_item_ops = {
 	.item_type		= XFS_LI_RUD,
+	.min_hdr_len		= sizeof(struct xfs_rud_log_format),
+	.validate_nregions	= xlog_recover_single_region,
+	.validate_region	= xlog_recover_rud_validate_region,
 	.commit_pass2		= xlog_recover_rud_commit_pass2,
 };
 
@@ -910,12 +937,6 @@ xlog_recover_rtrud_commit_pass2(
 	struct xfs_rud_log_format	*rud_formatp;
 
 	rud_formatp = item->ri_buf[0].iov_base;
-	if (item->ri_buf[0].iov_len != sizeof(struct xfs_rud_log_format)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
-				rud_formatp, item->ri_buf[0].iov_len);
-		return -EFSCORRUPTED;
-	}
-
 	xlog_recover_release_intent(log, XFS_LI_RUI_RT,
 			rud_formatp->rud_rui_id);
 	return 0;
@@ -926,5 +947,8 @@ xlog_recover_rtrud_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_rtrud_item_ops = {
 	.item_type		= XFS_LI_RUD_RT,
+	.min_hdr_len		= sizeof(struct xfs_rud_log_format),
+	.validate_nregions	= xlog_recover_single_region,
+	.validate_region	= xlog_recover_rud_validate_region,
 	.commit_pass2		= xlog_recover_rtrud_commit_pass2,
 };
-- 
2.55.0

