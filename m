Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E32EC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:24:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235792AbiLaAYo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235752AbiLaAYn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:24:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97022D104
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:24:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 370E561D2A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BEAC433EF;
        Sat, 31 Dec 2022 00:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446280;
        bh=OBFo+4moZcbgPzjlCk5MG/Z7uobT7Sg3Gyc57aVBF94=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uMo/6hE4qTjCBzq+wuSDrr3xIwt3TtBSegsSYZb7pCqCrj6P3oWNOjOCfrdO6nCX1
         fjHciyqdI+z295vPjqSiqq3872SsFzL77hHpO2esi+e4WOyrazYs8bmXGPM3OOadyQ
         y8+5NAYHIHgRDyRmvbRjY50caE+dayAF3Vp2NkQZiF/hM0ngbFXg874eux/gavEqBX
         nGEwsCmkfb33muSdbmLn6IHHNR4h7aJqny7H7P0UcRiEZLfDXS38ocsyAF+4dMzud9
         oHB6JVge5NttHVya7/oWwTi8B9jGhjQHiYpYCX+X6RRJ+Qt2DLHzaiGcdC5lxVxZtn
         M4HO/klbeFvHQ==
Subject: [PATCH 2/6] xfs_scrub: remove ALP_* flags namespace
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:10 -0800
Message-ID: <167243869050.714771.1824669891844239603.stgit@magnolia>
In-Reply-To: <167243869023.714771.3955258526251265287.stgit@magnolia>
References: <167243869023.714771.3955258526251265287.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In preparation to move all the repair code to repair.[ch], remove the
ALP_* flags namespace since it mostly overlaps with XRM_*.  Rename the
clunky "COMPLAIN_IF_UNFIXED" flag to "FINAL_WARNING", because that's
what it really means.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase3.c |    2 +-
 scrub/phase4.c |    2 +-
 scrub/phase5.c |    2 +-
 scrub/phase7.c |    2 +-
 scrub/repair.c |    4 ++--
 scrub/repair.h |   16 ++++++++++++----
 scrub/scrub.c  |   10 +++++-----
 scrub/scrub.h  |   10 ----------
 8 files changed, 23 insertions(+), 25 deletions(-)


diff --git a/scrub/phase3.c b/scrub/phase3.c
index 65e903f23d2..ef41ee8049d 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -88,7 +88,7 @@ try_inode_repair(
 		return 0;
 
 	ret = action_list_process(ictx->ctx, fd, alist,
-			ALP_REPAIR_ONLY | ALP_NOPROGRESS);
+			XRM_REPAIR_ONLY | XRM_NOPROGRESS);
 	if (ret)
 		return ret;
 
diff --git a/scrub/phase4.c b/scrub/phase4.c
index da9e8759134..c71b56b7bda 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -54,7 +54,7 @@ repair_ag(
 	} while (unfixed > 0);
 
 	/* Try once more, but this time complain if we can't fix things. */
