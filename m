Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9946DC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236275AbiLaCwl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236243AbiLaCwk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:52:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DD511450
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:52:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04864B81E6E
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BF3C433EF;
        Sat, 31 Dec 2022 02:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455156;
        bh=W6slZE1tX8eA8BR0DrNVp9qjjnyUoEjHeee5fKVNtVw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KfNJqhaBGIIbSRhq15j78ksFeSYZ2GR0UssZAbpZA4BXP/xLuoczpk7TTTF9+jizF
         u/yeo62UCNfsdzScAidEdeQiAjrmWZXd/DmnBBernrLkiQL7FOIpKqviJXM+2gRU/9
         aNSaD03DNQb2T0U+TXdDqHhTF8mgZyPh30rTeNBM15FVRQSdFwejHY45UuiTtrJ/ba
         H3nfr+DK35wB1t6rTY3ZKXXvYxalb4u7XAupuB9Ow1q2eVu+Jd6M5nhCE035rIOY7m
         cEsoV7XuE9SlhIh1t4W2D4uwEkfmz6/0mRUEYRzPWSPly1F8ot+4PmjJIoFLdbnx0c
         f1Smv0FG2SdCA==
Subject: [PATCH 39/41] xfs_repair: allow sysadmins to add realtime reverse
 mapping indexes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:01 -0800
Message-ID: <167243880110.732820.729630067665593667.stgit@magnolia>
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

Allow the sysadmin to use xfs_repair to upgrade an existing filesystem
to support the reverse mapping btree index for realtime volumes.  This
is needed for online fsck.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    4 ++
 repair/phase2.c          |   92 ++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 91 insertions(+), 5 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index ee864911e5e..2e7529cec54 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -56,6 +56,7 @@
 #define xfs_btree_bload			libxfs_btree_bload
 #define xfs_btree_bload_compute_geometry libxfs_btree_bload_compute_geometry
 #define xfs_btree_calc_size		libxfs_btree_calc_size
+#define xfs_btree_compute_maxlevels	libxfs_btree_compute_maxlevels
 #define xfs_btree_decrement		libxfs_btree_decrement
 #define xfs_btree_del_cursor		libxfs_btree_del_cursor
 #define xfs_btree_delete		libxfs_btree_delete
@@ -171,6 +172,8 @@
 #define xfs_imeta_link			libxfs_imeta_link
 #define xfs_imeta_lookup		libxfs_imeta_lookup
 #define xfs_imeta_mount			libxfs_imeta_mount
+#define xfs_imeta_resv_free_inode	libxfs_imeta_resv_free_inode
+#define xfs_imeta_resv_init_inode	libxfs_imeta_resv_init_inode
 #define xfs_imeta_set_metaflag		libxfs_imeta_set_metaflag
 #define xfs_imeta_start_update		libxfs_imeta_start_update
 #define xfs_imeta_unlink		libxfs_imeta_unlink
@@ -246,6 +249,7 @@
 #define xfs_rtgroup_put			libxfs_rtgroup_put
 #define xfs_rtgroup_update_secondary_sbs	libxfs_rtgroup_update_secondary_sbs
 #define xfs_rtgroup_update_super	libxfs_rtgroup_update_super
+#define xfs_rtrmapbt_calc_reserves	libxfs_rtrmapbt_calc_reserves
 #define xfs_rtrmapbt_commit_staged_btree	libxfs_rtrmapbt_commit_staged_btree
 #define xfs_rtrmapbt_create		libxfs_rtrmapbt_create
 #define xfs_rtrmapbt_create_path	libxfs_rtrmapbt_create_path
diff --git a/repair/phase2.c b/repair/phase2.c
index 707fe5ca519..35c1214be9a 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -264,9 +264,8 @@ set_rmapbt(
 		exit(0);
 	}
 
