Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8EB2C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E9B920738
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:28:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tf/ulwwr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgFBE2G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:28:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47334 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgFBE2F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:28:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524I2EW121428;
        Tue, 2 Jun 2020 04:28:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=RdHuP5vgNBMny5YlloLaWCKCKxloHgZbWeB6TvhEPcM=;
 b=tf/ulwwrToxDVd//bCx9M883Im33p0j9pSOAMzfCUwvs+0vjre9k02lLON4w+u/mNMbl
 3mO5KGKc/+el2X2Y+umdluRFFWsHG3gYwBNKNEXvNJYiGxShngWOpCUg5BBMhSfqWSK1
 vdDolx/YDR1rbXc/nqsN2oidsDFkYWXzgjwOEQG/BwLfzWVb8qmnnvo0Z67/5hY5Oa4E
 eNA9t90DDzGYKoIr5KUo/zeXQ4+9l9cmAKxVA7XbePhUEVbOrw0CQa6ykhcABmZcvM3D
 qgi/9Q1IDXUNpzVh93IEHJLxTVl69c+GudZqggrIk90mb7s6sIfjP7xSmMtT9xZICCK+ qg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31d5qr20su-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:28:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524JNPo102258;
        Tue, 2 Jun 2020 04:27:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 31c12ng59c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:27:59 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0524RxkZ022072;
        Tue, 2 Jun 2020 04:27:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:27:58 -0700
Subject: [PATCH 10/12] xfs_repair: rebuild refcount btrees with bulk loader
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 01 Jun 2020 21:27:57 -0700
Message-ID: <159107207766.315004.3208486320108630923.stgit@magnolia>
In-Reply-To: <159107201290.315004.4447998785149331259.stgit@magnolia>
References: <159107201290.315004.4447998785149331259.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=2 spamscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 cotscore=-2147483648
 mlxscore=0 lowpriorityscore=0 suspectscore=2 spamscore=0 adultscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020024
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
 repair/agbtree.c         |   71 ++++++++++
 repair/agbtree.h         |    5 +
 repair/phase5.c          |  341 ++--------------------------------------------
 4 files changed, 93 insertions(+), 325 deletions(-)


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
 
diff --git a/repair/agbtree.c b/repair/agbtree.c
index 7b075a52..d3639fe4 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -585,3 +585,74 @@ _("Error %d while creating rmap btree for AG %u.\n"), error, agno);
 	libxfs_btree_del_cursor(btr->cur, 0);
 	free_slab_cursor(&btr->slab_cursor);
 }
