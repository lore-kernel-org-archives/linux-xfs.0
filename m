Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58286C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235873AbiLaAHe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235857AbiLaAHd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:07:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2CA1E3C3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:07:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 787E961CCD
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9A8C433D2;
        Sat, 31 Dec 2022 00:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445251;
        bh=S/KSYmQJ6q2gEYBwIUa10jzEfxJgpcQ8T+U0/5PQmnM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=szzRfHR5jUdzXUxFHctlbWzz5APQ0Gdm+xzqfAadRGNeWL3xKuA+VyBvNTttSsfCE
         7XXCs5hc53MehW6WbowZvO+DFhm+ufT0h2BalC8OfQ96MyK+zcLqVIB+gfju6HB62H
         pfDWbBv9pwCyI586L7fntrIKszM/YP1RNQMgmwEYtF7D96vkhTd7WwSaW8mCIZ7Ngk
         DvSbTtHYDWEnsWGHApHciiFTd6EFshSUPrtg/g8PVI/C2VrA7XGBBDJeqRyCT2ZEbx
         VjAZNb/GpcOt1amQWzBqklFYfQ5eTxda3xJMgYAYK3NxVy2Ic6vL3HeU6+HUyPTdDA
         /5QlvmaCEaACA==
Subject: [PATCH 2/4] libfrog: promote XFROG_SCRUB_DESCR_SUMMARY to a scrub
 type
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:25 -0800
Message-ID: <167243864581.708428.5060762446690772815.stgit@magnolia>
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

"Summary" metadata, at least in the scrub context, are metadata whose
values depend on some kind of computation and therefore can only be
checked after we've looked at all the other metadata.  Currently, the
superblock summary counters are the only thing that are like this, but
since they run in a totally separate xfs_scrub phase (7 vs. 2), make
them their own group and remove the group+flag mix.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/scrub.c      |    3 +++
 libfrog/scrub.c |    3 +--
 libfrog/scrub.h |    8 +-------
 scrub/phase4.c  |    2 +-
 scrub/phase7.c  |    4 ++--
 scrub/scrub.c   |   16 ++++++++++++----
 scrub/scrub.h   |    3 ++-
 7 files changed, 22 insertions(+), 17 deletions(-)


diff --git a/io/scrub.c b/io/scrub.c
index 0cad69253dc..4cfa4bc3c4c 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -67,6 +67,7 @@ scrub_ioctl(
 		break;
 	case XFROG_SCRUB_GROUP_NONE:
 	case XFROG_SCRUB_GROUP_FS:
+	case XFROG_SCRUB_GROUP_SUMMARY:
 		/* no control parameters */
 		break;
 	}
@@ -168,6 +169,7 @@ parse_args(
 		break;
 	case XFROG_SCRUB_GROUP_FS:
 	case XFROG_SCRUB_GROUP_NONE:
+	case XFROG_SCRUB_GROUP_SUMMARY:
 		if (optind != argc) {
 			fprintf(stderr,
 				_("No parameters allowed.\n"));
@@ -259,6 +261,7 @@ repair_ioctl(
 		break;
 	case XFROG_SCRUB_GROUP_NONE:
 	case XFROG_SCRUB_GROUP_FS:
+	case XFROG_SCRUB_GROUP_SUMMARY:
 		/* no control parameters */
 		break;
 	}
diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 90fc2b1a40c..5a5f522a425 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -132,8 +132,7 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_FSCOUNTERS] = {
 		.name	= "fscounters",
 		.descr	= "filesystem summary counters",
-		.group	= XFROG_SCRUB_GROUP_FS,
-		.flags	= XFROG_SCRUB_DESCR_SUMMARY,
+		.group	= XFROG_SCRUB_GROUP_SUMMARY,
 	},
 };
 
diff --git a/libfrog/scrub.h b/libfrog/scrub.h
index 43a882321f9..68f1a968103 100644
--- a/libfrog/scrub.h
+++ b/libfrog/scrub.h
@@ -13,6 +13,7 @@ enum xfrog_scrub_group {
 	XFROG_SCRUB_GROUP_PERAG,	/* per-AG metadata */
 	XFROG_SCRUB_GROUP_FS,		/* per-FS metadata */
 	XFROG_SCRUB_GROUP_INODE,	/* per-inode metadata */
+	XFROG_SCRUB_GROUP_SUMMARY,	/* summary metadata */
 };
 
 /* Catalog of scrub types and names, indexed by XFS_SCRUB_TYPE_* */
