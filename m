Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED782C47257
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2D942184D
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:32:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vIAduXbr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgEIQcf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:32:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50650 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727863AbgEIQcf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:32:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GMgul072459;
        Sat, 9 May 2020 16:32:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ys9KUvXTN0RIL9G0eOWQ6cnCkd6EvJArsRfkrqpJAsg=;
 b=vIAduXbrlGxzoTbvavHFu2NaQA65t9C1HD2iO0snRD3Ijf26JNrussipd4xEgLwEIbVp
 w8VTTiz9XbUx0axwb/FohmncXOdU2Pb4nlywZ6gWrOJwEbglOk2JurgrcDH0iURcDo3s
 awTFTwF7x8IPtXNq/BACLFi1KdiiS8nfJ/XHsikmrjeac92JHgTjUt7fQPYxU7tCbfrj
 P5XIynp3UkKi8yVl84v8eu+S4HSRTi/Oqj5HD8fRMCGNLMUVWQ9v4eqsApToLAMrPxn6
 EQbFuoqg628RjWszePy3KPZEbnENb+JnnkBbe1Hk9a5GCiu3Syl0/VWwPDwCgtOOFrzR Yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30wkxqs6hd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:32:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GRbCG132470;
        Sat, 9 May 2020 16:32:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30wwxb5jta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:32:28 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 049GWRfs005224;
        Sat, 9 May 2020 16:32:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 09:32:27 -0700
Subject: [PATCH 7/9] xfs_repair: rebuild refcount btrees with bulk loader
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Sat, 09 May 2020 09:32:27 -0700
Message-ID: <158904194756.984305.3705661929019376198.stgit@magnolia>
In-Reply-To: <158904190079.984305.707785748675261111.stgit@magnolia>
References: <158904190079.984305.707785748675261111.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=2 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 suspectscore=2 phishscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the btree bulk loading functions to rebuild the refcount btrees
and drop the open-coded implementation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    1 
 repair/phase5.c          |  356 ++++++++--------------------------------------
 2 files changed, 66 insertions(+), 291 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 0026ca45..1a7cdbf9 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -135,6 +135,7 @@
 #define xfs_refcountbt_calc_reserves	libxfs_refcountbt_calc_reserves
 #define xfs_refcountbt_init_cursor	libxfs_refcountbt_init_cursor
 #define xfs_refcountbt_maxrecs		libxfs_refcountbt_maxrecs
+#define xfs_refcountbt_stage_cursor	libxfs_refcountbt_stage_cursor
 #define xfs_refcount_get_rec		libxfs_refcount_get_rec
 #define xfs_refcount_lookup_le		libxfs_refcount_lookup_le
 
diff --git a/repair/phase5.c b/repair/phase5.c
index 9c43100f..6efc0613 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -1149,309 +1149,80 @@ _("Error %d while writing rmap btree for AG %u.\n"), error, agno);
 
 /* rebuild the refcount tree */
 
