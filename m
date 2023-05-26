Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13AA9C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjEZBmW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234230AbjEZBmV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:42:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC80194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:42:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D309660ADA
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F637C433EF;
        Fri, 26 May 2023 01:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065339;
        bh=N8jT+dXdGpW/c8xyNWJBhOU4PUqUZ1g0QJ2oqLoZR5I=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=GJWvddBJeqpmhkI41YNE9IaA26ZCPxZkxU3uYEkvy5GyHdK2aCWli07Ue0gE1fvN1
         bYg+2H5iPKYn7smLQiT2+9kTftNjPwRDO9djk1O+m3B8RTGGcA5pq2ZxgwsPMttW5B
         fflwbwLpyrUgq6T/ad+tWvWoPRRpmL0Od56X5B5c0znBx2gS+hCFXiJ9c6K6BSpuwA
         WalysDA3QbKIrn34I6XFjYQGCVupO4nzxDQKAkG2Eqj4GguREAYhy9vLCM3ZQ62/1z
         wuaAZT9bLOjFPZBmGKqEWa8cHa+9r4oIZBs/zUpMk0wQwAoFbwrFYK9eF3jciPTPiU
         w6AWsdl8l0x0A==
Date:   Thu, 25 May 2023 18:42:18 -0700
Subject: [PATCH 7/7] xfs_scrub: actually try to fix summary counters ahead of
 repairs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506071399.3742205.14730154143697144652.stgit@frogsfrogsfrogs>
In-Reply-To: <168506071314.3742205.8114181660121831202.stgit@frogsfrogsfrogs>
References: <168506071314.3742205.8114181660121831202.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

A while ago, I decided to make phase 4 check the summary counters before
it starts any other repairs, having observed that repairs of primary
metadata can fail because the summary counters (incorrectly) claim that
there aren't enough free resources in the filesystem.  However, if
problems are found in the summary counters, the repair work will be run
as part of the AG 0 repairs, which means that it runs concurrently with
other scrubbers.  This doesn't quite get us to the intended goal, so try
to fix the scrubbers ahead of time.  If that fails, tough, we'll get
back to it in phase 7 if scrub gets that far.

Fixes: cbaf1c9d91a0 ("xfs_scrub: check summary counters")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase4.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)


diff --git a/scrub/phase4.c b/scrub/phase4.c
index 789208398b4..f14c3ad58f2 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -129,6 +129,7 @@ phase4_func(
 	struct scrub_ctx	*ctx)
 {
 	struct xfs_fsop_geom	fsgeom;
+	struct action_list	alist;
 	int			ret;
 
 	if (!have_action_items(ctx))
@@ -136,11 +137,13 @@ phase4_func(
 
 	/*
 	 * Check the summary counters early.  Normally we do this during phase
-	 * seven, but some of the cross-referencing requires fairly-accurate
-	 * counters, so counter repairs have to be put on the list now so that
-	 * they get fixed before we stop retrying unfixed metadata repairs.
+	 * seven, but some of the cross-referencing requires fairly accurate
+	 * summary counters.  Check and try to repair them now to minimize the
+	 * chance that repairs of primary metadata fail due to secondary
+	 * metadata.  If repairs fails, we'll come back during phase 7.
 	 */
-	ret = scrub_fs_counters(ctx, &ctx->action_lists[0]);
+	action_list_init(&alist);
+	ret = scrub_fs_counters(ctx, &alist);
 	if (ret)
 		return ret;
 
@@ -155,11 +158,18 @@ phase4_func(
 		return ret;
 
 	if (fsgeom.sick & XFS_FSOP_GEOM_SICK_QUOTACHECK) {
-		ret = scrub_quotacheck(ctx, &ctx->action_lists[0]);
+		ret = scrub_quotacheck(ctx, &alist);
 		if (ret)
 			return ret;
 	}
 
+	/* Repair counters before starting on the rest. */
+	ret = action_list_process(ctx, -1, &alist,
+			XRM_REPAIR_ONLY | XRM_NOPROGRESS);
+	if (ret)
+		return ret;
+	action_list_discard(&alist);
+
 	ret = repair_everything(ctx);
 	if (ret)
 		return ret;

