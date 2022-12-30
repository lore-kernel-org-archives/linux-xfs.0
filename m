Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3314AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236265AbiLaDBP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiLaDBO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:01:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1B315816
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:01:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACC24B81E82
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C052C433EF;
        Sat, 31 Dec 2022 03:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455670;
        bh=JO4IP5Mid8/euVQFn5mVC/Du8+DHMDl6u9IC7HqQDjY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cxa5kZ2kOGAI2WnfscblH4HTsBZr+rFr5/AMIHuDAQDjumSyG5K7OVsHtk3EEE27b
         F8OCarfb/cmPGrj1YV0z5P6+vL67xiinC5HnHWmIju5mTtoz9elo8GR+TKbhYmRqKd
         JH0gm3YmII0dQrbUpXqEZWPtYa5G8YS+ca3K8dhTTLQJo97smitfsoTNqcSCisei9X
         i6vFfo0nvxZp+9jKi6gM3/syDSB6mB1ffNMbitDQv7kRj/lkDgUc5SN9B2Q0X8gIsg
         g6/Qe1+Plqh56SKiDRs7wG4wUnJNcWjmxNtbBsnzEP5/1JeEHJ7kOTWzaxXQmX8jtR
         DD7qus/GxjnsA==
Subject: [PATCH 27/41] xfs_db: support rudimentary checks of the rtrefcount
 btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:11 -0800
Message-ID: <167243881127.734096.9765882862437810987.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Perform some fairly superficial checks of the rtrefcount btree.  We'll
do more sophisticated checks in xfs_repair, but provide enough of
a spot-check here that we can do simple things.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c |  254 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 db/inode.c |   14 +++
 db/inode.h |    1 
 3 files changed, 261 insertions(+), 8 deletions(-)


diff --git a/db/check.c b/db/check.c
index 6c92b961283..3a55c152eb1 100644
--- a/db/check.c
+++ b/db/check.c
@@ -59,6 +59,8 @@ typedef enum {
 	DBM_COWDATA,
 	DBM_RTSB,
 	DBM_BTRTRMAP,
+	DBM_BTRTREFC,
+	DBM_RLRTDATA,
 	DBM_NDBM
 } dbm_t;
 
@@ -193,6 +195,8 @@ static const char	*typename[] = {
 	"cowdata",
 	"rtsb",
 	"btrtrmap",
+	"btrtrefc",
+	"rlrtdata",
 	NULL
 };
 
@@ -268,7 +272,7 @@ static void		check_linkcounts(xfs_agnumber_t agno);
 static int		check_range(xfs_agnumber_t agno, xfs_agblock_t agbno,
 				    xfs_extlen_t len);
 static void		check_rdbmap(xfs_rfsblock_t bno, xfs_extlen_t len,
-				     dbm_t type);
+				     dbm_t type, bool is_reflink);
 static int		check_rinomap(xfs_rfsblock_t bno, xfs_extlen_t len,
 				      xfs_ino_t c_ino);
 static void		check_rootdir(void);
