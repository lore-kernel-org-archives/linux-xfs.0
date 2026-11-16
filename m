Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871082;
	b=TG8B3GbL4QZieGaPw3sZ5OfNaF1ZxRMuQSxb+6mGxahRAWscHPjENvCW9LF+xWHksyMF
	 nqxdhtBbkdikKKnpFCYuOQaO7GsQ1PIr3SnLTtHwi7CNK8Zmx+6muGK6iKB7wCX8quVE/
	 cybxQZP/rMWrexN/UsSkkAsn/ZXFnEtpRGbwBsGM2ef5383b0JZbXKLViAKymWA9wNMkA
	 fwMkRQi6PBj713lYfMDaeNJfgn62Ao1l5VQDcj2jNS/EDnmTCOo9NcdWX4bfZPaEPhBE2
	 IzAArofHMOALFpHQfzc7it7LZN6m347XoSpAtQ3G+ISqAaKA0Q49XDu63Dw4MIsiL/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Vd285umvqMk9zg0/fjRo79rhDcqV5I8thLJWTz47uFo=;
	b=oOekYOPRpcXEYb68xD/ev9aOs271sLefyX1m2FZto2H8QoB9uPGOhvFz5WIlTZVsqiRP
	 qjjYuUjpqA16OdEUMUDxeukG6xsFLa3/AeJ0SWUI2EO6z7fZia6o1vnZgfL9f9+LlDHis
	 pxKajBxY03SEH9zMqAw+N3+GRjZgViUBZbkV4aoA5ECmXiyIJ8yw9QpAXeSX+UdPZHjBo
	 eke3S20vkVRPKnpb+z4nlPZOcLZVecWj1zY5Wa2jAjXTsmp0xqJq9Nr1L2hW5J1aHE3yZ
	 KNJ7QTKuYj+TJdlimlY9fEsbq3r9sgpJbI/Tobk47bnmbyF2DecPji+X6K/aaxj7o4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n099KjTY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C1A606A329
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n099KjTY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DAB1F000C6;
	Mon, 16 Nov 2026 23:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871082;
	bh=Vd285umvqMk9zg0/fjRo79rhDcqV5I8thLJWTz47uFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n099KjTY8kxTCGLF+ZrV3aC9N7YMxhoufPLktmDafuA3g+xzl9KnhrfvFgm0xH4x0
	 ZG1hvNmm3CG5AOoDUiJhCG3qZilhvxXnO08qYCQCKwLZySSsUw048K7DxPey8+HuZp
	 pEfMXS91CZKJT5i3fUg89bW/O1lhhHGe9XmUpyMhtK/9qrRv46SPc0+18MtNCA0V6b
	 bPsJfZ3vFu1kU1zuGDiwBhfBO/4aY04Fw1Whw0shm9dnxFqWgxhoBJEKItG4v2in3K
	 bFglClsJ9fnrPYb29CEDB5Zp4na2S7zw9l6jfmf+B6s493LeW4zfFxTyZI4Uub5EZt
	 LRmQ/A3f1Hx7g==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 38/59] xfs: validate mapping exchange intents during recovery
Date: Tue, 17 Nov 2026 10:14:55 +1100
Message-ID: <20261116231707.3625263-39-dgc@kernel.org>
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

A mapping exchange intent is a single fixed size region describing an exchange
between two files, but its contents were only checked during intent replay,
after the item had been decoded and queued.

Validate the region length as it is decoded, and validate the exchange
parameters in ->validate_item(). xfs_xmi_validate() now takes the format
structure so it can run against the decoded region. The commit handler and
intent replay can then trust the item, so the redundant checks are removed from
them.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_exchmaps_item.c | 64 +++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_exchmaps_item.c b/fs/xfs/xfs_exchmaps_item.c
index 23381cb264c4..973df8ded795 100644
--- a/fs/xfs/xfs_exchmaps_item.c
+++ b/fs/xfs/xfs_exchmaps_item.c
@@ -324,14 +324,12 @@ xfs_exchmaps_abort_intent(
 static inline bool
 xfs_xmi_validate(
 	struct xfs_mount		*mp,
-	struct xfs_xmi_log_item		*xmi_lip)
+	struct xfs_xmi_log_format	*xlf)
 {
-	struct xfs_xmi_log_format	*xlf = &xmi_lip->xmi_format;
-
 	if (!xfs_has_exchange_range(mp))
 		return false;
 
-	if (xmi_lip->xmi_format.__pad != 0)
+	if (xlf->__pad != 0)
 		return false;
 
 	if (xlf->xmi_flags & ~XFS_EXCHMAPS_LOGGED_FLAGS)
@@ -447,13 +445,7 @@ xfs_exchmaps_recover_work(
 	struct xfs_inode		*ip1, *ip2;
 	int				error = 0;
 
-	if (!xfs_xmi_validate(mp, xmi_lip)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				&xmi_lip->xmi_format,
-				sizeof(xmi_lip->xmi_format));
-		return -EFSCORRUPTED;
-	}
-
+	/* The xmi was validated when it was recovered. */
 	xmi = xfs_xmi_item_recover_intent(mp, dfp, &xmi_lip->xmi_format, &req,
 			&ip1, &ip2);
 	if (IS_ERR(xmi))
@@ -569,32 +561,54 @@ xlog_recover_xmi_commit_pass2(
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_xmi_log_item		*xmi_lip;
 	struct xfs_xmi_log_format	*xmi_formatp;
-	size_t				len;
-
-	len = sizeof(struct xfs_xmi_log_format);
-	if (item->ri_buf[0].iov_len != len) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
-				 -EFSCORRUPTED, log->l_mp);
-		return -EFSCORRUPTED;
-	}
 
 	xmi_formatp = item->ri_buf[0].iov_base;
-	if (xmi_formatp->__pad != 0) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
-				 -EFSCORRUPTED, log->l_mp);
-		return -EFSCORRUPTED;
-	}
 
 	xmi_lip = xfs_xmi_init(mp);
-	memcpy(&xmi_lip->xmi_format, xmi_formatp, len);
+	memcpy(&xmi_lip->xmi_format, xmi_formatp,
+			sizeof(struct xfs_xmi_log_format));
 
 	xlog_recover_intent_item(log, &xmi_lip->xmi_item, lsn,
 			&xfs_exchmaps_defer_type);
 	return 0;
 }
 
+/* The xmi is a single fixed size region. */
+static int
+xlog_recover_xmi_validate_region(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	int				region_index)
+{
+	if (item->ri_buf[region_index].iov_len !=
+			sizeof(struct xfs_xmi_log_format)) {
+		xfs_warn(log->l_mp, "XMI: bad item region length %zu recovered.",
+				item->ri_buf[region_index].iov_len);
+		return -EFSCORRUPTED;
+	}
+	return 0;
+}
+
+/* Validate the mapping exchange parameters in the xmi. */
+static int
+xlog_recover_xmi_validate_item(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	if (!xfs_xmi_validate(log->l_mp, item->ri_buf[0].iov_base)) {
+		xfs_warn(log->l_mp, "XMI: bad exchange parameters recovered.");
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
 const struct xlog_recover_item_ops xlog_xmi_item_ops = {
 	.item_type		= XFS_LI_XMI,
+	.min_hdr_len		= sizeof(struct xfs_xmi_log_format),
+	.validate_nregions	= xlog_recover_single_region,
+	.validate_region	= xlog_recover_xmi_validate_region,
+	.validate_item		= xlog_recover_xmi_validate_item,
 	.commit_pass2		= xlog_recover_xmi_commit_pass2,
 };
 
-- 
2.55.0

