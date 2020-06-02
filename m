Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EF26C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F65B206C3
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:29:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ir2MqdNr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbgFBE3z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:29:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48138 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFBE3y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:29:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524IFpM121646;
        Tue, 2 Jun 2020 04:29:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=WCHwbCEXAKr9k7uey2RA24DXqDcmtMbo7D1JlkKwxBk=;
 b=ir2MqdNrRtuTdXV0b0aYjMLMDsu+JrIjYGSEo/x5+oihMoVRzyt2PCGqQwri20rKvuA3
 3JHcUuCW2xI8Rn90IRJ6InXdh4fx0eGo6v+pEADUsZLVV8H2NsDNJOhAllX+RxBiqCk1
 NklMS/l+RiqKX49/fmfhGrodYPrqi9Kzud3NcarTSGpSWfUrI9WohhALY/bYGOPlu7WG
 P8wuOJuU5UPdpren0lug2P/oizx1gAMdJwOkSa3AeuYXTmbpASFQypc7cFH+LFjYl34S
 RIOLWEyNj75z0gt7cqVYfOjmZb5zAbulTCjH+91r8kFA0cYAo8r7MZ8AGTXQzxyaH3Oa ow== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31d5qr20wg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:29:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524Hwan040140;
        Tue, 2 Jun 2020 04:27:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31c18sghjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:27:47 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0524RkK7021691;
        Tue, 2 Jun 2020 04:27:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:27:45 -0700
Subject: [PATCH 08/12] xfs_repair: rebuild inode btrees with bulk loader
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 01 Jun 2020 21:27:44 -0700
Message-ID: <159107206472.315004.3781193870434332876.stgit@magnolia>
In-Reply-To: <159107201290.315004.4447998785149331259.stgit@magnolia>
References: <159107201290.315004.4447998785149331259.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=2 spamscore=0 phishscore=0
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

Use the btree bulk loading functions to rebuild the inode btrees
and drop the open-coded implementation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    1 
 repair/agbtree.c         |  207 ++++++++++++++++++++
 repair/agbtree.h         |   13 +
 repair/phase5.c          |  488 +++-------------------------------------------
 4 files changed, 248 insertions(+), 461 deletions(-)


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
diff --git a/repair/agbtree.c b/repair/agbtree.c
index 3b8ab47c..e44475fc 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -308,3 +308,210 @@ _("Error %d while creating cntbt btree for AG %u.\n"), error, agno);
 	libxfs_btree_del_cursor(btr_bno->cur, 0);
 	libxfs_btree_del_cursor(btr_cnt->cur, 0);
 }
