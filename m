Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BD7C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M2dDauJz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4316C433C8;
	Sun, 31 Dec 2023 22:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062014;
	bh=M66T3WE97h+2uo9602Yu00K+GIFcZZ40vOlUhjJnrG8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=M2dDauJz+SXdb1MlbZBFMj3EnVkUgsQXvDt76KmV/AdHD7rVvDcG0btXZ2E9R6DZW
	 84IewB6Lp+xU9BLfVMa2QvfxmaWyOW86q6ijsl/4ifC1lImYKrjBkEK7eha697JOR0
	 ge1XBtcV30vej+mxoMZr3iwn2tRpzitfsgrw0XZcm5mZ+2GN0iizb9+VpDH6PdEMEB
	 pcv3zvQ/L9te7fn5kGqYwz2TAS0PBLYt7kWgzYpoJOL7l+6ctdBjEsQb5B4sWDS+oD
	 nVDr+NPqXWuNr6gGkYcq+m3JijOoHC1GK76yrtJdASBsFnerBGq/pVMkfnVt39qwTs
	 KUUp6xHDWeBOA==
Date: Sun, 31 Dec 2023 14:33:34 -0800
Subject: [PATCH 5/9] xfs: validate dabtree node buffer owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404996935.1796662.7932669643131262064.stgit@frogsfrogsfrogs>
In-Reply-To: <170404996860.1796662.9605761412685436403.stgit@frogsfrogsfrogs>
References: <170404996860.1796662.9605761412685436403.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Check the owner field of dabtree node blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_da_btree.c |  108 +++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_da_btree.h |    1 
 2 files changed, 109 insertions(+)


diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index a33c4acbd1d..92eae433a5a 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -247,6 +247,25 @@ xfs_da3_node_verify(
 	return NULL;
 }
 
