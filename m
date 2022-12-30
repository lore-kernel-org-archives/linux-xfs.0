Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C2FCC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236298AbiLaDDg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236258AbiLaDDe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:03:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2003815816
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:03:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8F01B81E9A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68635C433D2;
        Sat, 31 Dec 2022 03:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455810;
        bh=QiqTXPepr7zJQb2E2m5IZheZwsa4f9lCycqv3U0TeM4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iJpo8EVyrSiDrEMvOW7wJa02xzHdPawNAtdFGQUMf7wxHoEWCobxcyBqzZ2cw1EUM
         ba0y0jf213T4a6h66fODCuO55H/HCNwHYz/3KnseOPixoMzG9Lw6PdZfGn4GvWBkUS
         tczFJz30kRfCr3zYnuCIhhCy1BZg/d/9xuTnSU0Z8eUjMj2Q6wNLvxKnEHOYQzvcFw
         3uGsaQmfkG8XlhoRa62J3/ikbFDAyVS6nLl7SfPwZBxTMSudxXkEVk7Ne5EH4dX9sL
         ScsPyij2nAZ6lwaoFpcrQhdDb/4CRttNEJUS/ao4UFqnnhNXqh6IcAtzvyzjPPK5Os
         z+Oas5aEl+5SA==
Subject: [PATCH 36/41] xfs_repair: rebuild the realtime refcount btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:12 -0800
Message-ID: <167243881246.734096.16760380335738812271.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use the collected reference count information to rebuild the btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h   |    4 +
 repair/Makefile            |    1 
 repair/agbtree.c           |    2 
 repair/phase6.c            |  115 ++++++++++++++++++++
 repair/rmap.c              |   12 ++
 repair/rmap.h              |    5 +
 repair/rtrefcount_repair.c |  248 ++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 384 insertions(+), 3 deletions(-)
 create mode 100644 repair/rtrefcount_repair.c


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 7f52993aee4..5c7396a53a6 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -250,11 +250,15 @@
 #define xfs_rtgroup_update_secondary_sbs	libxfs_rtgroup_update_secondary_sbs
 #define xfs_rtgroup_update_super	libxfs_rtgroup_update_super
 
+#define xfs_rtrefcountbt_absolute_maxlevels	libxfs_rtrefcountbt_absolute_maxlevels
+#define xfs_rtrefcountbt_commit_staged_btree	libxfs_rtrefcountbt_commit_staged_btree
+#define xfs_rtrefcountbt_create		libxfs_rtrefcountbt_create
 #define xfs_rtrefcountbt_create_path	libxfs_rtrefcountbt_create_path
 #define xfs_rtrefcountbt_droot_maxrecs	libxfs_rtrefcountbt_droot_maxrecs
 #define xfs_rtrefcountbt_init_cursor	libxfs_rtrefcountbt_init_cursor
 #define xfs_rtrefcountbt_maxlevels_ondisk	libxfs_rtrefcountbt_maxlevels_ondisk
 #define xfs_rtrefcountbt_maxrecs	libxfs_rtrefcountbt_maxrecs
+#define xfs_rtrefcountbt_stage_cursor	libxfs_rtrefcountbt_stage_cursor
 
 #define xfs_rtrmapbt_calc_reserves	libxfs_rtrmapbt_calc_reserves
 #define xfs_rtrmapbt_commit_staged_btree	libxfs_rtrmapbt_commit_staged_btree
diff --git a/repair/Makefile b/repair/Makefile
index c7e09732800..0f2b05c4532 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -70,6 +70,7 @@ CFILES = \
 	rcbag.c \
 	rmap.c \
 	rt.c \
+	rtrefcount_repair.c \
 	rtrmap_repair.c \
 	sb.c \
 	scan.c \
diff --git a/repair/agbtree.c b/repair/agbtree.c
index 1eabce0104f..80d6d6710ce 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -721,7 +721,7 @@ init_refc_cursor(
 
 	/* Compute how many blocks we'll need. */
 	error = -libxfs_btree_bload_compute_geometry(btr->cur, &btr->bload,
-			refcount_record_count(sc->mp, agno));
+			refcount_record_count(sc->mp, false, agno));
 	if (error)
 		do_error(
 _("Unable to compute refcount btree geometry, error %d.\n"), error);
diff --git a/repair/phase6.c b/repair/phase6.c
index 890bb20bce1..bb123919932 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1096,6 +1096,120 @@ _("rtgroup %u rmap btree could not be rebuilt, error %d\n"),
 	libxfs_imeta_irele(ip);
 }
 
