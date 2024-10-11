Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D6BFBF0
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608111; cv=none; b=mt2BAh0BNHWn+Y51VRvI8zVPSCYtV/v3njzQgVEWtepWUS2Upq9UbylU+xUrosuGzA/foudKfE85M1zGXBHWEDLu7JYcqVS37o1KEozw5dZok6XsM7DR7rkKJiLbN2U7Vi3cOW0AeSuSHyDpHt64pkrOEDGuTRqdfuMDLPBxXNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608111; c=relaxed/simple;
	bh=QJeWmcphuEHUKHQ/w2ruFTF3OKGgncqfKs2un+k7uFk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zn0IpApezimAZf41+Ok9AXgJXqgKPEEbCsiaCw17xkEexowyVDEK+IRZvgzKCFPqjqPQYWK85xYMkZpzfZ/7Rkhbj8Wc/bzxscWP5NqbQffPrMV3GqhNwLsNA8cuIGZDwmaDEc9dO1jYbVb17mDmV44M3q/fo3ZSKDY8ySu8lEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FigKVHUZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FigKVHUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DB1C4CEC5;
	Fri, 11 Oct 2024 00:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608110;
	bh=QJeWmcphuEHUKHQ/w2ruFTF3OKGgncqfKs2un+k7uFk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FigKVHUZGxRoVy923tp9iqq1YEMF66eoVEr5qUID3cfdPv0mtr0zDwuO8GwG5tHJ/
	 crxRxqM+mqAU3K5alEyeZpi01OB/qCEFr4ehYxfSWUmCjA4YahEDiIXOrguCpdc7Yt
	 nqNCjP1YXreB1rxi0I6fMoIxB8b0XRExwqVMdSG5KYx33sZ2+aMeu62UeDj3jAVZdC
	 Nl6NBfoMKTgZNQVfS0qfBm95MV0dBAuZVxOBYopHiOnySvw7vjRlp+A5oc/1cnOH1A
	 r5VPUmuhpD0Kx0jK32yuY9CL+000J5DMh51n0PVupItp+va03PonHswtBeYlCrYJ7E
	 R7B1bR/b6ro1w==
Date: Thu, 10 Oct 2024 17:55:10 -0700
Subject: [PATCH 26/28] xfs: check metadata directory file path connectivity
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860642465.4176876.14820091213062933112.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
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
structures think is in use.  For example, check that "/quota/user" in
the metadata directory tree actually points to
mp->m_quotainfo->qi_uquotaip->i_ino.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile            |    1 
 fs/xfs/libxfs/xfs_fs.h     |   13 +++
 fs/xfs/libxfs/xfs_health.h |    4 +
 fs/xfs/scrub/common.h      |    1 
 fs/xfs/scrub/health.c      |    1 
 fs/xfs/scrub/metapath.c    |  174 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c       |    9 ++
 fs/xfs/scrub/scrub.h       |    2 +
 fs/xfs/scrub/stats.c       |    1 
 fs/xfs/scrub/trace.c       |    1 
 fs/xfs/scrub/trace.h       |   36 +++++++++
 fs/xfs/xfs_health.c        |    1 
 12 files changed, 241 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/scrub/metapath.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index ba418a40aeb528..d80c2817eb4892 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -174,6 +174,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   inode.o \
 				   iscan.o \
 				   listxattr.o \