+
+/* rebuild the refcount tree */
+
+/* Grab one refcount record. */
+static int
+get_refcountbt_record(
+	struct xfs_btree_cur		*cur,
+	void				*priv)
+{
+	struct xfs_refcount_irec	*rec;
+	struct bt_rebuild		*btr = priv;
+
+	rec = pop_slab_cursor(btr->slab_cursor);
+	memcpy(&cur->bc_rec.rc, rec, sizeof(struct xfs_refcount_irec));
+	return 0;
+}
+
+/* Set up the refcount rebuild parameters. */
+void
+init_refc_cursor(
+	struct repair_ctx	*sc,
+	xfs_agnumber_t		agno,
+	unsigned int		free_space,
+	struct bt_rebuild	*btr)
+{
+	int			error;
+
+	if (!xfs_sb_version_hasreflink(&sc->mp->m_sb))
+		return;
+
+	init_rebuild(sc, &XFS_RMAP_OINFO_REFC, free_space, btr);
+	btr->cur = libxfs_refcountbt_stage_cursor(sc->mp, &btr->newbt.afake,
+			agno);
+
+	btr->bload.get_record = get_refcountbt_record;
+	btr->bload.claim_block = rebuild_claim_block;
+
+	/* Compute how many blocks we'll need. */
+	error = -libxfs_btree_bload_compute_geometry(btr->cur, &btr->bload,
+			refcount_record_count(sc->mp, agno));
+	if (error)
+		do_error(
+_("Unable to compute refcount btree geometry, error %d.\n"), error);
+
+	reserve_btblocks(sc->mp, agno, btr, btr->bload.nr_blocks);
+}
+
+/* Rebuild a refcount btree. */
+void
+build_refcount_tree(
+	struct repair_ctx	*sc,
+	xfs_agnumber_t		agno,
+	struct bt_rebuild	*btr)
+{
+	int			error;
+
+	error = init_refcount_cursor(agno, &btr->slab_cursor);
+	if (error)
+		do_error(
+_("Insufficient memory to construct refcount cursor.\n"));
+
+	/* Add all observed refcount records. */
+	error = -libxfs_btree_bload(btr->cur, &btr->bload, btr);
+	if (error)
+		do_error(
+_("Error %d while creating refcount btree for AG %u.\n"), error, agno);
+
+	/* Since we're not writing the AGF yet, no need to commit the cursor */
+	libxfs_btree_del_cursor(btr->cur, 0);
+	free_slab_cursor(&btr->slab_cursor);
+}
diff --git a/repair/agbtree.h b/repair/agbtree.h
index ca6e70de..6bbeb022 100644
--- a/repair/agbtree.h
+++ b/repair/agbtree.h
@@ -54,4 +54,9 @@ void init_rmapbt_cursor(struct repair_ctx *sc, xfs_agnumber_t agno,
 void build_rmap_tree(struct repair_ctx *sc, xfs_agnumber_t agno,
 		struct bt_rebuild *btr);
 
+void init_refc_cursor(struct repair_ctx *sc, xfs_agnumber_t agno,
+		unsigned int free_space, struct bt_rebuild *btr);
+void build_refcount_tree(struct repair_ctx *sc, xfs_agnumber_t agno,
+		struct bt_rebuild *btr);
+
 #endif /* __XFS_REPAIR_AG_BTREE_H__ */
diff --git a/repair/phase5.c b/repair/phase5.c
index 1c6448f4..ad009416 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -417,313 +417,6 @@ build_agi(
 	libxfs_buf_relse(agi_buf);
 }
 
-/* rebuild the refcount tree */
-
-/*
- * we don't have to worry here about how chewing up free extents
- * may perturb things because reflink tree building happens before
- * freespace tree building.
- */
-static void
-init_refc_cursor(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
-	struct bt_status	*btree_curs)
-{
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
-
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
-
-	btree_curs->num_tot_blocks = btree_curs->num_free_blocks
-			= blocks_allocated;
-
-	setup_cursor(mp, agno, btree_curs);
-}
-
-static void
-prop_refc_cursor(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
-	struct bt_status	*btree_curs,
-	xfs_agblock_t		startbno,
-	int			level)
-{
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
-
-	bt_key->rc_startblock = cpu_to_be32(startbno);
-	*bt_ptr = cpu_to_be32(btree_curs->level[level-1].agbno);
-}
-
-/*
- * rebuilds a refcount btree given a cursor.
- */
-static void
-build_refcount_tree(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
-	struct bt_status	*btree_curs)
-{
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
-	int			error;
-
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
-
-	/*
-	 * run along leaf, setting up records.  as we have to switch
-	 * blocks, call the prop_refc_cursor routine to set up the new
-	 * pointers for the parent.  that can recurse up to the root
-	 * if required.  set the sibling pointers for leaf level here.
-	 */
-	error = init_refcount_cursor(agno, &refc_cur);
-	if (error)
-		do_error(
-_("Insufficient memory to construct refcount cursor."));
-	refc_rec = pop_slab_cursor(refc_cur);
-	lptr = &btree_curs->level[0];
-
-	for (i = 0; i < lptr->num_blocks; i++)  {
-		numrecs = lptr->num_recs_pb + (lptr->modulo > 0);
-		ASSERT(refc_rec != NULL || numrecs == 0);
-
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
-
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
-}
-
 /* Fill the AGFL with any leftover bnobt rebuilder blocks. */
 static void
 fill_agfl(
@@ -759,7 +452,7 @@ build_agf_agfl(
 	struct bt_rebuild	*btr_bno,
 	struct bt_rebuild	*btr_cnt,
 	struct bt_rebuild	*btr_rmap,
-	struct bt_status	*refcnt_bt,
+	struct bt_rebuild	*btr_refc,
 	struct xfs_slab		*lost_fsb)
 {
 	struct extent_tree_node	*ext_ptr;
@@ -817,10 +510,14 @@ build_agf_agfl(
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
@@ -981,7 +678,7 @@ phase5_func(
 	struct bt_rebuild	btr_ino;
 	struct bt_rebuild	btr_fino;
 	struct bt_rebuild	btr_rmap;
-	bt_status_t		refcnt_btree_curs;
+	struct bt_rebuild	btr_refc;
 	int			extra_blocks = 0;
 	uint			num_freeblocks;
 	xfs_agblock_t		num_extents;
@@ -1017,11 +714,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 
 	init_rmapbt_cursor(&sc, agno, num_freeblocks, &btr_rmap);
 
-	/*
-	 * Set up the btree cursors for the on-disk refcount btrees,
-	 * which includes pre-allocating all required blocks.
-	 */
-	init_refc_cursor(mp, agno, &refcnt_btree_curs);
+	init_refc_cursor(&sc, agno, num_freeblocks, &btr_refc);
 
 	num_extents = count_bno_extents_blocks(agno, &num_freeblocks);
 	/*
@@ -1085,16 +778,14 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
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
-	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, &btr_rmap,
-			&refcnt_btree_curs, lost_fsb);
+	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, &btr_rmap, &btr_refc,
+			lost_fsb);
 
 	build_inode_btrees(&sc, agno, &btr_ino, &btr_fino);
 
@@ -1112,7 +803,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
 		finish_rebuild(mp, &btr_rmap, lost_fsb);
 	if (xfs_sb_version_hasreflink(&mp->m_sb))
-		finish_cursor(&refcnt_btree_curs);
+		finish_rebuild(mp, &btr_refc, lost_fsb);
 
 	/*
 	 * release the incore per-AG bno/bcnt trees so the extent nodes

