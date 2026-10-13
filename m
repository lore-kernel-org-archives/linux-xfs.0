Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA89417BD2
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871356; cv=none; b=IiMx+v4rmJ6tHlQUcU6x+9d7bPnPfF7xd8HEbaHZ2NjPzBgXGqwpMxNW+uh5yVQv+Ui4CZqsiX+AluDvB/A74IV00AdCizibxQOHP+Y6jlzERnXom1EBmXghp+klEuyccAOo4ui4W5n1BMjfdwe3hKGS4OYvB+xAQ9R0q1PXQW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871356; c=relaxed/simple;
	bh=NQx8niGX+V5wH6TEXJWUXLxzpok9hoCRIpttj0oGm4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYr4/qZRUmTe2Xl3/yt1TN4EbhjIdS9WCi5EZGgW5mUgsfdeSQq4yFtH4Q8BWAIT57a1nOj0GAz31zz0kCTxCwjnJ7sCPJAnPUcRIg1dxZQg/eRzG6hrAZXDkq26Ujk3ZJy3HDZRtoIhfQ6DASjEUs0BCUunKcWXnCeb0GTRSw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QVHqvAi9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QVHqvAi9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAEE01F00893;
	Tue, 13 Oct 2026 06:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871355;
	bh=SfXrTUrRnKMOpAw5Jih0KJN5v9jwGrSQPIGqTbtz700=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QVHqvAi9XvwAA7aBtpWAbBGAJMmlsv70LZzQJMdkDIIRXiCFnrqgZLmQfxj5Zd7xT
	 wh/lNowH0apxBcq0Me7gVlcg4cZXlSBpa8MLGBliGBPO0JQF1TLZqIQuCD71Pjp6Tf
	 XimXtMKZsjarblxoPk0FqbBaIGgo5X7hR1Wd1q2jDo02LJIs18dswtu8TDkc4UogSq
	 qnk8hBLAr3N1INLwWR2im9jt4ym8xcZMB8i10ARUICFF+fNZIqm4lHLcqqUB9HYOl+
	 kvVzAUyUoQP37Q/EnBKXLBDynn8euFURUTfZnq65B3LkMUYSPLEAI+GNBEVficvmTg
	 MJLP9dl8aS2ZQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 21/48] xfs: validate and convert extent free done items during recovery
Date: Tue, 13 Oct 2026 17:01:11 +1100
Message-ID: <20261013060204.3138690-22-dgc@kernel.org>
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

An extent free done item carries the same extents as the intent it completes,
but recovery never converted it to host format or checked those extents. The
on-disk format was left in place and its contents trusted.

Convert the item to host format and validate its extents in ->validate_item(),
mirroring the extent free intent item. The conversion allocates a new buffer
only when the on-disk format differs in size from the host format. This is
shared by the data and realtime extent free done items.

This conversion and validation is being done now so that, in future, the EFD
extents can be checked against the extents in the matched EFI. This will ensure
a corruption of the efd_efi_id does not result in completion of an incorrect
EFI.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_extfree_item.c | 85 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index b38e1f2089d4..53da797182d4 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -219,6 +219,52 @@ xfs_efi_to_host_format(
 	}
 }
 
