Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A3C3C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:49:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjEZBti (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjEZBth (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:49:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC71189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:49:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D8F261B63
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE71AC433EF;
        Fri, 26 May 2023 01:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065775;
        bh=IQTQ8zuW+nfhUvw0Oz2bs/YFNjYsTmvHLlMUtT6xUhk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=SSa+dEZ9wk43Cf2yPjNAqat4nr16N9hRZzFrArINlkHmnBGiJrT3mcPUgz9HW+cEv
         /g0cKnQOrHGBi7U2CiB3BoNwm1XW5RQWbZfU6+oBNZeKkgfdUpKeQQql/yzJqHfi7O
         7fRk3cEXaZvlahec8zIn095IUkeO44XHPArq7IvA73G/zD07SH25EWx3nwHWvvxjDG
         pHhpRA+ixXivHdG54Qq49JRfxR/umuodwPS0T7blNIioTxoRbVfm0uDotOQBrMxVYq
         azEhQPrTfXJ20U1bC0yytbMpRR5/VEiVgHfq/+/6UvGWYGAyTN9P91064aEZumLFp2
         K7aqUfwP5pNkA==
Date:   Thu, 25 May 2023 18:49:35 -0700
Subject: [PATCH 4/8] xfs_scrub: fix the work estimation for phase 8
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506073133.3744829.18094717757505490219.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073077.3744829.468307851541842353.stgit@frogsfrogsfrogs>
References: <168506073077.3744829.468307851541842353.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If there are latent errors on the filesystem, we aren't going to do any
work during phase 8 and it makes no sense to add that into the work
estimate for the progress bar.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase8.c |   36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index 76648b30842..6ad948ff6bf 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -21,23 +21,35 @@
 
 /* Phase 8: Trim filesystem. */
 
-/* Trim the filesystem, if desired. */
-int
-phase8_func(
+static inline bool
+fstrim_ok(
 	struct scrub_ctx	*ctx)
 {
-	if (action_list_empty(ctx->fs_repair_list) &&
-	    action_list_empty(ctx->file_repair_list))
-		goto maybe_trim;
-
 	/*
 	 * If errors remain on the filesystem, do not trim anything.  We don't
 	 * have any threads running, so it's ok to skip the ctx lock here.
 	 */
-	if (ctx->corruptions_found || ctx->unfixable_errors != 0)
+	if (!action_list_empty(ctx->fs_repair_list))
+		return false;
+	if (!action_list_empty(ctx->file_repair_list))
+		return false;
+
+	if (ctx->corruptions_found != 0)
+		return false;
+	if (ctx->unfixable_errors != 0)
+		return false;
+
+	return true;
+}
+
+/* Trim the filesystem, if desired. */
+int
+phase8_func(
+	struct scrub_ctx	*ctx)
+{
+	if (!fstrim_ok(ctx))
 		return 0;
 
-maybe_trim:
 	fstrim(ctx);
 	progress_add(1);
 	return 0;
@@ -51,7 +63,11 @@ phase8_estimate(
 	unsigned int		*nr_threads,
 	int			*rshift)
 {
-	*items = 1;
+	*items = 0;
+
+	if (fstrim_ok(ctx))
+		*items = 1;
+
 	*nr_threads = 1;
 	*rshift = 0;
 	return 0;

