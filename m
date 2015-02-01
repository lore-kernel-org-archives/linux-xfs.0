Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 66DBA7F6A
	for <xfs@oss.sgi.com>; Sun,  1 Feb 2015 15:43:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 47431304032
	for <xfs@oss.sgi.com>; Sun,  1 Feb 2015 13:43:26 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	RxBSAQPknjmSFLFL for <xfs@oss.sgi.com>;
	Sun, 01 Feb 2015 13:43:23 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YI2IW-0003pC-4k
	for xfs@oss.sgi.com; Mon, 02 Feb 2015 08:43:16 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YI2IW-0007xG-3i
	for xfs@oss.sgi.com; Mon, 02 Feb 2015 08:43:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/5] xfs: use generic percpu counters for free block counter
Date: Mon,  2 Feb 2015 08:43:02 +1100
Message-Id: <1422826983-29570-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1422826983-29570-1-git-send-email-david@fromorbit.com>
References: <1422826983-29570-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

XFS has hand-rolled per-cpu counters for the superblock since before
there was any generic implementation. The free block counter is
special in that it is used for ENOSPC detection outside transaction
contexts for for delayed allocation. This means that the counter
needs to be accurate at zero. The current per-cpu counter code jumps
through lots of hoops to ensure we never run past zero, but we don't
need to make all those jumps with the generic counter
implementation.

The generic counter implementation allows us to pass a "batch"
threshold at which the addition/subtraction to the counter value
will be folded back into global value under lock. We can use this
feature to reduce the batch size as we approach 0 in a very similar
manner to the existing counters and their rebalance algorithm. If we
use a batch size of 1 as we approach 0, then every addition and
subtraction will be done against the global value and hence allow
accurate detection of zero threshold crossing.

Hence we can replace the handrolled, accurate-at-zero counters with
generic percpu counters.

