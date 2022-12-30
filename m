Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F178C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236250AbiLaCv5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:51:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236294AbiLaCvz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:51:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D405112AD7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:51:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EABEB81E70
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03309C433EF;
        Sat, 31 Dec 2022 02:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455110;
        bh=sGVilUSSPdZMT7MjK/hm5mWixYXvUfCogDVIfqaKXMo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VVrm1GgpvFNthGtNWNXAf/7lzvBgRq6Hkx5TYDvZK+AhOzEk7uimP4Cto82oX6h+t
         48J4a6iY22xuwUPdCCaHcnM5qjOQp85AZjJH12YKDOLZ1pv6ziztkJaueD3Y6rB229
         jBMjBJHzemLK7WXrZlqV9HZpp6zWb2xlgieMgRiEaWL3yfONfqjT2nJiP7y4Swsnht
         mfhZNdkrLbu2ug90MwTBcmh9c+HDkqKQWxwtcFWQPe0u6S9KzvAeIPmJtunXvXN7Mk
         hR3SoAi3Z11tcWy90OocW2omLRMWiP4lQ9NyIbdpYL6H4sXD5LHUhX9PxW9S6OiUrd
         Upn6foyxKQAcw==
Subject: [PATCH 36/41] xfs_repair: rebuild the realtime rmap btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:00 -0800
Message-ID: <167243880072.732820.11114261384518244943.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Rebuild the realtime rmap btree file from the reverse mapping records we
gathered from walking the inodes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    4 +
 repair/Makefile          |    1 
 repair/phase6.c          |  131 ++++++++++++++++++++++++
 repair/rmap.h            |    1 
 repair/rtrmap_repair.c   |  253 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/xfs_repair.c      |    8 +
 6 files changed, 396 insertions(+), 2 deletions(-)
 create mode 100644 repair/rtrmap_repair.c


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 2a07a717215..ee864911e5e 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -228,6 +228,7 @@
 #define xfs_rmap_irec_offset_unpack	libxfs_rmap_irec_offset_unpack
 #define xfs_rmap_lookup_le		libxfs_rmap_lookup_le
 #define xfs_rmap_lookup_le_range	libxfs_rmap_lookup_le_range
+#define xfs_rmap_map_extent		libxfs_rmap_map_extent
 #define xfs_rmap_map_raw		libxfs_rmap_map_raw
 #define xfs_rmap_query_all		libxfs_rmap_query_all
 #define xfs_rmap_query_range		libxfs_rmap_query_range
@@ -245,6 +246,8 @@
 #define xfs_rtgroup_put			libxfs_rtgroup_put
 #define xfs_rtgroup_update_secondary_sbs	libxfs_rtgroup_update_secondary_sbs
 #define xfs_rtgroup_update_super	libxfs_rtgroup_update_super
+#define xfs_rtrmapbt_commit_staged_btree	libxfs_rtrmapbt_commit_staged_btree
+#define xfs_rtrmapbt_create		libxfs_rtrmapbt_create
 #define xfs_rtrmapbt_create_path	libxfs_rtrmapbt_create_path
 #define xfs_rtrmapbt_droot_maxrecs	libxfs_rtrmapbt_droot_maxrecs
 #define xfs_rtrmapbt_maxlevels_ondisk	libxfs_rtrmapbt_maxlevels_ondisk
@@ -252,6 +255,7 @@
 #define xfs_rtrmapbt_maxrecs		libxfs_rtrmapbt_maxrecs
 #define xfs_rtrmapbt_mem_create		libxfs_rtrmapbt_mem_create
 #define xfs_rtrmapbt_mem_cursor		libxfs_rtrmapbt_mem_cursor
+#define xfs_rtrmapbt_stage_cursor	libxfs_rtrmapbt_stage_cursor
 
 #define xfs_sb_from_disk		libxfs_sb_from_disk
 #define xfs_sb_quota_from_disk		libxfs_sb_quota_from_disk
diff --git a/repair/Makefile b/repair/Makefile
index 250c86cca2d..c7e09732800 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -70,6 +70,7 @@ CFILES = \
 	rcbag.c \
 	rmap.c \
 	rt.c \
+	rtrmap_repair.c \
 	sb.c \
 	scan.c \
 	slab.c \
diff --git a/repair/phase6.c b/repair/phase6.c
index 1dbd600915d..d5381e1eddc 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -18,6 +18,8 @@
 #include "dinode.h"
 #include "progress.h"
 #include "versions.h"
+#include "slab.h"
+#include "rmap.h"
 
 static xfs_ino_t		orphanage_ino;
 
@@ -1033,6 +1035,121 @@ _("Couldn't find realtime summary parent, error %d\n"),
 	libxfs_irele(ip);
 }
 
