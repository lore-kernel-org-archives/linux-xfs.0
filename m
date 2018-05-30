Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56690 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753442AbeE3TbH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 15:31:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4UJPV6T011425
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 19:31:07 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2j9ev8425t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 19:31:07 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w4UJV6P9014684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 19:31:06 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w4UJV6cj018254
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 19:31:06 GMT
Subject: [PATCH 04/14] xfs: repair inode btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 30 May 2018 12:31:04 -0700
Message-ID: <152770866495.11611.1193477717645761767.stgit@magnolia>
In-Reply-To: <152770863951.11611.5866814627357136911.stgit@magnolia>
References: <152770863951.11611.5866814627357136911.stgit@magnolia>
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
 fs/xfs/scrub/ialloc_repair.c |  479 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h        |    2 
 fs/xfs/scrub/scrub.c         |    4 
 4 files changed, 484 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/ialloc_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index abe035ad0aa4..7c442f83b179 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -176,6 +176,7 @@ ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
 				   alloc_repair.o \
+				   ialloc_repair.o \
 				   repair.o \
 				   )
 endif
diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
new file mode 100644
index 000000000000..dc7b3e95b6c1
--- /dev/null
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -0,0 +1,479 @@
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
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
+	struct xfs_repair_extent_list		btlist;
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
+	if (xfs_scrub_should_terminate(ri->sc, &error))
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
+				KM_MAYFAIL);
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
+	xfs_agino_t			old_count;
+	xfs_agino_t			old_freecount;
+	xfs_agino_t			freecount;
+	unsigned int			count;
+	unsigned int			usedcount;
+	int				logflags;
+	int				error = 0;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	xfs_scrub_perag_get(sc->mp, &sc->sa);
+	pag = sc->sa.pag;
+	/* Collect all reverse mappings for inode blocks. */
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
+	INIT_LIST_HEAD(&ri.extlist);
+	xfs_repair_init_extent_list(&ri.btlist);
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
+	nr_blocks = xfs_iallocbt_calc_size(mp, ri.nr_records);
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		nr_blocks *= 2;
+	if (!xfs_repair_ag_has_space(pag, nr_blocks, XFS_AG_RESV_NONE)) {
+		error = -ENOSPC;
+		goto out;
+	}
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
+		error = xfs_repair_iallocbt_insert_rec(sc, rie);
+		if (error)
+			goto out;
+
+		list_del(&rie->list);
+		kmem_free(rie);
+	}
+
+
+	/* Update the AGI counters. */
+	agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
+	old_count = be32_to_cpu(agi->agi_count);
+	old_freecount = be32_to_cpu(agi->agi_freecount);
+	freecount = count - usedcount;
+
+	xfs_repair_mod_ino_counts(sc, old_count, count, old_freecount,
+			freecount);
+
+	if (count != old_count) {
+		if (sc->sa.pag->pagi_init)
+			sc->sa.pag->pagi_count = count;
+		agi->agi_count = cpu_to_be32(count);
+		xfs_ialloc_log_agi(sc->tp, sc->sa.agi_bp, XFS_AGI_COUNT);
+	}
+
+	if (freecount != old_freecount) {
+		if (sc->sa.pag->pagi_init)
+			sc->sa.pag->pagi_freecount = freecount;
+		agi->agi_freecount = cpu_to_be32(freecount);
+		xfs_ialloc_log_agi(sc->tp, sc->sa.agi_bp, XFS_AGI_FREECOUNT);
+	}
+
+	/* Free the old inode btree blocks if they're not in use. */
+	return xfs_repair_reap_btree_extents(sc, &ri.btlist, &oinfo,
+			XFS_AG_RESV_NONE);
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
index 82cf2d012ebc..eaacbd589754 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -112,6 +112,7 @@ int xfs_repair_agf(struct xfs_scrub_context *sc);
 int xfs_repair_agfl(struct xfs_scrub_context *sc);
 int xfs_repair_agi(struct xfs_scrub_context *sc);
 int xfs_repair_allocbt(struct xfs_scrub_context *sc);
+int xfs_repair_iallocbt(struct xfs_scrub_context *sc);
 
 #else
 
@@ -139,6 +140,7 @@ xfs_repair_calc_ag_resblks(
 #define xfs_repair_agfl			xfs_repair_notsupported
 #define xfs_repair_agi			xfs_repair_notsupported
 #define xfs_repair_allocbt		xfs_repair_notsupported
+#define xfs_repair_iallocbt		xfs_repair_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 213d7e21466a..95f82c7f77f6 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -252,14 +252,14 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
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

