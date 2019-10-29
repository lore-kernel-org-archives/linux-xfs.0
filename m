Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90BD2CA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 437DF20862
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:46:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="obauXpYF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbfJ2XqG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 19:46:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36536 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfJ2XqG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 19:46:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNdjNK024085;
        Tue, 29 Oct 2019 23:46:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=KFKUUJGRYnu90HFl+Z6WwocG3sUkVKQ5emge9ljlwQ0=;
 b=obauXpYFYs5Uwx/Xy1FU+6loyJw6+v/yci5yQvI0afBNpyj3g66SR8itiYwCckbIhW1Y
 TcLq7Ub26taWl2TNqyaLSQ5traE8P3vBselcH0DRbdjkyu1tt6z/CC9TBCjQLlB9iqJC
 I3r+9at6U5Td04jDHLXDoDyOiPJBzyvQp8cxJAZqwFj3RjCkXuAVLR7ThwjNkwIUlC7D
 T8/eA+lM4qXtUVKA9DTEjinI+irDG/8U38yJznGTIiyUBJujuR4QUYFCHAotXDCMybJJ
 VH/U8kxOqN+uZUtHiwz6xZKgFJBT03fUzG2URadwmspVQ6ZUwkzn6Ye8CCamBxMNQJCl tw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vxwhf8c5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 23:46:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNhNiX010634;
        Tue, 29 Oct 2019 23:46:01 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2vxwj55gcx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 23:46:01 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9TNjxQG013517;
        Tue, 29 Oct 2019 23:46:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 16:45:59 -0700
Subject: [PATCH 5/9] xfs_repair: rebuild inode btrees with bulk loader
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 29 Oct 2019 16:45:57 -0700
Message-ID: <157239275764.1277435.1340541889143147200.stgit@magnolia>
In-Reply-To: <157239272641.1277435.17698788915454836309.stgit@magnolia>
References: <157239272641.1277435.17698788915454836309.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290208
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290208
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
 repair/phase5.c          |  607 +++++++++++++++++-----------------------------
 2 files changed, 227 insertions(+), 381 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 80ca13b6..78801864 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -162,5 +162,6 @@
 #define xfs_btree_bload_compute_geometry libxfs_btree_bload_compute_geometry
 #define xfs_btree_bload			libxfs_btree_bload
 #define xfs_allocbt_stage_cursor	libxfs_allocbt_stage_cursor
+#define xfs_inobt_stage_cursor		libxfs_inobt_stage_cursor
 
 #endif /* __LIBXFS_API_DEFS_H__ */
diff --git a/repair/phase5.c b/repair/phase5.c
index 2421c4bc..1285527a 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -75,6 +75,10 @@ struct bt_rebuild {
 			struct extent_tree_node	*bno_rec;
 			xfs_agblock_t		*freeblks;
 		};
+		struct {
+			struct ino_tree_node	*ino_rec;
+			struct agi_stat		*agi_stat;
+		};
 	};
 };
 
@@ -764,48 +768,40 @@ _("Error %d while writing cntbt btree for AG %u.\n"), error, agno);
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
+	struct xfs_btree_cur	*cur;
+	struct ino_tree_node	*ino_rec;
+	unsigned int		ino_recs = 0;
+	unsigned int		fino_recs = 0;
+	bool			finobt;
+	int			error;
 
-	*num_inos = *num_free_inos = 0;
-	ninos = nfinos = 0;
+	finobt = xfs_sb_version_hasfinobt(&sc->mp->m_sb);
+	init_rebuild(sc, &XFS_RMAP_OINFO_INOBT, free_space, btr_ino);
+	init_rebuild(sc, &XFS_RMAP_OINFO_INOBT, free_space, btr_fino);
 
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
@@ -819,168 +815,222 @@ init_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 			rec_ninos++;
 		}
 
-		/*
-		 * finobt only considers records with free inodes
-		 */
-		if (finobt && !rec_nfinos)
-			continue;
+		*num_free_inos += rec_nfinos;
+		*num_inos += rec_ninos;
+		ino_recs++;
 