-	flags |= ALP_COMPLAIN_IF_UNFIXED;
+	flags |= XRM_FINAL_WARNING;
 	ret = action_list_process(ctx, -1, alist, flags);
 	if (ret)
 		*aborted = true;
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 622e58138db..93dd14d50ba 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -421,7 +421,7 @@ iscan_worker(
 	}
 
 	ret = action_list_process(ctx, ctx->mnt.fd, &item->alist,
-			ALP_COMPLAIN_IF_UNFIXED | ALP_NOPROGRESS);
+			XRM_FINAL_WARNING | XRM_NOPROGRESS);
 	if (ret) {
 		str_liberror(ctx, ret, _("repairing iscan metadata"));
 		*item->abortedp = true;
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 2b83e0a471d..e9cb40f48d8 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -122,7 +122,7 @@ phase7_func(
 	if (error)
 		return error;
 	error = action_list_process(ctx, -1, &alist,
-			ALP_COMPLAIN_IF_UNFIXED | ALP_NOPROGRESS);
+			XRM_FINAL_WARNING | XRM_NOPROGRESS);
 	if (error)
 		return error;
 
diff --git a/scrub/repair.c b/scrub/repair.c
index bb0faceca69..54016337896 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -274,7 +274,7 @@ action_list_process(
 		fix = xfs_repair_metadata(ctx, xfdp, aitem, repair_flags);
 		switch (fix) {
 		case CHECK_DONE:
-			if (!(repair_flags & ALP_NOPROGRESS))
+			if (!(repair_flags & XRM_NOPROGRESS))
 				progress_add(1);
 			alist->nr--;
 			list_del(&aitem->list);
@@ -316,7 +316,7 @@ action_list_process_or_defer(
 	int				ret;
 
 	ret = action_list_process(ctx, -1, alist,
-			ALP_REPAIR_ONLY | ALP_NOPROGRESS);
+			XRM_REPAIR_ONLY | XRM_NOPROGRESS);
 	if (ret)
 		return ret;
 
diff --git a/scrub/repair.h b/scrub/repair.h
index d7a3a9e7cff..969871bd8bf 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -32,10 +32,18 @@ void action_list_find_mustfix(struct action_list *actions,
 		unsigned long long *broken_primaries,
 		unsigned long long *broken_secondaries);
 
-/* Passed through to xfs_repair_metadata() */
-#define ALP_REPAIR_ONLY		(XRM_REPAIR_ONLY)
-#define ALP_COMPLAIN_IF_UNFIXED	(XRM_COMPLAIN_IF_UNFIXED)
-#define ALP_NOPROGRESS		(1U << 31)
+/*
+ * Only ask the kernel to repair this object if the kernel directly told us it
+ * was corrupt.  Objects that are only flagged as having cross-referencing
+ * errors or flagged as eligible for optimization are left for later.
+ */
+#define XRM_REPAIR_ONLY		(1U << 0)
+
+/* This is the last repair attempt; complain if still broken even after fix. */
+#define XRM_FINAL_WARNING	(1U << 1)
+
+/* Don't call progress_add after repairing an item. */
+#define XRM_NOPROGRESS		(1U << 2)
 
 int action_list_process(struct scrub_ctx *ctx, int fd,
 		struct action_list *alist, unsigned int repair_flags);
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 975dd8efbbc..7b9c360f796 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -734,7 +734,7 @@ _("Filesystem is shut down, aborting."));
 		 * could fix this, it's at least worth trying the scan
 		 * again to see if another repair fixed it.
 		 */
-		if (!(repair_flags & XRM_COMPLAIN_IF_UNFIXED))
+		if (!(repair_flags & XRM_FINAL_WARNING))
 			return CHECK_RETRY;
 		/*
 		 * If we forced repairs or this is a preen, don't
@@ -771,13 +771,13 @@ _("Read-only filesystem; cannot make changes."));
 		 * to requeue the repair for later and don't say a
 		 * thing.  Otherwise, print error and bail out.
 		 */
-		if (!(repair_flags & XRM_COMPLAIN_IF_UNFIXED))
+		if (!(repair_flags & XRM_FINAL_WARNING))
 			return CHECK_RETRY;
 		str_liberror(ctx, error, descr_render(&dsc));
 		return CHECK_DONE;
 	}
 
-	if (repair_flags & XRM_COMPLAIN_IF_UNFIXED)
+	if (repair_flags & XRM_FINAL_WARNING)
 		scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
 	if (needs_repair(&meta)) {
 		/*
@@ -785,7 +785,7 @@ _("Read-only filesystem; cannot make changes."));
 		 * just requeue this and try again later.  Otherwise we
 		 * log the error loudly and don't try again.
 		 */
-		if (!(repair_flags & XRM_COMPLAIN_IF_UNFIXED))
+		if (!(repair_flags & XRM_FINAL_WARNING))
 			return CHECK_RETRY;
 		str_corrupt(ctx, descr_render(&dsc),
 _("Repair unsuccessful; offline repair required."));
@@ -797,7 +797,7 @@ _("Repair unsuccessful; offline repair required."));
 		 * caller to run xfs_repair; otherwise, we'll keep trying to
 		 * reverify the cross-referencing as repairs progress.
 		 */
-		if (repair_flags & XRM_COMPLAIN_IF_UNFIXED) {
+		if (repair_flags & XRM_FINAL_WARNING) {
 			str_info(ctx, descr_render(&dsc),
  _("Seems correct but cross-referencing failed; offline repair recommended."));
 		} else {
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 0622677376c..751f2c8e9c1 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -54,16 +54,6 @@ struct action_item {
 	__u32			agno;
 };
 
-/*
- * Only ask the kernel to repair this object if the kernel directly told us it
- * was corrupt.  Objects that are only flagged as having cross-referencing
- * errors or flagged as eligible for optimization are left for later.
- */
-#define XRM_REPAIR_ONLY		(1U << 0)
-
-/* Complain if still broken even after fix. */
-#define XRM_COMPLAIN_IF_UNFIXED	(1U << 1)
-
 enum check_outcome xfs_repair_metadata(struct scrub_ctx *ctx,
 		struct xfs_fd *xfdp, struct action_item *aitem,
 		unsigned int repair_flags);

