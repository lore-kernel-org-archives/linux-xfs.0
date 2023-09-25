Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28D4DCE79A5
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbjIYV7D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbjIYV7C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:59:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F42112
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 14:58:56 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111AAC433C7;
        Mon, 25 Sep 2023 21:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695679136;
        bh=w86RNB4gaHr8rqCXtyn5uYoUX2ub1h4KQHc5exYlgEA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ozT62vXXg2SaOi/D8/sBeHrC34YHQG2+qYTzRAYnUADE5rho7eOeKgHIHbqiJn415
         1Nc41XiD+5Qe7YcSvQzUXTuqln31y3SID6MVBsSnHmh3XbCDZ0VX3xa9UbEgpT9X7v
         2Hq0jJoAVF/LR0jNrgTmqmP7+2uCwwVe87KFPQLY/Wr0VGfPGXYN1AJCOGumpkHwEM
         rCBy7YPdNIaHjaukjWhwRZoiL2Pc3COOZigSfX9X9ZZuctnwEFI2evpsI/3Fmm7DJK
         kLlOTRZ9zJ3gs3/jYp5I2+3MMJ3ACKXo5CKKQCz36jOCkfLUFZoaESekZSHmNhLJFM
         524cX9b8zhXNA==
Subject: [PATCH 2/3] xfs_scrub: don't retry unsupported optimizations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 25 Sep 2023 14:58:55 -0700
Message-ID: <169567913555.2320149.9303579022453923734.stgit@frogsfrogsfrogs>
In-Reply-To: <169567912436.2320149.9404820627184014976.stgit@frogsfrogsfrogs>
References: <169567912436.2320149.9404820627184014976.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If the kernel says it doesn't support optimizing a data structure, we
should mark it done and move on.  This is much better than requeuing the
repair, in which case it will likely keep failing.  Eventually these
requeued repairs end up in the single-threaded last resort at the end of
phase 4, which makes things /very/ slow.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/scrub.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)


diff --git a/scrub/scrub.c b/scrub/scrub.c
index e83d0d9ce99..1a4506875f7 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -668,6 +668,15 @@ _("Filesystem is shut down, aborting."));
 		return CHECK_ABORT;
 	case ENOTTY:
 	case EOPNOTSUPP:
+		/*
+		 * If the kernel cannot perform the optimization that we
+		 * requested; or we forced a repair but the kernel doesn't know
+		 * how to perform the repair, don't requeue the request.  Mark
+		 * it done and move on.
+		 */
+		if (is_unoptimized(&oldm) ||
+		    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
+			return CHECK_DONE;
 		/*
 		 * If we're in no-complain mode, requeue the check for
 		 * later.  It's possible that an error in another
@@ -678,13 +687,6 @@ _("Filesystem is shut down, aborting."));
 		 */
 		if (!(repair_flags & XRM_COMPLAIN_IF_UNFIXED))
 			return CHECK_RETRY;
-		/*
-		 * If we forced repairs or this is a preen, don't
-		 * error out if the kernel doesn't know how to fix.
-		 */
-		if (is_unoptimized(&oldm) ||
-		    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
-			return CHECK_DONE;
 		fallthrough;
 	case EINVAL:
 		/* Kernel doesn't know how to repair this? */

