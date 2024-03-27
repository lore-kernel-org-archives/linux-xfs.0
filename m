Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6676B1CF92
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 02:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504809; cv=none; b=aTGtml5X/oAvcWWU3XFFA9DZPovbLHL1M0AeMhS5gruL1cMLZFitETa7eA57/d5qKUGQNRQi0RxxQpYeE7gGVohnWmFcEeEXO2IZodBUzFLaW70tylWTfvNZ4T1RabeF0Yal/Xw+X8WqqSHmKH7XfXTQE+ocSiDZW6JFCCNXrmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504809; c=relaxed/simple;
	bh=26CxjmHdSPe3Pzwv0zdS7PA3JIzfHFsWT5OyHK57DwE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QEVp+cRuk41ojYlVfK3MToFTcLGnMwJhyrVgqipi05ou8slVVKO9KY6v3AxJxOmjgaDQNEWd3WYvnNmUyqLEuHy9CJYMPy5cWGJwXWzvUTKvBkZDYLBkeoCu5/l0wIiAVnSvwwOp7UZsQ+2fFItffeQs/YUDONP2H2jrmBIW+Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CnQ2Zo3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CnQ2Zo3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6F5C433F1;
	Wed, 27 Mar 2024 02:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504808;
	bh=26CxjmHdSPe3Pzwv0zdS7PA3JIzfHFsWT5OyHK57DwE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CnQ2Zo3+ggWeVUA0UKstrrbYusBbtMXQDiRBbOndPj8dpn9eTKGjuH4w1oPPhpwUO
	 e5yMGmqclZS1S024H8z46zQ21/sNlZ78IrDO4/Xedtf5RjoRTeiFpHq4wLJPW8ixdX
	 XYVRZLosUO+GMy91lbSWNOBBDb9XOBuGvpOr5NS5Ak2DgTudzx85osvQpsXDRvMmO8
	 3eJ5MH/KNMlxzIgND1AHqmEqxLXu64RVUf9Wa4PKZCqw3WwSADQ7Spd+4c5ORzZPcE
	 7241MbV1wVzyjpj48pe4WOLjGsAKSTaGVRMWOWfOQhAvdOz2Xa2juq+McLtxNGSvEu
	 kjGI6aFQfM3yg==
Date: Tue, 26 Mar 2024 19:00:08 -0700
Subject: [PATCH 06/10] xfs: validate dabtree node buffer owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150382224.3217370.8991205171144124549.stgit@frogsfrogsfrogs>
In-Reply-To: <171150382098.3217370.5208665628669220587.stgit@frogsfrogsfrogs>
References: <171150382098.3217370.5208665628669220587.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_btree.c |  108 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_da_btree.h |    1 
 fs/xfs/xfs_attr_list.c       |    9 ++++
 3 files changed, 118 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 65eef87751871..3505629043f0b 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -252,6 +252,25 @@ xfs_da3_node_verify(
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
@@ -266,6 +285,8 @@ xfs_da3_header_check(
 	switch (hdr->magic) {
 	case cpu_to_be16(XFS_ATTR3_LEAF_MAGIC):
 		return xfs_attr3_leaf_header_check(bp, owner);
+	case cpu_to_be16(XFS_DA3_NODE_MAGIC):
+		return xfs_da3_node_header_check(bp, owner);
 	}
 
 	return NULL;
@@ -1218,6 +1239,7 @@ xfs_da3_root_join(
 	struct xfs_da3_icnode_hdr oldroothdr;
 	int			error;
 	struct xfs_inode	*dp = state->args->dp;
+	xfs_failaddr_t		fa;
 
 	trace_xfs_da_root_join(state->args);
 
@@ -1244,6 +1266,13 @@ xfs_da3_root_join(
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
@@ -1278,6 +1307,7 @@ xfs_da3_node_toosmall(
 	struct xfs_da_blkinfo	*info;
 	xfs_dablk_t		blkno;
 	struct xfs_buf		*bp;
+	xfs_failaddr_t		fa;
 	struct xfs_da3_icnode_hdr nodehdr;
 	int			count;
 	int			forward;
@@ -1352,6 +1382,13 @@ xfs_da3_node_toosmall(
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
@@ -1674,6 +1711,13 @@ xfs_da3_node_lookup_int(
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
@@ -1846,6 +1890,7 @@ xfs_da3_blk_link(
 	struct xfs_da_blkinfo	*tmp_info;
 	struct xfs_da_args	*args;
 	struct xfs_buf		*bp;
+	xfs_failaddr_t		fa;
 	int			before = 0;
 	int			error;
 	struct xfs_inode	*dp = state->args->dp;
@@ -1889,6 +1934,13 @@ xfs_da3_blk_link(
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
@@ -1910,6 +1962,13 @@ xfs_da3_blk_link(
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
@@ -1939,6 +1998,7 @@ xfs_da3_blk_unlink(
 	struct xfs_da_blkinfo	*tmp_info;
 	struct xfs_da_args	*args;
 	struct xfs_buf		*bp;
+	xfs_failaddr_t		fa;
 	int			error;
 
 	/*
@@ -1969,6 +2029,13 @@ xfs_da3_blk_unlink(
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
@@ -1986,6 +2053,13 @@ xfs_da3_blk_unlink(
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
@@ -2101,6 +2175,12 @@ xfs_da3_path_shift(
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
@@ -2406,6 +2486,13 @@ xfs_da3_swap_lastblock(
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
@@ -2427,6 +2514,13 @@ xfs_da3_swap_lastblock(
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
@@ -2450,6 +2544,13 @@ xfs_da3_swap_lastblock(
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
@@ -2499,6 +2600,13 @@ xfs_da3_swap_lastblock(
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
index f6496e33ff91b..6a621f016f040 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -239,6 +239,10 @@ xfs_attr_node_list_lookup(
 			goto out_corruptbuf;
 		}
 
+		fa = xfs_da3_node_header_check(bp, dp->i_ino);
+		if (fa)
+			goto out_corruptbuf;
+
 		xfs_da3_node_hdr_from_disk(mp, &nodehdr, node);
 
 		/* Tree taller than we can handle; bail out! */
@@ -335,6 +339,11 @@ xfs_attr_node_list(
 		case XFS_DA_NODE_MAGIC:
 		case XFS_DA3_NODE_MAGIC:
 			trace_xfs_attr_list_wrong_blk(context);
+			fa = xfs_da3_node_header_check(bp, dp->i_ino);
+			if (fa) {
+				__xfs_buf_mark_corrupt(bp, fa);
+				xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
+			}
 			xfs_trans_brelse(context->tp, bp);
 			bp = NULL;
 			break;

