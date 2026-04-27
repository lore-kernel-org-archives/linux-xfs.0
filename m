Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108C23128CA
	for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2026 12:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777291780; cv=none; b=cJPr3mttq2vjMWhYjenAf5PISvQipTmWKpOmrXYwEEFDqcz0ALjQ1bEkd4dkYLOCnkDZw/APrR2BIm3BHt7LcgXrUMCMw5Nm8X7N+wJi8VOC+zHU6IIPuFUIGCCWuyLSNCPRQ8ejRjed2HS+fm5Wy3lyuLp/JgY2SYoqxa5VX+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777291780; c=relaxed/simple;
	bh=RKBZ+S3lR6IxsPnsv5mfvhkWB7YXBvZdCyruelUVJA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtMRgXtBW1t/VZPTusH3DrTt6FPgt44/3NzRXCmQNX/xUMKr5r4T6wzDFZGgRU41jZmW/bEhQgPGLMQLtLTlgM/bYoRIhc/gCAXTmBJyllbQNHm5/c6QGL+C9WaSE9AeFYwGauC4b42VrynrhmEDIoBYsgiqhDRMnlHAwXe99uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lFU2lEfs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lFU2lEfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178CBC19425;
	Mon, 27 Apr 2026 12:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777291779;
	bh=RKBZ+S3lR6IxsPnsv5mfvhkWB7YXBvZdCyruelUVJA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFU2lEfs3kxpY0WVcBIiYX4GzgZ/TR+oX8uEJFX3XTyAmMKOMcKRJ6fsIUGTjIIh+
	 t1A0RlhVZQXgMpu/zqiW0aw+wnZwTjIJGWoVMC+isNDGdagofP/3c8K3jjoH/Omxye
	 iHenoVi+RbtqKH3aZcEKVHCeunE7njLQev8xzo4At4WrbTQpPSqIL72+3/gsgAJp0m
	 GmI4VbnwHgfyRDWK33iGyf9DgrQ/CQ+IP26Ui4RLPs6rf0tMr/NVGiftEHS2iLbxXW
	 68/V7EvcKs9bfsl7KNzuj/bIxS/wpNmuj8WzdfRZr6D5aqXacY632yhBF5Od0bK/A/
	 qa2g6oPjlct/g==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	hch@lst.de,
	leo.lilong@huawei.com,
	morbo@google.com,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 2/3] xfs: factor out xfs_attr3_node_entry_remove
Date: Mon, 27 Apr 2026 14:09:07 +0200
Message-ID: <20260427120908.52254-3-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260427120908.52254-1-aalbersh@kernel.org>
References: <20260427120908.52254-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Long Li <leo.lilong@huawei.com>

Source kernel commit: ce4e789cf3561c9fac73cc24445bfed9ea0c514b

Factor out wrapper xfs_attr3_node_entry_remove function, which
exported for external use.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Long Li <leo.lilong@huawei.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_da_btree.c | 53 ++++++++++++++++++++++++++++++++++---------
 libxfs/xfs_da_btree.h |  2 ++
 2 files changed, 44 insertions(+), 11 deletions(-)

diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 2fce657af5d0..508fd1475c00 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -1502,21 +1502,20 @@ xfs_da3_fixhashpath(
 }
 
 /*
- * Remove an entry from an intermediate node.
+ * Internal implementation to remove an entry from an intermediate node.
  */
 STATIC void
-xfs_da3_node_remove(
-	struct xfs_da_state	*state,
-	struct xfs_da_state_blk	*drop_blk)
+__xfs_da3_node_remove(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	struct xfs_da_geometry  *geo,
+	struct xfs_da_state_blk *drop_blk)
 {
 	struct xfs_da_intnode	*node;
 	struct xfs_da3_icnode_hdr nodehdr;
 	struct xfs_da_node_entry *btree;
 	int			index;
 	int			tmp;
-	struct xfs_inode	*dp = state->args->dp;
-
-	trace_xfs_da_node_remove(state->args);
 
 	node = drop_blk->bp->b_addr;
 	xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr, node);
@@ -1532,17 +1531,17 @@ xfs_da3_node_remove(
 		tmp  = nodehdr.count - index - 1;
 		tmp *= (uint)sizeof(xfs_da_node_entry_t);
 		memmove(&btree[index], &btree[index + 1], tmp);
-		xfs_trans_log_buf(state->args->trans, drop_blk->bp,
+		xfs_trans_log_buf(tp, drop_blk->bp,
 		    XFS_DA_LOGRANGE(node, &btree[index], tmp));
 		index = nodehdr.count - 1;
 	}
 	memset(&btree[index], 0, sizeof(xfs_da_node_entry_t));
-	xfs_trans_log_buf(state->args->trans, drop_blk->bp,
+	xfs_trans_log_buf(tp, drop_blk->bp,
 	    XFS_DA_LOGRANGE(node, &btree[index], sizeof(btree[index])));
 	nodehdr.count -= 1;
 	xfs_da3_node_hdr_to_disk(dp->i_mount, node, &nodehdr);
-	xfs_trans_log_buf(state->args->trans, drop_blk->bp,
-	    XFS_DA_LOGRANGE(node, &node->hdr, state->args->geo->node_hdr_size));
+	xfs_trans_log_buf(tp, drop_blk->bp,
+	    XFS_DA_LOGRANGE(node, &node->hdr, geo->node_hdr_size));
 
 	/*
 	 * Copy the last hash value from the block to propagate upwards.
@@ -1550,6 +1549,38 @@ xfs_da3_node_remove(
 	drop_blk->hashval = be32_to_cpu(btree[index - 1].hashval);
 }
 
+/*
+ * Remove an entry from an intermediate node.
+ */
+STATIC void
+xfs_da3_node_remove(
+	struct xfs_da_state	*state,
+	struct xfs_da_state_blk	*drop_blk)
+{
+	trace_xfs_da_node_remove(state->args);
+
+	__xfs_da3_node_remove(state->args->trans, state->args->dp,
+			state->args->geo, drop_blk);
+}
+
+/*
+ * Remove an entry from an intermediate attr node at the specified index.
+ */
+void
+xfs_attr3_node_entry_remove(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	struct xfs_buf		*bp,
+	int			index)
+{
+	struct xfs_da_state_blk blk = {
+		.index		= index,
+		.bp		= bp,
+	};
+
+	__xfs_da3_node_remove(tp, dp, dp->i_mount->m_attr_geo, &blk);
+}
+
 /*
  * Unbalance the elements between two intermediate nodes,
  * move all Btree elements from one node into another.
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index 354d5d65043e..afcf2d3c7a21 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -184,6 +184,8 @@ int	xfs_da3_split(xfs_da_state_t *state);
 int	xfs_da3_join(xfs_da_state_t *state);
 void	xfs_da3_fixhashpath(struct xfs_da_state *state,
 			    struct xfs_da_state_path *path_to_to_fix);
+void	xfs_attr3_node_entry_remove(struct xfs_trans *tp, struct xfs_inode *dp,
+			    struct xfs_buf *bp, int index);
 
 /*
  * Routines used for finding things in the Btree.
-- 
2.51.2

