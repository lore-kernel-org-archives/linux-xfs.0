Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63268C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:50:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbiF1UuB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiF1UuB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:50:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E66A31202
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:50:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A95BB82013
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B448C341C8;
        Tue, 28 Jun 2022 20:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449397;
        bh=mpNvNTR7LooM2/xGePLAigcqEuDDa+mkjO6rQysBwqc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=INtChioJm1D2IeVPFi/kDES0fOVrV8ZTH+JpBZv2RWWvlbf7tR9kreevNfijamgPr
         xeYObTCMHJX8gsgpb6f8w22moGwaW9kNb1FB+Fokw0FQN0tqylpQLuR2ZfmdEqeGfr
         hr0RQYBWHSH/8Fmj8SuTE4xN+pW0CbBfkNd4LjVl8YGqEZn3Rfqx83QUIzBq1DIaUC
         E3nE3dV2qslt9cU54EGNkSq9o+3bvvrlMLrVZ/OkqbNyLSmEPSywibvl3XCbObiUZr
         egwmbhd/3EeiOjWAb7aO7wCEq+meE4Hth9VbCUnoWLofXOGKZtiIKtyd5dObiA99yY
         ddhdhtUPjOoWw==
Subject: [PATCH 1/2] xfs_repair: check filesystem geometry before allowing
 upgrades
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:49:56 -0700
Message-ID: <165644939676.1091400.13819613045283184204.stgit@magnolia>
In-Reply-To: <165644939119.1091400.7396096341976707391.stgit@magnolia>
References: <165644939119.1091400.7396096341976707391.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, the two V5 feature upgrades permitted by xfs_repair do not
affect filesystem space usage, so we haven't needed to verify the
geometry.

However, this will change once we start to allow the sysadmin to add new
metadata indexes to existing filesystems.  Add all the infrastructure we
need to ensure that the log will still be large enough, that there's
enough space for metadata space reservations, and the root inode will
still be where we expect it to be after the upgrade.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
[david: Recompute transaction reservation values; Exit with error if upgrade fails]
Signed-off-by: Dave Chinner <david@fromorbit.com>
[djwong: Refuse to upgrade if any part of the fs has < 10% free]
---
 include/libxfs.h         |    1 
 include/xfs_mount.h      |    1 
 libxfs/init.c            |   24 ++++-
 libxfs/libxfs_api_defs.h |    3 +
 repair/phase2.c          |  210 ++++++++++++++++++++++++++++++++++++++++++++--
 5 files changed, 222 insertions(+), 17 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index 915bf511..7d6e9a33 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -77,6 +77,7 @@ struct iomap;
 #include "xfs_refcount_btree.h"
 #include "xfs_refcount.h"
 #include "xfs_btree_staging.h"
+#include "xfs_ag_resv.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index ba80aa79..24b1d873 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -259,6 +259,7 @@ __XFS_UNSUPP_OPSTATE(shutdown)
 
 #define LIBXFS_BHASHSIZE(sbp) 		(1<<10)
 
+void libxfs_compute_all_maxlevels(struct xfs_mount *mp);
 struct xfs_mount *libxfs_mount(struct xfs_mount *mp, struct xfs_sb *sb,
 		dev_t dev, dev_t logdev, dev_t rtdev, unsigned int flags);
 int libxfs_flush_mount(struct xfs_mount *mp);
diff --git a/libxfs/init.c b/libxfs/init.c
index a01a41b2..15052696 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -728,6 +728,21 @@ xfs_agbtree_compute_maxlevels(
 	mp->m_agbtree_maxlevels = max(levels, mp->m_refc_maxlevels);
 }
 
