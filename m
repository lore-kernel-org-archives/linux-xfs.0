Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3616C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381907AbiEEQM2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381874AbiEEQME (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:12:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FC95D182
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:08:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5121EB82DF7
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCCEC385AE;
        Thu,  5 May 2022 16:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766896;
        bh=tbyIuWimoRfRKAxmIwVRmh71Ar+Vq82/jaFgitWMsJQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SOQs2CO528DyUbFnvmrz0L+G/ZAehOv/IF5jEPVlQ7nIfUFJu9dxTOjmzgEg+b5iS
         WHE5tAwE1WuA+6x2ZuxEcvmwM/+TtowdUSRGQ3FE+9h1LHnp7sJ2N2eGSB3i3EhGOH
         T9fgZUHrqySAKG2uS62+Nma1MsoS77rldSoFbaeZjUummHZY8xlpPULGqeFd2shAAS
         Kj6SeLF3lfg/Uhj6fnblqVTj02EfSZOOSbHDZXQwp/d/cKy/bE9gWcq+JwF0Nmf5ij
         w2cRK9pC+JuUsF1NCnlGdFQmkaRznnstm+0Y7IwZsNc8PKRhQJZ6spPGqACBFN+r3a
         OcKFsm41gPSSQ==
Subject: [PATCH 6/6] xfs_scrub: in phase 3,
 use the opened file descriptor for repair calls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:08:15 -0700
Message-ID: <165176689554.252160.2539425122472885718.stgit@magnolia>
In-Reply-To: <165176686186.252160.2880340500532409944.stgit@magnolia>
References: <165176686186.252160.2880340500532409944.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While profiling the performance of xfs_scrub, I noticed that phase3 only
employs the scrub-by-handle interface for repairs.  The kernel has had
the ability to skip the untrusted iget lookup if the fd matches the
handle data since the beginning, and using it reduces the repair runtime
by 5% on the author's system.  Normally, we shouldn't be running that
many repairs or optimizations, but we did this for scrub, so we should
do the same for repair.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase3.c |   17 +++++++++++++----
 scrub/phase4.c |    4 ++--
 scrub/phase7.c |    2 +-
 scrub/repair.c |   17 +++++++++++++++--
 scrub/scrub.c  |    4 ++--
 scrub/scrub.h  |    5 +++--
 6 files changed, 36 insertions(+), 13 deletions(-)


diff --git a/scrub/phase3.c b/scrub/phase3.c
index fd8e5419..d659a779 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -52,9 +52,12 @@ report_close_error(
 static int
 try_inode_repair(
 	struct scrub_inode_ctx	*ictx,
+	int			fd,
 	xfs_agnumber_t		agno,
 	struct action_list	*alist)
 {
+	int			ret;
+
 	/*
 	 * If at the start of phase 3 we already had ag/rt metadata repairs
 	 * queued up for phase 4, leave the action list untouched so that file
@@ -63,7 +66,13 @@ try_inode_repair(
 	if (ictx->always_defer_repairs)
 		return 0;
 
-	return action_list_process_or_defer(ictx->ctx, agno, alist);
+	ret = action_list_process(ictx->ctx, fd, alist,
+			ALP_REPAIR_ONLY | ALP_NOPROGRESS);
+	if (ret)
+		return ret;
+
+	action_list_defer(ictx->ctx, agno, alist);
+	return 0;
 }
 
 /* Verify the contents, xattrs, and extent maps of an inode. */
@@ -117,7 +126,7 @@ scrub_inode(
 	if (error)
 		goto out;
 
-	error = try_inode_repair(ictx, agno, &alist);
+	error = try_inode_repair(ictx, fd, agno, &alist);
 	if (error)
 		goto out;
 
@@ -132,7 +141,7 @@ scrub_inode(
 	if (error)
 		goto out;
 
-	error = try_inode_repair(ictx, agno, &alist);
+	error = try_inode_repair(ictx, fd, agno, &alist);
 	if (error)
 		goto out;
 
@@ -158,7 +167,7 @@ scrub_inode(
 		goto out;
 
 	/* Try to repair the file while it's open. */
-	error = try_inode_repair(ictx, agno, &alist);
+	error = try_inode_repair(ictx, fd, agno, &alist);
 	if (error)
 		goto out;
 
diff --git a/scrub/phase4.c b/scrub/phase4.c
index ad26d9d5..559b2779 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -40,7 +40,7 @@ repair_ag(
 
 	/* Repair anything broken until we fail to make progress. */
 	do {
-		ret = action_list_process(ctx, ctx->mnt.fd, alist, flags);
+		ret = action_list_process(ctx, -1, alist, flags);
 		if (ret) {
 			*aborted = true;
 			return;
@@ -55,7 +55,7 @@ repair_ag(
 
 	/* Try once more, but this time complain if we can't fix things. */
 	flags |= ALP_COMPLAIN_IF_UNFIXED;
-	ret = action_list_process(ctx, ctx->mnt.fd, alist, flags);
+	ret = action_list_process(ctx, -1, alist, flags);
 	if (ret)
 		*aborted = true;
 }
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 84546b1c..8d8034c3 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -121,7 +121,7 @@ phase7_func(
 	error = scrub_fs_summary(ctx, &alist);
 	if (error)
 		return error;
-	error = action_list_process(ctx, ctx->mnt.fd, &alist,
+	error = action_list_process(ctx, -1, &alist,
 			ALP_COMPLAIN_IF_UNFIXED | ALP_NOPROGRESS);
 	if (error)
 		return error;
diff --git a/scrub/repair.c b/scrub/repair.c
index 1ef6372e..bb026101 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -230,17 +230,30 @@ action_list_process(
 	struct action_list		*alist,
 	unsigned int			repair_flags)
 {
+	struct xfs_fd			xfd;
+	struct xfs_fd			*xfdp = &ctx->mnt;
 	struct action_item		*aitem;
 	struct action_item		*n;
 	enum check_outcome		fix;
 
+	/*
+	 * If the caller passed us a file descriptor for a scrub, use it
+	 * instead of scrub-by-handle because this enables the kernel to skip
+	 * costly inode btree lookups.
+	 */
+	if (fd >= 0) {
+		memcpy(&xfd, xfdp, sizeof(xfd));
+		xfd.fd = fd;
+		xfdp = &xfd;
+	}
+
 	if (!alist->sorted) {
 		list_sort(NULL, &alist->list, xfs_action_item_compare);
 		alist->sorted = true;
 	}
 
 	list_for_each_entry_safe(aitem, n, &alist->list, list) {
-		fix = xfs_repair_metadata(ctx, fd, aitem, repair_flags);
+		fix = xfs_repair_metadata(ctx, xfdp, aitem, repair_flags);
 		switch (fix) {
 		case CHECK_DONE:
 			if (!(repair_flags & ALP_NOPROGRESS))
@@ -284,7 +297,7 @@ action_list_process_or_defer(
 {
 	int				ret;
 
-	ret = action_list_process(ctx, ctx->mnt.fd, alist,
+	ret = action_list_process(ctx, -1, alist,
 			ALP_REPAIR_ONLY | ALP_NOPROGRESS);
 	if (ret)
 		return ret;
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 19a0b2d0..e83d0d9c 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -611,7 +611,7 @@ xfs_can_repair(
 enum check_outcome
 xfs_repair_metadata(
 	struct scrub_ctx		*ctx,
-	int				fd,
+	struct xfs_fd			*xfdp,
 	struct action_item		*aitem,
 	unsigned int			repair_flags)
 {
@@ -649,7 +649,7 @@ xfs_repair_metadata(
 		str_info(ctx, descr_render(&dsc),
 				_("Attempting optimization."));
 
-	error = -xfrog_scrub_metadata(&ctx->mnt, &meta);
+	error = -xfrog_scrub_metadata(xfdp, &meta);
 	switch (error) {
 	case 0:
 		/* No operational errors encountered. */
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 325d8f95..fccd82f2 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -57,7 +57,8 @@ struct action_item {
 /* Complain if still broken even after fix. */
 #define XRM_COMPLAIN_IF_UNFIXED	(1U << 1)
 
-enum check_outcome xfs_repair_metadata(struct scrub_ctx *ctx, int fd,
-		struct action_item *aitem, unsigned int repair_flags);
+enum check_outcome xfs_repair_metadata(struct scrub_ctx *ctx,
+		struct xfs_fd *xfdp, struct action_item *aitem,
+		unsigned int repair_flags);
 
 #endif /* XFS_SCRUB_SCRUB_H_ */

