Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871070;
	b=rKWXiTObfvuGmjRNwFfJRryV14rZgtlSCsOWRSmFWbMaUmJPmj6FLtKSLyZJDrGv2SjH
	 npYzEMO0kFPcSUfJaNkvTwuSaBQf5i+nW+8Dub01h9DfpTuuP27kzegqQu7QM2ABhvEs9
	 dZ3Eh6i1VndSQtadNC5b4g5/lwTK2/LXjK2MsrI8ANyHSOf39OVpx5xB1c1nAwE7aYk+F
	 szU7JWg777rr/na4EvBz8KCdlbEFaW0zdG6SE6x8SOogNfWB/Q1XWFBUgy/0J9GyRT3gp
	 +IChMDmLmgcZRegNnG6tKBQpmaTgXVK/QGVHI3Jt25HeLZ5r2N+o4/COMxAtxTwDQVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=s/TJLJzMC7KlC1wbQHtmOgXi5mVQGXnD3gMDbOzVE74=;
	b=05ejN/6TIrTvv4756aUoUg+2dBLxc3Y4GB0YL/4RHUCCSDFBeGhR4EwRnA0uFdWDq/RF
	 iqYi7iHgmMOjFxosYnZ84mrowRyRon9arVeJmVJvY6QlQAM92AHOLjQgA1nckQ6OouH7s
	 zo4CkC140R7TV/PR6HY03NYYTVQAL47dxAgmPoFHQ5Un7h8IvyXTV7n9BPrZ0YHpVmikO
	 pyO6wcTkSAGk16Sgeh+WGSnA0kCnDnG7do3ontVg5W37KCgxac1GUx6vHe3+T/37Z6+Px
	 Y3Fzymiv3tppMCBlMniEVctH6XRWtCVWdPjhE48Y//ECkXu5m5/I++kpCtZX3H5CAbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h0ckZVer;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E866F606A323
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h0ckZVer
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041751F000C5;
	Mon, 16 Nov 2026 23:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871069;
	bh=s/TJLJzMC7KlC1wbQHtmOgXi5mVQGXnD3gMDbOzVE74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h0ckZVerPWQlQAi7IUWM66gWt3P6wqO28MML/lGOqdubrODQ6oraHsYuiQsP9zEps
	 taPR3h/12TgRzIyt8I4bq+ckR3guuXZ/8Tjw1t72oPhrS2PAcQ0dRHobTXbrAuYzbH
	 xTvYJ99FtHjcqNE8EZEJ35J9DMV8T9DDVrhRb9V+vnvBSQsLFGCw90k2/UJQHlNT4i
	 7HN2f/9qZ0y7k8xWQUJz2adNCED9Z4qUfiZ1ZeubhlJCmPPfFe/A3Mm2x+5/DcKkHL
	 i/FXHvUgfkNp/PEWsCsX7UUBoSpcUiU6XQ3ejRJ0bQEqMJ++w0IKJw7y9fIx+TolN/
	 04PqN+rBn8t7w==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 28/59] xfs: validate inode create and quota off log items during recovery
Date: Tue, 17 Nov 2026 10:14:45 +1100
Message-ID: <20261116231707.3625263-29-dgc@kernel.org>
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

The inode create and quota off log items are each a single region. Recovery
trusted the region layout decoded from the journal without checking it.

Validate both as they are decoded. A shared region count check rejects
anything other than a single region. The inode create region must be
exactly the format structure size.

Quota off items were last logged by v5.14 kernels. They wrote the format
structure into a region sized as the in-core log item, so the region is 160
bytes on 64 bit platforms and 88 bytes on 32 bit platforms. The quota off
region must be one of those sizes. The rest of the region beyond the format
structure was never written, so only the flags are checked. Quota off was
only logged when it turned off quota accounting, so the flags must name at
least one accounting type and nothing else.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_log_recover.h |  1 +
 fs/xfs/xfs_dquot_item_recover.c | 38 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_icreate_item.c       | 18 ++++++++++++++++
 fs/xfs/xfs_log_recover.c        | 25 +++++++++++++++++-----
 4 files changed, 77 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index d2e128fca058..2aefaac8e5cd 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -196,6 +196,7 @@ int xlog_recover_iget_handle(struct xfs_mount *mp, xfs_ino_t ino, uint32_t gen,
 		struct xfs_inode **ipp);
 void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
 		uint64_t intent_id);
+int xlog_recover_single_region(struct xlog *log, uint16_t nregions);
 int xlog_alloc_buf_cancel_table(struct xlog *log);
 void xlog_free_buf_cancel_table(struct xlog *log);
 
diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index b8854316ac75..1291e50d3031 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -208,8 +208,46 @@ xlog_recover_quotaoff_commit_pass1(
 	return 0;
 }
 
