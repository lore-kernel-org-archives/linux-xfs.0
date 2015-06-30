Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 414A129E09
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 22:27:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E78C8304043
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 20:27:20 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id EV6XIkVIwOSJFuvI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 20:27:18 -0700 (PDT)
Subject: [PATCH 15/15] xfs_repair: rebuild the reflink btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 29 Jun 2015 20:27:15 -0700
Message-ID: <20150630032715.572.57448.stgit@birch.djwong.org>
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

Rebuild the reflink btree with the reference count data we assembled
during phase 4.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase5.c     |  338 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 repair/xfs_repair.c |    2 
 2 files changed, 333 insertions(+), 7 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index 0601810..86b47e6 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -28,6 +28,8 @@
 #include "versions.h"
 #include "threads.h"
 #include "progress.h"
+#include "slab.h"
+#include "rmap.h"
 
 /*
  * we maintain the current slice (path from root to leaf)
@@ -1324,6 +1326,291 @@ nextrec:
 	}
 }
 
+/* rebuild the reflink tree */
+
+#define XR_RLBT_BLOCK_MAXRECS(mp, level) \
+			((mp)->m_rlbt_mxr[(level) != 0])
+
+/*
+ * we don't have to worry here about how chewing up free extents
+ * may perturb things because reflink tree building happens before
+ * freespace tree building.
+ */
+static void
+init_rl_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs)
+{
+	size_t			num_recs;
+	int			level;
+	bt_stat_level_t		*lptr;
+	bt_stat_level_t		*p_lptr;
+	xfs_extlen_t		blocks_allocated;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb)) {
+		memset(btree_curs, 0, sizeof(bt_status_t));
+		return;
+	}
+
+	lptr = &btree_curs->level[0];
+	btree_curs->init = 1;
+
+	/*
+	 * build up statistics
+	 */
+	num_recs = reflink_count(mp, agno);
+	if (num_recs == 0) {
+		/*
+		 * easy corner-case -- no reflink records
+		 */
+		lptr->num_blocks = 1;
+		lptr->modulo = 0;
+		lptr->num_recs_pb = 0;
+		lptr->num_recs_tot = 0;
+
+		btree_curs->num_levels = 1;
+		btree_curs->num_tot_blocks = btree_curs->num_free_blocks = 1;
+
+		setup_cursor(mp, agno, btree_curs);
+
+		return;
+	}
+
+	blocks_allocated = lptr->num_blocks = howmany(num_recs,
+					XR_RLBT_BLOCK_MAXRECS(mp, 0));
+
+	lptr->modulo = num_recs % lptr->num_blocks;
+	lptr->num_recs_pb = num_recs / lptr->num_blocks;
+	lptr->num_recs_tot = num_recs;
+	level = 1;
+
+	if (lptr->num_blocks > 1)  {
+		for (; btree_curs->level[level-1].num_blocks > 1
+				&& level < XFS_BTREE_MAXLEVELS;
+				level++)  {
+			lptr = &btree_curs->level[level];
+			p_lptr = &btree_curs->level[level - 1];
+			lptr->num_blocks = howmany(p_lptr->num_blocks,
+				XR_RLBT_BLOCK_MAXRECS(mp, level));
+			lptr->modulo = p_lptr->num_blocks % lptr->num_blocks;
+			lptr->num_recs_pb = p_lptr->num_blocks
+					/ lptr->num_blocks;
+			lptr->num_recs_tot = p_lptr->num_blocks;
+
+			blocks_allocated += lptr->num_blocks;
+		}
+	}
+	ASSERT(lptr->num_blocks == 1);
+	btree_curs->num_levels = level;
+
+	btree_curs->num_tot_blocks = btree_curs->num_free_blocks
+			= blocks_allocated;
+
+	setup_cursor(mp, agno, btree_curs);
+
+	return;
+}
+
+static void
+prop_rl_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
+	xfs_agblock_t startbno, int level)
+{
+	struct xfs_btree_block	*bt_hdr;
+	xfs_reflink_key_t	*bt_key;
+	xfs_reflink_ptr_t	*bt_ptr;
+	xfs_agblock_t		agbno;
+	bt_stat_level_t		*lptr;
+
+	level++;
+
+	if (level >= btree_curs->num_levels)
+		return;
+
+	lptr = &btree_curs->level[level];
+	bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
+
+	if (be16_to_cpu(bt_hdr->bb_numrecs) == 0)  {
+		/*
+		 * this only happens once to initialize the
+		 * first path up the left side of the tree
+		 * where the agbno's are already set up
+		 */
+		prop_rl_cursor(mp, agno, btree_curs, startbno, level);
+	}
+
+	if (be16_to_cpu(bt_hdr->bb_numrecs) ==
+				lptr->num_recs_pb + (lptr->modulo > 0))  {
+		/*
+		 * write out current prev block, grab us a new block,
+		 * and set the rightsib pointer of current block
+		 */
+#ifdef XR_BLD_INO_TRACE
+		fprintf(stderr, " ino prop agbno %d ", lptr->prev_agbno);
+#endif
+		if (lptr->prev_agbno != NULLAGBLOCK)  {
+			ASSERT(lptr->prev_buf_p != NULL);
+			libxfs_writebuf(lptr->prev_buf_p, 0);
+		}
+		lptr->prev_agbno = lptr->agbno;
+		lptr->prev_buf_p = lptr->buf_p;
+		agbno = get_next_blockaddr(agno, level, btree_curs);
+
+		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(agbno);
+
+		lptr->buf_p = libxfs_getbuf(mp->m_dev,
+					XFS_AGB_TO_DADDR(mp, agno, agbno),
+					XFS_FSB_TO_BB(mp, 1));
+		lptr->agbno = agbno;
+
+		if (lptr->modulo)
+			lptr->modulo--;
+
+		/*
+		 * initialize block header
+		 */
+		lptr->buf_p->b_ops = &xfs_reflinkbt_buf_ops;
+		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
+		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
+		xfs_btree_init_block(mp, lptr->buf_p, XFS_RLBT_CRC_MAGIC,
+					level, 0, agno,
+					XFS_BTREE_CRC_BLOCKS);
+
+		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
+
+		/*
+		 * propagate extent record for first extent in new block up
+		 */
+		prop_rl_cursor(mp, agno, btree_curs, startbno, level);
+	}
+	/*
+	 * add inode info to current block
+	 */
+	be16_add_cpu(&bt_hdr->bb_numrecs, 1);
+
+	bt_key = XFS_REFLINK_KEY_ADDR(bt_hdr,
+				    be16_to_cpu(bt_hdr->bb_numrecs));
+	bt_ptr = XFS_REFLINK_PTR_ADDR(bt_hdr,
+				    be16_to_cpu(bt_hdr->bb_numrecs),
+				    mp->m_rlbt_mxr[1]);
+
+	bt_key->rr_startblock = cpu_to_be32(startbno);
+	*bt_ptr = cpu_to_be32(btree_curs->level[level-1].agbno);
+}
+
+/*
+ * rebuilds a reflink tree given a cursor.
+ */
+static void
+build_rl_tree(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs)
+{
+	xfs_agnumber_t		i;
+	xfs_agblock_t		j;
+	xfs_agblock_t		agbno;
+	struct xfs_btree_block	*bt_hdr;
+	xfs_reflink_rec_incore_t	*rl_rec;
+	xfs_slab_cursor_t	*rl_cur;
+	xfs_reflink_rec_t	*bt_rec;
+	bt_stat_level_t		*lptr;
+	int			level = btree_curs->num_levels;
+	int			error;
+
+	for (i = 0; i < level; i++)  {
+		lptr = &btree_curs->level[i];
+
+		agbno = get_next_blockaddr(agno, i, btree_curs);
+		lptr->buf_p = libxfs_getbuf(mp->m_dev,
+					XFS_AGB_TO_DADDR(mp, agno, agbno),
+					XFS_FSB_TO_BB(mp, 1));
+
+		if (i == btree_curs->num_levels - 1)
+			btree_curs->root = agbno;
+
+		lptr->agbno = agbno;
+		lptr->prev_agbno = NULLAGBLOCK;
+		lptr->prev_buf_p = NULL;
+		/*
+		 * initialize block header
+		 */
+
+		lptr->buf_p->b_ops = &xfs_reflinkbt_buf_ops;
+		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
+		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
+		xfs_btree_init_block(mp, lptr->buf_p, XFS_RLBT_CRC_MAGIC,
+					i, 0, agno,
+					XFS_BTREE_CRC_BLOCKS);
+	}
+
+	/*
+	 * run along leaf, setting up records.  as we have to switch
+	 * blocks, call the prop_rl_cursor routine to set up the new
+	 * pointers for the parent.  that can recurse up to the root
+	 * if required.  set the sibling pointers for leaf level here.
+	 */
+	error = init_reflink_cursor(agno, &rl_cur);
+	if (error)
+		do_error(
+_("Insufficient memory to construct reflink cursor."));
+	rl_rec = pop_slab_cursor(rl_cur);
+	lptr = &btree_curs->level[0];
+
+	for (i = 0; i < lptr->num_blocks; i++)  {
+		/*
+		 * block initialization, lay in block header
+		 */
+		lptr->buf_p->b_ops = &xfs_reflinkbt_buf_ops;
+		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
+		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
+		xfs_btree_init_block(mp, lptr->buf_p, XFS_RLBT_CRC_MAGIC,
+					0, 0, agno,
+					XFS_BTREE_CRC_BLOCKS);
+
+		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
+		bt_hdr->bb_numrecs = cpu_to_be16(lptr->num_recs_pb +
+							(lptr->modulo > 0));
+
+		if (lptr->modulo > 0)
+			lptr->modulo--;
+
+		if (lptr->num_recs_pb > 0)
+			prop_rl_cursor(mp, agno, btree_curs,
+					rl_rec->rr_startblock, 0);
+
+		bt_rec = (xfs_reflink_rec_t *)
+			  ((char *)bt_hdr + XFS_REFLINK_BLOCK_LEN);
+		for (j = 0; j < be16_to_cpu(bt_hdr->bb_numrecs); j++) {
+			ASSERT(rl_rec != NULL);
+			bt_rec[j].rr_startblock =
+					cpu_to_be32(rl_rec->rr_startblock);
+			bt_rec[j].rr_blockcount =
+					cpu_to_be32(rl_rec->rr_blockcount);
+			bt_rec[j].rr_nlinks = cpu_to_be32(rl_rec->rr_nlinks);
+
+			rl_rec = pop_slab_cursor(rl_cur);
+		}
+
+		if (rl_rec != NULL)  {
+			/*
+			 * get next leaf level block
+			 */
+			if (lptr->prev_buf_p != NULL)  {
+#ifdef XR_BLD_RL_TRACE
+				fprintf(stderr, "writing rlbt agbno %u\n",
+					lptr->prev_agbno);
+#endif
+				ASSERT(lptr->prev_agbno != NULLAGBLOCK);
+				libxfs_writebuf(lptr->prev_buf_p, 0);
+			}
+			lptr->prev_buf_p = lptr->buf_p;
+			lptr->prev_agbno = lptr->agbno;
+			lptr->agbno = get_next_blockaddr(agno, 0, btree_curs);
+			bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(lptr->agbno);
+
+			lptr->buf_p = libxfs_getbuf(mp->m_dev,
+					XFS_AGB_TO_DADDR(mp, agno, lptr->agbno),
+					XFS_FSB_TO_BB(mp, 1));
+		}
+	}
+	free_slab_cursor(&rl_cur);
+}
+
 /*
  * build both the agf and the agfl for an agno given both
  * btree cursors.
@@ -1336,7 +1623,8 @@ build_agf_agfl(xfs_mount_t	*mp,
 		bt_status_t	*bno_bt,
 		bt_status_t	*bcnt_bt,
 		xfs_extlen_t	freeblks,	/* # free blocks in tree */
