Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D41C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235660AbiLaAcO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235655AbiLaAcN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:32:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897FA13F7A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:32:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24CEC61D4B
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A12C433D2;
        Sat, 31 Dec 2022 00:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446731;
        bh=xQ46veMHiEjpu4IRA3sAKi6BlyeYGruh9A6WvcNPeik=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=q0O3oDNPYNdcPVwNf4AlXjxXDXdmpxv7f41HZDUK/JmgVs56NcH1HqotMwuQ4Gbx8
         XN23WsD+yYPYULnvF65eknKxUeNrb+2EFfwI7uHBHv7//wzp6HgIBc6TgjPYpBl3rq
         Wdsrgpw7fgavUismQxtGCdrWEcGh441RZH47QacA7xhqLS687v98KqRuFO6fSCXmfh
         vCw1oKssxlV3x/BBsT0k99G7b05GRApZGprMt/vEwFtF+iRTuPMIiu8vYgpU7JMrYA
         qcqMi+RSUHZbf8JBJLdYtbMhOdoZfTtlRQ5XkOgI35o0TKjHdYG3j1DS3grZgQ2fdV
         5TcHi0lWjbKNw==
Subject: [PATCH 1/7] xfs_scrub: move FITRIM to phase 8
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:27 -0800
Message-ID: <167243870763.716924.5100780745737024494.stgit@magnolia>
In-Reply-To: <167243870748.716924.8460607901853339412.stgit@magnolia>
References: <167243870748.716924.8460607901853339412.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Issuing discards against the filesystem should be the *last* thing that
xfs_scrub does, after everything else has been checked, repaired, and
found to be clean.  If we can't satisfy all those conditions, we have no
business telling the storage to discard itself.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/Makefile    |    1 +
 scrub/phase4.c    |   30 ++----------------------
 scrub/phase8.c    |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/xfs_scrub.h |    3 ++
 4 files changed, 73 insertions(+), 27 deletions(-)
 create mode 100644 scrub/phase8.c


diff --git a/scrub/Makefile b/scrub/Makefile
index aba14ed2310..2dc0fe1935c 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -60,6 +60,7 @@ phase4.c \
 phase5.c \
 phase6.c \
 phase7.c \
+phase8.c \
 progress.c \
 read_verify.c \
 repair.c \
diff --git a/scrub/phase4.c b/scrub/phase4.c
index aa9aaea1826..260f7bb7ac1 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -223,16 +223,6 @@ repair_everything(
 	return action_list_process(ctx, ctx->fs_repair_list, XRM_FINAL_WARNING);
 }
 
-/* Trim the unused areas of the filesystem if the caller asked us to. */
-static void
-trim_filesystem(
-	struct scrub_ctx	*ctx)
-{
-	if (want_fstrim)
-		fstrim(ctx);
-	progress_add(1);
-}
-
 /* Fix everything that needs fixing. */
 int
 phase4_func(
@@ -244,7 +234,7 @@ phase4_func(
 
 	if (action_list_empty(ctx->fs_repair_list) &&
 	    action_list_empty(ctx->file_repair_list))
-		goto maybe_trim;
+		return 0;
 
 	/*
 	 * Check the resource usage counters early.  Normally we do this during
@@ -277,20 +267,7 @@ phase4_func(
 	if (ret)
 		return ret;
 
-	ret = repair_everything(ctx);
-	if (ret)
-		return ret;
-
-	/*
-	 * If errors remain on the filesystem, do not trim anything.  We don't
-	 * have any threads running, so it's ok to skip the ctx lock here.
-	 */
-	if (ctx->corruptions_found || ctx->unfixable_errors != 0)
-		return 0;
-
-maybe_trim:
-	trim_filesystem(ctx);
-	return 0;
+	return repair_everything(ctx);
 }
 
 /* Estimate how much work we're going to do. */
@@ -303,10 +280,9 @@ phase4_estimate(
 {
 	unsigned long long	need_fixing;
 
-	/* Everything on the repair list plus FSTRIM. */
+	/* Everything on the repair lis. */
 	need_fixing = action_list_length(ctx->fs_repair_list) +
 		      action_list_length(ctx->file_repair_list);
-	need_fixing++;
 
 	*items = need_fixing;
 	*nr_threads = scrub_nproc(ctx) + 1;
diff --git a/scrub/phase8.c b/scrub/phase8.c
new file mode 100644
index 00000000000..e2d712990ab
--- /dev/null
+++ b/scrub/phase8.c
@@ -0,0 +1,66 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
+#include <stdint.h>
+#include <dirent.h>
+#include <sys/types.h>
+#include <sys/statvfs.h>
+#include "list.h"
+#include "libfrog/paths.h"
+#include "libfrog/workqueue.h"
+#include "xfs_scrub.h"
+#include "common.h"
+#include "progress.h"
+#include "scrub.h"
+#include "repair.h"
+#include "vfs.h"
+#include "atomic.h"
+
+/* Phase 8: Trim filesystem. */
+
+/* Trim the unused areas of the filesystem if the caller asked us to. */
+static void
+trim_filesystem(
+	struct scrub_ctx	*ctx)
+{
+	fstrim(ctx);
+	progress_add(1);
+}
+
+/* Trim the filesystem, if desired. */
+int
+phase8_func(
+	struct scrub_ctx	*ctx)
+{
+	if (action_list_empty(ctx->fs_repair_list) &&
+	    action_list_empty(ctx->file_repair_list))
+		goto maybe_trim;
+
+	/*
+	 * If errors remain on the filesystem, do not trim anything.  We don't
+	 * have any threads running, so it's ok to skip the ctx lock here.
+	 */
+	if (ctx->corruptions_found || ctx->unfixable_errors != 0)
+		return 0;
+
+maybe_trim:
+	trim_filesystem(ctx);
+	return 0;
+}
+
+/* Estimate how much work we're going to do. */
+int
+phase8_estimate(
+	struct scrub_ctx	*ctx,
+	uint64_t		*items,
+	unsigned int		*nr_threads,
+	int			*rshift)
+{
+	*items = 1;
+	*nr_threads = 1;
+	*rshift = 0;
+	return 0;
+}
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 8d6ee9826cb..004d2d02587 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -97,6 +97,7 @@ int phase4_func(struct scrub_ctx *ctx);
 int phase5_func(struct scrub_ctx *ctx);
 int phase6_func(struct scrub_ctx *ctx);
 int phase7_func(struct scrub_ctx *ctx);
+int phase8_func(struct scrub_ctx *ctx);
 
 /* Progress estimator functions */
 unsigned int scrub_estimate_ag_work(struct scrub_ctx *ctx);
@@ -111,5 +112,7 @@ int phase5_estimate(struct scrub_ctx *ctx, uint64_t *items,
 		    unsigned int *nr_threads, int *rshift);
 int phase6_estimate(struct scrub_ctx *ctx, uint64_t *items,
 		    unsigned int *nr_threads, int *rshift);
+int phase8_estimate(struct scrub_ctx *ctx, uint64_t *items,
+		    unsigned int *nr_threads, int *rshift);
 
 #endif /* XFS_SCRUB_XFS_SCRUB_H_ */

