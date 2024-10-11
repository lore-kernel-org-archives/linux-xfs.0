Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78534A1A
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609344; cv=none; b=g6LWvHA2bekifCRVloYWrJTLFwCaSfxJOvDJHDpx+3UDvWXxo0dZVPZLOcEVBwQWc/tDwEO+m6/9vPFw0y28/LOGr28f+WGwBx6ouM37T4dAEbgbDqJFesPSr2S/oKiOKiMu/RKDQxJNp/xz/1DqT9bWi89BUcLahSh90xcwjaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609344; c=relaxed/simple;
	bh=mepHrrUP9KR+ESnastH8XK6q/JqduKHCFD+Oi6ts1Qc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X6vyqCTGsCo1rh8Jbk3alS+woqf7MiAAoVngHXguDXG9IL0PlSeOKsrivzXQ+1S+lcJtMw3WlNthH9c5Bs3/fZTQcaiFjCrbDUH79rLFBxJMT0bsKGK11Kn6gipb2RtYW85asLZQGpvRWTm6xtdZZnekof3ckJlMl8t1Un3iXQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DVyJdEED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DVyJdEED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C38DC4CEC5;
	Fri, 11 Oct 2024 01:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609344;
	bh=mepHrrUP9KR+ESnastH8XK6q/JqduKHCFD+Oi6ts1Qc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DVyJdEEDpmjZ7/B7s45MtG7aBcfKQUbawo+vcvjVGIGDLkUWPXQDPoWiRf93blFMb
	 J7SFFb3NGHid3PeJN0NJA9Qj99ZwNK4+Tu9xUwBHQ4oIKVlDoMhFEBH7HC7YuK1BnQ
	 rU8QnmBsvH+1CJYldaWHRm8NBCPcEDpYW0mwR7CuzbuFqV1fnPAkGhPVVgWh5OE07m
	 pb5/M7pPFPYapgMRdnMxLAaCK00MzTjxjRKiz8leNkneY3t9pZIyQvoqc1Lrr9ACVl
	 bNze+y9blwqlUW/0P3xNGWE29HGg+pvRrueUH7BT80G6Z0v+pnsdzq+e5O87qKuj0H
	 XilhMCvhYr/0g==
Date: Thu, 10 Oct 2024 18:15:43 -0700
Subject: [PATCH 06/38] xfs_db: don't obfuscate metadata directories and
 attributes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654069.4183231.8627162465591121790.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
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

Don't obfuscate the directory and attribute names of metadata inodes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/metadump.c |  385 +++++++++++++++++++++++++++------------------------------
 1 file changed, 183 insertions(+), 202 deletions(-)


diff --git a/db/metadump.c b/db/metadump.c
index 5c57c1293a53cb..144ebfbfe2a90e 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1056,10 +1056,26 @@ generate_obfuscated_name(
 		free(orig_name);
 }
 
+static inline bool
+is_metadata_ino(
+	struct xfs_dinode	*dip)
+{
+	if (!xfs_has_metadir(mp) || dip->di_version < 3)
+		return false;
+	return dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA);
+}
+
+static inline bool
+want_obfuscate_dirents(bool is_meta)
+{
+	return metadump.obfuscate && !is_meta;
+}
+
 static void
 process_sf_dir(
 	struct xfs_dinode	*dip)
 {
+	bool			is_meta = is_metadata_ino(dip);
 	struct xfs_dir2_sf_hdr	*sfp;
 	xfs_dir2_sf_entry_t	*sfep;
 	uint64_t		ino_dir_size;
@@ -1105,7 +1121,7 @@ process_sf_dir(
 					 (char *)sfp);
 		}
 
-		if (metadump.obfuscate)
+		if (want_obfuscate_dirents(is_meta))
 			generate_obfuscated_name(
 					 libxfs_dir2_sf_get_ino(mp, sfp, sfep),
 					 namelen, &sfep->name[0]);
