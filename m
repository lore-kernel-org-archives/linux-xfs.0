Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE84FC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Mar 2022 16:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245485AbiCTQpD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 20 Mar 2022 12:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235794AbiCTQpD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Mar 2022 12:45:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B301EECE
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 09:43:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F192611D8
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 16:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88E2C340E9;
        Sun, 20 Mar 2022 16:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647794618;
        bh=odfhJVAYytYIIPFF/3AOEtSPXA91jUqkZiK1PWjE/80=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=K9KSQVquZiPmZnjbHcU9n4jPgTlt3NNadoZ1QZc3BjBR9s+sgEUrYFd8RZDRvs9Ou
         UI4mgH5od4s3FDEm3Th8wevRK+rRm7UiKsC10OHYK4H1Dcu4vEYH7X1mTVlBCZoAOj
         ixHyGTVuPRmEdx3/LuhUJiNwd8jJzyblj9LSVChNjLf/63wTeL5ar+axur2VNdfARV
         R+moqy9e+6V9eqsd+hOe5iEKItHlbX9KDUbnYOxlPuQ4iJebo0XLuUdkh1esVVYk02
         YcFku9I45q+OI3z0KnbmrryBLNO0hTX3HQQBUyIFaTbsyWeU7oHhxosST5KDn8y89e
         LZl0oWp5E9ozg==
Subject: [PATCH 2/6] xfs: actually set aside enough space to handle a bmbt
 split
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com, david@fromorbit.com
Date:   Sun, 20 Mar 2022 09:43:38 -0700
Message-ID: <164779461835.550479.15316047141170352189.stgit@magnolia>
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

The comment for xfs_alloc_set_aside indicates that we want to set aside
enough space to handle a bmap btree split.  The code, unfortunately,
hardcodes this to 4.

This is incorrect, since file bmap btrees can be taller than that:

xfs_db> btheight bmapbt -n 4294967295 -b 512
bmapbt: worst case per 512-byte block: 13 records (leaf) / 13 keyptrs (node)
level 0: 4294967295 records, 330382100 blocks
level 1: 330382100 records, 25414008 blocks
level 2: 25414008 records, 1954924 blocks
level 3: 1954924 records, 150379 blocks
level 4: 150379 records, 11568 blocks
level 5: 11568 records, 890 blocks
level 6: 890 records, 69 blocks
level 7: 69 records, 6 blocks
level 8: 6 records, 1 block
9 levels, 357913945 blocks total

Or, for V5 filesystems:

xfs_db> btheight bmapbt -n 4294967295 -b 1024
bmapbt: worst case per 1024-byte block: 29 records (leaf) / 29 keyptrs (node)
level 0: 4294967295 records, 148102321 blocks
level 1: 148102321 records, 5106977 blocks
level 2: 5106977 records, 176103 blocks
level 3: 176103 records, 6073 blocks
level 4: 6073 records, 210 blocks
level 5: 210 records, 8 blocks
level 6: 8 records, 1 block
7 levels, 153391693 blocks total

Fix this by using the actual bmap btree maxlevel value for the
set-aside.  We subtract one because the root is always in the inode and
hence never splits.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c |    7 +++++--
 fs/xfs/libxfs/xfs_sb.c    |    2 --
 fs/xfs/xfs_mount.c        |    7 +++++++
 3 files changed, 12 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index b0678e96ce61..747b3e45303f 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -107,13 +107,16 @@ xfs_prealloc_blocks(
  * aside a few blocks which will not be reserved in delayed allocation.
  *
  * For each AG, we need to reserve enough blocks to replenish a totally empty
- * AGFL and 4 more to handle a potential split of the file's bmap btree.
+ * AGFL and enough to handle a potential split of a file's bmap btree.
  */
 unsigned int
 xfs_alloc_set_aside(
 	struct xfs_mount	*mp)
 {
-	return mp->m_sb.sb_agcount * (XFS_ALLOCBT_AGFL_RESERVE + 4);
+	unsigned int		bmbt_splits;
+
+	bmbt_splits = max(mp->m_bm_maxlevels[0], mp->m_bm_maxlevels[1]) - 1;
+	return mp->m_sb.sb_agcount * (XFS_ALLOCBT_AGFL_RESERVE + bmbt_splits);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index f4e84aa1d50a..b823beb944e4 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -887,8 +887,6 @@ xfs_sb_mount_common(
 	mp->m_refc_mnr[1] = mp->m_refc_mxr[1] / 2;
 
 	mp->m_bsize = XFS_FSB_TO_BB(mp, 1);
-	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
-	mp->m_ag_max_usable = xfs_alloc_ag_max_usable(mp);
 }
 
 /*
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index bed73e8002a5..4f8fac8175e8 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -652,6 +652,13 @@ xfs_mountfs(
 
 	xfs_agbtree_compute_maxlevels(mp);
 
+	/*
+	 * Compute the amount of space to set aside to handle btree splits near
+	 * ENOSPC now that we have calculated the btree maxlevels.
+	 */
+	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
+	mp->m_ag_max_usable = xfs_alloc_ag_max_usable(mp);
+
 	/*
 	 * Check if sb_agblocks is aligned at stripe boundary.  If sb_agblocks
 	 * is NOT aligned turn off m_dalign since allocator alignment is within

