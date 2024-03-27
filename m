Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BF81F93E
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 02:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504871; cv=none; b=o2FIxLx59ePqU0AeyOMeR2+2ECxvBG/CEBJO8J2MoC4VZ0Hm/NX0vvvEnNtSj3Cl6TQxZr2M2+Her0z4Qu+85tl5SR72jV4eBtl9+j+Y0gIqRoYKW2fPIUplSdl/eT+A8O69DYgaTYszHlUw2iaFzIli9FQ788bmnE9773EoYvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504871; c=relaxed/simple;
	bh=iTFPkMFSUK2nsVT0SN1HxZ7KJgLHr3geSfUtPqbWleQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=brHWo4/Q2tF8DFT6hfQ/hra/uaZBENwIYYCm7ZYGvws8Cu506okjuczZk43GqIZ/1zBd0PzsXvUldoEqDlOeZiOmiHtYCX1v0AKG0/qyZr+0D8S+AhZMXuT+7guHft0vXYP3GpqsOoZmC+I9HPSIpEr4R4Eo2BUl8JDKKvHdXKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bsd32pQ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bsd32pQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CE9C433F1;
	Wed, 27 Mar 2024 02:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504871;
	bh=iTFPkMFSUK2nsVT0SN1HxZ7KJgLHr3geSfUtPqbWleQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Bsd32pQ3XitHW4H5jluihSo7sNpsL/Qod7294E7yBIaMYsJCaVC8BAfNp9kHvMERi
	 E6ouzqMZOcFyku5a+J03i1yAl6lXKmzT9CrxPFxh2bHu+0rP2/wBWU21Z5SF1JEy5C
	 fQcK/NjkljaxDGRtTPR08bAUXuIdjyRwGsCZvkJbSReonJdPw5k2MmMjo0S03douL+
	 K8PpcrKZY43Py6lfYFq2X5ZgM9mSc/z7b8iKnFsj9ldgBXPfIvUiKnxx6hRNyXrbSF
	 9DCcu6KoLigu0Eysu6yfLAsn3VbL9a9R9aiADpWYRDsOFjgh6DfdDDqlbmBGP/rFMa
	 Oqo4pLVjtv6IQ==
Date: Tue, 26 Mar 2024 19:01:10 -0700
Subject: [PATCH 10/10] xfs: validate explicit directory free block owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150382292.3217370.12070385316435154440.stgit@frogsfrogsfrogs>
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

Port the existing directory freespace block header checking function to
accept an owner number instead of an xfs_inode, then update the
callsites to use xfs_da_args.owner when possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_leaf.c |    3 ++-
 fs/xfs/libxfs/xfs_dir2_node.c |   32 ++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_dir2_priv.h |    4 ++--
 fs/xfs/scrub/dir.c            |    2 +-
 4 files changed, 23 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index a6eee26044875..fb78ae79fdc6a 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1805,7 +1805,8 @@ xfs_dir2_node_to_leaf(
 	/*
 	 * Read the freespace block.
 	 */
-	error = xfs_dir2_free_read(tp, dp,  args->geo->freeblk, &fbp);
+	error = xfs_dir2_free_read(tp, dp, args->owner, args->geo->freeblk,
+			&fbp);
 	if (error)
 		return error;
 	xfs_dir2_free_hdr_from_disk(mp, &freehdr, fbp->b_addr);
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index dc85197b8448e..fe8d4fa131289 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -175,11 +175,11 @@ const struct xfs_buf_ops xfs_dir3_free_buf_ops = {
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
 
@@ -195,7 +195,7 @@ xfs_dir3_free_header_check(
 			return __this_address;
 		if (be32_to_cpu(hdr3->nvalid) < be32_to_cpu(hdr3->nused))
 			return __this_address;
-		if (be64_to_cpu(hdr3->hdr.owner) != dp->i_ino)
+		if (be64_to_cpu(hdr3->hdr.owner) != owner)
 			return __this_address;
 	} else {
 		struct xfs_dir2_free_hdr *hdr = bp->b_addr;
@@ -214,6 +214,7 @@ static int
 __xfs_dir3_free_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
+	xfs_ino_t		owner,
 	xfs_dablk_t		fbno,
 	unsigned int		flags,
 	struct xfs_buf		**bpp)
@@ -227,7 +228,7 @@ __xfs_dir3_free_read(
 		return err;
 
 	/* Check things that we can't do in the verifier. */
-	fa = xfs_dir3_free_header_check(dp, fbno, *bpp);
+	fa = xfs_dir3_free_header_check(*bpp, owner, fbno);
 	if (fa) {
 		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
@@ -299,20 +300,23 @@ int
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
@@ -717,7 +721,7 @@ xfs_dir2_leafn_lookup_for_addname(
 				if (curbp)
 					xfs_trans_brelse(tp, curbp);
 
-				error = xfs_dir2_free_read(tp, dp,
+				error = xfs_dir2_free_read(tp, dp, args->owner,
 						xfs_dir2_db_to_da(args->geo,
 								  newfdb),
 						&curbp);
@@ -1356,8 +1360,8 @@ xfs_dir2_leafn_remove(
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
@@ -1716,7 +1720,7 @@ xfs_dir2_node_add_datablk(
 	 * that was just allocated.
 	 */
 	fbno = xfs_dir2_db_to_fdb(args->geo, *dbno);
-	error = xfs_dir2_free_try_read(tp, dp,
+	error = xfs_dir2_free_try_read(tp, dp, args->owner,
 			       xfs_dir2_db_to_da(args->geo, fbno), &fbp);
 	if (error)
 		return error;
@@ -1863,7 +1867,7 @@ xfs_dir2_node_find_freeblk(
 		 * so this might not succeed.  This should be really rare, so
 		 * there's no reason to avoid it.
 		 */
-		error = xfs_dir2_free_try_read(tp, dp,
+		error = xfs_dir2_free_try_read(tp, dp, args->owner,
 				xfs_dir2_db_to_da(args->geo, fbno),
 				&fbp);
 		if (error)
@@ -2302,7 +2306,7 @@ xfs_dir2_node_trim_free(
 	/*
 	 * Read the freespace block.
 	 */
-	error = xfs_dir2_free_try_read(tp, dp, fo, &bp);
+	error = xfs_dir2_free_try_read(tp, dp, args->owner, fo, &bp);
 	if (error)
 		return error;
 	/*
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index adbc544c9befa..3befb32509fa4 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
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
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 43f5bc8ce0d46..7bac74621af77 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -577,7 +577,7 @@ xchk_directory_free_bestfree(
 	int				error;
 
 	/* Read the free space block */
-	error = xfs_dir2_free_read(sc->tp, sc->ip, lblk, &bp);
+	error = xfs_dir2_free_read(sc->tp, sc->ip, sc->ip->i_ino, lblk, &bp);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
 		return error;
 	xchk_buffer_recheck(sc, bp);

