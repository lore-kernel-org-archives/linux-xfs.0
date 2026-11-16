Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871072;
	b=CwiRJRck9H7qjGMz571f7W3+kgrE7YHtPIZc6tGPEo715VMtCk5qfvaY+8qgH8IOo4AE
	 j+cTimSkj+Kk0HADv7JFcfV2+KUvze1TtJyg3pzuZcpe1zy/VScduoJHjZdO8NUIvjeb2
	 iz8QiKDRahVtwCjzs3qCIzuc3ySvj/ZJsWGyQMUjwBFMUzBejASngejqjbh+Zj8cvfCE/
	 jCHDeeILccsPTlyRFASIV9vi3LqdoeJdQbaTHQav0csFDPXXYu3902v2KOnktZEm442L4
	 uWX2O5qWZMVXreBhZ0YqxMrHNRl1tIaKOL1710bbqxCjFcoA5ND1HmIkj3PElz09EJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871072;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=pL45JZJxf0VvM7rFjxZMzlLPhbqExcWnFaT2NVc+1IM=;
	b=m6ZkjpAFXGUw8miosc0KwhPQXlR9x5aBVKMtUTY4U0J7Uza4tx6sCoyVAvpNVaXAdZS8
	 s7IQ3A1f+WzP/jpjcldo9FNRxauiBi94bFbS8sVvLqY8NOWBSycICvz3+2BaRogtBQGUE
	 nuY7Hs9hPk0oLagGoet9qV/ICyT01EPmbLhV+U7Rr7UyRFgreKshy7s73HFz2zD/KsQYa
	 wrx7Be9toO/YbMlDHX0e2W6t/DL1aGSXEPKYQKs0QzFg7u+xabSFsxQ+gINXzaTj/3I+e
	 LnYxFtx5pvD2E8N/tt1knpjork/alch17FbPkjrFhRqo/HrvWtSenQpwlTH8GmBCyuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lLU8Colu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E67606A32A
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lLU8Colu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF00E1F000C7;
	Mon, 16 Nov 2026 23:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871072;
	bh=pL45JZJxf0VvM7rFjxZMzlLPhbqExcWnFaT2NVc+1IM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lLU8Coluu5DydG2WdbN5KJrycZrJF+NJRAX3kdYU9xGJIzodB8vJstxT+9LCc8WAq
	 luc1aXvud7ILePVUi2uop7aoEvgUGaYoanVLZ+tJMWtRKn5RyhJ5ybkWNA0qz0DE6f
	 kKCHDJcPAWvwZt9miH4GrENRwrLaOxRxzT32nRw1LhHC1fGWgR6e0oK61crkqmaONR
	 pjw8mtPnI5gljzbUJGJaT7q5H0AcbQlrdg3WnznuI+Cs7a/km0y7fj/PMG7rdH3q3A
	 L7Em/gTcxYGnIg3oRFzJh4WZa3MnU+oqfzmGhK4TRZ9DkPciG2hofeKNdmZj+vF99I
	 sOtotFX9ovong==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 30/59] xfs: validate and convert extent free intents during recovery
Date: Tue, 17 Nov 2026 10:14:47 +1100
Message-ID: <20261116231707.3625263-31-dgc@kernel.org>
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

The extents in a recovered extent free intent were only checked for validity
during intent replay, after the item had been decoded, copied to host format
and queued. A corrupt extent was therefore carried a long way into recovery
before being rejected.

Validate the extents up front and convert the item to host format in
->validate_item(), so the rest of recovery iterates the item as a host
structure without regard for the on-disk format. The conversion allocates a
new buffer only when the on-disk format differs in size from the host format.

The commit handlers then copy the already host format item directly, and the
extent validity check is dropped from intent replay. The format conversion no
longer needs its host format input case and is renamed accordingly. This is
shared by the data and realtime extent free items.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_extfree_item.c | 88 +++++++++++++++++++++++----------------
 1 file changed, 51 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 02079e97e443..893d19812a0c 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -174,14 +174,13 @@ xfs_efi_init(
 }
 
 /*
- * Copy an EFI format buffer from the given buf, and into the destination
- * EFI format structure.
- * The given buffer can be in 32 bit or 64 bit form (which has different padding),
- * one of which will be the native format for this kernel.
- * It will handle the conversion of formats if necessary.
+ * Convert an on-disk EFI format buffer into the given host format structure.
+ * The buffer is in 32 bit or 64 bit on-disk form (which have different padding);
+ * a buffer already in host format does not need conversion and is not passed
+ * here. The buffer has already been validated as one of these two formats.
  */
 STATIC void
