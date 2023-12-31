Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D7CF9CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="diBIgP9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD3CC433C8;
	Sun, 31 Dec 2023 20:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054834;
	bh=KesRlWHHM+JRB1DZfuXS8QQqK4YzJkNq9kCvVQKanw4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=diBIgP9ocLj3sIp8paNp9JgkgTGGPeBOZWE084Gp51AYhp6mO2cm6zSbvUEiniSsp
	 jnYuhFGs1iWQeza2yXsQclFzmad31BJbQxscvC+gGA1IkVF/lECPxbZRXxMGfV8xdA
	 QdqcGF9YJHX2a38tPZ3zvGAv5IbR/KtAymycnHK9Pt0OF1k9lovxYAFsQQfyAYntVm
	 44n/9n55HF/rvngtO5IaFnCZDUz1D4jtYS0cvCskLSsIuRUa7gep+/iHZ+yhSVf3gA
	 YZE0yPc1o6ndBuyEa5SUrkPBR5yxxQtiIpC9IGWpW/nm09lVzaZZjg1gL12hd6heVB
	 5uyJZjfeWDkFA==
Date: Sun, 31 Dec 2023 12:33:53 -0800
Subject: [PATCH 5/9] xfs: validate dabtree node buffer owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404834781.1753044.10729728103632248031.stgit@frogsfrogsfrogs>
In-Reply-To: <170404834676.1753044.18168629400918360020.stgit@frogsfrogsfrogs>
References: <170404834676.1753044.18168629400918360020.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_da_btree.c |  108 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_da_btree.h |    1 
 fs/xfs/xfs_attr_list.c       |   10 ++++
 3 files changed, 119 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index a7782055db6cd..61719f6093ec8 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -251,6 +251,25 @@ xfs_da3_node_verify(
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
@@ -265,6 +284,8 @@ xfs_da3_header_check(
 	switch (hdr->magic) {
 	case cpu_to_be16(XFS_ATTR3_LEAF_MAGIC):
 		return xfs_attr3_leaf_header_check(bp, owner);
+	case cpu_to_be16(XFS_DA3_NODE_MAGIC):
+		return xfs_da3_node_header_check(bp, owner);
 	}
 
 	return NULL;
@@ -1217,6 +1238,7 @@ xfs_da3_root_join(
 	struct xfs_da3_icnode_hdr oldroothdr;
 	int			error;
 	struct xfs_inode	*dp = state->args->dp;
+	xfs_failaddr_t		fa;
 
 	trace_xfs_da_root_join(state->args);
 
@@ -1243,6 +1265,13 @@ xfs_da3_root_join(
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
@@ -1277,6 +1306,7 @@ xfs_da3_node_toosmall(
 	struct xfs_da_blkinfo	*info;
 	xfs_dablk_t		blkno;
 	struct xfs_buf		*bp;
+	xfs_failaddr_t		fa;
 	struct xfs_da3_icnode_hdr nodehdr;
 	int			count;
 	int			forward;
@@ -1351,6 +1381,13 @@ xfs_da3_node_toosmall(
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
@@ -1673,6 +1710,13 @@ xfs_da3_node_lookup_int(
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
@@ -1845,6 +1889,7 @@ xfs_da3_blk_link(
 	struct xfs_da_blkinfo	*tmp_info;
 	struct xfs_da_args	*args;
 	struct xfs_buf		*bp;
+	xfs_failaddr_t		fa;
 	int			before = 0;
 	int			error;
 	struct xfs_inode	*dp = state->args->dp;
@@ -1888,6 +1933,13 @@ xfs_da3_blk_link(
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
@@ -1909,6 +1961,13 @@ xfs_da3_blk_link(
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
@@ -1938,6 +1997,7 @@ xfs_da3_blk_unlink(
 	struct xfs_da_blkinfo	*tmp_info;
 	struct xfs_da_args	*args;
 	struct xfs_buf		*bp;
+	xfs_failaddr_t		fa;
 	int			error;
 
 	/*
@@ -1968,6 +2028,13 @@ xfs_da3_blk_unlink(
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
@@ -1985,6 +2052,13 @@ xfs_da3_blk_unlink(
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
@@ -2100,6 +2174,12 @@ xfs_da3_path_shift(
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
@@ -2404,6 +2484,13 @@ xfs_da3_swap_lastblock(
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
@@ -2425,6 +2512,13 @@ xfs_da3_swap_lastblock(
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
@@ -2448,6 +2542,13 @@ xfs_da3_swap_lastblock(
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
@@ -2497,6 +2598,13 @@ xfs_da3_swap_lastblock(
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
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 99618e0c8a72b..7a004786ee0a2 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -237,6 +237,7 @@ void	xfs_da3_node_hdr_from_disk(struct xfs_mount *mp,
 void	xfs_da3_node_hdr_to_disk(struct xfs_mount *mp,
 		struct xfs_da_intnode *to, struct xfs_da3_icnode_hdr *from);
 xfs_failaddr_t xfs_da3_header_check(struct xfs_buf *bp, xfs_ino_t owner);
+xfs_failaddr_t xfs_da3_node_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 
 extern struct kmem_cache	*xfs_da_state_cache;
 
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 2954ed7cfaf43..24516f3ff2df7 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -240,6 +240,10 @@ xfs_attr_node_list_lookup(
 			goto out_corruptbuf;
 		}
 
+		fa = xfs_da3_node_header_check(bp, dp->i_ino);
+		if (fa)
+			goto out_corruptbuf;
+
 		xfs_da3_node_hdr_from_disk(mp, &nodehdr, node);
 
 		/* Tree taller than we can handle; bail out! */
@@ -334,6 +338,12 @@ xfs_attr_node_list(
 			case XFS_DA_NODE_MAGIC:
 			case XFS_DA3_NODE_MAGIC:
 				trace_xfs_attr_list_wrong_blk(context);
+				fa = xfs_da3_node_header_check(bp,
+						dp->i_ino);
+				if (fa) {
+					__xfs_buf_mark_corrupt(bp, fa);
+					xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
+				}
 				xfs_trans_brelse(context->tp, bp);
 				bp = NULL;
 				break;

