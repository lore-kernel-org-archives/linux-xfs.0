Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A86C13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TwSB4S71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE919C433C7;
	Sun, 31 Dec 2023 22:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062327;
	bh=agmbz1bWrUc76dlx0Yu1nHcbDIIr6c77TqYBACxspdg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TwSB4S71UB2n9twHD+IX7j+bTgi9Z+/LcFBmZorgkMQ8O8CsqfFkoLMdDhmgtBbTM
	 GSSD9SimUz8aidDlKlm6ADQ6WrKrsEAFO26vL/+TdBYN7iEtFHc9lJOU9Scelycqtf
	 L2ZvUFgelfJHd7Miq0bDolmTkDccccc/prd6PlTKqClBLzVyLVO8D0d0shRNq14yuC
	 NvPIk1pIS2jcNnQ+BxUMgNTkuDEzMW6BzmHZynhUHpRlXmEgjorc0fIKzdScik8e21
	 H9OHThqMKWFLAdpnNSfTIFNBLwyFT5itgGqnxUsUJNiE+t3/jVixqPltKM7K9ZyLIJ
	 1iE5HYeVXOXQw==
Date: Sun, 31 Dec 2023 14:38:47 -0800
Subject: [PATCH 2/8] xfs_scrub: collapse trivial superblock scrub helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404999061.1797544.15540940981670714039.stgit@frogsfrogsfrogs>
In-Reply-To: <170404999029.1797544.5974682335470417611.stgit@frogsfrogsfrogs>
References: <170404999029.1797544.5974682335470417611.stgit@frogsfrogsfrogs>
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

Remove the trivial primary super scrub helper function since it makes
tracing code paths difficult and will become annoying in the patches
that follow.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase2.c |    9 +++++----
 scrub/scrub.c  |   16 +---------------
 scrub/scrub.h  |    3 ++-
 3 files changed, 8 insertions(+), 20 deletions(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index 2d49c604eae..ec72bb5b71a 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -166,12 +166,13 @@ phase2_func(
 	}
 
 	/*
-	 * In case we ever use the primary super scrubber to perform fs
-	 * upgrades (followed by a full scrub), do that before we launch
-	 * anything else.
+	 * Scrub primary superblock.  This will be useful if we ever need to
+	 * hook a filesystem-wide pre-scrub activity (e.g. enable filesystem
+	 * upgrades) off of the sb 0 scrubber (which currently does nothing).
+	 * If errors occur, this function will log them and return nonzero.
 	 */
 	action_list_init(&alist);
-	ret = scrub_primary_super(ctx, &alist);
+	ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_SB, 0, &alist);
 	if (ret)
 		goto out_wq;
 	ret = action_list_process(ctx, -1, &alist,
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 59583913031..c2e56e5f1cb 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -259,7 +259,7 @@ scrub_save_repair(
  * Returns 0 for success.  If errors occur, this function will log them and
  * return a positive error code.
  */
-static int
+int
 scrub_meta_type(
 	struct scrub_ctx		*ctx,
 	unsigned int			type,
@@ -325,20 +325,6 @@ scrub_group(
 	return 0;
 }
 
-/*
- * Scrub primary superblock.  This will be useful if we ever need to hook
- * a filesystem-wide pre-scrub activity off of the sb 0 scrubber (which
- * currently does nothing).  If errors occur, this function will log them and
- * return nonzero.
- */
-int
-scrub_primary_super(
-	struct scrub_ctx		*ctx,
-	struct action_list		*alist)
-{
-	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_SB, 0, alist);
-}
-
 /* Scrub each AG's header blocks. */
 int
 scrub_ag_headers(
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 133445e8da6..fef8a596049 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -17,7 +17,6 @@ enum check_outcome {
 struct action_item;
 
 void scrub_report_preen_triggers(struct scrub_ctx *ctx);
-int scrub_primary_super(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_ag_headers(struct scrub_ctx *ctx, xfs_agnumber_t agno,
 		struct action_list *alist);
 int scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
@@ -30,6 +29,8 @@ int scrub_fs_counters(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_quotacheck(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_nlinks(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_clean_health(struct scrub_ctx *ctx, struct action_list *alist);
+int scrub_meta_type(struct scrub_ctx *ctx, unsigned int type,
+		xfs_agnumber_t agno, struct action_list *alist);
 
 bool can_scrub_fs_metadata(struct scrub_ctx *ctx);
 bool can_scrub_inode(struct scrub_ctx *ctx);

