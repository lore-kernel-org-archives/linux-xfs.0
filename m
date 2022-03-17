Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 241C6C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 21:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiCQVWc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Mar 2022 17:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiCQVWb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 17:22:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A2B18BCC4
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 14:21:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33F2361A07
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 21:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E2FC340E9;
        Thu, 17 Mar 2022 21:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647552072;
        bh=D6dayoFRYb50KIYzsJT1a/6o0h6/QkVagz9Un/TC+e8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=t+8/nyG+psc34OAF/o6mI5fuTK+a17TEn7MLiRirs+weRX/8A2+F/faRQ/47Bzfk/
         C9DGUxDUlvPP1Gsk/pjDR1RlkFg+m5rGhzfsUrzfgh2Vql0jp4468L6ZCK7YE+epRJ
         BpWA3uQGf/K/K1Uj5MguGWhrVHUxS+wyHJQLD6aSGl/F+WY2ZYcfWuNJuXK9qhG1qY
         IXjSmYNgmtKQtTeE/vHf4OasTX0w+yDqML8NPnVfvhBtnj3hUskYUm/bf4JKb6mDfI
         LiPn0ipJQQnJe/NCYV7BHR306sZFevHDRgbF9oOGVuS/cNnj0C7FeEP8Sc2Jf/tgEY
         wj6WSYeHuiI+Q==
Subject: [PATCH 3/6] xfs: don't include bnobt blocks when reserving free block
 pool
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com, david@fromorbit.com
Date:   Thu, 17 Mar 2022 14:21:12 -0700
Message-ID: <164755207216.4194202.19795257360716142.stgit@magnolia>
In-Reply-To: <164755205517.4194202.16256634362046237564.stgit@magnolia>
References: <164755205517.4194202.16256634362046237564.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

Fix this by creating a function to estimate the number of blocks that
can be reserved from fdblocks, which needs to exclude the set-aside and
m_allocbt_blks.

Found by running xfs/306 (which formats a single-AG 20MB filesystem)
with an fstests configuration that specifies a 1k blocksize and a
specially crafted log size that will consume 7/8 of the space (17920
blocks, specifically) in that AG.

Cc: Brian Foster <bfoster@redhat.com>
Fixes: fd43cf600cf6 ("xfs: set aside allocation btree blocks from block reservation")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c |    7 +++++--
 fs/xfs/xfs_mount.h |   29 +++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 33e26690a8c4..b71799a3acd3 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -433,8 +433,11 @@ xfs_reserve_blocks(
 	 */
 	error = -ENOSPC;
 	do {
-		free = percpu_counter_sum(&mp->m_fdblocks) -
-						mp->m_alloc_set_aside;
+		/*
+		 * The reservation pool cannot take space that xfs_mod_fdblocks
+		 * will not give us.
+		 */
+		free = xfs_fdblocks_available(mp);
 		if (free <= 0)
 			break;
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 00720a02e761..998b54c3c454 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -479,6 +479,35 @@ extern void	xfs_unmountfs(xfs_mount_t *);
  */
 #define XFS_FDBLOCKS_BATCH	1024
 
+/*
+ * Estimate the amount of space that xfs_mod_fdblocks might give us without
+ * drawing from the reservation pool.  In other words, estimate the free space
+ * that is available to userspace.
+ *
+ * This quantity is the amount of free space tracked in the on-disk metadata
+ * minus:
+ *
+ * - Delayed allocation reservations
+ * - Per-AG space reservations to guarantee metadata expansion
+ * - Userspace-controlled free space reserve pool
+ *
+ * - Space reserved to ensure that we can always split a bmap btree
+ * - Free space btree blocks that are not available for allocation due to
+ *   per-AG metadata reservations
+ *
+ * The first three are captured in the incore fdblocks counter.
+ */
+static inline int64_t
+xfs_fdblocks_available(
+	struct xfs_mount	*mp)
+{
+	int64_t			free = percpu_counter_sum(&mp->m_fdblocks);
+
+	free -= mp->m_alloc_set_aside;
+	free -= atomic64_read(&mp->m_allocbt_blks);
+	return free;
+}
+
 extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
 				 bool reserved);
 extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);