-xfs_efi_copy_format(
+xfs_efi_to_host_format(
 	struct kvec			*buf,
 	struct xfs_efi_log_format	*dst_efi_fmt)
 {
@@ -191,20 +190,6 @@ xfs_efi_copy_format(
 	uint				nextents = src_efi_fmt->efi_nextents;
 	uint				i;
 
-	/*
-	 * The buffer has already been validated as one of the three formats, so
-	 * pick which one it is by its length and copy it into the native form.
-	 */
-	if (buf->iov_len == xfs_efi_log_format_sizeof(nextents)) {
-		memcpy(dst_efi_fmt, src_efi_fmt,
-		       offsetof(struct xfs_efi_log_format, efi_extents));
-		for (i = 0; i < nextents; i++)
-			memcpy(&dst_efi_fmt->efi_extents[i],
-			       &src_efi_fmt->efi_extents[i],
-			       sizeof(struct xfs_extent));
-		return;
-	}
-
 	if (buf->iov_len == xfs_efi_log_format32_sizeof(nextents)) {
 		src_efi_fmt_32 = buf->iov_base;
 		dst_efi_fmt->efi_type     = src_efi_fmt_32->efi_type;
@@ -660,23 +645,10 @@ xfs_extent_free_recover_work(
 	int				error = 0;
 	bool				isrt = xfs_efi_item_isrt(lip);
 
-	/*
-	 * First check the validity of the extents described by the EFI.  If
-	 * any are bad, then assume that all are bad and just toss the EFI.
-	 * Mixing RT and non-RT extents in the same EFI item is not allowed.
-	 */
-	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
-		if (!xfs_efi_validate_ext(mp, isrt,
-					&efip->efi_format.efi_extents[i])) {
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					&efip->efi_format,
-					sizeof(efip->efi_format));
-			return -EFSCORRUPTED;
-		}
-
+	/* The extents were validated when the efi was recovered. */
+	for (i = 0; i < efip->efi_format.efi_nextents; i++)
 		xfs_efi_recover_work(mp, dfp, isrt,
 				&efip->efi_format.efi_extents[i]);
-	}
 
 	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);
 	error = xfs_trans_alloc(mp, &resv, 0, 0, 0, &tp);
@@ -868,7 +840,7 @@ xlog_recover_efi_commit_pass2(
 	efi_formatp = item->ri_buf[0].iov_base;
 
 	efip = xfs_efi_init(mp, ITEM_TYPE(item), efi_formatp->efi_nextents);
-	xfs_efi_copy_format(&item->ri_buf[0], &efip->efi_format);
+	memcpy(&efip->efi_format, efi_formatp, item->ri_buf[0].iov_len);
 	atomic_set(&efip->efi_next_extent, efi_formatp->efi_nextents);
 
 	xlog_recover_intent_item(log, &efip->efi_item, lsn,
@@ -924,11 +896,52 @@ xlog_recover_efi_validate_region(
 	return 0;
 }
 
+/*
+ * Convert the efi to host format and validate its contents. Later recovery then
+ * iterates ri_buf[0] as a host struct xfs_efi_log_format without caring about
+ * the on-disk format. The conversion only needs to allocate a new buffer when
+ * the on-disk format differs in size from the host format; a buffer already in
+ * host format is validated in place.
+ */
+static int
+xlog_recover_efi_validate_item(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_efi_log_format	*efi_formatp = item->ri_buf[0].iov_base;
+	uint32_t			nextents = efi_formatp->efi_nextents;
+	size_t				host_len = xfs_efi_log_format_sizeof(nextents);
+	bool				isrt = ITEM_TYPE(item) == XFS_LI_EFI_RT;
+	uint32_t			i;
+
+	if (item->ri_buf[0].iov_len != host_len) {
+		efi_formatp = kzalloc(host_len, GFP_KERNEL | __GFP_NOFAIL);
+		xfs_efi_to_host_format(&item->ri_buf[0], efi_formatp);
+		kvfree(item->ri_buf[0].iov_base);
+		item->ri_buf[0].iov_base = efi_formatp;
+		item->ri_buf[0].iov_len = host_len;
+	}
+
+	for (i = 0; i < nextents; i++) {
+		struct xfs_extent	*extp = &efi_formatp->efi_extents[i];
+
+		if (!xfs_efi_validate_ext(log->l_mp, isrt, extp)) {
+			xfs_warn(log->l_mp,
+	"EFI: bad extent %u (start 0x%llx, len 0x%x) recovered.",
+				i, extp->ext_start, extp->ext_len);
+			return -EFSCORRUPTED;
+		}
+	}
+
+	return 0;
+}
+
 const struct xlog_recover_item_ops xlog_efi_item_ops = {
 	.item_type		= XFS_LI_EFI,
 	.min_hdr_len		= sizeof(struct xfs_efi_log_format),
 	.validate_nregions	= xlog_recover_single_region,
 	.validate_region	= xlog_recover_efi_validate_region,
+	.validate_item		= xlog_recover_efi_validate_item,
 	.commit_pass2		= xlog_recover_efi_commit_pass2,
 };
 
@@ -947,7 +960,7 @@ xlog_recover_rtefi_commit_pass2(
 	efi_formatp = item->ri_buf[0].iov_base;
 
 	efip = xfs_efi_init(mp, ITEM_TYPE(item), efi_formatp->efi_nextents);
-	xfs_efi_copy_format(&item->ri_buf[0], &efip->efi_format);
+	memcpy(&efip->efi_format, efi_formatp, item->ri_buf[0].iov_len);
 	atomic_set(&efip->efi_next_extent, efi_formatp->efi_nextents);
 
 	xlog_recover_intent_item(log, &efip->efi_item, lsn,
@@ -973,6 +986,7 @@ const struct xlog_recover_item_ops xlog_rtefi_item_ops = {
 	.min_hdr_len		= sizeof(struct xfs_efi_log_format),
 	.validate_nregions	= xlog_recover_single_region,
 	.validate_region	= xlog_recover_efi_validate_region,
+	.validate_item		= xlog_recover_efi_validate_item,
 	.commit_pass2		= xlog_recover_rtefi_commit_pass2,
 };
 
-- 
2.55.0

