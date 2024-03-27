Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F591CF92
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 02:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504856; cv=none; b=ogf6lXfhDyWyhitMUFJtzndyhgh0K5M1zWN/hik0rmtjMPb3OMx3TGq978ZJ3+NRRSYMkfVTEEZvQ+hw/NLFcyrNKpfBNT7r4XWr8l+P6pNQU4+Q60xjKjlLvSPftpKolJC6omHZA/Lr7Mor0yyfuJelbVSNmp4JCVDdBdBGZ+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504856; c=relaxed/simple;
	bh=4aBd2fpEi4pxkwT6L6sgIdk3NhLikis3aQKGp0x7wUA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cTR4lzB4TK/aVPrMzR0gP0st1N+QbD2bbTvPGDHGy1fPOyH+xUcJIepan5pDPwliMVfrEkGLBP+8e93OFAeQwseLQIvyx78IltJeIF+aQqJbBTH5SP2doEyNyNmze/dJ/w3WikXp1aVShvqr2GHqUK9Otp+mOQkdmJLavwtDGN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P0oCQaZw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P0oCQaZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BB4C433F1;
	Wed, 27 Mar 2024 02:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504855;
	bh=4aBd2fpEi4pxkwT6L6sgIdk3NhLikis3aQKGp0x7wUA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=P0oCQaZws9l5LE7iGUfj3NW7ecnKWvcNeQjIc/5aAEk+4GgmCYDtL2vtVoyJBaAoU
	 4qYYVjqEZHPkHUZsKK3uV1xtWvupDlWlL0Upb1ilSF5G6Mn5vcMmTi0WzyCoUmfP6P
	 r2SbbzgIHNIgdQT9VDQSt8z5lzcJOwASER+Jwt9EK2WkHT/qADxY/kFuydszTs8t3N
	 83lNAgeVkoyZ5bxjUtkoimJGftU8MCP7ABIPNI89YQmzg3/tVAZ0ohGKF7QA418WAM
	 XUy86ZoMO0FnCojOAAFetsU/K+vezKRpxixfmw1LJ7MbEQt1DLJrPpOo/XoazAobW4
	 zEXlK27mfsc1g==
Date: Tue, 26 Mar 2024 19:00:55 -0700
Subject: [PATCH 09/10] xfs: validate explicit directory block buffer owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150382275.3217370.10209203557287936545.stgit@frogsfrogsfrogs>
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

Port the existing directory block header checking function to accept an
owner number instead of an xfs_inode, then update the callsites to use
xfs_da_args.owner when possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2.h       |    1 +
 fs/xfs/libxfs/xfs_dir2_block.c |   22 ++++++++++++++--------
 fs/xfs/libxfs/xfs_dir2_priv.h  |    4 ++--
 fs/xfs/libxfs/xfs_exchmaps.c   |    2 +-
 fs/xfs/scrub/dir.c             |    2 +-
 fs/xfs/scrub/readdir.c         |    2 +-
 fs/xfs/xfs_dir2_readdir.c      |    2 +-
 7 files changed, 21 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index d623bfdcd4218..eb3a5c35025b5 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -103,6 +103,7 @@ extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
 
 xfs_failaddr_t xfs_dir3_leaf_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 xfs_failaddr_t xfs_dir3_data_header_check(struct xfs_buf *bp, xfs_ino_t owner);
+xfs_failaddr_t xfs_dir3_block_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 
 extern const struct xfs_buf_ops xfs_dir3_block_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index b20b08394aa06..91dd0fe0d105f 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -115,18 +115,23 @@ const struct xfs_buf_ops xfs_dir3_block_buf_ops = {
 	.verify_struct = xfs_dir3_block_verify,
 };
 
