Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA7D2C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235852AbiLaAIG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235621AbiLaAIF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:08:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3D31CB3E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:08:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D32F61CD0
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA422C433EF;
        Sat, 31 Dec 2022 00:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445283;
        bh=bMo6QwWRqO6mUOgNBjYztAPuiZS4T9xZhMECygc9mlM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=J3A3VQXt04vwTxGqOGfFJlLv6uZIWzREuVPwPl9hdS1yEXE9ofKDv7sPu4YMjMEfM
         RdjIwRUz2Jw5LEYsdAvyyeHBynQNzNVSeiZcDA4LSiMEHt8rz/Gd7c3B/FNZkSPg7F
         lk1dVJNyh68Ru0ZhpL6E4V+/hbJoGsleqe4V3ySnJg5ffuy1ToWA92EJr1sWSsdsMi
         /BpyS4wqgdPgRHR825P4OJgNnn50axooNJ8cpfJXiznaN7KVN0dfaGgfe+4GFLdWjQ
         CEUQf94teXrbz9wNyWEGkFxr1y87b0TxpJqtsVmJZ3sqTD6m5MzKLmsfwcplwHUWZ5
         frIBQWrJ050jQ==
Subject: [PATCH 4/4] xfs_scrub: scan metadata files in parallel
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:26 -0800
Message-ID: <167243864608.708428.2050110389681530091.stgit@magnolia>
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

