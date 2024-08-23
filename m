Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C62125AC
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372830; cv=none; b=HJNOrkTsiFQ4pBl37YnCbz/aVCxzMJTkBoKZapIjyKVHoNG1pcpjvfUStH142MPqhwRyNB9WxVEptqCM3jft3C3zqkWIrb6CDDKUeOr0RxHtyA6De1Izp4KLbSe+VO7iPh5KIDqYkkpkSAeJ1QMf6RMKzMCX3i2U7HelvpN4ZBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372830; c=relaxed/simple;
	bh=ObRyTY5WKSiQv2P+LVk2E+emcM8vnXXivHQ2V6BFgms=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nXGplBazaVrdwl6Z1bH6y5MypIvXvQla5L3XOjH6q00gaionN0/sp5RCf+gx8eCJ4W/r8eKJF/3xMu9XoMXqbeizFwRtoVRmlXrivn9TlT4tS4TFgr9dICsnaPcSqbrrid5HbpZg50JbHfvQd/X6blXV5pXoY+cH80bJts51/0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z3jLeoTN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z3jLeoTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71626C32782;
	Fri, 23 Aug 2024 00:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372830;
	bh=ObRyTY5WKSiQv2P+LVk2E+emcM8vnXXivHQ2V6BFgms=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Z3jLeoTNUq0PkNXZz8zP20J1MRz2DRaCyWlaPmu71pciUBrDhNZkNqR5xxfWUng7E
	 cfoFuyrmvkcMs3v+z7jBQkdbLmgt1RSHUGDKx6tdwXEasfm33G8AvMydR1MIOz7kDl
	 FSon1gq2Iakg/PXb8ux4iUxdlQItFDCdiwFtKfEs6EMvwx7otYy2fRY1V4geFeLPVl
	 VvF3jeUhQv0S8T9hsIZEdTsGXnahhbIYvcyeX/+P5qJk1wIdelvPMpi5Mzik5029Qb
	 S6TTsGNwp6YKlqoTm5WbWEyCf/OuF8EowRb0vKYCrj8GZAeYKQl8nbUckfJ8uRWbLD
	 RBB5ds4fDvpWg==
Date: Thu, 22 Aug 2024 17:27:10 -0700
Subject: [PATCH 23/26] xfs: scrub the realtime group superblock
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437088921.60592.15232505394298064283.stgit@frogsfrogsfrogs>
In-Reply-To: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
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

Enable scrubbing of realtime group superblocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile        |    1 +
 fs/xfs/libxfs/xfs_fs.h |    3 +-
 fs/xfs/scrub/common.h  |    2 +
 fs/xfs/scrub/health.c  |    1 +
 fs/xfs/scrub/rgsuper.c |   73 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c   |    7 +++++
 fs/xfs/scrub/scrub.h   |    2 +
 fs/xfs/scrub/stats.c   |    1 +
 fs/xfs/scrub/trace.h   |    4 ++-
 9 files changed, 92 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/rgsuper.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 388b5cef48ca5..56f518e5017fd 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -190,6 +190,7 @@ xfs-y				+= $(addprefix scrub/, \
 xfs-$(CONFIG_XFS_ONLINE_SCRUB_STATS) += scrub/stats.o
 
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
+				   rgsuper.o \
 				   rtbitmap.o \
 				   rtsummary.o \
 				   )
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 2dacc19723c37..07337958fc41a 100644
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
index 0d531770e83b0..c8465a4eb594a 100644
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
index a0a721ae5763d..3406579db71eb 100644
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
index 0000000000000..bfba31a03adbc
--- /dev/null
+++ b/fs/xfs/scrub/rgsuper.c
@@ -0,0 +1,73 @@
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
+	struct xfs_mount	*mp = sc->mp;
+	xfs_rgnumber_t		rgno = sc->sr.rtg->rtg_rgno;
+	xfs_rtblock_t		rtbno;
+
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+
+	rtbno = xfs_rgbno_to_rtb(mp, rgno, 0);
+	xchk_xref_is_used_rt_space(sc, rtbno, 1);
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
index 910825d4b61a2..fc8476c522746 100644
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
index f73c6d0d90a11..a7fda3e2b0137 100644
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
index edcd02dc2e62c..a476c7b2ab759 100644
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
index fe901b9138b4b..d4d0e8ceeeb7b 100644
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

