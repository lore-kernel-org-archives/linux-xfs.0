Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 832FB29DFF
	for <xfs@oss.sgi.com>; Tue, 26 May 2015 17:52:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E7AC3AC001
	for <xfs@oss.sgi.com>; Tue, 26 May 2015 15:52:00 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id GNW18Gm4icIUo5rA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 May 2015 15:51:58 -0700 (PDT)
Subject: [PATCH 4/5] xfs_db: enable blockget for v5 filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 26 May 2015 15:51:53 -0700
Message-ID: <20150526225153.26434.96347.stgit@birch.djwong.org>
In-Reply-To: <20150526225126.26434.69010.stgit@birch.djwong.org>
References: <20150526225126.26434.69010.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Plumb in the necessary magic number checks and other fixups required
to handle v5 filesystems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/check.c |  225 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 db/type.c  |    3 +
 db/type.h  |    2 -
 3 files changed, 214 insertions(+), 16 deletions(-)


diff --git a/db/check.c b/db/check.c
index c4c972f..8f8096d 100644
--- a/db/check.c
+++ b/db/check.c
@@ -44,7 +44,7 @@ typedef enum {
 	DBM_FREE1,	DBM_FREE2,	DBM_FREELIST,	DBM_INODE,
 	DBM_LOG,	DBM_MISSING,	DBM_QUOTA,	DBM_RTBITMAP,
 	DBM_RTDATA,	DBM_RTFREE,	DBM_RTSUM,	DBM_SB,
-	DBM_SYMLINK,
+	DBM_SYMLINK,	DBM_BTFINO,
 	DBM_NDBM
 } dbm_t;
 
@@ -170,6 +170,7 @@ static const char	*typename[] = {
 	"rtsum",
 	"sb",
 	"symlink",
+	"btfino",
 	NULL
 };
 static int		verbose;
@@ -345,6 +346,9 @@ static void		scanfunc_cnt(struct xfs_btree_block *block, int level,
 static void		scanfunc_ino(struct xfs_btree_block *block, int level,
 				     xfs_agf_t *agf, xfs_agblock_t bno,
 				     int isroot);
+static void		scanfunc_fino(struct xfs_btree_block *block, int level,
+				     xfs_agf_t *agf, xfs_agblock_t bno,
+				     int isroot);
 static void		set_dbmap(xfs_agnumber_t agno, xfs_agblock_t agbno,
 				  xfs_extlen_t len, dbm_t type,
 				  xfs_agnumber_t c_agno, xfs_agblock_t c_agbno);
@@ -799,8 +803,6 @@ blockget_f(
 	 * filters out, or we need to actually do the work to make check support
 	 * crc enabled filesystems.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb))
