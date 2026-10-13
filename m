Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24AE1443C29
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871354; cv=none; b=hJvIP785dxveqDwIE5/a9Q9qWfdvj9fNLjj2MZv0I94tXL2qYCQU0Y7azs1ykJ+W/h3A5P5Le9wSMOZ+UqNr9QeuD9qjGbFluK+T1Jz7mqVLK5V9Y+QjAKYsug79a1tuN4fC8Gjr5rvCA9gXSY9OgZebwrmvuTYmi58iaENtnW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871354; c=relaxed/simple;
	bh=PTI/ez4Uz97Q3GMzZzT7dEYrDnWjbycxFL3F75cbtCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QG/sww9d0J7enl3Wld0Vv4CB17oxUnnqIYvfIPD+cYfpNW2HkXhxQlJUOsXRurlX8QmctUcC8AzlRwMxUcCHgDh1LTmCzjk/zNkYesrOiXN3dKYHgZKc+Ipr/mLUJRFep8Jg5rpO1qaZ3JApfeDPouGxxY48UJxi8gX9oIJyBKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YZJA2W3J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YZJA2W3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510991F00893;
	Tue, 13 Oct 2026 06:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871353;
	bh=qTqJha9eCjzk3iVf7/jgmUuXyCfISWag+lnbExGbfjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YZJA2W3JEpH0+3Sbr1DK4zbM15tzrBLAWpSLiMVlNKZG1xiiEWJ4V+YFCSDxr5qLD
	 zuLvFy/MagpHl6UYjL419g5y4yCyqdVIJverJpDh0O4lU4TtqSNBbJM+BfcK0fZVo1
	 trVNpyvZPXbNyS3Y4tEH2apv7vg7koG0I5sXIrGhlakwlpVxx48h2W9J5vKxc/hGck
	 MpOAmeVj3d5zec4LV3vocET2gZKrOd+RoRAw+hnoG5pvPz1Iv5Gj2d8AljiO6SpaGC
	 9QSlfRiekqGuTd1Bsm7epTbxOpCudJNR1GcjGzz8ZVl05usOWYQJoT3KWJCf39PMvS
	 WYZROWfds4YTw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 19/48] xfs: validate extent free log items during recovery
Date: Tue, 13 Oct 2026 17:01:09 +1100
Message-ID: <20261013060204.3138690-20-dgc@kernel.org>
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

The extent free intent and done items are single region items whose length
depends on the extent count declared in the region. Recovery only checked this
in the commit handlers, after the item had already been decoded and
initialised. Validate the structure up front as the region is decoded instead.
The data and realtime variants share these checks as their formats are
identical.

