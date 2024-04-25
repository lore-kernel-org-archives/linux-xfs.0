Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB561494B4
	for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 13:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714051041; cv=none; b=KxWudw0PYLafEa0esOJJVRkuuq53pzZE5YmOkbZ8CIKCVl7NFndumGb62qKly8NGsy55I6jqD1TRwIXL2GuFiV0bCa6HMaXLBlGAqinanajIncDi2iDW69TSswW2/TL87zMYqt0tlaXv6N3LFXl/cZ4LFcFvnC0P5/JFoW0MrPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714051041; c=relaxed/simple;
	bh=UZ4hNf0yfJfeINCNrhyY5n/fSa0J7fL4pcf+jPQY7N8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nj3t9IKi1I+Ume7VFImMsKIcVx5S/BS13898ei5ZT+bxGdFsKrMnj52WonN8sHsgn1EsexXzFVNDL8mMP0puo45iGumt11m7Aa8GWjkxShTiwWfBX/kzFmJMJwZATEliethMfmE6d17ngDvKxLrfgn0KqqWtRSr0xPdFn00d3/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=e/5soUPo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e/5soUPo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UM+4xBPGLAMlG8WIcgQZePAoNeVAkaSEeGJayHkzWfE=; b=e/5soUPoROlWxeG5oCmDxYP655
	6hz8RM3JmARfm0ZB/MNQC60ITvJO1p+W66uFE/JDQ5e3w5ZLtPWX5JNm1/MquChmD9XKNvr8DYGW2
	Uz4syG4sctxh7vOaNF13XKAhWtuTBmjzEoYE6kN8wSjmoPlpHMsZ/LXzRR6lRav2Y/GRlMnuI1D2X
	42hMths8smEM5SmpzQJNFnVBK+1b55pfhjjiWqTCNtYnVBzW9NBObrPNK0K6pyYKVQHu9I+dusc9h
	JWLL77iKiVElG+0vyDQWEig1OKEKn+xsKPpqbHiOCKRka/4tPNcf8+03XLNGoo9t2FwwlhvxJ5IWZ
	x7CsikFA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rzyyV-00000008Rdf-2EjY;
	Thu, 25 Apr 2024 13:17:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 5/5] xfs: refactor dir format helpers
Date: Thu, 25 Apr 2024 15:17:03 +0200
Message-Id: <20240425131703.928936-6-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240425131703.928936-1-hch@lst.de>
References: <20240425131703.928936-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a new enum and a xfs_dir2_format helper that returns it to allow
the code to switch on the format of a directory in a single operation
and switch all helpers of xfs_dir2_isblock and xfs_dir2_isleaf to it.

This also removes the explicit xfs_iread_extents call in a few of the
call sites given that xfs_bmap_last_offset already takes care of it
underneath.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2.c     | 188 ++++++++++++++---------------------
 fs/xfs/libxfs/xfs_dir2.h     |  12 ++-
 fs/xfs/libxfs/xfs_exchmaps.c |   9 +-
 fs/xfs/scrub/dir.c           |   3 +-
 fs/xfs/scrub/readdir.c       |  24 ++---
 fs/xfs/xfs_dir2_readdir.c    |  19 ++--
 6 files changed, 105 insertions(+), 150 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index d3d4d80c2098d3..e3881bbad0a01c 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -256,31 +256,60 @@ xfs_dir_init(
 	return error;
 }
 
