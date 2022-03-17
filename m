Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F239C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 21:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbiCQVWv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Mar 2022 17:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiCQVWu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 17:22:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBE518CD0E
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 14:21:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4764B81F99
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 21:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D627C340E9;
        Thu, 17 Mar 2022 21:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647552089;
        bh=dft4arDD07v/10nEhf8kCYdwhr9W0yjuafjq9Bx98vE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Sbl4E6rN35RBfNf972KpPvq8Bf6FFtzLpoCmuKHwpYWVsk2fhOnWh1JZWKhuodbiH
         ptIrrIybVT3ctlYqivdhdjCiW3Y0eG0IxQ/uIK28i5BBCswPg5A/S7/uTHZPUL3EDc
         ME+Fhyp/Y3npkzw4IoKkbsxO8QJxtf9UyAO1kCLR1l+3O8FjSXQ0ihX3Yrkr0tBHmJ
         JpQ6RY+om4ODTymrII18zlTUNB0vZ8SVYLExIVgadt5nzQGz3o5p/2LhWy0DNsDceF
         14phZv0NvP+Vgo1xnr1ECm/vlLt9dFMry9RsD52j5zBhy/da4GJHbH5UgxuZXuDPZk
         eKmU3CXwc3Aiw==
Subject: [PATCH 6/6] xfs: rename "alloc_set_aside" to be more descriptive
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com, david@fromorbit.com
Date:   Thu, 17 Mar 2022 14:21:29 -0700
Message-ID: <164755208902.4194202.454742878504753117.stgit@magnolia>
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

We've established in this patchset that the "alloc_set_aside" pool is
actually used to ensure that a bmbt split always succeeds so that the
filesystem won't run out of space mid-transaction and crash.  Rename the
variable and the function to be a little more suggestive of the purpose
of this quantity.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c |    4 ++--
 fs/xfs/libxfs/xfs_alloc.h |    2 +-
 fs/xfs/xfs_fsops.c        |    2 +-
 fs/xfs/xfs_log_recover.c  |    2 +-
 fs/xfs/xfs_mount.c        |    4 ++--
 fs/xfs/xfs_mount.h        |    7 ++++---
 6 files changed, 11 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 747b3e45303f..a4a6cca1ffd1 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -110,7 +110,7 @@ xfs_prealloc_blocks(
  * AGFL and enough to handle a potential split of a file's bmap btree.
  */
 unsigned int
-xfs_alloc_set_aside(
+xfs_bmbt_split_setaside(
 	struct xfs_mount	*mp)
 {
 	unsigned int		bmbt_splits;
@@ -127,7 +127,7 @@ xfs_alloc_set_aside(
  *	- the AG superblock, AGF, AGI and AGFL
  *	- the AGF (bno and cnt) and AGI btree root blocks, and optionally
  *	  the AGI free inode and rmap btree root blocks.
- *	- blocks on the AGFL according to xfs_alloc_set_aside() limits
+ *	- blocks on the AGFL according to xfs_bmbt_split_setaside() limits
  *	- the rmapbt root block
  *
  * The AG headers are sector sized, so the amount of space they take up is
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index d4c057b764f9..7d676c1c66bc 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -88,7 +88,7 @@ typedef struct xfs_alloc_arg {
 #define XFS_ALLOC_NOBUSY		(1 << 2)/* Busy extents not allowed */
 
 /* freespace limit calculations */
-unsigned int xfs_alloc_set_aside(struct xfs_mount *mp);
+unsigned int xfs_bmbt_split_setaside(struct xfs_mount *mp);
 unsigned int xfs_alloc_ag_max_usable(struct xfs_mount *mp);
 
 xfs_extlen_t xfs_alloc_longest_free_extent(struct xfs_perag *pag,
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index b42b8bc55729..28a9a6f8eb18 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -190,7 +190,7 @@ xfs_growfs_data_private(
 	if (nagimax)
 		mp->m_maxagi = nagimax;
 	xfs_set_low_space_thresholds(mp);
-	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
+	mp->m_bmbt_split_setaside = xfs_bmbt_split_setaside(mp);
 
 	if (delta > 0) {
 		/*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 96c997ed2ec8..30e22cd943c2 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3351,7 +3351,7 @@ xlog_do_recover(
 		xfs_warn(mp, "Failed post-recovery per-ag init: %d", error);
 		return error;
 	}
-	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
+	mp->m_bmbt_split_setaside = xfs_bmbt_split_setaside(mp);
 
 	xlog_recover_check_summary(log);
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 9336176dc706..eac9534338fd 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -656,7 +656,7 @@ xfs_mountfs(
 	 * Compute the amount of space to set aside to handle btree splits now
 	 * that we have calculated the btree maxlevels.
 	 */
-	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
+	mp->m_bmbt_split_setaside = xfs_bmbt_split_setaside(mp);
 	mp->m_ag_max_usable = xfs_alloc_ag_max_usable(mp);
 
 	/*
@@ -1153,7 +1153,7 @@ xfs_mod_fdblocks(
 	 * problems (i.e. transaction abort, pagecache discards, etc.) than
 	 * slightly premature -ENOSPC.
 	 */
-	set_aside = mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
+	set_aside = mp->m_bmbt_split_setaside + atomic64_read(&mp->m_allocbt_blks);
 	percpu_counter_add_batch(&mp->m_fdblocks, delta, batch);
 	if (__percpu_counter_compare(&mp->m_fdblocks, set_aside,
 				     XFS_FDBLOCKS_BATCH) >= 0) {
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 74e9b8558162..6c4cbd4a0c32 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -134,7 +134,8 @@ typedef struct xfs_mount {
 	uint			m_refc_maxlevels; /* max refcount btree level */
 	unsigned int		m_agbtree_maxlevels; /* max level of all AG btrees */
 	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
-	uint			m_alloc_set_aside; /* space we can't use */
+	/* space reserved to ensure bmbt splits always succeed */
+	unsigned int		m_bmbt_split_setaside;
 	uint			m_ag_max_usable; /* max space per AG */
 	int			m_dalign;	/* stripe unit */
 	int			m_swidth;	/* stripe width */
@@ -503,7 +504,7 @@ xfs_fdblocks_available(
 {
 	int64_t			free = percpu_counter_sum(&mp->m_fdblocks);
 
-	free -= mp->m_alloc_set_aside;
+	free -= mp->m_bmbt_split_setaside;
 	free -= atomic64_read(&mp->m_allocbt_blks);
 	return free;
 }
@@ -516,7 +517,7 @@ xfs_fdblocks_available_fast(
 	int64_t			free;
 
 	free = percpu_counter_read_positive(&mp->m_fdblocks);
-	free -= mp->m_alloc_set_aside;
+	free -= mp->m_bmbt_split_setaside;
 	free -= atomic64_read(&mp->m_allocbt_blks);
 	return free;
 }

