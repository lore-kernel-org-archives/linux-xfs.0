Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871089;
	b=y578ckn0HTTDlo7iOo0y5jaBSdCn9lPWan5OLcxsGyQY0Zj+U9P2Pj4uq9dz4vQ+1xfG
	 Xh5MURJzCv6LGB0nXxRlloCwiWrb0mHa6KH+wlt20nRWMAyybXpTFx6xx25raKAF5V57W
	 RZ6/I5b/pMDJO91MhuF8m0txGHjmMYD4HZ1T1U4YJUFFCE16Epz/ClbtIY0adryte/PcR
	 Fa6Stg/ynGp/MCNdBeQxCLWLRVUhVzRsWjf8xx/FAoSFYrTeLS4noQmQuli1UZkMwy45E
	 lm5IWREax29lIeTTopSw6KySXp74uu7Fdt0OL2B7uxLKG06DYngjMy8asHdS7wg0Dtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=NPKjiC27GIWcB5NPhm8dq1gp7Wf9eAkbHKirT4VhJjA=;
	b=ns+SXVfvrI9gOa1rvuIyCNXICsQJGEYK/PYOPAEm7DrGliResYxGOnlJoSzSMPOSB3Pt
	 FIVn0r7rjVAr+dsI8XU7so8Tg74u1v30UX/1qMHqVJyFH7GjM2BKZfqXE4vFK6vRgumhi
	 IzSJNGID9mbFVer20v3UmC/oOPLijTtn9EA+WJEaQA/Tb0xcf52UVgfG24vkIPnpaQweA
	 6Ukdh6gqM1+lg8Zx2QMc4Cz6ijAgHU6Gd7Nhu5O3XgF7CcNzPqL5ZRqNQ55u9p/s7hHPJ
	 dDwaynhRMUbuYrO9lW8uTYrHbxl2xC+pRC0FJz4vvHYhoCBm6oIuf6NneNSZRHrDd6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dYa6S8lQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B544A606A323
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dYa6S8lQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E1D1F000C5;
	Mon, 16 Nov 2026 23:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871089;
	bh=NPKjiC27GIWcB5NPhm8dq1gp7Wf9eAkbHKirT4VhJjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dYa6S8lQn2tcf+LUV4hkxWFe2u+FDX3EIWcH/nFg+n3ZWl7XgFwKGeR25gEaYuOiR
	 LB7ezLRSLx94I52V24P//799RcBaikxj6POHW9+WR3xgToQsuZRd++KI00x6N4isJy
	 oFOcKAjeBgMliJpPAjEMxyg0XKEmiX3CHv6jgAzJEhBnhM0UOWslXOeMxddm5dMaih
	 eFox5Z6JMryUgdBKBngTQ7B9Bk/Zy3BtE3OnB3o0be3XR7EWp+0/+BC1YvtgLgwBDS
	 8WXVPRvMCFg6KajN+7H/EtDypRRZoOQLdQUVwFB0aREaduj7xDkIcoaK1ssM1xwSQT
	 NwfC1gP5BNLVg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 43/59] xfs: convert inode items to host format during recovery
Date: Tue, 17 Nov 2026 10:15:00 +1100
Message-ID: <20261116231707.3625263-44-dgc@kernel.org>
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

The inode item format header is logged in either the host format or the older
32 bit on-disk format. Recovery converted between them in the commit handler
and carried a separately allocated copy through the rest of the function.

