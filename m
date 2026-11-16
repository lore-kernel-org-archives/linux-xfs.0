Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871085;
	b=xGfNN1PlLmXOGeAj9/vAP6eYVpLVQO21NX+VHYrYrecbLQ9Yqk638noZ3WFREvfonrJg
	 NlCcdruVWRGBfGLXpGFqQxq2T2uu8rVz86fZO5KuvtVeXfdcBc0jEiZGpvoQTJ2fG+n6g
	 fT0j3SjPv0GhtCcLIwCQHYQCeGuPuCJ1MGHOpgiQJYssOcXY+Mkx0pz3Knrz8CwGGoUQJ
	 75//8a1k87s4VwGKR63QJI/NGoSpomI5g5hwgnL9NBmGtJkK4Bekk9BedeYxR6TweBeDS
	 clunTcx3iQY+QF/4BJ4IgnuZr/gyd8TzfxWryOwoqlCmL7D2h7+QcEHvEt8RKlkhPyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=inzcl2YREfpDHbkJ3hXCrTHM8iSoIrSU/f8ByouSgpg=;
	b=B7gq5aQbDlwRim2D2+gioLzV5+RcgrTZKMXoUSVLgxprQZMASWLCjAmJ2TzvRuAVXrIY
	 kIxjXRK4Vdx5rdw9GtRV0MhYiAjjsusGMG+r945pZiPQqS/mspUj8mmw7Nehf9Lh0K7kN
	 lTuRuda7XKjTZgfP6e7PRWXRAZPuObvoXAabZkjWzzAuPaJuYMV+kKgC0QFsQBCZVmvsT
	 1HXRNtYBPZn1o3QIurH59iTteFGbTIs0t1mfNF9YsK9ucb8q0XHH91Ghyyml8/7wFNSVp
	 jM2v3/WD4KFfrLu15inOng2eRy2Yml8UZYC1vN1uoQ1xkGgOWkMRS2SK+9pajhbheag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cStBGiv0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C15A606A33D
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cStBGiv0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7511F000C4;
	Mon, 16 Nov 2026 23:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871085;
	bh=inzcl2YREfpDHbkJ3hXCrTHM8iSoIrSU/f8ByouSgpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cStBGiv0JG5BA1gqaWmgbH/k9jfvjS51Eckd7Wny6WYJ6TpjRucRiciwVfsaKM2PJ
	 eHmkFC77Uq9xln/dLO/mMX07H6Q2CVCihlQbwonDKOwswI0Ww8z2XIXQgGe8pq4Azy
	 Ke2tdph4y3OOwSgnmhTXcvZ3PMRGWTq1R8Us1wPyRVNvw9TH9Hhm1+ciJUcFfGGDY1
	 fcFnWhKAV1hpjBEJJxbk9FutMsez3Ely0xkQxKwTpxb7jkNObrx2CZnxE/l0I9ZQEp
	 Z0mip0ceF6QDDijZw88vfY75vcJbXna/wVGaK85nt5Ydre/MoaGyR7el2RF/yzkquJ
	 6Cm/9iaVfEx1g==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 40/59] xfs: validate dquot items during recovery
Date: Tue, 17 Nov 2026 10:14:57 +1100
Message-ID: <20261116231707.3625263-41-dgc@kernel.org>
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

A dquot item is a format header region followed by the dquot record region.
Recovery validated the dquot record with xfs_dquot_verify() but never checked
the log format header, and only loosely checked the record region size, all
during commit rather than as the item was decoded. The buffer address and
offset in the format header were used to read a buffer without any bounds
checking.

Validate the region layout and the whole item up front as it is decoded, so
commit and readahead can trust the item. The location of a dquot within its
cluster buffer is fixed by the dquot ID, so the logged offset must match the
location derived from the ID. The redundant checks are removed from commit and
readahead.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_dquot_item_recover.c | 119 ++++++++++++++++++++++++++------
 1 file changed, 97 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index 1291e50d3031..b0be570c4842 100644
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
@@ -175,8 +153,105 @@ xlog_recover_dquot_commit_pass2(
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
+	unsigned int			ndquots;
+	unsigned int			start;
+	unsigned int			end;
+
+	if (dq_f->qlf_len != XFS_DQUOT_CLUSTER_SIZE_FSB) {
+		xfs_warn(mp, "DQUOT: bad buffer length %d recovered.",
+				dq_f->qlf_len);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * There is a fixed relationship between the dquot ID and its location
+	 * in the cluster buffer. These must match and the dqblk must still fit
+	 * within the dquot cluster buffer size.
+	 */
+	ndquots = xfs_calc_dquots_per_chunk(
+			XFS_FSB_TO_BB(mp, XFS_DQUOT_CLUSTER_SIZE_FSB));
+	start = (dq_f->qlf_id % ndquots) * sizeof(struct xfs_dqblk);
+	end = start + sizeof(struct xfs_dqblk);
+	if (dq_f->qlf_boffset != start) {
+		xfs_warn(mp,
+	"DQUOT: dquot id 0x%x bad buffer offset %u, expected %u recovered.",
+				dq_f->qlf_id, dq_f->qlf_boffset, start);
+		return -EFSCORRUPTED;
+	}
+	if (end > XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB)) {
+		xfs_warn(mp,
+	"DQUOT: dquot id 0x%x at offset %u overruns buffer size %lld recovered.",
+				dq_f->qlf_id, start,
+				XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB));
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

