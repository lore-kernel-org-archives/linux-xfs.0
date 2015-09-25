Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 06A827F37
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 18:23:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CCF7230404E
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 16:23:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XfD71spyF1GLYhtO (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 25 Sep 2015 16:23:19 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 5465F2FAA7A
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 23:23:19 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-55-243.rdu2.redhat.com
	[10.10.55.243])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8PNNBp6021662
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 19:23:16 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH 6/7] xfs: per-filesystem stats in sysfs.
Date: Fri, 25 Sep 2015 18:22:59 -0500
Message-Id: <1443223380-18870-7-git-send-email-billodo@redhat.com>
In-Reply-To: <1443223380-18870-1-git-send-email-billodo@redhat.com>
References: <1443223380-18870-1-git-send-email-billodo@redhat.com>
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

This patch implements per-filesystem stats objects in sysfs. It
depends on the application of the previous patch series that
develops the infrastructure to support both xfs global stats and
xfs per-fs stats in sysfs.

Stats objects are instantiated when an xfs filesystem is mounted
and deleted on unmount. With this patch, the stats directory is
created and populated with the familiar stats and stats_clear files.
Example:
        /sys/fs/xfs/sda9/stats/stats
        /sys/fs/xfs/sda9/stats/stats_clear

With this patch, the individual counts within the new per-fs
stats file(s) remain at zero. Functions that use the the macros
to increment, decrement, and add-to the per-fs stats counts will
be covered in a separate new patch to follow this one. Note that
the counts within the global stats file (/sys/fs/xfs/stats/stats)
advance normally and can be cleared as it was prior to this patch.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 fs/xfs/xfs_linux.h |  4 ++--
 fs/xfs/xfs_mount.c | 24 +++++++++++++++++++++++-
 fs/xfs/xfs_mount.h |  1 +
 fs/xfs/xfs_stats.c | 34 +++++++++++++++++++---------------
 fs/xfs/xfs_stats.h |  5 ++++-
 fs/xfs/xfs_super.c | 21 ++++++++++++++++-----
 fs/xfs/xfs_sysfs.c |  6 +++---
 7 files changed, 68 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index f1a8505..ec0e239 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -172,8 +172,8 @@ struct xfs_kobj {
 };
 
 struct xstats {
-	struct xfsstats __percpu *xs_stats;
-	struct xfs_kobj         xs_kobj;
+	struct xfsstats __percpu	*xs_stats;
+	struct xfs_kobj			xs_kobj;
 };
 
 extern struct xstats xfsstats;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index bf92e0c..5921d18 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -791,11 +791,25 @@ xfs_mountfs(
 		goto out_free_dir;
 	}
 
