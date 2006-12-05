Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Dec 2006 13:56:11 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kB5Lu1aG011740
	for <xfs@oss.sgi.com>; Tue, 5 Dec 2006 13:56:03 -0800
Date: Wed, 6 Dec 2006 08:55:04 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: Reduce in-core superblock lock contention near ENOSPC
Message-ID: <20061205215503.GW44411608@melbourne.sgi.com>
References: <20061123044122.GU11034@melbourne.sgi.com> <456F1CFC.2060705@sgi.com> <20061130223810.GO37654165@melbourne.sgi.com> <457080EA.1010807@sgi.com> <20061203234928.GA37654165@melbourne.sgi.com> <45755C26.2080505@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45755C26.2080505@gmx.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Klaus Strebel <klaus.strebel@gmx.net>
Cc: David Chinner <dgc@sgi.com>, Lachlan McIlroy <lachlan@sgi.com>, xfs-dev@sgi.com, xfs@oss.sgi.com

On Tue, Dec 05, 2006 at 12:46:46PM +0100, Klaus Strebel wrote:
> Hi guys,
> 
> just updated my CVS copy from oss.sgi.com ( the linux-2.6-xfs ) and 
> tried to compile ... but your patch failes to compile if HAVE_PERCPU_SB 
> is #ifndef'd :-(, the m_icsb_mutex is not in the struct see xfs_mount.h. 
> Make oldconfig didn't show HAVE_PERCPU_SB as option for .config, looks 
> like nobody tested on a single processor config ??

Sorry - my bad. The code did not change for UP, so I didn't think to
test it.  The patch below abstracts the icsb_mutex so that it
doesn't get directly referenced by code outside the per-cpu counter
code. Builds with and without HAVE_PERCPU_SB defined.

I'll run a test cycle on it and get it fixed up.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfs_mount.c |   23 ++++++++++++-----------
 fs/xfs/xfs_mount.h |   20 ++++++++++++++++++++
 2 files changed, 32 insertions(+), 11 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.c	2006-12-04 11:33:54.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.c	2006-12-06 08:43:25.389157507 +1100
@@ -536,11 +536,11 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 		ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
 	}
 
-	mutex_lock(&mp->m_icsb_mutex);
+	xfs_icsb_lock(mp);
 	xfs_icsb_balance_counter(mp, XFS_SBS_ICOUNT, 0, 0);
 	xfs_icsb_balance_counter(mp, XFS_SBS_IFREE, 0, 0);
 	xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS, 0, 0);
-	mutex_unlock(&mp->m_icsb_mutex);
+	xfs_icsb_unlock(mp);
 
 	mp->m_sb_bp = bp;
 	xfs_buf_relse(bp);
@@ -1726,17 +1726,17 @@ xfs_icsb_cpu_notify(
 		memset(cntp, 0, sizeof(xfs_icsb_cnts_t));
 		break;
 	case CPU_ONLINE:
-		mutex_lock(&mp->m_icsb_mutex);
+		xfs_icsb_lock(mp);
 		xfs_icsb_balance_counter(mp, XFS_SBS_ICOUNT, 0, 0);
 		xfs_icsb_balance_counter(mp, XFS_SBS_IFREE, 0, 0);
 		xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS, 0, 0);
-		mutex_unlock(&mp->m_icsb_mutex);
+		xfs_icsb_unlock(mp);
 		break;
 	case CPU_DEAD:
 		/* Disable all the counters, then fold the dead cpu's
 		 * count into the total on the global superblock and
 		 * re-enable the counters. */
-		mutex_lock(&mp->m_icsb_mutex);
+		xfs_icsb_lock(mp);
 		s = XFS_SB_LOCK(mp);
 		xfs_icsb_disable_counter(mp, XFS_SBS_ICOUNT);
 		xfs_icsb_disable_counter(mp, XFS_SBS_IFREE);
@@ -1755,7 +1755,7 @@ xfs_icsb_cpu_notify(
 		xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS,
 					 XFS_ICSB_SB_LOCKED, 0);
 		XFS_SB_UNLOCK(mp, s);
-		mutex_unlock(&mp->m_icsb_mutex);
+		xfs_icsb_unlock(mp);
 		break;
 	}
 
@@ -1803,6 +1803,7 @@ xfs_icsb_destroy_counters(
 		unregister_hotcpu_notifier(&mp->m_icsb_notifier);
 		free_percpu(mp->m_sb_cnts);
 	}
+	mutex_destroy(&mp->m_icsb_mutex);
 }
 
 STATIC_INLINE void
@@ -2146,7 +2147,7 @@ slow_path:
 	 * the superblock lock. We still need to hold the superblock
 	 * lock, however, when we modify the global structures.
 	 */
-	mutex_lock(&mp->m_icsb_mutex);
+	xfs_icsb_lock(mp);
 
 	/*
 	 * Now running atomically.
@@ -2155,7 +2156,7 @@ slow_path:
 	 * Drop the lock and try again in the fast path....
 	 */
 	if (!(xfs_icsb_counter_disabled(mp, field))) {
-		mutex_unlock(&mp->m_icsb_mutex);
+		xfs_icsb_unlock(mp);
 		goto again;
 	}
 
@@ -2182,7 +2183,7 @@ slow_path:
 	 */
 	if (ret != ENOSPC)
 		xfs_icsb_balance_counter(mp, field, 0, 0);
-	mutex_unlock(&mp->m_icsb_mutex);
+	xfs_icsb_unlock(mp);
 	return ret;
 
 balance_counter:
@@ -2195,7 +2196,7 @@ balance_counter:
 	 * do more balances than strictly necessary but it is not
 	 * the common slowpath case.
 	 */
-	mutex_lock(&mp->m_icsb_mutex);
+	xfs_icsb_lock(mp);
 
 	/*
 	 * running atomically.
@@ -2206,7 +2207,7 @@ balance_counter:
 	 * another balance operation being required.
 	 */
 	xfs_icsb_balance_counter(mp, field, 0, delta);
-	mutex_unlock(&mp->m_icsb_mutex);
+	xfs_icsb_unlock(mp);
 	goto again;
 }
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.h	2006-12-04 11:33:56.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.h	2006-12-06 08:43:18.630046128 +1100
@@ -576,6 +576,26 @@ xfs_daddr_to_agbno(struct xfs_mount *mp,
 }
 
 /*
+ * Per-cpu superblock locking functions
+ */
+#ifdef HAVE_PERCPU_SB
+STATIC_INLINE void
+xfs_icsb_lock(xfs_mount_t *mp)
+{
+	mutex_lock(&mp->m_icsb_mutex);
+}
+
+STATIC_INLINE void
+xfs_icsb_unlock(xfs_mount_t *mp)
+{
+	mutex_unlock(&mp->m_icsb_mutex);
+}
+#else
+#define xfs_icsb_lock(mp)
+#define xfs_icsb_unlock(mp)
+#endif
+
+/*
  * This structure is for use by the xfs_mod_incore_sb_batch() routine.
  * xfs_growfs can specify a few fields which are more than int limit
  */
