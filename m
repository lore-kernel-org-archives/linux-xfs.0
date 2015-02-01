Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0BC867F67
	for <xfs@oss.sgi.com>; Sun,  1 Feb 2015 15:43:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EF6C98F8037
	for <xfs@oss.sgi.com>; Sun,  1 Feb 2015 13:43:23 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	6o8U9h8WEdra6pSf for <xfs@oss.sgi.com>;
	Sun, 01 Feb 2015 13:43:21 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YI2IW-0003pA-3d
	for xfs@oss.sgi.com; Mon, 02 Feb 2015 08:43:16 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YI2IW-0007x6-2l
	for xfs@oss.sgi.com; Mon, 02 Feb 2015 08:43:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/5] xfs: use generic percpu counters for inode counter
Date: Mon,  2 Feb 2015 08:43:00 +1100
Message-Id: <1422826983-29570-3-git-send-email-david@fromorbit.com>
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
there was any generic implementation. There are some warts around
the  use of them for the inode counter as the hand rolled counter is
designed to be accurate at zero, but has no specific accurracy at
any other value. This design causes problems for the maximum inode
count threshold enforcement, as there is no trigger that balances
the counters as they get close tothe maximum threshold.

Instead of designing new triggers for balancing, just replace the
handrolled per-cpu counter with a generic counter directly in the
incore superblock. This enables us to update the counter throught eh
normal superblock modification funtions, rather than having to go
around them and then fall back to the normal modificaiton functions
if the per-cpu nature of the counter has been turned off.