-		nfinos += rec_nfinos;
-		ninos += rec_ninos;
-		num_recs++;
+		/* finobt only considers records with free inodes */
+		if (rec_nfinos)
+			fino_recs++;
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
+	/* Compute how many inobt blocks we'll need. */
+	cur = libxfs_inobt_stage_cursor(sc->mp, sc->tp,
+			&btr_ino->newbt.afake, agno, XFS_BTNUM_INO);
+	error = -libxfs_btree_bload_compute_geometry(cur, &btr_ino->bload,
+			ino_recs);
+	if (error)
+		do_error(
+_("Unable to compute inode btree geometry, error %d.\n"), error);
+	libxfs_btree_del_cursor(cur, error);
 
-		setup_cursor(mp, agno, btree_curs);
+	setup_rebuild(sc->mp, agno, btr_ino, btr_ino->bload.nr_blocks);
 
+	if (!finobt)
 		return;
-	}
 
-	blocks_allocated = lptr->num_blocks = howmany(num_recs,
-					XR_INOBT_BLOCK_MAXRECS(mp, 0));
+	/* Compute how many finobt blocks we'll need. */
+	cur = libxfs_inobt_stage_cursor(sc->mp, sc->tp,
+			&btr_fino->newbt.afake, agno, XFS_BTNUM_FINO);
+	error = -libxfs_btree_bload_compute_geometry(cur, &btr_fino->bload,
+			fino_recs);
+	if (error)
+		do_error(
+_("Unable to compute free inode btree geometry, error %d.\n"), error);
+	libxfs_btree_del_cursor(cur, error);
 
-	lptr->modulo = num_recs % lptr->num_blocks;
-	lptr->num_recs_pb = num_recs / lptr->num_blocks;
-	lptr->num_recs_tot = num_recs;
-	level = 1;
+	setup_rebuild(sc->mp, agno, btr_fino, btr_fino->bload.nr_blocks);
+}
 
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
 
-			blocks_allocated += lptr->num_blocks;
-		}
+	irec->ir_startino = ino_rec->ino_startnum;
+	irec->ir_free = ino_rec->ir_free;
+
+	for (k = 0; k < sizeof(xfs_inofree_t) * NBBY; k++)  {
+		ASSERT(is_inode_confirmed(ino_rec, k));
+
+		if (is_inode_sparse(ino_rec, k))
+			continue;
+		if (is_inode_free(ino_rec, k))
+			finocnt++;
+		inocnt++;
 	}
-	ASSERT(lptr->num_blocks == 1);
-	btree_curs->num_levels = level;
 
-	btree_curs->num_tot_blocks = btree_curs->num_free_blocks
-			= blocks_allocated;
+	irec->ir_count = inocnt;
+	irec->ir_freecount = finocnt;
 
-	setup_cursor(mp, agno, btree_curs);
+	if (xfs_sb_version_hassparseinodes(&cur->bc_mp->m_sb)) {
+		uint64_t		sparse;
+		int			spmask;
+		uint16_t		holemask;
+
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
+		}
 
-	*num_inos = ninos;
-	*num_free_inos = nfinos;
+		irec->ir_holemask = holemask;
+	} else {
+		irec->ir_holemask = 0;
+	}
 
-	return;
+	if (!agi_stat)
+		return;
+
+	if (agi_stat->first_agino != NULLAGINO)
+		agi_stat->first_agino = ino_rec->ino_startnum;
+	agi_stat->freecount += finocnt;
+	agi_stat->count += inocnt;
 }
 
-static void
-prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
-	xfs_btnum_t btnum, xfs_agino_t startino, int level)
+/* Grab one inobt record. */
+static int
+get_inobt_data(
+	struct xfs_btree_cur		*cur,
+	void				*priv)
 {
-	struct xfs_btree_block	*bt_hdr;
-	xfs_inobt_key_t		*bt_key;
-	xfs_inobt_ptr_t		*bt_ptr;
-	xfs_agblock_t		agbno;
-	bt_stat_level_t		*lptr;
-	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
+	struct bt_rebuild		*rebuild = priv;
 
-	level++;
+	get_inode_data(cur, rebuild->ino_rec, rebuild->agi_stat);
+	rebuild->ino_rec = next_ino_rec(rebuild->ino_rec);
+	return 0;
+}
 
