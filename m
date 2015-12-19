Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B0FD729E40
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:08:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 33BF68F8039
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:08:53 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id bZoFpEIGoeUsxTyG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:08:50 -0800 (PST)
Subject: [PATCH 34/53] xfs_repair: rebuild reverse-mapping btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:08:43 -0800
Message-ID: <20151219090843.14255.66422.stgit@birch.djwong.org>
In-Reply-To: <20151219090450.14255.48364.stgit@birch.djwong.org>
References: <20151219090450.14255.48364.stgit@birch.djwong.org>
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

Rebuild the reverse-mapping btree with the rmap observations
corresponding to file extents, bmbt blocks, and fixed per-AG
metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase5.c |  321 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 316 insertions(+), 5 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index 109e37b..f37ce6b 100644
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
@@ -1326,6 +1328,292 @@ nextrec:
 	}
 }
 
+/* rebuild the rmap tree */
+
+#define XR_RMAPBT_BLOCK_MAXRECS(mp, level) \
+			((mp)->m_rmap_mxr[(level) != 0])
+
+/*
+ * we don't have to worry here about how chewing up free extents
+ * may perturb things because rmap tree building happens before
+ * freespace tree building.
+ */
+static void
+init_rmapbt_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs)
+{
+	size_t			num_recs;
+	int			level;
+	bt_stat_level_t		*lptr;
+	bt_stat_level_t		*p_lptr;
+	xfs_extlen_t		blocks_allocated;
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb)) {
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
+	num_recs = rmap_record_count(mp, agno);
+	if (num_recs == 0) {
+		/*
+		 * easy corner-case -- no refcount records
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
+					XR_RMAPBT_BLOCK_MAXRECS(mp, 0));
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
+				XR_RMAPBT_BLOCK_MAXRECS(mp, level));
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
+}
+
+static void
+prop_rmap_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
+	struct xfs_rmap_irec *rm_rec, int level)
+{
+	struct xfs_btree_block	*bt_hdr;
+	struct xfs_rmap_key	*bt_key;
+	xfs_rmap_ptr_t		*bt_ptr;
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
+		prop_rmap_cursor(mp, agno, btree_curs, rm_rec, level);
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
+		lptr->buf_p->b_ops = &xfs_rmapbt_buf_ops;
+		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
+		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
+		xfs_btree_init_block(mp, lptr->buf_p, XFS_RMAP_CRC_MAGIC,
+					level, 0, agno,
+					XFS_BTREE_CRC_BLOCKS);
+
+		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
+
+		/*
+		 * propagate extent record for first extent in new block up
+		 */
+		prop_rmap_cursor(mp, agno, btree_curs, rm_rec, level);
+	}
+	/*
+	 * add inode info to current block
+	 */
+	be16_add_cpu(&bt_hdr->bb_numrecs, 1);
+
+	bt_key = XFS_RMAP_KEY_ADDR(bt_hdr,
+				    be16_to_cpu(bt_hdr->bb_numrecs));
+	bt_ptr = XFS_RMAP_PTR_ADDR(bt_hdr,
+				    be16_to_cpu(bt_hdr->bb_numrecs),
+				    mp->m_rmap_mxr[1]);
+
+	bt_key->rm_startblock = cpu_to_be32(rm_rec->rm_startblock);
+	bt_key->rm_owner = cpu_to_be64(rm_rec->rm_owner);
+	bt_key->rm_offset = cpu_to_be64(rm_rec->rm_offset);
+
+	*bt_ptr = cpu_to_be32(btree_curs->level[level-1].agbno);
+}
+
+/*
+ * rebuilds a rmap btree given a cursor.
+ */
+static void
+build_rmap_tree(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs)
+{
+	xfs_agnumber_t		i;
+	xfs_agblock_t		j;
+	xfs_agblock_t		agbno;
+	struct xfs_btree_block	*bt_hdr;
+	struct xfs_rmap_irec	*rm_rec;
+	struct xfs_slab_cursor	*rmap_cur;
+	struct xfs_rmap_rec	*bt_rec;
+	struct bt_stat_level	*lptr;
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
+		lptr->buf_p->b_ops = &xfs_rmapbt_buf_ops;
+		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
+		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
+		xfs_btree_init_block(mp, lptr->buf_p, XFS_RMAP_CRC_MAGIC,
+					i, 0, agno,
+					XFS_BTREE_CRC_BLOCKS);
+	}
+
+	/*
+	 * run along leaf, setting up records.  as we have to switch
+	 * blocks, call the prop_rmap_cursor routine to set up the new
+	 * pointers for the parent.  that can recurse up to the root
+	 * if required.  set the sibling pointers for leaf level here.
+	 */
+	error = init_rmap_cursor(agno, &rmap_cur);
+	if (error)
+		do_error(
+_("Insufficient memory to construct reverse-map cursor."));
+	rm_rec = pop_slab_cursor(rmap_cur);
+	lptr = &btree_curs->level[0];
+
+	for (i = 0; i < lptr->num_blocks; i++)  {
+		/*
+		 * block initialization, lay in block header
+		 */
+		lptr->buf_p->b_ops = &xfs_rmapbt_buf_ops;
+		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
+		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
+		xfs_btree_init_block(mp, lptr->buf_p, XFS_RMAP_CRC_MAGIC,
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
+			prop_rmap_cursor(mp, agno, btree_curs, rm_rec, 0);
+
+		bt_rec = (struct xfs_rmap_rec *)
+			  ((char *)bt_hdr + XFS_RMAP_BLOCK_LEN);
+		for (j = 0; j < be16_to_cpu(bt_hdr->bb_numrecs); j++) {
+			ASSERT(rm_rec != NULL);
+			bt_rec[j].rm_startblock =
+					cpu_to_be32(rm_rec->rm_startblock);
+			bt_rec[j].rm_blockcount =
+					cpu_to_be32(rm_rec->rm_blockcount);
+			bt_rec[j].rm_owner = cpu_to_be64(rm_rec->rm_owner);
+			bt_rec[j].rm_offset = cpu_to_be64(rm_rec->rm_offset);
+
+			rm_rec = pop_slab_cursor(rmap_cur);
+		}
+
+		if (rm_rec != NULL)  {
+			/*
+			 * get next leaf level block
+			 */
+			if (lptr->prev_buf_p != NULL)  {
+#ifdef XR_BLD_RL_TRACE
+				fprintf(stderr, "writing rmapbt agbno %u\n",
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
+	free_slab_cursor(&rmap_cur);
+}
+
 /*
  * build both the agf and the agfl for an agno given both
  * btree cursors.
@@ -1338,7 +1626,8 @@ build_agf_agfl(xfs_mount_t	*mp,
 		bt_status_t	*bno_bt,
 		bt_status_t	*bcnt_bt,
 		xfs_extlen_t	freeblks,	/* # free blocks in tree */
-		int		lostblocks)	/* # blocks that will be lost */
+		int		lostblocks,	/* # blocks that will be lost */
+		bt_status_t	*rmap_bt)
 {
 	extent_tree_node_t	*ext_ptr;
 	xfs_buf_t		*agf_buf, *agfl_buf;
@@ -1377,20 +1666,25 @@ build_agf_agfl(xfs_mount_t	*mp,
 	agf->agf_levels[XFS_BTNUM_BNO] = cpu_to_be32(bno_bt->num_levels);
 	agf->agf_roots[XFS_BTNUM_CNT] = cpu_to_be32(bcnt_bt->root);
 	agf->agf_levels[XFS_BTNUM_CNT] = cpu_to_be32(bcnt_bt->num_levels);
+	agf->agf_roots[XFS_BTNUM_RMAP] = cpu_to_be32(rmap_bt->root);
+	agf->agf_levels[XFS_BTNUM_RMAP] = cpu_to_be32(rmap_bt->num_levels);
 	agf->agf_freeblks = cpu_to_be32(freeblks);
 
 	/*
 	 * Count and record the number of btree blocks consumed if required.
 	 */
 	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
+		unsigned int blks;
 		/*
 		 * Don't count the root blocks as they are already
 		 * accounted for.
 		 */
-		agf->agf_btreeblks = cpu_to_be32(
-			(bno_bt->num_tot_blocks - bno_bt->num_free_blocks) +
+		blks = (bno_bt->num_tot_blocks - bno_bt->num_free_blocks) +
 			(bcnt_bt->num_tot_blocks - bcnt_bt->num_free_blocks) -
-			2);
+			2;
+		if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+			blks += rmap_bt->num_tot_blocks - rmap_bt->num_free_blocks - 1;
+		agf->agf_btreeblks = cpu_to_be32(blks);
 #ifdef XR_BLD_FREE_TRACE
 		fprintf(stderr, "agf->agf_btreeblks = %u\n",
 				be32_to_cpu(agf->agf_btreeblks));
@@ -1581,6 +1875,7 @@ phase5_func(
 	bt_status_t	bcnt_btree_curs;
 	bt_status_t	ino_btree_curs;
 	bt_status_t	fino_btree_curs;
+	bt_status_t	rmap_btree_curs;
 	int		extra_blocks = 0;
 	uint		num_freeblocks;
 	xfs_extlen_t	freeblks1;
@@ -1636,6 +1931,12 @@ phase5_func(
 		sb_icount_ag[agno] += num_inos;
 		sb_ifree_ag[agno] += num_free_inos;
 
+		/*
+		 * Set up the btree cursors for the on-disk rmap btrees,
+		 * which includes pre-allocating all required blocks.
+		 */
+		init_rmapbt_cursor(mp, agno, &rmap_btree_curs);
+
 		num_extents = count_bno_extents_blocks(agno, &num_freeblocks);
 		/*
 		 * lose two blocks per AG -- the space tree roots
@@ -1720,11 +2021,19 @@ phase5_func(
 
 		ASSERT(freeblks1 == freeblks2);
 
+		if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+			build_rmap_tree(mp, agno, &rmap_btree_curs);
+			write_cursor(&rmap_btree_curs);
+			sb_fdblocks_ag[agno] += (rmap_btree_curs.num_tot_blocks -
+					rmap_btree_curs.num_free_blocks) - 1;
+		}
+
 		/*
 		 * set up agf and agfl
 		 */
 		build_agf_agfl(mp, agno, &bno_btree_curs,
-				&bcnt_btree_curs, freeblks1, extra_blocks);
+				&bcnt_btree_curs, freeblks1, extra_blocks,
+				&rmap_btree_curs);
 		/*
 		 * build inode allocation tree.
 		 */
@@ -1753,6 +2062,8 @@ phase5_func(
 		 */
 		finish_cursor(&bno_btree_curs);
 		finish_cursor(&ino_btree_curs);
+		if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+			finish_cursor(&rmap_btree_curs);
 		if (xfs_sb_version_hasfinobt(&mp->m_sb))
 			finish_cursor(&fino_btree_curs);
 		finish_cursor(&bcnt_btree_curs);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
