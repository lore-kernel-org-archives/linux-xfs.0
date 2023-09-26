Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B26E7F150
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 01:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235103AbjI0Bx0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 21:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232164AbjI0BvZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 21:51:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F00D44B4
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:38:58 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378CFC433C8;
        Tue, 26 Sep 2023 23:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695771538;
        bh=ukvOwplUCnKY5B9lx6lK3vKRMyVou/wGzviOXwmfy9I=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=V2UEH4pCPn2QJlBPu8zsGRPEzGFVjNFrBTA4marEJJwbpK0Cdv3WMADP0S+gUwbDI
         J8/HbHCTa0cN9UY5888gQ5UCl7eCMdNxwp2O/GOIAB4UG4TTjGw2bYJeGuChfIxn2T
         LIAI9wKmSeSwr54yRw7SORjwEAZSokhsy7T+2HOF2GZjKiQCtfbryeV9RVm5ucUGzm
         f2DetqnxaYcFzi9beAXXkRuY57VcoWJSZeA3KRJiITqmQxlr5z2cqcfK5gFKX2WNuO
         caz/OP6Q+xnUoJREAfTHS/iUiMfYabz8/CtOZyy6F4zZHhu3aOWmJ4icaOfHNOMyYL
         hg+JtsqflGJZw==
Date:   Tue, 26 Sep 2023 16:38:57 -0700
Subject: [PATCH 3/4] xfs: always check the rtbitmap and rtsummary files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577061232.3315493.16915133401345350675.stgit@frogsfrogsfrogs>
In-Reply-To: <169577061183.3315493.6171012860982301231.stgit@frogsfrogsfrogs>
References: <169577061183.3315493.6171012860982301231.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

XFS filesystems always have a realtime bitmap and summary file, even if
there has never been a realtime volume attached.  Always check them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/scrub.c |    2 --
 1 file changed, 2 deletions(-)


diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index bc70a91f8b1bf..89ce6d2f9ad14 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -330,14 +330,12 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_FS,
 		.setup	= xchk_setup_rtbitmap,
 		.scrub	= xchk_rtbitmap,
-		.has	= xfs_has_realtime,
 		.repair	= xrep_notsupported,
 	},
 	[XFS_SCRUB_TYPE_RTSUM] = {	/* realtime summary */
 		.type	= ST_FS,
 		.setup	= xchk_setup_rtsummary,
 		.scrub	= xchk_rtsummary,
-		.has	= xfs_has_realtime,
 		.repair	= xrep_notsupported,
 	},
 	[XFS_SCRUB_TYPE_UQUOTA] = {	/* user quota */

