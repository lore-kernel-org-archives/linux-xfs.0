Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C79F9CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HR3InbDc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34E5C433C8;
	Sun, 31 Dec 2023 20:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054849;
	bh=11WC0GM0XMZpT6zKhzifDUZayPs1wUEnZSdE2QIt1P8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HR3InbDcX8SesmFrsKJxNRVpUm2tIoCtrgGjPelgN+000V6qremdhiZ4e0vjrWKpO
	 T0SiuTD6Qnzq3tLdfP8n2PYEYO/KWUVeTTVXqKvdcB0NUHcI3StetxgHr4hi3hSLzI
	 oo5xUdIM34GHgnVUF5XWOqmlsohxhiy3Ue+LstDYuqMXBeyTCpam0geSOzLgYXLQ9H
	 G2fwQQIC7+WTf62MswTWnp7J3zElrWGxvSYMZ4aM7pMS9M2p4Jz6atz/u2HUE1WlKb
	 ZewPliW45x53+JgBTTCFeJhfYqw8guSAswnZ1i2n2BALZDGRLTc5NNFkxyJP9YT1Sn
	 sd9ZiFwueX6pw==
Date: Sun, 31 Dec 2023 12:34:09 -0800
Subject: [PATCH 6/9] xfs: validate directory leaf buffer owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404834797.1753044.15320037373750032549.stgit@frogsfrogsfrogs>
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
index 61719f6093ec8..29646e3fbb56b 100644
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
 
@@ -1698,6 +1702,12 @@ xfs_da3_node_lookup_int(
 
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
@@ -2206,6 +2216,12 @@ xfs_da3_path_shift(
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
index ac3c264402dda..0b01dd6ccf1eb 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -98,6 +98,8 @@ extern struct xfs_dir2_data_free *xfs_dir2_data_freefind(
 
 extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
 
+xfs_failaddr_t xfs_dir3_leaf_header_check(struct xfs_buf *bp, xfs_ino_t owner);
+
 extern const struct xfs_buf_ops xfs_dir3_block_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops;
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 20ce057d12e82..16a581e225a37 100644
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
index 1ad7405f9c389..e21965788188b 100644
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
index 1db2e60ba827f..2f0e3ad47b371 100644
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
index 042e28547e044..d94e265a8e1f2 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -470,7 +470,7 @@ xchk_directory_leaf1_bestfree(
 	int				error;
 
 	/* Read the free space block. */
-	error = xfs_dir3_leaf_read(sc->tp, sc->ip, lblk, &bp);
+	error = xfs_dir3_leaf_read(sc->tp, sc->ip, sc->ip->i_ino, lblk, &bp);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
 		return error;
 	xchk_buffer_recheck(sc, bp);

