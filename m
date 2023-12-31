Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A91BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LD/CMmwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7105C433C7;
	Sun, 31 Dec 2023 21:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057227;
	bh=IgyhKtkVzJyEYjilPowA94ZT3cOhh/EZm/PdGiMl8Gg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LD/CMmwKXdqsJAbIJcFeY44j74NDDfN3iWr6PjdZ2Kj38O5uJwl+EXDUta3PrXPDK
	 zQro02dYm10XGgaMx8G4iOIzLXDXdg6E77c01q0KYu++xy31Or/Btbn1wNm7i6Igdr
	 QZbJI0bWVx1/68IZBpGQi/0NKzcUsYNm/5Rfz9bRUBTDpnN1KcFYmAWE35I+uFZex6
	 dXcdT9eFgQWcOj+Z0jmuoEIEnIE+ByMxdSAK+ZjSulJOBXRHYvF6el0EGncLJy+B69
	 BGSIW3uTZMsGVI5ASoYISphhIUcbfp3pejRaHu0iTXFUilvX1HyFBQh2vBZv7S+2Ux
	 G3LlO3MIMPhzA==
Date: Sun, 31 Dec 2023 13:13:47 -0800
Subject: [PATCH 29/32] xfs: check metadata directory file path connectivity
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404845332.1760491.15265829210239541655.stgit@frogsfrogsfrogs>
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

Create a new scrubber type that checks that well known metadata
directory paths are connected to the metadata inode that the incore
structures think is in use.  IOWs, check that "/quota/user" in the
metadata directory tree actually points to
mp->m_quotainfo->qi_uquotaip->i_ino.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile            |    1 
 fs/xfs/libxfs/xfs_fs.h     |   17 +++
 fs/xfs/libxfs/xfs_health.h |    4 +
 fs/xfs/scrub/common.h      |    1 
 fs/xfs/scrub/health.c      |    1 
 fs/xfs/scrub/metapath.c    |  250 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c       |    9 ++
 fs/xfs/scrub/scrub.h       |    2 
 fs/xfs/scrub/stats.c       |    1 
 fs/xfs/scrub/trace.c       |    1 
 fs/xfs/scrub/trace.h       |   45 ++++++++
 fs/xfs/xfs_health.c        |    1 
 12 files changed, 330 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/scrub/metapath.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 29cf5a5f8104a..5362a0fb56d77 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -173,6 +173,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   inode.o \
 				   iscan.o \
 				   listxattr.o \
+				   metapath.o \
 				   nlinks.o \
 				   parent.o \
 				   readdir.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 952e4fc93c4cf..a0efcbde5ae60 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -198,6 +198,7 @@ struct xfs_fsop_geom {
 #define XFS_FSOP_GEOM_SICK_QUOTACHECK	(1 << 6)  /* quota counts */
 #define XFS_FSOP_GEOM_SICK_NLINKS	(1 << 7)  /* inode link counts */
 #define XFS_FSOP_GEOM_SICK_METADIR	(1 << 8)  /* metadata directory */
+#define XFS_FSOP_GEOM_SICK_METAPATH	(1 << 9)  /* metadir tree path */
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
@@ -731,9 +732,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_NLINKS	26	/* inode link counts */
 #define XFS_SCRUB_TYPE_HEALTHY	27	/* everything checked out ok */
 #define XFS_SCRUB_TYPE_DIRTREE	28	/* directory tree structure */
+#define XFS_SCRUB_TYPE_METAPATH	29	/* metadata directory tree paths */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	29
+#define XFS_SCRUB_TYPE_NR	30
 
 /*
  * This special type code only applies to the vectored scrub implementation.
@@ -788,6 +790,19 @@ struct xfs_scrub_metadata {
 				 XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
 #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
 
+/*
+ * i: sm_ino values for XFS_SCRUB_TYPE_METAPATH to select a metadata file for
+ * path checking.
+ */
+#define XFS_SCRUB_METAPATH_RTBITMAP	0
+#define XFS_SCRUB_METAPATH_RTSUMMARY	1
+#define XFS_SCRUB_METAPATH_USRQUOTA	2
+#define XFS_SCRUB_METAPATH_GRPQUOTA	3
+#define XFS_SCRUB_METAPATH_PRJQUOTA	4
+
+/* Number of metapath sm_ino values */
+#define XFS_SCRUB_METAPATH_NR		5
+
 /*
  * ioctl limits
  */
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index d9b9968607f12..1816c67351ac8 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -61,6 +61,7 @@ struct xfs_da_args;
 #define XFS_SICK_FS_QUOTACHECK	(1 << 4)  /* quota counts */
 #define XFS_SICK_FS_NLINKS	(1 << 5)  /* inode link counts */
 #define XFS_SICK_FS_METADIR	(1 << 6)  /* metadata directory tree */
+#define XFS_SICK_FS_METAPATH	(1 << 7)  /* metadata directory tree path */
 
 /* Observable health issues for realtime volume metadata. */
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
@@ -105,7 +106,8 @@ struct xfs_da_args;
 				 XFS_SICK_FS_PQUOTA | \
 				 XFS_SICK_FS_QUOTACHECK | \
 				 XFS_SICK_FS_NLINKS | \
-				 XFS_SICK_FS_METADIR)
+				 XFS_SICK_FS_METADIR | \
+				 XFS_SICK_FS_METAPATH)
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
 				 XFS_SICK_RT_SUMMARY)
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index a90c82c18e3c9..11a893e4b228e 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -68,6 +68,7 @@ int xchk_setup_xattr(struct xfs_scrub *sc);
 int xchk_setup_symlink(struct xfs_scrub *sc);
 int xchk_setup_parent(struct xfs_scrub *sc);
 int xchk_setup_dirtree(struct xfs_scrub *sc);
