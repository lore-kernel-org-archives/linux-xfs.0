Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628A9C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Buw87/AQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7F1C433C8;
	Sun, 31 Dec 2023 23:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065704;
	bh=ByptrlMGc6Zq405DrCdniI3nU9mv1SqnUV2VRQyxQnI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Buw87/AQWshCZ0ofhCCFzagpjrTijLPl0qIP8Nrj6O1EMNvroTMYgNTiemzOYGkiV
	 rvHfXjj9/KoRXCjrfBIkS+dLy/v9Yp7A2N0hUM+RPEzJVQXRYQ1PQNG5Sm3uOCO3Om
	 JUSCypWLWrPco2FWj29xqqLjCpFJaKUfwbQkF7D6dRvxEDffN1KaA5saGT4ks7upO4
	 zbDuV5WA7xFfda8cThH4xAQS8KmGTT5wfS8ivwnnVW76zBdX5uKDFq1wEvQJD1vIk+
	 59kZJes/LIyTU44qKjb8tXgP/pGoNw/Bh3cgNyTwyELIWaaLz4LyJOzBTe324tQVIE
	 mRQGsM3q7WRHw==
Date: Sun, 31 Dec 2023 15:35:03 -0800
Subject: [PATCH 21/58] xfs: record health problems with the metadata directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010227.1809361.12610565692089952318.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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

Make a report to the health monitoring subsystem any time we encounter
something in the metadata directory tree that looks like corruption.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/imeta_utils.c |    5 ++++-
 libxfs/xfs_fs.h      |    1 +
 libxfs/xfs_health.h  |    4 +++-
 libxfs/xfs_imeta.c   |   24 +++++++++++++++++++-----
 4 files changed, 27 insertions(+), 7 deletions(-)


diff --git a/libxfs/imeta_utils.c b/libxfs/imeta_utils.c
index 0186968ed3e..3b6e891d2a6 100644
--- a/libxfs/imeta_utils.c
+++ b/libxfs/imeta_utils.c
@@ -21,6 +21,7 @@
 #include "xfs_imeta.h"
 #include "xfs_trace.h"
 #include "xfs_parent.h"
+#include "xfs_health.h"
 #include "imeta_utils.h"
 
 /* Initialize a metadata update structure. */
@@ -51,8 +52,10 @@ xfs_imeta_init(
 		return error;
 	error = xfs_imeta_dir_parent(tp, upd->path, &upd->dp);
 	xfs_trans_cancel(tp);
-	if (error == -ENOENT)
+	if (error == -ENOENT) {
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
+	}
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index ab961a01181..952e4fc93c4 100644
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
index bca1990f71d..d9b9968607f 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -60,6 +60,7 @@ struct xfs_da_args;
 #define XFS_SICK_FS_PQUOTA	(1 << 3)  /* project quota */
 #define XFS_SICK_FS_QUOTACHECK	(1 << 4)  /* quota counts */
 #define XFS_SICK_FS_NLINKS	(1 << 5)  /* inode link counts */
+#define XFS_SICK_FS_METADIR	(1 << 6)  /* metadata directory tree */
 
 /* Observable health issues for realtime volume metadata. */
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
@@ -103,7 +104,8 @@ struct xfs_da_args;
 				 XFS_SICK_FS_GQUOTA | \
 				 XFS_SICK_FS_PQUOTA | \
 				 XFS_SICK_FS_QUOTACHECK | \
-				 XFS_SICK_FS_NLINKS)
+				 XFS_SICK_FS_NLINKS | \
+				 XFS_SICK_FS_METADIR)
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
 				 XFS_SICK_RT_SUMMARY)
diff --git a/libxfs/xfs_imeta.c b/libxfs/xfs_imeta.c
index ad429c82b47..6ada36d5559 100644
--- a/libxfs/xfs_imeta.c
+++ b/libxfs/xfs_imeta.c
@@ -25,6 +25,7 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_health.h"
 
 /*
  * Metadata File Management
@@ -405,16 +406,22 @@ xfs_imeta_dir_lookup_component(
 	int			type_wanted = xname->type;
 	int			error;
 
-	if (!S_ISDIR(VFS_I(dp)->i_mode))
+	if (!S_ISDIR(VFS_I(dp)->i_mode)) {
+		xfs_fs_mark_sick(dp->i_mount, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
+	}
 
 	error = xfs_imeta_dir_lookup(tp, dp, xname, ino);
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
 
 	trace_xfs_imeta_dir_lookup(dp, xname, *ino);
 	return 0;
@@ -728,6 +735,7 @@ xfs_imeta_dir_unlink(
 	/* Metadata directory root cannot be unlinked. */
 	if (xfs_imeta_path_compare(upd->path, &XFS_IMETA_METADIR)) {
 		ASSERT(0);
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
 	}
 
@@ -743,6 +751,7 @@ xfs_imeta_dir_unlink(
 			error = -ENOENT;
 		break;
 	case -ENOENT:
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		error = -EFSCORRUPTED;
 		break;
 	}
@@ -787,6 +796,7 @@ xfs_imeta_dir_link(
 	/* Metadata directory root cannot be linked. */
 	if (xfs_imeta_path_compare(upd->path, &XFS_IMETA_METADIR)) {
 		ASSERT(0);
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
 	}
 
@@ -852,16 +862,20 @@ xfs_imeta_lookup(
 
 	if (xfs_has_metadir(mp)) {
 		error = xfs_imeta_dir_lookup_int(tp, path, &ino);
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

