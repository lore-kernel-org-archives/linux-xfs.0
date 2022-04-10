Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C771C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Apr 2022 18:21:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237616AbiDJSXZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 14:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbiDJSXY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 14:23:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2558322534
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 11:21:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEDCD61183
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 18:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E04EC385A1;
        Sun, 10 Apr 2022 18:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649614872;
        bh=tG0TT/Rlo682wI1OuP4WHKeKMpAh0VeljRBFrwpKdms=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GseVJenGG31cnKeV9c/SnkEmalLhL6oGSMX4KDECurHRQxUkEE1/tOF2gIsB8pPly
         DckMAWsjNR3mtTUF1xJ1TfX92B3tFwBTDPcnuPJNgIfbT71nl7VHOTlTrEqZw1YZOC
         YOQhflsa7lJ/vxk+Ysy3vnLuOBUcYTVN7sAi9eVrGz+q+A7VUWowG6O72L5TEQxgPh
         lZREZSDViKaMW0d2lq/S+mHOhMsfg1Q/C+P20Q+nqVC+XK918pKIukzmyf9H7rBGC7
         QEDRE6wqQgIAJuPqLaPsEgpYOlvuwlUS+GN5YvR4Qa38OxRczeNbCjJOhhqWKaOeC1
         DtMq8wuBh1GFQ==
Subject: [PATCH 3/3] xfs: use a separate frextents counter for rt extent
 reservations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Sun, 10 Apr 2022 11:21:11 -0700
