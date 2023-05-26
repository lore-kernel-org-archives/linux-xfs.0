Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D36E4C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:48:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbjEZBsg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjEZBsf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:48:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804C6189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:48:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1259060B6C
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A82AC433EF;
        Fri, 26 May 2023 01:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065713;
        bh=guE29lCGy3oNNUyTL0MEL5OsrT1AyVc9CkE2WQ80my0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Ze5gvoXhM4bqMmpHAKk0LhK3DcAKiEuFIPJqELQJpBnTER9KW0dgTS0DBQMpsBs01
         HimiPBW2wLUZrTF/96BVw8ywEE9ggJgEwZTDaTFC6sN4duWuOeeAhV4et4A4aae+d1
         rn9BUP3IkJzvhGaGU9qLSQzzr9cugWRrRhyxFEFM0BSFdNf7LndXxCeMwuWxx31C+C
         wZfa7va3VKpmbhFLUAezuSldTs/d+PuWxKtNmIKU+DjwVzxUv34cqIvi705j0UfFAk
         tLO3qDupIlGFU+7j0r/3bvDmLseGKLKU8dgDhRl7GFgwVjte01Na1IlBEp6liH1+6y
         CVC6eWMJMFYZQ==
Date:   Thu, 25 May 2023 18:48:33 -0700
Subject: [PATCH 4/4] xfs_scrub: try to repair space metadata before file
 metadata
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506072806.3744428.17596786190019798618.stgit@frogsfrogsfrogs>
In-Reply-To: <168506072752.3744428.6237393655315422413.stgit@frogsfrogsfrogs>
References: <168506072752.3744428.6237393655315422413.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Phase 4 (metadata repairs) of xfs_scrub has suffered a mild race
condition since the beginning of its existence.  Repair functions for
higher level metadata such as directories build the new directory blocks
in an unlinked temporary file and use atomic extent swapping to commit
the corrected directory contents into the existing directory.  Atomic
extent swapping requires consistent filesystem space metadata, but phase
4 has never enforced correctness dependencies between space and file
metadata repairs.

Before the previous patch eliminated the per-AG repair lists, this error
was not often hit in testing scenarios because the allocator generally
succeeds in placing file data blocks in the same AG as the inode.  With
pool threads now able to pop file repairs from the repair list before
space repairs complete, this error became much more obvious.

Fortunately, the new phase 4 design makes it easy to try to enforce the
consistency requirements of higher level file metadata repairs.  Split
the repair list into one for space metadata and another for file
metadata.  Phase 4 will now try to fix the space metadata until it stops
making progress on that, and only then will it try to fix file metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase1.c    |   13 ++++++++++---
 scrub/phase2.c    |    2 +-
 scrub/phase3.c    |    4 ++--
 scrub/phase4.c    |   22 +++++++++++++++++-----
 scrub/xfs_scrub.h |    3 ++-
 5 files changed, 32 insertions(+), 12 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 97b4386096e..99c7a7a5d28 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -89,7 +89,8 @@ scrub_cleanup(
 	if (error)
 		return error;
 
-	action_list_free(&ctx->action_list);
+	action_list_free(&ctx->file_repair_list);
+	action_list_free(&ctx->fs_repair_list);
 
 	if (ctx->fshandle)
 		free_handle(ctx->fshandle, ctx->fshandle_len);
@@ -186,9 +187,15 @@ _("Not an XFS filesystem."));
 		return error;
 	}
 
-	error = action_list_alloc(&ctx->action_list);
+	error = action_list_alloc(&ctx->fs_repair_list);
 	if (error) {
-		str_liberror(ctx, error, _("allocating repair list"));
+		str_liberror(ctx, error, _("allocating fs repair list"));
+		return error;
+	}
+
+	error = action_list_alloc(&ctx->file_repair_list);
+	if (error) {
+		str_liberror(ctx, error, _("allocating file repair list"));
 		return error;
 	}
 
diff --git a/scrub/phase2.c b/scrub/phase2.c
index a40545f6daf..5e4e03dc688 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -64,7 +64,7 @@ defer_fs_repair(
 		return error;
 
 	pthread_mutex_lock(&ctx->lock);
-	action_list_add(ctx->action_list, aitem);
+	action_list_add(ctx->fs_repair_list, aitem);
 	pthread_mutex_unlock(&ctx->lock);
 	return 0;
 }
diff --git a/scrub/phase3.c b/scrub/phase3.c
index ad2723f9ae3..6e6a68b9b68 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -225,7 +225,7 @@ collect_repairs(
 	struct scrub_ctx	*ctx = foreach_arg;
 	struct action_list	*alist = data;
 
-	action_list_merge(ctx->action_list, alist);
+	action_list_merge(ctx->file_repair_list, alist);
 	return 0;
 }
 
@@ -269,7 +269,7 @@ phase3_func(
 	 * to repair the space metadata.
 	 */
 	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
-		if (!action_list_empty(ctx->action_list))
+		if (!action_list_empty(ctx->fs_repair_list))
 			ictx.always_defer_repairs = true;
 	}
 
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 61405dacec4..cb0354b44cb 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -194,7 +194,13 @@ repair_everything(
 	do {
 		fixed_anything = 0;
 
-		ret = repair_list_schedule(ctx, &wq, ctx->action_list);
+		ret = repair_list_schedule(ctx, &wq, ctx->fs_repair_list);
+		if (ret < 0)
+			break;
+		if (ret == 1)
+			fixed_anything++;
+
+		ret = repair_list_schedule(ctx, &wq, ctx->file_repair_list);
 		if (ret < 0)
 			break;
 		if (ret == 1)
@@ -209,8 +215,12 @@ repair_everything(
 	if (ret < 0)
 		return ret;
 
-	/* Repair everything serially.  Last chance to fix things. */
-	return action_list_process(ctx, ctx->action_list, XRM_FINAL_WARNING);
+	/*
+	 * Combine both repair lists and repair everything serially.  This is
+	 * the last chance to fix things.
+	 */
+	action_list_merge(ctx->fs_repair_list, ctx->file_repair_list);
+	return action_list_process(ctx, ctx->fs_repair_list, XRM_FINAL_WARNING);
 }
 
 /* Trim the unused areas of the filesystem if the caller asked us to. */
@@ -232,7 +242,8 @@ phase4_func(
 	struct scrub_item	sri;
 	int			ret;
 
-	if (action_list_empty(ctx->action_list))
+	if (action_list_empty(ctx->fs_repair_list) &&
+	    action_list_empty(ctx->file_repair_list))
 		goto maybe_trim;
 
 	/*
@@ -293,7 +304,8 @@ phase4_estimate(
 	unsigned long long	need_fixing;
 
 	/* Everything on the repair list plus FSTRIM. */
-	need_fixing = action_list_length(ctx->action_list);
+	need_fixing = action_list_length(ctx->fs_repair_list) +
+		      action_list_length(ctx->file_repair_list);
 	need_fixing++;
 
 	*items = need_fixing;
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 96a6aa06eac..acfe6175bdb 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -71,7 +71,8 @@ struct scrub_ctx {
 
 	/* Mutable scrub state; use lock. */
 	pthread_mutex_t		lock;
-	struct action_list	*action_list;
+	struct action_list	*fs_repair_list;
+	struct action_list	*file_repair_list;
 	unsigned long long	max_errors;
 	unsigned long long	runtime_errors;
 	unsigned long long	corruptions_found;

