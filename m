Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B64DC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjBPVBx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjBPVBw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:01:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCB7528B7
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:01:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D4DB60C69
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC00C433EF;
        Thu, 16 Feb 2023 21:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581310;
        bh=SDCH4xNH1104nGicDC3U5cXSbbaLc3IomO7ExFQX2MA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=HG0+Gy8kwgP3xahu6IoNdcmVB2sAMsFKcVamtTBGeQc93jLzKOtVUwk/0YUsqjDdk
         DeIY7oN9fJFwE/0Q/IFGjdg4OMtylwuccoW4pz4UCSctunXAK+Pei/BbFEpNobzWww
         ipznyfR1pGvqPitK8f1l4DqkCANpZyGRZm6l8Qu/XEMwKC5HwnLlAdgRF7qGM0RoaY
         hQvERpF1a1cdYfSA6jpz6k3knUM0Eo0S5cMWRlfO0KOJmq3Xp8fPTnIrRiMpmkfdeK
         r0mINxG3ASe9CdHNsPZE4jtHhZdpP25LS91MYnHfhpU0ichXSpjnSsiAFdyCgd9tgE
         Bov4Uy269fL6A==
Date:   Thu, 16 Feb 2023 13:01:50 -0800
Subject: [PATCH 1/6] xfs_scrub: don't report media errors for space with
 unknowable owner
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879909.3476911.18047241575255398541.stgit@magnolia>
In-Reply-To: <167657879895.3476911.2211427543938389071.stgit@magnolia>
References: <167657879895.3476911.2211427543938389071.stgit@magnolia>
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
This fixes regressions reported by xfs/556.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase6.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index afdb16b6..1a2643bd 100644
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

