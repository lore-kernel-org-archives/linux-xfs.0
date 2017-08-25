Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27473 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933883AbdHYWS2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2017 18:18:28 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7PMIRpr022872
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:18:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v7PMIRaQ018498
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:18:27 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7PMIQIA009450
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 22:18:26 GMT
Subject: [PATCH 14/19] xfs: repair inode btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 25 Aug 2017 15:18:25 -0700
Message-ID: <150369950540.9957.5734595548507178311.stgit@magnolia>
In-Reply-To: <150369940879.9957.6303798184036268321.stgit@magnolia>
References: <150369940879.9957.6303798184036268321.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the rmapbt to find inode chunks, query the chunks to compute
hole and free masks, and with that information rebuild the inobt
and finobt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/ialloc.c |  411 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h |    1 
 fs/xfs/scrub/scrub.c  |    2 
 3 files changed, 414 insertions(+)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 08baab0..7503ade 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -37,12 +37,15 @@
 #include "xfs_log.h"
 #include "xfs_trans_priv.h"
 #include "xfs_alloc.h"
+#include "xfs_rmap_btree.h"
 #include "xfs_refcount.h"
+#include "xfs_error.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
 #include "scrub/trace.h"
+#include "scrub/repair.h"
 
 /*
  * Set us up to scrub inode btrees.
@@ -463,3 +466,411 @@ xfs_scrub_finobt(
 {
 	return xfs_scrub_iallocbt(sc, XFS_BTNUM_FINO);
 }
+
+/* Inode btree repair. */
+
+struct xfs_repair_ialloc_extent {
+	struct list_head		list;
+	xfs_inofree_t			freemask;
+	xfs_agino_t			startino;
+	unsigned int			count;
+	unsigned int			usedcount;
+	uint16_t			holemask;
+};
+
+struct xfs_repair_ialloc {
+	struct list_head		extlist;
+	struct list_head		btlist;
+	struct xfs_scrub_context	*sc;
+	uint64_t			nr_records;
+};
+
+/* Set usedmask if the inode is in use. */
+STATIC int
+xfs_repair_ialloc_check_free(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp,
+	xfs_ino_t		fsino,
+	xfs_agino_t		bpino,
+	bool			*inuse)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	struct xfs_dinode	*dip;
+	int			error;
+
+	/* Will the in-core inode tell us if it's in use? */
+	error = xfs_icache_inode_is_allocated(mp, cur->bc_tp, fsino, inuse);
+	if (!error)
+		return 0;
+
+	/* Inode uncached or half assembled, read disk buffer */
+	dip = xfs_buf_offset(bp, bpino * mp->m_sb.sb_inodesize);
+	if (be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC)
+		return -EFSCORRUPTED;
+
+	if (dip->di_version >= 3 && be64_to_cpu(dip->di_ino) != fsino)
+		return -EFSCORRUPTED;
+
+	*inuse = dip->di_mode != 0;
+	return 0;
+}
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
+	xfs_agino_t			cdist;
+	xfs_agino_t			startino;
+	xfs_agino_t			clusterino;
+	xfs_agino_t			nr_inodes;
+	xfs_agino_t			inoalign;
+	xfs_agino_t			agino;
+	xfs_agino_t			rmino;
+	uint16_t			fillmask;
+	bool				inuse;
+	int				blks_per_cluster;
+	int				usedcount;
+	int				error = 0;
+
+	if (xfs_scrub_should_terminate(&error))
+		return error;
+
+	/* Fragment of the old btrees; dispose of them later. */
+	if (rec->rm_owner == XFS_RMAP_OWN_INOBT) {
+		fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
+				rec->rm_startblock);
+		return xfs_repair_collect_btree_extent(ri->sc, &ri->btlist,
+				fsbno, rec->rm_blockcount);
+	}
+
+	/* Skip extents which are not owned by this inode and fork. */
+	if (rec->rm_owner != XFS_RMAP_OWN_INODES)
+		return 0;
+
+	agno = cur->bc_private.a.agno;
+	blks_per_cluster = xfs_icluster_size_fsb(mp);
+	nr_inodes = XFS_OFFBNO_TO_AGINO(mp, blks_per_cluster, 0);
+
+	if (rec->rm_startblock % blks_per_cluster != 0)
+		return -EFSCORRUPTED;
+
+	trace_xfs_repair_ialloc_extent_fn(mp, cur->bc_private.a.agno,
+			rec->rm_startblock, rec->rm_blockcount, rec->rm_owner,
+			rec->rm_offset, rec->rm_flags);
+
+	/*
+	 * Determine the inode block alignment, and where the block
+	 * ought to start if it's aligned properly.  On a sparse inode
+	 * system the rmap doesn't have to start on an alignment boundary,
+	 * but the record does.  On pre-sparse filesystems, we /must/
+	 * start both rmap and inobt on an alignment boundary.
+	 */
+	inoalign = xfs_ialloc_cluster_alignment(mp);
+	agbno = rec->rm_startblock;
+	agino = XFS_OFFBNO_TO_AGINO(mp, agbno, 0);
+	rmino = XFS_OFFBNO_TO_AGINO(mp, rounddown(agbno, inoalign), 0);
+	if (!xfs_sb_version_hassparseinodes(&mp->m_sb) && agino != rmino)
+		return -EFSCORRUPTED;
+
+	/*
+	 * For each cluster in this blob of inode, we must calculate the
+	 * properly aligned startino of that cluster, then iterate each
+	 * cluster to fill in used and filled masks appropriately.  We
+	 * then use the (startino, used, filled) information to construct
+	 * the appropriate inode records.
+	 */
+	for (agbno = rec->rm_startblock;
+	     agbno < rec->rm_startblock + rec->rm_blockcount;
+	     agbno += blks_per_cluster) {
+		/* The per-AG inum of this inode cluster. */
+		agino = XFS_OFFBNO_TO_AGINO(mp, agbno, 0);
+
+		/* The per-AG inum of the inobt record. */
+		startino = rmino +
+				rounddown(agino - rmino, XFS_INODES_PER_CHUNK);
+		cdist = agino - startino;
+
+		/* Every inode in this holemask slot is filled. */
+		fillmask = xfs_inobt_maskn(
+				cdist / XFS_INODES_PER_HOLEMASK_BIT,
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
+		usedmask = 0;
+		usedcount = 0;
+		/* Which inodes within this cluster are free? */
+		for (clusterino = 0; clusterino < nr_inodes; clusterino++) {
+			fsino = XFS_AGINO_TO_INO(mp, cur->bc_private.a.agno,
+					agino + clusterino);
+			error = xfs_repair_ialloc_check_free(cur, bp, fsino,
+					clusterino, &inuse);
+			if (error) {
+				xfs_trans_brelse(cur->bc_tp, bp);
+				return error;
+			}
+			if (inuse) {
+				usedcount++;
+				usedmask |= XFS_INOBT_MASK(cdist + clusterino);
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
+			if (rie->startino + XFS_INODES_PER_CHUNK > startino) {
+				rie->freemask &= ~usedmask;
+				rie->holemask &= ~fillmask;
+				rie->count += nr_inodes;
+				rie->usedcount += usedcount;
+				continue;
+			}
+		}
+
+		/* New inode chunk; add to the list. */
+		rie = kmem_alloc(sizeof(struct xfs_repair_ialloc_extent),
+				KM_MAYFAIL | KM_NOFS);
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
+int
+xfs_repair_iallocbt(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_repair_ialloc	ri;
+	struct xfs_owner_info		oinfo;
+	struct xfs_mount		*mp = sc->mp;
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
+	ri.sc = sc;
+
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
+	/* Invalidate all the inobt/finobt blocks in btlist. */
+	error = xfs_repair_invalidate_blocks(sc, &ri.btlist);
+	if (error)
+		goto out;
+
+	agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
+	/* Initialize new btree roots. */
+	error = xfs_repair_alloc_ag_block(sc, &oinfo, &inofsb,
+			XFS_AG_RESV_NONE);
+	if (error)
+		goto out;
+	error = xfs_repair_init_btblock(sc, inofsb, &bp, XFS_BTNUM_INO,
+			&xfs_inobt_buf_ops);
+	if (error)
+		goto out;
+	agi->agi_root = cpu_to_be32(XFS_FSB_TO_AGBNO(mp, inofsb));
+	agi->agi_level = cpu_to_be32(1);
+	logflags = XFS_AGI_ROOT | XFS_AGI_LEVEL;
+
+	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+		error = xfs_repair_alloc_ag_block(sc, &oinfo, &finofsb,
+				mp->m_inotbt_nores ? XFS_AG_RESV_NONE :
+						     XFS_AG_RESV_METADATA);
+		if (error)
+			goto out;
+		error = xfs_repair_init_btblock(sc, finofsb, &bp,
+				XFS_BTNUM_FINO, &xfs_inobt_buf_ops);
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
+		trace_xfs_repair_ialloc_insert(mp, sc->sa.agno, rie->startino,
+				rie->holemask, rie->count,
+				rie->count - rie->usedcount, rie->freemask);
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
+		pag = xfs_perag_get(mp, sc->sa.agno);
+		pag->pagi_init = 0;
+		xfs_perag_put(pag);
+
+		agi->agi_count = cpu_to_be32(count);
+		agi->agi_freecount = cpu_to_be32(count - usedcount);
+		xfs_ialloc_log_agi(sc->tp, sc->sa.agi_bp,
+				XFS_AGI_COUNT | XFS_AGI_FREECOUNT);
+		sc->reset_counters = true;
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
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 5756d27..b8d0f4d 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -75,5 +75,6 @@ int xfs_repair_agf(struct xfs_scrub_context *sc);
 int xfs_repair_agfl(struct xfs_scrub_context *sc);
 int xfs_repair_agi(struct xfs_scrub_context *sc);
 int xfs_repair_allocbt(struct xfs_scrub_context *sc);
+int xfs_repair_iallocbt(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_REPAIR_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index b15c320..7824913 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -246,10 +246,12 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 	{ /* inobt */
 		.setup	= xfs_scrub_setup_ag_iallocbt,
 		.scrub	= xfs_scrub_inobt,
+		.repair	= xfs_repair_iallocbt,
 	},
 	{ /* finobt */
 		.setup	= xfs_scrub_setup_ag_iallocbt,
 		.scrub	= xfs_scrub_finobt,
+		.repair	= xfs_repair_iallocbt,
 		.has	= xfs_sb_version_hasfinobt,
 	},
 	{ /* rmapbt */

