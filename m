Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9985AC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Mar 2022 16:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245516AbiCTQp1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 20 Mar 2022 12:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245510AbiCTQpZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Mar 2022 12:45:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C4B31230
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 09:44:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C9A3611D2
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 16:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCFAC340E9;
        Sun, 20 Mar 2022 16:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647794641;
        bh=Wx5PtS0bao05XqG9kUopov7p4/wszcnd1eBBebwPq6Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CaKld8kU04IwjsQveGzV2dxjpHYw75cxBpXP1dnLa2Yk8z6NDW2ny7X0veOyoK46T
         txJhuM/w0DS9BH6MI/gZ3wEyjZnnxXLkRISCzOA812OvEIYWdE2tsqWLQ/yLdCiTz0
         +UTD6gWEw3HfhOv+iexsDc1l1m2tpOgPoxYGb8hgp6zXgxbzqXM9NjbEOYeNwpL01c
         D8PAiGePPlTMX+fS9g4Eij0TBA783BVog1ZqdZFLyJtbsxDhyMPEN3fIXw8NYWvr89
         MuEUKqgDEqVfybAGboMpDmzu5RQLCPJz1w5U3EAsfGl7iO6nmoLiRshcFM7zgsti0K
         +jszZfRsW2pdw==
Subject: [PATCH 6/6] xfs: rename "alloc_set_aside" to be more descriptive
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com, david@fromorbit.com
Date:   Sun, 20 Mar 2022 09:44:00 -0700
Message-ID: <164779464063.550479.8986144162552096908.stgit@magnolia>
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

We've established in this patchset that the "alloc_set_aside" pool is
actually used to ensure that a bmbt split always succeeds so that the
filesystem won't run out of space mid-transaction and crash.  Rename the
variable and the function to be a little more suggestive of the purpose
of this quantity.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c |    4 ++--
 fs/xfs/libxfs/xfs_alloc.h |    2 +-
 fs/xfs/xfs_fsops.c        |    2 +-
 fs/xfs/xfs_log_recover.c  |    2 +-
 fs/xfs/xfs_mount.c        |    2 +-
 fs/xfs/xfs_mount.h        |    5 +++--
 6 files changed, 9 insertions(+), 8 deletions(-)


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
index 863e6389c6ff..b1840daf89c2 100644
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
index c9fd5219d377..e9fb61b2290a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -656,7 +656,7 @@ xfs_mountfs(
 	 * Compute the amount of space to set aside to handle btree splits near
 	 * ENOSPC now that we have calculated the btree maxlevels.
 	 */
-	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
+	mp->m_bmbt_split_setaside = xfs_bmbt_split_setaside(mp);
 	mp->m_ag_max_usable = xfs_alloc_ag_max_usable(mp);
 
 	/*
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index da1b7056e743..b948f4002e7f 100644
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
@@ -491,7 +492,7 @@ static inline uint64_t
 xfs_fdblocks_unavailable(
 	struct xfs_mount	*mp)
 {
-	return mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
+	return mp->m_bmbt_split_setaside + atomic64_read(&mp->m_allocbt_blks);
 }
 
 extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,