Convert the format header to host format in ->validate_item() as the item is
decoded, so the rest of recovery treats region 0 as a host format header
without regard for the on-disk format. The commit handler and readahead now use
the header directly. The separate allocation and its cleanup are removed.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_inode_item_recover.c | 108 +++++++++++++++++++++++---------
 1 file changed, 79 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 8da95131ab55..2c7a5627158b 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -30,17 +30,10 @@ xlog_recover_inode_ra_pass2(
 	struct xlog                     *log,
 	struct xlog_recover_item        *item)
 {
-	if (item->ri_buf[0].iov_len == sizeof(struct xfs_inode_log_format)) {
-		struct xfs_inode_log_format	*ilfp = item->ri_buf[0].iov_base;
+	struct xfs_inode_log_format	*ilfp = item->ri_buf[0].iov_base;
 
-		xlog_buf_readahead(log, ilfp->ilf_blkno, ilfp->ilf_len,
-				   &xfs_inode_buf_ra_ops);
-	} else {
-		struct xfs_inode_log_format_32	*ilfp = item->ri_buf[0].iov_base;
-
-		xlog_buf_readahead(log, ilfp->ilf_blkno, ilfp->ilf_len,
-				   &xfs_inode_buf_ra_ops);
-	}
+	xlog_buf_readahead(log, ilfp->ilf_blkno, ilfp->ilf_len,
+			   &xfs_inode_buf_ra_ops);
 }
 
 /*
@@ -304,6 +297,75 @@ xlog_recover_inode_dbroot(
 	return 0;
 }
 
+/*
+ * An inode item is a format header region, the log dinode core, and up to two
+ * fork regions, so it has two to four regions. The exact count depends on the
+ * fields logged and is checked once the format header is decoded.
+ */
+static int
+xlog_recover_inode_nregions(
+	struct xlog			*log,
+	uint16_t			nregions)
+{
+	if (nregions < 2 || nregions > 4)
+		return -EFSCORRUPTED;
+	return nregions;
+}
+
+/*
+ * The format header (region 0) is logged in either the host format or the 32
+ * bit on-disk format, so it must match one of those two sizes.
+ */
+static int
+xlog_recover_inode_validate_region(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	int				region_index)
+{
+	size_t				len = item->ri_buf[region_index].iov_len;
+
+	if (region_index > 0)
+		return 0;
+
+	if (len != sizeof(struct xfs_inode_log_format) &&
+	    len != sizeof(struct xfs_inode_log_format_32)) {
+		xfs_warn(log->l_mp,
+			"INODE: bad format region length %zu recovered.", len);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
+/*
+ * Convert the format header to host format so the rest of recovery can treat
+ * region 0 as a struct xfs_inode_log_format without regard for the on-disk
+ * format. A header already in host format is left in place.
+ */
+static int
+xlog_recover_inode_validate_item(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_inode_log_format	*in_f;
+	int				error;
+
+	if (item->ri_buf[0].iov_len == sizeof(struct xfs_inode_log_format))
+		return 0;
+
+	in_f = kzalloc_obj(struct xfs_inode_log_format, GFP_KERNEL | __GFP_NOFAIL);
+	error = xfs_inode_item_format_convert(&item->ri_buf[0], in_f);
+	if (error) {
+		kfree(in_f);
+		return error;
+	}
+
+	kvfree(item->ri_buf[0].iov_base);
+	item->ri_buf[0].iov_base = in_f;
+	item->ri_buf[0].iov_len = sizeof(struct xfs_inode_log_format);
+	return 0;
+}
+
 STATIC int
 xlog_recover_inode_commit_pass2(
 	struct xlog			*log,
@@ -311,7 +373,7 @@ xlog_recover_inode_commit_pass2(
 	struct xlog_recover_item	*item,
 	xfs_lsn_t			current_lsn)
 {
-	struct xfs_inode_log_format	*in_f;
+	struct xfs_inode_log_format	*in_f = item->ri_buf[0].iov_base;
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_buf			*bp;
 	struct xfs_dinode		*dip;
@@ -323,35 +385,22 @@ xlog_recover_inode_commit_pass2(
 	uint				fields;
 	struct xfs_log_dinode		*ldip;
 	uint				isize;
-	int				need_free = 0;
 	xfs_failaddr_t			fa;
 
-	if (item->ri_buf[0].iov_len == sizeof(struct xfs_inode_log_format)) {
-		in_f = item->ri_buf[0].iov_base;
-	} else {
-		in_f = kmalloc_obj(struct xfs_inode_log_format,
-				   GFP_KERNEL | __GFP_NOFAIL);
-		need_free = 1;
-		error = xfs_inode_item_format_convert(&item->ri_buf[0], in_f);
-		if (error)
-			goto error;
-	}
-
 	/*
 	 * Inode buffers can be freed, look out for it,
 	 * and do not replay the inode.
 	 */
 	if (xlog_is_buffer_cancelled(log, in_f->ilf_blkno, in_f->ilf_len)) {
-		error = 0;
 		trace_xfs_log_recover_inode_cancel(log, in_f);
-		goto error;
+		return 0;
 	}
 	trace_xfs_log_recover_inode_recover(log, in_f);
 
 	error = xfs_buf_read(mp->m_ddev_targp, in_f->ilf_blkno, in_f->ilf_len,
 			0, &bp, &xfs_inode_buf_ops);
 	if (error)
-		goto error;
+		return error;
 	ASSERT(in_f->ilf_fields & XFS_ILOG_CORE);
 	dip = xfs_buf_offset(bp, in_f->ilf_boffset);
 
@@ -608,14 +657,15 @@ xlog_recover_inode_commit_pass2(
 
 out_release:
 	xfs_buf_relse(bp);
-error:
-	if (need_free)
-		kfree(in_f);
 	return error;
 }
 
 const struct xlog_recover_item_ops xlog_inode_item_ops = {
 	.item_type		= XFS_LI_INODE,
+	.min_hdr_len		= sizeof(struct xfs_inode_log_format_32),
+	.validate_nregions	= xlog_recover_inode_nregions,
+	.validate_region	= xlog_recover_inode_validate_region,
+	.validate_item		= xlog_recover_inode_validate_item,
 	.ra_pass2		= xlog_recover_inode_ra_pass2,
 	.commit_pass2		= xlog_recover_inode_commit_pass2,
 };
-- 
2.55.0