+
+/* Inode Btrees */
+
+static inline struct ino_tree_node *
+get_ino_rec(
+	struct xfs_btree_cur	*cur,
+	struct ino_tree_node	*prev_value)
+{
+	xfs_agnumber_t		agno = cur->bc_ag.agno;
+
+	if (cur->bc_btnum == XFS_BTNUM_INO) {
+		if (!prev_value)
+			return findfirst_inode_rec(agno);
+		return next_ino_rec(prev_value);
+	}
+
+	/* finobt */
+	if (!prev_value)
+		return findfirst_free_inode_rec(agno);
+	return next_free_ino_rec(prev_value);
+}
+
+/* Grab one inobt record. */
+static int
+get_inobt_record(
+	struct xfs_btree_cur		*cur,
+	void				*priv)
+{
+	struct bt_rebuild		*btr = priv;
+	struct xfs_inobt_rec_incore	*irec = &cur->bc_rec.i;
+	struct ino_tree_node		*ino_rec;
+	int				inocnt = 0;
+	int				finocnt = 0;
+	int				k;
+
+	btr->ino_rec = ino_rec = get_ino_rec(cur, btr->ino_rec);
+
+	/* Transform the incore record into an on-disk record. */
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
+	}
+
+	irec->ir_count = inocnt;
+	irec->ir_freecount = finocnt;
+
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
+
+		irec->ir_holemask = holemask;
+	} else {
+		irec->ir_holemask = 0;
+	}
+
+	if (btr->first_agino == NULLAGINO)
+		btr->first_agino = ino_rec->ino_startnum;
+	btr->freecount += finocnt;
+	btr->count += inocnt;
+	return 0;
+}
+
+/* Initialize both inode btree cursors as needed. */
+void
+init_ino_cursors(
+	struct repair_ctx	*sc,
+	xfs_agnumber_t		agno,
+	unsigned int		free_space,
+	uint64_t		*num_inos,
+	uint64_t		*num_free_inos,
+	struct bt_rebuild	*btr_ino,
+	struct bt_rebuild	*btr_fino)
+{
+	struct ino_tree_node	*ino_rec;
+	unsigned int		ino_recs = 0;
+	unsigned int		fino_recs = 0;
+	bool			finobt;
+	int			error;
+
+	finobt = xfs_sb_version_hasfinobt(&sc->mp->m_sb);
+	init_rebuild(sc, &XFS_RMAP_OINFO_INOBT, free_space, btr_ino);
+
+	/* Compute inode statistics. */
+	*num_free_inos = 0;
+	*num_inos = 0;
+	for (ino_rec = findfirst_inode_rec(agno);
+	     ino_rec != NULL;
+	     ino_rec = next_ino_rec(ino_rec))  {
+		unsigned int	rec_ninos = 0;
+		unsigned int	rec_nfinos = 0;
+		int		i;
+
+		for (i = 0; i < XFS_INODES_PER_CHUNK; i++)  {
+			ASSERT(is_inode_confirmed(ino_rec, i));
+			/*
+			 * sparse inodes are not factored into superblock (free)
+			 * inode counts
+			 */
+			if (is_inode_sparse(ino_rec, i))
+				continue;
+			if (is_inode_free(ino_rec, i))
+				rec_nfinos++;
+			rec_ninos++;
+		}
+
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
+	btr_ino->bload.get_record = get_inobt_record;
+	btr_ino->bload.claim_block = rebuild_claim_block;
+	btr_ino->first_agino = NULLAGINO;
+
+	/* Compute how many inobt blocks we'll need. */
+	error = -libxfs_btree_bload_compute_geometry(btr_ino->cur,
+			&btr_ino->bload, ino_recs);
+	if (error)
+		do_error(
+_("Unable to compute inode btree geometry, error %d.\n"), error);
+
+	reserve_btblocks(sc->mp, agno, btr_ino, btr_ino->bload.nr_blocks);
+
+	if (!finobt)
+		return;
+
+	init_rebuild(sc, &XFS_RMAP_OINFO_INOBT, free_space, btr_fino);
+	btr_fino->cur = libxfs_inobt_stage_cursor(sc->mp,
+			&btr_fino->newbt.afake, agno, XFS_BTNUM_FINO);
+
+	btr_fino->bload.get_record = get_inobt_record;
+	btr_fino->bload.claim_block = rebuild_claim_block;
+	btr_fino->first_agino = NULLAGINO;
+
+	/* Compute how many finobt blocks we'll need. */
+	error = -libxfs_btree_bload_compute_geometry(btr_fino->cur,
+			&btr_fino->bload, fino_recs);
+	if (error)
+		do_error(
+_("Unable to compute free inode btree geometry, error %d.\n"), error);
+
+	reserve_btblocks(sc->mp, agno, btr_fino, btr_fino->bload.nr_blocks);
+}
+
+/* Rebuild the inode btrees. */
+void
+build_inode_btrees(
+	struct repair_ctx	*sc,
+	xfs_agnumber_t		agno,
+	struct bt_rebuild	*btr_ino,
+	struct bt_rebuild	*btr_fino)
+{
+	int			error;
+
+	/* Add all observed inobt records. */
+	error = -libxfs_btree_bload(btr_ino->cur, &btr_ino->bload, btr_ino);
+	if (error)
+		do_error(
+_("Error %d while creating inobt btree for AG %u.\n"), error, agno);
+
+	/* Since we're not writing the AGI yet, no need to commit the cursor */
+	libxfs_btree_del_cursor(btr_ino->cur, 0);
+
+	if (!xfs_sb_version_hasfinobt(&sc->mp->m_sb))
+		return;
+
+	/* Add all observed finobt records. */
+	error = -libxfs_btree_bload(btr_fino->cur, &btr_fino->bload, btr_fino);
+	if (error)
+		do_error(
+_("Error %d while creating finobt btree for AG %u.\n"), error, agno);
+
+	/* Since we're not writing the AGI yet, no need to commit the cursor */
+	libxfs_btree_del_cursor(btr_fino->cur, 0);
+}
diff --git a/repair/agbtree.h b/repair/agbtree.h
index 63352247..3cad2a8e 100644
--- a/repair/agbtree.h
+++ b/repair/agbtree.h
@@ -24,6 +24,12 @@ struct bt_rebuild {
 			struct extent_tree_node	*bno_rec;
 			unsigned int		freeblks;
 		};
+		struct {
+			struct ino_tree_node	*ino_rec;
+			xfs_agino_t		first_agino;
+			xfs_agino_t		count;
+			xfs_agino_t		freecount;
+		};
 	};
 };
 
