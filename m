Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA9A63D
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300451; cv=none; b=Lve+VNFI5G2hFy9gFBzJQje1/eg7X0G1wuRVEh3IQCvgXcZe1dwN0XYy3QdeepR0n4QIQdOWdQHREVUuKb/ycouiy6XGUqUI4PtFEH+ij5ooTBRjV+tKfv3dg159OoqPxwkk1sQJdrc0IDlY6RDJivBs3XXkSL7WEj5h6lPc5L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300451; c=relaxed/simple;
	bh=RjJFu9C8AJFZpQ+X7grIzFmlAttabbkNWLZ+REGfod8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rxxS/koG19QJl33pidxyGVWODz4CnDiob/PhrT3ztA+pKNR5TV8slo4nuEdR08J+dZjy2Be9ytBJOoREiAOemhXUl4rQd2j20/mciasdbMse17yYn/Nb4SnAovHQ/E56RcKDWyA0LCZQk0JQsT60KOwIxPhc9KCK8jq80+1djOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZHJdSxXA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZHJdSxXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CE8C32786;
	Tue, 30 Jul 2024 00:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300451;
	bh=RjJFu9C8AJFZpQ+X7grIzFmlAttabbkNWLZ+REGfod8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZHJdSxXAjf3mb45NWEj6VbKgbpjp8QIMTFLEFPY1lYRxPO0tNOC4XfVTIUuUIudas
	 AXfbykvZ5Xo5mWJWRsonFV4YPJ9oN73MC6hSZPgRPg+LnRcZ4egpVi2uFy+wTFQ87i
	 4thNFNNRAZOAO3L8DR0htV6hwx5RL/zscQnKrYaqIR8DIzPFlZDe965DoR7Arr9usE
	 RvT/f/gZPOnIIdllEm198QiEY3XGOjZ0hqgcG7A8YdyYqrWT0IUn7VuHg+MOFJf1r2
	 QeWidoPFi74TEf9jehLEp+s4Gew7NLfz6ZX2Ijijq57Lovvg0EtKqHb2vt9UaZR1U2
	 8MacRdALcTb0w==
Date: Mon, 29 Jul 2024 17:47:30 -0700
Subject: [PATCH 091/115] xfs: refactor dir format helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <172229843743.1338752.12553593713166400251.stgit@frogsfrogsfrogs>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: e58ac1770ded2a316447ca7608bb7809af82eca6

Add a new enum and a xfs_dir2_format helper that returns it to allow
the code to switch on the format of a directory in a single operation
and switch all helpers of xfs_dir2_isblock and xfs_dir2_isleaf to it.

This also removes the explicit xfs_iread_extents call in a few of the
call sites given that xfs_bmap_last_offset already takes care of it
underneath.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 db/namei.c               |   18 ++--
 libxfs/libxfs_api_defs.h |    3 -
 libxfs/xfs_dir2.c        |  188 ++++++++++++++++++----------------------------
 libxfs/xfs_dir2.h        |   12 ++-
 libxfs/xfs_exchmaps.c    |    9 --
 repair/phase6.c          |   21 ++---
 6 files changed, 105 insertions(+), 146 deletions(-)


diff --git a/db/namei.c b/db/namei.c
index 303ca3448..6de062161 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -449,18 +449,18 @@ listdir(
 		.geo		= dp->i_mount->m_dir_geo,
 	};
 	int			error;
-	bool			isblock;
 
-	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
+	switch (libxfs_dir2_format(&args, &error)) {
+	case XFS_DIR2_FMT_SF:
 		return list_sfdir(&args);
-
-	error = -libxfs_dir2_isblock(&args, &isblock);
-	if (error)
-		return error;
-
-	if (isblock)
+	case XFS_DIR2_FMT_BLOCK:
 		return list_blockdir(&args);
-	return list_leafdir(&args);
+	case XFS_DIR2_FMT_LEAF:
+	case XFS_DIR2_FMT_NODE:
+		return list_leafdir(&args);
+	default:
+		return error;
+	}
 }
 
 /* List the inode number of the currently selected inode. */
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 896b6c953..cc670d93a 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -122,9 +122,8 @@
 #define xfs_dir2_data_use_free		libxfs_dir2_data_use_free
 #define xfs_dir2_free_hdr_from_disk	libxfs_dir2_free_hdr_from_disk
 #define xfs_dir2_hashname		libxfs_dir2_hashname
-#define xfs_dir2_isblock		libxfs_dir2_isblock
-#define xfs_dir2_isleaf			libxfs_dir2_isleaf
 #define xfs_dir2_leaf_hdr_from_disk	libxfs_dir2_leaf_hdr_from_disk
