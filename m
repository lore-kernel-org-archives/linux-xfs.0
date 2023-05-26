Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9243C7EE2F
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjEZBn5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241962AbjEZBnz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:43:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11571B0
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:43:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5755861276
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA505C433EF;
        Fri, 26 May 2023 01:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065432;
        bh=vdRBtbv4ADpTX3+Fe4R5+n3tyia0ow/dzjB6zGGRlUo=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=KYr0u07GGyMtUv14ROXi3LiRQmusGQa1lY6y98Txiy4zwUtpx4lBroYDkTaLINwsx
         96Y4UBYPoT44C9fPMR7Jqde/i7ff8/pjA3TzQCsiZDjhb+6hJdOTWj9zWFwqUzMcd0
         NgrBCjNQF9LMVfgKFo+LC+kMyKq8kHZwlJXx0iLONGTtC3z4WdCM5uiHeZcqOdkomz
         azR+9s6kO/kVTjZmspClzBDKT8ch641S2puueb+K6xobwZmFi1N7arawWQ1dBjFQtl
         fp+oSOVdqnoxIdHCMzQYmE1y0/0d4nyYwvKzPw14W5bPchiSlnSYUdASoLZiqVtr8x
         Qa+ROK62P89/A==
Date:   Thu, 25 May 2023 18:43:52 -0700
Subject: [PATCH 6/6] xfs_scrub: warn about difficult repairs to rt and quota
 metadata
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506071745.3742978.7894839060007183327.stgit@frogsfrogsfrogs>
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

Warn the user if there are problems with the rt or quota metadata that
might make repairs difficult.  For now there aren't any corruption
conditions that would trigger this, but we don't want to leave a gap.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase2.c |   37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index 8919387f0f6..421ac61a538 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -31,6 +31,25 @@ struct scan_ctl {
 	bool			aborted;
 };
 
+/* Warn about the types of mutual inconsistencies that may make repairs hard. */
+static inline void
+warn_repair_difficulties(
+	struct scrub_ctx	*ctx,
+	unsigned int		difficulty,
+	const char		*descr)
+{
+	if (!(difficulty & REPAIR_DIFFICULTY_SECONDARY))
+		return;
+	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
+		return;
+
+	if (difficulty & REPAIR_DIFFICULTY_PRIMARY)
+		str_info(ctx, descr, _("Corrupt primary and secondary metadata."));
+	else
+		str_info(ctx, descr, _("Corrupt secondary metadata."));
+	str_info(ctx, descr, _("Filesystem might not be repairable."));
+}
+
 /* Scrub each AG's metadata btrees. */
 static void
 scan_ag_metadata(
@@ -80,18 +99,7 @@ scan_ag_metadata(
 	 */
 	difficulty = action_list_difficulty(&alist);
 	action_list_find_mustfix(&alist, &immediate_alist);
-
-	if ((difficulty & REPAIR_DIFFICULTY_SECONDARY) &&
-	    !debug_tweak_on("XFS_SCRUB_FORCE_REPAIR")) {
-		if (difficulty & REPAIR_DIFFICULTY_PRIMARY)
-			str_info(ctx, descr,
-_("Corrupt primary and secondary block mapping metadata."));
-		else
-			str_info(ctx, descr,
-_("Corrupt secondary block mapping metadata."));
-		str_info(ctx, descr,
-_("Filesystem might not be repairable."));
-	}
+	warn_repair_difficulties(ctx, difficulty, descr);
 
 	/* Repair (inode) btree damage. */
 	ret = action_list_process_or_defer(ctx, agno, &immediate_alist);
@@ -115,6 +123,7 @@ scan_metafile(
 	struct action_list	alist;
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	struct scan_ctl		*sctl = arg;
+	unsigned int		difficulty;
 	int			ret;
 
 	if (sctl->aborted)
@@ -127,6 +136,10 @@ scan_metafile(
 		goto out;
 	}
 
+	/* Complain about metadata corruptions that might not be fixable. */
+	difficulty = action_list_difficulty(&alist);
+	warn_repair_difficulties(ctx, difficulty, xfrog_scrubbers[type].descr);
+
 	action_list_defer(ctx, 0, &alist);
 
 out:

