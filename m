Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D4810E9
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299371; cv=none; b=hYEBckoCYhaHGcZkbXILc7HCJZP7XJNrZUS4swqKYLufiLCj7s6LC6XLBILZ02cIe611PoEJ+Uu11p8Zq3lr0rte2b7195o1VuluuTBFnrwOGNMM990xqw9yFF3wbLG+Od4ZHoFg2A6s3NVyiWZvY538Mth1h47+EftFitDXy7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299371; c=relaxed/simple;
	bh=h6mQPA5l5Pk8MyzOrlXVd563D3QqsC2IiDR7JRJac0I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oB/v0L/KqLp0zh/vOKWh8Aq1paitig1H//S5XSaAfXVsWgL1fQUwbVuJGRhWu5qPz7n+D2raDVpEY8hCtQrMts0H7tJ2QB0SpdsrZ5m5Hsjv05d9ssPcRiVy8GshHINzz4mmFNjNiLDtpZ8cfUevDS4X/F39HfcbVFuU3t6emn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dIuj+7hu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dIuj+7hu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2991BC4AF0B;
	Tue, 30 Jul 2024 00:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299371;
	bh=h6mQPA5l5Pk8MyzOrlXVd563D3QqsC2IiDR7JRJac0I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dIuj+7hu+ytIbgvifXSUG0T9/Wje9PdmsOBdqvbDi9hOw/9eWtXrR3a6gs1ovHuTt
	 ka+1rhKiCVhkUZhHpYiCZT6+M7BAdw87+t7KnJp9t/oG4HDi18KYtjCqqdayYQ0aBF
	 RHZk0SPSYJltpD1O9snOYdMGMxng4EB+lz0O+5pcHLx9LLiBqM6bDnOk22x/9GI4KF
	 ixwQh1rWFk1rciwvBnBI6/GnZHADjkG/pHzL1SQR0CcZNUG6WgDfYzFnglAnC3yF4m
	 UoMKlBzshcAMmOXKSvCOj+BFntLgLh15lJarSUa7JQCFKHviDTBp1VqMsOmGr19xIp
	 d5PaGaotCzDBg==
Date: Mon, 29 Jul 2024 17:29:30 -0700
Subject: [PATCH 022/115] xfs: validate explicit directory free block owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842753.1338752.16130123938354956861.stgit@frogsfrogsfrogs>
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

Source kernel commit: fe6c9f8e48e0dcbfc3dba17edd88490c8579b34b

Port the existing directory freespace block header checking function to
accept an owner number instead of an xfs_inode, then update the
callsites to use xfs_da_args.owner when possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_dir2_leaf.c |    3 ++-
 libxfs/xfs_dir2_node.c |   32 ++++++++++++++++++--------------
 libxfs/xfs_dir2_priv.h |    4 ++--
 3 files changed, 22 insertions(+), 17 deletions(-)


diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 1c12b5a66..7c0bba512 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -1804,7 +1804,8 @@ xfs_dir2_node_to_leaf(
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
index 690407374..c94d00eb9 100644
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
index adbc544c9..3befb3250 100644
--- a/libxfs/xfs_dir2_priv.h
+++ b/libxfs/xfs_dir2_priv.h
@@ -155,8 +155,8 @@ extern int xfs_dir2_node_removename(struct xfs_da_args *args);
 extern int xfs_dir2_node_replace(struct xfs_da_args *args);
 extern int xfs_dir2_node_trim_free(struct xfs_da_args *args, xfs_fileoff_t fo,
 		int *rvalp);
-extern int xfs_dir2_free_read(struct xfs_trans *tp, struct xfs_inode *dp,
-		xfs_dablk_t fbno, struct xfs_buf **bpp);
+int xfs_dir2_free_read(struct xfs_trans *tp, struct xfs_inode *dp,
+		xfs_ino_t owner, xfs_dablk_t fbno, struct xfs_buf **bpp);
 
 /* xfs_dir2_sf.c */
 xfs_ino_t xfs_dir2_sf_get_ino(struct xfs_mount *mp, struct xfs_dir2_sf_hdr *hdr,

