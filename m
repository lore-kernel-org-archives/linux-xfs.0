Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79096C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235872AbiLaAHU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235857AbiLaAHU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:07:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84D41E3C3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:07:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A31F7B81DF0
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB3AC433D2;
        Sat, 31 Dec 2022 00:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445236;
        bh=2pK/2z0eULe2PtnjeBVCR4C7EIN6Wg9qb/76YnVf2Fg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dTczdvgC+CJxPKqFXsd9x0JIvi36kluOXtx9XYWURSG8WM72GIAkcrLcGpVUUx+YH
         r6vBSI9m7fH6YaLP/V8O3rADf43guGOCCqHDlIExfPvvO+UhA7JDxOOjpPsneYgK91
         GuRd9RWsoZo56ALyPkoUhUXs7+G7jLTRRCnMWemx1K1MNWDSRqvfkA6W7l6PCDBwpV
         bgFKleKZZOjogN43AzPhbNFImtcs/LiO5ysVuGvSu0jWYk3Hz04FSDd0UGTFkSFbJC
         tXWPG5nBOUh7MW00WklMti6HuRHHXRybRTEXFFfGWXXvF7nQhMo9Kz5umG8KiSsrbS
         8Va8UN5A47DTw==
Subject: [PATCH 1/4] libfrog: rename XFROG_SCRUB_TYPE_* to XFROG_SCRUB_GROUP_*
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:25 -0800
Message-ID: <167243864568.708428.13971614791565931968.stgit@magnolia>
In-Reply-To: <167243864554.708428.558285078019160851.stgit@magnolia>
References: <167243864554.708428.558285078019160851.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

I didn't do a good job of naming XFROG_SCRUB_TYPE when I created that
enumeration.  The goal of the enum is to group the scrub ioctl's
XFS_SCRUB_TYPE_* codes by principal filesystem object (AG, inode, etc.)
but for some dumb reason I chose to reuse "type".  This is confusing,
so fix this sin.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/scrub.c      |   36 ++++++++++++++++++------------------
 libfrog/scrub.c |   50 +++++++++++++++++++++++++-------------------------
 libfrog/scrub.h |   16 ++++++++--------
 scrub/scrub.c   |   54 +++++++++++++++++++++++++++---------------------------
 4 files changed, 78 insertions(+), 78 deletions(-)


