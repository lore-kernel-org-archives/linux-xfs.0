Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B33B2C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:15:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236036AbiLaBPV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236038AbiLaBPT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:15:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8581E3EE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:15:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 169E261D4A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7416AC433EF;
        Sat, 31 Dec 2022 01:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449316;
        bh=kHHdbcSOsnzS+thLaLHOMPF/z9MwgJN4VS3qugne0ag=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aNTpQUIaEmEEjhvgiV7LpogPBOFVLMuUIsmm8bbteVmim3G2FBgYtZL6B1k+YKg/+
         thd6b9fiLBlITyNfyGmo9KNVfV/Ki00wt97RDZV9s7QSVfy2qUOcAm2hMyaYNcsWUg
         WUjzFprD3N7aVJObzhsEVhctAjq5aiiZ9oTakWnZheHBYp5LywSElxEjNF+nu/nyyB
         JPwCGUFSCeJAeqwgi4+Jm9p2TnN8+FeDjIITpudX2P70/1bp8fKg3bqIGgULPa8cME
         W48TSTB5vV/JyAUfUOUkI9hKUOOVDbZjpitG7eEoOIfvcIqNnsmvAJiZ2kTFTts69+
         6JUx+2+cYZf6g==
Subject: [PATCH 19/23] xfs: record health problems with the metadata directory
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:27 -0800
Message-ID: <167243864726.708110.7042365454388128884.stgit@magnolia>
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

Make a report to the health monitoring subsystem any time we encounter
something in the metadata directory tree that looks like corruption.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h     |    1 +
 fs/xfs/libxfs/xfs_health.h |    4 +++-
 fs/xfs/libxfs/xfs_imeta.c  |   28 ++++++++++++++++++++++------
 fs/xfs/xfs_health.c        |    1 +
 fs/xfs/xfs_icache.c        |    1 +
 fs/xfs/xfs_inode.c         |    1 +
 6 files changed, 29 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 6e0c45fcfeeb..c4995f6557d2 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -197,6 +197,7 @@ struct xfs_fsop_geom {
 #define XFS_FSOP_GEOM_SICK_RT_SUMMARY	(1 << 5)  /* realtime summary */
 #define XFS_FSOP_GEOM_SICK_QUOTACHECK	(1 << 6)  /* quota counts */
 #define XFS_FSOP_GEOM_SICK_NLINKS	(1 << 7)  /* inode link counts */
+#define XFS_FSOP_GEOM_SICK_METADIR	(1 << 8)  /* metadata directory */
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 252334bc0488..99d53bae9c13 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -60,6 +60,7 @@ struct xfs_da_args;
 #define XFS_SICK_FS_PQUOTA	(1 << 3)  /* project quota */
 #define XFS_SICK_FS_QUOTACHECK	(1 << 4)  /* quota counts */
 #define XFS_SICK_FS_NLINKS	(1 << 5)  /* inode link counts */
+#define XFS_SICK_FS_METADIR	(1 << 6)  /* metadata directory tree */
 
 /* Observable health issues for realtime volume metadata. */
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
@@ -96,7 +97,8 @@ struct xfs_da_args;
 				 XFS_SICK_FS_GQUOTA | \
 				 XFS_SICK_FS_PQUOTA | \
 				 XFS_SICK_FS_QUOTACHECK | \
-				 XFS_SICK_FS_NLINKS)
+				 XFS_SICK_FS_NLINKS | \
+				 XFS_SICK_FS_METADIR)
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
 				 XFS_SICK_RT_SUMMARY)
