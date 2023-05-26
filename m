Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD64C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjEZBtH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjEZBtG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:49:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65D618D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:49:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C70363B77
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6691C433EF;
        Fri, 26 May 2023 01:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065744;
        bh=kV3h+H4QlwayHE7T7fLtHBCNkXrrsnmReCaWJZBP66o=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=PW5kvv/SD2We4ZqVRscUA89k+eTVEyh44eTlqdZ4tT+9V0CklG0RpRx+Q6GNHk+yU
         0tEnqyxnivKlRlU+ku+YIWOO/g8Yl4X6KO4Z9zi+bF2qlwGSZoNdMzW3mRnDaXU/Pg
         I233qQaywm3b16lfthPOTbNJp0wJXAau03ZNxF2RnT09Ka6qDfppxYRsFlpvPTnoeo
         8XYlmmDQ+LusTQGkybUOEwGPd82BV0kL0RF50My8VvKM8H0GAyC2/r3pCoU7hi1qUP
         FYXODewZr+ekbV9EKl5UMAdrvfKOv/FHOyPJ8n1zllrtHIpyDzJu6920OY7HbsTjxv
         FB8f8/mSRzHvQ==
Date:   Thu, 25 May 2023 18:49:04 -0700
Subject: [PATCH 2/8] xfs_scrub: ignore phase 8 if the user disabled fstrim
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506073106.3744829.4305123730916746991.stgit@frogsfrogsfrogs>
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

If the user told us to skip trimming the filesystem, don't run the phase
at all.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)


diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 6c090a6dd88..73f82ef0c8d 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -246,6 +246,7 @@ struct phase_rusage {
 /* Operations for each phase. */
 #define DATASCAN_DUMMY_FN	((void *)1)
 #define REPAIR_DUMMY_FN		((void *)2)
+#define FSTRIM_DUMMY_FN		((void *)3)
 struct phase_ops {
 	char		*descr;
 	int		(*fn)(struct scrub_ctx *ctx);
@@ -426,6 +427,11 @@ run_scrub_phases(
 			.fn = phase7_func,
 			.must_run = true,
 		},
+		{
+			.descr = _("Trim filesystem storage."),
+			.fn = FSTRIM_DUMMY_FN,
+			.estimate_work = phase8_estimate,
+		},
 		{
 			NULL
 		},
@@ -446,6 +452,8 @@ run_scrub_phases(
 		/* Turn on certain phases if user said to. */
 		if (sp->fn == DATASCAN_DUMMY_FN && scrub_data) {
 			sp->fn = phase6_func;
+		} else if (sp->fn == FSTRIM_DUMMY_FN && want_fstrim) {
+			sp->fn = phase8_func;
 		} else if (sp->fn == REPAIR_DUMMY_FN &&
 			   ctx->mode == SCRUB_MODE_REPAIR) {
 			sp->descr = _("Repair filesystem.");
@@ -455,7 +463,8 @@ run_scrub_phases(
 
 		/* Skip certain phases unless they're turned on. */
 		if (sp->fn == REPAIR_DUMMY_FN ||
-		    sp->fn == DATASCAN_DUMMY_FN)
+		    sp->fn == DATASCAN_DUMMY_FN ||
+		    sp->fn == FSTRIM_DUMMY_FN)
 			continue;
 
 		/* Allow debug users to force a particular phase. */

