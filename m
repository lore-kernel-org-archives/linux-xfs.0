Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF252AE9F
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299356; cv=none; b=Lfl6AcMSTKdEpTHngdoBJfJCvwwlzkn0LmmN64pl2M4bpfYPAXupVmQAjb8atVBzfr1Fm4i0BMcXVEXhZ7vl0fOZ8YVi/WMY1WLbwDRJ1vGNSEwKGowPj8gcoiEd2VH3K7RpBAUMXBBO+GSqTwbCmAdktsVYjZYjLgh0xHvbMig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299356; c=relaxed/simple;
	bh=wrHC1UZzxOsPgOjAqp2ApSXogvKvl6x5hLlyzBvO9lw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l09Qh8ySgxExYsE2FIjJbt/76KfMJiG9bYwAlT7mPnoAKRNBgkGe6ISvH3p7BsHtGPPMABVSQxjNqyhGILvD0VYaYbwlntFNVAQ3KbOt4yOVtIL3pclnC17pflPW9eesQTB6O0PBN+FHUekWm2n9rTI0hR/EaZhUbdLW1s6OcLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eadcaFKa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eadcaFKa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3C5C4AF0E;
	Tue, 30 Jul 2024 00:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299355;
	bh=wrHC1UZzxOsPgOjAqp2ApSXogvKvl6x5hLlyzBvO9lw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eadcaFKalXFds0h5OUDGnBkqRNG/veZBLDCa31+/62/j9keBb/KtVq759/28GLXs4
	 8rqB914sNbcxGuUxpVpMOKF4HxCtKQv24RRCWb+7Hw5ajASRWqspxDL2UMEUigNrk+
	 X6WxcFKNGyCt6wvj+CErBYKZDSYe1Af6sJ8aIYghategeV6qpayMw1peGXhBSA044T
	 KRZKMF2bi9WUhUcaUELG8nJtkOM2kIL0PWhwR7IuJAl1EbQ14FYqiAsQ7K9TQ2VLc5
	 FqRhCejO9r9KPcSX+T/WHp4prz3TOx+oYTQsSfc2wRaITUXC5tXHAEd/ayf4OA4h83
	 m2mgnSZhENPzw==
Date: Mon, 29 Jul 2024 17:29:14 -0700
Subject: [PATCH 021/115] xfs: validate explicit directory block buffer owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842739.1338752.7558412289675474495.stgit@frogsfrogsfrogs>
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

Source kernel commit: 29b41ce919b7f0b0c2220e088e450d9b132bec36

Port the existing directory block header checking function to accept an
owner number instead of an xfs_inode, then update the callsites to use
xfs_da_args.owner when possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/namei.c              |    2 +-
 libxfs/xfs_dir2.h       |    1 +
 libxfs/xfs_dir2_block.c |   20 ++++++++++++--------
 libxfs/xfs_dir2_priv.h  |    4 ++--
 libxfs/xfs_exchmaps.c   |    2 +-
 5 files changed, 17 insertions(+), 12 deletions(-)


diff --git a/db/namei.c b/db/namei.c
index d2541b78a..303ca3448 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -337,7 +337,7 @@ list_blockdir(
 	unsigned int		end;
 	int			error;
 
-	error = xfs_dir3_block_read(NULL, dp, &bp);
+	error = xfs_dir3_block_read(NULL, dp, args->owner, &bp);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index d623bfdcd..eb3a5c350 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -103,6 +103,7 @@ extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
 
 xfs_failaddr_t xfs_dir3_leaf_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 xfs_failaddr_t xfs_dir3_data_header_check(struct xfs_buf *bp, xfs_ino_t owner);
+xfs_failaddr_t xfs_dir3_block_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 
 extern const struct xfs_buf_ops xfs_dir3_block_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 6107e01ca..82da0d327 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -112,17 +112,20 @@ const struct xfs_buf_ops xfs_dir3_block_buf_ops = {
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
 
@@ -133,6 +136,7 @@ int
 xfs_dir3_block_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
+	xfs_ino_t		owner,
 	struct xfs_buf		**bpp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -145,7 +149,7 @@ xfs_dir3_block_read(
 		return err;
 
 	/* Check things that we can't do in the verifier. */
-	fa = xfs_dir3_block_header_check(dp, *bpp);
+	fa = xfs_dir3_block_header_check(*bpp, owner);
 	if (fa) {
 		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
@@ -380,7 +384,7 @@ xfs_dir2_block_addname(
 	tp = args->trans;
 
 	/* Read the (one and only) directory block into bp. */
-	error = xfs_dir3_block_read(tp, dp, &bp);
+	error = xfs_dir3_block_read(tp, dp, args->owner, &bp);
 	if (error)
 		return error;
 
@@ -695,7 +699,7 @@ xfs_dir2_block_lookup_int(
 	dp = args->dp;
 	tp = args->trans;
 
-	error = xfs_dir3_block_read(tp, dp, &bp);
+	error = xfs_dir3_block_read(tp, dp, args->owner, &bp);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_dir2_priv.h b/libxfs/xfs_dir2_priv.h
index 879aa2e9f..adbc544c9 100644
--- a/libxfs/xfs_dir2_priv.h
+++ b/libxfs/xfs_dir2_priv.h
@@ -50,8 +50,8 @@ extern int xfs_dir_cilookup_result(struct xfs_da_args *args,
 
 
 /* xfs_dir2_block.c */
-extern int xfs_dir3_block_read(struct xfs_trans *tp, struct xfs_inode *dp,
-			       struct xfs_buf **bpp);
+int xfs_dir3_block_read(struct xfs_trans *tp, struct xfs_inode *dp,
+		xfs_ino_t owner, struct xfs_buf **bpp);
 extern int xfs_dir2_block_addname(struct xfs_da_args *args);
 extern int xfs_dir2_block_lookup(struct xfs_da_args *args);
 extern int xfs_dir2_block_removename(struct xfs_da_args *args);
diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index 21c501aab..71408d713 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -473,7 +473,7 @@ xfs_exchmaps_dir_to_sf(
 	if (!isblock)
 		return 0;
 
-	error = xfs_dir3_block_read(tp, xmi->xmi_ip2, &bp);
+	error = xfs_dir3_block_read(tp, xmi->xmi_ip2, xmi->xmi_ip2->i_ino, &bp);
 	if (error)
 		return error;
 

