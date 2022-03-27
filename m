Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F29C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Mar 2022 16:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiC0RA1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Mar 2022 13:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236083AbiC0RA0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Mar 2022 13:00:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84311AD8D
        for <linux-xfs@vger.kernel.org>; Sun, 27 Mar 2022 09:58:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4D7460FD6
        for <linux-xfs@vger.kernel.org>; Sun, 27 Mar 2022 16:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EB3C340EC;
        Sun, 27 Mar 2022 16:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648400325;
        bh=JTwgFIAhV2X0DpPX0KyKce65BHNG9txpFzj81lrYbiQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Uaj2W+LxTE1RwgA/Y4b9zLQ21N/DlpiIzU8kvVTQxPeTQmw/AwxsPErjWCIGY/V6Q
         A8YEaceYaPe0oWOjmdFtPIs4jY5sd5IFrQb0Iiswk1Ws5QRLWs4LYoGDiAOQRcWxI4
         Vo7W9cN9x4312QXAsTa1KeAN1W0pKVKhZwSi7sXCxhawyErEjfOQ2YNtegQZAP0Zoc
         SYLD18AdqmiBwjL7ysZYFlHtzyJqODJ02puGp+Falot8ukt+gXpkWPOD7YzcET7IfV
         HUFl4lrqU4BrnAi0Gm7dQobvAHVDtLMe1DCeL5qPSN4yxUCOvi68OWy1/KB54BZvzx
         y5GI0WTSdyNlA==
Subject: [PATCH 5/6] xfs: fix overfilling of reserve pool
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com, david@fromorbit.com
Date:   Sun, 27 Mar 2022 09:58:44 -0700
Message-ID: <164840032479.54920.10404960270844945481.stgit@magnolia>
In-Reply-To: <164840029642.54920.17464512987764939427.stgit@magnolia>
References: <164840029642.54920.17464512987764939427.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Due to cycling of m_sb_lock, it's possible for multiple callers of
xfs_reserve_blocks to race at changing the pool size, subtracting blocks
from fdblocks, and actually putting it in the pool.  The result of all
this is that we can overfill the reserve pool to hilarious levels.

xfs_mod_fdblocks, when called with a positive value, already knows how
to take freed blocks and either fill the reserve until it's full, or put
them in fdblocks.  Use that instead of setting m_resblks_avail directly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 5c2bea1e12a8..5b5b68affe66 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -448,18 +448,17 @@ xfs_reserve_blocks(
 		 * count or we'll get an ENOSPC.  Don't set the reserved flag
 		 * here - we don't want to reserve the extra reserve blocks
 		 * from the reserve.
+		 *
+		 * The desired reserve size can change after we drop the lock.
+		 * Use mod_fdblocks to put the space into the reserve or into
+		 * fdblocks as appropriate.
 		 */
 		fdblks_delta = min(free, delta);
 		spin_unlock(&mp->m_sb_lock);
 		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
-		spin_lock(&mp->m_sb_lock);
-
-		/*
-		 * Update the reserve counters if blocks have been successfully
-		 * allocated.
-		 */
 		if (!error)
-			mp->m_resblks_avail += fdblks_delta;
+			xfs_mod_fdblocks(mp, fdblks_delta, 0);
+		spin_lock(&mp->m_sb_lock);
 	}
 out:
 	if (outval) {

