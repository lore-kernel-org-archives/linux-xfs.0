Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D38717FBB
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:43:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9A3F5304043
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:43:04 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ca037RmKMmlr5XEm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:43:03 -0700 (PDT)
Subject: [PATCH 25/25] xfs: query the per-AG reservation counters
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:42:58 -0700
Message-ID: <147216857818.3108.11355542277200889786.stgit@birch.djwong.org>
In-Reply-To: <147216841262.3108.10746252464845687338.stgit@birch.djwong.org>
References: <147216841262.3108.10746252464845687338.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Establish an ioctl for userspace to query the original and current
per-AG reservation counts.  This will be used by xfs_scrub to
check that the vfs counters are at least somewhat sane.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |   10 ++++++++++
 fs/xfs/xfs_fsops.c     |   29 +++++++++++++++++++++++++++++
 fs/xfs/xfs_fsops.h     |    2 ++
 fs/xfs/xfs_ioctl.c     |   16 ++++++++++++++++
 4 files changed, 57 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 211c874..f273e76 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -556,6 +556,15 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_FLAGS_ALL	0x0	/* no flags yet */
 
 /*
+ * AG reserved block counters
+ */
+struct xfs_fsop_ag_resblks {
+	__u64 resblks;		/* blocks reserved now */
+	__u64 resblks_orig;	/* blocks reserved at mount time */
+	__u64 reserved[2];
+};
+
+/*
  * ioctl limits
  */
 #ifdef XATTR_LIST_MAX
@@ -631,6 +640,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
+#define XFS_IOC_GET_AG_RESBLKS	     _IOR ('X', 126, struct xfs_fsop_ag_resblks)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 /* reflink ioctls; these MUST match the btrfs ioctl definitions */
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 9880eeb..9d7984d 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -44,6 +44,7 @@
 #include "xfs_filestream.h"
 #include "xfs_rmap.h"
 #include "xfs_ag_resv.h"
+#include "xfs_fs.h"
 
 /*
  * File system operations
@@ -1044,3 +1045,31 @@ xfs_fs_unreserve_ag_blocks(
 	if (error)
 		xfs_warn(mp, "Error %d unreserving metadata blocks.", error);
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
+	out->resblks = 0;
+	out->resblks_orig = 0;
+	out->reserved[0] = out->reserved[1] = 0;
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		pag = xfs_perag_get(mp, agno);
+		r = xfs_perag_resv(pag, XFS_AG_RESV_METADATA);
+		out->resblks += r->ar_reserved;
+		out->resblks_orig += r->ar_asked;
+		r = xfs_perag_resv(pag, XFS_AG_RESV_AGFL);
+		out->resblks += r->ar_reserved;
+		out->resblks_orig += r->ar_asked;
+		xfs_perag_put(pag);
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index 71e32480..58b584b 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -25,6 +25,8 @@ extern int xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
 extern int xfs_reserve_blocks(xfs_mount_t *mp, __uint64_t *inval,
 				xfs_fsop_resblks_t *outval);
 extern int xfs_fs_goingdown(xfs_mount_t *mp, __uint32_t inflags);
+extern int xfs_fs_get_ag_reserve_blocks(struct xfs_mount *mp,
+		struct xfs_fsop_ag_resblks *out);
 
 extern void xfs_fs_reserve_ag_blocks(struct xfs_mount *mp);
 extern void xfs_fs_unreserve_ag_blocks(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 65f0c03..2a61268 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1993,6 +1993,22 @@ xfs_file_ioctl(
 		return 0;
 	}
 
+	case XFS_IOC_GET_AG_RESBLKS: {
+		struct xfs_fsop_ag_resblks	out;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		error = xfs_fs_get_ag_reserve_blocks(mp, &out);
+		if (error)
+			return error;
+
+		if (copy_to_user(arg, &out, sizeof(out)))
+			return -EFAULT;
+
+		return 0;
+	}
+
 	case XFS_IOC_FSGROWFSDATA: {
 		xfs_growfs_data_t in;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
