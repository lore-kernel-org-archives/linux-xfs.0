Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8777482
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530192; cv=none; b=IOKqd1vMaLBGB599qHr/1AITXpR25f/719GrHn2i2w6txU0XiyMU06Ul8PIdaEeQkPphnuV8NcyNJlOlfcffyL+OSEeGy2ZC9udkO1593/IP9aAzdtvzJZqZI+pYQ5sRdgE9bGrJAwr0hscuF5TolvAy9WLM2oI4KuiQ+mNAEzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530192; c=relaxed/simple;
	bh=H7h5rKCoFiw/enWZyAUbbHUdzaIZL3Li5k/KJHoDoQM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lz3zBXIutADiiSrvhWekFcla1yiAZh6+S5egkjtGCtnP40f4eEIJHj+rAkkGWWIZB1W/WLxILZP/R19EoNN/hVyGZg8amgzlqKECprBzQ9anxO2KL2xcrW2FGjAaioZkI15sHmJjdvrv4WgKfXRonwBrraxOeUu1KBliEOXWA/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xv7IPcIX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xv7IPcIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE24C4CED1;
	Sat,  7 Dec 2024 00:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530192;
	bh=H7h5rKCoFiw/enWZyAUbbHUdzaIZL3Li5k/KJHoDoQM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Xv7IPcIX6aH0Mf7eaqYp4IOoFL27aKMdYPiL99/dqqMb+kk5oMa3P2v7YKykIsG0y
	 r1xOV+3TT6QZEzSVvGHohjVQwdUN0ocFFvkq2dKIl5q1VdQM1qQa6/eQ1fyUb0b/ml
	 nZtbwx6MzbXUK76yZ6w8dY5e9ZdkEC0IUgbiy63admF41Vp4EHVnQ/0dgIcL9rIzSt
	 lUD5WFsa/JZ3BlHCD9I+h7KSpPF1lU7cj/0pD+bvVPfIZekfV6FZMXKcvR3qgszUBq
	 X+4t1GX1KwhMmpnsMrV4z+kduRoAyWrMV8/PHubz2pDc/gULEspJFY2NTWi1xit9nd
	 MRDRXbcxsa3yA==
Date: Fri, 06 Dec 2024 16:09:51 -0800
Subject: [PATCH 19/50] xfs_repair: support realtime groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752235.126362.14143467181782796888.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Make repair aware of multiple rtgroups.  This now uses the same code as the
AG-based data device for block usage tracking instead of the less optimal
AVL trees and bitmaps used for the traditonal RT device.

Note this is still a bit hacky at the moment by just going beyond the AG
arrays and not fully supporting the unknown state for RT allocation yet.
The next patch will clean this up.

All this should be fixable.

Large parts of the code are based on patches from Darrick J. Wong.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 
 repair/agheader.c        |    8 -
 repair/agheader.h        |   10 +
 repair/dinode.c          |  102 ++++++++----
 repair/dir2.c            |   13 +
 repair/incore.c          |   22 ++-
 repair/incore.h          |    2 
 repair/incore_ext.c      |    6 -
 repair/phase2.c          |   49 +++---
 repair/phase4.c          |   13 +
 repair/phase6.c          |  172 +++++++++++++++++++-
 repair/rt.c              |  404 ++++++++++++++++++++++++++++++++++++++--------
 repair/rt.h              |   20 ++
 repair/sb.c              |   41 +++++
 repair/xfs_repair.c      |   15 +-
 15 files changed, 733 insertions(+), 145 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 50da547f8f21d4..980250d58164ab 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -108,6 +108,7 @@
 #define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
 #define xfs_cntbt_init_cursor		libxfs_cntbt_init_cursor
 #define xfs_compute_rextslog		libxfs_compute_rextslog
+#define xfs_compute_rgblklog		libxfs_compute_rgblklog
 #define xfs_create_space_res		libxfs_create_space_res
 #define xfs_da3_node_hdr_from_disk	libxfs_da3_node_hdr_from_disk
 #define xfs_da3_node_read		libxfs_da3_node_read
diff --git a/repair/agheader.c b/repair/agheader.c
index 14aedece3d07b0..fd279559aed973 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -319,12 +319,6 @@ check_v5_feature_mismatch(
 	return XR_AG_SB_SEC;
 }
 
-static inline bool xfs_sb_version_hasmetadir(const struct xfs_sb *sbp)
-{
-	return xfs_sb_is_v5(sbp) &&
-		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR);
-}
-
 /*
  * Possible fields that may have been set at mkfs time,
  * sb_inoalignmt, sb_unit, sb_width and sb_dirblklog.
@@ -364,7 +358,7 @@ secondary_sb_whack(
 	 * size is the size of data which is valid for this sb.
 	 */
 	if (xfs_sb_version_hasmetadir(sb))
-		size = offsetofend(struct xfs_dsb, sb_metadirino);
+		size = offsetofend(struct xfs_dsb, sb_pad);
 	else if (xfs_sb_version_hasmetauuid(sb))
 		size = offsetofend(struct xfs_dsb, sb_meta_uuid);
 	else if (xfs_sb_version_hascrc(sb))