+#define xfs_dir2_format			libxfs_dir2_format
 #define xfs_dir2_namecheck		libxfs_dir2_namecheck
 #define xfs_dir2_sf_entsize		libxfs_dir2_sf_entsize
 #define xfs_dir2_sf_get_ftype		libxfs_dir2_sf_get_ftype
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 55cf39e11..9cf05ec51 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -255,31 +255,60 @@ xfs_dir_init(
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
@@ -358,36 +387,25 @@ int
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
@@ -447,24 +465,20 @@ int
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
@@ -508,25 +522,20 @@ int
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
@@ -632,57 +641,6 @@ xfs_dir2_grow_inode(
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
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 6c00fe24a..6dbe6e9ec 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
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
 
diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index a8a51ce53..08bfe6f1b 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -462,17 +462,12 @@ xfs_exchmaps_dir_to_sf(
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
diff --git a/repair/phase6.c b/repair/phase6.c
index 2eba9772d..1e985e7db 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2269,12 +2269,12 @@ longform_dir2_entry_check(
 	xfs_dablk_t		da_bno;
 	freetab_t		*freetab;
 	int			i;
-	bool			isblock;
-	bool			isleaf;
+	enum xfs_dir2_fmt	fmt;
 	xfs_fileoff_t		next_da_bno;
 	int			seeval;
 	int			fixit = 0;
 	struct xfs_da_args	args;
+	int			error;
 
 	*need_dot = 1;
 	freetab = malloc(FREETAB_SIZE(ip->i_disk_size / mp->m_dir_geo->blksize));
@@ -2294,8 +2294,7 @@ longform_dir2_entry_check(
 	/* is this a block, leaf, or node directory? */
 	args.dp = ip;
 	args.geo = mp->m_dir_geo;
-	libxfs_dir2_isblock(&args, &isblock);
-	libxfs_dir2_isleaf(&args, &isleaf);
+	fmt = libxfs_dir2_format(&args, &error);
 
 	/* check directory "data" blocks (ie. name/inode pairs) */
 	for (da_bno = 0, next_da_bno = 0;
@@ -2318,7 +2317,7 @@ longform_dir2_entry_check(
 			break;
 		}
 
-		if (isblock)
+		if (fmt == XFS_DIR2_FMT_BLOCK)
 			ops = &xfs_dir3_block_buf_ops;
 		else
 			ops = &xfs_dir3_data_buf_ops;
@@ -2335,7 +2334,7 @@ longform_dir2_entry_check(
 			 * block form and we fail, there isn't anything else to
 			 * read, and nothing we can do but trash it.
 			 */
-			if (isblock) {
+			if (fmt == XFS_DIR2_FMT_BLOCK) {
 				fixit++;
 				goto out_fix;
 			}
@@ -2349,7 +2348,7 @@ longform_dir2_entry_check(
 			error = check_dir3_header(mp, bp, ino);
 			if (error) {
 				fixit++;
-				if (isblock)
+				if (fmt == XFS_DIR2_FMT_BLOCK)
 					goto out_fix;
 
 				libxfs_buf_relse(bp);
@@ -2360,8 +2359,8 @@ longform_dir2_entry_check(
 
 		longform_dir2_entry_check_data(mp, ip, num_illegal, need_dot,
 				irec, ino_offset, bp, hashtab,
-				&freetab, da_bno, isblock);
-		if (isblock)
+				&freetab, da_bno, fmt == XFS_DIR2_FMT_BLOCK);
+		if (fmt == XFS_DIR2_FMT_BLOCK)
 			break;
 
 		libxfs_buf_relse(bp);
@@ -2371,7 +2370,7 @@ longform_dir2_entry_check(
 
 	if (!dotdot_update) {
 		/* check btree and freespace */
-		if (isblock) {
+		if (fmt == XFS_DIR2_FMT_BLOCK) {
 			struct xfs_dir2_data_hdr *block;
 			xfs_dir2_block_tail_t	*btp;
 			xfs_dir2_leaf_entry_t	*blp;
@@ -2384,7 +2383,7 @@ longform_dir2_entry_check(
 						be32_to_cpu(btp->stale));
 			if (dir_hash_check(hashtab, ip, seeval))
 				fixit |= 1;
-		} else if (isleaf) {
+		} else if (fmt == XFS_DIR2_FMT_LEAF) {
 			fixit |= longform_dir2_check_leaf(mp, ip, hashtab,
 								freetab);
 		} else {

