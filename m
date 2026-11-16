Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871077;
	b=QEUcAY1zOqvnQre4qxlXd6tCA4+6G5oG59w+0rk9WGR3J1tacF8I/KamycglaCnKapJ4
	 /eOCFqhFbZII426bQdTlom7O4I66V7YblMbq8v7xv9epYgVnlzXq9x2741/1Pz14CJ+Or
	 GmtPtj4I33He4tuK6IFnnwPQV+zqOMHSbmJY/Ni6DBsNHaAw32P1G4P9uTQmq+MFrxhJY
	 cHp+epTQvZ6XSrJK5T1mquwBxT2xHU8EudAzd3EKSfuUaULt0i/K9Q2U++Rtt32Wm9mRr
	 +7QhDzBmXPt7PPqghPFW2W7gl37tluu2x1iGGhmcwJgxZpMAcXgjJcRRh5ykRp9hbQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=3mUo8gwTV/KJPuDzwr6J2rWxCnj8gNa6/wRXIhAHeXQ=;
	b=2UxYZXQngMaoG2/My8MYSG9uZfKxTOhJlTTof8umANcLoizshq5G7EV3nW+PwJGE3B8w
	 gNixzFEj6+fqBXz4tHaskLzMWP0h/WVwI5PKEDCFsnus9iA6oRfXAZgZb0Qbfzcxnt4qQ
	 VaxylZ/aMoIYNUht3zIC8qMS1y67jECOcnuSp9/HE/nanA2BZtLazD67maOnIrVaXlMyl
	 W4KvCScJ471OcOR7MZCOYEjMQwdYMns3G2n3R+yu/9QxS+nqgUOiyTmyCV/1SSFfgRsxZ
	 LB68ysUWPzTzfPRbYzkSbTE25i93tlORSWkAHm7idGlDX2L0CxWmyfdWDdCC6iCVMQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=invMc7+j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FE6606A323
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=invMc7+j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8700F1F000C5;
	Mon, 16 Nov 2026 23:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871077;
	bh=3mUo8gwTV/KJPuDzwr6J2rWxCnj8gNa6/wRXIhAHeXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=invMc7+jwKIh2q+Y4c02uJb70i/6KFkZzVbGrcVnFBPDDyLMa1mW/eJYJHF9rANXe
	 wvdajq99aNT5lF8KS2c6Xj+jMZLm+Y5ZPRwUm7kpMftW3GjmQkssrar4hEZXcrFeEc
	 N+hd8SK3wM/fC0xMMoXmJlrSP4i2mWk3DF/FLEDuTR7WnimbkmApQzq2dEIU9AYBcK
	 qGCklwJLhrUt+vVzAb+lcuSY1MdBYQ+opTiksMiUkIv9tkEASl+yww8sUpyQAwUkdQ
	 s3Y6gsaTcItdpTLKHFnLvkd1HGNlYGeXVafymB62k00MYPBuHbLBduncR3VZxiz+MD
	 YDaJxLcp/81oA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 34/59] xfs: validate refcount update intents during recovery
Date: Tue, 17 Nov 2026 10:14:51 +1100
Message-ID: <20261116231707.3625263-35-dgc@kernel.org>
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

A refcount update intent is a single region item whose length depends on its
extent count, and whose extents carry refcount operation state that recovery
must trust. These were only checked during intent replay, after the item had
been decoded and queued.

Validate the region length as it is decoded, and validate the refcount extents
in ->validate_item(). The commit handlers and intent replay can then trust the
item, so the redundant checks are removed from them. This is shared by the data
and realtime refcount update items.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_refcount_item.c | 119 ++++++++++++++++++++++++-------------
 1 file changed, 77 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 682c6e1b45e3..1a5a4c3fb913 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -513,23 +513,10 @@ xfs_refcount_recover_work(
 	int				i;
 	int				error = 0;
 
-	/*
-	 * First check the validity of the extents described by the
-	 * CUI.  If any are bad, then assume that all are bad and
-	 * just toss the CUI.
-	 */
-	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
-		if (!xfs_cui_validate_phys(mp, isrt,
-					&cuip->cui_format.cui_extents[i])) {
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					&cuip->cui_format,
-					sizeof(cuip->cui_format));
-			return -EFSCORRUPTED;
-		}
-
+	/* The extents were validated when the cui was recovered. */
+	for (i = 0; i < cuip->cui_format.cui_nextents; i++)
 		xfs_cui_recover_work(mp, dfp, isrt,
 				&cuip->cui_format.cui_extents[i]);