+int xchk_setup_metapath(struct xfs_scrub *sc);
 #ifdef CONFIG_XFS_RT
 int xchk_setup_rtbitmap(struct xfs_scrub *sc);
 int xchk_setup_rtsummary(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 12f3e9fca727f..4aae9a594cce5 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -111,6 +111,7 @@ static const struct xchk_health_map type_to_health_flag[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_QUOTACHECK]	= { XHG_FS,  XFS_SICK_FS_QUOTACHECK },
 	[XFS_SCRUB_TYPE_NLINKS]		= { XHG_FS,  XFS_SICK_FS_NLINKS },
 	[XFS_SCRUB_TYPE_DIRTREE]	= { XHG_INO, XFS_SICK_INO_DIRTREE },
+	[XFS_SCRUB_TYPE_METAPATH]	= { XHG_FS,  XFS_SICK_FS_METAPATH },
 };
 
 /* Return the health status mask for this scrub type. */
diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
new file mode 100644
index 0000000000000..fac957de282c3
--- /dev/null
+++ b/fs/xfs/scrub/metapath.c
@@ -0,0 +1,250 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_inode.h"
+#include "xfs_imeta.h"
+#include "xfs_imeta_utils.h"
+#include "xfs_quota.h"
+#include "xfs_qm.h"
+#include "xfs_dir2.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/readdir.h"
+
+/*
+ * Metadata Directory Tree Paths
+ * =============================
+ *
+ * A filesystem with metadir enabled expects to find metadata structures
+ * attached to files that are accessible by walking a path down the metadata
+ * directory tree.  Given the metadir path and the incore inode storing the
+ * metadata, this scrubber ensures that the ondisk metadir path points to the
+ * ondisk inode represented by the incore inode.
+ */
+
+struct xchk_metapath {
+	struct xfs_scrub		*sc;
+
+	/* Name for lookup */
+	struct xfs_name			xname;
+
+	/* Path for this metadata file */
+	const struct xfs_imeta_path	*path;
+
+	/* Directory parent of the metadata file. */
+	struct xfs_inode		*dp;
+
+	/* Locks held on dp */
+	unsigned int			dp_ilock_flags;
+};
+
+/* Release resources tracked in the buffer. */
+STATIC void
+xchk_metapath_cleanup(
+	void			*buf)
+{
+	struct xchk_metapath	*mpath = buf;
+	struct xfs_scrub	*sc = mpath->sc;
+
+	if (mpath->dp) {
+		if (mpath->dp_ilock_flags)
+			xfs_iunlock(mpath->dp, mpath->dp_ilock_flags);
+		xchk_irele(sc, mpath->dp);
+	}
+	if (mpath->path)
+		xfs_imeta_free_path(mpath->path);
+}
+
+int
+xchk_setup_metapath(
+	struct xfs_scrub	*sc)
+{
+	struct xchk_metapath	*mpath;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_inode	*ip = NULL;
+	int			error;
+
+	if (!xfs_has_metadir(mp))
+		return -ENOENT;
+	if (sc->sm->sm_gen || sc->sm->sm_agno)
+		return -EINVAL;
+
+	mpath = kzalloc(sizeof(struct xchk_metapath), XCHK_GFP_FLAGS);
+	if (!mpath)
+		return -ENOMEM;
+	mpath->sc = sc;
+	sc->buf = mpath;
+	sc->buf_cleanup = xchk_metapath_cleanup;
+
+	/* Select the metadir path and the metadata file. */
+	switch (sc->sm->sm_ino) {
+	case XFS_SCRUB_METAPATH_RTBITMAP:
+		mpath->path = &XFS_IMETA_RTBITMAP;
+		ip = mp->m_rbmip;
+		break;
+	case XFS_SCRUB_METAPATH_RTSUMMARY:
+		mpath->path = &XFS_IMETA_RTSUMMARY;
+		ip = mp->m_rsumip;
+		break;
+	case XFS_SCRUB_METAPATH_USRQUOTA:
+		mpath->path = &XFS_IMETA_USRQUOTA;
+		if (XFS_IS_UQUOTA_ON(mp))
+			ip = xfs_quota_inode(mp, XFS_DQTYPE_USER);
+		break;
+	case XFS_SCRUB_METAPATH_GRPQUOTA:
+		mpath->path = &XFS_IMETA_GRPQUOTA;
+		if (XFS_IS_GQUOTA_ON(mp))
+			ip = xfs_quota_inode(mp, XFS_DQTYPE_GROUP);
+		break;
+	case XFS_SCRUB_METAPATH_PRJQUOTA:
+		mpath->path = &XFS_IMETA_PRJQUOTA;
+		if (XFS_IS_PQUOTA_ON(mp))
+			ip = xfs_quota_inode(mp, XFS_DQTYPE_PROJ);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (mpath->path->im_depth < 1) {
+		/* Not supposed to have any zero-length paths */
+		ASSERT(mpath->path->im_depth >= 1);
+		return -EFSCORRUPTED;
+	}
+
+	if (!ip)
+		return -ENOENT;
+
+	error = xchk_install_live_inode(sc, ip);
+	if (error)
+		return error;
+
+	mpath->xname.name = mpath->path->im_path[mpath->path->im_depth - 1];
+	mpath->xname.len = strlen(mpath->xname.name);
+	mpath->xname.type = xfs_mode_to_ftype(VFS_I(sc->ip)->i_mode);
+	return 0;
+}
+
+/*
+ * Try to attach the parent metadata directory to the scrub context.  Returns
+ * true if a parent is attached.
+ */
+STATIC bool
+xchk_metapath_try_attach_parent(
+	struct xchk_metapath	*mpath)
+{
+	struct xfs_scrub	*sc = mpath->sc;
+
+	if (mpath->dp)
+		return true;
+
+	/*
+	 * Grab the parent we just ensured.  If the parent itself is corrupt
+	 * enough that xfs_iget fails, someone else will have to fix it for us.
+	 * That someone are the inode and scrubbers, invoked on the parent dir
+	 * via handle.
+	 */
+	xfs_imeta_dir_parent(sc->tp, mpath->path, &mpath->dp);
+
+	trace_xchk_metapath_try_attach_parent(sc, mpath->path, mpath->dp,
+			NULLFSINO);
+	return mpath->dp != NULL;
+}
+
+/*
+ * Take the ILOCK on the metadata directory parent and child.  We do not know
+ * that the metadata directory is not corrupt, so we lock the parent and try
+ * to lock the child.  Returns 0 if successful, or -EINTR to abort the scrub.
+ */
+STATIC int
+xchk_metapath_ilock_both(
+	struct xchk_metapath	*mpath)
+{
+	struct xfs_scrub	*sc = mpath->sc;
+	int			error = 0;
+
+	while (true) {
+		xfs_ilock(mpath->dp, XFS_ILOCK_EXCL);
+		if (xchk_ilock_nowait(sc, XFS_ILOCK_EXCL)) {
+			mpath->dp_ilock_flags |= XFS_ILOCK_EXCL;
+			return 0;
+		}
+		xfs_iunlock(mpath->dp, XFS_ILOCK_EXCL);
+
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
+		delay(1);
+	}
+
+	ASSERT(0);
+	return -EINTR;
+}
+
+/* Unlock parent and child inodes. */
+static inline void
+xchk_metapath_iunlock(
+	struct xchk_metapath	*mpath)
+{
+	struct xfs_scrub	*sc = mpath->sc;
+
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+
+	mpath->dp_ilock_flags &= ~XFS_ILOCK_EXCL;
+	xfs_iunlock(mpath->dp, XFS_ILOCK_EXCL);
+}
+
+int
+xchk_metapath(
+	struct xfs_scrub	*sc)
+{
+	struct xchk_metapath	*mpath = sc->buf;
+	xfs_ino_t		ino = NULLFSINO;
+	int			error;
+
+	error = xchk_trans_alloc_empty(sc);
+	if (error)
+		return error;
+
+	/* Grab the parent; if we can't, it's corrupt. */
+	if (!xchk_metapath_try_attach_parent(mpath)) {
+		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+		goto out_cancel;
+	}
+
+	error = xchk_metapath_ilock_both(mpath);
+	if (error)
+		goto out_cancel;
+
+	/* Make sure the parent dir has a dirent pointing to this file. */
+	error = xchk_dir_lookup(sc, mpath->dp, &mpath->xname, &ino);
+	trace_xchk_metapath_lookup(sc, mpath->path, mpath->dp, ino);
+	if (error == -ENOENT) {
+		/* No directory entry at all */
+		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+		error = 0;
+		goto out_ilock;
+	}
+	if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
+		goto out_ilock;
+	if (ino != sc->ip->i_ino) {
+		/* Pointing to wrong inode */
+		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+	}
+
+out_ilock:
+	xchk_metapath_iunlock(mpath);
+out_cancel:
+	xchk_trans_cancel(sc);
+	return error;
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 7b70dfb30287b..07d3ed91259ce 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -447,6 +447,13 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.has	= xfs_has_parent,
 		.repair	= xrep_dirtree,
 	},
+	[XFS_SCRUB_TYPE_METAPATH] = {	/* metadata directory tree path */
+		.type	= ST_GENERIC,
+		.setup	= xchk_setup_metapath,
+		.scrub	= xchk_metapath,
+		.has	= xfs_has_metadir,
+		.repair	= xrep_notsupported,
+	},
 };
 
 static int
