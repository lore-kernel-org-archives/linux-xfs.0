Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E21C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:22:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 677E5206EE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:22:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WFKrQPEc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgAABWP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:22:15 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55566 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABWO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:22:14 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011FA2W094704;
        Wed, 1 Jan 2020 01:22:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=GHzTwOcrNg2SMFsoaX2ubyGSAKJTuRig+kzZlVt7Pvg=;
 b=WFKrQPEc3Jr3hpHbI7d8ukNSMpcRI1mmqZHP3aR1cGbMOpQfaJhLhD1hcRL6gw8UHMzq
 fd/Yi9zHytUkgsqYdcngatJ3OMbaSKQ3AxJtwPVqewqhIhRMnAPv/L4eFetftTyGFKpd
 xlwvhUgNOzS/evzBhx7W5CNKBWEyIJOzJzJLnYWhJgdggLDVB32/pkXx2r5j4OkwcrJB
 crZg85A2LojEwzgLHBssdAQCELpboaL6kO1ykxWeokPz0+wXfLsRCH89jTYR3KAMz6o8
 CqsK11VoouZsJ4s36NZoqfImcIB4Wd6KvI0BbO87sB4x2HxFIOBqFXKH7IYacRsUFtCN wQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2x5ypqjws6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:22:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011IHlQ057103;
        Wed, 1 Jan 2020 01:22:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2x7medfk1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:22:11 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011MA2H031491;
        Wed, 1 Jan 2020 01:22:10 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:22:10 -0800
Subject: [PATCH 7/9] xfs_repair: rebuild refcount btrees with bulk loader
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:22:07 -0800
Message-ID: <157784172756.1371226.13290540077669535973.stgit@magnolia>
In-Reply-To: <157784168333.1371226.17162288990534822154.stgit@magnolia>
References: <157784168333.1371226.17162288990534822154.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
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
 repair/phase5.c          |  347 +++++++++-------------------------------------
 2 files changed, 72 insertions(+), 276 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 4fc26d15..72605d4d 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -183,5 +183,6 @@
 #define xfs_allocbt_stage_cursor	libxfs_allocbt_stage_cursor
 #define xfs_inobt_stage_cursor		libxfs_inobt_stage_cursor
 #define xfs_rmapbt_stage_cursor		libxfs_rmapbt_stage_cursor
+#define xfs_refcountbt_stage_cursor	libxfs_refcountbt_stage_cursor
 
 #endif /* __LIBXFS_API_DEFS_H__ */
diff --git a/repair/phase5.c b/repair/phase5.c
index ef120b5e..ee4a4563 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -1157,295 +1157,89 @@ _("Error %d while writing rmap btree for AG %u.\n"), error, agno);
 
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
+	struct xfs_btree_cur	*refc_cur;
+	int			error;
 
-		setup_cursor(mp, agno, btree_curs);
+	init_rebuild(sc, &XFS_RMAP_OINFO_REFC, free_space, btr);
 
+	if (!xfs_sb_version_hasreflink(&sc->mp->m_sb))
 		return;
-	}
 
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
+	/* Compute how many blocks we'll need. */
+	refc_cur = libxfs_refcountbt_stage_cursor(sc->mp, sc->tp,
+			&btr->newbt.afake, agno);
+	error = -libxfs_btree_bload_compute_geometry(refc_cur, &btr->bload,
+			refcount_record_count(sc->mp, agno));
+	if (error)
+		do_error(
+_("Unable to compute refcount btree geometry, error %d.\n"), error);
+	libxfs_btree_del_cursor(refc_cur, error);
 
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
+get_refcount_data(
+	struct xfs_btree_cur		*cur,
+	void				*priv)
 {
-	struct xfs_btree_block	*bt_hdr;
-	struct xfs_refcount_key	*bt_key;
-	xfs_refcount_ptr_t	*bt_ptr;
-	xfs_agblock_t		agbno;
-	struct bt_stat_level	*lptr;
-	const struct xfs_buf_ops *ops = btnum_to_ops(XFS_BTNUM_REFC);
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
-			libxfs_writebuf(lptr->prev_buf_p, 0);
-		}
-		lptr->prev_agbno = lptr->agbno;
-		lptr->prev_buf_p = lptr->buf_p;
-		agbno = get_next_blockaddr(agno, level, btree_curs);
-
-		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(agbno);
-
-		lptr->buf_p = libxfs_getbuf(mp->m_dev,
-					XFS_AGB_TO_DADDR(mp, agno, agbno),
-					XFS_FSB_TO_BB(mp, 1));
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
+	struct xfs_refcount_irec	*refc = &cur->bc_rec.rc;
+	struct xfs_refcount_irec	*rec;
+	struct bt_rebuild		*btr = priv;
 
-	bt_key->rc_startblock = cpu_to_be32(startbno);
-	*bt_ptr = cpu_to_be32(btree_curs->level[level-1].agbno);
+	rec = pop_slab_cursor(btr->slab_cursor);
+	memcpy(refc, rec, sizeof(struct xfs_refcount_irec));
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
+	struct xfs_btree_cur	*refc_cur;
 	int			error;
 