-	if (level >= btree_curs->num_levels)
-		return;
+/* Rebuild a inobt btree. */
+static void
+build_inobt(
+	struct repair_ctx	*sc,
+	xfs_agnumber_t		agno,
+	struct bt_rebuild	*btr_ino,
+	struct agi_stat		*agi_stat)
+{
+	struct xfs_btree_cur	*cur;
+	int			error;
 
-	lptr = &btree_curs->level[level];
-	bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
+	btr_ino->bload.get_data = get_inobt_data;
+	btr_ino->bload.alloc_block = rebuild_alloc_block;
+	agi_stat->count = agi_stat->freecount = 0;
+	agi_stat->first_agino = NULLAGINO;
+	btr_ino->agi_stat = agi_stat;
+	btr_ino->ino_rec = findfirst_inode_rec(agno);
 
-	if (be16_to_cpu(bt_hdr->bb_numrecs) == 0)  {
-		/*
-		 * this only happens once to initialize the
-		 * first path up the left side of the tree
-		 * where the agbno's are already set up
-		 */
-		prop_ino_cursor(mp, agno, btree_curs, btnum, startino, level);
-	}
+	error = -libxfs_trans_alloc_empty(sc->mp, &sc->tp);
+	if (error)
+		do_error(
+_("Insufficient memory to construct inobt rebuild transaction.\n"));
 
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
-		lptr->prev_agbno = lptr->agbno;;
-		lptr->prev_buf_p = lptr->buf_p;
-		agbno = get_next_blockaddr(agno, level, btree_curs);
+	/* Add all observed inobt records. */
+	cur = libxfs_inobt_stage_cursor(sc->mp, sc->tp,
+			&btr_ino->newbt.afake, agno, XFS_BTNUM_INO);
+	error = -libxfs_btree_bload(cur, &btr_ino->bload, btr_ino);
+	if (error)
+		do_error(
+_("Error %d while creating inobt btree for AG %u.\n"), error, agno);
 
-		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(agbno);
+	/* Since we're not writing the AGI yet, no need to commit the cursor */
+	libxfs_btree_del_cursor(cur, 0);
+	error = -libxfs_trans_commit(sc->tp);
+	if (error)
+		do_error(
+_("Error %d while writing inobt btree for AG %u.\n"), error, agno);
+	sc->tp = NULL;
+}
 
-		lptr->buf_p = libxfs_getbuf(mp->m_dev,
-					XFS_AGB_TO_DADDR(mp, agno, agbno),
-					XFS_FSB_TO_BB(mp, 1));
-		lptr->agbno = agbno;
+/* Grab one finobt record. */
+static int
+get_finobt_data(
+	struct xfs_btree_cur		*cur,
+	void				*priv)
+{
+	struct bt_rebuild		*rebuild = priv;
 
-		if (lptr->modulo)
-			lptr->modulo--;
+	get_inode_data(cur, rebuild->ino_rec, NULL);
+	rebuild->ino_rec = next_free_ino_rec(rebuild->ino_rec);
+	return 0;
+}
 
-		/*
-		 * initialize block header
-		 */
-		lptr->buf_p->b_ops = ops;
-		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
-		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
-		libxfs_btree_init_block(mp, lptr->buf_p, btnum,
-					level, 0, agno);
+/* Rebuild a finobt btree. */
+static void
+build_finobt(
+	struct repair_ctx	*sc,
+	xfs_agnumber_t		agno,
+	struct bt_rebuild	*btr_fino)
+{
+	struct xfs_btree_cur	*cur;
+	int			error;
 
-		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
+	btr_fino->bload.get_data = get_finobt_data;
+	btr_fino->bload.alloc_block = rebuild_alloc_block;
+	btr_fino->ino_rec = findfirst_free_inode_rec(agno);
 
-		/*
-		 * propagate extent record for first extent in new block up
-		 */
-		prop_ino_cursor(mp, agno, btree_curs, btnum, startino, level);
-	}
-	/*
-	 * add inode info to current block
-	 */
-	be16_add_cpu(&bt_hdr->bb_numrecs, 1);
+	error = -libxfs_trans_alloc_empty(sc->mp, &sc->tp);
+	if (error)
+		do_error(
+_("Insufficient memory to construct finobt rebuild transaction.\n"));
 
