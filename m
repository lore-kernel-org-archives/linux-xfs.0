Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1814E1CCB2D
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846154; cv=none; b=tz6In0XjlHl4DP4vmFeDD/SCCisSbrXJcINJeZ4hsStV37RRhfSruuyN+kigj3wwhoknfuTvnakq76RviwbZ9xZGaxJhBmUjVXBpKij+MJQOnNJuFQywr+iMZxVCXAP75BakILPYR8yAw6KIPDOSRldJMbRnDVWpu/F950fRhuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846154; c=relaxed/simple;
	bh=yWfZe4oKt1HGq+bvLaXOUpai4lQaiXcpliMjvIYqM8U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QoHtLdEye8/6TpT43Kc1mwz2fnmurwBZ+/Q++dRlBJDJEQRlTyTH2TK8vImDi6ZwA3sTbey0lSzJCfvbwxLeJjhYjcIDmK2SZXwxDzFd1FdQu1mH4gtK+sI+WfcawV4B3v/96/2uVr+4nb4Q9CWi0w66XEHhsynE6mp3+dx22dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uxviANLg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uxviANLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D4CC4CED0;
	Tue,  5 Nov 2024 22:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846154;
	bh=yWfZe4oKt1HGq+bvLaXOUpai4lQaiXcpliMjvIYqM8U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uxviANLg7EC3D7sCJp4O47DDmxrV2KhjA/a8snaakBhB9p4BBzzhTQ2qBzuY7jx94
	 v4UaCZ0sXN8mldWfUwfCD5tI1SF+izqjf8fIBRseoFpnoh3HvmoQGv96WWKQN1TTcd
	 Z+TpRyQKlfJb31n6ryB7kDW4TVuU7ftQInSepmgUaP9UYyxJF6tt9x16ku3pWPrV0G
	 VmDuuXwzn2yI7m+MFvD7QMPYFcrm7kjYUSxXQQkUB0PbO+8fKZs+g8U/7iW6/EL5A2
	 R2bDLeiv3dAfzil8lycu5AhCE1uEX4P433josugemRXrUB6wEFQUwbwdDlWPf64RzI
	 V0UvDU+Xu72ug==
Date: Tue, 05 Nov 2024 14:35:53 -0800
Subject: [PATCH 23/34] xfs: scrub the realtime group superblock
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084398577.1871887.9591477714275246106.stgit@frogsfrogsfrogs>
In-Reply-To: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
References: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Enable scrubbing of realtime group superblocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile        |    1 +
 fs/xfs/libxfs/xfs_fs.h |    3 +-
 fs/xfs/scrub/common.h  |    2 +
 fs/xfs/scrub/health.c  |    1 +
 fs/xfs/scrub/rgsuper.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c   |    7 +++++
 fs/xfs/scrub/scrub.h   |    2 +
 fs/xfs/scrub/stats.c   |    1 +
 fs/xfs/scrub/trace.h   |    4 ++-
 9 files changed, 87 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/rgsuper.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 6814debac29929..ed9b0dabc1f11d 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -191,6 +191,7 @@ xfs-y				+= $(addprefix scrub/, \
 xfs-$(CONFIG_XFS_ONLINE_SCRUB_STATS) += scrub/stats.o
 
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
+				   rgsuper.o \
 				   rtbitmap.o \
 				   rtsummary.o \
 				   )
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 4c0682173d6144..50de6ad88dbe45 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -736,9 +736,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_HEALTHY	27	/* everything checked out ok */
 #define XFS_SCRUB_TYPE_DIRTREE	28	/* directory tree structure */
 #define XFS_SCRUB_TYPE_METAPATH	29	/* metadata directory tree paths */
+#define XFS_SCRUB_TYPE_RGSUPER	30	/* realtime superblock */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	30
+#define XFS_SCRUB_TYPE_NR	31
 
 /*
  * This special type code only applies to the vectored scrub implementation.
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 672ed48d4a9fc3..9ff3cafd867962 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -79,9 +79,11 @@ int xchk_setup_metapath(struct xfs_scrub *sc);
 #ifdef CONFIG_XFS_RT
 int xchk_setup_rtbitmap(struct xfs_scrub *sc);
 int xchk_setup_rtsummary(struct xfs_scrub *sc);
+int xchk_setup_rgsuperblock(struct xfs_scrub *sc);
 #else
 # define xchk_setup_rtbitmap		xchk_setup_nothing
 # define xchk_setup_rtsummary		xchk_setup_nothing
+# define xchk_setup_rgsuperblock	xchk_setup_nothing
 #endif
 #ifdef CONFIG_XFS_QUOTA
 int xchk_ino_dqattach(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 7547fb5bcd7272..ce86bdad37fa42 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -111,6 +111,7 @@ static const struct xchk_health_map type_to_health_flag[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_NLINKS]		= { XHG_FS,  XFS_SICK_FS_NLINKS },
 	[XFS_SCRUB_TYPE_DIRTREE]	= { XHG_INO, XFS_SICK_INO_DIRTREE },
 	[XFS_SCRUB_TYPE_METAPATH]	= { XHG_FS,  XFS_SICK_FS_METAPATH },
+	[XFS_SCRUB_TYPE_RGSUPER]	= { XHG_RTGROUP, XFS_SICK_RG_SUPER },
 };
 
 /* Return the health status mask for this scrub type. */