-	if (xfs_has_realtime(mp)) {
-		printf(
-	_("Reverse mapping btree feature not supported with realtime.\n"));
+	if (xfs_has_realtime(mp) && !xfs_has_rtgroups(mp)) {
+		printf(_("Reverse mapping btree requires realtime groups.\n"));
 		exit(0);
 	}
 
@@ -284,6 +283,11 @@ set_rmapbt(
 	printf(_("Adding reverse mapping btrees to filesystem.\n"));
 	new_sb->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
 	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+
+	/* Quota counts will be wrong once we add the rmap inodes. */
+	if (xfs_has_realtime(mp))
+		quotacheck_skip();
+
 	return true;
 }
 
@@ -409,6 +413,55 @@ check_free_space(
 	return avail > GIGABYTES(10, mp->m_sb.sb_blocklog);
 }
 
+/*
+ * Reserve space to handle rt rmap btree expansion.
+ *
+ * If the rmap inode for this group already exists, we assume that we're adding
+ * some other feature.  Note that we have not validated the metadata directory
+ * tree, so we must perform the lookup by hand and abort the upgrade if there
+ * are errors.  Otherwise, the amount of space needed to handle a new maximally
+ * sized rmap btree is added to @new_resv.
+ */
+static int
+reserve_rtrmap_inode(
+	struct xfs_rtgroup	*rtg,
+	xfs_rfsblock_t		*new_resv)
+{
+	struct xfs_mount	*mp = rtg->rtg_mount;
+	struct xfs_imeta_path	*path;
+	xfs_ino_t		ino;
+	xfs_filblks_t		ask;
+	int			error;
+
+	if (!xfs_has_rtrmapbt(mp))
+		return 0;
+
+	error = -libxfs_rtrmapbt_create_path(mp, rtg->rtg_rgno, &path);
+	if (error)
+		return error;
+
+	ask = libxfs_rtrmapbt_calc_reserves(mp);
+
+	error = -libxfs_imeta_lookup(mp, path, &ino);
+	libxfs_imeta_free_path(path);
+	if (error == EFSCORRUPTED) {
+		if (ask > mp->m_sb.sb_fdblocks)
+			return ENOSPC;
+
+		*new_resv += ask;
+		return 0;
+	}
+	if (error)
+		return error;
+
+	error = -libxfs_imeta_iget(mp, ino, XFS_DIR3_FT_REG_FILE,
+			&rtg->rtg_rmapip);
+	if (error)
+		return error;
+
+	return -libxfs_imeta_resv_init_inode(rtg->rtg_rmapip, ask);
+}
+
 static void
 check_fs_free_space(
 	struct xfs_mount		*mp,
@@ -416,7 +469,10 @@ check_fs_free_space(
 	struct xfs_sb			*new_sb)
 {
 	struct xfs_perag		*pag;
+	struct xfs_rtgroup		*rtg;
+	xfs_rfsblock_t			new_resv = 0;
 	xfs_agnumber_t			agno;
+	xfs_rgnumber_t			rgno;
 	int				error;
 
 	/* Make sure we have enough space for per-AG reservations. */
@@ -492,15 +548,41 @@ check_fs_free_space(
 		libxfs_trans_cancel(tp);
 	}
 
+	/* Realtime metadata btree inodes */
+	for_each_rtgroup(mp, rgno, rtg) {
+		error = reserve_rtrmap_inode(rtg, &new_resv);
+		if (error == ENOSPC) {
+			printf(
+_("Not enough free space would remain for rtgroup %u rmap inode.\n"),
+					rtg->rtg_rgno);
+			exit(0);
+		}
+		if (error)
+			do_error(
+_("Error %d while checking rtgroup %u rmap inode space reservation.\n"),
+					rtg->rtg_rgno, error);
+	}
+
 	/*
 	 * Would the post-upgrade filesystem have enough free space on the data
-	 * device after making per-AG reservations?
+	 * device after making per-AG reservations and reserving rt metadata
+	 * inode blocks?
 	 */
-	if (!check_free_space(mp, mp->m_sb.sb_fdblocks, mp->m_sb.sb_dblocks)) {
+	if (new_resv > mp->m_sb.sb_fdblocks ||
+	    !check_free_space(mp, mp->m_sb.sb_fdblocks, mp->m_sb.sb_dblocks)) {
 		printf(_("Filesystem will be low on space after upgrade.\n"));
 		exit(1);
 	}
 
+	/* Unreserve the realtime metadata reservations. */
+	for_each_rtgroup(mp, rgno, rtg) {
+		if (rtg->rtg_rmapip) {
+			libxfs_imeta_resv_free_inode(rtg->rtg_rmapip);
+			libxfs_imeta_irele(rtg->rtg_rmapip);
+			rtg->rtg_rmapip = NULL;
+		}
+	}
+
 	/*
 	 * Release the per-AG reservations and mark the per-AG structure as
 	 * uninitialized so that we don't trip over stale cached counters