-static xfs_failaddr_t
+xfs_failaddr_t
 xfs_dir3_block_header_check(
-	struct xfs_inode	*dp,
-	struct xfs_buf		*bp)
+	struct xfs_buf		*bp,
+	xfs_ino_t		owner)
 {
-	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 
 	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
 
-		if (be64_to_cpu(hdr3->owner) != dp->i_ino)
+		ASSERT(hdr3->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
+
+		if (be64_to_cpu(hdr3->owner) != owner) {
+			xfs_err(NULL, "dir block owner 0x%llx doesnt match block 0x%llx", owner, be64_to_cpu(hdr3->owner));
+			dump_stack();
 			return __this_address;
+		}
 	}
 
 	return NULL;
@@ -136,6 +141,7 @@ int
 xfs_dir3_block_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
+	xfs_ino_t		owner,
 	struct xfs_buf		**bpp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -148,7 +154,7 @@ xfs_dir3_block_read(
 		return err;
 
 	/* Check things that we can't do in the verifier. */
-	fa = xfs_dir3_block_header_check(dp, *bpp);
+	fa = xfs_dir3_block_header_check(*bpp, owner);
 	if (fa) {
 		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
@@ -383,7 +389,7 @@ xfs_dir2_block_addname(
 	tp = args->trans;
 
 	/* Read the (one and only) directory block into bp. */
-	error = xfs_dir3_block_read(tp, dp, &bp);
+	error = xfs_dir3_block_read(tp, dp, args->owner, &bp);
 	if (error)
 		return error;
 
@@ -698,7 +704,7 @@ xfs_dir2_block_lookup_int(
 	dp = args->dp;
 	tp = args->trans;
 
-	error = xfs_dir3_block_read(tp, dp, &bp);
+	error = xfs_dir3_block_read(tp, dp, args->owner, &bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 879aa2e9fd730..adbc544c9befa 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -50,8 +50,8 @@ extern int xfs_dir_cilookup_result(struct xfs_da_args *args,
 
 
 /* xfs_dir2_block.c */
-extern int xfs_dir3_block_read(struct xfs_trans *tp, struct xfs_inode *dp,
-			       struct xfs_buf **bpp);
+int xfs_dir3_block_read(struct xfs_trans *tp, struct xfs_inode *dp,
+		xfs_ino_t owner, struct xfs_buf **bpp);
 extern int xfs_dir2_block_addname(struct xfs_da_args *args);
 extern int xfs_dir2_block_lookup(struct xfs_da_args *args);
 extern int xfs_dir2_block_removename(struct xfs_da_args *args);
diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index 55085d00e4046..743059404f772 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -476,7 +476,7 @@ xfs_exchmaps_dir_to_sf(
 	if (!isblock)
 		return 0;
 
-	error = xfs_dir3_block_read(tp, xmi->xmi_ip2, &bp);
+	error = xfs_dir3_block_read(tp, xmi->xmi_ip2, xmi->xmi_ip2->i_ino, &bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 6b572196bb43d..43f5bc8ce0d46 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -315,7 +315,7 @@ xchk_directory_data_bestfree(
 		/* dir block format */
 		if (lblk != XFS_B_TO_FSBT(mp, XFS_DIR2_DATA_OFFSET))
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
-		error = xfs_dir3_block_read(sc->tp, sc->ip, &bp);
+		error = xfs_dir3_block_read(sc->tp, sc->ip, sc->ip->i_ino, &bp);
 	} else {
 		/* dir data format */
 		error = xfs_dir3_data_read(sc->tp, sc->ip, sc->ip->i_ino, lblk,
diff --git a/fs/xfs/scrub/readdir.c b/fs/xfs/scrub/readdir.c
index bed15a9524a2f..e940804693151 100644
--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -99,7 +99,7 @@ xchk_dir_walk_block(
 	unsigned int		off, next_off, end;
 	int			error;
 
-	error = xfs_dir3_block_read(sc->tp, dp, &bp);
+	error = xfs_dir3_block_read(sc->tp, dp, dp->i_ino, &bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 2c03371b542ae..b3abad5a6cd80 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -157,7 +157,7 @@ xfs_dir2_block_getdents(
 	if (xfs_dir2_dataptr_to_db(geo, ctx->pos) > geo->datablk)
 		return 0;
 
-	error = xfs_dir3_block_read(args->trans, dp, &bp);
+	error = xfs_dir3_block_read(args->trans, dp, args->owner, &bp);
 	if (error)
 		return error;
 

