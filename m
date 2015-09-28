Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A806929E06
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 16:33:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 42A2BAC002
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 14:33:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DDfq6fOOcra1ldjz (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 28 Sep 2015 14:33:19 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id E9DDDC0A1479
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 21:33:18 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-55-26.rdu2.redhat.com
	[10.10.55.26])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8SLXDo9005461
	for <xfs@oss.sgi.com>; Mon, 28 Sep 2015 17:33:18 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH 6/7] xfs: per-filesystem stats in sysfs.
Date: Mon, 28 Sep 2015 16:33:07 -0500
Message-Id: <1443475988-15251-7-git-send-email-billodo@redhat.com>
In-Reply-To: <1443475988-15251-1-git-send-email-billodo@redhat.com>
References: <1443475988-15251-1-git-send-email-billodo@redhat.com>
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
 fs/xfs/xfs_mount.c | 24 +++++++++++++++++++++++-
 fs/xfs/xfs_mount.h |  1 +
 fs/xfs/xfs_stats.c |  5 +++++
 fs/xfs/xfs_super.c | 12 ++++--------
 4 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index bf92e0c..89ac1bd 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -693,9 +693,23 @@ xfs_mountfs(
 	if (error)
 		goto out;
 
+	/*
+	 * Allocate stats memory and create stats sysfs object.
+	 */
+	mp->m_stats.xs_stats = alloc_percpu(struct xfsstats);
+	if (!mp->m_stats.xs_stats) {
+		error = PTR_ERR(mp->m_stats.xs_stats);
+		goto out_remove_sysfs;
+	}
+	error = xfs_sysfs_init(&mp->m_stats.xs_kobj, &xfs_stats_ktype,
+				&mp->m_kobj,
+				"stats");
+	if (error)
+		goto out_free_stats;
+
 	error = xfs_uuid_mount(mp);
 	if (error)
-		goto out_remove_sysfs;
+		goto out_del_stats;
 
 	/*
 	 * Set the minimum read and write sizes
@@ -971,6 +985,10 @@ xfs_mountfs(
 	xfs_da_unmount(mp);
  out_remove_uuid:
 	xfs_uuid_unmount(mp);
+ out_del_stats:
+	xfs_sysfs_del(&mp->m_stats.xs_kobj);
+ out_free_stats:
+	free_percpu(mp->m_stats.xs_stats);
  out_remove_sysfs:
 	xfs_sysfs_del(&mp->m_kobj);
  out:
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
index 3f9fc05..ef888bb 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -18,6 +18,11 @@
 #include "xfs.h"
 #include <linux/proc_fs.h>
 
+//#include "xfs_format.h"
+//#include "xfs_trans_resv.h"
+//#include "xfs_mount.h"
+//#include "xfs_sysfs.h"
+
 struct xstats xfsstats;
 
 static int counter_val(struct xfsstats __percpu *stats, int idx)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5901336..68d4976 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1841,18 +1841,14 @@ init_xfs_fs(void)
 		goto out_sysctl_unregister;
 	}
 
+	xfsstats.xs_kobj.kobject.kset = xfs_kset;
+
 	xfsstats.xs_stats = alloc_percpu(struct xfsstats);
 	if (!xfsstats.xs_stats) {
 		error = -ENOMEM;
 		goto out_kset_unregister;
 	}
 
-	xfsstats.xs_kobj.kobject.kset = xfs_kset;
-	if (!xfsstats.xs_kobj.kobject.kset) {
-		error = -ENOMEM;
-		goto out_free_stats;
-	}
-
 	error = xfs_sysfs_init(&xfsstats.xs_kobj, &xfs_stats_ktype, NULL,
 			       "stats");
 	if (error)
@@ -1862,7 +1858,7 @@ init_xfs_fs(void)
 	xfs_dbg_kobj.kobject.kset = xfs_kset;
 	error = xfs_sysfs_init(&xfs_dbg_kobj, &xfs_dbg_ktype, NULL, "debug");
 	if (error)
-		goto out_del_stats;
+		goto out_remove_stats_obj;
 #endif
 
 	error = xfs_qm_init();
@@ -1879,7 +1875,7 @@ init_xfs_fs(void)
  out_remove_dbg_kobj:
 #ifdef DEBUG
 	xfs_sysfs_del(&xfs_dbg_kobj);
- out_del_stats:
+ out_remove_stats_obj:
 #endif
 	xfs_sysfs_del(&xfsstats.xs_kobj);
  out_free_stats:
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
