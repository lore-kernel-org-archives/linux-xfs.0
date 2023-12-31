Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDD9C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HAXLocEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE490C433C8;
	Sun, 31 Dec 2023 22:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062233;
	bh=2XNTNBIc+Fz9ijRJ5TpwOsJr76EMS9tsKdtj4dJXfrU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HAXLocEunyyvDJEtMfRtdbOZ15foh7R/6xvAIKhJI7s0x4pQIQnM/6FpwXCF6oLbw
	 slXk0YXeLUB9CYxLlMNQnrwBebDgLbMOSFgLLD6wnMgDa1QD098ZkLjp5haOIqSON2
	 W8wkusQ2v52DpYc2E8Mzbbo//gQUnbUN4p+XoAeTZoY0OB1dk/wawRmNPKllzEbdre
	 NuhsT/Uqdf7mmSfNuufTjnRU1k05BwuOaXuP2DtfXyoYQF5uZ1VaWb3NnJv9SyGpxS
	 OagzCRi8MB0PtAGJpdGn2aREJOmh6/gjc9EgK/f43ty+V8OR7yPeUXjxp+syjjFiJA
	 9AuMHvv4WfC4g==
Date: Sun, 31 Dec 2023 14:37:13 -0800
Subject: [PATCH 3/7] xfs_scrub: remove ALP_* flags namespace
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404998686.1797322.5266294710113595532.stgit@frogsfrogsfrogs>
In-Reply-To: <170404998642.1797322.3177048972598846181.stgit@frogsfrogsfrogs>
References: <170404998642.1797322.3177048972598846181.stgit@frogsfrogsfrogs>
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
index 4235c228c0e..9a26b92036c 100644
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
index 8807f147aed..d42e67637d8 100644
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
index b4c635d3452..940e434c3cd 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -422,7 +422,7 @@ fs_scan_worker(
 	}
 
 	ret = action_list_process(ctx, ctx->mnt.fd, &item->alist,
-			ALP_COMPLAIN_IF_UNFIXED | ALP_NOPROGRESS);
+			XRM_FINAL_WARNING | XRM_NOPROGRESS);
 	if (ret) {
 		str_liberror(ctx, ret, _("repairing fs scan metadata"));
 		*item->abortedp = true;
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 93a074f1151..820a68f99a4 100644
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
index 9ade805e1b6..61d62ab6b49 100644
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
index aa3ea13615f..6b6f64691a3 100644
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
index 7cb94af3d15..f4b152a1c9c 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -743,7 +743,7 @@ _("Filesystem is shut down, aborting."));
 		 * could fix this, it's at least worth trying the scan
 		 * again to see if another repair fixed it.
 		 */
-		if (!(repair_flags & XRM_COMPLAIN_IF_UNFIXED))
+		if (!(repair_flags & XRM_FINAL_WARNING))
 			return CHECK_RETRY;
 		fallthrough;
 	case EINVAL:
@@ -773,13 +773,13 @@ _("Read-only filesystem; cannot make changes."));
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
@@ -787,7 +787,7 @@ _("Read-only filesystem; cannot make changes."));
 		 * just requeue this and try again later.  Otherwise we
 		 * log the error loudly and don't try again.
 		 */
-		if (!(repair_flags & XRM_COMPLAIN_IF_UNFIXED))
+		if (!(repair_flags & XRM_FINAL_WARNING))
 			return CHECK_RETRY;
 		str_corrupt(ctx, descr_render(&dsc),
 _("Repair unsuccessful; offline repair required."));
@@ -799,7 +799,7 @@ _("Repair unsuccessful; offline repair required."));
 		 * caller to run xfs_repair; otherwise, we'll keep trying to
 		 * reverify the cross-referencing as repairs progress.
 		 */
-		if (repair_flags & XRM_COMPLAIN_IF_UNFIXED) {
+		if (repair_flags & XRM_FINAL_WARNING) {
 			str_info(ctx, descr_render(&dsc),
  _("Seems correct but cross-referencing failed; offline repair recommended."));
 		} else {
diff --git a/scrub/scrub.h b/scrub/scrub.h
index cb33ddb46f3..5359548b06f 100644
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

