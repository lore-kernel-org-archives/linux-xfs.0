Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9511C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:59:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235836AbiL3X7B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235840AbiL3X7A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:59:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E8C16588
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:58:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFF0061CAD
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:58:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466BBC433EF;
        Fri, 30 Dec 2022 23:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444738;
        bh=hdEXecwgsJ4w3Q9QWwCNP45Qs4zuslK6HsZCZtBazg4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rUbIZGB1FK+gyyu+1wxHojJDwWE6v1fmrjANac+SlTgrGrTJiE6g2mB9aGIbD+dkM
         gcjnp187VEt0bs8k0Gn2PJionZPX7hsH7QUeNueq5sL3OE/yWx+xMbU6nF2hHy26FY
         lhmmHsW4qjr7USF7VicuDcz5AJxsO/jHSseAjP8vOdwjBp5p8V60aMwU/b3GgAqqqT
         pP7G1AHzpctRjE6bnXyOdVpr2BZCFuV/ESB43n8LuCFEhm43M27FgUbK6zLFvPEKqt
         P+Cf0tL5AZSOT4WPVMzaFUcdEw9ubgklzJAsam5MYNvd1A73wdQIt1hdMcST2IurHU
         yiFSFP1srVr8Q==
Subject: [PATCH 6/9] xfs: validate directory leaf buffer owners
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:09 -0800
Message-ID: <167243844920.700244.1435356997655532082.stgit@magnolia>
In-Reply-To: <167243844821.700244.10251762547708755105.stgit@magnolia>
References: <167243844821.700244.10251762547708755105.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Check the owner field of directory leaf blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_btree.c  |   16 ++++++++++
 fs/xfs/libxfs/xfs_dir2.h      |    2 +
 fs/xfs/libxfs/xfs_dir2_leaf.c |   64 +++++++++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_dir2_node.c |    3 +-
 fs/xfs/libxfs/xfs_dir2_priv.h |    4 +--
 fs/xfs/scrub/dir.c            |    2 +
 6 files changed, 81 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 1b4771b0ac50..89bf350f3f1c 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -286,8 +286,12 @@ xfs_da3_header_check(
 		return xfs_attr3_leaf_header_check(bp, owner);
 	case cpu_to_be16(XFS_DA3_NODE_MAGIC):
 		return xfs_da3_node_header_check(bp, owner);
+	case cpu_to_be16(XFS_DIR3_LEAF1_MAGIC):
+	case cpu_to_be16(XFS_DIR3_LEAFN_MAGIC):
+		return xfs_dir3_leaf_header_check(bp, owner);
 	}
 
+	ASSERT(0);
 	return NULL;
 }
 
