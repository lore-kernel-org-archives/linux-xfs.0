Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871075;
	b=Wrvg96G+HOLpoYWFm+dRvKwM7xNR+3kn3sqLnzIIokbL6dOrsYSC64n1tcecvCN4P8jd
	 HHuBPjKTwAD6xnqkXrDHsCa5HFYc3+k70iIzFB0tHJqUlL/lksAnRtZ0quFp2M/ycsYzT
	 L9+xFL8NLQoZF9qLhYBWQkLbQpNa2eW8zz/AsXimlvHGKv3yMgkSvkWfFgbqB9hGTr+z9
	 nBsL0Y5cZLGGlDvr7A7dFFD8CGLelMvz4coX4/ujBUmpueQ3dAN4TMj02lLQI5D0JrLDk
	 Lu5BERXrGb88WEFGwYxqTaXdGNd26ZeEFK8h/k7fd9i8euXVljHASoBO4H2Vr/xrNQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=4mAq5OZN11mZUR6qHfTd9EaGN+BAnyyyJ3xohLee2qI=;
	b=gfZytA4xtej3H0sc3OBvZYwcs7/aire4FIjwtoMOYK7YsrLsi7DH7loYNtvK24IXYwcu
	 4Si4xKqCbmp5zhgEsd3QQjgzUWGFk2Hwy/M+cyIYoW6iILhJNSa4n1iKOWonSXzf9PrJc
	 5zMfAAcz1B0IyIXxSZiOFNv9F9pyOQz1JQEJkXbBdDoL8ppyHbIUyokEJ7mvtg5TIVvpY
	 1qZKr4a5O+CRXxIWzcy1V4dWC22PzArj+zXCZkgwxMWU54FIjLWM0h9W/iptT1YtltNbX
	 LBOfm83IbEY93lSCAkeKIKdx+3iyQbS2LKyfO2spP9tWfl8WV8lGd/FCBO8WyQgQNOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TfjGSEvh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467D7606A885
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TfjGSEvh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206DB1F000C7;
	Mon, 16 Nov 2026 23:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871074;
	bh=4mAq5OZN11mZUR6qHfTd9EaGN+BAnyyyJ3xohLee2qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TfjGSEvhd6buYbMv1Id1ff7iL1B7f2A0QtYuNoEVhKZb3Hd4JaARoUAMXrpMZCIAF
	 33f1OVsvlo2juMsR8ZpmoiGm7ud16o3eLcrDgU33ewA51RWAWYqVYPAxcuHU74yVj5
	 v85QPl6eQ+HS9aeEM2X/Vdtc4ImcTfqIx/p3JcH+aKc4LLXnA0RZT9SVSGD7oOaEnR
	 QL29neeMeH3pZUx8HNcfOv7+8ug5cZS+rWml2rK/csegcQ23GCahlhiy86cBqrnx41
	 JVb6sX3pitmeWEM/+XeoBTKCywTCGTGiFPPlBPpYRRrWQPDjO6RUWx5K952Krl2nM9
	 2p9VM3rjmxi2A==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 32/59] xfs: validate rmap update intents during recovery
Date: Tue, 17 Nov 2026 10:14:49 +1100
Message-ID: <20261116231707.3625263-33-dgc@kernel.org>
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

An rmap update intent is a single region item whose length depends on its
extent count, and whose extents carry rmap owner, offset and state that
recovery must trust. These were only checked during intent replay, after the
item had been decoded and queued.

Validate the region length as it is decoded, and validate the rmap extents in
->validate_item(). The rmap map extent has fixed width fields, so there is a
single on-disk format and no conversion is required. The commit handlers and
intent replay can then trust the item, so the redundant checks are removed from
them. This is shared by the data and realtime rmap update items.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_rmap_item.c | 119 ++++++++++++++++++++++++++---------------
 1 file changed, 77 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index be2d5d6fe863..def068cef09d 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -578,23 +578,10 @@ xfs_rmap_recover_work(
 	int				i;
 	int				error = 0;
 
-	/*
-	 * First check the validity of the extents described by the
-	 * RUI.  If any are bad, then assume that all are bad and
-	 * just toss the RUI.
-	 */
-	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
-		if (!xfs_rui_validate_map(mp, isrt,
-					&ruip->rui_format.rui_extents[i])) {
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					&ruip->rui_format,
-					sizeof(ruip->rui_format));
-			return -EFSCORRUPTED;
-		}
-
+	/* The extents were validated when the rui was recovered. */
+	for (i = 0; i < ruip->rui_format.rui_nextents; i++)
 		xfs_rui_recover_work(mp, dfp, isrt,
 				&ruip->rui_format.rui_extents[i]);
-	}
 
 	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);
 	if (isrt)