+/* Compute maximum possible height of all btrees. */
+void
+libxfs_compute_all_maxlevels(
+	struct xfs_mount	*mp)
+{
+	xfs_alloc_compute_maxlevels(mp);
+	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
+	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
+	xfs_ialloc_setup_geometry(mp);
+	xfs_rmapbt_compute_maxlevels(mp);
+	xfs_refcountbt_compute_maxlevels(mp);
+
+	xfs_agbtree_compute_maxlevels(mp);
+}
+
 /*
  * Mount structure initialization, provides a filled-in xfs_mount_t
  * such that the numerous XFS_* macros can be used.  If dev is zero,
@@ -772,14 +787,7 @@ libxfs_mount(
 		mp->m_swidth = sbp->sb_width;
 	}
 
-	xfs_alloc_compute_maxlevels(mp);
-	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
-	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
-	xfs_ialloc_setup_geometry(mp);
-	xfs_rmapbt_compute_maxlevels(mp);
-	xfs_refcountbt_compute_maxlevels(mp);
-
-	xfs_agbtree_compute_maxlevels(mp);
+	libxfs_compute_all_maxlevels(mp);
 
 	/*
 	 * Check that the data (and log if separate) are an ok size.
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 370ad8b3..824f2c4d 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -21,6 +21,8 @@
 
 #define xfs_ag_init_headers		libxfs_ag_init_headers
 #define xfs_ag_block_count		libxfs_ag_block_count
+#define xfs_ag_resv_init		libxfs_ag_resv_init
+#define xfs_ag_resv_free		libxfs_ag_resv_free
 
 #define xfs_alloc_ag_max_usable		libxfs_alloc_ag_max_usable
 #define xfs_allocbt_maxlevels_ondisk	libxfs_allocbt_maxlevels_ondisk
@@ -112,6 +114,7 @@
 #define xfs_highbit64			libxfs_highbit64
 #define xfs_ialloc_calc_rootino		libxfs_ialloc_calc_rootino
 #define xfs_iallocbt_maxlevels_ondisk	libxfs_iallocbt_maxlevels_ondisk
+#define xfs_ialloc_read_agi		libxfs_ialloc_read_agi
 #define xfs_idata_realloc		libxfs_idata_realloc
 #define xfs_idestroy_fork		libxfs_idestroy_fork
 #define xfs_iext_lookup_extent		libxfs_iext_lookup_extent
diff --git a/repair/phase2.c b/repair/phase2.c
index 13832701..a0fd1e9c 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -133,7 +133,8 @@ zero_log(
 
 static bool
 set_inobtcount(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
 {
 	if (!xfs_has_crc(mp)) {
 		printf(
@@ -153,14 +154,15 @@ set_inobtcount(
 	}
 
 	printf(_("Adding inode btree counts to filesystem.\n"));
-	mp->m_sb.sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
-	mp->m_sb.sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	new_sb->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
 	return true;
 }
 
 static bool
 set_bigtime(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
 {
 	if (!xfs_has_crc(mp)) {
 		printf(
@@ -174,28 +176,218 @@ set_bigtime(
 	}
 
 	printf(_("Adding large timestamp support to filesystem.\n"));
-	mp->m_sb.sb_features_incompat |= (XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR |
-					  XFS_SB_FEAT_INCOMPAT_BIGTIME);
+	new_sb->sb_features_incompat |= (XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR |
+					 XFS_SB_FEAT_INCOMPAT_BIGTIME);
 	return true;
 }
 
+struct check_state {
+	struct xfs_sb		sb;
+	uint64_t		features;
+	bool			finobt_nores;
+};
+
+static inline void
+capture_old_state(
+	struct check_state	*old_state,
+	const struct xfs_mount	*mp)
+{
+	memcpy(&old_state->sb, &mp->m_sb, sizeof(struct xfs_sb));
+	old_state->finobt_nores = mp->m_finobt_nores;
+	old_state->features = mp->m_features;
+}
+
+static inline void
+restore_old_state(
+	struct xfs_mount		*mp,
+	const struct check_state	*old_state)
+{
+	memcpy(&mp->m_sb, &old_state->sb, sizeof(struct xfs_sb));
+	mp->m_finobt_nores = old_state->finobt_nores;
+	mp->m_features = old_state->features;
+	libxfs_compute_all_maxlevels(mp);
+	libxfs_trans_init(mp);
+}
+
+static inline void
+install_new_state(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	memcpy(&mp->m_sb, new_sb, sizeof(struct xfs_sb));
+	mp->m_features |= libxfs_sb_version_to_features(new_sb);
+	libxfs_compute_all_maxlevels(mp);
+	libxfs_trans_init(mp);
+}
+
+/*
+ * Make sure we can actually upgrade this (v5) filesystem without running afoul
+ * of root inode or log size requirements that would prevent us from mounting
+ * the filesystem.  If everything checks out, commit the new geometry.
+ */
+static void
+install_new_geometry(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	struct check_state	old;
+	struct xfs_perag	*pag;
+	xfs_ino_t		rootino;
+	xfs_agnumber_t		agno;
+	int			min_logblocks;
+	int			error;
+
+	capture_old_state(&old, mp);
+	install_new_state(mp, new_sb);
+
+	/*
+	 * The existing log must be large enough to satisfy the new minimum log
+	 * size requirements.
+	 */
+	min_logblocks = libxfs_log_calc_minimum_size(mp);
+	if (old.sb.sb_logblocks < min_logblocks) {
+		printf(
+	_("Filesystem log too small to upgrade filesystem; need %u blocks, have %u.\n"),
+				min_logblocks, old.sb.sb_logblocks);
+		exit(1);
+	}
+
+	/*
+	 * The root inode must be where xfs_repair will expect it to be with
+	 * the new geometry.
+	 */
+	rootino = libxfs_ialloc_calc_rootino(mp, new_sb->sb_unit);
+	if (old.sb.sb_rootino != rootino) {
+		printf(
+	_("Cannot upgrade filesystem, root inode (%llu) cannot be moved to %llu.\n"),
+				(unsigned long long)old.sb.sb_rootino,
+				(unsigned long long)rootino);
+		exit(1);
+	}
+
+	/* Make sure we have enough space for per-AG reservations. */
+	for_each_perag(mp, agno, pag) {
+		struct xfs_trans	*tp;
+		struct xfs_agf		*agf;
+		struct xfs_buf		*agi_bp, *agf_bp;
+		unsigned int		avail, agblocks;
+
+		/* Put back the old super so that we can read AG headers. */
+		restore_old_state(mp, &old);
+
+		/*
+		 * Create a dummy transaction so that we can load the AGI and
+		 * AGF buffers in memory with the old fs geometry and pin them
+		 * there while we try to make a per-AG reservation with the new
+		 * geometry.
+		 */
+		error = -libxfs_trans_alloc_empty(mp, &tp);
+		if (error)
+			do_error(
+	_("Cannot reserve resources for upgrade check, err=%d.\n"),
+					error);
+
+		error = -libxfs_ialloc_read_agi(mp, tp, pag->pag_agno,
+				&agi_bp);
+		if (error)
+			do_error(
+	_("Cannot read AGI %u for upgrade check, err=%d.\n"),
+					pag->pag_agno, error);
+
+		error = -libxfs_alloc_read_agf(mp, tp, pag->pag_agno, 0,
+				&agf_bp);
+		if (error)
+			do_error(
+	_("Cannot read AGF %u for upgrade check, err=%d.\n"),
+					pag->pag_agno, error);
+		agf = agf_bp->b_addr;
+		agblocks = be32_to_cpu(agf->agf_length);
+
+		/*
+		 * Install the new superblock and try to make a per-AG space
+		 * reservation with the new geometry.  We pinned the AG header
+		 * buffers to the transaction, so we shouldn't hit any
+		 * corruption errors on account of the new geometry.
+		 */
+		install_new_state(mp, new_sb);
+
+		error = -libxfs_ag_resv_init(pag, tp);
+		if (error == ENOSPC) {
+			printf(
+	_("Not enough free space would remain in AG %u for metadata.\n"),
+					pag->pag_agno);
+			exit(1);
+		}
+		if (error)
+			do_error(
+	_("Error %d while checking AG %u space reservation.\n"),
+					error, pag->pag_agno);
+
+		/*
+		 * Would we have at least 10% free space in this AG after
+		 * making per-AG reservations?
+		 */
+		avail = pag->pagf_freeblks + pag->pagf_flcount;
+		avail -= pag->pag_meta_resv.ar_reserved;
+		avail -= pag->pag_rmapbt_resv.ar_asked;
+		if (avail < agblocks / 10) {
+			printf(
+	_("AG %u will be low on space after upgrade.\n"),
+					pag->pag_agno);
+			exit(1);
+		}
+		libxfs_trans_cancel(tp);
+	}
+
+	/*
+	 * Would we have at least 10% free space in the data device after all
+	 * the upgrades?
+	 */
+	if (mp->m_sb.sb_fdblocks < mp->m_sb.sb_dblocks / 10) {
+		printf(_("Filesystem will be low on space after upgrade.\n"));
+		exit(1);
+	}
+
+	/*
+	 * Release the per-AG reservations and mark the per-AG structure as
+	 * uninitialized so that we don't trip over stale cached counters
+	 * after the upgrade/
+	 */
+	for_each_perag(mp, agno, pag) {
+		libxfs_ag_resv_free(pag);
+		pag->pagf_init = 0;
+		pag->pagi_init = 0;
+	}
+
+	/*
+	 * Restore the old state to get everything back to a clean state,
+	 * upgrade the featureset one more time, and recompute the btree max
+	 * levels for this filesystem.
+	 */
+	restore_old_state(mp, &old);
+	install_new_state(mp, new_sb);
+}
+
 /* Perform the user's requested upgrades on filesystem. */
 static void
 upgrade_filesystem(
 	struct xfs_mount	*mp)
 {
+	struct xfs_sb		new_sb;
 	struct xfs_buf		*bp;
 	bool			dirty = false;
 	int			error;
 
+	memcpy(&new_sb, &mp->m_sb, sizeof(struct xfs_sb));
+
 	if (add_inobtcount)
-		dirty |= set_inobtcount(mp);
+		dirty |= set_inobtcount(mp, &new_sb);
 	if (add_bigtime)
-		dirty |= set_bigtime(mp);
+		dirty |= set_bigtime(mp, &new_sb);
 	if (!dirty)
 		return;
 
-	mp->m_features |= libxfs_sb_version_to_features(&mp->m_sb);
+	install_new_geometry(mp, &new_sb);
 	if (no_modify)
 		return;
 