@@ -1706,6 +1710,12 @@ xfs_da3_node_lookup_int(
 
 		if (magic == XFS_DIR2_LEAFN_MAGIC ||
 		    magic == XFS_DIR3_LEAFN_MAGIC) {
+			fa = xfs_dir3_leaf_header_check(blk->bp, args->owner);
+			if (fa) {
+				__xfs_buf_mark_corrupt(blk->bp, fa);
+				xfs_da_mark_sick(args);
+				return -EFSCORRUPTED;
+			}
 			blk->magic = XFS_DIR2_LEAFN_MAGIC;
 			blk->hashval = xfs_dir2_leaf_lasthash(args->dp,
 							      blk->bp, NULL);
@@ -2214,6 +2224,12 @@ xfs_da3_path_shift(
 			break;
 		case XFS_DIR2_LEAFN_MAGIC:
 		case XFS_DIR3_LEAFN_MAGIC:
+			fa = xfs_dir3_leaf_header_check(blk->bp, args->owner);
+			if (fa) {
+				__xfs_buf_mark_corrupt(blk->bp, fa);
+				xfs_da_mark_sick(args);
+				return -EFSCORRUPTED;
+			}
 			blk->magic = XFS_DIR2_LEAFN_MAGIC;
 			ASSERT(level == path->active-1);
 			blk->index = 0;
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 15a36cf7ae87..b5ad503e47b3 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -89,6 +89,8 @@ extern struct xfs_dir2_data_free *xfs_dir2_data_freefind(
 
 extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
 
+xfs_failaddr_t xfs_dir3_leaf_header_check(struct xfs_buf *bp, xfs_ino_t owner);
+
 extern const struct xfs_buf_ops xfs_dir3_block_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops;
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 20ce057d12e8..16a581e225a3 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -208,6 +208,28 @@ xfs_dir3_leaf_verify(
 	return xfs_dir3_leaf_check_int(mp, &leafhdr, bp->b_addr, true);
 }
 
+xfs_failaddr_t
+xfs_dir3_leaf_header_check(
+	struct xfs_buf		*bp,
+	xfs_ino_t		owner)
+{
+	struct xfs_mount	*mp = bp->b_mount;
+
+	if (xfs_has_crc(mp)) {
+		struct xfs_dir3_leaf *hdr3 = bp->b_addr;
+
+		ASSERT(hdr3->hdr.info.hdr.magic ==
+					cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) ||
+		       hdr3->hdr.info.hdr.magic ==
+					cpu_to_be16(XFS_DIR3_LEAFN_MAGIC));
+
+		if (be64_to_cpu(hdr3->hdr.info.owner) != owner)
+			return __this_address;
+	}
+
+	return NULL;
+}
+
 static void
 xfs_dir3_leaf_read_verify(
 	struct xfs_buf  *bp)
@@ -271,32 +293,60 @@ int
 xfs_dir3_leaf_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
+	xfs_ino_t		owner,
 	xfs_dablk_t		fbno,
 	struct xfs_buf		**bpp)
 {
+	xfs_failaddr_t		fa;
 	int			err;
 
 	err = xfs_da_read_buf(tp, dp, fbno, 0, bpp, XFS_DATA_FORK,
 			&xfs_dir3_leaf1_buf_ops);
-	if (!err && tp && *bpp)
+	if (err || !(*bpp))
+		return err;
+
+	fa = xfs_dir3_leaf_header_check(*bpp, owner);
+	if (fa) {
+		__xfs_buf_mark_corrupt(*bpp, fa);
+		xfs_trans_brelse(tp, *bpp);
+		*bpp = NULL;
+		xfs_dirattr_mark_sick(dp, XFS_DATA_FORK);
+		return -EFSCORRUPTED;
+	}
+
+	if (tp)
 		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_LEAF1_BUF);
-	return err;
+	return 0;
 }
 
 int
 xfs_dir3_leafn_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
+	xfs_ino_t		owner,
 	xfs_dablk_t		fbno,
 	struct xfs_buf		**bpp)
 {
+	xfs_failaddr_t		fa;
 	int			err;
 
 	err = xfs_da_read_buf(tp, dp, fbno, 0, bpp, XFS_DATA_FORK,
 			&xfs_dir3_leafn_buf_ops);
-	if (!err && tp && *bpp)
+	if (err || !(*bpp))
+		return err;
+
+	fa = xfs_dir3_leaf_header_check(*bpp, owner);
+	if (fa) {
+		__xfs_buf_mark_corrupt(*bpp, fa);
+		xfs_trans_brelse(tp, *bpp);
+		*bpp = NULL;
+		xfs_dirattr_mark_sick(dp, XFS_DATA_FORK);
+		return -EFSCORRUPTED;
+	}
+
+	if (tp)
 		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_LEAFN_BUF);
-	return err;
+	return 0;
 }
 
 /*
@@ -646,7 +696,8 @@ xfs_dir2_leaf_addname(
 
 	trace_xfs_dir2_leaf_addname(args);
 
-	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, &lbp);
+	error = xfs_dir3_leaf_read(tp, dp, args->owner, args->geo->leafblk,
+			&lbp);
 	if (error)
 		return error;
 
@@ -1237,7 +1288,8 @@ xfs_dir2_leaf_lookup_int(
 	tp = args->trans;
 	mp = dp->i_mount;
 
-	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, &lbp);
+	error = xfs_dir3_leaf_read(tp, dp, args->owner, args->geo->leafblk,
+			&lbp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 1ad7405f9c38..e21965788188 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1562,7 +1562,8 @@ xfs_dir2_leafn_toosmall(
 		/*
 		 * Read the sibling leaf block.
 		 */
-		error = xfs_dir3_leafn_read(state->args->trans, dp, blkno, &bp);
+		error = xfs_dir3_leafn_read(state->args->trans, dp,
+				state->args->owner, blkno, &bp);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index b10859a43776..8a7b5f030a6c 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -95,9 +95,9 @@ void xfs_dir2_leaf_hdr_from_disk(struct xfs_mount *mp,
 void xfs_dir2_leaf_hdr_to_disk(struct xfs_mount *mp, struct xfs_dir2_leaf *to,
 		struct xfs_dir3_icleaf_hdr *from);
 int xfs_dir3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
-		xfs_dablk_t fbno, struct xfs_buf **bpp);
+		xfs_ino_t owner, xfs_dablk_t fbno, struct xfs_buf **bpp);
 int xfs_dir3_leafn_read(struct xfs_trans *tp, struct xfs_inode *dp,
-		xfs_dablk_t fbno, struct xfs_buf **bpp);
+		xfs_ino_t owner, xfs_dablk_t fbno, struct xfs_buf **bpp);
 extern int xfs_dir2_block_to_leaf(struct xfs_da_args *args,
 		struct xfs_buf *dbp);
 extern int xfs_dir2_leaf_addname(struct xfs_da_args *args);
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 8b4e58416327..81348bea8add 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -463,7 +463,7 @@ xchk_directory_leaf1_bestfree(
 	int				error;
 
 	/* Read the free space block. */
-	error = xfs_dir3_leaf_read(sc->tp, sc->ip, lblk, &bp);
+	error = xfs_dir3_leaf_read(sc->tp, sc->ip, sc->ip->i_ino, lblk, &bp);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
 		return error;
 	xchk_buffer_recheck(sc, bp);

