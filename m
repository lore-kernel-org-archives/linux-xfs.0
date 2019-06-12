Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34194 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390376AbfFLGtq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 02:49:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6mvPr047840
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:49:45 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t04etsfx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:49:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6mo9h178277
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:49:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2t1jphuw2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:49:44 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5C6niR7031199
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:49:44 GMT
Subject: [PATCH 6/9] xfs: wire up the new v5 bulkstat_single ioctl
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 11 Jun 2019 23:49:43 -0700
Message-ID: <156032218313.3774581.12164066844587307278.stgit@magnolia>
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

Wire up the V5 BULKSTAT_SINGLE ioctl and rename the old one V1.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |   16 ++++++++++
 fs/xfs/xfs_ioctl.c     |   79 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_ioctl32.c   |    1 +
 fs/xfs/xfs_ondisk.h    |    1 +
 4 files changed, 97 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 960f3542e207..95d0411dae9b 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -468,6 +468,16 @@ struct xfs_bulk_ireq {
 
 #define XFS_BULK_IREQ_FLAGS_ALL	(0)
 
+/* Header for a single inode request. */
+struct xfs_ireq {
+	uint64_t	ino;		/* I/O: start with this inode	*/
+	uint32_t	flags;		/* I/O: operation flags		*/
+	uint32_t	reserved32;	/* must be zero			*/
+	uint64_t	reserved[2];	/* must be zero			*/
+};
+
+#define XFS_IREQ_FLAGS_ALL	(0)
+
 /*
  * ioctl structures for v5 bulkstat and inumbers requests
  */
@@ -478,6 +488,11 @@ struct xfs_bulkstat_req {
 #define XFS_BULKSTAT_REQ_SIZE(nr)	(sizeof(struct xfs_bulkstat_req) + \
 					 (nr) * sizeof(struct xfs_bulkstat))
 
+struct xfs_bulkstat_single_req {
+	struct xfs_ireq		hdr;
+	struct xfs_bulkstat	bulkstat;
+};
+
 /*
  * Error injection.
  */
@@ -780,6 +795,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, uint32_t)
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
 #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
+#define XFS_IOC_BULKSTAT_SINGLE	     _IOR ('X', 128, struct xfs_bulkstat_single_req)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index cf6a38c2a3ed..2c821fa601a4 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -922,6 +922,83 @@ xfs_ioc_bulkstat(
 	return 0;
 }
 
+/*
+ * Check the incoming singleton request @hdr from userspace and initialize the
+ * internal @breq bulk request appropriately.  Returns 0 if the bulk request
+ * should proceed; or the usual negative error code.
+ */
+static int
+xfs_ireq_setup(
+	struct xfs_mount	*mp,
+	struct xfs_ireq		*hdr,
+	struct xfs_ibulk	*breq,
+	void __user		*ubuffer)
+{
+	if ((hdr->flags & ~XFS_IREQ_FLAGS_ALL) ||
+	    hdr->reserved32 ||
+	    memchr_inv(hdr->reserved, 0, sizeof(hdr->reserved)))
+		return -EINVAL;
+
+	if (XFS_INO_TO_AGNO(mp, hdr->ino) >= mp->m_sb.sb_agcount)
+		return -EINVAL;
+
+	breq->ubuffer = ubuffer;
+	breq->icount = 1;
+	breq->startino = hdr->ino;
+	return 0;
+}
+
+/*
+ * Update the userspace singleton request @hdr to reflect the end state of the
+ * internal bulk request @breq.  If @error is negative then we return just
+ * that; otherwise we copy the state so that userspace can discover what
+ * happened.
+ */
+static void
+xfs_ireq_teardown(
+	struct xfs_ireq		*hdr,
+	struct xfs_ibulk	*breq)
+{
+	hdr->ino = breq->startino;
+}
+
+/* Handle the v5 bulkstat_single ioctl. */
+STATIC int
+xfs_ioc_bulkstat_single(
+	struct xfs_mount	*mp,
+	unsigned int		cmd,
+	struct xfs_bulkstat_single_req __user *arg)
+{
+	struct xfs_ireq		hdr;
+	struct xfs_ibulk	breq = {
+		.mp		= mp,
+	};
+	int			error;
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
+	error = xfs_ireq_setup(mp, &hdr, &breq, &arg->bulkstat);
+	if (error)
+		return error;
+
+	error = xfs_bulkstat_one(&breq, xfs_bulkstat_fmt);
+	if (error)
+		return error;
+
+	xfs_ireq_teardown(&hdr, &breq);
+	if (copy_to_user(&arg->hdr, &hdr, sizeof(hdr)))
+		return -EFAULT;
+
+	return 0;
+}
+
 STATIC int
 xfs_ioc_fsgeometry(
 	struct xfs_mount	*mp,
@@ -2088,6 +2165,8 @@ xfs_file_ioctl(
 
 	case XFS_IOC_BULKSTAT:
 		return xfs_ioc_bulkstat(mp, cmd, arg);
+	case XFS_IOC_BULKSTAT_SINGLE:
+		return xfs_ioc_bulkstat_single(mp, cmd, arg);
 
 	case XFS_IOC_FSGEOMETRY_V1:
 		return xfs_ioc_fsgeometry(mp, arg, 3);
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 95cae33c961f..4152f68bfb5f 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -582,6 +582,7 @@ xfs_file_compat_ioctl(
 	case FS_IOC_GETFSMAP:
 	case XFS_IOC_SCRUB_METADATA:
 	case XFS_IOC_BULKSTAT:
+	case XFS_IOC_BULKSTAT_SINGLE:
 		return xfs_file_ioctl(filp, cmd, p);
 #if !defined(BROKEN_X86_ALIGNMENT) || defined(CONFIG_X86_X32)
 	/*
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 954484c6eb96..fa1252657b08 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -150,6 +150,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat,		192);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers,		24);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_req,		64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_single_req,	224);
 }
 
 #endif /* __XFS_ONDISK_H */
