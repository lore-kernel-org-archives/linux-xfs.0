Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:60666 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfDLG2p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Apr 2019 02:28:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C68oMm001785
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 06:28:43 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2rpmrqmjrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 06:28:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C6S9cs181724
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 06:28:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2rpytd5f36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 06:28:42 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3C6SgVf022801
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 06:28:42 GMT
Subject: [PATCH 6/8] xfs: report fs and rt health via geometry structure
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Apr 2019 23:28:41 -0700
Message-ID: <155505052098.1279757.6681709526284365789.stgit@magnolia>
In-Reply-To: <155505048097.1279757.13952335054480511366.stgit@magnolia>
References: <155505048097.1279757.13952335054480511366.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_fs.h     |   11 ++++++++-
 fs/xfs/libxfs/xfs_health.h |    3 ++
 fs/xfs/xfs_health.c        |   56 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_ioctl.c         |    5 +++-
 4 files changed, 73 insertions(+), 2 deletions(-)


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
index 0915d20975be..3fffdcc80970 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -34,6 +34,7 @@
 struct xfs_mount;
 struct xfs_perag;
 struct xfs_inode;
+struct xfs_fsop_geom;
 
 /* Observable health issues for metadata spanning the entire filesystem. */
 #define XFS_SICK_FS_COUNTERS	(1 << 0)  /* summary counters */
@@ -182,4 +183,6 @@ xfs_inode_is_healthy(struct xfs_inode *ip)
 	return !xfs_inode_has_sickness(ip, -1U);
 }
 
+void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
+
 #endif	/* __XFS_HEALTH_H__ */
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 21728228e08b..d137b8f13869 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -264,3 +264,59 @@ xfs_inode_measure_sickness(
 	*checked = ip->i_checked;
 	spin_unlock(&ip->i_flags_lock);
 }
+
+/* Mappings between internal sick masks and ioctl sick masks. */
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
+	struct xfs_fsop_geom		*geo,
+	unsigned int			sick,
+	unsigned int			checked,
+	const struct ioctl_sick_map	*m)
+{
+	if (checked & m->sick_mask)
+		geo->checked |= m->ioctl_mask;
+	if (sick & m->sick_mask)
+		geo->sick |= m->ioctl_mask;
+}
+
+/* Fill out fs geometry health info. */
+void
+xfs_fsop_geom_health(
+	struct xfs_mount		*mp,
+	struct xfs_fsop_geom		*geo)
+{
+	const struct ioctl_sick_map	*m;
+	unsigned int			sick;
+	unsigned int			checked;
+
+	geo->sick = 0;
+	geo->checked = 0;
+
+	xfs_fs_measure_sickness(mp, &sick, &checked);
+	for (m = fs_map; m->sick_mask; m++)
+		xfgeo_health_tick(geo, sick, checked, m);
+
+	xfs_rt_measure_sickness(mp, &sick, &checked);
+	for (m = rt_map; m->sick_mask; m++)
+		xfgeo_health_tick(geo, sick, checked, m);
+}
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0aaf4f88524d..aa5cd95707a0 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -34,6 +34,7 @@
 #include "scrub/xfs_scrub.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 #include <linux/capability.h>
 #include <linux/cred.h>
@@ -797,8 +798,10 @@ xfs_ioc_fsgeometry(
 		len = sizeof(struct xfs_fsop_geom_v1);
 	else if (struct_version == 4)
 		len = sizeof(struct xfs_fsop_geom_v4);
-	else
+	else {
+		xfs_fsop_geom_health(mp, &fsgeo);
 		len = sizeof(fsgeo);
+	}
 
 	if (copy_to_user(arg, &fsgeo, len))
 		return -EFAULT;
