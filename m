Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871081;
	b=sebFJZO8OirEnR2VAFYdbt6DbwW8H9KnIr8zaMNPtmuFbRaGKk8NB7MndJKYn5S9Nlvt
	 bWCXS3dX81HebyLIE+/7BYBI2dUv9GmUDYovzcJVpbCc+pj7rVsz+wBg3AZXhUsbw6ZpP
	 8XeCX221kLKY4w+GFqRyvP2u/IQEe5XzOFSZqjEu5RTawG4g1LFDUjEXe7L/SpbwReRT4
	 RpmhmsPAyC4+6kRcSCW6oiANOnlEI3CQV60EXTQKy8hqUI741MhXfGBZTLVQmPBhKbl8s
	 /MkNlCQx/TgQRgS357ldfiSFt4qw9DFGJZ6nZXMnFk45TkFxJkE/EhTS1DdvVzu3CgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=554L3Lko/7E4lABoISW8rhGth2S8t+c24XeibgdnGVU=;
	b=k6Nq3F1rAU9uNrdCzDIVTmJVMFh63x1ul3NrVNWnIOKikkT+OVRKbQdsdjI2vwJUlmT9
	 T0nWigR0mUBYFnod5B2Z4tvReIDwHxL/0cpVnNWaLKdynS2gTywU1BYAfwbsSzvyKJeE0
	 QCg2JC+dEFMv+xiq+E7NY7zagykd0sLYLcvE7EJIQIqj5/JElsaVEAyVhH11FiCigdlf7
	 wxPkIpifISAKMCxlQUXo1IACecr7hiee+XoU3ulhmWGopfq4MgwS9IdidGjncLT7UnEda
	 eTnLEJtVULoQ/tP/iUyYZTA3U3zvslP4h6FwVxn3x1/HOgtBh6kWbB9NjrW6rYmM87Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NAF3V6Cq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934D4606A329
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NAF3V6Cq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2E21F000C5;
	Mon, 16 Nov 2026 23:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871081;
	bh=554L3Lko/7E4lABoISW8rhGth2S8t+c24XeibgdnGVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NAF3V6Cq/BptOzYPWO0FovswsoZ7YFNgiGnyotHQ4+qZYlI43Ev55gM2NBJZtSV9h
	 DvU7pfmymKUOPQahU1HbfEXDsdK7OljTnjaB5V23CiYFwe+Q99V/GMvMYWhF3tmoli
	 Mf6Z8E1ZcK+z+UpGxJbTEhsAFRF7LvIA2E4xBhHSbwu1c1ZHUCVEA2d1ViFXGqXEhm
	 6EkTp7jOtMCt5mzK+7J2FdMnnAf1zPGRzK4n/ZkDJ4qDywPyibkj+k0/KZZvR5VGz0
	 wK/2coO+MVUr6k7w/rHQcnFZZ6WPkZC+lknks121t/Dp4j4/few1m19wFcJRUGvkZY
	 5/f91lq305CPg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 37/59] xfs: validate bmap update done items during recovery
Date: Tue, 17 Nov 2026 10:14:54 +1100
Message-ID: <20261116231707.3625263-38-dgc@kernel.org>
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

