Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 014EE7F37
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 18:24:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C4B6E304043
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 16:24:01 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id KqWFXYFGBacj1qlv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Mar 2015 16:24:00 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id t2INNxlO001653
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 23:23:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	t2INNwfI020770
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 23:23:59 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
	by userv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t2INNwJB023446
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2015 23:23:58 GMT
Date: Wed, 18 Mar 2015 16:23:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC 1/2] xfs_db: enable blockget for v5 filesystems
Message-ID: <20150318232356.GC24608@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Plumb in the necessary magic number checks and other fixups required
to handle v5 filesystems.  This requires Eric Sandeen's earlier patch
rollup.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/check.c |   52 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 13 deletions(-)

diff --git a/db/check.c b/db/check.c
index 4fd9fd0..767022f 100644
--- a/db/check.c
+++ b/db/check.c
@@ -799,8 +799,6 @@ blockget_f(
 	 * filters out, or we need to actually do the work to make check support
 	 * crc enabled filesystems.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb))
-		return 0;
 
 	if (!init(argc, argv)) {
 		if (serious_error)
@@ -2217,7 +2215,9 @@ process_data_dir_v2(
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
@@ -2228,7 +2228,8 @@ process_data_dir_v2(
 	db = xfs_dir2_da_to_db(mp, dabno);
 	bf = xfs_dir3_data_bestfree_p(data);
 	ptr = (char *)xfs_dir3_data_unused_p(data);
-	if (be32_to_cpu(block->magic) == XFS_DIR2_BLOCK_MAGIC) {
+	if (be32_to_cpu(block->magic) == XFS_DIR2_BLOCK_MAGIC ||
+	    be32_to_cpu(block->magic) == XFS_DIR3_BLOCK_MAGIC) {
 		btp = xfs_dir2_block_tail_p(mp, block);
 		lep = xfs_dir2_block_leaf_p(btp);
 		endptr = (char *)lep;
@@ -2374,7 +2375,8 @@ process_data_dir_v2(
 			(*dot)++;
 		}
 	}
-	if (be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC) {
+	if (be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC ||
+	    be32_to_cpu(data->magic) == XFS_DIR3_BLOCK_MAGIC) {
 		endptr = (char *)data + mp->m_dirblksize;
 		for (i = stale = 0; lep && i < be32_to_cpu(btp->count); i++) {
 			if ((char *)&lep[i] >= endptr) {
@@ -2406,7 +2408,8 @@ process_data_dir_v2(
 				id->ino, dabno);
 		error++;
 	}
-	if (be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC &&
+	if ((be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC ||
+	     be32_to_cpu(data->magic) == XFS_DIR3_BLOCK_MAGIC) &&
 	    count != be32_to_cpu(btp->count) - be32_to_cpu(btp->stale)) {
 		if (!sflag || v)
 			dbprintf(_("dir %lld block %d bad block tail count %d "
@@ -2415,7 +2418,8 @@ process_data_dir_v2(
 				be32_to_cpu(btp->stale));
 		error++;
 	}
-	if (be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC && 
+	if ((be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC ||
+	     be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC) &&
 					stale != be32_to_cpu(btp->stale)) {
 		if (!sflag || v)
 			dbprintf(_("dir %lld block %d bad stale tail count %d\n"),
@@ -3014,7 +3018,8 @@ process_leaf_node_dir_v2_free(
 	int			used;
 
 	free = iocur_top->data;
-	if (be32_to_cpu(free->hdr.magic) != XFS_DIR2_FREE_MAGIC) {
+	if (be32_to_cpu(free->hdr.magic) != XFS_DIR2_FREE_MAGIC &&
+	    be32_to_cpu(free->hdr.magic) != XFS_DIR3_FREE_MAGIC) {
 		if (!sflag || v)
 			dbprintf(_("bad free block magic # %#x for dir ino %lld "
 				 "block %d\n"),
@@ -3075,6 +3080,20 @@ process_leaf_node_dir_v2_free(
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
@@ -3094,6 +3113,7 @@ process_leaf_node_dir_v2_int(
 	leaf = iocur_top->data;
 	switch (be16_to_cpu(leaf->hdr.info.magic)) {
 	case XFS_DIR2_LEAF1_MAGIC:
+	case XFS_DIR3_LEAF1_MAGIC:
 		if (be32_to_cpu(leaf->hdr.info.forw) || 
 					be32_to_cpu(leaf->hdr.info.back)) {
 			if (!sflag || v)
@@ -3133,10 +3153,12 @@ process_leaf_node_dir_v2_int(
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
@@ -3158,7 +3180,7 @@ process_leaf_node_dir_v2_int(
 		return;
 	}
 	lep = xfs_dir3_leaf_ents_p(leaf);
-	for (i = stale = 0; i < be16_to_cpu(leaf->hdr.count); i++) {
+	for (i = stale = 0; i < xfs_dir3_leaf_ents_count(leaf); i++) {
 		if (be32_to_cpu(lep[i].address) == XFS_DIR2_NULL_DATAPTR)
 			stale++;
 		else if (dir_hash_see(be32_to_cpu(lep[i].hashval), 
@@ -3957,7 +3979,8 @@ scanfunc_bmap(
 
 	agno = XFS_FSB_TO_AGNO(mp, bno);
 	agbno = XFS_FSB_TO_AGBNO(mp, bno);
-	if (be32_to_cpu(block->bb_magic) != XFS_BMAP_MAGIC) {
+	if (be32_to_cpu(block->bb_magic) != XFS_BMAP_MAGIC ||
+	    be32_to_cpu(block->bb_magic) != XFS_BMAP_CRC_MAGIC) {
 		if (!sflag || id->ilist || CHECK_BLIST(bno))
 			dbprintf(_("bad magic # %#x in inode %lld bmbt block "
 				 "%u/%u\n"),
@@ -4022,7 +4045,8 @@ scanfunc_bno(
 	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
 	xfs_agblock_t		lastblock;
 
-	if (be32_to_cpu(block->bb_magic) != XFS_ABTB_MAGIC) {
+	if (be32_to_cpu(block->bb_magic) != XFS_ABTB_MAGIC &&
+	    be32_to_cpu(block->bb_magic) != XFS_ABTB_CRC_MAGIC) {
 		dbprintf(_("bad magic # %#x in btbno block %u/%u\n"),
 			be32_to_cpu(block->bb_magic), seqno, bno);
 		serious_error++;
@@ -4095,7 +4119,8 @@ scanfunc_cnt(
 	xfs_alloc_rec_t		*rp;
 	xfs_extlen_t		lastcount;
 
-	if (be32_to_cpu(block->bb_magic) != XFS_ABTC_MAGIC) {
+	if (be32_to_cpu(block->bb_magic) != XFS_ABTC_MAGIC &&
+	    be32_to_cpu(block->bb_magic) != XFS_ABTC_CRC_MAGIC) {
 		dbprintf(_("bad magic # %#x in btcnt block %u/%u\n"),
 			be32_to_cpu(block->bb_magic), seqno, bno);
 		serious_error++;
@@ -4175,7 +4200,8 @@ scanfunc_ino(
 	xfs_inobt_ptr_t		*pp;
 	xfs_inobt_rec_t		*rp;
 
-	if (be32_to_cpu(block->bb_magic) != XFS_IBT_MAGIC) {
+	if (be32_to_cpu(block->bb_magic) != XFS_IBT_MAGIC &&
+	    be32_to_cpu(block->bb_magic) != XFS_IBT_CRC_MAGIC) {
 		dbprintf(_("bad magic # %#x in inobt block %u/%u\n"),
 			be32_to_cpu(block->bb_magic), seqno, bno);
 		serious_error++;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
