Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14870C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Mar 2022 23:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352566AbiCOXYg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 19:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236358AbiCOXYd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 19:24:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939B92B186
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 16:23:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30115614DC
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 23:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1EEC340F3;
        Tue, 15 Mar 2022 23:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647386599;
        bh=doXMkej+tyK++K9S5Wh0QoxHIQC++dNcltVehYSXuZE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MM/1C1dMrVMediD4fGFk/+G4JaF2rzEEvsLkt7kx2kMJp4WtB039gkEzc/MYnsSIL
         SzkoJ9QnI6PKTufxwCiNnVtTMtU87t/XiIhSs/K5sqqlItU6KPaY10Qh9nNUxDABFH
         gOJSciFyJOYqpLi0VdRXO+BcsLGoPU+K4rYhz5r8R4oczjr8uNTpcQTq912WRJ7U5z
         je7jeKG9DXrVAYuZqCjzU0bwCziJSO9F4KUqAwhTPLZMb2+6lSpixrBwVq55bHSpG+
         aZbQkZtbuXprCbXPZbT87aFEnzGZrdr4yFpd2siK22rmY9PxeqyDPrPouBpH3HHXR6
         psKkOI8IoPCnA==
Subject: [PATCH 2/2] xfs_scrub: retry scrub (and repair) of items that are ok
 except for XFAIL
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Date:   Tue, 15 Mar 2022 16:23:19 -0700
Message-ID: <164738659907.3191772.7906348523548262156.stgit@magnolia>
In-Reply-To: <164738658769.3191772.13386518564409172970.stgit@magnolia>
References: <164738658769.3191772.13386518564409172970.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Sometimes a metadata object will pass all of the obvious scrubber
checks, but we won't be able to cross-reference the object's records
with other metadata objects (e.g. a file data fork and a free space
btree both claim ownership of an extent).  When this happens during the
checking phase, we should queue the object for a repair, which means
that phase 4 will keep re-evaluating the object as repairs proceed.
Eventually, the hope is that we'll fix the filesystem and everything
will scrub cleanly; if not, we recommend running xfs_repair as a second
attempt to fix the inconsistency.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/scrub.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)


diff --git a/scrub/scrub.c b/scrub/scrub.c
index 07ae0673..4ef19656 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -223,6 +223,16 @@ _("Optimization is possible."));
 		return CHECK_REPAIR;
 	}
 
+	/*
+	 * This metadata object itself looks ok, but we noticed inconsistencies
+	 * when comparing it with the other filesystem metadata.  If we're in
+	 * repair mode we need to queue it for a "repair" so that phase 4 will
+	 * re-examine the object as repairs progress to see if the kernel will
+	 * deem it completely consistent at some point.
+	 */
+	if (xref_failed(meta) && ctx->mode == SCRUB_MODE_REPAIR)
+		return CHECK_REPAIR;
+
 	/* Everything is ok. */
 	return CHECK_DONE;
 }
@@ -787,6 +797,23 @@ _("Read-only filesystem; cannot make changes."));
 			return CHECK_RETRY;
 		str_corrupt(ctx, descr_render(&dsc),
 _("Repair unsuccessful; offline repair required."));
+	} else if (xref_failed(&meta)) {
+		/*
+		 * This metadata object itself looks ok, but we still noticed
+		 * inconsistencies when comparing it with the other filesystem
+		 * metadata.  If we're in "final warning" mode, advise the
+		 * caller to run xfs_repair; otherwise, we'll keep trying to
+		 * reverify the cross-referencing as repairs progress.
+		 */
+		if (repair_flags & XRM_COMPLAIN_IF_UNFIXED) {
+			str_info(ctx, descr_render(&dsc),
+ _("Seems correct but cross-referencing failed; offline repair recommended."));
+		} else {
+			if (verbose)
+				str_info(ctx, descr_render(&dsc),
+ _("Seems correct but cross-referencing failed; will keep checking."));
+			return CHECK_RETRY;
+		}
 	} else {
 		/* Clean operation, no corruption detected. */
 		if (needs_repair(&oldm))