+/*
+ * Quota off items were last logged by v5.14 kernels. The format structure was
+ * written at the start of the region, but the region was sized as the in-core
+ * struct xfs_qoff_logitem. The region is therefore 160 bytes on 64 bit platforms
+ * and 88 bytes on 32 bit platforms. Only the format structure was ever written.
+ * The rest of the region is stale memory, so it cannot be checked.
+ */
+#define XFS_QOFF_LOG_REGION_SIZE_64	160
+#define XFS_QOFF_LOG_REGION_SIZE_32	88
+
+static int
+xlog_recover_quotaoff_validate_region(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	int				region_index)
+{
+	struct xfs_qoff_logformat	*qoff_f = item->ri_buf[region_index].iov_base;
+	size_t				len = item->ri_buf[region_index].iov_len;
+
+	if (len != XFS_QOFF_LOG_REGION_SIZE_64 &&
+	    len != XFS_QOFF_LOG_REGION_SIZE_32) {
+		xfs_warn(log->l_mp, "QOFF: bad item region length %zu recovered.",
+				len);
+		return -EFSCORRUPTED;
+	}
+
+	/* Quota off was only logged when it turned off quota accounting. */
+	if (!qoff_f->qf_flags || (qoff_f->qf_flags & ~XFS_ALL_QUOTA_ACCT)) {
+		xfs_warn(log->l_mp, "QOFF: bad flags 0x%x recovered.",
+				qoff_f->qf_flags);
+		return -EFSCORRUPTED;
+	}
+	return 0;
+}
+
 const struct xlog_recover_item_ops xlog_quotaoff_item_ops = {
 	.item_type		= XFS_LI_QUOTAOFF,
+	.min_hdr_len		= sizeof(struct xfs_qoff_logformat),
+	.validate_nregions	= xlog_recover_single_region,
+	.validate_region	= xlog_recover_quotaoff_validate_region,
 	.commit_pass1		= xlog_recover_quotaoff_commit_pass1,
 	/* nothing to commit in pass2 */
 };
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 95b0eba242e9..bae6a8ad3ca7 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -253,8 +253,26 @@ xlog_recover_icreate_commit_pass2(
 				     length, be32_to_cpu(icl->icl_gen));
 }
 
+static int
+xlog_recover_icreate_validate_region(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	int				region_index)
+{
+	if (item->ri_buf[region_index].iov_len !=
+			sizeof(struct xfs_icreate_log)) {
+		xfs_warn(log->l_mp, "ICR: bad item region length %zu recovered.",
+				item->ri_buf[region_index].iov_len);
+		return -EFSCORRUPTED;
+	}
+	return 0;
+}
+
 const struct xlog_recover_item_ops xlog_icreate_item_ops = {
 	.item_type		= XFS_LI_ICREATE,
+	.min_hdr_len		= sizeof(struct xfs_icreate_log),
+	.validate_nregions	= xlog_recover_single_region,
+	.validate_region	= xlog_recover_icreate_validate_region,
 	.reorder		= xlog_recover_icreate_reorder,
 	.commit_pass2		= xlog_recover_icreate_commit_pass2,
 };
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 927062a53dd4..4ed9cecdec03 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2231,14 +2231,25 @@ xlog_recover_nregions(
 	struct xlog		*log,
 	uint16_t		nregions)
 {
-	if (nregions == 0 || nregions > XLOG_MAX_REGIONS_IN_ITEM) {
-		xfs_warn(log->l_mp,
-	"bad number of regions (%d) in inode log format", nregions);
+	if (nregions == 0 || nregions > XLOG_MAX_REGIONS_IN_ITEM)
 		return -EFSCORRUPTED;
-	}
 	return nregions;
 }
 
+/*
+ * ->validate_nregions() helper for the many item types that are made up of a
+ * single region.
+ */
+int
+xlog_recover_single_region(
+	struct xlog		*log,
+	uint16_t		nregions)
+{
+	if (nregions != 1)
+		return -EFSCORRUPTED;
+	return 1;
+}
+
 /*
  * Start decoding a new log item. The item type and region count come from the
  * type/size fields at the front of the item's first region. Look up the item
@@ -2278,8 +2289,12 @@ xlog_recover_add_item(
 		valid_nregions = ops->validate_nregions(log, nregions);
 	else
 		valid_nregions = xlog_recover_nregions(log, nregions);
-	if (valid_nregions < 0)
+	if (valid_nregions < 0) {
+		xfs_warn(log->l_mp,
+			"%s: bad region count %u for log item type 0x%x",
+			__func__, nregions, item_type);
 		return ERR_PTR(valid_nregions);
+	}
 
 	item = kzalloc_obj(struct xlog_recover_item, GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&item->ri_list);
-- 
2.55.0

