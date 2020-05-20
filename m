Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE3DC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:51:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E89D20708
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:51:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GEyJUzOl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgETBvY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 21:51:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42504 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728309AbgETBvY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 21:51:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1nJcC178926;
        Wed, 20 May 2020 01:51:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=1yuvBoWdlDmaEHD4Ke7PJuRH/bu37ALsrJ0Bf4gLC7s=;
 b=GEyJUzOlhERI7X+8GNQwacLyiT26lBPbd1jIrno8hYXaBiQWUTX6WkBz7oYVJvgZ9SpB
 7qx5dKm1mWN6SXoQFAvWq5FIn2XluUvp6/n/fp2T2szJ+TYDWhTc5BCYUEqk8ecVuMcv
 BgCI+SyaMc/tepTpgyY9EqataYHvssEyQikeXLB1fMzkYNfPkShKR+cygdFCKiSpSUCt
 11YuIDnYRRLigDJPneDPGKXRXOdnatcP2LdAKWe/Pnb6ntV9z9xlb6+WezU7iCCnjg5F
 wAIBgvAg41G66WtLioLsYTm5tJz2+VsashmIvoo2HVpevDhg7o2LaUSHp45eIlgxBDWx JA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31284m0hps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 01:51:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1nALm042065;
        Wed, 20 May 2020 01:51:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 312sxtuhuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 01:51:17 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04K1pGHE005837;
        Wed, 20 May 2020 01:51:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 18:51:16 -0700
Subject: [PATCH 5/9] xfs_repair: rebuild inode btrees with bulk loader
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Tue, 19 May 2020 18:51:15 -0700
Message-ID: <158993947501.983175.11198846141379731761.stgit@magnolia>
In-Reply-To: <158993944270.983175.4120094597556662259.stgit@magnolia>
References: <158993944270.983175.4120094597556662259.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=2 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005200012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the btree bulk loading functions to rebuild the inode btrees
and drop the open-coded implementation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    1 
 repair/phase5.c          |  642 +++++++++++++++++-----------------------------
 2 files changed, 240 insertions(+), 403 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index bace739c..5d0868c2 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -115,6 +115,7 @@
 #define xfs_init_local_fork		libxfs_init_local_fork
 
 #define xfs_inobt_maxrecs		libxfs_inobt_maxrecs
+#define xfs_inobt_stage_cursor		libxfs_inobt_stage_cursor
 #define xfs_inode_from_disk		libxfs_inode_from_disk
 #define xfs_inode_to_disk		libxfs_inode_to_disk
 #define xfs_inode_validate_cowextsize	libxfs_inode_validate_cowextsize
diff --git a/repair/phase5.c b/repair/phase5.c
index e69b042c..38f30753 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -84,6 +84,10 @@ struct bt_rebuild {
 			struct extent_tree_node	*bno_rec;
 			xfs_agblock_t		*freeblks;
 		};
+		struct {
+			struct ino_tree_node	*ino_rec;
+			struct agi_stat		*agi_stat;
+		};
 	};
 };
 
@@ -372,6 +376,11 @@ estimate_ag_bload_slack(
 		bload->node_slack = 0;
 }
 
+static inline void skip_rebuild(struct bt_rebuild *btr)
+{
+	memset(btr, 0, sizeof(struct bt_rebuild));
+}
+
 /* Initialize a btree rebuild context. */
 static void
 init_rebuild(
@@ -765,48 +774,38 @@ _("Error %d while writing cntbt btree for AG %u.\n"), error, agno);
 	sc->tp = NULL;
 }
 
-/*
- * XXX(hch): any reason we don't just look at mp->m_inobt_mxr?
- */
-#define XR_INOBT_BLOCK_MAXRECS(mp, level) \
-			libxfs_inobt_maxrecs((mp), (mp)->m_sb.sb_blocksize, \
-						(level) == 0)
+/* Inode Btrees */
 
-/*
- * we don't have to worry here about how chewing up free extents
- * may perturb things because inode tree building happens before
- * freespace tree building.
- */
+/* Initialize both inode btree cursors as needed. */
 static void