diff --git a/fs/xfs/scrub/rgsuper.c b/fs/xfs/scrub/rgsuper.c
new file mode 100644
index 00000000000000..00dfe043dfea7f
--- /dev/null
+++ b/fs/xfs/scrub/rgsuper.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_rtgroup.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+
+/* Set us up with a transaction and an empty context. */
+int
+xchk_setup_rgsuperblock(
+	struct xfs_scrub	*sc)
+{
+	return xchk_trans_alloc(sc, 0);
+}
+
+/* Cross-reference with the other rt metadata. */
+STATIC void
+xchk_rgsuperblock_xref(
+	struct xfs_scrub	*sc)
+{
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+
+	xchk_xref_is_used_rt_space(sc, xfs_rgbno_to_rtb(sc->sr.rtg, 0), 1);
+}
+
+int
+xchk_rgsuperblock(
+	struct xfs_scrub	*sc)
+{
+	xfs_rgnumber_t		rgno = sc->sm->sm_agno;
+	int			error;
+
+	/*
+	 * Only rtgroup 0 has a superblock.  We may someday want to use higher
+	 * rgno for other functions, similar to what we do with the primary
+	 * super scrub function.
+	 */
+	if (rgno != 0)
+		return -ENOENT;
+
+	/*
+	 * Grab an active reference to the rtgroup structure.  If we can't get
+	 * it, we're racing with something that's tearing down the group, so
+	 * signal that the group no longer exists.  Take the rtbitmap in shared
+	 * mode so that the group can't change while we're doing things.
+	 */
+	error = xchk_rtgroup_init_existing(sc, rgno, &sc->sr);
+	if (!xchk_xref_process_error(sc, 0, 0, &error))
+		return error;
+
+	xchk_rtgroup_lock(&sc->sr, XFS_RTGLOCK_BITMAP_SHARED);
+
+	/*
+	 * Since we already validated the rt superblock at mount time, we don't
+	 * need to check its contents again.  All we need is to cross-reference.
+	 */
+	xchk_rgsuperblock_xref(sc);
+	return 0;
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 8cd7e36c09990e..ceb22c722d8f52 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -451,6 +451,13 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.has	= xfs_has_metadir,
 		.repair	= xrep_metapath,
 	},
+	[XFS_SCRUB_TYPE_RGSUPER] = {	/* realtime group superblock */
+		.type	= ST_RTGROUP,
+		.setup	= xchk_setup_rgsuperblock,
+		.scrub	= xchk_rgsuperblock,
+		.has	= xfs_has_rtsb,
+		.repair = xrep_notsupported,
+	},
 };
 
 static int
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index f73c6d0d90a11a..a7fda3e2b01377 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -273,9 +273,11 @@ int xchk_metapath(struct xfs_scrub *sc);
 #ifdef CONFIG_XFS_RT
 int xchk_rtbitmap(struct xfs_scrub *sc);
 int xchk_rtsummary(struct xfs_scrub *sc);
+int xchk_rgsuperblock(struct xfs_scrub *sc);
 #else
 # define xchk_rtbitmap		xchk_nothing
 # define xchk_rtsummary		xchk_nothing
+# define xchk_rgsuperblock	xchk_nothing
 #endif
 #ifdef CONFIG_XFS_QUOTA
 int xchk_quota(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index edcd02dc2e62c0..a476c7b2ab7597 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -81,6 +81,7 @@ static const char *name_map[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_NLINKS]		= "nlinks",
 	[XFS_SCRUB_TYPE_DIRTREE]	= "dirtree",
 	[XFS_SCRUB_TYPE_METAPATH]	= "metapath",
+	[XFS_SCRUB_TYPE_RGSUPER]	= "rgsuper",
 };
 
 /* Format the scrub stats into a text buffer, similar to pcp style. */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index b6c8d0944fa453..9b38f5ad1eaf07 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -71,6 +71,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_HEALTHY);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_DIRTREE);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BARRIER);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_METAPATH);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RGSUPER);
 
 #define XFS_SCRUB_TYPE_STRINGS \
 	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
@@ -103,7 +104,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_METAPATH);
 	{ XFS_SCRUB_TYPE_HEALTHY,	"healthy" }, \
 	{ XFS_SCRUB_TYPE_DIRTREE,	"dirtree" }, \
 	{ XFS_SCRUB_TYPE_BARRIER,	"barrier" }, \
-	{ XFS_SCRUB_TYPE_METAPATH,	"metapath" }
+	{ XFS_SCRUB_TYPE_METAPATH,	"metapath" }, \
+	{ XFS_SCRUB_TYPE_RGSUPER,	"rgsuper" }
 
 #define XFS_SCRUB_FLAG_STRINGS \
 	{ XFS_SCRUB_IFLAG_REPAIR,		"repair" }, \

