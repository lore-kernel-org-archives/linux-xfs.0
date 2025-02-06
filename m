Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6862417C8
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882513; cv=none; b=fZJULqlI9/UXLIpALI1uJkOdLqtWChNzFRjxOnngAZiIuoUbsMzxlQmr9WGm/KrKMXa4oTAe/vOoI+lmsX455XsMODQ5RfC03U/t7Rc9SU/9MAMMs+pT5Gxt6tATC4s/9TE0Wul1dq1l7BKwXlh0QdLEpikN4W+HHaoB/i6tSB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882513; c=relaxed/simple;
	bh=1A/LinvrIjdLccyR/Pk4gOrrIQyfcZOCOhZYuxkc2zc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uL1X6NU2JLs4dTImyVw7kmBmW4I/MGv42GD0g6Ei0G5wGeZLZemS0qp4RQx+nBVMDi7Dkowx+ROyj6avp5d15k5XrosQKFhmSZ7tujWmxY0BEhS6JqhTKOawV/LM8l4paThR1fGT0viTltkFPr4RU4kfPQ2CB6paMd5QOYgEcOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A9agdovR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A9agdovR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93CBC4CEDF;
	Thu,  6 Feb 2025 22:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882513;
	bh=1A/LinvrIjdLccyR/Pk4gOrrIQyfcZOCOhZYuxkc2zc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=A9agdovR+1TVjMQBLAVfZKLnsRkigHSdEl7OkrJvwNu7Jv+B2wtu4vUr5yfW5gZgW
	 EE3TXqEAuIiv+jqmmaBQVyAnDjIfybbPg2JF590PtTsH6hqApfktHrlzahrMAlBZsy
	 kBllMbx9iGAHYNqMqUH8HV6VxERqG3tJ6d16A+jIPtcYD4EzpL801D969VkC47jomh
	 AD8IEdrD3h3bOqpDOD9ioVn1dFoa7+8QWer0e24YfXnG5PpjQ725Ug1pjHbVjackRV
	 qmxVfTavT8sHbhlWW217JLoW5hOSbd6h1MW8pz4ZWpDWl6Ht8KwIj/MgC2y3fDuOEn
	 w8p7oNcog0+nA==
Date: Thu, 06 Feb 2025 14:55:12 -0800
Subject: [PATCH 21/27] xfs_repair: rebuild the realtime rmap btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088417.2741033.9023081378772193251.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    8 +
 repair/Makefile          |    1 
 repair/bulkload.c        |   41 +++++++
 repair/bulkload.h        |    2 
 repair/phase6.c          |   21 ++++
 repair/rmap.c            |   26 +++++
 repair/rmap.h            |    1 
 repair/rtrmap_repair.c   |  265 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/xfs_repair.c      |    8 +
 9 files changed, 371 insertions(+), 2 deletions(-)
 create mode 100644 repair/rtrmap_repair.c


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index b62efad757470b..193b1eeaa7537e 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -278,6 +278,7 @@
 #define xfs_rmap_irec_offset_unpack	libxfs_rmap_irec_offset_unpack
 #define xfs_rmap_lookup_le		libxfs_rmap_lookup_le
 #define xfs_rmap_lookup_le_range	libxfs_rmap_lookup_le_range
+#define xfs_rmap_map_extent		libxfs_rmap_map_extent
 #define xfs_rmap_map_raw		libxfs_rmap_map_raw
 #define xfs_rmap_query_all		libxfs_rmap_query_all
 #define xfs_rmap_query_range		libxfs_rmap_query_range
@@ -295,9 +296,12 @@
 #define xfs_rtginode_name		libxfs_rtginode_name
 #define xfs_rtsummary_create		libxfs_rtsummary_create
 
+#define xfs_rtginode_create		libxfs_rtginode_create
 #define xfs_rtginode_irele		libxfs_rtginode_irele
 #define xfs_rtginode_load		libxfs_rtginode_load
 #define xfs_rtginode_load_parent	libxfs_rtginode_load_parent
+#define xfs_rtginode_mkdir_parent	libxfs_rtginode_mkdir_parent
+#define xfs_rtginode_name		libxfs_rtginode_name
 #define xfs_rtgroup_alloc		libxfs_rtgroup_alloc
 #define xfs_rtgroup_extents		libxfs_rtgroup_extents
 #define xfs_rtgroup_grab		libxfs_rtgroup_grab
