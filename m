Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CF71362
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uiITZQeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6D9C433C8;
	Mon,  1 Jan 2024 00:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069332;
	bh=pBwG8k09UOjEkP3Zx1AMa1HZuSxE+Spj8512fvSZNC4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uiITZQeC/kX2/bMdiRdwxzQJSqECrYS4lB3VPixhDI1YC/vqlxdt8TJg03R+othRN
	 n/qeR9x8By8GrFZQbqTPReuL0ezFFiAO4FsOgLvqAA92Tp3fqI3STaUqtbhW2RsLLQ
	 etURNca+zqsJIhatrCMqYlelopTkHcs9YFkm4CCjvXLJucYrYNsOysKY0ERzSxLk4l
	 TxlfE5aTgcYyxO4Y8N4SBkxukcmaye2YaJ5nIIqrTtcEIbncY1LS3YlreHdBtd7kFe
	 x1SQfEHsfnYyEtlHjl/Ze2pJq9x41RhII7JVGY2Jp2FEdLlqvv0ILO6hFQvrwtr0dz
	 MvFHTVOAv/46g==
Date: Sun, 31 Dec 2023 16:35:32 +9900
Subject: [PATCH 36/42] xfs_repair: rebuild the realtime refcount btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017607.1817107.16721980498806545638.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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

Use the collected reference count information to rebuild the btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h   |    5 +
 repair/Makefile            |    1 
 repair/agbtree.c           |    2 
 repair/phase5.c            |    3 -
 repair/phase6.c            |  133 +++++++++++++++++++++++
 repair/rmap.c              |   31 +++++
 repair/rmap.h              |    7 +
 repair/rtrefcount_repair.c |  256 ++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 434 insertions(+), 4 deletions(-)
 create mode 100644 repair/rtrefcount_repair.c


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index cfa70778262..bc34ce9caad 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -293,11 +293,16 @@
 #define xfs_rtgroup_update_secondary_sbs	libxfs_rtgroup_update_secondary_sbs
 #define xfs_rtgroup_update_super	libxfs_rtgroup_update_super
 
+#define xfs_rtrefcountbt_absolute_maxlevels	libxfs_rtrefcountbt_absolute_maxlevels
+#define xfs_rtrefcountbt_calc_size		libxfs_rtrefcountbt_calc_size
+#define xfs_rtrefcountbt_commit_staged_btree	libxfs_rtrefcountbt_commit_staged_btree
+#define xfs_rtrefcountbt_create		libxfs_rtrefcountbt_create
 #define xfs_rtrefcountbt_create_path	libxfs_rtrefcountbt_create_path
 #define xfs_rtrefcountbt_droot_maxrecs	libxfs_rtrefcountbt_droot_maxrecs
 #define xfs_rtrefcountbt_init_cursor	libxfs_rtrefcountbt_init_cursor
 #define xfs_rtrefcountbt_maxlevels_ondisk	libxfs_rtrefcountbt_maxlevels_ondisk
 #define xfs_rtrefcountbt_maxrecs	libxfs_rtrefcountbt_maxrecs
+#define xfs_rtrefcountbt_stage_cursor	libxfs_rtrefcountbt_stage_cursor
 
 #define xfs_rtrmapbt_calc_reserves	libxfs_rtrmapbt_calc_reserves
 #define xfs_rtrmapbt_calc_size		libxfs_rtrmapbt_calc_size
diff --git a/repair/Makefile b/repair/Makefile
index 5bec8154829..5eca6d64c51 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -75,6 +75,7 @@ CFILES = \
 	rcbag.c \
 	rmap.c \
 	rt.c \
+	rtrefcount_repair.c \
 	rtrmap_repair.c \
 	sb.c \
 	scan.c \
diff --git a/repair/agbtree.c b/repair/agbtree.c
index 90863b0dd7d..571eeef231a 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -729,7 +729,7 @@ init_refc_cursor(
 
 	/* Compute how many blocks we'll need. */
 	error = -libxfs_btree_bload_compute_geometry(btr->cur, &btr->bload,
-			refcount_record_count(sc->mp, agno));
+			refcount_record_count(sc->mp, false, agno));
 	if (error)
 		do_error(
 _("Unable to compute refcount btree geometry, error %d.\n"), error);
