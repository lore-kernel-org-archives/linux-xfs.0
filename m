Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4E68C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235788AbiLaA0Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235760AbiLaA0P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:26:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF6BD104
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:26:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A77361D33
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED661C433EF;
        Sat, 31 Dec 2022 00:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446374;
        bh=cTDTRnNx4uvi0VByraorkMeWAy6yFPIwm9e63Tsj5LI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ir8mSK/l914ju2KBW4ynyJ0HS3xm9T2tjqrQTUZ67MIMHTRz2HzTLCmd7JeNeMTy3
         GHHj4KHeA0K8LQ3G+1sV1pCE13mTHqOcL13/ac353vJJ5NtT9l0K5cUt2Gxx7W37KG
         qpssED3aNdZfx044bWBF+udyNbTEJzACSmxuMSFwVmEgDdxqGY9nkT5HMUhRalbB9l
         81KJCcFk9Lx+QGGIiivHl0fQ9VGVTz3qPeQQiCxHwn9l2SfO1D036inedlaO1wUQ98
         fgsh+zxlLkCY4t40wW4AoA2lumxrprOycRyIoSE4UQu9eu4PljwTVfn3sk/R0zpIMD
         02DMe5aMssMXg==
Subject: [PATCH 2/6] xfs_scrub: get rid of trivial fs metadata scanner helpers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:13 -0800
Message-ID: <167243869393.715119.14529684698305779899.stgit@magnolia>
In-Reply-To: <167243869365.715119.17881025524336922669.stgit@magnolia>
References: <167243869365.715119.17881025524336922669.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Get rid of these pointless wrappers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase1.c |    2 +-
 scrub/phase4.c |    9 +++++----
 scrub/phase5.c |   14 ++++++--------
 scrub/scrub.c  |   36 ------------------------------------
 scrub/scrub.h  |    4 ----
 5 files changed, 12 insertions(+), 53 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 2d258a1a182..047631802e4 100644
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
index 5929df38084..df9b066cfd2 100644
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
index 93dd14d50ba..e598ffd3985 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -383,12 +383,10 @@ check_fs_label(
 	return error;
 }
 
-typedef int (*iscan_item_fn)(struct scrub_ctx *, struct action_list *);
-
 struct iscan_item {
 	struct action_list	alist;
 	bool			*abortedp;
-	iscan_item_fn		scrub_fn;
+	unsigned int		scrub_type;
 };
 
 /* Run one inode-scan scrubber in this thread. */
@@ -413,7 +411,7 @@ iscan_worker(
 		nanosleep(&tv, NULL);
 	}
 
-	ret = item->scrub_fn(ctx, &item->alist);
+	ret = scrub_meta_type(ctx, item->scrub_type, 0, &item->alist);
 	if (ret) {
 		str_liberror(ctx, ret, _("checking iscan metadata"));
 		*item->abortedp = true;
@@ -439,7 +437,7 @@ queue_iscan(
 	struct workqueue	*wq,
 	bool			*abortedp,
 	xfs_agnumber_t		nr,
-	iscan_item_fn		scrub_fn)
+	unsigned int		scrub_type)
 {
 	struct iscan_item	*item;
 	struct scrub_ctx	*ctx = wq->wq_ctx;
@@ -452,7 +450,7 @@ queue_iscan(
 		return ret;
 	}
 	action_list_init(&item->alist);
-	item->scrub_fn = scrub_fn;
+	item->scrub_type = scrub_type;
 	item->abortedp = abortedp;
 
 	ret = -workqueue_add(wq, iscan_worker, nr, item);
@@ -484,14 +482,14 @@ run_kernel_iscan_scrubbers(
 	 * The nlinks scanner is much faster than quotacheck because it only
 	 * walks directories, so we start it first.
 	 */
-	ret = queue_iscan(&wq_iscan, &aborted, nr, scrub_nlinks);
+	ret = queue_iscan(&wq_iscan, &aborted, nr, XFS_SCRUB_TYPE_NLINKS);
 	if (ret)
 		goto wait;
 
 	if (nr_threads > 1)
 		nr++;
 
-	ret = queue_iscan(&wq_iscan, &aborted, nr, scrub_quotacheck);
+	ret = queue_iscan(&wq_iscan, &aborted, nr, XFS_SCRUB_TYPE_QUOTACHECK);
 	if (ret)
 		goto wait;
 
diff --git a/scrub/scrub.c b/scrub/scrub.c
index bd33fcb770c..fe4603f863b 100644
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
index f228ffb89fc..b02e8f16815 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -25,10 +25,6 @@ int scrub_metadata_file(struct scrub_ctx *ctx, unsigned int scrub_type,
 		struct action_list *alist);
 int scrub_iscan_metadata(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_summary_metadata(struct scrub_ctx *ctx, struct action_list *alist);
-int scrub_fs_counters(struct scrub_ctx *ctx, struct action_list *alist);
-int scrub_quotacheck(struct scrub_ctx *ctx, struct action_list *alist);
-int scrub_nlinks(struct scrub_ctx *ctx, struct action_list *alist);
-int scrub_clean_health(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_meta_type(struct scrub_ctx *ctx, unsigned int type,
 		xfs_agnumber_t agno, struct action_list *alist);
 

