Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8EC3C09F8
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871355; cv=none; b=UeKqyzeWsg/LvCDxYtR9B+7R/DCa1qrXpMrAWyr9hxlkCBa098CqajVVUVS0qQli4h1OenULFJAqC2YLe8HMNZEaMj3mfb3iXjjzqs6zi7He4GjPeA9ZjVMqJGspzYi5dyAFa/ydgsIZ1kuoboVV1hDouIzD2hWsWVggmAJDYrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871355; c=relaxed/simple;
	bh=rplfqn1JJEUavCxDTc7wLf4iJmAXM73Qqndm0KVCMZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ly/5mCCnThrjvhmY9C9/96DHZu7r2cXqqSO/ZVPiujzLNdvVVuJK5w5pMql+k6j9DIm4FzNNzl1ooS4lBPmloGDibuZKglSkkUKd9OzIcTBTYXe1jxlApNlp5jcfx7tPeEodf2d3DtN0JHV6Z5I1pvqe8maA6EuFmiX9xoR9BK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LAq2YnN8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LAq2YnN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0B71F000FF;
	Tue, 13 Oct 2026 06:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871354;
	bh=QGeIJNPUR7wWMfFC56tfAUYiNlNI39UkgUek8yuPUos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LAq2YnN8h1IDk1TwQ2jPhXns4ogtvwQrLYxoowDviJ+bqEjeRlg8idubaLdkqWc+P
	 Sos8+8Uu/CCa+jmtTvUe1i1u+Q3guHVxMFegtOvDyXma5cmWUNUc4v/xGxxmHxNnnS
	 X1VCB7jvCT88DRIXmuJFJrmEVdmW0TenLrlLYYtzE5JlyiSluDIEEvrb0vCMgP0Iqo
	 AsIUXZwCw2w1cgJwIwFpUprAh2v6jx/82zBneXDQADOPbS9jLPyWZZZX9sqSZYj65h
	 vaQCdvoSiSsbldu/9VhivX19vt/JrCixveuKtYqwwg7PC+We51K7o8g1md4o3sV9XS
	 a2OkMyb0+F8ZQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 20/48] xfs: validate and convert extent free intents during recovery
Date: Tue, 13 Oct 2026 17:01:10 +1100
Message-ID: <20261013060204.3138690-21-dgc@kernel.org>
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
index c8d15de582f5..b38e1f2089d4 100644
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
@@ -925,11 +897,52 @@ xlog_recover_efi_validate_region(
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
+		efi_formatp = xlog_kvmalloc(host_len);
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
 
@@ -948,7 +961,7 @@ xlog_recover_rtefi_commit_pass2(
 	efi_formatp = item->ri_buf[0].iov_base;
 
 	efip = xfs_efi_init(mp, ITEM_TYPE(item), efi_formatp->efi_nextents);
-	xfs_efi_copy_format(&item->ri_buf[0], &efip->efi_format);
+	memcpy(&efip->efi_format, efi_formatp, item->ri_buf[0].iov_len);
 	atomic_set(&efip->efi_next_extent, efi_formatp->efi_nextents);
 
 	xlog_recover_intent_item(log, &efip->efi_item, lsn,
@@ -974,6 +987,7 @@ const struct xlog_recover_item_ops xlog_rtefi_item_ops = {
 	.min_hdr_len		= sizeof(struct xfs_efi_log_format),
 	.validate_nregions	= xlog_recover_single_region,
 	.validate_region	= xlog_recover_efi_validate_region,
+	.validate_item		= xlog_recover_efi_validate_item,
 	.commit_pass2		= xlog_recover_rtefi_commit_pass2,
 };
 
-- 
2.55.0

