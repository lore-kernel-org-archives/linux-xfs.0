Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3381FC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiLaAZr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235760AbiLaAZq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:25:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8285BB82
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:25:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BD12B81E9F
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:25:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C2EC433D2;
        Sat, 31 Dec 2022 00:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446342;
        bh=kkXZpw2e8SvSEmL4krT9vPo+q94TeWS39AGuQ9Eoa0A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=l7NQ9/W/rt1PoAbuhpArKHVe7KcutDV/32Kzh95cAkERfZJM0UWLEcBYWOZ14EuWI
         eq8ucOpMD/tZTfrGBHoSJ3TZL9kaYxWaAkAwIrPZbdLeB/70PxWW+/sHblywikGUYG
         WvcmrA2MdxBnQvdTEcbAAOf2jrC0jlBsUBmYuiNHIkZ+3zEHfE1taGA7+CcmJ9oWir
         mM8OF+gUB+aG0OJ9F1uUZSU3r/cwir/4MOctVmtRcN8QuN1c1H9HjrYjUO/iDY4H0a
         Rac8CNKa1dXo3iTiewZR6PCcptbPG5VmaaD4ecIxJJ/CRFCsZLI5DUORisPcMQ/vc3
         meOjT/KD9Ssmw==
Subject: [PATCH 6/6] xfs_scrub: actually try to fix summary counters ahead of
 repairs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:11 -0800
Message-ID: <167243869104.714771.2428848445593088790.stgit@magnolia>
In-Reply-To: <167243869023.714771.3955258526251265287.stgit@magnolia>
References: <167243869023.714771.3955258526251265287.stgit@magnolia>
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
index c71b56b7bda..5929df38084 100644
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

