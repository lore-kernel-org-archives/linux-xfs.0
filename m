Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC1B1368
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hPW7c10H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07EACC433C8;
	Mon,  1 Jan 2024 00:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069192;
	bh=IIGEMamOtlrJFyurpIabfwEZj2F4T4OvUjIxjNjkEE4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hPW7c10H44YnOkiIHTPkhtBRk1eNOncJx6T7w7FaaKNKz27mMOpZZ1o206Uxd4P0u
	 Wuj8VnyrHdMsJ35K38NeE5HiTTYODArroSC0fJddklRR0AbZ1+k7ZJR7UL51uTghFZ
	 z13Fgl3jJ5mKNoZDGimsyJRuZvEynjagObTHkAaDuaMzWGXtkYO9J/Q+STwA66Pwwi
	 i5r5buwzwhjvP0MLAfGbkMZC9SbKrPOCz2HS+a2wYp6Ge9hrZM1UKgDir1WxD5pNeL
	 r/qI76TsDccVm6Die7RSkDU8ix0MT9ahrUzLr/R/6XYwz9+wDba400Q9tTsrsqmfmU
	 40UcZ7QgswheA==
Date: Sun, 31 Dec 2023 16:33:11 +9900
Subject: [PATCH 27/42] xfs_db: support rudimentary checks of the rtrefcount
 btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017486.1817107.1529968241981576754.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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

Perform some fairly superficial checks of the rtrefcount btree.  We'll
do more sophisticated checks in xfs_repair, but provide enough of
a spot-check here that we can do simple things.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c |  254 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 db/inode.c |   18 ++++
 db/inode.h |    1 
 3 files changed, 265 insertions(+), 8 deletions(-)


diff --git a/db/check.c b/db/check.c
index 4ef24c20d79..b6ad28799af 100644
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
@@ -2873,7 +2913,7 @@ process_inode(
 		0				/* type 15 unused */
 	};
 	static char		*fmtnames[] = {
-		"dev", "local", "extents", "btree", "uuid", "rmap"
+		"dev", "local", "extents", "btree", "uuid", "rmap", "refcount"
 	};
 
 	ino = XFS_AGINO_TO_INO(mp, be32_to_cpu(agf->agf_seqno), agino);
@@ -2952,6 +2992,16 @@ process_inode(
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
@@ -3028,6 +3078,9 @@ process_inode(
 		} else if (is_rtrmap_inode(id->ino)) {
 			type = DBM_BTRTRMAP;
 			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
+		} else if (is_rtrefcount_inode(id->ino)) {
+			type = DBM_BTRTREFC;
+			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
 		}
 		else
 			type = DBM_DATA;
@@ -3063,6 +3116,10 @@ process_inode(
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
@@ -3089,6 +3146,7 @@ process_inode(
 		case DBM_RTSUM:
 		case DBM_SYMLINK:
 		case DBM_BTRTRMAP:
+		case DBM_BTRTREFC:
 		case DBM_UNKNOWN:
 			bc = totdblocks + totiblocks +
 			     atotdblocks + atotiblocks;
@@ -3916,8 +3974,7 @@ process_rtrmap(
 					 i, be32_to_cpu(rp[i].rm_startblock),
 					 be32_to_cpu(rp[i].rm_startblock));
 			} else {
-				lastblock = be32_to_cpu(rp[i].rm_startblock) +
-					    be32_to_cpu(rp[i].rm_blockcount);
+				lastblock = be32_to_cpu(rp[i].rm_startblock);
 			}
 		}
 		return;
@@ -3932,6 +3989,79 @@ process_rtrmap(
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
@@ -5089,8 +5219,7 @@ scanfunc_rtrmap(
 					 be32_to_cpu(rp[i].rm_blockcount),
 					 agno, bno, lastblock);
 			} else {
-				lastblock = be32_to_cpu(rp[i].rm_startblock) +
-					    be32_to_cpu(rp[i].rm_blockcount);
+				lastblock = be32_to_cpu(rp[i].rm_startblock);
 			}
 		}
 		return;
@@ -5206,6 +5335,115 @@ scanfunc_refcnt(
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
index 760d47c0f04..4feff172cbb 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -642,6 +642,7 @@ inode_init(void)
 
 struct rtgroup_inodes {
 	xfs_ino_t		rmap_ino;
+	xfs_ino_t		refcount_ino;
 };
 
 static struct rtgroup_inodes	*rtgroup_inodes;
@@ -722,6 +723,11 @@ set_rtgroup_refcount_inode(
 	}
 
 	error = bitmap_set(refcount_inodes, rtino, 1);
+	if (error)
+		goto out_trans;
+
+	rtgroup_inodes[rgno].refcount_ino = rtino;
+
 out_trans:
 	libxfs_trans_cancel(tp);
 out_path:
@@ -786,6 +792,18 @@ bool is_rtrefcount_inode(xfs_ino_t ino)
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

