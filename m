Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8824928EA
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422530; cv=none; b=NbjLFkuFDgLOxHFL3ADhxL2fdzngJ6wDpEUnyc8bqF+jdp0jH15NUYKZ9R/ROvIrLsV4Esn46JtI9IWthW1IrCqnceghZEQBMVSGe5qHwZJL7hMC8JxJEQzHq5ZW786b3VrZ+yYGPGmzjn+Hw3S+XlVPqt/l/klIeKd2edZVZoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422530; c=relaxed/simple;
	bh=KRv9u3RVvCsZo+epQZ+JmiGaOd/0jJshgJ32D4eprfc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NAe0s3Vgj5Ecgeom/nOkz+4oJMl/ivbPFQuEHz9wS6nBgs2Gg0MbMESmlol6nMBW9fLypypJ3T1AgBP/TKg0XnEbYncOsWsOO+ETOYwKpWMa8wj1HqmhDvXOEkise5ASIbBjpQEg9HBhLqzA78WikEU0cJIcdiexZx5cQAjL/XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BG+joAau; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BG+joAau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5551DC433C7;
	Tue, 26 Mar 2024 03:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422530;
	bh=KRv9u3RVvCsZo+epQZ+JmiGaOd/0jJshgJ32D4eprfc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BG+joAau3suiHxcP3XGkjeeIbS9Bg3ILRPFEm7xdvdqMWPpK1hNduRmwBVQbxCdmy
	 h2OmlTCCp2fhiwX+fdAXifzfUkR11ZhYDul1xOPR+1+nb4PLx4YY12Um+JzPOjjZhl
	 JKcVJRxf6cznPYbL1ZF3yRqisVqgQaPl8tH5q+MhkHITsvL5Jg7D8GQbrc/EiKJd2v
	 vFHfEnqSSpXke/sSgFTTN9Bu0ul/pLiEVE84+0l7GNIsEBgLZnl+Z9esV0SgZNlb0T
	 6EEWMztRiL8Tf5G2JMB9dX2POaRHF5+tLWhzzabTlgVzgA5XFwJ+3z7McWJa6tquiQ
	 QuLDFIdyj860A==
Date: Mon, 25 Mar 2024 20:08:49 -0700
Subject: [PATCH 23/67] xfs: extract xfs_da_buf_copy() helper function
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Zhang Tianci <zhangtianci.1997@bytedance.com>,
 Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@lst.de>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127294.2212320.4730571109977235505.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Zhang Tianci <zhangtianci.1997@bytedance.com>

Source kernel commit: fd45ddb9dd606b3eaddf26e13f64340636955986

This patch does not modify logic.

xfs_da_buf_copy() will copy one block from src xfs_buf to
dst xfs_buf, and update the block metadata in dst directly.

Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_attr_leaf.c |   12 +++-----
 libxfs/xfs_da_btree.c  |   74 +++++++++++++++++++-----------------------------
 libxfs/xfs_da_btree.h  |    2 +
 3 files changed, 36 insertions(+), 52 deletions(-)


diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index ed81471ce066..baa168318f91 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1241,14 +1241,10 @@ xfs_attr3_leaf_to_node(
 	if (error)
 		goto out;
 
-	/* copy leaf to new buffer, update identifiers */
-	xfs_trans_buf_set_type(args->trans, bp2, XFS_BLFT_ATTR_LEAF_BUF);
-	bp2->b_ops = bp1->b_ops;
-	memcpy(bp2->b_addr, bp1->b_addr, args->geo->blksize);
-	if (xfs_has_crc(mp)) {
-		struct xfs_da3_blkinfo *hdr3 = bp2->b_addr;
-		hdr3->blkno = cpu_to_be64(xfs_buf_daddr(bp2));
-	}
+	/*
+	 * Copy leaf to new buffer and log it.
+	 */
+	xfs_da_buf_copy(bp2, bp1, args->geo->blksize);
 	xfs_trans_log_buf(args->trans, bp2, 0, args->geo->blksize - 1);
 
 	/*
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 3903486d19d2..0779bb6242ca 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -417,6 +417,25 @@ xfs_da3_node_read_mapped(
 	return xfs_da3_node_set_type(tp, *bpp);
 }
 
+/*
+ * Copy src directory/attr leaf/node buffer to the dst.
+ * For v5 file systems make sure the right blkno is stamped in.
+ */
+void
+xfs_da_buf_copy(
+	struct xfs_buf *dst,
+	struct xfs_buf *src,
+	size_t size)
+{
+	struct xfs_da3_blkinfo *da3 = dst->b_addr;
+
+	memcpy(dst->b_addr, src->b_addr, size);
+	dst->b_ops = src->b_ops;
+	xfs_trans_buf_copy_type(dst, src);
+	if (xfs_has_crc(dst->b_mount))
+		da3->blkno = cpu_to_be64(xfs_buf_daddr(dst));
+}
+
 /*========================================================================
  * Routines used for growing the Btree.
  *========================================================================*/
@@ -686,12 +705,6 @@ xfs_da3_root_split(
 		btree = icnodehdr.btree;
 		size = (int)((char *)&btree[icnodehdr.count] - (char *)oldroot);
 		level = icnodehdr.level;
-
-		/*
-		 * we are about to copy oldroot to bp, so set up the type
-		 * of bp while we know exactly what it will be.
-		 */
-		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DA_NODE_BUF);
 	} else {
 		struct xfs_dir3_icleaf_hdr leafhdr;
 
@@ -703,31 +716,17 @@ xfs_da3_root_split(
 		size = (int)((char *)&leafhdr.ents[leafhdr.count] -
 			(char *)leaf);
 		level = 0;
-
-		/*
-		 * we are about to copy oldroot to bp, so set up the type
-		 * of bp while we know exactly what it will be.
-		 */
-		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DIR_LEAFN_BUF);
 	}
 
 	/*
-	 * we can copy most of the information in the node from one block to
-	 * another, but for CRC enabled headers we have to make sure that the
-	 * block specific identifiers are kept intact. We update the buffer
-	 * directly for this.
+	 * Copy old root to new buffer and log it.
 	 */