Message-ID: <164961487162.70555.13624412630554454462.stgit@magnolia>
In-Reply-To: <164961485474.70555.18228016043917319266.stgit@magnolia>
References: <164961485474.70555.18228016043917319266.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_sb.c |    5 +++++
 fs/xfs/xfs_fsops.c     |    5 +----
 fs/xfs/xfs_icache.c    |    9 ++++++---
 fs/xfs/xfs_mount.c     |   50 ++++++++++++++++++++----------------------------
 fs/xfs/xfs_mount.h     |   19 +++++++++++++++---
 fs/xfs/xfs_rtalloc.c   |    1 +
 fs/xfs/xfs_super.c     |   14 ++++++++++++-
 fs/xfs/xfs_trans.c     |   43 ++++++++++++++++++++++++++++++++++++-----
 8 files changed, 99 insertions(+), 47 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index f4e84aa1d50a..8dd7186ef9df 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -911,6 +911,11 @@ xfs_log_sb(
 	 * reservations that have been taken out percpu counters. If we have an
 	 * unclean shutdown, this will be corrected by log recovery rebuilding
 	 * the counters from the AGF block counts.
+	 *
+	 * Do not update sb_frextents here because it is not part of the lazy
+	 * sb counters, despite having a percpu counter. It is always kept
+	 * consistent with the ondisk rtbitmap by xfs_trans_apply_sb_deltas()
+	 * and hence we don't need have to update it here.
 	 */
 	if (xfs_has_lazysbcount(mp)) {
 		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
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
index 53e130f803b1..0c0bcbd4949d 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1110,24 +1110,33 @@ xfs_fs_writable(
 	return true;
 }
 
+/* Adjust m_fdblocks or m_frextents. */
 int
-xfs_mod_fdblocks(
+xfs_mod_freecounter(
 	struct xfs_mount	*mp,
+	struct percpu_counter	*counter,
 	int64_t			delta,
 	bool			rsvd)
 {
 	int64_t			lcounter;
 	long long		res_used;
+	uint64_t		set_aside = 0;
 	s32			batch;
-	uint64_t		set_aside;
+	bool			has_resv_pool;
+
+	ASSERT(counter == &mp->m_fdblocks || counter == &mp->m_frextents);
+	has_resv_pool = (counter == &mp->m_fdblocks);
+	if (rsvd)
+		ASSERT(has_resv_pool);
 
 	if (delta > 0) {
 		/*
 		 * If the reserve pool is depleted, put blocks back into it
 		 * first. Most of the time the pool is full.
 		 */
-		if (likely(mp->m_resblks == mp->m_resblks_avail)) {
-			percpu_counter_add(&mp->m_fdblocks, delta);
+		if (likely(!has_resv_pool ||
+			   mp->m_resblks == mp->m_resblks_avail)) {
+			percpu_counter_add(counter, delta);
 			return 0;
 		}
 
@@ -1139,7 +1148,7 @@ xfs_mod_fdblocks(
 		} else {
 			delta -= res_used;
 			mp->m_resblks_avail = mp->m_resblks;
-			percpu_counter_add(&mp->m_fdblocks, delta);
+			percpu_counter_add(counter, delta);
 		}
 		spin_unlock(&mp->m_sb_lock);
 		return 0;
@@ -1153,7 +1162,7 @@ xfs_mod_fdblocks(
 	 * then make everything serialise as we are real close to
 	 * ENOSPC.
 	 */
-	if (__percpu_counter_compare(&mp->m_fdblocks, 2 * XFS_FDBLOCKS_BATCH,
+	if (__percpu_counter_compare(counter, 2 * XFS_FDBLOCKS_BATCH,
 				     XFS_FDBLOCKS_BATCH) < 0)
 		batch = 1;
 	else
@@ -1170,9 +1179,10 @@ xfs_mod_fdblocks(
 	 * problems (i.e. transaction abort, pagecache discards, etc.) than
 	 * slightly premature -ENOSPC.
 	 */
-	set_aside = xfs_fdblocks_unavailable(mp);
-	percpu_counter_add_batch(&mp->m_fdblocks, delta, batch);
-	if (__percpu_counter_compare(&mp->m_fdblocks, set_aside,
+	if (has_resv_pool)
+		set_aside = xfs_fdblocks_unavailable(mp);
+	percpu_counter_add_batch(counter, delta, batch);
+	if (__percpu_counter_compare(counter, set_aside,
 				     XFS_FDBLOCKS_BATCH) >= 0) {
 		/* we had space! */
 		return 0;
@@ -1183,8 +1193,8 @@ xfs_mod_fdblocks(
 	 * that took us to ENOSPC.
 	 */
 	spin_lock(&mp->m_sb_lock);
-	percpu_counter_add(&mp->m_fdblocks, -delta);
-	if (!rsvd)
+	percpu_counter_add(counter, -delta);
+	if (!has_resv_pool || !rsvd)
 		goto fdblocks_enospc;
 
 	lcounter = (long long)mp->m_resblks_avail + delta;
@@ -1201,24 +1211,6 @@ xfs_mod_fdblocks(
 	return -ENOSPC;
 }
 
-int
-xfs_mod_frextents(
-	struct xfs_mount	*mp,
-	int64_t			delta)
-{
-	int64_t			lcounter;
-	int			ret = 0;
-
-	spin_lock(&mp->m_sb_lock);
-	lcounter = mp->m_sb.sb_frextents + delta;
-	if (lcounter < 0)
-		ret = -ENOSPC;
-	else
-		mp->m_sb.sb_frextents = lcounter;
-	spin_unlock(&mp->m_sb_lock);
-	return ret;
-}
-
 /*
  * Used to free the superblock along various error paths.
  */
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index f6dc19de8322..a6b8efb2df52 100644
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
@@ -494,9 +496,20 @@ xfs_fdblocks_unavailable(
 	return mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
 }
 
-extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
-				 bool reserved);
-extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
+int xfs_mod_freecounter(struct xfs_mount *mp, struct percpu_counter *counter,
+		int64_t delta, bool rsvd);
+
+static inline int
+xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta, bool reserved)
+{
+	return xfs_mod_freecounter(mp, &mp->m_fdblocks, delta, reserved);
+}
+
+static inline int
+xfs_mod_frextents(struct xfs_mount *mp, int64_t delta)
+{
+	return xfs_mod_freecounter(mp, &mp->m_frextents, delta, false);
+}
 
 extern int	xfs_readsb(xfs_mount_t *, int);
 extern void	xfs_freesb(xfs_mount_t *);
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 76f50e75f99c..997e4a9d27d3 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1318,6 +1318,7 @@ xfs_rtalloc_reinit_frextents(
 	spin_lock(&mp->m_sb_lock);
 	mp->m_sb.sb_frextents = val;
 	spin_unlock(&mp->m_sb_lock);
+	percpu_counter_set(&mp->m_frextents, mp->m_sb.sb_frextents);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 54be9d64093e..3a5088646294 100644
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
+		freertx = percpu_counter_sum_positive(&mp->m_frextents);
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
index 0ac717aad380..6d9df2e9b267 100644
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
@@ -622,7 +648,12 @@ xfs_trans_unreserve_and_mod_sb(
 	mp->m_sb.sb_fdblocks += tp->t_fdblocks_delta + tp->t_res_fdblocks_delta;
 	mp->m_sb.sb_icount += idelta;
 	mp->m_sb.sb_ifree += ifreedelta;
-	mp->m_sb.sb_frextents += rtxdelta;
+	/*
+	 * Do not touch sb_frextents here because we are dealing with incore
+	 * reservation.  sb_frextents is not part of the lazy sb counters so it
+	 * must be consistent with the ondisk rtbitmap and must never include
+	 * incore reservations.
+	 */
 	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
 	mp->m_sb.sb_agcount += tp->t_agcount_delta;
 	mp->m_sb.sb_imax_pct += tp->t_imaxpct_delta;