-init_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
-		uint64_t *num_inos, uint64_t *num_free_inos, int finobt)
+init_ino_cursors(
+	struct repair_ctx	*sc,
+	xfs_agnumber_t		agno,
+	unsigned int		free_space,
+	uint64_t		*num_inos,
+	uint64_t		*num_free_inos,
+	struct bt_rebuild	*btr_ino,
+	struct bt_rebuild	*btr_fino)
 {
-	uint64_t		ninos;
-	uint64_t		nfinos;
-	int			rec_nfinos;
-	int			rec_ninos;
-	ino_tree_node_t		*ino_rec;
-	int			num_recs;
-	int			level;
-	bt_stat_level_t		*lptr;
-	bt_stat_level_t		*p_lptr;
-	xfs_extlen_t		blocks_allocated;
-	int			i;
+	struct ino_tree_node	*ino_rec;
+	unsigned int		ino_recs = 0;
+	unsigned int		fino_recs = 0;
+	bool			finobt;
+	int			error;
 
-	*num_inos = *num_free_inos = 0;
-	ninos = nfinos = 0;
+	finobt = xfs_sb_version_hasfinobt(&sc->mp->m_sb);
+	init_rebuild(sc, &XFS_RMAP_OINFO_INOBT, free_space, btr_ino);
 
-	lptr = &btree_curs->level[0];
-	btree_curs->init = 1;
-	btree_curs->owner = XFS_RMAP_OWN_INOBT;
+	/* Compute inode statistics. */
+	*num_free_inos = 0;
+	*num_inos = 0;
+	for (ino_rec = findfirst_inode_rec(agno);
+	     ino_rec != NULL;
+	     ino_rec = next_ino_rec(ino_rec))  {
+		unsigned int	rec_ninos = 0;
+		unsigned int	rec_nfinos = 0;
+		int		i;
 
-	/*
-	 * build up statistics
-	 */
-	ino_rec = findfirst_inode_rec(agno);
-	for (num_recs = 0; ino_rec != NULL; ino_rec = next_ino_rec(ino_rec))  {
-		rec_ninos = 0;
-		rec_nfinos = 0;
 		for (i = 0; i < XFS_INODES_PER_CHUNK; i++)  {
 			ASSERT(is_inode_confirmed(ino_rec, i));
 			/*
@@ -820,174 +819,220 @@ init_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 			rec_ninos++;
 		}
 
-		/*
-		 * finobt only considers records with free inodes
-		 */
-		if (finobt && !rec_nfinos)
+		*num_free_inos += rec_nfinos;
+		*num_inos += rec_ninos;
+		ino_recs++;
+
+		/* finobt only considers records with free inodes */
+		if (rec_nfinos)
+			fino_recs++;
+	}
+
+	btr_ino->cur = libxfs_inobt_stage_cursor(sc->mp, &btr_ino->newbt.afake,
+			agno, XFS_BTNUM_INO);
+
+	/* Compute how many inobt blocks we'll need. */
+	error = -libxfs_btree_bload_compute_geometry(btr_ino->cur,
+			&btr_ino->bload, ino_recs);
+	if (error)
+		do_error(
+_("Unable to compute inode btree geometry, error %d.\n"), error);
+
+	setup_rebuild(sc->mp, agno, btr_ino, btr_ino->bload.nr_blocks);
+
+	if (!finobt) {
+		skip_rebuild(btr_fino);
+		return;
+	}
+
+	init_rebuild(sc, &XFS_RMAP_OINFO_INOBT, free_space, btr_fino);
+	btr_fino->cur = libxfs_inobt_stage_cursor(sc->mp,
+			&btr_fino->newbt.afake, agno, XFS_BTNUM_FINO);
+
+	/* Compute how many finobt blocks we'll need. */
+	error = -libxfs_btree_bload_compute_geometry(btr_fino->cur,
+			&btr_fino->bload, fino_recs);
+	if (error)
+		do_error(
+_("Unable to compute free inode btree geometry, error %d.\n"), error);
+
+	setup_rebuild(sc->mp, agno, btr_fino, btr_fino->bload.nr_blocks);
+}
+
+/* Copy one incore inode record into the inobt cursor. */
+static void
+get_inode_data(
+	struct xfs_btree_cur		*cur,
+	struct ino_tree_node		*ino_rec,
+	struct agi_stat			*agi_stat)
+{
+	struct xfs_inobt_rec_incore	*irec = &cur->bc_rec.i;
+	int				inocnt = 0;
+	int				finocnt = 0;
+	int				k;
+
+	irec->ir_startino = ino_rec->ino_startnum;
+	irec->ir_free = ino_rec->ir_free;
+
+	for (k = 0; k < sizeof(xfs_inofree_t) * NBBY; k++)  {
+		ASSERT(is_inode_confirmed(ino_rec, k));
+
+		if (is_inode_sparse(ino_rec, k))
 			continue;
-
-		nfinos += rec_nfinos;
-		ninos += rec_ninos;
-		num_recs++;
+		if (is_inode_free(ino_rec, k))
+			finocnt++;
+		inocnt++;
 	}
 
-	if (num_recs == 0) {
-		/*
-		 * easy corner-case -- no inode records
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
+	irec->ir_count = inocnt;
+	irec->ir_freecount = finocnt;
 
-		return;
-	}
+	if (xfs_sb_version_hassparseinodes(&cur->bc_mp->m_sb)) {
+		uint64_t		sparse;
+		int			spmask;
+		uint16_t		holemask;
 
-	blocks_allocated = lptr->num_blocks = howmany(num_recs,
-					XR_INOBT_BLOCK_MAXRECS(mp, 0));
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
-				XR_INOBT_BLOCK_MAXRECS(mp, level));
-			lptr->modulo = p_lptr->num_blocks % lptr->num_blocks;
-			lptr->num_recs_pb = p_lptr->num_blocks
-					/ lptr->num_blocks;
-			lptr->num_recs_tot = p_lptr->num_blocks;
-
-			blocks_allocated += lptr->num_blocks;
+		/*
+		 * Convert the 64-bit in-core sparse inode state to the
+		 * 16-bit on-disk holemask.
+		 */
+		holemask = 0;
+		spmask = (1 << XFS_INODES_PER_HOLEMASK_BIT) - 1;
+		sparse = ino_rec->ir_sparse;
+		for (k = 0; k < XFS_INOBT_HOLEMASK_BITS; k++) {
+			if (sparse & spmask) {
+				ASSERT((sparse & spmask) == spmask);
+				holemask |= (1 << k);
+			} else
+				ASSERT((sparse & spmask) == 0);
+			sparse >>= XFS_INODES_PER_HOLEMASK_BIT;
 		}
+
+		irec->ir_holemask = holemask;
+	} else {
+		irec->ir_holemask = 0;
 	}
-	ASSERT(lptr->num_blocks == 1);
-	btree_curs->num_levels = level;
 
-	btree_curs->num_tot_blocks = btree_curs->num_free_blocks
-			= blocks_allocated;
+	if (!agi_stat)
+		return;
 
-	setup_cursor(mp, agno, btree_curs);
+	if (agi_stat->first_agino != NULLAGINO)
+		agi_stat->first_agino = ino_rec->ino_startnum;
+	agi_stat->freecount += finocnt;
+	agi_stat->count += inocnt;
+}
 
-	*num_inos = ninos;
-	*num_free_inos = nfinos;
+/* Grab one inobt record. */
+static int
+get_inobt_record(
+	struct xfs_btree_cur		*cur,
+	void				*priv)
+{
+	struct bt_rebuild		*rebuild = priv;
 
-	return;
+	get_inode_data(cur, rebuild->ino_rec, rebuild->agi_stat);
+	rebuild->ino_rec = next_ino_rec(rebuild->ino_rec);
+	return 0;
 }
 
+/* Rebuild a inobt btree. */
 static void
-prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
-	xfs_btnum_t btnum, xfs_agino_t startino, int level)
+build_inobt(
+	struct repair_ctx	*sc,
+	xfs_agnumber_t		agno,
+	struct bt_rebuild	*btr_ino,
+	struct agi_stat		*agi_stat)
 {
-	struct xfs_btree_block	*bt_hdr;
-	xfs_inobt_key_t		*bt_key;
-	xfs_inobt_ptr_t		*bt_ptr;
-	xfs_agblock_t		agbno;
-	bt_stat_level_t		*lptr;
-	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
 	int			error;
 
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
-		prop_ino_cursor(mp, agno, btree_curs, btnum, startino, level);
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
-		lptr->prev_agbno = lptr->agbno;;
-		lptr->prev_buf_p = lptr->buf_p;
-		agbno = get_next_blockaddr(agno, level, btree_curs);
-
-		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(agbno);
-
-		error = -libxfs_buf_get(mp->m_dev,
-				XFS_AGB_TO_DADDR(mp, agno, agbno),
-				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
-		if (error)
-			do_error(_("Cannot grab inode btree buffer, err=%d"),
-					error);
-		lptr->agbno = agbno;
+	btr_ino->bload.get_record = get_inobt_record;
+	btr_ino->bload.claim_block = rebuild_claim_block;
+	agi_stat->count = agi_stat->freecount = 0;
+	agi_stat->first_agino = NULLAGINO;
+	btr_ino->agi_stat = agi_stat;
+	btr_ino->ino_rec = findfirst_inode_rec(agno);
+
+	error = -libxfs_trans_alloc_empty(sc->mp, &sc->tp);
+	if (error)
+		do_error(
+_("Insufficient memory to construct inobt rebuild transaction.\n"));
+
+	/* Add all observed inobt records. */
+	error = -libxfs_btree_bload(btr_ino->cur, &btr_ino->bload, btr_ino);
+	if (error)
+		do_error(
+_("Error %d while creating inobt btree for AG %u.\n"), error, agno);
+
+	/* Since we're not writing the AGI yet, no need to commit the cursor */
+	libxfs_btree_del_cursor(btr_ino->cur, 0);
+	error = -libxfs_trans_commit(sc->tp);
+	if (error)
+		do_error(
+_("Error %d while writing inobt btree for AG %u.\n"), error, agno);
+	sc->tp = NULL;
+}
 
-		if (lptr->modulo)
-			lptr->modulo--;
+/* Grab one finobt record. */
+static int
+get_finobt_record(
+	struct xfs_btree_cur		*cur,
+	void				*priv)
+{
+	struct bt_rebuild		*rebuild = priv;
 
-		/*
-		 * initialize block header
-		 */
-		lptr->buf_p->b_ops = ops;
-		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
-		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
-		libxfs_btree_init_block(mp, lptr->buf_p, btnum,
-					level, 0, agno);
+	get_inode_data(cur, rebuild->ino_rec, NULL);
+	rebuild->ino_rec = next_free_ino_rec(rebuild->ino_rec);
+	return 0;
+}
 
-		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
+/* Rebuild a finobt btree. */
+static void
+build_finobt(
+	struct repair_ctx	*sc,
+	xfs_agnumber_t		agno,
+	struct bt_rebuild	*btr_fino)
+{
+	int			error;
 
-		/*
-		 * propagate extent record for first extent in new block up
-		 */
-		prop_ino_cursor(mp, agno, btree_curs, btnum, startino, level);
-	}
-	/*
-	 * add inode info to current block
-	 */
-	be16_add_cpu(&bt_hdr->bb_numrecs, 1);
-
-	bt_key = XFS_INOBT_KEY_ADDR(mp, bt_hdr,
-				    be16_to_cpu(bt_hdr->bb_numrecs));
-	bt_ptr = XFS_INOBT_PTR_ADDR(mp, bt_hdr,
-				    be16_to_cpu(bt_hdr->bb_numrecs),
-				    M_IGEO(mp)->inobt_mxr[1]);
-
-	bt_key->ir_startino = cpu_to_be32(startino);
-	*bt_ptr = cpu_to_be32(btree_curs->level[level-1].agbno);
+	btr_fino->bload.get_record = get_finobt_record;
+	btr_fino->bload.claim_block = rebuild_claim_block;
+	btr_fino->ino_rec = findfirst_free_inode_rec(agno);
+
+	error = -libxfs_trans_alloc_empty(sc->mp, &sc->tp);
+	if (error)
+		do_error(
+_("Insufficient memory to construct finobt rebuild transaction.\n"));
+
+	/* Add all observed finobt records. */
+	error = -libxfs_btree_bload(btr_fino->cur, &btr_fino->bload, btr_fino);
+	if (error)
+		do_error(
+_("Error %d while creating finobt btree for AG %u.\n"), error, agno);
+
+	/* Since we're not writing the AGI yet, no need to commit the cursor */
+	libxfs_btree_del_cursor(btr_fino->cur, 0);
+	error = -libxfs_trans_commit(sc->tp);
+	if (error)
+		do_error(
+_("Error %d while writing finobt btree for AG %u.\n"), error, agno);
+	sc->tp = NULL;
 }
 
 /*
  * XXX: yet more code that can be shared with mkfs, growfs.
  */
 static void
-build_agi(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
-		bt_status_t *finobt_curs, struct agi_stat *agi_stat)
+build_agi(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	struct bt_rebuild	*btr_ino,
+	struct bt_rebuild	*btr_fino,
+	struct agi_stat		*agi_stat)
 {
-	xfs_buf_t	*agi_buf;
-	xfs_agi_t	*agi;
-	int		i;
-	int		error;
+	struct xfs_buf		*agi_buf;
+	struct xfs_agi		*agi;
+	int			i;
+	int			error;
 
 	error = -libxfs_buf_get(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
@@ -1008,8 +1053,8 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 		agi->agi_length = cpu_to_be32(mp->m_sb.sb_dblocks -
 			(xfs_rfsblock_t) mp->m_sb.sb_agblocks * agno);
 	agi->agi_count = cpu_to_be32(agi_stat->count);
-	agi->agi_root = cpu_to_be32(btree_curs->root);
-	agi->agi_level = cpu_to_be32(btree_curs->num_levels);
+	agi->agi_root = cpu_to_be32(btr_ino->newbt.afake.af_root);
+	agi->agi_level = cpu_to_be32(btr_ino->newbt.afake.af_levels);
 	agi->agi_freecount = cpu_to_be32(agi_stat->freecount);
 	agi->agi_newino = cpu_to_be32(agi_stat->first_agino);
 	agi->agi_dirino = cpu_to_be32(NULLAGINO);
@@ -1021,203 +1066,16 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 		platform_uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid);
 
 	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
-		agi->agi_free_root = cpu_to_be32(finobt_curs->root);
-		agi->agi_free_level = cpu_to_be32(finobt_curs->num_levels);
+		agi->agi_free_root =
+				cpu_to_be32(btr_fino->newbt.afake.af_root);
+		agi->agi_free_level =
+				cpu_to_be32(btr_fino->newbt.afake.af_levels);
 	}
 
 	libxfs_buf_mark_dirty(agi_buf);
 	libxfs_buf_relse(agi_buf);
 }
 