@@ -348,6 +352,9 @@ static xfs_ino_t	process_sf_dir_v2(struct xfs_dinode *dip, int *dot,
 static void		process_rtrmap(struct inodata *id,
 				       struct xfs_dinode *dip,
 				       xfs_rfsblock_t *toti);
+static void		process_rtrefc(struct inodata *id,
+				       struct xfs_dinode *dip,
+				       xfs_rfsblock_t *toti);
 static void		quota_add(xfs_dqid_t *p, xfs_dqid_t *g, xfs_dqid_t *u,
 				  int dq, xfs_qcnt_t bc, xfs_qcnt_t ic,
 				  xfs_qcnt_t rc);
@@ -379,6 +386,12 @@ static void		scanfunc_rtrmap(struct xfs_btree_block *block,
 				      xfs_rfsblock_t *toti, xfs_extnum_t *nex,
 				      blkmap_t **blkmapp, int isroot,
 				      typnm_t btype);
+static void		scanfunc_rtrefc(struct xfs_btree_block *block,
+				      int level, dbm_t type, xfs_fsblock_t bno,
+				      inodata_t *id, xfs_rfsblock_t *totd,
+				      xfs_rfsblock_t *toti, xfs_extnum_t *nex,
+				      blkmap_t **blkmapp, int isroot,
+				      typnm_t btype);
 static void		scanfunc_bno(struct xfs_btree_block *block, int level,
 				     xfs_agf_t *agf, xfs_agblock_t bno,
 				     int isroot);
@@ -1128,6 +1141,7 @@ blocktrash_f(
 		   (1ULL << DBM_BTFINO) |
 		   (1ULL << DBM_BTRMAP) |
 		   (1ULL << DBM_BTREFC) |
+		   (1ULL << DBM_BTRTREFC) |
 		   (1ULL << DBM_SB);
 	while ((c = getopt(argc, argv, "0123n:o:s:t:x:y:z")) != EOF) {
 		switch (c) {
@@ -1562,7 +1576,8 @@ static void
 check_rdbmap(
 	xfs_rfsblock_t	bno,
 	xfs_extlen_t	len,
-	dbm_t		type)
+	dbm_t		type,
+	bool		ignore_reflink)
 {
 	xfs_extlen_t	i;
 	char		*p;
@@ -1574,6 +1589,9 @@ check_rdbmap(
 			error++;
 			break;
 		}
+		if (ignore_reflink && (*p == DBM_UNKNOWN || *p == DBM_RTDATA ||
+				       *p == DBM_RLRTDATA))
+			continue;
 		if ((dbm_t)*p != type) {
 			if (!sflag || CHECK_BLIST(bno + i))
 				dbprintf(_("rtblock %llu expected type %s got "
@@ -1600,6 +1618,8 @@ check_rinomap(
 			bno, bno + len - 1, c_ino);
 		return 0;
 	}
+	if (xfs_has_rtreflink(mp))
+		return 0;
 	for (i = 0, rval = 1, idp = &inomap[mp->m_sb.sb_agcount][bno];
 	     i < len;
 	     i++, idp++) {
@@ -1740,6 +1760,26 @@ check_set_dbmap(
 	}
 }
 
+/*
+ * We don't check the accuracy of reference counts -- all we do is ensure
+ * that a data block never crosses with non-data blocks.  repair can check
+ * those kinds of things.
+ *
+ * So with that in mind, if we're setting a block to be data or rldata,
+ * don't complain so long as the block is currently unknown, data, or rldata.
+ * Don't let blocks downgrade from rldata -> data.
+ */
+static bool
+is_rtreflink(
+	dbm_t		type2)
+{
+	if (!xfs_has_rtreflink(mp))
+		return false;
+	if (type2 == DBM_RTDATA || type2 == DBM_RLRTDATA)
+		return true;
+	return false;
+}
+
 static void
 check_set_rdbmap(
 	xfs_rfsblock_t	bno,
@@ -1753,7 +1793,7 @@ check_set_rdbmap(
 
 	if (!check_rrange(bno, len))
 		return;
-	check_rdbmap(bno, len, type1);
+	check_rdbmap(bno, len, type1, is_rtreflink(type2));
 	mayprint = verbose | blist_size;
 	for (i = 0, p = &dbmap[mp->m_sb.sb_agcount][bno]; i < len; i++, p++) {
 		if (!rdbmap_boundscheck(bno + i)) {
@@ -2863,7 +2903,7 @@ process_inode(
 		0				/* type 15 unused */
 	};
 	static char		*fmtnames[] = {
-		"dev", "local", "extents", "btree", "uuid", "rmap"
+		"dev", "local", "extents", "btree", "uuid", "rmap", "refcount"
 	};
 
 	ino = XFS_AGINO_TO_INO(mp, be32_to_cpu(agf->agf_seqno), agino);
@@ -2942,6 +2982,16 @@ process_inode(
 			error++;
 			return;
 		}
+	} else if (is_rtrefcount_inode(ino)) {
+		if (!S_ISREG(mode) || dip->di_format != XFS_DINODE_FMT_REFCOUNT) {
+			if (v)
+				dbprintf(
+			_("bad format %d for rtrefc inode %lld type %#o\n"),
+					dip->di_format, (long long)ino,
+					mode & S_IFMT);
+			error++;
+			return;
+		}
 	} else if ((((mode & S_IFMT) >> 12) > 15) ||
 	    (!(okfmts[(mode & S_IFMT) >> 12] & (1 << dip->di_format)))) {
 		if (v)
@@ -3018,6 +3068,9 @@ process_inode(
 		} else if (is_rtrmap_inode(id->ino)) {
 			type = DBM_BTRTRMAP;
 			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
+		} else if (is_rtrefcount_inode(id->ino)) {
+			type = DBM_BTRTREFC;
+			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
 		}
 		else
 			type = DBM_DATA;
@@ -3053,6 +3106,10 @@ process_inode(
 		id->rgno = rtgroup_for_rtrmap_ino(mp, id->ino);
 		process_rtrmap(id, dip, &totiblocks);
 		break;
+	case XFS_DINODE_FMT_REFCOUNT:
+		id->rgno = rtgroup_for_rtrefcount_ino(mp, id->ino);
+		process_rtrefc(id, dip, &totiblocks);
+		break;
 	}
 	if (dip->di_forkoff) {
 		sbversion |= XFS_SB_VERSION_ATTRBIT;
@@ -3079,6 +3136,7 @@ process_inode(
 		case DBM_RTSUM:
 		case DBM_SYMLINK:
 		case DBM_BTRTRMAP:
+		case DBM_BTRTREFC:
 		case DBM_UNKNOWN:
 			bc = totdblocks + totiblocks +
 			     atotdblocks + atotiblocks;
@@ -3883,8 +3941,7 @@ process_rtrmap(
 					 i, be32_to_cpu(rp[i].rm_startblock),
 					 be32_to_cpu(rp[i].rm_startblock));
 			} else {
-				lastblock = be32_to_cpu(rp[i].rm_startblock) +
-					    be32_to_cpu(rp[i].rm_blockcount);
+				lastblock = be32_to_cpu(rp[i].rm_startblock);
 			}
 		}
 		return;
@@ -3899,6 +3956,79 @@ process_rtrmap(
 	}
 }
 
+static void
+process_rtrefc(
+	struct inodata		*id,
+	struct xfs_dinode	*dip,
+	xfs_rfsblock_t		*toti)
+{
+	xfs_extnum_t		nex = 0;
+	xfs_rfsblock_t		totd = 0;
+	struct xfs_rtrefcount_root *dib;
+	int			whichfork = XFS_DATA_FORK;
+	int			i;
+	int			maxrecs;
+	xfs_rtrefcount_ptr_t	*pp;
+
+	if (id->rgno == NULLRGNUMBER) {
+		dbprintf(
+	_("rt group for refcount ino %lld not found\n"),
+				id->ino);
+		error++;
+		return;
+	}
+
+	dib = (struct xfs_rtrefcount_root *)XFS_DFORK_PTR(dip, whichfork);
+	if (be16_to_cpu(dib->bb_level) >= mp->m_rtrefc_maxlevels) {
+		if (!sflag || id->ilist)
+			dbprintf(_("level for ino %lld rtrefc root too "
+				 "large (%u)\n"),
+				id->ino,
+				be16_to_cpu(dib->bb_level));
+		error++;
+		return;
+	}
+	maxrecs = libxfs_rtrefcountbt_droot_maxrecs(
+			XFS_DFORK_SIZE(dip, mp, whichfork),
+			dib->bb_level == 0);
+	if (be16_to_cpu(dib->bb_numrecs) > maxrecs) {
+		if (!sflag || id->ilist)
+			dbprintf(_("numrecs for ino %lld rtrefc root too "
+				 "large (%u)\n"),
+				id->ino,
+				be16_to_cpu(dib->bb_numrecs));
+		error++;
+		return;
+	}
+	if (be16_to_cpu(dib->bb_level) == 0) {
+		struct xfs_refcount_rec	*rp;
+		xfs_fsblock_t		lastblock;
+
+		rp = xfs_rtrefcount_droot_rec_addr(dib, 1);
+		lastblock = 0;
+		for (i = 0; i < be16_to_cpu(dib->bb_numrecs); i++) {
+			if (be32_to_cpu(rp[i].rc_startblock) < lastblock) {
+				dbprintf(_(
+		"out-of-order rtrefc btree record %d (%u %u) root\n"),
+					 i, be32_to_cpu(rp[i].rc_startblock),
+					 be32_to_cpu(rp[i].rc_startblock));
+			} else {
+				lastblock = be32_to_cpu(rp[i].rc_startblock) +
+					    be32_to_cpu(rp[i].rc_blockcount);
+			}
+		}
+		return;
+	} else {
+		pp = xfs_rtrefcount_droot_ptr_addr(dib, 1, maxrecs);
+		for (i = 0; i < be16_to_cpu(dib->bb_numrecs); i++)
+			scan_lbtree(get_unaligned_be64(&pp[i]),
+					be16_to_cpu(dib->bb_level),
+					scanfunc_rtrefc, DBM_BTRTREFC,
+					id, &totd, toti,
+					&nex, NULL, 1, TYP_RTREFCBT);
+	}
+}
+
 static xfs_ino_t
 process_sf_dir_v2(
 	struct xfs_dinode	*dip,
@@ -5056,8 +5186,7 @@ scanfunc_rtrmap(
 					 be32_to_cpu(rp[i].rm_blockcount),
 					 agno, bno, lastblock);
 			} else {
-				lastblock = be32_to_cpu(rp[i].rm_startblock) +
-					    be32_to_cpu(rp[i].rm_blockcount);
+				lastblock = be32_to_cpu(rp[i].rm_startblock);
 			}
 		}
 		return;
@@ -5173,6 +5302,115 @@ scanfunc_refcnt(
 				TYP_REFCBT);
 }
 
+static void
+scanfunc_rtrefc(
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
+	xfs_rtrefcount_ptr_t	*pp;
+	struct xfs_refcount_rec *rp;
+	xfs_rtblock_t		lastblock;
+
+	agno = XFS_FSB_TO_AGNO(mp, bno);
+	agbno = XFS_FSB_TO_AGBNO(mp, bno);
+	if (be32_to_cpu(block->bb_magic) != XFS_RTREFC_CRC_MAGIC) {
+		dbprintf(_("bad magic # %#x in rtrefcbt block %u/%u\n"),
+			be32_to_cpu(block->bb_magic), agno, agbno);
+		serious_error++;
+		return;
+	}
+	if (be16_to_cpu(block->bb_level) != level) {
+		if (!sflag)
+			dbprintf(_("expected level %d got %d in rtrefcntbt block "
+				 "%u/%u\n"),
+				level, be16_to_cpu(block->bb_level), agno, agbno);
+		error++;
+	}
+	set_dbmap(agno, agbno, 1, type, agno, agbno);
+	set_inomap(agno, agbno, 1, id);
+	(*toti)++;
+	if (level == 0) {
+		if (be16_to_cpu(block->bb_numrecs) > mp->m_rtrefc_mxr[0] ||
+		    (isroot == 0 && be16_to_cpu(block->bb_numrecs) < mp->m_rtrefc_mnr[0])) {
+			dbprintf(_("bad btree nrecs (%u, min=%u, max=%u) in "
+				 "rtrefcntbt block %u/%u\n"),
+				be16_to_cpu(block->bb_numrecs), mp->m_rtrefc_mnr[0],
+				mp->m_rtrefc_mxr[0], agno, agbno);
+			serious_error++;
+			return;
+		}
+		rp = xfs_rtrefcount_rec_addr(block, 1);
+		lastblock = 0;
+		for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++) {
+			xfs_rtblock_t	rtbno;
+
+			if (be32_to_cpu(rp[i].rc_refcount) == 1) {
+				xfs_fsblock_t	bno;
+				char		*msg;
+
+				bno = be32_to_cpu(rp[i].rc_startblock);
+				if (bno & XFS_REFC_COWFLAG) {
+					bno &= ~XFS_REFC_COWFLAG;
+					msg = _(
+		"leftover rt CoW extent (%lu) len %u\n");
+				} else {
+					msg = _(
+		"leftover rt CoW extent at unexpected address (%lu) len %lu\n");
+				}
+				dbprintf(msg,
+					agbno,
+					be32_to_cpu(rp[i].rc_blockcount));
+				rtbno = xfs_rgbno_to_rtb(mp, id->rgno, bno);
+				set_rdbmap(rtbno,
+					be32_to_cpu(rp[i].rc_blockcount),
+					DBM_COWDATA);
+			} else {
+				rtbno = xfs_rgbno_to_rtb(mp, id->rgno,
+						be32_to_cpu(rp[i].rc_startblock));
+				set_rdbmap(rtbno,
+					   be32_to_cpu(rp[i].rc_blockcount),
+					   DBM_RLRTDATA);
+			}
+			if (be32_to_cpu(rp[i].rc_startblock) < lastblock) {
+				dbprintf(_(
+		"out-of-order rt refcnt btree record %d (%llu %llu) block %llu\n"),
+					 i, be32_to_cpu(rp[i].rc_startblock),
+					 be32_to_cpu(rp[i].rc_startblock),
+					 bno);
+			} else {
+				lastblock = be32_to_cpu(rp[i].rc_startblock) +
+					    be32_to_cpu(rp[i].rc_blockcount);
+			}
+		}
+		return;
+	}
+	if (be16_to_cpu(block->bb_numrecs) > mp->m_rtrefc_mxr[1] ||
+	    (isroot == 0 && be16_to_cpu(block->bb_numrecs) < mp->m_rtrefc_mnr[1])) {
+		dbprintf(_("bad btree nrecs (%u, min=%u, max=%u) in rtrefcntbt "
+			 "block %u/%u\n"),
+			be16_to_cpu(block->bb_numrecs), mp->m_rtrefc_mnr[1],
+			mp->m_rtrefc_mxr[1], agno, agbno);
+		serious_error++;
+		return;
+	}
+	pp = xfs_rtrefcount_ptr_addr(block, 1, mp->m_rtrefc_mxr[1]);
+	for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++)
+		scan_lbtree(be64_to_cpu(pp[i]), level, scanfunc_rtrefc,
+				type, id, totd, toti, nex, blkmapp, 0, btype);
+}
+
 static void
 set_dbmap(
 	xfs_agnumber_t	agno,
diff --git a/db/inode.c b/db/inode.c
index af56e615e08..ffcf25d0c70 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -642,6 +642,7 @@ inode_init(void)
 
 struct rtgroup_inodes {
 	xfs_ino_t		rmap_ino;
+	xfs_ino_t		refcount_ino;
 };
 
 static struct rtgroup_inodes	*rtgroup_inodes;
@@ -700,6 +701,7 @@ set_rtgroup_refcount_inode(
 	if (rtino == NULLFSINO)
 		return EFSCORRUPTED;
 
+	rtgroup_inodes[rgno].refcount_ino = rtino;
 	return bitmap_set(refcount_inodes, rtino, 1);
 }
 
@@ -760,6 +762,18 @@ bool is_rtrefcount_inode(xfs_ino_t ino)
 	return bitmap_test(refcount_inodes, ino, 1);
 }
 
+xfs_rgnumber_t rtgroup_for_rtrefcount_ino(struct xfs_mount *mp, xfs_ino_t ino)
+{
+	unsigned int i;
+
+	for (i = 0; i < mp->m_sb.sb_rgcount; i++) {
+		if (rtgroup_inodes[i].refcount_ino == ino)
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
index 666bb5201ea..c789017e0c8 100644
--- a/db/inode.h
+++ b/db/inode.h
@@ -28,3 +28,4 @@ int init_rtmeta_inode_bitmaps(struct xfs_mount *mp);
 bool is_rtrmap_inode(xfs_ino_t ino);
 xfs_rgnumber_t rtgroup_for_rtrmap_ino(struct xfs_mount *mp, xfs_ino_t ino);
 bool is_rtrefcount_inode(xfs_ino_t ino);
+xfs_rgnumber_t rtgroup_for_rtrefcount_ino(struct xfs_mount *mp, xfs_ino_t ino);

