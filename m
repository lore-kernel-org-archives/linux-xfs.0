Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577E5C13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qbkcqaTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4735C433C7;
	Sun, 31 Dec 2023 22:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062061;
	bh=xTP7xSouAdmiT5Gz27cpxjPjFOtVMPQFJ2tM8BwqcS0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qbkcqaTdMKIb1S36PvCRHQm3jZ0jG4TiPnXU7EDq8JpxDoMFj/aWu5kAW5527vSSC
	 PmlmoRVhNKTez5OFmDLSDTFuEnuJ9L3JiPXiKGekrdZH9KLPTnp24G9+hDpfwa/EjT
	 9dqr5IeSDDYu/EWqeZaIc9x2E/wY2sPXfX84mNLyp+lU5wqfgRCNbrz6uw3JpuXMwk
	 knCBaW1oqn16BNGtkeZ9HrVPzaqdtxU+sOc9cV0A7YFfSuzJP+cINfiOiMbkmllFJF
	 aYsIfGHLbazVl0WVMSB5p4EgMfKlBp8ks6VOLFkgRXcyT+F4xuIGNYa5fN0lsdHKrL
	 lHkgwQv1+I96A==
Date: Sun, 31 Dec 2023 14:34:21 -0800
Subject: [PATCH 8/9] xfs: validate explicit directory block buffer owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404996975.1796662.7701276307823992202.stgit@frogsfrogsfrogs>
In-Reply-To: <170404996860.1796662.9605761412685436403.stgit@frogsfrogsfrogs>
References: <170404996860.1796662.9605761412685436403.stgit@frogsfrogsfrogs>
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
---
 db/namei.c              |    2 +-
 libxfs/xfs_dir2.h       |    1 +
 libxfs/xfs_dir2_block.c |   22 ++++++++++++++--------
 libxfs/xfs_dir2_priv.h  |    2 +-
 libxfs/xfs_swapext.c    |    2 +-
 5 files changed, 18 insertions(+), 11 deletions(-)


diff --git a/db/namei.c b/db/namei.c
index d7bf489cd53..a8577b97222 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -339,7 +339,7 @@ list_blockdir(
 	unsigned int		end;
 	int			error;
 
-	error = xfs_dir3_block_read(NULL, dp, &bp);
+	error = xfs_dir3_block_read(NULL, dp, args->owner, &bp);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 537596b9de4..f99788a1f3e 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -100,6 +100,7 @@ extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
 
 xfs_failaddr_t xfs_dir3_leaf_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 xfs_failaddr_t xfs_dir3_data_header_check(struct xfs_buf *bp, xfs_ino_t owner);
+xfs_failaddr_t xfs_dir3_block_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 
 extern const struct xfs_buf_ops xfs_dir3_block_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 86e49fbc2b7..370f4df0c72 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -112,18 +112,23 @@ const struct xfs_buf_ops xfs_dir3_block_buf_ops = {
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
@@ -133,6 +138,7 @@ int
 xfs_dir3_block_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
+	xfs_ino_t		owner,
 	struct xfs_buf		**bpp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -145,7 +151,7 @@ xfs_dir3_block_read(
 		return err;
 
 	/* Check things that we can't do in the verifier. */
-	fa = xfs_dir3_block_header_check(dp, *bpp);
+	fa = xfs_dir3_block_header_check(*bpp, owner);
 	if (fa) {
 		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
@@ -380,7 +386,7 @@ xfs_dir2_block_addname(
 	tp = args->trans;
 
 	/* Read the (one and only) directory block into bp. */
-	error = xfs_dir3_block_read(tp, dp, &bp);
+	error = xfs_dir3_block_read(tp, dp, args->owner, &bp);
 	if (error)
 		return error;
 
@@ -695,7 +701,7 @@ xfs_dir2_block_lookup_int(
 	dp = args->dp;
 	tp = args->trans;
 
-	error = xfs_dir3_block_read(tp, dp, &bp);
+	error = xfs_dir3_block_read(tp, dp, args->owner, &bp);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_dir2_priv.h b/libxfs/xfs_dir2_priv.h
index 879aa2e9fd7..969e36a03fe 100644
--- a/libxfs/xfs_dir2_priv.h
+++ b/libxfs/xfs_dir2_priv.h
@@ -51,7 +51,7 @@ extern int xfs_dir_cilookup_result(struct xfs_da_args *args,
 
 /* xfs_dir2_block.c */
 extern int xfs_dir3_block_read(struct xfs_trans *tp, struct xfs_inode *dp,
-			       struct xfs_buf **bpp);
+			       xfs_ino_t owner, struct xfs_buf **bpp);
 extern int xfs_dir2_block_addname(struct xfs_da_args *args);
 extern int xfs_dir2_block_lookup(struct xfs_da_args *args);
 extern int xfs_dir2_block_removename(struct xfs_da_args *args);
diff --git a/libxfs/xfs_swapext.c b/libxfs/xfs_swapext.c
index eae4f6b7310..f396593a5c8 100644
--- a/libxfs/xfs_swapext.c
+++ b/libxfs/xfs_swapext.c
@@ -571,7 +571,7 @@ xfs_swapext_dir_to_sf(
 	if (!isblock)
 		return 0;
 
-	error = xfs_dir3_block_read(tp, sxi->sxi_ip2, &bp);
+	error = xfs_dir3_block_read(tp, sxi->sxi_ip2, sxi->sxi_ip2->i_ino, &bp);
 	if (error)
 		return error;
 

