Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60476 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730088AbfDARLA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Apr 2019 13:11:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x31H9HBe131425
        for <linux-xfs@vger.kernel.org>; Mon, 1 Apr 2019 17:10:59 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2rhyvt0cvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 01 Apr 2019 17:10:59 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x31HAv3M014292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 1 Apr 2019 17:10:58 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x31HAvgq017187
        for <linux-xfs@vger.kernel.org>; Mon, 1 Apr 2019 17:10:57 GMT
Subject: [PATCH 07/10] xfs: report AG health via AG geometry ioctl
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 01 Apr 2019 10:10:52 -0700
Message-ID: <155413865266.4966.1015973371094452528.stgit@magnolia>
In-Reply-To: <155413860964.4966.6087725033542837255.stgit@magnolia>
References: <155413860964.4966.6087725033542837255.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_fs.h     |   12 +++++++++++-
 fs/xfs/libxfs/xfs_health.h |    2 ++
 fs/xfs/xfs_health.c        |   40 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_ioctl.c         |    2 ++
 4 files changed, 55 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index ddbfde7ff79d..dc2c538e6b92 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -284,9 +284,19 @@ struct xfs_ag_geometry {
 	__u32		ag_freeblks;	/* o: free space */
 	__u32		ag_icount;	/* o: inodes allocated */
 	__u32		ag_ifree;	/* o: inodes free */
-	__u32		ag_reserved32;	/* o: zero */
+	__u32		ag_health;	/* o: sick things in ag */
 	__u64		ag_reserved[5];	/* o: zero */
 };
+#define XFS_AG_GEOM_HEALTH_AG_SB	(1 << 0)  /* superblock */
+#define XFS_AG_GEOM_HEALTH_AG_AGF	(1 << 1)  /* AGF header */
+#define XFS_AG_GEOM_HEALTH_AG_AGFL	(1 << 2)  /* AGFL header */
+#define XFS_AG_GEOM_HEALTH_AG_AGI	(1 << 3)  /* AGI header */
+#define XFS_AG_GEOM_HEALTH_AG_BNOBT	(1 << 4)  /* free space by block */
+#define XFS_AG_GEOM_HEALTH_AG_CNTBT	(1 << 5)  /* free space by length */
+#define XFS_AG_GEOM_HEALTH_AG_INOBT	(1 << 6)  /* inode index */
+#define XFS_AG_GEOM_HEALTH_AG_FINOBT	(1 << 7)  /* free inode index */
+#define XFS_AG_GEOM_HEALTH_AG_RMAPBT	(1 << 8)  /* reverse mappings */
+#define XFS_AG_GEOM_HEALTH_AG_REFCNTBT	(1 << 9)  /* reference counts */
 
 /*
  * Structures for XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG & XFS_IOC_FSGROWFSRT
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 36736d54a3e3..2d3b879da9b5 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -202,5 +202,7 @@ xfs_inode_healthy(struct xfs_inode *ip)
 }
 
 void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
+void xfs_ag_geom_health(struct xfs_mount *mp, xfs_agnumber_t agno,
+		struct xfs_ag_geometry *ageo);
 
 #endif	/* __XFS_HEALTH_H__ */
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 151c98693bef..5ca471bd41ad 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -276,3 +276,43 @@ xfs_fsop_geom_health(
 	if (sick & XFS_HEALTH_RT_SUMMARY)
 		geo->health |= XFS_FSOP_GEOM_HEALTH_RT_SUMMARY;
 }
+
+/* Fill out ag geometry health info. */
+void
+xfs_ag_geom_health(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	struct xfs_ag_geometry	*ageo)
+{
+	struct xfs_perag	*pag;
+	unsigned int		sick;
+
+	if (agno >= mp->m_sb.sb_agcount)
+		return;
+
+	ageo->ag_health = 0;
+
+	pag = xfs_perag_get(mp, agno);
+	sick = xfs_ag_measure_sickness(pag);
+	if (sick & XFS_HEALTH_AG_SB)
+		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_SB;
+	if (sick & XFS_HEALTH_AG_AGF)
+		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_AGF;
+	if (sick & XFS_HEALTH_AG_AGFL)
+		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_AGFL;
+	if (sick & XFS_HEALTH_AG_AGI)
+		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_AGI;
+	if (sick & XFS_HEALTH_AG_BNOBT)
+		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_BNOBT;
+	if (sick & XFS_HEALTH_AG_CNTBT)
+		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_CNTBT;
+	if (sick & XFS_HEALTH_AG_INOBT)
+		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_INOBT;
+	if (sick & XFS_HEALTH_AG_FINOBT)
+		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_FINOBT;
+	if (sick & XFS_HEALTH_AG_RMAPBT)
+		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_RMAPBT;
+	if (sick & XFS_HEALTH_AG_REFCNTBT)
+		ageo->ag_health |= XFS_AG_GEOM_HEALTH_AG_REFCNTBT;
+	xfs_perag_put(pag);
+}
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f9bf11b6a055..f1fc5e53cfc1 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -853,6 +853,8 @@ xfs_ioc_ag_geometry(
 	if (error)
 		return error;
 
+	xfs_ag_geom_health(mp, ageo.ag_number, &ageo);
+
 	if (copy_to_user(arg, &ageo, sizeof(ageo)))
 		return -EFAULT;
 	return 0;
