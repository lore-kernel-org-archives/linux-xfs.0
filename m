Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 744A5C27C40
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Nov 2023 23:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235206AbjKVXII (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Nov 2023 18:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235199AbjKVXIE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2023 18:08:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31AAD10E
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 15:08:01 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9111C433C9;
        Wed, 22 Nov 2023 23:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700694480;
        bh=OfvA4KwoaM9q7jtK4tAf8ikTgjyG9t9pFiwtbZRwURk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aD+7aLDAwtP+LbXcJBQLVj9jdy5ECQkXh+VqNGFrHNAuGYvLnHBi85hLkOPheapx7
         N2e/QoxwPihua4A+uQtHzwnmCHtKJXgj+4R48ocfRNpTEaQVOOaqyVkdPUlFtsVHEv
         87pN7qk4JJXHWBuo4T+lxjrIv5dnNrWT/OINsvyz3WoackG1ths1iXuOijlx1/1aZP
         6pVSYJ++aXtXOqAA+iqj4H7EPpheawFFGlaMODObQI7Dxuh1Zj5zKnLG65O65w8/uX
         Wf6SWwC85fIRPpd01uetIJxmotQ7TpjY7AXkd6OYnEKIA8PTT/WYryc0Mr4BTiGHHe
         nFYst4kFn0lQA==
Subject: [PATCH 3/4] xfs_scrub: don't retry unsupported optimizations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 22 Nov 2023 15:08:00 -0800
Message-ID: <170069448029.1867812.17301472136475061729.stgit@frogsfrogsfrogs>
In-Reply-To: <170069446332.1867812.3207871076452705865.stgit@frogsfrogsfrogs>
References: <170069446332.1867812.3207871076452705865.stgit@frogsfrogsfrogs>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
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

