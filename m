Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 780437F87
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2015 14:54:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6326D30406A
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2015 12:54:31 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	UAiEn7ND0scMYepX for <xfs@oss.sgi.com>;
	Wed, 04 Feb 2015 12:54:29 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YJ6xg-0003D3-5C
	for xfs@oss.sgi.com; Thu, 05 Feb 2015 07:54:12 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YJ6xg-0007E6-4M
	for xfs@oss.sgi.com; Thu, 05 Feb 2015 07:54:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/7] xfs: use generic percpu counters for inode counter
Date: Thu,  5 Feb 2015 07:54:03 +1100
Message-Id: <1423083249-27493-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1423083249-27493-1-git-send-email-david@fromorbit.com>
References: <1423083249-27493-1-git-send-email-david@fromorbit.com>
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
handrolled per-cpu counter with a generic counter.  This enables us
to update the counter through the normal superblock modification
funtions, but rather than do that we add a xfs_mod_icount() helper
function (from Christoph Hellwig) and keep the percpu counter
outside the superblock in the struct xfs_mount.

This means we still need to initialise the per-cpu counter
specifically when we read the superblock, and vice versa when we
log/write it, but it does mean that we don't need to change any
other code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c |  6 ++--
 fs/xfs/libxfs/xfs_sb.c     |  2 ++
 fs/xfs/xfs_fsops.c         |  3 +-
 fs/xfs/xfs_mount.c         | 76 +++++++++++++++++++++-------------------------
 fs/xfs/xfs_mount.h         |  7 +++--
 fs/xfs/xfs_super.c         |  7 +++--
 fs/xfs/xfs_trans.c         |  5 ++-
 7 files changed, 54 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 116ef1d..5b4ba9f 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -376,7 +376,8 @@ xfs_ialloc_ag_alloc(
 	 */
 	newlen = args.mp->m_ialloc_inos;
 	if (args.mp->m_maxicount &&
-	    args.mp->m_sb.sb_icount + newlen > args.mp->m_maxicount)
+	    percpu_counter_read(&args.mp->m_icount) + newlen >
+							args.mp->m_maxicount)
 		return -ENOSPC;
 	args.minlen = args.maxlen = args.mp->m_ialloc_blks;
 	/*
@@ -1340,7 +1341,8 @@ xfs_dialloc(
 	 * inode.
 	 */
 	if (mp->m_maxicount &&
-	    mp->m_sb.sb_icount + mp->m_ialloc_inos > mp->m_maxicount) {
+	    percpu_counter_read(&mp->m_icount) + mp->m_ialloc_inos >
+							mp->m_maxicount) {
 		noroom = 1;
 		okalloc = 0;
 	}
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index b0a5fe9..017cb2f 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -771,6 +771,8 @@ xfs_log_sb(
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_buf		*bp = xfs_trans_getsb(tp, mp, 0);
 
+	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
+
 	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
 	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb));
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index f711452..e1470f2 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -631,11 +631,12 @@ xfs_fs_counts(
 	xfs_fsop_counts_t	*cnt)
 {
 	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
+	cnt->allocino = percpu_counter_read_positive(&mp->m_icount);
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
index 4fa80e6..702ea6a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1099,6 +1099,21 @@ xfs_log_sbcount(xfs_mount_t *mp)
 	return xfs_sync_sb(mp, true);
 }
 