@@ -20,15 +21,8 @@ struct xfrog_scrub_descr {
 	const char		*name;
 	const char		*descr;
 	enum xfrog_scrub_group	group;
-	unsigned int		flags;
 };
 
-/*
- * The type of metadata checked by this scrubber is a summary of other types
- * of metadata.  This scrubber should be run after all the others.
- */
-#define XFROG_SCRUB_DESCR_SUMMARY	(1 << 0)
-
 extern const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR];
 
 int xfrog_scrub_metadata(struct xfs_fd *xfd, struct xfs_scrub_metadata *meta);
diff --git a/scrub/phase4.c b/scrub/phase4.c
index ecd56056ca2..3c985cdc13a 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -139,7 +139,7 @@ phase4_func(
 	 * counters, so counter repairs have to be put on the list now so that
 	 * they get fixed before we stop retrying unfixed metadata repairs.
 	 */
-	ret = scrub_fs_summary(ctx, &ctx->action_lists[0]);
+	ret = scrub_fs_counters(ctx, &ctx->action_lists[0]);
 	if (ret)
 		return ret;
 
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 8d8034c36af..2b83e0a471d 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -116,9 +116,9 @@ phase7_func(
 	int			ip;
 	int			error;
 
-	/* Check and fix the fs summary counters. */
+	/* Check and fix the summary metadata. */
 	action_list_init(&alist);
-	error = scrub_fs_summary(ctx, &alist);
+	error = scrub_summary_metadata(ctx, &alist);
 	if (error)
 		return error;
 	error = action_list_process(ctx, -1, &alist,
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 61a111db080..b7e120e91d6 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -46,6 +46,7 @@ format_scrub_descr(
 				_(sc->descr));
 		break;
 	case XFROG_SCRUB_GROUP_FS:
+	case XFROG_SCRUB_GROUP_SUMMARY:
 		return snprintf(buf, buflen, _("%s"), _(sc->descr));
 		break;
 	case XFROG_SCRUB_GROUP_NONE:
@@ -356,8 +357,6 @@ scrub_group(
 
 		if (sc->group != group)
 			continue;
-		if (sc->flags & XFROG_SCRUB_DESCR_SUMMARY)
-			continue;
 
 		ret = scrub_meta_type(ctx, type, agno, alist);
 		if (ret)
@@ -410,9 +409,18 @@ scrub_fs_metadata(
 	return scrub_group(ctx, XFROG_SCRUB_GROUP_FS, 0, alist);
 }
 
-/* Scrub FS summary metadata. */
+/* Scrub all FS summary metadata. */
 int
-scrub_fs_summary(
+scrub_summary_metadata(
+	struct scrub_ctx		*ctx,
+	struct action_list		*alist)
+{
+	return scrub_group(ctx, XFROG_SCRUB_GROUP_SUMMARY, 0, alist);
+}
+
+/* Scrub /only/ the superblock summary counters. */
+int
+scrub_fs_counters(
 	struct scrub_ctx		*ctx,
 	struct action_list		*alist)
 {
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 023069ee066..56836cf2ba3 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -23,7 +23,8 @@ int scrub_ag_headers(struct scrub_ctx *ctx, xfs_agnumber_t agno,
 int scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
 		struct action_list *alist);
 int scrub_fs_metadata(struct scrub_ctx *ctx, struct action_list *alist);
-int scrub_fs_summary(struct scrub_ctx *ctx, struct action_list *alist);
+int scrub_summary_metadata(struct scrub_ctx *ctx, struct action_list *alist);
+int scrub_fs_counters(struct scrub_ctx *ctx, struct action_list *alist);
 
 bool can_scrub_fs_metadata(struct scrub_ctx *ctx);
 bool can_scrub_inode(struct scrub_ctx *ctx);