diff --git a/repair/phase5.c b/repair/phase5.c
index 5e1dff0aadd..8c0685f494f 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -705,7 +705,7 @@ are_packed_btrees_needed(
 	 * If we don't have inode-based metadata, we can let the AG btrees
 	 * pack as needed; there are no global space concerns here.
 	 */
-	if (!xfs_has_rtrmapbt(mp))
+	if (!xfs_has_rtrmapbt(mp) && !xfs_has_rtreflink(mp))
 		return false;
 
 	for_each_perag(mp, agno, pag) {
@@ -718,6 +718,7 @@ are_packed_btrees_needed(
 
 	for_each_rtgroup(mp, rgno, rtg) {
 		metadata_blocks += estimate_rtrmapbt_blocks(rtg);
+		metadata_blocks += estimate_rtrefcountbt_blocks(rtg);
 	}
 
 	/*
diff --git a/repair/phase6.c b/repair/phase6.c
index c9974623d12..9c79b233e35 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1148,6 +1148,137 @@ ensure_rtgroup_rmapbt(
 	libxfs_imeta_irele(ip);
 }
 
+static void
+ensure_rtgroup_refcountbt(
+	struct xfs_rtgroup	*rtg,
+	xfs_filblks_t		est_fdblocks)
+{
+	struct xfs_mount	*mp = rtg->rtg_mount;
+	struct xfs_imeta_path	*path;
+	struct xfs_inode	*ip;
+	struct xfs_imeta_update	upd;
+	xfs_ino_t		ino;
+	int			error;
+
+	if (!xfs_has_rtreflink(mp))
+		return;
+
+	ino = rtgroup_refcount_ino(rtg);
+	if (no_modify) {
+		if (ino == NULLFSINO)
+			do_warn(_("would reset rtgroup %u refcount btree\n"),
+					rtg->rtg_rgno);
+		return;
+	}
+
+	if (ino == NULLFSINO)
+		do_warn(_("resetting rtgroup %u refcount btree\n"),
+				rtg->rtg_rgno);
+
+	error = -libxfs_rtrefcountbt_create_path(mp, rtg->rtg_rgno, &path);
+	if (error)
+		do_error(
+ _("Couldn't create rtgroup %u refcount file path, err %d\n"),
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
+		 * can't be grabbed, create a new rtrefcount file.
+		 */
+		error = -libxfs_trans_alloc_empty(mp, &tp);
+		if (error)
+			do_error(
+ _("Couldn't allocate transaction to iget rtgroup %u refcountbt inode 0x%llx, error %d\n"),
+					rtg->rtg_rgno, (unsigned long long)ino,
+					error);
+		error = -libxfs_imeta_iget(tp, ino, XFS_DIR3_FT_REG_FILE, &ip);
+		libxfs_trans_cancel(tp);
+		if (error) {
+			do_warn(
+ _("Couldn't iget rtgroup %u refcountbt inode 0x%llx, error %d\n"),
+					rtg->rtg_rgno,
+					(unsigned long long)ino,
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
+ _("Couldn't grab resources to reconnect rtgroup %u refcountbt, error %d\n"),
+					rtg->rtg_rgno, error);
+
+		error = -libxfs_imeta_link(&upd);
+		if (error)
+			do_error(
+ _("Failed to link rtgroup %u refcountbt inode 0x%llx, error %d\n"),
+					rtg->rtg_rgno,
+					(unsigned long long)ino,
+					error);
+
+		/* Reset the link count to something sane. */
+		set_nlink(VFS_I(ip), 1);
+		ip->i_df.if_format = XFS_DINODE_FMT_REFCOUNT;
+		libxfs_trans_log_inode(upd.tp, ip, XFS_ILOG_CORE);
+	} else {
+zap:
+		/*
+		 * The rtrefcount inode was bad or gone, so just make a new one
+		 * and give our reference to the rtgroup structure.
+		 */
+		error = -libxfs_imeta_start_create(mp, path, &upd);
+		if (error)
+			do_error(
+ _("Couldn't grab resources to recreate rtgroup %u refcountbt, error %d\n"),
+					rtg->rtg_rgno, error);
+
+		error = -libxfs_rtrefcountbt_create(&upd, &ip);
+		if (error)
+			do_error(
+ _("Couldn't create rtgroup %u refcountbt inode, error %d\n"),
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
+ _("Couldn't commit new rtgroup %u refcountbt inode %llu, error %d\n"),
+				rtg->rtg_rgno,
+				(unsigned long long)ip->i_ino,
+				error);
+
+	/* Copy our incore refcount data to the ondisk refcount inode. */
+	error = populate_rtgroup_refcountbt(rtg, ip, est_fdblocks);
+	if (error)
+		do_error(
+ _("rtgroup %u refcount btree could not be rebuilt, error %d\n"),
+				rtg->rtg_rgno, error);
+
+	libxfs_imeta_free_path(path);
+	libxfs_imeta_irele(ip);
+}
+
 /* Initialize a root directory. */
 static int
 init_fs_root_dir(
@@ -3931,6 +4062,7 @@ reset_rt_metadata_inodes(
 	if (!need_packed_btrees) {
 		for_each_rtgroup(mp, rgno, rtg) {
 			metadata_blocks += estimate_rtrmapbt_blocks(rtg);
+			metadata_blocks += estimate_rtrefcountbt_blocks(rtg);
 		}
 		if (mp->m_sb.sb_fdblocks > metadata_blocks)
 			est_fdblocks = mp->m_sb.sb_fdblocks - metadata_blocks;
@@ -3938,6 +4070,7 @@ reset_rt_metadata_inodes(
 
 	for_each_rtgroup(mp, rgno, rtg) {
 		ensure_rtgroup_rmapbt(rtg, est_fdblocks);
+		ensure_rtgroup_refcountbt(rtg, est_fdblocks);
 	}
 }
 
diff --git a/repair/rmap.c b/repair/rmap.c
index 51431808db2..ab5664846c8 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1930,9 +1930,10 @@ _("Unable to fix reflink flag on inode %"PRIu64".\n"),
 uint64_t
 refcount_record_count(
 	struct xfs_mount	*mp,
+	bool			isrt,
 	xfs_agnumber_t		agno)
 {
-	struct xfs_ag_rmap	*x = rmaps_for_group(false, agno);
+	struct xfs_ag_rmap	*x = rmaps_for_group(isrt, agno);
 
 	return slab_count(x->ar_refcount_items);
 }
@@ -2346,3 +2347,31 @@ estimate_rtrmapbt_blocks(
 	nr_recs = xfbtree_bytes(x->ar_xfbtree) / sizeof(struct xfs_rmap_rec);
 	return libxfs_rtrmapbt_calc_size(mp, nr_recs);
 }
+
+xfs_ino_t
+rtgroup_refcount_ino(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_ag_rmap	*ar = rmaps_for_group(true, rtg->rtg_rgno);
+
+	return ar->rg_refcount_ino;
+}
+
+/* Estimate the size of the ondisk rtrefcountbt from the incore data. */
+xfs_filblks_t
+estimate_rtrefcountbt_blocks(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_mount	*mp = rtg->rtg_mount;
+	struct xfs_ag_rmap	*x;
+
+	if (!rmap_needs_work(mp) || !xfs_has_rtreflink(mp))
+		return 0;
+
+	x = &rg_rmaps[rtg->rtg_rgno];
+	if (!x->ar_refcount_items)
+		return 0;
+
+	return libxfs_rtrefcountbt_calc_size(mp,
+			slab_count(x->ar_refcount_items));
+}
diff --git a/repair/rmap.h b/repair/rmap.h
index 45560805a4e..74322044cb5 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -39,7 +39,8 @@ extern void rmap_high_key_from_rec(struct xfs_rmap_irec *rec,
 		struct xfs_rmap_irec *key);
 
 int compute_refcounts(struct xfs_mount *mp, bool isrt, xfs_agnumber_t agno);
-uint64_t refcount_record_count(struct xfs_mount *mp, xfs_agnumber_t agno);
+uint64_t refcount_record_count(struct xfs_mount *mp, bool isrt,
+		xfs_agnumber_t agno);
 int init_refcount_cursor(bool isrt, xfs_agnumber_t agno,
 		struct xfs_slab_cursor **pcur);
 extern void refcount_avoid_check(struct xfs_mount *mp);
@@ -76,5 +77,9 @@ xfs_filblks_t estimate_rtrmapbt_blocks(struct xfs_rtgroup *rtg);
 xfs_rgnumber_t rtgroup_for_rtrefcount_inode(struct xfs_mount *mp,
 		xfs_ino_t ino);
 bool is_rtrefcount_ino(xfs_ino_t ino);
+xfs_ino_t rtgroup_refcount_ino(struct xfs_rtgroup *rtg);
+int populate_rtgroup_refcountbt(struct xfs_rtgroup *rtg, struct xfs_inode *ip,
+		xfs_filblks_t fdblocks);
+xfs_filblks_t estimate_rtrefcountbt_blocks(struct xfs_rtgroup *rtg);
 
 #endif /* RMAP_H_ */
diff --git a/repair/rtrefcount_repair.c b/repair/rtrefcount_repair.c
new file mode 100644
index 00000000000..f11684b4775
--- /dev/null
+++ b/repair/rtrefcount_repair.c
@@ -0,0 +1,256 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
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
+/*
+ * Realtime Reference Count (RTREFCBT) Repair
+ * ==========================================
+ *
+ * Gather all the reference count records for the realtime device, reset the
+ * incore fork, then recreate the btree.
+ */
+struct xrep_rtrefc {
+	/* rtrefcbt slab cursor */
+	struct xfs_slab_cursor	*slab_cursor;
+
+	/* New fork. */
+	struct bulkload		new_fork_info;
+	struct xfs_btree_bload	rtrefc_bload;
+
+	struct repair_ctx	*sc;
+	struct xfs_rtgroup	*rtg;
+
+	/* Estimated free space after building all rt btrees */
+	xfs_filblks_t		est_fdblocks;
+};
+
+/* Retrieve rtrefc data for bulk load. */
+STATIC int
+xrep_rtrefc_get_records(
+	struct xfs_btree_cur		*cur,
+	unsigned int			idx,
+	struct xfs_btree_block		*block,
+	unsigned int			nr_wanted,
+	void				*priv)
+{
+	struct xfs_refcount_irec	*rec;
+	struct xrep_rtrefc		*rc = priv;
+	union xfs_btree_rec		*block_rec;
+	unsigned int			loaded;
+
+	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
+		rec = pop_slab_cursor(rc->slab_cursor);
+		memcpy(&cur->bc_rec.rc, rec, sizeof(struct xfs_refcount_irec));
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
+xrep_rtrefc_claim_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	void			*priv)
+{
+	struct xrep_rtrefc	*rr = priv;
+
+	return bulkload_claim_block(cur, &rr->new_fork_info, ptr);
+}
+
+/* Figure out how much space we need to create the incore btree root block. */
+STATIC size_t
+xrep_rtrefc_iroot_size(
+	struct xfs_btree_cur	*cur,
+	unsigned int		level,
+	unsigned int		nr_this_level,
+	void			*priv)
+{
+	return xfs_rtrefcount_broot_space_calc(cur->bc_mp, level,
+			nr_this_level);
+}
+
+/* Reserve new btree blocks and bulk load all the rtrmap records. */
+STATIC int
+xrep_rtrefc_btree_load(
+	struct xrep_rtrefc	*rr,
+	struct xfs_btree_cur	*rtrmap_cur)
+{
+	struct repair_ctx	*sc = rr->sc;
+	int			error;
+
+	rr->rtrefc_bload.get_records = xrep_rtrefc_get_records;
+	rr->rtrefc_bload.claim_block = xrep_rtrefc_claim_block;
+	rr->rtrefc_bload.iroot_size = xrep_rtrefc_iroot_size;
+	bulkload_estimate_inode_slack(sc->mp, &rr->rtrefc_bload,
+			rr->est_fdblocks);
+
+	/* Compute how many blocks we'll need. */
+	error = -libxfs_btree_bload_compute_geometry(rtrmap_cur,
+			&rr->rtrefc_bload,
+			refcount_record_count(sc->mp, true, rr->rtg->rtg_rgno));
+	if (error)
+		return error;
+
+	/*
+	 * Guess how many blocks we're going to need to rebuild an entire
+	 * rtrefcountbt from the number of extents we found, and pump up our
+	 * transaction to have sufficient block reservation.
+	 */
+	error = -libxfs_trans_reserve_more(sc->tp, rr->rtrefc_bload.nr_blocks,
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
+			rr->rtrefc_bload.nr_blocks);
+	if (error)
+		return error;
+
+	/* Add all observed rtrmap records. */
+	error = init_refcount_cursor(true, rr->rtg->rtg_rgno, &rr->slab_cursor);
+	if (error)
+		return error;
+	error = -libxfs_btree_bload(rtrmap_cur, &rr->rtrefc_bload, rr);
+	free_slab_cursor(&rr->slab_cursor);
+	return error;
+}
+
+/* Update the inode counters. */
+STATIC int
+xrep_rtrefc_reset_counters(
+	struct xrep_rtrefc	*rr)
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
+ * Use the collected rmap information to stage a new rt refcount btree.  If
+ * this is successful we'll return with the new btree root information logged
+ * to the repair transaction but not yet committed.
+ */
+static int
+xrep_rtrefc_build_new_tree(
+	struct xrep_rtrefc	*rr)
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
+	cur = libxfs_rtrefcountbt_stage_cursor(sc->mp, rr->rtg, sc->ip, ifake);
+
+	/*
+	 * Figure out the size and format of the new fork, then fill it with
+	 * all the rtrmap records we've found.  Join the inode to the
+	 * transaction so that we can roll the transaction while holding the
+	 * inode locked.
+	 */
+	libxfs_trans_ijoin(sc->tp, sc->ip, 0);
+	ifake->if_fork->if_format = XFS_DINODE_FMT_REFCOUNT;
+	error = xrep_rtrefc_btree_load(rr, cur);
+	if (error)
+		goto err_cur;
+
+	/*
+	 * Install the new fork in the inode.  After this point the old mapping
+	 * data are no longer accessible and the new tree is live.  We delete
+	 * the cursor immediately after committing the staged root because the
+	 * staged fork might be in extents format.
+	 */
+	libxfs_rtrefcountbt_commit_staged_btree(cur, sc->tp);
+	libxfs_btree_del_cursor(cur, 0);
+
+	/* Reset the inode counters now that we've changed the fork. */
+	error = xrep_rtrefc_reset_counters(rr);
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
+/* Store the realtime reference counts in the rtrefcbt. */
+int
+populate_rtgroup_refcountbt(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_inode	*ip,
+	xfs_filblks_t		est_fdblocks)
+{
+	struct repair_ctx	sc = {
+		.mp		= rtg->rtg_mount,
+		.ip		= ip,
+	};
+	struct xrep_rtrefc	rr = {
+		.sc		= &sc,
+		.rtg		= rtg,
+		.est_fdblocks	= est_fdblocks,
+	};
+	struct xfs_mount	*mp = rtg->rtg_mount;
+	int			error;
+
+	if (!xfs_has_rtreflink(mp))
+		return 0;
+
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0,
+			&sc.tp);
+	if (error)
+		return error;
+
+	error = xrep_rtrefc_build_new_tree(&rr);
+	if (error)
+		goto out_cancel;
+
+	return -libxfs_trans_commit(sc.tp);
+
+out_cancel:
+	libxfs_trans_cancel(sc.tp);
+	return error;
+}