+	/*
+	 * Allocate stats memory and create stats sysfs object.
+	 */
+	mp->m_stats.xs_stats = alloc_percpu(struct xfsstats);
+	if (IS_ERR(mp->m_stats.xs_stats)) {
+		error = PTR_ERR(mp->m_stats.xs_stats);
+		goto out_free_perag;
+	}
+	error = xfs_sysfs_init(&mp->m_stats.xs_kobj, &xfs_stats_ktype,
+				&mp->m_kobj,
+				"stats");
+	if (error)
+		goto out_free_stats;
+
 	if (!sbp->sb_logblocks) {
 		xfs_warn(mp, "no log defined");
 		XFS_ERROR_REPORT("xfs_mountfs", XFS_ERRLEVEL_LOW, mp);
 		error = -EFSCORRUPTED;
-		goto out_free_perag;
+		goto out_del_stats;
 	}
 
 	/*
@@ -965,6 +979,10 @@ xfs_mountfs(
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
 		xfs_wait_buftarg(mp->m_logdev_targp);
 	xfs_wait_buftarg(mp->m_ddev_targp);
+ out_del_stats:
+	xfs_sysfs_del(&mp->m_stats.xs_kobj);
+ out_free_stats:
+	free_percpu(mp->m_stats.xs_stats);
  out_free_perag:
 	xfs_free_perag(mp);
  out_free_dir:
@@ -1047,6 +1065,10 @@ xfs_unmountfs(
 		xfs_warn(mp, "Unable to update superblock counters. "
 				"Freespace may not be correct on next mount.");
 
+	/* remove the stats kobject and free stats memory */
+	xfs_sysfs_del(&mp->m_stats.xs_kobj);
+	free_percpu(mp->m_stats.xs_stats);
+
 	xfs_log_unmount(mp);
 	xfs_da_unmount(mp);
 	xfs_uuid_unmount(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7999e91..8795272 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -127,6 +127,7 @@ typedef struct xfs_mount {
 	int64_t			m_low_space[XFS_LOWSP_MAX];
 						/* low free space thresholds */
 	struct xfs_kobj		m_kobj;
+	struct xstats		m_stats;	/* per-fs stats */
 
 	struct workqueue_struct *m_buf_workqueue;
 	struct workqueue_struct	*m_data_workqueue;
diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index ab79973..d5b3704 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -18,6 +18,11 @@
 #include "xfs.h"
 #include <linux/proc_fs.h>
 
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_sysfs.h"
+
 struct xstats xfsstats;
 
 static int counter_val(struct xfsstats __percpu *stats, int idx)
@@ -25,7 +30,7 @@ static int counter_val(struct xfsstats __percpu *stats, int idx)
 	int val = 0, cpu;
 
 	for_each_possible_cpu(cpu)
-		val += *(((__u32 *)&per_cpu(*stats, cpu) + idx));
+		val += *(((__u32 *)per_cpu_ptr(stats, cpu) + idx));
 	return val;
 }
 
@@ -78,9 +83,9 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 	}
 	/* extra precision counters */
 	for_each_possible_cpu(i) {
-		xs_xstrat_bytes += per_cpu(*stats, i).xs_xstrat_bytes;
-		xs_write_bytes += per_cpu(*stats, i).xs_write_bytes;
-		xs_read_bytes += per_cpu(*stats, i).xs_read_bytes;
+		xs_xstrat_bytes += per_cpu_ptr(stats, i)->xs_xstrat_bytes;
+		xs_write_bytes += per_cpu_ptr(stats, i)->xs_write_bytes;
+		xs_read_bytes += per_cpu_ptr(stats, i)->xs_read_bytes;
 	}
 
 	len += snprintf(buf+len, PATH_MAX-len, "xpc %Lu %Lu %Lu\n",
@@ -104,10 +109,9 @@ void xfs_stats_clearall(struct xfsstats __percpu *stats)
 	for_each_possible_cpu(c) {
 		preempt_disable();
 		/* save vn_active, it's a universal truth! */
-		vn_active = per_cpu(*stats, c).vn_active;
-		memset(&per_cpu(*stats, c), 0,
-		       sizeof(*stats));
-		per_cpu(*stats, c).vn_active = vn_active;
+		vn_active = per_cpu_ptr(stats, c)->vn_active;
+		memset(per_cpu_ptr(stats, c), 0, sizeof(*stats));
+		per_cpu_ptr(stats, c)->vn_active = vn_active;
 		preempt_enable();
 	}
 }
@@ -172,28 +176,28 @@ xfs_init_procfs(void)
 		goto out;
 
 	if (!proc_symlink("fs/xfs/stat", NULL,
-			"/sys/fs/xfs/stats/stats"))
+			  "/sys/fs/xfs/stats/stats"))
 		goto out_remove_xfs_dir;
 
 #ifdef CONFIG_XFS_QUOTA
 	if (!proc_create("fs/xfs/xqmstat", 0, NULL,
-			&xqmstat_proc_fops))
+			 &xqmstat_proc_fops))
 		goto out_remove_stat_file;
 	if (!proc_create("fs/xfs/xqm", 0, NULL,
-			&xqm_proc_fops))
+			 &xqm_proc_fops))
 		goto out_remove_xqmstat_file;
 #endif
 	return 0;
 
 #ifdef CONFIG_XFS_QUOTA
-out_remove_xqmstat_file:
+ out_remove_xqmstat_file:
 	remove_proc_entry("fs/xfs/xqmstat", NULL);
-out_remove_stat_file:
+ out_remove_stat_file:
 	remove_proc_entry("fs/xfs/stat", NULL);
 #endif
