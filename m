Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185697ED
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h4OaB5zX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773CDC433C7;
	Mon,  1 Jan 2024 00:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068472;
	bh=s4PnGIJc/tzdEtnzLulooUXzqIb14R+gIym0+AWJ1yY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=h4OaB5zXfgDamDrTelYc+lu5wybh5b1Tj1V/YH4FussETQt5WoK5dnpkAVnTbb6dS
	 6MOwYCD/FVigX72nCjs1semg18B+E88YbaDxKxtOw78VgNMCiibw1SnWsxU0oprB2l
	 CxU7aYQa7OQHzy+RQ9moiVVLrRaDSahXeWJ8vP2DnMqQwWMkAGMJvjXWzU/ays96RL
	 uaPFJx7hioYULmm/tm9uTmoAI0JLPCeLtawzcLxMU4v5c/PuEYN+0vATmThqj9YdGW
	 5/wWu5lF/uvWdXDteSu1oDoByZgifHbJ8T+EzPb+XZY2pM186r8dTPtGvyZryC3hzt
	 k6Cv9IZ8ex06g==
Date: Sun, 31 Dec 2023 16:21:12 +9900
Subject: [PATCH 41/47] xfs_repair: rebuild the realtime rmap btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015859.1815505.4816283208917682698.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Rebuild the realtime rmap btree file from the reverse mapping records we
gathered from walking the inodes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    5 +
 repair/Makefile          |    1 
 repair/bulkload.c        |   41 +++++++
 repair/bulkload.h        |    2 
 repair/phase6.c          |  155 +++++++++++++++++++++++++++
 repair/rmap.c            |   26 +++++
 repair/rmap.h            |    3 +
 repair/rtrmap_repair.c   |  261 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/xfs_repair.c      |    8 +
 9 files changed, 500 insertions(+), 2 deletions(-)
 create mode 100644 repair/rtrmap_repair.c


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index e65b4d6fea5..b5bb6c39928 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -271,6 +271,7 @@
 #define xfs_rmap_irec_offset_unpack	libxfs_rmap_irec_offset_unpack
 #define xfs_rmap_lookup_le		libxfs_rmap_lookup_le
 #define xfs_rmap_lookup_le_range	libxfs_rmap_lookup_le_range
+#define xfs_rmap_map_extent		libxfs_rmap_map_extent
 #define xfs_rmap_map_raw		libxfs_rmap_map_raw
 #define xfs_rmap_query_all		libxfs_rmap_query_all
 #define xfs_rmap_query_range		libxfs_rmap_query_range
@@ -288,6 +289,9 @@
 #define xfs_rtgroup_put			libxfs_rtgroup_put
 #define xfs_rtgroup_update_secondary_sbs	libxfs_rtgroup_update_secondary_sbs
 #define xfs_rtgroup_update_super	libxfs_rtgroup_update_super
+#define xfs_rtrmapbt_calc_size		libxfs_rtrmapbt_calc_size
+#define xfs_rtrmapbt_commit_staged_btree	libxfs_rtrmapbt_commit_staged_btree
+#define xfs_rtrmapbt_create		libxfs_rtrmapbt_create
 #define xfs_rtrmapbt_create_path	libxfs_rtrmapbt_create_path
 #define xfs_rtrmapbt_droot_maxrecs	libxfs_rtrmapbt_droot_maxrecs
 #define xfs_rtrmapbt_maxlevels_ondisk	libxfs_rtrmapbt_maxlevels_ondisk
@@ -295,6 +299,7 @@
 #define xfs_rtrmapbt_maxrecs		libxfs_rtrmapbt_maxrecs
 #define xfs_rtrmapbt_mem_create		libxfs_rtrmapbt_mem_create
 #define xfs_rtrmapbt_mem_cursor		libxfs_rtrmapbt_mem_cursor
+#define xfs_rtrmapbt_stage_cursor	libxfs_rtrmapbt_stage_cursor
 
 #define xfs_sb_from_disk		libxfs_sb_from_disk
 #define xfs_sb_quota_from_disk		libxfs_sb_quota_from_disk
