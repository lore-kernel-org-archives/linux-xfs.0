Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B554EC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Mar 2022 16:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245481AbiCTQpA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 20 Mar 2022 12:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235794AbiCTQo7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Mar 2022 12:44:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AF61EC47
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 09:43:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE3B2611D7
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 16:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34658C340E9;
        Sun, 20 Mar 2022 16:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647794613;
        bh=h3J2UAvxa/RMxmLj87DQOvxWl4GPw0quH2H0bR1+iVQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=d59mBz1zWXZSYFP2y/SVUALuL3TShWkPeuY7B33xIMQotbGsxE8WmHyUyx2Z5IPQL
         VpXTdl4LbPVI2muCqQqcmN++J7ujmpafXLJaTAhwabMGn/Xh6Gg0jVFtj/OZEU8aXs
         f+OwD2RNkdMBsgEtW4ZcNoosEeRhNvCsX1sc4sbm6LKbb/sCfmbJJFd/vcIXXC1+2i
         5th4NGHDW30EGRcd/vvhX2FX5YwSke/ruEvYvFaXQMNRnuaIft7ZWivZrRce1+NN3r
         V9iFGhtijHpZEHNazv2iSkOZmO9GTp44CLTJx6GMiYJLKvzCZh9K0ZNaa1oMu23yvb
         Yp2nM0Gpm+2vQ==
Subject: [PATCH 1/6] xfs: document the XFS_ALLOC_AGFL_RESERVE constant
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com, david@fromorbit.com
Date:   Sun, 20 Mar 2022 09:43:32 -0700
Message-ID: <164779461278.550479.17511700626088235894.stgit@magnolia>
In-Reply-To: <164779460699.550479.5112721232994728564.stgit@magnolia>
References: <164779460699.550479.5112721232994728564.stgit@magnolia>
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c |   23 ++++++++++++++++++-----
 fs/xfs/libxfs/xfs_alloc.h |    1 -
 2 files changed, 18 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 353e53b892e6..b0678e96ce61 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -82,6 +82,19 @@ xfs_prealloc_blocks(
 }
 
 /*
+ * The number of blocks per AG that we withhold from xfs_mod_fdblocks to
+ * guarantee that we can refill the AGFL prior to allocating space in a nearly
+ * full AG.  We require two blocks per free space btree because free space
+ * btrees shrink to a single block as the AG fills up, and any allocation can
+ * cause a btree split.  The rmap btree uses a per-AG reservation to withhold
+ * space from xfs_mod_fdblocks, so we do not account for that here.
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
@@ -93,14 +106,14 @@ xfs_prealloc_blocks(
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
@@ -124,12 +137,12 @@ xfs_alloc_ag_max_usable(
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
 

