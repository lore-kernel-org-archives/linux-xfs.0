Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1811C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:09:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235860AbiLaAJ0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235855AbiLaAJY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:09:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66111E3C5
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:09:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DFD861CD4
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D364DC433EF;
        Sat, 31 Dec 2022 00:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445360;
        bh=+zOOXRREf3NLEZo1K6Cq+gnKSdjYX7/IC9ivjBtCv0o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=L5CPvFjJ+P6WCertaZUEEWj9UZGLtniGB92Gp8r9+HXyFYZDQPswjKUJgc5EKgfRK
         5Z/j2yqClYecCzHudsh1YchkLcLV2ouYF3gq+tRoeluwgYH3LXSrwER8/nYAwb2Ctj
         GHfIUbbPZ7mvpnTBgu0z929M7JAzK9QfwYKGt20c2U5inzOesfDXUhmA87o+qEdIq2
         oc3I5D//RT+LxdCGgEncUCOTkZaC6nYd+RxSsrksRf0B1pB/TX2b0MDxkqZFRieXOX
         V8WbAqqdAX3NxMv8F18i0kAeLOc7eac0t85dGQ7O+NZ5vLzwSSt4Sqcx1/Zn2IUH6U
         rLAfT6GwGf+aA==
Subject: [PATCH 2/2] xfs_repair: rebuild block mappings from rmapbt data
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:32 -0800
Message-ID: <167243865218.709165.1232765679919053772.stgit@magnolia>
In-Reply-To: <167243865191.709165.12894699968646341429.stgit@magnolia>
References: <167243865191.709165.12894699968646341429.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use rmap records to rebuild corrupt inode forks instead of zapping
the whole inode if we think the rmap data is reasonably sane.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_trans.h      |    2 
 libxfs/libxfs_api_defs.h |   13 +
 libxfs/trans.c           |   48 +++
 repair/Makefile          |    2 
 repair/agbtree.c         |    2 
 repair/bmap_repair.c     |  741 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/bmap_repair.h     |   13 +
 repair/bulkload.c        |  175 +++++++++++
 repair/bulkload.h        |   19 +
 repair/dinode.c          |   54 +++
 repair/rmap.c            |    2 
 repair/rmap.h            |    1 
 12 files changed, 1066 insertions(+), 6 deletions(-)
 create mode 100644 repair/bmap_repair.c
 create mode 100644 repair/bmap_repair.h


diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 690759ece3a..ae339df1195 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -91,6 +91,8 @@ int	libxfs_trans_alloc_rollable(struct xfs_mount *mp, uint blocks,
 int	libxfs_trans_alloc_empty(struct xfs_mount *mp, struct xfs_trans **tpp);
 int	libxfs_trans_commit(struct xfs_trans *);
 void	libxfs_trans_cancel(struct xfs_trans *);
+int	libxfs_trans_reserve_more(struct xfs_trans *tp, uint blocks,
+			uint rtextents);
 
 /* cancel dfops associated with a transaction */
 void xfs_defer_cancel(struct xfs_trans *);
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 5aa9c019d40..5d73111b508 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -39,11 +39,18 @@
 #define xfs_attr_set			libxfs_attr_set
 
 #define __xfs_bmap_add_free		__libxfs_bmap_add_free
+#define xfs_bmap_validate_extent	libxfs_bmap_validate_extent
 #define xfs_bmapi_read			libxfs_bmapi_read
+#define xfs_bmapi_remap			libxfs_bmapi_remap
 #define xfs_bmapi_write			libxfs_bmapi_write
 #define xfs_bmap_last_offset		libxfs_bmap_last_offset
+#define xfs_bmbt_calc_size		libxfs_bmbt_calc_size
+#define xfs_bmbt_commit_staged_btree	libxfs_bmbt_commit_staged_btree
+#define xfs_bmbt_disk_get_startoff	libxfs_bmbt_disk_get_startoff
+#define xfs_bmbt_disk_set_all		libxfs_bmbt_disk_set_all
 #define xfs_bmbt_maxlevels_ondisk	libxfs_bmbt_maxlevels_ondisk
 #define xfs_bmbt_maxrecs		libxfs_bmbt_maxrecs
+#define xfs_bmbt_stage_cursor		libxfs_bmbt_stage_cursor
 #define xfs_bmdr_maxrecs		libxfs_bmdr_maxrecs
 
 #define xfs_btree_bload			libxfs_btree_bload
@@ -120,8 +127,12 @@
 #define xfs_ialloc_read_agi		libxfs_ialloc_read_agi
 #define xfs_idata_realloc		libxfs_idata_realloc
 #define xfs_idestroy_fork		libxfs_idestroy_fork
+#define xfs_iext_first			libxfs_iext_first
+#define xfs_iext_insert_raw		libxfs_iext_insert_raw
 #define xfs_iext_lookup_extent		libxfs_iext_lookup_extent
+#define xfs_iext_next			libxfs_iext_next
 #define xfs_ifork_zap_attr		libxfs_ifork_zap_attr
+#define xfs_imap_to_bp			libxfs_imap_to_bp
 #define xfs_initialize_perag		libxfs_initialize_perag
 #define xfs_initialize_perag_data	libxfs_initialize_perag_data
 #define xfs_init_local_fork		libxfs_init_local_fork
@@ -162,10 +173,12 @@
 #define xfs_rmapbt_stage_cursor		libxfs_rmapbt_stage_cursor
 #define xfs_rmap_compare		libxfs_rmap_compare
 #define xfs_rmap_get_rec		libxfs_rmap_get_rec
+#define xfs_rmap_ino_bmbt_owner		libxfs_rmap_ino_bmbt_owner
 #define xfs_rmap_irec_offset_pack	libxfs_rmap_irec_offset_pack
 #define xfs_rmap_irec_offset_unpack	libxfs_rmap_irec_offset_unpack
 #define xfs_rmap_lookup_le		libxfs_rmap_lookup_le
 #define xfs_rmap_lookup_le_range	libxfs_rmap_lookup_le_range
+#define xfs_rmap_query_all		libxfs_rmap_query_all
 #define xfs_rmap_query_range		libxfs_rmap_query_range
 
 #define xfs_rtfree_extent		libxfs_rtfree_extent
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 50d9c23de3e..e9430c61562 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -1046,3 +1046,51 @@ libxfs_trans_alloc_inode(
 	*tpp = tp;
 	return 0;
 }
+
+/*
+ * Try to reserve more blocks for a transaction.  The single use case we
+ * support is for offline repair -- use a transaction to gather data without
+ * fear of btree cycle deadlocks; calculate how many blocks we really need
+ * from that data; and only then start modifying data.  This can fail due to
+ * ENOSPC, so we have to be able to cancel the transaction.
+ */
+int
+libxfs_trans_reserve_more(
+	struct xfs_trans	*tp,
+	uint			blocks,
+	uint			rtextents)
+{
+	int			error = 0;
+
+	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
+
+	/*
+	 * Attempt to reserve the needed disk blocks by decrementing
+	 * the number needed from the number available.  This will
+	 * fail if the count would go below zero.
+	 */
+	if (blocks > 0) {
+		if (tp->t_mountp->m_sb.sb_fdblocks < blocks)
+			return -ENOSPC;
+		tp->t_blk_res += blocks;
+	}
+
+	/*
+	 * Attempt to reserve the needed realtime extents by decrementing
+	 * the number needed from the number available.  This will
+	 * fail if the count would go below zero.
+	 */
+	if (rtextents > 0) {
+		if (tp->t_mountp->m_sb.sb_rextents < rtextents) {
+			error = -ENOSPC;
+			goto out_blocks;
+		}
+	}
+
+	return 0;
+out_blocks:
+	if (blocks > 0)
+		tp->t_blk_res -= blocks;
+
+	return error;
+}
diff --git a/repair/Makefile b/repair/Makefile
index 2c40e59a30f..e5014deb0ce 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -16,6 +16,7 @@ HFILES = \
 	avl.h \
 	bulkload.h \
 	bmap.h \
+	bmap_repair.h \
 	btree.h \
 	da_util.h \
 	dinode.h \
@@ -41,6 +42,7 @@ CFILES = \
 	avl.c \
 	bulkload.c \
 	bmap.c \
+	bmap_repair.c \
 	btree.c \
 	da_util.c \
 	dino_chunks.c \
diff --git a/repair/agbtree.c b/repair/agbtree.c
index cba67c5fbf4..23851f17b61 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -22,7 +22,7 @@ init_rebuild(
 {
 	memset(btr, 0, sizeof(struct bt_rebuild));
 
-	bulkload_init_ag(&btr->newbt, sc, oinfo);
+	bulkload_init_ag(&btr->newbt, sc, oinfo, NULLFSBLOCK);
 	btr->bload.max_dirty = XFS_B_TO_FSBT(sc->mp, 256U << 10); /* 256K */
 	bulkload_estimate_ag_slack(sc, &btr->bload, free_space);
 }
diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
new file mode 100644
index 00000000000..25a9daa7449
--- /dev/null
+++ b/repair/bmap_repair.c
@@ -0,0 +1,741 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include <libxfs.h>
+#include "btree.h"
+#include "err_protos.h"
+#include "libxlog.h"
+#include "incore.h"
+#include "globals.h"
+#include "dinode.h"
+#include "slab.h"
+#include "rmap.h"
+#include "bulkload.h"
+#include "bmap_repair.h"
+
+#define min_t(type, x, y) ( ((type)(x)) > ((type)(y)) ? ((type)(y)) : ((type)(x)) )
+
+/*
+ * Inode Fork Block Mapping (BMBT) Repair
+ * ======================================
+ *
+ * Gather all the rmap records for the inode and fork we're fixing, reset the
+ * incore fork, then recreate the btree.
+ */
+struct xrep_bmap {
+	/* List of new bmap records. */
+	struct xfs_slab		*bmap_records;
+	struct xfs_slab_cursor	*bmap_cursor;
+
+	/* New fork. */
+	struct bulkload		new_fork_info;
+	struct xfs_btree_bload	bmap_bload;
+
+	struct repair_ctx	*sc;
+
+	/* How many blocks did we find allocated to this file? */
+	xfs_rfsblock_t		nblocks;
+
+	/* How many bmbt blocks did we find for this fork? */
+	xfs_rfsblock_t		old_bmbt_block_count;
+
+	/* Which fork are we fixing? */
+	int			whichfork;
+};
+
+/* Remember this reverse-mapping as a series of bmap records. */
+STATIC int
+xrep_bmap_from_rmap(
+	struct xrep_bmap	*rb,
+	xfs_fileoff_t		startoff,
+	xfs_fsblock_t		startblock,
+	xfs_filblks_t		blockcount,
+	bool			unwritten)
+{
+	struct xfs_bmbt_rec	rbe;
+	struct xfs_bmbt_irec	irec;
+	int			error = 0;
+
+	irec.br_startoff = startoff;
+	irec.br_startblock = startblock;
+	irec.br_state = unwritten ? XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
+
+	do {
+		xfs_failaddr_t	fa;
+
+		irec.br_blockcount = min_t(xfs_filblks_t, blockcount,
+				XFS_MAX_BMBT_EXTLEN);
+
+		fa = libxfs_bmap_validate_extent(rb->sc->ip, rb->whichfork,
+				&irec);
+		if (fa)
+			return -EFSCORRUPTED;
+
+		libxfs_bmbt_disk_set_all(&rbe, &irec);
+
+		error = slab_add(rb->bmap_records, &rbe);
+		if (error)
+			return error;
+
+		irec.br_startblock += irec.br_blockcount;
+		irec.br_startoff += irec.br_blockcount;
+		blockcount -= irec.br_blockcount;
+	} while (blockcount > 0);
+
+	return 0;
+}
+
+/* Check for any obvious errors or conflicts in the file mapping. */
+STATIC int
+xrep_bmap_check_fork_rmap(
+	struct xrep_bmap		*rb,
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec)
+{
+	struct repair_ctx		*sc = rb->sc;
+
+	/*
+	 * Data extents for rt files are never stored on the data device, but
+	 * everything else (xattrs, bmbt blocks) can be.
+	 */
+	if (XFS_IS_REALTIME_INODE(sc->ip) &&
+	    !(rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK)))
+		return EFSCORRUPTED;
+
+	/* Check that this is within the AG. */
+	if (!xfs_verify_agbext(cur->bc_ag.pag, rec->rm_startblock,
+				rec->rm_blockcount))
+		return EFSCORRUPTED;
+
+	/* No contradictory flags. */
+	if ((rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK)) &&
+	    (rec->rm_flags & XFS_RMAP_UNWRITTEN))
+		return EFSCORRUPTED;
+
+	/* Check the file offset range. */
+	if (!(rec->rm_flags & XFS_RMAP_BMBT_BLOCK) &&
+	    !xfs_verify_fileext(sc->mp, rec->rm_offset, rec->rm_blockcount))
+		return EFSCORRUPTED;
+
+	return 0;
+}
+
+/* Record extents that belong to this inode's fork. */
+STATIC int
+xrep_bmap_walk_rmap(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct xrep_bmap		*rb = priv;
+	struct xfs_mount		*mp = cur->bc_mp;
+	xfs_fsblock_t			fsbno;
+	int				error;
+
+	/* Skip extents which are not owned by this inode and fork. */
+	if (rec->rm_owner != rb->sc->ip->i_ino)
+		return 0;
+
+	error = xrep_bmap_check_fork_rmap(rb, cur, rec);
+	if (error)
+		return error;
+
+	/*
+	 * Record all blocks allocated to this file even if the extent isn't
+	 * for the fork we're rebuilding so that we can reset di_nblocks later.
+	 */
+	rb->nblocks += rec->rm_blockcount;
+
+	/* If this rmap isn't for the fork we want, we're done. */
+	if (rb->whichfork == XFS_DATA_FORK &&
+	    (rec->rm_flags & XFS_RMAP_ATTR_FORK))
+		return 0;
+	if (rb->whichfork == XFS_ATTR_FORK &&
+	    !(rec->rm_flags & XFS_RMAP_ATTR_FORK))
+		return 0;
+
+	fsbno = XFS_AGB_TO_FSB(mp, cur->bc_ag.pag->pag_agno,
+			rec->rm_startblock);
+
+	if (rec->rm_flags & XFS_RMAP_BMBT_BLOCK) {
+		rb->old_bmbt_block_count += rec->rm_blockcount;
+		return 0;
+	}
+
+	return xrep_bmap_from_rmap(rb, rec->rm_offset, fsbno,
+			rec->rm_blockcount,
+			rec->rm_flags & XFS_RMAP_UNWRITTEN);
+}
+
+/* Compare two bmap extents. */
+static int
+xrep_bmap_extent_cmp(
+	const void			*a,
+	const void			*b)
+{
+	xfs_fileoff_t			ao;
+	xfs_fileoff_t			bo;
+
+	ao = libxfs_bmbt_disk_get_startoff((struct xfs_bmbt_rec *)a);
+	bo = libxfs_bmbt_disk_get_startoff((struct xfs_bmbt_rec *)b);
+
+	if (ao > bo)
+		return 1;
+	else if (ao < bo)
+		return -1;
+	return 0;
+}
+
+/* Scan one AG for reverse mappings that we can turn into extent maps. */
+STATIC int
+xrep_bmap_scan_ag(
+	struct xrep_bmap	*rb,
+	struct xfs_perag	*pag)
+{
+	struct repair_ctx	*sc = rb->sc;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_buf		*agf_bp = NULL;
+	struct xfs_btree_cur	*cur;
+	int			error;
+
+	error = -libxfs_alloc_read_agf(pag, sc->tp, 0, &agf_bp);
+	if (error)
+		return error;
+	if (!agf_bp)
+		return ENOMEM;
+	cur = libxfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, pag);
+	error = -libxfs_rmap_query_all(cur, xrep_bmap_walk_rmap, rb);
+	libxfs_btree_del_cursor(cur, error);
+	libxfs_trans_brelse(sc->tp, agf_bp);
+	return error;
+}
+
+/*
+ * Collect block mappings for this fork of this inode and decide if we have
+ * enough space to rebuild.  Caller is responsible for cleaning up the list if
+ * anything goes wrong.
+ */
+STATIC int
+xrep_bmap_find_mappings(
+	struct xrep_bmap	*rb)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+	int			error;
+
+	/* Iterate the rmaps for extents. */
+	for_each_perag(rb->sc->mp, agno, pag) {
+		error = xrep_bmap_scan_ag(rb, pag);
+		if (error) {
+			libxfs_perag_put(pag);
+			return error;
+		}
+	}
+
+	return 0;
+}
+
+/* Retrieve bmap data for bulk load. */
+STATIC int
+xrep_bmap_get_records(
+	struct xfs_btree_cur	*cur,
+	unsigned int		idx,
+	struct xfs_btree_block	*block,
+	unsigned int		nr_wanted,
+	void			*priv)
+{
+	struct xfs_bmbt_rec	*rec;
+	struct xfs_bmbt_irec	*irec = &cur->bc_rec.b;
+	struct xrep_bmap	*rb = priv;
+	union xfs_btree_rec	*block_rec;
+	unsigned int		loaded;
+
+	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
+		rec = pop_slab_cursor(rb->bmap_cursor);
+		libxfs_bmbt_disk_get_all(rec, irec);
+
+		block_rec = libxfs_btree_rec_addr(cur, idx, block);
+		cur->bc_ops->init_rec_from_cur(cur, block_rec);
+	}
+
+	return loaded;
+}
+
+/* Feed one of the new btree blocks to the bulk loader. */
+STATIC int
+xrep_bmap_claim_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	void			*priv)
+{
+	struct xrep_bmap        *rb = priv;
+
+	return bulkload_claim_block(cur, &rb->new_fork_info, ptr);
+}
+
+/* Figure out how much space we need to create the incore btree root block. */
+STATIC size_t
+xrep_bmap_iroot_size(
+	struct xfs_btree_cur	*cur,
+	unsigned int		level,
+	unsigned int		nr_this_level,
+	void			*priv)
+{
+	ASSERT(level > 0);
+
+	return XFS_BMAP_BROOT_SPACE_CALC(cur->bc_mp, nr_this_level);
+}
+
+/* Update the inode counters. */
+STATIC int
+xrep_bmap_reset_counters(
+	struct xrep_bmap	*rb)
+{
+	struct repair_ctx	*sc = rb->sc;
+	struct xbtree_ifakeroot	*ifake = &rb->new_fork_info.ifake;
+	int64_t			delta;
+
+	/*
+	 * Update the inode block counts to reflect the extents we found in the
+	 * rmapbt.
+	 */
+	delta = ifake->if_blocks - rb->old_bmbt_block_count;
+	sc->ip->i_nblocks = rb->nblocks + delta;
+	libxfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
+
+	/* Quotas don't exist so we're done. */
+	return 0;
+}
+
+/*
+ * Ensure that the inode being repaired is ready to handle a certain number of
+ * extents, or return EFSCORRUPTED.  Caller must hold the ILOCK of the inode
+ * being repaired and have joined it to the scrub transaction.
+ */
+static int
+xrep_ino_ensure_extent_count(
+	struct repair_ctx	*sc,
+	int			whichfork,
+	xfs_extnum_t		nextents)
+{
+	xfs_extnum_t		max_extents;
+	bool			large_extcount;
+
+	large_extcount = xfs_inode_has_large_extent_counts(sc->ip);
+	max_extents = xfs_iext_max_nextents(large_extcount, whichfork);
+	if (nextents <= max_extents)
+		return 0;
+	if (large_extcount)
+		return EFSCORRUPTED;
+	if (!xfs_has_large_extent_counts(sc->mp))
+		return EFSCORRUPTED;
+
+	max_extents = xfs_iext_max_nextents(true, whichfork);
+	if (nextents > max_extents)
+		return EFSCORRUPTED;
+
+	sc->ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
+	libxfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
+	return 0;
+}
+
+/*
+ * Create a new iext tree and load it with block mappings.  If the inode is
+ * in extents format, that's all we need to do to commit the new mappings.
+ * If it is in btree format, this takes care of preloading the incore tree.
+ */
+STATIC int
+xrep_bmap_extents_load(
+	struct xrep_bmap	*rb,
+	struct xfs_btree_cur	*bmap_cur,
+	uint64_t		nextents)
+{
+	struct xfs_iext_cursor	icur;
+	struct xbtree_ifakeroot	*ifake = &rb->new_fork_info.ifake;
+	struct xfs_ifork	*ifp = ifake->if_fork;
+	unsigned int		i;
+	int			error;
+
+	ASSERT(ifp->if_bytes == 0);
+
+	error = init_slab_cursor(rb->bmap_records, xrep_bmap_extent_cmp,
+			&rb->bmap_cursor);
+	if (error)
+		return error;
+
+	/* Add all the mappings to the incore extent tree. */
+	libxfs_iext_first(ifp, &icur);
+	for (i = 0; i < nextents; i++) {
+		struct xfs_bmbt_rec	*rec;
+
+		rec = pop_slab_cursor(rb->bmap_cursor);
+		libxfs_bmbt_disk_get_all(rec, &bmap_cur->bc_rec.b);
+		libxfs_iext_insert_raw(ifp, &icur, &bmap_cur->bc_rec.b);
+		ifp->if_nextents++;
+		libxfs_iext_next(ifp, &icur);
+	}
+	free_slab_cursor(&rb->bmap_cursor);
+
+	return xrep_ino_ensure_extent_count(rb->sc, rb->whichfork,
+			ifp->if_nextents);
+}
+
+/*
+ * Reserve new btree blocks, bulk load the bmap records into the ondisk btree,
+ * and load the incore extent tree.
+ */
+STATIC int
+xrep_bmap_btree_load(
+	struct xrep_bmap	*rb,
+	struct xfs_btree_cur	*bmap_cur,
+	uint64_t		nextents)
+{
+	struct repair_ctx	*sc = rb->sc;
+	int			error;
+
+	rb->bmap_bload.get_records = xrep_bmap_get_records;
+	rb->bmap_bload.claim_block = xrep_bmap_claim_block;
+	rb->bmap_bload.iroot_size = xrep_bmap_iroot_size;
+	rb->bmap_bload.max_dirty = XFS_B_TO_FSBT(sc->mp, 256U << 10); /* 256K */
+	bulkload_estimate_inode_slack(sc->mp, &rb->bmap_bload);
+
+	/* Compute how many blocks we'll need. */
+	error = -libxfs_btree_bload_compute_geometry(bmap_cur, &rb->bmap_bload,
+			nextents);
+	if (error)
+		return error;
+
+	/*
+	 * Guess how many blocks we're going to need to rebuild an entire bmap
+	 * from the number of extents we found, and pump up our transaction to
+	 * have sufficient block reservation.
+	 */
+	error = -libxfs_trans_reserve_more(sc->tp, rb->bmap_bload.nr_blocks, 0);
+	if (error)
+		return error;
+
+	/* Reserve the space we'll need for the new btree. */
+	error = bulkload_alloc_blocks(&rb->new_fork_info,
+			rb->bmap_bload.nr_blocks);
+	if (error)
+		return error;
+
+	/* Add all observed bmap records. */
+	error = init_slab_cursor(rb->bmap_records, xrep_bmap_extent_cmp,
+			&rb->bmap_cursor);
+	if (error)
+		return error;
+	error = -libxfs_btree_bload(bmap_cur, &rb->bmap_bload, rb);
+	free_slab_cursor(&rb->bmap_cursor);
+	if (error)
+	       return error;
+
+	/*
+	 * Load the new bmap records into the new incore extent tree to
+	 * preserve delalloc reservations for regular files.  The directory
+	 * code loads the extent tree during xfs_dir_open and assumes
+	 * thereafter that it remains loaded, so we must not violate that
+	 * assumption.
+	 */
+	return xrep_bmap_extents_load(rb, bmap_cur, nextents);
+}
+
+/*
+ * Use the collected bmap information to stage a new bmap fork.  If this is
+ * successful we'll return with the new fork information logged to the repair
+ * transaction but not yet committed.
+ */
+STATIC int
+xrep_bmap_build_new_fork(
+	struct xrep_bmap	*rb)
+{
+	struct xfs_owner_info	oinfo;
+	struct repair_ctx	*sc = rb->sc;
+	struct xfs_btree_cur	*bmap_cur;
+	struct xbtree_ifakeroot	*ifake = &rb->new_fork_info.ifake;
+	uint64_t		nextents;
+	int			error;
+
+	/*
+	 * Sort the bmap extents by startblock to avoid btree splits when we
+	 * rebuild the bmbt btree.
+	 */
+	qsort_slab(rb->bmap_records, xrep_bmap_extent_cmp);
+
+	/*
+	 * Prepare to construct the new fork by initializing the new btree
+	 * structure and creating a fake ifork in the ifakeroot structure.
+	 */
+	libxfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, rb->whichfork);
+	bulkload_init_inode(&rb->new_fork_info, sc, rb->whichfork, &oinfo);
+	bmap_cur = libxfs_bmbt_stage_cursor(sc->mp, sc->ip, ifake);
+
+	/*
+	 * Figure out the size and format of the new fork, then fill it with
+	 * all the bmap records we've found.  Join the inode to the transaction
+	 * so that we can roll the transaction while holding the inode locked.
+	 */
+	libxfs_trans_ijoin(sc->tp, sc->ip, 0);
+	nextents = slab_count(rb->bmap_records);
+	if (nextents <= XFS_IFORK_MAXEXT(sc->ip, rb->whichfork)) {
+		ifake->if_fork->if_format = XFS_DINODE_FMT_EXTENTS;
+		error = xrep_bmap_extents_load(rb, bmap_cur, nextents);
+	} else {
+		ifake->if_fork->if_format = XFS_DINODE_FMT_BTREE;
+		error = xrep_bmap_btree_load(rb, bmap_cur, nextents);
+	}
+	if (error)
+		goto err_cur;
+
+	/*
+	 * Install the new fork in the inode.  After this point the old mapping
+	 * data are no longer accessible and the new tree is live.  We delete
+	 * the cursor immediately after committing the staged root because the
+	 * staged fork might be in extents format.
+	 */
+	libxfs_bmbt_commit_staged_btree(bmap_cur, sc->tp, rb->whichfork);
+	libxfs_btree_del_cursor(bmap_cur, 0);
+
+	/* Reset the inode counters now that we've changed the fork. */
+	error = xrep_bmap_reset_counters(rb);
+	if (error)
+		goto err_newbt;
+
+	/* Dispose of any unused blocks and the accounting infomation. */
+	bulkload_destroy(&rb->new_fork_info, error);
+
+	return -libxfs_trans_roll_inode(&sc->tp, sc->ip);
+err_cur:
+	if (bmap_cur)
+		libxfs_btree_del_cursor(bmap_cur, error);
+err_newbt:
+	bulkload_destroy(&rb->new_fork_info, error);
+	return error;
+}
+
+/* Check for garbage inputs.  Returns ECANCELED if there's nothing to do. */
+STATIC int
+xrep_bmap_check_inputs(
+	struct repair_ctx	*sc,
+	int			whichfork)
+{
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(sc->ip, whichfork);
+
+	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
+
+	if (!xfs_has_rmapbt(sc->mp))
+		return EOPNOTSUPP;
+
+	/* No fork means nothing to rebuild. */
+	if (!ifp)
+		return ECANCELED;
+
+	/*
+	 * We only know how to repair extent mappings, which is to say that we
+	 * only support extents and btree fork format.  Repairs to a local
+	 * format fork require a higher level repair function, so we do not
+	 * have any work to do here.
+	 */
+	switch (ifp->if_format) {
+	case XFS_DINODE_FMT_DEV:
+	case XFS_DINODE_FMT_LOCAL:
+	case XFS_DINODE_FMT_UUID:
+		return ECANCELED;
+	case XFS_DINODE_FMT_EXTENTS:
+	case XFS_DINODE_FMT_BTREE:
+		break;
+	default:
+		return EFSCORRUPTED;
+	}
+
+	if (whichfork == XFS_ATTR_FORK)
+		return 0;
+
+	/* Only files, symlinks, and directories get to have data forks. */
+	switch (VFS_I(sc->ip)->i_mode & S_IFMT) {
+	case S_IFREG:
+	case S_IFDIR:
+	case S_IFLNK:
+		/* ok */
+		break;
+	default:
+		return EINVAL;
+	}
+
+	/* Don't know how to rebuild realtime data forks. */
+	if (XFS_IS_REALTIME_INODE(sc->ip))
+		return EOPNOTSUPP;
+
+	return 0;
+}
+
+/* Repair an inode fork. */
+STATIC int
+xrep_bmap(
+	struct repair_ctx	*sc,
+	int			whichfork)
+{
+	struct xrep_bmap	*rb;
+	int			error = 0;
+
+	error = xrep_bmap_check_inputs(sc, whichfork);
+	if (error == ECANCELED)
+		return 0;
+	if (error)
+		return error;
+
+	rb = kmem_zalloc(sizeof(struct xrep_bmap), KM_NOFS | KM_MAYFAIL);
+	if (!rb)
+		return ENOMEM;
+	rb->sc = sc;
+	rb->whichfork = whichfork;
+
+	/* Set up some storage */
+	error = init_slab(&rb->bmap_records, sizeof(struct xfs_bmbt_rec));
+	if (error)
+		goto out_rb;
+
+	/* Collect all reverse mappings for this fork's extents. */
+	error = xrep_bmap_find_mappings(rb);
+	if (error)
+		goto out_bitmap;
+
+	/* Rebuild the bmap information. */
+	error = xrep_bmap_build_new_fork(rb);
+
+	/*
+	 * We don't need to free the old bmbt blocks because we're rebuilding
+	 * all the space metadata later.
+	 */
+
+out_bitmap:
+	free_slab(&rb->bmap_records);
+out_rb:
+	kmem_free(rb);
+	return error;
+}
+
+/* Rebuild some inode's bmap. */
+int
+rebuild_bmap(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	int			whichfork,
+	unsigned long		nr_extents,
+	struct xfs_buf		**ino_bpp,
+	struct xfs_dinode	**dinop,
+	int			*dirty)
+{
+	struct repair_ctx	sc = {
+		.mp		= mp,
+	};
+	const struct xfs_buf_ops *bp_ops;
+	unsigned long		boffset;
+	unsigned long long	resblks;
+	xfs_daddr_t		bp_bn;
+	int			bp_length;
+	int			error, err2;
+
+	bp_bn = xfs_buf_daddr(*ino_bpp);
+	bp_length = (*ino_bpp)->b_length;
+	bp_ops = (*ino_bpp)->b_ops;
+	boffset = (char *)(*dinop) - (char *)(*ino_bpp)->b_addr;
+
+	/*
+	 * Bail out if the inode didn't think it had extents.  Otherwise, zap
+	 * it back to a zero-extents fork so that we can rebuild it.
+	 */
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		if ((*dinop)->di_nextents == 0)
+			return 0;
+		(*dinop)->di_format = XFS_DINODE_FMT_EXTENTS;
+		(*dinop)->di_nextents = 0;
+		libxfs_dinode_calc_crc(mp, *dinop);
+		*dirty = 1;
+		break;
+	case XFS_ATTR_FORK:
+		if ((*dinop)->di_anextents == 0)
+			return 0;
+		(*dinop)->di_aformat = XFS_DINODE_FMT_EXTENTS;
+		(*dinop)->di_anextents = 0;
+		libxfs_dinode_calc_crc(mp, *dinop);
+		*dirty = 1;
+		break;
+	default:
+		return EINVAL;
+	}
+
+	resblks = libxfs_bmbt_calc_size(mp, nr_extents);
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks, 0,
+			0, &sc.tp);
+	if (error)
+		return error;
+
+	/*
+	 * Repair magic: the caller passed us the inode cluster buffer for the
+	 * inode.  The _iget call grabs the buffer to load the incore inode, so
+	 * the buffer must be attached to the transaction to avoid recursing
+	 * the buffer lock.
+	 *
+	 * Unfortunately, the _iget call drops the buffer once the inode is
+	 * loaded, so if we've made any changes we have to log the buffer, hold
+	 * it, and roll the transaction.  This persists the caller's changes
+	 * and maintains our ownership of the cluster buffer.
+	 */
+	libxfs_trans_bjoin(sc.tp, *ino_bpp);
+	if (*dirty) {
+		unsigned int	end = BBTOB((*ino_bpp)->b_length) - 1;
+
+		libxfs_trans_log_buf(sc.tp, *ino_bpp, 0, end);
+		*dirty = 0;
+
+		libxfs_trans_bhold(sc.tp, *ino_bpp);
+		error = -libxfs_trans_roll(&sc.tp);
+		libxfs_trans_bjoin(sc.tp, *ino_bpp);
+		if (error)
+			goto out_cancel;
+	}
+
+	/* Grab the inode and fix the bmbt. */
+	error = -libxfs_iget(mp, sc.tp, ino, 0, &sc.ip);
+	if (error)
+		goto out_cancel;
+	error = xrep_bmap(&sc, whichfork);
+	if (error)
+		libxfs_trans_cancel(sc.tp);
+	else
+		error = -libxfs_trans_commit(sc.tp);
+
+	/*
+	 * Rebuilding the inode fork rolled the transaction, so we need to
+	 * re-grab the inode cluster buffer and dinode pointer for the caller.
+	 */
+	err2 = -libxfs_imap_to_bp(mp, NULL, &sc.ip->i_imap, ino_bpp);
+	if (err2)
+		do_error(
+ _("Unable to re-grab inode cluster buffer after failed repair of inode %llu, error %d.\n"),
+				(unsigned long long)ino, err2);
+	*dinop = xfs_buf_offset(*ino_bpp, sc.ip->i_imap.im_boffset);
+	libxfs_irele(sc.ip);
+
+	return error;
+
+out_cancel:
+	libxfs_trans_cancel(sc.tp);
+
+	/*
+	 * Try to regrab the old buffer so we have something to return to the
+	 * caller.
+	 */
+	err2 = -libxfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, bp_bn,
+			bp_length, 0, ino_bpp, bp_ops);
+	if (err2)
+		do_error(
+ _("Unable to re-grab inode cluster buffer after failed repair of inode %llu, error %d.\n"),
+				(unsigned long long)ino, err2);
+	*dinop = xfs_buf_offset(*ino_bpp, boffset);
+	return error;
+}
diff --git a/repair/bmap_repair.h b/repair/bmap_repair.h
new file mode 100644
index 00000000000..0f3e016c948
--- /dev/null
+++ b/repair/bmap_repair.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef REBUILD_H_
+#define REBUILD_H_
+
+int rebuild_bmap(struct xfs_mount *mp, xfs_ino_t ino, int whichfork,
+		 unsigned long nr_extents, struct xfs_buf **ino_bpp,
+		 struct xfs_dinode **dinop, int *dirty);
+
+#endif /* REBUILD_H_ */
diff --git a/repair/bulkload.c b/repair/bulkload.c
index 8dd0a0c3908..0a0a60fde44 100644
--- a/repair/bulkload.c
+++ b/repair/bulkload.c
@@ -14,14 +14,30 @@ void
 bulkload_init_ag(
 	struct bulkload			*bkl,
 	struct repair_ctx		*sc,
-	const struct xfs_owner_info	*oinfo)
+	const struct xfs_owner_info	*oinfo,
+	xfs_fsblock_t			alloc_hint)
 {
 	memset(bkl, 0, sizeof(struct bulkload));
 	bkl->sc = sc;
 	bkl->oinfo = *oinfo; /* structure copy */
+	bkl->alloc_hint = alloc_hint;
 	INIT_LIST_HEAD(&bkl->resv_list);
 }
 