diff --git a/fs/xfs/libxfs/xfs_imeta.c b/fs/xfs/libxfs/xfs_imeta.c
index 8960c13117fc..e4db1651d067 100644
--- a/fs/xfs/libxfs/xfs_imeta.c
+++ b/fs/xfs/libxfs/xfs_imeta.c
@@ -26,6 +26,7 @@
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 /*
  * Metadata Inode Number Management
@@ -405,16 +406,22 @@ xfs_imeta_dir_lookup_component(
 
 	trace_xfs_imeta_dir_lookup_component(dp, xname, NULLFSINO);
 
-	if (!S_ISDIR(VFS_I(dp)->i_mode))
+	if (!S_ISDIR(VFS_I(dp)->i_mode)) {
+		xfs_fs_mark_sick(dp->i_mount, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
+	}
 
 	error = xfs_imeta_dir_lookup(dp, xname, ino);
 	if (error)
 		return error;
-	if (!xfs_verify_ino(dp->i_mount, *ino))
+	if (!xfs_verify_ino(dp->i_mount, *ino)) {
+		xfs_fs_mark_sick(dp->i_mount, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
-	if (type_wanted != XFS_DIR3_FT_UNKNOWN && xname->type != type_wanted)
+	}
+	if (type_wanted != XFS_DIR3_FT_UNKNOWN && xname->type != type_wanted) {
+		xfs_fs_mark_sick(dp->i_mount, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
+	}
 
 	trace_xfs_imeta_dir_lookup_found(dp, xname, *ino);
 	return 0;
@@ -713,6 +720,7 @@ xfs_imeta_dir_unlink(
 	/* Metadata directory root cannot be unlinked. */
 	if (xfs_imeta_path_compare(path, &XFS_IMETA_METADIR)) {
 		ASSERT(0);
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
 	}
 
@@ -728,6 +736,7 @@ xfs_imeta_dir_unlink(
 			error = -ENOENT;
 		break;
 	case -ENOENT:
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		error = -EFSCORRUPTED;
 		break;
 	}
@@ -779,6 +788,7 @@ xfs_imeta_dir_link(
 	/* Metadata directory root cannot be linked. */
 	if (xfs_imeta_path_compare(path, &XFS_IMETA_METADIR)) {
 		ASSERT(0);
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
 	}
 
@@ -856,16 +866,20 @@ xfs_imeta_lookup(
 
 	if (xfs_has_metadir(mp)) {
 		error = xfs_imeta_dir_lookup_int(mp, path, &ino);
-		if (error == -ENOENT)
+		if (error == -ENOENT) {
+			xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 			return -EFSCORRUPTED;
+		}
 	} else {
 		error = xfs_imeta_sb_lookup(mp, path, &ino);
 	}
 	if (error)
 		return error;
 
-	if (!xfs_imeta_verify(mp, ino))
+	if (!xfs_imeta_verify(mp, ino)) {
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
+	}
 
 	*inop = ino;
 	return 0;
@@ -1041,8 +1055,10 @@ xfs_imeta_start_update(
 	 * to exist.
 	 */
 	error = xfs_imeta_dir_parent(mp, path, &upd->dp);
-	if (error == -ENOENT)
+	if (error == -ENOENT) {
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
+	}
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 6de8780b208a..61f7a6aca6b1 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -360,6 +360,7 @@ static const struct ioctl_sick_map fs_map[] = {
 	{ XFS_SICK_FS_PQUOTA,	XFS_FSOP_GEOM_SICK_PQUOTA },
 	{ XFS_SICK_FS_QUOTACHECK, XFS_FSOP_GEOM_SICK_QUOTACHECK },
 	{ XFS_SICK_FS_NLINKS,	XFS_FSOP_GEOM_SICK_NLINKS },
+	{ XFS_SICK_FS_METADIR,	XFS_FSOP_GEOM_SICK_METADIR },
 	{ 0, 0 },
 };
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index fc11ae6eae0b..728065bdfc32 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -940,6 +940,7 @@ xfs_imeta_iget(
 	xfs_irele(ip);
 whine:
 	xfs_err(mp, "metadata inode 0x%llx is corrupt", ino);
+	xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 	return -EFSCORRUPTED;
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 187c6025cfd8..51bceccd8c9a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -577,6 +577,7 @@ xfs_lookup(
 	 * metadata file.
 	 */
 	if (XFS_IS_CORRUPT(dp->i_mount, xfs_is_metadata_inode(*ipp))) {
+		xfs_fs_mark_sick(dp->i_mount, XFS_SICK_FS_METADIR);
 		error = -EFSCORRUPTED;
 		goto out_irele;
 	}

