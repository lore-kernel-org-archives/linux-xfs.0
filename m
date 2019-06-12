Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:54294 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390376AbfFLGtx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 02:49:53 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6mjMv066082
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:49:51 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2t02heskaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:49:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6mukC049433
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:49:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2t04hyrx2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:49:50 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5C6no6p014988
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:49:50 GMT
Subject: [PATCH 7/9] xfs: wire up the v5 INUMBERS ioctl
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 11 Jun 2019 23:49:49 -0700
Message-ID: <156032218931.3774581.1709208162506188977.stgit@magnolia>
In-Reply-To: <156032214432.3774581.1304900948974476604.stgit@magnolia>
References: <156032214432.3774581.1304900948974476604.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, allison.henderson@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Wire up the v5 INUMBERS ioctl and rename the old one to v1.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |    8 +++++++
 fs/xfs/xfs_ioctl.c     |   52 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_ioctl32.c   |    1 +
 fs/xfs/xfs_ondisk.h    |    1 +
 4 files changed, 62 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 95d0411dae9b..f9f35139d4b7 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -493,6 +493,13 @@ struct xfs_bulkstat_single_req {
 	struct xfs_bulkstat	bulkstat;
 };
 
+struct xfs_inumbers_req {
+	struct xfs_bulk_ireq	hdr;
+	struct xfs_inumbers	inumbers[];
+};
+#define XFS_INUMBERS_REQ_SIZE(nr)	(sizeof(struct xfs_inumbers_req) + \
+					 (nr) * sizeof(struct xfs_inumbers))
+
 /*
  * Error injection.
  */
@@ -796,6 +803,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
 #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
 #define XFS_IOC_BULKSTAT_SINGLE	     _IOR ('X', 128, struct xfs_bulkstat_single_req)
+#define XFS_IOC_INUMBERS	     _IOR ('X', 129, struct xfs_inumbers_req)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 2c821fa601a4..2ac5e100b147 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -999,6 +999,56 @@ xfs_ioc_bulkstat_single(
 	return 0;
 }
 
+STATIC int
+xfs_inumbers_fmt(
+	struct xfs_ibulk		*breq,
+	const struct xfs_inumbers	*igrp)
+{
+	if (copy_to_user(breq->ubuffer, igrp, sizeof(struct xfs_inumbers)))
+		return -EFAULT;
+	return xfs_ibulk_advance(breq, sizeof(struct xfs_inumbers));
+}
+
+/* Handle the v5 inumbers ioctl. */
+STATIC int
+xfs_ioc_inumbers(
+	struct xfs_mount		*mp,
+	unsigned int			cmd,
+	struct xfs_inumbers_req __user	*arg)
+{
+	struct xfs_bulk_ireq		hdr;
+	struct xfs_ibulk		breq = {
+		.mp			= mp,
+	};
+	int				error;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
+	if (copy_from_user(&hdr, &arg->hdr, sizeof(hdr)))
+		return -EFAULT;
+
+	error = xfs_bulk_ireq_setup(mp, &hdr, &breq, arg->inumbers);
+	if (error == XFS_ITER_ABORT)
+		goto out_teardown;
+	if (error < 0)
+		return error;
+
+	error = xfs_inumbers(&breq, xfs_inumbers_fmt);
+	if (error)
+		return error;
+
+out_teardown:
+	xfs_bulk_ireq_teardown(&hdr, &breq);
+	if (copy_to_user(&arg->hdr, &hdr, sizeof(hdr)))
+		return -EFAULT;
+
+	return 0;
+}
+
 STATIC int
 xfs_ioc_fsgeometry(
 	struct xfs_mount	*mp,
@@ -2167,6 +2217,8 @@ xfs_file_ioctl(
 		return xfs_ioc_bulkstat(mp, cmd, arg);
 	case XFS_IOC_BULKSTAT_SINGLE:
 		return xfs_ioc_bulkstat_single(mp, cmd, arg);
+	case XFS_IOC_INUMBERS:
+		return xfs_ioc_inumbers(mp, cmd, arg);
 
 	case XFS_IOC_FSGEOMETRY_V1:
 		return xfs_ioc_fsgeometry(mp, arg, 3);
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 4152f68bfb5f..d7d6ca570089 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -583,6 +583,7 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_SCRUB_METADATA:
 	case XFS_IOC_BULKSTAT:
 	case XFS_IOC_BULKSTAT_SINGLE:
+	case XFS_IOC_INUMBERS:
 		return xfs_file_ioctl(filp, cmd, p);
 #if !defined(BROKEN_X86_ALIGNMENT) || defined(CONFIG_X86_X32)
 	/*
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index fa1252657b08..e390e65d2438 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -151,6 +151,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers,		24);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_req,		64);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_single_req,	224);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers_req,		64);
 }
 
 #endif /* __XFS_ONDISK_H */