@@ -314,12 +318,16 @@
 #define xfs_rtgroup_get			libxfs_rtgroup_get
 #define xfs_rtgroup_put			libxfs_rtgroup_put
 #define xfs_rtrmapbt_calc_reserves	libxfs_rtrmapbt_calc_reserves
+#define xfs_rtrmapbt_calc_size		libxfs_rtrmapbt_calc_size
+#define xfs_rtrmapbt_commit_staged_btree	libxfs_rtrmapbt_commit_staged_btree
+#define xfs_rtrmapbt_create		libxfs_rtrmapbt_create
 #define xfs_rtrmapbt_droot_maxrecs	libxfs_rtrmapbt_droot_maxrecs
 #define xfs_rtrmapbt_maxlevels_ondisk	libxfs_rtrmapbt_maxlevels_ondisk
 #define xfs_rtrmapbt_init_cursor	libxfs_rtrmapbt_init_cursor
 #define xfs_rtrmapbt_maxrecs		libxfs_rtrmapbt_maxrecs
 #define xfs_rtrmapbt_mem_init		libxfs_rtrmapbt_mem_init
 #define xfs_rtrmapbt_mem_cursor		libxfs_rtrmapbt_mem_cursor
+#define xfs_rtrmapbt_stage_cursor	libxfs_rtrmapbt_stage_cursor
 
 #define xfs_sb_from_disk		libxfs_sb_from_disk
 #define xfs_sb_mount_rextsize		libxfs_sb_mount_rextsize
diff --git a/repair/Makefile b/repair/Makefile
index a36a95e353a504..6f4ec3b3a9c4dc 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -73,6 +73,7 @@ CFILES = \
 	rcbag.c \
 	rmap.c \
 	rt.c \
+	rtrmap_repair.c \
 	sb.c \
 	scan.c \
 	slab.c \
