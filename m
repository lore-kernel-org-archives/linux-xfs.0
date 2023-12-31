Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FB0C140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lGt94RRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949ECC433C8;
	Sun, 31 Dec 2023 22:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062343;
	bh=XD/MsUI6VAxwCnirEH4XrZReYRsCL/4OaUZTOepuo5M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lGt94RRzENcl4BkQGUtsgRvlWo3qSMJpQYvWRmwKPruEhRL7gwdSgMoO7VvJDtBzh
	 pwSC8a/XUK5o20skVu17R5KjdGOsUwDp1nwtZL9BXloofEtFsXbTd6atAjupZibktg
	 vpp6xS01an19wYAyAUWfBgZp1iJZkKd03/nlf0VQR+eCbgQYTNFWss1WX3Yfbm2rCZ
	 ypLQelrAkQzdH3UkA5CN1adhwD5R19SHg60diOGDHSsdb6E8k8XQIobKv3XXzz/FRN
	 60I8L7D4hDzEQlwqjxjliUQNLe/A2zMB6GS6A5wR9UDf74SUHbq71NUHcA+sxk44Vy
	 SjfnQi64dMEWA==
Date: Sun, 31 Dec 2023 14:39:02 -0800
Subject: [PATCH 3/8] xfs_scrub: get rid of trivial fs metadata scanner helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404999074.1797544.12862346087688523993.stgit@frogsfrogsfrogs>
In-Reply-To: <170404999029.1797544.5974682335470417611.stgit@frogsfrogsfrogs>
References: <170404999029.1797544.5974682335470417611.stgit@frogsfrogsfrogs>
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

Get rid of these pointless wrappers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase1.c |    2 +-
 scrub/phase4.c |    9 +++++----
 scrub/phase5.c |   15 +++++++--------
 scrub/scrub.c  |   36 ------------------------------------
 scrub/scrub.h  |    4 ----
 5 files changed, 13 insertions(+), 53 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 81b0918a1c8..a61e154a84a 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -61,7 +61,7 @@ report_to_kernel(
 		return 0;
 
 	action_list_init(&alist);
-	ret = scrub_clean_health(ctx, &alist);
+	ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_HEALTHY, 0, &alist);
 	if (ret)
 		return ret;
 
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 0c67abf64a3..d01dc89f44f 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -136,14 +136,14 @@ phase4_func(
 		goto maybe_trim;
 
 	/*
-	 * Check the summary counters early.  Normally we do this during phase
-	 * seven, but some of the cross-referencing requires fairly accurate
+	 * Check the resource usage counters early.  Normally we do this during
+	 * phase 7, but some of the cross-referencing requires fairly accurate
 	 * summary counters.  Check and try to repair them now to minimize the
 	 * chance that repairs of primary metadata fail due to secondary
 	 * metadata.  If repairs fails, we'll come back during phase 7.
 	 */
 	action_list_init(&alist);
-	ret = scrub_fs_counters(ctx, &alist);
+	ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_FSCOUNTERS, 0, &alist);
 	if (ret)
 		return ret;
 
@@ -158,7 +158,8 @@ phase4_func(
 		return ret;
 
 	if (fsgeom.sick & XFS_FSOP_GEOM_SICK_QUOTACHECK) {
-		ret = scrub_quotacheck(ctx, &alist);
+		ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_QUOTACHECK, 0,
+				&alist);
 		if (ret)
 			return ret;
 	}
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 940e434c3cd..68d35cd5852 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -384,12 +384,10 @@ check_fs_label(
 	return error;
 }
 
-typedef int (*fs_scan_item_fn)(struct scrub_ctx *, struct action_list *);
-
 struct fs_scan_item {
 	struct action_list	alist;
 	bool			*abortedp;
-	fs_scan_item_fn		scrub_fn;
+	unsigned int		scrub_type;
 };
 
 /* Run one full-fs scan scrubber in this thread. */
@@ -414,7 +412,7 @@ fs_scan_worker(
 		nanosleep(&tv, NULL);
 	}
 
