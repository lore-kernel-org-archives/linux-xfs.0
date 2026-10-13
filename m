Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50F348EC62
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871367; cv=none; b=TMvGKOQYsoCtvSr8RV7JtS2HNASTeecQDGa65SyWCGNFOxrqv+jUtLo2EAbSPWUPIDp+EEHWoCghOtgfskWERmSgh4bzmJn+u6ib1Zvli7VQzOUMU1tVCRJdfojctHcmN1rWn7oGuztlRGdriXY+xMBRXGx+b7CzxHyOkshDy5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871367; c=relaxed/simple;
	bh=P8AA6JO8P5tOi7dNu8VH1n68ah9jg0qGTst2Mx2H9BI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cc8Ki/7cwKrGmnJnlRfh+3ymuESjNQxp4iSyNbx5/rneUarZfIOsnTera7HFtxOFmCV18yYbHT256YCIrRFHzMRWWFfkZj0ERmFIdmnn6jkPnTwTo2w0uqYxKj+ycglAlAjeCesf9kJR5NYo19R8Km70qaYqmClZfU3cp9bxG38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IM9ryZiU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IM9ryZiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEA31F000FF;
	Tue, 13 Oct 2026 06:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871366;
	bh=7jqulrZRmBbp/g6dRSF1lj+C3sAI22diFGTCyHfrLIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IM9ryZiUfTPPFL612Q89lzPxLdnipOqk5VtQ/vd0DMHHHMg2vOzhW/vkXZHCiFUru
	 DH6PRaGY8olGxzNubcnkqxU1b11gbCXkV95g6sRKlVsxxByqyWzI87u+liJguFp0GB
	 gtwvnhAYECFFr1Zf+WSM2yuNwwA6AV5LYUpTzrB03ChvuQNtYBV+1KxwAlMPkWUtXk
	 Swhl51oKC4j9sMhZoNF7BFTrBAHquS+FDYt+WlMaIC4DB+/PWLIqFRMJOKAjG2rHv1
	 yKvAHSoUZT3z/FlZYt9qqF2bRD5H4ffJRDmofXY4551VywD9HgSr249EWsNiDOEoC7
	 szlyQXG/6d68w==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 30/48] xfs: validate dquot items during recovery
Date: Tue, 13 Oct 2026 17:01:20 +1100
Message-ID: <20261013060204.3138690-31-dgc@kernel.org>
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

A dquot item is a format header region followed by the dquot record region.
Recovery validated the dquot record with xfs_dquot_verify() but never checked
the log format header, and only loosely checked the record region size, all
during commit rather than as the item was decoded. The buffer address and
offset in the format header were used to read a buffer without any bounds
checking.

Validate the region layout and the whole item up front as it is decoded, so
commit and readahead can trust the item. The redundant checks are removed from
them.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_dquot_item_recover.c | 100 +++++++++++++++++++++++++-------
 1 file changed, 78 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index 980d1f24c1d5..e485b828cd95 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -35,11 +35,6 @@ xlog_recover_dquot_ra_pass2(
 		return;
 
 	recddq = item->ri_buf[1].iov_base;
-	if (recddq == NULL)
-		return;
-	if (item->ri_buf[1].iov_len < sizeof(struct xfs_disk_dquot))
-		return;
-
 	type = recddq->d_type & XFS_DQTYPE_REC_MASK;
 	ASSERT(type);
 	if (log->l_quotaoffs_flag & type)
@@ -80,15 +75,6 @@ xlog_recover_dquot_commit_pass2(
 		return 0;
 
 	recddq = item->ri_buf[1].iov_base;
-	if (recddq == NULL) {
-		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
-		return -EFSCORRUPTED;
-	}
-	if (item->ri_buf[1].iov_len < sizeof(struct xfs_disk_dquot)) {
-		xfs_alert(log->l_mp, "dquot too small (%zd) in %s.",
-			item->ri_buf[1].iov_len, __func__);
-		return -EFSCORRUPTED;
-	}
 
 	/*
 	 * This type of quotas was turned off, so ignore this record.
@@ -109,14 +95,6 @@ xlog_recover_dquot_commit_pass2(
 	 * removed since the last mount - ENOSYS.
 	 */
 	dq_f = item->ri_buf[0].iov_base;
-	ASSERT(dq_f);
-	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id);
-	if (fa) {
-		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
-				dq_f->qlf_id, fa);
-		return -EFSCORRUPTED;
-	}
-	ASSERT(dq_f->qlf_len == 1);
 
 	/*
 	 * At this point we are assuming that the dquots have been allocated
@@ -175,8 +153,86 @@ xlog_recover_dquot_commit_pass2(
 	return error;
 }
 
+/* A dquot item is a format header region followed by the dquot record. */
+static int
+xlog_recover_dquot_nregions(
+	struct xlog			*log,
+	uint16_t			nregions)
+{
+	if (nregions != 2)
+		return -EFSCORRUPTED;
+	return 2;
+}
+
+static int
+xlog_recover_dquot_validate_region(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	int				region_index)
+{
+	size_t				len = item->ri_buf[region_index].iov_len;
+	size_t				expected;
+
+	if (region_index == 0)
+		expected = sizeof(struct xfs_dq_logformat);
+	else
+		expected = sizeof(struct xfs_disk_dquot);
+
+	if (len != expected) {
+		xfs_warn(log->l_mp,
+			"DQUOT: bad region %d length %zu recovered.",
+			region_index, len);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
+static int
+xlog_recover_dquot_validate_item(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_dq_logformat		*dq_f = item->ri_buf[0].iov_base;
+	struct xfs_disk_dquot		*ddq = item->ri_buf[1].iov_base;
+	xfs_failaddr_t			fa;
+
+	if (dq_f->qlf_len != XFS_DQUOT_CLUSTER_SIZE_FSB) {
+		xfs_warn(mp, "DQUOT: bad buffer length %d recovered.",
+				dq_f->qlf_len);
+		return -EFSCORRUPTED;
+	}
+
+	if (dq_f->qlf_boffset + sizeof(struct xfs_dqblk) >
+			XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB)) {
+		xfs_warn(mp, "DQUOT: bad buffer offset %u recovered.",
+				dq_f->qlf_boffset);
+		return -EFSCORRUPTED;
+	}
+
+	if (!xfs_verify_fsbno(mp, XFS_DADDR_TO_FSB(mp, dq_f->qlf_blkno))) {
+		xfs_warn(mp, "DQUOT: bad buffer block 0x%llx recovered.",
+				dq_f->qlf_blkno);
+		return -EFSCORRUPTED;
+	}
+
+	fa = xfs_dquot_verify(mp, ddq, dq_f->qlf_id);
+	if (fa) {
+		xfs_warn(mp, "DQUOT: dquot id 0x%x failed validation at %pS",
+				dq_f->qlf_id, fa);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
 const struct xlog_recover_item_ops xlog_dquot_item_ops = {
 	.item_type		= XFS_LI_DQUOT,
+	.min_hdr_len		= sizeof(struct xfs_dq_logformat),
+	.validate_nregions	= xlog_recover_dquot_nregions,
+	.validate_region	= xlog_recover_dquot_validate_region,
+	.validate_item		= xlog_recover_dquot_validate_item,
 	.ra_pass2		= xlog_recover_dquot_ra_pass2,
 	.commit_pass2		= xlog_recover_dquot_commit_pass2,
 };
-- 
2.55.0

