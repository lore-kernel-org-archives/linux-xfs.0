Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18221 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753593AbcKEAXB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:23:01 -0400
Subject: [PATCH 36/41] xfs: repair inode btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:22:58 -0700
Message-ID: <147830537835.2155.17850078750990350851.stgit@birch.djwong.org>
In-Reply-To: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
References: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Use the rmapbt to find inode chunks, query the chunks to compute
hole and free masks, and with that information rebuild the inobt
and finobt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ialloc.c |    2 
 fs/xfs/libxfs/xfs_ialloc.h |    3 
 fs/xfs/xfs_scrub.c         |  345 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 346 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 900978e..ed8f591 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -147,7 +147,7 @@ xfs_inobt_get_rec(
 /*
  * Insert a single inobt record. Cursor must already point to desired location.
  */
-STATIC int
+int
 xfs_inobt_insert_rec(
 	struct xfs_btree_cur	*cur,
 	__uint16_t		holemask,
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index f20d958..afcb250 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -175,5 +175,8 @@ int xfs_ialloc_has_inodes_at_extent(struct xfs_btree_cur *cur,
 		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
 int xfs_ialloc_has_inode_record(struct xfs_btree_cur *cur, xfs_agino_t low,
 		xfs_agino_t high, bool *exists);
+int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, __uint16_t holemask,
+		__uint8_t count, __int32_t freecount, xfs_inofree_t free,
+		int *stat);
 
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index def1209..4b46f03 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -2062,11 +2062,13 @@ xfs_scrub_setup(
 	bool				retry_deadlocked)
 {
 	struct xfs_mount		*mp = ip->i_mount;
+	xfs_extlen_t			resblks;
 
 	memset(sc, 0, sizeof(*sc));
 	sc->sm = sm;
+	resblks = xfs_scrub_calc_ag_resblks(sc, ip, sm);
 	return xfs_scrub_trans_alloc(sm, mp, &M_RES(mp)->tr_itruncate,
-			0, 0, 0, &sc->tp);
+			resblks, 0, 0, &sc->tp);
 }
 
 /* Set us up to check an AG header. */
@@ -3597,6 +3599,343 @@ xfs_scrub_finobt(
 	return xfs_scrub_iallocbt(sc, XFS_BTNUM_FINO);
 }
 
+struct xfs_repair_ialloc_extent {
+	struct list_head		list;
+	xfs_inofree_t			freemask;
+	xfs_agino_t			startino;
+	unsigned int			count;
+	unsigned int			usedcount;
+	__uint16_t			holemask;
+};
+
+struct xfs_repair_ialloc {
+	struct list_head		extlist;
+	struct list_head		btlist;
+	uint64_t			nr_records;
+};
+
+/* Record extents that belong to inode btrees. */
+STATIC int
+xfs_repair_ialloc_extent_fn(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*priv)
+{
+	struct xfs_imap			imap;
+	struct xfs_repair_ialloc	*ri = priv;
+	struct xfs_repair_ialloc_extent	*rie;
+	struct xfs_dinode		*dip;
+	struct xfs_buf			*bp;
+	struct xfs_mount		*mp = cur->bc_mp;
+	xfs_ino_t			fsino;
+	xfs_inofree_t			usedmask;
+	xfs_fsblock_t			fsbno;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+	xfs_agino_t			agino;
+	xfs_agino_t			startino;
+	xfs_agino_t			chunkino;
+	xfs_agino_t			nr_inodes;
+	xfs_agino_t			i;
+	__uint16_t			fillmask;
+	int				blks_per_cluster;
+	int				usedcount;
+	int				error;
+
+	/* Fragment of the old btrees; dispose of them later. */
+	if (rec->rm_owner == XFS_RMAP_OWN_INOBT) {
+		fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
+				rec->rm_startblock);
+		return xfs_repair_collect_btree_extent(&ri->btlist,
+				fsbno, rec->rm_blockcount);
+	}
+
+	/* Skip extents which are not owned by this inode and fork. */
+	if (rec->rm_owner != XFS_RMAP_OWN_INODES)
+		return 0;
+
+	agno = cur->bc_private.a.agno;
+	blks_per_cluster = xfs_icluster_size_fsb(mp);
+
+	ASSERT(rec->rm_startblock % blks_per_cluster == 0);
+
+	for (agbno = rec->rm_startblock;
+	     agbno < rec->rm_startblock + rec->rm_blockcount;
+	     agbno += blks_per_cluster) {
+		agino = XFS_OFFBNO_TO_AGINO(mp, agbno, 0);
+		fsino = XFS_AGINO_TO_INO(mp, agno, agino);
+		chunkino = agino & (XFS_INODES_PER_CHUNK - 1);
+		startino = agino & ~(XFS_INODES_PER_CHUNK - 1);
+		nr_inodes = XFS_OFFBNO_TO_AGINO(mp, blks_per_cluster, 0);
+
+		/* Which inodes are not holes? */
+		fillmask = xfs_inobt_maskn(
+				chunkino / XFS_INODES_PER_HOLEMASK_BIT,
+				nr_inodes / XFS_INODES_PER_HOLEMASK_BIT);
+
+		/* Grab the inode cluster buffer. */
+		imap.im_blkno = XFS_AGB_TO_DADDR(mp, agno, agbno);
+		imap.im_len = XFS_FSB_TO_BB(mp, blks_per_cluster);
+		imap.im_boffset = 0;
+
+		error = xfs_imap_to_bp(mp, cur->bc_tp, &imap,
+				&dip, &bp, 0, XFS_IGET_UNTRUSTED);
+		if (error)
+			return error;
+
+		/* Which inodes are free? */
+		for (usedmask = 0, usedcount = 0, i = 0; i < nr_inodes; i++) {
+			dip = xfs_buf_offset(bp, i * mp->m_sb.sb_inodesize);
+			if (be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC) {
+				xfs_trans_brelse(cur->bc_tp, bp);
+				return -EFSCORRUPTED;
+			}
+			if (dip->di_version >= 3 &&
+			    be64_to_cpu(dip->di_ino) != fsino + i) {
+				xfs_trans_brelse(cur->bc_tp, bp);
+				return -EFSCORRUPTED;
+			}
+
+			if (dip->di_nlink || dip->di_onlink) {
+				usedmask |= 1ULL << (chunkino + i);
+				usedcount++;
+			}
+		}
+		xfs_trans_brelse(cur->bc_tp, bp);
+
+		/*
+		 * If the last item in the list is our chunk record,
+		 * update that.
+		 */
+		if (!list_empty(&ri->extlist)) {
+			rie = list_last_entry(&ri->extlist,
+					struct xfs_repair_ialloc_extent, list);
+			if (rie->startino == startino) {
+				rie->freemask &= ~usedmask;
+				rie->holemask &= ~fillmask;
+				rie->count += nr_inodes;
+				rie->usedcount += usedcount;
+				continue;
+			}
+		}
+
+		/* New inode chunk; add to the list. */
+		rie = kmem_alloc(sizeof(*rie), KM_NOFS);
+		if (!rie)
+			return -ENOMEM;
+
+		INIT_LIST_HEAD(&rie->list);
+		rie->startino = startino;
+		rie->freemask = XFS_INOBT_ALL_FREE & ~usedmask;
+		rie->holemask = XFS_INOBT_ALL_FREE & ~fillmask;
+		rie->count = nr_inodes;
+		rie->usedcount = usedcount;
+		list_add_tail(&rie->list, &ri->extlist);
+		ri->nr_records++;
+	}
+
+	return 0;
+}
+
+/* Compare two ialloc extents. */
+static int
+xfs_repair_ialloc_extent_cmp(
+	void				*priv,
+	struct list_head		*a,
+	struct list_head		*b)
+{
+	struct xfs_repair_ialloc_extent	*ap;
+	struct xfs_repair_ialloc_extent	*bp;
+
+	ap = container_of(a, struct xfs_repair_ialloc_extent, list);
+	bp = container_of(b, struct xfs_repair_ialloc_extent, list);
+
+	if (ap->startino > bp->startino)
+		return 1;
+	else if (ap->startino < bp->startino)
+		return -1;
+	return 0;
+}
+
+/* Repair both inode btrees. */
+STATIC int
+xfs_repair_iallocbt(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_repair_ialloc	ri;
+	struct xfs_owner_info		oinfo;
+	struct xfs_mount		*mp = sc->tp->t_mountp;
+	struct xfs_buf			*bp;
+	struct xfs_repair_ialloc_extent	*rie;
+	struct xfs_repair_ialloc_extent	*n;
+	struct xfs_agi			*agi;
+	struct xfs_btree_cur		*cur = NULL;
+	struct xfs_perag		*pag;
+	xfs_fsblock_t			inofsb;
+	xfs_fsblock_t			finofsb;
+	xfs_extlen_t			nr_blocks;
+	unsigned int			count;
+	unsigned int			usedcount;
+	int				stat;
+	int				logflags;
+	int				error = 0;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	/* Collect all reverse mappings for inode blocks. */
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
+	INIT_LIST_HEAD(&ri.extlist);
+	INIT_LIST_HEAD(&ri.btlist);
+	ri.nr_records = 0;
+	cur = xfs_rmapbt_init_cursor(mp, sc->tp, sc->sa.agf_bp, sc->sa.agno);
+	error = xfs_rmap_query_all(cur, xfs_repair_ialloc_extent_fn, &ri);
+	if (error)
+		goto out;
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	cur = NULL;
+
+	/* Do we actually have enough space to do this? */
+	pag = xfs_perag_get(mp, sc->sa.agno);
+	nr_blocks = xfs_iallocbt_calc_size(mp, ri.nr_records);
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		nr_blocks *= 2;
+	if (!xfs_repair_ag_has_space(pag, nr_blocks, XFS_AG_RESV_NONE)) {
+		xfs_perag_put(pag);
+		error = -ENOSPC;
+		goto out;
+	}
+	xfs_perag_put(pag);
+
+	agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
+	/* Initialize new btree roots. */
+	error = xfs_repair_alloc_ag_block(sc, &oinfo, &inofsb,
+			XFS_AG_RESV_NONE);
+	if (error)
+		goto out;
+	error = xfs_repair_init_btblock(sc, inofsb, &bp, XFS_IBT_CRC_MAGIC,
+			&xfs_inobt_buf_ops);
+	if (error)
+		goto out;
+	agi->agi_root = cpu_to_be32(XFS_FSB_TO_AGBNO(mp, inofsb));
+	agi->agi_level = cpu_to_be32(1);
+	logflags = XFS_AGI_ROOT | XFS_AGI_LEVEL;
+
+	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+		error = xfs_repair_alloc_ag_block(sc, &oinfo, &finofsb,
+				XFS_AG_RESV_NONE);
+		if (error)
+			goto out;
+		error = xfs_repair_init_btblock(sc, finofsb, &bp,
+				XFS_FIBT_CRC_MAGIC, &xfs_inobt_buf_ops);
+		if (error)
+			goto out;
+		agi->agi_free_root = cpu_to_be32(XFS_FSB_TO_AGBNO(mp, finofsb));
+		agi->agi_free_level = cpu_to_be32(1);
+		logflags |= XFS_AGI_FREE_ROOT | XFS_AGI_FREE_LEVEL;
+	}
+
+	xfs_ialloc_log_agi(sc->tp, sc->sa.agi_bp, logflags);
+	error = xfs_repair_roll_ag_trans(sc);
+	if (error)
+		goto out;
+
+	/* Insert records into the new btrees. */
+	count = 0;
+	usedcount = 0;
+	list_sort(NULL, &ri.extlist, xfs_repair_ialloc_extent_cmp);
+	list_for_each_entry_safe(rie, n, &ri.extlist, list) {
+		count += rie->count;
+		usedcount += rie->usedcount;
+
+		/* Insert into the inobt. */
+		cur = xfs_inobt_init_cursor(mp, sc->tp, sc->sa.agi_bp,
+				sc->sa.agno, XFS_BTNUM_INO);
+		error = xfs_inobt_lookup(cur, rie->startino, XFS_LOOKUP_EQ,
+				&stat);
+		if (error)
+			goto out;
+		XFS_WANT_CORRUPTED_GOTO(mp, stat == 0, out);
+		error = xfs_inobt_insert_rec(cur, rie->holemask, rie->count,
+				rie->count - rie->usedcount, rie->freemask,
+				&stat);
+		if (error)
+			goto out;
+		XFS_WANT_CORRUPTED_GOTO(mp, stat == 1, out);
+		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+		cur = NULL;
+
+		/* Insert into the finobt. */
+		if (rie->count != rie->usedcount &&
+		    xfs_sb_version_hasfinobt(&mp->m_sb)) {
+			cur = xfs_inobt_init_cursor(mp, sc->tp, sc->sa.agi_bp,
+					sc->sa.agno, XFS_BTNUM_FINO);
+			error = xfs_inobt_lookup(cur, rie->startino,
+					XFS_LOOKUP_EQ, &stat);
+			if (error)
+				goto out;
+			XFS_WANT_CORRUPTED_GOTO(mp, stat == 0, out);
+			error = xfs_inobt_insert_rec(cur, rie->holemask,
+					rie->count, rie->count - rie->usedcount,
+					rie->freemask, &stat);
+			if (error)
+				goto out;
+			XFS_WANT_CORRUPTED_GOTO(mp, stat == 1, out);
+			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+			cur = NULL;
+		}
+
+		error = xfs_repair_roll_ag_trans(sc);
+		if (error)
+			goto out;
+
+		list_del(&rie->list);
+		kmem_free(rie);
+	}
+
+	/* Update the AGI counters. */
+	agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
+	if (be32_to_cpu(agi->agi_count) != count ||
+	    be32_to_cpu(agi->agi_freecount) != count - usedcount) {
+		error = xfs_mod_icount(mp,
+				(int64_t)count - be32_to_cpu(agi->agi_count));
+		if (error)
+			goto out;
+		error = xfs_mod_ifree(mp, (int64_t)(count - usedcount) -
+				be32_to_cpu(agi->agi_freecount));
+		if (error)
+			goto out;
+
+		pag = xfs_perag_get(mp, sc->sa.agno);
+		pag->pagi_count = count;
+		pag->pagi_freecount = count - usedcount;
+		xfs_perag_put(pag);
+
+		agi->agi_count = cpu_to_be32(count);
+		agi->agi_freecount = cpu_to_be32(count - usedcount);
+		xfs_ialloc_log_agi(sc->tp, sc->sa.agi_bp,
+				XFS_AGI_COUNT | XFS_AGI_FREECOUNT);
+	}
+
+	/* Free the old inode btree blocks if they're not in use. */
+	error = xfs_repair_reap_btree_extents(sc, &ri.btlist, &oinfo,
+			XFS_AG_RESV_NONE);
+	if (error)
+		goto out;
+
+	return error;
+out:
+	if (cur)
+		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	xfs_repair_cancel_btree_extents(sc, &ri.btlist);
+	list_for_each_entry_safe(rie, n, &ri.extlist, list) {
+		list_del(&rie->list);
+		kmem_free(rie);
+	}
+	return error;
+}
+
 /* Reverse-mapping scrubber. */
 
 /* Scrub an rmapbt record. */
@@ -5524,8 +5863,8 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup_ag_header, xfs_scrub_agi, NULL, NULL},
 	{xfs_scrub_setup_ag_header, xfs_scrub_bnobt, xfs_repair_allocbt, NULL},
 	{xfs_scrub_setup_ag_header, xfs_scrub_cntbt, xfs_repair_allocbt, NULL},
-	{xfs_scrub_setup_ag_header, xfs_scrub_inobt, NULL, NULL},
-	{xfs_scrub_setup_ag_header, xfs_scrub_finobt, NULL, xfs_sb_version_hasfinobt},
+	{xfs_scrub_setup_ag_header, xfs_scrub_inobt, xfs_repair_iallocbt, NULL},
+	{xfs_scrub_setup_ag_header, xfs_scrub_finobt, xfs_repair_iallocbt, xfs_sb_version_hasfinobt},
 	{xfs_scrub_setup_ag_header, xfs_scrub_rmapbt, NULL, xfs_sb_version_hasrmapbt},
 	{xfs_scrub_setup_ag_header, xfs_scrub_refcountbt, NULL, xfs_sb_version_hasreflink},
 	{xfs_scrub_setup_inode, xfs_scrub_inode, NULL, NULL},

