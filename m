Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32892417C9
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 23:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882872; cv=none; b=SLrQG4Fsjcl/PQwIL5SZAU0AL5RENv2rZbZ6Ky4YQ2icZOOs4eAllDRmvus0SBvWqt7mdu81Z/7/lzvoo6N/uoy/ZruioPhEvUOJ3nzXKsC/mBwXTE153h2WB7GOzQzH9+99U5139yKlD4Q0JW4I4Ip/60DhVcCHBtZb/es2EeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882872; c=relaxed/simple;
	bh=HLZWwRQavcix0GHVVd+D50NLm653zeVyTsVnYqIDpTc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nYlo85Hil+hjT7NU30gAI57Aw0tpl9lyTSM7jVPJQwEJtMQ5+CR+2Xj2qnFg6Leu96+S/Mq4OK66AoIom5DX183QIjtizrt9EvlWl9a2izEpp43181KmIZHjKrmwFh46ovCW6lRR2blSdKEEKjOJDo6OOtK4W3oZ84Bbk+D2Qxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OCUfQveI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OCUfQveI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700DEC4CEDD;
	Thu,  6 Feb 2025 23:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882872;
	bh=HLZWwRQavcix0GHVVd+D50NLm653zeVyTsVnYqIDpTc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OCUfQveIvY3jjFCkLObYYmUBqwZsyvdssl/E6op2UZvx7xne5Gz/MJ1e+dfRP/LMo
	 qhVPSgf2TTO+f+bUyU91NwQXBuRNlwiSv3+qQGX2MaLjNiYpcV4QfnOfZFj7HXM74h
	 6tyXFz3ugxqRyNCIABFsrRZP0OFiaNHaMYeNt3WcmCe/aIymrQpBRpCYFsXSgVJEAO
	 JuvlieFGaaAELAbD8hQBKDSounimyezKj09EAcKrlkSyp3Mjh6bgD8cZo2mIgP+5gg
	 4+pzXVXQiT/RVfIFWzbWIHDTTGiCmn/btU6Yn0orj2oxhh8ux9wYt8idPdDJLqgP7T
	 yFcpt6W55DV/A==
Date: Thu, 06 Feb 2025 15:01:11 -0800
Subject: [PATCH 17/22] xfs_repair: rebuild the realtime refcount btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888089192.2741962.1542453669085725843.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h   |    5 +
 repair/Makefile            |    1 
 repair/agbtree.c           |    2 
 repair/phase5.c            |    6 +
 repair/phase6.c            |   14 ++
 repair/rmap.c              |   22 ++++
 repair/rmap.h              |    7 +
 repair/rtrefcount_repair.c |  257 ++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 308 insertions(+), 6 deletions(-)
 create mode 100644 repair/rtrefcount_repair.c


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index b5a39856bc1e80..66cbb34f05a48f 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -320,11 +320,16 @@
 #define xfs_rtgroup_get			libxfs_rtgroup_get
 #define xfs_rtgroup_put			libxfs_rtgroup_put
 
+#define xfs_rtrefcountbt_absolute_maxlevels	libxfs_rtrefcountbt_absolute_maxlevels
 #define xfs_rtrefcountbt_calc_reserves	libxfs_rtrefcountbt_calc_reserves
+#define xfs_rtrefcountbt_calc_size		libxfs_rtrefcountbt_calc_size
+#define xfs_rtrefcountbt_commit_staged_btree	libxfs_rtrefcountbt_commit_staged_btree
+#define xfs_rtrefcountbt_create		libxfs_rtrefcountbt_create
 #define xfs_rtrefcountbt_droot_maxrecs	libxfs_rtrefcountbt_droot_maxrecs
 #define xfs_rtrefcountbt_init_cursor	libxfs_rtrefcountbt_init_cursor
 #define xfs_rtrefcountbt_maxlevels_ondisk	libxfs_rtrefcountbt_maxlevels_ondisk
 #define xfs_rtrefcountbt_maxrecs	libxfs_rtrefcountbt_maxrecs
+#define xfs_rtrefcountbt_stage_cursor	libxfs_rtrefcountbt_stage_cursor
 
 #define xfs_rtrmapbt_calc_reserves	libxfs_rtrmapbt_calc_reserves
 #define xfs_rtrmapbt_calc_size		libxfs_rtrmapbt_calc_size
diff --git a/repair/Makefile b/repair/Makefile
index 6f4ec3b3a9c4dc..ff5b1f5abedac0 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -73,6 +73,7 @@ CFILES = \
 	rcbag.c \
 	rmap.c \
 	rt.c \
+	rtrefcount_repair.c \
 	rtrmap_repair.c \
 	sb.c \
 	scan.c \
diff --git a/repair/agbtree.c b/repair/agbtree.c
index 01066130767cb6..983b645e1a35a3 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -730,7 +730,7 @@ init_refc_cursor(
 
 	/* Compute how many blocks we'll need. */
 	error = -libxfs_btree_bload_compute_geometry(btr->cur, &btr->bload,
-			refcount_record_count(sc->mp, agno));
+			refcount_record_count(sc->mp, false, agno));
 	if (error)
 		do_error(
 _("Unable to compute refcount btree geometry, error %d.\n"), error);