+xfs_failaddr_t
+xfs_da3_node_header_check(
+	struct xfs_buf		*bp,
+	xfs_ino_t		owner)
+{
+	struct xfs_mount	*mp = bp->b_mount;
+
+	if (xfs_has_crc(mp)) {
+		struct xfs_da3_blkinfo *hdr3 = bp->b_addr;
+
+		ASSERT(hdr3->hdr.magic == cpu_to_be16(XFS_DA3_NODE_MAGIC));
+
+		if (be64_to_cpu(hdr3->owner) != owner)
+			return __this_address;
+	}
+
+	return NULL;
+}
+
 xfs_failaddr_t
 xfs_da3_header_check(
 	struct xfs_buf		*bp,
@@ -261,6 +280,8 @@ xfs_da3_header_check(
 	switch (hdr->magic) {
 	case cpu_to_be16(XFS_ATTR3_LEAF_MAGIC):
 		return xfs_attr3_leaf_header_check(bp, owner);
+	case cpu_to_be16(XFS_DA3_NODE_MAGIC):
+		return xfs_da3_node_header_check(bp, owner);
 	}
 
 	return NULL;
@@ -1213,6 +1234,7 @@ xfs_da3_root_join(
 	struct xfs_da3_icnode_hdr oldroothdr;
 	int			error;
 	struct xfs_inode	*dp = state->args->dp;
+	xfs_failaddr_t		fa;
 
 	trace_xfs_da_root_join(state->args);
 
@@ -1239,6 +1261,13 @@ xfs_da3_root_join(
 	error = xfs_da3_node_read(args->trans, dp, child, &bp, args->whichfork);
 	if (error)
 		return error;
+	fa = xfs_da3_header_check(bp, args->owner);
+	if (fa) {
+		__xfs_buf_mark_corrupt(bp, fa);
+		xfs_trans_brelse(args->trans, bp);
+		xfs_da_mark_sick(args);
+		return -EFSCORRUPTED;
+	}
 	xfs_da_blkinfo_onlychild_validate(bp->b_addr, oldroothdr.level);
 
 	/*
@@ -1273,6 +1302,7 @@ xfs_da3_node_toosmall(
 	struct xfs_da_blkinfo	*info;
 	xfs_dablk_t		blkno;
 	struct xfs_buf		*bp;
+	xfs_failaddr_t		fa;
 	struct xfs_da3_icnode_hdr nodehdr;
 	int			count;
 	int			forward;
@@ -1347,6 +1377,13 @@ xfs_da3_node_toosmall(
 				state->args->whichfork);
 		if (error)
 			return error;
+		fa = xfs_da3_node_header_check(bp, state->args->owner);
+		if (fa) {
+			__xfs_buf_mark_corrupt(bp, fa);
+			xfs_trans_brelse(state->args->trans, bp);
+			xfs_da_mark_sick(state->args);
+			return -EFSCORRUPTED;
+		}
 
 		node = bp->b_addr;
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &thdr, node);
@@ -1669,6 +1706,13 @@ xfs_da3_node_lookup_int(
 			return -EFSCORRUPTED;
 		}
 
+		fa = xfs_da3_node_header_check(blk->bp, args->owner);
+		if (fa) {
+			__xfs_buf_mark_corrupt(blk->bp, fa);
+			xfs_da_mark_sick(args);
+			return -EFSCORRUPTED;
+		}
+
 		blk->magic = XFS_DA_NODE_MAGIC;
 
 		/*
@@ -1841,6 +1885,7 @@ xfs_da3_blk_link(
 	struct xfs_da_blkinfo	*tmp_info;
 	struct xfs_da_args	*args;
 	struct xfs_buf		*bp;
+	xfs_failaddr_t		fa;
 	int			before = 0;
 	int			error;
 	struct xfs_inode	*dp = state->args->dp;
@@ -1884,6 +1929,13 @@ xfs_da3_blk_link(
 						&bp, args->whichfork);
 			if (error)
 				return error;
+			fa = xfs_da3_header_check(bp, args->owner);
+			if (fa) {
+				__xfs_buf_mark_corrupt(bp, fa);
+				xfs_trans_brelse(args->trans, bp);
+				xfs_da_mark_sick(args);
+				return -EFSCORRUPTED;
+			}
 			ASSERT(bp != NULL);
 			tmp_info = bp->b_addr;
 			ASSERT(tmp_info->magic == old_info->magic);
@@ -1905,6 +1957,13 @@ xfs_da3_blk_link(
 						&bp, args->whichfork);
 			if (error)
 				return error;
+			fa = xfs_da3_header_check(bp, args->owner);
+			if (fa) {
+				__xfs_buf_mark_corrupt(bp, fa);
+				xfs_trans_brelse(args->trans, bp);
+				xfs_da_mark_sick(args);
+				return -EFSCORRUPTED;
+			}
 			ASSERT(bp != NULL);
 			tmp_info = bp->b_addr;
 			ASSERT(tmp_info->magic == old_info->magic);
@@ -1934,6 +1993,7 @@ xfs_da3_blk_unlink(
 	struct xfs_da_blkinfo	*tmp_info;
 	struct xfs_da_args	*args;
 	struct xfs_buf		*bp;
+	xfs_failaddr_t		fa;
 	int			error;
 
 	/*
@@ -1964,6 +2024,13 @@ xfs_da3_blk_unlink(
 						&bp, args->whichfork);
 			if (error)
 				return error;
+			fa = xfs_da3_header_check(bp, args->owner);
+			if (fa) {
+				__xfs_buf_mark_corrupt(bp, fa);
+				xfs_trans_brelse(args->trans, bp);
+				xfs_da_mark_sick(args);
+				return -EFSCORRUPTED;
+			}
 			ASSERT(bp != NULL);
 			tmp_info = bp->b_addr;
 			ASSERT(tmp_info->magic == save_info->magic);
@@ -1981,6 +2048,13 @@ xfs_da3_blk_unlink(
 						&bp, args->whichfork);
 			if (error)
 				return error;
+			fa = xfs_da3_header_check(bp, args->owner);
+			if (fa) {
+				__xfs_buf_mark_corrupt(bp, fa);
+				xfs_trans_brelse(args->trans, bp);
+				xfs_da_mark_sick(args);
+				return -EFSCORRUPTED;
+			}
 			ASSERT(bp != NULL);
 			tmp_info = bp->b_addr;
 			ASSERT(tmp_info->magic == save_info->magic);
@@ -2096,6 +2170,12 @@ xfs_da3_path_shift(
 		switch (be16_to_cpu(info->magic)) {
 		case XFS_DA_NODE_MAGIC:
 		case XFS_DA3_NODE_MAGIC:
+			fa = xfs_da3_node_header_check(blk->bp, args->owner);
+			if (fa) {
+				__xfs_buf_mark_corrupt(blk->bp, fa);
+				xfs_da_mark_sick(args);
+				return -EFSCORRUPTED;
+			}
 			blk->magic = XFS_DA_NODE_MAGIC;
 			xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr,
 						   bp->b_addr);
@@ -2400,6 +2480,13 @@ xfs_da3_swap_lastblock(
 		error = xfs_da3_node_read(tp, dp, sib_blkno, &sib_buf, w);
 		if (error)
 			goto done;
+		fa = xfs_da3_header_check(sib_buf, args->owner);
+		if (fa) {
+			__xfs_buf_mark_corrupt(sib_buf, fa);
+			xfs_da_mark_sick(args);
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		sib_info = sib_buf->b_addr;
 		if (XFS_IS_CORRUPT(mp,
 				   be32_to_cpu(sib_info->forw) != last_blkno ||
@@ -2421,6 +2508,13 @@ xfs_da3_swap_lastblock(
 		error = xfs_da3_node_read(tp, dp, sib_blkno, &sib_buf, w);
 		if (error)
 			goto done;
+		fa = xfs_da3_header_check(sib_buf, args->owner);
+		if (fa) {
+			__xfs_buf_mark_corrupt(sib_buf, fa);
+			xfs_da_mark_sick(args);
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		sib_info = sib_buf->b_addr;
 		if (XFS_IS_CORRUPT(mp,
 				   be32_to_cpu(sib_info->back) != last_blkno ||
@@ -2444,6 +2538,13 @@ xfs_da3_swap_lastblock(
 		error = xfs_da3_node_read(tp, dp, par_blkno, &par_buf, w);
 		if (error)
 			goto done;
+		fa = xfs_da3_node_header_check(par_buf, args->owner);
+		if (fa) {
+			__xfs_buf_mark_corrupt(par_buf, fa);
+			xfs_da_mark_sick(args);
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		par_node = par_buf->b_addr;
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &par_hdr, par_node);
 		if (XFS_IS_CORRUPT(mp,
@@ -2493,6 +2594,13 @@ xfs_da3_swap_lastblock(
 		error = xfs_da3_node_read(tp, dp, par_blkno, &par_buf, w);
 		if (error)
 			goto done;
+		fa = xfs_da3_node_header_check(par_buf, args->owner);
+		if (fa) {
+			__xfs_buf_mark_corrupt(par_buf, fa);
+			xfs_da_mark_sick(args);
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		par_node = par_buf->b_addr;
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &par_hdr, par_node);
 		if (XFS_IS_CORRUPT(mp, par_hdr.level != level)) {
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index 99618e0c8a7..7a004786ee0 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -237,6 +237,7 @@ void	xfs_da3_node_hdr_from_disk(struct xfs_mount *mp,
 void	xfs_da3_node_hdr_to_disk(struct xfs_mount *mp,
 		struct xfs_da_intnode *to, struct xfs_da3_icnode_hdr *from);
 xfs_failaddr_t xfs_da3_header_check(struct xfs_buf *bp, xfs_ino_t owner);
+xfs_failaddr_t xfs_da3_node_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 
 extern struct kmem_cache	*xfs_da_state_cache;
 

