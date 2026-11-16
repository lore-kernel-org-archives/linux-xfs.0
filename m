Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871076;
	b=iUz4kyogZ397n9gUQgsx34BoZxzYkoMniNr4K2iEMhMIXmHd0jgxk3YqKxJEMUtjIBze
	 BvNUMNAA7ZbSzbpheFW9PDQB8Wp3J6lR525vD6xcfAauornLXQ1XPSG0RAJA7OF+F7IGn
	 b7y9ZrlyU1Pr8zYmQRFvVFnnh0YYmQMz/OwdfArOGPIWpYinCdS2hcKwwsf9WnjZraa4/
	 Tl2S68XQ7137yuQ3gymGwPXH8TJwV2WH46TCeabNTRKjGuedgCNA+lJs8F1+s5IYAHKjv
	 3YmBvabsWYMcwQ3rYk4dc/BXQw5/FpBY9V08AFTFsSE6CN2CISPQddoD9a8SHBjMJ/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871076;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=d1L4pJ30IAlwtwaljxL56c3u/tUWJ0XWpZappeJh5ps=;
	b=3pXxxyNc85Gp3GOeGHJBv/qa7SckdgJtfhO/zw6Ei/9Stto88OqmID0Mq4LAYUTVsRCH
	 vDUxOPtpNYPNiQkMaJqlfWu1Jvs1nwj2A68wcP5uT1eoA7bXKxAO1S9va9jmROVe4mOhq
	 ruJuUMSmU8zuMo108v3eqoH7y3jI7C8hqHSD0XpywPzevzc0aLEDCXxg1/9u0U5uLwE68
	 g52hjhTimCUo0ku+mTPZe1N5tbCKt57RG7cDxp6Y80dBjv/4f+p0rg+xDAHMmd9DQ5BHS
	 +omdYSUhwCF6o+7OHVQlClH3IjPuwuRCV95HF6zUp0Kw0HMGSodW63MD4rmeC1JmWZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hHfipOr3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3619E606A333
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hHfipOr3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534191F000C6;
	Mon, 16 Nov 2026 23:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871076;
	bh=d1L4pJ30IAlwtwaljxL56c3u/tUWJ0XWpZappeJh5ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hHfipOr3w6E6+Nj99yx0LnCkka9sKTlPAxXvPBcax5YLttSFvOiRoThfKHMKcc1Pu
	 2/cp2k/OMOKbAnAkuDPEfTrYi8Q905/WQbEgtkbXh7CYQ1wey7gErfESHPCLsbpeu8
	 dKAV0VRj9iIPsXfRtcfWXRRQ0EiFd/cuVP2p4nzFX34xPZ1hTvSqCUSPOH3Zkq1i/t
	 GqsYXaYAtY+BLAJxchuHaOvTcJtGOzEBQyCOM6tvSTm/wOBEEZOzMHiUf3XidSGW5k
	 Q91e7JoIA/YruJlDofIlJl4rnTi0u6yIYEq++YjzaujTkPmQHX7c/VlYUj74XVlbCJ
	 1mNajZ06E1u9g==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 33/59] xfs: validate rmap update done items during recovery
Date: Tue, 17 Nov 2026 10:14:50 +1100
Message-ID: <20261116231707.3625263-34-dgc@kernel.org>
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