-	for (i = 0; i < level; i++)  {
-		lptr = &btree_curs->level[i];
-
-		agbno = get_next_blockaddr(agno, i, btree_curs);
-		lptr->buf_p = libxfs_getbuf(mp->m_dev,
-					XFS_AGB_TO_DADDR(mp, agno, agbno),
-					XFS_FSB_TO_BB(mp, 1));
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
+	btr->bload.get_data = get_refcount_data;
+	btr->bload.alloc_block = rebuild_alloc_block;
 
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
+	refc_cur = libxfs_refcountbt_stage_cursor(sc->mp, sc->tp,
+			&btr->newbt.afake, agno);
+	error = -libxfs_btree_bload(refc_cur, &btr->bload, btr);
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
-				libxfs_writebuf(lptr->prev_buf_p, 0);
-			}
-			lptr->prev_buf_p = lptr->buf_p;
-			lptr->prev_agbno = lptr->agbno;
-			lptr->agbno = get_next_blockaddr(agno, 0, btree_curs);
-			bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(lptr->agbno);
-
-			lptr->buf_p = libxfs_getbuf(mp->m_dev,
-					XFS_AGB_TO_DADDR(mp, agno, lptr->agbno),
-					XFS_FSB_TO_BB(mp, 1));
-		}
-	}
-	free_slab_cursor(&refc_cur);
+	/* Since we're not writing the AGF yet, no need to commit the cursor */
+	libxfs_btree_del_cursor(refc_cur, 0);
+	free_slab_cursor(&btr->slab_cursor);
+	error = -libxfs_trans_commit(sc->tp);
+	if (error)
+		do_error(
+_("Error %d while writing refcount btree for AG %u.\n"), error, agno);
+	sc->tp = NULL;
 }
 
 /* Fill the AGFL with any leftover bnobt rebuilder blocks. */
@@ -1484,7 +1278,7 @@ build_agf_agfl(
 	xfs_extlen_t		freeblks,	/* # free blocks in tree */
 	int			lostblocks,	/* # blocks that will be lost */
 	struct bt_rebuild	*btr_rmap,
-	struct bt_status	*refcnt_bt,
+	struct bt_rebuild	*btr_refcount,
 	struct xfs_slab		*lost_fsb)
 {
 	struct extent_tree_node	*ext_ptr;
@@ -1532,11 +1326,14 @@ build_agf_agfl(
 	agf->agf_levels[XFS_BTNUM_RMAP] =
 			cpu_to_be32(btr_rmap->newbt.afake.af_levels);
 	agf->agf_freeblks = cpu_to_be32(freeblks);
-	agf->agf_rmap_blocks = cpu_to_be32(btr_rmap->newbt.afake.af_blocks);
-	agf->agf_refcount_root = cpu_to_be32(refcnt_bt->root);
-	agf->agf_refcount_level = cpu_to_be32(refcnt_bt->num_levels);
-	agf->agf_refcount_blocks = cpu_to_be32(refcnt_bt->num_tot_blocks -
-			refcnt_bt->num_free_blocks);
+	agf->agf_rmap_blocks =
+			cpu_to_be32(btr_rmap->newbt.afake.af_blocks);
+	agf->agf_refcount_root =
+			cpu_to_be32(btr_refcount->newbt.afake.af_root);
+	agf->agf_refcount_level =
+			cpu_to_be32(btr_refcount->newbt.afake.af_levels);
+	agf->agf_refcount_blocks =
+			cpu_to_be32(btr_refcount->newbt.afake.af_blocks);
 
 	/*
 	 * Count and record the number of btree blocks consumed if required.
@@ -1690,7 +1487,7 @@ phase5_func(
 	struct bt_rebuild	btr_ino;
 	struct bt_rebuild	btr_fino;
 	struct bt_rebuild	btr_rmap;
-	bt_status_t		refcnt_btree_curs;
+	struct bt_rebuild	btr_refcount;
 	int			extra_blocks = 0;
 	uint			num_freeblocks;
 	xfs_extlen_t		freeblks1;
@@ -1738,7 +1535,7 @@ phase5_func(
 	 * Set up the btree cursors for the on-disk refcount btrees,
 	 * which includes pre-allocating all required blocks.
 	 */
-	init_refc_cursor(mp, agno, &refcnt_btree_curs);
+	init_refc_cursor(&sc, agno, num_freeblocks, &btr_refcount);
 
 	num_extents = count_bno_extents_blocks(agno, &num_freeblocks);
 	/*
@@ -1809,16 +1606,14 @@ phase5_func(
 		sb_fdblocks_ag[agno] += btr_rmap.newbt.afake.af_blocks - 1;
 	}
 
-	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
-		build_refcount_tree(mp, agno, &refcnt_btree_curs);
-		write_cursor(&refcnt_btree_curs);
-	}
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		build_refcount_tree(&sc, agno, &btr_refcount);
 
 	/*
 	 * set up agf and agfl
 	 */
 	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, freeblks1, extra_blocks,
-			&btr_rmap, &refcnt_btree_curs, lost_fsb);
+			&btr_rmap, &btr_refcount, lost_fsb);
 
 	/*
 	 * build inode allocation trees.
@@ -1841,7 +1636,7 @@ phase5_func(
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
 		finish_rebuild(mp, &btr_rmap, lost_fsb);
 	if (xfs_sb_version_hasreflink(&mp->m_sb))
-		finish_cursor(&refcnt_btree_curs);
+		finish_rebuild(mp, &btr_refcount, lost_fsb);
 
 	/*
 	 * release the incore per-AG bno/bcnt trees so