+/* Initialize accounting resources for staging a new inode fork btree. */
+void
+bulkload_init_inode(
+	struct bulkload			*bkl,
+	struct repair_ctx		*sc,
+	int				whichfork,
+	const struct xfs_owner_info	*oinfo)
+{
+	bulkload_init_ag(bkl, sc, oinfo, XFS_INO_TO_FSB(sc->mp, sc->ip->i_ino));
+	bkl->ifake.if_fork = kmem_cache_zalloc(xfs_ifork_cache, 0);
+	bkl->ifake.if_fork_size = xfs_inode_fork_size(sc->ip, whichfork);
+	bkl->ifake.if_whichfork = whichfork;
+}
+
 /* Designate specific blocks to be used to build our new btree. */
 int
 bulkload_add_blocks(
@@ -30,6 +46,7 @@ bulkload_add_blocks(
 	xfs_extlen_t		len)
 {
 	struct bulkload_resv	*resv;
+	struct xfs_mount	*mp = bkl->sc->mp;
 
 	resv = kmem_alloc(sizeof(struct bulkload_resv), KM_MAYFAIL);
 	if (!resv)
@@ -39,24 +56,140 @@ bulkload_add_blocks(
 	resv->fsbno = fsbno;
 	resv->len = len;
 	resv->used = 0;
+	resv->pag = libxfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, fsbno));
+
 	list_add_tail(&resv->list, &bkl->resv_list);
 	bkl->nr_reserved += len;
 
 	return 0;
 }
 
