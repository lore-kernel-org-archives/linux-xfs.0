Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F3E5D811E
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:53:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 56270AC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:53:49 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id XFAOGTOMTzNjAdif (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:53:46 -0700 (PDT)
Subject: [PATCH 66/71] xfs_repair: rebuild the refcount btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:53:42 -0700
Message-ID: <147216922212.4420.9634068016216710493.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Rebuild the refcount btree with the reference count data we assembled
during phase 4.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase5.c |  318 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 316 insertions(+), 2 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index b464b56..1b29043 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -1692,6 +1692,297 @@ _("Insufficient memory to construct reverse-map cursor."));
 	free_slab_cursor(&rmap_cur);
 }
 
+/* rebuild the refcount tree */
+
+/*
+ * we don't have to worry here about how chewing up free extents
+ * may perturb things because reflink tree building happens before
+ * freespace tree building.
+ */
+static void
+init_refc_cursor(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	struct bt_status	*btree_curs)
+{
+	size_t			num_recs;
+	int			level;
+	struct bt_stat_level	*lptr;
+	struct bt_stat_level	*p_lptr;
+	xfs_extlen_t		blocks_allocated;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb)) {
+		memset(btree_curs, 0, sizeof(struct bt_status));
+		return;
+	}
+
+	lptr = &btree_curs->level[0];
+	btree_curs->init = 1;
+	btree_curs->owner = XFS_RMAP_OWN_REFC;
+
+	/*
+	 * build up statistics
+	 */
+	num_recs = refcount_record_count(mp, agno);
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
+					mp->m_refc_mxr[0]);
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
+					mp->m_refc_mxr[1]);
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
+prop_refc_cursor(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	struct bt_status	*btree_curs,
+	xfs_agblock_t		startbno,
+	int			level)
+{
+	struct xfs_btree_block	*bt_hdr;
+	struct xfs_refcount_key	*bt_key;
+	xfs_refcount_ptr_t	*bt_ptr;
+	xfs_agblock_t		agbno;
+	struct bt_stat_level	*lptr;
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
+		prop_refc_cursor(mp, agno, btree_curs, startbno, level);
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
+		lptr->buf_p->b_ops = &xfs_refcountbt_buf_ops;
+		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
+		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
+		libxfs_btree_init_block(mp, lptr->buf_p, XFS_REFC_CRC_MAGIC,
+					level, 0, agno,
+					XFS_BTREE_CRC_BLOCKS);
+
+		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
+
+		/*
+		 * propagate extent record for first extent in new block up
+		 */
+		prop_refc_cursor(mp, agno, btree_curs, startbno, level);
+	}
+	/*
+	 * add inode info to current block
+	 */
+	be16_add_cpu(&bt_hdr->bb_numrecs, 1);
+
+	bt_key = XFS_REFCOUNT_KEY_ADDR(bt_hdr,
+				    be16_to_cpu(bt_hdr->bb_numrecs));
+	bt_ptr = XFS_REFCOUNT_PTR_ADDR(bt_hdr,
+				    be16_to_cpu(bt_hdr->bb_numrecs),
+				    mp->m_refc_mxr[1]);
+
+	bt_key->rc_startblock = cpu_to_be32(startbno);
+	*bt_ptr = cpu_to_be32(btree_curs->level[level-1].agbno);
+}
+
+/*
+ * rebuilds a refcount btree given a cursor.
+ */
+static void
+build_refcount_tree(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	struct bt_status	*btree_curs)
+{
+	xfs_agnumber_t		i;
+	xfs_agblock_t		j;
+	xfs_agblock_t		agbno;
+	struct xfs_btree_block	*bt_hdr;
+	struct xfs_refcount_irec	*refc_rec;
+	struct xfs_slab_cursor	*refc_cur;
+	struct xfs_refcount_rec	*bt_rec;
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
+		lptr->buf_p->b_ops = &xfs_refcountbt_buf_ops;
+		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
+		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
+		libxfs_btree_init_block(mp, lptr->buf_p, XFS_REFC_CRC_MAGIC,
+					i, 0, agno,
+					XFS_BTREE_CRC_BLOCKS);
+	}
+
+	/*
+	 * run along leaf, setting up records.  as we have to switch
+	 * blocks, call the prop_refc_cursor routine to set up the new
+	 * pointers for the parent.  that can recurse up to the root
+	 * if required.  set the sibling pointers for leaf level here.
+	 */
+	error = init_refcount_cursor(agno, &refc_cur);
+	if (error)
+		do_error(
+_("Insufficient memory to construct refcount cursor."));
+	refc_rec = pop_slab_cursor(refc_cur);
+	lptr = &btree_curs->level[0];
+
+	for (i = 0; i < lptr->num_blocks; i++)  {
+		/*
+		 * block initialization, lay in block header
+		 */
+		lptr->buf_p->b_ops = &xfs_refcountbt_buf_ops;
+		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
+		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
+		libxfs_btree_init_block(mp, lptr->buf_p, XFS_REFC_CRC_MAGIC,
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
+			prop_refc_cursor(mp, agno, btree_curs,
+					refc_rec->rc_startblock, 0);
+
+		bt_rec = (struct xfs_refcount_rec *)
+			  ((char *)bt_hdr + XFS_REFCOUNT_BLOCK_LEN);
+		for (j = 0; j < be16_to_cpu(bt_hdr->bb_numrecs); j++) {
+			ASSERT(refc_rec != NULL);
+			bt_rec[j].rc_startblock =
+					cpu_to_be32(refc_rec->rc_startblock);
+			bt_rec[j].rc_blockcount =
+					cpu_to_be32(refc_rec->rc_blockcount);
+			bt_rec[j].rc_refcount = cpu_to_be32(refc_rec->rc_refcount);
+
+			refc_rec = pop_slab_cursor(refc_cur);
+		}
+
+		if (refc_rec != NULL)  {
+			/*
+			 * get next leaf level block
+			 */
+			if (lptr->prev_buf_p != NULL)  {
+#ifdef XR_BLD_RL_TRACE
+				fprintf(stderr, "writing refcntbt agbno %u\n",
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
+	free_slab_cursor(&refc_cur);
+}
+
 /*
  * build both the agf and the agfl for an agno given both
  * btree cursors.
@@ -1706,7 +1997,8 @@ build_agf_agfl(
 	struct bt_status	*bcnt_bt,
 	xfs_extlen_t		freeblks,	/* # free blocks in tree */
 	int			lostblocks,	/* # blocks that will be lost */
-	struct bt_status	*rmap_bt)
+	struct bt_status	*rmap_bt,
+	struct bt_status	*refcnt_bt)
 {
 	struct extent_tree_node	*ext_ptr;
 	struct xfs_buf		*agf_buf, *agfl_buf;
@@ -1750,6 +2042,10 @@ build_agf_agfl(
 	agf->agf_freeblks = cpu_to_be32(freeblks);
 	agf->agf_rmap_blocks = cpu_to_be32(rmap_bt->num_tot_blocks -
 			rmap_bt->num_free_blocks);
+	agf->agf_refcount_root = cpu_to_be32(refcnt_bt->root);
+	agf->agf_refcount_level = cpu_to_be32(refcnt_bt->num_levels);
+	agf->agf_refcount_blocks = cpu_to_be32(refcnt_bt->num_tot_blocks -
+			refcnt_bt->num_free_blocks);
 
 	/*
 	 * Count and record the number of btree blocks consumed if required.
@@ -1867,6 +2163,10 @@ build_agf_agfl(
 
 	ASSERT(be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNOi]) !=
 		be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNTi]));
+	ASSERT(be32_to_cpu(agf->agf_refcount_root) !=
+		be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNOi]));
+	ASSERT(be32_to_cpu(agf->agf_refcount_root) !=
+		be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNTi]));
 
 	libxfs_writebuf(agf_buf, 0);
 
@@ -1936,6 +2236,7 @@ phase5_func(
 	bt_status_t	ino_btree_curs;
 	bt_status_t	fino_btree_curs;
 	bt_status_t	rmap_btree_curs;
+	bt_status_t	refcnt_btree_curs;
 	int		extra_blocks = 0;
 	uint		num_freeblocks;
 	xfs_extlen_t	freeblks1;
@@ -1998,6 +2299,12 @@ phase5_func(
 		 */
 		init_rmapbt_cursor(mp, agno, &rmap_btree_curs);
 
+		/*
+		 * Set up the btree cursors for the on-disk refcount btrees,
+		 * which includes pre-allocating all required blocks.
+		 */
+		init_refc_cursor(mp, agno, &refcnt_btree_curs);
+
 		num_extents = count_bno_extents_blocks(agno, &num_freeblocks);
 		/*
 		 * lose two blocks per AG -- the space tree roots
@@ -2091,12 +2398,17 @@ phase5_func(
 					rmap_btree_curs.num_free_blocks) - 1;
 		}
 
+		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+			build_refcount_tree(mp, agno, &refcnt_btree_curs);
+			write_cursor(&refcnt_btree_curs);
+		}
+
 		/*
 		 * set up agf and agfl
 		 */
 		build_agf_agfl(mp, agno, &bno_btree_curs,
 				&bcnt_btree_curs, freeblks1, extra_blocks,
-				&rmap_btree_curs);
+				&rmap_btree_curs, &refcnt_btree_curs);
 		/*
 		 * build inode allocation tree.
 		 */
@@ -2127,6 +2439,8 @@ phase5_func(
 		finish_cursor(&ino_btree_curs);
 		if (xfs_sb_version_hasrmapbt(&mp->m_sb))
 			finish_cursor(&rmap_btree_curs);
+		if (xfs_sb_version_hasreflink(&mp->m_sb))
+			finish_cursor(&refcnt_btree_curs);
 		if (xfs_sb_version_hasfinobt(&mp->m_sb))
 			finish_cursor(&fino_btree_curs);
 		finish_cursor(&bcnt_btree_curs);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