+enum xfs_dir2_fmt
+xfs_dir2_format(
+	struct xfs_da_args	*args,
+	int			*error)
+{
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_da_geometry	*geo = mp->m_dir_geo;
+	xfs_fileoff_t		eof;
+ 
+	xfs_assert_ilocked(dp, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL);
+
+	*error = 0;
+	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
+		return XFS_DIR2_FMT_SF;
+
+	*error = xfs_bmap_last_offset(dp, &eof, XFS_DATA_FORK);
+	if (*error)
+		return XFS_DIR2_FMT_ERROR;
+
+	if (eof == XFS_B_TO_FSB(mp, geo->blksize)) {
+		if (XFS_IS_CORRUPT(mp, dp->i_disk_size != geo->blksize)) {
+			xfs_da_mark_sick(args);
+			*error = -EFSCORRUPTED;
+			return XFS_DIR2_FMT_ERROR;
+		}
+		return XFS_DIR2_FMT_BLOCK;
+	}
+	if (eof == geo->leafblk + geo->fsbcount)
+		return XFS_DIR2_FMT_LEAF;
+	return XFS_DIR2_FMT_NODE;
+}
+
 int
 xfs_dir_createname_args(
 	struct xfs_da_args	*args)
 {
-	bool			is_block, is_leaf;
 	int			error;
 
 	if (!args->inumber)
 		args->op_flags |= XFS_DA_OP_JUSTCHECK;
 
-	if (args->dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
+	switch (xfs_dir2_format(args, &error)) {
+	case XFS_DIR2_FMT_SF:
 		return xfs_dir2_sf_addname(args);
-
-	error = xfs_dir2_isblock(args, &is_block);
-	if (error)
-		return error;
-	if (is_block)
+	case XFS_DIR2_FMT_BLOCK:
 		return xfs_dir2_block_addname(args);
-
-	error = xfs_dir2_isleaf(args, &is_leaf);
-	if (error)
-		return error;
-	if (is_leaf)
+	case XFS_DIR2_FMT_LEAF:
 		return xfs_dir2_leaf_addname(args);
-	return xfs_dir2_node_addname(args);
+	case XFS_DIR2_FMT_NODE:
+		return xfs_dir2_node_addname(args);
+	default:
+		return error;	
+	}
 }
 
 /*
@@ -359,36 +388,25 @@ int
 xfs_dir_lookup_args(
 	struct xfs_da_args	*args)
 {
-	bool			is_block, is_leaf;
 	int			error;
 
-	if (args->dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
+	switch (xfs_dir2_format(args, &error)) {
+	case XFS_DIR2_FMT_SF:
 		error = xfs_dir2_sf_lookup(args);
-		goto out;
-	}
-
-	/* dir2 functions require that the data fork is loaded */
-	error = xfs_iread_extents(args->trans, args->dp, XFS_DATA_FORK);
-	if (error)
-		goto out;
-
-	error = xfs_dir2_isblock(args, &is_block);
-	if (error)
-		goto out;
-
-	if (is_block) {
+		break;
+	case XFS_DIR2_FMT_BLOCK:
 		error = xfs_dir2_block_lookup(args);
-		goto out;
-	}
-
-	error = xfs_dir2_isleaf(args, &is_leaf);
-	if (error)
-		goto out;
-	if (is_leaf)
+		break;
+	case XFS_DIR2_FMT_LEAF:
 		error = xfs_dir2_leaf_lookup(args);
-	else
+		break;
+	case XFS_DIR2_FMT_NODE:
 		error = xfs_dir2_node_lookup(args);
-out:
+		break;
+	default:
+		break;
+	}
+
 	if (error != -EEXIST)
 		return error;
 	return 0;