+/*
+ * Convert an on-disk EFD format buffer into the given host format structure.
+ * The buffer is in 32 bit or 64 bit on-disk form (which have different padding);
+ * a buffer already in host format does not need conversion and is not passed
+ * here. The buffer has already been validated as one of these two formats.
+ */
+STATIC void
+xfs_efd_to_host_format(
+	struct kvec			*buf,
+	struct xfs_efd_log_format	*dst_efd_fmt)
+{
+	struct xfs_efd_log_format	*src_efd_fmt = buf->iov_base;
+	struct xfs_efd_log_format_32	*src_efd_fmt_32;
+	struct xfs_efd_log_format_64	*src_efd_fmt_64;
+	uint				nextents = src_efd_fmt->efd_nextents;
+	uint				i;
+
+	if (buf->iov_len == xfs_efd_log_format32_sizeof(nextents)) {
+		src_efd_fmt_32 = buf->iov_base;
+		dst_efd_fmt->efd_type     = src_efd_fmt_32->efd_type;
+		dst_efd_fmt->efd_size     = src_efd_fmt_32->efd_size;
+		dst_efd_fmt->efd_nextents = src_efd_fmt_32->efd_nextents;
+		dst_efd_fmt->efd_efi_id   = src_efd_fmt_32->efd_efi_id;
+		for (i = 0; i < nextents; i++) {
+			dst_efd_fmt->efd_extents[i].ext_start =
+				src_efd_fmt_32->efd_extents[i].ext_start;
+			dst_efd_fmt->efd_extents[i].ext_len =
+				src_efd_fmt_32->efd_extents[i].ext_len;
+		}
+		return;
+	}
+
+	ASSERT(buf->iov_len == xfs_efd_log_format64_sizeof(nextents));
+	src_efd_fmt_64 = buf->iov_base;
+	dst_efd_fmt->efd_type     = src_efd_fmt_64->efd_type;
+	dst_efd_fmt->efd_size     = src_efd_fmt_64->efd_size;
+	dst_efd_fmt->efd_nextents = src_efd_fmt_64->efd_nextents;
+	dst_efd_fmt->efd_efi_id   = src_efd_fmt_64->efd_efi_id;
+	for (i = 0; i < nextents; i++) {
+		dst_efd_fmt->efd_extents[i].ext_start =
+			src_efd_fmt_64->efd_extents[i].ext_start;
+		dst_efd_fmt->efd_extents[i].ext_len =
+			src_efd_fmt_64->efd_extents[i].ext_len;
+	}
+}
+
 static inline struct xfs_efd_log_item *EFD_ITEM(struct xfs_log_item *lip)
 {
 	return container_of(lip, struct xfs_efd_log_item, efd_item);
@@ -1061,11 +1107,49 @@ xlog_recover_efd_validate_region(
 	return 0;
 }
 
+/*
+ * Convert the efd to host format and validate its contents, as for the efi.
+ * The efd extents mirror those of the efi it completes.
+ */
+static int
+xlog_recover_efd_validate_item(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_efd_log_format	*efd_formatp = item->ri_buf[0].iov_base;
+	uint32_t			nextents = efd_formatp->efd_nextents;
+	size_t				host_len = xfs_efd_log_format_sizeof(nextents);
+	bool				isrt = ITEM_TYPE(item) == XFS_LI_EFD_RT;
+	uint32_t			i;
+
+	if (item->ri_buf[0].iov_len != host_len) {
+		efd_formatp = xlog_kvmalloc(host_len);
+		xfs_efd_to_host_format(&item->ri_buf[0], efd_formatp);
+		kvfree(item->ri_buf[0].iov_base);
+		item->ri_buf[0].iov_base = efd_formatp;
+		item->ri_buf[0].iov_len = host_len;
+	}
+
+	for (i = 0; i < nextents; i++) {
+		struct xfs_extent	*extp = &efd_formatp->efd_extents[i];
+
+		if (!xfs_efi_validate_ext(log->l_mp, isrt, extp)) {
+			xfs_warn(log->l_mp,
+	"EFD: bad extent %u (start 0x%llx, len 0x%x) recovered.",
+				i, extp->ext_start, extp->ext_len);
+			return -EFSCORRUPTED;
+		}
+	}
+
+	return 0;
+}
+
 const struct xlog_recover_item_ops xlog_efd_item_ops = {
 	.item_type		= XFS_LI_EFD,
 	.min_hdr_len		= sizeof(struct xfs_efd_log_format),
 	.validate_nregions	= xlog_recover_single_region,
 	.validate_region	= xlog_recover_efd_validate_region,
+	.validate_item		= xlog_recover_efd_validate_item,
 	.commit_pass2		= xlog_recover_efd_commit_pass2,
 };
 
@@ -1094,5 +1178,6 @@ const struct xlog_recover_item_ops xlog_rtefd_item_ops = {
 	.min_hdr_len		= sizeof(struct xfs_efd_log_format),
 	.validate_nregions	= xlog_recover_single_region,
 	.validate_region	= xlog_recover_efd_validate_region,
+	.validate_item		= xlog_recover_efd_validate_item,
 	.commit_pass2		= xlog_recover_rtefd_commit_pass2,
 };
-- 
2.55.0