diff --git a/repair/Makefile b/repair/Makefile
index 1f72c811056..5bec8154829 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -75,6 +75,7 @@ CFILES = \
 	rcbag.c \
 	rmap.c \
 	rt.c \
+	rtrmap_repair.c \
 	sb.c \
 	scan.c \
 	slab.c \
diff --git a/repair/bulkload.c b/repair/bulkload.c
index e9c52afd23c..819639ae343 100644
--- a/repair/bulkload.c
+++ b/repair/bulkload.c
@@ -364,3 +364,44 @@ bulkload_estimate_ag_slack(
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
+	struct xfs_btree_bload	*bload,
+	unsigned long long	free)
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
+	if (free >= ((mp->m_sb.sb_dblocks * 3) >> 5))
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
index a88aafaa678..842121b1519 100644
--- a/repair/bulkload.h
+++ b/repair/bulkload.h
@@ -78,5 +78,7 @@ void bulkload_cancel(struct bulkload *bkl);
 int bulkload_commit(struct bulkload *bkl);
 void bulkload_estimate_ag_slack(struct repair_ctx *sc,
 		struct xfs_btree_bload *bload, unsigned int free);
+void bulkload_estimate_inode_slack(struct xfs_mount *mp,
+		struct xfs_btree_bload *bload, unsigned long long free);
 
 #endif /* __XFS_REPAIR_BULKLOAD_H__ */
diff --git a/repair/phase6.c b/repair/phase6.c
index 63a2768d9c6..4c387557c31 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -19,6 +19,8 @@
 #include "progress.h"
 #include "versions.h"
 #include "repair/pptr.h"
+#include "slab.h"
+#include "rmap.h"
 
 static xfs_ino_t		orphanage_ino;
 
@@ -1072,6 +1074,136 @@ mk_rsumino(
 	libxfs_irele(ip);
 }
 
