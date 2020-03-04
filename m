Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 059F4C3F2CD
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 03:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFA8E20836
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 03:29:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HNceAkjG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387613AbgCDD3w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 22:29:52 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34168 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387483AbgCDD3w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 22:29:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0243OAgc077050;
        Wed, 4 Mar 2020 03:29:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=wLKOJRqi+6K0Obkg/lQvy5qlnCn2sxs817TDWM32F3M=;
 b=HNceAkjGMXK4Z48R476tTKqRq3vh6LdunqIqgIRUjZhy8P3h5El7aaoJ0gAMoUBYvRPD
 nsPTyBC8Wv6cOWTnTUkAkp/fug7DupODxwoD9Z9OlFXh9Tl5WjRhPLksL/JO2pEMVTyo
 Pa2ezybrsFLgdaie7blV8Lw8Gu6endrL3frvBQz/7oGBmiCjmKh8SlK+sWtArA4sIZe0
 +1uwTNqkrtkQkjN0oDASN7G01g3bdpMOaOJtlydgz91NKaafu/TEyaCxi7/2wZo0LW0R
 MwIAwJGPbwE9Vcx82A2gUNmRD1Ib6oGQl9t1984Dg14BqXIUPqLQsRDQULNIbNKvHC1+ 1A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2yffwqukg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Mar 2020 03:29:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0243Gcpt106517;
        Wed, 4 Mar 2020 03:29:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2yg1enjyu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Mar 2020 03:29:46 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0243TjkM003540;
        Wed, 4 Mar 2020 03:29:45 GMT
