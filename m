Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9517C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235673AbiLaAKM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbiLaAKL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:10:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0608A1CB3E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:10:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB9C9B81DF6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFD9C433EF;
        Sat, 31 Dec 2022 00:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445407;
        bh=mXsZqKDDRl/pVY3Gs0yBZiSTdtMqQl6sJxUXiZotcJo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pTcUiD4GGIwj+BNx6G1lijDvzSwHd7EAfFgJ1ty2zsU+aqux/2HecMwyDD0HQrbM/
         Nsomc4KLekBGE8teAP21mDmyhqQzUBwgXTuYudqNRJdsGJPHoeXmliAqG1FFyJ7XWY
         WS8kYDYS9IZzZdek4CX8rKTdZDtRLi3Woi2RzZbUzxIRRbDNtOa8rDEG0/zlHw2qUi
         XgBthKv9CQCaMvXrqfdFSwK44ISOuB7JuRPkfAN7iEJLndUir2o+YRlD69GEUQ4Tf9
         7p8ENfpF9CVCO1vNkI0u2qctwD4Uq6QhEsC9OrmxITjG6wk1DeyJqcWJFpYv4Ov3PZ
         mWW2gdSp6cW9Q==
Subject: [PATCH 3/3] xfs_scrub: use multiple threads to run in-kernel metadata
 scrubs that scan inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:35 -0800
Message-ID: <167243865542.709394.18210123102047724459.stgit@magnolia>
In-Reply-To: <167243865502.709394.13215707195694339795.stgit@magnolia>
References: <167243865502.709394.13215707195694339795.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Instead of running the inode link count and quotacheck scanners in
serial, run them in parallel, with a slight delay to stagger the work to
reduce inode resource contention.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase5.c |  136 +++++++++++++++++++++++++++++++++++++++++++++++++++++---
 scrub/scrub.c  |   18 ++++---
 scrub/scrub.h  |    1 
 3 files changed, 138 insertions(+), 17 deletions(-)


diff --git a/scrub/phase5.c b/scrub/phase5.c
index 123e3751ca1..622e58138db 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -383,12 +383,137 @@ check_fs_label(
 	return error;
 }
 
