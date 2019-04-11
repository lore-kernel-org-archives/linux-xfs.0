Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60516 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfDKBqP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Apr 2019 21:46:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3B1hhOH044995
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 01:46:13 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2rpkht66vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 01:46:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3B1iWvK049058
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 01:46:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2rph7tgpgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 01:46:13 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3B1kCe7018002
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 01:46:12 GMT
Subject: [PATCH 7/8] xfs: report AG health via AG geometry ioctl
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 10 Apr 2019 18:46:10 -0700
Message-ID: <155494717070.1090518.15401214807663806671.stgit@magnolia>
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

Use the AG geometry info ioctl to report health status too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h     |   14 +++++++++++++-
 fs/xfs/libxfs/xfs_health.h |    2 ++
 fs/xfs/xfs_health.c        |   43 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_ioctl.c         |    2 ++
 4 files changed, 60 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 6b8956dbf49d..35d60f8017cd 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -285,9 +285,21 @@ struct xfs_ag_geometry {
 	uint32_t	ag_freeblks;	/* o: free space */
 	uint32_t	ag_icount;	/* o: inodes allocated */
 	uint32_t	ag_ifree;	/* o: inodes free */
+	uint32_t	ag_sick;	/* o: sick things in ag */
+	uint32_t	ag_checked;	/* o: checked metadata in ag */
 	uint32_t	ag_reserved32;	/* o: zero */
-	uint64_t	ag_reserved[13];/* o: zero */
+	uint64_t	ag_reserved[12];/* o: zero */
 };
+#define XFS_AG_GEOM_SICK_SB	(1 << 0)  /* superblock */
+#define XFS_AG_GEOM_SICK_AGF	(1 << 1)  /* AGF header */
+#define XFS_AG_GEOM_SICK_AGFL	(1 << 2)  /* AGFL header */
+#define XFS_AG_GEOM_SICK_AGI	(1 << 3)  /* AGI header */
+#define XFS_AG_GEOM_SICK_BNOBT	(1 << 4)  /* free space by block */
+#define XFS_AG_GEOM_SICK_CNTBT	(1 << 5)  /* free space by length */
+#define XFS_AG_GEOM_SICK_INOBT	(1 << 6)  /* inode index */
+#define XFS_AG_GEOM_SICK_FINOBT	(1 << 7)  /* free inode index */
+#define XFS_AG_GEOM_SICK_RMAPBT	(1 << 8)  /* reverse mappings */
+#define XFS_AG_GEOM_SICK_REFCNTBT (1 << 9)  /* reference counts */
 
 /*
  * Structures for XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG & XFS_IOC_FSGROWFSRT
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index c72142ec7cbb..adf9d41843a5 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -176,5 +176,7 @@ xfs_inode_is_healthy(struct xfs_inode *ip)
 }
 
 void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
+void xfs_ag_geom_health(struct xfs_mount *mp, xfs_agnumber_t agno,
+		struct xfs_ag_geometry *ageo);
 
 #endif	/* __XFS_HEALTH_H__ */
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index eb8dbc3a952a..0315b95a8d84 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -321,3 +321,46 @@ xfs_fsop_geom_health(
 		xfgeo_health_tick(geo, sick, checked, m->sick_mask,
 				m->ioctl_mask);
 }
+
+static const struct ioctl_sick_map ag_map[] = {
+	{ XFS_SICK_AG_SB,	XFS_AG_GEOM_SICK_SB },
+	{ XFS_SICK_AG_AGF,	XFS_AG_GEOM_SICK_AGF },
+	{ XFS_SICK_AG_AGFL,	XFS_AG_GEOM_SICK_AGFL },
+	{ XFS_SICK_AG_AGI,	XFS_AG_GEOM_SICK_AGI },
+	{ XFS_SICK_AG_BNOBT,	XFS_AG_GEOM_SICK_BNOBT },
+	{ XFS_SICK_AG_CNTBT,	XFS_AG_GEOM_SICK_CNTBT },
+	{ XFS_SICK_AG_INOBT,	XFS_AG_GEOM_SICK_INOBT },
+	{ XFS_SICK_AG_FINOBT,	XFS_AG_GEOM_SICK_FINOBT },
+	{ XFS_SICK_AG_RMAPBT,	XFS_AG_GEOM_SICK_RMAPBT },
+	{ XFS_SICK_AG_REFCNTBT,	XFS_AG_GEOM_SICK_REFCNTBT },
+	{ 0, 0 },
+};
+
+/* Fill out ag geometry health info. */
+void
+xfs_ag_geom_health(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	struct xfs_ag_geometry	*ageo)
+{
+	struct xfs_perag	*pag;
+	const struct ioctl_sick_map *m;
+	unsigned int		sick;
+	unsigned int		checked;
+
+	ASSERT(agno < mp->m_sb.sb_agcount);
+
+	ageo->ag_sick = 0;
+	ageo->ag_checked = 0;
+
+	pag = xfs_perag_get(mp, agno);
+	xfs_ag_measure_sickness(pag, &sick, &checked);
+	for (m = ag_map; m->sick_mask; m++) {
+		if (checked & m->sick_mask)
+			ageo->ag_checked |= m->ioctl_mask;
+		if (sick & m->sick_mask)
+			ageo->ag_sick |= m->ioctl_mask;
+	}
+
+	xfs_perag_put(pag);
+}
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 3e3ee197bd0f..c47f4201452c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -822,6 +822,8 @@ xfs_ioc_ag_geometry(
 	if (error)
 		return error;
 
+	xfs_ag_geom_health(mp, ageo.ag_number, &ageo);
+
 	if (copy_to_user(arg, &ageo, sizeof(ageo)))
 		return -EFAULT;
 	return 0;
