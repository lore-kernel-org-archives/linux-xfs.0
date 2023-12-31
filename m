Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D201DC2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sRlR5Cno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B26C433C7;
	Sun, 31 Dec 2023 23:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065813;
	bh=FgxN001mOTmk+AxBT61V344SXu/FkvWCV2TW9r9au2I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sRlR5CnovjWK/WCPi+BBtMKNQMDfytlusvrFTv+fnf07CvZWc3LZ+YzwZbAoqGgyi
	 opM8nh6fB5sESGFOdlR+VXVPnrF+c7jw+TuYor5VFzE3bERWZG/P0DUIIPwv47zcVh
	 D6ovsKX/lHAi+Atxk/GxKb87oDFpVV7PXg8cVRwP3HzRLIpzyu7zXpDRagKRUk0+fj
	 6/yo8TsfHATZcBPxy8+MIOsxhaKY9JNHc7QX+/sGU/iColiyJFTK0TLy1HFjN6PuFk
	 YSHeKuR36E2ovG/lEvNgprWIBzRA1XDD3ALtWIbcW2GlBm105V7rjhAsF+Are9jXDk
	 DEL8/E8qcbVWQ==
Date: Sun, 31 Dec 2023 15:36:53 -0800
Subject: [PATCH 28/58] xfs_db: don't obfuscate metadata directories and
 attributes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010321.1809361.10825471775307243751.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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
 db/metadump.c |  114 ++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 79 insertions(+), 35 deletions(-)


diff --git a/db/metadump.c b/db/metadump.c
index f5b930d51d2..714be862231 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1056,9 +1056,16 @@ generate_obfuscated_name(
 		free(orig_name);
 }
 
+static inline bool
+want_obfuscate_dirents(bool is_meta)
+{
+	return metadump.obfuscate && !is_meta;
+}
+
 static void
 process_sf_dir(
-	struct xfs_dinode	*dip)
+	struct xfs_dinode	*dip,
+	bool			is_meta)
 {
 	struct xfs_dir2_sf_hdr	*sfp;
 	xfs_dir2_sf_entry_t	*sfep;
@@ -1105,7 +1112,7 @@ process_sf_dir(
 					 (char *)sfp);
 		}
 
-		if (metadump.obfuscate)
+		if (want_obfuscate_dirents(is_meta))
 			generate_obfuscated_name(
 					 libxfs_dir2_sf_get_ino(mp, sfp, sfep),
 					 namelen, &sfep->name[0]);
