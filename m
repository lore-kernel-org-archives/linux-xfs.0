Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250BF470454
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871366; cv=none; b=dMP0s/qkFoDxkCN5oBHy/7OS5AVulTkanrSDN9jGML94bURERQp59Jo52TlMCnasoiZ0f7BxSgBoGYqi/fBLV64kZD9VoIk7Pu8b9iYNYsHHLZQrw38Ez8AhGxVp/gI/kvbrnly8oXHNb8OknCXojCBYIk7r9mjrSwHEuazg2B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871366; c=relaxed/simple;
	bh=vvpX3nlY8qWLMmsj6B8fNOPiiGQE+M8n/c3Ik6bqAlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMXHciTl1xfqXZD7S/7MeOH0uxVlDoavc+A62bW+BtHOCgvbaSuqm+H7myLJ+ANjtx0P/nqcbX/q48n+Iwkr5M70NLF6O8KkavoMPXL39ptY3OezNUQA43W6427fSp3PULfRx9EdUGx/pYgLOEpeF5g0SOZio52oSkoPiBdwxp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fzjG++Bl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fzjG++Bl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D04F1F00893;
	Tue, 13 Oct 2026 06:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871365;
	bh=JajQXIKe6MN6wou6e5yu8Ere9/Ua51Y16A3cs0tt9KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fzjG++BlnbPDMEuRxhT4YAtZxhLDHXqx1Zfs1cILDIQbulZYb6KDmKRQ3ajNECJsw
	 8IMSfuqOIUdzb8ScrXUy5oWdJ7QCKNd+Nv+Q1st9kQaTF2afLBWpiMPw8A/t7cZ4Un
	 rKU/jQGdz1VU15vtGH1qxDT1j7HA4AzGZehOYUrkaawS7PLAoaKNzvUgKEekJxXq0F
	 tAMeMXqSGoyxqVbozZCQ0S6RRfEdh36xogvS6eCEZ8GQ/QfVYg0t0Ui8Zfswe/5PgN
	 R20XLk8wnA3qwMyJaABMe4ABzS9Lgw9wQPOtveAGRcY5vcfAR19Sa5uFwHaBpyw65e
	 i9JeXvkkgcIAA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 29/48] xfs: validate mapping exchange done items during recovery
Date: Tue, 13 Oct 2026 17:01:19 +1100
Message-ID: <20261013060204.3138690-30-dgc@kernel.org>
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

A mapping exchange done item is a single fixed size region, but recovery only
checked its length in the commit handler and never checked its padding.

Validate the region length and require the padding to be zero as the item is
decoded. The commit handler can then trust the item, so the length check is
removed from it.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_exchmaps_item.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_exchmaps_item.c b/fs/xfs/xfs_exchmaps_item.c
index 6ee55a22eb90..9c60c6712a45 100644
--- a/fs/xfs/xfs_exchmaps_item.c
+++ b/fs/xfs/xfs_exchmaps_item.c
@@ -607,17 +607,41 @@ xlog_recover_xmd_commit_pass2(
 	struct xfs_xmd_log_format	*xmd_formatp;
 
 	xmd_formatp = item->ri_buf[0].iov_base;
-	if (item->ri_buf[0].iov_len != sizeof(struct xfs_xmd_log_format)) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
-				 -EFSCORRUPTED, log->l_mp);
+	xlog_recover_release_intent(log, XFS_LI_XMI, xmd_formatp->xmd_xmi_id);
+	return 0;
+}
+
+/* The xmd is a single fixed size region. */
+static int
+xlog_recover_xmd_validate_region(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	int				region_index)
+{
+	struct xfs_xmd_log_format	*xmd_formatp =
+		item->ri_buf[region_index].iov_base;
+
+	if (item->ri_buf[region_index].iov_len !=
+			sizeof(struct xfs_xmd_log_format)) {
+		xfs_warn(log->l_mp, "XMD: bad item region length %zu recovered.",
+				item->ri_buf[region_index].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	/* The padding is always written as zero. */
+	if (xmd_formatp->__pad != 0) {
+		xfs_warn(log->l_mp, "XMD: bad padding 0x%x recovered.",
+				xmd_formatp->__pad);
 		return -EFSCORRUPTED;
 	}
 
-	xlog_recover_release_intent(log, XFS_LI_XMI, xmd_formatp->xmd_xmi_id);
 	return 0;
 }
 
 const struct xlog_recover_item_ops xlog_xmd_item_ops = {
 	.item_type		= XFS_LI_XMD,
+	.min_hdr_len		= sizeof(struct xfs_xmd_log_format),
+	.validate_nregions	= xlog_recover_single_region,
+	.validate_region	= xlog_recover_xmd_validate_region,
 	.commit_pass2		= xlog_recover_xmd_commit_pass2,
 };
-- 
2.55.0

