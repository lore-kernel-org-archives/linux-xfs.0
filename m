Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 201FB7F69
	for <xfs@oss.sgi.com>; Sun,  1 Feb 2015 15:43:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 93FCAAC001
	for <xfs@oss.sgi.com>; Sun,  1 Feb 2015 13:43:24 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	9YNnbFfjuZcX932V for <xfs@oss.sgi.com>;
	Sun, 01 Feb 2015 13:43:22 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YI2IW-0003pB-49
	for xfs@oss.sgi.com; Mon, 02 Feb 2015 08:43:16 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YI2IW-0007xB-3E
	for xfs@oss.sgi.com; Mon, 02 Feb 2015 08:43:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/5] xfs: use generic percpu counters for free inode counter
Date: Mon,  2 Feb 2015 08:43:01 +1100
Message-Id: <1422826983-29570-4-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

XFS has hand-rolled per-cpu counters for the superblock since before
there was any generic implementation. The free inode counter is not
used for any limit enforcement - the per-AG free inode counters are
used during allocation to determine if there are inode available for
allocation.

Hence we don't need any of the complexity of the hand-rolled
counters and we can simply replace them with generic per-cpu
counters similar to the inode counter.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_sb.c |  8 ++++---
 fs/xfs/xfs_fsops.c     |  2 +-
 fs/xfs/xfs_mount.c     | 62 +++++++++++++++++---------------------------------
 fs/xfs/xfs_super.c     |  4 +++-
 fs/xfs/xfs_super.h     |  2 +-
 fs/xfs/xfs_trans.c     |  5 ++--
 6 files changed, 33 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 7bfa527..42e5c89 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -359,7 +359,8 @@ __xfs_sb_from_disk(
 	to->sb_imax_pct = from->sb_imax_pct;
 	if (percpu_counter_initialized(&to->sb_icount))
 		percpu_counter_set(&to->sb_icount, be64_to_cpu(from->sb_icount));
-	to->sb_ifree = be64_to_cpu(from->sb_ifree);
+	if (percpu_counter_initialized(&to->sb_icount))
+		percpu_counter_set(&to->sb_ifree, be64_to_cpu(from->sb_ifree));
 	to->sb_fdblocks = be64_to_cpu(from->sb_fdblocks);
 	to->sb_frextents = be64_to_cpu(from->sb_frextents);
 	to->sb_uquotino = be64_to_cpu(from->sb_uquotino);
@@ -494,7 +495,7 @@ xfs_sb_to_disk(
 	to->sb_inprogress = from->sb_inprogress;
 	to->sb_imax_pct = from->sb_imax_pct;
 	to->sb_icount = cpu_to_be64(percpu_counter_sum(&from->sb_icount));
-	to->sb_ifree = cpu_to_be64(from->sb_ifree);
+	to->sb_ifree = cpu_to_be64(percpu_counter_sum(&from->sb_ifree));
 	to->sb_fdblocks = cpu_to_be64(from->sb_fdblocks);
 	to->sb_frextents = cpu_to_be64(from->sb_frextents);
 
@@ -540,6 +541,7 @@ xfs_sb_verify(
 
 	/* don't need to validate icount here */
 	sb.sb_icount.counters = NULL;
+	sb.sb_ifree.counters = NULL;
 
 	/*
 	 * Use call variant which doesn't convert quota flags from disk 
@@ -751,7 +753,7 @@ xfs_initialize_perag_data(
 	 * Overwrite incore superblock counters with just-read data
 	 */
 	spin_lock(&mp->m_sb_lock);
-	sbp->sb_ifree = ifree;
+	percpu_counter_set(&sbp->sb_ifree, ifree);
 	percpu_counter_set(&sbp->sb_icount, ialloc);
 	sbp->sb_fdblocks = bfree + bfreelst + btree;
 	spin_unlock(&mp->m_sb_lock);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 9cc34d2..619a9f3 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -632,11 +632,11 @@ xfs_fs_counts(
 {
 	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
 	cnt->allocino = percpu_counter_read_positive(&mp->m_sb.sb_icount);
+	cnt->freeino = percpu_counter_read_positive(&mp->m_sb.sb_ifree);
 
 	spin_lock(&mp->m_sb_lock);
 	cnt->freedata = mp->m_sb.sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
 	cnt->freertx = mp->m_sb.sb_frextents;
-	cnt->freeino = mp->m_sb.sb_ifree;
 	spin_unlock(&mp->m_sb_lock);
 	return 0;
 }
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index df5ec55..8e8924f 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1136,13 +1136,12 @@ xfs_mod_incore_sb_unlocked(
 		}
 		return 0;
 	case XFS_SBS_IFREE:
-		lcounter = (long long)mp->m_sb.sb_ifree;
-		lcounter += delta;
-		if (lcounter < 0) {
+		percpu_counter_add(&mp->m_sb.sb_ifree, delta);
+		if (percpu_counter_compare(&mp->m_sb.sb_ifree, 0) < 0) {
 			ASSERT(0);
+			percpu_counter_add(&mp->m_sb.sb_ifree, -delta);
 			return -EINVAL;
 		}
-		mp->m_sb.sb_ifree = lcounter;
 		return 0;
 	case XFS_SBS_FDBLOCKS:
 		lcounter = (long long)
@@ -1288,9 +1287,9 @@ xfs_mod_incore_sb(
 	int			status;
 
 #ifdef HAVE_PERCPU_SB
-	ASSERT(field < XFS_SBS_IFREE || field > XFS_SBS_FDBLOCKS);
+	ASSERT(field != XFS_SBS_FDBLOCKS);
 #endif
-	if (field == XFS_SBS_ICOUNT)
+	if (field == XFS_SBS_ICOUNT || field == XFS_SBS_IFREE)
 		return xfs_mod_incore_sb_unlocked(mp, field, delta, rsvd);
 
 	spin_lock(&mp->m_sb_lock);
@@ -1495,7 +1494,6 @@ xfs_icsb_cpu_notify(
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		xfs_icsb_lock(mp);
-		xfs_icsb_balance_counter(mp, XFS_SBS_IFREE, 0);
 		xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS, 0);
 		xfs_icsb_unlock(mp);
 		break;
@@ -1506,15 +1504,12 @@ xfs_icsb_cpu_notify(
 		 * re-enable the counters. */
 		xfs_icsb_lock(mp);
 		spin_lock(&mp->m_sb_lock);
-		xfs_icsb_disable_counter(mp, XFS_SBS_IFREE);
 		xfs_icsb_disable_counter(mp, XFS_SBS_FDBLOCKS);
 
-		mp->m_sb.sb_ifree += cntp->icsb_ifree;
 		mp->m_sb.sb_fdblocks += cntp->icsb_fdblocks;
 
 		memset(cntp, 0, sizeof(xfs_icsb_cnts_t));
 
-		xfs_icsb_balance_counter_locked(mp, XFS_SBS_IFREE, 0);
 		xfs_icsb_balance_counter_locked(mp, XFS_SBS_FDBLOCKS, 0);
 		spin_unlock(&mp->m_sb_lock);
 		xfs_icsb_unlock(mp);
@@ -1536,11 +1531,13 @@ xfs_icsb_init_counters(
 	if (i)
 		return ENOMEM;
 
+	i = percpu_counter_init(&mp->m_sb.sb_ifree, 0, GFP_KERNEL);
+	if (i)
+		goto free_icount;
+
 	mp->m_sb_cnts = alloc_percpu(xfs_icsb_cnts_t);
-	if (!mp->m_sb_cnts) {
-		percpu_counter_destroy(&mp->m_sb.sb_icount);
-		return -ENOMEM;
-	}
+	if (!mp->m_sb_cnts)
+		goto free_ifree;
 
 	for_each_online_cpu(i) {
 		cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
@@ -1562,6 +1559,12 @@ xfs_icsb_init_counters(
 #endif /* CONFIG_HOTPLUG_CPU */
 
 	return 0;
+
+free_ifree:
+	percpu_counter_destroy(&mp->m_sb.sb_ifree);
+free_icount:
+	percpu_counter_destroy(&mp->m_sb.sb_icount);
+	return -ENOMEM;
 }
 
 void
@@ -1574,7 +1577,6 @@ xfs_icsb_reinit_counters(
 	 * initial balance kicks us off correctly
 	 */
 	mp->m_icsb_counters = -1;
-	xfs_icsb_balance_counter(mp, XFS_SBS_IFREE, 0);
 	xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS, 0);
 	xfs_icsb_unlock(mp);
 }
@@ -1589,6 +1591,7 @@ xfs_icsb_destroy_counters(
 	}
 
 	percpu_counter_destroy(&mp->m_sb.sb_icount);
+	percpu_counter_destroy(&mp->m_sb.sb_ifree);
 
 	mutex_destroy(&mp->m_icsb_mutex);
 }
@@ -1652,7 +1655,6 @@ xfs_icsb_count(
 
 	for_each_online_cpu(i) {
 		cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
-		cnt->icsb_ifree += cntp->icsb_ifree;
 		cnt->icsb_fdblocks += cntp->icsb_fdblocks;
 	}
 
@@ -1665,7 +1667,7 @@ xfs_icsb_counter_disabled(
 	xfs_mount_t	*mp,
 	xfs_sb_field_t	field)
 {
-	ASSERT((field >= XFS_SBS_IFREE) && (field <= XFS_SBS_FDBLOCKS));
+	ASSERT(field == XFS_SBS_FDBLOCKS);
 	return test_bit(field, &mp->m_icsb_counters);
 }
 
@@ -1676,7 +1678,7 @@ xfs_icsb_disable_counter(
 {
 	xfs_icsb_cnts_t	cnt;
 
-	ASSERT((field >= XFS_SBS_IFREE) && (field <= XFS_SBS_FDBLOCKS));
+	ASSERT(field == XFS_SBS_FDBLOCKS);
 
 	/*
 	 * If we are already disabled, then there is nothing to do
@@ -1695,9 +1697,6 @@ xfs_icsb_disable_counter(
 
 		xfs_icsb_count(mp, &cnt, XFS_ICSB_LAZY_COUNT);
 		switch(field) {
-		case XFS_SBS_IFREE:
-			mp->m_sb.sb_ifree = cnt.icsb_ifree;
-			break;
 		case XFS_SBS_FDBLOCKS:
 			mp->m_sb.sb_fdblocks = cnt.icsb_fdblocks;
 			break;
@@ -1719,15 +1718,12 @@ xfs_icsb_enable_counter(
 	xfs_icsb_cnts_t	*cntp;
 	int		i;
 
-	ASSERT((field >= XFS_SBS_IFREE) && (field <= XFS_SBS_FDBLOCKS));
+	ASSERT(field == XFS_SBS_FDBLOCKS);
 
 	xfs_icsb_lock_all_counters(mp);
 	for_each_online_cpu(i) {
 		cntp = per_cpu_ptr(mp->m_sb_cnts, i);
 		switch (field) {
-		case XFS_SBS_IFREE:
-			cntp->icsb_ifree = count + resid;
-			break;
 		case XFS_SBS_FDBLOCKS:
 			cntp->icsb_fdblocks = count + resid;
 			break;
@@ -1750,8 +1746,6 @@ xfs_icsb_sync_counters_locked(
 
 	xfs_icsb_count(mp, &cnt, flags);
 
-	if (!xfs_icsb_counter_disabled(mp, XFS_SBS_IFREE))
-		mp->m_sb.sb_ifree = cnt.icsb_ifree;
 	if (!xfs_icsb_counter_disabled(mp, XFS_SBS_FDBLOCKS))
 		mp->m_sb.sb_fdblocks = cnt.icsb_fdblocks;
 }
@@ -1803,12 +1797,6 @@ xfs_icsb_balance_counter_locked(
 
 	/* update counters  - first CPU gets residual*/
 	switch (field) {
-	case XFS_SBS_IFREE:
-		count = mp->m_sb.sb_ifree;
-		resid = do_div(count, weight);
-		if (count < max(min, XFS_ICSB_INO_CNTR_REENABLE))
-			return;
-		break;
 	case XFS_SBS_FDBLOCKS:
 		count = mp->m_sb.sb_fdblocks;
 		resid = do_div(count, weight);
@@ -1863,14 +1851,6 @@ again:
 	}
 
 	switch (field) {
-	case XFS_SBS_IFREE:
-		lcounter = icsbp->icsb_ifree;
-		lcounter += delta;
-		if (unlikely(lcounter < 0))
-			goto balance_counter;
-		icsbp->icsb_ifree = lcounter;
-		break;
-
 	case XFS_SBS_FDBLOCKS:
 		BUG_ON((mp->m_resblks - mp->m_resblks_avail) != 0);
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 408e2fe..c17bfa4 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1088,6 +1088,7 @@ xfs_fs_statfs(
 	struct xfs_inode	*ip = XFS_I(dentry->d_inode);
 	__uint64_t		fakeinos, id;
 	__uint64_t		sb_icount;
+	__uint64_t		sb_ifree;
 	xfs_extlen_t		lsize;
 	__int64_t		ffree;
 
@@ -1100,6 +1101,7 @@ xfs_fs_statfs(
 
 	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
 	sb_icount = percpu_counter_sum(&sbp->sb_icount);
+	sb_ifree = percpu_counter_sum(&sbp->sb_ifree);
 
 	spin_lock(&mp->m_sb_lock);
 	statp->f_bsize = sbp->sb_blocksize;
@@ -1116,7 +1118,7 @@ xfs_fs_statfs(
 					mp->m_maxicount);
 
 	/* make sure statp->f_ffree does not underflow */
-	ffree = statp->f_files - (sb_icount - sbp->sb_ifree);
+	ffree = statp->f_files - (sb_icount - sb_ifree);
 	statp->f_ffree = max_t(__int64_t, ffree, 0);
 
 	spin_unlock(&mp->m_sb_lock);
diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
index fa5603c..6efc7a2 100644
--- a/fs/xfs/xfs_super.h
+++ b/fs/xfs/xfs_super.h
@@ -98,8 +98,8 @@ struct xfs_sb {
 					/* statistics */
 
 	struct percpu_counter	sb_icount;	/* allocated inodes */
+	struct percpu_counter	sb_ifree;	/* free inodes */
 
-	__uint64_t	sb_ifree;	/* free inodes */
 	__uint64_t	sb_fdblocks;	/* free data blocks */
 	__uint64_t	sb_frextents;	/* free realtime extents */
 	xfs_ino_t	sb_uquotino;	/* user quota inode */
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index d78b0ae..c54d4b7 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -560,8 +560,7 @@ xfs_trans_unreserve_and_mod_sb(
 	}
 
 	if (ifreedelta) {
-		error = xfs_icsb_modify_counters(mp, XFS_SBS_IFREE,
-						 ifreedelta, rsvd);
+		error = xfs_mod_incore_sb(mp, XFS_SBS_IFREE, ifreedelta, rsvd);
 		if (error)
 			goto out_undo_icount;
 	}
@@ -630,7 +629,7 @@ xfs_trans_unreserve_and_mod_sb(
 
 out_undo_ifreecount:
 	if (ifreedelta)
-		xfs_icsb_modify_counters(mp, XFS_SBS_IFREE, -ifreedelta, rsvd);
+		xfs_mod_incore_sb(mp, XFS_SBS_IFREE, -ifreedelta, rsvd);
 out_undo_icount:
 	if (idelta)
 		xfs_mod_incore_sb(mp, XFS_SBS_ICOUNT, -idelta, rsvd);
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
