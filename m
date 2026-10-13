Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A4D3988E3
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871385; cv=none; b=pfRVSVFtQLi2jDU6U66++lRY6pwPm3k+JGHJyA+E9rWpln8qQRRhXq/7aWr2e/0W1zEUAy45lSg3zaIfjm8XaWjAFh9CaGRxxe4dj4gUfjYF7YUlgyuz9JK4TndJmwJOZex6YLJbar2BxkDq6tue1gnxPQAkz2EB+CAFA/agS1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871385; c=relaxed/simple;
	bh=q4/4883hm4V5Dswfnm/HBtrrfrXmNPa3f8gIRoXFON4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L07ktW11ue8JZ4w41zLDVep8Q9i8Wmy6rNR7vCV7i8sGxxwVAv8++yBuFXar3GGF99VPSYFlLnUOtgoKGs6jGmBBdQil2n9cndCVuUa9pH/4RlmkBsBO4ykAQvTwax3/oSEprJ4ue1xXUAxe8UVEBvLX6H9R3YOPZTtcNoNHVeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ki1NL1YZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ki1NL1YZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406031F00893;
	Tue, 13 Oct 2026 06:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871384;
	bh=S/pGFd5RbKoUAzM0VkEuf4O1gdZHOcJ7EnRHT8+v2sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ki1NL1YZNBn9qloJHNGR0bidwYKGXAl4W5WPHiy5fSGFkHMF/FP73zrRf/Xw/7//2
	 BVm+WzYsYBCUIZHfSJC5+6f3udhN5vo2dN83FJ5RxeRhMCqXvw4mn5+Yhp758Jcew2
	 AW8eZNk8ZhTyOhSKVkUsApeNDWBogLduI9yNqvGttxPDNp1ku9pVn/psrkYe7bbBXL
	 iEm/ZlPS/gue9/3dORbkO+OvHcNEpDJZiX9P51aWf0KEFwg5TasiVccm+iudMc8gNm
	 6RCUKmZkVj7NcC0reGxZNxgifPxjYm1RVVauVDg4qURAPmHfQHs1Y2Rq0G8anSLFE2
	 oFNL3iICf8FMg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 44/48] xfs: validate buffer item regions during recovery
Date: Tue, 13 Oct 2026 17:01:34 +1100
Message-ID: <20261013060204.3138690-45-dgc@kernel.org>
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

Validate each region of a buffer log item as it is decoded from the journal.
The format header must hold a dirty bitmap that fits within the region, and each
dirty range region must cover whole chunks of the buffer.

The fixed prefix of the format header is checked through min_hdr_len, so the
region check only has to bound the used part of the dirty bitmap against the
region.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c | 46 +++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 52253b426166..8cae5287e4fb 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -1189,9 +1189,55 @@ xlog_recover_buf_nregions(
 	return nregions;
 }
 
+/*
+ * Region 0 is the format header. The fixed prefix is already checked by
+ * min_hdr_len, so check that the used part of the dirty bitmap does not exceed
+ * the bitmap and fits within the region. Later regions are the dirty ranges of
+ * the buffer, each covering whole chunks of it. The region length has already
+ * been bounds checked against XLOG_MAX_REGION_SIZE during assembly, so only the
+ * lower bound and chunk alignment are checked here.
+ */
+static int
+xlog_recover_buf_validate_region(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	int				region_index)
+{
+	size_t				len = item->ri_buf[region_index].iov_len;
+
+	if (region_index == 0) {
+		struct xfs_buf_log_format *blf = item->ri_buf[0].iov_base;
+
+		if (blf->blf_map_size > XFS_BLF_DATAMAP_SIZE) {
+			xfs_warn(log->l_mp,
+				"BUF: bad dirty bitmap size %u recovered.",
+				blf->blf_map_size);
+			return -EFSCORRUPTED;
+		}
+		if (!xfs_buf_log_check_iovec(&item->ri_buf[0])) {
+			xfs_warn(log->l_mp,
+				"BUF: bad format region length %zu recovered.",
+				len);
+			return -EFSCORRUPTED;
+		}
+		return 0;
+	}
+
+	if (len == 0 || (len % XFS_BLF_CHUNK)) {
+		xfs_warn(log->l_mp,
+			"BUF: bad region %d length %zu recovered.",
+			region_index, len);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
 const struct xlog_recover_item_ops xlog_buf_item_ops = {
 	.item_type		= XFS_LI_BUF,
+	.min_hdr_len		= offsetof(struct xfs_buf_log_format, blf_data_map),
 	.validate_nregions	= xlog_recover_buf_nregions,
+	.validate_region	= xlog_recover_buf_validate_region,
 	.reorder		= xlog_recover_buf_reorder,
 	.ra_pass2		= xlog_recover_buf_ra_pass2,
 	.commit_pass1		= xlog_recover_buf_commit_pass1,
-- 
2.55.0