diff --git a/repair/agheader.h b/repair/agheader.h
index b4f81d5537906d..c81147b6607d2b 100644
--- a/repair/agheader.h
+++ b/repair/agheader.h
@@ -3,6 +3,8 @@
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
+#ifndef __XFS_REPAIR_AGHEADER_H__
+#define __XFS_REPAIR_AGHEADER_H__
 
 typedef struct fs_geometry  {
 	/*
@@ -82,3 +84,11 @@ typedef struct fs_geo_list  {
 #define XR_AG_AGF	0x2
 #define XR_AG_AGI	0x4
 #define XR_AG_SB_SEC	0x8
+
+static inline bool xfs_sb_version_hasmetadir(const struct xfs_sb *sbp)
+{
+	return xfs_sb_is_v5(sbp) &&
+		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR);
+}
+
+#endif /* __XFS_REPAIR_AGHEADER_H__ */
diff --git a/repair/dinode.c b/repair/dinode.c
index 916aadc782248f..73a70ab5116c9f 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -21,6 +21,7 @@
 #include "slab.h"
 #include "rmap.h"
 #include "bmap_repair.h"
+#include "rt.h"
 
 /*
  * gettext lookups for translations of strings use mutexes internally to
@@ -171,20 +172,33 @@ clear_dinode(xfs_mount_t *mp, struct xfs_dinode *dino, xfs_ino_t ino_num)
 static __inline int
 verify_dfsbno_range(
 	struct xfs_mount	*mp,
-	xfs_fsblock_t		fsbno,
-	xfs_filblks_t		count)
+	struct xfs_bmbt_irec	*irec,
+	bool			isrt)
 {
+	xfs_fsblock_t		end =
+		irec->br_startblock + irec->br_blockcount - 1;
+
 	/* the start and end blocks better be in the same allocation group */
-	if (XFS_FSB_TO_AGNO(mp, fsbno) !=
-	    XFS_FSB_TO_AGNO(mp, fsbno + count - 1)) {
-		return XR_DFSBNORANGE_OVERFLOW;
+	if (isrt) {
+		if (xfs_rtb_to_rgno(mp, irec->br_startblock) !=
+		    xfs_rtb_to_rgno(mp, end))
+			return XR_DFSBNORANGE_OVERFLOW;
+
+		if (!libxfs_verify_rtbno(mp, irec->br_startblock))
+			return XR_DFSBNORANGE_BADSTART;
+		if (!libxfs_verify_rtbno(mp, end))
+			return XR_DFSBNORANGE_BADEND;
+	} else {
+		if (XFS_FSB_TO_AGNO(mp, irec->br_startblock) !=
+		    XFS_FSB_TO_AGNO(mp, end))
+			return XR_DFSBNORANGE_OVERFLOW;
+
+		if (!libxfs_verify_fsbno(mp, irec->br_startblock))
+			return XR_DFSBNORANGE_BADSTART;
+		if (!libxfs_verify_fsbno(mp, end))
+			return XR_DFSBNORANGE_BADEND;
 	}
 
-	if (!libxfs_verify_fsbno(mp, fsbno))
-		return XR_DFSBNORANGE_BADSTART;
-	if (!libxfs_verify_fsbno(mp, fsbno + count - 1))
-		return XR_DFSBNORANGE_BADEND;
-
 	return XR_DFSBNORANGE_VALID;
 }
 
@@ -387,17 +401,21 @@ process_bmbt_reclist_int(
 	xfs_extnum_t		i;
 	int			state;
 	xfs_agnumber_t		agno;
-	xfs_agblock_t		agbno;
+	xfs_agblock_t		agbno, first_agbno;
 	xfs_agblock_t		ebno;
 	xfs_extlen_t		blen;
 	xfs_agnumber_t		locked_agno = -1;
 	int			error = 1;
 	int			error2;
+	bool			isrt = false;
 
-	if (type == XR_INO_RTDATA)
+	if (type == XR_INO_RTDATA) {
+		if (whichfork == XFS_DATA_FORK)
+			isrt = true;
 		ftype = ftype_real_time;
-	else
+	} else {
 		ftype = ftype_regular;
+	}
 
 	for (i = 0; i < *numrecs; i++) {
 		libxfs_bmbt_disk_get_all((rp +i), &irec);
@@ -452,7 +470,7 @@ _("zero length extent (off = %" PRIu64 ", fsbno = %" PRIu64 ") in ino %" PRIu64
 			goto done;
 		}
 
-		if (type == XR_INO_RTDATA && whichfork == XFS_DATA_FORK) {
+		if (isrt && !xfs_has_rtgroups(mp)) {
 			error2 = process_rt_rec(mp, &irec, ino, tot, check_dups,
 					zap_metadata);
 			if (error2)
@@ -468,8 +486,7 @@ _("zero length extent (off = %" PRIu64 ", fsbno = %" PRIu64 ") in ino %" PRIu64
 		/*
 		 * regular file data fork or attribute fork
 		 */
-		switch (verify_dfsbno_range(mp, irec.br_startblock,
-						irec.br_blockcount)) {
+		switch (verify_dfsbno_range(mp, &irec, isrt)) {
 			case XR_DFSBNORANGE_VALID:
 				break;
 
@@ -532,12 +549,21 @@ _("Fatal error: inode %" PRIu64 " - blkmap_set_ext(): %s\n"
 		}
 
 		/*
-		 * Profiling shows that the following loop takes the
-		 * most time in all of xfs_repair.
+		 * XXX: For rtgroup enabled file systems we treat the RTGs as
+		 * basically another set of AGs tacked on at the end, but
+		 * otherwise reuse all the existing code.  That's why we'll
+		 * see odd "agno" value here.
 		 */
-		agno = XFS_FSB_TO_AGNO(mp, irec.br_startblock);
-		agbno = XFS_FSB_TO_AGBNO(mp, irec.br_startblock);
-		ebno = agbno + irec.br_blockcount;
+		if (isrt) {
+			agno = mp->m_sb.sb_agcount +
+				xfs_rtb_to_rgno(mp, irec.br_startblock);
+			first_agbno = xfs_rtb_to_rgbno(mp, irec.br_startblock);
+		} else {
+			agno = XFS_FSB_TO_AGNO(mp, irec.br_startblock);
+			first_agbno = XFS_FSB_TO_AGBNO(mp, irec.br_startblock);
+		}
+		agbno = first_agbno;
+		ebno = first_agbno + irec.br_blockcount;
 		if (agno != locked_agno) {
 			if (locked_agno != -1)
 				unlock_ag(locked_agno);
@@ -545,12 +571,23 @@ _("Fatal error: inode %" PRIu64 " - blkmap_set_ext(): %s\n"
 			lock_ag(locked_agno);
 		}
 
+		/*
+		 * Profiling shows that the following loop takes the most time
+		 * in all of xfs_repair.
+		 */
 		for (b = irec.br_startblock;
 		     agbno < ebno;
 		     b += blen, agbno += blen) {
 			state = get_bmap_ext(agno, agbno, ebno, &blen);
 			switch (state)  {
 			case XR_E_FREE:
+				/*
+				 * We never do a scan pass of the rt bitmap, so unknown
+				 * blocks are marked as free.
+				 */
+				if (isrt)
+					break;
+				fallthrough;
 			case XR_E_FREE1:
 				do_warn(
 _("%s fork in ino %" PRIu64 " claims free block %" PRIu64 "\n"),
@@ -624,8 +661,8 @@ _("illegal state %d in block map %" PRIu64 "\n"),
 		 * After a successful rebuild we'll try this scan again.
 		 * (If the rebuild fails we won't come back here.)
 		 */
-		agbno = XFS_FSB_TO_AGBNO(mp, irec.br_startblock);
-		ebno = agbno + irec.br_blockcount;
+		agbno = first_agbno;
+		ebno = first_agbno + irec.br_blockcount;
 		for (; agbno < ebno; agbno += blen) {
 			state = get_bmap_ext(agno, agbno, ebno, &blen);
 			switch (state)  {
@@ -1588,7 +1625,7 @@ check_dinode_mode_format(
  */
 
 static int
-process_check_sb_inodes(
+process_check_metadata_inodes(
 	xfs_mount_t		*mp,
 	struct xfs_dinode	*dinoc,
 	xfs_ino_t		lino,
@@ -1638,8 +1675,10 @@ process_check_sb_inodes(
 		}
 		return 0;
 	}
+
 	dnextents = xfs_dfork_data_extents(dinoc);
-	if (lino == mp->m_sb.sb_rsumino) {
+	if (lino == mp->m_sb.sb_rsumino ||
+	    is_rtsummary_inode(lino)) {
 		if (*type != XR_INO_RTSUM) {
 			do_warn(
 _("realtime summary inode %" PRIu64 " has bad type 0x%x, "),
@@ -1660,7 +1699,8 @@ _("bad # of extents (%" PRIu64 ") for realtime summary inode %" PRIu64 "\n"),
 		}
 		return 0;
 	}
-	if (lino == mp->m_sb.sb_rbmino) {
+	if (lino == mp->m_sb.sb_rbmino ||
+	    is_rtbitmap_inode(lino)) {
 		if (*type != XR_INO_RTBITMAP) {
 			do_warn(
 _("realtime bitmap inode %" PRIu64 " has bad type 0x%x, "),
@@ -2920,9 +2960,11 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 	case S_IFREG:
 		if (be16_to_cpu(dino->di_flags) & XFS_DIFLAG_REALTIME)
 			type = XR_INO_RTDATA;
-		else if (lino == mp->m_sb.sb_rbmino)
+		else if (lino == mp->m_sb.sb_rbmino ||
+			 is_rtbitmap_inode(lino))
 			type = XR_INO_RTBITMAP;
-		else if (lino == mp->m_sb.sb_rsumino)
+		else if (lino == mp->m_sb.sb_rsumino ||
+			 is_rtsummary_inode(lino))
 			type = XR_INO_RTSUM;
 		else if (lino == mp->m_sb.sb_uquotino)
 			type = XR_INO_UQUOTA;
@@ -2955,9 +2997,9 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 	}
 
 	/*
-	 * type checks for superblock inodes
+	 * type checks for metadata inodes
 	 */
-	if (process_check_sb_inodes(mp, dino, lino, &type, dirty) != 0)
+	if (process_check_metadata_inodes(mp, dino, lino, &type, dirty) != 0)
 		goto clear_bad_out;
 
 	validate_extsize(mp, dino, lino, dirty);
diff --git a/repair/dir2.c b/repair/dir2.c
index d233c724488182..ca747c90175e93 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -15,6 +15,7 @@
 #include "da_util.h"
 #include "prefetch.h"
 #include "progress.h"
+#include "rt.h"
 
 /*
  * Known bad inode list.  These are seen when the leaf and node
@@ -256,10 +257,12 @@ process_sf_dir2(
 			 * bother checking if the child inode is free or not.
 			 */
 			junkit = 0;
-		} else if (lino == mp->m_sb.sb_rbmino)  {
+		} else if (lino == mp->m_sb.sb_rbmino ||
+		           is_rtbitmap_inode(lino)) {
 			junkit = 1;
 			junkreason = _("realtime bitmap");
-		} else if (lino == mp->m_sb.sb_rsumino)  {
+		} else if (lino == mp->m_sb.sb_rsumino ||
+		           is_rtsummary_inode(lino)) {
 			junkit = 1;
 			junkreason = _("realtime summary");
 		} else if (lino == mp->m_sb.sb_uquotino)  {
@@ -737,9 +740,11 @@ process_dir2_data(
 			 * bother checking if the child inode is free or not.
 			 */
 			clearino = 0;
-		} else if (ent_ino == mp->m_sb.sb_rbmino) {
+		} else if (ent_ino == mp->m_sb.sb_rbmino ||
+		           is_rtbitmap_inode(ent_ino)) {
 			clearreason = _("realtime bitmap");
-		} else if (ent_ino == mp->m_sb.sb_rsumino) {
+		} else if (ent_ino == mp->m_sb.sb_rsumino ||
+		           is_rtsummary_inode(ent_ino)) {
 			clearreason = _("realtime summary");
 		} else if (ent_ino == mp->m_sb.sb_uquotino) {
 			clearreason = _("user quota");
diff --git a/repair/incore.c b/repair/incore.c
index fb9ebee1671d4f..bab9b74bf922c8 100644
--- a/repair/incore.c
+++ b/repair/incore.c
@@ -254,7 +254,8 @@ free_rt_bmap(xfs_mount_t *mp)
 void
 reset_bmaps(xfs_mount_t *mp)
 {
-	xfs_agnumber_t	agno;
+	unsigned int	nr_groups = mp->m_sb.sb_agcount + mp->m_sb.sb_rgcount;
+	unsigned int	agno;
 	xfs_agblock_t	ag_size;
 	int		ag_hdr_block;
 
@@ -287,6 +288,25 @@ reset_bmaps(xfs_mount_t *mp)
 		btree_insert(bmap, ag_size, &states[XR_E_BAD_STATE]);
 	}
 
+	for ( ; agno < nr_groups; agno++) {
+		struct btree_root	*bmap = ag_bmaps[agno].root;
+		uint64_t		rblocks;
+
+		btree_clear(bmap);
+		if (agno == mp->m_sb.sb_agcount && xfs_has_rtsb(mp)) {
+			btree_insert(bmap, 0, &states[XR_E_INUSE_FS]);
+			btree_insert(bmap, mp->m_sb.sb_rextsize,
+					&states[XR_E_FREE]);
+		} else {
+			btree_insert(bmap, 0, &states[XR_E_FREE]);
+		}
+
+		rblocks = xfs_rtbxlen_to_blen(mp,
+				xfs_rtgroup_extents(mp,
+					(agno - mp->m_sb.sb_agcount)));
+		btree_insert(bmap, rblocks, &states[XR_E_BAD_STATE]);
+	}
+
 	if (mp->m_sb.sb_logstart != 0) {
 		set_bmap_ext(XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart),
 			     XFS_FSB_TO_AGBNO(mp, mp->m_sb.sb_logstart),
diff --git a/repair/incore.h b/repair/incore.h
index 8385043580637f..ea55c25087dc1a 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -698,6 +698,8 @@ static inline unsigned int
 xfs_rootrec_inodes_inuse(
 	struct xfs_mount	*mp)
 {
+	if (xfs_has_rtgroups(mp))
+		return 2; /* sb_rootino, sb_metadirino */
 	if (xfs_has_metadir(mp))
 		return 4; /* sb_rootino, sb_rbmino, sb_rsumino, sb_metadirino */
 	return 3; /* sb_rootino, sb_rbmino, sb_rsumino */
diff --git a/repair/incore_ext.c b/repair/incore_ext.c
index 59c5d6f502c308..a31ef066ef356c 100644
--- a/repair/incore_ext.c
+++ b/repair/incore_ext.c
@@ -593,7 +593,6 @@ release_rt_extent_tree()
 void
 free_rt_dup_extent_tree(xfs_mount_t *mp)
 {
-	ASSERT(mp->m_sb.sb_rblocks != 0);
 	free(rt_ext_tree_ptr);
 	rt_ext_tree_ptr = NULL;
 }
@@ -726,8 +725,8 @@ static avl64ops_t avl64_extent_tree_ops = {
 void
 incore_ext_init(xfs_mount_t *mp)
 {
+	xfs_agnumber_t agcount = mp->m_sb.sb_agcount + mp->m_sb.sb_rgcount;
 	int i;
-	xfs_agnumber_t agcount = mp->m_sb.sb_agcount;
 
 	pthread_mutex_init(&rt_ext_tree_lock, NULL);
 
@@ -779,9 +778,10 @@ incore_ext_init(xfs_mount_t *mp)
 void
 incore_ext_teardown(xfs_mount_t *mp)
 {
+	xfs_agnumber_t agcount = mp->m_sb.sb_agcount + mp->m_sb.sb_rgcount;
 	xfs_agnumber_t i;
 
-	for (i = 0; i < mp->m_sb.sb_agcount; i++)  {
+	for (i = 0; i < agcount; i++)  {
 		btree_destroy(dup_extent_trees[i]);
 		free(extent_bno_ptrs[i]);
 		free(extent_bcnt_ptrs[i]);
diff --git a/repair/phase2.c b/repair/phase2.c
index 476a1c74db8c8d..d2f7f544d0e579 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -14,6 +14,7 @@
 #include "incore.h"
 #include "progress.h"
 #include "scan.h"
+#include "rt.h"
 
 /* workaround craziness in the xlog routines */
 int xlog_recover_do_trans(struct xlog *log, struct xlog_recover *t, int p)
@@ -544,16 +545,14 @@ phase2(
 		struct xfs_sb	*sb = &mp->m_sb;
 
 		if (xfs_has_metadir(mp))
-			ASSERT(sb->sb_metadirino == sb->sb_rootino + 1 &&
-			       sb->sb_rbmino  == sb->sb_rootino + 2 &&
-			       sb->sb_rsumino == sb->sb_rootino + 3);
+			ASSERT(sb->sb_metadirino == sb->sb_rootino + 1);
 		else
 			ASSERT(sb->sb_rbmino  == sb->sb_rootino + 1 &&
 			       sb->sb_rsumino == sb->sb_rootino + 2);
 		do_warn(_("root inode chunk not found\n"));
 
 		/*
-		 * mark the first 3-4 inodes used, the rest are free
+		 * mark the first 2-3 inodes used, the rest are free
 		 */
 		ino_rec = set_inode_used_alloc(mp, 0,
 				XFS_INO_TO_AGINO(mp, sb->sb_rootino));
@@ -600,29 +599,33 @@ phase2(
 			j++;
 		}
 
-		if (is_inode_free(ino_rec, j))  {
-			do_warn(_("realtime bitmap inode marked free, "));
-			set_inode_used(ino_rec, j);
-			if (!no_modify)
-				do_warn(_("correcting\n"));
-			else
-				do_warn(_("would correct\n"));
-		}
-		set_inode_is_meta(ino_rec, j);
-		j++;
+		if (!xfs_has_rtgroups(mp)) {
+			if (is_inode_free(ino_rec, j))  {
+				do_warn(_("realtime bitmap inode marked free, "));
+				set_inode_used(ino_rec, j);
+				if (!no_modify)
+					do_warn(_("correcting\n"));
+				else
+					do_warn(_("would correct\n"));
+			}
+			set_inode_is_meta(ino_rec, j);
+			j++;
 
-		if (is_inode_free(ino_rec, j))  {
-			do_warn(_("realtime summary inode marked free, "));
-			set_inode_used(ino_rec, j);
-			if (!no_modify)
-				do_warn(_("correcting\n"));
-			else
-				do_warn(_("would correct\n"));
+			if (is_inode_free(ino_rec, j))  {
+				do_warn(_("realtime summary inode marked free, "));
+				set_inode_used(ino_rec, j);
+				if (!no_modify)
+					do_warn(_("correcting\n"));
+				else
+					do_warn(_("would correct\n"));
+			}
+			set_inode_is_meta(ino_rec, j);
+			j++;
 		}
-		set_inode_is_meta(ino_rec, j);
-		j++;
 	}
 
+	discover_rtgroup_inodes(mp);
+
 	/*
 	 * Upgrade the filesystem now that we've done a preliminary check of
 	 * the superblocks, the AGs, the log, and the metadata inodes.
diff --git a/repair/phase4.c b/repair/phase4.c
index 036a4ed0e54445..e93178465991c2 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -395,7 +395,18 @@ phase4(xfs_mount_t *mp)
 	}
 	print_final_rpt();
 
-	process_dup_rt_extents(mp);
+	if (xfs_has_rtgroups(mp)) {
+		for (i = 0; i < mp->m_sb.sb_rgcount; i++)  {
+			uint64_t	rblocks;
+
+			rblocks = xfs_rtbxlen_to_blen(mp,
+					xfs_rtgroup_extents(mp, i));
+			process_dup_extents(mp->m_sb.sb_agcount + i, 0,
+					rblocks);
+		}
+	} else {
+		process_dup_rt_extents(mp);
+	}
 
 	/*
 	 * initialize bitmaps for all AGs
diff --git a/repair/phase6.c b/repair/phase6.c
index 99019e94bab285..fa4eeb08265f0c 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -570,6 +570,122 @@ _("couldn't iget realtime %s inode -- error - %d\n"),
 		do_error(_("%s: commit failed, error %d\n"), __func__, error);
 }
 
+/* Mark a newly allocated inode in use in the incore bitmap. */
+static void
+mark_ino_inuse(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	int			mode,
+	xfs_ino_t		parent)
+{
+	struct ino_tree_node	*irec;
+	int			ino_offset;
+	int			i;
+
+	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, ino),
+			XFS_INO_TO_AGINO(mp, ino));
+
+	if (irec == NULL) {
+		/*
+		 * This inode is allocated from a newly created inode
+		 * chunk and therefore did not exist when inode chunks
+		 * were processed in phase3. Add this group of inodes to
+		 * the entry avl tree as if they were discovered in phase3.
+		 */
+		irec = set_inode_free_alloc(mp,
+				XFS_INO_TO_AGNO(mp, ino),
+				XFS_INO_TO_AGINO(mp, ino));
+		alloc_ex_data(irec);
+
+		for (i = 0; i < XFS_INODES_PER_CHUNK; i++)
+			set_inode_free(irec, i);
+	}
+
+	ino_offset = get_inode_offset(mp, ino, irec);
+
+	/*
+	 * Mark the inode allocated so it is not skipped in phase 7.  We'll
+	 * find it with the directory traverser soon, so we don't need to
+	 * mark it reached.
+	 */
+	set_inode_used(irec, ino_offset);
+	set_inode_ftype(irec, ino_offset, libxfs_mode_to_ftype(mode));
+	set_inode_parent(irec, ino_offset, parent);
+	if (S_ISDIR(mode))
+		set_inode_isadir(irec, ino_offset);
+}
+
+static bool
+ensure_rtgroup_file(
+	struct xfs_rtgroup	*rtg,
+	enum xfs_rtg_inodes	type)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_inode	*ip = rtg->rtg_inodes[type];
+	const char		*name = libxfs_rtginode_name(type);
+	int			error;
+
+	if (!xfs_rtginode_enabled(rtg, type))
+		return false;
+
+	if (no_modify) {
+		if (rtgroup_inodes_were_bad(type))
+			do_warn(_("would reset rtgroup %u %s inode\n"),
+				rtg_rgno(rtg), name);
+		return false;
+	}
+
+	if (rtgroup_inodes_were_bad(type)) {
+		/*
+		 * The inode was bad or missing, state that we'll make a new
+		 * one even though we always create a new one.
+		 */
+		do_warn(_("resetting rtgroup %u %s inode\n"),
+			rtg_rgno(rtg), name);
+	}
+
+	error = -libxfs_rtginode_create(rtg, type, false);
+	if (error)
+		do_error(
+_("Couldn't create rtgroup %u %s inode, error %d\n"),
+			rtg_rgno(rtg), name, error);
+
+	ip = rtg->rtg_inodes[type];
+
+	/* Mark the inode in use. */
+	mark_ino_inuse(mp, ip->i_ino, S_IFREG, mp->m_rtdirip->i_ino);
+	mark_ino_metadata(mp, ip->i_ino);
+	return true;
+}
+
+static void
+ensure_rtgroup_bitmap(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+
+	if (!xfs_has_rtgroups(mp))
+		return;
+	if (!ensure_rtgroup_file(rtg, XFS_RTGI_BITMAP))
+		return;
+
+	fill_rtbitmap(rtg);
+}
+
+static void
+ensure_rtgroup_summary(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+
+	if (!xfs_has_rtgroups(mp))
+		return;
+	if (!ensure_rtgroup_file(rtg, XFS_RTGI_SUMMARY))
+		return;
+
+	fill_rtsummary(rtg);
+}
+
 /* Initialize a root directory. */
 static int
 init_fs_root_dir(
@@ -634,6 +750,8 @@ mk_metadir(
 	struct xfs_trans	*tp;
 	int			error;
 
+	libxfs_rtginode_irele(&mp->m_rtdirip);
+
 	error = init_fs_root_dir(mp, mp->m_sb.sb_metadirino, 0,
 			&mp->m_metadirip);
 	if (error)
@@ -3063,8 +3181,10 @@ mark_inode(
 static void
 mark_standalone_inodes(xfs_mount_t *mp)
 {
-	mark_inode(mp, mp->m_sb.sb_rbmino);
-	mark_inode(mp, mp->m_sb.sb_rsumino);
+	if (!xfs_has_rtgroups(mp)) {
+		mark_inode(mp, mp->m_sb.sb_rbmino);
+		mark_inode(mp, mp->m_sb.sb_rsumino);
+	}
 
 	if (!fs_quotas)
 		return;
@@ -3245,6 +3365,49 @@ _("        - resetting contents of realtime bitmap and summary inodes\n"));
 	libxfs_rtgroup_rele(rtg);
 }
 
+static void
+reset_rt_metadir_inodes(
+	struct xfs_mount	*mp)
+{
+	struct xfs_rtgroup	*rtg = NULL;
+	int			error;
+
+	/*
+	 * Release the rtgroup inodes so that we can rebuild everything from
+	 * observations.
+	 */
+	if (!no_modify)
+		unload_rtgroup_inodes(mp);
+
+	if (mp->m_sb.sb_rgcount > 0) {
+		if (!no_modify) {
+			error = -libxfs_rtginode_mkdir_parent(mp);
+			if (error)
+				do_error(_("failed to create realtime metadir (%d)\n"),
+					error);
+		}
+		mark_ino_inuse(mp, mp->m_rtdirip->i_ino, S_IFDIR,
+				mp->m_metadirip->i_ino);
+		mark_ino_metadata(mp, mp->m_rtdirip->i_ino);
+	}
+
+	/*
+	 * This isn't the whole story, but it keeps the message that we've had
+	 * for years and which is expected in xfstests and more.
+	 */
+	if (!no_modify)
+		do_log(
+_("        - resetting contents of realtime bitmap and summary inodes\n"));
+
+	if (mp->m_sb.sb_rgcount == 0)
+		return;
+
+	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
+		ensure_rtgroup_bitmap(rtg);
+		ensure_rtgroup_summary(rtg);
+	}
+}
+
 void
 phase6(xfs_mount_t *mp)
 {
@@ -3293,7 +3456,10 @@ phase6(xfs_mount_t *mp)
 		do_warn(_("would reinitialize metadata root directory\n"));
 	}
 
-	reset_rt_sb_inodes(mp);
+	if (xfs_has_rtgroups(mp))
+		reset_rt_metadir_inodes(mp);
+	else
+		reset_rt_sb_inodes(mp);
 
 	mark_standalone_inodes(mp);
 
diff --git a/repair/rt.c b/repair/rt.c
index a3378ef1dd0af2..f034e925965f75 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -12,11 +12,19 @@
 #include "dinode.h"
 #include "protos.h"
 #include "err_protos.h"
+#include "libfrog/bitmap.h"
 #include "rt.h"
 
+/* Bitmap of rt group inodes */
+static struct bitmap	*rtg_inodes[XFS_RTGI_MAX];
+static bool		rtginodes_bad[XFS_RTGI_MAX];
+
 /* Computed rt bitmap/summary data */
-static union xfs_rtword_raw	*btmcompute;
-static union xfs_suminfo_raw	*sumcompute;
+struct rtg_computed {
+	union xfs_rtword_raw	*bmp;
+	union xfs_suminfo_raw	*sum;
+};
+struct rtg_computed *rt_computed;
 
 static inline void
 set_rtword(
@@ -44,14 +52,13 @@ inc_sumcount(
 		p->old++;
 }
 
-/*
- * generate the real-time bitmap and summary info based on the
- * incore realtime extent map.
- */
-void
-generate_rtinfo(
-	struct xfs_mount	*mp)
+static void
+generate_rtgroup_rtinfo(
+	struct xfs_rtgroup	*rtg)
 {
+	struct rtg_computed	*comp = &rt_computed[rtg_rgno(rtg)];
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	unsigned int		idx = mp->m_sb.sb_agcount + rtg_rgno(rtg);
 	unsigned int		bitsperblock =
 		mp->m_blockwsize << XFS_NBWORDLOG;
 	xfs_rtxnum_t		extno = 0;
@@ -63,15 +70,15 @@ generate_rtinfo(
 	union xfs_rtword_raw	*words;
 
 	wordcnt = XFS_FSB_TO_B(mp, mp->m_sb.sb_rbmblocks) >> XFS_WORDLOG;
-	btmcompute = calloc(wordcnt, sizeof(union xfs_rtword_raw));
-	if (!btmcompute)
+	comp->bmp = calloc(wordcnt, sizeof(union xfs_rtword_raw));
+	if (!comp->bmp)
 		do_error(
 _("couldn't allocate memory for incore realtime bitmap.\n"));
-	words = btmcompute;
+	words = comp->bmp;
 
 	wordcnt = XFS_FSB_TO_B(mp, mp->m_rsumblocks) >> XFS_WORDLOG;
-	sumcompute = calloc(wordcnt, sizeof(union xfs_suminfo_raw));
-	if (!sumcompute)
+	comp->sum = calloc(wordcnt, sizeof(union xfs_suminfo_raw));
+	if (!comp->sum)
 		do_error(
 _("couldn't allocate memory for incore realtime summary info.\n"));
 
@@ -81,15 +88,27 @@ _("couldn't allocate memory for incore realtime summary info.\n"));
 	 * end (size) of each range of free extents to set the summary info
 	 * properly.
 	 */
-	while (extno < mp->m_sb.sb_rextents)  {
+	while (extno < rtg->rtg_extents) {
 		xfs_rtword_t		freebit = 1;
 		xfs_rtword_t		bits = 0;
-		int			i;
+		int			state, i;
 
 		set_rtword(mp, words, 0);
-		for (i = 0; i < sizeof(xfs_rtword_t) * NBBY &&
-				extno < mp->m_sb.sb_rextents; i++, extno++)  {
-			if (get_rtbmap(extno) == XR_E_FREE)  {
+		for (i = 0; i < sizeof(xfs_rtword_t) * NBBY; i++) {
+			if (extno == rtg->rtg_extents)
+				break;
+
+			/*
+			 * Note: for the RTG case it might make sense to use
+			 * get_bmap_ext here and generate multiple bitmap
+			 * entries per lookup.
+			 */
+			if (xfs_has_rtgroups(mp))
+				state = get_bmap(idx,
+					extno * mp->m_sb.sb_rextsize);
+			else
+				state = get_rtbmap(extno);
+			if (state == XR_E_FREE)  {
 				sb_frextents++;
 				bits |= freebit;
 
@@ -104,11 +123,12 @@ _("couldn't allocate memory for incore realtime summary info.\n"));
 
 				offs = xfs_rtsumoffs(mp, libxfs_highbit64(len),
 						start_bmbno);
-				inc_sumcount(mp, sumcompute, offs);
+				inc_sumcount(mp, comp->sum, offs);
 				in_extent = false;
 			}
 
 			freebit <<= 1;
+			extno++;
 		}
 		set_rtword(mp, words, bits);
 		words++;
@@ -122,8 +142,27 @@ _("couldn't allocate memory for incore realtime summary info.\n"));
 		xfs_rtsumoff_t	offs;
 
 		offs = xfs_rtsumoffs(mp, libxfs_highbit64(len), start_bmbno);
-		inc_sumcount(mp, sumcompute, offs);
+		inc_sumcount(mp, comp->sum, offs);
 	}
+}
+
+/*
+ * generate the real-time bitmap and summary info based on the
+ * incore realtime extent map.
+ */
+void
+generate_rtinfo(
+	struct xfs_mount	*mp)
+{
+	struct xfs_rtgroup	*rtg = NULL;
+
+	rt_computed = calloc(mp->m_sb.sb_rgcount, sizeof(struct rtg_computed));
+	if (!rt_computed)
+		do_error(
+	_("couldn't allocate memory for incore realtime info.\n"));
+
+	while ((rtg = xfs_rtgroup_next(mp, rtg)))
+		generate_rtgroup_rtinfo(rtg);
 
 	if (mp->m_sb.sb_frextents != sb_frextents) {
 		do_warn(_("sb_frextents %" PRIu64 ", counted %" PRIu64 "\n"),
@@ -133,12 +172,13 @@ _("couldn't allocate memory for incore realtime summary info.\n"));
 
 static void
 check_rtwords(
-	struct xfs_mount	*mp,
+	struct xfs_rtgroup	*rtg,
 	const char		*filename,
 	unsigned long long	bno,
 	void			*ondisk,
 	void			*incore)
 {
+	struct xfs_mount	*mp = rtg_mount(rtg);
 	unsigned int		wordcnt = mp->m_blockwsize;
 	union xfs_rtword_raw	*o = ondisk, *i = incore;
 	int			badstart = -1;
@@ -152,8 +192,9 @@ check_rtwords(
 			/* Report a range of inconsistency that just ended. */
 			if (badstart >= 0)
 				do_warn(
- _("discrepancy in %s at dblock 0x%llx words 0x%x-0x%x/0x%x\n"),
-					filename, bno, badstart, j - 1, wordcnt);
+ _("discrepancy in %s (%u) at dblock 0x%llx words 0x%x-0x%x/0x%x\n"),
+					filename, rtg_rgno(rtg), bno,
+					badstart, j - 1, wordcnt);
 			badstart = -1;
 			continue;
 		}
@@ -164,44 +205,26 @@ check_rtwords(
 
 	if (badstart >= 0)
 		do_warn(
- _("discrepancy in %s at dblock 0x%llx words 0x%x-0x%x/0x%x\n"),
-					filename, bno, badstart, wordcnt,
-					wordcnt);
+ _("discrepancy in %s (%u) at dblock 0x%llx words 0x%x-0x%x/0x%x\n"),
+			filename, rtg_rgno(rtg), bno,
+			badstart, wordcnt, wordcnt);
 }
 
 static void
 check_rtfile_contents(
-	struct xfs_mount	*mp,
-	enum xfs_metafile_type	metafile_type,
+	struct xfs_rtgroup	*rtg,
+	enum xfs_rtg_inodes	type,
+	void			*buf,
 	xfs_fileoff_t		filelen)
 {
-	struct xfs_bmbt_irec	map;
-	struct xfs_buf		*bp;
-	struct xfs_inode	*ip;
-	const char		*filename;
-	void			*buf;
-	xfs_ino_t		ino;
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	const char		*filename = libxfs_rtginode_name(type);
+	struct xfs_inode	*ip = rtg->rtg_inodes[type];
 	xfs_fileoff_t		bno = 0;
 	int			error;
 
-	switch (metafile_type) {
-	case XFS_METAFILE_RTBITMAP:
-		ino = mp->m_sb.sb_rbmino;
-		filename = "rtbitmap";
-		buf = btmcompute;
-		break;
-	case XFS_METAFILE_RTSUMMARY:
-		ino = mp->m_sb.sb_rsumino;
-		filename = "rtsummary";
-		buf = sumcompute;
-		break;
-	default:
-		return;
-	}
-
-	error = -libxfs_metafile_iget(mp, ino, metafile_type, &ip);
-	if (error) {
-		do_warn(_("unable to open %s file, err %d\n"), filename, error);
+	if (!ip) {
+		do_warn(_("unable to open %s file\n"), filename);
 		return;
 	}
 
@@ -213,12 +236,11 @@ check_rtfile_contents(
 	}
 
 	while (bno < filelen)  {
-		xfs_filblks_t	maplen;
-		int		nmap = 1;
+		struct xfs_bmbt_irec	map;
+		struct xfs_buf		*bp;
+		int			nmap = 1;
 
-		/* Read up to 1MB at a time. */
-		maplen = min(filelen - bno, XFS_B_TO_FSBT(mp, 1048576));
-		error = -libxfs_bmapi_read(ip, bno, maplen, &map, &nmap, 0);
+		error = -libxfs_bmapi_read(ip, bno, 1, &map, &nmap, 0);
 		if (error) {
 			do_warn(_("unable to read %s mapping, err %d\n"),
 					filename, error);
@@ -233,43 +255,104 @@ check_rtfile_contents(
 
 		error = -libxfs_buf_read_uncached(mp->m_dev,
 				XFS_FSB_TO_DADDR(mp, map.br_startblock),
-				XFS_FSB_TO_BB(mp, map.br_blockcount),
-				0, &bp, NULL);
+				XFS_FSB_TO_BB(mp, 1), 0, &bp,
+				xfs_rtblock_ops(mp, type));
 		if (error) {
 			do_warn(_("unable to read %s at dblock 0x%llx, err %d\n"),
 					filename, (unsigned long long)bno, error);
 			break;
 		}
 
-		check_rtwords(mp, filename, bno, bp->b_addr, buf);
+		check_rtwords(rtg, filename, bno, bp->b_addr, buf);
 
-		buf += XFS_FSB_TO_B(mp, map.br_blockcount);
-		bno += map.br_blockcount;
+		buf += mp->m_blockwsize << XFS_WORDLOG;
+		bno++;
 		libxfs_buf_relse(bp);
 	}
+}
 
-	libxfs_irele(ip);
+/*
+ * Try to load a sb-rooted rt metadata file now, since earlier phases may have
+ * fixed verifier problems in the root inode chunk.
+ */
+static void
+try_load_sb_rtfile(
+	struct xfs_mount	*mp,
+	enum xfs_rtg_inodes	type)
+{
+	struct xfs_rtgroup	*rtg = libxfs_rtgroup_grab(mp, 0);
+	struct xfs_trans	*tp;
+	int			error;
+
+	if (rtg->rtg_inodes[type])
+		goto out_rtg;
+
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		goto out_rtg;
+
+
+	error = -libxfs_rtginode_load(rtg, type, tp);
+	if (error)
+		goto out_cancel;
+
+	/* If we can't load the inode, signal to phase 6 to recreate it. */
+	if (!rtg->rtg_inodes[type]) {
+		switch (type) {
+		case XFS_RTGI_BITMAP:
+			need_rbmino = 1;
+			break;
+		case XFS_RTGI_SUMMARY:
+			need_rsumino = 1;
+			break;
+		default:
+			ASSERT(0);
+			break;
+		}
+	}
+
+out_cancel:
+	libxfs_trans_cancel(tp);
+out_rtg:
+	libxfs_rtgroup_rele(rtg);
 }
 
 void
 check_rtbitmap(
 	struct xfs_mount	*mp)
 {
+	struct xfs_rtgroup	*rtg = NULL;
+
 	if (need_rbmino)
 		return;
 
-	check_rtfile_contents(mp, XFS_METAFILE_RTBITMAP,
-			mp->m_sb.sb_rbmblocks);
+	if (!xfs_has_rtgroups(mp))
+		try_load_sb_rtfile(mp, XFS_RTGI_BITMAP);
+
+	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
+		check_rtfile_contents(rtg, XFS_RTGI_BITMAP,
+				rt_computed[rtg_rgno(rtg)].bmp,
+				mp->m_sb.sb_rbmblocks);
+	}
 }
 
 void
 check_rtsummary(
 	struct xfs_mount	*mp)
 {
+	struct xfs_rtgroup	*rtg = NULL;
+
 	if (need_rsumino)
 		return;
 
-	check_rtfile_contents(mp, XFS_METAFILE_RTSUMMARY, mp->m_rsumblocks);
+	if (!xfs_has_rtgroups(mp))
+		try_load_sb_rtfile(mp, XFS_RTGI_SUMMARY);
+
+	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
+		check_rtfile_contents(rtg, XFS_RTGI_SUMMARY,
+				rt_computed[rtg_rgno(rtg)].sum,
+				mp->m_rsumblocks);
+	}
 }
 
 void
@@ -278,8 +361,17 @@ fill_rtbitmap(
 {
 	int			error;
 
+	/*
+	 * For file systems without a RT subvolume we have the bitmap and
+	 * summary files, but they are empty.  In that case rt_computed is
+	 * NULL.
+	 */
+	if (!rt_computed)
+		return;
+
 	error = -libxfs_rtfile_initialize_blocks(rtg, XFS_RTGI_BITMAP,
-			0, rtg_mount(rtg)->m_sb.sb_rbmblocks, btmcompute);
+			0, rtg_mount(rtg)->m_sb.sb_rbmblocks,
+			rt_computed[rtg_rgno(rtg)].bmp);
 	if (error)
 		do_error(
 _("couldn't re-initialize realtime bitmap inode, error %d\n"), error);
@@ -291,9 +383,183 @@ fill_rtsummary(
 {
 	int			error;
 
+	/*
+	 * For file systems without a RT subvolume we have the bitmap and
+	 * summary files, but they are empty.  In that case rt_computed is
+	 * NULL.
+	 */
+	if (!rt_computed)
+		return;
+
 	error = -libxfs_rtfile_initialize_blocks(rtg, XFS_RTGI_SUMMARY,
-			0, rtg_mount(rtg)->m_rsumblocks, sumcompute);
+			0, rtg_mount(rtg)->m_rsumblocks,
+			rt_computed[rtg_rgno(rtg)].sum);
 	if (error)
 		do_error(
 _("couldn't re-initialize realtime summary inode, error %d\n"), error);
 }
+
+bool
+is_rtgroup_inode(
+	xfs_ino_t		ino,
+	enum xfs_rtg_inodes	type)
+{
+	if (!rtg_inodes[type])
+		return false;
+	return bitmap_test(rtg_inodes[type], ino, 1);
+}
+
+bool
+rtgroup_inodes_were_bad(
+	enum xfs_rtg_inodes	type)
+{
+	return rtginodes_bad[type];
+}
+
+void
+mark_rtgroup_inodes_bad(
+	struct xfs_mount	*mp,
+	enum xfs_rtg_inodes	type)
+{
+	struct xfs_rtgroup	*rtg = NULL;
+
+	while ((rtg = xfs_rtgroup_next(mp, rtg)))
+		libxfs_rtginode_irele(&rtg->rtg_inodes[type]);
+
+	rtginodes_bad[type] = true;
+}
+
+static inline int
+mark_rtginode(
+	struct xfs_trans	*tp,
+	struct xfs_rtgroup	*rtg,
+	enum xfs_rtg_inodes	type)
+{
+	struct xfs_inode	*ip;
+	int			error;
+
+	if (!xfs_rtginode_enabled(rtg, type))
+		return 0;
+
+	error = -libxfs_rtginode_load(rtg, type, tp);
+	if (error)
+		goto out_corrupt;
+
+	ip = rtg->rtg_inodes[type];
+	if (!ip)
+		goto out_corrupt;
+
+	if (xfs_has_rtgroups(rtg_mount(rtg))) {
+		if (bitmap_test(rtg_inodes[type], ip->i_ino, 1)) {
+			error = EFSCORRUPTED;
+			goto out_corrupt;
+		}
+
+		error = bitmap_set(rtg_inodes[type], ip->i_ino, 1);
+		if (error)
+			goto out_corrupt;
+	}
+
+	/*
+	 * Phase 3 will clear the ondisk inodes of all rt metadata files, but
+	 * it doesn't reset any blocks.  Keep the incore inodes loaded so that
+	 * phase 4 can check the rt metadata.  These inodes must be dropped
+	 * before rebuilding can begin during phase 6.
+	 */
+	return 0;
+
+out_corrupt:
+	rtginodes_bad[type] = true;
+	return error;
+}
+
+/* Mark the reachable rt metadata inodes prior to the inode scan. */
+void
+discover_rtgroup_inodes(
+	struct xfs_mount	*mp)
+{
+	struct xfs_rtgroup	*rtg = NULL;
+	struct xfs_trans	*tp;
+	int			error, err2;
+	int			i;
+
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		goto out;
+	if (xfs_has_rtgroups(mp) && mp->m_sb.sb_rgcount > 0) {
+		error = -libxfs_rtginode_load_parent(tp);
+		if (error)
+			goto out_cancel;
+	}
+
+	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
+		for (i = 0; i < XFS_RTGI_MAX; i++) {
+			err2 = mark_rtginode(tp, rtg, i);
+			if (err2 && !error)
+				error = err2;
+		}
+	}
+
+out_cancel:
+	libxfs_trans_cancel(tp);
+out:
+	if (xfs_has_rtgroups(mp) && error) {
+		/*
+		 * Old xfs_repair didn't complain if rtbitmaps didn't load
+		 * until phase 5, so only turn on extra warnings during phase 2
+		 * for newer filesystems.
+		 */
+		switch (error) {
+		case EFSCORRUPTED:
+			do_warn(
+ _("corruption in metadata directory tree while discovering rt group inodes\n"));
+			break;
+		default:
+			do_warn(
+ _("couldn't discover rt group inodes, err %d\n"),
+						error);
+			break;
+		}
+	}
+}
+
+/* Unload incore rtgroup inodes before rebuilding rt metadata. */
+void
+unload_rtgroup_inodes(
+	struct xfs_mount	*mp)
+{
+	struct xfs_rtgroup	*rtg = NULL;
+	unsigned int		i;
+
+	while ((rtg = xfs_rtgroup_next(mp, rtg)))
+		for (i = 0; i < XFS_RTGI_MAX; i++)
+			libxfs_rtginode_irele(&rtg->rtg_inodes[i]);
+
+	libxfs_rtginode_irele(&mp->m_rtdirip);
+}
+
+void
+init_rtgroup_inodes(void)
+{
+	unsigned int		i;
+	int			error;
+
+	for (i = 0; i < XFS_RTGI_MAX; i++) {
+		error = bitmap_alloc(&rtg_inodes[i]);
+		if (error)
+			break;
+	}
+
+	if (error)
+		do_error(_("could not allocate rtginode bitmap, err=%d!\n"),
+				error);
+}
+
+void
+free_rtgroup_inodes(void)
+{
+	int			i;
+
+	for (i = 0; i < XFS_RTGI_MAX; i++)
+		bitmap_free(&rtg_inodes[i]);
+}
diff --git a/repair/rt.h b/repair/rt.h
index 9d837de65a7dfc..4dfe4a921d4cdf 100644
--- a/repair/rt.h
+++ b/repair/rt.h
@@ -13,4 +13,24 @@ void check_rtsummary(struct xfs_mount *mp);
 void fill_rtbitmap(struct xfs_rtgroup *rtg);
 void fill_rtsummary(struct xfs_rtgroup *rtg);
 
+void discover_rtgroup_inodes(struct xfs_mount *mp);
+void unload_rtgroup_inodes(struct xfs_mount *mp);
+
+void init_rtgroup_inodes(void);
+void free_rtgroup_inodes(void);
+
+bool is_rtgroup_inode(xfs_ino_t ino, enum xfs_rtg_inodes type);
+
+static inline bool is_rtbitmap_inode(xfs_ino_t ino)
+{
+	return is_rtgroup_inode(ino, XFS_RTGI_BITMAP);
+}
+static inline bool is_rtsummary_inode(xfs_ino_t ino)
+{
+	return is_rtgroup_inode(ino, XFS_RTGI_SUMMARY);
+}
+
+void mark_rtgroup_inodes_bad(struct xfs_mount *mp, enum xfs_rtg_inodes type);
+bool rtgroup_inodes_were_bad(enum xfs_rtg_inodes type);
+
 #endif /* _XFS_REPAIR_RT_H_ */
diff --git a/repair/sb.c b/repair/sb.c
index 7f27833d697ea9..d52ab2ffeaf28c 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -311,6 +311,38 @@ verify_sb_loginfo(
 	return true;
 }
 
+static int
+verify_sb_rtgroups(
+	struct xfs_sb		*sbp)
+{
+	uint64_t		groups;
+
+	if (sbp->sb_rextsize == 0)
+		return XR_BAD_RT_GEO_DATA;
+
+	if (sbp->sb_rgextents > XFS_MAX_RGBLOCKS / sbp->sb_rextsize)
+		return XR_BAD_RT_GEO_DATA;
+
+	if (sbp->sb_rgextents < XFS_MIN_RGEXTENTS)
+		return XR_BAD_RT_GEO_DATA;
+
+	if (sbp->sb_rgcount > XFS_MAX_RGNUMBER)
+		return XR_BAD_RT_GEO_DATA;
+
+	groups = howmany_64(sbp->sb_rextents, sbp->sb_rgextents);
+	if (groups != sbp->sb_rgcount)
+		return XR_BAD_RT_GEO_DATA;
+
+	if (!(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_EXCHRANGE))
+		return XR_BAD_RT_GEO_DATA;
+
+	if (sbp->sb_rgblklog != libxfs_compute_rgblklog(sbp->sb_rgextents,
+							sbp->sb_rextsize))
+		return XR_BAD_RT_GEO_DATA;
+
+	return 0;
+}
+
 /*
  * verify a superblock -- does not verify root inode #
  *	can only check that geometry info is internally
@@ -482,6 +514,15 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 	if (sb->sb_blocklog + sb->sb_dirblklog > XFS_MAX_BLOCKSIZE_LOG)
 		return XR_BAD_DIR_SIZE_DATA;
 
+	if (xfs_sb_version_hasmetadir(sb)) {
+		if (memchr_inv(sb->sb_pad, 0, sizeof(sb->sb_pad)))
+			return XR_SB_GEO_MISMATCH;
+
+		ret = verify_sb_rtgroups(sb);
+		if (ret)
+			return ret;
+	}
+
 	return(XR_OK);
 }
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 30b014898c3203..d06bf659df89c1 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -27,6 +27,7 @@
 #include "bulkload.h"
 #include "quotacheck.h"
 #include "rcbag_btree.h"
+#include "rt.h"
 
 /*
  * option tables for getsubopt calls
@@ -729,10 +730,12 @@ _("sb root inode value %" PRIu64 " valid but in unaligned location (expected %"P
 		rootino++;
 	}
 
-	validate_sb_ino(&mp->m_sb.sb_rbmino, rootino + 1,
-			_("realtime bitmap"));
-	validate_sb_ino(&mp->m_sb.sb_rsumino, rootino + 2,
-			_("realtime summary"));
+	if (!xfs_has_rtgroups(mp)) {
+		validate_sb_ino(&mp->m_sb.sb_rbmino, rootino + 1,
+				_("realtime bitmap"));
+		validate_sb_ino(&mp->m_sb.sb_rsumino, rootino + 2,
+				_("realtime summary"));
+	}
 }
 
 /*
@@ -1345,6 +1348,7 @@ main(int argc, char **argv)
 	incore_ino_init(mp);
 	incore_ext_init(mp);
 	rmaps_init(mp);
+	init_rtgroup_inodes();
 
 	/* initialize random globals now that we know the fs geometry */
 	inodes_per_block = mp->m_sb.sb_inopblock;
@@ -1390,11 +1394,14 @@ main(int argc, char **argv)
 		phase6(mp);
 		phase_end(mp, 6);
 
+		free_rtgroup_inodes();
+
 		phase7(mp, phase2_threads);
 		phase_end(mp, 7);
 	} else  {
 		do_warn(
 _("Inode allocation btrees are too corrupted, skipping phases 6 and 7\n"));
+		free_rtgroup_inodes();
 	}
 
 	if (lost_quotas && !have_uquotino && !have_gquotino && !have_pquotino) {

