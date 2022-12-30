Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D40AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbiLaAcb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235655AbiLaAca (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:32:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E15413F7A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:32:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57F88B81EB2
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:32:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B19C433D2;
        Sat, 31 Dec 2022 00:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446747;
        bh=6uBWROMEJlb3V7XDV8hQnHvMvTb3X7gdVjnNqniBR+I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uX+ya6nDkYgDge2wzUFfb50JkzBP4bDo8WHdx3KpjG5WgbDcZGRnFlPZO+hlLqrWw
         WYvwIiW1m3EWhQbD3b/qXyEUQIZF9W89dON5EDE5kNKpJgKPUU9m/FE6x+N+IndBwZ
         Yp3/e1kEfwUni/E1WhQgxXSInxbihal10sOvzSjGmD6U9QWo2uzFhVkSWWkiaHpUy4
         yCoK2sJ1GmUMCfZGRW7sOpehyazgKbzlO+8N2JXZ+s+P6cElRvzSf4CyK0TIHqxvZI
         5756Bs5j5eeAkuoY03Ak/T1Mdrh5yKTKOBTyiVG0AXA/Z41bBBgrIx8OtBCX1H7+pQ
         KcdkiaENJz8tQ==
Subject: [PATCH 2/7] xfs_scrub: ignore phase 8 if the user disabled fstrim
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:27 -0800
Message-ID: <167243870777.716924.8136510482651151559.stgit@magnolia>
In-Reply-To: <167243870748.716924.8460607901853339412.stgit@magnolia>
References: <167243870748.716924.8460607901853339412.stgit@magnolia>
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
index 597be59f9f9..bdee8e4fdae 100644
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