+static void
+ensure_rtgroup_rmapbt(
+	struct xfs_rtgroup	*rtg,
+	xfs_filblks_t		est_fdblocks)
+{
+	struct xfs_imeta_update	upd;
+	struct xfs_mount	*mp = rtg->rtg_mount;
+	struct xfs_imeta_path	*path;
+	struct xfs_inode	*ip;
+	xfs_ino_t		ino;
+	int			error;
+
+	if (!xfs_has_rtrmapbt(mp))
+		return;
+
+	ino = rtgroup_rmap_ino(rtg);
+	if (no_modify) {
+		if (ino == NULLFSINO)
+			do_warn(_("would reset rtgroup %u rmap btree\n"),
+					rtg->rtg_rgno);
+		return;
+	}
+
+	if (ino == NULLFSINO)
+		do_warn(_("resetting rtgroup %u rmap btree\n"),
+				rtg->rtg_rgno);
+
+	error = -libxfs_rtrmapbt_create_path(mp, rtg->rtg_rgno, &path);
+	if (error)
+		do_error(
+ _("Couldn't create rtgroup %u rmap file path, err %d\n"),
+				rtg->rtg_rgno, error);
+
+	error = ensure_imeta_dirpath(mp, path);
+	if (error)
+		do_error(
+ _("Couldn't create rtgroup %u metadata directory, error %d\n"),
+				rtg->rtg_rgno, error);
+
+	if (ino != NULLFSINO) {
+		struct xfs_trans	*tp;
+
+		/*
+		 * We're still hanging on to our old inode pointer, so grab it
+		 * and reconnect it to the metadata directory tree.  If it
+		 * can't be grabbed, create a new rtrmap file.
+		 */
+		error = -libxfs_trans_alloc_empty(mp, &tp);
+		if (error)
+			do_error(
+ _("Couldn't allocate transaction to iget rtgroup %u rmap inode 0x%llx, error %d\n"),
+					rtg->rtg_rgno, (unsigned long long)ino,
+					error);
+		error = -libxfs_imeta_iget(tp, ino, XFS_DIR3_FT_REG_FILE, &ip);
+		libxfs_trans_cancel(tp);
+		if (error) {
+			do_warn(
+ _("Couldn't iget rtgroup %u rmap inode 0x%llx, error %d\n"),
+					rtg->rtg_rgno, (unsigned long long)ino,
+					error);
+			goto zap;
+		}
+
+		/*
+		 * Since we're reattaching this file to the metadata directory
+		 * tree, try to remove all the parent pointers that might be
+		 * attached.
+		 */
+		try_erase_parent_ptrs(ip);
+
+		error = -libxfs_imeta_start_link(mp, path, ip, &upd);
+		if (error)
+			do_error(
+ _("Couldn't grab resources to reconnect rtgroup %u rmapbt, error %d\n"),
+					rtg->rtg_rgno, error);
+
+		error = -libxfs_imeta_link(&upd);
+		if (error)
+			do_error(
+ _("Failed to link rtgroup %u rmapbt inode 0x%llx, error %d\n"),
+					rtg->rtg_rgno,
+					(unsigned long long)ip->i_ino,
+					error);
+
+		/* Reset the link count to something sane. */
+		set_nlink(VFS_I(ip), 1);
+		ip->i_df.if_format = XFS_DINODE_FMT_RMAP;
+		libxfs_trans_log_inode(upd.tp, ip, XFS_ILOG_CORE);
+	} else {
+zap:
+		/*
+		 * The rtrmap inode was bad or gone, so just make a new one
+		 * and give our reference to the rtgroup structure.
+		 */
+		error = -libxfs_imeta_start_create(mp, path, &upd);
+		if (error)
+			do_error(
+ _("Couldn't grab resources to recreate rtgroup %u rmapbt, error %d\n"),
+					rtg->rtg_rgno, error);
+
+		error = -libxfs_rtrmapbt_create(&upd, &ip);
+		if (error)
+			do_error(
+ _("Couldn't create rtgroup %u rmap inode, error %d\n"),
+					rtg->rtg_rgno, error);
+	}
+
+	/* Mark the inode in use. */
+	mark_ino_inuse(mp, ip->i_ino, S_IFREG, upd.dp->i_ino);
+	mark_ino_metadata(mp, ip->i_ino);
+
+	error = -libxfs_imeta_commit_update(&upd);
+	if (error)
+		do_error(
+ _("Couldn't commit new rtgroup %u rmap inode %llu, error %d\n"),
+				rtg->rtg_rgno,
+				(unsigned long long)ip->i_ino,
+				error);
+
+	/* Copy our incore rmap data to the ondisk rmap inode. */
+	error = populate_rtgroup_rmapbt(rtg, ip, est_fdblocks);
+	if (error)
+		do_error(
+ _("rtgroup %u rmap btree could not be rebuilt, error %d\n"),
+				rtg->rtg_rgno, error);
+
+	libxfs_imeta_free_path(path);
+	libxfs_imeta_irele(ip);
+}
+
 /* Initialize a root directory. */
 static int
 init_fs_root_dir(
@@ -3838,6 +3970,27 @@ traverse_ags(
 	do_inode_prefetch(mp, ag_stride, traverse_function, false, true);
 }
 
+static void
+reset_rt_metadata_inodes(
+	struct xfs_mount	*mp)
+{
+	struct xfs_rtgroup	*rtg;
+	xfs_filblks_t		metadata_blocks = 0;
+	xfs_filblks_t		est_fdblocks = 0;
+	xfs_rgnumber_t		rgno;
+
+	/* Estimate how much free space will be left after building btrees */
+	for_each_rtgroup(mp, rgno, rtg) {
+		metadata_blocks += estimate_rtrmapbt_blocks(rtg);
+	}
+	if (mp->m_sb.sb_fdblocks > metadata_blocks)
+		est_fdblocks = mp->m_sb.sb_fdblocks - metadata_blocks;
+
+	for_each_rtgroup(mp, rgno, rtg) {
+		ensure_rtgroup_rmapbt(rtg, est_fdblocks);
+	}
+}
+
 void
 phase6(xfs_mount_t *mp)
 {
@@ -3903,6 +4056,8 @@ phase6(xfs_mount_t *mp)
 		}
 	}
 
