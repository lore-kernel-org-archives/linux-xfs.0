Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5780FC127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U/AQtEsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261CEC433C7;
	Sun, 31 Dec 2023 22:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062578;
	bh=bs1KBr9yNiiigik8P1RjQ3ycR8YB3zGKm1vjUb3LIjk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U/AQtEsEsMVWTpUttQMq0SJQ1NqOkKGOZJvNuM0vPiegVi2k+mVyDCY46J5zG5ZVN
	 PxebMzZkuvtG+WLSwFoYmUBWjWFqtXJWw4ZbZQUF9FNFHqT7Ca9bbxVy0rEvdMEczn
	 XbImFGfAnBLMmPyDo6OTTlCTMn5d6MJosaGyXOGrNGDzRgpSwzN5XpEJTzwnAGA4n/
	 8wL/1BVpaD5vfQCmgkc+V6kZBW1o27LzjRwASaHjYW+7gtUEPl5q2UsqeD4m9wf+kK
	 tROp89lJOAa/0aH3t3qqHG/Zm7dIFuO455vXfJugNYNviwVhEbCDJWxwWnQZrAX8De
	 oA0aPugn3POpA==
Date: Sun, 31 Dec 2023 14:42:57 -0800
Subject: [PATCH 1/5] xfs_scrub: start tracking scrub state in scrub_item
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404999877.1798060.11854009505263504940.stgit@frogsfrogsfrogs>
In-Reply-To: <170404999861.1798060.18204009464583067612.stgit@frogsfrogsfrogs>
References: <170404999861.1798060.18204009464583067612.stgit@frogsfrogsfrogs>
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

Start using the scrub_item to track which metadata objects need
checking by adding a new flag to the scrub_item state set.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase1.c |    3 +
 scrub/phase2.c |   12 +++--
 scrub/phase3.c |   41 +++++-----------
 scrub/phase4.c |   16 +++---
 scrub/phase5.c |    5 +-
 scrub/phase7.c |    5 ++
 scrub/scrub.c  |  147 +++++++++++++++++++-------------------------------------
 scrub/scrub.h  |   28 ++++++++---
 8 files changed, 108 insertions(+), 149 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 1e56f9fb1ee..60a8db5724e 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -61,7 +61,8 @@ report_to_kernel(
 		return 0;
 
 	scrub_item_init_fs(&sri);
-	ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_HEALTHY, &sri);
+	scrub_item_schedule(&sri, XFS_SCRUB_TYPE_HEALTHY);
+	ret = scrub_item_check(ctx, &sri);
 	if (ret)
 		return ret;
 
