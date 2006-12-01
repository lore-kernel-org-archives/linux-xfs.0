Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Nov 2006 16:42:18 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kB10g5aG009889
	for <xfs@oss.sgi.com>; Thu, 30 Nov 2006 16:42:08 -0800
Date: Fri, 1 Dec 2006 11:41:12 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: Reduce in-core superblock lock contention near ENOSPC
Message-ID: <20061201004112.GW37654165@melbourne.sgi.com>
References: <20061123044122.GU11034@melbourne.sgi.com> <456F1CFC.2060705@sgi.com> <20061130223810.GO37654165@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061130223810.GO37654165@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev@sgi.com, xfs@oss.sgi.com

On Fri, Dec 01, 2006 at 09:38:11AM +1100, David Chinner wrote:
> On Thu, Nov 30, 2006 at 06:03:40PM +0000, Lachlan McIlroy wrote:
> 
> > These changes wouldn't apply cleanly to tot (3 hunks failed in
> > xfs_mount.c) but I couldn't see why.
> 
> Whitespace issue? Try setting:
> 
> $ export QUILT_PATCH_OPTS="--ignore-whitespace"
> 
> I'll apply the patch to a separate tree and see if I hit the same
> problem....

I see the problem - the next patch I am going to send out for
review which is earlier in my series....

The growfs fix changes the delta parameter to xfs_icsb_modify_counters()
from int to int64_t, and that is why the hunks don't apply.

The attached patch should apply (with a 6 line offset to most hunks).

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfs_mount.c |  234 +++++++++++++++++++++++++++++++----------------------
 fs/xfs/xfs_mount.h |    1 
 2 files changed, 142 insertions(+), 93 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.c	2006-10-19 10:29:35.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.c	2006-10-19 10:32:16.626827226 +1000
@@ -52,21 +52,19 @@ STATIC void	xfs_unmountfs_wait(xfs_mount
 
 #ifdef HAVE_PERCPU_SB
 STATIC void	xfs_icsb_destroy_counters(xfs_mount_t *);
-STATIC void	xfs_icsb_balance_counter(xfs_mount_t *, xfs_sb_field_t, int);
+STATIC void	xfs_icsb_balance_counter(xfs_mount_t *, xfs_sb_field_t, int,
+int);
 STATIC void	xfs_icsb_sync_counters(xfs_mount_t *);
 STATIC int	xfs_icsb_modify_counters(xfs_mount_t *, xfs_sb_field_t,
 						int, int);
-STATIC int	xfs_icsb_modify_counters_locked(xfs_mount_t *, xfs_sb_field_t,
-						int, int);
 STATIC int	xfs_icsb_disable_counter(xfs_mount_t *, xfs_sb_field_t);
 
 #else
 
 #define xfs_icsb_destroy_counters(mp)			do { } while (0)
-#define xfs_icsb_balance_counter(mp, a, b)		do { } while (0)
+#define xfs_icsb_balance_counter(mp, a, b, c)		do { } while (0)
 #define xfs_icsb_sync_counters(mp)			do { } while (0)
 #define xfs_icsb_modify_counters(mp, a, b, c)		do { } while (0)
-#define xfs_icsb_modify_counters_locked(mp, a, b, c)	do { } while (0)
 
 #endif
 
@@ -540,9 +538,11 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 		ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
 	}
 
-	xfs_icsb_balance_counter(mp, XFS_SBS_ICOUNT, 0);
-	xfs_icsb_balance_counter(mp, XFS_SBS_IFREE, 0);
-	xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS, 0);
+	mutex_lock(&mp->m_icsb_mutex);
+	xfs_icsb_balance_counter(mp, XFS_SBS_ICOUNT, 0, 0);
+	xfs_icsb_balance_counter(mp, XFS_SBS_IFREE, 0, 0);
+	xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS, 0, 0);
+	mutex_unlock(&mp->m_icsb_mutex);
 
 	mp->m_sb_bp = bp;
 	xfs_buf_relse(bp);
