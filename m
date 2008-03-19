Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 13:50:34 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2JKoNn1030990
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 13:50:25 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 837BB6C0452
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 13:50:55 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id MpqnjM29FHRzugP6 for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 13:50:55 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m2JKj9F3024156
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 21:45:09 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m2JKj9WZ024154
	for xfs@oss.sgi.com; Wed, 19 Mar 2008 21:45:09 +0100
Date: Wed, 19 Mar 2008 21:45:09 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] split xfs_icsb_balance_counter
Message-ID: <20080319204509.GC23644@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Add an xfs_icsb_balance_counter_locked for the case where mp->m_sb_lock
is already locked.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2008-03-06 10:01:27.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2008-03-06 10:05:42.000000000 +0100
@@ -53,7 +53,9 @@ STATIC void	xfs_unmountfs_wait(xfs_mount
 #ifdef HAVE_PERCPU_SB
 STATIC void	xfs_icsb_destroy_counters(xfs_mount_t *);
 STATIC void	xfs_icsb_balance_counter(xfs_mount_t *, xfs_sb_field_t,
-						int, int);
+						int);
+STATIC void	xfs_icsb_balance_counter_locked(xfs_mount_t *, xfs_sb_field_t,
+						int);
 STATIC int	xfs_icsb_modify_counters(xfs_mount_t *, xfs_sb_field_t,
 						int64_t, int);
 STATIC int	xfs_icsb_disable_counter(xfs_mount_t *, xfs_sb_field_t);
@@ -61,7 +63,8 @@ STATIC int	xfs_icsb_disable_counter(xfs_
 #else
 
 #define xfs_icsb_destroy_counters(mp)			do { } while (0)
-#define xfs_icsb_balance_counter(mp, a, b, c)		do { } while (0)
+#define xfs_icsb_balance_counter(mp, a, b)		do { } while (0)
+#define xfs_icsb_balance_counter_locked(mp, a, b)	do { } while (0)
 #define xfs_icsb_modify_counters(mp, a, b, c)		do { } while (0)
 
 #endif
@@ -1996,9 +1999,9 @@ xfs_icsb_cpu_notify(
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		xfs_icsb_lock(mp);
-		xfs_icsb_balance_counter(mp, XFS_SBS_ICOUNT, 0, 0);
-		xfs_icsb_balance_counter(mp, XFS_SBS_IFREE, 0, 0);
-		xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS, 0, 0);
+		xfs_icsb_balance_counter(mp, XFS_SBS_ICOUNT, 0);
+		xfs_icsb_balance_counter(mp, XFS_SBS_IFREE, 0);
+		xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS, 0);
 		xfs_icsb_unlock(mp);
 		break;
 	case CPU_DEAD:
@@ -2018,12 +2021,9 @@ xfs_icsb_cpu_notify(
 
 		memset(cntp, 0, sizeof(xfs_icsb_cnts_t));
 
-		xfs_icsb_balance_counter(mp, XFS_SBS_ICOUNT,
-					 XFS_ICSB_SB_LOCKED, 0);
-		xfs_icsb_balance_counter(mp, XFS_SBS_IFREE,
-					 XFS_ICSB_SB_LOCKED, 0);
-		xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS,
-					 XFS_ICSB_SB_LOCKED, 0);
+		xfs_icsb_balance_counter_locked(mp, XFS_SBS_ICOUNT, 0);
+		xfs_icsb_balance_counter_locked(mp, XFS_SBS_IFREE, 0);
+		xfs_icsb_balance_counter_locked(mp, XFS_SBS_FDBLOCKS, 0);
 		spin_unlock(&mp->m_sb_lock);
 		xfs_icsb_unlock(mp);
 		break;
@@ -2075,9 +2075,9 @@ xfs_icsb_reinit_counters(
 	 * initial balance kicks us off correctly
 	 */
 	mp->m_icsb_counters = -1;
-	xfs_icsb_balance_counter(mp, XFS_SBS_ICOUNT, 0, 0);
-	xfs_icsb_balance_counter(mp, XFS_SBS_IFREE, 0, 0);
-	xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS, 0, 0);
+	xfs_icsb_balance_counter(mp, XFS_SBS_ICOUNT, 0);
+	xfs_icsb_balance_counter(mp, XFS_SBS_IFREE, 0);
+	xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS, 0);
 	xfs_icsb_unlock(mp);
 }
 
@@ -2299,19 +2299,15 @@ xfs_icsb_sync_counters(
 #define XFS_ICSB_FDBLK_CNTR_REENABLE(mp) \
 		(uint64_t)(512 + XFS_ALLOC_SET_ASIDE(mp))
 STATIC void
-xfs_icsb_balance_counter(
+xfs_icsb_balance_counter_locked(
 	xfs_mount_t	*mp,
 	xfs_sb_field_t  field,
-	int		flags,
 	int		min_per_cpu)
 {
 	uint64_t	count, resid;
 	int		weight = num_online_cpus();
 	uint64_t	min = (uint64_t)min_per_cpu;
 
-	if (!(flags & XFS_ICSB_SB_LOCKED))
-		spin_lock(&mp->m_sb_lock);
-
 	/* disable counter and sync counter */
 	xfs_icsb_disable_counter(mp, field);
 
@@ -2321,19 +2317,19 @@ xfs_icsb_balance_counter(
 		count = mp->m_sb.sb_icount;
 		resid = do_div(count, weight);
 		if (count < max(min, XFS_ICSB_INO_CNTR_REENABLE))
-			goto out;
+			return;
 		break;
 	case XFS_SBS_IFREE:
 		count = mp->m_sb.sb_ifree;
 		resid = do_div(count, weight);
 		if (count < max(min, XFS_ICSB_INO_CNTR_REENABLE))
-			goto out;
+			return;
 		break;
 	case XFS_SBS_FDBLOCKS:
 		count = mp->m_sb.sb_fdblocks;
 		resid = do_div(count, weight);
 		if (count < max(min, XFS_ICSB_FDBLK_CNTR_REENABLE(mp)))
-			goto out;
+			return;
 		break;
 	default:
 		BUG();
@@ -2342,9 +2338,17 @@ xfs_icsb_balance_counter(
 	}
 
 	xfs_icsb_enable_counter(mp, field, count, resid);
-out:
-	if (!(flags & XFS_ICSB_SB_LOCKED))
-		spin_unlock(&mp->m_sb_lock);
+}
+
+STATIC void
+xfs_icsb_balance_counter(
+	xfs_mount_t	*mp,
+	xfs_sb_field_t  fields,
+	int		min_per_cpu)
+{
+	spin_lock(&mp->m_sb_lock);
+	xfs_icsb_balance_counter_locked(mp, fields, min_per_cpu);
+	spin_unlock(&mp->m_sb_lock);
 }
 
 STATIC int
@@ -2451,7 +2455,7 @@ slow_path:
 	 * we are done.
 	 */
 	if (ret != ENOSPC)
-		xfs_icsb_balance_counter(mp, field, 0, 0);
+		xfs_icsb_balance_counter(mp, field, 0);
 	xfs_icsb_unlock(mp);
 	return ret;
 
@@ -2475,7 +2479,7 @@ balance_counter:
 	 * will either succeed through the fast path or slow path without
 	 * another balance operation being required.
 	 */
-	xfs_icsb_balance_counter(mp, field, 0, delta);
+	xfs_icsb_balance_counter(mp, field, delta);
 	xfs_icsb_unlock(mp);
 	goto again;
 }
