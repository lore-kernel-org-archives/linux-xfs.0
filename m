Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974D3C13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bEUhKtK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68916C433C7;
	Sun, 31 Dec 2023 22:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062077;
	bh=AS1sqLpKM2VTlWdZq1KHqXmLnkF8GdmBBpNYp38LEiw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bEUhKtK3DY6GtGjfxeDVdkJQdE8gcxTy3R3joF5Tw0/wnf//IZJRw7TAXUXIiliCC
	 Wb/vHk89EcXoTqeEoNEb+ovo7acoDNVKurBHAmP8gTWsdrKdagUG0OOW9kQYoKPNys
	 UQ3NveVxHI7rGFcR2p2zM+dbsY5rUCk5jnrD7pP5CUqTd6/jn7ca8jYZhqMHfS5pRx
	 6Ge5EhOcLOHOZK+hYtG+13/c7CfXd+M0RSKXM78wZn0crbhghvTvTKsQ3iQJm2MFho
	 cy8vQTEWxoYwZySsQffpztbXdZXji1j5VAUo8SmaLCq2GFt3RjN8t9sfJSPJTI8jqe
	 7YXxdEHGCMUkA==
Date: Sun, 31 Dec 2023 14:34:36 -0800
Subject: [PATCH 9/9] xfs: validate explicit directory free block owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404996988.1796662.9255833509682611896.stgit@frogsfrogsfrogs>
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

Port the existing directory freespace block header checking function to
accept an owner number instead of an xfs_inode, then update the
callsites to use xfs_da_args.owner when possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_dir2_leaf.c |    3 ++-
 libxfs/xfs_dir2_node.c |   32 ++++++++++++++++++--------------
 libxfs/xfs_dir2_priv.h |    2 +-
 3 files changed, 21 insertions(+), 16 deletions(-)


diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index dd2bb2bc8b6..77eca816c66 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -1803,7 +1803,8 @@ xfs_dir2_node_to_leaf(
 	/*
 	 * Read the freespace block.
 	 */
-	error = xfs_dir2_free_read(tp, dp,  args->geo->freeblk, &fbp);
+	error = xfs_dir2_free_read(tp, dp, args->owner, args->geo->freeblk,
+			&fbp);
 	if (error)
 		return error;
 	xfs_dir2_free_hdr_from_disk(mp, &freehdr, fbp->b_addr);
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 69040737418..c94d00eb99c 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -172,11 +172,11 @@ const struct xfs_buf_ops xfs_dir3_free_buf_ops = {
 /* Everything ok in the free block header? */
 static xfs_failaddr_t
 xfs_dir3_free_header_check(
-	struct xfs_inode	*dp,
-	xfs_dablk_t		fbno,
-	struct xfs_buf		*bp)
+	struct xfs_buf		*bp,
+	xfs_ino_t		owner,
+	xfs_dablk_t		fbno)
 {
-	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	int			maxbests = mp->m_dir_geo->free_max_bests;
 	unsigned int		firstdb;
 
@@ -192,7 +192,7 @@ xfs_dir3_free_header_check(
 			return __this_address;
 		if (be32_to_cpu(hdr3->nvalid) < be32_to_cpu(hdr3->nused))
 			return __this_address;
-		if (be64_to_cpu(hdr3->hdr.owner) != dp->i_ino)
+		if (be64_to_cpu(hdr3->hdr.owner) != owner)
 			return __this_address;
 	} else {
 		struct xfs_dir2_free_hdr *hdr = bp->b_addr;
@@ -211,6 +211,7 @@ static int
 __xfs_dir3_free_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
+	xfs_ino_t		owner,
 	xfs_dablk_t		fbno,
 	unsigned int		flags,
 	struct xfs_buf		**bpp)
@@ -224,7 +225,7 @@ __xfs_dir3_free_read(
 		return err;
 
 	/* Check things that we can't do in the verifier. */
-	fa = xfs_dir3_free_header_check(dp, fbno, *bpp);
+	fa = xfs_dir3_free_header_check(*bpp, owner, fbno);
 	if (fa) {
 		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
@@ -296,20 +297,23 @@ int
 xfs_dir2_free_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
+	xfs_ino_t		owner,
 	xfs_dablk_t		fbno,
 	struct xfs_buf		**bpp)
 {
-	return __xfs_dir3_free_read(tp, dp, fbno, 0, bpp);
+	return __xfs_dir3_free_read(tp, dp, owner, fbno, 0, bpp);
 }
 
 static int
 xfs_dir2_free_try_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
+	xfs_ino_t		owner,
 	xfs_dablk_t		fbno,
 	struct xfs_buf		**bpp)
 {
-	return __xfs_dir3_free_read(tp, dp, fbno, XFS_DABUF_MAP_HOLE_OK, bpp);
+	return __xfs_dir3_free_read(tp, dp, owner, fbno, XFS_DABUF_MAP_HOLE_OK,
+			bpp);
 }
 
 static int
@@ -714,7 +718,7 @@ xfs_dir2_leafn_lookup_for_addname(
 				if (curbp)
 					xfs_trans_brelse(tp, curbp);
 
-				error = xfs_dir2_free_read(tp, dp,
+				error = xfs_dir2_free_read(tp, dp, args->owner,
 						xfs_dir2_db_to_da(args->geo,
 								  newfdb),
 						&curbp);
@@ -1353,8 +1357,8 @@ xfs_dir2_leafn_remove(
 		 * read in the free block.
 		 */
 		fdb = xfs_dir2_db_to_fdb(geo, db);
-		error = xfs_dir2_free_read(tp, dp, xfs_dir2_db_to_da(geo, fdb),
-					   &fbp);
+		error = xfs_dir2_free_read(tp, dp, args->owner,
+				xfs_dir2_db_to_da(geo, fdb), &fbp);
 		if (error)
 			return error;
 		free = fbp->b_addr;
@@ -1713,7 +1717,7 @@ xfs_dir2_node_add_datablk(
 	 * that was just allocated.
 	 */
 	fbno = xfs_dir2_db_to_fdb(args->geo, *dbno);
-	error = xfs_dir2_free_try_read(tp, dp,
+	error = xfs_dir2_free_try_read(tp, dp, args->owner,
 			       xfs_dir2_db_to_da(args->geo, fbno), &fbp);
 	if (error)
 		return error;
@@ -1860,7 +1864,7 @@ xfs_dir2_node_find_freeblk(
 		 * so this might not succeed.  This should be really rare, so
 		 * there's no reason to avoid it.
 		 */
-		error = xfs_dir2_free_try_read(tp, dp,
+		error = xfs_dir2_free_try_read(tp, dp, args->owner,
 				xfs_dir2_db_to_da(args->geo, fbno),
 				&fbp);
 		if (error)
@@ -2299,7 +2303,7 @@ xfs_dir2_node_trim_free(
 	/*
 	 * Read the freespace block.
 	 */
-	error = xfs_dir2_free_try_read(tp, dp, fo, &bp);
+	error = xfs_dir2_free_try_read(tp, dp, args->owner, fo, &bp);
 	if (error)
 		return error;
 	/*
diff --git a/libxfs/xfs_dir2_priv.h b/libxfs/xfs_dir2_priv.h
index 969e36a03fe..f9bc280e8c2 100644
--- a/libxfs/xfs_dir2_priv.h
+++ b/libxfs/xfs_dir2_priv.h
@@ -156,7 +156,7 @@ extern int xfs_dir2_node_replace(struct xfs_da_args *args);
 extern int xfs_dir2_node_trim_free(struct xfs_da_args *args, xfs_fileoff_t fo,
 		int *rvalp);
 extern int xfs_dir2_free_read(struct xfs_trans *tp, struct xfs_inode *dp,
-		xfs_dablk_t fbno, struct xfs_buf **bpp);
+		xfs_ino_t owner, xfs_dablk_t fbno, struct xfs_buf **bpp);
 
 /* xfs_dir2_sf.c */
 xfs_ino_t xfs_dir2_sf_get_ino(struct xfs_mount *mp, struct xfs_dir2_sf_hdr *hdr,