-out_remove_xfs_dir:
+ out_remove_xfs_dir:
 	remove_proc_entry("fs/xfs", NULL);
-out:
+ out:
 	return -ENOMEM;
 }
 
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index 672fe83..00afc13 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -218,13 +218,16 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf);
 void xfs_stats_clearall(struct xfsstats __percpu *stats);
 extern struct xstats xfsstats;
 
+struct xfs_mount;
+
 /*
  * We don't disable preempt, not too worried about poking the
  * wrong CPU's stat for now (also aggregated before reporting).
  */
 #define XFS_STATS_INC(v)	(per_cpu(*xfsstats.xs_stats, current_cpu()).v++)
 #define XFS_STATS_DEC(v)	(per_cpu(*xfsstats.xs_stats, current_cpu()).v--)
-#define XFS_STATS_ADD(v, inc)	(per_cpu(*xfsstats.xs_stats, current_cpu()).v += (inc))
+#define XFS_STATS_ADD(v, inc)	(per_cpu(*xfsstats.xs_stats, current_cpu()).v \
+				+= (inc))
 
 extern int xfs_init_procfs(void);
 extern void xfs_cleanup_procfs(void);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 23e5681..3898643 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1801,7 +1801,6 @@ xfs_destroy_workqueues(void)
 	destroy_workqueue(xfs_alloc_wq);
 }
 
-
 STATIC int __init
 init_xfs_fs(void)
 {
@@ -1843,17 +1842,26 @@ init_xfs_fs(void)
 	}
 
 	xfsstats.xs_stats = alloc_percpu(struct xfsstats);
+	if (!xfsstats.xs_stats) {
+		error = -ENOMEM;
+		goto out_kset_unregister;
+	}
 	xfsstats.xs_kobj.kobject.kset = xfs_kset;
+	if (!xfsstats.xs_kobj.kobject.kset) {
+		error = -ENOMEM;
+		goto out_free_stats;
+	}
+
 	error = xfs_sysfs_init(&xfsstats.xs_kobj, &xfs_stats_ktype, NULL,
-			       "stats");
+				"stats");
 	if (error)
-		goto out_kset_unregister;
+		goto out_free_stats;
 
 #ifdef DEBUG
 	xfs_dbg_kobj.kobject.kset = xfs_kset;
 	error = xfs_sysfs_init(&xfs_dbg_kobj, &xfs_dbg_ktype, NULL, "debug");
 	if (error)
-		goto out_remove_stats;
+		goto out_del_stats;
 #endif
 
 	error = xfs_qm_init();
@@ -1870,8 +1878,10 @@ init_xfs_fs(void)
  out_remove_dbg_kobj:
 #ifdef DEBUG
 	xfs_sysfs_del(&xfs_dbg_kobj);
- out_remove_stats:
+ out_del_stats:
 #endif
+	xfs_sysfs_del(&xfsstats.xs_kobj);
+ out_free_stats:
 	free_percpu(xfsstats.xs_stats);
  out_kset_unregister:
 	kset_unregister(xfs_kset);
@@ -1899,6 +1909,7 @@ exit_xfs_fs(void)
 #ifdef DEBUG
 	xfs_sysfs_del(&xfs_dbg_kobj);
 #endif
+	xfs_sysfs_del(&xfsstats.xs_kobj);
 	free_percpu(xfsstats.xs_stats);
 	kset_unregister(xfs_kset);
 	xfs_sysctl_unregister();
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 3275408..a6bc433 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -143,9 +143,9 @@ to_xstats(struct kobject *kobject)
 STATIC ssize_t
 stats_show(
 	struct kobject	*kobject,
-	char	*buf)
+	char		*buf)
 {
-	struct xstats *stats = to_xstats(kobject);
+	struct xstats	*stats = to_xstats(kobject);
 
 	return xfs_stats_format(stats->xs_stats, buf);
 }
@@ -159,7 +159,7 @@ stats_clear_store(
 {
 	int		ret;
 	int		val;
-	struct xstats *stats = to_xstats(kobject);
+	struct xstats	*stats = to_xstats(kobject);
 
 	ret = kstrtoint(buf, 0, &val);
 	if (ret)
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