-/*
- * we don't have to worry here about how chewing up free extents
- * may perturb things because reflink tree building happens before
- * freespace tree building.
- */
+/* Set up the refcount rebuild parameters. */
 static void
 init_refc_cursor(
-	struct xfs_mount	*mp,
+	struct repair_ctx	*sc,
 	xfs_agnumber_t		agno,
-	struct bt_status	*btree_curs)
+	unsigned int		free_space,
+	struct bt_rebuild	*btr)
 {
-	size_t			num_recs;
-	int			level;
-	struct bt_stat_level	*lptr;
-	struct bt_stat_level	*p_lptr;
-	xfs_extlen_t		blocks_allocated;
-
-	if (!xfs_sb_version_hasreflink(&mp->m_sb)) {
-		memset(btree_curs, 0, sizeof(struct bt_status));
-		return;
-	}
-
-	lptr = &btree_curs->level[0];
-	btree_curs->init = 1;
-	btree_curs->owner = XFS_RMAP_OWN_REFC;
-
-	/*
-	 * build up statistics
-	 */
-	num_recs = refcount_record_count(mp, agno);
-	if (num_recs == 0) {
-		/*
-		 * easy corner-case -- no refcount records
-		 */
-		lptr->num_blocks = 1;
-		lptr->modulo = 0;
-		lptr->num_recs_pb = 0;
-		lptr->num_recs_tot = 0;
-
-		btree_curs->num_levels = 1;
-		btree_curs->num_tot_blocks = btree_curs->num_free_blocks = 1;
-
-		setup_cursor(mp, agno, btree_curs);
-
-		return;
-	}
+	int			error;
 
-	blocks_allocated = lptr->num_blocks = howmany(num_recs,
-					mp->m_refc_mxr[0]);
-
-	lptr->modulo = num_recs % lptr->num_blocks;
-	lptr->num_recs_pb = num_recs / lptr->num_blocks;
-	lptr->num_recs_tot = num_recs;
-	level = 1;
-
-	if (lptr->num_blocks > 1)  {
-		for (; btree_curs->level[level-1].num_blocks > 1
-				&& level < XFS_BTREE_MAXLEVELS;
-				level++)  {
-			lptr = &btree_curs->level[level];
-			p_lptr = &btree_curs->level[level - 1];
-			lptr->num_blocks = howmany(p_lptr->num_blocks,
-					mp->m_refc_mxr[1]);
-			lptr->modulo = p_lptr->num_blocks % lptr->num_blocks;
-			lptr->num_recs_pb = p_lptr->num_blocks
-					/ lptr->num_blocks;
-			lptr->num_recs_tot = p_lptr->num_blocks;
-
-			blocks_allocated += lptr->num_blocks;
-		}
-	}
-	ASSERT(lptr->num_blocks == 1);
-	btree_curs->num_levels = level;
+	init_rebuild(sc, &XFS_RMAP_OINFO_REFC, free_space, btr);
+	btr->cur = libxfs_refcountbt_stage_cursor(sc->mp, &btr->newbt.afake,
+			agno);
 
-	btree_curs->num_tot_blocks = btree_curs->num_free_blocks
-			= blocks_allocated;
+	/* Compute how many blocks we'll need. */
+	error = -libxfs_btree_bload_compute_geometry(btr->cur, &btr->bload,
+			refcount_record_count(sc->mp, agno));
+	if (error)
+		do_error(
+_("Unable to compute refcount btree geometry, error %d.\n"), error);
 
-	setup_cursor(mp, agno, btree_curs);
+	setup_rebuild(sc->mp, agno, btr, btr->bload.nr_blocks);
 }
 
