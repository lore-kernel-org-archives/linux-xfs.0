Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E4AAC001DC
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbjG0Wb0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbjG0WbZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:31:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A4630D6
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:31:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B084661F57
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A42CC433C7;
        Thu, 27 Jul 2023 22:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690497080;
        bh=Efq1Pm3moeDZcFrlVHykOdy26VATR/g3GblBNqHZdxQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=rr2JIoLDQO+T7l0dwU2EYeKvkFWIGWM+Tctyw+bKw372qmFRnK6osEaRdRmFGeDBr
         6LeLWDYu+J3/fZmXLphbbU8e2pLDgDNwhZYpnHCq195ORPvd02Sgtwgkx5G1+M7d5U
         NINZD+gWgXSw4Bn/EV+5CA2TyOIoqQwpNMW0Y3l/TcHG8+S4eOm1B1YglfuF8U7jeT
         Yd7St+90nPTc5K+KkxdAL6YzD5mUlocQj66ibHmsufuH3QPHinLn+GN+kAwMOm1V1i
         Hibfwnx5a2qQJX+kGxwVgsV/jyGeHid9rcGmlF0xFWTEHu1EeaJKbqXGCd8MCwteEZ
         qI7ZFnNtDQ6dw==
Date:   Thu, 27 Jul 2023 15:31:19 -0700
Subject: [PATCH 4/5] xfs: repair inode btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <169049625768.922264.16783258840306382356.stgit@frogsfrogsfrogs>
In-Reply-To: <169049625702.922264.5146998399930069330.stgit@frogsfrogsfrogs>
References: <169049625702.922264.5146998399930069330.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use the rmapbt to find inode chunks, query the chunks to compute
hole and free masks, and with that information rebuild the inobt
and finobt.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/Makefile              |    1 
 fs/xfs/libxfs/xfs_ialloc.c   |   41 +-
 fs/xfs/libxfs/xfs_ialloc.h   |    3 
 fs/xfs/scrub/common.c        |    1 
 fs/xfs/scrub/ialloc_repair.c |  882 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.c        |   59 +++
 fs/xfs/scrub/repair.h        |   17 +
 fs/xfs/scrub/scrub.c         |    6 
 fs/xfs/scrub/scrub.h         |    1 
 fs/xfs/scrub/trace.h         |   68 ++-
 10 files changed, 1030 insertions(+), 49 deletions(-)
 create mode 100644 fs/xfs/scrub/ialloc_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 026591681937d..7fed0e706cfa0 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -182,6 +182,7 @@ ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
 				   alloc_repair.o \
+				   ialloc_repair.o \
 				   newbt.o \
 				   reap.o \
 				   repair.o \
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index b83e54c709069..fe6e3ce3d2029 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -95,18 +95,29 @@ xfs_inobt_btrec_to_irec(
 	irec->ir_free = be64_to_cpu(rec->inobt.ir_free);
 }
 
