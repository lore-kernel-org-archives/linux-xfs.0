Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84DE489862
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871363; cv=none; b=UnR9jXCG7/xgzC91nvUUw9ZoTc4c19/VFAnbZRxsJBvRwGrcc1mKoYk7nKio5538nDfxwlFUo55J9kBDiyTkeFgU+5jXhS+VSEobK24G5xDViH3kn54jgp6AZ6YgKtUHqaebw9aR9qVJCSb/dGy8BsKpRtYPryvMxckqdRRAYeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871363; c=relaxed/simple;
	bh=N0QGaK3iVesmcJTOhU8Tdaj4NbpQ/0aIWCvXN9gqyNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cF4dGgf5M2O1HNUq1J842vso85TFFOQYPz5thzKsOWVrJ8lLieqkFKswchkLI/2oEeD1Pg1XKCwApg84AQNFyO3tfXj5tQQCo+ZINbK7weATce0D7izTZUwAuzVxOKIt0MdfqPbJUVIMsXkvNjioQpPEfNWwLthUaUBaEAbj2Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CnkJnIE4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CnkJnIE4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0D71F00893;
	Tue, 13 Oct 2026 06:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871362;
	bh=554L3Lko/7E4lABoISW8rhGth2S8t+c24XeibgdnGVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CnkJnIE4QAZfGKw1RTBSzWe869NzR6USJEZTb8s4FVMdCus4FuSbbuLs+9yZpqPOW
	 qIR23KFw3MMipqfLXphgsqvkBRrj0CyA5fkXKatp0oRyCmnQ3KSg5QRKnlgyjbd5XJ
	 Lt2EaDMoRPStaWmfKnPZHY0qn22m4sdPKXwzQGRuNpeq4Z1Fw2zRfj7t7dsSOLqO3N
	 2vfwUq7HiUFV8MibWLopyyqEVYwrUsDT95lUZQgehEmD/FXJumjXEiaYPmWuW9zBbE
	 qKWmwlJH+wF6k05bnASZfnfEELQxsVpxusoxzW2h8i3tW4OCDF9bkicTi/rfy3notb
	 VQ0RMnfDUR1ow==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 27/48] xfs: validate bmap update done items during recovery
Date: Tue, 13 Oct 2026 17:01:17 +1100
Message-ID: <20261013060204.3138690-28-dgc@kernel.org>
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

A bmap update done item is a single fixed size region, but recovery only
checked its length in the commit handler and never checked its padding.

Validate the region length and require the padding to be zero as the item is
decoded. The commit handler can then trust the item, so the length check is
removed from it.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_bmap_item.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 37ada25109c9..d2205335a08f 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -733,17 +733,41 @@ xlog_recover_bud_commit_pass2(
 	struct xfs_bud_log_format	*bud_formatp;
 
 	bud_formatp = item->ri_buf[0].iov_base;
-	if (item->ri_buf[0].iov_len != sizeof(struct xfs_bud_log_format)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
-				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+	xlog_recover_release_intent(log, XFS_LI_BUI, bud_formatp->bud_bui_id);
+	return 0;
+}
+
+/* The bud is a single fixed size region. */
+static int
+xlog_recover_bud_validate_region(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	int				region_index)
+{
+	struct xfs_bud_log_format	*bud_formatp =
+		item->ri_buf[region_index].iov_base;
+
+	if (item->ri_buf[region_index].iov_len !=
+			sizeof(struct xfs_bud_log_format)) {
+		xfs_warn(log->l_mp, "BUD: bad item region length %zu recovered.",
+				item->ri_buf[region_index].iov_len);
+		return -EFSCORRUPTED;
+	}
+
+	/* The padding is always written as zero. */
+	if (bud_formatp->__pad != 0) {
+		xfs_warn(log->l_mp, "BUD: bad padding 0x%x recovered.",
+				bud_formatp->__pad);
 		return -EFSCORRUPTED;
 	}
 
-	xlog_recover_release_intent(log, XFS_LI_BUI, bud_formatp->bud_bui_id);
 	return 0;
 }
 
 const struct xlog_recover_item_ops xlog_bud_item_ops = {
 	.item_type		= XFS_LI_BUD,
+	.min_hdr_len		= sizeof(struct xfs_bud_log_format),
+	.validate_nregions	= xlog_recover_single_region,
+	.validate_region	= xlog_recover_bud_validate_region,
 	.commit_pass2		= xlog_recover_bud_commit_pass2,
 };
-- 
2.55.0