-	ret = item->scrub_fn(ctx, &item->alist);
+	ret = scrub_meta_type(ctx, item->scrub_type, 0, &item->alist);
 	if (ret) {
 		str_liberror(ctx, ret, _("checking fs scan metadata"));
 		*item->abortedp = true;
@@ -440,7 +438,7 @@ queue_fs_scan(
 	struct workqueue	*wq,
 	bool			*abortedp,
 	xfs_agnumber_t		nr,
-	fs_scan_item_fn		scrub_fn)
+	unsigned int		scrub_type)
 {
 	struct fs_scan_item	*item;
 	struct scrub_ctx	*ctx = wq->wq_ctx;
@@ -453,7 +451,7 @@ queue_fs_scan(
 		return ret;
 	}
 	action_list_init(&item->alist);
-	item->scrub_fn = scrub_fn;
+	item->scrub_type = scrub_type;
 	item->abortedp = abortedp;
 
 	ret = -workqueue_add(wq, fs_scan_worker, nr, item);
@@ -485,14 +483,15 @@ run_kernel_fs_scan_scrubbers(
 	 * The nlinks scanner is much faster than quotacheck because it only
 	 * walks directories, so we start it first.
 	 */
-	ret = queue_fs_scan(&wq_fs_scan, &aborted, nr, scrub_nlinks);
+	ret = queue_fs_scan(&wq_fs_scan, &aborted, nr, XFS_SCRUB_TYPE_NLINKS);
 	if (ret)
 		goto wait;
 
 	if (nr_threads > 1)
 		nr++;
 
-	ret = queue_fs_scan(&wq_fs_scan, &aborted, nr, scrub_quotacheck);
+	ret = queue_fs_scan(&wq_fs_scan, &aborted, nr,
+			XFS_SCRUB_TYPE_QUOTACHECK);
 	if (ret)
 		goto wait;
 
diff --git a/scrub/scrub.c b/scrub/scrub.c
index c2e56e5f1cb..6e857c79dfb 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -366,42 +366,6 @@ scrub_summary_metadata(
 	return scrub_group(ctx, XFROG_SCRUB_GROUP_SUMMARY, 0, alist);
 }
 
-/* Scrub /only/ the superblock summary counters. */
-int
-scrub_fs_counters(
-	struct scrub_ctx		*ctx,
-	struct action_list		*alist)
-{
-	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_FSCOUNTERS, 0, alist);
-}
-
-/* Scrub /only/ the quota counters. */
-int
-scrub_quotacheck(
-	struct scrub_ctx		*ctx,
-	struct action_list		*alist)
-{
-	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_QUOTACHECK, 0, alist);
-}
-
-/* Scrub /only/ the file link counters. */
-int
-scrub_nlinks(
-	struct scrub_ctx		*ctx,
-	struct action_list		*alist)
-{
-	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_NLINKS, 0, alist);
-}
-
-/* Update incore health records if we were clean. */
-int
-scrub_clean_health(
-	struct scrub_ctx		*ctx,
-	struct action_list		*alist)
-{
-	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_HEALTHY, 0, alist);
-}
-
 /* How many items do we have to check? */
 unsigned int
 scrub_estimate_ag_work(
diff --git a/scrub/scrub.h b/scrub/scrub.h
index fef8a596049..98819a25b62 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -25,10 +25,6 @@ int scrub_fs_metadata(struct scrub_ctx *ctx, unsigned int scrub_type,
 		struct action_list *alist);
 int scrub_iscan_metadata(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_summary_metadata(struct scrub_ctx *ctx, struct action_list *alist);
-int scrub_fs_counters(struct scrub_ctx *ctx, struct action_list *alist);
-int scrub_quotacheck(struct scrub_ctx *ctx, struct action_list *alist);
-int scrub_nlinks(struct scrub_ctx *ctx, struct action_list *alist);
-int scrub_clean_health(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_meta_type(struct scrub_ctx *ctx, unsigned int type,
 		xfs_agnumber_t agno, struct action_list *alist);
 