diff --git a/io/scrub.c b/io/scrub.c
index a74e65fbe8d..0cad69253dc 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -56,17 +56,17 @@ scrub_ioctl(
 	sc = &xfrog_scrubbers[type];
 	memset(&meta, 0, sizeof(meta));
 	meta.sm_type = type;
-	switch (sc->type) {
-	case XFROG_SCRUB_TYPE_AGHEADER:
-	case XFROG_SCRUB_TYPE_PERAG:
+	switch (sc->group) {
+	case XFROG_SCRUB_GROUP_AGHEADER:
+	case XFROG_SCRUB_GROUP_PERAG:
 		meta.sm_agno = control;
 		break;
-	case XFROG_SCRUB_TYPE_INODE:
+	case XFROG_SCRUB_GROUP_INODE:
 		meta.sm_ino = control;
 		meta.sm_gen = control2;
 		break;
-	case XFROG_SCRUB_TYPE_NONE:
-	case XFROG_SCRUB_TYPE_FS:
+	case XFROG_SCRUB_GROUP_NONE:
+	case XFROG_SCRUB_GROUP_FS:
 		/* no control parameters */
 		break;
 	}
@@ -126,8 +126,8 @@ parse_args(
 	}
 	optind++;
 
-	switch (d->type) {
-	case XFROG_SCRUB_TYPE_INODE:
+	switch (d->group) {
+	case XFROG_SCRUB_GROUP_INODE:
 		if (optind == argc) {
 			control = 0;
 			control2 = 0;
@@ -152,8 +152,8 @@ parse_args(
 			return 0;
 		}
 		break;
-	case XFROG_SCRUB_TYPE_AGHEADER:
-	case XFROG_SCRUB_TYPE_PERAG:
+	case XFROG_SCRUB_GROUP_AGHEADER:
+	case XFROG_SCRUB_GROUP_PERAG:
 		if (optind != argc - 1) {
 			fprintf(stderr,
 				_("Must specify one AG number.\n"));
@@ -166,8 +166,8 @@ parse_args(
 			return 0;
 		}
 		break;
-	case XFROG_SCRUB_TYPE_FS:
-	case XFROG_SCRUB_TYPE_NONE:
+	case XFROG_SCRUB_GROUP_FS:
+	case XFROG_SCRUB_GROUP_NONE:
 		if (optind != argc) {
 			fprintf(stderr,
 				_("No parameters allowed.\n"));
@@ -248,17 +248,17 @@ repair_ioctl(
 	sc = &xfrog_scrubbers[type];
 	memset(&meta, 0, sizeof(meta));
 	meta.sm_type = type;
-	switch (sc->type) {
-	case XFROG_SCRUB_TYPE_AGHEADER:
-	case XFROG_SCRUB_TYPE_PERAG:
+	switch (sc->group) {
+	case XFROG_SCRUB_GROUP_AGHEADER:
+	case XFROG_SCRUB_GROUP_PERAG:
 		meta.sm_agno = control;
 		break;
-	case XFROG_SCRUB_TYPE_INODE:
+	case XFROG_SCRUB_GROUP_INODE:
 		meta.sm_ino = control;
 		meta.sm_gen = control2;
 		break;
-	case XFROG_SCRUB_TYPE_NONE:
-	case XFROG_SCRUB_TYPE_FS:
+	case XFROG_SCRUB_GROUP_NONE:
+	case XFROG_SCRUB_GROUP_FS:
 		/* no control parameters */
 		break;
 	}
diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index d900bf2af63..90fc2b1a40c 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -12,127 +12,127 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_PROBE] = {
 		.name	= "probe",
 		.descr	= "metadata",
-		.type	= XFROG_SCRUB_TYPE_NONE,
+		.group	= XFROG_SCRUB_GROUP_NONE,
 	},
 	[XFS_SCRUB_TYPE_SB] = {
 		.name	= "sb",
 		.descr	= "superblock",
-		.type	= XFROG_SCRUB_TYPE_AGHEADER,
+		.group	= XFROG_SCRUB_GROUP_AGHEADER,
 	},
 	[XFS_SCRUB_TYPE_AGF] = {
 		.name	= "agf",
 		.descr	= "free space header",
-		.type	= XFROG_SCRUB_TYPE_AGHEADER,
+		.group	= XFROG_SCRUB_GROUP_AGHEADER,
 	},
 	[XFS_SCRUB_TYPE_AGFL] = {
 		.name	= "agfl",
 		.descr	= "free list",
-		.type	= XFROG_SCRUB_TYPE_AGHEADER,
+		.group	= XFROG_SCRUB_GROUP_AGHEADER,
 	},
 	[XFS_SCRUB_TYPE_AGI] = {
 		.name	= "agi",
 		.descr	= "inode header",
-		.type	= XFROG_SCRUB_TYPE_AGHEADER,
+		.group	= XFROG_SCRUB_GROUP_AGHEADER,
 	},
 	[XFS_SCRUB_TYPE_BNOBT] = {
 		.name	= "bnobt",
 		.descr	= "freesp by block btree",
-		.type	= XFROG_SCRUB_TYPE_PERAG,
+		.group	= XFROG_SCRUB_GROUP_PERAG,
 	},
 	[XFS_SCRUB_TYPE_CNTBT] = {
 		.name	= "cntbt",
 		.descr	= "freesp by length btree",
-		.type	= XFROG_SCRUB_TYPE_PERAG,
+		.group	= XFROG_SCRUB_GROUP_PERAG,
 	},
 	[XFS_SCRUB_TYPE_INOBT] = {
 		.name	= "inobt",
 		.descr	= "inode btree",
-		.type	= XFROG_SCRUB_TYPE_PERAG,
+		.group	= XFROG_SCRUB_GROUP_PERAG,
 	},
 	[XFS_SCRUB_TYPE_FINOBT] = {
 		.name	= "finobt",
 		.descr	= "free inode btree",
-		.type	= XFROG_SCRUB_TYPE_PERAG,
+		.group	= XFROG_SCRUB_GROUP_PERAG,
 	},
 	[XFS_SCRUB_TYPE_RMAPBT] = {
 		.name	= "rmapbt",
 		.descr	= "reverse mapping btree",
-		.type	= XFROG_SCRUB_TYPE_PERAG,
+		.group	= XFROG_SCRUB_GROUP_PERAG,
 	},
 	[XFS_SCRUB_TYPE_REFCNTBT] = {
 		.name	= "refcountbt",
 		.descr	= "reference count btree",
-		.type	= XFROG_SCRUB_TYPE_PERAG,
+		.group	= XFROG_SCRUB_GROUP_PERAG,
 	},
 	[XFS_SCRUB_TYPE_INODE] = {
 		.name	= "inode",
 		.descr	= "inode record",
-		.type	= XFROG_SCRUB_TYPE_INODE,
+		.group	= XFROG_SCRUB_GROUP_INODE,
 	},
 	[XFS_SCRUB_TYPE_BMBTD] = {
 		.name	= "bmapbtd",
 		.descr	= "data block map",
-		.type	= XFROG_SCRUB_TYPE_INODE,
+		.group	= XFROG_SCRUB_GROUP_INODE,
 	},
 	[XFS_SCRUB_TYPE_BMBTA] = {
 		.name	= "bmapbta",
 		.descr	= "attr block map",
-		.type	= XFROG_SCRUB_TYPE_INODE,
+		.group	= XFROG_SCRUB_GROUP_INODE,
 	},
 	[XFS_SCRUB_TYPE_BMBTC] = {
 		.name	= "bmapbtc",
 		.descr	= "CoW block map",
-		.type	= XFROG_SCRUB_TYPE_INODE,
+		.group	= XFROG_SCRUB_GROUP_INODE,
 	},
 	[XFS_SCRUB_TYPE_DIR] = {
 		.name	= "directory",
 		.descr	= "directory entries",
-		.type	= XFROG_SCRUB_TYPE_INODE,
+		.group	= XFROG_SCRUB_GROUP_INODE,
 	},
 	[XFS_SCRUB_TYPE_XATTR] = {
 		.name	= "xattr",
 		.descr	= "extended attributes",
-		.type	= XFROG_SCRUB_TYPE_INODE,
+		.group	= XFROG_SCRUB_GROUP_INODE,
 	},
 	[XFS_SCRUB_TYPE_SYMLINK] = {
 		.name	= "symlink",
 		.descr	= "symbolic link",
-		.type	= XFROG_SCRUB_TYPE_INODE,
+		.group	= XFROG_SCRUB_GROUP_INODE,
 	},
 	[XFS_SCRUB_TYPE_PARENT] = {
 		.name	= "parent",
 		.descr	= "parent pointer",
-		.type	= XFROG_SCRUB_TYPE_INODE,
+		.group	= XFROG_SCRUB_GROUP_INODE,
 	},
 	[XFS_SCRUB_TYPE_RTBITMAP] = {
 		.name	= "rtbitmap",
 		.descr	= "realtime bitmap",
-		.type	= XFROG_SCRUB_TYPE_FS,
+		.group	= XFROG_SCRUB_GROUP_FS,
 	},
 	[XFS_SCRUB_TYPE_RTSUM] = {
 		.name	= "rtsummary",
 		.descr	= "realtime summary",
-		.type	= XFROG_SCRUB_TYPE_FS,
+		.group	= XFROG_SCRUB_GROUP_FS,
 	},
 	[XFS_SCRUB_TYPE_UQUOTA] = {
 		.name	= "usrquota",
 		.descr	= "user quotas",
-		.type	= XFROG_SCRUB_TYPE_FS,
+		.group	= XFROG_SCRUB_GROUP_FS,
 	},
 	[XFS_SCRUB_TYPE_GQUOTA] = {
 		.name	= "grpquota",
 		.descr	= "group quotas",
-		.type	= XFROG_SCRUB_TYPE_FS,
+		.group	= XFROG_SCRUB_GROUP_FS,
 	},
 	[XFS_SCRUB_TYPE_PQUOTA] = {
 		.name	= "prjquota",
 		.descr	= "project quotas",
-		.type	= XFROG_SCRUB_TYPE_FS,
+		.group	= XFROG_SCRUB_GROUP_FS,
 	},
 	[XFS_SCRUB_TYPE_FSCOUNTERS] = {
 		.name	= "fscounters",
 		.descr	= "filesystem summary counters",
-		.type	= XFROG_SCRUB_TYPE_FS,
+		.group	= XFROG_SCRUB_GROUP_FS,
 		.flags	= XFROG_SCRUB_DESCR_SUMMARY,
 	},
 };
diff --git a/libfrog/scrub.h b/libfrog/scrub.h
index e43d8c244e4..43a882321f9 100644
--- a/libfrog/scrub.h
+++ b/libfrog/scrub.h
@@ -6,20 +6,20 @@
 #ifndef __LIBFROG_SCRUB_H__
 #define __LIBFROG_SCRUB_H__
 
-/* Type info and names for the scrub types. */
-enum xfrog_scrub_type {
-	XFROG_SCRUB_TYPE_NONE,		/* not metadata */
-	XFROG_SCRUB_TYPE_AGHEADER,	/* per-AG header */
-	XFROG_SCRUB_TYPE_PERAG,		/* per-AG metadata */
-	XFROG_SCRUB_TYPE_FS,		/* per-FS metadata */
-	XFROG_SCRUB_TYPE_INODE,		/* per-inode metadata */
+/* Group the scrub types by principal filesystem object. */
+enum xfrog_scrub_group {
+	XFROG_SCRUB_GROUP_NONE,		/* not metadata */
+	XFROG_SCRUB_GROUP_AGHEADER,	/* per-AG header */
+	XFROG_SCRUB_GROUP_PERAG,	/* per-AG metadata */
+	XFROG_SCRUB_GROUP_FS,		/* per-FS metadata */
+	XFROG_SCRUB_GROUP_INODE,	/* per-inode metadata */
 };
 
 /* Catalog of scrub types and names, indexed by XFS_SCRUB_TYPE_* */
 struct xfrog_scrub_descr {
 	const char		*name;
 	const char		*descr;
-	enum xfrog_scrub_type	type;
+	enum xfrog_scrub_group	group;
 	unsigned int		flags;
 };
 
diff --git a/scrub/scrub.c b/scrub/scrub.c
index d899f75a92f..61a111db080 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -34,21 +34,21 @@ format_scrub_descr(
 	struct xfs_scrub_metadata	*meta = where;
 	const struct xfrog_scrub_descr	*sc = &xfrog_scrubbers[meta->sm_type];
 
-	switch (sc->type) {
-	case XFROG_SCRUB_TYPE_AGHEADER:
-	case XFROG_SCRUB_TYPE_PERAG:
+	switch (sc->group) {
+	case XFROG_SCRUB_GROUP_AGHEADER:
+	case XFROG_SCRUB_GROUP_PERAG:
 		return snprintf(buf, buflen, _("AG %u %s"), meta->sm_agno,
 				_(sc->descr));
 		break;
-	case XFROG_SCRUB_TYPE_INODE:
+	case XFROG_SCRUB_GROUP_INODE:
 		return scrub_render_ino_descr(ctx, buf, buflen,
 				meta->sm_ino, meta->sm_gen, "%s",
 				_(sc->descr));
 		break;
-	case XFROG_SCRUB_TYPE_FS:
+	case XFROG_SCRUB_GROUP_FS:
 		return snprintf(buf, buflen, _("%s"), _(sc->descr));
 		break;
-	case XFROG_SCRUB_TYPE_NONE:
+	case XFROG_SCRUB_GROUP_NONE:
 		assert(0);
 		break;
 	}
@@ -276,12 +276,12 @@ scrub_save_repair(
 	memset(aitem, 0, sizeof(*aitem));
 	aitem->type = meta->sm_type;
 	aitem->flags = meta->sm_flags;
-	switch (xfrog_scrubbers[meta->sm_type].type) {
-	case XFROG_SCRUB_TYPE_AGHEADER:
-	case XFROG_SCRUB_TYPE_PERAG:
+	switch (xfrog_scrubbers[meta->sm_type].group) {
+	case XFROG_SCRUB_GROUP_AGHEADER:
+	case XFROG_SCRUB_GROUP_PERAG:
 		aitem->agno = meta->sm_agno;
 		break;
-	case XFROG_SCRUB_TYPE_INODE:
+	case XFROG_SCRUB_GROUP_INODE:
 		aitem->ino = meta->sm_ino;
 		aitem->gen = meta->sm_gen;
 		break;
@@ -336,14 +336,14 @@ scrub_meta_type(
 }
 
 /*
- * Scrub all metadata types that are assigned to the given XFROG_SCRUB_TYPE_*,
+ * Scrub all metadata types that are assigned to the given XFROG_SCRUB_GROUP_*,
  * saving corruption reports for later.  This should not be used for
- * XFROG_SCRUB_TYPE_INODE or for checking summary metadata.
+ * XFROG_SCRUB_GROUP_INODE or for checking summary metadata.
  */
 static bool
-scrub_all_types(
+scrub_group(
 	struct scrub_ctx		*ctx,
-	enum xfrog_scrub_type		scrub_type,
+	enum xfrog_scrub_group		group,
 	xfs_agnumber_t			agno,
 	struct action_list		*alist)
 {
@@ -354,7 +354,7 @@ scrub_all_types(
 	for (type = 0; type < XFS_SCRUB_TYPE_NR; type++, sc++) {
 		int			ret;
 
-		if (sc->type != scrub_type)
+		if (sc->group != group)
 			continue;
 		if (sc->flags & XFROG_SCRUB_DESCR_SUMMARY)
 			continue;
@@ -388,7 +388,7 @@ scrub_ag_headers(
 	xfs_agnumber_t			agno,
 	struct action_list		*alist)
 {
-	return scrub_all_types(ctx, XFROG_SCRUB_TYPE_AGHEADER, agno, alist);
+	return scrub_group(ctx, XFROG_SCRUB_GROUP_AGHEADER, agno, alist);
 }
 
 /* Scrub each AG's metadata btrees. */
@@ -398,7 +398,7 @@ scrub_ag_metadata(
 	xfs_agnumber_t			agno,
 	struct action_list		*alist)
 {
-	return scrub_all_types(ctx, XFROG_SCRUB_TYPE_PERAG, agno, alist);
+	return scrub_group(ctx, XFROG_SCRUB_GROUP_PERAG, agno, alist);
 }
 
 /* Scrub whole-FS metadata btrees. */
@@ -407,7 +407,7 @@ scrub_fs_metadata(
 	struct scrub_ctx		*ctx,
 	struct action_list		*alist)
 {
-	return scrub_all_types(ctx, XFROG_SCRUB_TYPE_FS, 0, alist);
+	return scrub_group(ctx, XFROG_SCRUB_GROUP_FS, 0, alist);
 }
 
 /* Scrub FS summary metadata. */
@@ -430,12 +430,12 @@ scrub_estimate_ag_work(
 
 	sc = xfrog_scrubbers;
 	for (type = 0; type < XFS_SCRUB_TYPE_NR; type++, sc++) {
-		switch (sc->type) {
-		case XFROG_SCRUB_TYPE_AGHEADER:
-		case XFROG_SCRUB_TYPE_PERAG:
+		switch (sc->group) {
+		case XFROG_SCRUB_GROUP_AGHEADER:
+		case XFROG_SCRUB_GROUP_PERAG:
 			estimate += ctx->mnt.fsgeom.agcount;
 			break;
-		case XFROG_SCRUB_TYPE_FS:
+		case XFROG_SCRUB_GROUP_FS:
 			estimate++;
 			break;
 		default:
@@ -463,7 +463,7 @@ scrub_file(
 	enum check_outcome		fix;
 
 	assert(type < XFS_SCRUB_TYPE_NR);
-	assert(xfrog_scrubbers[type].type == XFROG_SCRUB_TYPE_INODE);
+	assert(xfrog_scrubbers[type].group == XFROG_SCRUB_GROUP_INODE);
 
 	meta.sm_type = type;
 	meta.sm_ino = bstat->bs_ino;
@@ -625,12 +625,12 @@ xfs_repair_metadata(
 	meta.sm_flags = aitem->flags | XFS_SCRUB_IFLAG_REPAIR;
 	if (use_force_rebuild)
 		meta.sm_flags |= XFS_SCRUB_IFLAG_FORCE_REBUILD;
-	switch (xfrog_scrubbers[aitem->type].type) {
-	case XFROG_SCRUB_TYPE_AGHEADER:
-	case XFROG_SCRUB_TYPE_PERAG:
+	switch (xfrog_scrubbers[aitem->type].group) {
+	case XFROG_SCRUB_GROUP_AGHEADER:
+	case XFROG_SCRUB_GROUP_PERAG:
 		meta.sm_agno = aitem->agno;
 		break;
-	case XFROG_SCRUB_TYPE_INODE:
+	case XFROG_SCRUB_GROUP_INODE:
 		meta.sm_ino = aitem->ino;
 		meta.sm_gen = aitem->gen;
 		break;