-		int		lostblocks)	/* # blocks that will be lost */
+		int		lostblocks,	/* # blocks that will be lost */
+		bt_status_t	*reflink_bt)
 {
 	extent_tree_node_t	*ext_ptr;
 	xfs_buf_t		*agf_buf, *agfl_buf;
@@ -1376,19 +1664,23 @@ build_agf_agfl(xfs_mount_t	*mp,
 	agf->agf_roots[XFS_BTNUM_CNT] = cpu_to_be32(bcnt_bt->root);
 	agf->agf_levels[XFS_BTNUM_CNT] = cpu_to_be32(bcnt_bt->num_levels);
 	agf->agf_freeblks = cpu_to_be32(freeblks);
+	agf->agf_reflink_root = cpu_to_be32(reflink_bt->root);
+	agf->agf_reflink_level = cpu_to_be32(reflink_bt->num_levels);
 
 	/*
 	 * Count and record the number of btree blocks consumed if required.
 	 */
 	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
+		unsigned nr_blks;
+
+		nr_blks = (bno_bt->num_tot_blocks - bno_bt->num_free_blocks) +
+			(bcnt_bt->num_tot_blocks - bcnt_bt->num_free_blocks) +
+			(reflink_bt->num_tot_blocks - reflink_bt->num_free_blocks) - 3;
 		/*
 		 * Don't count the root blocks as they are already
 		 * accounted for.
 		 */
-		agf->agf_btreeblks = cpu_to_be32(
-			(bno_bt->num_tot_blocks - bno_bt->num_free_blocks) +
-			(bcnt_bt->num_tot_blocks - bcnt_bt->num_free_blocks) -
-			2);
+		agf->agf_btreeblks = cpu_to_be32(nr_blks);
 #ifdef XR_BLD_FREE_TRACE
 		fprintf(stderr, "agf->agf_btreeblks = %u\n",
 				be32_to_cpu(agf->agf_btreeblks));
@@ -1428,7 +1720,8 @@ build_agf_agfl(xfs_mount_t	*mp,
 	 * do we have left-over blocks in the btree cursors that should
 	 * be used to fill the AGFL?
 	 */
-	if (bno_bt->num_free_blocks > 0 || bcnt_bt->num_free_blocks > 0)  {
+	if (bno_bt->num_free_blocks > 0 || bcnt_bt->num_free_blocks > 0 ||
+	    reflink_bt->num_free_blocks > 0)  {
 		/*
 		 * yes, now grab as many blocks as we can
 		 */
@@ -1444,6 +1737,12 @@ build_agf_agfl(xfs_mount_t	*mp,
 					get_next_blockaddr(agno, 0, bcnt_bt));
 			i++;
 		}
+
+		while (reflink_bt->num_free_blocks > 0 && i < XFS_AGFL_SIZE(mp))  {
+			freelist[i] = cpu_to_be32(
+					get_next_blockaddr(agno, 0, reflink_bt));
+			i++;
+		}
 		/*
 		 * now throw the rest of the blocks away and complain
 		 */
@@ -1455,6 +1754,10 @@ build_agf_agfl(xfs_mount_t	*mp,
 			(void) get_next_blockaddr(agno, 0, bcnt_bt);
 			j++;
 		}
+		while (reflink_bt->num_free_blocks > 0)  {
+			(void) get_next_blockaddr(agno, 0, reflink_bt);
+			j++;
+		}
 
 		if (j > 0)  {
 			if (j == lostblocks)
@@ -1489,6 +1792,10 @@ build_agf_agfl(xfs_mount_t	*mp,
 
 	ASSERT(be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNOi]) !=
 		be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNTi]));
+	ASSERT(be32_to_cpu(agf->agf_reflink_root) !=
+		be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNOi]));
+	ASSERT(be32_to_cpu(agf->agf_reflink_root) !=
+		be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNTi]));
 
 	libxfs_writebuf(agf_buf, 0);
 
