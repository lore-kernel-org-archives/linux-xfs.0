Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152382417C0
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 23:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738883000; cv=none; b=Hi298dDkysGpOv1E029RgIbrrnq5U/3w29J+4BJI5G0yhUGhRpidzjSfMGoin38dj78d1iYFFn1GjFHpPFHGm1OGCw6Mv/JaFDd1d9AJg6IUz5PdddNdnJgOkqocyH42+YetBmPsp8ndUBD4EDysyRf1YBtVt5t92saRZJeiKP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738883000; c=relaxed/simple;
	bh=N6jj/6dXE2y6hBO2v061SiUOuk1WzH3vjF6qdjJqE6k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j0uMyX4bVcOpXOMTzh5gU//r9TJp+l+LfBkcjs+J8Iqomdsr+QCdQz3lr5J3Tuv6KMICdbeiVtiGRZugt/Hy8xR4UIR71QUdna6QSvFH7jZ7dQyTX3V1atTUZxKldLsogd+ugPydhupP6Z5r5yAyx/Q6rMQpOq8TfkLCznHwTtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K8FTNkwG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K8FTNkwG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848DDC4CEDF;
	Thu,  6 Feb 2025 23:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882997;
	bh=N6jj/6dXE2y6hBO2v061SiUOuk1WzH3vjF6qdjJqE6k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=K8FTNkwGEFzbNamQt86HxRLwOgUFcJSeHl7EedihMqChtvQmzitNq94galmf4h+aB
	 DGqu7hUIBIRqbmk6vlXGHPKwRbLzJY2e+RqUuzoe0RWhDtyib6fTU314xfW/PEAe6x
	 ekMKWbCV2FNupUCepMF+lQHuRY34UargCifLzqu3ZZsD5FnAC5NJ+yFmk2dufwusHV
	 NNcKodFmXkpxSWxysVR6zzaXp+WGxUuVxUmAtitxmHyqWvBFh38pRIj+T39dzjqZDb
	 KNMVYap/hK2kUWW6xMwvsnMoeV0UW+8e7A0Hxe3046LJMzWXr+LHp8t6DTlwBQ422o
	 gJboj4s1GD2xQ==
Date: Thu, 06 Feb 2025 15:03:17 -0800
Subject: [PATCH 3/4] xfs_db: make listdir more generally useful
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888089649.2742734.4268130787597232707.stgit@frogsfrogsfrogs>
In-Reply-To: <173888089597.2742734.4600497543125166516.stgit@frogsfrogsfrogs>
References: <173888089597.2742734.4600497543125166516.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Enhance the current directory entry iteration code in xfs_db to be more
generally useful by allowing callers to pass around a transaction, a
callback function, and a private pointer.  This will be used in the next
patch to iterate directories when we want to copy their contents out of
the filesystem into a directory.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/namei.c |   83 +++++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 57 insertions(+), 26 deletions(-)


diff --git a/db/namei.c b/db/namei.c
index 22eae50f219fd0..6f277a65ed91ac 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -266,15 +266,18 @@ get_dstr(
 	return filetype_strings[filetype];
 }
 
-static void
-dir_emit(
-	struct xfs_mount	*mp,
+static int
+print_dirent(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
 	xfs_dir2_dataptr_t	off,
 	char			*name,
 	ssize_t			namelen,
 	xfs_ino_t		ino,
-	uint8_t			dtype)
+	uint8_t			dtype,
+	void			*private)
 {
+	struct xfs_mount	*mp = dp->i_mount;
 	char			*display_name;
 	struct xfs_name		xname = { .name = (unsigned char *)name };
 	const char		*dstr = get_dstr(mp, dtype);
@@ -306,11 +309,14 @@ dir_emit(
 
 	if (display_name != name)
 		free(display_name);
+	return 0;
 }
 
 static int
 list_sfdir(
-	struct xfs_da_args		*args)
+	struct xfs_da_args		*args,
+	dir_emit_t			dir_emit,
+	void				*private)
 {
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_mount		*mp = dp->i_mount;
@@ -321,17 +327,24 @@ list_sfdir(
 	xfs_dir2_dataptr_t		off;
 	unsigned int			i;
 	uint8_t				filetype;
+	int				error;
 
 	/* . and .. entries */
 	off = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
 			geo->data_entry_offset);
-	dir_emit(args->dp->i_mount, off, ".", -1, dp->i_ino, XFS_DIR3_FT_DIR);
+	error = dir_emit(args->trans, args->dp, off, ".", -1, dp->i_ino,
+			XFS_DIR3_FT_DIR, private);
+	if (error)
+		return error;
 
 	ino = libxfs_dir2_sf_get_parent_ino(sfp);
 	off = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
 			geo->data_entry_offset +
 			libxfs_dir2_data_entsize(mp, sizeof(".") - 1));
-	dir_emit(args->dp->i_mount, off, "..", -1, ino, XFS_DIR3_FT_DIR);
+	error = dir_emit(args->trans, args->dp, off, "..", -1, ino,
+			XFS_DIR3_FT_DIR, private);
+	if (error)
+		return error;
 
 	/* Walk everything else. */
 	sfep = xfs_dir2_sf_firstentry(sfp);
@@ -341,8 +354,11 @@ list_sfdir(
 		off = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
 				xfs_dir2_sf_get_offset(sfep));
 
