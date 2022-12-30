Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26EEFC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:48:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236196AbiLaCsP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:48:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236240AbiLaCsO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:48:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F223120B6
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:48:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C09BD61D23
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C700C433D2;
        Sat, 31 Dec 2022 02:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454892;
        bh=Pb1OMRY3mENs386rcL2Kecq7myihpAO4arEeyEd7SdI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qx+qacW5A3Ypdf10UVpObNB7LbrDlOawI11K+9WGdn2hUyzp1nwOVrgFSnYFcV8ka
         KQlYV2rM7I8s76ac2CR0YRT6OPQlaE4FftN8Ea7LSX/6NbpqtYUHIzho34t+NuVADb
         RKsBXlOCvtsynhgw99+aqAVxGmKGN2StdVb0BzQy8WT6baP4/BjrstqoQlJfxZvQY0
         WQjm0eBqIEA6iEFXQYz7jkzgBKrCFc/kWT0OQIcQdo6vyBYyHSaJLzPtmQsPGOgm7W
         SBC/UM2scBnqJg0jNzgtkfLGqcSmCkfh0jklQXfvw6kdXXtszVaX1XHEgklASnk5yK
         YHaS7KCcArA2A==
Subject: [PATCH 22/41] xfs_db: support rudimentary checks of the rtrmap btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:58 -0800
Message-ID: <167243879885.732820.7680188758290930222.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Perform some fairly superficial checks of the rtrmap btree.  We'll
do more sophisticated checks in xfs_repair, but provide enough of
a spot-check here that we can do simple things.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c |  203 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 db/inode.c |   25 +++++++
 db/inode.h |    1 
 3 files changed, 223 insertions(+), 6 deletions(-)


diff --git a/db/check.c b/db/check.c
index 0e1fb3cf8f1..79f26b0e789 100644
--- a/db/check.c
+++ b/db/check.c
@@ -20,6 +20,7 @@
 #include "init.h"
 #include "malloc.h"
 #include "dir2.h"
