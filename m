Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 243EBC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 20:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbiDGUxK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 16:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbiDGUwy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Apr 2022 16:52:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B603B167F6
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 13:47:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F89AB82926
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 20:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC40DC385A4;
        Thu,  7 Apr 2022 20:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649364423;
        bh=V9e5EjKuqd0cCNtM0ySRpsyEWL1obgvSb/OMwerZrOs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=udHgxUesVjKJa8Gb4wEEQvgZzOU6kXqDhihdzpbWpJV99J+TaQ/HTm6XBqXWJWfhz
         VRbr3tDqEKC4YX+B5Y9+YD1gN4Mo6fhl4ErlZ38zuTo50+ASpPiHA/92GR2PJiRGIC
         c3qfpb8CbNC5sWXN7t37e3USWpRDJa2wewBOAs0VaWgLhE5kVhjGGbCfCdVEPPhWtb
         XuK3Eyf6kl2kykDD3feNC1QiMGJ8M/noDq1+JYqEsnXiEGzljh3R18XGKy7xv8+Mn7
         JPeiGfQEse3sC86S1Uqb8VXHKbGjrLxUEBgviFK9vK1n7AEgt2n1MEUmUFJZ0ITniP
         E1iqFLrMiVgRg==
Subject: [PATCH 2/2] xfs: use a separate frextents counter for rt extent
 reservations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Thu, 07 Apr 2022 13:47:02 -0700
Message-ID: <164936442248.457511.4389675360381809144.stgit@magnolia>
In-Reply-To: <164936441107.457511.6646449842358518774.stgit@magnolia>
References: <164936441107.457511.6646449842358518774.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

As mentioned in the previous commit, the kernel misuses sb_frextents in
the incore mount to reflect both incore reservations made by running
transactions as well as the actual count of free rt extents on disk.
This results in the superblock being written to the log with an
underestimate of the number of rt extents that are marked free in the
rtbitmap.

Teaching XFS to recompute frextents after log recovery avoids
operational problems in the current mount, but it doesn't solve the
problem of us writing undercounted frextents which are then recovered by
an older kernel that doesn't have that fix.

Create an incore percpu counter to mirror the ondisk frextents.  This
new counter will track transaction reservations and the only time we
will touch the incore super counter (i.e the one that gets logged) is
when those transactions commit updates to the rt bitmap.  This is in
contrast to the lazysbcount counters (e.g. fdblocks), where we know that
log recovery will always fix any incorrect counter that we log.
As a bonus, we only take m_sb_lock at transaction commit time.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c   |    5 +----
 fs/xfs/xfs_icache.c  |    9 ++++++---
 fs/xfs/xfs_mount.c   |   38 +++++++++++++++++++++++++++++---------
 fs/xfs/xfs_mount.h   |    2 ++
 fs/xfs/xfs_rtalloc.c |    1 +
 fs/xfs/xfs_super.c   |   14 ++++++++++++--
 fs/xfs/xfs_trans.c   |   37 +++++++++++++++++++++++++++++++------
 7 files changed, 82 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 68f74549fa22..a0d7aa7fbbff 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -349,10 +349,7 @@ xfs_fs_counts(
 	cnt->freeino = percpu_counter_read_positive(&mp->m_ifree);
 	cnt->freedata = percpu_counter_read_positive(&mp->m_fdblocks) -
 						xfs_fdblocks_unavailable(mp);
-
-	spin_lock(&mp->m_sb_lock);
-	cnt->freertx = mp->m_sb.sb_frextents;
-	spin_unlock(&mp->m_sb_lock);
+	cnt->freertx = percpu_counter_read_positive(&mp->m_frextents);
 }
 
 /*
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 6c7267451b82..f16ccc3b0e98 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1916,13 +1916,16 @@ xfs_inodegc_want_queue_rt_file(
 	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	uint64_t		freertx;
 
 	if (!XFS_IS_REALTIME_INODE(ip))
 		return false;
 
-	freertx = READ_ONCE(mp->m_sb.sb_frextents);
-	return freertx < mp->m_low_rtexts[XFS_LOWSP_5_PCNT];
+	if (__percpu_counter_compare(&mp->m_frextents,
+				mp->m_low_rtexts[XFS_LOWSP_5_PCNT],
+				XFS_FDBLOCKS_BATCH) < 0)
+		return true;
+
+	return false;
 }
 #else
 # define xfs_inodegc_want_queue_rt_file(ip)	(false)
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index c5f153c3693f..d5463728c305 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1183,17 +1183,37 @@ xfs_mod_frextents(
 	struct xfs_mount	*mp,
 	int64_t			delta)
 {
-	int64_t			lcounter;
-	int			ret = 0;
+	int			batch;
 
-	spin_lock(&mp->m_sb_lock);
-	lcounter = mp->m_sb.sb_frextents + delta;
-	if (lcounter < 0)
-		ret = -ENOSPC;
+	if (delta > 0) {
+		percpu_counter_add(&mp->m_frextents, delta);
+		return 0;
+	}
+
+	/*
+	 * Taking blocks away, need to be more accurate the closer we
+	 * are to zero.
+	 *
+	 * If the counter has a value of less than 2 * max batch size,
+	 * then make everything serialise as we are real close to
+	 * ENOSPC.
+	 */
+	if (__percpu_counter_compare(&mp->m_frextents, 2 * XFS_FDBLOCKS_BATCH,
+				     XFS_FDBLOCKS_BATCH) < 0)
+		batch = 1;
 	else