diff --git a/repair/bulkload.c b/repair/bulkload.c
index aada5bbae579f8..a9e51de0a24c17 100644
--- a/repair/bulkload.c
+++ b/repair/bulkload.c
@@ -361,3 +361,44 @@ bulkload_estimate_ag_slack(
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
index a88aafaa678a3a..842121b15190e7 100644
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
index 7d2e0554594265..cae9d970481840 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -21,6 +21,8 @@
 #include "repair/pptr.h"
 #include "repair/rt.h"
 #include "repair/quotacheck.h"
+#include "repair/slab.h"
+#include "repair/rmap.h"
 
 static xfs_ino_t		orphanage_ino;
 
@@ -685,6 +687,15 @@ ensure_rtgroup_summary(
 	fill_rtsummary(rtg);
 }
 
+static void
+ensure_rtgroup_rmapbt(
+	struct xfs_rtgroup	*rtg,
+	xfs_filblks_t		est_fdblocks)
+{
+	if (ensure_rtgroup_file(rtg, XFS_RTGI_RMAP))
+		populate_rtgroup_rmapbt(rtg, est_fdblocks);
+}
+
 /* Initialize a root directory. */
 static int
 init_fs_root_dir(
@@ -3365,6 +3376,8 @@ reset_rt_metadir_inodes(
 	struct xfs_mount	*mp)
 {
 	struct xfs_rtgroup	*rtg = NULL;
+	xfs_filblks_t		metadata_blocks = 0;
+	xfs_filblks_t		est_fdblocks = 0;
 	int			error;
 
 	/*
@@ -3386,6 +3399,13 @@ reset_rt_metadir_inodes(
 		mark_ino_metadata(mp, mp->m_rtdirip->i_ino);
 	}
 
+	/* Estimate how much free space will be left after building btrees */
+	while ((rtg = xfs_rtgroup_next(mp, rtg)))
+		metadata_blocks += estimate_rtrmapbt_blocks(rtg);
+
+	if (mp->m_sb.sb_fdblocks > metadata_blocks)
+		est_fdblocks = mp->m_sb.sb_fdblocks - metadata_blocks;
+
 	/*
 	 * This isn't the whole story, but it keeps the message that we've had
 	 * for years and which is expected in xfstests and more.
@@ -3400,6 +3420,7 @@ _("        - resetting contents of realtime bitmap and summary inodes\n"));
 	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
 		ensure_rtgroup_bitmap(rtg);
 		ensure_rtgroup_summary(rtg);
+		ensure_rtgroup_rmapbt(rtg, est_fdblocks);
 	}
 }
 
diff --git a/repair/rmap.c b/repair/rmap.c
index a40851b4d0dc69..85a65048db9afc 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1940,3 +1940,29 @@ estimate_refcountbt_blocks(
 	return libxfs_refcountbt_calc_size(mp,
 			slab_count(x->ar_refcount_items));
 }
+
+/* Estimate the size of the ondisk rtrmapbt from the incore tree. */
+xfs_filblks_t
+estimate_rtrmapbt_blocks(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_ag_rmap	*x;
+	unsigned long long	nr_recs;
+
+	if (!rmap_needs_work(mp) || !xfs_has_rtrmapbt(mp))
+		return 0;
+
+	/*
+	 * Overestimate the amount of space needed by pretending that every
+	 * byte in the incore tree is used to store rtrmapbt records.  This
+	 * means we can use SEEK_DATA/HOLE on the xfile, which is faster than
+	 * walking the entire btree.
+	 */
+	x = &rg_rmaps[rtg_rgno(rtg)];
+	if (!rmaps_has_observations(x))
+		return 0;
+
+	nr_recs = xmbuf_bytes(x->ar_xmbtp) / sizeof(struct xfs_rmap_rec);
+	return libxfs_rtrmapbt_calc_size(mp, nr_recs);
+}
diff --git a/repair/rmap.h b/repair/rmap.h
index ebda561e59bc8f..23859bf6c2ad42 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -60,5 +60,6 @@ int rmap_get_mem_rec(struct xfs_btree_cur *rmcur, struct xfs_rmap_irec *irec);
 
 void populate_rtgroup_rmapbt(struct xfs_rtgroup *rtg,
 		xfs_filblks_t est_fdblocks);
+xfs_filblks_t estimate_rtrmapbt_blocks(struct xfs_rtgroup *rtg);
 
 #endif /* RMAP_H_ */
diff --git a/repair/rtrmap_repair.c b/repair/rtrmap_repair.c
new file mode 100644
index 00000000000000..2b07e8943e591d
--- /dev/null
+++ b/repair/rtrmap_repair.c
@@ -0,0 +1,265 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2019-2025 Oracle.  All Rights Reserved.
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
+	struct xfs_btree_cur	*btree_cursor;
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
+		ret = rmap_get_mem_rec(rr->btree_cursor, &cur->bc_rec.r);
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
+			rmap_record_count(sc->mp, true, rtg_rgno(rr->rtg)));
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
+			rtg_rgno(rr->rtg), &rr->btree_cursor);
+	if (error)
+		return error;
+	error = -libxfs_btree_bload(rtrmap_cur, &rr->rtrmap_bload, rr);
+	libxfs_btree_del_cursor(rr->btree_cursor, error);
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
+	cur = libxfs_rtrmapbt_init_cursor(NULL, rr->rtg);
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
+void
+populate_rtgroup_rmapbt(
+	struct xfs_rtgroup	*rtg,
+	xfs_filblks_t		est_fdblocks)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_inode	*ip = rtg_rmap(rtg);
+	struct repair_ctx	sc = {
+		.mp		= mp,
+		.ip		= ip,
+	};
+	struct xrep_rtrmap	rr = {
+		.sc		= &sc,
+		.rtg		= rtg,
+		.est_fdblocks	= est_fdblocks,
+	};
+	int			error;
+
+	if (!xfs_has_rtrmapbt(mp))
+		return;
+
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0,
+			&sc.tp);
+	if (error)
+		goto out;
+
+	error = xrep_rtrmap_build_new_tree(&rr);
+	if (error) {
+		libxfs_trans_cancel(sc.tp);
+		goto out;
+	}
+
+	error = -libxfs_trans_commit(sc.tp);
+out:
+	if (error)
+		do_error(
+ _("rtgroup %u rmap btree could not be rebuilt, error %d\n"),
+			rtg_rgno(rtg), error);
+}
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 9509f04685c870..eeaaf643468941 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1385,15 +1385,19 @@ main(int argc, char **argv)
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
 		phase_end(mp, 6);
 
+		if (mp->m_sb.sb_rblocks != 0)
+			rmaps_free(mp);
 		free_rtgroup_inodes();
 
 		phase7(mp, phase2_threads);

