Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B377DC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236187AbiLaCPg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbiLaCPg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:15:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A8D1C430
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:15:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 62BE0CE1A06
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F13C433EF;
        Sat, 31 Dec 2022 02:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452931;
        bh=eGkuIWqqvyN9X0TtTdNsOtN04139+bOwFi1GB1HGrv4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pB7oY2d9gekDGYSqdj5H8w5zBA5pVZif41UijmUaERTt5N3f3+qjdAuPul1insRpl
         +qYt6S/zqX8VCF3mn6Z7lA1hvqim1p14PdDGYjh2nStLzcUm0ZGJpR192QWsxQIfTk
         iX+8QKtXnB59N9PYiC9Kku9i0sfwe6720X/0nyqytCX4bJe8jMmYGB8IMCOu2NZr1u
         XHOFLcvotfmptGPx7eL51i1hkAXW/FA7eWYnMTviq5xEjczzo6qgsMQDW9HxZ4fyoe
         v5qCw4DRRnifGOOUEzDbfwO8iTNhfW2VPy2ZSqoEOjhzogDbf6mUTmANxHxBkINQsi
         hMzG2Gvo2sieQ==
Subject: [PATCH 22/46] xfs_db: don't obfuscate metadata directories and
 attributes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:22 -0800
Message-ID: <167243876223.725900.15680015487113391050.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Don't obfuscate the directory and attribute names of metadata inodes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/metadump.c |   92 ++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 64 insertions(+), 28 deletions(-)


diff --git a/db/metadump.c b/db/metadump.c
index 27d1df43279..996c97ca6a2 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1234,7 +1234,8 @@ generate_obfuscated_name(
 
 static void
 process_sf_dir(
-	struct xfs_dinode	*dip)
+	struct xfs_dinode	*dip,
+	bool			is_meta)
 {
 	struct xfs_dir2_sf_hdr	*sfp;
 	xfs_dir2_sf_entry_t	*sfep;
@@ -1280,7 +1281,7 @@ process_sf_dir(
 					 (char *)sfp);
 		}
 
-		if (obfuscate)
+		if (obfuscate && !is_meta)
 			generate_obfuscated_name(
 					 libxfs_dir2_sf_get_ino(mp, sfp, sfep),
 					 namelen, &sfep->name[0]);
@@ -1363,7 +1364,8 @@ process_sf_symlink(
 
 static void
 process_sf_attr(
-	struct xfs_dinode		*dip)
+	struct xfs_dinode		*dip,
+	bool				is_meta)
 {
 	/*
 	 * with extended attributes, obfuscate the names and fill the actual
@@ -1406,7 +1408,7 @@ process_sf_attr(
 			break;
 		}
 
-		if (obfuscate) {
+		if (obfuscate && !is_meta) {
 			generate_obfuscated_name(0, asfep->namelen,
 						 &asfep->nameval[0]);
 			memset(&asfep->nameval[asfep->namelen], 'v',
@@ -1509,7 +1511,8 @@ static void
 process_dir_data_block(
 	char		*block,
 	xfs_fileoff_t	offset,
-	int		is_block_format)
+	int		is_block_format,
+	bool		is_meta)
 {
 	/*
 	 * we have to rely on the fileoffset and signature of the block to
@@ -1616,7 +1619,7 @@ process_dir_data_block(
 				dir_offset)
 			return;
 
-		if (obfuscate)
+		if (obfuscate && !is_meta)
 			generate_obfuscated_name(be64_to_cpu(dep->inumber),
 					 dep->namelen, &dep->name[0]);
 		dir_offset += length;
@@ -1641,7 +1644,8 @@ process_symlink_block(
 	xfs_fsblock_t	s,
 	xfs_filblks_t	c,
 	typnm_t		btype,
-	xfs_fileoff_t	last)
+	xfs_fileoff_t	last,
+	bool		is_meta)
 {
 	struct bbmap	map;
 	char		*link;
@@ -1666,7 +1670,7 @@ process_symlink_block(
 	if (xfs_has_crc((mp)))
 		link += sizeof(struct xfs_dsymlink_hdr);
 
-	if (obfuscate)
+	if (obfuscate && !is_meta)
 		obfuscate_path_components(link, XFS_SYMLINK_BUF_SPACE(mp,
 							mp->m_sb.sb_blocksize));
 	if (zero_stale_data) {
@@ -1717,7 +1721,8 @@ add_remote_vals(
 static void
 process_attr_block(
 	char				*block,
-	xfs_fileoff_t			offset)
+	xfs_fileoff_t			offset,
+	bool				is_meta)
 {
 	struct xfs_attr_leafblock	*leaf;
 	struct xfs_attr3_icleaf_hdr	hdr;
@@ -1785,7 +1790,7 @@ process_attr_block(
 						(long long)cur_ino);
 				break;
 			}
-			if (obfuscate) {
+			if (obfuscate && !is_meta) {
 				generate_obfuscated_name(0, local->namelen,
 					&local->nameval[0]);
 				memset(&local->nameval[local->namelen], 'v',
@@ -1808,7 +1813,7 @@ process_attr_block(
 						(long long)cur_ino);
 				break;
 			}
-			if (obfuscate) {
+			if (obfuscate && !is_meta) {
 				generate_obfuscated_name(0, remote->namelen,
 							 &remote->name[0]);
 				add_remote_vals(be32_to_cpu(remote->valueblk),
@@ -1841,7 +1846,8 @@ process_single_fsb_objects(
 	xfs_fsblock_t	s,
 	xfs_filblks_t	c,
 	typnm_t		btype,
-	xfs_fileoff_t	last)
+	xfs_fileoff_t	last,
+	bool		is_meta)
 {
 	int		rval = 1;
 	char		*dp;
@@ -1911,12 +1917,13 @@ process_single_fsb_objects(
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
@@ -1949,7 +1956,8 @@ process_multi_fsb_dir(
 	xfs_fsblock_t	s,
 	xfs_filblks_t	c,
 	typnm_t		btype,
-	xfs_fileoff_t	last)
+	xfs_fileoff_t	last,
+	bool		is_meta)
 {
 	char		*dp;
 	int		rval = 1;
@@ -1993,7 +2001,8 @@ process_multi_fsb_dir(
 				process_dir_leaf_block(dp);
 			} else {
 				process_dir_data_block(dp, o,
-					 last == mp->m_dir_geo->fsbcount);
+					 last == mp->m_dir_geo->fsbcount,
+					 is_meta);
 			}
 			iocur_top->need_crc = 1;
 write:
@@ -2030,13 +2039,14 @@ process_multi_fsb_objects(
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
@@ -2048,7 +2058,8 @@ static int
 process_bmbt_reclist(
 	xfs_bmbt_rec_t		*rp,
 	int			numrecs,
-	typnm_t			btype)
+	typnm_t			btype,
+	bool			is_meta)
 {
 	int			i;
 	xfs_fileoff_t		o, op = NULLFILEOFF;
@@ -2124,10 +2135,10 @@ process_bmbt_reclist(
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
@@ -2135,6 +2146,11 @@ process_bmbt_reclist(
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
@@ -2144,6 +2160,7 @@ scanfunc_bmap(
 	typnm_t			btype,
 	void			*arg)	/* ptr to itype */
 {
+	struct scan_bmap	*sbm = arg;
 	int			i;
 	xfs_bmbt_ptr_t		*pp;
 	int			nrecs;
@@ -2159,7 +2176,7 @@ scanfunc_bmap(
 			return 1;
 		}
 		return process_bmbt_reclist(XFS_BMBT_REC_ADDR(mp, block, 1),
-					    nrecs, *(typnm_t*)arg);
+					    nrecs, sbm->typ, sbm->is_meta);
 	}
 
 	if (nrecs > mp->m_bmap_dmxr[1]) {
@@ -2191,6 +2208,15 @@ scanfunc_bmap(
 	return 1;
 }
 
+static inline bool
+is_metadata_ino(
+	struct xfs_dinode	*dip)
+{
+	return xfs_has_metadir(mp) &&
+			dip->di_version >= 3 &&
+			(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA));
+}
+
 static int
 process_btinode(
 	struct xfs_dinode 	*dip,
@@ -2204,6 +2230,7 @@ process_btinode(
 	int			maxrecs;
 	int			whichfork;
 	typnm_t			btype;
+	bool			is_meta = is_metadata_ino(dip);
 
 	whichfork = (itype == TYP_ATTR) ? XFS_ATTR_FORK : XFS_DATA_FORK;
 	btype = (itype == TYP_ATTR) ? TYP_BMAPBTA : TYP_BMAPBTD;
@@ -2222,7 +2249,7 @@ process_btinode(
 
 	if (level == 0) {
 		return process_bmbt_reclist(XFS_BMDR_REC_ADDR(dib, 1),
-					    nrecs, itype);
+					    nrecs, itype, is_meta);
 	}
 
 	maxrecs = libxfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork), 0);