The result is a much simpler counter implementation that can be used
accurately across it's entire range of values rather than just near
to zero values.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c |  6 +++--
 fs/xfs/libxfs/xfs_sb.c     | 10 +++++---
 fs/xfs/xfs_fsops.c         |  3 ++-
 fs/xfs/xfs_mount.c         | 58 +++++++++++++++++-----------------------------
 fs/xfs/xfs_mount.h         |  1 -
 fs/xfs/xfs_super.c         |  8 ++++---
 fs/xfs/xfs_super.h         |  4 +++-
 fs/xfs/xfs_trans.c         |  5 ++--
 8 files changed, 44 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 116ef1d..95a1762 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -376,7 +376,8 @@ xfs_ialloc_ag_alloc(
 	 */
 	newlen = args.mp->m_ialloc_inos;
 	if (args.mp->m_maxicount &&
-	    args.mp->m_sb.sb_icount + newlen > args.mp->m_maxicount)
+	    percpu_counter_read(&args.mp->m_sb.sb_icount) + newlen >
+							args.mp->m_maxicount)
 		return -ENOSPC;
 	args.minlen = args.maxlen = args.mp->m_ialloc_blks;
 	/*
@@ -1340,7 +1341,8 @@ xfs_dialloc(
 	 * inode.
 	 */
 	if (mp->m_maxicount &&
-	    mp->m_sb.sb_icount + mp->m_ialloc_inos > mp->m_maxicount) {
+	    percpu_counter_read(&mp->m_sb.sb_icount) + mp->m_ialloc_inos >
+							mp->m_maxicount) {
 		noroom = 1;
 		okalloc = 0;
 	}
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 4cf335b..7bfa527 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -357,7 +357,8 @@ __xfs_sb_from_disk(
 	to->sb_rextslog = from->sb_rextslog;
 	to->sb_inprogress = from->sb_inprogress;
 	to->sb_imax_pct = from->sb_imax_pct;
-	to->sb_icount = be64_to_cpu(from->sb_icount);
+	if (percpu_counter_initialized(&to->sb_icount))
+		percpu_counter_set(&to->sb_icount, be64_to_cpu(from->sb_icount));
 	to->sb_ifree = be64_to_cpu(from->sb_ifree);
 	to->sb_fdblocks = be64_to_cpu(from->sb_fdblocks);
 	to->sb_frextents = be64_to_cpu(from->sb_frextents);
@@ -492,7 +493,7 @@ xfs_sb_to_disk(
 	to->sb_rextslog = from->sb_rextslog;
 	to->sb_inprogress = from->sb_inprogress;
 	to->sb_imax_pct = from->sb_imax_pct;
-	to->sb_icount = cpu_to_be64(from->sb_icount);
+	to->sb_icount = cpu_to_be64(percpu_counter_sum(&from->sb_icount));
 	to->sb_ifree = cpu_to_be64(from->sb_ifree);
 	to->sb_fdblocks = cpu_to_be64(from->sb_fdblocks);
 	to->sb_frextents = cpu_to_be64(from->sb_frextents);
@@ -537,6 +538,9 @@ xfs_sb_verify(
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_sb	sb;
 
+	/* don't need to validate icount here */
+	sb.sb_icount.counters = NULL;
+
 	/*
 	 * Use call variant which doesn't convert quota flags from disk 
 	 * format, because xfs_mount_validate_sb checks the on-disk flags.
@@ -748,7 +752,7 @@ xfs_initialize_perag_data(
 	 */
 	spin_lock(&mp->m_sb_lock);
 	sbp->sb_ifree = ifree;
-	sbp->sb_icount = ialloc;
+	percpu_counter_set(&sbp->sb_icount, ialloc);
 	sbp->sb_fdblocks = bfree + bfreelst + btree;
 	spin_unlock(&mp->m_sb_lock);
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index f711452..9cc34d2 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -631,11 +631,12 @@ xfs_fs_counts(
 	xfs_fsop_counts_t	*cnt)
 {
 	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
+	cnt->allocino = percpu_counter_read_positive(&mp->m_sb.sb_icount);
+
 	spin_lock(&mp->m_sb_lock);
 	cnt->freedata = mp->m_sb.sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
 	cnt->freertx = mp->m_sb.sb_frextents;
 	cnt->freeino = mp->m_sb.sb_ifree;
-	cnt->allocino = mp->m_sb.sb_icount;
 	spin_unlock(&mp->m_sb_lock);
 	return 0;
 }
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 6015f54..df5ec55 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1127,13 +1127,13 @@ xfs_mod_incore_sb_unlocked(
 	 */
 	switch (field) {
 	case XFS_SBS_ICOUNT:
-		lcounter = (long long)mp->m_sb.sb_icount;
-		lcounter += delta;
-		if (lcounter < 0) {
+		/* deltas are +/-64, hence the large batch size of 128. */
+		__percpu_counter_add(&mp->m_sb.sb_icount, delta, 128);
+		if (percpu_counter_compare(&mp->m_sb.sb_icount, 0) < 0) {
 			ASSERT(0);
+			percpu_counter_add(&mp->m_sb.sb_icount, -delta);
 			return -EINVAL;
 		}
-		mp->m_sb.sb_icount = lcounter;
 		return 0;
 	case XFS_SBS_IFREE:
 		lcounter = (long long)mp->m_sb.sb_ifree;
@@ -1288,8 +1288,11 @@ xfs_mod_incore_sb(
 	int			status;
 
 #ifdef HAVE_PERCPU_SB
-	ASSERT(field < XFS_SBS_ICOUNT || field > XFS_SBS_FDBLOCKS);
+	ASSERT(field < XFS_SBS_IFREE || field > XFS_SBS_FDBLOCKS);
 #endif
+	if (field == XFS_SBS_ICOUNT)
+		return xfs_mod_incore_sb_unlocked(mp, field, delta, rsvd);
+
 	spin_lock(&mp->m_sb_lock);
 	status = xfs_mod_incore_sb_unlocked(mp, field, delta, rsvd);
 	spin_unlock(&mp->m_sb_lock);
@@ -1492,7 +1495,6 @@ xfs_icsb_cpu_notify(
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		xfs_icsb_lock(mp);
-		xfs_icsb_balance_counter(mp, XFS_SBS_ICOUNT, 0);
 		xfs_icsb_balance_counter(mp, XFS_SBS_IFREE, 0);
 		xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS, 0);
 		xfs_icsb_unlock(mp);
@@ -1504,17 +1506,14 @@ xfs_icsb_cpu_notify(
 		 * re-enable the counters. */
 		xfs_icsb_lock(mp);
 		spin_lock(&mp->m_sb_lock);
-		xfs_icsb_disable_counter(mp, XFS_SBS_ICOUNT);
 		xfs_icsb_disable_counter(mp, XFS_SBS_IFREE);
 		xfs_icsb_disable_counter(mp, XFS_SBS_FDBLOCKS);
 
-		mp->m_sb.sb_icount += cntp->icsb_icount;
 		mp->m_sb.sb_ifree += cntp->icsb_ifree;
 		mp->m_sb.sb_fdblocks += cntp->icsb_fdblocks;
 
 		memset(cntp, 0, sizeof(xfs_icsb_cnts_t));
 
-		xfs_icsb_balance_counter_locked(mp, XFS_SBS_ICOUNT, 0);
 		xfs_icsb_balance_counter_locked(mp, XFS_SBS_IFREE, 0);
 		xfs_icsb_balance_counter_locked(mp, XFS_SBS_FDBLOCKS, 0);
 		spin_unlock(&mp->m_sb_lock);
@@ -1533,9 +1532,15 @@ xfs_icsb_init_counters(
 	xfs_icsb_cnts_t *cntp;
 	int		i;
 
+	i = percpu_counter_init(&mp->m_sb.sb_icount, 0, GFP_KERNEL);
+	if (i)
+		return ENOMEM;
+
 	mp->m_sb_cnts = alloc_percpu(xfs_icsb_cnts_t);
-	if (mp->m_sb_cnts == NULL)
+	if (!mp->m_sb_cnts) {
+		percpu_counter_destroy(&mp->m_sb.sb_icount);
 		return -ENOMEM;
+	}
 
 	for_each_online_cpu(i) {
 		cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
@@ -1569,7 +1574,6 @@ xfs_icsb_reinit_counters(
 	 * initial balance kicks us off correctly
 	 */
 	mp->m_icsb_counters = -1;
-	xfs_icsb_balance_counter(mp, XFS_SBS_ICOUNT, 0);
 	xfs_icsb_balance_counter(mp, XFS_SBS_IFREE, 0);
 	xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS, 0);
 	xfs_icsb_unlock(mp);
@@ -1583,6 +1587,9 @@ xfs_icsb_destroy_counters(
 		unregister_hotcpu_notifier(&mp->m_icsb_notifier);
 		free_percpu(mp->m_sb_cnts);
 	}
+
+	percpu_counter_destroy(&mp->m_sb.sb_icount);
+
 	mutex_destroy(&mp->m_icsb_mutex);
 }
 
@@ -1645,7 +1652,6 @@ xfs_icsb_count(
 
 	for_each_online_cpu(i) {
 		cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
-		cnt->icsb_icount += cntp->icsb_icount;
 		cnt->icsb_ifree += cntp->icsb_ifree;
 		cnt->icsb_fdblocks += cntp->icsb_fdblocks;
 	}
@@ -1659,7 +1665,7 @@ xfs_icsb_counter_disabled(
 	xfs_mount_t	*mp,
 	xfs_sb_field_t	field)
 {
-	ASSERT((field >= XFS_SBS_ICOUNT) && (field <= XFS_SBS_FDBLOCKS));
+	ASSERT((field >= XFS_SBS_IFREE) && (field <= XFS_SBS_FDBLOCKS));
 	return test_bit(field, &mp->m_icsb_counters);
 }
 
@@ -1670,7 +1676,7 @@ xfs_icsb_disable_counter(
 {
 	xfs_icsb_cnts_t	cnt;
 
-	ASSERT((field >= XFS_SBS_ICOUNT) && (field <= XFS_SBS_FDBLOCKS));
+	ASSERT((field >= XFS_SBS_IFREE) && (field <= XFS_SBS_FDBLOCKS));
 
 	/*
 	 * If we are already disabled, then there is nothing to do
@@ -1689,9 +1695,6 @@ xfs_icsb_disable_counter(
 
 		xfs_icsb_count(mp, &cnt, XFS_ICSB_LAZY_COUNT);
 		switch(field) {
-		case XFS_SBS_ICOUNT:
-			mp->m_sb.sb_icount = cnt.icsb_icount;
-			break;
 		case XFS_SBS_IFREE:
 			mp->m_sb.sb_ifree = cnt.icsb_ifree;
 			break;
@@ -1716,15 +1719,12 @@ xfs_icsb_enable_counter(
 	xfs_icsb_cnts_t	*cntp;
 	int		i;
 
-	ASSERT((field >= XFS_SBS_ICOUNT) && (field <= XFS_SBS_FDBLOCKS));
+	ASSERT((field >= XFS_SBS_IFREE) && (field <= XFS_SBS_FDBLOCKS));
 
 	xfs_icsb_lock_all_counters(mp);
 	for_each_online_cpu(i) {
 		cntp = per_cpu_ptr(mp->m_sb_cnts, i);
 		switch (field) {
-		case XFS_SBS_ICOUNT:
-			cntp->icsb_icount = count + resid;
-			break;
 		case XFS_SBS_IFREE:
 			cntp->icsb_ifree = count + resid;
 			break;
@@ -1750,8 +1750,6 @@ xfs_icsb_sync_counters_locked(
 
 	xfs_icsb_count(mp, &cnt, flags);
 
-	if (!xfs_icsb_counter_disabled(mp, XFS_SBS_ICOUNT))
-		mp->m_sb.sb_icount = cnt.icsb_icount;
 	if (!xfs_icsb_counter_disabled(mp, XFS_SBS_IFREE))
 		mp->m_sb.sb_ifree = cnt.icsb_ifree;
 	if (!xfs_icsb_counter_disabled(mp, XFS_SBS_FDBLOCKS))
@@ -1805,12 +1803,6 @@ xfs_icsb_balance_counter_locked(
 
 	/* update counters  - first CPU gets residual*/
 	switch (field) {
-	case XFS_SBS_ICOUNT:
-		count = mp->m_sb.sb_icount;
-		resid = do_div(count, weight);
-		if (count < max(min, XFS_ICSB_INO_CNTR_REENABLE))
-			return;
-		break;
 	case XFS_SBS_IFREE:
 		count = mp->m_sb.sb_ifree;
 		resid = do_div(count, weight);
@@ -1871,14 +1863,6 @@ again:
 	}
 
 	switch (field) {
-	case XFS_SBS_ICOUNT:
-		lcounter = icsbp->icsb_icount;
-		lcounter += delta;
-		if (unlikely(lcounter < 0))
-			goto balance_counter;
-		icsbp->icsb_icount = lcounter;
-		break;
-
 	case XFS_SBS_IFREE:
 		lcounter = icsbp->icsb_ifree;
 		lcounter += delta;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 9d62134..9499a8f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -41,7 +41,6 @@ struct xfs_da_geometry;
 typedef struct xfs_icsb_cnts {
 	uint64_t	icsb_fdblocks;
 	uint64_t	icsb_ifree;
-	uint64_t	icsb_icount;
 	unsigned long	icsb_flags;
 } xfs_icsb_cnts_t;
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 7583044..408e2fe 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1087,6 +1087,7 @@ xfs_fs_statfs(
 	struct xfs_sb		*sbp = &mp->m_sb;
 	struct xfs_inode	*ip = XFS_I(dentry->d_inode);
 	__uint64_t		fakeinos, id;
+	__uint64_t		sb_icount;
 	xfs_extlen_t		lsize;
 	__int64_t		ffree;
 
@@ -1098,6 +1099,7 @@ xfs_fs_statfs(
 	statp->f_fsid.val[1] = (u32)(id >> 32);
 
 	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
+	sb_icount = percpu_counter_sum(&sbp->sb_icount);
 
 	spin_lock(&mp->m_sb_lock);
 	statp->f_bsize = sbp->sb_blocksize;
@@ -1106,15 +1108,15 @@ xfs_fs_statfs(
 	statp->f_bfree = statp->f_bavail =
 				sbp->sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
 	fakeinos = statp->f_bfree << sbp->sb_inopblog;
-	statp->f_files =
-	    MIN(sbp->sb_icount + fakeinos, (__uint64_t)XFS_MAXINUMBER);
+	statp->f_files = MIN(sb_icount + fakeinos,
+			     (__uint64_t)XFS_MAXINUMBER);
 	if (mp->m_maxicount)
 		statp->f_files = min_t(typeof(statp->f_files),
 					statp->f_files,
 					mp->m_maxicount);
 
 	/* make sure statp->f_ffree does not underflow */
-	ffree = statp->f_files - (sbp->sb_icount - sbp->sb_ifree);
+	ffree = statp->f_files - (sb_icount - sbp->sb_ifree);
 	statp->f_ffree = max_t(__int64_t, ffree, 0);
 
 	spin_unlock(&mp->m_sb_lock);
diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
index a02236b..fa5603c 100644
--- a/fs/xfs/xfs_super.h
+++ b/fs/xfs/xfs_super.h
@@ -96,7 +96,9 @@ struct xfs_sb {
 	__uint8_t	sb_inprogress;	/* mkfs is in progress, don't mount */
 	__uint8_t	sb_imax_pct;	/* max % of fs for inode space */
 					/* statistics */
-	__uint64_t	sb_icount;	/* allocated inodes */
+
+	struct percpu_counter	sb_icount;	/* allocated inodes */
+
 	__uint64_t	sb_ifree;	/* free inodes */
 	__uint64_t	sb_fdblocks;	/* free data blocks */
 	__uint64_t	sb_frextents;	/* free realtime extents */
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index eb90cd5..d78b0ae 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -554,8 +554,7 @@ xfs_trans_unreserve_and_mod_sb(
 	}
 
 	if (idelta) {
-		error = xfs_icsb_modify_counters(mp, XFS_SBS_ICOUNT,
-						 idelta, rsvd);
+		error = xfs_mod_incore_sb(mp, XFS_SBS_ICOUNT, idelta, rsvd);
 		if (error)
 			goto out_undo_fdblocks;
 	}
@@ -634,7 +633,7 @@ out_undo_ifreecount:
 		xfs_icsb_modify_counters(mp, XFS_SBS_IFREE, -ifreedelta, rsvd);
 out_undo_icount:
 	if (idelta)
-		xfs_icsb_modify_counters(mp, XFS_SBS_ICOUNT, -idelta, rsvd);
+		xfs_mod_incore_sb(mp, XFS_SBS_ICOUNT, -idelta, rsvd);
 out_undo_fdblocks:
 	if (blkdelta)
 		xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS, -blkdelta, rsvd);
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
