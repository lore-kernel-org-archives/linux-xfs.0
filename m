Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871073;
	b=QdrQsbG2Ijeqep2sz2QiEHhcWIasNMii6YVIfG0SntZqxMRe2cMO72SENZM48X34k2M/
	 76mzqjB0fNhFvsdEYmPkP+Kxma9dU3o3oE9D7L82rDrA5lyQPdqJ8HDIE9P2m5vtkxt3F
	 zUHqD6ZZxKTiW4UEtJsg+XRytRzlXL4LZ8QfIeXsm/7Qbx0idEKnu3pDqlIk6kXQzkAV0
	 ISc8QagRPgqQwlYys8EwhSWfGWzFHxxZ5gnQ/Gc9Cy1P0EXe21rMHzq5WW70rZ0FdBVLw
	 bFyuTqKY9VhnvzekgNzPcr+0euNyBs0IPyEqbOEErGQqE/n+avFUP4Qx7CpDqLnGqXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=0P9ispdCZ1JkUMvaLFOe6bWNYvNSX+sbGI7e+Xry0u0=;
	b=BEXQNiFsOsPZc37W1swXIEP++ezbZxNA6z0c71YjtIfJEQ782xMuHd9qwh0c9WcDqhJx
	 ylqtPvFrTMYOC+R1hM40+juMWE+peYMZJjvHKjKSvfbEtEZT/OV6pa/jjes3hnc0vniIi
	 XwFHxFwaFtfwtYS9RNHrzy+14nCTBrfyCmboULiFyLeKgNsGHVh54iFIRUDr+fJhQblH5
	 IDRnvMrhw1hjf35VbUhQYhWCAQOCyKb/M9NXtrzt9ytnJjZU2n13G4jk5UolF+F+kB2dG
	 YGz1SlLR8R7ilvB7FEPAmKBRLP06OoakeCp72EBXPYZlcCbuGjvze7VYEAtVaU0pkxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ocNamEQC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9760606A336
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ocNamEQC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D201F000C7;
	Mon, 16 Nov 2026 23:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871073;
	bh=0P9ispdCZ1JkUMvaLFOe6bWNYvNSX+sbGI7e+Xry0u0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ocNamEQCGII2f7OX+DCrbNjMgQaCdedbeg65spqHZFUop+J6Dx/tLIdXFqUzSNbwk
	 o7UP9+2PZWB8J2eDzTVMXff58EQ00NaNCv/xqbdr55ujzX/go68O3ocudrcxaL3rLW
	 qPq4QuTMJjjRiAQdIConOQQhjEaW2+BJY/1haEKRoe4Zy7VMKeMTZNi7JqSRhdMfQk
	 rfQEgriDSsbott8plaHqLbTZ35iZBJJsowcwzgslAXGTKaijxbNjxInGp1fM9ZcTgZ
	 lJftg92ynm9kSwvTf4xCEE8ZqFNm2fxA6qYhc1aRS98Yx34FBeAlZtaCH2ZPUMU5/5
	 fKkyAA2bB9M1w==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 31/59] xfs: validate and convert extent free done items during recovery
Date: Tue, 17 Nov 2026 10:14:48 +1100
Message-ID: <20261116231707.3625263-32-dgc@kernel.org>
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
index 893d19812a0c..7ec18c8224cb 100644
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
@@ -1060,11 +1106,49 @@ xlog_recover_efd_validate_region(
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
+		efd_formatp = kzalloc(host_len, GFP_KERNEL | __GFP_NOFAIL);
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
 
@@ -1093,5 +1177,6 @@ const struct xlog_recover_item_ops xlog_rtefd_item_ops = {
 	.min_hdr_len		= sizeof(struct xfs_efd_log_format),
 	.validate_nregions	= xlog_recover_single_region,
 	.validate_region	= xlog_recover_efd_validate_region,
+	.validate_item		= xlog_recover_efd_validate_item,
 	.commit_pass2		= xlog_recover_rtefd_commit_pass2,
 };
-- 
2.55.0