-static void
-prop_refc_cursor(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
-	struct bt_status	*btree_curs,
-	xfs_agblock_t		startbno,
-	int			level)
+/* Grab one refcount record. */
+static int
+get_refcountbt_record(
+	struct xfs_btree_cur		*cur,
+	void				*priv)
 {
-	struct xfs_btree_block	*bt_hdr;
-	struct xfs_refcount_key	*bt_key;
-	xfs_refcount_ptr_t	*bt_ptr;
-	xfs_agblock_t		agbno;
-	struct bt_stat_level	*lptr;
-	const struct xfs_buf_ops *ops = btnum_to_ops(XFS_BTNUM_REFC);
-	int			error;
-
-	level++;
-
-	if (level >= btree_curs->num_levels)
-		return;
-
-	lptr = &btree_curs->level[level];
-	bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
-
-	if (be16_to_cpu(bt_hdr->bb_numrecs) == 0)  {
-		/*
-		 * this only happens once to initialize the
-		 * first path up the left side of the tree
-		 * where the agbno's are already set up
-		 */
-		prop_refc_cursor(mp, agno, btree_curs, startbno, level);
-	}
-
-	if (be16_to_cpu(bt_hdr->bb_numrecs) ==
-				lptr->num_recs_pb + (lptr->modulo > 0))  {
-		/*
-		 * write out current prev block, grab us a new block,
-		 * and set the rightsib pointer of current block
-		 */
-#ifdef XR_BLD_INO_TRACE
-		fprintf(stderr, " ino prop agbno %d ", lptr->prev_agbno);
-#endif
-		if (lptr->prev_agbno != NULLAGBLOCK)  {
-			ASSERT(lptr->prev_buf_p != NULL);
-			libxfs_buf_mark_dirty(lptr->prev_buf_p);
-			libxfs_buf_relse(lptr->prev_buf_p);
-		}
-		lptr->prev_agbno = lptr->agbno;
-		lptr->prev_buf_p = lptr->buf_p;
-		agbno = get_next_blockaddr(agno, level, btree_curs);
-
-		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(agbno);
-
-		error = -libxfs_buf_get(mp->m_dev,
-				XFS_AGB_TO_DADDR(mp, agno, agbno),
-				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
-		if (error)
-			do_error(_("Cannot grab refcountbt buffer, err=%d"),
-					error);
-		lptr->agbno = agbno;
-
-		if (lptr->modulo)
-			lptr->modulo--;
-
-		/*
-		 * initialize block header
-		 */
-		lptr->buf_p->b_ops = ops;
-		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
-		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
-		libxfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_REFC,
-					level, 0, agno);
-
-		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
-
-		/*
-		 * propagate extent record for first extent in new block up
-		 */
-		prop_refc_cursor(mp, agno, btree_curs, startbno, level);
-	}
-	/*
-	 * add inode info to current block
-	 */
-	be16_add_cpu(&bt_hdr->bb_numrecs, 1);
-
-	bt_key = XFS_REFCOUNT_KEY_ADDR(bt_hdr,
-				    be16_to_cpu(bt_hdr->bb_numrecs));
-	bt_ptr = XFS_REFCOUNT_PTR_ADDR(bt_hdr,
-				    be16_to_cpu(bt_hdr->bb_numrecs),
-				    mp->m_refc_mxr[1]);
+	struct xfs_refcount_irec	*rec;
+	struct bt_rebuild		*btr = priv;
 
-	bt_key->rc_startblock = cpu_to_be32(startbno);
-	*bt_ptr = cpu_to_be32(btree_curs->level[level-1].agbno);
+	rec = pop_slab_cursor(btr->slab_cursor);
+	memcpy(&cur->bc_rec.rc, rec, sizeof(struct xfs_refcount_irec));
+	return 0;
 }
 
-/*
- * rebuilds a refcount btree given a cursor.
- */
+/* Rebuild a refcount btree. */
 static void
 build_refcount_tree(
-	struct xfs_mount	*mp,
+	struct repair_ctx	*sc,
 	xfs_agnumber_t		agno,
-	struct bt_status	*btree_curs)
+	struct bt_rebuild	*btr)
 {
-	xfs_agnumber_t		i;
-	xfs_agblock_t		j;
-	xfs_agblock_t		agbno;
-	struct xfs_btree_block	*bt_hdr;
-	struct xfs_refcount_irec	*refc_rec;
-	struct xfs_slab_cursor	*refc_cur;
-	struct xfs_refcount_rec	*bt_rec;
-	struct bt_stat_level	*lptr;
-	const struct xfs_buf_ops *ops = btnum_to_ops(XFS_BTNUM_REFC);
-	int			numrecs;
-	int			level = btree_curs->num_levels;
 	int			error;
 
-	for (i = 0; i < level; i++)  {
-		lptr = &btree_curs->level[i];
-
-		agbno = get_next_blockaddr(agno, i, btree_curs);
-		error = -libxfs_buf_get(mp->m_dev,
-				XFS_AGB_TO_DADDR(mp, agno, agbno),
-				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
-		if (error)
-			do_error(_("Cannot grab refcountbt buffer, err=%d"),
-					error);
-
-		if (i == btree_curs->num_levels - 1)
-			btree_curs->root = agbno;
-
-		lptr->agbno = agbno;
-		lptr->prev_agbno = NULLAGBLOCK;
-		lptr->prev_buf_p = NULL;
-		/*
-		 * initialize block header
-		 */
-
-		lptr->buf_p->b_ops = ops;
-		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
-		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
-		libxfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_REFC,
-					i, 0, agno);
-	}
+	btr->bload.get_record = get_refcountbt_record;
+	btr->bload.claim_block = rebuild_claim_block;
 
-	/*
-	 * run along leaf, setting up records.  as we have to switch
-	 * blocks, call the prop_refc_cursor routine to set up the new
-	 * pointers for the parent.  that can recurse up to the root
-	 * if required.  set the sibling pointers for leaf level here.
-	 */
-	error = init_refcount_cursor(agno, &refc_cur);
+	error = -libxfs_trans_alloc_empty(sc->mp, &sc->tp);
 	if (error)
 		do_error(
-_("Insufficient memory to construct refcount cursor."));
-	refc_rec = pop_slab_cursor(refc_cur);
-	lptr = &btree_curs->level[0];
+_("Insufficient memory to construct refcount rebuild transaction.\n"));
 