Note: this removes just enough of the icsb infrastructure to compile
without warnings. The rest will go in subsequent commits.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_sb.c |  11 +++-
 fs/xfs/xfs_fsops.c     |   9 +--
 fs/xfs/xfs_iomap.c     |   2 +-
 fs/xfs/xfs_mount.c     | 167 ++++++++++++++++++++++++-------------------------
 fs/xfs/xfs_super.c     |  11 +++-
 fs/xfs/xfs_super.h     |   2 +-
 fs/xfs/xfs_trans.c     |   9 ++-
 7 files changed, 109 insertions(+), 102 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 42e5c89..bdde5c7 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -357,11 +357,15 @@ __xfs_sb_from_disk(
 	to->sb_rextslog = from->sb_rextslog;
 	to->sb_inprogress = from->sb_inprogress;
 	to->sb_imax_pct = from->sb_imax_pct;
+
 	if (percpu_counter_initialized(&to->sb_icount))
 		percpu_counter_set(&to->sb_icount, be64_to_cpu(from->sb_icount));
 	if (percpu_counter_initialized(&to->sb_icount))
 		percpu_counter_set(&to->sb_ifree, be64_to_cpu(from->sb_ifree));
-	to->sb_fdblocks = be64_to_cpu(from->sb_fdblocks);
+	if (percpu_counter_initialized(&to->sb_fdblocks))
+		percpu_counter_set(&to->sb_fdblocks,
+				    be64_to_cpu(from->sb_fdblocks));
+
 	to->sb_frextents = be64_to_cpu(from->sb_frextents);
 	to->sb_uquotino = be64_to_cpu(from->sb_uquotino);
 	to->sb_gquotino = be64_to_cpu(from->sb_gquotino);
@@ -496,7 +500,7 @@ xfs_sb_to_disk(
 	to->sb_imax_pct = from->sb_imax_pct;
 	to->sb_icount = cpu_to_be64(percpu_counter_sum(&from->sb_icount));
 	to->sb_ifree = cpu_to_be64(percpu_counter_sum(&from->sb_ifree));
-	to->sb_fdblocks = cpu_to_be64(from->sb_fdblocks);
+	to->sb_fdblocks = cpu_to_be64(percpu_counter_sum(&from->sb_fdblocks));
 	to->sb_frextents = cpu_to_be64(from->sb_frextents);
 
 	to->sb_flags = from->sb_flags;
@@ -542,6 +546,7 @@ xfs_sb_verify(
 	/* don't need to validate icount here */
 	sb.sb_icount.counters = NULL;
 	sb.sb_ifree.counters = NULL;
+	sb.sb_fdblocks.counters = NULL;
 
 	/*
 	 * Use call variant which doesn't convert quota flags from disk 
@@ -755,7 +760,7 @@ xfs_initialize_perag_data(
 	spin_lock(&mp->m_sb_lock);
 	percpu_counter_set(&sbp->sb_ifree, ifree);
 	percpu_counter_set(&sbp->sb_icount, ialloc);
-	sbp->sb_fdblocks = bfree + bfreelst + btree;
+	percpu_counter_set(&sbp->sb_fdblocks, bfree + bfreelst + btree);
 	spin_unlock(&mp->m_sb_lock);
 
 	/* Fixup the per-cpu counters as well. */
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 619a9f3..ccb00cd 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -633,9 +633,10 @@ xfs_fs_counts(
 	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
 	cnt->allocino = percpu_counter_read_positive(&mp->m_sb.sb_icount);
 	cnt->freeino = percpu_counter_read_positive(&mp->m_sb.sb_ifree);
+	cnt->freedata = percpu_counter_read_positive(&mp->m_sb.sb_fdblocks) -
+							XFS_ALLOC_SET_ASIDE(mp);
 
 	spin_lock(&mp->m_sb_lock);
-	cnt->freedata = mp->m_sb.sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
 	cnt->freertx = mp->m_sb.sb_frextents;
 	spin_unlock(&mp->m_sb_lock);
 	return 0;
@@ -710,7 +711,8 @@ retry:
 	} else {
 		__int64_t	free;
 
-		free =  mp->m_sb.sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
+		free = percpu_counter_sum(&mp->m_sb.sb_fdblocks) -
+							XFS_ALLOC_SET_ASIDE(mp);
 		if (!free)
 			goto out; /* ENOSPC and fdblks_delta = 0 */
 
@@ -749,8 +751,7 @@ out:
 		 * the extra reserve blocks from the reserve.....
 		 */
 		int error;
-		error = xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
-						 fdblks_delta, 0);
+		error = xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS, fdblks_delta, 0);
 		if (error == -ENOSPC)
 			goto retry;
 	}
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index ccb1dd0..310433a 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -461,7 +461,7 @@ xfs_iomap_prealloc_size(
 				       alloc_blocks);
 
 	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
-	freesp = mp->m_sb.sb_fdblocks;
+	freesp = percpu_counter_read_positive(&mp->m_sb.sb_fdblocks);
 	if (freesp < mp->m_low_space[XFS_LOWSP_5_PCNT]) {
 		shift = 2;
 		if (freesp < mp->m_low_space[XFS_LOWSP_4_PCNT])
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 8e8924f..0e37248 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1117,7 +1117,8 @@ xfs_mod_incore_sb_unlocked(
 {
 	int		scounter;	/* short counter for 32 bit fields */
 	long long	lcounter;	/* long counter for 64 bit fields */
-	long long	res_used, rem;
+	long long	res_used;
+	s32		batch;
 
 	/*
 	 * With the in-core superblock spin lock held, switch
@@ -1144,47 +1145,80 @@ xfs_mod_incore_sb_unlocked(
 		}
 		return 0;
 	case XFS_SBS_FDBLOCKS:
-		lcounter = (long long)
-			mp->m_sb.sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
-		res_used = (long long)(mp->m_resblks - mp->m_resblks_avail);
 
 		if (delta > 0) {		/* Putting blocks back */
+			if (mp->m_resblks == mp->m_resblks_avail) {
+				percpu_counter_add(&mp->m_sb.sb_fdblocks, delta);
+				return 0;
+			}
+
+			/* put blocks back into reserve pool first */
+			spin_lock(&mp->m_sb_lock);
+			res_used = (long long)
+					(mp->m_resblks - mp->m_resblks_avail);
+
 			if (res_used > delta) {
 				mp->m_resblks_avail += delta;
 			} else {
-				rem = delta - res_used;
+				delta -= res_used;
 				mp->m_resblks_avail = mp->m_resblks;
-				lcounter += rem;
-			}
-		} else {				/* Taking blocks away */
-			lcounter += delta;
-			if (lcounter >= 0) {
-				mp->m_sb.sb_fdblocks = lcounter +
-							XFS_ALLOC_SET_ASIDE(mp);
-				return 0;
+				percpu_counter_add(&mp->m_sb.sb_fdblocks, delta);
 			}
+			spin_unlock(&mp->m_sb_lock);
+			return 0;
 
-			/*
-			 * We are out of blocks, use any available reserved
-			 * blocks if were allowed to.
-			 */
-			if (!rsvd)
-				return -ENOSPC;
+		}
 
-			lcounter = (long long)mp->m_resblks_avail + delta;
-			if (lcounter >= 0) {
-				mp->m_resblks_avail = lcounter;
-				return 0;
-			}
-			printk_once(KERN_WARNING
-				"Filesystem \"%s\": reserve blocks depleted! "
-				"Consider increasing reserve pool size.",
-				mp->m_fsname);
-			return -ENOSPC;
+		/*
+		 * Taking blocks away, need to be more accurate the closer we
+		 * are to zero.
+		 *
+		 * batch size is set to a maximum of 1024 blocks - if we are
+		 * allocating of freeing extents larger than this then we aren't
+		 * going to be hammering the counter lock so a lock per update
+		 * is not a problem.
+		 *
+		 * If the counter has a value of less than 2 * max batch size,
+		 * then make everything serialise as we are real close to
+		 * ENOSPC.
+		 */
+#define __BATCH	1024
+		if (percpu_counter_compare(&mp->m_sb.sb_fdblocks,
+					   2 * __BATCH) < 0)
+			batch = 1;
+		else
+			batch = __BATCH;
+
+		__percpu_counter_add(&mp->m_sb.sb_fdblocks, delta, batch);
+		if (percpu_counter_compare(&mp->m_sb.sb_fdblocks,
+					   XFS_ALLOC_SET_ASIDE(mp)) >= 0) {
+			/* we had space! */
+			return 0;
 		}
 
-		mp->m_sb.sb_fdblocks = lcounter + XFS_ALLOC_SET_ASIDE(mp);
-		return 0;
+		/*
+		 * lock up the sb for dipping into reserves before releasing
+		 * the space that took us to ENOSPC.
+		 */
+		spin_lock(&mp->m_sb_lock);
+		percpu_counter_add(&mp->m_sb.sb_fdblocks, -delta);
+		if (!rsvd)
+			goto fdblocks_enospc;
+
+		lcounter = (long long)mp->m_resblks_avail + delta;
+		if (lcounter >= 0) {
+			mp->m_resblks_avail = lcounter;
+			spin_unlock(&mp->m_sb_lock);
+			return 0;
+		}
+		printk_once(KERN_WARNING
+			"Filesystem \"%s\": reserve blocks depleted! "
+			"Consider increasing reserve pool size.",
+			mp->m_fsname);
+fdblocks_enospc:
+		spin_unlock(&mp->m_sb_lock);
+		return -ENOSPC;
+
 	case XFS_SBS_FREXTENTS:
 		lcounter = (long long)mp->m_sb.sb_frextents;
 		lcounter += delta;
@@ -1286,11 +1320,14 @@ xfs_mod_incore_sb(
 {
 	int			status;
 
-#ifdef HAVE_PERCPU_SB
-	ASSERT(field != XFS_SBS_FDBLOCKS);
-#endif
-	if (field == XFS_SBS_ICOUNT || field == XFS_SBS_IFREE)
+	switch (field) {
+	case XFS_SBS_ICOUNT:
+	case XFS_SBS_IFREE:
+	case XFS_SBS_FDBLOCKS:
 		return xfs_mod_incore_sb_unlocked(mp, field, delta, rsvd);
+	default:
+		break;
+	}
 
 	spin_lock(&mp->m_sb_lock);
 	status = xfs_mod_incore_sb_unlocked(mp, field, delta, rsvd);
@@ -1309,7 +1346,7 @@ xfs_mod_incore_sb(
  *
  * Note that this function may not be used for the superblock values that
  * are tracked with the in-memory per-cpu counters - a direct call to
- * xfs_icsb_modify_counters is required for these.
+ * xfs_mod_incore_sb is required for these.
  */
 int
 xfs_mod_incore_sb_batch(
@@ -1494,7 +1531,6 @@ xfs_icsb_cpu_notify(
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		xfs_icsb_lock(mp);
-		xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS, 0);
 		xfs_icsb_unlock(mp);
 		break;
 	case CPU_DEAD:
@@ -1504,13 +1540,9 @@ xfs_icsb_cpu_notify(
 		 * re-enable the counters. */
 		xfs_icsb_lock(mp);
 		spin_lock(&mp->m_sb_lock);
-		xfs_icsb_disable_counter(mp, XFS_SBS_FDBLOCKS);
-
-		mp->m_sb.sb_fdblocks += cntp->icsb_fdblocks;
 
 		memset(cntp, 0, sizeof(xfs_icsb_cnts_t));
 
-		xfs_icsb_balance_counter_locked(mp, XFS_SBS_FDBLOCKS, 0);
 		spin_unlock(&mp->m_sb_lock);
 		xfs_icsb_unlock(mp);
 		break;
@@ -1535,9 +1567,13 @@ xfs_icsb_init_counters(
 	if (i)
 		goto free_icount;
 
+	i = percpu_counter_init(&mp->m_sb.sb_fdblocks, 0, GFP_KERNEL);
+	if (i)
+		goto free_ifree;
+
 	mp->m_sb_cnts = alloc_percpu(xfs_icsb_cnts_t);
 	if (!mp->m_sb_cnts)
-		goto free_ifree;
+		goto free_fdblocks;
 
 	for_each_online_cpu(i) {
 		cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
@@ -1560,6 +1596,8 @@ xfs_icsb_init_counters(
 
 	return 0;
 
+free_fdblocks:
+	percpu_counter_destroy(&mp->m_sb.sb_fdblocks);
 free_ifree:
 	percpu_counter_destroy(&mp->m_sb.sb_ifree);
 free_icount:
@@ -1577,7 +1615,6 @@ xfs_icsb_reinit_counters(
 	 * initial balance kicks us off correctly
 	 */
 	mp->m_icsb_counters = -1;
-	xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS, 0);
 	xfs_icsb_unlock(mp);
 }
 
@@ -1592,6 +1629,7 @@ xfs_icsb_destroy_counters(
 
 	percpu_counter_destroy(&mp->m_sb.sb_icount);
 	percpu_counter_destroy(&mp->m_sb.sb_ifree);
+	percpu_counter_destroy(&mp->m_sb.sb_fdblocks);
 
 	mutex_destroy(&mp->m_icsb_mutex);
 }
@@ -1645,18 +1683,11 @@ xfs_icsb_count(
 	xfs_icsb_cnts_t	*cnt,
 	int		flags)
 {
-	xfs_icsb_cnts_t *cntp;
-	int		i;
-
 	memset(cnt, 0, sizeof(xfs_icsb_cnts_t));
 
 	if (!(flags & XFS_ICSB_LAZY_COUNT))
 		xfs_icsb_lock_all_counters(mp);
 
-	for_each_online_cpu(i) {
-		cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
-		cnt->icsb_fdblocks += cntp->icsb_fdblocks;
-	}
 
 	if (!(flags & XFS_ICSB_LAZY_COUNT))
 		xfs_icsb_unlock_all_counters(mp);
@@ -1667,7 +1698,6 @@ xfs_icsb_counter_disabled(
 	xfs_mount_t	*mp,
 	xfs_sb_field_t	field)
 {
-	ASSERT(field == XFS_SBS_FDBLOCKS);
 	return test_bit(field, &mp->m_icsb_counters);
 }
 
@@ -1678,8 +1708,6 @@ xfs_icsb_disable_counter(
 {
 	xfs_icsb_cnts_t	cnt;
 
-	ASSERT(field == XFS_SBS_FDBLOCKS);
-
 	/*
 	 * If we are already disabled, then there is nothing to do
 	 * here. We check before locking all the counters to avoid
@@ -1697,9 +1725,6 @@ xfs_icsb_disable_counter(
 
 		xfs_icsb_count(mp, &cnt, XFS_ICSB_LAZY_COUNT);
 		switch(field) {
-		case XFS_SBS_FDBLOCKS:
-			mp->m_sb.sb_fdblocks = cnt.icsb_fdblocks;
-			break;
 		default:
 			BUG();
 		}
@@ -1715,18 +1740,11 @@ xfs_icsb_enable_counter(
 	uint64_t	count,
 	uint64_t	resid)
 {
-	xfs_icsb_cnts_t	*cntp;
 	int		i;
 
-	ASSERT(field == XFS_SBS_FDBLOCKS);
-
 	xfs_icsb_lock_all_counters(mp);
 	for_each_online_cpu(i) {
-		cntp = per_cpu_ptr(mp->m_sb_cnts, i);
 		switch (field) {
-		case XFS_SBS_FDBLOCKS:
-			cntp->icsb_fdblocks = count + resid;
-			break;
 		default:
 			BUG();
 			break;
@@ -1745,9 +1763,6 @@ xfs_icsb_sync_counters_locked(
 	xfs_icsb_cnts_t	cnt;
 
 	xfs_icsb_count(mp, &cnt, flags);
-
-	if (!xfs_icsb_counter_disabled(mp, XFS_SBS_FDBLOCKS))
-		mp->m_sb.sb_fdblocks = cnt.icsb_fdblocks;
 }
 
 /*
@@ -1789,20 +1804,12 @@ xfs_icsb_balance_counter_locked(
 	int		min_per_cpu)
 {
 	uint64_t	count, resid;
-	int		weight = num_online_cpus();
-	uint64_t	min = (uint64_t)min_per_cpu;
 
 	/* disable counter and sync counter */
 	xfs_icsb_disable_counter(mp, field);
 
 	/* update counters  - first CPU gets residual*/
 	switch (field) {
-	case XFS_SBS_FDBLOCKS:
-		count = mp->m_sb.sb_fdblocks;
-		resid = do_div(count, weight);
-		if (count < max(min, XFS_ICSB_FDBLK_CNTR_REENABLE(mp)))
-			return;
-		break;
 	default:
 		BUG();
 		count = resid = 0;	/* quiet, gcc */
@@ -1831,7 +1838,6 @@ xfs_icsb_modify_counters(
 	int		rsvd)
 {
 	xfs_icsb_cnts_t	*icsbp;
-	long long	lcounter;	/* long counter for 64 bit fields */
 	int		ret = 0;
 
 	might_sleep();
@@ -1851,18 +1857,9 @@ again:
 	}
 
 	switch (field) {
-	case XFS_SBS_FDBLOCKS:
-		BUG_ON((mp->m_resblks - mp->m_resblks_avail) != 0);
-
-		lcounter = icsbp->icsb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
-		lcounter += delta;
-		if (unlikely(lcounter < 0))
-			goto balance_counter;
-		icsbp->icsb_fdblocks = lcounter + XFS_ALLOC_SET_ASIDE(mp);
-		break;
 	default:
 		BUG();
-		break;
+		goto balance_counter; /* be still, gcc */
 	}
 	xfs_icsb_unlock_cntr(icsbp);
 	preempt_enable();
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index c17bfa4..0fa688a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1089,6 +1089,7 @@ xfs_fs_statfs(
 	__uint64_t		fakeinos, id;
 	__uint64_t		sb_icount;
 	__uint64_t		sb_ifree;
+	__uint64_t		sb_fdblocks;
 	xfs_extlen_t		lsize;
 	__int64_t		ffree;
 
@@ -1100,15 +1101,20 @@ xfs_fs_statfs(
 	statp->f_fsid.val[1] = (u32)(id >> 32);
 
 	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
+
 	sb_icount = percpu_counter_sum(&sbp->sb_icount);
 	sb_ifree = percpu_counter_sum(&sbp->sb_ifree);
+	sb_fdblocks = percpu_counter_sum(&sbp->sb_fdblocks);
 
 	spin_lock(&mp->m_sb_lock);
 	statp->f_bsize = sbp->sb_blocksize;
 	lsize = sbp->sb_logstart ? sbp->sb_logblocks : 0;
 	statp->f_blocks = sbp->sb_dblocks - lsize;
-	statp->f_bfree = statp->f_bavail =
-				sbp->sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
+	spin_unlock(&mp->m_sb_lock);
+
+	statp->f_bfree = sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
+	statp->f_bavail = statp->f_bfree;
+
 	fakeinos = statp->f_bfree << sbp->sb_inopblog;
 	statp->f_files = MIN(sb_icount + fakeinos,
 			     (__uint64_t)XFS_MAXINUMBER);
@@ -1121,7 +1127,6 @@ xfs_fs_statfs(
 	ffree = statp->f_files - (sb_icount - sb_ifree);
 	statp->f_ffree = max_t(__int64_t, ffree, 0);
 
-	spin_unlock(&mp->m_sb_lock);
 
 	if ((ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
 	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))) ==
diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
index 6efc7a2..f649d1a 100644
--- a/fs/xfs/xfs_super.h
+++ b/fs/xfs/xfs_super.h
@@ -99,8 +99,8 @@ struct xfs_sb {
 
 	struct percpu_counter	sb_icount;	/* allocated inodes */
 	struct percpu_counter	sb_ifree;	/* free inodes */
+	struct percpu_counter	sb_fdblocks;	/* free data blocks */
 
-	__uint64_t	sb_fdblocks;	/* free data blocks */
 	__uint64_t	sb_frextents;	/* free realtime extents */
 	xfs_ino_t	sb_uquotino;	/* user quota inode */
 	xfs_ino_t	sb_gquotino;	/* group quota inode */
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index c54d4b7..b7da423 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -184,7 +184,7 @@ xfs_trans_reserve(
 	 * fail if the count would go below zero.
 	 */
 	if (blocks > 0) {
-		error = xfs_icsb_modify_counters(tp->t_mountp, XFS_SBS_FDBLOCKS,
+		error = xfs_mod_incore_sb(tp->t_mountp, XFS_SBS_FDBLOCKS,
 					  -((int64_t)blocks), rsvd);
 		if (error != 0) {
 			current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
@@ -268,7 +268,7 @@ undo_log:
 
 undo_blocks:
 	if (blocks > 0) {
-		xfs_icsb_modify_counters(tp->t_mountp, XFS_SBS_FDBLOCKS,
+		xfs_mod_incore_sb(tp->t_mountp, XFS_SBS_FDBLOCKS,
 					 (int64_t)blocks, rsvd);
 		tp->t_blk_res = 0;
 	}
@@ -547,8 +547,7 @@ xfs_trans_unreserve_and_mod_sb(
 
 	/* apply the per-cpu counters */
 	if (blkdelta) {
-		error = xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
-						 blkdelta, rsvd);
+		error = xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS, blkdelta, rsvd);
 		if (error)
 			goto out;
 	}
@@ -635,7 +634,7 @@ out_undo_icount:
 		xfs_mod_incore_sb(mp, XFS_SBS_ICOUNT, -idelta, rsvd);
 out_undo_fdblocks:
 	if (blkdelta)
-		xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS, -blkdelta, rsvd);
+		xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS, -blkdelta, rsvd);
 out:
 	ASSERT(error == 0);
 	return;
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
