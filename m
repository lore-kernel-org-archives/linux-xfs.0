Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE805C6FD20
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Mar 2023 23:34:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjCUXe0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Mar 2023 19:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjCUXe0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Mar 2023 19:34:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3254729155
        for <linux-xfs@vger.kernel.org>; Tue, 21 Mar 2023 16:34:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFAB361A43
        for <linux-xfs@vger.kernel.org>; Tue, 21 Mar 2023 23:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176D7C433D2;
        Tue, 21 Mar 2023 23:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679441664;
        bh=M78d7JknLpnAsSgzluVGP9ytkfCc2Drk6IW+aBmIUlM=;
        h=Date:From:To:Cc:Subject:From;
        b=KqYUDdoWqrbGMMTks39nDt9x2FsExWhvJ+MAHF4kKbpDb5FZbdM5aAOXrwfbupGfB
         fThg92VGpPcr6TbgYXoCgWRa/IY3YsxEtU4U5loVvvfyWD4f+Vxa9onZwSGsuV7DqP
         XceWbF+btxBaqGVNgEcC9dbKWTh+NCkLmulvEzADu0TRtiGNWzWsYSKb2FH/MKz4HV
         LBUio9XsS88vI4aIc1B4LcMKKcNKyNrK0T2fi48uxN1gd6o1h+ZZB05q7SM9gh4VI7
         yVGXcglxx3lI4k0LuSHstEyZRdIcC97+3CtTuH36CcOcSH4/PQGQZcZLUYrcupsL5S
         iPxk7YWgDjFLg==
Date:   Tue, 21 Mar 2023 16:34:23 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: clear incore AGFL_RESET state if it's not needed
Message-ID: <20230321233423.GC11376@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Prior to commit 7ac2ff8bb371, when we loaded the incore perag structure
with information from the AGF header, we would set or clear the
pagf_agfl_reset field based on whether or not the AGFL list was
misaligned within the block.  IOWs, it's an incore state bit that's
supposed to cache something in the ondisk metadata.  Therefore, the code
still needs to support clearing the incore bit if (somehow) the AGFL
were to correct itself.

It turns out that xfs_repair does exactly this -- phase 4 loads the AGF
to scan the rmapbt for corrupt records, which can set NEEDS_AGFL_RESET.
The scan unsets AGF_INIT but doesn't unset NEEDS_AGFL_RESET.  Phase 5
totally rewrites the AGFL and fixes the alignment problem, didn't clear
NEEDS_AGFL_RESET historically, and reloads the perag state to fix the
freelist.  This results in the AGFL being reset based on stale data,
which then causes the new AGFL blocks to be leaked.  A subsequent
xfs_repair -n then complains about the leaks.

One could argue that phase 5 ought to clear this bit directly when it
reloads the perag AGF data after rewriting the AGFL, but libxfs used to
handle this for us, so it should go back to doing that.

Found by fuzzing flfirst = ones in xfs/352.

Fixes: 7ac2ff8bb371 ("xfs: perags need atomic operational state")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 55ae08a6144c..badc213384a4 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3045,6 +3045,8 @@ xfs_alloc_read_agf(
 		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
 		if (xfs_agfl_needs_reset(pag->pag_mount, agf))
 			set_bit(XFS_AGSTATE_AGFL_NEEDS_RESET, &pag->pag_opstate);
+		else
+			clear_bit(XFS_AGSTATE_AGFL_NEEDS_RESET, &pag->pag_opstate);
 
 		/*
 		 * Update the in-core allocbt counter. Filter out the rmapbt
