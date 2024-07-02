Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C644A06
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882063; cv=none; b=pGS+IpOLl3n4xLwWjTmbvly+KI/NymQlOvaK4HtJ2ui55sX24HLU8ywhp+smIcvR07y6JVF47yuow4X3M8tJx+bcobhsMNRo/t+xB0SjkJGQ5OC78Tg9ZsNECjqLhyPNXXsefEJsUTNuX+OtF+pMe/HxNFIJ3QoYTix8YLEVF/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882063; c=relaxed/simple;
	bh=nvwtKB4gUF1veTOF9c47AD1dCudnk1PZGRTjwfc7C94=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Du7MvCKsGvg0MzAIOzOj29RbFOR59cxCb3Elp7Y5ElRVBkJWhLjlnrro3LpciLYLrn3hZR+stqsWew6P+WvMCFRNbozQOnTV0dCSaFWfziGUzvya0Dw6l2CBptwb+YkUz/AQKGDTH+3UO64Y0w1cyg+kXkOexea/NyhJj/HQyRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dO2Thm24; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dO2Thm24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEF0C116B1;
	Tue,  2 Jul 2024 01:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882063;
	bh=nvwtKB4gUF1veTOF9c47AD1dCudnk1PZGRTjwfc7C94=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dO2Thm24w7AhA65lhRKMRtrU/rBXqlngGK3S6azYSodrehxLI/j5NBkFfa3nDJCVG
	 napSPfZDrWW6Wg7TYAOZ2pCYXLt8KtQ2UXV+SZn4ccsYWPWRbvF6ot3FSrLyAcf2Ab
	 qUE22leikcpbSUEOoq6R24BVEDQCwFLnQF8okdjTB0Oh4zzFgLWVkaappfNFkhTdAm
	 8DBM+5NYPCNhm3rzqyfTh6iU4h930qgvJTBrM7Nbl6TBSfq3U9EsuXqHxevioVizqe
	 2qqz1UyeEmERtd6HEcIIrcJWGNaSJksXBsmUDqp4tOWbrRygLdUWDJtxPJWv+7WLsZ
	 0qQdrx8fuvb3g==
Date: Mon, 01 Jul 2024 18:01:02 -0700
Subject: [PATCH 1/8] xfs_scrub: move FITRIM to phase 8
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988118144.2007602.9357076180672124914.stgit@frogsfrogsfrogs>
In-Reply-To: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs>
References: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs>
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
index c11c2b5fe84e..8ccc67d01df3 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -68,6 +68,7 @@ phase4.c \
 phase5.c \
 phase6.c \
 phase7.c \
+phase8.c \
 progress.c \
 read_verify.c \
 repair.c \
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 9080d38818f7..451101811c9b 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -227,16 +227,6 @@ repair_everything(
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
@@ -248,7 +238,7 @@ phase4_func(
 
 	if (action_list_empty(ctx->fs_repair_list) &&
 	    action_list_empty(ctx->file_repair_list))
-		goto maybe_trim;
+		return 0;
 
 	/*
 	 * Check the resource usage counters early.  Normally we do this during
@@ -281,20 +271,7 @@ phase4_func(
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
@@ -307,10 +284,9 @@ phase4_estimate(
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
index 000000000000..07726b5b8691
--- /dev/null
+++ b/scrub/phase8.c
@@ -0,0 +1,66 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
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
index ed86d0093db3..6272a36879e7 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -98,6 +98,7 @@ int phase4_func(struct scrub_ctx *ctx);
 int phase5_func(struct scrub_ctx *ctx);
 int phase6_func(struct scrub_ctx *ctx);
 int phase7_func(struct scrub_ctx *ctx);
+int phase8_func(struct scrub_ctx *ctx);
 
 /* Progress estimator functions */
 unsigned int scrub_estimate_ag_work(struct scrub_ctx *ctx);
@@ -112,5 +113,7 @@ int phase5_estimate(struct scrub_ctx *ctx, uint64_t *items,
 		    unsigned int *nr_threads, int *rshift);
 int phase6_estimate(struct scrub_ctx *ctx, uint64_t *items,
 		    unsigned int *nr_threads, int *rshift);
+int phase8_estimate(struct scrub_ctx *ctx, uint64_t *items,
+		    unsigned int *nr_threads, int *rshift);
 
 #endif /* XFS_SCRUB_XFS_SCRUB_H_ */

