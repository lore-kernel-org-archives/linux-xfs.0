Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 172347F81
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 22:25:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8797CAC006
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 20:25:57 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id qbU4TszNVoEvxVR4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 20:25:55 -0700 (PDT)
Subject: [PATCH 02/15] xfs_db: enable blockget for v5 filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 29 Jun 2015 20:25:51 -0700
Message-ID: <20150630032551.572.83770.stgit@birch.djwong.org>
In-Reply-To: <20150630032538.572.20293.stgit@birch.djwong.org>
References: <20150630032538.572.20293.stgit@birch.djwong.org>
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
 db/check.c |  237 +++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 db/type.c  |    3 +
 db/type.h  |    2 -
 3 files changed, 215 insertions(+), 27 deletions(-)


diff --git a/db/check.c b/db/check.c
index 1822905..288b2ab 100644
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
@@ -789,19 +793,6 @@ blockget_f(
 		return 0;
 	}
 
-	/*
-	 * XXX: check does not support CRC enabled filesystems. Return
-	 * immediately, silently, with success but  without doing anything here
-	 * initially so that xfstests can run without modification on metadata
-	 * enabled filesystems.
-	 *
-	 * XXX: ultimately we need to dump an error message here that xfstests
-	 * filters out, or we need to actually do the work to make check support
-	 * crc enabled filesystems.
-	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb))
-		return 0;
-
 	if (!init(argc, argv)) {
 		if (serious_error)
 			exitcode = 3;
@@ -2216,7 +2207,9 @@ process_data_dir_v2(
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
@@ -2227,7 +2220,8 @@ process_data_dir_v2(
 	db = xfs_dir2_da_to_db(mp->m_dir_geo, dabno);
 	bf = M_DIROPS(mp)->data_bestfree_p(data);
 	ptr = (char *)M_DIROPS(mp)->data_unused_p(data);
-	if (be32_to_cpu(block->magic) == XFS_DIR2_BLOCK_MAGIC) {
+	if (be32_to_cpu(block->magic) == XFS_DIR2_BLOCK_MAGIC ||
+	    be32_to_cpu(block->magic) == XFS_DIR3_BLOCK_MAGIC) {
 		btp = xfs_dir2_block_tail_p(mp->m_dir_geo, block);
 		lep = xfs_dir2_block_leaf_p(btp);
 		endptr = (char *)lep;
@@ -2373,7 +2367,8 @@ process_data_dir_v2(
 			(*dot)++;
 		}
 	}
-	if (be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC) {
+	if (be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC ||
+	    be32_to_cpu(data->magic) == XFS_DIR3_BLOCK_MAGIC) {
 		endptr = (char *)data + mp->m_dir_geo->blksize;
 		for (i = stale = 0; lep && i < be32_to_cpu(btp->count); i++) {
 			if ((char *)&lep[i] >= endptr) {
@@ -2405,7 +2400,8 @@ process_data_dir_v2(
 				id->ino, dabno);
 		error++;
 	}
-	if (be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC &&
+	if ((be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC ||
+	     be32_to_cpu(data->magic) == XFS_DIR3_BLOCK_MAGIC) &&
 	    count != be32_to_cpu(btp->count) - be32_to_cpu(btp->stale)) {
 		if (!sflag || v)
 			dbprintf(_("dir %lld block %d bad block tail count %d "
@@ -2414,7 +2410,8 @@ process_data_dir_v2(
 				be32_to_cpu(btp->stale));
 		error++;
 	}
-	if (be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC && 
+	if ((be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC ||
+	     be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC) &&
 					stale != be32_to_cpu(btp->stale)) {
 		if (!sflag || v)
 			dbprintf(_("dir %lld block %d bad stale tail count %d\n"),
@@ -3000,6 +2997,73 @@ process_leaf_node_dir_v2(
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
+	maxent = M_DIROPS(mp)->free_max_bests(mp->m_dir_geo);
+	if (be32_to_cpu(free->hdr.firstdb) != xfs_dir2_da_to_db(mp->m_dir_geo, 
+					dabno - mp->m_dir_geo->freeblk) * maxent) {
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
@@ -3013,7 +3077,8 @@ process_leaf_node_dir_v2_free(
 	int			used;
 
 	free = iocur_top->data;
-	if (be32_to_cpu(free->hdr.magic) != XFS_DIR2_FREE_MAGIC) {
+	if (be32_to_cpu(free->hdr.magic) != XFS_DIR2_FREE_MAGIC &&
+	    be32_to_cpu(free->hdr.magic) != XFS_DIR3_FREE_MAGIC) {
 		if (!sflag || v)
 			dbprintf(_("bad free block magic # %#x for dir ino %lld "
 				 "block %d\n"),
@@ -3021,6 +3086,10 @@ process_leaf_node_dir_v2_free(
 		error++;
 		return;
 	}
+	if (be32_to_cpu(free->hdr.magic) == XFS_DIR3_FREE_MAGIC) {
+		process_leaf_node_dir_v3_free(id, v, dabno, freetab);
+		return;
+	}
 	maxent = M_DIROPS(mp)->free_max_bests(mp->m_dir_geo);
 	if (be32_to_cpu(free->hdr.firstdb) != xfs_dir2_da_to_db(mp->m_dir_geo, 
 					dabno - mp->m_dir_geo->freeblk) * maxent) {
@@ -3074,6 +3143,21 @@ process_leaf_node_dir_v2_free(
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
+
+		return be16_to_cpu(lp3->hdr.count);
+	}
+	return be16_to_cpu(lp->hdr.count);
+}
+
 static void
 process_leaf_node_dir_v2_int(
 	inodata_t		*id,
@@ -3084,6 +3168,7 @@ process_leaf_node_dir_v2_int(
 	int			i;
 	__be16			*lbp;
 	xfs_dir2_leaf_t		*leaf;
+	struct xfs_dir3_leaf	*leaf3 = NULL;
 	xfs_dir2_leaf_entry_t	*lep;
 	xfs_dir2_leaf_tail_t	*ltp;
 	xfs_da_intnode_t	*node;
@@ -3092,7 +3177,15 @@ process_leaf_node_dir_v2_int(
 
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
@@ -3132,10 +3225,12 @@ process_leaf_node_dir_v2_int(
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
 		M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, node);
 		if (nodehdr.level < 1 || nodehdr.level > XFS_DA_NODE_MAXDEPTH) {
@@ -3157,7 +3252,7 @@ process_leaf_node_dir_v2_int(
 		return;
 	}
 	lep = M_DIROPS(mp)->leaf_ents_p(leaf);
-	for (i = stale = 0; i < be16_to_cpu(leaf->hdr.count); i++) {
+	for (i = stale = 0; i < xfs_dir3_leaf_ents_count(leaf); i++) {
 		if (be32_to_cpu(lep[i].address) == XFS_DIR2_NULL_DATAPTR)
 			stale++;
 		else if (dir_hash_see(be32_to_cpu(lep[i].hashval), 
@@ -3170,7 +3265,14 @@ process_leaf_node_dir_v2_int(
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
@@ -3757,6 +3859,12 @@ scan_ag(
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
@@ -3956,7 +4064,8 @@ scanfunc_bmap(
 
 	agno = XFS_FSB_TO_AGNO(mp, bno);
 	agbno = XFS_FSB_TO_AGBNO(mp, bno);
-	if (be32_to_cpu(block->bb_magic) != XFS_BMAP_MAGIC) {
+	if (be32_to_cpu(block->bb_magic) != XFS_BMAP_MAGIC &&
+	    be32_to_cpu(block->bb_magic) != XFS_BMAP_CRC_MAGIC) {
 		if (!sflag || id->ilist || CHECK_BLIST(bno))
 			dbprintf(_("bad magic # %#x in inode %lld bmbt block "
 				 "%u/%u\n"),
@@ -4021,7 +4130,8 @@ scanfunc_bno(
 	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
 	xfs_agblock_t		lastblock;
 
-	if (be32_to_cpu(block->bb_magic) != XFS_ABTB_MAGIC) {
+	if (be32_to_cpu(block->bb_magic) != XFS_ABTB_MAGIC &&
+	    be32_to_cpu(block->bb_magic) != XFS_ABTB_CRC_MAGIC) {
 		dbprintf(_("bad magic # %#x in btbno block %u/%u\n"),
 			be32_to_cpu(block->bb_magic), seqno, bno);
 		serious_error++;
@@ -4094,7 +4204,8 @@ scanfunc_cnt(
 	xfs_alloc_rec_t		*rp;
 	xfs_extlen_t		lastcount;
 
-	if (be32_to_cpu(block->bb_magic) != XFS_ABTC_MAGIC) {
+	if (be32_to_cpu(block->bb_magic) != XFS_ABTC_MAGIC &&
+	    be32_to_cpu(block->bb_magic) != XFS_ABTC_CRC_MAGIC) {
 		dbprintf(_("bad magic # %#x in btcnt block %u/%u\n"),
 			be32_to_cpu(block->bb_magic), seqno, bno);
 		serious_error++;
@@ -4174,7 +4285,8 @@ scanfunc_ino(
 	xfs_inobt_ptr_t		*pp;
 	xfs_inobt_rec_t		*rp;
 
-	if (be32_to_cpu(block->bb_magic) != XFS_IBT_MAGIC) {
+	if (be32_to_cpu(block->bb_magic) != XFS_IBT_MAGIC &&
+	    be32_to_cpu(block->bb_magic) != XFS_IBT_CRC_MAGIC) {
 		dbprintf(_("bad magic # %#x in inobt block %u/%u\n"),
 			be32_to_cpu(block->bb_magic), seqno, bno);
 		serious_error++;
@@ -4270,6 +4382,79 @@ scanfunc_ino(
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
index 9db1ba3..99a83e2 100644
--- a/db/type.c
+++ b/db/type.c
@@ -71,6 +71,7 @@ static const typ_t	__typtab[] = {
 	{ TYP_SB, "sb", handle_struct, sb_hfld, NULL },
 	{ TYP_SYMLINK, "symlink", handle_string, NULL, NULL },
 	{ TYP_TEXT, "text", handle_text, NULL, NULL },
+	{ TYP_FINOBT, "finobt", handle_struct, inobt_hfld, NULL },
 	{ TYP_NONE, NULL }
 };
 
@@ -107,6 +108,8 @@ static const typ_t	__typtab_crc[] = {
 	{ TYP_SYMLINK, "symlink", handle_struct, symlink_crc_hfld,
 		&xfs_symlink_buf_ops },
 	{ TYP_TEXT, "text", handle_text, NULL, NULL },
+	{ TYP_FINOBT, "finobt", handle_struct, inobt_crc_hfld,
+		&xfs_inobt_buf_ops },
 	{ TYP_NONE, NULL }
 };
 
diff --git a/db/type.h b/db/type.h
index 9e3635e..1bef8e6 100644
--- a/db/type.h
+++ b/db/type.h
@@ -27,7 +27,7 @@ typedef enum typnm
 	TYP_BMAPBTD, TYP_BNOBT, TYP_CNTBT, TYP_RMAPBT, TYP_DATA,
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