@@ -1195,9 +1202,10 @@ want_obfuscate_pptr(
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
 
 	/* Ignore if parent pointers aren't enabled. */
@@ -1293,9 +1301,10 @@ want_obfuscate_attr(
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
@@ -1310,7 +1319,8 @@ want_obfuscate_attr(
 
 static void
 process_sf_attr(
-	struct xfs_dinode		*dip)
+	struct xfs_dinode		*dip,
+	bool				is_meta)
 {
 	/*
 	 * with extended attributes, obfuscate the names and fill the actual
@@ -1357,11 +1367,11 @@ process_sf_attr(
 		name = &asfep->nameval[0];
 		value = &asfep->nameval[asfep->namelen];
 
-		if (want_obfuscate_pptr(asfep->flags, name, namelen, value,
-					asfep->valuelen)) {
+		if (want_obfuscate_pptr(asfep->flags, name, namelen,
+					value, asfep->valuelen, is_meta)) {
 			obfuscate_parent_pointer(name, value, asfep->valuelen);
 		} else if (want_obfuscate_attr(asfep->flags, name, namelen,
-					value, asfep->valuelen)) {
+					value, asfep->valuelen, is_meta)) {
 			generate_obfuscated_name(0, asfep->namelen, name);
 			memset(value, 'v', asfep->valuelen);
 		}
@@ -1463,7 +1473,8 @@ static void
 process_dir_data_block(
 	char		*block,
 	xfs_fileoff_t	offset,
-	int		is_block_format)
+	int		is_block_format,
+	bool		is_meta)
 {
 	/*
 	 * we have to rely on the fileoffset and signature of the block to
@@ -1570,7 +1581,7 @@ process_dir_data_block(
 				dir_offset)
 			return;
 
-		if (metadump.obfuscate)
+		if (want_obfuscate_dirents(is_meta))
 			generate_obfuscated_name(be64_to_cpu(dep->inumber),
 					 dep->namelen, &dep->name[0]);
 		dir_offset += length;
@@ -1595,7 +1606,8 @@ process_symlink_block(
 	xfs_fsblock_t	s,
 	xfs_filblks_t	c,
 	typnm_t		btype,
-	xfs_fileoff_t	last)
+	xfs_fileoff_t	last,
+	bool		is_meta)
 {
 	struct bbmap	map;
 	char		*link;
@@ -1620,7 +1632,7 @@ process_symlink_block(
 	if (xfs_has_crc((mp)))
 		link += sizeof(struct xfs_dsymlink_hdr);
 
-	if (metadump.obfuscate)
+	if (want_obfuscate_dirents(is_meta))
 		obfuscate_path_components(link, XFS_SYMLINK_BUF_SPACE(mp,
 							mp->m_sb.sb_blocksize));
 	if (metadump.zero_stale_data) {
@@ -1671,7 +1683,8 @@ add_remote_vals(
 static void
 process_attr_block(
 	char				*block,
-	xfs_fileoff_t			offset)
+	xfs_fileoff_t			offset,
+	bool				is_meta)
 {
 	struct xfs_attr_leafblock	*leaf;
 	struct xfs_attr3_icleaf_hdr	hdr;
@@ -1750,11 +1763,11 @@ process_attr_block(
 
 			if (want_obfuscate_pptr(entry->flags, name,
 						local->namelen, value,
-						valuelen)) {
+						valuelen, is_meta)) {
 				obfuscate_parent_pointer(name, value, valuelen);
 			} else if (want_obfuscate_attr(entry->flags, name,
 						local->namelen, value,
-						valuelen)) {
+						valuelen, is_meta)) {
 				generate_obfuscated_name(0, local->namelen,
 						name);
 				memset(value, 'v', valuelen);
@@ -1776,7 +1789,7 @@ process_attr_block(
 						(long long)metadump.cur_ino);
 				break;
 			}
-			if (metadump.obfuscate) {
+			if (want_obfuscate_dirents(is_meta)) {
 				generate_obfuscated_name(0, remote->namelen,
 							 &remote->name[0]);
 				add_remote_vals(be32_to_cpu(remote->valueblk),
@@ -1809,7 +1822,8 @@ process_single_fsb_objects(
 	xfs_fsblock_t	s,
 	xfs_filblks_t	c,
 	typnm_t		btype,
-	xfs_fileoff_t	last)
+	xfs_fileoff_t	last,
+	bool		is_meta)
 {
 	int		rval = 1;
 	char		*dp;
@@ -1879,12 +1893,13 @@ process_single_fsb_objects(
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
@@ -1917,7 +1932,8 @@ process_multi_fsb_dir(
 	xfs_fsblock_t	s,
 	xfs_filblks_t	c,
 	typnm_t		btype,
-	xfs_fileoff_t	last)
+	xfs_fileoff_t	last,
+	bool		is_meta)
 {
 	char		*dp;
 	int		rval = 1;
@@ -1961,7 +1977,8 @@ process_multi_fsb_dir(
 				process_dir_leaf_block(dp);
 			} else {
 				process_dir_data_block(dp, o,
-					 last == mp->m_dir_geo->fsbcount);
+					 last == mp->m_dir_geo->fsbcount,
+					 is_meta);
 			}
 			iocur_top->need_crc = 1;
 write:
@@ -1998,13 +2015,14 @@ process_multi_fsb_objects(
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
@@ -2016,7 +2034,8 @@ static int
 process_bmbt_reclist(
 	xfs_bmbt_rec_t		*rp,
 	int			numrecs,
-	typnm_t			btype)
+	typnm_t			btype,
+	bool			is_meta)
 {
 	int			i;
 	xfs_fileoff_t		o, op = NULLFILEOFF;
@@ -2096,10 +2115,10 @@ process_bmbt_reclist(
 		/* multi-extent blocks require special handling */
 		if (is_multi_fsb)
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
@@ -2107,6 +2126,11 @@ process_bmbt_reclist(
 	return rval;
 }
 
+struct scan_bmap {
+	enum typnm	typ;
+	bool		is_meta;
+};
+
 static int
 scanfunc_bmap(
 	struct xfs_btree_block	*block,
@@ -2116,6 +2140,7 @@ scanfunc_bmap(
 	typnm_t			btype,
 	void			*arg)	/* ptr to itype */
 {
+	struct scan_bmap	*sbm = arg;
 	int			i;
 	xfs_bmbt_ptr_t		*pp;
 	int			nrecs;
@@ -2131,7 +2156,7 @@ scanfunc_bmap(
 			return 1;
 		}
 		return process_bmbt_reclist(XFS_BMBT_REC_ADDR(mp, block, 1),
-					    nrecs, *(typnm_t*)arg);
+					    nrecs, sbm->typ, sbm->is_meta);
 	}
 
 	if (nrecs > mp->m_bmap_dmxr[1]) {
@@ -2163,6 +2188,15 @@ scanfunc_bmap(
 	return 1;
 }
 
+static inline bool
+is_metadata_ino(
+	struct xfs_dinode	*dip)
+{
+	return xfs_has_metadir(mp) &&
+			dip->di_version >= 3 &&
+			(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADIR));
+}
+
 static int
 process_btinode(
 	struct xfs_dinode 	*dip,
@@ -2176,6 +2210,7 @@ process_btinode(
 	int			maxrecs;
 	int			whichfork;
 	typnm_t			btype;
+	bool			is_meta = is_metadata_ino(dip);
 
 	whichfork = (itype == TYP_ATTR) ? XFS_ATTR_FORK : XFS_DATA_FORK;
 	btype = (itype == TYP_ATTR) ? TYP_BMAPBTA : TYP_BMAPBTD;
@@ -2194,7 +2229,7 @@ process_btinode(
 
 	if (level == 0) {
 		return process_bmbt_reclist(XFS_BMDR_REC_ADDR(dib, 1),
-					    nrecs, itype);
+					    nrecs, itype, is_meta);
 	}
 
 	maxrecs = libxfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork), 0);
@@ -2221,6 +2256,10 @@ process_btinode(
 	}
 
 	for (i = 0; i < nrecs; i++) {
+		struct scan_bmap	sbm = {
+			.typ = itype,
+			.is_meta = is_meta,
+		};
 		xfs_agnumber_t	ag;
 		xfs_agblock_t	bno;
 
@@ -2237,7 +2276,7 @@ process_btinode(
 			continue;
 		}
 
-		if (!scan_btree(ag, bno, level, btype, &itype, scanfunc_bmap))
+		if (!scan_btree(ag, bno, level, btype, &sbm, scanfunc_bmap))
 			return 0;
 	}
 	return 1;
@@ -2251,6 +2290,7 @@ process_exinode(
 	int			whichfork;
 	int			used;
 	xfs_extnum_t		nex, max_nex;
+	bool			is_meta = is_metadata_ino(dip);
 
 	whichfork = (itype == TYP_ATTR) ? XFS_ATTR_FORK : XFS_DATA_FORK;
 
@@ -2275,7 +2315,7 @@ process_exinode(
 
 
 	return process_bmbt_reclist((xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip,
-					whichfork), nex, itype);
+					whichfork), nex, itype, is_meta);
 }
 
 static int
@@ -2283,6 +2323,8 @@ process_inode_data(
 	struct xfs_dinode	*dip,
 	typnm_t			itype)
 {
+	bool			is_meta = is_metadata_ino(dip);
+
 	switch (dip->di_format) {
 		case XFS_DINODE_FMT_LOCAL:
 			if (!(metadump.obfuscate || metadump.zero_stale_data))
@@ -2303,7 +2345,7 @@ process_inode_data(
 
 			switch (itype) {
 				case TYP_DIR2:
-					process_sf_dir(dip);
+					process_sf_dir(dip, is_meta);
 					break;
 
 				case TYP_SYMLINK:
@@ -2421,13 +2463,15 @@ process_inode(
 
 	/* copy extended attributes if they exist and forkoff is valid */
 	if (XFS_DFORK_DSIZE(dip, mp) < XFS_LITINO(mp)) {
+		bool	is_meta = is_metadata_ino(dip);
+
 		attr_data.remote_val_count = 0;
 		switch (dip->di_aformat) {
 			case XFS_DINODE_FMT_LOCAL:
 				need_new_crc = true;
 				if (metadump.obfuscate ||
 				    metadump.zero_stale_data)
-					process_sf_attr(dip);
+					process_sf_attr(dip, is_meta);
 				break;
 
 			case XFS_DINODE_FMT_EXTENTS:

