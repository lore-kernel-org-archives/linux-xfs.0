Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23D62D3217
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 05:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752556598; cv=none; b=TriIsGKplAQJPogAQXbS7r+9l5gW3+QFGGjhlO/9bj79IKrd85jmI6DHzSbAqnb0jFGwe6IvIXtaxOHHYaKnw6o8VqHkypRWeEUh1u0xAsJCHssFgsBJ26oUc2zEugI/xMgR+CIPb2TXmdk9JVWulgm6Bu2HpIbNus4/d+piWPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752556598; c=relaxed/simple;
	bh=b3QsqoqYcDaKgS2gIs1lhiYy4MtOXplEWNWvaGQ3dKM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hveRW9RupsuDnpQtv6KFJyzofUQAO4J9RGzbm7AUJy0K0v/95OmGdI4D/3M/fPTLGfGdkg/afvCF8P5lcFAWkbFx7NaOXJ1ccsoGkEPqwCUIHyFmk4TwIGerCGQdJ1B4WJbvAZ/ImPJDVyYxn0/86g6gOAVZNzmR8cLMYCznZLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fwV7FgzI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fwV7FgzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2AEC4CEE3;
	Tue, 15 Jul 2025 05:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752556598;
	bh=b3QsqoqYcDaKgS2gIs1lhiYy4MtOXplEWNWvaGQ3dKM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fwV7FgzIbiNPqzS/HCbOHxEA/ooUJPMU6P4qjAGfIW0h3HCCCZmJuQwTsaXPDfNo0
	 zGnlBGXnov22iQ0JW7RQfQb1xnkaY95pPPTwAG7tJCg33/Y/b6nnuRyO222rhA2lMf
	 w0WfQcRLYDucOQrTrFeluer/h3B3f3c7Tm3WjG2Y3jRRi3oRNmH6fsro1hfLGP4Jhr
	 epdx8CRwG5SPD116OTvOPJAyIZNIpaqozd7ocJFLdd6kh7AUOCmtxPujXZW1My+Xsa
	 nUWjVRo/CrtTvEAdTKeTHxvJ1VHraUZ46seR1d/UPrwUX5ix86XVY9m1U+0mf9T67U
	 aCQbD6qP1o1bQ==
Date: Mon, 14 Jul 2025 22:16:37 -0700
Subject: [PATCH 1/6] xfs: add helpers to compute transaction reservation for
 finishing intent items
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: john.g.garry@oracle.com, catherine.hoang@oracle.com,
 john.g.garry@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <175255652130.1830720.11838512013292511854.stgit@frogsfrogsfrogs>
In-Reply-To: <175255652087.1830720.17606543077660806130.stgit@frogsfrogsfrogs>
References: <175255652087.1830720.17606543077660806130.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 805f89881252a9aee30799b8a395deec79c13414

In the transaction reservation code, hoist the logic that computes the
reservation needed to finish one log intent item into separate helper
functions.  These will be used in subsequent patches to estimate the
number of blocks that an online repair can commit to reaping in the same
transaction as the change committing the new data structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 libxfs/xfs_trans_resv.h |   18 +++++
 libxfs/xfs_trans_resv.c |  165 ++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 152 insertions(+), 31 deletions(-)


