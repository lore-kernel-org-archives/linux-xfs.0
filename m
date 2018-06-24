Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58450 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752239AbeFXTYQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Jun 2018 15:24:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5OJOGAM077374
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:16 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2jt8a7gerf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:16 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5OJOFGm020003
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:15 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5OJOFCx013122
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:15 GMT
Subject: [PATCH 07/21] xfs: repair inode btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 24 Jun 2018 12:24:13 -0700
Message-ID: <152986825387.3155.16901181422449777127.stgit@magnolia>
In-Reply-To: <152986820984.3155.16417868536016544528.stgit@magnolia>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
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
 fs/xfs/Makefile              |    1 
 fs/xfs/scrub/ialloc_repair.c |  585 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h        |    2 
 fs/xfs/scrub/scrub.c         |    4 
 4 files changed, 590 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/ialloc_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 841e0824eeb6..837fd4a95f6f 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -165,6 +165,7 @@ ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
 				   alloc_repair.o \
+				   ialloc_repair.o \
 				   repair.o \
 				   )
 endif
diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
new file mode 100644
index 000000000000..29c736466bba
--- /dev/null
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -0,0 +1,585 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_alloc.h"
+#include "xfs_ialloc.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_icache.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_log.h"
+#include "xfs_trans_priv.h"
+#include "xfs_error.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+
+/*
+ * Inode Btree Repair
+ * ==================
+ *
+ * Iterate the reverse mapping records looking for OWN_INODES and OWN_INOBT
+ * records.  The OWN_INOBT records are the old inode btree blocks and will be
+ * cleared out after we've rebuilt the tree.  Each possible inode chunk within
+ * an OWN_INODES record will be read in and the freemask calculated from the
+ * i_mode data in the inode chunk.  For sparse inodes the holemask will be
+ * calculated by creating the properly aligned inobt record and punching out
+ * any chunk that's missing.  Inode allocations and frees grab the AGI first,
+ * so repair protects itself from concurrent access by locking the AGI.
+ *
+ * Once we've reconstructed all the inode records, we can create new inode
+ * btree roots and reload the btrees.  We rebuild both inode trees at the same
+ * time because they have the same rmap owner and it would be more complex to
+ * figure out if the other tree isn't in need of a rebuild and which OWN_INOBT
+ * blocks it owns.  We have all the data we need to build both, so dump
+ * everything and start over.
+ */
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
+	struct list_head		*extlist;
+	struct xfs_repair_extent_list	*btlist;
+	struct xfs_scrub_context	*sc;
+	uint64_t			nr_records;
+};
+
+/*
+ * Is this inode in use?  If the inode is in memory we can tell from i_mode,
+ * otherwise we have to check di_mode in the on-disk buffer.  We only care
+ * that the high (i.e. non-permission) bits of _mode are zero.  This should be
+ * safe because repair keeps all AG headers locked until the end, and process
+ * trying to perform an inode allocation/free must lock the AGI.
+ */
+STATIC int
+xfs_repair_ialloc_check_free(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*bp,
+	xfs_ino_t			fsino,
+	xfs_agino_t			bpino,
+	bool				*inuse)
+{
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_dinode		*dip;
+	int				error;
+
+	/* Will the in-core inode tell us if it's in use? */
+	error = xfs_icache_inode_is_allocated(mp, sc->tp, fsino, inuse);
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
+/*
+ * For each cluster in this blob of inode, we must calculate the
+ * properly aligned startino of that cluster, then iterate each
+ * cluster to fill in used and filled masks appropriately.  We
+ * then use the (startino, used, filled) information to construct
+ * the appropriate inode records.
+ */
+STATIC int
+xfs_repair_ialloc_process_cluster(
+	struct xfs_repair_ialloc	*ri,
+	xfs_agblock_t			agbno,
+	int				blks_per_cluster,
+	xfs_agino_t			rec_agino)
+{
+	struct xfs_imap			imap;
+	struct xfs_repair_ialloc_extent	*rie;
+	struct xfs_dinode		*dip;
+	struct xfs_buf			*bp;
+	struct xfs_scrub_context	*sc = ri->sc;
+	struct xfs_mount		*mp = sc->mp;
+	xfs_ino_t			fsino;
+	xfs_inofree_t			usedmask;
+	xfs_agino_t			nr_inodes;
+	xfs_agino_t			startino;
+	xfs_agino_t			clusterino;
+	xfs_agino_t			clusteroff;
+	xfs_agino_t			agino;
+	uint16_t			fillmask;
+	bool				inuse;
+	int				usedcount;
+	int				error;
+
+	/* The per-AG inum of this inode cluster. */
+	agino = XFS_OFFBNO_TO_AGINO(mp, agbno, 0);
+
+	/* The per-AG inum of the inobt record. */
+	startino = rec_agino + rounddown(agino - rec_agino,
+			XFS_INODES_PER_CHUNK);
+
+	/* The per-AG inum of the cluster within the inobt record. */
+	clusteroff = agino - startino;
+
+	/* Every inode in this holemask slot is filled. */
+	nr_inodes = XFS_OFFBNO_TO_AGINO(mp, blks_per_cluster, 0);
+	fillmask = xfs_inobt_maskn(clusteroff / XFS_INODES_PER_HOLEMASK_BIT,
+			nr_inodes / XFS_INODES_PER_HOLEMASK_BIT);
+
+	/* Grab the inode cluster buffer. */
+	imap.im_blkno = XFS_AGB_TO_DADDR(mp, sc->sa.agno, agbno);
+	imap.im_len = XFS_FSB_TO_BB(mp, blks_per_cluster);
+	imap.im_boffset = 0;
+
+	error = xfs_imap_to_bp(mp, sc->tp, &imap, &dip, &bp, 0,
+			XFS_IGET_UNTRUSTED);
+	if (error)
+		return error;
+
+	usedmask = 0;
+	usedcount = 0;
+	/* Which inodes within this cluster are free? */
+	for (clusterino = 0; clusterino < nr_inodes; clusterino++) {
+		fsino = XFS_AGINO_TO_INO(mp, sc->sa.agno, agino + clusterino);
+		error = xfs_repair_ialloc_check_free(sc, bp, fsino,
+				clusterino, &inuse);
+		if (error) {
+			xfs_trans_brelse(sc->tp, bp);
+			return error;
+		}
+		if (inuse) {
+			usedcount++;
+			usedmask |= XFS_INOBT_MASK(clusteroff + clusterino);
+		}
+	}
+	xfs_trans_brelse(sc->tp, bp);
+
+	/*
+	 * If the last item in the list is our chunk record,
+	 * update that.
+	 */
+	if (!list_empty(ri->extlist)) {
+		rie = list_last_entry(ri->extlist,
+				struct xfs_repair_ialloc_extent, list);
+		if (rie->startino + XFS_INODES_PER_CHUNK > startino) {
+			rie->freemask &= ~usedmask;
+			rie->holemask &= ~fillmask;
+			rie->count += nr_inodes;
+			rie->usedcount += usedcount;
+			return 0;
+		}
+	}
+
+	/* New inode chunk; add to the list. */
+	rie = kmem_alloc(sizeof(struct xfs_repair_ialloc_extent), KM_MAYFAIL);
+	if (!rie)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&rie->list);
+	rie->startino = startino;
+	rie->freemask = XFS_INOBT_ALL_FREE & ~usedmask;
+	rie->holemask = XFS_INOBT_ALL_FREE & ~fillmask;
+	rie->count = nr_inodes;
+	rie->usedcount = usedcount;
+	list_add_tail(&rie->list, ri->extlist);
+	ri->nr_records++;
+
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
+	struct xfs_repair_ialloc	*ri = priv;
+	struct xfs_mount		*mp = cur->bc_mp;
+	xfs_fsblock_t			fsbno;
+	xfs_agblock_t			agbno = rec->rm_startblock;
+	xfs_agino_t			inoalign;
+	xfs_agino_t			agino;
+	xfs_agino_t			rec_agino;
+	int				blks_per_cluster;
+	int				error = 0;
+
+	if (xfs_scrub_should_terminate(ri->sc, &error))
+		return error;
+
+	/* Fragment of the old btrees; dispose of them later. */
+	if (rec->rm_owner == XFS_RMAP_OWN_INOBT) {
+		fsbno = XFS_AGB_TO_FSB(mp, ri->sc->sa.agno, agbno);
+		return xfs_repair_collect_btree_extent(ri->sc, ri->btlist,
+				fsbno, rec->rm_blockcount);
+	}
+
+	/* Skip extents which are not owned by this inode and fork. */
+	if (rec->rm_owner != XFS_RMAP_OWN_INODES)
+		return 0;
+
+	blks_per_cluster = xfs_icluster_size_fsb(mp);
+
+	if (agbno % blks_per_cluster != 0)
+		return -EFSCORRUPTED;
+
+	trace_xfs_repair_ialloc_extent_fn(mp, ri->sc->sa.agno,
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
+	agino = XFS_OFFBNO_TO_AGINO(mp, agbno, 0);
+	rec_agino = XFS_OFFBNO_TO_AGINO(mp, rounddown(agbno, inoalign), 0);
+	if (!xfs_sb_version_hassparseinodes(&mp->m_sb) && agino != rec_agino)
+		return -EFSCORRUPTED;
+
+	/* Set up the free/hole masks for each cluster in this inode chunk. */
+	for (;
+	     agbno < rec->rm_startblock + rec->rm_blockcount;
+	     agbno += blks_per_cluster) {
+		error = xfs_repair_ialloc_process_cluster(ri, agbno,
+				blks_per_cluster, rec_agino);
+		if (error)
+			return error;
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
+/* Insert an inode chunk record into a given btree. */
+static int
+xfs_repair_iallocbt_insert_btrec(
+	struct xfs_btree_cur		*cur,
+	struct xfs_repair_ialloc_extent	*rie)
+{
+	int				stat;
+	int				error;
+
+	error = xfs_inobt_lookup(cur, rie->startino, XFS_LOOKUP_EQ, &stat);
+	if (error)
+		return error;
+	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, stat == 0);
+	error = xfs_inobt_insert_rec(cur, rie->holemask, rie->count,
+			rie->count - rie->usedcount, rie->freemask, &stat);
+	if (error)
+		return error;
+	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, stat == 1);
+	return error;
+}
+
+/* Insert an inode chunk record into both inode btrees. */
+static int
+xfs_repair_iallocbt_insert_rec(
+	struct xfs_scrub_context	*sc,
+	struct xfs_repair_ialloc_extent	*rie)
+{
+	struct xfs_btree_cur		*cur;
+	int				error;
+
+	trace_xfs_repair_ialloc_insert(sc->mp, sc->sa.agno, rie->startino,
+			rie->holemask, rie->count, rie->count - rie->usedcount,
+			rie->freemask);
+
+	/* Insert into the inobt. */
+	cur = xfs_inobt_init_cursor(sc->mp, sc->tp, sc->sa.agi_bp, sc->sa.agno,
+			XFS_BTNUM_INO);
+	error = xfs_repair_iallocbt_insert_btrec(cur, rie);
+	if (error)
+		goto out_cur;
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+
+	/* Insert into the finobt if chunk has free inodes. */
+	if (xfs_sb_version_hasfinobt(&sc->mp->m_sb) &&
+	    rie->count != rie->usedcount) {
+		cur = xfs_inobt_init_cursor(sc->mp, sc->tp, sc->sa.agi_bp,
+				sc->sa.agno, XFS_BTNUM_FINO);
+		error = xfs_repair_iallocbt_insert_btrec(cur, rie);
+		if (error)
+			goto out_cur;
+		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	}
+
+	return xfs_repair_roll_ag_trans(sc);
+out_cur:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	return error;
+}
+
+/* Free every record in the inode list. */
+STATIC void
+xfs_repair_iallocbt_cancel_inorecs(
+	struct list_head		*reclist)
+{
+	struct xfs_repair_ialloc_extent	*rie;
+	struct xfs_repair_ialloc_extent	*n;
+
+	list_for_each_entry_safe(rie, n, reclist, list) {
+		list_del(&rie->list);
+		kmem_free(rie);
+	}
+}
+
+/*
+ * Iterate all reverse mappings to find the inodes (OWN_INODES) and the inode
+ * btrees (OWN_INOBT).  Figure out if we have enough free space to reconstruct
+ * the inode btrees.  The caller must clean up the lists if anything goes
+ * wrong.
+ */
+STATIC int
+xfs_repair_iallocbt_find_inodes(
+	struct xfs_scrub_context	*sc,
+	struct list_head		*inode_records,
+	struct xfs_repair_extent_list	*old_iallocbt_blocks)
+{
+	struct xfs_repair_ialloc	ri;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_btree_cur		*cur;
+	xfs_agblock_t			nr_blocks;
+	int				error;
+
+	/* Collect all reverse mappings for inode blocks. */
+	ri.extlist = inode_records;
+	ri.btlist = old_iallocbt_blocks;
+	ri.nr_records = 0;
+	ri.sc = sc;
+
+	cur = xfs_rmapbt_init_cursor(mp, sc->tp, sc->sa.agf_bp, sc->sa.agno);
+	error = xfs_rmap_query_all(cur, xfs_repair_ialloc_extent_fn, &ri);
+	if (error)
+		goto err;
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+
+	/* Do we actually have enough space to do this? */
+	nr_blocks = xfs_iallocbt_calc_size(mp, ri.nr_records);
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		nr_blocks *= 2;
+	if (!xfs_repair_ag_has_space(sc->sa.pag, nr_blocks, XFS_AG_RESV_NONE))
+		return -ENOSPC;
+
+	return 0;
+
+err:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	return error;
+}
+
+/* Update the AGI counters. */
+STATIC int
+xfs_repair_iallocbt_reset_counters(
+	struct xfs_scrub_context	*sc,
+	struct list_head		*inode_records,
+	int				*log_flags)
+{
+	struct xfs_agi			*agi;
+	struct xfs_repair_ialloc_extent	*rie;
+	unsigned int			count = 0;
+	unsigned int			usedcount = 0;
+	unsigned int			freecount;
+
+	/* Figure out the new counters. */
+	list_for_each_entry(rie, inode_records, list) {
+		count += rie->count;
+		usedcount += rie->usedcount;
+	}
+
+	agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
+	freecount = count - usedcount;
+
+	/* XXX: trigger inode count recalculation */
+
+	/* Reset the per-AG info, both incore and ondisk. */
+	sc->sa.pag->pagi_count = count;
+	sc->sa.pag->pagi_freecount = freecount;
+	agi->agi_count = cpu_to_be32(count);
+	agi->agi_freecount = cpu_to_be32(freecount);
+	*log_flags |= XFS_AGI_COUNT | XFS_AGI_FREECOUNT;
+
+	return 0;
+}
+
+/* Initialize new inobt/finobt roots and implant them into the AGI. */
+STATIC int
+xfs_repair_iallocbt_reset_btrees(
+	struct xfs_scrub_context	*sc,
+	struct xfs_owner_info		*oinfo,
+	int				*log_flags)
+{
+	struct xfs_agi			*agi;
+	struct xfs_buf			*bp;
+	struct xfs_mount		*mp = sc->mp;
+	xfs_fsblock_t			inofsb;
+	xfs_fsblock_t			finofsb;
+	enum xfs_ag_resv_type		resv;
+	int				error;
+
+	agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
+
+	/* Initialize new inobt root. */
+	resv = XFS_AG_RESV_NONE;
+	error = xfs_repair_alloc_ag_block(sc, oinfo, &inofsb, resv);
+	if (error)
+		return error;
+	error = xfs_repair_init_btblock(sc, inofsb, &bp, XFS_BTNUM_INO,
+			&xfs_inobt_buf_ops);
+	if (error)
+		return error;
+	agi->agi_root = cpu_to_be32(XFS_FSB_TO_AGBNO(mp, inofsb));
+	agi->agi_level = cpu_to_be32(1);
+	*log_flags |= XFS_AGI_ROOT | XFS_AGI_LEVEL;
+
+	/* Initialize new finobt root. */
+	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
+		return 0;
+
+	resv = mp->m_inotbt_nores ? XFS_AG_RESV_NONE : XFS_AG_RESV_METADATA;
+	error = xfs_repair_alloc_ag_block(sc, oinfo, &finofsb, resv);
+	if (error)
+		return error;
+	error = xfs_repair_init_btblock(sc, finofsb, &bp, XFS_BTNUM_FINO,
+			&xfs_inobt_buf_ops);
+	if (error)
+		return error;
+	agi->agi_free_root = cpu_to_be32(XFS_FSB_TO_AGBNO(mp, finofsb));
+	agi->agi_free_level = cpu_to_be32(1);
+	*log_flags |= XFS_AGI_FREE_ROOT | XFS_AGI_FREE_LEVEL;
+
+	return 0;
+}
+
+/* Build new inode btrees and dispose of the old one. */
+STATIC int
+xfs_repair_iallocbt_rebuild_trees(
+	struct xfs_scrub_context	*sc,
+	struct list_head		*inode_records,
+	struct xfs_owner_info		*oinfo,
+	struct xfs_repair_extent_list	*old_iallocbt_blocks)
+{
+	struct xfs_repair_ialloc_extent	*rie;
+	struct xfs_repair_ialloc_extent	*n;
+	int				error;
+
+	/* Add all records. */
+	list_sort(NULL, inode_records, xfs_repair_ialloc_extent_cmp);
+	list_for_each_entry_safe(rie, n, inode_records, list) {
+		error = xfs_repair_iallocbt_insert_rec(sc, rie);
+		if (error)
+			return error;
+
+		list_del(&rie->list);
+		kmem_free(rie);
+	}
+
+	/* Free the old inode btree blocks if they're not in use. */
+	return xfs_repair_reap_btree_extents(sc, old_iallocbt_blocks, oinfo,
+			XFS_AG_RESV_NONE);
+}
+
+/* Repair both inode btrees. */
+int
+xfs_repair_iallocbt(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_owner_info		oinfo;
+	struct list_head		inode_records;
+	struct xfs_repair_extent_list	old_iallocbt_blocks;
+	struct xfs_mount		*mp = sc->mp;
+	int				log_flags = 0;
+	int				error = 0;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	xfs_scrub_perag_get(sc->mp, &sc->sa);
+
+	/* Collect the free space data and find the old btree blocks. */
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
+	INIT_LIST_HEAD(&inode_records);
+	xfs_repair_init_extent_list(&old_iallocbt_blocks);
+	error = xfs_repair_iallocbt_find_inodes(sc, &inode_records,
+			&old_iallocbt_blocks);
+	if (error)
+		goto out;
+
+	/*
+	 * Blow out the old inode btrees.  This is the point at which
+	 * we are no longer able to bail out gracefully.
+	 */
+	error = xfs_repair_iallocbt_reset_counters(sc, &inode_records,
+			&log_flags);
+	if (error)
+		goto out;
+	error = xfs_repair_iallocbt_reset_btrees(sc, &oinfo, &log_flags);
+	if (error)
+		goto out;
+	xfs_ialloc_log_agi(sc->tp, sc->sa.agi_bp, log_flags);
+
+	/* Invalidate all the inobt/finobt blocks in btlist. */
+	error = xfs_repair_invalidate_blocks(sc, &old_iallocbt_blocks);
+	if (error)
+		goto out;
+	error = xfs_repair_roll_ag_trans(sc);
+	if (error)
+		goto out;
+
+	/* Now rebuild the inode information. */
+	error = xfs_repair_iallocbt_rebuild_trees(sc, &inode_records, &oinfo,
+			&old_iallocbt_blocks);
+out:
+	xfs_repair_cancel_btree_extents(sc, &old_iallocbt_blocks);
+	xfs_repair_iallocbt_cancel_inorecs(&inode_records);
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index e5f67fc68e9a..dcfa5eb18940 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -104,6 +104,7 @@ int xfs_repair_agf(struct xfs_scrub_context *sc);
 int xfs_repair_agfl(struct xfs_scrub_context *sc);
 int xfs_repair_agi(struct xfs_scrub_context *sc);
 int xfs_repair_allocbt(struct xfs_scrub_context *sc);
+int xfs_repair_iallocbt(struct xfs_scrub_context *sc);
 
 #else
 
@@ -131,6 +132,7 @@ xfs_repair_calc_ag_resblks(
 #define xfs_repair_agfl			xfs_repair_notsupported
 #define xfs_repair_agi			xfs_repair_notsupported
 #define xfs_repair_allocbt		xfs_repair_notsupported
+#define xfs_repair_iallocbt		xfs_repair_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 7a55b20b7e4e..fec0e130f19e 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -238,14 +238,14 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.type	= ST_PERAG,
 		.setup	= xfs_scrub_setup_ag_iallocbt,
 		.scrub	= xfs_scrub_inobt,
-		.repair	= xfs_repair_notsupported,
+		.repair	= xfs_repair_iallocbt,
 	},
 	[XFS_SCRUB_TYPE_FINOBT] = {	/* finobt */
 		.type	= ST_PERAG,
 		.setup	= xfs_scrub_setup_ag_iallocbt,
 		.scrub	= xfs_scrub_finobt,
 		.has	= xfs_sb_version_hasfinobt,
-		.repair	= xfs_repair_notsupported,
+		.repair	= xfs_repair_iallocbt,
 	},
 	[XFS_SCRUB_TYPE_RMAPBT] = {	/* rmapbt */
 		.type	= ST_PERAG,