-/* Simple checks for inode records. */
-xfs_failaddr_t
-xfs_inobt_check_irec(
-	struct xfs_btree_cur			*cur,
+/* Compute the freecount of an incore inode record. */
+uint8_t
+xfs_inobt_rec_freecount(
 	const struct xfs_inobt_rec_incore	*irec)
 {
-	uint64_t			realfree;
+	uint64_t				realfree;
 
+	if (!xfs_inobt_issparse(irec->ir_holemask))
+		realfree = irec->ir_free;
+	else
+		realfree = irec->ir_free & xfs_inobt_irec_to_allocmask(irec);
+	return hweight64(realfree);
+}
+
+inline xfs_failaddr_t
+xfs_inobt_check_perag_irec(
+	struct xfs_perag			*pag,
+	const struct xfs_inobt_rec_incore	*irec)
+{
 	/* Record has to be properly aligned within the AG. */
-	if (!xfs_verify_agino(cur->bc_ag.pag, irec->ir_startino))
+	if (!xfs_verify_agino(pag, irec->ir_startino))
 		return __this_address;
-	if (!xfs_verify_agino(cur->bc_ag.pag,
+	if (!xfs_verify_agino(pag,
 				irec->ir_startino + XFS_INODES_PER_CHUNK - 1))
 		return __this_address;
 	if (irec->ir_count < XFS_INODES_PER_HOLEMASK_BIT ||
@@ -115,17 +126,21 @@ xfs_inobt_check_irec(
 	if (irec->ir_freecount > XFS_INODES_PER_CHUNK)
 		return __this_address;
 
-	/* if there are no holes, return the first available offset */
-	if (!xfs_inobt_issparse(irec->ir_holemask))
-		realfree = irec->ir_free;
-	else
-		realfree = irec->ir_free & xfs_inobt_irec_to_allocmask(irec);
-	if (hweight64(realfree) != irec->ir_freecount)
+	if (xfs_inobt_rec_freecount(irec) != irec->ir_freecount)
 		return __this_address;
 
 	return NULL;
 }
 
+/* Simple checks for inode records. */
+xfs_failaddr_t
+xfs_inobt_check_irec(
+	struct xfs_btree_cur			*cur,
+	const struct xfs_inobt_rec_incore	*irec)
+{
+	return xfs_inobt_check_perag_irec(cur->bc_ag.pag, irec);
+}
+
 static inline int
 xfs_inobt_complain_bad_rec(
 	struct xfs_btree_cur		*cur,
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index fe824bb04a091..012aac5671bad 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -79,6 +79,7 @@ int xfs_inobt_lookup(struct xfs_btree_cur *cur, xfs_agino_t ino,
  */
 int xfs_inobt_get_rec(struct xfs_btree_cur *cur,
 		xfs_inobt_rec_incore_t *rec, int *stat);
+uint8_t xfs_inobt_rec_freecount(const struct xfs_inobt_rec_incore *irec);
 
 /*
  * Inode chunk initialisation routine
@@ -93,6 +94,8 @@ union xfs_btree_rec;
 void xfs_inobt_btrec_to_irec(struct xfs_mount *mp,
 		const union xfs_btree_rec *rec,
 		struct xfs_inobt_rec_incore *irec);
+xfs_failaddr_t xfs_inobt_check_perag_irec(struct xfs_perag *pag,
+		const struct xfs_inobt_rec_incore *irec);
 xfs_failaddr_t xfs_inobt_check_irec(struct xfs_btree_cur *cur,
 		const struct xfs_inobt_rec_incore *irec);
 int xfs_ialloc_has_inodes_at_extent(struct xfs_btree_cur *cur,
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 61f583b72a669..52fa0028c7ba0 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -605,6 +605,7 @@ xchk_ag_free(
 	struct xchk_ag		*sa)
 {
 	xchk_ag_btcur_free(sa);
+	xrep_reset_perag_resv(sc);
 	if (sa->agf_bp) {
 		xfs_trans_brelse(sc->tp, sa->agf_bp);
 		sa->agf_bp = NULL;
diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
new file mode 100644
index 0000000000000..05302f411d7e3
--- /dev/null
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -0,0 +1,882 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_btree_staging.h"
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
+#include "xfs_health.h"
+#include "xfs_ag.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/bitmap.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
+#include "scrub/newbt.h"
+#include "scrub/reap.h"
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
+	/* new inobt information */
+	struct xrep_newbt	new_inobt;
+
+	/* new finobt information */
+	struct xrep_newbt	new_finobt;
+
+	/* Old inode btree blocks we found in the rmap. */
+	struct xagb_bitmap	old_iallocbt_blocks;
+
+	/* Reconstructed inode records. */
+	struct xfarray		*inode_records;
+
+	struct xfs_scrub	*sc;
+
+	/* Number of inodes assigned disk space. */
+	unsigned int		icount;
+
+	/* Number of inodes in use. */
+	unsigned int		iused;
+
+	/* Number of finobt records needed. */
+	unsigned int		finobt_recs;
+
+	/* get_records()'s position in the inode record array. */
+	xfarray_idx_t		array_cur;
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
+	xfs_agino_t		agino;
+	xfs_agnumber_t		agno = ri->sc->sa.pag->pag_agno;
+	unsigned int		cluster_buf_base;
+	unsigned int		offset;
+	int			error;
+
+	agino = cluster_ag_base + cluster_index;
+	fsino = XFS_AGINO_TO_INO(mp, agno, agino);
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
+	error = xchk_inode_is_allocated(sc, agino, inuse);
+	if (!error)
+		return 0;
+
+	*inuse = dip->di_mode != 0;
+	return 0;
+}
+
+/* Stash the accumulated inobt record for rebuilding. */
+STATIC int
+xrep_ibt_stash(
+	struct xrep_ibt		*ri)
+{
+	int			error = 0;
+
+	if (xchk_should_terminate(ri->sc, &error))
+		return error;
+
+	ri->rie.ir_freecount = xfs_inobt_rec_freecount(&ri->rie);
+	if (xfs_inobt_check_perag_irec(ri->sc->sa.pag, &ri->rie) != NULL)
+		return -EFSCORRUPTED;
+
+	if (ri->rie.ir_freecount > 0)
+		ri->finobt_recs++;
+
+	trace_xrep_ibt_found(ri->sc->mp, ri->sc->sa.pag->pag_agno, &ri->rie);
+
+	error = xfarray_append(ri->inode_records, &ri->rie);
+	if (error)
+		return error;
+
+	ri->rie.ir_startino = NULLAGINO;
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
+	int			error = 0;
+
+	ir_startino = cluster_ir_startino;
+	if (xfs_has_sparseinodes(mp))
+		ir_startino = rounddown(ir_startino, XFS_INODES_PER_CHUNK);
+	cluster_base = cluster_ir_startino - ir_startino;
+
+	/*
+	 * If the accumulated inobt record doesn't map this cluster, add it to
+	 * the list and reset it.
+	 */
+	if (ri->rie.ir_startino != NULLAGINO &&
+	    ri->rie.ir_startino + XFS_INODES_PER_CHUNK <= ir_startino) {
+		error = xrep_ibt_stash(ri);
+		if (error)
+			return error;
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
+		bool		inuse = false;
+
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
+	struct xfs_buf		*cluster_bp;
+	struct xfs_scrub	*sc = ri->sc;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	xfs_agino_t		cluster_ag_base;
+	xfs_agino_t		irec_index;
+	unsigned int		nr_inodes;
+	int			error;
+
+	nr_inodes = min_t(unsigned int, igeo->inodes_per_cluster,
+			XFS_INODES_PER_CHUNK);
+
+	/*
+	 * Grab the inode cluster buffer.  This is safe to do with a broken
+	 * inobt because imap_to_bp directly maps the buffer without touching
+	 * either inode btree.
+	 */
+	imap.im_blkno = XFS_AGB_TO_DADDR(mp, sc->sa.pag->pag_agno, cluster_bno);
+	imap.im_len = XFS_FSB_TO_BB(mp, igeo->blocks_per_cluster);
+	imap.im_boffset = 0;
+	error = xfs_imap_to_bp(mp, sc->tp, &imap, &cluster_bp);
+	if (error)
+		return error;
+
+	/*
+	 * Record the contents of each possible inobt record mapping this
+	 * cluster.
+	 */
+	cluster_ag_base = XFS_AGB_TO_AGINO(mp, cluster_bno);
+	for (irec_index = 0;
+	     irec_index < igeo->inodes_per_cluster;
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
+/* Check for any obvious conflicts in the inode chunk extent. */
+STATIC int
+xrep_ibt_check_inode_ext(
+	struct xfs_scrub	*sc,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		len)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	xfs_agino_t		agino;
+	enum xbtree_recpacking	outcome;
+	int			error;
+
+	/* Inode records must be within the AG. */
+	if (!xfs_verify_agbext(sc->sa.pag, agbno, len))
+		return -EFSCORRUPTED;
+
+	/* The entire record must align to the inode cluster size. */
+	if (!IS_ALIGNED(agbno, igeo->blocks_per_cluster) ||
+	    !IS_ALIGNED(agbno + len, igeo->blocks_per_cluster))
+		return -EFSCORRUPTED;
+
+	/*
+	 * The entire record must also adhere to the inode cluster alignment
+	 * size if sparse inodes are not enabled.
+	 */
+	if (!xfs_has_sparseinodes(mp) &&
+	    (!IS_ALIGNED(agbno, igeo->cluster_align) ||
+	     !IS_ALIGNED(agbno + len, igeo->cluster_align)))
+		return -EFSCORRUPTED;
+
+	/*
+	 * On a sparse inode fs, this cluster could be part of a sparse chunk.
+	 * Sparse clusters must be aligned to sparse chunk alignment.
+	 */
+	if (xfs_has_sparseinodes(mp) &&
+	    (!IS_ALIGNED(agbno, mp->m_sb.sb_spino_align) ||
+	     !IS_ALIGNED(agbno + len, mp->m_sb.sb_spino_align)))
+		return -EFSCORRUPTED;
+
+	/* Make sure the entire range of blocks are valid AG inodes. */
+	agino = XFS_AGB_TO_AGINO(mp, agbno);
+	if (!xfs_verify_agino(sc->sa.pag, agino))
+		return -EFSCORRUPTED;
+
+	agino = XFS_AGB_TO_AGINO(mp, agbno + len) - 1;
+	if (!xfs_verify_agino(sc->sa.pag, agino))
+		return -EFSCORRUPTED;
+
+	/* Make sure this isn't free space. */
+	error = xfs_alloc_has_records(sc->sa.bno_cur, agbno, len, &outcome);
+	if (error)
+		return error;
+	if (outcome != XBTREE_RECPACKING_EMPTY)
+		return -EFSCORRUPTED;
+
+	return 0;
+}
+
+/* Found a fragment of the old inode btrees; dispose of them later. */
+STATIC int
+xrep_ibt_record_old_btree_blocks(
+	struct xrep_ibt			*ri,
+	const struct xfs_rmap_irec	*rec)
+{
+	if (!xfs_verify_agbext(ri->sc->sa.pag, rec->rm_startblock,
+				rec->rm_blockcount))
+		return -EFSCORRUPTED;
+
+	return xagb_bitmap_set(&ri->old_iallocbt_blocks, rec->rm_startblock,
+			rec->rm_blockcount);
+}
+
+/* Record extents that belong to inode btrees. */
+STATIC int
+xrep_ibt_walk_rmap(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct xrep_ibt			*ri = priv;
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_ino_geometry		*igeo = M_IGEO(mp);
+	xfs_agblock_t			cluster_base;
+	int				error = 0;
+
+	if (xchk_should_terminate(ri->sc, &error))
+		return error;
+
+	if (rec->rm_owner == XFS_RMAP_OWN_INOBT)
+		return xrep_ibt_record_old_btree_blocks(ri, rec);
+
+	/* Skip extents which are not owned by this inode and fork. */
+	if (rec->rm_owner != XFS_RMAP_OWN_INODES)
+		return 0;
+
+	error = xrep_ibt_check_inode_ext(ri->sc, rec->rm_startblock,
+			rec->rm_blockcount);
+	if (error)
+		return error;
+
+	trace_xrep_ibt_walk_rmap(mp, ri->sc->sa.pag->pag_agno,
+			rec->rm_startblock, rec->rm_blockcount, rec->rm_owner,
+			rec->rm_offset, rec->rm_flags);
+
+	/*
+	 * Record the free/hole masks for each inode cluster that could be
+	 * mapped by this rmap record.
+	 */
+	for (cluster_base = 0;
+	     cluster_base < rec->rm_blockcount;
+	     cluster_base += igeo->blocks_per_cluster) {
+		error = xrep_ibt_process_cluster(ri,
+				rec->rm_startblock + cluster_base);
+		if (error)
+			return error;
+	}
+
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
+	struct xrep_ibt		*ri)
+{
+	struct xfs_scrub	*sc = ri->sc;
+	int			error;
+
+	ri->rie.ir_startino = NULLAGINO;
+
+	/* Collect all reverse mappings for inode blocks. */
+	xrep_ag_btcur_init(sc, &sc->sa);
+	error = xfs_rmap_query_all(sc->sa.rmap_cur, xrep_ibt_walk_rmap, ri);
+	xchk_ag_btcur_free(&sc->sa);
+	if (error)
+		return error;
+
+	/* If we have a record ready to go, add it to the array. */
+	if (ri->rie.ir_startino == NULLAGINO)
+		return 0;
+
+	return xrep_ibt_stash(ri);
+}
+
+/* Update the AGI counters. */
+STATIC int
+xrep_ibt_reset_counters(
+	struct xrep_ibt		*ri)
+{
+	struct xfs_scrub	*sc = ri->sc;
+	struct xfs_agi		*agi = sc->sa.agi_bp->b_addr;
+	unsigned int		freecount = ri->icount - ri->iused;
+
+	/* Trigger inode count recalculation */
+	xfs_force_summary_recalc(sc->mp);
+
+	/*
+	 * The AGI header contains extra information related to the inode
+	 * btrees, so we must update those fields here.
+	 */
+	agi->agi_count = cpu_to_be32(ri->icount);
+	agi->agi_freecount = cpu_to_be32(freecount);
+	xfs_ialloc_log_agi(sc->tp, sc->sa.agi_bp,
+			   XFS_AGI_COUNT | XFS_AGI_FREECOUNT);
+
+	/* Reinitialize with the values we just logged. */
+	return xrep_reinit_pagi(sc);
+}
+
+/* Retrieve finobt data for bulk load. */
+STATIC int
+xrep_fibt_get_records(
+	struct xfs_btree_cur		*cur,
+	unsigned int			idx,
+	struct xfs_btree_block		*block,
+	unsigned int			nr_wanted,
+	void				*priv)
+{
+	struct xfs_inobt_rec_incore	*irec = &cur->bc_rec.i;
+	struct xrep_ibt			*ri = priv;
+	union xfs_btree_rec		*block_rec;
+	unsigned int			loaded;
+	int				error;
+
+	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
+		do {
+			error = xfarray_load(ri->inode_records,
+					ri->array_cur++, irec);
+		} while (error == 0 && xfs_inobt_rec_freecount(irec) == 0);
+		if (error)
+			return error;
+
+		block_rec = xfs_btree_rec_addr(cur, idx, block);
+		cur->bc_ops->init_rec_from_cur(cur, block_rec);
+	}
+
+	return loaded;
+}
+
+/* Retrieve inobt data for bulk load. */
+STATIC int
+xrep_ibt_get_records(
+	struct xfs_btree_cur		*cur,
+	unsigned int			idx,
+	struct xfs_btree_block		*block,
+	unsigned int			nr_wanted,
+	void				*priv)
+{
+	struct xfs_inobt_rec_incore	*irec = &cur->bc_rec.i;
+	struct xrep_ibt			*ri = priv;
+	union xfs_btree_rec		*block_rec;
+	unsigned int			loaded;
+	int				error;
+
+	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
+		error = xfarray_load(ri->inode_records, ri->array_cur++, irec);
+		if (error)
+			return error;
+
+		block_rec = xfs_btree_rec_addr(cur, idx, block);
+		cur->bc_ops->init_rec_from_cur(cur, block_rec);
+	}
+
+	return loaded;
+}
+
+/* Feed one of the new inobt blocks to the bulk loader. */
+STATIC int
+xrep_ibt_claim_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	void			*priv)
+{
+	struct xrep_ibt		*ri = priv;
+	int			error;
+
+	error = xrep_newbt_relog_autoreap(&ri->new_inobt);
+	if (error)
+		return error;
+
+	return xrep_newbt_claim_block(cur, &ri->new_inobt, ptr);
+}
+
+/* Feed one of the new finobt blocks to the bulk loader. */
+STATIC int
+xrep_fibt_claim_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	void			*priv)
+{
+	struct xrep_ibt		*ri = priv;
+	int			error;
+
+	error = xrep_newbt_relog_autoreap(&ri->new_finobt);
+	if (error)
+		return error;
+
+	return xrep_newbt_claim_block(cur, &ri->new_finobt, ptr);
+}
+
+/* Make sure the records do not overlap in inumber address space. */
+STATIC int
+xrep_ibt_check_startino(
+	struct xrep_ibt			*ri)
+{
+	struct xfs_inobt_rec_incore	irec;
+	xfarray_idx_t			cur;
+	xfs_agino_t			next_agino = 0;
+	int				error = 0;
+
+	foreach_xfarray_idx(ri->inode_records, cur) {
+		if (xchk_should_terminate(ri->sc, &error))
+			return error;
+
+		error = xfarray_load(ri->inode_records, cur, &irec);
+		if (error)
+			return error;
+
+		if (irec.ir_startino < next_agino)
+			return -EFSCORRUPTED;
+
+		next_agino = irec.ir_startino + XFS_INODES_PER_CHUNK;
+	}
+
+	return error;
+}
+
+/* Build new inode btrees and dispose of the old one. */
+STATIC int
+xrep_ibt_build_new_trees(
+	struct xrep_ibt		*ri)
+{
+	struct xfs_scrub	*sc = ri->sc;
+	struct xfs_btree_cur	*ino_cur;
+	struct xfs_btree_cur	*fino_cur = NULL;
+	xfs_fsblock_t		fsbno;
+	bool			need_finobt;
+	int			error;
+
+	need_finobt = xfs_has_finobt(sc->mp);
+
+	/*
+	 * Create new btrees for staging all the inobt records we collected
+	 * earlier.  The records were collected in order of increasing agino,
+	 * so we do not have to sort them.  Ensure there are no overlapping
+	 * records.
+	 */
+	error = xrep_ibt_check_startino(ri);
+	if (error)
+		return error;
+
+	/*
+	 * The new inode btrees will not be rooted in the AGI until we've
+	 * successfully rebuilt the tree.
+	 *
+	 * Start by setting up the inobt staging cursor.
+	 */
+	fsbno = XFS_AGB_TO_FSB(sc->mp, sc->sa.pag->pag_agno,
+			XFS_IBT_BLOCK(sc->mp)),
+	xrep_newbt_init_ag(&ri->new_inobt, sc, &XFS_RMAP_OINFO_INOBT, fsbno,
+			XFS_AG_RESV_NONE);
+	ri->new_inobt.bload.claim_block = xrep_ibt_claim_block;
+	ri->new_inobt.bload.get_records = xrep_ibt_get_records;
+
+	ino_cur = xfs_inobt_stage_cursor(sc->sa.pag, &ri->new_inobt.afake,
+			XFS_BTNUM_INO);
+	error = xfs_btree_bload_compute_geometry(ino_cur, &ri->new_inobt.bload,
+			xfarray_length(ri->inode_records));
+	if (error)
+		goto err_inocur;
+
+	/* Set up finobt staging cursor. */
+	if (need_finobt) {
+		enum xfs_ag_resv_type	resv = XFS_AG_RESV_METADATA;
+
+		if (sc->mp->m_finobt_nores)
+			resv = XFS_AG_RESV_NONE;
+
+		fsbno = XFS_AGB_TO_FSB(sc->mp, sc->sa.pag->pag_agno,
+				XFS_FIBT_BLOCK(sc->mp)),
+		xrep_newbt_init_ag(&ri->new_finobt, sc, &XFS_RMAP_OINFO_INOBT,
+				fsbno, resv);
+		ri->new_finobt.bload.claim_block = xrep_fibt_claim_block;
+		ri->new_finobt.bload.get_records = xrep_fibt_get_records;
+
+		fino_cur = xfs_inobt_stage_cursor(sc->sa.pag,
+				&ri->new_finobt.afake, XFS_BTNUM_FINO);
+		error = xfs_btree_bload_compute_geometry(fino_cur,
+				&ri->new_finobt.bload, ri->finobt_recs);
+		if (error)
+			goto err_finocur;
+	}
+
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		goto err_finocur;
+
+	/* Reserve all the space we need to build the new btrees. */
+	error = xrep_newbt_alloc_blocks(&ri->new_inobt,
+			ri->new_inobt.bload.nr_blocks);
+	if (error)
+		goto err_finocur;
+
+	if (need_finobt) {
+		error = xrep_newbt_alloc_blocks(&ri->new_finobt,
+				ri->new_finobt.bload.nr_blocks);
+		if (error)
+			goto err_finocur;
+	}
+
+	/* Add all inobt records. */
+	ri->array_cur = XFARRAY_CURSOR_INIT;
+	error = xfs_btree_bload(ino_cur, &ri->new_inobt.bload, ri);
+	if (error)
+		goto err_finocur;
+
+	/* Add all finobt records. */
+	if (need_finobt) {
+		ri->array_cur = XFARRAY_CURSOR_INIT;
+		error = xfs_btree_bload(fino_cur, &ri->new_finobt.bload, ri);
+		if (error)
+			goto err_finocur;
+	}
+
+	/*
+	 * Install the new btrees in the AG header.  After this point the old
+	 * btrees are no longer accessible and the new trees are live.
+	 */
+	xfs_inobt_commit_staged_btree(ino_cur, sc->tp, sc->sa.agi_bp);
+	xfs_btree_del_cursor(ino_cur, 0);
+
+	if (fino_cur) {
+		xfs_inobt_commit_staged_btree(fino_cur, sc->tp, sc->sa.agi_bp);
+		xfs_btree_del_cursor(fino_cur, 0);
+	}
+
+	/* Reset the AGI counters now that we've changed the inode roots. */
+	error = xrep_ibt_reset_counters(ri);
+	if (error)
+		goto err_finobt;
+
+	/* Free unused blocks and bitmap. */
+	if (need_finobt) {
+		error = xrep_newbt_commit(&ri->new_finobt);
+		if (error)
+			goto err_inobt;
+	}
+	error = xrep_newbt_commit(&ri->new_inobt);
+	if (error)
+		return error;
+
+	return xrep_roll_ag_trans(sc);
+
+err_finocur:
+	if (need_finobt)
+		xfs_btree_del_cursor(fino_cur, error);
+err_inocur:
+	xfs_btree_del_cursor(ino_cur, error);
+err_finobt:
+	if (need_finobt)
+		xrep_newbt_cancel(&ri->new_finobt);
+err_inobt:
+	xrep_newbt_cancel(&ri->new_inobt);
+	return error;
+}
+
+/*
+ * Now that we've logged the roots of the new btrees, invalidate all of the
+ * old blocks and free them.
+ */
+STATIC int
+xrep_ibt_remove_old_trees(
+	struct xrep_ibt		*ri)
+{
+	struct xfs_scrub	*sc = ri->sc;
+	int			error;
+
+	/*
+	 * Free the old inode btree blocks if they're not in use.  It's ok to
+	 * reap with XFS_AG_RESV_NONE even if the finobt had a per-AG
+	 * reservation because we reset the reservation before releasing the
+	 * AGI and AGF header buffer locks.
+	 */
+	error = xrep_reap_agblocks(sc, &ri->old_iallocbt_blocks,
+			&XFS_RMAP_OINFO_INOBT, XFS_AG_RESV_NONE);
+	if (error)
+		return error;
+
+	/*
+	 * If the finobt is enabled and has a per-AG reservation, make sure we
+	 * reinitialize the per-AG reservations.
+	 */
+	if (xfs_has_finobt(sc->mp) && !sc->mp->m_finobt_nores)
+		sc->flags |= XREP_RESET_PERAG_RESV;
+
+	return 0;
+}
+
+/* Repair both inode btrees. */
+int
+xrep_iallocbt(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_ibt		*ri;
+	struct xfs_mount	*mp = sc->mp;
+	char			*descr;
+	xfs_agino_t		first_agino, last_agino;
+	int			error = 0;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_has_rmapbt(mp))
+		return -EOPNOTSUPP;
+
+	ri = kzalloc(sizeof(struct xrep_ibt), XCHK_GFP_FLAGS);
+	if (!ri)
+		return -ENOMEM;
+	ri->sc = sc;
+
+	/* We rebuild both inode btrees. */
+	sc->sick_mask = XFS_SICK_AG_INOBT | XFS_SICK_AG_FINOBT;
+
+	/* Set up enough storage to handle an AG with nothing but inodes. */
+	xfs_agino_range(mp, sc->sa.pag->pag_agno, &first_agino, &last_agino);
+	last_agino /= XFS_INODES_PER_CHUNK;
+	descr = xchk_xfile_ag_descr(sc, "inode index records");
+	error = xfarray_create(descr, last_agino,
+			sizeof(struct xfs_inobt_rec_incore),
+			&ri->inode_records);
+	kfree(descr);
+	if (error)
+		goto out_ri;
+
+	/* Collect the inode data and find the old btree blocks. */
+	xagb_bitmap_init(&ri->old_iallocbt_blocks);
+	error = xrep_ibt_find_inodes(ri);
+	if (error)
+		goto out_bitmap;
+
+	/* Rebuild the inode indexes. */
+	error = xrep_ibt_build_new_trees(ri);
+	if (error)
+		goto out_bitmap;
+
+	/* Kill the old tree. */
+	error = xrep_ibt_remove_old_trees(ri);
+
+out_bitmap:
+	xagb_bitmap_destroy(&ri->old_iallocbt_blocks);
+	xfarray_destroy(ri->inode_records);
+out_ri:
+	kfree(ri);
+	return error;
+}
+
+/* Make sure both btrees are ok after we've rebuilt them. */
+int
+xrep_revalidate_iallocbt(
+	struct xfs_scrub	*sc)
+{
+	__u32			old_type = sc->sm->sm_type;
+	int			error;
+
+	/*
+	 * We must update sm_type temporarily so that the tree-to-tree cross
+	 * reference checks will work in the correct direction, and also so
+	 * that tracing will report correctly if there are more errors.
+	 */
+	sc->sm->sm_type = XFS_SCRUB_TYPE_INOBT;
+	error = xchk_inobt(sc);
+	if (error)
+		goto out;
+
+	if (xfs_has_finobt(sc->mp)) {
+		sc->sm->sm_type = XFS_SCRUB_TYPE_FINOBT;
+		error = xchk_finobt(sc);
+	}
+
+out:
+	sc->sm->sm_type = old_type;
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index cec6d63080632..9e336ab249535 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -813,3 +813,62 @@ xrep_reinit_pagf(
 
 	return 0;
 }
+
+/*
+ * Reinitialize the in-core AG state after a repair by rereading the AGI
+ * buffer.  We had better get the same AGI buffer as the one that's attached
+ * to the scrub context.
+ */
+int
+xrep_reinit_pagi(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_perag	*pag = sc->sa.pag;
+	struct xfs_buf		*bp;
+	int			error;
+
+	ASSERT(pag);
+	ASSERT(xfs_perag_initialised_agi(pag));
+
+	clear_bit(XFS_AGSTATE_AGI_INIT, &pag->pag_opstate);
+	error = xfs_ialloc_read_agi(pag, sc->tp, &bp);
+	if (error)
+		return error;
+
+	if (bp != sc->sa.agi_bp) {
+		ASSERT(bp == sc->sa.agi_bp);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
+/* Reinitialize the per-AG block reservation for the AG we just fixed. */
+int
+xrep_reset_perag_resv(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	if (!(sc->flags & XREP_RESET_PERAG_RESV))
+		return 0;
+
+	ASSERT(sc->sa.pag != NULL);
+	ASSERT(sc->ops->type == ST_PERAG);
+	ASSERT(sc->tp);
+
+	sc->flags &= ~XREP_RESET_PERAG_RESV;
+	error = xfs_ag_resv_free(sc->sa.pag);
+	if (error)
+		goto out;
+	error = xfs_ag_resv_init(sc->sa.pag, sc->tp);
+	if (error == -ENOSPC) {
+		xfs_err(sc->mp,
+"Insufficient free space to reset per-AG reservation for AG %u after repair.",
+				sc->sa.pag->pag_agno);
+		error = 0;
+	}
+
+out:
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 74d287138b719..3ff5e37316685 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -52,6 +52,7 @@ int xrep_find_ag_btree_roots(struct xfs_scrub *sc, struct xfs_buf *agf_bp,
 		struct xrep_find_ag_btree *btree_info, struct xfs_buf *agfl_bp);
 void xrep_force_quotacheck(struct xfs_scrub *sc, xfs_dqtype_t type);
 int xrep_ino_dqattach(struct xfs_scrub *sc);
+int xrep_reset_perag_resv(struct xfs_scrub *sc);
 
 /* Repair setup functions */
 int xrep_setup_ag_allocbt(struct xfs_scrub *sc);
@@ -61,6 +62,7 @@ void xrep_ag_btcur_init(struct xfs_scrub *sc, struct xchk_ag *sa);
 /* Metadata revalidators */
 
 int xrep_revalidate_allocbt(struct xfs_scrub *sc);
+int xrep_revalidate_iallocbt(struct xfs_scrub *sc);
 
 /* Metadata repairers */
 
@@ -70,8 +72,10 @@ int xrep_agf(struct xfs_scrub *sc);
 int xrep_agfl(struct xfs_scrub *sc);
 int xrep_agi(struct xfs_scrub *sc);
 int xrep_allocbt(struct xfs_scrub *sc);
+int xrep_iallocbt(struct xfs_scrub *sc);
 
 int xrep_reinit_pagf(struct xfs_scrub *sc);
+int xrep_reinit_pagi(struct xfs_scrub *sc);
 
 #else
 
@@ -92,6 +96,17 @@ xrep_calc_ag_resblks(
 	return 0;
 }
 
+static inline int
+xrep_reset_perag_resv(
+	struct xfs_scrub	*sc)
+{
+	if (!(sc->flags & XREP_RESET_PERAG_RESV))
+		return 0;
+
+	ASSERT(0);
+	return -EOPNOTSUPP;
+}
+
 /* repair setup functions for no-repair */
 static inline int
 xrep_setup_nothing(
@@ -102,6 +117,7 @@ xrep_setup_nothing(
 #define xrep_setup_ag_allocbt		xrep_setup_nothing
 
 #define xrep_revalidate_allocbt		(NULL)
+#define xrep_revalidate_iallocbt	(NULL)
 
 #define xrep_probe			xrep_notsupported
 #define xrep_superblock			xrep_notsupported
@@ -109,6 +125,7 @@ xrep_setup_nothing(
 #define xrep_agfl			xrep_notsupported
 #define xrep_agi			xrep_notsupported
 #define xrep_allocbt			xrep_notsupported
+#define xrep_iallocbt			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index f9f8537bfe9c0..57f2db883792e 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -253,14 +253,16 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_iallocbt,
 		.scrub	= xchk_inobt,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_iallocbt,
+		.repair_eval = xrep_revalidate_iallocbt,
 	},
 	[XFS_SCRUB_TYPE_FINOBT] = {	/* finobt */
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_iallocbt,
 		.scrub	= xchk_finobt,
 		.has	= xfs_has_finobt,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_iallocbt,
+		.repair_eval = xrep_revalidate_iallocbt,
 	},
 	[XFS_SCRUB_TYPE_RMAPBT] = {	/* rmapbt */
 		.type	= ST_PERAG,
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 999100c88ec4e..d44e71fbb7df7 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -120,6 +120,7 @@ struct xfs_scrub {
 #define XCHK_TRY_HARDER		(1U << 0)  /* can't get resources, try again */
 #define XCHK_FSGATES_DRAIN	(1U << 2)  /* defer ops draining enabled */
 #define XCHK_NEED_DRAIN		(1U << 3)  /* scrub needs to drain defer ops */
+#define XREP_RESET_PERAG_RESV	(1U << 30) /* must reset AG space reservation */
 #define XREP_ALREADY_FIXED	(1U << 31) /* checking our repair work */
 
 /*
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index c9097d138c044..79d1316b288ed 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -105,6 +105,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FSCOUNTERS);
 	{ XCHK_TRY_HARDER,			"try_harder" }, \
 	{ XCHK_FSGATES_DRAIN,			"fsgates_drain" }, \
 	{ XCHK_NEED_DRAIN,			"need_drain" }, \
+	{ XREP_RESET_PERAG_RESV,		"reset_perag_resv" }, \
 	{ XREP_ALREADY_FIXED,			"already_fixed" }
 
 DECLARE_EVENT_CLASS(xchk_class,
@@ -1145,7 +1146,7 @@ DEFINE_EVENT(xrep_rmap_class, name, \
 		 xfs_agblock_t agbno, xfs_extlen_t len, \
 		 uint64_t owner, uint64_t offset, unsigned int flags), \
 	TP_ARGS(mp, agno, agbno, len, owner, offset, flags))
-DEFINE_REPAIR_RMAP_EVENT(xrep_ialloc_extent_fn);
+DEFINE_REPAIR_RMAP_EVENT(xrep_ibt_walk_rmap);
 DEFINE_REPAIR_RMAP_EVENT(xrep_rmap_extent_fn);
 DEFINE_REPAIR_RMAP_EVENT(xrep_bmap_extent_fn);
 
@@ -1172,6 +1173,38 @@ TRACE_EVENT(xrep_abt_found,
 		  __entry->blockcount)
 )
 
+TRACE_EVENT(xrep_ibt_found,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 const struct xfs_inobt_rec_incore *rec),
+	TP_ARGS(mp, agno, rec),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, startino)
+		__field(uint16_t, holemask)
+		__field(uint8_t, count)
+		__field(uint8_t, freecount)
+		__field(uint64_t, freemask)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->startino = rec->ir_startino;
+		__entry->holemask = rec->ir_holemask;
+		__entry->count = rec->ir_count;
+		__entry->freecount = rec->ir_freecount;
+		__entry->freemask = rec->ir_free;
+	),
+	TP_printk("dev %d:%d agno 0x%x agino 0x%x holemask 0x%x count 0x%x freecount 0x%x freemask 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->startino,
+		  __entry->holemask,
+		  __entry->count,
+		  __entry->freecount,
+		  __entry->freemask)
+)
+
 TRACE_EVENT(xrep_refcount_extent_fn,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
 		 struct xfs_refcount_irec *irec),
@@ -1294,39 +1327,6 @@ TRACE_EVENT(xrep_reset_counters,
 		  MAJOR(__entry->dev), MINOR(__entry->dev))
 )
 
-TRACE_EVENT(xrep_ialloc_insert,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agino_t startino, uint16_t holemask, uint8_t count,
-		 uint8_t freecount, uint64_t freemask),
-	TP_ARGS(mp, agno, startino, holemask, count, freecount, freemask),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_agnumber_t, agno)
-		__field(xfs_agino_t, startino)
-		__field(uint16_t, holemask)
-		__field(uint8_t, count)
-		__field(uint8_t, freecount)
-		__field(uint64_t, freemask)
-	),
-	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->startino = startino;
-		__entry->holemask = holemask;
-		__entry->count = count;
-		__entry->freecount = freecount;
-		__entry->freemask = freemask;
-	),
-	TP_printk("dev %d:%d agno 0x%x startino 0x%x holemask 0x%x count %u freecount %u freemask 0x%llx",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->agno,
-		  __entry->startino,
-		  __entry->holemask,
-		  __entry->count,
-		  __entry->freecount,
-		  __entry->freemask)
-)
-
 DECLARE_EVENT_CLASS(xrep_newbt_extent_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
 		 xfs_agblock_t agbno, xfs_extlen_t len,