@@ -2249,6 +2276,10 @@ process_btinode(
 	}
 
 	for (i = 0; i < nrecs; i++) {
+		struct scan_bmap	sbm = {
+			.typ = itype,
+			.is_meta = is_meta,
+		};
 		xfs_agnumber_t	ag;
 		xfs_agblock_t	bno;
 
@@ -2265,7 +2296,7 @@ process_btinode(
 			continue;
 		}
 
-		if (!scan_btree(ag, bno, level, btype, &itype, scanfunc_bmap))
+		if (!scan_btree(ag, bno, level, btype, &sbm, scanfunc_bmap))
 			return 0;
 	}
 	return 1;
@@ -2279,6 +2310,7 @@ process_exinode(
 	int			whichfork;
 	int			used;
 	xfs_extnum_t		nex, max_nex;
+	bool			is_meta = is_metadata_ino(dip);
 
 	whichfork = (itype == TYP_ATTR) ? XFS_ATTR_FORK : XFS_DATA_FORK;
 
@@ -2301,7 +2333,7 @@ process_exinode(
 
 
 	return process_bmbt_reclist((xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip,
-					whichfork), nex, itype);
+					whichfork), nex, itype, is_meta);
 }
 
 static int
@@ -2309,6 +2341,8 @@ process_inode_data(
 	struct xfs_dinode	*dip,
 	typnm_t			itype)
 {
+	bool			is_meta = is_metadata_ino(dip);
+
 	switch (dip->di_format) {
 		case XFS_DINODE_FMT_LOCAL:
 			if (!(obfuscate || zero_stale_data))
@@ -2329,7 +2363,7 @@ process_inode_data(
 
 			switch (itype) {
 				case TYP_DIR2:
-					process_sf_dir(dip);
+					process_sf_dir(dip, is_meta);
 					break;
 
 				case TYP_SYMLINK:
@@ -2447,12 +2481,14 @@ process_inode(
 
 	/* copy extended attributes if they exist and forkoff is valid */
 	if (XFS_DFORK_DSIZE(dip, mp) < XFS_LITINO(mp)) {
+		bool	is_meta = is_metadata_ino(dip);
+
 		attr_data.remote_val_count = 0;
 		switch (dip->di_aformat) {
 			case XFS_DINODE_FMT_LOCAL:
 				need_new_crc = 1;
 				if (obfuscate || zero_stale_data)
-					process_sf_attr(dip);
+					process_sf_attr(dip, is_meta);
 				break;
 
 			case XFS_DINODE_FMT_EXTENTS:

