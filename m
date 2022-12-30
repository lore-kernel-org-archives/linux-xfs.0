Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55E55C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236182AbiLaCOe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:14:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbiLaCOb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:14:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697F81C900
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:14:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0406561D1C
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3B4C433F0;
        Sat, 31 Dec 2022 02:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452869;
        bh=xtuvQA32xvLVepJlmh6qYxT4sNiQl7I3UBiffYveppk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BYNX47mI4gtKBZceacBAScmieKJBsSjqOpHGpXuCC9PwuD4Pu44/GDbxYcfcBHijO
         y8CjdU+0mNM4dilPaZngQ2W4FIlzpa3RagoinilOmEs9QiZhWgRoyKDiK/26B+jK+G
         jeYDE81rfxmI/zwi2lxRxuPt5g7NxrS5SOzgEFig7mnOMpEqwgmKYafu0x34Rns+vz
         6ilvfVrJVEPz+YQYZMUM8EJNTfae1560hxWyQoAYyAuYFsBwim05/iHlBUuPFl0mRT
         S+x848AUnQdJ6qvvvuL5daJlgPc6v+cMpxVPRIIjM+DTZnbicJt+n0SgGSo0oM0cMM
         b4sTlFJGMln1A==
Subject: [PATCH 18/46] xfs: record health problems with the metadata directory
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:21 -0800
Message-ID: <167243876173.725900.13619590794151530056.stgit@magnolia>
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

Make a report to the health monitoring subsystem any time we encounter
something in the metadata directory tree that looks like corruption.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h     |    1 +
 libxfs/xfs_health.h |    4 +++-
 libxfs/xfs_imeta.c  |   28 ++++++++++++++++++++++------
 3 files changed, 26 insertions(+), 7 deletions(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 6e0c45fcfee..c4995f6557d 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -197,6 +197,7 @@ struct xfs_fsop_geom {
 #define XFS_FSOP_GEOM_SICK_RT_SUMMARY	(1 << 5)  /* realtime summary */
 #define XFS_FSOP_GEOM_SICK_QUOTACHECK	(1 << 6)  /* quota counts */
 #define XFS_FSOP_GEOM_SICK_NLINKS	(1 << 7)  /* inode link counts */
+#define XFS_FSOP_GEOM_SICK_METADIR	(1 << 8)  /* metadata directory */
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 252334bc048..99d53bae9c1 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
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
diff --git a/libxfs/xfs_imeta.c b/libxfs/xfs_imeta.c
index eaf63275c08..a5d8e6057bb 100644
--- a/libxfs/xfs_imeta.c
+++ b/libxfs/xfs_imeta.c
@@ -25,6 +25,7 @@
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 /*
  * Metadata Inode Number Management
@@ -404,16 +405,22 @@ xfs_imeta_dir_lookup_component(
 
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
@@ -712,6 +719,7 @@ xfs_imeta_dir_unlink(
 	/* Metadata directory root cannot be unlinked. */
 	if (xfs_imeta_path_compare(path, &XFS_IMETA_METADIR)) {
 		ASSERT(0);
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
 	}
 
@@ -727,6 +735,7 @@ xfs_imeta_dir_unlink(
 			error = -ENOENT;
 		break;
 	case -ENOENT:
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		error = -EFSCORRUPTED;
 		break;
 	}
@@ -778,6 +787,7 @@ xfs_imeta_dir_link(
 	/* Metadata directory root cannot be linked. */
 	if (xfs_imeta_path_compare(path, &XFS_IMETA_METADIR)) {
 		ASSERT(0);
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
 	}
 
@@ -855,16 +865,20 @@ xfs_imeta_lookup(
 
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
@@ -1040,8 +1054,10 @@ xfs_imeta_start_update(
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
 