@@ -494,6 +501,8 @@ xchk_validate_inputs(
 		if (sm->sm_agno || (sm->sm_gen && !sm->sm_ino))
 			goto out;
 		break;
+	case ST_GENERIC:
+		break;
 	default:
 		goto out;
 	}
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index ecd7aff7a48bf..b48199d8940b8 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -66,6 +66,7 @@ enum xchk_type {
 	ST_PERAG,	/* per-AG metadata */
 	ST_FS,		/* per-FS metadata */
 	ST_INODE,	/* per-inode metadata */
+	ST_GENERIC,	/* determined by the scrubber */
 };
 
 struct xchk_meta_ops {
@@ -250,6 +251,7 @@ int xchk_xattr(struct xfs_scrub *sc);
 int xchk_symlink(struct xfs_scrub *sc);
 int xchk_parent(struct xfs_scrub *sc);
 int xchk_dirtree(struct xfs_scrub *sc);
+int xchk_metapath(struct xfs_scrub *sc);
 #ifdef CONFIG_XFS_RT
 int xchk_rtbitmap(struct xfs_scrub *sc);
 int xchk_rtsummary(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index fd92df6389ac8..2e576c601b7dc 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -80,6 +80,7 @@ static const char *name_map[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_QUOTACHECK]	= "quotacheck",
 	[XFS_SCRUB_TYPE_NLINKS]		= "nlinks",
 	[XFS_SCRUB_TYPE_DIRTREE]	= "dirtree",
+	[XFS_SCRUB_TYPE_METAPATH]	= "metapath",
 };
 
 /* Format the scrub stats into a text buffer, similar to pcp style. */
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 994a910eead80..06f7b89920e94 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -21,6 +21,7 @@
 #include "xfs_dir2.h"
 #include "xfs_rmap.h"
 #include "xfs_parent.h"
+#include "xfs_imeta.h"
 #include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 83ad76a18b2c0..f7a0f4de23a55 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -32,6 +32,7 @@ struct xfs_parent_name_irec;
 enum xchk_dirpath_outcome;
 struct xchk_dirtree;
 struct xchk_dirtree_outcomes;
+struct xfs_imeta_path;
 
 /*
  * ftrace's __print_symbolic requires that all enum values be wrapped in the
@@ -81,6 +82,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_NLINKS);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_HEALTHY);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_DIRTREE);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BARRIER);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_METAPATH);
 
 #define XFS_SCRUB_TYPE_STRINGS \
 	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
@@ -112,7 +114,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BARRIER);
 	{ XFS_SCRUB_TYPE_NLINKS,	"nlinks" }, \
 	{ XFS_SCRUB_TYPE_HEALTHY,	"healthy" }, \
 	{ XFS_SCRUB_TYPE_DIRTREE,	"dirtree" }, \
-	{ XFS_SCRUB_TYPE_BARRIER,	"barrier" }
+	{ XFS_SCRUB_TYPE_BARRIER,	"barrier" }, \
+	{ XFS_SCRUB_TYPE_METAPATH,	"metapath" }
 
 #define XFS_SCRUB_FLAG_STRINGS \
 	{ XFS_SCRUB_IFLAG_REPAIR,		"repair" }, \
@@ -1926,6 +1929,46 @@ TRACE_EVENT(xchk_dirtree_live_update,
 		  __get_str(name))
 );
 
+DECLARE_EVENT_CLASS(xchk_metapath_class,
+	TP_PROTO(struct xfs_scrub *sc, const struct xfs_imeta_path *path,
+		 struct xfs_inode *dp, xfs_ino_t ino),
+	TP_ARGS(sc, path, dp, ino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, scrub_ino)
+		__field(xfs_ino_t, parent_ino)
+		__field(xfs_ino_t, ino)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, strlen(path->im_path[path->im_depth - 1]))
+	),
+	TP_fast_assign(
+		const unsigned char *p;
+
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->scrub_ino = sc->ip ? sc->ip->i_ino : NULLFSINO;
+		__entry->parent_ino = dp ? dp->i_ino : NULLFSINO;
+		__entry->ino = ino;
+
+		p = path->im_path[path->im_depth - 1];
+		__entry->namelen = strlen(p);
+		memcpy(__get_str(name), p, __entry->namelen);
+	),
+	TP_printk("dev %d:%d ino 0x%llx parent_ino 0x%llx name '%.*s' ino 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->scrub_ino,
+		  __entry->parent_ino,
+		  __entry->namelen,
+		  __get_str(name),
+		  __entry->ino)
+);
+#define DEFINE_XCHK_METAPATH_EVENT(name) \
+DEFINE_EVENT(xchk_metapath_class, name, \
+	TP_PROTO(struct xfs_scrub *sc, const struct xfs_imeta_path *path, \
+		 struct xfs_inode *dp, xfs_ino_t ino), \
+	TP_ARGS(sc, path, dp, ino))
+DEFINE_XCHK_METAPATH_EVENT(xchk_metapath_try_attach_parent);
+DEFINE_XCHK_METAPATH_EVENT(xchk_metapath_lookup);
+
 /* repair tracepoints */
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
 
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 09094b271e54e..b7aa33a4c9e06 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -361,6 +361,7 @@ static const struct ioctl_sick_map fs_map[] = {
 	{ XFS_SICK_FS_QUOTACHECK, XFS_FSOP_GEOM_SICK_QUOTACHECK },
 	{ XFS_SICK_FS_NLINKS,	XFS_FSOP_GEOM_SICK_NLINKS },
 	{ XFS_SICK_FS_METADIR,	XFS_FSOP_GEOM_SICK_METADIR },
+	{ XFS_SICK_FS_METAPATH,	XFS_FSOP_GEOM_SICK_METAPATH },
 	{ 0, 0 },
 };
 

