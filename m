Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB34C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:12:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236019AbiLaBMn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236017AbiLaBMm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:12:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA98016588
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:12:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 567BA61D5A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4A5C433EF;
        Sat, 31 Dec 2022 01:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449160;
        bh=aA0zWBPaG3LTenJr0sQnp4aSno3zG/Z2TGpVDZLhJDg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SGAtmBb/tnHrGLshMa3N293WnkN+VvpGEwGnUskbsziIE+nyNdnNRr9Uwz5wLRCWW
         KU9ztQM2v3b9VCw+h4UgdpUVvXkE9y4V1bAWrcLjffjDwCfYB0c6+A83p8LZpRuOTN
         mUqCP21NDucsnlAQBz24sET7WVhz4sIgltqb51AoIilTFpaji6UKTBir1fIS+mfCsp
         LIE9t3FpJ9wiP3IgkzPBPxOitsDzuuSQfeeOWFmbrqG2n5Rq6zIWT8Uk1E59GYsTTP
         nB/pcuWz6gnYG5OhAtFwyJYSvAo6wj2ZEBkhqYNX4TuLrQoTgFUHR/11/iYBpvJ9Ya
         /C6A68o6XZEjg==
Subject: [PATCH 09/23] xfs: load metadata directory root at mount time
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:25 -0800
Message-ID: <167243864583.708110.12125895474641301362.stgit@magnolia>
In-Reply-To: <167243864431.708110.1688096566212843499.stgit@magnolia>
References: <167243864431.708110.1688096566212843499.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Load the metadata directory root inode into memory at mount time and
release it at unmount time.  We also make sure that the obsolete inode
pointers in the superblock are not logged or read from the superblock.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c    |   31 +++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_types.c |    2 +-
 fs/xfs/xfs_mount.c        |   20 +++++++++++++++++---
 fs/xfs/xfs_mount.h        |    1 +
 4 files changed, 50 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 345a6fdf8625..181bede3b3f6 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -622,6 +622,25 @@ __xfs_sb_from_disk(
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
@@ -769,6 +788,18 @@ xfs_sb_to_disk(
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
index 50efa181b26d..dfcc1889c203 100644
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
index 0ee6a856f1e4..3957c60d5d07 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -616,6 +616,16 @@ xfs_mount_setup_metadir(
 {
 	int			error;
 
+	/* Load the metadata directory inode into memory. */
+	if (xfs_has_metadir(mp)) {
+		error = xfs_imeta_iget(mp, mp->m_sb.sb_metadirino,
+				XFS_DIR3_FT_DIR, &mp->m_metadirip);
+		if (error) {
+			xfs_warn(mp, "Failed metadir inode init: %d", error);
+			return error;
+		}
+	}
+
 	error = xfs_imeta_mount(mp);
 	if (error) {
 		xfs_warn(mp, "Failed to load metadata inode info, error %d",
@@ -862,7 +872,7 @@ xfs_mountfs(
 
 	error = xfs_mount_setup_metadir(mp);
 	if (error)
-		goto out_log_dealloc;
+		goto out_free_metadir;
 
 	/*
 	 * Get and sanity-check the root inode.
@@ -874,7 +884,7 @@ xfs_mountfs(
 		xfs_warn(mp,
 			"Failed to read root inode 0x%llx, error %d",
 			sbp->sb_rootino, -error);
-		goto out_log_dealloc;
+		goto out_free_metadir;
 	}
 
 	ASSERT(rip != NULL);
@@ -1017,6 +1027,9 @@ xfs_mountfs(
 	xfs_irele(rip);
 	/* Clean out dquots that might be in memory after quotacheck. */
 	xfs_qm_unmount(mp);
+ out_free_metadir:
+	if (mp->m_metadirip)
+		xfs_imeta_irele(mp->m_metadirip);
 
 	/*
 	 * Inactivate all inodes that might still be in memory after a log
@@ -1038,7 +1051,6 @@ xfs_mountfs(
 	 * quota inodes.
 	 */
 	xfs_unmount_flush_inodes(mp);
- out_log_dealloc:
 	xfs_log_mount_cancel(mp);
  out_inodegc_shrinker:
 	unregister_shrinker(&mp->m_inodegc_shrinker);
@@ -1090,6 +1102,8 @@ xfs_unmountfs(
 	xfs_qm_unmount_quotas(mp);
 	xfs_rtunmount_inodes(mp);
 	xfs_irele(mp->m_rootip);
+	if (mp->m_metadirip)
+		xfs_imeta_irele(mp->m_metadirip);
 
 	xfs_unmount_flush_inodes(mp);
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 0fb545e92a26..88fbbaee8806 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -90,6 +90,7 @@ typedef struct xfs_mount {
 	struct xfs_inode	*m_rbmip;	/* pointer to bitmap inode */
 	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
 	struct xfs_inode	*m_rootip;	/* pointer to root directory */
+	struct xfs_inode	*m_metadirip;	/* ptr to metadata directory */
 	struct xfs_quotainfo	*m_quotainfo;	/* disk quota information */
 	xfs_buftarg_t		*m_ddev_targp;	/* saves taking the address */
 	xfs_buftarg_t		*m_logdev_targp;/* ptr to log device */