+#include "inode.h"
 
 typedef enum {
 	IS_USER_QUOTA, IS_PROJECT_QUOTA, IS_GROUP_QUOTA,
@@ -57,6 +58,7 @@ typedef enum {
 	DBM_RLDATA,
 	DBM_COWDATA,
 	DBM_RTSB,
+	DBM_BTRTRMAP,
 	DBM_NDBM
 } dbm_t;
 
@@ -71,6 +73,7 @@ typedef struct inodata {
 	xfs_ino_t	ino;
 	struct inodata	*parent;
 	char		*name;
+	xfs_rgnumber_t	rgno;	/* only if rtgroup metadata inode */
 } inodata_t;
 #define	MIN_INODATA_HASH_SIZE	256
 #define	MAX_INODATA_HASH_SIZE	65536
@@ -189,6 +192,7 @@ static const char	*typename[] = {
 	"rldata",
 	"cowdata",
 	"rtsb",
+	"btrtrmap",
 	NULL
 };
 
@@ -341,6 +345,9 @@ static void		process_rtbitmap(blkmap_t *blkmap);
 static void		process_rtsummary(blkmap_t *blkmap);
 static xfs_ino_t	process_sf_dir_v2(struct xfs_dinode *dip, int *dot,
 					  int *dotdot, inodata_t *id);
+static void		process_rtrmap(struct inodata *id,
+				       struct xfs_dinode *dip,
+				       xfs_rfsblock_t *toti);
 static void		quota_add(xfs_dqid_t *p, xfs_dqid_t *g, xfs_dqid_t *u,
 				  int dq, xfs_qcnt_t bc, xfs_qcnt_t ic,
 				  xfs_qcnt_t rc);
@@ -366,6 +373,12 @@ static void		scanfunc_bmap(struct xfs_btree_block *block,
 				      xfs_rfsblock_t *toti, xfs_extnum_t *nex,
 				      blkmap_t **blkmapp, int isroot,
 				      typnm_t btype);
+static void		scanfunc_rtrmap(struct xfs_btree_block *block,
+				      int level, dbm_t type, xfs_fsblock_t bno,
+				      inodata_t *id, xfs_rfsblock_t *totd,
+				      xfs_rfsblock_t *toti, xfs_extnum_t *nex,
+				      blkmap_t **blkmapp, int isroot,
+				      typnm_t btype);
 static void		scanfunc_bno(struct xfs_btree_block *block, int level,
 				     xfs_agf_t *agf, xfs_agblock_t bno,
 				     int isroot);
@@ -839,12 +852,21 @@ blockget_f(
 	xfs_agnumber_t	agno;
 	int		oldprefix;
 	int		sbyell;
+	int		error;
 
 	if (dbmap) {
 		dbprintf(_("already have block usage information\n"));
 		return 0;
 	}
 
+	error = init_rtmeta_inode_bitmaps(mp);
+	if (error) {
+		dbprintf(_("error %d setting up rt metadata inode bitmaps\n"),
+				error);
+		exitcode = 3;
+		return 0;
+	}
+
 	if (!init(argc, argv)) {
 		if (serious_error)
 			exitcode = 3;
@@ -1101,6 +1123,7 @@ blocktrash_f(
 		   (1 << DBM_QUOTA) |
 		   (1 << DBM_RTBITMAP) |
 		   (1 << DBM_RTSUM) |
+		   (1 << DBM_BTRTRMAP) |
 		   (1 << DBM_SYMLINK) |
 		   (1 << DBM_BTFINO) |
 		   (1 << DBM_BTRMAP) |
@@ -2840,7 +2863,7 @@ process_inode(
 		0				/* type 15 unused */
 	};
 	static char		*fmtnames[] = {
-		"dev", "local", "extents", "btree", "uuid"
+		"dev", "local", "extents", "btree", "uuid", "rmap"
 	};
 
 	ino = XFS_AGINO_TO_INO(mp, be32_to_cpu(agf->agf_seqno), agino);
@@ -2906,11 +2929,20 @@ process_inode(
 				be32_to_cpu(dip->di_next_unlinked), ino);
 		error++;
 	}
-	/*
-	 * di_mode is a 16-bit uint so no need to check the < 0 case
-	 */
+
+	/* Check that mode and data fork format match. */
 	mode = be16_to_cpu(dip->di_mode);
-	if ((((mode & S_IFMT) >> 12) > 15) ||
+	if (is_rtrmap_inode(ino)) {
+		if (!S_ISREG(mode) || dip->di_format != XFS_DINODE_FMT_RMAP) {
+			if (v)
+				dbprintf(
+			_("bad format %d for rtrmap inode %lld type %#o\n"),
+					dip->di_format, (long long)ino,
+					mode & S_IFMT);
+			error++;
+			return;
+		}
+	} else if ((((mode & S_IFMT) >> 12) > 15) ||
 	    (!(okfmts[(mode & S_IFMT) >> 12] & (1 << dip->di_format)))) {
 		if (v)
 			dbprintf(_("bad format %d for inode %lld type %#o\n"),
@@ -2983,6 +3015,9 @@ process_inode(
 			blkmap = blkmap_alloc(dnextents);
 			if (!xfs_has_metadir(mp))
 				addlink_inode(id);
+		} else if (is_rtrmap_inode(id->ino)) {
+			type = DBM_BTRTRMAP;
+			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
 		}
 		else
 			type = DBM_DATA;
@@ -3014,6 +3049,10 @@ process_inode(
 		process_btinode(id, dip, type, &totdblocks, &totiblocks,
 			&nextents, &blkmap, XFS_DATA_FORK);
 		break;
+	case XFS_DINODE_FMT_RMAP:
+		id->rgno = rtgroup_for_rtrmap_ino(mp, id->ino);
+		process_rtrmap(id, dip, &totiblocks);
+		break;
 	}
 	if (dip->di_forkoff) {
 		sbversion |= XFS_SB_VERSION_ATTRBIT;
@@ -3039,6 +3078,7 @@ process_inode(
 		case DBM_RTBITMAP:
 		case DBM_RTSUM:
 		case DBM_SYMLINK:
+		case DBM_BTRTRMAP:
 		case DBM_UNKNOWN:
 			bc = totdblocks + totiblocks +
 			     atotdblocks + atotiblocks;
@@ -3786,6 +3826,79 @@ process_rtsummary(
 	}
 }
 
+static void
+process_rtrmap(
+	struct inodata		*id,
+	struct xfs_dinode	*dip,
+	xfs_rfsblock_t		*toti)
+{
+	xfs_extnum_t		nex = 0;
+	xfs_rfsblock_t		totd = 0;
+	struct xfs_rtrmap_root	*dib;
+	int			whichfork = XFS_DATA_FORK;
+	int			i;
+	int			maxrecs;
+	xfs_rtrmap_ptr_t	*pp;
+
+	if (id->rgno == NULLRGNUMBER) {
+		dbprintf(
+	_("rt group for rmap ino %lld not found\n"),
+				id->ino);
+		error++;
+		return;
+	}
+
+	dib = (struct xfs_rtrmap_root *)XFS_DFORK_PTR(dip, whichfork);
+	if (be16_to_cpu(dib->bb_level) >= mp->m_rtrmap_maxlevels) {
+		if (!sflag || id->ilist)
+			dbprintf(_("level for ino %lld rtrmap root too "
+				 "large (%u)\n"),
+				id->ino,
+				be16_to_cpu(dib->bb_level));
+		error++;
+		return;
+	}
+	maxrecs = libxfs_rtrmapbt_droot_maxrecs(
+			XFS_DFORK_SIZE(dip, mp, whichfork),
+			dib->bb_level == 0);
+	if (be16_to_cpu(dib->bb_numrecs) > maxrecs) {
+		if (!sflag || id->ilist)
+			dbprintf(_("numrecs for ino %lld rtrmap root too "
+				 "large (%u)\n"),
+				id->ino,
+				be16_to_cpu(dib->bb_numrecs));
+		error++;
+		return;
+	}
+	if (be16_to_cpu(dib->bb_level) == 0) {
+		struct xfs_rmap_rec	*rp;
+		xfs_fsblock_t		lastblock;
+
+		rp = xfs_rtrmap_droot_rec_addr(dib, 1);
+		lastblock = 0;
+		for (i = 0; i < be16_to_cpu(dib->bb_numrecs); i++) {
+			if (be32_to_cpu(rp[i].rm_startblock) < lastblock) {
+				dbprintf(_(
+		"out-of-order rtrmap btree record %d (%u %u) root\n"),
+					 i, be32_to_cpu(rp[i].rm_startblock),
+					 be32_to_cpu(rp[i].rm_startblock));
+			} else {
+				lastblock = be32_to_cpu(rp[i].rm_startblock) +
+					    be32_to_cpu(rp[i].rm_blockcount);
+			}
+		}
+		return;
+	} else {
+		pp = xfs_rtrmap_droot_ptr_addr(dib, 1, maxrecs);
+		for (i = 0; i < be16_to_cpu(dib->bb_numrecs); i++)
+			scan_lbtree(get_unaligned_be64(&pp[i]),
+					be16_to_cpu(dib->bb_level),
+					scanfunc_rtrmap, DBM_BTRTRMAP,
+					id, &totd, toti,
+					&nex, NULL, 1, TYP_RTRMAPBT);
+	}
+}
+
 static xfs_ino_t
 process_sf_dir_v2(
 	struct xfs_dinode	*dip,
@@ -4884,6 +4997,86 @@ scanfunc_rmap(
 				TYP_RMAPBT);
 }
 
+static void
+scanfunc_rtrmap(
+	struct xfs_btree_block	*block,
+	int			level,
+	dbm_t			type,
+	xfs_fsblock_t		bno,
+	inodata_t		*id,
+	xfs_rfsblock_t		*totd,
+	xfs_rfsblock_t		*toti,
+	xfs_extnum_t		*nex,
+	blkmap_t		**blkmapp,
+	int			isroot,
+	typnm_t			btype)
+{
+	xfs_agblock_t		agbno;
+	xfs_agnumber_t		agno;
+	int			i;
+	xfs_rtrmap_ptr_t	*pp;
+	struct xfs_rmap_rec	*rp;
+	xfs_fsblock_t		lastblock;
+
+	agno = XFS_FSB_TO_AGNO(mp, bno);
+	agbno = XFS_FSB_TO_AGBNO(mp, bno);
+	if (be32_to_cpu(block->bb_magic) != XFS_RTRMAP_CRC_MAGIC) {
+		dbprintf(_("bad magic # %#x in rtrmapbt block %u/%u\n"),
+			be32_to_cpu(block->bb_magic), agno, bno);
+		serious_error++;
+		return;
+	}
+	if (be16_to_cpu(block->bb_level) != level) {
+		if (!sflag)
+			dbprintf(_("expected level %d got %d in rtrmapbt block "
+				 "%u/%u\n"),
+				level, be16_to_cpu(block->bb_level), agno, bno);
+		error++;
+	}
+	set_dbmap(agno, agbno, 1, type, agno, agbno);
+	set_inomap(agno, agbno, 1, id);
+	(*toti)++;
+	if (level == 0) {
+		if (be16_to_cpu(block->bb_numrecs) > mp->m_rtrmap_mxr[0] ||
+		    (isroot == 0 && be16_to_cpu(block->bb_numrecs) < mp->m_rtrmap_mnr[0])) {
+			dbprintf(_("bad btree nrecs (%u, min=%u, max=%u) in "
+				 "rtrmapbt block %u/%u\n"),
+				be16_to_cpu(block->bb_numrecs), mp->m_rtrmap_mnr[0],
+				mp->m_rtrmap_mxr[0], agno, bno);
+			serious_error++;
+			return;
+		}
+		rp = xfs_rtrmap_rec_addr(block, 1);
+		lastblock = 0;
+		for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++) {
+			if (be32_to_cpu(rp[i].rm_startblock) < lastblock) {
+				dbprintf(_(
+		"out-of-order rtrmap btree record %d (%u %u) block %u/%u l %llu\n"),
+					 i, be32_to_cpu(rp[i].rm_startblock),
+					 be32_to_cpu(rp[i].rm_blockcount),
+					 agno, bno, lastblock);
+			} else {
+				lastblock = be32_to_cpu(rp[i].rm_startblock) +
+					    be32_to_cpu(rp[i].rm_blockcount);
+			}
+		}
+		return;
+	}
+	if (be16_to_cpu(block->bb_numrecs) > mp->m_rtrmap_mxr[1] ||
+	    (isroot == 0 && be16_to_cpu(block->bb_numrecs) < mp->m_rtrmap_mnr[1])) {
+		dbprintf(_("bad btree nrecs (%u, min=%u, max=%u) in rtrmapbt "
+			 "block %u/%u\n"),
+			be16_to_cpu(block->bb_numrecs), mp->m_rtrmap_mnr[1],
+			mp->m_rtrmap_mxr[1], agno, bno);
+		serious_error++;
+		return;
+	}
+	pp = xfs_rtrmap_ptr_addr(block, 1, mp->m_rtrmap_mxr[1]);
+	for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++)
+		scan_lbtree(be64_to_cpu(pp[i]), level, scanfunc_rtrmap, type, id,
+					totd, toti, nex, blkmapp, 0, btype);
+}
+
 static void
 scanfunc_refcnt(
 	struct xfs_btree_block	*block,
diff --git a/db/inode.c b/db/inode.c
index 460d99175ab..2d28eae4dad 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -637,7 +637,12 @@ inode_init(void)
 	add_command(&inode_cmd);
 }
 
-static struct bitmap	*rmap_inodes;
+struct rtgroup_inodes {
+	xfs_ino_t		rmap_ino;
+};
+
+static struct rtgroup_inodes	*rtgroup_inodes;
+static struct bitmap		*rmap_inodes;
 
 static inline int
 set_rtgroup_rmap_inode(
@@ -663,6 +668,7 @@ set_rtgroup_rmap_inode(
 	if (rtino == NULLFSINO)
 		return EFSCORRUPTED;
 
+	rtgroup_inodes[rgno].rmap_ino = rtino;
 	return bitmap_set(rmap_inodes, rtino, 1);
 }
 
@@ -676,6 +682,11 @@ init_rtmeta_inode_bitmaps(
 	if (rmap_inodes)
 		return 0;
 
+	rtgroup_inodes = calloc(mp->m_sb.sb_rgcount,
+			sizeof(struct rtgroup_inodes));
+	if (!rtgroup_inodes)
+		return ENOMEM;
+
 	error = bitmap_alloc(&rmap_inodes);
 	if (error)
 		return error;
@@ -694,6 +705,18 @@ bool is_rtrmap_inode(xfs_ino_t ino)
 	return bitmap_test(rmap_inodes, ino, 1);
 }
 
+xfs_rgnumber_t rtgroup_for_rtrmap_ino(struct xfs_mount *mp, xfs_ino_t ino)
+{
+	unsigned int i;
+
+	for (i = 0; i < mp->m_sb.sb_rgcount; i++) {
+		if (rtgroup_inodes[i].rmap_ino == ino)
+			return i;
+	}
+
+	return NULLRGNUMBER;
+}
+
 typnm_t
 inode_next_type(void)
 {
diff --git a/db/inode.h b/db/inode.h
index a47b0575a15..04e606abed3 100644
--- a/db/inode.h
+++ b/db/inode.h
@@ -26,3 +26,4 @@ extern void	set_cur_inode(xfs_ino_t ino);
 
 int init_rtmeta_inode_bitmaps(struct xfs_mount *mp);
 bool is_rtrmap_inode(xfs_ino_t ino);
+xfs_rgnumber_t rtgroup_for_rtrmap_ino(struct xfs_mount *mp, xfs_ino_t ino);