diff --git a/repair/phase5.c b/repair/phase5.c
index cacaf74dda3a60..4cf28d8ae1a250 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -705,7 +705,7 @@ are_packed_btrees_needed(
 	 * If we don't have inode-based metadata, we can let the AG btrees
 	 * pack as needed; there are no global space concerns here.
 	 */
-	if (!xfs_has_rtrmapbt(mp))
+	if (!xfs_has_rtrmapbt(mp) && !xfs_has_rtreflink(mp))
 		return false;
 
 	while ((pag = xfs_perag_next(mp, pag))) {
@@ -716,8 +716,10 @@ are_packed_btrees_needed(
 		fdblocks += ag_fdblocks;
 	}
 
-	while ((rtg = xfs_rtgroup_next(mp, rtg)))
+	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
 		metadata_blocks += estimate_rtrmapbt_blocks(rtg);
+		metadata_blocks += estimate_rtrefcountbt_blocks(rtg);
+	}
 
 	/*
 	 * If we think we'll have more metadata blocks than free space, then
diff --git a/repair/phase6.c b/repair/phase6.c
index 30ea19fda9fd87..4064a84b24509f 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -696,6 +696,15 @@ ensure_rtgroup_rmapbt(
 		populate_rtgroup_rmapbt(rtg, est_fdblocks);
 }
 
+static void
+ensure_rtgroup_refcountbt(
+	struct xfs_rtgroup	*rtg,
+	xfs_filblks_t		est_fdblocks)
+{
+	if (ensure_rtgroup_file(rtg, XFS_RTGI_REFCOUNT))
+		populate_rtgroup_refcountbt(rtg, est_fdblocks);
+}
+
 /* Initialize a root directory. */
 static int
 init_fs_root_dir(
@@ -3405,8 +3414,10 @@ reset_rt_metadir_inodes(
 	 * maximally.
 	 */
 	if (!need_packed_btrees) {
-		while ((rtg = xfs_rtgroup_next(mp, rtg)))
+		while ((rtg = xfs_rtgroup_next(mp, rtg))) {
 			metadata_blocks += estimate_rtrmapbt_blocks(rtg);
+			metadata_blocks += estimate_rtrefcountbt_blocks(rtg);
+		}
 
 		if (mp->m_sb.sb_fdblocks > metadata_blocks)
 			est_fdblocks = mp->m_sb.sb_fdblocks - metadata_blocks;
@@ -3427,6 +3438,7 @@ _("        - resetting contents of realtime bitmap and summary inodes\n"));
 		ensure_rtgroup_bitmap(rtg);
 		ensure_rtgroup_summary(rtg);
 		ensure_rtgroup_rmapbt(rtg, est_fdblocks);
+		ensure_rtgroup_refcountbt(rtg, est_fdblocks);
 	}
 }
 
diff --git a/repair/rmap.c b/repair/rmap.c
index 638e5ea92278cb..97510dd875911a 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1682,9 +1682,10 @@ _("Unable to fix reflink flag on inode %"PRIu64".\n"),
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
@@ -2081,3 +2082,22 @@ estimate_rtrmapbt_blocks(
 	nr_recs = xmbuf_bytes(x->ar_xmbtp) / sizeof(struct xfs_rmap_rec);
 	return libxfs_rtrmapbt_calc_size(mp, nr_recs);
 }
+
+/* Estimate the size of the ondisk rtrefcountbt from the incore data. */
+xfs_filblks_t
+estimate_rtrefcountbt_blocks(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_ag_rmap	*x;
+
+	if (!rmap_needs_work(mp) || !xfs_has_rtreflink(mp))
+		return 0;
+
+	x = &rg_rmaps[rtg_rgno(rtg)];
+	if (!x->ar_refcount_items)
+		return 0;
+
+	return libxfs_rtrefcountbt_calc_size(mp,
+			slab_count(x->ar_refcount_items));
+}
diff --git a/repair/rmap.h b/repair/rmap.h
index 80e82a4ac4c008..1f234b8be32e72 100644
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
@@ -64,4 +65,8 @@ void populate_rtgroup_rmapbt(struct xfs_rtgroup *rtg,
 		xfs_filblks_t est_fdblocks);
 xfs_filblks_t estimate_rtrmapbt_blocks(struct xfs_rtgroup *rtg);
 
+int populate_rtgroup_refcountbt(struct xfs_rtgroup *rtg,
+		xfs_filblks_t est_fdblocks);
+xfs_filblks_t estimate_rtrefcountbt_blocks(struct xfs_rtgroup *rtg);
+
 #endif /* RMAP_H_ */
diff --git a/repair/rtrefcount_repair.c b/repair/rtrefcount_repair.c
new file mode 100644
index 00000000000000..228d080e5a5dcb
--- /dev/null
+++ b/repair/rtrefcount_repair.c
@@ -0,0 +1,257 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2021-2025 Oracle.  All Rights Reserved.
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
+			refcount_record_count(sc->mp, true, rtg_rgno(rr->rtg)));
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
+	error = init_refcount_cursor(true, rtg_rgno(rr->rtg), &rr->slab_cursor);
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
+	cur = libxfs_rtrefcountbt_init_cursor(NULL, rr->rtg);
+	libxfs_btree_stage_ifakeroot(cur, ifake);
+
+	/*
+	 * Figure out the size and format of the new fork, then fill it with
+	 * all the rtrmap records we've found.  Join the inode to the
+	 * transaction so that we can roll the transaction while holding the
+	 * inode locked.
+	 */
+	libxfs_trans_ijoin(sc->tp, sc->ip, 0);
+	ifake->if_fork->if_format = XFS_DINODE_FMT_META_BTREE;
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
+	xfs_filblks_t		est_fdblocks)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_inode	*ip = rtg_refcount(rtg);
+	struct repair_ctx	sc = {
+		.mp		= mp,
+		.ip		= ip,
+	};
+	struct xrep_rtrefc	rr = {
+		.sc		= &sc,
+		.rtg		= rtg,
+		.est_fdblocks	= est_fdblocks,
+	};
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