@@ -1479,9 +1479,11 @@ xfs_mod_incore_sb_batch(xfs_mount_t *mp,
 		case XFS_SBS_IFREE:
 		case XFS_SBS_FDBLOCKS:
 			if (!(mp->m_flags & XFS_MOUNT_NO_PERCPU_SB)) {
-				status = xfs_icsb_modify_counters_locked(mp,
+				XFS_SB_UNLOCK(mp, s);
+				status = xfs_icsb_modify_counters(mp,
 							msbp->msb_field,
 							msbp->msb_delta, rsvd);
+				s = XFS_SB_LOCK(mp);
 				break;
 			}
 			/* FALLTHROUGH */
@@ -1515,11 +1517,12 @@ xfs_mod_incore_sb_batch(xfs_mount_t *mp,
 			case XFS_SBS_IFREE:
 			case XFS_SBS_FDBLOCKS:
 				if (!(mp->m_flags & XFS_MOUNT_NO_PERCPU_SB)) {
-					status =
-					    xfs_icsb_modify_counters_locked(mp,
+					XFS_SB_UNLOCK(mp, s);
+					status = xfs_icsb_modify_counters(mp,
 							msbp->msb_field,
 							-(msbp->msb_delta),
 							rsvd);
+					s = XFS_SB_LOCK(mp);
 					break;
 				}
 				/* FALLTHROUGH */
@@ -1727,14 +1730,17 @@ xfs_icsb_cpu_notify(
 		memset(cntp, 0, sizeof(xfs_icsb_cnts_t));
 		break;
 	case CPU_ONLINE:
-		xfs_icsb_balance_counter(mp, XFS_SBS_ICOUNT, 0);
-		xfs_icsb_balance_counter(mp, XFS_SBS_IFREE, 0);
-		xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS, 0);
+		mutex_lock(&mp->m_icsb_mutex);
+		xfs_icsb_balance_counter(mp, XFS_SBS_ICOUNT, 0, 0);
+		xfs_icsb_balance_counter(mp, XFS_SBS_IFREE, 0, 0);
+		xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS, 0, 0);
+		mutex_unlock(&mp->m_icsb_mutex);
 		break;
 	case CPU_DEAD:
 		/* Disable all the counters, then fold the dead cpu's
 		 * count into the total on the global superblock and
 		 * re-enable the counters. */
+		mutex_lock(&mp->m_icsb_mutex);
 		s = XFS_SB_LOCK(mp);
 		xfs_icsb_disable_counter(mp, XFS_SBS_ICOUNT);
 		xfs_icsb_disable_counter(mp, XFS_SBS_IFREE);
@@ -1746,10 +1752,14 @@ xfs_icsb_cpu_notify(
 
 		memset(cntp, 0, sizeof(xfs_icsb_cnts_t));
 
-		xfs_icsb_balance_counter(mp, XFS_SBS_ICOUNT, XFS_ICSB_SB_LOCKED);
-		xfs_icsb_balance_counter(mp, XFS_SBS_IFREE, XFS_ICSB_SB_LOCKED);
-		xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS, XFS_ICSB_SB_LOCKED);
+		xfs_icsb_balance_counter(mp, XFS_SBS_ICOUNT,
+					 XFS_ICSB_SB_LOCKED, 0);
+		xfs_icsb_balance_counter(mp, XFS_SBS_IFREE,
+					 XFS_ICSB_SB_LOCKED, 0);
+		xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS,
+					 XFS_ICSB_SB_LOCKED, 0);
 		XFS_SB_UNLOCK(mp, s);
+		mutex_unlock(&mp->m_icsb_mutex);
 		break;
 	}
 
@@ -1778,6 +1788,9 @@ xfs_icsb_init_counters(
 		cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
 		memset(cntp, 0, sizeof(xfs_icsb_cnts_t));
 	}
+
+	mutex_init(&mp->m_icsb_mutex);
+
 	/*
 	 * start with all counters disabled so that the
 	 * initial balance kicks us off correctly
@@ -1882,6 +1895,17 @@ xfs_icsb_disable_counter(
 
 	ASSERT((field >= XFS_SBS_ICOUNT) && (field <= XFS_SBS_FDBLOCKS));
 
+	/*
+	 * If we are already disabled, then there is nothing to do
+	 * here. We check before locking all the counters to avoid
+	 * the expensive lock operation when being called in the
+	 * slow path and the counter is already disabled. This is
+	 * safe because the only time we set or clear this state is under
+	 * the m_icsb_mutex.
+	 */
+	if (xfs_icsb_counter_disabled(mp, field))
+		return 0;
+
 	xfs_icsb_lock_all_counters(mp);
 	if (!test_and_set_bit(field, &mp->m_icsb_counters)) {
 		/* drain back to superblock */
@@ -1991,24 +2015,33 @@ xfs_icsb_sync_counters_lazy(
 /*
  * Balance and enable/disable counters as necessary.
  *
- * Thresholds for re-enabling counters are somewhat magic.
- * inode counts are chosen to be the same number as single
- * on disk allocation chunk per CPU, and free blocks is
- * something far enough zero that we aren't going thrash
- * when we get near ENOSPC.
+ * Thresholds for re-enabling counters are somewhat magic.  inode counts are
+ * chosen to be the same number as single on disk allocation chunk per CPU, and
+ * free blocks is something far enough zero that we aren't going thrash when we
+ * get near ENOSPC. We also need to supply a minimum we require per cpu to
+ * prevent looping endlessly when xfs_alloc_space asks for more than will
+ * be distributed to a single CPU but each CPU has enough blocks to be
+ * reenabled.
+ *
+ * Note that we can be called when counters are already disabled.
+ * xfs_icsb_disable_counter() optimises the counter locking in this case to
+ * prevent locking every per-cpu counter needlessly.
  */
-#define XFS_ICSB_INO_CNTR_REENABLE	64
+
+#define XFS_ICSB_INO_CNTR_REENABLE	(uint64_t)64
 #define XFS_ICSB_FDBLK_CNTR_REENABLE(mp) \
-		(512 + XFS_ALLOC_SET_ASIDE(mp))
+		(uint64_t)(512 + XFS_ALLOC_SET_ASIDE(mp))
 STATIC void
 xfs_icsb_balance_counter(
 	xfs_mount_t	*mp,
 	xfs_sb_field_t  field,
-	int		flags)
+	int		flags,
+	int		min_per_cpu)
 {
 	uint64_t	count, resid;
 	int		weight = num_online_cpus();
 	int		s;
+	uint64_t	min = (uint64_t)min_per_cpu;
 
 	if (!(flags & XFS_ICSB_SB_LOCKED))
 		s = XFS_SB_LOCK(mp);
@@ -2021,19 +2054,19 @@ xfs_icsb_balance_counter(
 	case XFS_SBS_ICOUNT:
 		count = mp->m_sb.sb_icount;
 		resid = do_div(count, weight);
-		if (count < XFS_ICSB_INO_CNTR_REENABLE)
+		if (count < max(min, XFS_ICSB_INO_CNTR_REENABLE))
 			goto out;
 		break;
 	case XFS_SBS_IFREE:
 		count = mp->m_sb.sb_ifree;
 		resid = do_div(count, weight);
-		if (count < XFS_ICSB_INO_CNTR_REENABLE)
+		if (count < max(min, XFS_ICSB_INO_CNTR_REENABLE))
 			goto out;
 		break;
 	case XFS_SBS_FDBLOCKS:
 		count = mp->m_sb.sb_fdblocks;
 		resid = do_div(count, weight);
-		if (count < XFS_ICSB_FDBLK_CNTR_REENABLE(mp))
+		if (count < max(min, XFS_ICSB_FDBLK_CNTR_REENABLE(mp)))
 			goto out;
 		break;
 	default:
@@ -2048,32 +2081,39 @@ out:
 		XFS_SB_UNLOCK(mp, s);
 }
 
-STATIC int
-xfs_icsb_modify_counters_int(
+int
+xfs_icsb_modify_counters(
 	xfs_mount_t	*mp,
 	xfs_sb_field_t	field,
 	int		delta,
-	int		rsvd,
-	int		flags)
+	int		rsvd)
 {
 	xfs_icsb_cnts_t	*icsbp;
 	long long	lcounter;	/* long counter for 64 bit fields */
-	int		cpu, s, locked = 0;
-	int		ret = 0, balance_done = 0;
+	int		cpu, ret = 0, s;
 
+	might_sleep();
 again:
 	cpu = get_cpu();
-	icsbp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, cpu),
-	xfs_icsb_lock_cntr(icsbp);
+	icsbp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, cpu);
+
+	/*
+	 * if the counter is disabled, go to slow path
+	 */
 	if (unlikely(xfs_icsb_counter_disabled(mp, field)))
 		goto slow_path;
+	xfs_icsb_lock_cntr(icsbp);
+	if (unlikely(xfs_icsb_counter_disabled(mp, field))) {
+		xfs_icsb_unlock_cntr(icsbp);
+		goto slow_path;
+	}
 
 	switch (field) {
 	case XFS_SBS_ICOUNT:
 		lcounter = icsbp->icsb_icount;
 		lcounter += delta;
 		if (unlikely(lcounter < 0))
-			goto slow_path;
+			goto balance_counter;
 		icsbp->icsb_icount = lcounter;
 		break;
 
@@ -2081,7 +2121,7 @@ again:
 		lcounter = icsbp->icsb_ifree;
 		lcounter += delta;
 		if (unlikely(lcounter < 0))
-			goto slow_path;
+			goto balance_counter;
 		icsbp->icsb_ifree = lcounter;
 		break;
 
@@ -2091,7 +2131,7 @@ again:
 		lcounter = icsbp->icsb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
 		lcounter += delta;
 		if (unlikely(lcounter < 0))
-			goto slow_path;
+			goto balance_counter;
 		icsbp->icsb_fdblocks = lcounter + XFS_ALLOC_SET_ASIDE(mp);
 		break;
 	default:
@@ -2100,72 +2140,80 @@ again:
 	}
 	xfs_icsb_unlock_cntr(icsbp);
 	put_cpu();
-	if (locked)
-		XFS_SB_UNLOCK(mp, s);
 	return 0;
 
-	/*
-	 * The slow path needs to be run with the SBLOCK
-	 * held so that we prevent other threads from
-	 * attempting to run this path at the same time.
-	 * this provides exclusion for the balancing code,
-	 * and exclusive fallback if the balance does not
-	 * provide enough resources to continue in an unlocked
-	 * manner.
-	 */
 slow_path:
-	xfs_icsb_unlock_cntr(icsbp);
 	put_cpu();
 
-	/* need to hold superblock incase we need
-	 * to disable a counter */
-	if (!(flags & XFS_ICSB_SB_LOCKED)) {
-		s = XFS_SB_LOCK(mp);
-		locked = 1;
-		flags |= XFS_ICSB_SB_LOCKED;
-	}
-	if (!balance_done) {
-		xfs_icsb_balance_counter(mp, field, flags);
-		balance_done = 1;
+	/*
+	 * serialise with a mutex so we don't burn lots of cpu on
+	 * the superblock lock. We still need to hold the superblock
+	 * lock, however, when we modify the global structures.
+	 */
+	mutex_lock(&mp->m_icsb_mutex);
+
+	/*
+	 * Now running atomically.
+	 *
+	 * If the counter is enabled, someone has beaten us to rebalancing.
+	 * Drop the lock and try again in the fast path....
+	 */
+	if (!(xfs_icsb_counter_disabled(mp, field))) {
+		mutex_unlock(&mp->m_icsb_mutex);
 		goto again;
-	} else {
-		/*
-		 * we might not have enough on this local
-		 * cpu to allocate for a bulk request.
-		 * We need to drain this field from all CPUs
-		 * and disable the counter fastpath
-		 */
-		xfs_icsb_disable_counter(mp, field);
 	}
 
+	/*
+	 * The counter is currently disabled. Because we are
+	 * running atomically here, we know a rebalance cannot
+	 * be in progress. Hence we can go straight to operating
+	 * on the global superblock. We do not call xfs_mod_incore_sb()
+	 * here even though we need to get the SB_LOCK. Doing so
+	 * will cause us to re-enter this function and deadlock.
+	 * Hence we get the SB_LOCK ourselves and then call
+	 * xfs_mod_incore_sb_unlocked() as the unlocked path operates
+	 * directly on the global counters.
+	 */
+	s = XFS_SB_LOCK(mp);
 	ret = xfs_mod_incore_sb_unlocked(mp, field, delta, rsvd);
+	XFS_SB_UNLOCK(mp, s);
 
-	if (locked)
-		XFS_SB_UNLOCK(mp, s);
+	/*
+	 * Now that we've modified the global superblock, we
+	 * may be able to re-enable the distributed counters
+	 * (e.g. lots of space just got freed). After that
+	 * we are done.
+	 */
+	if (ret != ENOSPC)
+		xfs_icsb_balance_counter(mp, field, 0, 0);
+	mutex_unlock(&mp->m_icsb_mutex);
 	return ret;
-}
 
-STATIC int
-xfs_icsb_modify_counters(
-	xfs_mount_t	*mp,
-	xfs_sb_field_t	field,
-	int		delta,
-	int		rsvd)
-{
-	return xfs_icsb_modify_counters_int(mp, field, delta, rsvd, 0);
-}
+balance_counter:
+	xfs_icsb_unlock_cntr(icsbp);
+	put_cpu();
 
-/*
- * Called when superblock is already locked
- */
-STATIC int
-xfs_icsb_modify_counters_locked(
-	xfs_mount_t	*mp,
-	xfs_sb_field_t	field,
-	int		delta,
-	int		rsvd)
-{
-	return xfs_icsb_modify_counters_int(mp, field, delta,
-						rsvd, XFS_ICSB_SB_LOCKED);
+	/*
+	 * We may have multiple threads here if multiple per-cpu
+	 * counters run dry at the same time. This will mean we can
+	 * do more balances than strictly necessary but it is not
+	 * the common slowpath case.
+	 */
+	mutex_lock(&mp->m_icsb_mutex);
+
+	/*
+	 * running atomically.
+	 *
+	 * This will leave the counter in the correct state for future
+	 * accesses. After the rebalance, we simply try again but with the
+	 * global superblock lock held. This ensures that the counter state as
+	 * a result of the balance does not change and our retry will either
+	 * succeed through the fast path or slow path without another balance
+	 * operation being required.
+	 */
+	xfs_icsb_balance_counter(mp, field, 0, delta);
+	mutex_unlock(&mp->m_icsb_mutex);
+	goto again;
 }
+
 #endif
Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.h	2006-10-19 10:25:12.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.h	2006-10-19 10:32:16.626827226 +1000
@@ -419,6 +419,7 @@ typedef struct xfs_mount {
 	xfs_icsb_cnts_t		*m_sb_cnts;	/* per-cpu superblock counters */
 	unsigned long		m_icsb_counters; /* disabled per-cpu counters */
 	struct notifier_block	m_icsb_notifier; /* hotplug cpu notifier */
+	struct mutex		m_icsb_mutex;	/* balancer sync lock */
 #endif
 } xfs_mount_t;
 
