Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F7D65C
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299309; cv=none; b=Au/YkDHqIuZQyiX65lx3LBiDOCWmR/PCeZziygKwYtZ6zWmIYB+kmyVlIsgZVTdH1ubPqQACgAqIWayc10PXtXyxbHnBdh0mS75eigHWy/9wf43ubZLi6mbcPmZDXkqUSNEH9sHbrkj5IpXjaAXGxjqRy6OCrFAQPZNhzKol9QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299309; c=relaxed/simple;
	bh=wMEls1dpmUCqbpjk9TUwvukXV6ZnWskH/DcQYRaXHbc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ogPHC2fLSvX3kPwCVWj3SkKs6Z2+BMCXX3eq4qI2mvdlHhn2cA6UU869V+C4SrKUor/TkUgk9eLHMXq4ot3mcI//wzUXflSfbPI4qlUosczQXD8NtHb4lxyIYkPmLYMWpYOM0Zu9DM7MyeVlFqFniiFE17xdDq3cE7tHyJqOM3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P6LcF2WE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P6LcF2WE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6E0C32786;
	Tue, 30 Jul 2024 00:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299308;
	bh=wMEls1dpmUCqbpjk9TUwvukXV6ZnWskH/DcQYRaXHbc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=P6LcF2WEmlx2gCdd6avysUDd6wC49gf1mOYND64esV2K8GF321y35KYo8H2pQ7aeM
	 9U2X9wcMFBXkcCt4BYHSGSfRAxgK5DgpQmf1/bqMVQzrbETlyFbuv1uo0Z8J6qa0jg
	 BqktYjKlHGDWH1ufzkQy1IdiXrfJKp7hcBp1X/tjx2grncgD3G3H5N6zLSe47GSA7K
	 orx6egM1NpEn+ieKSGp6IDrxyv/wL8w0bq0mgukRognfhBaHY3+SqhDX/WoErzSm5z
	 nc57WYEoIa1oRNY/Ik71peSuAIzoJlgBYSyOO+f3/U9vEp9STe16Qf5PgLCTACvCYj
	 5fRugIQsbKRCA==
Date: Mon, 29 Jul 2024 17:28:28 -0700
Subject: [PATCH 018/115] xfs: validate dabtree node buffer owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842695.1338752.11118531122403269518.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: d44bea9b41ca25f91fd9f25ed2cc3bb2f6dab4bc

Check the owner field of dabtree node blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_da_btree.c |  109 +++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_da_btree.h |    1 
 2 files changed, 110 insertions(+)


diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 28fd87c2d..c221cbba4 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -248,6 +248,26 @@ xfs_da3_node_verify(
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
+		if (hdr3->hdr.magic != cpu_to_be16(XFS_DA3_NODE_MAGIC))
+			return __this_address;
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
@@ -262,6 +282,8 @@ xfs_da3_header_check(
 	switch (hdr->magic) {
 	case cpu_to_be16(XFS_ATTR3_LEAF_MAGIC):
 		return xfs_attr3_leaf_header_check(bp, owner);
+	case cpu_to_be16(XFS_DA3_NODE_MAGIC):
+		return xfs_da3_node_header_check(bp, owner);
 	}
 
 	return NULL;
@@ -1214,6 +1236,7 @@ xfs_da3_root_join(
 	struct xfs_da3_icnode_hdr oldroothdr;
 	int			error;
 	struct xfs_inode	*dp = state->args->dp;
+	xfs_failaddr_t		fa;
 
 	trace_xfs_da_root_join(state->args);
 
@@ -1240,6 +1263,13 @@ xfs_da3_root_join(
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
@@ -1274,6 +1304,7 @@ xfs_da3_node_toosmall(
 	struct xfs_da_blkinfo	*info;
 	xfs_dablk_t		blkno;
 	struct xfs_buf		*bp;
+	xfs_failaddr_t		fa;
 	struct xfs_da3_icnode_hdr nodehdr;
 	int			count;
 	int			forward;
@@ -1348,6 +1379,13 @@ xfs_da3_node_toosmall(
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
@@ -1670,6 +1708,13 @@ xfs_da3_node_lookup_int(
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
@@ -1842,6 +1887,7 @@ xfs_da3_blk_link(
 	struct xfs_da_blkinfo	*tmp_info;
 	struct xfs_da_args	*args;
 	struct xfs_buf		*bp;
+	xfs_failaddr_t		fa;
 	int			before = 0;
 	int			error;
 	struct xfs_inode	*dp = state->args->dp;
@@ -1885,6 +1931,13 @@ xfs_da3_blk_link(
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
@@ -1906,6 +1959,13 @@ xfs_da3_blk_link(
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
@@ -1935,6 +1995,7 @@ xfs_da3_blk_unlink(
 	struct xfs_da_blkinfo	*tmp_info;
 	struct xfs_da_args	*args;
 	struct xfs_buf		*bp;
+	xfs_failaddr_t		fa;
 	int			error;
 
 	/*
@@ -1965,6 +2026,13 @@ xfs_da3_blk_unlink(
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
@@ -1982,6 +2050,13 @@ xfs_da3_blk_unlink(
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
@@ -2097,6 +2172,12 @@ xfs_da3_path_shift(
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
@@ -2402,6 +2483,13 @@ xfs_da3_swap_lastblock(
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
@@ -2423,6 +2511,13 @@ xfs_da3_swap_lastblock(
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
@@ -2446,6 +2541,13 @@ xfs_da3_swap_lastblock(
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
@@ -2495,6 +2597,13 @@ xfs_da3_swap_lastblock(
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
index 99618e0c8..7a004786e 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -237,6 +237,7 @@ void	xfs_da3_node_hdr_from_disk(struct xfs_mount *mp,
 void	xfs_da3_node_hdr_to_disk(struct xfs_mount *mp,
 		struct xfs_da_intnode *to, struct xfs_da3_icnode_hdr *from);
 xfs_failaddr_t xfs_da3_header_check(struct xfs_buf *bp, xfs_ino_t owner);
+xfs_failaddr_t xfs_da3_node_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 
 extern struct kmem_cache	*xfs_da_state_cache;
 