@@ -1201,7 +1217,8 @@ maybe_obfuscate_pptr(
 	uint8_t				*name,
 	int				namelen,
 	const void			*value,
-	int				valuelen)
+	int				valuelen,
+	bool				is_meta)
 {
 	unsigned char			old_name[MAXNAMELEN];
 	struct remap_ent		*remap;
@@ -1210,7 +1227,7 @@ maybe_obfuscate_pptr(
 	xfs_ino_t			parent_ino;
 	int				error;
 
-	if (!metadump.obfuscate)
+	if (!metadump.obfuscate || is_meta)
 		return;
 
 	if (!(attr_flags & XFS_ATTR_PARENT))
@@ -1274,9 +1291,10 @@ want_obfuscate_attr(
 	const void	*name,
 	unsigned int	namelen,
 	const void	*value,
-	unsigned int	valuelen)
+	unsigned int	valuelen,
+	bool		is_meta)
 {
-	if (!metadump.obfuscate)
+	if (!metadump.obfuscate || is_meta)
 		return false;
 
 	/*
@@ -1289,15 +1307,15 @@ want_obfuscate_attr(
 	return true;
 }
 
+/*
+ * Obfuscate the attr names and fill the actual values with 'v' (to see a valid
+ * string length, as opposed to NULLs).
+ */
 static void
 process_sf_attr(
 	struct xfs_dinode		*dip)
 {
-	/*
-	 * with extended attributes, obfuscate the names and fill the actual
-	 * values with 'v' (to see a valid string length, as opposed to NULLs)
-	 */
-
+	bool				is_meta = is_metadata_ino(dip);
 	struct xfs_attr_sf_hdr		*hdr = XFS_DFORK_APTR(dip);
 	struct xfs_attr_sf_entry	*asfep = libxfs_attr_sf_firstentry(hdr);
 	int				ino_attr_size;
@@ -1338,9 +1356,9 @@ process_sf_attr(
 
 		if (asfep->flags & XFS_ATTR_PARENT) {
 			maybe_obfuscate_pptr(asfep->flags, name, namelen,
-					value, asfep->valuelen);
+					value, asfep->valuelen, is_meta);
 		} else if (want_obfuscate_attr(asfep->flags, name, namelen,
-					value, asfep->valuelen)) {
+					value, asfep->valuelen, is_meta)) {
 			generate_obfuscated_name(0, asfep->namelen, name);
 			memset(value, 'v', asfep->valuelen);
 		}
@@ -1442,7 +1460,8 @@ static void
 process_dir_data_block(
 	char		*block,
 	xfs_fileoff_t	offset,
-	int		is_block_format)
+	int		is_block_format,
+	bool		is_meta)
 {
 	/*
 	 * we have to rely on the fileoffset and signature of the block to
@@ -1549,7 +1568,7 @@ process_dir_data_block(
 				dir_offset)
 			return;
 
-		if (metadump.obfuscate)
+		if (want_obfuscate_dirents(is_meta))
 			generate_obfuscated_name(be64_to_cpu(dep->inumber),
 					 dep->namelen, &dep->name[0]);
 		dir_offset += length;
@@ -1574,7 +1593,8 @@ process_symlink_block(
 	xfs_fsblock_t	s,
 	xfs_filblks_t	c,
 	typnm_t		btype,
-	xfs_fileoff_t	last)
+	xfs_fileoff_t	last,
+	bool		is_meta)
 {
 	struct bbmap	map;
 	char		*link;
@@ -1599,7 +1619,7 @@ process_symlink_block(
 	if (xfs_has_crc((mp)))
 		link += sizeof(struct xfs_dsymlink_hdr);
 
-	if (metadump.obfuscate)
+	if (want_obfuscate_dirents(is_meta))
 		obfuscate_path_components(link, XFS_SYMLINK_BUF_SPACE(mp,
 							mp->m_sb.sb_blocksize));
 	if (metadump.zero_stale_data) {
@@ -1650,7 +1670,8 @@ add_remote_vals(
 static void
 process_attr_block(
 	char				*block,
-	xfs_fileoff_t			offset)
+	xfs_fileoff_t			offset,
+	bool				is_meta)
 {
 	struct xfs_attr_leafblock	*leaf;
 	struct xfs_attr3_icleaf_hdr	hdr;
@@ -1730,10 +1751,10 @@ process_attr_block(
 			if (entry->flags & XFS_ATTR_PARENT) {
 				maybe_obfuscate_pptr(entry->flags, name,
 						local->namelen, value,
-						valuelen);
+						valuelen, is_meta);
 			} else if (want_obfuscate_attr(entry->flags, name,
 						local->namelen, value,
-						valuelen)) {
+						valuelen, is_meta)) {
 				generate_obfuscated_name(0, local->namelen,
 						name);
 				memset(value, 'v', valuelen);
@@ -1759,7 +1780,7 @@ process_attr_block(
 				/* do not obfuscate obviously busted pptr */
 				add_remote_vals(be32_to_cpu(remote->valueblk),
 						be32_to_cpu(remote->valuelen));
-			} else if (metadump.obfuscate) {
+			} else if (want_obfuscate_dirents(is_meta)) {
 				generate_obfuscated_name(0, remote->namelen,
 							 &remote->name[0]);
 				add_remote_vals(be32_to_cpu(remote->valueblk),
@@ -1792,7 +1813,8 @@ process_single_fsb_objects(
 	xfs_fsblock_t	s,
 	xfs_filblks_t	c,
 	typnm_t		btype,
-	xfs_fileoff_t	last)
+	xfs_fileoff_t	last,
+	bool		is_meta)
 {
 	int		rval = 1;
 	char		*dp;
@@ -1862,12 +1884,13 @@ process_single_fsb_objects(
 				process_dir_leaf_block(dp);
 			} else {
 				process_dir_data_block(dp, o,
-					 last == mp->m_dir_geo->fsbcount);
+					 last == mp->m_dir_geo->fsbcount,
+					 is_meta);
 			}
 			iocur_top->need_crc = 1;
 			break;
 		case TYP_ATTR:
-			process_attr_block(dp, o);
+			process_attr_block(dp, o, is_meta);
 			iocur_top->need_crc = 1;
 			break;
 		default:
@@ -1900,7 +1923,8 @@ process_multi_fsb_dir(
 	xfs_fsblock_t	s,
 	xfs_filblks_t	c,
 	typnm_t		btype,
-	xfs_fileoff_t	last)
+	xfs_fileoff_t	last,
+	bool		is_meta)
 {
 	char		*dp;
 	int		rval = 1;
@@ -1944,7 +1968,8 @@ process_multi_fsb_dir(
 				process_dir_leaf_block(dp);
 			} else {
 				process_dir_data_block(dp, o,
-					 last == mp->m_dir_geo->fsbcount);
+					 last == mp->m_dir_geo->fsbcount,
+					 is_meta);
 			}
 			iocur_top->need_crc = 1;
 write:
@@ -1963,6 +1988,38 @@ process_multi_fsb_dir(
 	return rval;
 }
 
+static typnm_t
+ifork_data_type(
+	struct xfs_dinode	*dip,
+	int			whichfork)
+{
+	xfs_ino_t		ino = be64_to_cpu(dip->di_ino);
+
+	if (whichfork == XFS_ATTR_FORK)
+		return TYP_ATTR;
+
+	switch (be16_to_cpu(dip->di_mode) & S_IFMT) {
+	case S_IFDIR:
+		return TYP_DIR2;
+	case S_IFLNK:
+		return TYP_SYMLINK;
+	case S_IFREG:
+		if (ino == mp->m_sb.sb_rbmino)
+			return TYP_RTBITMAP;
+		if (ino == mp->m_sb.sb_rsumino)
+			return TYP_RTSUMMARY;
+		if (ino == mp->m_sb.sb_uquotino)
+			return TYP_DQBLK;
+		if (ino == mp->m_sb.sb_gquotino)
+			return TYP_DQBLK;
+		if (ino == mp->m_sb.sb_pquotino)
+			return TYP_DQBLK;
+		return TYP_DATA;
+	default:
+		return TYP_NONE;
+	}
+}
+
 static bool
 is_multi_fsb_object(
 	struct xfs_mount	*mp,
@@ -1981,13 +2038,14 @@ process_multi_fsb_objects(
 	xfs_fsblock_t	s,
 	xfs_filblks_t	c,
 	typnm_t		btype,
-	xfs_fileoff_t	last)
+	xfs_fileoff_t	last,
+	bool		is_meta)
 {
 	switch (btype) {
 	case TYP_DIR2:
-		return process_multi_fsb_dir(o, s, c, btype, last);
+		return process_multi_fsb_dir(o, s, c, btype, last, is_meta);
 	case TYP_SYMLINK:
-		return process_symlink_block(o, s, c, btype, last);
+		return process_symlink_block(o, s, c, btype, last, is_meta);
 	default:
 		print_warning("bad type for multi-fsb object %d", btype);
 		return 1;
@@ -1997,10 +2055,13 @@ process_multi_fsb_objects(
 /* inode copy routines */
 static int
 process_bmbt_reclist(
-	xfs_bmbt_rec_t		*rp,
-	int			numrecs,
-	typnm_t			btype)
+	struct xfs_dinode	*dip,
+	int			whichfork,
+	struct xfs_bmbt_rec	*rp,
+	int			numrecs)
 {
+	bool			is_meta = is_metadata_ino(dip);
+	typnm_t			btype = ifork_data_type(dip, whichfork);
 	int			i;
 	xfs_fileoff_t		o, op = NULLFILEOFF;
 	xfs_fsblock_t		s;
@@ -2009,7 +2070,6 @@ process_bmbt_reclist(
 	xfs_fileoff_t		last;
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
-	bool			is_multi_fsb = is_multi_fsb_object(mp, btype);
 	int			rval = 1;
 
 	if (btype == TYP_DATA)
@@ -2077,12 +2137,12 @@ process_bmbt_reclist(
 		}
 
 		/* multi-extent blocks require special handling */
-		if (is_multi_fsb)
+		if (is_multi_fsb_object(mp, btype))
 			rval = process_multi_fsb_objects(o, s, c, btype,
-					last);
+					last, is_meta);
 		else
 			rval = process_single_fsb_objects(o, s, c, btype,
-					last);
+					last, is_meta);
 		if (!rval)
 			break;
 	}
@@ -2090,6 +2150,11 @@ process_bmbt_reclist(
 	return rval;
 }
 
+struct scan_bmap {
+	struct xfs_dinode *dip;
+	int		whichfork;
+};
+
 static int
 scanfunc_bmap(
 	struct xfs_btree_block	*block,
@@ -2097,8 +2162,9 @@ scanfunc_bmap(
 	xfs_agblock_t		agbno,
 	int			level,
 	typnm_t			btype,
-	void			*arg)	/* ptr to itype */
+	void			*arg)
 {
+	struct scan_bmap	*sbm = arg;
 	int			i;
 	xfs_bmbt_ptr_t		*pp;
 	int			nrecs;
@@ -2113,8 +2179,8 @@ scanfunc_bmap(
 					typtab[btype].name, agno, agbno);
 			return 1;
 		}
-		return process_bmbt_reclist(xfs_bmbt_rec_addr(mp, block, 1),
-					    nrecs, *(typnm_t*)arg);
+		return process_bmbt_reclist(sbm->dip, sbm->whichfork,
+				xfs_bmbt_rec_addr(mp, block, 1), nrecs);
 	}
 
 	if (nrecs > mp->m_bmap_dmxr[1]) {
@@ -2149,23 +2215,17 @@ scanfunc_bmap(
 static int
 process_btinode(
 	struct xfs_dinode 	*dip,
-	typnm_t			itype)
+	int			whichfork)
 {
-	xfs_bmdr_block_t	*dib;
-	int			i;
-	xfs_bmbt_ptr_t		*pp;
-	int			level;
-	int			nrecs;
+	struct xfs_bmdr_block	*dib =
+		(struct xfs_bmdr_block *)XFS_DFORK_PTR(dip, whichfork);
+	int			level = be16_to_cpu(dib->bb_level);
+	int			nrecs = be16_to_cpu(dib->bb_numrecs);
 	int			maxrecs;
-	int			whichfork;
-	typnm_t			btype;
-
-	whichfork = (itype == TYP_ATTR) ? XFS_ATTR_FORK : XFS_DATA_FORK;
-	btype = (itype == TYP_ATTR) ? TYP_BMAPBTA : TYP_BMAPBTD;
-
-	dib = (xfs_bmdr_block_t *)XFS_DFORK_PTR(dip, whichfork);
-	level = be16_to_cpu(dib->bb_level);
-	nrecs = be16_to_cpu(dib->bb_numrecs);
+	typnm_t			btype = (whichfork == XFS_ATTR_FORK) ?
+		TYP_BMAPBTA : TYP_BMAPBTD;
+	xfs_bmbt_ptr_t		*pp;
+	int			i;
 
 	if (level > XFS_BM_MAXLEVELS(mp, whichfork)) {
 		if (metadump.show_warnings)
@@ -2176,8 +2236,8 @@ process_btinode(
 	}
 
 	if (level == 0) {
-		return process_bmbt_reclist(xfs_bmdr_rec_addr(dib, 1),
-					    nrecs, itype);
+		return process_bmbt_reclist(dip, whichfork,
+				xfs_bmdr_rec_addr(dib, 1), nrecs);
 	}
 
 	maxrecs = libxfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork), 0);
@@ -2204,6 +2264,10 @@ process_btinode(
 	}
 
 	for (i = 0; i < nrecs; i++) {
+		struct scan_bmap	sbm = {
+			.dip		= dip,
+			.whichfork	= whichfork,
+		};
 		xfs_agnumber_t	ag;
 		xfs_agblock_t	bno;
 
@@ -2220,7 +2284,7 @@ process_btinode(
 			continue;
 		}
 
-		if (!scan_btree(ag, bno, level, btype, &itype, scanfunc_bmap))
+		if (!scan_btree(ag, bno, level, btype, &sbm, scanfunc_bmap))
 			return 0;
 	}
 	return 1;
@@ -2229,19 +2293,13 @@ process_btinode(
 static int
 process_exinode(
 	struct xfs_dinode 	*dip,
-	typnm_t			itype)
+	int			whichfork)
 {
-	int			whichfork;
-	int			used;
-	xfs_extnum_t		nex, max_nex;
+	xfs_extnum_t		max_nex = xfs_iext_max_nextents(
+			xfs_dinode_has_large_extent_counts(dip), whichfork);
+	xfs_extnum_t		nex = xfs_dfork_nextents(dip, whichfork);
+	int			used = nex * sizeof(struct xfs_bmbt_rec);
 
-	whichfork = (itype == TYP_ATTR) ? XFS_ATTR_FORK : XFS_DATA_FORK;
-
-	nex = xfs_dfork_nextents(dip, whichfork);
-	max_nex = xfs_iext_max_nextents(
-			xfs_dinode_has_large_extent_counts(dip),
-			whichfork);
-	used = nex * sizeof(xfs_bmbt_rec_t);
 	if (nex > max_nex || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
 		if (metadump.show_warnings)
 			print_warning("bad number of extents %llu in inode %lld",
@@ -2257,52 +2315,52 @@ process_exinode(
 		       XFS_DFORK_SIZE(dip, mp, whichfork) - used);
 
 
-	return process_bmbt_reclist((xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip,
-					whichfork), nex, itype);
+	return process_bmbt_reclist(dip, whichfork,
+			(struct xfs_bmbt_rec *)XFS_DFORK_PTR(dip, whichfork),
+			nex);
 }
 
 static int
 process_inode_data(
-	struct xfs_dinode	*dip,
-	typnm_t			itype)
+	struct xfs_dinode	*dip)
 {
 	switch (dip->di_format) {
-		case XFS_DINODE_FMT_LOCAL:
-			if (!(metadump.obfuscate || metadump.zero_stale_data))
-				break;
+	case XFS_DINODE_FMT_LOCAL:
+		if (!(metadump.obfuscate || metadump.zero_stale_data))
+			break;
 
-			/*
-			 * If the fork size is invalid, we can't safely do
-			 * anything with this fork. Leave it alone to preserve
-			 * the information for diagnostic purposes.
-			 */
-			if (XFS_DFORK_DSIZE(dip, mp) > XFS_LITINO(mp)) {
-				print_warning(
+		/*
+		 * If the fork size is invalid, we can't safely do anything
+		 * with this fork. Leave it alone to preserve the information
+		 * for diagnostic purposes.
+		 */
+		if (XFS_DFORK_DSIZE(dip, mp) > XFS_LITINO(mp)) {
+			print_warning(
 "Invalid data fork size (%d) in inode %llu, preserving contents!",
-						XFS_DFORK_DSIZE(dip, mp),
-						(long long)metadump.cur_ino);
-				break;
-			}
+					XFS_DFORK_DSIZE(dip, mp),
+					(long long)metadump.cur_ino);
+			break;
+		}
 
-			switch (itype) {
-				case TYP_DIR2:
-					process_sf_dir(dip);
-					break;
+		switch (be16_to_cpu(dip->di_mode) & S_IFMT) {
+		case S_IFDIR:
+			process_sf_dir(dip);
+			break;
 
-				case TYP_SYMLINK:
-					process_sf_symlink(dip);
-					break;
+		case S_IFLNK:
+			process_sf_symlink(dip);
+			break;
 
-				default:
-					break;
-			}
+		default:
 			break;
+		}
+		break;
 
-		case XFS_DINODE_FMT_EXTENTS:
-			return process_exinode(dip, itype);
+	case XFS_DINODE_FMT_EXTENTS:
+		return process_exinode(dip, XFS_DATA_FORK);
 
-		case XFS_DINODE_FMT_BTREE:
-			return process_btinode(dip, itype);
+	case XFS_DINODE_FMT_BTREE:
+		return process_btinode(dip, XFS_DATA_FORK);
 	}
 	return 1;
 }
@@ -2375,28 +2433,22 @@ process_inode(
 
 	/* copy appropriate data fork metadata */
 	switch (be16_to_cpu(dip->di_mode) & S_IFMT) {
-		case S_IFDIR:
-			rval = process_inode_data(dip, TYP_DIR2);
-			if (dip->di_format == XFS_DINODE_FMT_LOCAL)
-				need_new_crc = true;
-			break;
-		case S_IFLNK:
-			rval = process_inode_data(dip, TYP_SYMLINK);
-			if (dip->di_format == XFS_DINODE_FMT_LOCAL)
-				need_new_crc = true;
-			break;
-		case S_IFREG:
-			rval = process_inode_data(dip, TYP_DATA);
-			break;
-		case S_IFIFO:
-		case S_IFCHR:
-		case S_IFBLK:
-		case S_IFSOCK:
-			process_dev_inode(dip);
+	case S_IFDIR:
+	case S_IFLNK:
+	case S_IFREG:
+		rval = process_inode_data(dip);
+		if (dip->di_format == XFS_DINODE_FMT_LOCAL)
 			need_new_crc = true;
-			break;
-		default:
-			break;
+		break;
+	case S_IFIFO:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFSOCK:
+		process_dev_inode(dip);
+		need_new_crc = true;
+		break;
+	default:
+		break;
 	}
 	nametable_clear();
 	if (!rval)
@@ -2406,20 +2458,17 @@ process_inode(
 	if (XFS_DFORK_DSIZE(dip, mp) < XFS_LITINO(mp)) {
 		attr_data.remote_val_count = 0;
 		switch (dip->di_aformat) {
-			case XFS_DINODE_FMT_LOCAL:
-				need_new_crc = true;
-				if (metadump.obfuscate ||
-				    metadump.zero_stale_data)
-					process_sf_attr(dip);
-				break;
-
-			case XFS_DINODE_FMT_EXTENTS:
-				rval = process_exinode(dip, TYP_ATTR);
-				break;
-
-			case XFS_DINODE_FMT_BTREE:
-				rval = process_btinode(dip, TYP_ATTR);
-				break;
+		case XFS_DINODE_FMT_LOCAL:
+			need_new_crc = true;
+			if (metadump.obfuscate || metadump.zero_stale_data)
+				process_sf_attr(dip);
+			break;
+		case XFS_DINODE_FMT_EXTENTS:
+			rval = process_exinode(dip, XFS_ATTR_FORK);
+			break;
+		case XFS_DINODE_FMT_BTREE:
+			rval = process_btinode(dip, XFS_ATTR_FORK);
+			break;
 		}
 		nametable_clear();
 	}
@@ -2796,70 +2845,6 @@ scan_ag(
 	return rval;
 }
 
-static int
-copy_ino(
-	xfs_ino_t		ino,
-	typnm_t			itype)
-{
-	xfs_agnumber_t		agno;
-	xfs_agblock_t		agbno;
-	xfs_agino_t		agino;
-	int			offset;
-	int			rval = 1;
-
-	if (ino == 0 || ino == NULLFSINO)
-		return 1;
-
-	agno = XFS_INO_TO_AGNO(mp, ino);
-	agino = XFS_INO_TO_AGINO(mp, ino);
-	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
-	offset = XFS_AGINO_TO_OFFSET(mp, agino);
-
-	if (agno >= mp->m_sb.sb_agcount || agbno >= mp->m_sb.sb_agblocks ||
-			offset >= mp->m_sb.sb_inopblock) {
-		if (metadump.show_warnings)
-			print_warning("invalid %s inode number (%lld)",
-					typtab[itype].name, (long long)ino);
-		return 1;
-	}
-
-	push_cur();
-	set_cur(&typtab[TYP_INODE], XFS_AGB_TO_DADDR(mp, agno, agbno),
-			blkbb, DB_RING_IGN, NULL);
-	if (iocur_top->data == NULL) {
-		print_warning("cannot read %s inode %lld",
-				typtab[itype].name, (long long)ino);
-		rval = !metadump.stop_on_read_error;
-		goto pop_out;
-	}
-	off_cur(offset << mp->m_sb.sb_inodelog, mp->m_sb.sb_inodesize);
-
-	metadump.cur_ino = ino;
-	rval = process_inode_data(iocur_top->data, itype);
-pop_out:
-	pop_cur();
-	return rval;
-}
-
-
-static int
-copy_sb_inodes(void)
-{
-	if (!copy_ino(mp->m_sb.sb_rbmino, TYP_RTBITMAP))
-		return 0;
-
-	if (!copy_ino(mp->m_sb.sb_rsumino, TYP_RTSUMMARY))
-		return 0;
-
-	if (!copy_ino(mp->m_sb.sb_uquotino, TYP_DQBLK))
-		return 0;
-
-	if (!copy_ino(mp->m_sb.sb_gquotino, TYP_DQBLK))
-		return 0;
-
-	return copy_ino(mp->m_sb.sb_pquotino, TYP_DQBLK);
-}
-
 static int
 copy_log(void)
 {
@@ -3296,10 +3281,6 @@ metadump_f(
 		}
 	}
 
-	/* copy realtime and quota inode contents */
-	if (!exitcode)
-		exitcode = !copy_sb_inodes();
-
 	/* copy log */
 	if (!exitcode && !(metadump.version == 1 && metadump.external_log))
 		exitcode = !copy_log();

