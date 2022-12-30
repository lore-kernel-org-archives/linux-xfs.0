Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5952CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236174AbiLaCMN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiLaCMM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:12:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C2F1C900
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:12:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D452B81E09
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541F1C433D2;
        Sat, 31 Dec 2022 02:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452729;
        bh=m92xEz7ocHFfsZ2++rnFCFgOMSNHN05gmr+olS5n0Hw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fEEvJVZVlgKRhmFN/FLL6VOhCoZYylbrLnsgUba0Mk1sfWmK6nIbGjhimRRz301Ww
         zt6u4Q7Q/7Os4S0MlRyu9YJ2YTxQLdIVoXTXTtw8VzKQeYQiCd9HcH7apPx6PBudBv
         fmMgJ5kHAkWsaFMMAvWLqZwi0iQZH7YPn3Rs4sI2QMqlqASxei+ZViJ42ajwhnMQNR
         NjQRBqjh0FOce5g3aJT0JCvWNJ4s8nb5JVjIg0GTkAeHreF9cQJYXOQGpd+IeDFLWW
         uRCoXU10CD8bYDJYoRqk2JB5pR4BrWx0dRL3+P1ApYDqdza5PURRwl4bCaEB45whC1
         PRfvvetrur8uw==
Subject: [PATCH 09/46] xfs: load metadata directory root at mount time
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:20 -0800
Message-ID: <167243876057.725900.14341853041384069003.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
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
 include/xfs_mount.h |    1 +
 libxfs/init.c       |   20 ++++++++++++++++++--
 libxfs/xfs_sb.c     |   31 +++++++++++++++++++++++++++++++
 libxfs/xfs_types.c  |    2 +-
 4 files changed, 51 insertions(+), 3 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 5a8f45e7796..4347098dc7e 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -55,6 +55,7 @@ typedef struct xfs_mount {
 	uint8_t			*m_rsum_cache;
 	struct xfs_inode	*m_rbmip;	/* pointer to bitmap inode */
 	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
+	struct xfs_inode	*m_metadirip;	/* ptr to metadata directory */
 	struct xfs_buftarg	*m_ddev_targp;
 	struct xfs_buftarg	*m_logdev_targp;
 	struct xfs_buftarg	*m_rtdev_targp;
diff --git a/libxfs/init.c b/libxfs/init.c
index d114ac87f19..787f7c108db 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -802,11 +802,25 @@ libxfs_mountfs_imeta(
 	if (mp->m_sb.sb_inprogress)
 		return;
 
+	if (xfs_has_metadir(mp)) {
+		error = -libxfs_imeta_iget(mp, mp->m_sb.sb_metadirino,
+				XFS_DIR3_FT_DIR, &mp->m_metadirip);
+		if (error)
+			fprintf(stderr,
+_("%s: could not open metadata directory, error %d\n"),
+					progname, error);
+	}
+
 	error = -xfs_imeta_mount(mp);
-	if (error)
+	if (error) {
+		if (mp->m_metadirip)
+			libxfs_imeta_irele(mp->m_metadirip);
+		mp->m_metadirip = NULL;
+
 		fprintf(stderr,
-_("%s: metadata inode mounting failed, error %d\n"),
+_("%s: mounting metadata directory failed, error %d\n"),
 			progname, error);
+	}
 }
 
 /*
@@ -1091,6 +1105,8 @@ libxfs_umount(
 	int			error;
 
 	libxfs_rtmount_destroy(mp);
+	if (mp->m_metadirip)
+		libxfs_imeta_irele(mp->m_metadirip);
 
 	/*
 	 * Purge the buffer cache to write all dirty buffers to disk and free
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index c421099e4f9..6452856d45b 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -620,6 +620,25 @@ __xfs_sb_from_disk(
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
@@ -767,6 +786,18 @@ xfs_sb_to_disk(
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
diff --git a/libxfs/xfs_types.c b/libxfs/xfs_types.c
index 93eefd7b35f..d20d9a5c915 100644
--- a/libxfs/xfs_types.c
+++ b/libxfs/xfs_types.c
@@ -128,7 +128,7 @@ xfs_verify_dir_ino(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino)
 {
-	if (xfs_internal_inum(mp, ino))
+	if (!xfs_has_metadir(mp) && xfs_internal_inum(mp, ino))
 		return false;
 	return xfs_verify_ino(mp, ino);
 }

