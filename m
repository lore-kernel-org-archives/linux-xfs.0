Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46D17C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Mar 2022 16:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245495AbiCTQpL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 20 Mar 2022 12:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245490AbiCTQpL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Mar 2022 12:45:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4F5245BE
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 09:43:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 10F07CE122F
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 16:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502C9C340E9;
        Sun, 20 Mar 2022 16:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647794624;
        bh=8WSjLZt1fIou1K9zmRIeKmtzDR6Ed4YslVo1cDynNPg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=b2QQDVpymNmSJA+bMByRpc52z+y3HKsZvT2YNDdMelu8+3pWNWPqCTHTMJWQjrjmQ
         7fZU/TBEPFqJygNJqgMDSK0KLX69pw3NasCKc+wPvp5KmIR7DISpk4QvY47m2iNen/
         CiYCcF4WT95gmD2iWvgwYRQ5TSrACPMlS0g9EEPA5z0DOzPsFg7ezAu4RWYmOscyN8
         LN76GJ5rPLII1sUqmahjC47ZsO3tEA6Qfe4BsYNaI5MF5QagvTR1r9i+TgaoHX+5eI
         fMgUdhfxMByJWTNEV+s9jArHatLAY5JqHFR+rsDGywvDdExuhe0FDIA2yObuP6xUc0
         xnFFdGeAxWyVw==
Subject: [PATCH 3/6] xfs: don't include bnobt blocks when reserving free block
 pool
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com, david@fromorbit.com
Date:   Sun, 20 Mar 2022 09:43:43 -0700
Message-ID: <164779462392.550479.11627083041484347485.stgit@magnolia>
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
 fs/xfs/xfs_fsops.c |    2 +-
 fs/xfs/xfs_mount.c |    2 +-
 fs/xfs/xfs_mount.h |   15 +++++++++++++++
 3 files changed, 17 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 33e26690a8c4..710e857bb825 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -434,7 +434,7 @@ xfs_reserve_blocks(
 	error = -ENOSPC;
 	do {
 		free = percpu_counter_sum(&mp->m_fdblocks) -
-						mp->m_alloc_set_aside;
+						xfs_fdblocks_unavailable(mp);
 		if (free <= 0)
 			break;
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 4f8fac8175e8..c9fd5219d377 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1153,7 +1153,7 @@ xfs_mod_fdblocks(
 	 * problems (i.e. transaction abort, pagecache discards, etc.) than
 	 * slightly premature -ENOSPC.
 	 */
-	set_aside = mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
+	set_aside = xfs_fdblocks_unavailable(mp);
 	percpu_counter_add_batch(&mp->m_fdblocks, delta, batch);
 	if (__percpu_counter_compare(&mp->m_fdblocks, set_aside,
 				     XFS_FDBLOCKS_BATCH) >= 0) {
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 00720a02e761..da1b7056e743 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -479,6 +479,21 @@ extern void	xfs_unmountfs(xfs_mount_t *);
  */
 #define XFS_FDBLOCKS_BATCH	1024
 
+/*
+ * Estimate the amount of free space that is not available to userspace and is
+ * not explicitly reserved from the incore fdblocks:
+ *
+ * - Space reserved to ensure that we can always split a bmap btree
+ * - Free space btree blocks that are not available for allocation due to
+ *   per-AG metadata reservations
+ */
+static inline uint64_t
+xfs_fdblocks_unavailable(
+	struct xfs_mount	*mp)
+{
+	return mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
+}
+
 extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
 				 bool reserved);
 extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);

