Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD3F1C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjEZBlu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234215AbjEZBlu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:41:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF0F18D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:41:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFDF464C19
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCEAC433D2;
        Fri, 26 May 2023 01:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065308;
        bh=6uOSWO8XASchu38XCdMSGEaPC4NymCxdY+tIy2HxCow=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=UMvbPmZbq5nBEb22bUpvI3a6vO4DCHjoMI0dQbCpi0bdhcOGiRH5yyEC4hs+Wps6p
         8UstfF7IjqyrRkduJ+NyWCnxt5nmsEexcEUCaOla+h5ILI7IByKS6z45pOLvGRFVEk
         ru/aBizRpOnVfEuH5fFJL5U4f0YqqE4Es8AW+0/SbJvg248gXtGKYFVZKrOokiesgP
         uDmuoh69AqMlars0Xyarv65RA1WNRG4Tg8YHo/9yWdTE8C+Wv5oGW9utaM+r4DVc94
         UAwtEnacm4am/jJ0DaUIMjf2afLkLA5GoIN/pwwMwD3rzWFFXW7q+T4hbgI1sYL4eD
         rnjaC3iBKSAlA==
Date:   Thu, 25 May 2023 18:41:47 -0700
Subject: [PATCH 5/7] xfs_scrub: log when a repair was unnecessary
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506071376.3742205.16215291270428569390.stgit@frogsfrogsfrogs>
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

If the kernel tells us that a filesystem object didn't need repairs, we
should log that with a message specific to that outcome.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/scrub/repair.c b/scrub/repair.c
index b6f1f4be0fb..3a10e4c67f9 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -167,6 +167,10 @@ _("Repair unsuccessful; offline repair required."));
  _("Seems correct but cross-referencing failed; will keep checking."));
 			return CHECK_RETRY;
 		}
+	} else if (meta.sm_flags & XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED) {
+		if (verbose)
+			str_info(ctx, descr_render(&dsc),
+					_("No modification needed."));
 	} else {
 		/* Clean operation, no corruption detected. */
 		if (is_corrupt(&oldm))