The realtime bitmap and the three quota files are completely independent
of each other, which means that we ought to be able to scan them in
parallel.  Rework the phase2 code so that we can do this.  Note,
however, that the realtime summary file summarizes the contents of the
realtime bitmap, so we must coordinate the workqueue threads.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase2.c |  146 +++++++++++++++++++++++++++++++++++++++++++-------------
 scrub/scrub.c  |    9 ++-
 scrub/scrub.h  |    3 +
 3 files changed, 121 insertions(+), 37 deletions(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index 8f82e2a6c04..75c302af075 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -10,6 +10,8 @@
 #include "list.h"
 #include "libfrog/paths.h"
 #include "libfrog/workqueue.h"
+#include "libfrog/fsgeom.h"
+#include "libfrog/scrub.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "scrub.h"
@@ -17,6 +19,18 @@
 
 /* Phase 2: Check internal metadata. */
 
+struct scan_ctl {
+	/*
+	 * Control mechanism to signal that the rt bitmap file scan is done and
+	 * wake up any waiters.
+	 */
+	pthread_cond_t		rbm_wait;
+	pthread_mutex_t		rbm_waitlock;
+	bool			rbm_done;
+
+	bool			aborted;
+};
+
 /* Scrub each AG's metadata btrees. */
 static void
 scan_ag_metadata(
@@ -25,7 +39,7 @@ scan_ag_metadata(
 	void				*arg)
 {
 	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->wq_ctx;
-	bool				*aborted = arg;
+	struct scan_ctl			*sctl = arg;
 	struct action_list		alist;
 	struct action_list		immediate_alist;
 	unsigned long long		broken_primaries;
@@ -33,7 +47,7 @@ scan_ag_metadata(
 	char				descr[DESCR_BUFSZ];
 	int				ret;
 
-	if (*aborted)
+	if (sctl->aborted)
 		return;
 
 	action_list_init(&alist);
@@ -89,32 +103,40 @@ _("Filesystem might not be repairable."));
 	action_list_defer(ctx, agno, &alist);
 	return;
 err:
-	*aborted = true;
+	sctl->aborted = true;
 }
 
-/* Scrub whole-FS metadata btrees. */
+/* Scan one metadata file. */
 static void
-scan_fs_metadata(
-	struct workqueue		*wq,
-	xfs_agnumber_t			agno,
-	void				*arg)
+scan_metafile(
+	struct workqueue	*wq,
+	xfs_agnumber_t		type,
+	void			*arg)
 {
-	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->wq_ctx;
-	bool				*aborted = arg;
-	struct action_list		alist;
-	int				ret;
+	struct action_list	alist;
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
+	struct scan_ctl		*sctl = arg;
+	int			ret;
 
-	if (*aborted)
-		return;
+	if (sctl->aborted)
+		goto out;
 
 	action_list_init(&alist);
-	ret = scrub_fs_metadata(ctx, &alist);
+	ret = scrub_metadata_file(ctx, type, &alist);
 	if (ret) {
-		*aborted = true;
-		return;
+		sctl->aborted = true;
+		goto out;
 	}
 
-	action_list_defer(ctx, agno, &alist);
+	action_list_defer(ctx, 0, &alist);
+
+out:
+	if (type == XFS_SCRUB_TYPE_RTBITMAP) {
+		pthread_mutex_lock(&sctl->rbm_waitlock);
+		sctl->rbm_done = true;
+		pthread_cond_broadcast(&sctl->rbm_wait);
+		pthread_mutex_unlock(&sctl->rbm_waitlock);
+	}
 }
 
 /* Scan all filesystem metadata. */
@@ -122,17 +144,25 @@ int
 phase2_func(
 	struct scrub_ctx	*ctx)
 {
-	struct action_list	alist;
 	struct workqueue	wq;
+	struct scan_ctl		sctl = {
+		.aborted	= false,
+		.rbm_done	= false,
+	};
+	struct action_list	alist;
+	const struct xfrog_scrub_descr *sc = xfrog_scrubbers;
 	xfs_agnumber_t		agno;
-	bool			aborted = false;
+	unsigned int		type;
 	int			ret, ret2;
 
+	pthread_mutex_init(&sctl.rbm_waitlock, NULL);
+	pthread_cond_init(&sctl.rbm_wait, NULL);
+
 	ret = -workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
 	if (ret) {
 		str_liberror(ctx, ret, _("creating scrub workqueue"));
-		return ret;
+		goto out_wait;
 	}
 
 	/*
@@ -143,29 +173,76 @@ phase2_func(
 	action_list_init(&alist);
 	ret = scrub_primary_super(ctx, &alist);
 	if (ret)
-		goto out;
+		goto out_wq;
 	ret = action_list_process_or_defer(ctx, 0, &alist);
 	if (ret)
-		goto out;
+		goto out_wq;
 
-	for (agno = 0; !aborted && agno < ctx->mnt.fsgeom.agcount; agno++) {
-		ret = -workqueue_add(&wq, scan_ag_metadata, agno, &aborted);
+	/* Scan each AG in parallel. */
+	for (agno = 0;
+	     agno < ctx->mnt.fsgeom.agcount && !sctl.aborted;
+	     agno++) {
+		ret = -workqueue_add(&wq, scan_ag_metadata, agno, &sctl);
 		if (ret) {
 			str_liberror(ctx, ret, _("queueing per-AG scrub work"));
-			goto out;
+			goto out_wq;
 		}
 	}
 
-	if (aborted)
-		goto out;
+	if (sctl.aborted)
+		goto out_wq;
 
-	ret = -workqueue_add(&wq, scan_fs_metadata, 0, &aborted);
+	/*
+	 * Scan all the metadata files in parallel except for the realtime
+	 * summary file, which must run after the realtime bitmap has been
+	 * scanned.
+	 */
+	for (type = 0; type < XFS_SCRUB_TYPE_NR; type++, sc++) {
+		if (sc->group != XFROG_SCRUB_GROUP_METAFILES)
+			continue;
+		if (type == XFS_SCRUB_TYPE_RTSUM)
+			continue;
+
+		ret = -workqueue_add(&wq, scan_metafile, type, &sctl);
+		if (ret) {
+			str_liberror(ctx, ret,
+	_("queueing metadata file scrub work"));
+			goto out_wq;
+		}
+	}
+
+	if (sctl.aborted)
+		goto out_wq;
+
+	/*
+	 * Wait for the rt bitmap to finish scanning, then scan the rt summary
+	 * since the summary can be regenerated completely from the bitmap.
+	 */
+	ret = pthread_mutex_lock(&sctl.rbm_waitlock);
+	if (ret) {
+		str_liberror(ctx, ret, _("waiting for rtbitmap scrubber"));
+		goto out_wq;
+	}
+	if (!sctl.rbm_done) {
+		ret = pthread_cond_wait(&sctl.rbm_wait, &sctl.rbm_waitlock);
+		if (ret) {
+			str_liberror(ctx, ret,
+	_("waiting for rtbitmap scrubber"));
+			goto out_wq;
+		}
+	}
+	pthread_mutex_unlock(&sctl.rbm_waitlock);
+
+	if (sctl.aborted)
+		goto out_wq;
+
+	ret = -workqueue_add(&wq, scan_metafile, XFS_SCRUB_TYPE_RTSUM, &sctl);
 	if (ret) {
-		str_liberror(ctx, ret, _("queueing per-FS scrub work"));
-		goto out;
+		str_liberror(ctx, ret, _("queueing rtsummary scrub work"));
+		goto out_wq;
 	}
 
-out:
+out_wq:
 	ret2 = -workqueue_terminate(&wq);
 	if (ret2) {
 		str_liberror(ctx, ret2, _("finishing scrub work"));
@@ -173,8 +250,11 @@ phase2_func(
 			ret = ret2;
 	}
 	workqueue_destroy(&wq);
+out_wait:
+	pthread_cond_destroy(&sctl.rbm_wait);
+	pthread_mutex_destroy(&sctl.rbm_waitlock);
 
-	if (!ret && aborted)
+	if (!ret && sctl.aborted)
 		ret = ECANCELED;
 	return ret;
 }
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 1fcd5b8e85d..20067df523f 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -400,13 +400,16 @@ scrub_ag_metadata(
 	return scrub_group(ctx, XFROG_SCRUB_GROUP_PERAG, agno, alist);
 }
 
-/* Scrub whole-FS metadata btrees. */
+/* Scrub one metadata file */
 int
-scrub_fs_metadata(
+scrub_metadata_file(
 	struct scrub_ctx		*ctx,
+	unsigned int			type,
 	struct action_list		*alist)
 {
-	return scrub_group(ctx, XFROG_SCRUB_GROUP_METAFILES, 0, alist);
+	ASSERT(xfrog_scrubbers[type].group == XFROG_SCRUB_GROUP_METAFILES);
+
+	return scrub_meta_type(ctx, type, 0, alist);
 }
 
 /* Scrub all FS summary metadata. */
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 56836cf2ba3..a4e36808f34 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -22,7 +22,8 @@ int scrub_ag_headers(struct scrub_ctx *ctx, xfs_agnumber_t agno,
 		struct action_list *alist);
 int scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
 		struct action_list *alist);
-int scrub_fs_metadata(struct scrub_ctx *ctx, struct action_list *alist);
+int scrub_metadata_file(struct scrub_ctx *ctx, unsigned int scrub_type,
+		struct action_list *alist);
 int scrub_summary_metadata(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_fs_counters(struct scrub_ctx *ctx, struct action_list *alist);
 

