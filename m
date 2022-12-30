Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB5AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235581AbiLaAZR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiLaAZP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:25:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DD8BE0E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:25:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0902B81E9C
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A48C433D2;
        Sat, 31 Dec 2022 00:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446311;
        bh=wM0R60c26tmu4gww3eOyZ9giivZ7UCi/NOpyCHjqbJk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mvydeZKGPchh2diB1/bTGF6NZBMbIPOo+EaEmDuSHRYMPj9A04NXSDnq9hTHqoJhZ
         s4j3P9kIwWkJjH1y3M9atcXBuvQ993m8l2KRZPKFTBiq2Ch7rG+SWY7KUY1Xg4Hifq
         C2RPxBeCv5UO2mBZBMHS+Q509rp4pbtj1jeViTkkFY54ekm0QSsa5sDkxWA8gOMPlY
         ICZ602y5LPbojRy9H+bmWI2ZYvL8YqNEt9XS5iSBCkb2odwo66c5ZPX+6xkGvGt5qD
         VTHKCXrAeG/GilvONUcvbvyyIvPmVQzWg0n9dBFP9//P5AVwX0sMj7DVHeyhT5xrOM
         um1FThItFn4lA==
Subject: [PATCH 4/6] xfs_scrub: log when a repair was unnecessary
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:10 -0800
Message-ID: <167243869077.714771.263719638960610884.stgit@magnolia>
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

If the kernel tells us that a filesystem object didn't need repairs, we
should log that with a message specific to that outcome.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/scrub/repair.c b/scrub/repair.c
index a6fbdcb638d..1ca8331bb04 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -165,6 +165,10 @@ _("Read-only filesystem; cannot make changes."));
  _("Seems correct but cross-referencing failed; will keep checking."));
 			return CHECK_RETRY;
 		}
+	} else if (meta.sm_flags & XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED) {
+		if (verbose)
+			str_info(ctx, descr_render(&dsc),
+					_("No modification needed."));
 	} else {
 		/* Clean operation, no corruption detected. */
 		if (needs_repair(&oldm))