+/* Reserve disk space for our new btree. */
+int
+bulkload_alloc_blocks(
+	struct bulkload		*bkl,
+	uint64_t		nr_blocks)
+{
+	struct repair_ctx	*sc = bkl->sc;
+	xfs_alloctype_t		type;
+	int			error = 0;
+
+	type = sc->ip ? XFS_ALLOCTYPE_START_BNO : XFS_ALLOCTYPE_NEAR_BNO;
+
+	while (nr_blocks > 0) {
+		struct xfs_alloc_arg	args = {
+			.tp		= sc->tp,
+			.mp		= sc->mp,
+			.type		= type,
+			.fsbno		= bkl->alloc_hint,
+			.oinfo		= bkl->oinfo,
+			.minlen		= 1,
+			.maxlen		= nr_blocks,
+			.prod		= 1,
+			.resv		= XFS_AG_RESV_NONE,
+		};
+
+		error = -libxfs_alloc_vextent(&args);
+		if (error)
+			return error;
+		if (args.fsbno == NULLFSBLOCK)
+			return ENOSPC;
+
+		error = bulkload_add_blocks(bkl, args.fsbno, args.len);
+		if (error)
+			return error;
+
+		nr_blocks -= args.len;
+
+		error = -libxfs_trans_roll_inode(&sc->tp, sc->ip);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/*
+ * Release blocks that were reserved for a btree repair.  If the repair
+ * succeeded then we log deferred frees for unused blocks.  Otherwise, we try
+ * to free the extents immediately to roll the filesystem back to where it was
+ * before we started.
+ */
+static inline int
+bulkload_destroy_reservation(
+	struct bulkload		*bkl,
+	struct bulkload_resv	*resv,
+	bool			cancel_repair)
+{
+	struct repair_ctx	*sc = bkl->sc;
+
+	if (cancel_repair) {
+		int		error;
+
+		/* Free the extent then roll the transaction. */
+		error = -libxfs_free_extent(sc->tp, resv->pag,
+				XFS_FSB_TO_AGBNO(sc->mp, resv->fsbno),
+				resv->len, &bkl->oinfo, XFS_AG_RESV_NONE);
+		if (error)
+			return error;
+
+		return -libxfs_trans_roll_inode(&sc->tp, sc->ip);
+	}
+
+	/*
+	 * Use the deferred freeing mechanism to schedule for deletion any
+	 * blocks we didn't use to rebuild the tree.  This enables us to log
+	 * them all in the same transaction as the root change.
+	 */
+	resv->fsbno += resv->used;
+	resv->len -= resv->used;
+	resv->used = 0;
+
+	if (resv->len == 0)
+		return 0;
+
+	__xfs_free_extent_later(sc->tp, resv->fsbno, resv->len, &bkl->oinfo,
+			true);
+
+	return 0;
+}
+
 /* Free all the accounting info and disk space we reserved for a new btree. */
 void
 bulkload_destroy(
 	struct bulkload		*bkl,
 	int			error)
 {
+	struct repair_ctx	*sc = bkl->sc;
 	struct bulkload_resv	*resv, *n;
+	int			err2;
 
+	list_for_each_entry_safe(resv, n, &bkl->resv_list, list) {
+		err2 = bulkload_destroy_reservation(bkl, resv, error != 0);
+		if (err2)
+			goto junkit;
+
+		list_del(&resv->list);
+		libxfs_perag_put(resv->pag);
+		kmem_free(resv);
+	}
+
+junkit:
+	/*
+	 * If we still have reservations attached to @newbt, cleanup must have
+	 * failed and the filesystem is about to go down.  Clean up the incore
+	 * reservations.
+	 */
 	list_for_each_entry_safe(resv, n, &bkl->resv_list, list) {
 		list_del(&resv->list);
+		libxfs_perag_put(resv->pag);
 		kmem_free(resv);
 	}
+
+	if (sc->ip) {
+		kmem_cache_free(xfs_ifork_cache, bkl->ifake.if_fork);
+		bkl->ifake.if_fork = NULL;
+	}
 }
 
 /* Feed one of the reserved btree blocks to the bulk loader. */
@@ -138,3 +271,43 @@ bulkload_estimate_ag_slack(
 	if (bload->node_slack < 0)
 		bload->node_slack = 2;
 }
+
+/*
+ * Estimate proper slack values for a btree that's being reloaded.
+ *
+ * Under most circumstances, we'll take whatever default loading value the
+ * btree bulk loading code calculates for us.  However, there are some
+ * exceptions to this rule:
+ *
+ * (1) If someone turned one of the debug knobs.
+ * (2) The FS has less than ~9% space free.
+ *
+ * Note that we actually use 3/32 for the comparison to avoid division.
+ */
+void
+bulkload_estimate_inode_slack(
+	struct xfs_mount	*mp,
+	struct xfs_btree_bload	*bload)
+{
+	/*
+	 * The global values are set to -1 (i.e. take the bload defaults)
+	 * unless someone has set them otherwise, so we just pull the values
+	 * here.
+	 */
+	bload->leaf_slack = bload_leaf_slack;
+	bload->node_slack = bload_node_slack;
+
+	/* No further changes if there's more than 3/32ths space left. */
+	if (mp->m_sb.sb_fdblocks >= ((mp->m_sb.sb_dblocks * 3) >> 5))
+		return;
+
+	/*
+	 * We're low on space; load the btrees as tightly as possible.  Leave
+	 * a couple of open slots in each btree block so that we don't end up
+	 * splitting the btrees like crazy right after mount.
+	 */
+	if (bload->leaf_slack < 0)
+		bload->leaf_slack = 2;
+	if (bload->node_slack < 0)
+		bload->node_slack = 2;
+}
diff --git a/repair/bulkload.h b/repair/bulkload.h
index a84e99b8c89..b1c0925890b 100644
--- a/repair/bulkload.h
+++ b/repair/bulkload.h
@@ -11,12 +11,16 @@ extern int bload_node_slack;
 
 struct repair_ctx {
 	struct xfs_mount	*mp;
+	struct xfs_inode	*ip;
+	struct xfs_trans	*tp;
 };
 
 struct bulkload_resv {
 	/* Link to list of extents that we've reserved. */
 	struct list_head	list;
 
+	struct xfs_perag	*pag;
+
 	/* FSB of the block we reserved. */
 	xfs_fsblock_t		fsbno;
 
@@ -34,7 +38,10 @@ struct bulkload {
 	struct list_head	resv_list;
 
 	/* Fake root for new btree. */
-	struct xbtree_afakeroot	afake;
+	union {
+		struct xbtree_afakeroot	afake;
+		struct xbtree_ifakeroot	ifake;
+	};
 
 	/* rmap owner of these blocks */
 	struct xfs_owner_info	oinfo;
@@ -42,6 +49,9 @@ struct bulkload {
 	/* The last reservation we allocated from. */
 	struct bulkload_resv	*last_resv;
 
+	/* Hint as to where we should allocate blocks. */
+	xfs_fsblock_t		alloc_hint;
+
 	/* Number of blocks reserved via resv_list. */
 	unsigned int		nr_reserved;
 };
@@ -50,13 +60,18 @@ struct bulkload {
 	list_for_each_entry_safe((resv), (n), &(bkl)->resv_list, list)
 
 void bulkload_init_ag(struct bulkload *bkl, struct repair_ctx *sc,
-		const struct xfs_owner_info *oinfo);
+		const struct xfs_owner_info *oinfo, xfs_fsblock_t alloc_hint);
+void bulkload_init_inode(struct bulkload *bkl, struct repair_ctx *sc,
+		int whichfork, const struct xfs_owner_info *oinfo);
 int bulkload_add_blocks(struct bulkload *bkl, xfs_fsblock_t fsbno,
 		xfs_extlen_t len);
+int bulkload_alloc_blocks(struct bulkload *bkl, uint64_t nr_blocks);
 void bulkload_destroy(struct bulkload *bkl, int error);
 int bulkload_claim_block(struct xfs_btree_cur *cur, struct bulkload *bkl,
 		union xfs_btree_ptr *ptr);
 void bulkload_estimate_ag_slack(struct repair_ctx *sc,
 		struct xfs_btree_bload *bload, unsigned int free);
+void bulkload_estimate_inode_slack(struct xfs_mount *mp,
+		struct xfs_btree_bload *bload);
 
 #endif /* __XFS_REPAIR_BULKLOAD_H__ */
diff --git a/repair/dinode.c b/repair/dinode.c
index cea3c1ee5fe..5e664eab7ea 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -20,6 +20,7 @@
 #include "threads.h"
 #include "slab.h"
 #include "rmap.h"
+#include "bmap_repair.h"
 
 /*
  * gettext lookups for translations of strings use mutexes internally to
@@ -1905,7 +1906,9 @@ process_inode_data_fork(
 	xfs_ino_t		lino = XFS_AGINO_TO_INO(mp, agno, ino);
 	int			err = 0;
 	xfs_extnum_t		nex, max_nex;
+	int			try_rebuild = -1; /* don't know yet */
 
+retry:
 	/*
 	 * extent count on disk is only valid for positive values. The kernel
 	 * uses negative values in memory. hence if we see negative numbers
@@ -1934,11 +1937,15 @@ process_inode_data_fork(
 		*totblocks = 0;
 		break;
 	case XFS_DINODE_FMT_EXTENTS:
+		if (!rmapbt_suspect && try_rebuild == -1)
+			try_rebuild = 1;
 		err = process_exinode(mp, agno, ino, dino, type, dirty,
 			totblocks, nextents, dblkmap, XFS_DATA_FORK,
 			check_dups);
 		break;
 	case XFS_DINODE_FMT_BTREE:
+		if (!rmapbt_suspect && try_rebuild == -1)
+			try_rebuild = 1;
 		err = process_btinode(mp, agno, ino, dino, type, dirty,
 			totblocks, nextents, dblkmap, XFS_DATA_FORK,
 			check_dups);
@@ -1954,8 +1961,28 @@ process_inode_data_fork(
 	if (err)  {
 		do_warn(_("bad data fork in inode %" PRIu64 "\n"), lino);
 		if (!no_modify)  {
+			if (try_rebuild == 1) {
+				do_warn(
+_("rebuilding inode %"PRIu64" data fork\n"),
+					lino);
+				try_rebuild = 0;
+				err = rebuild_bmap(mp, lino, XFS_DATA_FORK,
+						be32_to_cpu(dino->di_nextents),
+						ino_bpp, dinop, dirty);
+				dino = *dinop;
+				if (!err)
+					goto retry;
+				do_warn(
+_("inode %"PRIu64" data fork rebuild failed, error %d, clearing\n"),
+					lino, err);
+			}
 			clear_dinode(mp, dino, lino);
 			*dirty += 1;
+			ASSERT(*dirty > 0);
+		} else if (try_rebuild == 1) {
+			do_warn(
+_("would have tried to rebuild inode %"PRIu64" data fork\n"),
+					lino);
 		}
 		return 1;
 	}
@@ -2021,7 +2048,9 @@ process_inode_attr_fork(
 	struct blkmap		*ablkmap = NULL;
 	int			repair = 0;
 	int			err;
+	int			try_rebuild = -1; /* don't know yet */
 
+retry:
 	if (!dino->di_forkoff) {
 		*anextents = 0;
 		if (dino->di_aformat != XFS_DINODE_FMT_EXTENTS) {
@@ -2048,6 +2077,8 @@ process_inode_attr_fork(
 		err = process_lclinode(mp, agno, ino, dino, XFS_ATTR_FORK);
 		break;
 	case XFS_DINODE_FMT_EXTENTS:
+		if (!rmapbt_suspect && try_rebuild == -1)
+			try_rebuild = 1;
 		ablkmap = blkmap_alloc(*anextents, XFS_ATTR_FORK);
 		*anextents = 0;
 		err = process_exinode(mp, agno, ino, dino, type, dirty,
@@ -2055,6 +2086,8 @@ process_inode_attr_fork(
 				XFS_ATTR_FORK, check_dups);
 		break;
 	case XFS_DINODE_FMT_BTREE:
+		if (!rmapbt_suspect && try_rebuild == -1)
+			try_rebuild = 1;
 		ablkmap = blkmap_alloc(*anextents, XFS_ATTR_FORK);
 		*anextents = 0;
 		err = process_btinode(mp, agno, ino, dino, type, dirty,
@@ -2080,11 +2113,30 @@ process_inode_attr_fork(
 		do_warn(_("bad attribute fork in inode %" PRIu64 "\n"), lino);
 
 		if (!no_modify)  {
+			if (try_rebuild == 1) {
+				do_warn(
+_("rebuilding inode %"PRIu64" attr fork\n"),
+					lino);
+				try_rebuild = 0;
+				err = rebuild_bmap(mp, lino, XFS_ATTR_FORK,
+						be16_to_cpu(dino->di_anextents),
+						ino_bpp, dinop, dirty);
+				dino = *dinop;
+				if (!err)
+					goto retry;
+				do_warn(
+_("inode %"PRIu64" attr fork rebuild failed, error %d"),
+					lino, err);
+			}
 			do_warn(_(", clearing attr fork\n"));
 			*dirty += clear_dinode_attr(mp, dino, lino);
 			dino->di_aformat = XFS_DINODE_FMT_LOCAL;
 			ASSERT(*dirty > 0);
-		} else  {
+		} else if (try_rebuild) {
+			do_warn(
+_("would have tried to rebuild inode %"PRIu64" attr fork or cleared it\n"),
+					lino);
+		} else {
 			do_warn(_(", would clear attr fork\n"));
 		}
 
diff --git a/repair/rmap.c b/repair/rmap.c
index 6dba330fd7b..5fbae50d5b7 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -33,7 +33,7 @@ struct xfs_ag_rmap {
 };
 
 static struct xfs_ag_rmap *ag_rmaps;
-static bool rmapbt_suspect;
+bool rmapbt_suspect;
 static bool refcbt_suspect;
 
 static inline int rmap_compare(const void *a, const void *b)
diff --git a/repair/rmap.h b/repair/rmap.h
index b9177f765e3..782256f8b7e 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -7,6 +7,7 @@
 #define RMAP_H_
 
 extern bool collect_rmaps;
+extern bool rmapbt_suspect;
 
 extern bool rmap_needs_work(struct xfs_mount *);
 

