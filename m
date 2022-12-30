Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 658C6C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:32:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235622AbiLaAcA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:32:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235750AbiLaAb5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:31:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8B313F7A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:31:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F6EA61D4B
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B731C433EF;
        Sat, 31 Dec 2022 00:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446716;
        bh=PkGczJ7tvQDEY0tAYot2tk1WvdNWx1Z0tEKNg5+9ZFo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nJJ0W356n1ECSOJ/QoY1Uq0u1Al70P1vVkYMOo2SZkkpqRa26oZZKeGQyZ+g6mDN8
         kJYt90cRGwifqI4mrrQ9UMtHesApEWO8aZRXk7Hrv9WoQXK7RNc9RP1nco0W+NFxMd
         qH0yBxt2XIM886iUDxqaPrTHqEnaK4zjaEl//Q4B9Yn4Pw0MXF29+rB7XwVPNjTsAr
         IxCF72sKokyJBepxbvnD616N/hJwHzVmbaD1lCAnTIQURvHhoPfOlHeRxfoFRu/98M
         jbXOiRJRlfxIZ8XfzW48eM4IcTADLAjH2IntPu0DO8ChzX96yn8GvVCGcCn3NnyIu2
         9vBA9mxcKWOlg==
Subject: [PATCH 4/4] xfs_scrub: try to repair space metadata before file
 metadata
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:24 -0800
Message-ID: <167243870483.716640.9332994789785540092.stgit@magnolia>
In-Reply-To: <167243870430.716640.15368107413813691968.stgit@magnolia>
References: <167243870430.716640.15368107413813691968.stgit@magnolia>
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
index 6ad012042da..faa554f1e1e 100644
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
index e07f7a11be5..ebe3ad3ad5c 100644
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
index e000d8fe4c5..c5950b1b9e3 100644
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
index 5563c4c5b0b..aa9aaea1826 100644
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
index d5094147327..8d6ee9826cb 100644
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