diff --git a/scrub/phase2.c b/scrub/phase2.c
index 4d90291ed14..79b33dd04db 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -75,7 +75,8 @@ scan_ag_metadata(
 	 * First we scrub and fix the AG headers, because we need
 	 * them to work well enough to check the AG btrees.
 	 */
-	ret = scrub_ag_headers(ctx, &sri);
+	scrub_item_schedule_group(&sri, XFROG_SCRUB_GROUP_AGHEADER);
+	ret = scrub_item_check(ctx, &sri);
 	if (ret)
 		goto err;
 
@@ -85,7 +86,8 @@ scan_ag_metadata(
 		goto err;
 
 	/* Now scrub the AG btrees. */
-	ret = scrub_ag_metadata(ctx, &sri);
+	scrub_item_schedule_group(&sri, XFROG_SCRUB_GROUP_PERAG);
+	ret = scrub_item_check(ctx, &sri);
 	if (ret)
 		goto err;
 
@@ -131,7 +133,8 @@ scan_fs_metadata(
 		goto out;
 
 	scrub_item_init_fs(&sri);
-	ret = scrub_meta_type(ctx, type, &sri);
+	scrub_item_schedule(&sri, type);
+	ret = scrub_item_check(ctx, &sri);
 	if (ret) {
 		sctl->aborted = true;
 		goto out;
@@ -189,7 +192,8 @@ phase2_func(
 	 * If errors occur, this function will log them and return nonzero.
 	 */
 	scrub_item_init_ag(&sri, 0);
-	ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_SB, &sri);
+	scrub_item_schedule(&sri, XFS_SCRUB_TYPE_SB);
+	ret = scrub_item_check(ctx, &sri);
 	if (ret)
 		goto out_wq;
 	ret = repair_item_completely(ctx, &sri);
diff --git a/scrub/phase3.c b/scrub/phase3.c
index fa2eef4dea1..09347c977b5 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -144,7 +144,8 @@ scrub_inode(
 		fd = scrub_open_handle(handle);
 
 	/* Scrub the inode. */
-	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_INODE, &sri);
+	scrub_item_schedule(&sri, XFS_SCRUB_TYPE_INODE);
+	error = scrub_item_check_file(ctx, &sri, fd);
 	if (error)
 		goto out;
 
@@ -153,13 +154,10 @@ scrub_inode(
 		goto out;
 
 	/* Scrub all block mappings. */
-	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_BMBTD, &sri);
-	if (error)
-		goto out;
-	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_BMBTA, &sri);
-	if (error)
-		goto out;
-	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_BMBTC, &sri);
+	scrub_item_schedule(&sri, XFS_SCRUB_TYPE_BMBTD);
+	scrub_item_schedule(&sri, XFS_SCRUB_TYPE_BMBTA);
+	scrub_item_schedule(&sri, XFS_SCRUB_TYPE_BMBTC);
+	error = scrub_item_check_file(ctx, &sri, fd);
 	if (error)
 		goto out;
 
@@ -177,27 +175,14 @@ scrub_inode(
 	 * content scrubbers.  Better to have them return -ENOENT than miss
 	 * some coverage.
 	 */
-	if (S_ISLNK(bstat->bs_mode) || !bstat->bs_mode) {
-		/* Check symlink contents. */
-		error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_SYMLINK,
-				&sri);
-		if (error)
-			goto out;
-	}
-	if (S_ISDIR(bstat->bs_mode) || !bstat->bs_mode) {
-		/* Check the directory entries. */
-		error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_DIR, &sri);
-		if (error)
-			goto out;
-	}
+	if (S_ISLNK(bstat->bs_mode) || !bstat->bs_mode)
+		scrub_item_schedule(&sri, XFS_SCRUB_TYPE_SYMLINK);
+	if (S_ISDIR(bstat->bs_mode) || !bstat->bs_mode)
+		scrub_item_schedule(&sri, XFS_SCRUB_TYPE_DIR);
 
-	/* Check all the extended attributes. */
-	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_XATTR, &sri);
-	if (error)
-		goto out;
-
-	/* Check parent pointers. */
-	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_PARENT, &sri);
+	scrub_item_schedule(&sri, XFS_SCRUB_TYPE_XATTR);
+	scrub_item_schedule(&sri, XFS_SCRUB_TYPE_PARENT);
+	error = scrub_item_check_file(ctx, &sri, fd);
 	if (error)
 		goto out;
 
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 230c559f07f..3c51b38a55e 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -143,9 +143,7 @@ phase4_func(
 	 * metadata.  If repairs fails, we'll come back during phase 7.
 	 */
 	scrub_item_init_fs(&sri);
-	ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_FSCOUNTERS, &sri);
-	if (ret)
-		return ret;
+	scrub_item_schedule(&sri, XFS_SCRUB_TYPE_FSCOUNTERS);
 
 	/*
 	 * Repair possibly bad quota counts before starting other repairs,
@@ -157,13 +155,13 @@ phase4_func(
 	if (ret)
 		return ret;
 
-	if (fsgeom.sick & XFS_FSOP_GEOM_SICK_QUOTACHECK) {
-		ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_QUOTACHECK, &sri);
-		if (ret)
-			return ret;
-	}
+	if (fsgeom.sick & XFS_FSOP_GEOM_SICK_QUOTACHECK)
+		scrub_item_schedule(&sri, XFS_SCRUB_TYPE_QUOTACHECK);
 
-	/* Repair counters before starting on the rest. */
+	/* Check and repair counters before starting on the rest. */
+	ret = scrub_item_check(ctx, &sri);
+	if (ret)
+		return ret;
 	ret = repair_item_corruption(ctx, &sri);
 	if (ret)
 		return ret;
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 6c9a518db4d..0df8c46e9f5 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -387,7 +387,6 @@ check_fs_label(
 struct fs_scan_item {
 	struct scrub_item	sri;
 	bool			*abortedp;
-	unsigned int		scrub_type;
 };
 
 /* Run one full-fs scan scrubber in this thread. */
@@ -412,7 +411,7 @@ fs_scan_worker(
 		nanosleep(&tv, NULL);
 	}
 
-	ret = scrub_meta_type(ctx, item->scrub_type, &item->sri);
+	ret = scrub_item_check(ctx, &item->sri);
 	if (ret) {
 		str_liberror(ctx, ret, _("checking fs scan metadata"));
 		*item->abortedp = true;
@@ -450,7 +449,7 @@ queue_fs_scan(
 		return ret;
 	}
 	scrub_item_init_fs(&item->sri);
-	item->scrub_type = scrub_type;
+	scrub_item_schedule(&item->sri, scrub_type);
 	item->abortedp = abortedp;
 
 	ret = -workqueue_add(wq, fs_scan_worker, nr, item);
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 02da6b42beb..cd4501f72b7 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -10,6 +10,8 @@
 #include <linux/fsmap.h>
 #include "libfrog/paths.h"
 #include "libfrog/ptvar.h"
+#include "libfrog/fsgeom.h"
+#include "libfrog/scrub.h"
 #include "list.h"
 #include "xfs_scrub.h"
 #include "common.h"
@@ -118,7 +120,8 @@ phase7_func(
 
 	/* Check and fix the summary metadata. */
 	scrub_item_init_fs(&sri);
-	error = scrub_summary_metadata(ctx, &sri);
+	scrub_item_schedule_group(&sri, XFROG_SCRUB_GROUP_SUMMARY);
+	error = scrub_item_check(ctx, &sri);
 	if (error)
 		return error;
 	error = repair_item_completely(ctx, &sri);
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 5fc549f9728..5aa36a96499 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -86,9 +86,11 @@ xfs_check_metadata(
 	bool				is_inode)
 {
 	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
+	enum xfrog_scrub_group		group;
 	unsigned int			tries = 0;
 	int				error;
 
+	group = xfrog_scrubbers[meta->sm_type].group;
 	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
 	assert(meta->sm_type < XFS_SCRUB_TYPE_NR);
 	descr_set(&dsc, meta);
@@ -165,7 +167,7 @@ _("Repairs are required."));
 	 */
 	if (is_unoptimized(meta)) {
 		if (ctx->mode != SCRUB_MODE_REPAIR) {
-			if (!is_inode) {
+			if (group != XFROG_SCRUB_GROUP_INODE) {
 				/* AG or FS metadata, always warn. */
 				str_info(ctx, descr_render(&dsc),
 _("Optimization is possible."));
@@ -223,9 +225,10 @@ _("Optimizations of %s are possible."), _(xfrog_scrubbers[i].descr));
  * Returns 0 for success.  If errors occur, this function will log them and
  * return a positive error code.
  */
-int
+static int
 scrub_meta_type(
 	struct scrub_ctx		*ctx,
+	struct xfs_fd			*xfdp,
 	unsigned int			type,
 	struct scrub_item		*sri)
 {
@@ -243,16 +246,20 @@ scrub_meta_type(
 		break;
 	case XFROG_SCRUB_GROUP_FS:
 	case XFROG_SCRUB_GROUP_SUMMARY:
+	case XFROG_SCRUB_GROUP_ISCAN:
 	case XFROG_SCRUB_GROUP_NONE:
 		break;
-	default:
-		assert(0);
+	case XFROG_SCRUB_GROUP_INODE:
+		meta.sm_ino = sri->sri_ino;
+		meta.sm_gen = sri->sri_gen;
 		break;
 	}
 
 	/* Check the item. */
-	fix = xfs_check_metadata(ctx, &ctx->mnt, &meta, false);
-	progress_add(1);
+	fix = xfs_check_metadata(ctx, xfdp, &meta, false);
+
+	if (xfrog_scrubbers[type].group != XFROG_SCRUB_GROUP_INODE)
+		progress_add(1);
 
 	switch (fix) {
 	case CHECK_ABORT:
@@ -269,60 +276,54 @@ scrub_meta_type(
 	}
 }
 
-/*
- * Scrub all metadata types that are assigned to the given XFROG_SCRUB_GROUP_*,
- * saving corruption reports for later.  This should not be used for
- * XFROG_SCRUB_GROUP_INODE or for checking summary metadata.
- */
-static bool
-scrub_group(
-	struct scrub_ctx		*ctx,
-	enum xfrog_scrub_group		group,
-	struct scrub_item		*sri)
+/* Schedule scrub for all metadata of a given group. */
+void
+scrub_item_schedule_group(
+	struct scrub_item		*sri,
+	enum xfrog_scrub_group		group)
 {
-	const struct xfrog_scrub_descr	*sc;
-	unsigned int			type;
-
-	sc = xfrog_scrubbers;
-	for (type = 0; type < XFS_SCRUB_TYPE_NR; type++, sc++) {
-		int			ret;
+	unsigned int			scrub_type;
 
-		if (sc->group != group)
+	foreach_scrub_type(scrub_type) {
+		if (xfrog_scrubbers[scrub_type].group != group)
 			continue;
-
-		ret = scrub_meta_type(ctx, type, sri);
-		if (ret)
-			return ret;
+		scrub_item_schedule(sri, scrub_type);
 	}
-
-	return 0;
 }
 
-/* Scrub each AG's header blocks. */
+/* Run all the incomplete scans on this scrub principal. */
 int
-scrub_ag_headers(
+scrub_item_check_file(
 	struct scrub_ctx		*ctx,
-	struct scrub_item		*sri)
+	struct scrub_item		*sri,
+	int				override_fd)
 {
-	return scrub_group(ctx, XFROG_SCRUB_GROUP_AGHEADER, sri);
-}
+	struct xfs_fd			xfd;
+	struct xfs_fd			*xfdp = &ctx->mnt;
+	unsigned int			scrub_type;
+	int				error;
 
-/* Scrub each AG's metadata btrees. */
-int
-scrub_ag_metadata(
-	struct scrub_ctx		*ctx,
-	struct scrub_item		*sri)
-{
-	return scrub_group(ctx, XFROG_SCRUB_GROUP_PERAG, sri);
-}
+	/*
+	 * If the caller passed us a file descriptor for a scrub, use it
+	 * instead of scrub-by-handle because this enables the kernel to skip
+	 * costly inode btree lookups.
+	 */
+	if (override_fd >= 0) {
+		memcpy(&xfd, xfdp, sizeof(xfd));
+		xfd.fd = override_fd;
+		xfdp = &xfd;
+	}
 
-/* Scrub all FS summary metadata. */
-int
-scrub_summary_metadata(
-	struct scrub_ctx		*ctx,
-	struct scrub_item		*sri)
-{
-	return scrub_group(ctx, XFROG_SCRUB_GROUP_SUMMARY, sri);
+	foreach_scrub_type(scrub_type) {
+		if (!(sri->sri_state[scrub_type] & SCRUB_ITEM_NEEDSCHECK))
+			continue;
+
+		error = scrub_meta_type(ctx, xfdp, scrub_type, sri);
+		if (error)
+			break;
+	}
+
+	return error;
 }
 
 /* How many items do we have to check? */
@@ -374,54 +375,6 @@ scrub_estimate_iscan_work(
 	return estimate;
 }
 
-/*
- * Scrub file metadata of some sort.  If errors occur, this function will log
- * them and return nonzero.
- */
-int
-scrub_file(
-	struct scrub_ctx		*ctx,
-	int				fd,
-	const struct xfs_bulkstat	*bstat,
-	unsigned int			type,
-	struct scrub_item		*sri)
-{
-	struct xfs_scrub_metadata	meta = {0};
-	struct xfs_fd			xfd;
-	struct xfs_fd			*xfdp = &ctx->mnt;
-	enum check_outcome		fix;
-
-	assert(type < XFS_SCRUB_TYPE_NR);
-	assert(xfrog_scrubbers[type].group == XFROG_SCRUB_GROUP_INODE);
-
-	meta.sm_type = type;
-	meta.sm_ino = bstat->bs_ino;
-	meta.sm_gen = bstat->bs_gen;
-
-	/*
-	 * If the caller passed us a file descriptor for a scrub, use it
-	 * instead of scrub-by-handle because this enables the kernel to skip
-	 * costly inode btree lookups.
-	 */
-	if (fd >= 0) {
-		memcpy(&xfd, xfdp, sizeof(xfd));
-		xfd.fd = fd;
-		xfdp = &xfd;
-	}
-
-	/* Scrub the piece of metadata. */
-	fix = xfs_check_metadata(ctx, xfdp, &meta, true);
-	if (fix == CHECK_ABORT)
-		return ECANCELED;
-	if (fix == CHECK_DONE) {
-		scrub_item_clean_state(sri, type);
-		return 0;
-	}
-
-	scrub_item_save_state(sri, type, meta.sm_flags);
-	return 0;
-}
-
 /* Dump a scrub item for debugging purposes. */
 void
 scrub_item_dump(
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 3ae0bfd2952..1ac0d8aed20 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -6,6 +6,8 @@
 #ifndef XFS_SCRUB_SCRUB_H_
 #define XFS_SCRUB_SCRUB_H_
 
+enum xfrog_scrub_group;
+
 /* Online scrub and repair. */
 enum check_outcome {
 	CHECK_DONE,	/* no further processing needed */
@@ -33,6 +35,9 @@ enum check_outcome {
 #define SCRUB_ITEM_XFAIL	(XFS_SCRUB_OFLAG_XFAIL)		/* (1 << 3) */
 #define SCRUB_ITEM_XCORRUPT	(XFS_SCRUB_OFLAG_XCORRUPT)	/* (1 << 4) */
 
+/* This scrub type needs to be checked. */
+#define SCRUB_ITEM_NEEDSCHECK	(1 << 5)
+
 /* All of the state flags that we need to prioritize repair work. */
 #define SCRUB_ITEM_REPAIR_ANY	(SCRUB_ITEM_CORRUPT | \
 				 SCRUB_ITEM_PREEN | \
@@ -96,13 +101,24 @@ scrub_item_init_file(struct scrub_item *sri, const struct xfs_bulkstat *bstat)
 void scrub_item_dump(struct scrub_item *sri, unsigned int group_mask,
 		const char *tag);
 
+static inline void
+scrub_item_schedule(struct scrub_item *sri, unsigned int scrub_type)
+{
+	sri->sri_state[scrub_type] = SCRUB_ITEM_NEEDSCHECK;
+}
+
+void scrub_item_schedule_group(struct scrub_item *sri,
+		enum xfrog_scrub_group group);
+int scrub_item_check_file(struct scrub_ctx *ctx, struct scrub_item *sri,
+		int override_fd);
+
+static inline int
+scrub_item_check(struct scrub_ctx *ctx, struct scrub_item *sri)
+{
+	return scrub_item_check_file(ctx, sri, -1);
+}
+
 void scrub_report_preen_triggers(struct scrub_ctx *ctx);
-int scrub_ag_headers(struct scrub_ctx *ctx, struct scrub_item *sri);
-int scrub_ag_metadata(struct scrub_ctx *ctx, struct scrub_item *sri);
-int scrub_iscan_metadata(struct scrub_ctx *ctx, struct scrub_item *sri);
-int scrub_summary_metadata(struct scrub_ctx *ctx, struct scrub_item *sri);
-int scrub_meta_type(struct scrub_ctx *ctx, unsigned int type,
-		struct scrub_item *sri);
 
 bool can_scrub_fs_metadata(struct scrub_ctx *ctx);
 bool can_scrub_inode(struct scrub_ctx *ctx);

