Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CD1AC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Mar 2022 23:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351007AbiCOXY2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 19:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352559AbiCOXY1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 19:24:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69F91FA4F
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 16:23:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83B3C6135C
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 23:23:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29C8C340F4;
        Tue, 15 Mar 2022 23:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647386593;
        bh=TuyVKCQM5PhxV18HTljxdhGDPuvo7csvLOoFyBQnIyA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ow8IMx/CgRQVnuvh5PBZNLS3npQFefSKzLAfW0dQbEvbxs747o+jQJBSyBUJ90dQq
         w+0V2axJI7eHp+3HpwJL/ocTiDouXvGI+fep5eQFnrtgViDJQaJhDjN9dNViQuAvnT
         WIQbFfzx8yiL9tAKcTfocy1VpCvvTxgcj0cnIFDDkCJiZou3dwUR4GVRjLbWxXuR2v
         ZDG68mSkl0sV3/b5jmk5oTeW3A/HzRCko3L05py48cb8ip7IFIjTgc17Dy3HTB4dGl
         OGwbz7rf++eLIpbtr+axnu3DN14g1j0LXRDXy7cbzc5cHao/9BSM7KlU4uD5hEFwwl
         4Yfl45TLwX14g==
Subject: [PATCH 1/2] xfs_scrub: fix xfrog_scrub_metadata error reporting
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Date:   Tue, 15 Mar 2022 16:23:13 -0700
Message-ID: <164738659344.3191772.10477029754314882992.stgit@magnolia>
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
 