@@ -36,4 +42,11 @@ void init_freespace_cursors(struct repair_ctx *sc, xfs_agnumber_t agno,
 void build_freespace_btrees(struct repair_ctx *sc, xfs_agnumber_t agno,
 		struct bt_rebuild *btr_bno, struct bt_rebuild *btr_cnt);
 
+void init_ino_cursors(struct repair_ctx *sc, xfs_agnumber_t agno,
+		unsigned int free_space, uint64_t *num_inos,
+		uint64_t *num_free_inos, struct bt_rebuild *btr_ino,
+		struct bt_rebuild *btr_fino);
+void build_inode_btrees(struct repair_ctx *sc, xfs_agnumber_t agno,
+		struct bt_rebuild *btr_ino, struct bt_rebuild *btr_fino);
+
 #endif /* __XFS_REPAIR_AG_BTREE_H__ */
diff --git a/repair/phase5.c b/repair/phase5.c
index a93d900d..e570349d 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -67,15 +67,6 @@ typedef struct bt_status  {
 	uint64_t		owner;		/* owner */
 } bt_status_t;
 
-/*
- * extra metadata for the agi
- */
-struct agi_stat {
-	xfs_agino_t		first_agino;
-	xfs_agino_t		count;
-	xfs_agino_t		freecount;
-};
-
 static uint64_t	*sb_icount_ag;		/* allocated inodes per ag */
 static uint64_t	*sb_ifree_ag;		/* free inodes per ag */
 static uint64_t	*sb_fdblocks_ag;	/* free data blocks per ag */
@@ -369,229 +360,20 @@ btnum_to_ops(
 	}
 }
 