@@ -448,24 +466,20 @@ int
 xfs_dir_removename_args(
 	struct xfs_da_args	*args)
 {
-	bool			is_block, is_leaf;
 	int			error;
 
-	if (args->dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
+	switch (xfs_dir2_format(args, &error)) {
+	case XFS_DIR2_FMT_SF:
 		return xfs_dir2_sf_removename(args);
-
-	error = xfs_dir2_isblock(args, &is_block);
-	if (error)
-		return error;
-	if (is_block)
+	case XFS_DIR2_FMT_BLOCK:
 		return xfs_dir2_block_removename(args);
-
-	error = xfs_dir2_isleaf(args, &is_leaf);
-	if (error)
-		return error;
-	if (is_leaf)
+	case XFS_DIR2_FMT_LEAF:
 		return xfs_dir2_leaf_removename(args);
-	return xfs_dir2_node_removename(args);
+	case XFS_DIR2_FMT_NODE:
+		return xfs_dir2_node_removename(args);
+	default:
+		return error;
+	}
 }
 
 /*
@@ -509,25 +523,20 @@ int
 xfs_dir_replace_args(
 	struct xfs_da_args	*args)
 {
-	bool			is_block, is_leaf;
 	int			error;
 
-	if (args->dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
+	switch (xfs_dir2_format(args, &error)) {
+	case XFS_DIR2_FMT_SF:
 		return xfs_dir2_sf_replace(args);
-
-	error = xfs_dir2_isblock(args, &is_block);
-	if (error)
-		return error;
-	if (is_block)
+	case XFS_DIR2_FMT_BLOCK:
 		return xfs_dir2_block_replace(args);
-
-	error = xfs_dir2_isleaf(args, &is_leaf);
-	if (error)
-		return error;
-	if (is_leaf)
+	case XFS_DIR2_FMT_LEAF:
 		return xfs_dir2_leaf_replace(args);
-
-	return xfs_dir2_node_replace(args);
+	case XFS_DIR2_FMT_NODE:
+		return xfs_dir2_node_replace(args);
+	default:
+		return error;
+	}
 }
 
 /*
@@ -633,57 +642,6 @@ xfs_dir2_grow_inode(
 	return 0;
 }
 
-/*
- * See if the directory is a single-block form directory.
- */
-int
-xfs_dir2_isblock(
-	struct xfs_da_args	*args,
-	bool			*isblock)
-{
-	struct xfs_mount	*mp = args->dp->i_mount;
-	xfs_fileoff_t		eof;
-	int			error;
-
-	error = xfs_bmap_last_offset(args->dp, &eof, XFS_DATA_FORK);
-	if (error)
-		return error;
-
-	*isblock = false;
-	if (XFS_FSB_TO_B(mp, eof) != args->geo->blksize)
-		return 0;
-
-	*isblock = true;
-	if (XFS_IS_CORRUPT(mp, args->dp->i_disk_size != args->geo->blksize)) {
-		xfs_da_mark_sick(args);
-		return -EFSCORRUPTED;
-	}
-	return 0;
-}
-
-/*
- * See if the directory is a single-leaf form directory.
- */
-int
-xfs_dir2_isleaf(
-	struct xfs_da_args	*args,
-	bool			*isleaf)
-{
-	xfs_fileoff_t		eof;
-	int			error;
-
-	error = xfs_bmap_last_offset(args->dp, &eof, XFS_DATA_FORK);
-	if (error)
-		return error;
-
-	*isleaf = false;
-	if (eof != args->geo->leafblk + args->geo->fsbcount)
-		return 0;
-
-	*isleaf = true;
-	return 0;
-}
-
 /*
  * Remove the given block from the directory.
  * This routine is used for data and free blocks, leaf/node are done
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 6c00fe24a8987e..6dbe6e9ecb491f 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -36,6 +36,16 @@ xfs_dir2_samename(
 	return !memcmp(n1->name, n2->name, n1->len);
 }
 
+enum xfs_dir2_fmt {
+	XFS_DIR2_FMT_SF,
+	XFS_DIR2_FMT_BLOCK,
+	XFS_DIR2_FMT_LEAF,
+	XFS_DIR2_FMT_NODE,
+	XFS_DIR2_FMT_ERROR,
+};
+
+enum xfs_dir2_fmt xfs_dir2_format(struct xfs_da_args *args, int *error);
+
 /*
  * Convert inode mode to directory entry filetype
  */
@@ -79,8 +89,6 @@ extern int xfs_dir2_sf_to_block(struct xfs_da_args *args);
 /*
  * Interface routines used by userspace utilities
  */
-extern int xfs_dir2_isblock(struct xfs_da_args *args, bool *isblock);
-extern int xfs_dir2_isleaf(struct xfs_da_args *args, bool *isleaf);
 extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
 				struct xfs_buf *bp);
 
diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index 44ab6a9235c0bd..2021396651de27 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -465,17 +465,12 @@ xfs_exchmaps_dir_to_sf(
 	};
 	struct xfs_dir2_sf_hdr	sfh;
 	struct xfs_buf		*bp;
