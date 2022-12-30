Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B08BAC3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235484AbiLaA36 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235648AbiLaA3y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:29:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890671EACF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:29:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1554761D47
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A98AC433D2;
        Sat, 31 Dec 2022 00:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446591;
        bh=iIuDcDw9qiiYcctymVMQmfjXDwID+YW0ooFqZU1QUzM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=i24HMN46uU4qoNiCYQxIO1Iz7NYpcXff5mDBrteCbdGv9mzTcu3zrrHzoyleG63f0
         1bvEbJvc6YiJpgSKBj+ylIIDhIFeXeJllL5qa6xql6RL9r0Bl5TRiNamZ4Gt5wFWa1
         ++riYrlCc+QYtxUIJlK2SJNQdtpA0EL0LS7cQnBE0cXsEsEvmTUnLnAhoEXnRmUvr5
         pFKidvsFHWfE/EssmxCilbeRaonbmyGvdlEWo1TWJ93IZyE3KiC1RTmIEkhB4bhi63
         kyiY6zA3OhbheVDLvxpsIEkv4yvKXszLLdE4ovI4IjDBfGltTuy3VXqO4lyJUmp+XF
         WbI1X9Q/ZM8rA==
Subject: [PATCH 1/5] xfs_scrub: start tracking scrub state in scrub_item
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:21 -0800
Message-ID: <167243870113.716382.5425252396933143192.stgit@magnolia>
In-Reply-To: <167243870099.716382.3489355808439125232.stgit@magnolia>
References: <167243870099.716382.3489355808439125232.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Start using the scrub_item to track which metadata objects need
checking by adding a new flag to the scrub_item state set.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase1.c |    3 +
 scrub/phase2.c |   12 +++--
 scrub/phase3.c |   39 +++++----------
 scrub/phase4.c |   16 +++---
 scrub/phase5.c |    5 +-
 scrub/phase7.c |    5 ++
 scrub/scrub.c  |  147 +++++++++++++++++++-------------------------------------
 scrub/scrub.h  |   28 ++++++++---
 8 files changed, 109 insertions(+), 146 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 6b2f6cdd5fa..18b1d5e948e 100644
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
index 138f0f8a8f3..7b580f4e4dd 100644
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
 
@@ -131,7 +133,8 @@ scan_metafile(
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
index 01171de64d1..06a338480e7 100644
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
 
@@ -167,24 +165,15 @@ scrub_inode(
 	if (error)
 		goto out;
 
-	if (S_ISLNK(bstat->bs_mode)) {
-		/* Check symlink contents. */
-		error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_SYMLINK,
-				&sri);
-	} else if (S_ISDIR(bstat->bs_mode)) {
-		/* Check the directory entries. */
-		error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_DIR, &sri);
-	}
-	if (error)
-		goto out;
+	/* Check everything accessible via file mapping. */
+	if (S_ISLNK(bstat->bs_mode))
+		scrub_item_schedule(&sri, XFS_SCRUB_TYPE_SYMLINK);
+	else if (S_ISDIR(bstat->bs_mode))
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
index ee6aa90f326..aa0b060fcc9 100644
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
index ea32d185751..96e13ac423f 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -386,7 +386,6 @@ check_fs_label(
 struct iscan_item {
 	struct scrub_item	sri;
 	bool			*abortedp;
-	unsigned int		scrub_type;
 };
 
 /* Run one inode-scan scrubber in this thread. */
@@ -411,7 +410,7 @@ iscan_worker(
 		nanosleep(&tv, NULL);
 	}
 
-	ret = scrub_meta_type(ctx, item->scrub_type, &item->sri);
+	ret = scrub_item_check(ctx, &item->sri);
 	if (ret) {
 		str_liberror(ctx, ret, _("checking iscan metadata"));
 		*item->abortedp = true;
@@ -449,7 +448,7 @@ queue_iscan(
 		return ret;
 	}
 	scrub_item_init_fs(&item->sri);
-	item->scrub_type = scrub_type;
+	scrub_item_schedule(&item->sri, scrub_type);
 	item->abortedp = abortedp;
 
 	ret = -workqueue_add(wq, iscan_worker, nr, item);
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 98846a1566b..75d0ee0fb02 100644
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
index 699e9aa3940..1a60631eddc 100644
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
 	case XFROG_SCRUB_GROUP_METAFILES:
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
index 75595f43ee9..1c24b054fd9 100644
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
@@ -96,13 +101,24 @@ scrub_item_init_file(struct scrub_item *sri, struct xfs_bulkstat *bstat)
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