The commit handlers and xfs_efi_copy_format() can now trust the structure, so
the redundant checks are removed from them. xfs_efi_copy_format() no longer has
a failure case and returns void.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_extfree_item.c | 217 ++++++++++++++++++++++++--------------
 1 file changed, 136 insertions(+), 81 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 2266d56e37dc..c8d15de582f5 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -180,58 +180,58 @@ xfs_efi_init(
  * one of which will be the native format for this kernel.
  * It will handle the conversion of formats if necessary.
  */
-STATIC int
+STATIC void
 xfs_efi_copy_format(
 	struct kvec			*buf,
 	struct xfs_efi_log_format	*dst_efi_fmt)
 {
 	struct xfs_efi_log_format	*src_efi_fmt = buf->iov_base;
-	uint				len, len32, len64, i;
-
-	len = xfs_efi_log_format_sizeof(src_efi_fmt->efi_nextents);
-	len32 = xfs_efi_log_format32_sizeof(src_efi_fmt->efi_nextents);
-	len64 = xfs_efi_log_format64_sizeof(src_efi_fmt->efi_nextents);
+	struct xfs_efi_log_format_32	*src_efi_fmt_32;
+	struct xfs_efi_log_format_64	*src_efi_fmt_64;
+	uint				nextents = src_efi_fmt->efi_nextents;
+	uint				i;
 
-	if (buf->iov_len == len) {
+	/*
+	 * The buffer has already been validated as one of the three formats, so
+	 * pick which one it is by its length and copy it into the native form.
+	 */
+	if (buf->iov_len == xfs_efi_log_format_sizeof(nextents)) {
 		memcpy(dst_efi_fmt, src_efi_fmt,
 		       offsetof(struct xfs_efi_log_format, efi_extents));
-		for (i = 0; i < src_efi_fmt->efi_nextents; i++)
+		for (i = 0; i < nextents; i++)
 			memcpy(&dst_efi_fmt->efi_extents[i],
 			       &src_efi_fmt->efi_extents[i],
 			       sizeof(struct xfs_extent));
-		return 0;
-	} else if (buf->iov_len == len32) {
-		struct xfs_efi_log_format_32 *src_efi_fmt_32 = buf->iov_base;
+		return;
+	}
 
+	if (buf->iov_len == xfs_efi_log_format32_sizeof(nextents)) {
+		src_efi_fmt_32 = buf->iov_base;
 		dst_efi_fmt->efi_type     = src_efi_fmt_32->efi_type;
 		dst_efi_fmt->efi_size     = src_efi_fmt_32->efi_size;
 		dst_efi_fmt->efi_nextents = src_efi_fmt_32->efi_nextents;
 		dst_efi_fmt->efi_id       = src_efi_fmt_32->efi_id;
-		for (i = 0; i < dst_efi_fmt->efi_nextents; i++) {
+		for (i = 0; i < nextents; i++) {
 			dst_efi_fmt->efi_extents[i].ext_start =
 				src_efi_fmt_32->efi_extents[i].ext_start;
 			dst_efi_fmt->efi_extents[i].ext_len =
 				src_efi_fmt_32->efi_extents[i].ext_len;
 		}
-		return 0;
-	} else if (buf->iov_len == len64) {
-		struct xfs_efi_log_format_64 *src_efi_fmt_64 = buf->iov_base;
-
-		dst_efi_fmt->efi_type     = src_efi_fmt_64->efi_type;
-		dst_efi_fmt->efi_size     = src_efi_fmt_64->efi_size;
-		dst_efi_fmt->efi_nextents = src_efi_fmt_64->efi_nextents;
-		dst_efi_fmt->efi_id       = src_efi_fmt_64->efi_id;
-		for (i = 0; i < dst_efi_fmt->efi_nextents; i++) {
-			dst_efi_fmt->efi_extents[i].ext_start =
-				src_efi_fmt_64->efi_extents[i].ext_start;
-			dst_efi_fmt->efi_extents[i].ext_len =
-				src_efi_fmt_64->efi_extents[i].ext_len;
-		}
-		return 0;
+		return;
+	}
+
+	ASSERT(buf->iov_len == xfs_efi_log_format64_sizeof(nextents));
+	src_efi_fmt_64 = buf->iov_base;
+	dst_efi_fmt->efi_type     = src_efi_fmt_64->efi_type;
+	dst_efi_fmt->efi_size     = src_efi_fmt_64->efi_size;
+	dst_efi_fmt->efi_nextents = src_efi_fmt_64->efi_nextents;
+	dst_efi_fmt->efi_id       = src_efi_fmt_64->efi_id;
+	for (i = 0; i < nextents; i++) {
+		dst_efi_fmt->efi_extents[i].ext_start =
+			src_efi_fmt_64->efi_extents[i].ext_start;
+		dst_efi_fmt->efi_extents[i].ext_len =
+			src_efi_fmt_64->efi_extents[i].ext_len;
 	}
-	XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, NULL, buf->iov_base,
-			buf->iov_len);
-	return -EFSCORRUPTED;
 }
 
 static inline struct xfs_efd_log_item *EFD_ITEM(struct xfs_log_item *lip)
@@ -864,22 +864,11 @@ xlog_recover_efi_commit_pass2(
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_efi_log_item		*efip;
 	struct xfs_efi_log_format	*efi_formatp;
-	int				error;
 
 	efi_formatp = item->ri_buf[0].iov_base;
 
-	if (item->ri_buf[0].iov_len < xfs_efi_log_format_sizeof(0)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
-		return -EFSCORRUPTED;
-	}
-
 	efip = xfs_efi_init(mp, ITEM_TYPE(item), efi_formatp->efi_nextents);
-	error = xfs_efi_copy_format(&item->ri_buf[0], &efip->efi_format);
-	if (error) {
-		xfs_efi_item_free(efip);
-		return error;
-	}
+	xfs_efi_copy_format(&item->ri_buf[0], &efip->efi_format);
 	atomic_set(&efip->efi_next_extent, efi_formatp->efi_nextents);
 
 	xlog_recover_intent_item(log, &efip->efi_item, lsn,
@@ -887,8 +876,60 @@ xlog_recover_efi_commit_pass2(
 	return 0;
 }
 
+/*
+ * The efi is a single region whose length must match the extent count for one
+ * of the native, 32 bit or 64 bit on-disk formats. This is shared by the data
+ * and realtime efi items, which have identical formats.
+ */
+static int
+xlog_recover_efi_validate_region(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	int				region_index)
+{
+	struct xfs_efi_log_format	*efi_formatp =
+		item->ri_buf[region_index].iov_base;
+	size_t				len = item->ri_buf[region_index].iov_len;
+	uint32_t			nextents;
+
+	if (len < xfs_efi_log_format_sizeof(0)) {
+		xfs_warn(log->l_mp, "EFI: bad item region length %zu recovered.",
+				len);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * Bound the extent count before the exact size checks below so a corrupt
+	 * count cannot overflow the size calculations. This limit is a fuzzy
+	 * upper bound using the smallest extent encoding to prevent overflow; it
+	 * does not need to be exact as the size checks that follow enforce the
+	 * precise length for each format.
+	 */
+	nextents = efi_formatp->efi_nextents;
+	if (nextents == 0 ||
+	    nextents > XLOG_MAX_REGION_SIZE / sizeof(struct xfs_extent_32)) {
+		xfs_warn(log->l_mp, "EFI: bad extent count %u recovered.",
+				nextents);
+		return -EFSCORRUPTED;
+	}
+
+	if (len != xfs_efi_log_format_sizeof(nextents) &&
+	    len != xfs_efi_log_format32_sizeof(nextents) &&
+	    len != xfs_efi_log_format64_sizeof(nextents)) {
+		xfs_warn(log->l_mp,
+			"EFI: item region length %zu does not match %u extents recovered.",
+			len, nextents);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
 const struct xlog_recover_item_ops xlog_efi_item_ops = {
 	.item_type		= XFS_LI_EFI,
+	.min_hdr_len		= sizeof(struct xfs_efi_log_format),
+	.validate_nregions	= xlog_recover_single_region,
+	.validate_region	= xlog_recover_efi_validate_region,
 	.commit_pass2		= xlog_recover_efi_commit_pass2,
 };
 
@@ -903,22 +944,11 @@ xlog_recover_rtefi_commit_pass2(
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_efi_log_item		*efip;
 	struct xfs_efi_log_format	*efi_formatp;
-	int				error;
 
 	efi_formatp = item->ri_buf[0].iov_base;
 
-	if (item->ri_buf[0].iov_len < xfs_efi_log_format_sizeof(0)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
-		return -EFSCORRUPTED;
-	}
-
 	efip = xfs_efi_init(mp, ITEM_TYPE(item), efi_formatp->efi_nextents);
-	error = xfs_efi_copy_format(&item->ri_buf[0], &efip->efi_format);
-	if (error) {
-		xfs_efi_item_free(efip);
-		return error;
-	}
+	xfs_efi_copy_format(&item->ri_buf[0], &efip->efi_format);
 	atomic_set(&efip->efi_next_extent, efi_formatp->efi_nextents);
 
 	xlog_recover_intent_item(log, &efip->efi_item, lsn,
@@ -941,6 +971,9 @@ xlog_recover_rtefi_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_rtefi_item_ops = {
 	.item_type		= XFS_LI_EFI_RT,
+	.min_hdr_len		= sizeof(struct xfs_efi_log_format),
+	.validate_nregions	= xlog_recover_single_region,
+	.validate_region	= xlog_recover_efi_validate_region,
 	.commit_pass2		= xlog_recover_rtefi_commit_pass2,
 };
 
@@ -959,31 +992,66 @@ xlog_recover_efd_commit_pass2(
 	xfs_lsn_t			lsn)
 {
 	struct xfs_efd_log_format	*efd_formatp;
-	int				buflen = item->ri_buf[0].iov_len;
 
 	efd_formatp = item->ri_buf[0].iov_base;
 
-	if (buflen < sizeof(struct xfs_efd_log_format)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
-				efd_formatp, buflen);
+	xlog_recover_release_intent(log, XFS_LI_EFI, efd_formatp->efd_efi_id);
+	return 0;
+}
+
+/*
+ * The efd is a single region whose length must match the extent count for the
+ * 32 bit or 64 bit on-disk format. This is shared by the data and realtime efd
+ * items, which have identical formats.
+ */
+static int
+xlog_recover_efd_validate_region(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	int				region_index)
+{
+	struct xfs_efd_log_format	*efd_formatp =
+		item->ri_buf[region_index].iov_base;
+	size_t				len = item->ri_buf[region_index].iov_len;
+	uint32_t			nextents;
+
+	if (len < sizeof(struct xfs_efd_log_format)) {
+		xfs_warn(log->l_mp, "EFD: bad item region length %zu recovered.",
+				len);
 		return -EFSCORRUPTED;
 	}
 
-	if (item->ri_buf[0].iov_len != xfs_efd_log_format32_sizeof(
-						efd_formatp->efd_nextents) &&
-	    item->ri_buf[0].iov_len != xfs_efd_log_format64_sizeof(
-						efd_formatp->efd_nextents)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
-				efd_formatp, buflen);
+	/*
+	 * Bound the extent count before the exact size checks below so a corrupt
+	 * count cannot overflow the size calculations. This limit is a fuzzy
+	 * upper bound using the smallest extent encoding to prevent overflow; it
+	 * does not need to be exact as the size checks that follow enforce the
+	 * precise length for each format.
+	 */
+	nextents = efd_formatp->efd_nextents;
+	if (nextents == 0 ||
+	    nextents > XLOG_MAX_REGION_SIZE / sizeof(struct xfs_extent_32)) {
+		xfs_warn(log->l_mp, "EFD: bad extent count %u recovered.",
+				nextents);
+		return -EFSCORRUPTED;
+	}
+
+	if (len != xfs_efd_log_format32_sizeof(nextents) &&
+	    len != xfs_efd_log_format64_sizeof(nextents)) {
+		xfs_warn(log->l_mp,
+			"EFD: item region length %zu does not match %u extents recovered.",
+			len, nextents);
 		return -EFSCORRUPTED;
 	}
 
-	xlog_recover_release_intent(log, XFS_LI_EFI, efd_formatp->efd_efi_id);
 	return 0;
 }
 
 const struct xlog_recover_item_ops xlog_efd_item_ops = {
 	.item_type		= XFS_LI_EFD,
+	.min_hdr_len		= sizeof(struct xfs_efd_log_format),
+	.validate_nregions	= xlog_recover_single_region,
+	.validate_region	= xlog_recover_efd_validate_region,
 	.commit_pass2		= xlog_recover_efd_commit_pass2,
 };
 
@@ -996,25 +1064,9 @@ xlog_recover_rtefd_commit_pass2(
 	xfs_lsn_t			lsn)
 {
 	struct xfs_efd_log_format	*efd_formatp;
-	int				buflen = item->ri_buf[0].iov_len;
 
 	efd_formatp = item->ri_buf[0].iov_base;
 
-	if (buflen < sizeof(struct xfs_efd_log_format)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
-				efd_formatp, buflen);
-		return -EFSCORRUPTED;
-	}
-
-	if (item->ri_buf[0].iov_len != xfs_efd_log_format32_sizeof(
-						efd_formatp->efd_nextents) &&
-	    item->ri_buf[0].iov_len != xfs_efd_log_format64_sizeof(
-						efd_formatp->efd_nextents)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
-				efd_formatp, buflen);
-		return -EFSCORRUPTED;
-	}
-
 	xlog_recover_release_intent(log, XFS_LI_EFI_RT,
 			efd_formatp->efd_efi_id);
 	return 0;
@@ -1025,5 +1077,8 @@ xlog_recover_rtefd_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_rtefd_item_ops = {
 	.item_type		= XFS_LI_EFD_RT,
+	.min_hdr_len		= sizeof(struct xfs_efd_log_format),
+	.validate_nregions	= xlog_recover_single_region,
+	.validate_region	= xlog_recover_efd_validate_region,
 	.commit_pass2		= xlog_recover_rtefd_commit_pass2,
 };
-- 
2.55.0