-	for (i = 0; i < lptr->num_blocks; i++)  {
-		numrecs = lptr->num_recs_pb + (lptr->modulo > 0);
-		ASSERT(refc_rec != NULL || numrecs == 0);
+	error = init_refcount_cursor(agno, &btr->slab_cursor);
+	if (error)
+		do_error(
+_("Insufficient memory to construct refcount cursor.\n"));
 
-		/*
-		 * block initialization, lay in block header
-		 */
-		lptr->buf_p->b_ops = ops;
-		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
-		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
-		libxfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_REFC,
-					0, 0, agno);
-
-		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
-		bt_hdr->bb_numrecs = cpu_to_be16(numrecs);
-
-		if (lptr->modulo > 0)
-			lptr->modulo--;
-
-		if (lptr->num_recs_pb > 0)
-			prop_refc_cursor(mp, agno, btree_curs,
-					refc_rec->rc_startblock, 0);
-
-		bt_rec = (struct xfs_refcount_rec *)
-			  ((char *)bt_hdr + XFS_REFCOUNT_BLOCK_LEN);
-		for (j = 0; j < be16_to_cpu(bt_hdr->bb_numrecs); j++) {
-			ASSERT(refc_rec != NULL);
-			bt_rec[j].rc_startblock =
-					cpu_to_be32(refc_rec->rc_startblock);
-			bt_rec[j].rc_blockcount =
-					cpu_to_be32(refc_rec->rc_blockcount);
-			bt_rec[j].rc_refcount = cpu_to_be32(refc_rec->rc_refcount);
-
-			refc_rec = pop_slab_cursor(refc_cur);
-		}
+	/* Add all observed refcount records. */
+	error = -libxfs_btree_bload(btr->cur, &btr->bload, btr);
+	if (error)
+		do_error(
+_("Error %d while creating refcount btree for AG %u.\n"), error, agno);
 
-		if (refc_rec != NULL)  {
-			/*
-			 * get next leaf level block
-			 */
-			if (lptr->prev_buf_p != NULL)  {
-#ifdef XR_BLD_RL_TRACE
-				fprintf(stderr, "writing refcntbt agbno %u\n",
-					lptr->prev_agbno);
-#endif
-				ASSERT(lptr->prev_agbno != NULLAGBLOCK);
-				libxfs_buf_mark_dirty(lptr->prev_buf_p);
-				libxfs_buf_relse(lptr->prev_buf_p);
-			}
-			lptr->prev_buf_p = lptr->buf_p;
-			lptr->prev_agbno = lptr->agbno;
-			lptr->agbno = get_next_blockaddr(agno, 0, btree_curs);
-			bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(lptr->agbno);
-
-			error = -libxfs_buf_get(mp->m_dev,
-					XFS_AGB_TO_DADDR(mp, agno, lptr->agbno),
-					XFS_FSB_TO_BB(mp, 1),
-					&lptr->buf_p);
-			if (error)
-				do_error(
-	_("Cannot grab refcountbt buffer, err=%d"),
-						error);
-		}
-	}
-	free_slab_cursor(&refc_cur);
+	/* Since we're not writing the AGF yet, no need to commit the cursor */
+	libxfs_btree_del_cursor(btr->cur, 0);
+	free_slab_cursor(&btr->slab_cursor);
+	error = -libxfs_trans_commit(sc->tp);
+	if (error)
+		do_error(
+_("Error %d while writing refcount btree for AG %u.\n"), error, agno);
+	sc->tp = NULL;
 }
 
 /* Fill the AGFL with any leftover bnobt rebuilder blocks. */