@@ -1578,6 +1885,7 @@ phase5_func(
 	bt_status_t	bcnt_btree_curs;
 	bt_status_t	ino_btree_curs;
 	bt_status_t	fino_btree_curs;
+	bt_status_t	rl_btree_curs;
 	int		extra_blocks = 0;
 	uint		num_freeblocks;
 	xfs_extlen_t	freeblks1;
@@ -1633,6 +1941,12 @@ phase5_func(
 		sb_icount_ag[agno] += num_inos;
 		sb_ifree_ag[agno] += num_free_inos;
 
+		/*
+		 * Set up the btree cursors for the on-disk reflink btrees,
+		 * which includes pre-allocating all required blocks.
+		 */
+		init_rl_cursor(mp, agno, &rl_btree_curs);
+
 		num_extents = count_bno_extents_blocks(agno, &num_freeblocks);
 		/*
 		 * lose two blocks per AG -- the space tree roots
@@ -1717,11 +2031,19 @@ phase5_func(
 
 		ASSERT(freeblks1 == freeblks2);
 
+		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+			build_rl_tree(mp, agno, &rl_btree_curs);
+			write_cursor(&rl_btree_curs);
+			sb_fdblocks_ag[agno] += (rl_btree_curs.num_tot_blocks -
+					rl_btree_curs.num_free_blocks) - 1;
+		}
+
 		/*
 		 * set up agf and agfl
 		 */
 		build_agf_agfl(mp, agno, &bno_btree_curs,
-				&bcnt_btree_curs, freeblks1, extra_blocks);
+				&bcnt_btree_curs, freeblks1, extra_blocks,
+				&rl_btree_curs);
 		/*
 		 * build inode allocation tree.
 		 */
@@ -1750,6 +2072,8 @@ phase5_func(
 		 */
 		finish_cursor(&bno_btree_curs);
 		finish_cursor(&ino_btree_curs);
+		if (xfs_sb_version_hasreflink(&mp->m_sb))
+			finish_cursor(&rl_btree_curs);
 		if (xfs_sb_version_hasfinobt(&mp->m_sb))
 			finish_cursor(&fino_btree_curs);
 		finish_cursor(&bcnt_btree_curs);
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 3cd288a..d7a9ad2 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -415,6 +415,8 @@ calc_mkfs(xfs_mount_t *mp)
 		fino_bno++;
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
 		fino_bno++;
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		fino_bno++;
 
 	/*
 	 * If the log is allocated in the first allocation group we need to

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
