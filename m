Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D3D157A61
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224902; cv=none; b=KdpOT37vSwEoHz2gSyEF1LZzIIul9xQIdzDy00SYrx26ei5nzRvYOVakT6fSlAIPxoIF5vhKF3wpEFTFYANjgvzHVXNDXMJhWgR1O7uwSHn3AGr5EFU6XLQed5qEnXETJqhnonizJZjrjexMtjjqVLNPVw2PLDS6wy/bRhAUGvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224902; c=relaxed/simple;
	bh=+/7JoGiMx8O+rtx4pBS1OR/1+00BRXy0vwGfvBHJobg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hdZLF4Hje8YxJOdTgLxG9cOaGJ8n7j2nLOtd2X1/kx3WtUMWoTwyTlUWiFIQIbNva2TeAqKKkDdO3MNXxqGNqyO4xcVaKO8Zoe/U7wL9SuxIwChp6OQGN0m8fHLsGRMr1jduEz0rHHWEH48Qm6b98jW0HTDxq+j5BY3Tj1TVvWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ehht35LF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ehht35LF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1051DC113CC;
	Mon, 15 Apr 2024 23:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224902;
	bh=+/7JoGiMx8O+rtx4pBS1OR/1+00BRXy0vwGfvBHJobg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ehht35LFhcr4SDAtQRg4yYZhw0W6dga3sCP6LkaAW8UpbeZpZVNC4Wq0FS4iSqKQz
	 D8yuHQ2jkorA66hOoJPhPea+6tEP9a/+46CfxZwcMFec5ZDQ/UhmUa9SvRqOYQk6K+
	 MaMOI+NwReUnaqKIeAuAnPsYOTZixWaZam5/4H60gD2vyBRn4RVBwk1iOUpzDBb/1G
	 5jBikE1cDVuoPRak5QdCWwg0DnjwsYgeRyoOCFbfYoHMI3TXLAkds+Bmi+BYoyybel
	 lejk6ARFKeoXwYveirjA/BWDJhdZhDcJ4vi6ArXIef1mrWKu5UnDX0UhQ+SZtcnq9B
	 UwzWJVbmYWzhA==
Date: Mon, 15 Apr 2024 16:48:21 -0700
Subject: [PATCH 07/10] xfs: validate directory leaf buffer owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322382698.88250.837763080778336394.stgit@frogsfrogsfrogs>
In-Reply-To: <171322382551.88250.5431690184825585631.stgit@frogsfrogsfrogs>
References: <171322382551.88250.5431690184825585631.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_btree.c  |   16 ++++++++++
 fs/xfs/libxfs/xfs_dir2.h      |    2 +
 fs/xfs/libxfs/xfs_dir2_leaf.c |   65 +++++++++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_dir2_node.c |    3 +-
 fs/xfs/libxfs/xfs_dir2_priv.h |    4 +--
 fs/xfs/scrub/dir.c            |    2 +
 6 files changed, 82 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index e6c28bccdbc0..b13796629e22 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -288,8 +288,12 @@ xfs_da3_header_check(
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
 
@@ -1700,6 +1704,12 @@ xfs_da3_node_lookup_int(
 
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
@@ -2208,6 +2218,12 @@ xfs_da3_path_shift(
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
index 8497d041f316..2f728c26a416 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -101,6 +101,8 @@ extern struct xfs_dir2_data_free *xfs_dir2_data_freefind(
 
 extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
 
+xfs_failaddr_t xfs_dir3_leaf_header_check(struct xfs_buf *bp, xfs_ino_t owner);
+
 extern const struct xfs_buf_ops xfs_dir3_block_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops;
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 20ce057d12e8..53b808e2a5f0 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -208,6 +208,29 @@ xfs_dir3_leaf_verify(
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
@@ -271,32 +294,60 @@ int
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
@@ -646,7 +697,8 @@ xfs_dir2_leaf_addname(
 
 	trace_xfs_dir2_leaf_addname(args);
 
-	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, &lbp);
+	error = xfs_dir3_leaf_read(tp, dp, args->owner, args->geo->leafblk,
+			&lbp);
 	if (error)
 		return error;
 
@@ -1237,7 +1289,8 @@ xfs_dir2_leaf_lookup_int(
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
index 1db2e60ba827..2f0e3ad47b37 100644
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
index 042e28547e04..d94e265a8e1f 100644
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

