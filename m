Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37952 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfAACKf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:10:35 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0128ua7015780
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:10:31 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2pp0btp729-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:10:31 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012APaW019084
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:10:25 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012APnw022406
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:10:25 GMT
Subject: [PATCH 04/17] xfs: repair inode btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:10:23 -0800
Message-ID: <154630862383.15625.13320810679321795750.stgit@magnolia>
In-Reply-To: <154630859850.15625.17640302184521917854.stgit@magnolia>
References: <154630859850.15625.17640302184521917854.stgit@magnolia>
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
 fs/xfs/scrub/common.c        |    2 
 fs/xfs/scrub/ialloc_repair.c |  709 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.c        |   20 +
 fs/xfs/scrub/repair.h        |   11 +
 fs/xfs/scrub/scrub.c         |    4 
 fs/xfs/scrub/scrub.h         |    1 
 fs/xfs/scrub/trace.h         |    4 
 8 files changed, 748 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/scrub/ialloc_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index a7f87c684b7d..ff11d48e8089 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -168,6 +168,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   alloc_repair.o \
 				   array.o \
 				   bitmap.o \
+				   ialloc_repair.o \
 				   repair.o \
 				   )
 endif
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 108c2b08c269..76629c874e07 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -516,6 +516,8 @@ xchk_ag_free(
 	struct xchk_ag		*sa)
 {
 	xchk_ag_btcur_free(sa);
+	if (sa->pag != NULL && sc->reset_perag_resv)
+		xrep_reset_perag_resv(sc);
 	if (sa->agfl_bp) {
 		xfs_trans_brelse(sc->tp, sa->agfl_bp);
 		sa->agfl_bp = NULL;
diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
new file mode 100644
index 000000000000..3bb7ffbcc8b3
--- /dev/null
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -0,0 +1,709 @@
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
+#include "scrub/bitmap.h"
+#include "scrub/array.h"
+
+/*
+ * Inode Btree Repair
+ * ==================
+ *
+ * A quick refresher of inode btrees on a v5 filesystem:
+ *
+ * - Inode records are read into memory in units of 'inode clusters'.  However
+ *   many inodes fit in a cluster buffer is the smallest number of inodes that
+ *   can be allocated or freed.  Clusters are never smaller than one fs block
+ *   though they can span multiple blocks.  The size (in fs blocks) is
+ *   computed with xfs_icluster_size_fsb().  The fs block alignment of a
+ *   cluster is computed with xfs_ialloc_cluster_alignment().
+ *
+ * - Each inode btree record can describe a single 'inode chunk'.  The chunk
+ *   size is defined to be 64 inodes.  If sparse inodes are enabled, every
+ *   inobt record must be aligned to the chunk size; if not, every record must
+ *   be aligned to the start of a cluster.  It is possible to construct an XFS
+ *   geometry where one inobt record maps to multiple inode clusters; it is
+ *   also possible to construct a geometry where multiple inobt records map to
+ *   different parts of one inode cluster.
+ *
+ * - If sparse inodes are not enabled, the smallest unit of allocation for
+ *   inode records is enough to contain one inode chunk's worth of inodes.
+ *
+ * - If sparse inodes are enabled, the holemask field will be active.  Each
+ *   bit of the holemask represents 4 potential inodes; if set, the
+ *   corresponding space does *not* contain inodes and must be left alone.
+ *   Clusters cannot be smaller than 4 inodes.  The smallest unit of allocation
+ *   of inode records is one inode cluster.
+ *
+ * So what's the rebuild algorithm?
+ *
+ * Iterate the reverse mapping records looking for OWN_INODES and OWN_INOBT
+ * records.  The OWN_INOBT records are the old inode btree blocks and will be
+ * cleared out after we've rebuilt the tree.  Each possible inode cluster
+ * within an OWN_INODES record will be read in; for each possible inobt record
+ * associated with that cluster, compute the freemask calculated from the
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
+ *
+ * We use the prefix 'xrep_ibt' because we rebuild both inode btrees at once.
+ */
+
+struct xrep_ibt {
+	/* Record under construction. */
+	struct xfs_inobt_rec_incore	rie;
+
+	/* Reconstructed inode records. */
+	struct xfbma		*inode_records;
+
+	/* Old inode btree blocks we found in the rmap. */
+	struct xfs_bitmap	*btlist;
+
+	struct xfs_scrub	*sc;
+
+	/* Number of inodes assigned disk space. */
+	unsigned int		icount;
+
+	/* Number of inodes in use. */
+	unsigned int		iused;
+};
+
+/*
+ * Is this inode in use?  If the inode is in memory we can tell from i_mode,
+ * otherwise we have to check di_mode in the on-disk buffer.  We only care
+ * that the high (i.e. non-permission) bits of _mode are zero.  This should be
+ * safe because repair keeps all AG headers locked until the end, and process
+ * trying to perform an inode allocation/free must lock the AGI.
+ *
+ * @cluster_ag_base is the inode offset of the cluster within the AG.
+ * @cluster_bp is the cluster buffer.
+ * @cluster_index is the inode offset within the inode cluster.
+ */
+STATIC int
+xrep_ibt_check_ifree(
+	struct xrep_ibt		*ri,
+	xfs_agino_t		cluster_ag_base,
+	struct xfs_buf		*cluster_bp,
+	unsigned int		cluster_index,
+	bool			*inuse)
+{
+	struct xfs_scrub	*sc = ri->sc;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_dinode	*dip;
+	xfs_ino_t		fsino;
+	xfs_agnumber_t		agno = ri->sc->sa.agno;
+	unsigned int		cluster_buf_base;
+	unsigned int		offset;
+	int			error;
+
+	fsino = XFS_AGINO_TO_INO(mp, agno, cluster_ag_base + cluster_index);
+
+	/* Inode uncached or half assembled, read disk buffer */
+	cluster_buf_base = XFS_INO_TO_OFFSET(mp, cluster_ag_base);
+	offset = (cluster_buf_base + cluster_index) * mp->m_sb.sb_inodesize;
+	if (offset >= BBTOB(cluster_bp->b_length))
+		return -EFSCORRUPTED;
+	dip = xfs_buf_offset(cluster_bp, offset);
+	if (be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC)
+		return -EFSCORRUPTED;
+
+	if (dip->di_version >= 3 && be64_to_cpu(dip->di_ino) != fsino)
+		return -EFSCORRUPTED;
+
+	/* Will the in-core inode tell us if it's in use? */
+	error = xfs_icache_inode_is_allocated(mp, sc->tp, fsino, inuse);
+	if (!error)
+		return 0;
+
+	*inuse = dip->di_mode != 0;
+	return 0;
+}
+
+/*
+ * Given an extent of inodes and an inode cluster buffer, calculate the
+ * location of the corresponding inobt record (creating it if necessary),
+ * then update the parts of the holemask and freemask of that record that
+ * correspond to the inode extent we were given.
+ *
+ * @cluster_ir_startino is the AG inode number of an inobt record that we're
+ * proposing to create for this inode cluster.  If sparse inodes are enabled,
+ * we must round down to a chunk boundary to find the actual sparse record.
+ * @cluster_bp is the buffer of the inode cluster.
+ * @nr_inodes is the number of inodes to check from the cluster.
+ */
+STATIC int
+xrep_ibt_cluster_record(
+	struct xrep_ibt		*ri,
+	xfs_agino_t		cluster_ir_startino,
+	struct xfs_buf		*cluster_bp,
+	unsigned int		nr_inodes)
+{
+	struct xfs_scrub	*sc = ri->sc;
+	struct xfs_mount	*mp = sc->mp;
+	xfs_agino_t		ir_startino;
+	unsigned int		cluster_base;
+	unsigned int		cluster_index;
+	bool			inuse;
+	int			error = 0;
+
+	ir_startino = cluster_ir_startino;
+	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+		ir_startino = rounddown(ir_startino, XFS_INODES_PER_CHUNK);
+	cluster_base = cluster_ir_startino - ir_startino;
+
+	/*
+	 * If the accumulated inobt record doesn't map this cluster, add it to
+	 * the list and reset it.
+	 */
+	if (ri->rie.ir_startino != NULLAGINO &&
+	    ri->rie.ir_startino + XFS_INODES_PER_CHUNK <= ir_startino) {
+		error = xfbma_append(ri->inode_records, &ri->rie);
+		if (error)
+			return error;
+		ri->rie.ir_startino = NULLAGINO;
+	}
+
+	if (ri->rie.ir_startino == NULLAGINO) {
+		ri->rie.ir_startino = ir_startino;
+		ri->rie.ir_free = XFS_INOBT_ALL_FREE;
+		ri->rie.ir_holemask = 0xFFFF;
+		ri->rie.ir_count = 0;
+	}
+
+	/* Record the whole cluster. */
+	ri->icount += nr_inodes;
+	ri->rie.ir_count += nr_inodes;
+	ri->rie.ir_holemask &= ~xfs_inobt_maskn(
+				cluster_base / XFS_INODES_PER_HOLEMASK_BIT,
+				nr_inodes / XFS_INODES_PER_HOLEMASK_BIT);
+
+	/* Which inodes within this cluster are free? */
+	for (cluster_index = 0; cluster_index < nr_inodes; cluster_index++) {
+		error = xrep_ibt_check_ifree(ri, cluster_ir_startino,
+				cluster_bp, cluster_index, &inuse);
+		if (error)
+			return error;
+		if (!inuse)
+			continue;
+		ri->iused++;
+		ri->rie.ir_free &= ~XFS_INOBT_MASK(cluster_base +
+						   cluster_index);
+	}
+	return 0;
+}
+
+/*
+ * For each inode cluster covering the physical extent recorded by the rmapbt,
+ * we must calculate the properly aligned startino of that cluster, then
+ * iterate each cluster to fill in used and filled masks appropriately.  We
+ * then use the (startino, used, filled) information to construct the
+ * appropriate inode records.
+ */
+STATIC int
+xrep_ibt_process_cluster(
+	struct xrep_ibt		*ri,
+	xfs_agblock_t		cluster_bno)
+{
+	struct xfs_imap		imap;
+	struct xfs_dinode	*dip;
+	struct xfs_buf		*cluster_bp;
+	struct xfs_scrub	*sc = ri->sc;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_ino_geometry	*igeo = &mp->m_ino_geo;
+	xfs_agino_t		cluster_ag_base;
+	xfs_agino_t		irec_index;
+	unsigned int		nr_inodes;
+	int			error;
+
+	nr_inodes = min_t(unsigned int, igeo->ig_inodes_per_cluster,
+				XFS_INODES_PER_CHUNK);
+
+	/*
+	 * Grab the inode cluster buffer.  This is safe to do with a broken
+	 * inobt because imap_to_bp directly maps the buffer without touching
+	 * either inode btree.
+	 */
+	imap.im_blkno = XFS_AGB_TO_DADDR(mp, sc->sa.agno, cluster_bno);
+	imap.im_len = XFS_FSB_TO_BB(mp, igeo->ig_blocks_per_cluster);
+	imap.im_boffset = 0;
+	error = xfs_imap_to_bp(mp, sc->tp, &imap, &dip, &cluster_bp, 0, 0);
+	if (error)
+		return error;
+
+	/*
+	 * Record the contents of each possible inobt record mapping this
+	 * cluster.
+	 */
+	cluster_ag_base = XFS_AGB_TO_AGINO(mp, cluster_bno);
+	for (irec_index = 0;
+	     irec_index < igeo->ig_inodes_per_cluster;
+	     irec_index += XFS_INODES_PER_CHUNK) {
+		error = xrep_ibt_cluster_record(ri,
+				cluster_ag_base + irec_index, cluster_bp,
+				nr_inodes);
+		if (error)
+			break;
+
+	}
+
+	xfs_trans_brelse(sc->tp, cluster_bp);
+	return error;
+}
+
+/* Record extents that belong to inode btrees. */
+STATIC int
+xrep_ibt_walk_rmap(
+	struct xfs_btree_cur	*cur,
+	struct xfs_rmap_irec	*rec,
+	void			*priv)
+{
+	struct xrep_ibt		*ri = priv;
+	struct xfs_mount	*mp = cur->bc_mp;
+	struct xfs_ino_geometry	*igeo = &mp->m_ino_geo;
+	xfs_fsblock_t		fsbno;
+	xfs_agblock_t		agbno = rec->rm_startblock;
+	xfs_agblock_t		cluster_base;
+	int			error = 0;
+
+	if (xchk_should_terminate(ri->sc, &error))
+		return error;
+
+	/* Fragment of the old btrees; dispose of them later. */
+	if (rec->rm_owner == XFS_RMAP_OWN_INOBT) {
+		fsbno = XFS_AGB_TO_FSB(mp, ri->sc->sa.agno, agbno);
+		return xfs_bitmap_set(ri->btlist, fsbno, rec->rm_blockcount);
+	}
+
+	/* Skip extents which are not owned by this inode and fork. */
+	if (rec->rm_owner != XFS_RMAP_OWN_INODES)
+		return 0;
+
+	/* The entire record must align to the inode cluster size. */
+	if (agbno & (igeo->ig_blocks_per_cluster - 1) ||
+	    (agbno + rec->rm_blockcount) & (igeo->ig_blocks_per_cluster - 1))
+		return -EFSCORRUPTED;
+
+	/*
+	 * The entire record must also adhere to the inode cluster alignment
+	 * size if sparse inodes are not enabled.
+	 */
+	if (!xfs_sb_version_hassparseinodes(&mp->m_sb) &&
+	    (agbno & (igeo->ig_cluster_align - 1) ||
+	     (agbno + rec->rm_blockcount) & (igeo->ig_cluster_align - 1)))
+		return -ENAVAIL;
+
+	/*
+	 * On a sparse inode fs, this cluster could be part of a sparse chunk.
+	 * Sparse clusters must be aligned to sparse chunk alignment.
+	 */
+	if (xfs_sb_version_hassparseinodes(&mp->m_sb) &&
+	    (agbno & (mp->m_sb.sb_spino_align - 1) ||
+	     (agbno + rec->rm_blockcount) & (mp->m_sb.sb_spino_align - 1)))
+		return -EREMOTEIO;
+
+	trace_xrep_ibt_walk_rmap(mp, ri->sc->sa.agno, rec->rm_startblock,
+			rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
+			rec->rm_flags);
+
+	/*
+	 * Record the free/hole masks for each inode cluster that could be
+	 * mapped by this rmap record.
+	 */
+	for (cluster_base = 0;
+	     cluster_base < rec->rm_blockcount;
+	     cluster_base += igeo->ig_blocks_per_cluster) {
+		error = xrep_ibt_process_cluster(ri, agbno + cluster_base);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/* Insert an inode chunk record into a given btree. */
+static int
+xrep_ibt_insert_btrec(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_inobt_rec_incore	*rie,
+	unsigned int			freecount)
+{
+	int				stat;
+	int				error;
+
+	error = xfs_inobt_lookup(cur, rie->ir_startino, XFS_LOOKUP_EQ, &stat);
+	if (error)
+		return error;
+	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, stat == 0);
+	error = xfs_inobt_insert_rec(cur, rie->ir_holemask, rie->ir_count,
+			freecount, rie->ir_free, &stat);
+	if (error)
+		return error;
+	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, stat == 1);
+	return error;
+}
+
+/* Compare two ialloc extents. */
+static int
+xfs_inobt_rec_incore_cmp(
+	const void			*a,
+	const void			*b)
+{
+	const struct xfs_inobt_rec_incore	*ap = a;
+	const struct xfs_inobt_rec_incore	*bp = b;
+
+	if (ap->ir_startino > bp->ir_startino)
+		return 1;
+	else if (ap->ir_startino < bp->ir_startino)
+		return -1;
+	return 0;
+}
+
+/*
+ * Iterate all reverse mappings to find the inodes (OWN_INODES) and the inode
+ * btrees (OWN_INOBT).  Figure out if we have enough free space to reconstruct
+ * the inode btrees.  The caller must clean up the lists if anything goes
+ * wrong.
+ */
+STATIC int
+xrep_ibt_find_inodes(
+	struct xfs_scrub	*sc,
+	struct xfbma		*inode_records,
+	struct xfs_bitmap	*old_iallocbt_blocks,
+	unsigned int		*icount,
+	unsigned int		*iused)
+{
+	struct xrep_ibt		ri = {
+		.sc		= sc,
+		.inode_records	= inode_records,
+		.btlist		= old_iallocbt_blocks,
+		.rie		= { .ir_startino = NULLAGINO, },
+	};
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_btree_cur	*cur;
+	xfs_agblock_t		nr_blocks;
+	int			error;
+
+	/* Collect all reverse mappings for inode blocks. */
+	cur = xfs_rmapbt_init_cursor(mp, sc->tp, sc->sa.agf_bp, sc->sa.agno);
+	error = xfs_rmap_query_all(cur, xrep_ibt_walk_rmap, &ri);
+	if (error)
+		goto err;
+	xfs_btree_del_cursor(cur, error);
+
+	/* If we have a record ready to go, add it to the array. */
+	if (ri.rie.ir_startino != NULLAGINO) {
+		error = xfbma_append(inode_records, &ri.rie);
+		if (error)
+			return error;
+	}
+
+	/* Do we have enough space to rebuild all inode trees? */
+	nr_blocks = xfs_iallocbt_calc_size(mp, xfbma_length(inode_records));
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		nr_blocks *= 2;
+	if (!xrep_ag_has_space(sc->sa.pag, nr_blocks, XFS_AG_RESV_NONE))
+		return -ENOSPC;
+
+	*icount = ri.icount;
+	*iused = ri.iused;
+	return 0;
+
+err:
+	xfs_btree_del_cursor(cur, error);
+	return error;
+}
+
+/* Update the AGI counters. */
+STATIC int
+xrep_ibt_reset_counters(
+	struct xfs_scrub	*sc,
+	struct xfbma		*inode_records,
+	unsigned int		icount,
+	unsigned int		iused,
+	int			*log_flags)
+{
+	struct xfs_agi		*agi;
+	struct xfs_perag	*pag = sc->sa.pag;
+	unsigned int		freecount;
+
+	agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
+	freecount = icount - iused;
+
+	/* Trigger inode count recalculation */
+	xfs_force_summary_recalc(sc->mp);
+
+	/*
+	 * Reset the per-AG info, both incore and ondisk.  Mark the incore
+	 * state stale in case we fail out of here.
+	 */
+	ASSERT(pag->pagi_init);
+	pag->pagi_init = 0;
+	pag->pagi_count = icount;
+	pag->pagi_freecount = freecount;
+
+	agi->agi_count = cpu_to_be32(icount);
+	agi->agi_freecount = cpu_to_be32(freecount);
+	*log_flags |= XFS_AGI_COUNT | XFS_AGI_FREECOUNT;
+
+	return 0;
+}
+
+/* Initialize a new inode btree roots and implant it into the AGI. */
+STATIC int
+xrep_ibt_reset_btree(
+	struct xfs_scrub	*sc,
+	xfs_btnum_t		btnum,
+	enum xfs_ag_resv_type	resv,
+	int			*log_flags)
+{
+	struct xfs_agi		*agi;
+	struct xfs_buf		*bp;
+	struct xfs_mount	*mp = sc->mp;
+	xfs_fsblock_t		fsbno;
+	int			error;
+
+	agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
+
+	/* Initialize new btree root. */
+	error = xrep_alloc_ag_block(sc, &XFS_RMAP_OINFO_INOBT, &fsbno, resv);
+	if (error)
+		return error;
+	error = xrep_init_btblock(sc, fsbno, &bp, btnum, &xfs_inobt_buf_ops);
+	if (error)
+		return error;
+
+	switch (btnum) {
+	case XFS_BTNUM_INOi:
+		agi->agi_root = cpu_to_be32(XFS_FSB_TO_AGBNO(mp, fsbno));
+		agi->agi_level = cpu_to_be32(1);
+		*log_flags |= XFS_AGI_ROOT | XFS_AGI_LEVEL;
+		break;
+	case XFS_BTNUM_FINOi:
+		agi->agi_free_root = cpu_to_be32(XFS_FSB_TO_AGBNO(mp, fsbno));
+		agi->agi_free_level = cpu_to_be32(1);
+		*log_flags |= XFS_AGI_FREE_ROOT | XFS_AGI_FREE_LEVEL;
+		break;
+	default:
+		ASSERT(0);
+	}
+
+	return 0;
+}
+
+/* Initialize new inobt/finobt roots and implant them into the AGI. */
+STATIC int
+xrep_ibt_reset_btrees(
+	struct xfs_scrub	*sc,
+	int			*log_flags)
+{
+	enum xfs_ag_resv_type	resv;
+	int			error;
+
+	resv = XFS_AG_RESV_NONE;
+	error = xrep_ibt_reset_btree(sc, XFS_BTNUM_INO, XFS_AG_RESV_NONE,
+			log_flags);
+	if (error || !xfs_sb_version_hasfinobt(&sc->mp->m_sb))
+		return error;
+
+	/*
+	 * If we made a per-AG reservation for the finobt then we must account
+	 * the new block correctly.
+	 */
+	if (!sc->mp->m_inotbt_nores)
+		resv = XFS_AG_RESV_METADATA;
+	return xrep_ibt_reset_btree(sc, XFS_BTNUM_FINO, resv, log_flags);
+}
+
+/* Insert an inode chunk record into both inode btrees. */
+static int
+xrep_ibt_insert_rec(
+	const void			*item,
+	void				*priv)
+{
+	const struct xfs_inobt_rec_incore	*rie = item;
+	struct xfs_scrub		*sc = priv;
+	struct xfs_btree_cur		*cur;
+	unsigned int			freecount;
+	unsigned int			holes;
+	int				error;
+
+	holes = hweight16(rie->ir_holemask) * XFS_INODES_PER_HOLEMASK_BIT;
+	freecount = hweight64(rie->ir_free) - holes;
+	trace_xrep_ibt_insert(sc->mp, sc->sa.agno, rie->ir_startino,
+			rie->ir_holemask, rie->ir_count, freecount,
+			rie->ir_free);
+
+	/* Insert into the inobt. */
+	cur = xfs_inobt_init_cursor(sc->mp, sc->tp, sc->sa.agi_bp, sc->sa.agno,
+			XFS_BTNUM_INO);
+	error = xrep_ibt_insert_btrec(cur, rie, freecount);
+	if (error)
+		goto out_cur;
+	xfs_btree_del_cursor(cur, error);
+
+	/* Insert into the finobt if chunk has free inodes. */
+	if (xfs_sb_version_hasfinobt(&sc->mp->m_sb) && freecount != 0) {
+		cur = xfs_inobt_init_cursor(sc->mp, sc->tp, sc->sa.agi_bp,
+				sc->sa.agno, XFS_BTNUM_FINO);
+		error = xrep_ibt_insert_btrec(cur, rie, freecount);
+		if (error)
+			goto out_cur;
+		xfs_btree_del_cursor(cur, error);
+	}
+
+	return xrep_roll_ag_trans(sc);
+out_cur:
+	xfs_btree_del_cursor(cur, error);
+	return error;
+}
+
+/* Build new inode btrees and dispose of the old one. */
+STATIC int
+xrep_ibt_rebuild_trees(
+	struct xfs_scrub	*sc,
+	struct xfbma		*inode_records,
+	struct xfs_bitmap	*old_iallocbt_blocks)
+{
+	int			error;
+
+	/*
+	 * Sort the inode extents by startino to avoid btree splits when we
+	 * rebuild the inode btrees.
+	 */
+	error = xfbma_sort(inode_records, xfs_inobt_rec_incore_cmp);
+	if (error)
+		return error;
+
+	/* Free the old inode btree blocks if they're not in use. */
+	error = xrep_reap_extents(sc, old_iallocbt_blocks,
+			&XFS_RMAP_OINFO_INOBT, XFS_AG_RESV_NONE);
+	if (error)
+		return error;
+
+	/* Add all records. */
+	return xfbma_iter_del(inode_records, xrep_ibt_insert_rec, sc);
+}
+
+/*
+ * Make our new inode btree roots permanent so that we can start re-adding
+ * inode records back into the AG.
+ */
+STATIC int
+xrep_ibt_commit_new(
+	struct xfs_scrub	*sc,
+	struct xfs_bitmap	*old_iallocbt_blocks,
+	int			log_flags)
+{
+	int			error;
+
+	xfs_ialloc_log_agi(sc->tp, sc->sa.agi_bp, log_flags);
+
+	/* Invalidate all the inobt/finobt blocks in btlist. */
+	error = xrep_invalidate_blocks(sc, old_iallocbt_blocks);
+	if (error)
+		return error;
+	error = xrep_roll_ag_trans(sc);
+	if (error)
+		return error;
+
+	/*
+	 * Now that we've succeeded, mark the incore state valid again.  If the
+	 * finobt is enabled, make sure we reinitialize the per-AG reservations
+	 * when we're done.
+	 */
+	sc->sa.pag->pagi_init = 1;
+	if (xfs_sb_version_hasfinobt(&sc->mp->m_sb))
+		sc->reset_perag_resv = true;
+	return 0;
+}
+
+/* Repair both inode btrees. */
+int
+xrep_iallocbt(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_bitmap	old_iallocbt_blocks;
+	struct xfbma		*inode_records;
+	struct xfs_mount	*mp = sc->mp;
+	unsigned int		icount = 0;
+	unsigned int		iused = 0;
+	int			log_flags = 0;
+	int			error = 0;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	xchk_perag_get(sc->mp, &sc->sa);
+
+	/* Set up some storage */
+	inode_records = xfbma_init(sizeof(struct xfs_inobt_rec_incore));
+	if (IS_ERR(inode_records))
+		return PTR_ERR(inode_records);
+
+	/* Collect the inode data and find the old btree blocks. */
+	xfs_bitmap_init(&old_iallocbt_blocks);
+	error = xrep_ibt_find_inodes(sc, inode_records, &old_iallocbt_blocks,
+			&icount, &iused);
+	if (error)
+		goto out;
+
+	/*
+	 * Blow out the old inode btrees.  This is the point at which
+	 * we are no longer able to bail out gracefully.
+	 */
+	error = xrep_ibt_reset_counters(sc, inode_records, icount, iused,
+			&log_flags);
+	if (error)
+		goto out;
+	error = xrep_ibt_reset_btrees(sc, &log_flags);
+	if (error)
+		goto out;
+	error = xrep_ibt_commit_new(sc, &old_iallocbt_blocks, log_flags);
+	if (error)
+		goto out;
+
+	/* Now rebuild the inode information. */
+	error = xrep_ibt_rebuild_trees(sc, inode_records, &old_iallocbt_blocks);
+out:
+	xfbma_destroy(inode_records);
+	xfs_bitmap_destroy(&old_iallocbt_blocks);
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 1c8eecfe52b8..77b337fd9ba9 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -964,3 +964,23 @@ xrep_ino_dqattach(
 
 	return error;
 }
+
+/*
+ * Reinitialize the per-AG block reservation for the AG we just fixed.
+ */
+int
+xrep_reset_perag_resv(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	ASSERT(sc->ops->type == ST_PERAG);
+	ASSERT(sc->tp);
+
+	error = xfs_ag_resv_free(sc->sa.pag);
+	if (error)
+		goto out;
+	error = xfs_ag_resv_init(sc->sa.pag, sc->tp);
+out:
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index a69902bee460..8ba72b381bc2 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -54,6 +54,7 @@ int xrep_find_ag_btree_roots(struct xfs_scrub *sc, struct xfs_buf *agf_bp,
 		struct xrep_find_ag_btree *btree_info, struct xfs_buf *agfl_bp);
 void xrep_force_quotacheck(struct xfs_scrub *sc, uint dqtype);
 int xrep_ino_dqattach(struct xfs_scrub *sc);
+int xrep_reset_perag_resv(struct xfs_scrub *sc);
 
 /* Metadata repairers */
 
@@ -63,6 +64,7 @@ int xrep_agf(struct xfs_scrub *sc);
 int xrep_agfl(struct xfs_scrub *sc);
 int xrep_agi(struct xfs_scrub *sc);
 int xrep_allocbt(struct xfs_scrub *sc);
+int xrep_iallocbt(struct xfs_scrub *sc);
 
 #else
 
@@ -84,12 +86,21 @@ xrep_calc_ag_resblks(
 	return 0;
 }
 
+static inline int
+xrep_reset_perag_resv(
+	struct xfs_scrub	*sc)
+{
+	ASSERT(0);
+	return -EOPNOTSUPP;
+}
+
 #define xrep_probe			xrep_notsupported
 #define xrep_superblock			xrep_notsupported
 #define xrep_agf			xrep_notsupported
 #define xrep_agfl			xrep_notsupported
 #define xrep_agi			xrep_notsupported
 #define xrep_allocbt			xrep_notsupported
+#define xrep_iallocbt			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 73135c05457b..22ad456f5c51 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -244,14 +244,14 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_iallocbt,
 		.scrub	= xchk_inobt,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_iallocbt,
 	},
 	[XFS_SCRUB_TYPE_FINOBT] = {	/* finobt */
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_iallocbt,
 		.scrub	= xchk_finobt,
 		.has	= xfs_sb_version_hasfinobt,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_iallocbt,
 	},
 	[XFS_SCRUB_TYPE_RMAPBT] = {	/* rmapbt */
 		.type	= ST_PERAG,
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 22f754fba8e5..81333809c198 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -64,6 +64,7 @@ struct xfs_scrub {
 	uint				ilock_flags;
 	bool				try_harder;
 	bool				has_quotaofflock;
+	bool				reset_perag_resv;
 
 	/* State tracking for single-AG operations. */
 	struct xchk_ag			sa;
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 0d8a9261cfff..a847f9be0c1c 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -662,7 +662,7 @@ DEFINE_EVENT(xrep_rmap_class, name, \
 		 uint64_t owner, uint64_t offset, unsigned int flags), \
 	TP_ARGS(mp, agno, agbno, len, owner, offset, flags))
 DEFINE_REPAIR_RMAP_EVENT(xrep_abt_walk_rmap);
-DEFINE_REPAIR_RMAP_EVENT(xrep_ialloc_extent_fn);
+DEFINE_REPAIR_RMAP_EVENT(xrep_ibt_walk_rmap);
 DEFINE_REPAIR_RMAP_EVENT(xrep_rmap_extent_fn);
 DEFINE_REPAIR_RMAP_EVENT(xrep_bmap_extent_fn);
 
@@ -810,7 +810,7 @@ TRACE_EVENT(xrep_reset_counters,
 		  MAJOR(__entry->dev), MINOR(__entry->dev))
 )
 
-TRACE_EVENT(xrep_ialloc_insert,
+TRACE_EVENT(xrep_ibt_insert,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
 		 xfs_agino_t startino, uint16_t holemask, uint8_t count,
 		 uint8_t freecount, uint64_t freemask),