-	}
 
 	/*
 	 * Under normal operation, refcount updates are deferred, so we
@@ -717,34 +704,92 @@ xlog_recover_cui_commit_pass2(
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_cui_log_item		*cuip;
 	struct xfs_cui_log_format	*cui_formatp;
-	size_t				len;
 
 	cui_formatp = item->ri_buf[0].iov_base;
 
-	if (item->ri_buf[0].iov_len < xfs_cui_log_format_sizeof(0)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+	cuip = xfs_cui_init(mp, ITEM_TYPE(item), cui_formatp->cui_nextents);
+	xfs_cui_copy_format(&cuip->cui_format, cui_formatp);
+	atomic_set(&cuip->cui_next_extent, cui_formatp->cui_nextents);
+
+	xlog_recover_intent_item(log, &cuip->cui_item, lsn,
+			&xfs_refcount_update_defer_type);
+	return 0;
+}
+
+/*
+ * The cui is a single region whose length must match its extent count. The
+ * refcount phys extent has fixed width fields, so there is a single on-disk
+ * format. This is shared by the data and realtime cui items, which have
+ * identical formats.
+ */
+static int
+xlog_recover_cui_validate_region(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	int				region_index)
+{
+	struct xfs_cui_log_format	*cui_formatp =
+		item->ri_buf[region_index].iov_base;
+	size_t				len = item->ri_buf[region_index].iov_len;
+	uint32_t			nextents;
+
+	if (len < xfs_cui_log_format_sizeof(0)) {
+		xfs_warn(log->l_mp, "CUI: bad item region length %zu recovered.",
+				len);
 		return -EFSCORRUPTED;
 	}
 
-	len = xfs_cui_log_format_sizeof(cui_formatp->cui_nextents);
-	if (item->ri_buf[0].iov_len != len) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+	/*
+	 * Bound the extent count before the exact size check below so a corrupt
+	 * count cannot overflow the size calculation. This limit is a fuzzy
+	 * upper bound to prevent overflow; the size check that follows enforces
+	 * the precise length.
+	 */
+	nextents = cui_formatp->cui_nextents;
+	if (nextents == 0 ||
+	    nextents > XLOG_MAX_REGION_SIZE / sizeof(struct xfs_phys_extent)) {
+		xfs_warn(log->l_mp, "CUI: bad extent count %u recovered.",
+				nextents);
 		return -EFSCORRUPTED;
 	}
 
-	cuip = xfs_cui_init(mp, ITEM_TYPE(item), cui_formatp->cui_nextents);
-	xfs_cui_copy_format(&cuip->cui_format, cui_formatp);
-	atomic_set(&cuip->cui_next_extent, cui_formatp->cui_nextents);
+	if (len != xfs_cui_log_format_sizeof(nextents)) {
+		xfs_warn(log->l_mp,
+			"CUI: item region length %zu does not match %u extents recovered.",
+			len, nextents);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
+/* Validate the refcount update extents in the cui. */
+static int
+xlog_recover_cui_validate_item(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_cui_log_format	*cui_formatp = item->ri_buf[0].iov_base;
+	bool				isrt = ITEM_TYPE(item) == XFS_LI_CUI_RT;
+	uint32_t			i;
+
+	for (i = 0; i < cui_formatp->cui_nextents; i++) {
+		if (!xfs_cui_validate_phys(log->l_mp, isrt,
+					&cui_formatp->cui_extents[i])) {
+			xfs_warn(log->l_mp, "CUI: bad extent %u recovered.", i);
+			return -EFSCORRUPTED;
+		}
+	}
 
-	xlog_recover_intent_item(log, &cuip->cui_item, lsn,
-			&xfs_refcount_update_defer_type);
 	return 0;
 }
 
 const struct xlog_recover_item_ops xlog_cui_item_ops = {
 	.item_type		= XFS_LI_CUI,
+	.min_hdr_len		= sizeof(struct xfs_cui_log_format),
+	.validate_nregions	= xlog_recover_single_region,
+	.validate_region	= xlog_recover_cui_validate_region,
+	.validate_item		= xlog_recover_cui_validate_item,
 	.commit_pass2		= xlog_recover_cui_commit_pass2,
 };
 
@@ -759,23 +804,9 @@ xlog_recover_rtcui_commit_pass2(
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_cui_log_item		*cuip;
 	struct xfs_cui_log_format	*cui_formatp;
-	size_t				len;
 
 	cui_formatp = item->ri_buf[0].iov_base;
 
-	if (item->ri_buf[0].iov_len < xfs_cui_log_format_sizeof(0)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
-		return -EFSCORRUPTED;
-	}
-
-	len = xfs_cui_log_format_sizeof(cui_formatp->cui_nextents);
-	if (item->ri_buf[0].iov_len != len) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
-		return -EFSCORRUPTED;
-	}
-
 	cuip = xfs_cui_init(mp, ITEM_TYPE(item), cui_formatp->cui_nextents);
 	xfs_cui_copy_format(&cuip->cui_format, cui_formatp);
 	atomic_set(&cuip->cui_next_extent, cui_formatp->cui_nextents);
@@ -800,6 +831,10 @@ xlog_recover_rtcui_commit_pass2(
 
 const struct xlog_recover_item_ops xlog_rtcui_item_ops = {
 	.item_type		= XFS_LI_CUI_RT,
+	.min_hdr_len		= sizeof(struct xfs_cui_log_format),
+	.validate_nregions	= xlog_recover_single_region,
+	.validate_region	= xlog_recover_cui_validate_region,
+	.validate_item		= xlog_recover_cui_validate_item,
 	.commit_pass2		= xlog_recover_rtcui_commit_pass2,
 };
 
-- 
2.55.0

