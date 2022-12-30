Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC85C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:24:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbiLaAY3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiLaAY3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:24:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95029BE0E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:24:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FBB5B81E99
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153EEC433EF;
        Sat, 31 Dec 2022 00:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446265;
        bh=phkSImHAqApCt9RyrgXNUa3NTNw6dntsxrfRGnqtYsA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fpiJwZPcmA/mel13f2N+lpnod8eg6GfGcUWdosqMbDs6hQIztyQXKzq6xZseM/f8X
         m/Q5PHifGP/6HlPg+otEjvn8bxrz9QuClc9v+tsmpvCCP0yN4X+2ysdrqTZUEO5fKG
         RM9spNIbPBK4MSZ9hpslBHyANHtZe3iS8y8B8gH09nJDnS2M9G3mnJiXLmUVLLUE0s
         dsHHt6geaEtY9A8GYDchGGudaGar2k4lIVPZ7zmunMWpVS2ySGKSGPUJ2RXOWyUy+0
         +Jf3OsobECk1qU1iOIODI10M0NYy+9rAz7Rt7QQuhaPObqpE0B1nKYj16jqLCsiVHO
         Vkc6PC862UCsQ==
Subject: [PATCH 1/6] xfs_scrub: don't report media errors for space with
 unknowable owner
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:10 -0800
Message-ID: <167243869037.714771.16498518334442187393.stgit@magnolia>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase6.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index afdb16b689c..1a2643bdaf0 100644
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

