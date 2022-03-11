Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4FDCC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Mar 2022 03:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345818AbiCKDGi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Mar 2022 22:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238895AbiCKDGh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Mar 2022 22:06:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B1819BE7E
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 19:05:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92C5E61314
        for <linux-xfs@vger.kernel.org>; Fri, 11 Mar 2022 03:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E80C340E8;
        Fri, 11 Mar 2022 03:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646967935;
        bh=L5B8ZnDZX8GpNMhJpr3MBLEK8G3uiH2N8TTVe5WzQKM=;
        h=Date:From:To:Cc:Subject:From;
        b=MO+nNIk6OAg//Js5s7L029qgv84lDsqVMdUv4mAE+RYsJtVYTngQTHo7QmNG7Enls
         7MsK1SAV6bK4jIWAlkoaDHTKArkU6qunqFpwGuQ0GNC+aChHfBd1H6W7qDwMrRioOE
         CyvD7uoqW0OheVdLJHoLgzUqfpiUpqvr//I+jCEiSK1L+0dFrQOsUX21vQdTj+KiTb
         wmZAoO0kA41ZsH+gmKNPfMWZx/EHwTtAQfbVyGRXqaAku/hlAE+Ul1dHYHDA3yXHJR
         rUzSD3YyvoDrl2tBBKOEU37SGEBbZwB40hduFDJV2T5fCI0sgpC7rilTxijP88opCy
         FvH24qBULFKMA==
Date:   Thu, 10 Mar 2022 19:05:34 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_scrub: fix xfrog_scrub_metadata error reporting
Message-ID: <20220311030534.GK8224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Commit de5d20ec converted xfrog_scrub_metadata to return negative error
codes directly, but forgot to fix up the str_errno calls to use
str_liberror.  This doesn't result in incorrect error reporting
currently, but (a) the calls in the switch statement are inconsistent,
and (b) this will matter in future patches where we can call library
functions in between xfrog_scrub_metadata and str_liberror.

Fixes: de5d20ec ("libfrog: convert scrub.c functions to negative error codes")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/scrub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scrub/scrub.c b/scrub/scrub.c
index a4b7084e..07ae0673 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -153,7 +153,7 @@ _("Filesystem is shut down, aborting."));
 	case EIO:
 	case ENOMEM:
 		/* Abort on I/O errors or insufficient memory. */
-		str_errno(ctx, descr_render(&dsc));
+		str_liberror(ctx, error, descr_render(&dsc));
 		return CHECK_ABORT;
 	case EDEADLOCK:
 	case EBUSY:
@@ -164,10 +164,10 @@ _("Filesystem is shut down, aborting."));
 		 * and the other two should be reported via sm_flags.
 		 */
 		str_liberror(ctx, error, _("Kernel bug"));
-		fallthrough;
+		return CHECK_DONE;
 	default:
 		/* Operational error. */
-		str_errno(ctx, descr_render(&dsc));
+		str_liberror(ctx, error, descr_render(&dsc));
 		return CHECK_DONE;
 	}
 