+	reset_rt_metadata_inodes(mp);
+
 	if (!no_modify)  {
 		do_log(
 _("        - resetting contents of realtime bitmap and summary inodes\n"));
diff --git a/repair/rmap.c b/repair/rmap.c
index 5ac7188f12e..1312a0dde34 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -2106,3 +2106,29 @@ rtgroup_rmap_ino(
 
 	return ar->rg_rmap_ino;
 }
+
+/* Estimate the size of the ondisk rtrmapbt from the incore tree. */
+xfs_filblks_t
+estimate_rtrmapbt_blocks(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_mount	*mp = rtg->rtg_mount;
+	struct xfs_ag_rmap	*x;
+	unsigned long long	nr_recs;
+
+	if (!rmap_needs_work(mp) || !xfs_has_rtrmapbt(mp))
+		return 0;
+
+	x = &rg_rmaps[rtg->rtg_rgno];
+	if (!x->ar_xfbtree)
+		return 0;
+
+	/*
+	 * Overestimate the amount of space needed by pretending that every
+	 * byte in the incore tree is used to store rtrmapbt records.  This
+	 * means we can use SEEK_DATA/HOLE on the xfile, which is faster than
+	 * walking the entire btree.
+	 */
+	nr_recs = xfbtree_bytes(x->ar_xfbtree) / sizeof(struct xfs_rmap_rec);
+	return libxfs_rtrmapbt_calc_size(mp, nr_recs);
+}
diff --git a/repair/rmap.h b/repair/rmap.h
index dcd834ef242..1f99606a455 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -67,5 +67,8 @@ int rmap_get_mem_rec(struct rmap_mem_cur *rmcur, struct xfs_rmap_irec *irec);
 
 bool is_rtrmap_inode(xfs_ino_t ino);
 xfs_ino_t rtgroup_rmap_ino(struct xfs_rtgroup *rtg);
+int populate_rtgroup_rmapbt(struct xfs_rtgroup *rtg, struct xfs_inode *ip,
+		xfs_filblks_t fdblocks);
+xfs_filblks_t estimate_rtrmapbt_blocks(struct xfs_rtgroup *rtg);
 
 #endif /* RMAP_H_ */
diff --git a/repair/rtrmap_repair.c b/repair/rtrmap_repair.c
new file mode 100644
index 00000000000..1c9df17d205
--- /dev/null
+++ b/repair/rtrmap_repair.c
@@ -0,0 +1,261 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2019-2024 Oracle.  All Rights Reserved.
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
+
+/* Ported routines from fs/xfs/scrub/rtrmap_repair.c */
+
+/*
+ * Realtime Reverse Mapping (RTRMAPBT) Repair
+ * ==========================================
+ *
+ * Gather all the rmap records for the inode and fork we're fixing, reset the
+ * incore fork, then recreate the btree.
+ */
+struct xrep_rtrmap {
+	struct rmap_mem_cur	btree_cursor;
+
+	/* New fork. */
+	struct bulkload		new_fork_info;
+	struct xfs_btree_bload	rtrmap_bload;
+
+	struct repair_ctx	*sc;
+	struct xfs_rtgroup	*rtg;
+
+	/* Estimated free space after building all rt btrees */
+	xfs_filblks_t		est_fdblocks;
+};
+
+/* Retrieve rtrmapbt data for bulk load. */
+STATIC int
+xrep_rtrmap_get_records(
+	struct xfs_btree_cur	*cur,
+	unsigned int		idx,
+	struct xfs_btree_block	*block,
+	unsigned int		nr_wanted,
+	void			*priv)
+{
+	struct xrep_rtrmap	*rr = priv;
+	union xfs_btree_rec	*block_rec;
+	unsigned int		loaded;
+	int			ret;
+
+	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
+		ret = rmap_get_mem_rec(&rr->btree_cursor, &cur->bc_rec.r);
+		if (ret < 0)
+			return ret;
+		if (ret == 0)
+			do_error(
+ _("ran out of records while rebuilding rt rmap btree\n"));
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
+xrep_rtrmap_claim_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	void			*priv)
+{
+	struct xrep_rtrmap	*rr = priv;
+
+	return bulkload_claim_block(cur, &rr->new_fork_info, ptr);
+}
+
+/* Figure out how much space we need to create the incore btree root block. */
+STATIC size_t
+xrep_rtrmap_iroot_size(
+	struct xfs_btree_cur	*cur,
+	unsigned int		level,
+	unsigned int		nr_this_level,
+	void			*priv)
+{
+	return xfs_rtrmap_broot_space_calc(cur->bc_mp, level, nr_this_level);
+}
+
+/* Reserve new btree blocks and bulk load all the rtrmap records. */
+STATIC int
+xrep_rtrmap_btree_load(
+	struct xrep_rtrmap	*rr,
+	struct xfs_btree_cur	*rtrmap_cur)
+{
+	struct repair_ctx	*sc = rr->sc;
+	int			error;
+
+	rr->rtrmap_bload.get_records = xrep_rtrmap_get_records;
+	rr->rtrmap_bload.claim_block = xrep_rtrmap_claim_block;
+	rr->rtrmap_bload.iroot_size = xrep_rtrmap_iroot_size;
+	bulkload_estimate_inode_slack(sc->mp, &rr->rtrmap_bload,
+			rr->est_fdblocks);
+
+	/* Compute how many blocks we'll need. */
+	error = -libxfs_btree_bload_compute_geometry(rtrmap_cur,
+			&rr->rtrmap_bload,
+			rmap_record_count(sc->mp, true, rr->rtg->rtg_rgno));
+	if (error)
+		return error;
+
+	/*
+	 * Guess how many blocks we're going to need to rebuild an entire rtrmap
+	 * from the number of extents we found, and pump up our transaction to
+	 * have sufficient block reservation.
+	 */
+	error = -libxfs_trans_reserve_more(sc->tp, rr->rtrmap_bload.nr_blocks,
+			0);
+	if (error)
+		return error;
+
+	/*
+	 * Reserve the space we'll need for the new btree.  Drop the cursor
+	 * while we do this because that can roll the transaction and cursors
+	 * can't handle that.
+	 */
+	error = bulkload_alloc_file_blocks(&rr->new_fork_info,
+			rr->rtrmap_bload.nr_blocks);
+	if (error)
+		return error;
+
+	/* Add all observed rtrmap records. */
+	error = rmap_init_mem_cursor(rr->sc->mp, sc->tp, true,
+			rr->rtg->rtg_rgno, &rr->btree_cursor);
+	if (error)
+		return error;
+	error = -libxfs_btree_bload(rtrmap_cur, &rr->rtrmap_bload, rr);
+	rmap_free_mem_cursor(sc->tp, &rr->btree_cursor, error);
+	return error;
+}
+
+/* Update the inode counters. */
+STATIC int
+xrep_rtrmap_reset_counters(
+	struct xrep_rtrmap	*rr)
+{
+	struct repair_ctx	*sc = rr->sc;
+
+	/*
+	 * Update the inode block counts to reflect the btree we just
+	 * generated.
+	 */
+	sc->ip->i_nblocks = rr->new_fork_info.ifake.if_blocks;
+	libxfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
+
+	/* Quotas don't exist so we're done. */
+	return 0;
+}
+
+/*
+ * Use the collected rmap information to stage a new rt rmap btree.  If this is
+ * successful we'll return with the new btree root information logged to the
+ * repair transaction but not yet committed.
+ */
+static int
+xrep_rtrmap_build_new_tree(
+	struct xrep_rtrmap	*rr)
+{
+	struct xfs_owner_info	oinfo;
+	struct xfs_btree_cur	*cur;
+	struct repair_ctx	*sc = rr->sc;
+	struct xbtree_ifakeroot	*ifake = &rr->new_fork_info.ifake;
+	int			error;
+
+	/*
+	 * Prepare to construct the new fork by initializing the new btree
+	 * structure and creating a fake ifork in the ifakeroot structure.
+	 */
+	libxfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, XFS_DATA_FORK);
+	bulkload_init_inode(&rr->new_fork_info, sc, XFS_DATA_FORK, &oinfo);
+	cur = libxfs_rtrmapbt_stage_cursor(sc->mp, rr->rtg, sc->ip, ifake);
+
+	/*
+	 * Figure out the size and format of the new fork, then fill it with
+	 * all the rtrmap records we've found.  Join the inode to the
+	 * transaction so that we can roll the transaction while holding the
+	 * inode locked.
+	 */
+	libxfs_trans_ijoin(sc->tp, sc->ip, 0);
+	ifake->if_fork->if_format = XFS_DINODE_FMT_RMAP;
+	error = xrep_rtrmap_btree_load(rr, cur);
+	if (error)
+		goto err_cur;
+
+	/*
+	 * Install the new fork in the inode.  After this point the old mapping
+	 * data are no longer accessible and the new tree is live.  We delete
+	 * the cursor immediately after committing the staged root because the
+	 * staged fork might be in extents format.
+	 */
+	libxfs_rtrmapbt_commit_staged_btree(cur, sc->tp);
+	libxfs_btree_del_cursor(cur, 0);
+
+	/* Reset the inode counters now that we've changed the fork. */
+	error = xrep_rtrmap_reset_counters(rr);
+	if (error)
+		goto err_newbt;
+
+	/* Dispose of any unused blocks and the accounting infomation. */
+	error = bulkload_commit(&rr->new_fork_info);
+	if (error)
+		return error;
+
+	return -libxfs_trans_roll_inode(&sc->tp, sc->ip);
+err_cur:
+	if (cur)
+		libxfs_btree_del_cursor(cur, error);
+err_newbt:
+	bulkload_cancel(&rr->new_fork_info);
+	return error;
+}
+
+/* Store the realtime reverse-mappings in the rtrmapbt. */
+int
+populate_rtgroup_rmapbt(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_inode	*ip,
+	xfs_filblks_t		est_fdblocks)
+{
+	struct repair_ctx	sc = {
+		.mp		= rtg->rtg_mount,
+		.ip		= ip,
+	};
+	struct xrep_rtrmap	rr = {
+		.sc		= &sc,
+		.rtg		= rtg,
+		.est_fdblocks	= est_fdblocks,
+	};
+	struct xfs_mount	*mp = rtg->rtg_mount;
+	int			error;
+
+	if (!xfs_has_rtrmapbt(mp))
+		return 0;
+
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0,
+			&sc.tp);
+	if (error)
+		return error;
+
+	error = xrep_rtrmap_build_new_tree(&rr);
+	if (error)
+		goto out_cancel;
+
+	return -libxfs_trans_commit(sc.tp);
+
+out_cancel:
+	libxfs_trans_cancel(sc.tp);
+	return error;
+}
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index e3701f91470..88d23dbc8ec 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1425,13 +1425,17 @@ main(int argc, char **argv)
 	rcbagbt_destroy_cur_cache();
 
 	/*
-	 * Done with the block usage maps, toss them...
+	 * Done with the block usage maps, toss them.  Realtime metadata aren't
+	 * rebuilt until phase 6, so we have to keep them around.
 	 */
-	rmaps_free(mp);
+	if (mp->m_sb.sb_rblocks == 0)
+		rmaps_free(mp);
 	free_bmaps(mp);
 
 	if (!bad_ino_btree)  {
 		phase6(mp);
+		if (mp->m_sb.sb_rblocks != 0)
+			rmaps_free(mp);
 		phase_end(mp, 6);
 
 		phase7(mp, phase2_threads);

