Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C8DFC7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:41:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbjEZBlE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234071AbjEZBlD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:41:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590DE199
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:41:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5F2064C19
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5496FC433EF;
        Fri, 26 May 2023 01:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065261;
        bh=/1JRnGrSJZdIHZRBabNl6IXJslnj1joZEn0I461EVkw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=IMK8GSaM+gx5xMjCI17aHGWld33YP3hUUVzfO798Oms3piGwZDFi+1Fx65GGPFanv
         GsLBFjlvY7B2MR9Fgh820FUc9K6Ag17OxRjE+UN+mY97czRMIaOua7vlswiFEe7XHN
         8g4KmdQmffNUuZG5TmC3Hp8msRjbRjg8LxeOu85mshqFZ+R3A1L/HsDYAC2+/bR82s
         gY879cQE4UBk9Zox/FXVtYrFJI4BGC5ICgZwcmUfxSeTqCG0J9Db1rZjIm8E1501U/
         35nTjZzCYIDhL7ZDAm8gwEHFr28VnGDRFnOtu1FuUCX03CaBXI7y64+3fCZ5L0n2Q7
         XtoV4cXgJ3r3A==
Date:   Thu, 25 May 2023 18:41:00 -0700
Subject: [PATCH 2/7] xfs_scrub: don't report media errors for space with
 unknowable owner
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506071341.3742205.3939386181294902605.stgit@frogsfrogsfrogs>
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

On filesystems that don't have the reverse mapping feature enabled, the
GETFSMAP call cannot tell us much about the owner of a space extent --
we're limited to static fs metadata, free space, or "unknown".  In this
case, nothing is corrupt, so str_corrupt is not an appropriate logging
function.  Relax this to str_info so that the user sees a notice that
media errors have been found so that the user knows something bad
happened even if the directory tree walker cannot find the file owning
the space where the media error was found.

Filesystems with rmap enabled are never supposed to return OWN_UNKNOWN
from a GETFSMAP report, so continue to report that as a corruption.
This fixes a regression in xfs/556.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase6.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index 8aba630dcca..c52d0f1a445 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -397,7 +397,18 @@ report_ioerr_fsmap(
 		snprintf(buf, DESCR_BUFSZ, _("disk offset %"PRIu64),
 				(uint64_t)map->fmr_physical + err_off);
 		type = decode_special_owner(map->fmr_owner);
-		str_corrupt(ctx, buf, _("media error in %s."), type);
+		/*
+		 * On filesystems that don't store reverse mappings, the
+		 * GETFSMAP call returns OWNER_UNKNOWN for allocated space.
+		 * We'll have to let the directory tree walker find the file
+		 * that lost data.
+		 */
+		if (!(ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_RMAPBT) &&
+		    map->fmr_owner == XFS_FMR_OWN_UNKNOWN) {
+			str_info(ctx, buf, _("media error detected."));
+		} else {
+			str_corrupt(ctx, buf, _("media error in %s."), type);
+		}
 	}
 
 	/* Report extent maps */

