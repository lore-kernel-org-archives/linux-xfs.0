Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A5512E4E
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710296018; cv=none; b=Ptj41Ht7cWaNXYYvYydzw88Gx5LJNfUSQJHNX9UPyoUm19Xjjvq83/jfyqq+AVfjGr1tUctBa0QfU7OY76Yq/FuUls1hkOru7TptkQAROjwglc9rzz0EpK6bhOaq5AW65cUry4+ipfPAb6So1/SPRb076qEJP5jM6yM843CWzXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710296018; c=relaxed/simple;
	bh=YoUc+TVgpukWi01X9KHZbaloJQ1zvw25Zzd/j5md6Ac=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BY2coDe4PFdr7IjJq46zaTIYYwwX/a32jQXYxDu6KpkrJRl1QNT7SXfbHrd0f6IyfBFPCzkrpSL0buR3pooyhzIIRcjB0YBrHYCGdQ+mDxF8XmsVFC14UOYnyT1ZQ1NAh/xha4WAkmautSfRsHYVSxnnAasjl9mW3VAJ3E4xgZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cCbFrMPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cCbFrMPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A65C433F1;
	Wed, 13 Mar 2024 02:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710296018;
	bh=YoUc+TVgpukWi01X9KHZbaloJQ1zvw25Zzd/j5md6Ac=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cCbFrMPEjVYPtec3/18vkiW0aKVVxVmDNrjik7NAX3BmhKjtaQxwvfOkY3HDO9I9C
	 +6/la6JYYoXHW2SZFpme3z+rBpPi0gqxHJE1osKcw8kDW17qi8gkIcFd8XzOAked0Q
	 oEV+s/cN5OT+/WKtaHA0E94Uw6xx5bHNkM8x3rJEYxG/cyOkzJ0i9PK740uJrmzTnb
	 eNtI424Qj8Yg4XisnxEN0RNNfI6AmLg7Cdo2GKVTKDmcH4iQH/5Ku3W8mC38EKsLKi
	 DLetndqyuXVNgOgIuLryBt3KZ6xIOM6TkF+yM+xBJ5UCbK6VLWryOSu7hazOAmAX9L
	 Uptz+nf8bLJkw==
Date: Tue, 12 Mar 2024 19:13:37 -0700
Subject: [PATCH 2/3] libfrog: promote XFROG_SCRUB_DESCR_SUMMARY to a scrub
 type
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029433978.2065570.9230970776737199107.stgit@frogsfrogsfrogs>
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

"Summary" metadata, at least in the scrub context, are metadata whose
values depend on some kind of computation and therefore can only be
checked after we've looked at all the other metadata.  Currently, the
superblock summary counters are the only thing that are like this, but
since they run in a totally separate xfs_scrub phase (7 vs. 2), make
them their own group and remove the group+flag mix.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 io/scrub.c      |    1 +
 libfrog/scrub.c |    3 +--
 libfrog/scrub.h |    8 +-------
 scrub/phase4.c  |    2 +-
 scrub/phase7.c  |    4 ++--
 scrub/scrub.c   |   16 ++++++++++++----
 scrub/scrub.h   |    3 ++-
 7 files changed, 20 insertions(+), 17 deletions(-)


diff --git a/io/scrub.c b/io/scrub.c
index d6eda5bea538..70301c0676c4 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -183,6 +183,7 @@ parse_args(
 		break;
 	case XFROG_SCRUB_GROUP_FS:
 	case XFROG_SCRUB_GROUP_NONE:
+	case XFROG_SCRUB_GROUP_SUMMARY:
 		if (!parse_none(argc, optind)) {
 			exitcode = 1;
 			return command_usage(cmdinfo);
diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 90fc2b1a40cd..5a5f522a4258 100644
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
index 43a882321f99..68f1a968103e 100644
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
index 1228c7cb6545..5dfc3856b82f 100644
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
index 2fd96053f6cc..93a074f11513 100644
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
index cde9babc5574..c7ee074fd36c 100644
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
index f7e66bb614b4..35d609f283a4 100644
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