-/*
- * XXX(hch): any reason we don't just look at mp->m_inobt_mxr?
- */
-#define XR_INOBT_BLOCK_MAXRECS(mp, level) \
-			libxfs_inobt_maxrecs((mp), (mp)->m_sb.sb_blocksize, \
-						(level) == 0)
-
-/*
- * we don't have to worry here about how chewing up free extents
- * may perturb things because inode tree building happens before
- * freespace tree building.
- */
-static void
-init_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
-		uint64_t *num_inos, uint64_t *num_free_inos, int finobt)
-{
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
-
-	*num_inos = *num_free_inos = 0;
-	ninos = nfinos = 0;
-
-	lptr = &btree_curs->level[0];
-	btree_curs->init = 1;
-	btree_curs->owner = XFS_RMAP_OWN_INOBT;
-
-	/*
-	 * build up statistics
-	 */
-	ino_rec = findfirst_inode_rec(agno);
-	for (num_recs = 0; ino_rec != NULL; ino_rec = next_ino_rec(ino_rec))  {
-		rec_ninos = 0;
-		rec_nfinos = 0;
-		for (i = 0; i < XFS_INODES_PER_CHUNK; i++)  {
-			ASSERT(is_inode_confirmed(ino_rec, i));
-			/*
-			 * sparse inodes are not factored into superblock (free)
-			 * inode counts
-			 */
-			if (is_inode_sparse(ino_rec, i))
-				continue;
-			if (is_inode_free(ino_rec, i))
-				rec_nfinos++;
-			rec_ninos++;
-		}
-
-		/*
-		 * finobt only considers records with free inodes
-		 */
-		if (finobt && !rec_nfinos)
-			continue;
-
-		nfinos += rec_nfinos;
-		ninos += rec_ninos;
-		num_recs++;
-	}
-
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
-
-		return;
-	}
-
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
-		}
-	}
-	ASSERT(lptr->num_blocks == 1);
-	btree_curs->num_levels = level;
-
-	btree_curs->num_tot_blocks = btree_curs->num_free_blocks
-			= blocks_allocated;
-
-	setup_cursor(mp, agno, btree_curs);
-
-	*num_inos = ninos;
-	*num_free_inos = nfinos;
-
-	return;
-}
-
-static void
-prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
-	xfs_btnum_t btnum, xfs_agino_t startino, int level)
-{
-	struct xfs_btree_block	*bt_hdr;
-	xfs_inobt_key_t		*bt_key;
-	xfs_inobt_ptr_t		*bt_ptr;
-	xfs_agblock_t		agbno;
-	bt_stat_level_t		*lptr;
-	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
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
-		libxfs_btree_init_block(mp, lptr->buf_p, btnum,
-					level, 0, agno);
-
-		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
-
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
-}
-
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
+	struct bt_rebuild	*btr_fino)
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
@@ -611,11 +393,11 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 	else
 		agi->agi_length = cpu_to_be32(mp->m_sb.sb_dblocks -
 			(xfs_rfsblock_t) mp->m_sb.sb_agblocks * agno);
-	agi->agi_count = cpu_to_be32(agi_stat->count);
-	agi->agi_root = cpu_to_be32(btree_curs->root);
-	agi->agi_level = cpu_to_be32(btree_curs->num_levels);
-	agi->agi_freecount = cpu_to_be32(agi_stat->freecount);
-	agi->agi_newino = cpu_to_be32(agi_stat->first_agino);
+	agi->agi_count = cpu_to_be32(btr_ino->count);
+	agi->agi_root = cpu_to_be32(btr_ino->newbt.afake.af_root);
+	agi->agi_level = cpu_to_be32(btr_ino->newbt.afake.af_levels);
+	agi->agi_freecount = cpu_to_be32(btr_ino->freecount);
+	agi->agi_newino = cpu_to_be32(btr_ino->first_agino);
 	agi->agi_dirino = cpu_to_be32(NULLAGINO);
 
 	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++)
@@ -625,203 +407,16 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
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
@@ -1744,15 +1339,10 @@ phase5_func(
 	struct xfs_slab		*lost_fsb)
 {
 	struct repair_ctx	sc = { .mp = mp, };
-	struct agi_stat		agi_stat = {0,};
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
@@ -1785,19 +1375,8 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
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
@@ -1886,36 +1465,23 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, &rmap_btree_curs,
 			&refcnt_btree_curs, lost_fsb);
 
-	/*
-	 * build inode allocation tree.
-	 */
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
+	build_inode_btrees(&sc, agno, &btr_ino, &btr_fino);
 
 	/* build the agi */
-	build_agi(mp, agno, &ino_btree_curs, &fino_btree_curs, &agi_stat);
+	build_agi(mp, agno, &btr_ino, &btr_fino);
 
 	/*
 	 * tear down cursors
 	 */
 	finish_rebuild(mp, &btr_bno, lost_fsb);
 	finish_rebuild(mp, &btr_cnt, lost_fsb);
-	finish_cursor(&ino_btree_curs);
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