+typedef int (*iscan_item_fn)(struct scrub_ctx *, struct action_list *);
+
+struct iscan_item {
+	struct action_list	alist;
+	bool			*abortedp;
+	iscan_item_fn		scrub_fn;
+};
+
+/* Run one inode-scan scrubber in this thread. */
+static void
+iscan_worker(
+	struct workqueue	*wq,
+	xfs_agnumber_t		nr,
+	void			*arg)
+{
+	struct timespec		tv;
+	struct iscan_item	*item = arg;
+	struct scrub_ctx	*ctx = wq->wq_ctx;
+	int			ret;
+
+	/*
+	 * Delay each successive iscan by a second so that the threads are less
+	 * likely to contend on the inode buffers.
+	 */
+	if (nr) {
+		tv.tv_sec = nr;
+		tv.tv_nsec = 0;
+		nanosleep(&tv, NULL);
+	}
+
+	ret = item->scrub_fn(ctx, &item->alist);
+	if (ret) {
+		str_liberror(ctx, ret, _("checking iscan metadata"));
+		*item->abortedp = true;
+		goto out;
+	}
+
+	ret = action_list_process(ctx, ctx->mnt.fd, &item->alist,
+			ALP_COMPLAIN_IF_UNFIXED | ALP_NOPROGRESS);
+	if (ret) {
+		str_liberror(ctx, ret, _("repairing iscan metadata"));
+		*item->abortedp = true;
+		goto out;
+	}
+
+out:
+	free(item);
+	return;
+}
+
+/* Queue one inode-scan scrubber. */
+static int
+queue_iscan(
+	struct workqueue	*wq,
+	bool			*abortedp,
+	xfs_agnumber_t		nr,
+	iscan_item_fn		scrub_fn)
+{
+	struct iscan_item	*item;
+	struct scrub_ctx	*ctx = wq->wq_ctx;
+	int			ret;
+
+	item = malloc(sizeof(struct iscan_item));
+	if (!item) {
+		ret = ENOMEM;
+		str_liberror(ctx, ret, _("setting up iscan"));
+		return ret;
+	}
+	action_list_init(&item->alist);
+	item->scrub_fn = scrub_fn;
+	item->abortedp = abortedp;
+
+	ret = -workqueue_add(wq, iscan_worker, nr, item);
+	if (ret)
+		str_liberror(ctx, ret, _("queuing iscan work"));
+
+	return ret;
+}
+
+/* Run multiple inode-scan scrubbers at the same time. */
+static int
+run_kernel_iscan_scrubbers(
+	struct scrub_ctx	*ctx)
+{
+	struct workqueue	wq_iscan;
+	unsigned int		nr_threads = scrub_nproc_workqueue(ctx);
+	xfs_agnumber_t		nr = 0;
+	bool			aborted = false;
+	int			ret, ret2;
+
+	ret = -workqueue_create(&wq_iscan, (struct xfs_mount *)ctx,
+			nr_threads);
+	if (ret) {
+		str_liberror(ctx, ret, _("setting up iscan workqueue"));
+		return ret;
+	}
+
+	/*
+	 * The nlinks scanner is much faster than quotacheck because it only
+	 * walks directories, so we start it first.
+	 */
+	ret = queue_iscan(&wq_iscan, &aborted, nr, scrub_nlinks);
+	if (ret)
+		goto wait;
+
+	if (nr_threads > 1)
+		nr++;
+
+	ret = queue_iscan(&wq_iscan, &aborted, nr, scrub_quotacheck);
+	if (ret)
+		goto wait;
+
+wait:
+	ret2 = -workqueue_terminate(&wq_iscan);
+	if (ret2) {
+		str_liberror(ctx, ret2, _("joining iscan workqueue"));
+		if (!ret)
+			ret = ret2;
+	}
+	if (aborted && !ret)
+		ret = ECANCELED;
+
+	workqueue_destroy(&wq_iscan);
+	return ret;
+}
+
 /* Check directory connectivity. */
 int
 phase5_func(
 	struct scrub_ctx	*ctx)
 {
-	struct action_list	alist;
 	bool			aborted = false;
 	int			ret;
 
@@ -397,12 +522,7 @@ phase5_func(
 	 * after we've checked all inodes and repaired anything that could get
 	 * in the way of a scan.
 	 */
-	action_list_init(&alist);
-	ret = scrub_iscan_metadata(ctx, &alist);
-	if (ret)
-		return ret;
-	ret = action_list_process(ctx, ctx->mnt.fd, &alist,
-			ALP_COMPLAIN_IF_UNFIXED | ALP_NOPROGRESS);
+	ret = run_kernel_iscan_scrubbers(ctx);
 	if (ret)
 		return ret;
 
@@ -435,7 +555,7 @@ phase5_estimate(
 	int			*rshift)
 {
 	*items = scrub_estimate_iscan_work(ctx);
-	*nr_threads = scrub_nproc(ctx);
+	*nr_threads = scrub_nproc(ctx) * 2;
 	*rshift = 0;
 	return 0;
 }
diff --git a/scrub/scrub.c b/scrub/scrub.c
index f2dd9bb9d0b..fe5c8ade5d8 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -422,15 +422,6 @@ scrub_summary_metadata(
 	return scrub_group(ctx, XFROG_SCRUB_GROUP_SUMMARY, 0, alist);
 }
 
-/* Scrub all metadata requiring a full inode scan. */
-int
-scrub_iscan_metadata(
-	struct scrub_ctx		*ctx,
-	struct action_list		*alist)
-{
-	return scrub_group(ctx, XFROG_SCRUB_GROUP_ISCAN, 0, alist);
-}
-
 /* Scrub /only/ the superblock summary counters. */
 int
 scrub_fs_counters(
@@ -449,6 +440,15 @@ scrub_quotacheck(
 	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_QUOTACHECK, 0, alist);
 }
 
+/* Scrub /only/ the file link counters. */
+int
+scrub_nlinks(
+	struct scrub_ctx		*ctx,
+	struct action_list		*alist)
+{
+	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_NLINKS, 0, alist);
+}
+
 /* How many items do we have to check? */
 unsigned int
 scrub_estimate_ag_work(
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 42b91fbc3ed..430ad0fbd83 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -28,6 +28,7 @@ int scrub_iscan_metadata(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_summary_metadata(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_fs_counters(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_quotacheck(struct scrub_ctx *ctx, struct action_list *alist);
+int scrub_nlinks(struct scrub_ctx *ctx, struct action_list *alist);
 
 bool can_scrub_fs_metadata(struct scrub_ctx *ctx);
 bool can_scrub_inode(struct scrub_ctx *ctx);

