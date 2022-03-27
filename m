Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36218C433F5
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Mar 2022 16:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236115AbiC0RAF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Mar 2022 13:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiC0RAF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Mar 2022 13:00:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D2CDF4C
        for <linux-xfs@vger.kernel.org>; Sun, 27 Mar 2022 09:58:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5119CB80D62
        for <linux-xfs@vger.kernel.org>; Sun, 27 Mar 2022 16:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA1FC340EC;
        Sun, 27 Mar 2022 16:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648400302;
        bh=LPPIN++7ATtVHOxUoH0/5XqTW5u3cbUZuA/g0jq9fl0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=h43/aBhXVBWAXyKOB+s56I1ezQnajiCJUnmf0k++GrgrKo2cNZQSyxCK89V5CKInE
         W2jPlKPX2vyQVViKv26Od4z1LNAxkiR4pJ5tR27rIDhD73Rg2LWeHvcbwbhl+/7E/s
         HLpyXSHcbGN0JFRua5FHTUUW39J0uGy7r70/rw2OaB+diYuHmy7mZ6M7LQv0KA5iGG
         gRMvC1dgrZDL5MIxk/Zp3D8wKKOv5rq3fPhUtBnSykx+8Ne9kiBF4s0vNkrzCUQ75W
         WM2GaeUJo7/ZltYdK0Gr5yOGjgbGo5U37hLvMitrADDZVAXw1nP+gGXNnDOQXY6TAh
         ozC+hYq8U+a5Q==
Subject: [PATCH 1/6] xfs: document the XFS_ALLOC_AGFL_RESERVE constant
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com, david@fromorbit.com
Date:   Sun, 27 Mar 2022 09:58:22 -0700
Message-ID: <164840030231.54920.7952660071015931236.stgit@magnolia>
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

Currently, we use this undocumented macro to encode the minimum number
of blocks needed to replenish a completely empty AGFL when an AG is
nearly full.  This has lead to confusion on the part of the maintainers,
so let's document what the value actually means, and move it to
xfs_alloc.c since it's not used outside of that module.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c |   28 +++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_alloc.h |    1 -
 2 files changed, 23 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 353e53b892e6..b52ed339727f 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -82,6 +82,24 @@ xfs_prealloc_blocks(
 }
 
 /*
+ * The number of blocks per AG that we withhold from xfs_mod_fdblocks to
+ * guarantee that we can refill the AGFL prior to allocating space in a nearly
+ * full AG.  Although the the space described by the free space btrees, the
+ * blocks used by the freesp btrees themselves, and the blocks owned by the
+ * AGFL are counted in the ondisk fdblocks, it's a mistake to let the ondisk
+ * free space in the AG drop so low that the free space btrees cannot refill an
+ * empty AGFL up to the minimum level.  Rather than grind through empty AGs
+ * until the fs goes down, we subtract this many AG blocks from the incore
+ * fdblocks to ensure user allocation does not overcommit the space the
+ * filesystem needs for the AGFLs.  The rmap btree uses a per-AG reservation to
+ * withhold space from xfs_mod_fdblocks, so we do not account for that here.
+ */
+#define XFS_ALLOCBT_AGFL_RESERVE	4
+
+/*
+ * Compute the number of blocks that we set aside to guarantee the ability to
+ * refill the AGFL and handle a full bmap btree split.
+ *
  * In order to avoid ENOSPC-related deadlock caused by out-of-order locking of
  * AGF buffer (PV 947395), we place constraints on the relationship among
  * actual allocations for data blocks, freelist blocks, and potential file data
@@ -93,14 +111,14 @@ xfs_prealloc_blocks(
  * extents need to be actually allocated. To get around this, we explicitly set
  * aside a few blocks which will not be reserved in delayed allocation.
  *
- * We need to reserve 4 fsbs _per AG_ for the freelist and 4 more to handle a
- * potential split of the file's bmap btree.
+ * For each AG, we need to reserve enough blocks to replenish a totally empty
+ * AGFL and 4 more to handle a potential split of the file's bmap btree.
  */
 unsigned int
 xfs_alloc_set_aside(
 	struct xfs_mount	*mp)
 {
-	return mp->m_sb.sb_agcount * (XFS_ALLOC_AGFL_RESERVE + 4);
+	return mp->m_sb.sb_agcount * (XFS_ALLOCBT_AGFL_RESERVE + 4);
 }
 
 /*
@@ -124,12 +142,12 @@ xfs_alloc_ag_max_usable(
 	unsigned int		blocks;
 
 	blocks = XFS_BB_TO_FSB(mp, XFS_FSS_TO_BB(mp, 4)); /* ag headers */
-	blocks += XFS_ALLOC_AGFL_RESERVE;
+	blocks += XFS_ALLOCBT_AGFL_RESERVE;
 	blocks += 3;			/* AGF, AGI btree root blocks */
 	if (xfs_has_finobt(mp))
 		blocks++;		/* finobt root block */
 	if (xfs_has_rmapbt(mp))
-		blocks++; 		/* rmap root block */
+		blocks++;		/* rmap root block */
 	if (xfs_has_reflink(mp))
 		blocks++;		/* refcount root block */
 
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 1c14a0b1abea..d4c057b764f9 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -88,7 +88,6 @@ typedef struct xfs_alloc_arg {
 #define XFS_ALLOC_NOBUSY		(1 << 2)/* Busy extents not allowed */
 
 /* freespace limit calculations */
-#define XFS_ALLOC_AGFL_RESERVE	4
 unsigned int xfs_alloc_set_aside(struct xfs_mount *mp);
 unsigned int xfs_alloc_ag_max_usable(struct xfs_mount *mp);
 