Received: from localhost (/10.159.225.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Mar 2020 19:29:44 -0800
Subject: [PATCH 6/9] xfs_repair: rebuild reverse mapping btrees with bulk
 loader
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Tue, 03 Mar 2020 19:29:43 -0800
Message-ID: <158329258389.2424103.8098775426992415699.stgit@magnolia>
In-Reply-To: <158329254501.2424103.11001979654106437662.stgit@magnolia>
References: <158329254501.2424103.11001979654106437662.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=2 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003040022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=2
 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003040022
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
 repair/phase5.c          |  422 ++++++++--------------------------------------
 2 files changed, 70 insertions(+), 353 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index a4876faf..44fbacd3 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -144,6 +144,7 @@
 #define xfs_rmapbt_calc_reserves	libxfs_rmapbt_calc_reserves
 #define xfs_rmapbt_init_cursor		libxfs_rmapbt_init_cursor
 #define xfs_rmapbt_maxrecs		libxfs_rmapbt_maxrecs
+#define xfs_rmapbt_stage_cursor		libxfs_rmapbt_stage_cursor
 #define xfs_rmap_compare		libxfs_rmap_compare
 #define xfs_rmap_get_rec		libxfs_rmap_get_rec
 #define xfs_rmap_irec_offset_pack	libxfs_rmap_irec_offset_pack
diff --git a/repair/phase5.c b/repair/phase5.c
index de1e0433..430df429 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -1077,373 +1077,89 @@ build_agi(
 
 /* rebuild the rmap tree */
 
-/*
- * we don't have to worry here about how chewing up free extents
- * may perturb things because rmap tree building happens before
- * freespace tree building.
- */
+/* Set up the rmap rebuild parameters. */
 static void
 init_rmapbt_cursor(
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
+	struct repair_ctx	*sc,
 	xfs_agnumber_t		agno,
-	struct bt_status	*btree_curs,
-	struct xfs_rmap_irec	*rm_rec,
-	int			level)
+	unsigned int		free_space,
+	struct bt_rebuild	*btr)
 {
-	struct xfs_btree_block	*bt_hdr;
-	struct xfs_rmap_key	*bt_key;
-	xfs_rmap_ptr_t		*bt_ptr;
-	xfs_agblock_t		agbno;
-	struct bt_stat_level	*lptr;
-	const struct xfs_buf_ops *ops = btnum_to_ops(XFS_BTNUM_RMAP);
+	struct xfs_btree_cur	*rmap_cur;
 	int			error;
 
-	level++;
+	init_rebuild(sc, &XFS_RMAP_OINFO_AG, free_space, btr);
 
-	if (level >= btree_curs->num_levels)
+	if (!xfs_sb_version_hasrmapbt(&sc->mp->m_sb))
 		return;
 
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
+	/* Compute how many blocks we'll need. */
+	rmap_cur = libxfs_rmapbt_stage_cursor(sc->mp, sc->tp,
+			&btr->newbt.afake, agno);
+	error = -libxfs_btree_bload_compute_geometry(rmap_cur, &btr->bload,
+			rmap_record_count(sc->mp, agno));
+	if (error)
+		do_error(
+_("Unable to compute rmap btree geometry, error %d.\n"), error);
+	libxfs_btree_del_cursor(rmap_cur, error);
 
-	*bt_ptr = cpu_to_be32(btree_curs->level[level-1].agbno);
+	setup_rebuild(sc->mp, agno, btr, btr->bload.nr_blocks);
 }
 
-static void
-prop_rmap_highkey(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
-	struct bt_status	*btree_curs,
-	struct xfs_rmap_irec	*rm_highkey)
+/* Grab one rmap record. */
+static int
+get_rmap_data(
+	struct xfs_btree_cur		*cur,
+	void				*priv)
 {
-	struct xfs_btree_block	*bt_hdr;
-	struct xfs_rmap_key	*bt_key;
-	struct bt_stat_level	*lptr;
-	struct xfs_rmap_irec	key = {0};
-	struct xfs_rmap_irec	high_key;
-	int			level;
-	int			i;
-	int			numrecs;
+	struct xfs_rmap_irec		*rmap = &cur->bc_rec.r;
+	struct xfs_rmap_irec		*rec;
+	struct bt_rebuild		*btr = priv;
 
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
+	rec = pop_slab_cursor(btr->slab_cursor);
+	memcpy(rmap, rec, sizeof(struct xfs_rmap_irec));
+	return 0;
 }
 
-/*
- * rebuilds a rmap btree given a cursor.
- */
+/* Rebuild a rmap btree. */
 static void
 build_rmap_tree(
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
-	struct xfs_rmap_irec	*rm_rec;
-	struct xfs_slab_cursor	*rmap_cur;
-	struct xfs_rmap_rec	*bt_rec;
-	struct xfs_rmap_irec	highest_key = {0};
-	struct xfs_rmap_irec	hi_key = {0};
-	struct bt_stat_level	*lptr;
-	const struct xfs_buf_ops *ops = btnum_to_ops(XFS_BTNUM_RMAP);
-	int			numrecs;
-	int			level = btree_curs->num_levels;
+	struct xfs_btree_cur	*rmap_cur;
 	int			error;
 
-	highest_key.rm_flags = 0;
-	for (i = 0; i < level; i++)  {
-		lptr = &btree_curs->level[i];
+	btr->bload.get_data = get_rmap_data;
+	btr->bload.alloc_block = rebuild_alloc_block;
 
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
+	error = -libxfs_trans_alloc_empty(sc->mp, &sc->tp);
 	if (error)
 		do_error(
-_("Insufficient memory to construct reverse-map cursor."));
-	rm_rec = pop_slab_cursor(rmap_cur);
-	lptr = &btree_curs->level[0];
-
-	for (i = 0; i < lptr->num_blocks; i++)  {
-		numrecs = lptr->num_recs_pb + (lptr->modulo > 0);
-		ASSERT(rm_rec != NULL || numrecs == 0);
+_("Insufficient memory to construct rmap rebuild transaction.\n"));
 
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
+	error = rmap_init_cursor(agno, &btr->slab_cursor);
+	if (error)
+		do_error(
+_("Insufficient memory to construct rmap cursor.\n"));
 
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
+	/* Add all observed rmap records. */
+	rmap_cur = libxfs_rmapbt_stage_cursor(sc->mp, sc->tp,
+			&btr->newbt.afake, agno);
+	error = -libxfs_btree_bload(rmap_cur, &btr->bload, btr);
+	if (error)
+		do_error(
+_("Error %d while creating rmap btree for AG %u.\n"), error, agno);
 
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
+	/* Since we're not writing the AGF yet, no need to commit the cursor */
+	libxfs_btree_del_cursor(rmap_cur, 0);
+	free_slab_cursor(&btr->slab_cursor);
+	error = -libxfs_trans_commit(sc->tp);
+	if (error)
+		do_error(
+_("Error %d while writing rmap btree for AG %u.\n"), error, agno);
+	sc->tp = NULL;
 }
 
 /* rebuild the refcount tree */
@@ -1788,7 +1504,7 @@ build_agf_agfl(
 	struct bt_rebuild	*btr_cnt,
 	xfs_extlen_t		freeblks,	/* # free blocks in tree */
 	int			lostblocks,	/* # blocks that will be lost */
-	struct bt_status	*rmap_bt,
+	struct bt_rebuild	*btr_rmap,
 	struct bt_status	*refcnt_bt,
 	struct xfs_slab		*lost_fsb)
 {
@@ -1836,11 +1552,12 @@ build_agf_agfl(
 			cpu_to_be32(btr_cnt->newbt.afake.af_root);
 	agf->agf_levels[XFS_BTNUM_CNT] =
 			cpu_to_be32(btr_cnt->newbt.afake.af_levels);
-	agf->agf_roots[XFS_BTNUM_RMAP] = cpu_to_be32(rmap_bt->root);
-	agf->agf_levels[XFS_BTNUM_RMAP] = cpu_to_be32(rmap_bt->num_levels);
+	agf->agf_roots[XFS_BTNUM_RMAP] =
+			cpu_to_be32(btr_rmap->newbt.afake.af_root);
+	agf->agf_levels[XFS_BTNUM_RMAP] =
+			cpu_to_be32(btr_rmap->newbt.afake.af_levels);
 	agf->agf_freeblks = cpu_to_be32(freeblks);
-	agf->agf_rmap_blocks = cpu_to_be32(rmap_bt->num_tot_blocks -
-			rmap_bt->num_free_blocks);
+	agf->agf_rmap_blocks = cpu_to_be32(btr_rmap->newbt.afake.af_blocks);
 	agf->agf_refcount_root = cpu_to_be32(refcnt_bt->root);
 	agf->agf_refcount_level = cpu_to_be32(refcnt_bt->num_levels);
 	agf->agf_refcount_blocks = cpu_to_be32(refcnt_bt->num_tot_blocks -
@@ -1858,7 +1575,7 @@ build_agf_agfl(
 		blks = btr_bno->newbt.afake.af_blocks +
 			btr_cnt->newbt.afake.af_blocks - 2;
 		if (xfs_sb_version_hasrmapbt(&mp->m_sb))
-			blks += rmap_bt->num_tot_blocks - rmap_bt->num_free_blocks - 1;
+			blks += btr_rmap->newbt.afake.af_blocks - 1;
 		agf->agf_btreeblks = cpu_to_be32(blks);
 #ifdef XR_BLD_FREE_TRACE
 		fprintf(stderr, "agf->agf_btreeblks = %u\n",
@@ -1902,6 +1619,7 @@ build_agf_agfl(
 	/* Fill the AGFL with leftover blocks or save them for later. */
 	fill_agfl(btr_bno, freelist, &i);
 	fill_agfl(btr_cnt, freelist, &i);
+	fill_agfl(btr_rmap, freelist, &i);
 
 	/* Set the AGF counters for the AGFL. */
 	if (i > 0) {
@@ -2002,7 +1720,7 @@ phase5_func(
 	struct bt_rebuild	btr_cnt;
 	struct bt_rebuild	btr_ino;
 	struct bt_rebuild	btr_fino;
-	bt_status_t		rmap_btree_curs;
+	struct bt_rebuild	btr_rmap;
 	bt_status_t		refcnt_btree_curs;
 	int			extra_blocks = 0;
 	uint			num_freeblocks;
@@ -2045,7 +1763,7 @@ phase5_func(
 	 * Set up the btree cursors for the on-disk rmap btrees,
 	 * which includes pre-allocating all required blocks.
 	 */
-	init_rmapbt_cursor(mp, agno, &rmap_btree_curs);
+	init_rmapbt_cursor(&sc, agno, num_freeblocks, &btr_rmap);
 
 	/*
 	 * Set up the btree cursors for the on-disk refcount btrees,
@@ -2118,10 +1836,8 @@ phase5_func(
 	ASSERT(freeblks1 == freeblks2);
 
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
-		build_rmap_tree(mp, agno, &rmap_btree_curs);
-		write_cursor(&rmap_btree_curs);
-		sb_fdblocks_ag[agno] += (rmap_btree_curs.num_tot_blocks -
-				rmap_btree_curs.num_free_blocks) - 1;
+		build_rmap_tree(&sc, agno, &btr_rmap);
+		sb_fdblocks_ag[agno] += btr_rmap.newbt.afake.af_blocks - 1;
 	}
 
 	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
@@ -2133,7 +1849,7 @@ phase5_func(
 	 * set up agf and agfl
 	 */
 	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, freeblks1, extra_blocks,
-			&rmap_btree_curs, &refcnt_btree_curs, lost_fsb);
+			&btr_rmap, &refcnt_btree_curs, lost_fsb);
 
 	/*
 	 * build inode allocation trees.
@@ -2154,7 +1870,7 @@ phase5_func(
 	if (xfs_sb_version_hasfinobt(&mp->m_sb))
 		finish_rebuild(mp, &btr_fino, lost_fsb);
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
-		finish_cursor(&rmap_btree_curs);
+		finish_rebuild(mp, &btr_rmap, lost_fsb);
 	if (xfs_sb_version_hasreflink(&mp->m_sb))
 		finish_cursor(&refcnt_btree_curs);
 