@@ -746,34 +733,92 @@ xlog_recover_rui_commit_pass2(
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_rui_log_item		*ruip;
 	struct xfs_rui_log_format	*rui_formatp;
-	size_t				len;
 
 	rui_formatp = item->ri_buf[0].iov_base;
 
-	if (item->ri_buf[0].iov_len < xfs_rui_log_format_sizeof(0)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+	ruip = xfs_rui_init(mp, ITEM_TYPE(item), rui_formatp->rui_nextents);
+	xfs_rui_copy_format(&ruip->rui_format, rui_formatp);
+	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
+
+	xlog_recover_intent_item(log, &ruip->rui_item, lsn,
+			&xfs_rmap_update_defer_type);
+	return 0;
+}
+
+/*
+ * The rui is a single region whose length must match its extent count. The
+ * rmap map extent has fixed width fields, so there is a single on-disk format.
+ * This is shared by the data and realtime rui items, which have identical
+ * formats.
+ */
+static int
+xlog_recover_rui_validate_region(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	int				region_index)
+{
+	struct xfs_rui_log_format	*rui_formatp =
+		item->ri_buf[region_index].iov_base;
+	size_t				len = item->ri_buf[region_index].iov_len;
+	uint32_t			nextents;
+
+	if (len < xfs_rui_log_format_sizeof(0)) {
+		xfs_warn(log->l_mp, "RUI: bad item region length %zu recovered.",
+				len);
 		return -EFSCORRUPTED;
 	}
 
-	len = xfs_rui_log_format_sizeof(rui_formatp->rui_nextents);
-	if (item->ri_buf[0].iov_len != len) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+	/*
+	 * Bound the extent count before the exact size check below so a corrupt
+	 * count cannot overflow the size calculation. This limit is a fuzzy
+	 * upper bound to prevent overflow; the size check that follows enforces
+	 * the precise length.
+	 */
+	nextents = rui_formatp->rui_nextents;
+	if (nextents == 0 ||
+	    nextents > XLOG_MAX_REGION_SIZE / sizeof(struct xfs_map_extent)) {
+		xfs_warn(log->l_mp, "RUI: bad extent count %u recovered.",
+				nextents);
 		return -EFSCORRUPTED;
 	}
 
-	ruip = xfs_rui_init(mp, ITEM_TYPE(item), rui_formatp->rui_nextents);
-	xfs_rui_copy_format(&ruip->rui_format, rui_formatp);
-	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
+	if (len != xfs_rui_log_format_sizeof(nextents)) {
+		xfs_warn(log->l_mp,
+			"RUI: item region length %zu does not match %u extents recovered.",
+			len, nextents);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
+/* Validate the rmap update extents in the rui. */
+static int
+xlog_recover_rui_validate_item(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_rui_log_format	*rui_formatp = item->ri_buf[0].iov_base;
+	bool				isrt = ITEM_TYPE(item) == XFS_LI_RUI_RT;
+	uint32_t			i;
+
+	for (i = 0; i < rui_formatp->rui_nextents; i++) {
+		if (!xfs_rui_validate_map(log->l_mp, isrt,
+					&rui_formatp->rui_extents[i])) {
+			xfs_warn(log->l_mp, "RUI: bad extent %u recovered.", i);
+			return -EFSCORRUPTED;
+		}
+	}
 
-	xlog_recover_intent_item(log, &ruip->rui_item, lsn,
-			&xfs_rmap_update_defer_type);
 	return 0;
 }
 
 const struct xlog_recover_item_ops xlog_rui_item_ops = {
 	.item_type		= XFS_LI_RUI,
+	.min_hdr_len		= sizeof(struct xfs_rui_log_format),
+	.validate_nregions	= xlog_recover_single_region,
+	.validate_region	= xlog_recover_rui_validate_region,
+	.validate_item		= xlog_recover_rui_validate_item,
 	.commit_pass2		= xlog_recover_rui_commit_pass2,
 };
 
@@ -788,23 +833,9 @@ xlog_recover_rtrui_commit_pass2(
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_rui_log_item		*ruip;
 	struct xfs_rui_log_format	*rui_formatp;
-	size_t				len;
 
 	rui_formatp = item->ri_buf[0].iov_base;
 
-	if (item->ri_buf[0].iov_len < xfs_rui_log_format_sizeof(0)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
-		return -EFSCORRUPTED;
-	}
-
-	len = xfs_rui_log_format_sizeof(rui_formatp->rui_nextents);
-	if (item->ri_buf[0].iov_len != len) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
-		return -EFSCORRUPTED;
-	}
-
 	ruip = xfs_rui_init(mp, ITEM_TYPE(item), rui_formatp->rui_nextents);
 	xfs_rui_copy_format(&ruip->rui_format, rui_formatp);
 	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
@@ -829,6 +860,10 @@ xlog_recover_rtrui_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_rtrui_item_ops = {
 	.item_type		= XFS_LI_RUI_RT,
+	.min_hdr_len		= sizeof(struct xfs_rui_log_format),
+	.validate_nregions	= xlog_recover_single_region,
+	.validate_region	= xlog_recover_rui_validate_region,
+	.validate_item		= xlog_recover_rui_validate_item,
 	.commit_pass2		= xlog_recover_rtrui_commit_pass2,
 };
 
-- 
2.55.0