-	bool			isblock;
 	int			size;
-	int			error;
+	int			error = 0;
 
-	error = xfs_dir2_isblock(&args, &isblock);
-	if (error)
+	if (xfs_dir2_format(&args, &error) != XFS_DIR2_FMT_BLOCK)
 		return error;
 
-	if (!isblock)
-		return 0;
-
 	error = xfs_dir3_block_read(tp, xmi->xmi_ip2, xmi->xmi_ip2->i_ino, &bp);
 	if (error)
 		return error;
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 62474d0557c41a..bf9199e8df633f 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -808,7 +808,8 @@ xchk_directory_blocks(
 	free_lblk = XFS_B_TO_FSB(mp, XFS_DIR2_FREE_OFFSET);
 
 	/* Is this a block dir? */
-	error = xfs_dir2_isblock(&args, &is_block);
+	if (xfs_dir2_format(&args, &error) == XFS_DIR2_FMT_BLOCK)
+		is_block = true;
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
 		goto out;
 
diff --git a/fs/xfs/scrub/readdir.c b/fs/xfs/scrub/readdir.c
index 0ac77359d8e9f8..01c9a2dc0f2c48 100644
--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -276,7 +276,6 @@ xchk_dir_walk(
 		.trans		= sc->tp,
 		.owner		= dp->i_ino,
 	};
-	bool			isblock;
 	int			error;
 
 	if (xfs_is_shutdown(dp->i_mount))
@@ -285,22 +284,17 @@ xchk_dir_walk(
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	xfs_assert_ilocked(dp, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL);
 
-	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
+	switch (xfs_dir2_format(&args, &error)) {
+	case XFS_DIR2_FMT_SF:
 		return xchk_dir_walk_sf(sc, dp, dirent_fn, priv);
-
-	/* dir2 functions require that the data fork is loaded */
-	error = xfs_iread_extents(sc->tp, dp, XFS_DATA_FORK);
-	if (error)
-		return error;
-
-	error = xfs_dir2_isblock(&args, &isblock);
-	if (error)
-		return error;
-
-	if (isblock)
+	case XFS_DIR2_FMT_BLOCK:
 		return xchk_dir_walk_block(sc, dp, dirent_fn, priv);
-
-	return xchk_dir_walk_leaf(sc, dp, dirent_fn, priv);
+	case XFS_DIR2_FMT_LEAF:
+	case XFS_DIR2_FMT_NODE:
+		return xchk_dir_walk_leaf(sc, dp, dirent_fn, priv);
+	default:
+		return error;
+	}
 }
 
 /*
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index b3abad5a6cd800..06ac5a7de60a04 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -516,7 +516,6 @@ xfs_readdir(
 {
 	struct xfs_da_args	args = { NULL };
 	unsigned int		lock_mode;
-	bool			isblock;
 	int			error;
 
 	trace_xfs_readdir(dp);
@@ -539,18 +538,18 @@ xfs_readdir(
 		return xfs_dir2_sf_getdents(&args, ctx);
 
 	lock_mode = xfs_ilock_data_map_shared(dp);
-	error = xfs_dir2_isblock(&args, &isblock);
-	if (error)
-		goto out_unlock;
-
-	if (isblock) {
+	switch (xfs_dir2_format(&args, &error)) {
+	case XFS_DIR2_FMT_BLOCK:
 		error = xfs_dir2_block_getdents(&args, ctx, &lock_mode);
-		goto out_unlock;
+		break;
+	case XFS_DIR2_FMT_LEAF:
+	case XFS_DIR2_FMT_NODE:
+		error = xfs_dir2_leaf_getdents(&args, ctx, bufsize, &lock_mode);
+		break;
+	default:
+		break;
 	}
 
-	error = xfs_dir2_leaf_getdents(&args, ctx, bufsize, &lock_mode);
-
-out_unlock:
 	if (lock_mode)
 		xfs_iunlock(dp, lock_mode);
 	return error;
-- 
2.39.2

