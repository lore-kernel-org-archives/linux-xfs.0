Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036DF12E4E
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710296003; cv=none; b=PGeT81YSRDW3fKzfEtj30BTTMLKayStXOQOFKU589Vxm+k5nQN4AE5R73MYc8lPU6I8F+G9mpqnf9CG9aXPv9cdRexPhip8ql589iMsgFA29On7EUKveCXIoCMphzgIdLUH41GXHXoGE6Gr3MXXR80CCqyXW/kU72OZLoyfMiPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710296003; c=relaxed/simple;
	bh=33m8uN8HbMwfPGs5GSIKDhhJWt2n4ZkEgrOetw8pvC8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oo9ihznoLxRFydRXRz2hSWlSKyumsIwTajqjpyGkBgxKbThQEpPc57giM2+8lgXjFkgIhckXcPnRAKNDTT2vCrCtvLSKnUwAmaK2kwVoy0EZiGsRLGlHL4gT4osTNhgr8qTvvCcH1DZtw89XYl7VuU5k1lIoFNAzvxubJI58W6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oXwE6p85; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oXwE6p85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D77C433F1;
	Wed, 13 Mar 2024 02:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710296002;
	bh=33m8uN8HbMwfPGs5GSIKDhhJWt2n4ZkEgrOetw8pvC8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oXwE6p85D5FOhtlefmPnOaKiWDVMdI/Kx/qLUlyQO/XHXHjHFItxhSn451MYzq27v
	 wUg540EreNiHWFzAHZ90qjZNIgpZj2trCtgSqG6sZ3r4XyFk3EkqUzVfKnNL8pmiVM
	 MP0A1LIGq96Fvvee41vS2Ui2053Mj6nLWQOm/h7QRxGR9EOsRzuMADq5D5zVI2A1Td
	 mtQqZV9Jms54TcY84Lmt/6SPhAxoRC4a9YuSEbQbaU+SQgxk5F0+UEC5wu4JBIYZiY
	 2NRb2WC7B/DnfHGYskM66tHjlGB2e1t4kCUSMeRAfjCuk3rxvtwhCpmqK8cH9NC01F
	 t03Hcwv1nnihQ==
Date: Tue, 12 Mar 2024 19:13:22 -0700
Subject: [PATCH 1/3] libfrog: rename XFROG_SCRUB_TYPE_* to XFROG_SCRUB_GROUP_*
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029433964.2065570.2690498250825367424.stgit@frogsfrogsfrogs>
In-Reply-To: <171029433946.2065570.16411233810474878821.stgit@frogsfrogsfrogs>
References: <171029433946.2065570.16411233810474878821.stgit@frogsfrogsfrogs>
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

I didn't do a good job of naming XFROG_SCRUB_TYPE when I created that
enumeration.  The goal of the enum is to group the scrub ioctl's
XFS_SCRUB_TYPE_* codes by principal filesystem object (AG, inode, etc.)
but for some dumb reason I chose to reuse "type".  This is confusing,
so fix this sin.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 io/scrub.c      |   12 ++++++------
 libfrog/scrub.c |   50 +++++++++++++++++++++++++-------------------------
 libfrog/scrub.h |   16 ++++++++--------
 scrub/scrub.c   |   54 +++++++++++++++++++++++++++---------------------------
 4 files changed, 66 insertions(+), 66 deletions(-)


diff --git a/io/scrub.c b/io/scrub.c
index 403b3a7282ea..d6eda5bea538 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -166,23 +166,23 @@ parse_args(
 	meta->sm_type = type;
 	meta->sm_flags = flags;
 
-	switch (d->type) {
-	case XFROG_SCRUB_TYPE_INODE:
+	switch (d->group) {
+	case XFROG_SCRUB_GROUP_INODE:
 		if (!parse_inode(argc, argv, optind, &meta->sm_ino,
 						     &meta->sm_gen)) {
 			exitcode = 1;
 			return command_usage(cmdinfo);
 		}
 		break;
-	case XFROG_SCRUB_TYPE_AGHEADER:
-	case XFROG_SCRUB_TYPE_PERAG:
+	case XFROG_SCRUB_GROUP_AGHEADER:
+	case XFROG_SCRUB_GROUP_PERAG:
 		if (!parse_agno(argc, argv, optind, &meta->sm_agno)) {
 			exitcode = 1;
 			return command_usage(cmdinfo);
 		}
 		break;
-	case XFROG_SCRUB_TYPE_FS:
-	case XFROG_SCRUB_TYPE_NONE:
+	case XFROG_SCRUB_GROUP_FS:
+	case XFROG_SCRUB_GROUP_NONE:
 		if (!parse_none(argc, optind)) {
 			exitcode = 1;
 			return command_usage(cmdinfo);
diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index d900bf2af638..90fc2b1a40cd 100644
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
index e43d8c244e48..43a882321f99 100644
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
index 756f1915ab91..cde9babc5574 100644
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

