Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58128 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfDKBqK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Apr 2019 21:46:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3B1hxXl051933
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 01:46:08 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2rpmrqe2tn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 01:46:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3B1jcVp189496
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 01:46:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2rpj5bg2f2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 01:46:07 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3B1k69Z017947
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 01:46:06 GMT
Subject: [PATCH 6/8] xfs: report fs and rt health via geometry structure
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 10 Apr 2019 18:46:04 -0700
Message-ID: <155494716446.1090518.6511378096384851735.stgit@magnolia>
In-Reply-To: <155494712442.1090518.2784809287026447547.stgit@magnolia>
References: <155494712442.1090518.2784809287026447547.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use our newly expanded geometry structure to report the overall fs and
realtime health status.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h     |   11 ++++++++
 fs/xfs/libxfs/xfs_health.h |    3 ++
 fs/xfs/xfs_health.c        |   57 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_ioctl.c         |    2 ++
 4 files changed, 72 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index ee33d628a240..6b8956dbf49d 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -199,9 +199,18 @@ struct xfs_fsop_geom {
 	__u32		rtsectsize;	/* realtime sector size, bytes	*/
 	__u32		dirblocksize;	/* directory block size, bytes	*/
 	__u32		logsunit;	/* log stripe unit, bytes	*/
-	__u64		reserved[18];	/* reserved space		*/
+	uint32_t	sick;		/* o: unhealthy fs & rt metadata */
+	uint32_t	checked;	/* o: checked fs & rt metadata	*/
+	__u64		reserved[17];	/* reserved space		*/
 };
 
+#define XFS_FSOP_GEOM_SICK_COUNTERS	(1 << 0)  /* summary counters */
+#define XFS_FSOP_GEOM_SICK_UQUOTA	(1 << 1)  /* user quota */
+#define XFS_FSOP_GEOM_SICK_GQUOTA	(1 << 2)  /* group quota */
+#define XFS_FSOP_GEOM_SICK_PQUOTA	(1 << 3)  /* project quota */
+#define XFS_FSOP_GEOM_SICK_RT_BITMAP	(1 << 4)  /* realtime bitmap */
+#define XFS_FSOP_GEOM_SICK_RT_SUMMARY	(1 << 5)  /* realtime summary */
+
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
 	__u64	freedata;	/* free data section blocks */
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index a434b47f2aa0..c72142ec7cbb 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -26,6 +26,7 @@
 struct xfs_mount;
 struct xfs_perag;
 struct xfs_inode;
+struct xfs_fsop_geom;
 
 /* Observable health issues for metadata spanning the entire filesystem. */
 #define XFS_SICK_FS_COUNTERS	(1 << 0)  /* summary counters */
@@ -174,4 +175,6 @@ xfs_inode_is_healthy(struct xfs_inode *ip)
 	return !xfs_inode_has_sickness(ip, -1U);
 }
 
+void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
+
 #endif	/* __XFS_HEALTH_H__ */
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 21728228e08b..eb8dbc3a952a 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -264,3 +264,60 @@ xfs_inode_measure_sickness(
 	*checked = ip->i_checked;
 	spin_unlock(&ip->i_flags_lock);
 }
+
+struct ioctl_sick_map {
+	unsigned int		sick_mask;
+	unsigned int		ioctl_mask;
+};
+
+static const struct ioctl_sick_map fs_map[] = {
+	{ XFS_SICK_FS_COUNTERS,	XFS_FSOP_GEOM_SICK_COUNTERS},
+	{ XFS_SICK_FS_UQUOTA,	XFS_FSOP_GEOM_SICK_UQUOTA },
+	{ XFS_SICK_FS_GQUOTA,	XFS_FSOP_GEOM_SICK_GQUOTA },
+	{ XFS_SICK_FS_PQUOTA,	XFS_FSOP_GEOM_SICK_PQUOTA },
+	{ 0, 0 },
+};
+
+static const struct ioctl_sick_map rt_map[] = {
+	{ XFS_SICK_RT_BITMAP,	XFS_FSOP_GEOM_SICK_RT_BITMAP },
+	{ XFS_SICK_RT_SUMMARY,	XFS_FSOP_GEOM_SICK_RT_SUMMARY },
+	{ 0, 0 },
+};
+
+static inline void
+xfgeo_health_tick(
+	struct xfs_fsop_geom	*geo,
+	unsigned int		sick,
+	unsigned int		checked,
+	unsigned int		sick_mask,
+	unsigned int		fsop_mask)
+{
+	if (checked & sick_mask)
+		geo->checked |= fsop_mask;
+	if (sick & sick_mask)
+		geo->sick |= fsop_mask;
+}
+
+/* Fill out fs geometry health info. */
+void
+xfs_fsop_geom_health(
+	struct xfs_mount	*mp,
+	struct xfs_fsop_geom	*geo)
+{
+	const struct ioctl_sick_map *m;
+	unsigned int		sick;
+	unsigned int		checked;
+
+	geo->sick = 0;
+	geo->checked = 0;
+
+	xfs_fs_measure_sickness(mp, &sick, &checked);
+	for (m = fs_map; m->sick_mask; m++)
+		xfgeo_health_tick(geo, sick, checked, m->sick_mask,
+				m->ioctl_mask);
+
+	xfs_rt_measure_sickness(mp, &sick, &checked);
+	for (m = rt_map; m->sick_mask; m++)
+		xfgeo_health_tick(geo, sick, checked, m->sick_mask,
+				m->ioctl_mask);
+}
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0aaf4f88524d..3e3ee197bd0f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -34,6 +34,7 @@
 #include "scrub/xfs_scrub.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 #include <linux/capability.h>
 #include <linux/cred.h>
@@ -792,6 +793,7 @@ xfs_ioc_fsgeometry(
 	error = xfs_fs_geometry(&mp->m_sb, &fsgeo, struct_version);
 	if (error)
 		return error;
+	xfs_fsop_geom_health(mp, &fsgeo);
 
 	if (struct_version <= 3)
 		len = sizeof(struct xfs_fsop_geom_v1);
