Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBD1M5aW147904 for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 19:22:05 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A6820143F7F1
	for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 17:23:53 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	LKWPyQaEbqCQTpeM for <xfs@oss.sgi.com>;
	Sun, 12 Dec 2010 17:23:52 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	49618381-1927428
	for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 11:53:51 +1030 (CDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] xfs: use generic per-cpu counter infrastructure
Date: Mon, 13 Dec 2010 12:21:52 +1100
Message-Id: <1292203313-15570-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1292203313-15570-1-git-send-email-david@fromorbit.com>
References: <1292203313-15570-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl

From: Dave Chinner <dchinner@redhat.com>

XFS has a per-cpu counter implementation for in-core superblock
counters that pre-dated the generic implementation. It is complex
and baroque as it is tailored directly to the needs of ENOSPC
detection.

Now that the generic percpu counter infrastructure has the
percpu_counter_add_unless_lt() function that implements the
necessary threshold checks for us, switch the XFS per-cpu
superblock counters to use the generic percpu counter
infrastructure.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_linux.h |    9 -
 fs/xfs/linux-2.6/xfs_super.c |    4 +-
 fs/xfs/xfs_fsops.c           |    4 +-
 fs/xfs/xfs_mount.c           |  802 ++++++++----------------------------------
 fs/xfs/xfs_mount.h           |   71 +---
 5 files changed, 171 insertions(+), 719 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_linux.h b/fs/xfs/linux-2.6/xfs_linux.h
index 214ddd7..9fa4f2a 100644
--- a/fs/xfs/linux-2.6/xfs_linux.h
+++ b/fs/xfs/linux-2.6/xfs_linux.h
@@ -88,15 +88,6 @@
 #include <xfs_super.h>
 #include <xfs_buf.h>
 
