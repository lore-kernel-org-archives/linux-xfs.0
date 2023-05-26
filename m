Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77145C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbjEZBbo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjEZBbn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:31:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DAA9125
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:31:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9505D64C30
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C3EC433D2;
        Fri, 26 May 2023 01:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685064700;
        bh=osY8eSyT2SwG7aLmNGlzFVChaoQnqnhZ46QDqI1lTD0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Y3u60kMwPWRgYWZiu3J+PdnQuGSJQ7TvqYsde046UQ4Gy9KKEES+gKzfUsOq6dlp+
         vMQNFimlGGqxH2eTcEqQSGMXxh70LoWFbU12jLJG9rKjrMb+QTn712H9LdI6OpFx0/
         sOQqhLCWdFxyrl0tLyxYh68/xIzAcRDwFHL2nigENLQkSor2l02is0jvdUI1++2/4d
         uHoBnL3lnlASHUBMOD+UrsAKgXG0CUSmN9Y/db/4P4kcK5sNGaEyAPmyZ482foHHg/
         RHBUFzWf8YfEu8DjezwzGzKxmvspJzbq27r1Gpx4xNnrZDuQMOK0w5gNV54XAJICaO
         JlvaZR7jZKw1Q==
Date:   Thu, 25 May 2023 18:31:39 -0700
Subject: [PATCH 5/9] xfs: validate dabtree node buffer owners
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506066449.3735378.7869287104747705185.stgit@frogsfrogsfrogs>
In-Reply-To: <168506066363.3735378.3534676169269107254.stgit@frogsfrogsfrogs>
References: <168506066363.3735378.3534676169269107254.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Check the owner field of dabtree node blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_btree.c |  108 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_da_btree.h |    1 
 fs/xfs/xfs_attr_list.c       |   10 ++++
 3 files changed, 119 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 0349e10552f6..1b4771b0ac50 100644
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
@@ -1285,6 +1314,7 @@ xfs_da3_node_toosmall(
 	struct xfs_da_blkinfo	*info;
 	xfs_dablk_t		blkno;
 	struct xfs_buf		*bp;
+	xfs_failaddr_t		fa;
 	struct xfs_da3_icnode_hdr nodehdr;
 	int			count;
 	int			forward;
@@ -1359,6 +1389,13 @@ xfs_da3_node_toosmall(
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
@@ -1681,6 +1718,13 @@ xfs_da3_node_lookup_int(
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
@@ -1853,6 +1897,7 @@ xfs_da3_blk_link(
 	struct xfs_da_blkinfo	*tmp_info;
 	struct xfs_da_args	*args;
 	struct xfs_buf		*bp;
+	xfs_failaddr_t		fa;
 	int			before = 0;
 	int			error;
 	struct xfs_inode	*dp = state->args->dp;
@@ -1896,6 +1941,13 @@ xfs_da3_blk_link(
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
@@ -1917,6 +1969,13 @@ xfs_da3_blk_link(
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
@@ -1946,6 +2005,7 @@ xfs_da3_blk_unlink(
 	struct xfs_da_blkinfo	*tmp_info;
 	struct xfs_da_args	*args;
 	struct xfs_buf		*bp;
+	xfs_failaddr_t		fa;
 	int			error;
 
 	/*
@@ -1976,6 +2036,13 @@ xfs_da3_blk_unlink(
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
@@ -1993,6 +2060,13 @@ xfs_da3_blk_unlink(
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
@@ -2108,6 +2182,12 @@ xfs_da3_path_shift(
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
@@ -2411,6 +2491,13 @@ xfs_da3_swap_lastblock(
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
@@ -2432,6 +2519,13 @@ xfs_da3_swap_lastblock(
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
@@ -2455,6 +2549,13 @@ xfs_da3_swap_lastblock(
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
@@ -2504,6 +2605,13 @@ xfs_da3_swap_lastblock(
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
index 0b9e467663b6..1f5b3c3f0deb 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -235,6 +235,7 @@ void	xfs_da3_node_hdr_from_disk(struct xfs_mount *mp,
 void	xfs_da3_node_hdr_to_disk(struct xfs_mount *mp,
 		struct xfs_da_intnode *to, struct xfs_da3_icnode_hdr *from);
 xfs_failaddr_t xfs_da3_header_check(struct xfs_buf *bp, xfs_ino_t owner);
+xfs_failaddr_t xfs_da3_node_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 
 extern struct kmem_cache	*xfs_da_state_cache;
 
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 2954ed7cfaf4..24516f3ff2df 100644
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

