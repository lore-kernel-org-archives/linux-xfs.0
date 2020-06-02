Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C092C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D656206C3
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:28:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KjiqewOi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgFBE2C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:28:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47272 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgFBE2B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:28:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524IOAA121700;
        Tue, 2 Jun 2020 04:27:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4r/hruD/abG184F6va01aLpp/9fwyUvOy9gEAKMvUQE=;
 b=KjiqewOi5CMC5uFl7qsDZ6Oyi6703VM/1xrAqMDbLlVeh/386h2ie/9dW/8AGGDiNedc
 1xLvfvK5lBLL/C7DN5yjHZkf81J2qmjGfcnnlb3Vg1Qhb5f+RwnHcKDWNEr4AZh7TVOd
 oeb8VMYYhcSVup42U+C6h4/TdZRI+7cAWisiotLTPXDwvAs6dCrHHr8EPnNU05R4Qngt
 H6YfX2LyrhuTt5K5Xlp4Ly/PFpKauz7jgmDsni+3+BmdEThYVtLf/BBRtYiYMaotuKE1
 cg9vEAsPxzl5jh37re7ZhnHrVI57eLhx2H9lX3tZrnWpPAaIwiEm0QGDeshvQcgqLwcp sw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31d5qr20sk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:27:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524HwRh127107;
        Tue, 2 Jun 2020 04:27:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31c25mnm2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:27:53 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0524Rqx7021708;
        Tue, 2 Jun 2020 04:27:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:27:52 -0700
Subject: [PATCH 09/12] xfs_repair: rebuild reverse mapping btrees with bulk
 loader
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 01 Jun 2020 21:27:51 -0700
Message-ID: <159107207124.315004.2948634653215669449.stgit@magnolia>
In-Reply-To: <159107201290.315004.4447998785149331259.stgit@magnolia>
References: <159107201290.315004.4447998785149331259.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=2 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
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

Use the btree bulk loading functions to rebuild the reverse mapping
btrees and drop the open-coded implementation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    1 
 repair/agbtree.c         |   70 ++++++++
 repair/agbtree.h         |    5 +
 repair/phase5.c          |  409 ++--------------------------------------------
 4 files changed, 96 insertions(+), 389 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 5d0868c2..0026ca45 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -142,6 +142,7 @@
 #define xfs_rmapbt_calc_reserves	libxfs_rmapbt_calc_reserves
 #define xfs_rmapbt_init_cursor		libxfs_rmapbt_init_cursor
 #define xfs_rmapbt_maxrecs		libxfs_rmapbt_maxrecs
+#define xfs_rmapbt_stage_cursor		libxfs_rmapbt_stage_cursor
 #define xfs_rmap_compare		libxfs_rmap_compare
 #define xfs_rmap_get_rec		libxfs_rmap_get_rec
 #define xfs_rmap_irec_offset_pack	libxfs_rmap_irec_offset_pack
diff --git a/repair/agbtree.c b/repair/agbtree.c
index e44475fc..7b075a52 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -515,3 +515,73 @@ _("Error %d while creating finobt btree for AG %u.\n"), error, agno);
 	/* Since we're not writing the AGI yet, no need to commit the cursor */
 	libxfs_btree_del_cursor(btr_fino->cur, 0);
 }