-/*
- * Feature macros (disable/enable)
- */
-#ifdef CONFIG_SMP
-#define HAVE_PERCPU_SB	/* per cpu superblock counters are a 2.6 feature */
-#else
-#undef  HAVE_PERCPU_SB	/* per cpu superblock counters are a 2.6 feature */
-#endif
-
 #define irix_sgid_inherit	xfs_params.sgid_inherit.val
 #define irix_symlink_mode	xfs_params.symlink_mode.val
 #define xfs_panic_mask		xfs_params.panic_mask.val
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index c45b323..abcda07 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1229,9 +1229,9 @@ xfs_fs_statfs(
 	statp->f_fsid.val[0] = (u32)id;
 	statp->f_fsid.val[1] = (u32)(id >> 32);
 
-	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
-
 	spin_lock(&mp->m_sb_lock);
+	xfs_icsb_sync_counters(mp);
+
 	statp->f_bsize = sbp->sb_blocksize;
 	lsize = sbp->sb_logstart ? sbp->sb_logblocks : 0;
 	statp->f_blocks = sbp->sb_dblocks - lsize;
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index a7c116e..fb9a9c8 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -478,8 +478,8 @@ xfs_fs_counts(
 	xfs_mount_t		*mp,
 	xfs_fsop_counts_t	*cnt)
 {
-	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
 	spin_lock(&mp->m_sb_lock);
+	xfs_icsb_sync_counters(mp);
 	cnt->freedata = mp->m_sb.sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
 	cnt->freertx = mp->m_sb.sb_frextents;
 	cnt->freeino = mp->m_sb.sb_ifree;
@@ -540,7 +540,7 @@ xfs_reserve_blocks(
 	 */
 retry:
 	spin_lock(&mp->m_sb_lock);
-	xfs_icsb_sync_counters_locked(mp, 0);
+	xfs_icsb_sync_counters(mp);
 
 	/*
 	 * If our previous reservation was larger than the current value,
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 19e9dfa..16be1b1 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -46,19 +46,6 @@
 
 STATIC void	xfs_unmountfs_wait(xfs_mount_t *);
 
-
-#ifdef HAVE_PERCPU_SB
-STATIC void	xfs_icsb_balance_counter(xfs_mount_t *, xfs_sb_field_t,
-						int);
-STATIC void	xfs_icsb_balance_counter_locked(xfs_mount_t *, xfs_sb_field_t,
-						int);
-STATIC void	xfs_icsb_disable_counter(xfs_mount_t *, xfs_sb_field_t);
-#else
-
-#define xfs_icsb_balance_counter(mp, a, b)		do { } while (0)
-#define xfs_icsb_balance_counter_locked(mp, a, b)	do { } while (0)
-#endif
-
 static const struct {
 	short offset;
 	short type;	/* 0 = integer
@@ -281,6 +268,71 @@ xfs_free_perag(
 }
 
 /*
+ * Per-cpu incore superblock counters
+ *
+ * This provides distributed per cpu counters for contended fields (e.g. free
+ * block count).  Difficulties arise in that the incore sb is used for ENOSPC
+ * checking, and hence needs to be accurately read when we are running low on
+ * space. Hence We need to check against counter error bounds and determine how
+ * accurately to sum based on that metric. The percpu counters take care of
+ * this for us, so we only need to modify the fast path to handle per-cpu
+ * counter error cases.
+ */
+void
+xfs_icsb_reinit_counters(
+	struct xfs_mount	*mp)
+{
+	percpu_counter_set(&mp->m_icsb[XFS_ICSB_FDBLOCKS],
+						mp->m_sb.sb_fdblocks);
+	percpu_counter_set(&mp->m_icsb[XFS_ICSB_IFREE], mp->m_sb.sb_ifree);
+	percpu_counter_set(&mp->m_icsb[XFS_ICSB_ICOUNT], mp->m_sb.sb_icount);
+}
+
+int
+xfs_icsb_init_counters(
+	struct xfs_mount	*mp)
+{
+	int			i;
+	int			error;
+
+	for (i = 0; i < XFS_ICSB_MAX; i++) {
+		error = percpu_counter_init(&mp->m_icsb[i], 0);
+		if (error)
+			goto out_error;
+	}
+	xfs_icsb_reinit_counters(mp);
+	return 0;
+
+out_error:
+	for (; i >= 0; i--)
+		percpu_counter_destroy(&mp->m_icsb[i]);
+	return error;
+}
+
+void
+xfs_icsb_destroy_counters(
+	xfs_mount_t	*mp)
+{
+	int		i;
+
+	for (i = 0; i < XFS_ICSB_MAX; i++)
+		percpu_counter_destroy(&mp->m_icsb[i]);
+}
+
+void
+xfs_icsb_sync_counters(
+	xfs_mount_t	*mp)
+{
+	assert_spin_locked(&mp->m_sb_lock);
+	mp->m_sb.sb_icount =
+		percpu_counter_sum_positive(&mp->m_icsb[XFS_ICSB_ICOUNT]);
+	mp->m_sb.sb_ifree =
+		percpu_counter_sum_positive(&mp->m_icsb[XFS_ICSB_IFREE]);
+	mp->m_sb.sb_fdblocks =
+		percpu_counter_sum_positive(&mp->m_icsb[XFS_ICSB_FDBLOCKS]);
+}
+
+/*
  * Check size of device based on the (data/realtime) block count.
  * Note: this check is used by the growfs code as well as mount.
  */
@@ -1562,7 +1614,9 @@ xfs_log_sbcount(
 	if (!xfs_fs_writable(mp))
 		return 0;
 
-	xfs_icsb_sync_counters(mp, 0);
+	spin_lock(&mp->m_sb_lock);
+	xfs_icsb_sync_counters(mp);
+	spin_unlock(&mp->m_sb_lock);
 
 	/*
 	 * we don't need to do this if we are updating the superblock
@@ -1674,9 +1728,8 @@ xfs_mod_incore_sb_unlocked(
 	int64_t		delta,
 	int		rsvd)
 {
-	int		scounter;	/* short counter for 32 bit fields */
-	long long	lcounter;	/* long counter for 64 bit fields */
-	long long	res_used, rem;
+	int		scounter = 0;	/* short counter for 32 bit fields */
+	long long	lcounter = 0;	/* long counter for 64 bit fields */
 
 	/*
 	 * With the in-core superblock spin lock held, switch
@@ -1685,66 +1738,6 @@ xfs_mod_incore_sb_unlocked(
 	 * 0, then do not apply the delta and return EINVAL.
 	 */
 	switch (field) {
-	case XFS_SBS_ICOUNT:
-		lcounter = (long long)mp->m_sb.sb_icount;
-		lcounter += delta;
-		if (lcounter < 0) {
-			ASSERT(0);
-			return XFS_ERROR(EINVAL);
-		}
-		mp->m_sb.sb_icount = lcounter;
-		return 0;
-	case XFS_SBS_IFREE:
-		lcounter = (long long)mp->m_sb.sb_ifree;
-		lcounter += delta;
-		if (lcounter < 0) {
-			ASSERT(0);
-			return XFS_ERROR(EINVAL);
-		}
-		mp->m_sb.sb_ifree = lcounter;
-		return 0;
-	case XFS_SBS_FDBLOCKS:
-		lcounter = (long long)
-			mp->m_sb.sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
-		res_used = (long long)(mp->m_resblks - mp->m_resblks_avail);
-
-		if (delta > 0) {		/* Putting blocks back */
-			if (res_used > delta) {
-				mp->m_resblks_avail += delta;
-			} else {
-				rem = delta - res_used;
-				mp->m_resblks_avail = mp->m_resblks;
-				lcounter += rem;
-			}
-		} else {				/* Taking blocks away */
-			lcounter += delta;
-			if (lcounter >= 0) {
-				mp->m_sb.sb_fdblocks = lcounter +
-							XFS_ALLOC_SET_ASIDE(mp);
-				return 0;
-			}
-
-			/*
-			 * We are out of blocks, use any available reserved
-			 * blocks if were allowed to.
-			 */
-			if (!rsvd)
-				return XFS_ERROR(ENOSPC);
-
-			lcounter = (long long)mp->m_resblks_avail + delta;
-			if (lcounter >= 0) {
-				mp->m_resblks_avail = lcounter;
-				return 0;
-			}
-			printk_once(KERN_WARNING
-				"Filesystem \"%s\": reserve blocks depleted! "
-				"Consider increasing reserve pool size.",
-				mp->m_fsname);
-			return XFS_ERROR(ENOSPC);
-		}
-
-		mp->m_sb.sb_fdblocks = lcounter + XFS_ALLOC_SET_ASIDE(mp);
-		return 0;
 	case XFS_SBS_FREXTENTS:
 		lcounter = (long long)mp->m_sb.sb_frextents;
 		lcounter += delta;
@@ -1846,9 +1839,7 @@ xfs_mod_incore_sb(
 {
 	int			status;
 
-#ifdef HAVE_PERCPU_SB
 	ASSERT(field < XFS_SBS_ICOUNT || field > XFS_SBS_FDBLOCKS);
-#endif
 	spin_lock(&mp->m_sb_lock);
 	status = xfs_mod_incore_sb_unlocked(mp, field, delta, rsvd);
 	spin_unlock(&mp->m_sb_lock);
@@ -1907,6 +1898,90 @@ unwind:
 	return error;
 }
 
+int
+xfs_icsb_modify_counters(
+	xfs_mount_t	*mp,
+	xfs_sb_field_t	field,
+	int64_t		delta,
+	int		rsvd)
+{
+	int64_t		lcounter;
+	int64_t		res_used;
+	int		ret = 0;
+
+
+	switch (field) {
+	case XFS_SBS_ICOUNT:
+		ret = percpu_counter_add_unless_lt(&mp->m_icsb[XFS_SBS_ICOUNT],
+							delta, 0);
+		if (ret < 0) {
+			ASSERT(0);
+			return XFS_ERROR(EINVAL);
+		}
+		return 0;
+
+	case XFS_SBS_IFREE:
+		ret = percpu_counter_add_unless_lt(&mp->m_icsb[XFS_SBS_IFREE],
+							delta, 0);
+		if (ret < 0) {
+			ASSERT(0);
+			return XFS_ERROR(EINVAL);
+		}
+		return 0;
+
+	case XFS_SBS_FDBLOCKS:
+		/*
+		 * if we are putting blocks back, put them into the reserve
+		 * block pool first.
+		 */
+		if (mp->m_resblks != mp->m_resblks_avail && delta > 0) {
+			spin_lock(&mp->m_sb_lock);
+			res_used = (int64_t)(mp->m_resblks -
+						mp->m_resblks_avail);
+			if (res_used > delta) {
+				mp->m_resblks_avail += delta;
+				delta = 0;
+			} else {
+				delta -= res_used;
+				mp->m_resblks_avail = mp->m_resblks;
+			}
+			spin_unlock(&mp->m_sb_lock);
+			if (!delta)
+				return 0;
+		}
+
+		/* try the change */
+		ret = percpu_counter_add_unless_lt(&mp->m_icsb[XFS_ICSB_FDBLOCKS],
+						delta, XFS_ALLOC_SET_ASIDE(mp));
+		if (likely(ret >= 0))
+			return 0;
+
+		/* ENOSPC */
+		ASSERT(delta < 0);
+
+		if (!rsvd)
+			return XFS_ERROR(ENOSPC);
+
+		spin_lock(&mp->m_sb_lock);
+		lcounter = (int64_t)mp->m_resblks_avail + delta;
+		if (lcounter >= 0) {
+			mp->m_resblks_avail = lcounter;
+			spin_unlock(&mp->m_sb_lock);
+			return 0;
+		}
+		spin_unlock(&mp->m_sb_lock);
+		printk_once(KERN_WARNING
+			"Filesystem \"%s\": reserve blocks depleted! "
+			"Consider increasing reserve pool size.",
+			mp->m_fsname);
+		return XFS_ERROR(ENOSPC);
+	default:
+		ASSERT(0);
+		return XFS_ERROR(EINVAL);
+	}
+	return 0;
+}
+
 /*
  * xfs_getsb() is called to obtain the buffer for the superblock.
  * The buffer is returned locked and read in from disk.
@@ -2000,572 +2075,3 @@ xfs_dev_is_read_only(
 	}
 	return 0;
 }
-
-#ifdef HAVE_PERCPU_SB
-/*
- * Per-cpu incore superblock counters
- *
- * Simple concept, difficult implementation
- *
- * Basically, replace the incore superblock counters with a distributed per cpu
- * counter for contended fields (e.g.  free block count).
- *
- * Difficulties arise in that the incore sb is used for ENOSPC checking, and
- * hence needs to be accurately read when we are running low on space. Hence
- * there is a method to enable and disable the per-cpu counters based on how
- * much "stuff" is available in them.
- *
- * Basically, a counter is enabled if there is enough free resource to justify
- * running a per-cpu fast-path. If the per-cpu counter runs out (i.e. a local
- * ENOSPC), then we disable the counters to synchronise all callers and
- * re-distribute the available resources.
- *
- * If, once we redistributed the available resources, we still get a failure,
- * we disable the per-cpu counter and go through the slow path.
- *
- * The slow path is the current xfs_mod_incore_sb() function.  This means that
- * when we disable a per-cpu counter, we need to drain its resources back to
- * the global superblock. We do this after disabling the counter to prevent
- * more threads from queueing up on the counter.
- *
- * Essentially, this means that we still need a lock in the fast path to enable
- * synchronisation between the global counters and the per-cpu counters. This
- * is not a problem because the lock will be local to a CPU almost all the time
- * and have little contention except when we get to ENOSPC conditions.
- *
- * Basically, this lock becomes a barrier that enables us to lock out the fast
- * path while we do things like enabling and disabling counters and
- * synchronising the counters.
- *
- * Locking rules:
- *
- * 	1. m_sb_lock before picking up per-cpu locks
- * 	2. per-cpu locks always picked up via for_each_online_cpu() order
- * 	3. accurate counter sync requires m_sb_lock + per cpu locks
- * 	4. modifying per-cpu counters requires holding per-cpu lock
- * 	5. modifying global counters requires holding m_sb_lock
- *	6. enabling or disabling a counter requires holding the m_sb_lock 
- *	   and _none_ of the per-cpu locks.
- *
- * Disabled counters are only ever re-enabled by a balance operation
- * that results in more free resources per CPU than a given threshold.
- * To ensure counters don't remain disabled, they are rebalanced when
- * the global resource goes above a higher threshold (i.e. some hysteresis
- * is present to prevent thrashing).
- */
-
-#ifdef CONFIG_HOTPLUG_CPU
-/*
- * hot-plug CPU notifier support.
- *
- * We need a notifier per filesystem as we need to be able to identify
- * the filesystem to balance the counters out. This is achieved by
- * having a notifier block embedded in the xfs_mount_t and doing pointer
- * magic to get the mount pointer from the notifier block address.
- */
-STATIC int
-xfs_icsb_cpu_notify(
-	struct notifier_block *nfb,
-	unsigned long action,
-	void *hcpu)
-{
-	xfs_icsb_cnts_t *cntp;
-	xfs_mount_t	*mp;
-
-	mp = (xfs_mount_t *)container_of(nfb, xfs_mount_t, m_icsb_notifier);
-	cntp = (xfs_icsb_cnts_t *)
-			per_cpu_ptr(mp->m_sb_cnts, (unsigned long)hcpu);
-	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		/* Easy Case - initialize the area and locks, and
-		 * then rebalance when online does everything else for us. */
-		memset(cntp, 0, sizeof(xfs_icsb_cnts_t));
-		break;
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		xfs_icsb_lock(mp);
-		xfs_icsb_balance_counter(mp, XFS_SBS_ICOUNT, 0);
-		xfs_icsb_balance_counter(mp, XFS_SBS_IFREE, 0);
-		xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS, 0);
-		xfs_icsb_unlock(mp);
-		break;
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		/* Disable all the counters, then fold the dead cpu's
-		 * count into the total on the global superblock and
-		 * re-enable the counters. */
-		xfs_icsb_lock(mp);
-		spin_lock(&mp->m_sb_lock);
-		xfs_icsb_disable_counter(mp, XFS_SBS_ICOUNT);
-		xfs_icsb_disable_counter(mp, XFS_SBS_IFREE);
-		xfs_icsb_disable_counter(mp, XFS_SBS_FDBLOCKS);
-
-		mp->m_sb.sb_icount += cntp->icsb_icount;
-		mp->m_sb.sb_ifree += cntp->icsb_ifree;
-		mp->m_sb.sb_fdblocks += cntp->icsb_fdblocks;
-
-		memset(cntp, 0, sizeof(xfs_icsb_cnts_t));
-
-		xfs_icsb_balance_counter_locked(mp, XFS_SBS_ICOUNT, 0);
-		xfs_icsb_balance_counter_locked(mp, XFS_SBS_IFREE, 0);
-		xfs_icsb_balance_counter_locked(mp, XFS_SBS_FDBLOCKS, 0);
-		spin_unlock(&mp->m_sb_lock);
-		xfs_icsb_unlock(mp);
-		break;
-	}
-
-	return NOTIFY_OK;
-}
-#endif /* CONFIG_HOTPLUG_CPU */
-
-int
-xfs_icsb_init_counters(
-	xfs_mount_t	*mp)
-{
-	xfs_icsb_cnts_t *cntp;
-	int		i;
-
-	mp->m_sb_cnts = alloc_percpu(xfs_icsb_cnts_t);
-	if (mp->m_sb_cnts == NULL)
-		return -ENOMEM;
-
-#ifdef CONFIG_HOTPLUG_CPU
-	mp->m_icsb_notifier.notifier_call = xfs_icsb_cpu_notify;
-	mp->m_icsb_notifier.priority = 0;
-	register_hotcpu_notifier(&mp->m_icsb_notifier);
-#endif /* CONFIG_HOTPLUG_CPU */
-
-	for_each_online_cpu(i) {
-		cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
-		memset(cntp, 0, sizeof(xfs_icsb_cnts_t));
-	}
-
-	mutex_init(&mp->m_icsb_mutex);
-
-	/*
-	 * start with all counters disabled so that the
-	 * initial balance kicks us off correctly
-	 */
-	mp->m_icsb_counters = -1;
-	return 0;
-}
-
-void
-xfs_icsb_reinit_counters(
-	xfs_mount_t	*mp)
-{
-	xfs_icsb_lock(mp);
-	/*
-	 * start with all counters disabled so that the
-	 * initial balance kicks us off correctly
-	 */
-	mp->m_icsb_counters = -1;
-	xfs_icsb_balance_counter(mp, XFS_SBS_ICOUNT, 0);
-	xfs_icsb_balance_counter(mp, XFS_SBS_IFREE, 0);
-	xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS, 0);
-	xfs_icsb_unlock(mp);
-}
-
-void
-xfs_icsb_destroy_counters(
-	xfs_mount_t	*mp)
-{
-	if (mp->m_sb_cnts) {
-		unregister_hotcpu_notifier(&mp->m_icsb_notifier);
-		free_percpu(mp->m_sb_cnts);
-	}
-	mutex_destroy(&mp->m_icsb_mutex);
-}
-
-STATIC void
-xfs_icsb_lock_cntr(
-	xfs_icsb_cnts_t	*icsbp)
-{
-	while (test_and_set_bit(XFS_ICSB_FLAG_LOCK, &icsbp->icsb_flags)) {
-		ndelay(1000);
-	}
-}
-
-STATIC void
-xfs_icsb_unlock_cntr(
-	xfs_icsb_cnts_t	*icsbp)
-{
-	clear_bit(XFS_ICSB_FLAG_LOCK, &icsbp->icsb_flags);
-}
-
-
-STATIC void
-xfs_icsb_lock_all_counters(
-	xfs_mount_t	*mp)
-{
-	xfs_icsb_cnts_t *cntp;
-	int		i;
-
-	for_each_online_cpu(i) {
-		cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
-		xfs_icsb_lock_cntr(cntp);
-	}
-}
-
-STATIC void
-xfs_icsb_unlock_all_counters(
-	xfs_mount_t	*mp)
-{
-	xfs_icsb_cnts_t *cntp;
-	int		i;
-
-	for_each_online_cpu(i) {
-		cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
-		xfs_icsb_unlock_cntr(cntp);
-	}
-}
-
-STATIC void
-xfs_icsb_count(
-	xfs_mount_t	*mp,
-	xfs_icsb_cnts_t	*cnt,
-	int		flags)
-{
-	xfs_icsb_cnts_t *cntp;
-	int		i;
-
-	memset(cnt, 0, sizeof(xfs_icsb_cnts_t));
-
-	if (!(flags & XFS_ICSB_LAZY_COUNT))
-		xfs_icsb_lock_all_counters(mp);
-
-	for_each_online_cpu(i) {
-		cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
-		cnt->icsb_icount += cntp->icsb_icount;
-		cnt->icsb_ifree += cntp->icsb_ifree;
-		cnt->icsb_fdblocks += cntp->icsb_fdblocks;
-	}
-
-	if (!(flags & XFS_ICSB_LAZY_COUNT))
-		xfs_icsb_unlock_all_counters(mp);
-}
-
-STATIC int
-xfs_icsb_counter_disabled(
-	xfs_mount_t	*mp,
-	xfs_sb_field_t	field)
-{
-	ASSERT((field >= XFS_SBS_ICOUNT) && (field <= XFS_SBS_FDBLOCKS));
-	return test_bit(field, &mp->m_icsb_counters);
-}
-
-STATIC void
-xfs_icsb_disable_counter(
-	xfs_mount_t	*mp,
-	xfs_sb_field_t	field)
-{
-	xfs_icsb_cnts_t	cnt;
-
-	ASSERT((field >= XFS_SBS_ICOUNT) && (field <= XFS_SBS_FDBLOCKS));
-
-	/*
-	 * If we are already disabled, then there is nothing to do
-	 * here. We check before locking all the counters to avoid
-	 * the expensive lock operation when being called in the
-	 * slow path and the counter is already disabled. This is
-	 * safe because the only time we set or clear this state is under
-	 * the m_icsb_mutex.
-	 */
-	if (xfs_icsb_counter_disabled(mp, field))
-		return;
-
-	xfs_icsb_lock_all_counters(mp);
-	if (!test_and_set_bit(field, &mp->m_icsb_counters)) {
-		/* drain back to superblock */
-
-		xfs_icsb_count(mp, &cnt, XFS_ICSB_LAZY_COUNT);
-		switch(field) {
-		case XFS_SBS_ICOUNT:
-			mp->m_sb.sb_icount = cnt.icsb_icount;
-			break;
-		case XFS_SBS_IFREE:
-			mp->m_sb.sb_ifree = cnt.icsb_ifree;
-			break;
-		case XFS_SBS_FDBLOCKS:
-			mp->m_sb.sb_fdblocks = cnt.icsb_fdblocks;
-			break;
-		default:
-			BUG();
-		}
-	}
-
-	xfs_icsb_unlock_all_counters(mp);
-}
-
-STATIC void
-xfs_icsb_enable_counter(
-	xfs_mount_t	*mp,
-	xfs_sb_field_t	field,
-	uint64_t	count,
-	uint64_t	resid)
-{
-	xfs_icsb_cnts_t	*cntp;
-	int		i;
-
-	ASSERT((field >= XFS_SBS_ICOUNT) && (field <= XFS_SBS_FDBLOCKS));
-
-	xfs_icsb_lock_all_counters(mp);
-	for_each_online_cpu(i) {
-		cntp = per_cpu_ptr(mp->m_sb_cnts, i);
-		switch (field) {
-		case XFS_SBS_ICOUNT:
-			cntp->icsb_icount = count + resid;
-			break;
-		case XFS_SBS_IFREE:
-			cntp->icsb_ifree = count + resid;
-			break;
-		case XFS_SBS_FDBLOCKS:
-			cntp->icsb_fdblocks = count + resid;
-			break;
-		default:
-			BUG();
-			break;
-		}
-		resid = 0;
-	}
-	clear_bit(field, &mp->m_icsb_counters);
-	xfs_icsb_unlock_all_counters(mp);
-}
-
-void
-xfs_icsb_sync_counters_locked(
-	xfs_mount_t	*mp,
-	int		flags)
-{
-	xfs_icsb_cnts_t	cnt;
-
-	xfs_icsb_count(mp, &cnt, flags);
-
-	if (!xfs_icsb_counter_disabled(mp, XFS_SBS_ICOUNT))
-		mp->m_sb.sb_icount = cnt.icsb_icount;
-	if (!xfs_icsb_counter_disabled(mp, XFS_SBS_IFREE))
-		mp->m_sb.sb_ifree = cnt.icsb_ifree;
-	if (!xfs_icsb_counter_disabled(mp, XFS_SBS_FDBLOCKS))
-		mp->m_sb.sb_fdblocks = cnt.icsb_fdblocks;
-}
-
-/*
- * Accurate update of per-cpu counters to incore superblock
- */
-void
-xfs_icsb_sync_counters(
-	xfs_mount_t	*mp,
-	int		flags)
-{
-	spin_lock(&mp->m_sb_lock);
-	xfs_icsb_sync_counters_locked(mp, flags);
-	spin_unlock(&mp->m_sb_lock);
-}
-
-/*
- * Balance and enable/disable counters as necessary.
- *
- * Thresholds for re-enabling counters are somewhat magic.  inode counts are
- * chosen to be the same number as single on disk allocation chunk per CPU, and
- * free blocks is something far enough zero that we aren't going thrash when we
- * get near ENOSPC. We also need to supply a minimum we require per cpu to
- * prevent looping endlessly when xfs_alloc_space asks for more than will
- * be distributed to a single CPU but each CPU has enough blocks to be
- * reenabled.
- *
- * Note that we can be called when counters are already disabled.
- * xfs_icsb_disable_counter() optimises the counter locking in this case to
- * prevent locking every per-cpu counter needlessly.
- */
-
-#define XFS_ICSB_INO_CNTR_REENABLE	(uint64_t)64
-#define XFS_ICSB_FDBLK_CNTR_REENABLE(mp) \
-		(uint64_t)(512 + XFS_ALLOC_SET_ASIDE(mp))
-STATIC void
-xfs_icsb_balance_counter_locked(
-	xfs_mount_t	*mp,
-	xfs_sb_field_t  field,
-	int		min_per_cpu)
-{
-	uint64_t	count, resid;
-	int		weight = num_online_cpus();
-	uint64_t	min = (uint64_t)min_per_cpu;
-
-	/* disable counter and sync counter */
-	xfs_icsb_disable_counter(mp, field);
-
-	/* update counters  - first CPU gets residual*/
-	switch (field) {
-	case XFS_SBS_ICOUNT:
-		count = mp->m_sb.sb_icount;
-		resid = do_div(count, weight);
-		if (count < max(min, XFS_ICSB_INO_CNTR_REENABLE))
-			return;
-		break;
-	case XFS_SBS_IFREE:
-		count = mp->m_sb.sb_ifree;
-		resid = do_div(count, weight);
-		if (count < max(min, XFS_ICSB_INO_CNTR_REENABLE))
-			return;
-		break;
-	case XFS_SBS_FDBLOCKS:
-		count = mp->m_sb.sb_fdblocks;
-		resid = do_div(count, weight);
-		if (count < max(min, XFS_ICSB_FDBLK_CNTR_REENABLE(mp)))
-			return;
-		break;
-	default:
-		BUG();
-		count = resid = 0;	/* quiet, gcc */
-		break;
-	}
-
-	xfs_icsb_enable_counter(mp, field, count, resid);
-}
-
-STATIC void
-xfs_icsb_balance_counter(
-	xfs_mount_t	*mp,
-	xfs_sb_field_t  fields,
-	int		min_per_cpu)
-{
-	spin_lock(&mp->m_sb_lock);
-	xfs_icsb_balance_counter_locked(mp, fields, min_per_cpu);
-	spin_unlock(&mp->m_sb_lock);
-}
-
-int
-xfs_icsb_modify_counters(
-	xfs_mount_t	*mp,
-	xfs_sb_field_t	field,
-	int64_t		delta,
-	int		rsvd)
-{
-	xfs_icsb_cnts_t	*icsbp;
-	long long	lcounter;	/* long counter for 64 bit fields */
-	int		ret = 0;
-
-	might_sleep();
-again:
-	preempt_disable();
-	icsbp = this_cpu_ptr(mp->m_sb_cnts);
-
-	/*
-	 * if the counter is disabled, go to slow path
-	 */
-	if (unlikely(xfs_icsb_counter_disabled(mp, field)))
-		goto slow_path;
-	xfs_icsb_lock_cntr(icsbp);
-	if (unlikely(xfs_icsb_counter_disabled(mp, field))) {
-		xfs_icsb_unlock_cntr(icsbp);
-		goto slow_path;
-	}
-
-	switch (field) {
-	case XFS_SBS_ICOUNT:
-		lcounter = icsbp->icsb_icount;
-		lcounter += delta;
-		if (unlikely(lcounter < 0))
-			goto balance_counter;
-		icsbp->icsb_icount = lcounter;
-		break;
-
-	case XFS_SBS_IFREE:
-		lcounter = icsbp->icsb_ifree;
-		lcounter += delta;
-		if (unlikely(lcounter < 0))
-			goto balance_counter;
-		icsbp->icsb_ifree = lcounter;
-		break;
-
-	case XFS_SBS_FDBLOCKS:
-		BUG_ON((mp->m_resblks - mp->m_resblks_avail) != 0);
-
-		lcounter = icsbp->icsb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
-		lcounter += delta;
-		if (unlikely(lcounter < 0))
-			goto balance_counter;
-		icsbp->icsb_fdblocks = lcounter + XFS_ALLOC_SET_ASIDE(mp);
-		break;
-	default:
-		BUG();
-		break;
-	}
-	xfs_icsb_unlock_cntr(icsbp);
-	preempt_enable();
-	return 0;
-
-slow_path:
-	preempt_enable();
-
-	/*
-	 * serialise with a mutex so we don't burn lots of cpu on
-	 * the superblock lock. We still need to hold the superblock
-	 * lock, however, when we modify the global structures.
-	 */
-	xfs_icsb_lock(mp);
-
-	/*
-	 * Now running atomically.
-	 *
-	 * If the counter is enabled, someone has beaten us to rebalancing.
-	 * Drop the lock and try again in the fast path....
-	 */
-	if (!(xfs_icsb_counter_disabled(mp, field))) {
-		xfs_icsb_unlock(mp);
-		goto again;
-	}
-
-	/*
-	 * The counter is currently disabled. Because we are
-	 * running atomically here, we know a rebalance cannot
-	 * be in progress. Hence we can go straight to operating
-	 * on the global superblock. We do not call xfs_mod_incore_sb()
-	 * here even though we need to get the m_sb_lock. Doing so
-	 * will cause us to re-enter this function and deadlock.
-	 * Hence we get the m_sb_lock ourselves and then call
-	 * xfs_mod_incore_sb_unlocked() as the unlocked path operates
-	 * directly on the global counters.
-	 */
-	spin_lock(&mp->m_sb_lock);
-	ret = xfs_mod_incore_sb_unlocked(mp, field, delta, rsvd);
-	spin_unlock(&mp->m_sb_lock);
-
-	/*
-	 * Now that we've modified the global superblock, we
-	 * may be able to re-enable the distributed counters
-	 * (e.g. lots of space just got freed). After that
-	 * we are done.
-	 */
-	if (ret != ENOSPC)
-		xfs_icsb_balance_counter(mp, field, 0);
-	xfs_icsb_unlock(mp);
-	return ret;
-
-balance_counter:
-	xfs_icsb_unlock_cntr(icsbp);
-	preempt_enable();
-
-	/*
-	 * We may have multiple threads here if multiple per-cpu
-	 * counters run dry at the same time. This will mean we can
-	 * do more balances than strictly necessary but it is not
-	 * the common slowpath case.
-	 */
-	xfs_icsb_lock(mp);
-
-	/*
-	 * running atomically.
-	 *
-	 * This will leave the counter in the correct state for future
-	 * accesses. After the rebalance, we simply try again and our retry
-	 * will either succeed through the fast path or slow path without
-	 * another balance operation being required.
-	 */
-	xfs_icsb_balance_counter(mp, field, delta);
-	xfs_icsb_unlock(mp);
-	goto again;
-}
-
-#endif
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 5861b49..42d31df 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -65,44 +65,19 @@ struct xfs_nameops;
 struct xfs_ail;
 struct xfs_quotainfo;
 
-#ifdef HAVE_PERCPU_SB
-
 /*
- * Valid per-cpu incore superblock counters. Note that if you add new counters,
- * you may need to define new counter disabled bit field descriptors as there
- * are more possible fields in the superblock that can fit in a bitfield on a
- * 32 bit platform. The XFS_SBS_* values for the current current counters just
- * fit.
+ * Per-cpu incore superblock counters.
  */
-typedef struct xfs_icsb_cnts {
-	uint64_t	icsb_fdblocks;
-	uint64_t	icsb_ifree;
-	uint64_t	icsb_icount;
-	unsigned long	icsb_flags;
-} xfs_icsb_cnts_t;
-
-#define XFS_ICSB_FLAG_LOCK	(1 << 0)	/* counter lock bit */
-
-#define XFS_ICSB_LAZY_COUNT	(1 << 1)	/* accuracy not needed */
+enum {
+	XFS_ICSB_FDBLOCKS = 0,
+	XFS_ICSB_IFREE,
+	XFS_ICSB_ICOUNT,
+	XFS_ICSB_MAX,
+};
 
-extern int	xfs_icsb_init_counters(struct xfs_mount *);
-extern void	xfs_icsb_reinit_counters(struct xfs_mount *);
-extern void	xfs_icsb_destroy_counters(struct xfs_mount *);
-extern void	xfs_icsb_sync_counters(struct xfs_mount *, int);
-extern void	xfs_icsb_sync_counters_locked(struct xfs_mount *, int);
 extern int	xfs_icsb_modify_counters(struct xfs_mount *, xfs_sb_field_t,
 						int64_t, int);
 
-#else
-#define xfs_icsb_init_counters(mp)		(0)
-#define xfs_icsb_destroy_counters(mp)		do { } while (0)
-#define xfs_icsb_reinit_counters(mp)		do { } while (0)
-#define xfs_icsb_sync_counters(mp, flags)	do { } while (0)
-#define xfs_icsb_sync_counters_locked(mp, flags) do { } while (0)
-#define xfs_icsb_modify_counters(mp, field, delta, rsvd) \
-	xfs_mod_incore_sb(mp, field, delta, rsvd)
-#endif
-
 typedef struct xfs_mount {
 	struct super_block	*m_super;
 	xfs_tid_t		m_tid;		/* next unused tid for fs */
@@ -186,12 +161,6 @@ typedef struct xfs_mount {
 	struct xfs_chash	*m_chash;	/* fs private inode per-cluster
 						 * hash table */
 	atomic_t		m_active_trans;	/* number trans frozen */
-#ifdef HAVE_PERCPU_SB
-	xfs_icsb_cnts_t __percpu *m_sb_cnts;	/* per-cpu superblock counters */
-	unsigned long		m_icsb_counters; /* disabled per-cpu counters */
-	struct notifier_block	m_icsb_notifier; /* hotplug cpu notifier */
-	struct mutex		m_icsb_mutex;	/* balancer sync lock */
-#endif
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
 	struct task_struct	*m_sync_task;	/* generalised sync thread */
 	xfs_sync_work_t		m_sync_work;	/* work item for VFS_SYNC */
@@ -202,6 +171,7 @@ typedef struct xfs_mount {
 	__int64_t		m_update_flags;	/* sb flags we need to update
 						   on the next remount,rw */
 	struct shrinker		m_inode_shrink;	/* inode reclaim shrinker */
+	struct percpu_counter	m_icsb[XFS_ICSB_MAX];
 } xfs_mount_t;
 
 /*
@@ -333,26 +303,6 @@ struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *mp, xfs_agnumber_t agno,
 void	xfs_perag_put(struct xfs_perag *pag);
 
 /*
- * Per-cpu superblock locking functions
- */
-#ifdef HAVE_PERCPU_SB
-static inline void
-xfs_icsb_lock(xfs_mount_t *mp)
-{
-	mutex_lock(&mp->m_icsb_mutex);
-}
-
-static inline void
-xfs_icsb_unlock(xfs_mount_t *mp)
-{
-	mutex_unlock(&mp->m_icsb_mutex);
-}
-#else
-#define xfs_icsb_lock(mp)
-#define xfs_icsb_unlock(mp)
-#endif
-
-/*
  * This structure is for use by the xfs_mod_incore_sb_batch() routine.
  * xfs_growfs can specify a few fields which are more than int limit
  */
@@ -379,6 +329,11 @@ extern int	xfs_sb_validate_fsb_count(struct xfs_sb *, __uint64_t);
 
 extern int	xfs_dev_is_read_only(struct xfs_mount *, char *);
 
+extern int	xfs_icsb_init_counters(struct xfs_mount *);
+extern void	xfs_icsb_reinit_counters(struct xfs_mount *);
+extern void	xfs_icsb_destroy_counters(struct xfs_mount *);
+extern void	xfs_icsb_sync_counters(struct xfs_mount *);
+
 #endif	/* __KERNEL__ */
 
 extern void	xfs_mod_sb(struct xfs_trans *, __int64_t);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
