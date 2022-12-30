Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 797B2C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235621AbiLaAIj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235391AbiLaAIi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:08:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47731CB3E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:08:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E9AAB81DF7
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:08:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4B8C433EF;
        Sat, 31 Dec 2022 00:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445314;
        bh=RRe71CImCEMc7jEdrMAIg+VmJehchWsQr/i3qi84JwY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=frsS56DOMUewnfgZwMv/sldjzcVUkgfDwIrL+OZBQ0cxhm8pMicPKEzxFlrvGfOAI
         0S1t6MoHxq2AObKwYer0yLJXQMtftf6ZHlGrEpmsVVF/sm3BQyRdYKA3mtjSmJwKWJ
         anXcrhri+MLbYN1EFEvuH0frZWG/lh0hgGeC1NfT3t0vp2A+KMsq2hYxqMqX9KyLL4
         PNuchXPLq+uBw0p1SX7bc2+T7sa+LvzYO849aIjHgidnjYuBIOaiw0RQ1FOzzpFTZM
         kJjKNEGcnSFszkH3k0BP1SaCgXv0SxqQr8u2iYuIDuNpvZr5Ay6FWPaHSNmoGX1qWm
         lEqU4ZxFyi3RA==
Subject: [PATCH 2/3] libfrog: create a new scrub group for things requiring
 full inode scans
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:29 -0800
Message-ID: <167243864918.708814.3900773115101938843.stgit@magnolia>
In-Reply-To: <167243864892.708814.13943121883358066158.stgit@magnolia>
References: <167243864892.708814.13943121883358066158.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Subsequent patches will add online fsck types (quotacheck, link counts)
that require us to walk every inode in the entire filesystem.  This
requires the AG metadata and the inodes to be in good enough shape to
complete the scan without hitting corruption errors.  As such, they
ought to run after phases 2-4 and before phase 7, which summarizes what
we've found.

Phase 5 seems like a reasonable place to do this, since it already walks
every xattr and directory entry in the filesystem to look for suspicious
looking names.  Add a new XFROG_SCRUB_GROUP, and add it to phase 5.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/scrub.c        |    3 +++
 libfrog/scrub.h   |    1 +
 scrub/phase5.c    |   22 ++++++++++++++++++++--
 scrub/scrub.c     |   33 +++++++++++++++++++++++++++++++++
 scrub/scrub.h     |    1 +
 scrub/xfs_scrub.h |    1 +
 6 files changed, 59 insertions(+), 2 deletions(-)


diff --git a/io/scrub.c b/io/scrub.c
index 3971a9fedb5..0ad1b0229cc 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -68,6 +68,7 @@ scrub_ioctl(
 	case XFROG_SCRUB_GROUP_NONE:
 	case XFROG_SCRUB_GROUP_METAFILES:
 	case XFROG_SCRUB_GROUP_SUMMARY:
+	case XFROG_SCRUB_GROUP_ISCAN:
 		/* no control parameters */
 		break;
 	}
