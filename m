Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBED23C0A1A
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871353; cv=none; b=Uc432QRYl9Xx5vfKZCt+Aemmj7rpHAmLPDL62Am6wzpwp/SwjxivG0hFX8ooDRlkwooA6BkhZBwNOAaiyMdS8ceX/M359u7AqRQlu/3x2Hnq6x4MQJje1ySlv8UdA8PAiDu+KZcZJIJdwItSBMz3zMdJZe3IbUwc891ZW6jUwkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871353; c=relaxed/simple;
	bh=7IEF5fUVIBJrriqBi9VjSpolmH3sMNOFmA6OAv69SUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDhgKCSYZvY/LdW0WLtid8SpGZB1CkMDnXmkbdH55ZhLhOCmcis9yw8hsSuPUBCrB080sh0ZT08nm4QmpAjkX2cT4gVNR/rCUUztFILScGlz7bqxaMIrQP8CJ260e4o7ukKN9sptZm5miyR4XBbL9EJ+UoIO5qTSF3KScufBI5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PC89QrFn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PC89QrFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221D21F000FF;
	Tue, 13 Oct 2026 06:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871351;
	bh=XWIio2sMSlGEJU1tB2ReNLGvToCT4H75mWs/NurhVkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PC89QrFnOeUkAtbplWRhHrVDb1x3AMz4YM7Sn/tFWeBqOZHaePhoAhOgJ90lUfJFF
	 y6drxs12jmWvdEiKidahp2neIzB1Z4S90mTYGczDhIEQVxww5RObz4E9ZS/lXMNTIu
	 dM53gZcxAp2E1g7vBNDDGnsrMcBI3YwmI3o5Gb6wmmS/T7XXvQoTsbnNmxaqoSjKgz
	 Rtx2Vv6FB3h9P4bjshfNj/UlVOcwyjMbTSGyZ14eDANovhBOlYbgo1IF+NtRjUK5tk
	 tF4Moi9NEEMXv5Zk81DR40+1rIeaqWo7JqCDfgMW2UsvvUkyQDNy2RoxUCeK4ilYrR
	 n1xCKH/UsWSFQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 18/48] xfs: validate fixed size log items during recovery
Date: Tue, 13 Oct 2026 17:01:08 +1100
Message-ID: <20261013060204.3138690-19-dgc@kernel.org>
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

The inode create and quota off log items are each a single fixed size region.
Recovery trusted the region layout decoded from the journal without checking
that it matched.

Validate both against their fixed shape as they are decoded. A shared region
count check rejects anything other than a single region, and each type checks
its one region is exactly the format structure size.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_log_recover.h |  1 +
 fs/xfs/xfs_dquot_item_recover.c | 18 ++++++++++++++++++
 fs/xfs/xfs_icreate_item.c       | 18 ++++++++++++++++++
 fs/xfs/xfs_log_recover.c        | 25 ++++++++++++++++++++-----
 4 files changed, 57 insertions(+), 5 deletions(-)

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
index b8854316ac75..980d1f24c1d5 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -208,8 +208,26 @@ xlog_recover_quotaoff_commit_pass1(
 	return 0;
 }
 
+static int
+xlog_recover_quotaoff_validate_region(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	int				region_index)
+{
+	if (item->ri_buf[region_index].iov_len !=
+			sizeof(struct xfs_qoff_logformat)) {
+		xfs_warn(log->l_mp, "QOFF: bad item region length %zu recovered.",
+				item->ri_buf[region_index].iov_len);
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
index b353362587cb..77fddcad868f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2224,14 +2224,25 @@ xlog_recover_nregions(
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
@@ -2271,8 +2282,12 @@ xlog_recover_add_item(
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

