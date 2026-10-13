Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E53F3C09F8
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871361; cv=none; b=BTxooHK+KZ0dezK6wekDNgRc08k0WZM+V36pvrLLJe+/I/uUquGo74Eq0zVgSr5R7veQDMQoClMw1Pl5eZNRa+YlZ7+px8RYId6nZrOBggs5s2ocoNlR8IC+z6oWc4dkdTWDhuF9B0h9HRrUxzsJRO2Xvg/cqtiOrTnS5f+AE5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871361; c=relaxed/simple;
	bh=ZeS29bcJMEhV0b2fUrxYijtr6fw/+JtldRBqYhYcCeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJFw+gxopc2GTV5VvE1tHW2LjXp2kdGTI5fWK6aJWmNY1JFTni1lIok9jaLRUbS+GD7lHyGpozGabZ+8KVDyDVN6vdO2BpPx9Jb17wOORInSS8UzBuOLkRsVDmHiCM39/07PdOTAkAoK7CG1UtHCv74oXwBtBhgWo0BP7AWwcpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YUr9rLkI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YUr9rLkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723871F00893;
	Tue, 13 Oct 2026 06:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871360;
	bh=AOa5md2eTt4r4BHhm2rD84IRR7Y9vT7AZ1LJdNtk+X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YUr9rLkIoVm2GeETKS6aNRGoKZ8hxFmZrpkj799YqHjiQ+QYRaIRD0KHzcHTlOlNL
	 e4F4owuY+Eyr6wM1PJ5M1j0cZC3zo2hJxMsqSAzL2FtCrY6EWXCjiHMtJZimBQ/2Va
	 zDXEgdM+T8OewZ1nNHpzTBJJC4zp86aqU+zN9A9sU2c/bOAIeRKwFFg7Z9vqh6hLJd
	 D2E+QXwfl0mfNwu38mXGNZTdrqe/7dWn6wfnbYr3nqkDTbhnGfQoWONZevbv4wTsbF
	 4WPrD95fMT/joXsL4ViGgQbutVMtrdfDOP2NojGO5pN1su+2nGnd4qVQjAksz+nl1r
	 3BjunKHjfcIew==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 25/48] xfs: validate refcount update done items during recovery
Date: Tue, 13 Oct 2026 17:01:15 +1100
Message-ID: <20261013060204.3138690-26-dgc@kernel.org>
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

A refcount update done item is a single fixed size region, but recovery only
checked its length in the commit handler and never checked its padding.

Validate the region length and require the padding to be zero as the item is
decoded. The commit handlers can then trust the item, so the length check is
removed from them. This is shared by the data and realtime refcount update done
items.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_refcount_item.c | 44 +++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 1a5a4c3fb913..f94ad3f557ed 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -855,18 +855,45 @@ xlog_recover_cud_commit_pass2(
 	struct xfs_cud_log_format	*cud_formatp;
 
 	cud_formatp = item->ri_buf[0].iov_base;
-	if (item->ri_buf[0].iov_len != sizeof(struct xfs_cud_log_format)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
-				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+	xlog_recover_release_intent(log, XFS_LI_CUI, cud_formatp->cud_cui_id);
+	return 0;
+}
+
+/*
+ * The cud is a single fixed size region. This is shared by the data and
+ * realtime cud items, which have identical formats.
+ */
+static int
+xlog_recover_cud_validate_region(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	int				region_index)
+{
+	struct xfs_cud_log_format	*cud_formatp =
+		item->ri_buf[region_index].iov_base;
+
+	if (item->ri_buf[region_index].iov_len !=
+			sizeof(struct xfs_cud_log_format)) {
+		xfs_warn(log->l_mp, "CUD: bad item region length %zu recovered.",
+				item->ri_buf[region_index].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	/* The padding is always written as zero. */
+	if (cud_formatp->__pad != 0) {
+		xfs_warn(log->l_mp, "CUD: bad padding 0x%x recovered.",
+				cud_formatp->__pad);
 		return -EFSCORRUPTED;
 	}
 
-	xlog_recover_release_intent(log, XFS_LI_CUI, cud_formatp->cud_cui_id);
 	return 0;
 }
 
 const struct xlog_recover_item_ops xlog_cud_item_ops = {
 	.item_type		= XFS_LI_CUD,
+	.min_hdr_len		= sizeof(struct xfs_cud_log_format),
+	.validate_nregions	= xlog_recover_single_region,
+	.validate_region	= xlog_recover_cud_validate_region,
 	.commit_pass2		= xlog_recover_cud_commit_pass2,
 };
 
@@ -881,12 +908,6 @@ xlog_recover_rtcud_commit_pass2(
 	struct xfs_cud_log_format	*cud_formatp;
 
 	cud_formatp = item->ri_buf[0].iov_base;
-	if (item->ri_buf[0].iov_len != sizeof(struct xfs_cud_log_format)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
-				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
-		return -EFSCORRUPTED;
-	}
-
 	xlog_recover_release_intent(log, XFS_LI_CUI_RT,
 			cud_formatp->cud_cui_id);
 	return 0;
@@ -897,5 +918,8 @@ xlog_recover_rtcud_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_rtcud_item_ops = {
 	.item_type		= XFS_LI_CUD_RT,
+	.min_hdr_len		= sizeof(struct xfs_cud_log_format),
+	.validate_nregions	= xlog_recover_single_region,
+	.validate_region	= xlog_recover_cud_validate_region,
 	.commit_pass2		= xlog_recover_rtcud_commit_pass2,
 };
-- 
2.55.0

