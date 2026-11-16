Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871079;
	b=3KGsNBLi9QQdKZ4q0pYS93YPDsQB6Fq6qAMT/dTegfLxxzaAHp73eLmBBkGrQHtIorum
	 LxVDYsqlQF+YvO4b7kN2Q6YFzqJvbHpAn3aejTyMQAkxACEO8xoqR9lIcCFmAmx3OUtUC
	 WrBKKwdP0DUOLbavMVGq5Ov6m8S96FwhGDi6S42EQrsmhUoBQ5yDH0gH7GgcpKUY/RgjY
	 d9jA5p+bFRDanlutY12nBILr81/C5hZ9/UpQsQmY9wT8k0xPoPKIjVY3vRQY6nwcSE3B2
	 36YssiJ03Gb1g+I50Ux1+rOesX3Pq70NEnLkSuEGM/W766cxgZtScSaH76mvK2nwNrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871079;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=AOa5md2eTt4r4BHhm2rD84IRR7Y9vT7AZ1LJdNtk+X8=;
	b=xDh5vzmYpc4DtFHSLwoRjImpjj565d0lJkaKk57dEH0It0WymZSf47TPK0nSeVrUMr3j
	 W/UgEJAoS+WjsGvNtXFYpu3LMVkSPYFhFricb5kdffUiNiS/mm3at8z+4v98Xrx/fFMEg
	 s6uE1yOv7T7fdc94jmeeOsif1CtUt1ntO4UbDaEo/dO1IkzM4X4ztdzauuZGQEvVGEu/n
	 hL0l3lbhgKkEcGUQZ2zDFulRUVcX/j0mE0M17oXHeAsFgDW/TAiAf1LHZMWDVmy9u/HvT
	 ohLOdLOXeQuNEoGTJ5di8U7Dlfvf7DhvPnsbpyfjCU1nMKVOwtWydlkVZrNVgSoo7dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="V5pG++a/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27493606A32A
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V5pG++a/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41361F000C4;
	Mon, 16 Nov 2026 23:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871078;
	bh=AOa5md2eTt4r4BHhm2rD84IRR7Y9vT7AZ1LJdNtk+X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V5pG++a/C0+3VZIW48elIH9s0GCHVB8IlF5aV+5NNQXlEgt8HuVEB8+qLC00/r1Uc
	 hhNZxPhvvefxUI1kzX0B5ix2WzWlFE1/BRo47c31TUObn4t7mXwGczDX4hv0lLBiNZ
	 RkwvsZbTxTgX+FZENVvHmANpgTLGW9mD4BJsQzpar2ksnomWpJmPdEfBFO5yI584s/
	 oqV/qR55jZG7BNCxCXMBV8T4UQB3ujH5aZsLuRLj6n+q1wioTRttG3knJxg+D/02lG
	 oK6KuZVViqrDJ9n3YOBFsLuEHpftDuqdJYOn6yuBp+H3tMvsKPg1tC6yVgq0jHTpq1
	 D6OubyCbr5DIw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 35/59] xfs: validate refcount update done items during recovery
Date: Tue, 17 Nov 2026 10:14:52 +1100
Message-ID: <20261116231707.3625263-36-dgc@kernel.org>
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