+int
+xfs_mod_icount(
+	struct xfs_mount	*mp,
+	int64_t			delta)
+{
+	/* deltas are +/-64, hence the large batch size of 128. */
+	__percpu_counter_add(&mp->m_icount, delta, 128);
+	if (percpu_counter_compare(&mp->m_icount, 0) < 0) {
+		ASSERT(0);
+		percpu_counter_add(&mp->m_icount, -delta);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 /*
  * xfs_mod_incore_sb_unlocked() is a utility routine commonly used to apply
  * a delta to a specified field in the in-core superblock.  Simply
@@ -1127,14 +1142,8 @@ xfs_mod_incore_sb_unlocked(
 	 */
 	switch (field) {
 	case XFS_SBS_ICOUNT:
-		lcounter = (long long)mp->m_sb.sb_icount;
-		lcounter += delta;
-		if (lcounter < 0) {
-			ASSERT(0);
-			return -EINVAL;
-		}
-		mp->m_sb.sb_icount = lcounter;
-		return 0;
+		ASSERT(0);
+		return -ENOSPC;
 	case XFS_SBS_IFREE:
 		lcounter = (long long)mp->m_sb.sb_ifree;
 		lcounter += delta;
@@ -1288,8 +1297,9 @@ xfs_mod_incore_sb(
 	int			status;
 
 #ifdef HAVE_PERCPU_SB
-	ASSERT(field < XFS_SBS_ICOUNT || field > XFS_SBS_FDBLOCKS);
+	ASSERT(field < XFS_SBS_IFREE || field > XFS_SBS_FDBLOCKS);
 #endif
+
 	spin_lock(&mp->m_sb_lock);
 	status = xfs_mod_incore_sb_unlocked(mp, field, delta, rsvd);
 	spin_unlock(&mp->m_sb_lock);
@@ -1492,7 +1502,6 @@ xfs_icsb_cpu_notify(
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		xfs_icsb_lock(mp);
-		xfs_icsb_balance_counter(mp, XFS_SBS_ICOUNT, 0);
 		xfs_icsb_balance_counter(mp, XFS_SBS_IFREE, 0);
 		xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS, 0);
 		xfs_icsb_unlock(mp);
@@ -1504,17 +1513,14 @@ xfs_icsb_cpu_notify(
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
@@ -1531,11 +1537,18 @@ xfs_icsb_init_counters(
 	xfs_mount_t	*mp)
 {
 	xfs_icsb_cnts_t *cntp;
+	int		error;
 	int		i;
 
+	error = percpu_counter_init(&mp->m_icount, 0, GFP_KERNEL);
+	if (error)
+		return error;
+
 	mp->m_sb_cnts = alloc_percpu(xfs_icsb_cnts_t);
-	if (mp->m_sb_cnts == NULL)
+	if (!mp->m_sb_cnts) {
+		percpu_counter_destroy(&mp->m_icount);
 		return -ENOMEM;
+	}
 
 	for_each_online_cpu(i) {
 		cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
@@ -1563,13 +1576,14 @@ void
 xfs_icsb_reinit_counters(
 	xfs_mount_t	*mp)
 {
+	percpu_counter_set(&mp->m_icount, mp->m_sb.sb_icount);
+
 	xfs_icsb_lock(mp);
 	/*
 	 * start with all counters disabled so that the
 	 * initial balance kicks us off correctly
 	 */
 	mp->m_icsb_counters = -1;
-	xfs_icsb_balance_counter(mp, XFS_SBS_ICOUNT, 0);
 	xfs_icsb_balance_counter(mp, XFS_SBS_IFREE, 0);
 	xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS, 0);
 	xfs_icsb_unlock(mp);
@@ -1583,6 +1597,9 @@ xfs_icsb_destroy_counters(
 		unregister_hotcpu_notifier(&mp->m_icsb_notifier);
 		free_percpu(mp->m_sb_cnts);
 	}
+
+	percpu_counter_destroy(&mp->m_icount);
+
 	mutex_destroy(&mp->m_icsb_mutex);
 }
 
@@ -1645,7 +1662,6 @@ xfs_icsb_count(
 
 	for_each_online_cpu(i) {
 		cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
-		cnt->icsb_icount += cntp->icsb_icount;
 		cnt->icsb_ifree += cntp->icsb_ifree;
 		cnt->icsb_fdblocks += cntp->icsb_fdblocks;
 	}
@@ -1659,7 +1675,7 @@ xfs_icsb_counter_disabled(
 	xfs_mount_t	*mp,
 	xfs_sb_field_t	field)
 {
-	ASSERT((field >= XFS_SBS_ICOUNT) && (field <= XFS_SBS_FDBLOCKS));
+	ASSERT((field >= XFS_SBS_IFREE) && (field <= XFS_SBS_FDBLOCKS));
 	return test_bit(field, &mp->m_icsb_counters);
 }
 
@@ -1670,7 +1686,7 @@ xfs_icsb_disable_counter(
 {
 	xfs_icsb_cnts_t	cnt;
 
-	ASSERT((field >= XFS_SBS_ICOUNT) && (field <= XFS_SBS_FDBLOCKS));
+	ASSERT((field >= XFS_SBS_IFREE) && (field <= XFS_SBS_FDBLOCKS));
 
 	/*
 	 * If we are already disabled, then there is nothing to do
@@ -1689,9 +1705,6 @@ xfs_icsb_disable_counter(
 
 		xfs_icsb_count(mp, &cnt, XFS_ICSB_LAZY_COUNT);
 		switch(field) {
-		case XFS_SBS_ICOUNT:
-			mp->m_sb.sb_icount = cnt.icsb_icount;
-			break;
 		case XFS_SBS_IFREE:
 			mp->m_sb.sb_ifree = cnt.icsb_ifree;
 			break;
@@ -1716,15 +1729,12 @@ xfs_icsb_enable_counter(
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
@@ -1750,8 +1760,6 @@ xfs_icsb_sync_counters_locked(
 
 	xfs_icsb_count(mp, &cnt, flags);
 
-	if (!xfs_icsb_counter_disabled(mp, XFS_SBS_ICOUNT))
-		mp->m_sb.sb_icount = cnt.icsb_icount;
 	if (!xfs_icsb_counter_disabled(mp, XFS_SBS_IFREE))
 		mp->m_sb.sb_ifree = cnt.icsb_ifree;
 	if (!xfs_icsb_counter_disabled(mp, XFS_SBS_FDBLOCKS))
@@ -1805,12 +1813,6 @@ xfs_icsb_balance_counter_locked(
 
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
@@ -1871,14 +1873,6 @@ again:
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
index a5b2ff8..457c6e3 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -41,7 +41,6 @@ struct xfs_da_geometry;
 typedef struct xfs_icsb_cnts {
 	uint64_t	icsb_fdblocks;
 	uint64_t	icsb_ifree;
-	uint64_t	icsb_icount;
 	unsigned long	icsb_flags;
 } xfs_icsb_cnts_t;
 
@@ -81,8 +80,11 @@ typedef struct xfs_mount {
 	struct super_block	*m_super;
 	xfs_tid_t		m_tid;		/* next unused tid for fs */
 	struct xfs_ail		*m_ail;		/* fs active log item list */
-	xfs_sb_t		m_sb;		/* copy of fs superblock */
+
+	struct xfs_sb		m_sb;		/* copy of fs superblock */
 	spinlock_t		m_sb_lock;	/* sb counter lock */
+	struct percpu_counter	m_icount;	/* allocated inodes counter */
+
 	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
 	char			*m_fsname;	/* filesystem name */
 	int			m_fsname_len;	/* strlen of fs name */
@@ -377,6 +379,7 @@ extern void	xfs_unmountfs(xfs_mount_t *);
 extern int	xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int64_t, int);
 extern int	xfs_mod_incore_sb_batch(xfs_mount_t *, xfs_mod_sb_t *,
 			uint, int);
+extern int	xfs_mod_icount(struct xfs_mount *mp, int64_t delta);
 extern int	xfs_mount_log_sb(xfs_mount_t *);
 extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
 extern int	xfs_readsb(xfs_mount_t *, int);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 40d2ac5..87e169f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1087,6 +1087,7 @@ xfs_fs_statfs(
 	xfs_sb_t		*sbp = &mp->m_sb;
 	struct xfs_inode	*ip = XFS_I(dentry->d_inode);
 	__uint64_t		fakeinos, id;
+	__uint64_t		icount;
 	xfs_extlen_t		lsize;
 	__int64_t		ffree;
 
@@ -1098,6 +1099,7 @@ xfs_fs_statfs(
 	statp->f_fsid.val[1] = (u32)(id >> 32);
 
 	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
+	icount = percpu_counter_sum(&mp->m_icount);
 
 	spin_lock(&mp->m_sb_lock);
 	statp->f_bsize = sbp->sb_blocksize;
@@ -1106,15 +1108,14 @@ xfs_fs_statfs(
 	statp->f_bfree = statp->f_bavail =
 				sbp->sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
 	fakeinos = statp->f_bfree << sbp->sb_inopblog;
-	statp->f_files =
-	    MIN(sbp->sb_icount + fakeinos, (__uint64_t)XFS_MAXINUMBER);
+	statp->f_files = MIN(icount + fakeinos, (__uint64_t)XFS_MAXINUMBER);
 	if (mp->m_maxicount)
 		statp->f_files = min_t(typeof(statp->f_files),
 					statp->f_files,
 					mp->m_maxicount);
 
 	/* make sure statp->f_ffree does not underflow */
-	ffree = statp->f_files - (sbp->sb_icount - sbp->sb_ifree);
+	ffree = statp->f_files - (icount - sbp->sb_ifree);
 	statp->f_ffree = max_t(__int64_t, ffree, 0);
 
 	spin_unlock(&mp->m_sb_lock);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index eb90cd5..9bc742b 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -554,8 +554,7 @@ xfs_trans_unreserve_and_mod_sb(
 	}
 
 	if (idelta) {
-		error = xfs_icsb_modify_counters(mp, XFS_SBS_ICOUNT,
-						 idelta, rsvd);
+		error = xfs_mod_icount(mp, idelta);
 		if (error)
 			goto out_undo_fdblocks;
 	}
@@ -634,7 +633,7 @@ out_undo_ifreecount:
 		xfs_icsb_modify_counters(mp, XFS_SBS_IFREE, -ifreedelta, rsvd);
 out_undo_icount:
 	if (idelta)
-		xfs_icsb_modify_counters(mp, XFS_SBS_ICOUNT, -idelta, rsvd);
+		xfs_mod_icount(mp, -idelta);
 out_undo_fdblocks:
 	if (blkdelta)
 		xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS, -blkdelta, rsvd);
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