+static void
+ensure_rtgroup_refcountbt(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_mount	*mp = rtg->rtg_mount;
+	struct xfs_trans	*tp;
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
+_("Couldn't create rtgroup %u refcount file path, err %d\n"),
+				rtg->rtg_rgno, error);
+
+	error = ensure_imeta_dirpath(mp, path);
+	if (error)
+		do_error(
+_("Couldn't create rtgroup %u metadata directory, error %d\n"),
+				rtg->rtg_rgno, error);
+
+	error = -libxfs_imeta_start_update(mp, path, &upd);
+	if (error)
+		do_error(
+_("Couldn't find rtgroup %u refcountbt parent, error %d\n"),
+				rtg->rtg_rgno, error);
+
+	/* Create a transaction for whatever work we end up doing. */
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_imeta_create,
+			libxfs_imeta_create_space_res(mp), 0, 0, &tp);
+	if (error)
+		do_error(
+_("Couldn't prepare to attach rtgroup %u refcountbt inode, error %d\n"),
+				rtg->rtg_rgno, error);
+
+	if (ino != NULLFSINO) {
+		/*
+		 * We're still hanging on to our old inode, so try to grab it
+		 * so that we can reconnect it and reconnect it to the metadata
+		 * directory tree.
+		 */
+		error = -libxfs_imeta_iget(mp, ino, XFS_DIR3_FT_REG_FILE, &ip);
+		if (error) {
+			do_warn(
+_("Couldn't iget rtgroup %u refcountbt inode 0x%llx, error %d\n"),
+					rtg->rtg_rgno, (unsigned long long)ino,
+					error);
+			goto zap;
+		}
+
+		error = -libxfs_imeta_link(tp, path, ip, &upd);
+		if (error)
+			do_error(
+_("Failed to link rtgroup %u refcountbt inode 0x%llx, error %d\n"),
+					rtg->rtg_rgno, (unsigned long long)ino,
+					error);
+
+		set_nlink(VFS_I(ip), 1);
+		ip->i_df.if_format = XFS_DINODE_FMT_REFCOUNT;
+		libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	} else {
+zap:
+		/*
+		 * The rtrefcount inode was bad or gone, so just make a new one
+		 * and give our reference to the rtgroup structure.
+		 */
+		error = -libxfs_rtrefcountbt_create(&tp, path, &upd, &ip);
+		if (error)
+			do_error(
+_("Couldn't create rtgroup %u refcountbt inode, error %d\n"),
+					rtg->rtg_rgno, error);
+	}
+
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(
+_("Couldn't commit new rtgroup %u refcountbt inode %llu, error %d\n"),
+				rtg->rtg_rgno, (unsigned long long)ip->i_ino,
+				error);
+
+	/* Mark the inode in use. */
+	mark_ino_inuse(mp, ip->i_ino, S_IFREG, upd.dp->i_ino);
+	mark_ino_metadata(mp, ip->i_ino);
+	libxfs_imeta_end_update(mp, &upd, error);
+
+	/* Copy our incore refcount data to the ondisk refcount inode. */
+	error = populate_rtgroup_refcountbt(rtg, ip);
+	if (error)
+		do_error(
+_("rtgroup %u refcount btree could not be rebuilt, error %d\n"),
+				rtg->rtg_rgno, error);
+
+	libxfs_imeta_free_path(path);
+	libxfs_imeta_irele(ip);
+}
+
 /* Initialize a root directory. */
 static int
 init_fs_root_dir(
@@ -3756,6 +3870,7 @@ reset_rt_metadata_inodes(
 
 	for_each_rtgroup(mp, rgno, rtg) {
 		ensure_rtgroup_rmapbt(rtg);
+		ensure_rtgroup_refcountbt(rtg);
 	}
 }
 
diff --git a/repair/rmap.c b/repair/rmap.c
index 21062e4ac49..0c7faa9ad08 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1871,9 +1871,10 @@ _("Unable to fix reflink flag on inode %"PRIu64".\n"),
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
@@ -2219,3 +2220,12 @@ rtgroup_rmap_ino(
 
 	return ar->rg_rmap_ino;
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
diff --git a/repair/rmap.h b/repair/rmap.h
index 9e7a4968588..7e23e650246 100644
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
@@ -71,5 +72,7 @@ int populate_rtgroup_rmapbt(struct xfs_rtgroup *rtg, struct xfs_inode *ip);
 xfs_rgnumber_t rtgroup_for_rtrefcount_inode(struct xfs_mount *mp,
 		xfs_ino_t ino);
 bool is_rtrefcount_ino(xfs_ino_t ino);
+xfs_ino_t rtgroup_refcount_ino(struct xfs_rtgroup *rtg);
+int populate_rtgroup_refcountbt(struct xfs_rtgroup *rtg, struct xfs_inode *ip);
 
 #endif /* RMAP_H_ */
diff --git a/repair/rtrefcount_repair.c b/repair/rtrefcount_repair.c
new file mode 100644
index 00000000000..04f61f1bbc4
--- /dev/null
+++ b/repair/rtrefcount_repair.c
@@ -0,0 +1,248 @@
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
+	bulkload_estimate_inode_slack(sc->mp, &rr->rtrefc_bload);
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
+	error = bulkload_alloc_blocks(&rr->new_fork_info,
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
+	bulkload_destroy(&rr->new_fork_info, error);
+
+	return -libxfs_trans_roll_inode(&sc->tp, sc->ip);
+err_cur:
+	if (cur)
+		libxfs_btree_del_cursor(cur, error);
+err_newbt:
+	bulkload_destroy(&rr->new_fork_info, error);
+	return error;
+}
+
+/* Store the realtime reference counts in the rtrefcbt. */
+int
+populate_rtgroup_refcountbt(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_inode	*ip)
+{
+	struct repair_ctx	sc = {
+		.mp		= rtg->rtg_mount,
+		.ip		= ip,
+	};
+	struct xrep_rtrefc	rr = {
+		.sc		= &sc,
+		.rtg		= rtg,
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

