Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19813BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZH2SS/Xl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0EF0C433C7;
	Sun, 31 Dec 2023 21:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056914;
	bh=8c5vXfqZV6dSdSPGPBya7Xt+ds3z4xk3EgKneb6W+eI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZH2SS/XlXzICo4aY8pd94gLfrwDfx3fjxwg5vIyRsKuJCQhgezGB58yWH0A1wnH7c
	 cnss4sAWXjvg6KzM4sKaes+8HmWzTCv793DO1UhHVIabt9AoJEMjIHX2HtGmNQw4xJ
	 PVhWEJCSrzd7nWngAcCbYP7dh+a6WDSLforKdQuaipsnAQYfPDdFAGZCInYkNqXwtr
	 Rjw/+UdEZ3vg549m+RDtaDLIuGUoVpVhSGmC1EA0OZoyg2TW5rWfCPABhAkWJNsmv5
	 VwN1Y5tSvnlVGIaZ+C+8H0JlO2evsErI/bb7b5k6IbZ9FpO37RTuukCDTV2iIlsT3o
	 Qhqw840Ymf1tg==
Date: Sun, 31 Dec 2023 13:08:34 -0800
Subject: [PATCH 09/32] xfs: load metadata directory root at mount time
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404845009.1760491.5632662407095206679.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
References: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
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

Load the metadata directory root inode into memory at mount time and
release it at unmount time.  We also make sure that the obsolete inode
pointers in the superblock are not logged or read from the superblock.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c    |   31 +++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_types.c |    2 +-
 fs/xfs/xfs_mount.c        |   22 +++++++++++++++++++---
 fs/xfs/xfs_mount.h        |    1 +
 4 files changed, 52 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 2d2f55099db04..28f65753c0c5a 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -682,6 +682,25 @@ __xfs_sb_from_disk(
 	/* Convert on-disk flags to in-memory flags? */
 	if (convert_xquota)
 		xfs_sb_quota_from_disk(to);
+
+	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
+		/*
+		 * Set metadirino here and null out the in-core fields for
+		 * the other inodes because metadir initialization will load
+		 * them later.
+		 */
+		to->sb_metadirino = be64_to_cpu(from->sb_rbmino);
+		to->sb_rbmino = NULLFSINO;
+		to->sb_rsumino = NULLFSINO;
+
+		/*
+		 * We don't have to worry about quota inode conversion here
+		 * because metadir requires a v5 filesystem.
+		 */
+		to->sb_uquotino = NULLFSINO;
+		to->sb_gquotino = NULLFSINO;
+		to->sb_pquotino = NULLFSINO;
+	}
 }
 
 void
@@ -829,6 +848,18 @@ xfs_sb_to_disk(
 	to->sb_lsn = cpu_to_be64(from->sb_lsn);
 	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID)
 		uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
+
+	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
+		/*
+		 * Save metadirino here and null out the on-disk fields for
+		 * the other inodes, at least until we reuse the fields.
+		 */
+		to->sb_rbmino = cpu_to_be64(from->sb_metadirino);
+		to->sb_rsumino = cpu_to_be64(NULLFSINO);
+		to->sb_uquotino = cpu_to_be64(NULLFSINO);
+		to->sb_gquotino = cpu_to_be64(NULLFSINO);
+		to->sb_pquotino = cpu_to_be64(NULLFSINO);
+	}
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 72f7e050e600a..b1fa715e5f398 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -128,7 +128,7 @@ xfs_verify_dir_ino(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino)
 {
-	if (xfs_internal_inum(mp, ino))
+	if (!xfs_has_metadir(mp) && xfs_internal_inum(mp, ino))
 		return false;
 	return xfs_verify_ino(mp, ino);
 }
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index ab11fe9a4b4ab..8b61b8c51cd16 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -622,6 +622,18 @@ xfs_mount_setup_metadir(
 	if (error)
 		return error;
 
+	/* Load the metadata directory root inode into memory. */
+	if (xfs_has_metadir(mp)) {
+		error = xfs_imeta_iget(tp, mp->m_sb.sb_metadirino,
+				XFS_DIR3_FT_DIR, &mp->m_metadirip);
+		if (error) {
+			xfs_warn(mp,
+ "Failed to load metadir root directory, error %d",
+					error);
+			goto err_cancel;
+		}
+	}
+
 	error = xfs_imeta_mount(tp);
 	if (error) {
 		xfs_warn(mp, "Failed to load metadata inodes, error %d",
@@ -872,7 +884,7 @@ xfs_mountfs(
 
 	error = xfs_mount_setup_metadir(mp);
 	if (error)
-		goto out_log_dealloc;
+		goto out_free_metadir;
 
 	/*
 	 * Get and sanity-check the root inode.
@@ -884,7 +896,7 @@ xfs_mountfs(
 		xfs_warn(mp,
 			"Failed to read root inode 0x%llx, error %d",
 			sbp->sb_rootino, -error);
-		goto out_log_dealloc;
+		goto out_free_metadir;
 	}
 
 	ASSERT(rip != NULL);
@@ -1027,6 +1039,9 @@ xfs_mountfs(
 	xfs_irele(rip);
 	/* Clean out dquots that might be in memory after quotacheck. */
 	xfs_qm_unmount(mp);
+ out_free_metadir:
+	if (mp->m_metadirip)
+		xfs_imeta_irele(mp->m_metadirip);
 
 	/*
 	 * Inactivate all inodes that might still be in memory after a log
@@ -1048,7 +1063,6 @@ xfs_mountfs(
 	 * quota inodes.
 	 */
 	xfs_unmount_flush_inodes(mp);
- out_log_dealloc:
 	xfs_log_mount_cancel(mp);
  out_inodegc_shrinker:
 	shrinker_free(mp->m_inodegc_shrinker);
@@ -1101,6 +1115,8 @@ xfs_unmountfs(
 	xfs_qm_unmount_quotas(mp);
 	xfs_rtunmount_inodes(mp);
 	xfs_irele(mp->m_rootip);
+	if (mp->m_metadirip)
+		xfs_imeta_irele(mp->m_metadirip);
 
 	xfs_unmount_flush_inodes(mp);
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 953386ad4b13f..b45a4f4a8503e 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -93,6 +93,7 @@ typedef struct xfs_mount {
 	struct xfs_inode	*m_rbmip;	/* pointer to bitmap inode */
 	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
 	struct xfs_inode	*m_rootip;	/* pointer to root directory */
+	struct xfs_inode	*m_metadirip;	/* ptr to metadata directory */
 	struct xfs_quotainfo	*m_quotainfo;	/* disk quota information */
 	xfs_buftarg_t		*m_ddev_targp;	/* saves taking the address */
 	xfs_buftarg_t		*m_logdev_targp;/* ptr to log device */