@@ -1490,7 +1261,7 @@ build_agf_agfl(
 	xfs_extlen_t		freeblks,	/* # free blocks in tree */
 	int			lostblocks,	/* # blocks that will be lost */
 	struct bt_rebuild	*btr_rmap,
-	struct bt_status	*refcnt_bt,
+	struct bt_rebuild	*btr_refc,
 	struct xfs_slab		*lost_fsb)
 {
 	struct extent_tree_node	*ext_ptr;
@@ -1548,10 +1319,14 @@ build_agf_agfl(
 				cpu_to_be32(btr_rmap->newbt.afake.af_blocks);
 	}
 
-	agf->agf_refcount_root = cpu_to_be32(refcnt_bt->root);
-	agf->agf_refcount_level = cpu_to_be32(refcnt_bt->num_levels);
-	agf->agf_refcount_blocks = cpu_to_be32(refcnt_bt->num_tot_blocks -
-			refcnt_bt->num_free_blocks);
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		agf->agf_refcount_root =
+				cpu_to_be32(btr_refc->newbt.afake.af_root);
+		agf->agf_refcount_level =
+				cpu_to_be32(btr_refc->newbt.afake.af_levels);
+		agf->agf_refcount_blocks =
+				cpu_to_be32(btr_refc->newbt.afake.af_blocks);
+	}
 
 	/*
 	 * Count and record the number of btree blocks consumed if required.
@@ -1715,7 +1490,7 @@ phase5_func(
 	struct bt_rebuild	btr_ino;
 	struct bt_rebuild	btr_fino;
 	struct bt_rebuild	btr_rmap;
-	bt_status_t		refcnt_btree_curs;
+	struct bt_rebuild	btr_refc;
 	int			extra_blocks = 0;
 	uint			num_freeblocks;
 	xfs_extlen_t		freeblks1;
@@ -1765,7 +1540,8 @@ phase5_func(
 	 * Set up the btree cursors for the on-disk refcount btrees,
 	 * which includes pre-allocating all required blocks.
 	 */
-	init_refc_cursor(mp, agno, &refcnt_btree_curs);
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		init_refc_cursor(&sc, agno, num_freeblocks, &btr_refc);
 
 	num_extents = count_bno_extents_blocks(agno, &num_freeblocks);
 	/*
@@ -1836,16 +1612,14 @@ phase5_func(
 		sb_fdblocks_ag[agno] += btr_rmap.newbt.afake.af_blocks - 1;
 	}
 
-	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
-		build_refcount_tree(mp, agno, &refcnt_btree_curs);
-		write_cursor(&refcnt_btree_curs);
-	}
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		build_refcount_tree(&sc, agno, &btr_refc);
 
 	/*
 	 * set up agf and agfl
 	 */
 	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, freeblks1, extra_blocks,
-			&btr_rmap, &refcnt_btree_curs, lost_fsb);
+			&btr_rmap, &btr_refc, lost_fsb);
 
 	/*
 	 * build inode allocation trees.
@@ -1868,7 +1642,7 @@ phase5_func(
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
 		finish_rebuild(mp, &btr_rmap, lost_fsb);
 	if (xfs_sb_version_hasreflink(&mp->m_sb))
-		finish_cursor(&refcnt_btree_curs);
+		finish_rebuild(mp, &btr_refc, lost_fsb);
 
 	/*
 	 * release the incore per-AG bno/bcnt trees so