-	memcpy(node, oldroot, size);
-	if (oldroot->hdr.info.magic == cpu_to_be16(XFS_DA3_NODE_MAGIC) ||
-	    oldroot->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC)) {
-		struct xfs_da3_intnode *node3 = (struct xfs_da3_intnode *)node;
-
-		node3->hdr.info.blkno = cpu_to_be64(xfs_buf_daddr(bp));
-	}
+	xfs_da_buf_copy(bp, blk1->bp, size);
 	xfs_trans_log_buf(tp, bp, 0, size - 1);
 
-	bp->b_ops = blk1->bp->b_ops;
-	xfs_trans_buf_copy_type(bp, blk1->bp);
+	/*
+	 * Update blk1 to point to new buffer.
+	 */
 	blk1->bp = bp;
 	blk1->blkno = blkno;
 
@@ -1216,21 +1215,14 @@ xfs_da3_root_join(
 	xfs_da_blkinfo_onlychild_validate(bp->b_addr, oldroothdr.level);
 
 	/*
-	 * This could be copying a leaf back into the root block in the case of
-	 * there only being a single leaf block left in the tree. Hence we have
-	 * to update the b_ops pointer as well to match the buffer type change
-	 * that could occur. For dir3 blocks we also need to update the block
-	 * number in the buffer header.
+	 * Copy child to root buffer and log it.
 	 */
-	memcpy(root_blk->bp->b_addr, bp->b_addr, args->geo->blksize);
-	root_blk->bp->b_ops = bp->b_ops;
-	xfs_trans_buf_copy_type(root_blk->bp, bp);
-	if (oldroothdr.magic == XFS_DA3_NODE_MAGIC) {
-		struct xfs_da3_blkinfo *da3 = root_blk->bp->b_addr;
-		da3->blkno = cpu_to_be64(xfs_buf_daddr(root_blk->bp));
-	}
+	xfs_da_buf_copy(root_blk->bp, bp, args->geo->blksize);
 	xfs_trans_log_buf(args->trans, root_blk->bp, 0,
 			  args->geo->blksize - 1);
+	/*
+	 * Now we can drop the child buffer.
+	 */
 	error = xfs_da_shrink_inode(args, child, bp);
 	return error;
 }
@@ -2312,14 +2304,8 @@ xfs_da3_swap_lastblock(
 		return error;
 	/*
 	 * Copy the last block into the dead buffer and log it.
-	 * On CRC-enabled file systems, also update the stamped in blkno.
 	 */
-	memcpy(dead_buf->b_addr, last_buf->b_addr, args->geo->blksize);
-	if (xfs_has_crc(mp)) {
-		struct xfs_da3_blkinfo *da3 = dead_buf->b_addr;
-
-		da3->blkno = cpu_to_be64(xfs_buf_daddr(dead_buf));
-	}
+	xfs_da_buf_copy(dead_buf, last_buf, args->geo->blksize);
 	xfs_trans_log_buf(tp, dead_buf, 0, args->geo->blksize - 1);
 	dead_info = dead_buf->b_addr;
 
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index ffa3df5b2893..706baf36e175 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -219,6 +219,8 @@ int	xfs_da_reada_buf(struct xfs_inode *dp, xfs_dablk_t bno,
 		const struct xfs_buf_ops *ops);
 int	xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
 					  struct xfs_buf *dead_buf);
+void	xfs_da_buf_copy(struct xfs_buf *dst, struct xfs_buf *src,
+			size_t size);
 
 uint xfs_da_hashname(const uint8_t *name_string, int name_length);
 enum xfs_dacmp xfs_da_compname(struct xfs_da_args *args,

