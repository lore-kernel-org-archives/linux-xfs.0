Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96B1BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DyKLLJWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436F8C433C8;
	Sun, 31 Dec 2023 21:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057118;
	bh=ywNnlEIgRhIzpD+7wGbOgHckJ5eXVKZVQoZVGv90vMU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DyKLLJWNZaAQZMjltEigYrlOdOBKH4Vzx27zCCKB2u8C5+pFxQsGo1xjfCdRei2Lm
	 RTCj339Z5wQ5C2RIiQsO9d/20ORohtfpNPFmuK+Ogu5F+T3A9TKGtjEXJxQGeoChyu
	 EHnt8mdeNM1ktqTDxC0ex+HI/JXC/mptHJrIWfypeMNMOqsv+nZMIBSl7V0sD3h1kU
	 NRSkYouRgE1Hx5ngi73wdyzN7bXSaSID3oVs+jXXIloXMURLw7vEXkk80pdrQqbTCD
	 X3xHZ4iYnuemYjMIq52kNRcwUBlgf791W95x/WKU6346Ly/GwUNBpMjTdlfuiHBGss
	 MQGFglcvXIAkw==
Date: Sun, 31 Dec 2023 13:11:57 -0800
Subject: [PATCH 22/32] xfs: record health problems with the metadata directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404845220.1760491.2484247512169305686.stgit@frogsfrogsfrogs>
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

Make a report to the health monitoring subsystem any time we encounter
something in the metadata directory tree that looks like corruption.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h     |    1 +
 fs/xfs/libxfs/xfs_health.h |    4 +++-
 fs/xfs/libxfs/xfs_imeta.c  |   24 +++++++++++++++++++-----
 fs/xfs/xfs_health.c        |    1 +
 fs/xfs/xfs_icache.c        |    1 +
 fs/xfs/xfs_imeta_utils.c   |    5 ++++-
 fs/xfs/xfs_inode.c         |    1 +
 7 files changed, 30 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index ab961a0118157..952e4fc93c4cf 100644
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
index bca1990f71da8..d9b9968607f12 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
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
diff --git a/fs/xfs/libxfs/xfs_imeta.c b/fs/xfs/libxfs/xfs_imeta.c
index 10249a1c36c73..57be23f89d864 100644
--- a/fs/xfs/libxfs/xfs_imeta.c
+++ b/fs/xfs/libxfs/xfs_imeta.c
@@ -26,6 +26,7 @@
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_health.h"
 
 /*
  * Metadata File Management
@@ -406,16 +407,22 @@ xfs_imeta_dir_lookup_component(
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
@@ -729,6 +736,7 @@ xfs_imeta_dir_unlink(
 	/* Metadata directory root cannot be unlinked. */
 	if (xfs_imeta_path_compare(upd->path, &XFS_IMETA_METADIR)) {
 		ASSERT(0);
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
 	}
 
@@ -744,6 +752,7 @@ xfs_imeta_dir_unlink(
 			error = -ENOENT;
 		break;
 	case -ENOENT:
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		error = -EFSCORRUPTED;
 		break;
 	}
@@ -788,6 +797,7 @@ xfs_imeta_dir_link(
 	/* Metadata directory root cannot be linked. */
 	if (xfs_imeta_path_compare(upd->path, &XFS_IMETA_METADIR)) {
 		ASSERT(0);
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
 	}
 
@@ -853,16 +863,20 @@ xfs_imeta_lookup(
 
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
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 15ebfe331f277..09094b271e54e 100644
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
index 64c52e8621fdb..27cef2922d206 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -850,6 +850,7 @@ xfs_imeta_iget(
 	xfs_irele(ip);
 whine:
 	xfs_err(mp, "metadata inode 0x%llx is corrupt", ino);
+	xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 	return -EFSCORRUPTED;
 }
 
diff --git a/fs/xfs/xfs_imeta_utils.c b/fs/xfs/xfs_imeta_utils.c
index 9fbaa4323e3b2..e871d5b52e7be 100644
--- a/fs/xfs/xfs_imeta_utils.c
+++ b/fs/xfs/xfs_imeta_utils.c
@@ -23,6 +23,7 @@
 #include "xfs_imeta_utils.h"
 #include "xfs_trace.h"
 #include "xfs_parent.h"
+#include "xfs_health.h"
 
 /* Initialize a metadata update structure. */
 static inline int
@@ -52,8 +53,10 @@ xfs_imeta_init(
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
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 66aa8bbcb1045..322fa538aec4b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -582,6 +582,7 @@ xfs_lookup(
 	 * a metadata file.
 	 */
 	if (XFS_IS_CORRUPT(dp->i_mount, xfs_is_metadir_inode(*ipp))) {
+		xfs_fs_mark_sick(dp->i_mount, XFS_SICK_FS_METADIR);
 		error = -EFSCORRUPTED;
 		goto out_irele;
 	}

