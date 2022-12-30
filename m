Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74324C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiLaAa6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235622AbiLaAa5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:30:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FA412093
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:30:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB9D3B81EB1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B47AC433D2;
        Sat, 31 Dec 2022 00:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446653;
        bh=zcvNXEPfQF/3cfzHYuZZD2WPkUmrRx3AUrO9S0GcRrM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uUXPFWjshZLuFnujFF1tbP36sEHdmKZmjCyZG0ScLfQnzaxEz0sjDEEnENzZxBGQn
         2UH+PXXikOi5jKbcvS7hPud1IYxNnMi+9dRq0J8Kr5CaXFgcAftC9G5z/t6VYmrfvD
         HRNkWkEMzuxEv6Qfos5bhqdyZETsDFpJfYMKIR1gUurMW+KoYp9wo4jhf/PhnGfM1z
         YA6MFmZ+4BdX2j8MW7IQAs2jnTvFjAQ4kpXfzEEAOk/U1Whc/FplWy/a1fgzwZxUDM
         EywnlOwtuxVduL7sTSuPlxlqy8U8mt8W1pas2Lybyoi6At6/AtKrsU+hG/3Q5vGzV7
         eTqwMdCryMUpA==
Subject: [PATCH 5/5] xfs_scrub: hoist scrub retry loop to
 scrub_item_check_file
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:21 -0800
Message-ID: <167243870168.716382.7115032161168414265.stgit@magnolia>
In-Reply-To: <167243870099.716382.3489355808439125232.stgit@magnolia>
References: <167243870099.716382.3489355808439125232.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

For metadata check calls, use the ioctl retry and freeze permission
tracking in scrub_item that we created in the last patch.  This enables
us to move the check retry loop out of xfs_scrub_metadata and into its
caller to remove a long backwards jump, and gets us closer to
vectorizing scrub calls.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/scrub.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)


diff --git a/scrub/scrub.c b/scrub/scrub.c
index d3d96a85903..6f9f182c629 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -88,7 +88,6 @@ xfs_check_metadata(
 	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
 	struct xfs_scrub_metadata	meta = { };
 	enum xfrog_scrub_group		group;
-	unsigned int			tries = 0;
 	int				error;
 
 	background_sleep();
@@ -116,7 +115,7 @@ xfs_check_metadata(
 	descr_set(&dsc, &meta);
 
 	dbg_printf("check %s flags %xh\n", descr_render(&dsc), meta.sm_flags);
-retry:
+
 	error = -xfrog_scrub_metadata(xfdp, &meta);
 	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !error)
 		meta.sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
@@ -163,10 +162,8 @@ _("Filesystem is shut down, aborting."));
 	 * we'll try the scan again, just in case the fs was busy.
 	 * Only retry so many times.
 	 */
-	if (want_retry(&meta) && tries < 10) {
-		tries++;
-		goto retry;
-	}
+	if (want_retry(&meta) && scrub_item_schedule_retry(sri, scrub_type))
+		return 0;
 
 	/* Complain about incomplete or suspicious metadata. */
 	scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
@@ -304,6 +301,7 @@ scrub_item_check_file(
 	int				override_fd)
 {
 	struct xfs_fd			xfd;
+	struct scrub_item		old_sri;
 	struct xfs_fd			*xfdp = &ctx->mnt;
 	unsigned int			scrub_type;
 	int				error;
@@ -323,7 +321,14 @@ scrub_item_check_file(
 		if (!(sri->sri_state[scrub_type] & SCRUB_ITEM_NEEDSCHECK))
 			continue;
 
-		error = xfs_check_metadata(ctx, xfdp, scrub_type, sri);
+		sri->sri_tries[scrub_type] = SCRUB_ITEM_MAX_RETRIES;
+		do {
+			memcpy(&old_sri, sri, sizeof(old_sri));
+			error = xfs_check_metadata(ctx, xfdp, scrub_type, sri);
+			if (error)
+				return error;
+		} while (scrub_item_call_kernel_again(sri, scrub_type,
+					SCRUB_ITEM_NEEDSCHECK, &old_sri));
 
 		/*
 		 * Progress is counted by the inode for inode metadata; for

