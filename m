Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93E7157A61
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224933; cv=none; b=kYQFim5Yn9UtTv9MHtp2B7ObfQdvQxvg2McUod6XGwg571AVphcqxL5g2D2wY0c4BGDGWNtQtM2Poe2lqIWEcRRZEh3RF5OcT5fuuoycbfTTloXSlBRb3V1Yh+At+SN3otbjlsPWh4dBldyBR/af2FIM+YjQbD4+Lm7J3dQ9PvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224933; c=relaxed/simple;
	bh=AvOMzBdf163VrawPr0G/Abe7Q/i0jcDaPmsH1Lyhx10=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NekbFUlHFV2tyPJFgi1rP4+THoCWer0U/IGNry7xlBL28MC6IGKUqtHlJ8sl6Raa4DrEIisonGuOqDBmrNucNPlAfuHk4Ec3oAzuaVyR5rDQJGZ5IBG/mjs4cR7QuROQH+Jc6EKpmOWgPw8v6a09QVpXRWQ5oHy/RkDGK3tCxM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CSjXglIA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CSjXglIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56876C113CC;
	Mon, 15 Apr 2024 23:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224933;
	bh=AvOMzBdf163VrawPr0G/Abe7Q/i0jcDaPmsH1Lyhx10=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CSjXglIA9c5LrNsq52UhT2VApi3txk3l9NW5TC0IbZ22k3s27fWYH4/tB5/pqKqwj
	 pfc2m4RsSTT8KSjB0EUQfa7JzSOgQm7L/kQuXE9HAhRsRmFOtUFPJ0C1Yl7VYKFVE0
	 /gxrl3pPCR3stnMbcVsnIQU/O6lcnHx6JPo7xTLRLTR8iiHyLyRZVBWB7RRM4dWW7G
	 HOViW/78H8cPGcOfIkVaPV3mT/uTYwyY8V+m1GyytV4uBzRiA5JWGSctxA/VYF1HWx
	 rd9A+5O0qe86EGDWR/u9gxlBiZGZsFu17tVJYhnpSRAP6HjWgJw81Zb5plpkTsDft7
	 jp3q6fxZfHivQ==
Date: Mon, 15 Apr 2024 16:48:52 -0700
Subject: [PATCH 09/10] xfs: validate explicit directory block buffer owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322382732.88250.13713835106714863436.stgit@frogsfrogsfrogs>
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

Port the existing directory block header checking function to accept an
owner number instead of an xfs_inode, then update the callsites to use
xfs_da_args.owner when possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2.h       |    1 +
 fs/xfs/libxfs/xfs_dir2_block.c |   20 ++++++++++++--------
 fs/xfs/libxfs/xfs_dir2_priv.h  |    4 ++--
 fs/xfs/libxfs/xfs_exchmaps.c   |    2 +-
 fs/xfs/scrub/dir.c             |    2 +-
 fs/xfs/scrub/readdir.c         |    2 +-
 fs/xfs/xfs_dir2_readdir.c      |    2 +-
 7 files changed, 19 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index d623bfdcd421..eb3a5c35025b 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -103,6 +103,7 @@ extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
 
 xfs_failaddr_t xfs_dir3_leaf_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 xfs_failaddr_t xfs_dir3_data_header_check(struct xfs_buf *bp, xfs_ino_t owner);
+xfs_failaddr_t xfs_dir3_block_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 
 extern const struct xfs_buf_ops xfs_dir3_block_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index b20b08394aa0..0f93ed1a4a74 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -115,17 +115,20 @@ const struct xfs_buf_ops xfs_dir3_block_buf_ops = {
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
+		if (hdr3->magic != cpu_to_be32(XFS_DIR3_BLOCK_MAGIC))
+			return __this_address;
+
+		if (be64_to_cpu(hdr3->owner) != owner)
 			return __this_address;
 	}
 
@@ -136,6 +139,7 @@ int
 xfs_dir3_block_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
+	xfs_ino_t		owner,
 	struct xfs_buf		**bpp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -148,7 +152,7 @@ xfs_dir3_block_read(
 		return err;
 
 	/* Check things that we can't do in the verifier. */
-	fa = xfs_dir3_block_header_check(dp, *bpp);
+	fa = xfs_dir3_block_header_check(*bpp, owner);
 	if (fa) {
 		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
@@ -383,7 +387,7 @@ xfs_dir2_block_addname(
 	tp = args->trans;
 
 	/* Read the (one and only) directory block into bp. */
-	error = xfs_dir3_block_read(tp, dp, &bp);
+	error = xfs_dir3_block_read(tp, dp, args->owner, &bp);
 	if (error)
 		return error;
 
@@ -698,7 +702,7 @@ xfs_dir2_block_lookup_int(
 	dp = args->dp;
 	tp = args->trans;
 
-	error = xfs_dir3_block_read(tp, dp, &bp);
+	error = xfs_dir3_block_read(tp, dp, args->owner, &bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 879aa2e9fd73..adbc544c9bef 100644
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
index 9c9cf2e998b2..3880ae32eecf 100644
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
index 6b572196bb43..43f5bc8ce0d4 100644
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
index bed15a9524a2..e94080469315 100644
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
index 2c03371b542a..b3abad5a6cd8 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -157,7 +157,7 @@ xfs_dir2_block_getdents(
 	if (xfs_dir2_dataptr_to_db(geo, ctx->pos) > geo->datablk)
 		return 0;
 
-	error = xfs_dir3_block_read(args->trans, dp, &bp);
+	error = xfs_dir3_block_read(args->trans, dp, args->owner, &bp);
 	if (error)
 		return error;
 