+				   metapath.o \
 				   nlinks.o \
 				   parent.o \
 				   readdir.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index b05e6fb1470351..faa38a7d1eb019 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -199,6 +199,7 @@ struct xfs_fsop_geom {
 #define XFS_FSOP_GEOM_SICK_QUOTACHECK	(1 << 6)  /* quota counts */
 #define XFS_FSOP_GEOM_SICK_NLINKS	(1 << 7)  /* inode link counts */
 #define XFS_FSOP_GEOM_SICK_METADIR	(1 << 8)  /* metadata directory */
+#define XFS_FSOP_GEOM_SICK_METAPATH	(1 << 9)  /* metadir tree path */
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
@@ -732,9 +733,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_NLINKS	26	/* inode link counts */
 #define XFS_SCRUB_TYPE_HEALTHY	27	/* everything checked out ok */
 #define XFS_SCRUB_TYPE_DIRTREE	28	/* directory tree structure */
+#define XFS_SCRUB_TYPE_METAPATH	29	/* metadata directory tree paths */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	29
+#define XFS_SCRUB_TYPE_NR	30
 
 /*
  * This special type code only applies to the vectored scrub implementation.
@@ -812,6 +814,15 @@ struct xfs_scrub_vec_head {
 
 #define XFS_SCRUB_VEC_FLAGS_ALL		(0)
 
+/*
+ * i: sm_ino values for XFS_SCRUB_TYPE_METAPATH to select a metadata file for
+ * path checking.
+ */
+#define XFS_SCRUB_METAPATH_PROBE	(0)  /* do we have a metapath scrubber? */
+
+/* Number of metapath sm_ino values */
+#define XFS_SCRUB_METAPATH_NR		(1)
+
 /*
  * ioctl limits
  */
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index b8846d35a6adbd..38310f240aed5d 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -63,6 +63,7 @@ struct xfs_da_args;
 #define XFS_SICK_FS_QUOTACHECK	(1 << 4)  /* quota counts */
 #define XFS_SICK_FS_NLINKS	(1 << 5)  /* inode link counts */
 #define XFS_SICK_FS_METADIR	(1 << 6)  /* metadata directory tree */
+#define XFS_SICK_FS_METAPATH	(1 << 7)  /* metadata directory tree path */
 
 /* Observable health issues for realtime volume metadata. */
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
@@ -107,7 +108,8 @@ struct xfs_da_args;
 				 XFS_SICK_FS_PQUOTA | \
 				 XFS_SICK_FS_QUOTACHECK | \
 				 XFS_SICK_FS_NLINKS | \
-				 XFS_SICK_FS_METADIR)
+				 XFS_SICK_FS_METADIR | \
+				 XFS_SICK_FS_METAPATH)
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
 				 XFS_SICK_RT_SUMMARY)
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index b419adc6e7cf2a..b2a81e85ded9cf 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -73,6 +73,7 @@ int xchk_setup_xattr(struct xfs_scrub *sc);
 int xchk_setup_symlink(struct xfs_scrub *sc);
 int xchk_setup_parent(struct xfs_scrub *sc);
 int xchk_setup_dirtree(struct xfs_scrub *sc);
+int xchk_setup_metapath(struct xfs_scrub *sc);
 #ifdef CONFIG_XFS_RT
 int xchk_setup_rtbitmap(struct xfs_scrub *sc);
 int xchk_setup_rtsummary(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index cd3afa67c636da..4fff359b197725 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -109,6 +109,7 @@ static const struct xchk_health_map type_to_health_flag[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_QUOTACHECK]	= { XHG_FS,  XFS_SICK_FS_QUOTACHECK },
 	[XFS_SCRUB_TYPE_NLINKS]		= { XHG_FS,  XFS_SICK_FS_NLINKS },
 	[XFS_SCRUB_TYPE_DIRTREE]	= { XHG_INO, XFS_SICK_INO_DIRTREE },
+	[XFS_SCRUB_TYPE_METAPATH]	= { XHG_FS,  XFS_SICK_FS_METAPATH },
 };
 
 /* Return the health status mask for this scrub type. */
diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
new file mode 100644
index 00000000000000..b7bd86df9877cd
--- /dev/null
+++ b/fs/xfs/scrub/metapath.c
@@ -0,0 +1,174 @@
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
+#include "xfs_metafile.h"
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
+	/* Path for this metadata file and the parent directory */
+	const char			*path;
+	const char			*parent_path;
+
+	/* Directory parent of the metadata file. */
+	struct xfs_inode		*dp;
+
+	/* Locks held on dp */
+	unsigned int			dp_ilock_flags;
+};
+
+/* Release resources tracked in the buffer. */
+static inline void
+xchk_metapath_cleanup(
+	void			*buf)
+{
+	struct xchk_metapath	*mpath = buf;
+
+	if (mpath->dp_ilock_flags)
+		xfs_iunlock(mpath->dp, mpath->dp_ilock_flags);
+	kfree(mpath->path);
+}
+
+int
+xchk_setup_metapath(
+	struct xfs_scrub	*sc)
+{
+	if (!xfs_has_metadir(sc->mp))
+		return -ENOENT;
+	if (sc->sm->sm_gen)
+		return -EINVAL;
+
+	switch (sc->sm->sm_ino) {
+	case XFS_SCRUB_METAPATH_PROBE:
+		/* Just probing, nothing else to do. */
+		if (sc->sm->sm_agno)
+			return -EINVAL;
+		return 0;
+	default:
+		return -ENOENT;
+	}
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
+	/* Just probing, nothing else to do. */
+	if (sc->sm->sm_ino == XFS_SCRUB_METAPATH_PROBE)
+		return 0;
+
+	/* Parent required to do anything else. */
+	if (mpath->dp == NULL) {
+		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+		return 0;
+	}
+
+	error = xchk_trans_alloc_empty(sc);
+	if (error)
+		return error;
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
index 4cbcf7a86dbec5..f1b2714e2894af 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -442,6 +442,13 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
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
@@ -489,6 +496,8 @@ xchk_validate_inputs(
 		if (sm->sm_agno || (sm->sm_gen && !sm->sm_ino))
 			goto out;
 		break;
+	case ST_GENERIC:
+		break;
 	default:
 		goto out;
 	}
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 5993fcaffb2c9f..c688ff4fc7fc4c 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -73,6 +73,7 @@ enum xchk_type {
 	ST_PERAG,	/* per-AG metadata */
 	ST_FS,		/* per-FS metadata */
 	ST_INODE,	/* per-inode metadata */
+	ST_GENERIC,	/* determined by the scrubber */
 };
 
 struct xchk_meta_ops {
@@ -255,6 +256,7 @@ int xchk_xattr(struct xfs_scrub *sc);
 int xchk_symlink(struct xfs_scrub *sc);
 int xchk_parent(struct xfs_scrub *sc);
 int xchk_dirtree(struct xfs_scrub *sc);
+int xchk_metapath(struct xfs_scrub *sc);
 #ifdef CONFIG_XFS_RT
 int xchk_rtbitmap(struct xfs_scrub *sc);
 int xchk_rtsummary(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index 7996c23354763d..edcd02dc2e62c0 100644
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
index 4470ad0533b81d..98f923ae664d0e 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -20,6 +20,7 @@
 #include "xfs_dir2.h"
 #include "xfs_rmap.h"
 #include "xfs_parent.h"
+#include "xfs_metafile.h"
 #include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index bc246d86a5c89f..bb52baaa2fa726 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -70,6 +70,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_NLINKS);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_HEALTHY);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_DIRTREE);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BARRIER);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_METAPATH);
 
 #define XFS_SCRUB_TYPE_STRINGS \
 	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
@@ -101,7 +102,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BARRIER);
 	{ XFS_SCRUB_TYPE_NLINKS,	"nlinks" }, \
 	{ XFS_SCRUB_TYPE_HEALTHY,	"healthy" }, \
 	{ XFS_SCRUB_TYPE_DIRTREE,	"dirtree" }, \
-	{ XFS_SCRUB_TYPE_BARRIER,	"barrier" }
+	{ XFS_SCRUB_TYPE_BARRIER,	"barrier" }, \
+	{ XFS_SCRUB_TYPE_METAPATH,	"metapath" }
 
 #define XFS_SCRUB_FLAG_STRINGS \
 	{ XFS_SCRUB_IFLAG_REPAIR,		"repair" }, \
@@ -1916,6 +1918,38 @@ TRACE_EVENT(xchk_dirtree_live_update,
 		  __get_str(name))
 );
 
+DECLARE_EVENT_CLASS(xchk_metapath_class,
+	TP_PROTO(struct xfs_scrub *sc, const char *path,
+		 struct xfs_inode *dp, xfs_ino_t ino),
+	TP_ARGS(sc, path, dp, ino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, scrub_ino)
+		__field(xfs_ino_t, parent_ino)
+		__field(xfs_ino_t, ino)
+		__string(name, path)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->scrub_ino = sc->ip ? sc->ip->i_ino : NULLFSINO;
+		__entry->parent_ino = dp ? dp->i_ino : NULLFSINO;
+		__entry->ino = ino;
+		__assign_str(name);
+	),
+	TP_printk("dev %d:%d ino 0x%llx parent_ino 0x%llx name '%s' ino 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->scrub_ino,
+		  __entry->parent_ino,
+		  __get_str(name),
+		  __entry->ino)
+);
+#define DEFINE_XCHK_METAPATH_EVENT(name) \
+DEFINE_EVENT(xchk_metapath_class, name, \
+	TP_PROTO(struct xfs_scrub *sc, const char *path, \
+		 struct xfs_inode *dp, xfs_ino_t ino), \
+	TP_ARGS(sc, path, dp, ino))
+DEFINE_XCHK_METAPATH_EVENT(xchk_metapath_lookup);
+
 /* repair tracepoints */
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
 
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index b149b9cf3402f1..b2272c7f737e3d 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -381,6 +381,7 @@ static const struct ioctl_sick_map fs_map[] = {
 	{ XFS_SICK_FS_QUOTACHECK, XFS_FSOP_GEOM_SICK_QUOTACHECK },
 	{ XFS_SICK_FS_NLINKS,	XFS_FSOP_GEOM_SICK_NLINKS },
 	{ XFS_SICK_FS_METADIR,	XFS_FSOP_GEOM_SICK_METADIR },
+	{ XFS_SICK_FS_METAPATH,	XFS_FSOP_GEOM_SICK_METAPATH },
 	{ 0, 0 },
 };
 