-		dir_emit(args->dp->i_mount, off, (char *)sfep->name,
-				sfep->namelen, ino, filetype);
+		error = dir_emit(args->trans, args->dp, off,
+				(char *)sfep->name, sfep->namelen, ino,
+				filetype, private);
+		if (error)
+			return error;
 		sfep = libxfs_dir2_sf_nextentry(mp, sfp, sfep);
 	}
 
@@ -352,7 +368,9 @@ list_sfdir(
 /* List entries in block format directory. */
 static int
 list_blockdir(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	dir_emit_t		dir_emit,
+	void			*private)
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
@@ -363,7 +381,7 @@ list_blockdir(
 	unsigned int		end;
 	int			error;
 
-	error = xfs_dir3_block_read(NULL, dp, args->owner, &bp);
+	error = xfs_dir3_block_read(args->trans, dp, args->owner, &bp);
 	if (error)
 		return error;
 
@@ -383,8 +401,11 @@ list_blockdir(
 		diroff = xfs_dir2_db_off_to_dataptr(geo, geo->datablk, offset);
 		offset += libxfs_dir2_data_entsize(mp, dep->namelen);
 		filetype = libxfs_dir2_data_get_ftype(dp->i_mount, dep);
-		dir_emit(mp, diroff, (char *)dep->name, dep->namelen,
-				be64_to_cpu(dep->inumber), filetype);
+		error = dir_emit(args->trans, args->dp, diroff,
+				(char *)dep->name, dep->namelen,
+				be64_to_cpu(dep->inumber), filetype, private);
+		if (error)
+			break;
 	}
 
 	libxfs_trans_brelse(args->trans, bp);
@@ -394,7 +415,9 @@ list_blockdir(
 /* List entries in leaf format directory. */
 static int
 list_leafdir(
-	struct xfs_da_args	*args)
+	struct xfs_da_args	*args,
+	dir_emit_t		dir_emit,
+	void			*private)
 {
 	struct xfs_bmbt_irec	map;
 	struct xfs_iext_cursor	icur;
@@ -408,7 +431,7 @@ list_leafdir(
 	int			error = 0;
 
 	/* Read extent map. */
-	error = -libxfs_iread_extents(NULL, dp, XFS_DATA_FORK);
+	error = -libxfs_iread_extents(args->trans, dp, XFS_DATA_FORK);
 	if (error)
 		return error;
 
@@ -424,7 +447,7 @@ list_leafdir(
 		libxfs_trim_extent(&map, dabno, geo->leafblk - dabno);
 
 		/* Read the directory block of that first mapping. */
-		error = xfs_dir3_data_read(NULL, dp, args->owner,
+		error = xfs_dir3_data_read(args->trans, dp, args->owner,
 				map.br_startoff, 0, &bp);
 		if (error)
 			break;
@@ -449,18 +472,22 @@ list_leafdir(
 			offset += libxfs_dir2_data_entsize(mp, dep->namelen);
 			filetype = libxfs_dir2_data_get_ftype(mp, dep);
 
-			dir_emit(mp, xfs_dir2_byte_to_dataptr(dirboff + offset),
+			error = dir_emit(args->trans, args->dp,
+					xfs_dir2_byte_to_dataptr(dirboff + offset),
 					(char *)dep->name, dep->namelen,
-					be64_to_cpu(dep->inumber), filetype);
+					be64_to_cpu(dep->inumber), filetype,
+					private);
+			if (error)
+				break;
 		}
 
 		dabno += XFS_DADDR_TO_FSB(mp, bp->b_length);
-		libxfs_buf_relse(bp);
+		libxfs_trans_brelse(args->trans, bp);
 		bp = NULL;
 	}
 
 	if (bp)
-		libxfs_buf_relse(bp);
+		libxfs_trans_brelse(args->trans, bp);
 
 	return error;
 }
@@ -468,9 +495,13 @@ list_leafdir(
 /* Read the directory, display contents. */
 static int
 listdir(
-	struct xfs_inode	*dp)
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	dir_emit_t		dir_emit,
+	void			*private)
 {
 	struct xfs_da_args	args = {
+		.trans		= tp,
 		.dp		= dp,
 		.geo		= dp->i_mount->m_dir_geo,
 		.owner		= dp->i_ino,
@@ -479,14 +510,14 @@ listdir(
 
 	switch (libxfs_dir2_format(&args, &error)) {
 	case XFS_DIR2_FMT_SF:
-		return list_sfdir(&args);
+		return list_sfdir(&args, dir_emit, private);
 	case XFS_DIR2_FMT_BLOCK:
-		return list_blockdir(&args);
+		return list_blockdir(&args, dir_emit, private);
 	case XFS_DIR2_FMT_LEAF:
 	case XFS_DIR2_FMT_NODE:
-		return list_leafdir(&args);
+		return list_leafdir(&args, dir_emit, private);
 	default:
-		return error;
+		return EFSCORRUPTED;
 	}
 }
 
@@ -526,7 +557,7 @@ ls_cur(
 	if (tag)
 		dbprintf(_("%s:\n"), tag);
 
-	error = listdir(dp);
+	error = listdir(NULL, dp, print_dirent, NULL);
 	if (error)
 		goto rele;
 