@@ -170,6 +171,7 @@ parse_args(
 	case XFROG_SCRUB_GROUP_METAFILES:
 	case XFROG_SCRUB_GROUP_NONE:
 	case XFROG_SCRUB_GROUP_SUMMARY:
+	case XFROG_SCRUB_GROUP_ISCAN:
 		if (optind != argc) {
 			fprintf(stderr,
 				_("No parameters allowed.\n"));
@@ -262,6 +264,7 @@ repair_ioctl(
 	case XFROG_SCRUB_GROUP_NONE:
 	case XFROG_SCRUB_GROUP_METAFILES:
 	case XFROG_SCRUB_GROUP_SUMMARY:
+	case XFROG_SCRUB_GROUP_ISCAN:
 		/* no control parameters */
 		break;
 	}
diff --git a/libfrog/scrub.h b/libfrog/scrub.h
index 14c4857bede..a59371fe141 100644
--- a/libfrog/scrub.h
+++ b/libfrog/scrub.h
@@ -13,6 +13,7 @@ enum xfrog_scrub_group {
 	XFROG_SCRUB_GROUP_PERAG,	/* per-AG metadata */
 	XFROG_SCRUB_GROUP_METAFILES,	/* whole-fs metadata files */
 	XFROG_SCRUB_GROUP_INODE,	/* per-inode metadata */
+	XFROG_SCRUB_GROUP_ISCAN,	/* metadata requiring full inode scan */
 	XFROG_SCRUB_GROUP_SUMMARY,	/* summary metadata */
 };
 
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 1ef234bff68..123e3751ca1 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -16,6 +16,8 @@
 #include "list.h"
 #include "libfrog/paths.h"
 #include "libfrog/workqueue.h"
+#include "libfrog/fsgeom.h"
+#include "libfrog/scrub.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "inodes.h"
@@ -23,8 +25,9 @@
 #include "scrub.h"
 #include "descr.h"
 #include "unicrash.h"
+#include "repair.h"
 
-/* Phase 5: Check directory connectivity. */
+/* Phase 5: Full inode scans and check directory connectivity. */
 
 /*
  * Warn about problematic bytes in a directory/attribute name.  That means
@@ -385,9 +388,24 @@ int
 phase5_func(
 	struct scrub_ctx	*ctx)
 {
+	struct action_list	alist;
 	bool			aborted = false;
 	int			ret;
 
+	/*
+	 * Check and fix anything that requires a full inode scan.  We do this
+	 * after we've checked all inodes and repaired anything that could get
+	 * in the way of a scan.
+	 */
+	action_list_init(&alist);
+	ret = scrub_iscan_metadata(ctx, &alist);
+	if (ret)
+		return ret;
+	ret = action_list_process(ctx, ctx->mnt.fd, &alist,
+			ALP_COMPLAIN_IF_UNFIXED | ALP_NOPROGRESS);
+	if (ret)
+		return ret;
+
 	if (ctx->corruptions_found || ctx->unfixable_errors) {
 		str_info(ctx, ctx->mntpoint,
 _("Filesystem has errors, skipping connectivity checks."));
@@ -416,7 +434,7 @@ phase5_estimate(
 	unsigned int		*nr_threads,
 	int			*rshift)
 {
-	*items = ctx->mnt_sv.f_files - ctx->mnt_sv.f_ffree;
+	*items = scrub_estimate_iscan_work(ctx);
 	*nr_threads = scrub_nproc(ctx);
 	*rshift = 0;
 	return 0;
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 20067df523f..5c7fc4c2a3a 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -47,6 +47,7 @@ format_scrub_descr(
 		break;
 	case XFROG_SCRUB_GROUP_METAFILES:
 	case XFROG_SCRUB_GROUP_SUMMARY:
+	case XFROG_SCRUB_GROUP_ISCAN:
 		return snprintf(buf, buflen, _("%s"), _(sc->descr));
 		break;
 	case XFROG_SCRUB_GROUP_NONE:
@@ -421,6 +422,15 @@ scrub_summary_metadata(
 	return scrub_group(ctx, XFROG_SCRUB_GROUP_SUMMARY, 0, alist);
 }
 
+/* Scrub all metadata requiring a full inode scan. */
+int
+scrub_iscan_metadata(
+	struct scrub_ctx		*ctx,
+	struct action_list		*alist)
+{
+	return scrub_group(ctx, XFROG_SCRUB_GROUP_ISCAN, 0, alist);
+}
+
 /* Scrub /only/ the superblock summary counters. */
 int
 scrub_fs_counters(
@@ -456,6 +466,29 @@ scrub_estimate_ag_work(
 	return estimate;
 }
 
+/*
+ * How many kernel calls will we make to scrub everything requiring a full
+ * inode scan?
+ */
+unsigned int
+scrub_estimate_iscan_work(
+	struct scrub_ctx		*ctx)
+{
+	const struct xfrog_scrub_descr	*sc;
+	int				type;
+	unsigned int			estimate;
+
+	estimate = ctx->mnt_sv.f_files - ctx->mnt_sv.f_ffree;
+
+	sc = xfrog_scrubbers;
+	for (type = 0; type < XFS_SCRUB_TYPE_NR; type++, sc++) {
+		if (sc->group == XFROG_SCRUB_GROUP_ISCAN)
+			estimate++;
+	}
+
+	return estimate;
+}
+
 /*
  * Scrub file metadata of some sort.  If errors occur, this function will log
  * them and return nonzero.
diff --git a/scrub/scrub.h b/scrub/scrub.h
index a4e36808f34..5d365f99148 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -24,6 +24,7 @@ int scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
 		struct action_list *alist);
 int scrub_metadata_file(struct scrub_ctx *ctx, unsigned int scrub_type,
 		struct action_list *alist);
+int scrub_iscan_metadata(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_summary_metadata(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_fs_counters(struct scrub_ctx *ctx, struct action_list *alist);
 
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 0d6b9dad2c9..768f935084f 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -99,6 +99,7 @@ int phase7_func(struct scrub_ctx *ctx);
 
 /* Progress estimator functions */
 unsigned int scrub_estimate_ag_work(struct scrub_ctx *ctx);
+unsigned int scrub_estimate_iscan_work(struct scrub_ctx *ctx);
 int phase2_estimate(struct scrub_ctx *ctx, uint64_t *items,
 		    unsigned int *nr_threads, int *rshift);
 int phase3_estimate(struct scrub_ctx *ctx, uint64_t *items,

