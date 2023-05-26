Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD5B4C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbjEZBmi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234230AbjEZBmh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:42:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0AA189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:42:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7411861276
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D99C433EF;
        Fri, 26 May 2023 01:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065354;
        bh=tGC0YsjUxhJLuE9X/CfBEagGyccPcz0vBRQl2jAZ6Ok=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=S5MK/z5IPA2y5WlyPr90Xqdlnz/XQoi1s0oUblhIqzI8rlntlZiYYYcilAOL2sz9R
         YHHW1vi6qJatLuYmsZHcO5Fjju4iBJnxv6sxD0b4/xsTNj1anM4bvnQ3j3pd6/2cNK
         V2KeUAjRW2sL+GFl94rW/62BGnkLs4573jVGjS4G3Qd1B5Hslr/YOhtyi4W70IMpdS
         Csl+e+PLmz6W6RF2C9HgxLAFirInR3sgkd7OeEF1YlE5bQt7HkPBPq5zWLtmQXfmze
         kcuVC0S+rqJrthZzTv4r8l2O4j9wg/HNbnuVQoJsEsqv8voJE7A8ithoHIkSHb4Iev
         byOpfT/4DBHXg==
Date:   Thu, 25 May 2023 18:42:34 -0700
Subject: [PATCH 1/6] xfs_scrub: collapse trivial superblock scrub helpers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506071679.3742978.12062584012078231030.stgit@frogsfrogsfrogs>
In-Reply-To: <168506071665.3742978.12693465390096953510.stgit@frogsfrogsfrogs>
References: <168506071665.3742978.12693465390096953510.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index d6618dac509..75993544158 100644
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
index 93a49ddebb6..06433aea197 100644
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
index 39e8439cb8b..4ae8e142ce9 100644
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