diff --git a/libxfs/xfs_trans_resv.h b/libxfs/xfs_trans_resv.h
index 0554b9d775d269..d9d0032cbbc5d4 100644
--- a/libxfs/xfs_trans_resv.h
+++ b/libxfs/xfs_trans_resv.h
@@ -98,6 +98,24 @@ struct xfs_trans_resv {
 void xfs_trans_resv_calc(struct xfs_mount *mp, struct xfs_trans_resv *resp);
 uint xfs_allocfree_block_count(struct xfs_mount *mp, uint num_ops);
 
+unsigned int xfs_calc_finish_bui_reservation(struct xfs_mount *mp,
+		unsigned int nr_ops);
+
+unsigned int xfs_calc_finish_efi_reservation(struct xfs_mount *mp,
+		unsigned int nr_ops);
+unsigned int xfs_calc_finish_rt_efi_reservation(struct xfs_mount *mp,
+		unsigned int nr_ops);
+
+unsigned int xfs_calc_finish_rui_reservation(struct xfs_mount *mp,
+		unsigned int nr_ops);
+unsigned int xfs_calc_finish_rt_rui_reservation(struct xfs_mount *mp,
+		unsigned int nr_ops);
+
+unsigned int xfs_calc_finish_cui_reservation(struct xfs_mount *mp,
+		unsigned int nr_ops);
+unsigned int xfs_calc_finish_rt_cui_reservation(struct xfs_mount *mp,
+		unsigned int nr_ops);
+
 unsigned int xfs_calc_itruncate_reservation_minlogsize(struct xfs_mount *mp);
 unsigned int xfs_calc_write_reservation_minlogsize(struct xfs_mount *mp);
 unsigned int xfs_calc_qm_dqalloc_reservation_minlogsize(struct xfs_mount *mp);
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 4034c52790de8b..0a843deb50a118 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -260,6 +260,42 @@ xfs_rtalloc_block_count(
  * register overflow from temporaries in the calculations.
  */
 
+/*
+ * Finishing a data device refcount updates (t1):
+ *    the agfs of the ags containing the blocks: nr_ops * sector size
+ *    the refcount btrees: nr_ops * 1 trees * (2 * max depth - 1) * block size
+ */
+inline unsigned int
+xfs_calc_finish_cui_reservation(
+	struct xfs_mount	*mp,
+	unsigned int		nr_ops)
+{
+	if (!xfs_has_reflink(mp))
+		return 0;
+
+	return xfs_calc_buf_res(nr_ops, mp->m_sb.sb_sectsize) +
+	       xfs_calc_buf_res(xfs_refcountbt_block_count(mp, nr_ops),
+			       mp->m_sb.sb_blocksize);
+}
+
+/*
+ * Realtime refcount updates (t2);
+ *    the rt refcount inode
+ *    the rtrefcount btrees: nr_ops * 1 trees * (2 * max depth - 1) * block size
+ */
+inline unsigned int
+xfs_calc_finish_rt_cui_reservation(
+	struct xfs_mount	*mp,
+	unsigned int		nr_ops)
+{
+	if (!xfs_has_rtreflink(mp))
+		return 0;
+
+	return xfs_calc_inode_res(mp, 1) +
+	       xfs_calc_buf_res(xfs_rtrefcountbt_block_count(mp, nr_ops),
+				     mp->m_sb.sb_blocksize);
+}
+
 /*
  * Compute the log reservation required to handle the refcount update
  * transaction.  Refcount updates are always done via deferred log items.
@@ -277,19 +313,10 @@ xfs_calc_refcountbt_reservation(
 	struct xfs_mount	*mp,
 	unsigned int		nr_ops)
 {
-	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
-	unsigned int		t1, t2 = 0;
+	unsigned int		t1, t2;
 
-	if (!xfs_has_reflink(mp))
-		return 0;
-
-	t1 = xfs_calc_buf_res(nr_ops, mp->m_sb.sb_sectsize) +
-	     xfs_calc_buf_res(xfs_refcountbt_block_count(mp, nr_ops), blksz);
-
-	if (xfs_has_realtime(mp))
-		t2 = xfs_calc_inode_res(mp, 1) +
-		     xfs_calc_buf_res(xfs_rtrefcountbt_block_count(mp, nr_ops),
-				     blksz);
+	t1 = xfs_calc_finish_cui_reservation(mp, nr_ops);
+	t2 = xfs_calc_finish_rt_cui_reservation(mp, nr_ops);
 
 	return max(t1, t2);
 }
@@ -376,6 +403,96 @@ xfs_calc_write_reservation_minlogsize(
 	return xfs_calc_write_reservation(mp, true);
 }
 
+/*
+ * Finishing an EFI can free the blocks and bmap blocks (t2):
+ *    the agf for each of the ags: nr * sector size
+ *    the agfl for each of the ags: nr * sector size
+ *    the super block to reflect the freed blocks: sector size
+ *    worst case split in allocation btrees per extent assuming nr extents:
+ *		nr exts * 2 trees * (2 * max depth - 1) * block size
+ */
+inline unsigned int
+xfs_calc_finish_efi_reservation(
+	struct xfs_mount	*mp,
+	unsigned int		nr)
+{
+	return xfs_calc_buf_res((2 * nr) + 1, mp->m_sb.sb_sectsize) +
+	       xfs_calc_buf_res(xfs_allocfree_block_count(mp, nr),
+			       mp->m_sb.sb_blocksize);
+}
+
+/*
+ * Or, if it's a realtime file (t3):
+ *    the agf for each of the ags: 2 * sector size
+ *    the agfl for each of the ags: 2 * sector size
+ *    the super block to reflect the freed blocks: sector size
+ *    the realtime bitmap:
+ *		2 exts * ((XFS_BMBT_MAX_EXTLEN / rtextsize) / NBBY) bytes
+ *    the realtime summary: 2 exts * 1 block
+ *    worst case split in allocation btrees per extent assuming 2 extents:
+ *		2 exts * 2 trees * (2 * max depth - 1) * block size
+ */
+inline unsigned int
+xfs_calc_finish_rt_efi_reservation(
+	struct xfs_mount	*mp,
+	unsigned int		nr)
+{
+	if (!xfs_has_realtime(mp))
+		return 0;
+
+	return xfs_calc_buf_res((2 * nr) + 1, mp->m_sb.sb_sectsize) +
+	       xfs_calc_buf_res(xfs_rtalloc_block_count(mp, nr),
+			       mp->m_sb.sb_blocksize) +
+	       xfs_calc_buf_res(xfs_allocfree_block_count(mp, nr),
+			       mp->m_sb.sb_blocksize);
+}
+
+/*
+ * Finishing an RUI is the same as an EFI.  We can split the rmap btree twice
+ * on each end of the record, and that can cause the AGFL to be refilled or
+ * emptied out.
+ */
+inline unsigned int
+xfs_calc_finish_rui_reservation(
+	struct xfs_mount	*mp,
+	unsigned int		nr)
+{
+	if (!xfs_has_rmapbt(mp))
+		return 0;
+	return xfs_calc_finish_efi_reservation(mp, nr);
+}
+
+/*
+ * Finishing an RUI is the same as an EFI.  We can split the rmap btree twice
+ * on each end of the record, and that can cause the AGFL to be refilled or
+ * emptied out.
+ */
+inline unsigned int
+xfs_calc_finish_rt_rui_reservation(
+	struct xfs_mount	*mp,
+	unsigned int		nr)
+{
+	if (!xfs_has_rtrmapbt(mp))
+		return 0;
+	return xfs_calc_finish_rt_efi_reservation(mp, nr);
+}
+
+/*
+ * In finishing a BUI, we can modify:
+ *    the inode being truncated: inode size
+ *    dquots
+ *    the inode's bmap btree: (max depth + 1) * block size
+ */
+inline unsigned int
+xfs_calc_finish_bui_reservation(
+	struct xfs_mount	*mp,
+	unsigned int		nr)
+{
+	return xfs_calc_inode_res(mp, 1) + XFS_DQUOT_LOGRES +
+	       xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1,
+			       mp->m_sb.sb_blocksize);
+}
+
 /*
  * In truncating a file we free up to two extents at once.  We can modify (t1):
  *    the inode being truncated: inode size
@@ -408,16 +525,8 @@ xfs_calc_itruncate_reservation(
 	t1 = xfs_calc_inode_res(mp, 1) +
 	     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1, blksz);
 
-	t2 = xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
-	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 4), blksz);
-
-	if (xfs_has_realtime(mp)) {
-		t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_rtalloc_block_count(mp, 2), blksz) +
-		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 2), blksz);
-	} else {
-		t3 = 0;
-	}
+	t2 = xfs_calc_finish_efi_reservation(mp, 4);
+	t3 = xfs_calc_finish_rt_efi_reservation(mp, 2);
 
 	/*
 	 * In the early days of reflink, we included enough reservation to log
@@ -498,9 +607,7 @@ xfs_calc_rename_reservation(
 	     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
 			XFS_FSB_TO_B(mp, 1));
 
-	t2 = xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
-	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 3),
-			XFS_FSB_TO_B(mp, 1));
+	t2 = xfs_calc_finish_efi_reservation(mp, 3);
 
 	if (xfs_has_parent(mp)) {
 		unsigned int	rename_overhead, exchange_overhead;
@@ -608,9 +715,7 @@ xfs_calc_link_reservation(
 	overhead += xfs_calc_iunlink_remove_reservation(mp);
 	t1 = xfs_calc_inode_res(mp, 2) +
 	     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
-	t2 = xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
-	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1),
-			      XFS_FSB_TO_B(mp, 1));
+	t2 = xfs_calc_finish_efi_reservation(mp, 1);
 
 	if (xfs_has_parent(mp)) {
 		t3 = resp->tr_attrsetm.tr_logres;
@@ -673,9 +778,7 @@ xfs_calc_remove_reservation(
 
 	t1 = xfs_calc_inode_res(mp, 2) +
 	     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
-	t2 = xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
-	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 2),
-			      XFS_FSB_TO_B(mp, 1));
+	t2 = xfs_calc_finish_efi_reservation(mp, 2);
 
 	if (xfs_has_parent(mp)) {
 		t3 = resp->tr_attrrm.tr_logres;

