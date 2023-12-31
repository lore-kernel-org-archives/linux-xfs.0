Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D7BC2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="be2oFbIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273DEC433C8;
	Sun, 31 Dec 2023 22:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062703;
	bh=YqgZenfX5D8sE2vrt+3RJduw4tgQuWbZ2opBk1jFwOA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=be2oFbIPXsJBEdY6wdi4IXwwOATem9w27flMPZAtp6vgVUJCk3TjAyIZtQzoGLXzn
	 KnK1+CsY1cVOsQXPFS/Iu+pyv6vIgCh8Gc/WbOoiNZUPbXVHi12GnaM5uBjS/EHbpk
	 1JM2AEPrNA+bw+qb+YHNtI3Yt1oNo4LS754Zp4gFfg8feQxYPExqFm17i1ZtLhRUJ9
	 WS5pDjBv28jBM/t8hq3Ee39cd0GaHvA1FoDK+vrQQ08Xu1fwJtEavMX3WadkKFU5z6
	 wwZXjy/BbwHHzilmD8kkV03yKSEY2ZC8yBp46xOKE34CTKAPFwsP/rDBkO/zmR+63I
	 auZSeJJEp+vFw==
Date: Sun, 31 Dec 2023 14:45:02 -0800
Subject: [PATCH 4/4] xfs_scrub: try to repair space metadata before file
 metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405000278.1798235.5942937767888494780.stgit@frogsfrogsfrogs>
In-Reply-To: <170405000222.1798235.1301416875511824495.stgit@frogsfrogsfrogs>
References: <170405000222.1798235.1301416875511824495.stgit@frogsfrogsfrogs>
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
index 78769a57bf1..1b3f6e8eb4f 100644
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
index 5803d8c645a..57c6d0ef213 100644
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
index 1a71d4ace48..98e5c5a1f9f 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -234,7 +234,7 @@ collect_repairs(
 	struct scrub_ctx	*ctx = foreach_arg;
 	struct action_list	*alist = data;
 
-	action_list_merge(ctx->action_list, alist);
+	action_list_merge(ctx->file_repair_list, alist);
 	return 0;
 }
 
@@ -278,7 +278,7 @@ phase3_func(
 	 * to repair the space metadata.
 	 */
 	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
-		if (!action_list_empty(ctx->action_list))
+		if (!action_list_empty(ctx->fs_repair_list))
 			ictx.always_defer_repairs = true;
 	}
 
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 564ccb82704..9080d38818f 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -198,7 +198,13 @@ repair_everything(
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
@@ -213,8 +219,12 @@ repair_everything(
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
@@ -236,7 +246,8 @@ phase4_func(
 	struct scrub_item	sri;
 	int			ret;
 
-	if (action_list_empty(ctx->action_list))
+	if (action_list_empty(ctx->fs_repair_list) &&
+	    action_list_empty(ctx->file_repair_list))
 		goto maybe_trim;
 
 	/*
@@ -297,7 +308,8 @@ phase4_estimate(
 	unsigned long long	need_fixing;
 
 	/* Everything on the repair list plus FSTRIM. */
-	need_fixing = action_list_length(ctx->action_list);
+	need_fixing = action_list_length(ctx->fs_repair_list) +
+		      action_list_length(ctx->file_repair_list);
 	need_fixing++;
 
 	*items = need_fixing;
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index a339c4d6348..ed86d0093db 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -72,7 +72,8 @@ struct scrub_ctx {
 
 	/* Mutable scrub state; use lock. */
 	pthread_mutex_t		lock;
-	struct action_list	*action_list;
+	struct action_list	*fs_repair_list;
+	struct action_list	*file_repair_list;
 	unsigned long long	max_errors;
 	unsigned long long	runtime_errors;
 	unsigned long long	corruptions_found;

