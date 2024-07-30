Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9914F10E3
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299324; cv=none; b=Hlgn8SzmMlWTYYcexxSWadrpnXdsXfYQ9F8UV8weBeIpv+GK02xypoB/CO0TS9XwumObADydxhGPf80Rvtwgw657qlp+qlsED0PaUq0Pd32goyWdMnLmLGGIffKKJexwFXc8gJEoygCTr9ZtBEkqv4B6a73ZmnlxUYYD68qh6N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299324; c=relaxed/simple;
	bh=eJ8wkroWWu0bCV2pXvpgKctis4cSMyv3r19EKvbixdg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dssn2D/OrAt7utpE4c52q1R9NdNGlhdVCaXwLiHnfYLcuY47J2puFQSok1uPH/tKLxXle34H89X5h4ytIRkX83SCRXajaOZCs5zqF/HIeAMjsiL4U0ex++Z74C3jNEf7Suh47IoIYYRiuJ1FKa8TCG55zQJHT5b/75mimV4lZZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FtOLNK2e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FtOLNK2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA9EC32786;
	Tue, 30 Jul 2024 00:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299324;
	bh=eJ8wkroWWu0bCV2pXvpgKctis4cSMyv3r19EKvbixdg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FtOLNK2eRaAd0bOhiPmJwcfOc4QbfO9+fEVVU1vq23ZjfI5JMqTEzfX6V9VgYJqww
	 Jlc9UQOENBdgmVWrw6yo/kkVwXtheWEv1nH64QHtxOFKWWZzjE/Gxr7BFKrGIkfLvf
	 QMH0jAHY+DflV/HOKRp5Z8MEzX6COBqXoi2VFCCzIKix+AMFhBD7T8yLl2ldza3w7v
	 GDTbTIrP4GumykIWEIgC1olCySF8WyWvG0PD4DUn93nW+18cOXVmTXceX28O3CosYz
	 LZr4YOfohYQpMsuUZxsUQQvQ1CTYebrLU78Xo2NAWeL5snU7sgJX5y3OcE2ZKU7kEp
	 uKzbVSuphkcRA==
Date: Mon, 29 Jul 2024 17:28:43 -0700
Subject: [PATCH 019/115] xfs: validate directory leaf buffer owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842710.1338752.72489110537039762.stgit@frogsfrogsfrogs>
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

Source kernel commit: 402eef10a1bab0b428c418cfbaaa0a62efc9c951

Check the owner field of directory leaf blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_da_btree.c  |   16 ++++++++++++
 libxfs/xfs_dir2.h      |    2 +
 libxfs/xfs_dir2_leaf.c |   65 ++++++++++++++++++++++++++++++++++++++++++++----
 libxfs/xfs_dir2_node.c |    3 +-
 libxfs/xfs_dir2_priv.h |    4 +--
 5 files changed, 81 insertions(+), 9 deletions(-)


diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index c221cbba4..3c0dc26b7 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -284,8 +284,12 @@ xfs_da3_header_check(
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
 
@@ -1696,6 +1700,12 @@ xfs_da3_node_lookup_int(
 
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
@@ -2204,6 +2214,12 @@ xfs_da3_path_shift(
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
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 8497d041f..2f728c26a 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -101,6 +101,8 @@ extern struct xfs_dir2_data_free *xfs_dir2_data_freefind(
 
 extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
 
+xfs_failaddr_t xfs_dir3_leaf_header_check(struct xfs_buf *bp, xfs_ino_t owner);
+
 extern const struct xfs_buf_ops xfs_dir3_block_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops;
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 8fbda2250..6ce2d4b28 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -206,6 +206,29 @@ xfs_dir3_leaf_verify(
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
+		if (hdr3->hdr.info.hdr.magic !=
+					cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) &&
+		    hdr3->hdr.info.hdr.magic !=
+					cpu_to_be16(XFS_DIR3_LEAFN_MAGIC))
+			return __this_address;
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
@@ -269,32 +292,60 @@ int
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
@@ -644,7 +695,8 @@ xfs_dir2_leaf_addname(
 
 	trace_xfs_dir2_leaf_addname(args);
 
-	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, &lbp);
+	error = xfs_dir3_leaf_read(tp, dp, args->owner, args->geo->leafblk,
+			&lbp);
 	if (error)
 		return error;
 
@@ -1235,7 +1287,8 @@ xfs_dir2_leaf_lookup_int(
 	tp = args->trans;
 	mp = dp->i_mount;
 
-	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, &lbp);
+	error = xfs_dir3_leaf_read(tp, dp, args->owner, args->geo->leafblk,
+			&lbp);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index b00f78387..c0160d725 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -1559,7 +1559,8 @@ xfs_dir2_leafn_toosmall(
 		/*
 		 * Read the sibling leaf block.
 		 */
-		error = xfs_dir3_leafn_read(state->args->trans, dp, blkno, &bp);
+		error = xfs_dir3_leafn_read(state->args->trans, dp,
+				state->args->owner, blkno, &bp);
 		if (error)
 			return error;
 
diff --git a/libxfs/xfs_dir2_priv.h b/libxfs/xfs_dir2_priv.h
index 1db2e60ba..2f0e3ad47 100644
--- a/libxfs/xfs_dir2_priv.h
+++ b/libxfs/xfs_dir2_priv.h
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