+static void
+ensure_rtgroup_rmapbt(
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
+_("Couldn't create rtgroup %u rmap file path, err %d\n"),
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
+_("Couldn't find rtgroup %u rmap inode parent, error %d\n"),
+				rtg->rtg_rgno, error);
+
+	/* Create a transaction for whatever work we end up doing. */
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_imeta_create,
+			libxfs_imeta_create_space_res(mp), 0, 0, &tp);
+	if (error)
+		do_error(
+_("Couldn't prepare to attach rtgroup %u rmap inode, error %d\n"),
+				rtg->rtg_rgno, error);
+
+	if (ino != NULLFSINO) {
+		/*
+		 * We're still hanging on to our old inode, so reconnect it to
+		 * the metadata directory tree.
+		 */
+		error = -libxfs_imeta_iget(mp, ino, XFS_DIR3_FT_REG_FILE, &ip);
+		if (error) {
+			do_warn(
+_("Couldn't iget rtgroup %u rmap inode 0x%llx, error %d\n"),
+					rtg->rtg_rgno, (unsigned long long)ino,
+					error);
+			goto zap;
+		}
+
+		error = -libxfs_imeta_link(tp, path, ip, &upd);
+		if (error)
+			do_error(
+_("Failed to link rtgroup %u rmapbt inode 0x%llx, error %d\n"),
+					rtg->rtg_rgno,
+					(unsigned long long)ip->i_ino,
+					error);
+
+		set_nlink(VFS_I(ip), 1);
+		ip->i_df.if_format = XFS_DINODE_FMT_RMAP;
+		libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	} else {
+zap:
+		/*
+		 * The rtrmap inode was bad or gone, so just make a new one
+		 * and give our reference to the rtgroup structure.
+		 */
+		error = -libxfs_rtrmapbt_create(&tp, path, &upd, &ip);
+		if (error)
+			do_error(
+_("Couldn't create rtgroup %u rmap inode, error %d\n"),
+					rtg->rtg_rgno, error);
+	}
+
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(
+_("Couldn't commit new rtgroup %u rmap inode %llu, error %d\n"),
+				rtg->rtg_rgno,
+				(unsigned long long)ip->i_ino,
+				error);
+
+	/* Mark the inode in use. */
+	mark_ino_inuse(mp, ip->i_ino, S_IFREG, upd.dp->i_ino);
+	mark_ino_metadata(mp, ip->i_ino);
+	libxfs_imeta_end_update(mp, &upd, error);
+
+	/* Copy our incore rmap data to the ondisk rmap inode. */
+	error = populate_rtgroup_rmapbt(rtg, ip);
+	if (error)
+		do_error(
+_("rtgroup %u rmap btree could not be rebuilt, error %d\n"),
+				rtg->rtg_rgno, error);
+
+	libxfs_imeta_free_path(path);
+	libxfs_imeta_irele(ip);
+}
+
 /* Initialize a root directory. */
 static int
 init_fs_root_dir(
@@ -3684,6 +3801,18 @@ traverse_ags(
 	do_inode_prefetch(mp, ag_stride, traverse_function, false, true);
 }
 
+static void
+reset_rt_metadata_inodes(
+	struct xfs_mount	*mp)
+{
+	struct xfs_rtgroup	*rtg;
+	xfs_rgnumber_t		rgno;
+
+	for_each_rtgroup(mp, rgno, rtg) {
+		ensure_rtgroup_rmapbt(rtg);
+	}
+}
+
 void
 phase6(xfs_mount_t *mp)
 {
@@ -3747,6 +3876,8 @@ phase6(xfs_mount_t *mp)
 		}
 	}
 
+	reset_rt_metadata_inodes(mp);
+
 	if (!no_modify)  {
 		do_log(
 _("        - resetting contents of realtime bitmap and summary inodes\n"));
diff --git a/repair/rmap.h b/repair/rmap.h
index c7c09046a8a..64a85b32341 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -64,5 +64,6 @@ int rmap_get_mem_rec(struct rmap_mem_cur *rmcur, struct xfs_rmap_irec *irec);
 
 bool is_rtrmap_inode(xfs_ino_t ino);
 xfs_ino_t rtgroup_rmap_ino(struct xfs_rtgroup *rtg);
+int populate_rtgroup_rmapbt(struct xfs_rtgroup *rtg, struct xfs_inode *ip);
 
 #endif /* RMAP_H_ */
diff --git a/repair/rtrmap_repair.c b/repair/rtrmap_repair.c
new file mode 100644
index 00000000000..d9a0083e298
--- /dev/null
+++ b/repair/rtrmap_repair.c
@@ -0,0 +1,253 @@
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
+	bulkload_estimate_inode_slack(sc->mp, &rr->rtrmap_bload);
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
+	error = bulkload_alloc_blocks(&rr->new_fork_info,
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
+/* Store the realtime reverse-mappings in the rtrmapbt. */
+int
+populate_rtgroup_rmapbt(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_inode	*ip)
+{
+	struct repair_ctx	sc = {
+		.mp		= rtg->rtg_mount,
+		.ip		= ip,
+	};
+	struct xrep_rtrmap	rr = {
+		.sc		= &sc,
+		.rtg		= rtg,
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
index 13e1f2deccf..78129218877 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1381,13 +1381,17 @@ main(int argc, char **argv)
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

