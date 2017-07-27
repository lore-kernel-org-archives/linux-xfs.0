Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35456 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751662AbdG0Wlt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2017 18:41:49 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6RMfm6B006523
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:41:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v6RMfmbZ008169
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:41:48 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v6RMfmG8017122
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:41:48 GMT
Subject: [PATCH 01/26] xfs: query the per-AG reservation counters
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 27 Jul 2017 15:41:46 -0700
Message-ID: <150119530649.15159.70450759634733150.stgit@magnolia>
In-Reply-To: <150119530010.15159.9900948790538082160.stgit@magnolia>
References: <150119530010.15159.9900948790538082160.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Establish an ioctl for userspace to query the original and current
per-AG reservation counts.  This will be used by xfs_scrub to
check that the vfs counters are at least somewhat sane.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |   12 ++++++++++++
 fs/xfs/xfs_fsops.c     |   26 ++++++++++++++++++++++++++
 fs/xfs/xfs_fsops.h     |    2 ++
 fs/xfs/xfs_ioctl.c     |   24 ++++++++++++++++++++++++
 fs/xfs/xfs_ioctl32.c   |    1 +
 5 files changed, 65 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 8c61f21..2c26c38 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -469,6 +469,17 @@ typedef struct xfs_swapext
 #define XFS_FSOP_GOING_FLAGS_NOLOGFLUSH		0x2	/* don't flush log nor data */
 
 /*
+ * AG reserved block counters
+ */
+struct xfs_fsop_ag_resblks {
+	__u32 ar_flags;			/* output flags, none defined now */
+	__u32 ar_reserved;		/* zero */
+	__u64 ar_current_resv;		/* blocks reserved now */
+	__u64 ar_mount_resv;		/* blocks reserved at mount time */
+	__u64 ar_reserved2[5];		/* zero */
+};
+
+/*
  * ioctl limits
  */
 #ifdef XATTR_LIST_MAX
@@ -543,6 +554,7 @@ typedef struct xfs_swapext
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, uint32_t)
+#define XFS_IOC_GET_AG_RESBLKS	     _IOR ('X', 126, struct xfs_fsop_ag_resblks)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 8f22fc5..50fb3a2 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -44,6 +44,7 @@
 #include "xfs_filestream.h"
 #include "xfs_rmap.h"
 #include "xfs_ag_resv.h"
+#include "xfs_fs.h"
 
 /*
  * File system operations
@@ -1046,3 +1047,28 @@ xfs_fs_unreserve_ag_blocks(
 
 	return error;
 }
+
+/* Query the per-AG reservations to see how many blocks we have reserved. */
+int
+xfs_fs_get_ag_reserve_blocks(
+	struct xfs_mount		*mp,
+	struct xfs_fsop_ag_resblks	*out)
+{
+	struct xfs_ag_resv		*r;
+	struct xfs_perag		*pag;
+	xfs_agnumber_t			agno;
+
+	memset(out, 0, sizeof(struct xfs_fsop_ag_resblks));
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		pag = xfs_perag_get(mp, agno);
+		r = xfs_perag_resv(pag, XFS_AG_RESV_METADATA);
+		out->ar_current_resv += r->ar_reserved;
+		out->ar_mount_resv += r->ar_asked;
+		r = xfs_perag_resv(pag, XFS_AG_RESV_AGFL);
+		out->ar_current_resv += r->ar_reserved;
+		out->ar_mount_resv += r->ar_asked;
+		xfs_perag_put(pag);
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index 2954c13..c8f5e26 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -25,6 +25,8 @@ extern int xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
 extern int xfs_reserve_blocks(xfs_mount_t *mp, uint64_t *inval,
 				xfs_fsop_resblks_t *outval);
 extern int xfs_fs_goingdown(xfs_mount_t *mp, uint32_t inflags);
+extern int xfs_fs_get_ag_reserve_blocks(struct xfs_mount *mp,
+		struct xfs_fsop_ag_resblks *out);
 
 extern int xfs_fs_reserve_ag_blocks(struct xfs_mount *mp);
 extern int xfs_fs_unreserve_ag_blocks(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 9c0c7a9..d70ba553 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1769,6 +1769,27 @@ xfs_ioc_swapext(
 	return error;
 }
 
+static int
+xfs_ioc_get_ag_reserve_blocks(
+	struct xfs_mount		*mp,
+	void __user			*arg)
+{
+	struct xfs_fsop_ag_resblks	out;
+	int				error;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	error = xfs_fs_get_ag_reserve_blocks(mp, &out);
+	if (error)
+		return error;
+
+	if (copy_to_user(arg, &out, sizeof(out)))
+		return -EFAULT;
+
+	return 0;
+}
+
 /*
  * Note: some of the ioctl's return positive numbers as a
  * byte count indicating success, such as readlink_by_handle.
@@ -1974,6 +1995,9 @@ xfs_file_ioctl(
 		return 0;
 	}
 
+	case XFS_IOC_GET_AG_RESBLKS:
+		return xfs_ioc_get_ag_reserve_blocks(mp, arg);
+
 	case XFS_IOC_FSGROWFSDATA: {
 		xfs_growfs_data_t in;
 
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index fa0bc4d..e8b4de3 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -556,6 +556,7 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_ERROR_INJECTION:
 	case XFS_IOC_ERROR_CLEARALL:
 	case FS_IOC_GETFSMAP:
+	case XFS_IOC_GET_AG_RESBLKS:
 		return xfs_file_ioctl(filp, cmd, p);
 #ifndef BROKEN_X86_ALIGNMENT
 	/* These are handled fine if no alignment issues */