-		mp->m_sb.sb_frextents = lcounter;
-	spin_unlock(&mp->m_sb_lock);
-	return ret;
+		batch = XFS_FDBLOCKS_BATCH;
+
+	percpu_counter_add_batch(&mp->m_frextents, delta, batch);
+	if (__percpu_counter_compare(&mp->m_frextents, 0,
+				     XFS_FDBLOCKS_BATCH) >= 0) {
+		/* we had space! */
+		return 0;
+	}
+
+	/* oops, negative free space, put that back! */
+	percpu_counter_add(&mp->m_frextents, -delta);
+	return -ENOSPC;
 }
 
 /*
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index f6dc19de8322..b1833f71fb3e 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -183,6 +183,8 @@ typedef struct xfs_mount {
 	struct percpu_counter	m_icount;	/* allocated inodes counter */
 	struct percpu_counter	m_ifree;	/* free inodes counter */
 	struct percpu_counter	m_fdblocks;	/* free block counter */
+	struct percpu_counter	m_frextents;	/* free rt extent counter */
+
 	/*
 	 * Count of data device blocks reserved for delayed allocations,
 	 * including indlen blocks.  Does not include allocated CoW staging
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index c9ab4f333472..3673be83391a 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1320,6 +1320,7 @@ xfs_rtalloc_reinit_frextents(
 	spin_lock(&mp->m_sb_lock);
 	mp->m_sb.sb_frextents = val;
 	spin_unlock(&mp->m_sb_lock);
+	percpu_counter_set(&mp->m_frextents, mp->m_sb.sb_frextents);
 	return 0;
 }
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 54be9d64093e..cc95768eb8e1 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -843,9 +843,11 @@ xfs_fs_statfs(
 
 	if (XFS_IS_REALTIME_MOUNT(mp) &&
 	    (ip->i_diflags & (XFS_DIFLAG_RTINHERIT | XFS_DIFLAG_REALTIME))) {
+		s64	freertx;
+
 		statp->f_blocks = sbp->sb_rblocks;
-		statp->f_bavail = statp->f_bfree =
-			sbp->sb_frextents * sbp->sb_rextsize;
+		freertx = max_t(s64, 0, percpu_counter_sum(&mp->m_frextents));
+		statp->f_bavail = statp->f_bfree = freertx * sbp->sb_rextsize;
 	}
 
 	return 0;
@@ -1015,8 +1017,14 @@ xfs_init_percpu_counters(
 	if (error)
 		goto free_fdblocks;
 
+	error = percpu_counter_init(&mp->m_frextents, 0, GFP_KERNEL);
+	if (error)
+		goto free_delalloc;
+
 	return 0;
 
+free_delalloc:
+	percpu_counter_destroy(&mp->m_delalloc_blks);
 free_fdblocks:
 	percpu_counter_destroy(&mp->m_fdblocks);
 free_ifree:
@@ -1033,6 +1041,7 @@ xfs_reinit_percpu_counters(
 	percpu_counter_set(&mp->m_icount, mp->m_sb.sb_icount);
 	percpu_counter_set(&mp->m_ifree, mp->m_sb.sb_ifree);
 	percpu_counter_set(&mp->m_fdblocks, mp->m_sb.sb_fdblocks);
+	percpu_counter_set(&mp->m_frextents, mp->m_sb.sb_frextents);
 }
 
 static void
@@ -1045,6 +1054,7 @@ xfs_destroy_percpu_counters(
 	ASSERT(xfs_is_shutdown(mp) ||
 	       percpu_counter_sum(&mp->m_delalloc_blks) == 0);
 	percpu_counter_destroy(&mp->m_delalloc_blks);
+	percpu_counter_destroy(&mp->m_frextents);
 }
 
 static int
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 0ac717aad380..63a4d3a24340 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -498,10 +498,31 @@ xfs_trans_apply_sb_deltas(
 			be64_add_cpu(&sbp->sb_fdblocks, tp->t_res_fdblocks_delta);
 	}
 
-	if (tp->t_frextents_delta)
-		be64_add_cpu(&sbp->sb_frextents, tp->t_frextents_delta);
-	if (tp->t_res_frextents_delta)
-		be64_add_cpu(&sbp->sb_frextents, tp->t_res_frextents_delta);
+	/*
+	 * Updating frextents requires careful handling because it does not
+	 * behave like the lazysb counters because we cannot rely on log
+	 * recovery in older kenels to recompute the value from the rtbitmap.
+	 * This means that the ondisk frextents must be consistent with the
+	 * rtbitmap.
+	 *
+	 * Therefore, log the frextents change to the ondisk superblock and
+	 * update the incore superblock so that future calls to xfs_log_sb
+	 * write the correct value ondisk.
+	 *
+	 * Don't touch m_frextents because it includes incore reservations,
+	 * and those are handled by the unreserve function.
+	 */
+	if (tp->t_frextents_delta || tp->t_res_frextents_delta) {
+		struct xfs_mount	*mp = tp->t_mountp;
+		int64_t			rtxdelta;
+
+		rtxdelta = tp->t_frextents_delta + tp->t_res_frextents_delta;
+
+		spin_lock(&mp->m_sb_lock);
+		be64_add_cpu(&sbp->sb_frextents, rtxdelta);
+		mp->m_sb.sb_frextents += rtxdelta;
+		spin_unlock(&mp->m_sb_lock);
+	}
 
 	if (tp->t_dblocks_delta) {
 		be64_add_cpu(&sbp->sb_dblocks, tp->t_dblocks_delta);
@@ -614,7 +635,12 @@ xfs_trans_unreserve_and_mod_sb(
 	if (ifreedelta)
 		percpu_counter_add(&mp->m_ifree, ifreedelta);
 
-	if (rtxdelta == 0 && !(tp->t_flags & XFS_TRANS_SB_DIRTY))
+	if (rtxdelta) {
+		error = xfs_mod_frextents(mp, rtxdelta);
+		ASSERT(!error);
+	}
+
+	if (!(tp->t_flags & XFS_TRANS_SB_DIRTY))
 		return;
 
 	/* apply remaining deltas */
@@ -622,7 +648,6 @@ xfs_trans_unreserve_and_mod_sb(
 	mp->m_sb.sb_fdblocks += tp->t_fdblocks_delta + tp->t_res_fdblocks_delta;
 	mp->m_sb.sb_icount += idelta;
 	mp->m_sb.sb_ifree += ifreedelta;
-	mp->m_sb.sb_frextents += rtxdelta;
 	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
 	mp->m_sb.sb_agcount += tp->t_agcount_delta;
 	mp->m_sb.sb_imax_pct += tp->t_imaxpct_delta;