+
+/* rebuild the rmap tree */
+
+/* Grab one rmap record. */
+static int
+get_rmapbt_record(
+	struct xfs_btree_cur		*cur,
+	void				*priv)
+{
+	struct xfs_rmap_irec		*rec;
+	struct bt_rebuild		*btr = priv;
+
+	rec = pop_slab_cursor(btr->slab_cursor);
+	memcpy(&cur->bc_rec.r, rec, sizeof(struct xfs_rmap_irec));
+	return 0;
+}
+
+/* Set up the rmap rebuild parameters. */
+void
+init_rmapbt_cursor(
+	struct repair_ctx	*sc,
+	xfs_agnumber_t		agno,
+	unsigned int		free_space,
+	struct bt_rebuild	*btr)
+{
+	int			error;
+
+	if (!xfs_sb_version_hasrmapbt(&sc->mp->m_sb))
+		return;
+
+	init_rebuild(sc, &XFS_RMAP_OINFO_AG, free_space, btr);
+	btr->cur = libxfs_rmapbt_stage_cursor(sc->mp, &btr->newbt.afake, agno);
+
+	btr->bload.get_record = get_rmapbt_record;
+	btr->bload.claim_block = rebuild_claim_block;
+
+	/* Compute how many blocks we'll need. */
+	error = -libxfs_btree_bload_compute_geometry(btr->cur, &btr->bload,
+			rmap_record_count(sc->mp, agno));
+	if (error)
+		do_error(
+_("Unable to compute rmap btree geometry, error %d.\n"), error);
+
+	reserve_btblocks(sc->mp, agno, btr, btr->bload.nr_blocks);
+}
+
+/* Rebuild a rmap btree. */
+void
+build_rmap_tree(
+	struct repair_ctx	*sc,
+	xfs_agnumber_t		agno,
+	struct bt_rebuild	*btr)
+{
+	int			error;
+
+	error = rmap_init_cursor(agno, &btr->slab_cursor);
+	if (error)
+		do_error(
+_("Insufficient memory to construct rmap cursor.\n"));
+
+	/* Add all observed rmap records. */
+	error = -libxfs_btree_bload(btr->cur, &btr->bload, btr);
+	if (error)
+		do_error(
+_("Error %d while creating rmap btree for AG %u.\n"), error, agno);
+
+	/* Since we're not writing the AGF yet, no need to commit the cursor */
+	libxfs_btree_del_cursor(btr->cur, 0);
+	free_slab_cursor(&btr->slab_cursor);
+}
diff --git a/repair/agbtree.h b/repair/agbtree.h
index 3cad2a8e..ca6e70de 100644
--- a/repair/agbtree.h
+++ b/repair/agbtree.h
@@ -49,4 +49,9 @@ void init_ino_cursors(struct repair_ctx *sc, xfs_agnumber_t agno,
 void build_inode_btrees(struct repair_ctx *sc, xfs_agnumber_t agno,
 		struct bt_rebuild *btr_ino, struct bt_rebuild *btr_fino);
 
+void init_rmapbt_cursor(struct repair_ctx *sc, xfs_agnumber_t agno,
+		unsigned int free_space, struct bt_rebuild *btr);
+void build_rmap_tree(struct repair_ctx *sc, xfs_agnumber_t agno,
+		struct bt_rebuild *btr);
+
 #endif /* __XFS_REPAIR_AG_BTREE_H__ */
diff --git a/repair/phase5.c b/repair/phase5.c
index e570349d..1c6448f4 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -417,377 +417,6 @@ build_agi(
 	libxfs_buf_relse(agi_buf);
 }
 
-/* rebuild the rmap tree */
-
-/*
- * we don't have to worry here about how chewing up free extents
- * may perturb things because rmap tree building happens before
- * freespace tree building.
- */
-static void
-init_rmapbt_cursor(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
-	struct bt_status	*btree_curs)
-{
-	size_t			num_recs;
-	int			level;
-	struct bt_stat_level	*lptr;
-	struct bt_stat_level	*p_lptr;
-	xfs_extlen_t		blocks_allocated;
-	int			maxrecs;
-
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb)) {
-		memset(btree_curs, 0, sizeof(struct bt_status));
-		return;
-	}
-
-	lptr = &btree_curs->level[0];
-	btree_curs->init = 1;
-	btree_curs->owner = XFS_RMAP_OWN_AG;
-
-	/*
-	 * build up statistics
-	 */
-	num_recs = rmap_record_count(mp, agno);
-	if (num_recs == 0) {
-		/*
-		 * easy corner-case -- no rmap records
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
-	/*
-	 * Leave enough slack in the rmapbt that we can insert the
-	 * metadata AG entries without too many splits.
-	 */
-	maxrecs = mp->m_rmap_mxr[0];
-	if (num_recs > maxrecs)
-		maxrecs -= 10;
-	blocks_allocated = lptr->num_blocks = howmany(num_recs, maxrecs);
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
-				mp->m_rmap_mxr[1]);
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
-prop_rmap_cursor(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
-	struct bt_status	*btree_curs,
-	struct xfs_rmap_irec	*rm_rec,
-	int			level)
-{
-	struct xfs_btree_block	*bt_hdr;
-	struct xfs_rmap_key	*bt_key;
-	xfs_rmap_ptr_t		*bt_ptr;
-	xfs_agblock_t		agbno;
-	struct bt_stat_level	*lptr;
-	const struct xfs_buf_ops *ops = btnum_to_ops(XFS_BTNUM_RMAP);
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
-		prop_rmap_cursor(mp, agno, btree_curs, rm_rec, level);
-	}
-
-	if (be16_to_cpu(bt_hdr->bb_numrecs) ==
-				lptr->num_recs_pb + (lptr->modulo > 0))  {
-		/*
-		 * write out current prev block, grab us a new block,
-		 * and set the rightsib pointer of current block
-		 */
-#ifdef XR_BLD_INO_TRACE
-		fprintf(stderr, " rmap prop agbno %d ", lptr->prev_agbno);
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
-			do_error(_("Cannot grab rmapbt buffer, err=%d"),
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
-		libxfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_RMAP,
-					level, 0, agno);
-
-		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
-
-		/*
-		 * propagate extent record for first extent in new block up
-		 */
-		prop_rmap_cursor(mp, agno, btree_curs, rm_rec, level);
-	}
-	/*
-	 * add rmap info to current block
-	 */
-	be16_add_cpu(&bt_hdr->bb_numrecs, 1);
-
-	bt_key = XFS_RMAP_KEY_ADDR(bt_hdr,
-				    be16_to_cpu(bt_hdr->bb_numrecs));
-	bt_ptr = XFS_RMAP_PTR_ADDR(bt_hdr,
-				    be16_to_cpu(bt_hdr->bb_numrecs),
-				    mp->m_rmap_mxr[1]);
-
-	bt_key->rm_startblock = cpu_to_be32(rm_rec->rm_startblock);
-	bt_key->rm_owner = cpu_to_be64(rm_rec->rm_owner);
-	bt_key->rm_offset = cpu_to_be64(rm_rec->rm_offset);
-
-	*bt_ptr = cpu_to_be32(btree_curs->level[level-1].agbno);
-}
-
-static void
-prop_rmap_highkey(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
-	struct bt_status	*btree_curs,
-	struct xfs_rmap_irec	*rm_highkey)
-{
-	struct xfs_btree_block	*bt_hdr;
-	struct xfs_rmap_key	*bt_key;
-	struct bt_stat_level	*lptr;
-	struct xfs_rmap_irec	key = {0};
-	struct xfs_rmap_irec	high_key;
-	int			level;
-	int			i;
-	int			numrecs;
-
-	high_key = *rm_highkey;
-	for (level = 1; level < btree_curs->num_levels; level++) {
-		lptr = &btree_curs->level[level];
-		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
-		numrecs = be16_to_cpu(bt_hdr->bb_numrecs);
-		bt_key = XFS_RMAP_HIGH_KEY_ADDR(bt_hdr, numrecs);
-
-		bt_key->rm_startblock = cpu_to_be32(high_key.rm_startblock);
-		bt_key->rm_owner = cpu_to_be64(high_key.rm_owner);
-		bt_key->rm_offset = cpu_to_be64(
-				libxfs_rmap_irec_offset_pack(&high_key));
-
-		for (i = 1; i <= numrecs; i++) {
-			bt_key = XFS_RMAP_HIGH_KEY_ADDR(bt_hdr, i);
-			key.rm_startblock = be32_to_cpu(bt_key->rm_startblock);
-			key.rm_owner = be64_to_cpu(bt_key->rm_owner);
-			key.rm_offset = be64_to_cpu(bt_key->rm_offset);
-			if (rmap_diffkeys(&key, &high_key) > 0)
-				high_key = key;
-		}
-	}
-}
-
-/*
- * rebuilds a rmap btree given a cursor.
- */
-static void
-build_rmap_tree(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
-	struct bt_status	*btree_curs)
-{
-	xfs_agnumber_t		i;
-	xfs_agblock_t		j;
-	xfs_agblock_t		agbno;
-	struct xfs_btree_block	*bt_hdr;
-	struct xfs_rmap_irec	*rm_rec;
-	struct xfs_slab_cursor	*rmap_cur;
-	struct xfs_rmap_rec	*bt_rec;
-	struct xfs_rmap_irec	highest_key = {0};
-	struct xfs_rmap_irec	hi_key = {0};
-	struct bt_stat_level	*lptr;
-	const struct xfs_buf_ops *ops = btnum_to_ops(XFS_BTNUM_RMAP);
-	int			numrecs;
-	int			level = btree_curs->num_levels;
-	int			error;
-
-	highest_key.rm_flags = 0;
-	for (i = 0; i < level; i++)  {
-		lptr = &btree_curs->level[i];
-
-		agbno = get_next_blockaddr(agno, i, btree_curs);
-		error = -libxfs_buf_get(mp->m_dev,
-				XFS_AGB_TO_DADDR(mp, agno, agbno),
-				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
-		if (error)
-			do_error(_("Cannot grab rmapbt buffer, err=%d"),
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
-		libxfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_RMAP,
-					i, 0, agno);
-	}
-
-	/*
-	 * run along leaf, setting up records.  as we have to switch
-	 * blocks, call the prop_rmap_cursor routine to set up the new
-	 * pointers for the parent.  that can recurse up to the root
-	 * if required.  set the sibling pointers for leaf level here.
-	 */
-	error = rmap_init_cursor(agno, &rmap_cur);
-	if (error)
-		do_error(
-_("Insufficient memory to construct reverse-map cursor."));
-	rm_rec = pop_slab_cursor(rmap_cur);
-	lptr = &btree_curs->level[0];
-
-	for (i = 0; i < lptr->num_blocks; i++)  {
-		numrecs = lptr->num_recs_pb + (lptr->modulo > 0);
-		ASSERT(rm_rec != NULL || numrecs == 0);
-
-		/*
-		 * block initialization, lay in block header
-		 */
-		lptr->buf_p->b_ops = ops;
-		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
-		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
-		libxfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_RMAP,
-					0, 0, agno);
-
-		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
-		bt_hdr->bb_numrecs = cpu_to_be16(numrecs);
-
-		if (lptr->modulo > 0)
-			lptr->modulo--;
-
-		if (lptr->num_recs_pb > 0) {
-			ASSERT(rm_rec != NULL);
-			prop_rmap_cursor(mp, agno, btree_curs, rm_rec, 0);
-		}
-
-		bt_rec = (struct xfs_rmap_rec *)
-			  ((char *)bt_hdr + XFS_RMAP_BLOCK_LEN);
-		highest_key.rm_startblock = 0;
-		highest_key.rm_owner = 0;
-		highest_key.rm_offset = 0;
-		for (j = 0; j < be16_to_cpu(bt_hdr->bb_numrecs); j++) {
-			ASSERT(rm_rec != NULL);
-			bt_rec[j].rm_startblock =
-					cpu_to_be32(rm_rec->rm_startblock);
-			bt_rec[j].rm_blockcount =
-					cpu_to_be32(rm_rec->rm_blockcount);
-			bt_rec[j].rm_owner = cpu_to_be64(rm_rec->rm_owner);
-			bt_rec[j].rm_offset = cpu_to_be64(
-					libxfs_rmap_irec_offset_pack(rm_rec));
-			rmap_high_key_from_rec(rm_rec, &hi_key);
-			if (rmap_diffkeys(&hi_key, &highest_key) > 0)
-				highest_key = hi_key;
-
-			rm_rec = pop_slab_cursor(rmap_cur);
-		}
-
-		/* Now go set the parent key */
-		prop_rmap_highkey(mp, agno, btree_curs, &highest_key);
-
-		if (rm_rec != NULL)  {
-			/*
-			 * get next leaf level block
-			 */
-			if (lptr->prev_buf_p != NULL)  {
-#ifdef XR_BLD_RL_TRACE
-				fprintf(stderr, "writing rmapbt agbno %u\n",
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
-	_("Cannot grab rmapbt buffer, err=%d"),
-						error);
-		}
-	}
-	free_slab_cursor(&rmap_cur);
-}
-
 /* rebuild the refcount tree */
 
 /*
@@ -1129,7 +758,7 @@ build_agf_agfl(
 	xfs_agnumber_t		agno,
 	struct bt_rebuild	*btr_bno,
 	struct bt_rebuild	*btr_cnt,
-	struct bt_status	*rmap_bt,
+	struct bt_rebuild	*btr_rmap,
 	struct bt_status	*refcnt_bt,
 	struct xfs_slab		*lost_fsb)
 {
@@ -1177,11 +806,17 @@ build_agf_agfl(
 			cpu_to_be32(btr_cnt->newbt.afake.af_root);
 	agf->agf_levels[XFS_BTNUM_CNT] =
 			cpu_to_be32(btr_cnt->newbt.afake.af_levels);
-	agf->agf_roots[XFS_BTNUM_RMAP] = cpu_to_be32(rmap_bt->root);
-	agf->agf_levels[XFS_BTNUM_RMAP] = cpu_to_be32(rmap_bt->num_levels);
 	agf->agf_freeblks = cpu_to_be32(btr_bno->freeblks);
-	agf->agf_rmap_blocks = cpu_to_be32(rmap_bt->num_tot_blocks -
-			rmap_bt->num_free_blocks);
+
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		agf->agf_roots[XFS_BTNUM_RMAP] =
+				cpu_to_be32(btr_rmap->newbt.afake.af_root);
+		agf->agf_levels[XFS_BTNUM_RMAP] =
+				cpu_to_be32(btr_rmap->newbt.afake.af_levels);
+		agf->agf_rmap_blocks =
+				cpu_to_be32(btr_rmap->newbt.afake.af_blocks);
+	}
+
 	agf->agf_refcount_root = cpu_to_be32(refcnt_bt->root);
 	agf->agf_refcount_level = cpu_to_be32(refcnt_bt->num_levels);
 	agf->agf_refcount_blocks = cpu_to_be32(refcnt_bt->num_tot_blocks -
@@ -1199,7 +834,7 @@ build_agf_agfl(
 		blks = btr_bno->newbt.afake.af_blocks +
 			btr_cnt->newbt.afake.af_blocks - 2;
 		if (xfs_sb_version_hasrmapbt(&mp->m_sb))
-			blks += rmap_bt->num_tot_blocks - rmap_bt->num_free_blocks - 1;
+			blks += btr_rmap->newbt.afake.af_blocks - 1;
 		agf->agf_btreeblks = cpu_to_be32(blks);
 #ifdef XR_BLD_FREE_TRACE
 		fprintf(stderr, "agf->agf_btreeblks = %u\n",
@@ -1244,6 +879,8 @@ build_agf_agfl(
 	freelist = xfs_buf_to_agfl_bno(agfl_buf);
 	fill_agfl(btr_bno, freelist, &agfl_idx);
 	fill_agfl(btr_cnt, freelist, &agfl_idx);
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+		fill_agfl(btr_rmap, freelist, &agfl_idx);
 
 	/* Set the AGF counters for the AGFL. */
 	if (agfl_idx > 0) {
@@ -1343,7 +980,7 @@ phase5_func(
 	struct bt_rebuild	btr_cnt;
 	struct bt_rebuild	btr_ino;
 	struct bt_rebuild	btr_fino;
-	bt_status_t		rmap_btree_curs;
+	struct bt_rebuild	btr_rmap;
 	bt_status_t		refcnt_btree_curs;
 	int			extra_blocks = 0;
 	uint			num_freeblocks;
@@ -1378,11 +1015,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 	init_ino_cursors(&sc, agno, num_freeblocks, &sb_icount_ag[agno],
 			&sb_ifree_ag[agno], &btr_ino, &btr_fino);
 
-	/*
-	 * Set up the btree cursors for the on-disk rmap btrees, which includes
-	 * pre-allocating all required blocks.
-	 */
-	init_rmapbt_cursor(mp, agno, &rmap_btree_curs);
+	init_rmapbt_cursor(&sc, agno, num_freeblocks, &btr_rmap);
 
 	/*
 	 * Set up the btree cursors for the on-disk refcount btrees,
@@ -1448,10 +1081,8 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 	ASSERT(btr_bno.freeblks == btr_cnt.freeblks);
 
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
-		build_rmap_tree(mp, agno, &rmap_btree_curs);
-		write_cursor(&rmap_btree_curs);
-		sb_fdblocks_ag[agno] += (rmap_btree_curs.num_tot_blocks -
-				rmap_btree_curs.num_free_blocks) - 1;
+		build_rmap_tree(&sc, agno, &btr_rmap);
+		sb_fdblocks_ag[agno] += btr_rmap.newbt.afake.af_blocks - 1;
 	}
 
 	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
@@ -1462,7 +1093,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 	/*
 	 * set up agf and agfl
 	 */
-	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, &rmap_btree_curs,
+	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, &btr_rmap,
 			&refcnt_btree_curs, lost_fsb);
 
 	build_inode_btrees(&sc, agno, &btr_ino, &btr_fino);
@@ -1479,7 +1110,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 	if (xfs_sb_version_hasfinobt(&mp->m_sb))
 		finish_rebuild(mp, &btr_fino, lost_fsb);
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
-		finish_cursor(&rmap_btree_curs);
+		finish_rebuild(mp, &btr_rmap, lost_fsb);
 	if (xfs_sb_version_hasreflink(&mp->m_sb))
 		finish_cursor(&refcnt_btree_curs);
 

