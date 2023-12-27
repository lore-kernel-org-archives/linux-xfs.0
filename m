Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6357EE
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TyC5d+Tb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7C8C433C8;
	Mon,  1 Jan 2024 00:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068535;
	bh=XGux3g2DbuffIzvy1ksVLaTCYtLQ9yVqg0WsS1e3z+c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TyC5d+TbcRacR9r8EpkMARzjdKstJDvlJikmvF9hu2OMIhIycHuVkSRIMr/33vJQY
	 1M9PFW9jbSkZAPPeO9ngQnOeiFMY1tguRap+noJt++lcEzhwUuMjnjjp89Gd4qSlbd
	 HuNKP1McHqzfQ8HtTiFCHqg+VRWhXc9jRpfgm/Y+72y2mExpwb/wJ2pSzH6SGNytbd
	 ZgbJZjTpf47tIQz7i5s4ghIJeH4hl+ToVB7NoeHtzaLqRsGh40jh2zjTcNGxOxGk3L
	 DvHjdPXqg+1Lc7hW5snKgnP2+kmQcOEeKPlZKYU3t5z/1MbUs8QbrOsditqkltPysA
	 L3lp3+b3UzpDw==
Date: Sun, 31 Dec 2023 16:22:14 +9900
Subject: [PATCH 45/47] xfs_repair: allow sysadmins to add realtime reverse
 mapping indexes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015913.1815505.10741521850890564062.stgit@frogsfrogsfrogs>
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

Allow the sysadmin to use xfs_repair to upgrade an existing filesystem
to support the reverse mapping btree index for realtime volumes.  This
is needed for online fsck.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    4 ++
 repair/phase2.c          |  100 ++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 99 insertions(+), 5 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index b5bb6c39928..cfa8c474160 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -63,6 +63,7 @@
 #define xfs_btree_bload			libxfs_btree_bload
 #define xfs_btree_bload_compute_geometry libxfs_btree_bload_compute_geometry
 #define xfs_btree_calc_size		libxfs_btree_calc_size
+#define xfs_btree_compute_maxlevels	libxfs_btree_compute_maxlevels
 #define xfs_btree_decrement		libxfs_btree_decrement
 #define xfs_btree_del_cursor		libxfs_btree_del_cursor
 #define xfs_btree_delete		libxfs_btree_delete
@@ -190,6 +191,8 @@
 #define xfs_imeta_link_space_res	libxfs_imeta_link_space_res
 #define xfs_imeta_lookup		libxfs_imeta_lookup
 #define xfs_imeta_mount			libxfs_imeta_mount
+#define xfs_imeta_resv_free_inode	libxfs_imeta_resv_free_inode
+#define xfs_imeta_resv_init_inode	libxfs_imeta_resv_init_inode
 #define xfs_imeta_set_iflag		libxfs_imeta_set_iflag
 #define xfs_imeta_start_create		libxfs_imeta_start_create
 #define xfs_imeta_start_link		libxfs_imeta_start_link
@@ -289,6 +292,7 @@
 #define xfs_rtgroup_put			libxfs_rtgroup_put
 #define xfs_rtgroup_update_secondary_sbs	libxfs_rtgroup_update_secondary_sbs
 #define xfs_rtgroup_update_super	libxfs_rtgroup_update_super
+#define xfs_rtrmapbt_calc_reserves	libxfs_rtrmapbt_calc_reserves
 #define xfs_rtrmapbt_calc_size		libxfs_rtrmapbt_calc_size
 #define xfs_rtrmapbt_commit_staged_btree	libxfs_rtrmapbt_commit_staged_btree
 #define xfs_rtrmapbt_create		libxfs_rtrmapbt_create
diff --git a/repair/phase2.c b/repair/phase2.c
index 4cb0d7946bf..22458aee4cd 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -250,9 +250,8 @@ set_rmapbt(
 		exit(0);
 	}
 
-	if (xfs_has_realtime(mp)) {
-		printf(
-	_("Reverse mapping btree feature not supported with realtime.\n"));
+	if (xfs_has_realtime(mp) && !xfs_has_rtgroups(mp)) {
+		printf(_("Reverse mapping btree requires realtime groups.\n"));
 		exit(0);
 	}
 
@@ -265,6 +264,11 @@ set_rmapbt(
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
 
@@ -450,6 +454,63 @@ check_free_space(
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
+	struct xfs_trans	*tp;
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
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		goto out_path;
+
+	ask = libxfs_rtrmapbt_calc_reserves(mp);
+
+	error = -libxfs_imeta_lookup(tp, path, &ino);
+	if (error)
+		goto out_trans;
+
+	if (ino == NULLFSINO) {
+		*new_resv += ask;
+		goto out_trans;
+	}
+
+	error = -libxfs_imeta_iget(tp, ino, XFS_DIR3_FT_REG_FILE,
+			&rtg->rtg_rmapip);
+	if (error)
+		goto out_trans;
+
+	error = -libxfs_imeta_resv_init_inode(rtg->rtg_rmapip, ask);
+
+out_trans:
+	libxfs_trans_cancel(tp);
+out_path:
+	libxfs_imeta_free_path(path);
+	return error;
+}
+
 static void
 check_fs_free_space(
 	struct xfs_mount		*mp,
@@ -457,7 +518,10 @@ check_fs_free_space(
 	struct xfs_sb			*new_sb)
 {
 	struct xfs_perag		*pag;
+	struct xfs_rtgroup		*rtg;
+	xfs_rfsblock_t			new_resv = 0;
 	xfs_agnumber_t			agno;
+	xfs_rgnumber_t			rgno;
 	int				error;
 
 	/* Make sure we have enough space for per-AG reservations. */
@@ -533,6 +597,21 @@ check_fs_free_space(
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
+					error, rtg->rtg_rgno);
+	}
+
 	/*
 	 * If we're adding parent pointers, we need at least 25% free since
 	 * scanning the entire filesystem to guesstimate the overhead is
@@ -548,13 +627,24 @@ check_fs_free_space(
 
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

