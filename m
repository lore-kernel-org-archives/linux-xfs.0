Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183E63EAC76
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871371; cv=none; b=TDUob8lTNjTUs5HhuVS1Dc6lMy9kkGP+c9RL+jl+2Ox3mIGla6Q7wUzA/YEdSr9PV0nnyDa9e97KJ6995xD5j+mCQ+s6+CjMCoM79BUJzyHCbTYgtVVgowrU0rKvBZL37n5MmOVd+jcRJ1czN7ub37z49nGKAfdy97FcaY1Uvlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871371; c=relaxed/simple;
	bh=Mddx4af3zgZjcSlaZUmKVC6ZPwitpP6uyWux7xegjBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AfvpEql9agdROgOXhY1OlxlNHhP8xH2LVtK1GPV5P5BrraOsEL783IH93wb77VeTgkAyfOwW27OXbM9p3kas7TtBRMYK0B6+psO7jJz1uNo5PMUV1vWuRxCZhQ8MErmf0C+RVp4oigdoH/Qbqw3vD9/ov0Hn9MkQnS27Tt/cb9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mjoSkZrD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mjoSkZrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 368CF1F000FF;
	Tue, 13 Oct 2026 06:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871370;
	bh=9E0t1ooD5nslJovIqNUePHct+aLIy5HysrpW/mjFJzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mjoSkZrDF16Tx1Cv88kTskNNfCgEBd01j9cKdy0cqxgXl5ryk4RIGOHiHiaGLKFnE
	 WxiyZqpCiF20afiTxM+PPicMZ+7xPIJFo3gw0B/gRh39D+0CHn2hS4GhYg0ceXMqNA
	 kKr4Uap44MYUROGDjVILGKeP/j2miQzsnXNG81Bk2Jg4ZdbHQZh9xReL4U8JRDS837
	 E25Ur7lR8pIJR706BxLDbJWecu9OM2uHJ5ZJK0uuapTYZi9svfkezgtTMsQgLnaNzs
	 F3UrMDfyKjpYrdVuSJMWjplKFiE1Z2XRdib4NJmUbcvBDFezyI6xEU1XiqyOhOmDM8
	 qCyUhBYWNkY9A==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 33/48] xfs: convert inode items to host format during recovery
Date: Tue, 13 Oct 2026 17:01:23 +1100
Message-ID: <20261013060204.3138690-34-dgc@kernel.org>
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
index 8da95131ab55..48acb0aa3b6c 100644
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
+	in_f = kmalloc_obj(struct xfs_inode_log_format, GFP_KERNEL | __GFP_NOFAIL);
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