-		return 0;
 
 	if (!init(argc, argv)) {
 		if (serious_error)
@@ -2223,7 +2225,9 @@ process_data_dir_v2(
 	data = iocur_top->data;
 	block = iocur_top->data;
 	if (be32_to_cpu(block->magic) != XFS_DIR2_BLOCK_MAGIC &&
-			be32_to_cpu(data->magic) != XFS_DIR2_DATA_MAGIC) {
+			be32_to_cpu(data->magic) != XFS_DIR2_DATA_MAGIC &&
+			be32_to_cpu(block->magic) != XFS_DIR3_BLOCK_MAGIC &&
+			be32_to_cpu(data->magic) != XFS_DIR3_DATA_MAGIC) {
 		if (!sflag || v)
 			dbprintf(_("bad directory data magic # %#x for dir ino "
 				 "%lld block %d\n"),
@@ -2234,7 +2238,8 @@ process_data_dir_v2(
 	db = xfs_dir2_da_to_db(mp, dabno);
 	bf = xfs_dir3_data_bestfree_p(data);
 	ptr = (char *)xfs_dir3_data_unused_p(data);
-	if (be32_to_cpu(block->magic) == XFS_DIR2_BLOCK_MAGIC) {
+	if (be32_to_cpu(block->magic) == XFS_DIR2_BLOCK_MAGIC ||
+	    be32_to_cpu(block->magic) == XFS_DIR3_BLOCK_MAGIC) {
 		btp = xfs_dir2_block_tail_p(mp, block);
 		lep = xfs_dir2_block_leaf_p(btp);
 		endptr = (char *)lep;
@@ -2380,7 +2385,8 @@ process_data_dir_v2(
 			(*dot)++;
 		}
 	}
-	if (be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC) {
+	if (be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC ||
+	    be32_to_cpu(data->magic) == XFS_DIR3_BLOCK_MAGIC) {
 		endptr = (char *)data + mp->m_dirblksize;
 		for (i = stale = 0; lep && i < be32_to_cpu(btp->count); i++) {
 			if ((char *)&lep[i] >= endptr) {
@@ -2412,7 +2418,8 @@ process_data_dir_v2(
 				id->ino, dabno);
 		error++;
 	}
-	if (be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC &&
+	if ((be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC ||
+	     be32_to_cpu(data->magic) == XFS_DIR3_BLOCK_MAGIC) &&
 	    count != be32_to_cpu(btp->count) - be32_to_cpu(btp->stale)) {
 		if (!sflag || v)
 			dbprintf(_("dir %lld block %d bad block tail count %d "
@@ -2421,7 +2428,8 @@ process_data_dir_v2(
 				be32_to_cpu(btp->stale));
 		error++;
 	}
-	if (be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC && 
+	if ((be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC ||
+	     be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC) &&
 					stale != be32_to_cpu(btp->stale)) {
 		if (!sflag || v)
 			dbprintf(_("dir %lld block %d bad stale tail count %d\n"),
@@ -3007,6 +3015,73 @@ process_leaf_node_dir_v2(
 }
 
 static void
+process_leaf_node_dir_v3_free(
+	inodata_t		*id,
+	int			v,
+	xfs_dablk_t		dabno,
+	freetab_t		*freetab)
+{
+	xfs_dir2_data_off_t	ent;
+	struct xfs_dir3_free	*free;
+	int			i;
+	int			maxent;
+	int			used;
+
+	free = iocur_top->data;
+	maxent = xfs_dir3_free_max_bests(mp);
+	if (be32_to_cpu(free->hdr.firstdb) != xfs_dir2_da_to_db(mp,
+					dabno - mp->m_dirfreeblk) * maxent) {
+		if (!sflag || v)
+			dbprintf(_("bad free block firstdb %d for dir ino %lld "
+				 "block %d\n"),
+				be32_to_cpu(free->hdr.firstdb), id->ino, dabno);
+		error++;
+		return;
+	}
+	if (be32_to_cpu(free->hdr.nvalid) > maxent ||
+				be32_to_cpu(free->hdr.nvalid) < 0 ||
+				be32_to_cpu(free->hdr.nused) > maxent ||
+				be32_to_cpu(free->hdr.nused) < 0 ||
+				be32_to_cpu(free->hdr.nused) >
+					be32_to_cpu(free->hdr.nvalid)) {
+		if (!sflag || v)
+			dbprintf(_("bad free block nvalid/nused %d/%d for dir "
+				 "ino %lld block %d\n"),
+				be32_to_cpu(free->hdr.nvalid),
+				be32_to_cpu(free->hdr.nused), id->ino, dabno);
+		error++;
+		return;
+	}
+	for (used = i = 0; i < be32_to_cpu(free->hdr.nvalid); i++) {
+		if (freetab->nents <= be32_to_cpu(free->hdr.firstdb) + i)
+			ent = NULLDATAOFF;
+		else
+			ent = freetab->ents[be32_to_cpu(free->hdr.firstdb) + i];
+		if (ent != be16_to_cpu(free->bests[i])) {
+			if (!sflag || v)
+				dbprintf(_("bad free block ent %d is %d should "
+					 "be %d for dir ino %lld block %d\n"),
+					i, be16_to_cpu(free->bests[i]), ent,
+					id->ino, dabno);
+			error++;
+		}
+		if (be16_to_cpu(free->bests[i]) != NULLDATAOFF)
+			used++;
+		if (ent != NULLDATAOFF)
+			freetab->ents[be32_to_cpu(free->hdr.firstdb) + i] =
+								NULLDATAOFF;
+	}
+	if (used != be32_to_cpu(free->hdr.nused)) {
+		if (!sflag || v)
+			dbprintf(_("bad free block nused %d should be %d for dir "
+				 "ino %lld block %d\n"),
+				be32_to_cpu(free->hdr.nused), used, id->ino,
+				dabno);
+		error++;
+	}
+}
+
+static void
 process_leaf_node_dir_v2_free(
 	inodata_t		*id,
 	int			v,
@@ -3020,7 +3095,8 @@ process_leaf_node_dir_v2_free(
 	int			used;
 
 	free = iocur_top->data;
-	if (be32_to_cpu(free->hdr.magic) != XFS_DIR2_FREE_MAGIC) {
+	if (be32_to_cpu(free->hdr.magic) != XFS_DIR2_FREE_MAGIC &&
+	    be32_to_cpu(free->hdr.magic) != XFS_DIR3_FREE_MAGIC) {
 		if (!sflag || v)
 			dbprintf(_("bad free block magic # %#x for dir ino %lld "
 				 "block %d\n"),
@@ -3028,6 +3104,10 @@ process_leaf_node_dir_v2_free(
 		error++;
 		return;
 	}
+	if (be32_to_cpu(free->hdr.magic) == XFS_DIR3_FREE_MAGIC) {
+		process_leaf_node_dir_v3_free(id, v, dabno, freetab);
+		return;
+	}
 	maxent = xfs_dir3_free_max_bests(mp);
 	if (be32_to_cpu(free->hdr.firstdb) != xfs_dir2_da_to_db(mp, 
 					dabno - mp->m_dirfreeblk) * maxent) {
@@ -3081,6 +3161,20 @@ process_leaf_node_dir_v2_free(
 	}
 }
 
+/*
+ * Get address of the bestcount field in the single-leaf block.
+ */
+static inline int
+xfs_dir3_leaf_ents_count(struct xfs_dir2_leaf *lp)
+{
+	if (lp->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) ||
+	    lp->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC)) {
+		struct xfs_dir3_leaf *lp3 = (struct xfs_dir3_leaf *)lp;
+		return be16_to_cpu(lp3->hdr.count);
+	}
+	return be16_to_cpu(lp->hdr.count);
+}
+
 static void
 process_leaf_node_dir_v2_int(
 	inodata_t		*id,
@@ -3091,6 +3185,7 @@ process_leaf_node_dir_v2_int(
 	int			i;
 	__be16			*lbp;
 	xfs_dir2_leaf_t		*leaf;
+	struct xfs_dir3_leaf	*leaf3 = NULL;
 	xfs_dir2_leaf_entry_t	*lep;
 	xfs_dir2_leaf_tail_t	*ltp;
 	xfs_da_intnode_t	*node;
@@ -3099,7 +3194,15 @@ process_leaf_node_dir_v2_int(
 
 	leaf = iocur_top->data;
 	switch (be16_to_cpu(leaf->hdr.info.magic)) {
+	case XFS_DIR3_LEAF1_MAGIC:
+	case XFS_DIR3_LEAFN_MAGIC:
+	case XFS_DA3_NODE_MAGIC:
+		leaf3 = iocur_top->data;
+		break;
+	}
+	switch (be16_to_cpu(leaf->hdr.info.magic)) {
 	case XFS_DIR2_LEAF1_MAGIC:
+	case XFS_DIR3_LEAF1_MAGIC:
 		if (be32_to_cpu(leaf->hdr.info.forw) || 
 					be32_to_cpu(leaf->hdr.info.back)) {
 			if (!sflag || v)
@@ -3139,10 +3242,12 @@ process_leaf_node_dir_v2_int(
 		}
 		break;
 	case XFS_DIR2_LEAFN_MAGIC:
+	case XFS_DIR3_LEAFN_MAGIC:
 		/* if it's at the root location then we can check the
 		 * pointers are null XXX */
 		break;
 	case XFS_DA_NODE_MAGIC:
+	case XFS_DA3_NODE_MAGIC:
 		node = iocur_top->data;
 		xfs_da3_node_hdr_from_disk(&nodehdr, node);
 		if (nodehdr.level < 1 || nodehdr.level > XFS_DA_NODE_MAXDEPTH) {
@@ -3164,7 +3269,7 @@ process_leaf_node_dir_v2_int(
 		return;
 	}
 	lep = xfs_dir3_leaf_ents_p(leaf);
-	for (i = stale = 0; i < be16_to_cpu(leaf->hdr.count); i++) {
+	for (i = stale = 0; i < xfs_dir3_leaf_ents_count(leaf); i++) {
 		if (be32_to_cpu(lep[i].address) == XFS_DIR2_NULL_DATAPTR)
 			stale++;
 		else if (dir_hash_see(be32_to_cpu(lep[i].hashval), 
@@ -3177,7 +3282,14 @@ process_leaf_node_dir_v2_int(
 			error++;
 		}
 	}
-	if (stale != be16_to_cpu(leaf->hdr.stale)) {
+	if (leaf3 && stale != be16_to_cpu(leaf3->hdr.stale)) {
+		if (!sflag || v)
+			dbprintf(_("dir3 %lld block %d stale mismatch "
+				 "%d/%d\n"),
+				 id->ino, dabno, stale,
+				 be16_to_cpu(leaf3->hdr.stale));
+		error++;
+	} else if (!leaf && stale != be16_to_cpu(leaf->hdr.stale)) {
 		if (!sflag || v)
 			dbprintf(_("dir %lld block %d stale mismatch "
 				 "%d/%d\n"),
@@ -3764,6 +3876,12 @@ scan_ag(
 		be32_to_cpu(agi->agi_root),
 		be32_to_cpu(agi->agi_level),
 		1, scanfunc_ino, TYP_INOBT);
+	if (agi->agi_free_root) {
+		scan_sbtree(agf,
+			be32_to_cpu(agi->agi_free_root),
+			be32_to_cpu(agi->agi_free_level),
+			1, scanfunc_fino, TYP_FINOBT);
+	}
 	if (be32_to_cpu(agf->agf_freeblks) != agffreeblks) {
 		if (!sflag)
 			dbprintf(_("agf_freeblks %u, counted %u in ag %u\n"),
@@ -3963,7 +4081,8 @@ scanfunc_bmap(
 
 	agno = XFS_FSB_TO_AGNO(mp, bno);
 	agbno = XFS_FSB_TO_AGBNO(mp, bno);
-	if (be32_to_cpu(block->bb_magic) != XFS_BMAP_MAGIC) {
+	if (be32_to_cpu(block->bb_magic) != XFS_BMAP_MAGIC &&
+	    be32_to_cpu(block->bb_magic) != XFS_BMAP_CRC_MAGIC) {
 		if (!sflag || id->ilist || CHECK_BLIST(bno))
 			dbprintf(_("bad magic # %#x in inode %lld bmbt block "
 				 "%u/%u\n"),
@@ -4028,7 +4147,8 @@ scanfunc_bno(
 	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
 	xfs_agblock_t		lastblock;
 
-	if (be32_to_cpu(block->bb_magic) != XFS_ABTB_MAGIC) {
+	if (be32_to_cpu(block->bb_magic) != XFS_ABTB_MAGIC &&
+	    be32_to_cpu(block->bb_magic) != XFS_ABTB_CRC_MAGIC) {
 		dbprintf(_("bad magic # %#x in btbno block %u/%u\n"),
 			be32_to_cpu(block->bb_magic), seqno, bno);
 		serious_error++;
@@ -4101,7 +4221,8 @@ scanfunc_cnt(
 	xfs_alloc_rec_t		*rp;
 	xfs_extlen_t		lastcount;
 
-	if (be32_to_cpu(block->bb_magic) != XFS_ABTC_MAGIC) {
+	if (be32_to_cpu(block->bb_magic) != XFS_ABTC_MAGIC &&
+	    be32_to_cpu(block->bb_magic) != XFS_ABTC_CRC_MAGIC) {
 		dbprintf(_("bad magic # %#x in btcnt block %u/%u\n"),
 			be32_to_cpu(block->bb_magic), seqno, bno);
 		serious_error++;
@@ -4181,7 +4302,8 @@ scanfunc_ino(
 	xfs_inobt_ptr_t		*pp;
 	xfs_inobt_rec_t		*rp;
 
-	if (be32_to_cpu(block->bb_magic) != XFS_IBT_MAGIC) {
+	if (be32_to_cpu(block->bb_magic) != XFS_IBT_MAGIC &&
+	    be32_to_cpu(block->bb_magic) != XFS_IBT_CRC_MAGIC) {
 		dbprintf(_("bad magic # %#x in inobt block %u/%u\n"),
 			be32_to_cpu(block->bb_magic), seqno, bno);
 		serious_error++;
@@ -4277,6 +4399,79 @@ scanfunc_ino(
 }
 
 static void
+scanfunc_fino(
+	struct xfs_btree_block	*block,
+	int			level,
+	xfs_agf_t		*agf,
+	xfs_agblock_t		bno,
+	int			isroot)
+{
+	xfs_agino_t		agino;
+	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
+	int			i;
+	int			off;
+	xfs_inobt_ptr_t		*pp;
+	xfs_inobt_rec_t		*rp;
+
+	if (be32_to_cpu(block->bb_magic) != XFS_FIBT_MAGIC &&
+	    be32_to_cpu(block->bb_magic) != XFS_FIBT_CRC_MAGIC) {
+		dbprintf(_("bad magic # %#x in finobt block %u/%u\n"),
+			be32_to_cpu(block->bb_magic), seqno, bno);
+		serious_error++;
+		return;
+	}
+	if (be16_to_cpu(block->bb_level) != level) {
+		if (!sflag)
+			dbprintf(_("expected level %d got %d in finobt block "
+				 "%u/%u\n"),
+				level, be16_to_cpu(block->bb_level), seqno, bno);
+		error++;
+	}
+	set_dbmap(seqno, bno, 1, DBM_BTFINO, seqno, bno);
+	if (level == 0) {
+		if (be16_to_cpu(block->bb_numrecs) > mp->m_inobt_mxr[0] ||
+		    (isroot == 0 && be16_to_cpu(block->bb_numrecs) < mp->m_inobt_mnr[0])) {
+			dbprintf(_("bad btree nrecs (%u, min=%u, max=%u) in "
+				 "finobt block %u/%u\n"),
+				be16_to_cpu(block->bb_numrecs), mp->m_inobt_mnr[0],
+				mp->m_inobt_mxr[0], seqno, bno);
+			serious_error++;
+			return;
+		}
+		rp = XFS_INOBT_REC_ADDR(mp, block, 1);
+		for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++) {
+			agino = be32_to_cpu(rp[i].ir_startino);
+			off = XFS_INO_TO_OFFSET(mp, agino);
+			if (off == 0) {
+				if ((sbversion & XFS_SB_VERSION_ALIGNBIT) &&
+				    mp->m_sb.sb_inoalignmt &&
+				    (XFS_INO_TO_AGBNO(mp, agino) %
+				     mp->m_sb.sb_inoalignmt))
+					sbversion &= ~XFS_SB_VERSION_ALIGNBIT;
+				check_set_dbmap(seqno, XFS_AGINO_TO_AGBNO(mp, agino),
+					(xfs_extlen_t)MAX(1,
+						XFS_INODES_PER_CHUNK >>
+						mp->m_sb.sb_inopblog),
+					DBM_INODE, DBM_INODE, seqno, bno);
+			}
+		}
+		return;
+	}
+	if (be16_to_cpu(block->bb_numrecs) > mp->m_inobt_mxr[1] ||
+	    (isroot == 0 && be16_to_cpu(block->bb_numrecs) < mp->m_inobt_mnr[1])) {
+		dbprintf(_("bad btree nrecs (%u, min=%u, max=%u) in finobt block "
+			 "%u/%u\n"),
+			be16_to_cpu(block->bb_numrecs), mp->m_inobt_mnr[1],
+			mp->m_inobt_mxr[1], seqno, bno);
+		serious_error++;
+		return;
+	}
+	pp = XFS_INOBT_PTR_ADDR(mp, block, 1, mp->m_inobt_mxr[1]);
+	for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++)
+		scan_sbtree(agf, be32_to_cpu(pp[i]), level, 0, scanfunc_ino, TYP_FINOBT);
+}
+
+static void
 set_dbmap(
 	xfs_agnumber_t	agno,
 	xfs_agblock_t	agbno,
diff --git a/db/type.c b/db/type.c
index b29f2a4..0aa3137 100644
--- a/db/type.c
+++ b/db/type.c
@@ -70,6 +70,7 @@ static const typ_t	__typtab[] = {
 	{ TYP_SB, "sb", handle_struct, sb_hfld, NULL },
 	{ TYP_SYMLINK, "symlink", handle_string, NULL, NULL },
 	{ TYP_TEXT, "text", handle_text, NULL, NULL },
+	{ TYP_FINOBT, "finobt", handle_struct, inobt_hfld, NULL },
 	{ TYP_NONE, NULL }
 };
 
@@ -104,6 +105,8 @@ static const typ_t	__typtab_crc[] = {
 	{ TYP_SYMLINK, "symlink", handle_struct, symlink_crc_hfld,
 		&xfs_symlink_buf_ops },
 	{ TYP_TEXT, "text", handle_text, NULL, NULL },
+	{ TYP_FINOBT, "finobt", handle_struct, inobt_crc_hfld,
+		&xfs_inobt_buf_ops },
 	{ TYP_NONE, NULL }
 };
 
diff --git a/db/type.h b/db/type.h
index 3bb26f1..e8d8df7 100644
--- a/db/type.h
+++ b/db/type.h
@@ -27,7 +27,7 @@ typedef enum typnm
 	TYP_BMAPBTD, TYP_BNOBT, TYP_CNTBT, TYP_DATA,
 	TYP_DIR2, TYP_DQBLK, TYP_INOBT, TYP_INODATA, TYP_INODE,
 	TYP_LOG, TYP_RTBITMAP, TYP_RTSUMMARY, TYP_SB, TYP_SYMLINK,
-	TYP_TEXT, TYP_NONE
+	TYP_TEXT, TYP_FINOBT, TYP_NONE
 } typnm_t;
 
 #define DB_WRITE 1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