-/*
- * rebuilds an inode tree given a cursor.  We're lazy here and call
- * the routine that builds the agi
- */
-static void
-build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
-		bt_status_t *btree_curs, xfs_btnum_t btnum,
-		struct agi_stat *agi_stat)
-{
-	xfs_agnumber_t		i;
-	xfs_agblock_t		j;
-	xfs_agblock_t		agbno;
-	xfs_agino_t		first_agino;
-	struct xfs_btree_block	*bt_hdr;
-	xfs_inobt_rec_t		*bt_rec;
-	ino_tree_node_t		*ino_rec;
-	bt_stat_level_t		*lptr;
-	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
-	xfs_agino_t		count = 0;
-	xfs_agino_t		freecount = 0;
-	int			inocnt;
-	uint8_t			finocnt;
-	int			k;
-	int			level = btree_curs->num_levels;
-	int			spmask;
-	uint64_t		sparse;
-	uint16_t		holemask;
-	int			error;
-
-	ASSERT(btnum == XFS_BTNUM_INO || btnum == XFS_BTNUM_FINO);
-
-	for (i = 0; i < level; i++)  {
-		lptr = &btree_curs->level[i];
-
-		agbno = get_next_blockaddr(agno, i, btree_curs);
-		error = -libxfs_buf_get(mp->m_dev,
-				XFS_AGB_TO_DADDR(mp, agno, agbno),
-				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
-		if (error)
-			do_error(_("Cannot grab inode btree buffer, err=%d"),
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
-		libxfs_btree_init_block(mp, lptr->buf_p, btnum, i, 0, agno);
-	}
-
-	/*
-	 * run along leaf, setting up records.  as we have to switch
-	 * blocks, call the prop_ino_cursor routine to set up the new
-	 * pointers for the parent.  that can recurse up to the root
-	 * if required.  set the sibling pointers for leaf level here.
-	 */
-	if (btnum == XFS_BTNUM_FINO)
-		ino_rec = findfirst_free_inode_rec(agno);
-	else
-		ino_rec = findfirst_inode_rec(agno);
-
-	if (ino_rec != NULL)
-		first_agino = ino_rec->ino_startnum;
-	else
-		first_agino = NULLAGINO;
-
-	lptr = &btree_curs->level[0];
-
-	for (i = 0; i < lptr->num_blocks; i++)  {
-		/*
-		 * block initialization, lay in block header
-		 */
-		lptr->buf_p->b_ops = ops;
-		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
-		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
-		libxfs_btree_init_block(mp, lptr->buf_p, btnum, 0, 0, agno);
-
-		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
-		bt_hdr->bb_numrecs = cpu_to_be16(lptr->num_recs_pb +
-							(lptr->modulo > 0));
-
-		if (lptr->modulo > 0)
-			lptr->modulo--;
-
-		if (lptr->num_recs_pb > 0)
-			prop_ino_cursor(mp, agno, btree_curs, btnum,
-					ino_rec->ino_startnum, 0);
-
-		bt_rec = (xfs_inobt_rec_t *)
-			  ((char *)bt_hdr + XFS_INOBT_BLOCK_LEN(mp));
-		for (j = 0; j < be16_to_cpu(bt_hdr->bb_numrecs); j++) {
-			ASSERT(ino_rec != NULL);
-			bt_rec[j].ir_startino =
-					cpu_to_be32(ino_rec->ino_startnum);
-			bt_rec[j].ir_free = cpu_to_be64(ino_rec->ir_free);
-
-			inocnt = finocnt = 0;
-			for (k = 0; k < sizeof(xfs_inofree_t)*NBBY; k++)  {
-				ASSERT(is_inode_confirmed(ino_rec, k));
-
-				if (is_inode_sparse(ino_rec, k))
-					continue;
-				if (is_inode_free(ino_rec, k))
-					finocnt++;
-				inocnt++;
-			}
-
-			/*
-			 * Set the freecount and check whether we need to update
-			 * the sparse format fields. Otherwise, skip to the next
-			 * record.
-			 */
-			inorec_set_freecount(mp, &bt_rec[j], finocnt);
-			if (!xfs_sb_version_hassparseinodes(&mp->m_sb))
-				goto nextrec;
-
-			/*
-			 * Convert the 64-bit in-core sparse inode state to the
-			 * 16-bit on-disk holemask.
-			 */
-			holemask = 0;
-			spmask = (1 << XFS_INODES_PER_HOLEMASK_BIT) - 1;
-			sparse = ino_rec->ir_sparse;
-			for (k = 0; k < XFS_INOBT_HOLEMASK_BITS; k++) {
-				if (sparse & spmask) {
-					ASSERT((sparse & spmask) == spmask);
-					holemask |= (1 << k);
-				} else
-					ASSERT((sparse & spmask) == 0);
-				sparse >>= XFS_INODES_PER_HOLEMASK_BIT;
-			}
-
-			bt_rec[j].ir_u.sp.ir_count = inocnt;
-			bt_rec[j].ir_u.sp.ir_holemask = cpu_to_be16(holemask);
-
-nextrec:
-			freecount += finocnt;
-			count += inocnt;
-
-			if (btnum == XFS_BTNUM_FINO)
-				ino_rec = next_free_ino_rec(ino_rec);
-			else
-				ino_rec = next_ino_rec(ino_rec);
-		}
-
-		if (ino_rec != NULL)  {
-			/*
-			 * get next leaf level block
-			 */
-			if (lptr->prev_buf_p != NULL)  {
-#ifdef XR_BLD_INO_TRACE
-				fprintf(stderr, "writing inobt agbno %u\n",
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
-	_("Cannot grab inode btree buffer, err=%d"),
-						error);
-		}
-	}
-
-	if (agi_stat) {
-		agi_stat->first_agino = first_agino;
-		agi_stat->count = count;
-		agi_stat->freecount = freecount;
-	}
-}
-
 /* rebuild the rmap tree */
 
 /*
@@ -2142,14 +2000,10 @@ phase5_func(
 {
 	struct repair_ctx	sc = { .mp = mp, };
 	struct agi_stat		agi_stat = {0,};
-	uint64_t		num_inos;
-	uint64_t		num_free_inos;
-	uint64_t		finobt_num_inos;
-	uint64_t		finobt_num_free_inos;
 	struct bt_rebuild	btr_bno;
 	struct bt_rebuild	btr_cnt;
-	bt_status_t		ino_btree_curs;
-	bt_status_t		fino_btree_curs;
+	struct bt_rebuild	btr_ino;
+	struct bt_rebuild	btr_fino;
 	bt_status_t		rmap_btree_curs;
 	bt_status_t		refcnt_btree_curs;
 	int			extra_blocks = 0;
@@ -2184,19 +2038,8 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 			agno);
 	}
 
-	/*
-	 * ok, now set up the btree cursors for the on-disk btrees (includes
-	 * pre-allocating all required blocks for the trees themselves)
-	 */
-	init_ino_cursor(mp, agno, &ino_btree_curs, &num_inos,
-			&num_free_inos, 0);
-
-	if (xfs_sb_version_hasfinobt(&mp->m_sb))
-		init_ino_cursor(mp, agno, &fino_btree_curs, &finobt_num_inos,
-				&finobt_num_free_inos, 1);
-
-	sb_icount_ag[agno] += num_inos;
-	sb_ifree_ag[agno] += num_free_inos;
+	init_ino_cursors(&sc, agno, num_freeblocks, &sb_icount_ag[agno],
+			&sb_ifree_ag[agno], &btr_ino, &btr_fino);
 
 	/*
 	 * Set up the btree cursors for the on-disk rmap btrees, which includes
@@ -2287,34 +2130,27 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 			&rmap_btree_curs, &refcnt_btree_curs, lost_fsb);
 
 	/*
-	 * build inode allocation tree.
+	 * build inode allocation trees.
 	 */
-	build_ino_tree(mp, agno, &ino_btree_curs, XFS_BTNUM_INO, &agi_stat);
-	write_cursor(&ino_btree_curs);
-
-	/*
-	 * build free inode tree
-	 */
-	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
-		build_ino_tree(mp, agno, &fino_btree_curs,
-				XFS_BTNUM_FINO, NULL);
-		write_cursor(&fino_btree_curs);
-	}
+	build_inobt(&sc, agno, &btr_ino, &agi_stat);
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		build_finobt(&sc, agno, &btr_fino);
 
 	/* build the agi */
-	build_agi(mp, agno, &ino_btree_curs, &fino_btree_curs, &agi_stat);
+	build_agi(mp, agno, &btr_ino, &btr_fino, &agi_stat);
 
 	/*
 	 * tear down cursors
 	 */
 	finish_rebuild(mp, &btr_bno, lost_fsb);
 	finish_rebuild(mp, &btr_cnt, lost_fsb);
+	finish_rebuild(mp, &btr_ino, lost_fsb);
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		finish_rebuild(mp, &btr_fino, lost_fsb);
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
 		finish_cursor(&rmap_btree_curs);
 	if (xfs_sb_version_hasreflink(&mp->m_sb))
 		finish_cursor(&refcnt_btree_curs);
-	if (xfs_sb_version_hasfinobt(&mp->m_sb))
-		finish_cursor(&fino_btree_curs);
 
 	/*
 	 * release the incore per-AG bno/bcnt trees so the extent nodes