-	bt_key = XFS_INOBT_KEY_ADDR(mp, bt_hdr,
-				    be16_to_cpu(bt_hdr->bb_numrecs));
-	bt_ptr = XFS_INOBT_PTR_ADDR(mp, bt_hdr,
-				    be16_to_cpu(bt_hdr->bb_numrecs),
-				    M_IGEO(mp)->inobt_mxr[1]);
+	/* Add all observed finobt records. */
+	cur = libxfs_inobt_stage_cursor(sc->mp, sc->tp,
+			&btr_fino->newbt.afake, agno, XFS_BTNUM_FINO);
+	error = -libxfs_btree_bload(cur, &btr_fino->bload, btr_fino);
+	if (error)
+		do_error(
+_("Error %d while creating finobt btree for AG %u.\n"), error, agno);
 
-	bt_key->ir_startino = cpu_to_be32(startino);
-	*bt_ptr = cpu_to_be32(btree_curs->level[level-1].agbno);
+	/* Since we're not writing the AGI yet, no need to commit the cursor */
+	libxfs_btree_del_cursor(cur, 0);
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
+	struct bt_rebuild	*ino_bt,
+	struct bt_rebuild	*fino_bt,
+	struct agi_stat		*agi_stat)
 {
-	xfs_buf_t	*agi_buf;
-	xfs_agi_t	*agi;
-	int		i;
+	struct xfs_buf		*agi_buf;
+	struct xfs_agi		*agi;
+	int			i;
 
 	agi_buf = libxfs_getbuf(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
@@ -998,8 +1048,8 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 		agi->agi_length = cpu_to_be32(mp->m_sb.sb_dblocks -
 			(xfs_rfsblock_t) mp->m_sb.sb_agblocks * agno);
 	agi->agi_count = cpu_to_be32(agi_stat->count);
-	agi->agi_root = cpu_to_be32(btree_curs->root);
-	agi->agi_level = cpu_to_be32(btree_curs->num_levels);
+	agi->agi_root = cpu_to_be32(ino_bt->newbt.afake.af_root);
+	agi->agi_level = cpu_to_be32(ino_bt->newbt.afake.af_levels);
 	agi->agi_freecount = cpu_to_be32(agi_stat->freecount);
 	agi->agi_newino = cpu_to_be32(agi_stat->first_agino);
 	agi->agi_dirino = cpu_to_be32(NULLAGINO);
@@ -1011,192 +1061,13 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 		platform_uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid);
 
 	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
-		agi->agi_free_root = cpu_to_be32(finobt_curs->root);
-		agi->agi_free_level = cpu_to_be32(finobt_curs->num_levels);
+		agi->agi_free_root = cpu_to_be32(fino_bt->newbt.afake.af_root);
+		agi->agi_free_level = cpu_to_be32(fino_bt->newbt.afake.af_levels);
 	}
 
 	libxfs_writebuf(agi_buf, 0);
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
-
-	ASSERT(btnum == XFS_BTNUM_INO || btnum == XFS_BTNUM_FINO);
-
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
@@ -2082,14 +1953,10 @@ phase5_func(
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
@@ -2126,21 +1993,8 @@ phase5_func(
 			agno);
 	}
 
-	/*
-	 * ok, now set up the btree cursors for the
-	 * on-disk btrees (includs pre-allocating all
-	 * required blocks for the trees themselves)
-	 */
-	init_ino_cursor(mp, agno, &ino_btree_curs, &num_inos,
-			&num_free_inos, 0);
-
-	if (xfs_sb_version_hasfinobt(&mp->m_sb))
-		init_ino_cursor(mp, agno, &fino_btree_curs,
-				&finobt_num_inos, &finobt_num_free_inos,
-				1);
-
-	sb_icount_ag[agno] += num_inos;
-	sb_ifree_ag[agno] += num_free_inos;
+	init_ino_cursors(&sc, agno, num_freeblocks, &sb_icount_ag[agno],
+			&sb_ifree_ag[agno], &btr_ino, &btr_fino);
 
 	/*
 	 * Set up the btree cursors for the on-disk rmap btrees,
@@ -2237,36 +2091,27 @@ phase5_func(
 			&rmap_btree_curs, &refcnt_btree_curs, lost_fsb);
 
 	/*
-	 * build inode allocation tree.
+	 * build inode allocation trees.
 	 */
-	build_ino_tree(mp, agno, &ino_btree_curs, XFS_BTNUM_INO,
-			&agi_stat);
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
-	build_agi(mp, agno, &ino_btree_curs, &fino_btree_curs,
-		  &agi_stat);
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
 	 * release the incore per-AG bno/bcnt trees so

