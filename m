Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCBCBC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjEZBv6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233833AbjEZBv6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:51:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D853189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:51:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C637364C3E
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32DDAC433EF;
        Fri, 26 May 2023 01:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065916;
        bh=2d+9p106mN0bS6FZ8X9Ba+GMTdZ2SrmU8dgpnogqyUU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=jwkCy2ze5ObbVjXmjGJaXx0ndeE1+fPNFzua+GedlrrR31WwER36xaMPGP40nAIjX
         M/zMUxHiF3uoSxRH2quTmllm6VjidEg5DqgPa1sgTbMMRhG8jI7EuBYF9wBgnDLV/t
         itOvZeCEzo3XBCFYZ5PGrlour/cZWht9OM/cI89EvYOuNAnYPIr5PI2Z9DkTxRI/lc
         8O41dzpW3fDKYuNhN4LYQTvRMj6PyrDYTgnp2eIXfjS8LkmCQqoVmIfBebLriJRw+F
         uuU5mRUSw79uDU9CP3qCoW/fA21FG9/BhgcZO6HmEAYO1dqFlrlyh3mw2k+JYH3mj4
         JIqx0VFp/d9Jg==
Date:   Thu, 25 May 2023 18:51:55 -0700
Subject: [PATCH 5/7] xfs_scrub: remove pointless spacemap.c arguments
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506073533.3745433.7207577103762464307.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073466.3745433.1072164718437572976.stgit@frogsfrogsfrogs>
References: <168506073466.3745433.1072164718437572976.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Remove unused parameters from the full-device spacemap scan functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/spacemap.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)


diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index 2c0b6d7bad1..4bac0ba48de 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -132,7 +132,6 @@ scan_ag_rmaps(
 static void
 scan_dev_rmaps(
 	struct scrub_ctx	*ctx,
-	int			idx,
 	dev_t			dev,
 	struct scan_blocks	*sbx)
 {
@@ -170,7 +169,7 @@ scan_rt_rmaps(
 {
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 
-	scan_dev_rmaps(ctx, agno, ctx->fsinfo.fs_rtdev, arg);
+	scan_dev_rmaps(ctx, ctx->fsinfo.fs_rtdev, arg);
 }
 
 /* Iterate all the reverse mappings of the log device. */
@@ -182,7 +181,7 @@ scan_log_rmaps(
 {
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 
-	scan_dev_rmaps(ctx, agno, ctx->fsinfo.fs_logdev, arg);
+	scan_dev_rmaps(ctx, ctx->fsinfo.fs_logdev, arg);
 }
 
 /*
@@ -210,8 +209,7 @@ scrub_scan_all_spacemaps(
 		return ret;
 	}
 	if (ctx->fsinfo.fs_rt) {
-		ret = -workqueue_add(&wq, scan_rt_rmaps,
-				ctx->mnt.fsgeom.agcount + 1, &sbx);
+		ret = -workqueue_add(&wq, scan_rt_rmaps, 0, &sbx);
 		if (ret) {
 			sbx.aborted = true;
 			str_liberror(ctx, ret, _("queueing rtdev fsmap work"));
@@ -219,8 +217,7 @@ scrub_scan_all_spacemaps(
 		}
 	}
 	if (ctx->fsinfo.fs_log) {
-		ret = -workqueue_add(&wq, scan_log_rmaps,
-				ctx->mnt.fsgeom.agcount + 2, &sbx);
+		ret = -workqueue_add(&wq, scan_log_rmaps, 0, &sbx);
 		if (ret) {
 			sbx.aborted = true;
 			str_liberror(ctx, ret, _("queueing logdev fsmap work"));

