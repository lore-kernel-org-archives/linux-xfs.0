Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9111129E0E
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 11:23:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 582158F8035
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 09:23:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id aYA2y1izCBRxCjrS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 02 Oct 2015 09:23:00 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 023C6A8D
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 16:22:59 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-48-121.rdu2.redhat.com
	[10.10.48.121])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t92GMqqD005602
	for <xfs@oss.sgi.com>; Fri, 2 Oct 2015 12:22:59 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH 6/7] xfs: per-filesystem stats in sysfs.
Date: Fri,  2 Oct 2015 11:22:39 -0500
Message-Id: <1443802960-26662-7-git-send-email-billodo@redhat.com>
In-Reply-To: <1443802960-26662-1-git-send-email-billodo@redhat.com>
References: <1443802960-26662-1-git-send-email-billodo@redhat.com>
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
 2 files changed, 24 insertions(+), 1 deletion(-)

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
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
