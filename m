Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47507C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Mar 2022 18:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237561AbiCNSKB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Mar 2022 14:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbiCNSKB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Mar 2022 14:10:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FFDE007
        for <linux-xfs@vger.kernel.org>; Mon, 14 Mar 2022 11:08:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05DC6B80EDA
        for <linux-xfs@vger.kernel.org>; Mon, 14 Mar 2022 18:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72FA1C340E9;
        Mon, 14 Mar 2022 18:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647281327;
        bh=Xo1PbZquYHJ3DH/PvFXhEoZeT14Vcl0t9iRNiogpO9A=;
        h=Date:From:To:Cc:Subject:From;
        b=q8b81oVI5Ab0edZHIGs0L57vy3EZWptXn//7FmIoRb2dLiuxPH8/Ve8r02EAbCRRu
         hpbSm1KOVG5wlEwWkvAJveCz2wCe6HWH/30DMp1dazoVz5lW1hB+2bnmWN+PUx9qds
         G4A7rKr+OtlZUI1cAi/WoTsGxsJRhErkN3ftlIb5jspRZAxW0swPvlReG31M+jdAeq
         WbnS/HDEgs+d7/npA/SdgiXGCUA5uflEf+pRl/3wVty18PEsQKDL2cF7FfJaegblBo
         v1hwYIcYhuIB7OaJtL4ntZVT1glPouigxlw12WFEr7Xe/AAO6QG6hLm6pmPh+qM4xz
         AQStRi2zmGbng==
Date:   Mon, 14 Mar 2022 11:08:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: don't include bnobt blocks when reserving free block
 pool
Message-ID: <20220314180847.GM8224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

xfs_reserve_blocks controls the size of the user-visible free space
reserve pool.  Given the difference between the current and requested
pool sizes, it will try to reserve free space from fdblocks.  However,
the amount requested from fdblocks is also constrained by the amount of
space that we think xfs_mod_fdblocks will give us.  We'll keep trying to
reserve space so long as xfs_mod_fdblocks returns ENOSPC.

In commit fd43cf600cf6, we decided that xfs_mod_fdblocks should not hand
out the "free space" used by the free space btrees, because some portion
of the free space btrees hold in reserve space for future btree
expansion.  Unfortunately, xfs_reserve_blocks' estimation of the number
of blocks that it could request from xfs_mod_fdblocks was not updated to
include m_allocbt_blks, so if space is extremely low, the caller hangs.

Fix this by including m_allocbt_blks in the estimation, and modify the
loop so that it will not retry infinitely.

Found by running xfs/306 (which formats a single-AG 20MB filesystem)
with an fstests configuration that specifies a 1k blocksize and a
specially crafted log size that will consume 7/8 of the space (17920
blocks, specifically) in that AG.

Cc: Brian Foster <bfoster@redhat.com>
Fixes: fd43cf600cf6 ("xfs: set aside allocation btree blocks from block reservation")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 33e26690a8c4..78b6982ea5b0 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -379,6 +379,7 @@ xfs_reserve_blocks(
 	int64_t			fdblks_delta = 0;
 	uint64_t		request;
 	int64_t			free;
+	unsigned int		tries;
 	int			error = 0;
 
 	/* If inval is null, report current values and return */
@@ -432,9 +433,16 @@ xfs_reserve_blocks(
 	 * perform a partial reservation if the request exceeds free space.
 	 */
 	error = -ENOSPC;
-	do {
-		free = percpu_counter_sum(&mp->m_fdblocks) -
-						mp->m_alloc_set_aside;
+	for (tries = 0; tries < 30 && error == -ENOSPC; tries++) {
+		/*
+		 * The reservation pool cannot take space that xfs_mod_fdblocks
+		 * will not give us.  This includes the per-AG set-aside space
+		 * and free space btree blocks that are not available for
+		 * allocation due to per-AG metadata reservations.
+		 */
+		free = percpu_counter_sum(&mp->m_fdblocks);
+		free -= mp->m_alloc_set_aside;
+		free -= atomic64_read(&mp->m_allocbt_blks);
 		if (free <= 0)
 			break;
 
@@ -459,7 +467,7 @@ xfs_reserve_blocks(
 		spin_unlock(&mp->m_sb_lock);
 		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
 		spin_lock(&mp->m_sb_lock);
-	} while (error == -ENOSPC);
+	}
 
 	/*
 	 * Update the reserve counters if blocks have been successfully
