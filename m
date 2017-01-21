Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19364 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750932AbdAUIBl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Jan 2017 03:01:41 -0500
Subject: [PATCH 13/55] xfs: query the per-AG reservation counters
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 21 Jan 2017 00:01:38 -0800
Message-ID: <148498569831.15323.6578249794248927699.stgit@birch.djwong.org>
In-Reply-To: <148498561504.15323.8531512066874274553.stgit@birch.djwong.org>
References: <148498561504.15323.8531512066874274553.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Establish an ioctl for userspace to query the original and current
per-AG reservation counts.  This will be used by xfs_scrub to
check that the vfs counters are at least somewhat sane.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |   10 ++++++++++
 fs/xfs/xfs_fsops.c     |   29 +++++++++++++++++++++++++++++
 fs/xfs/xfs_fsops.h     |    2 ++
 fs/xfs/xfs_ioctl.c     |   16 ++++++++++++++++
 fs/xfs/xfs_ioctl32.c   |    1 +
 5 files changed, 58 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index e62996f..10aa908 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -555,6 +555,15 @@ typedef struct xfs_swapext
 #define XFS_FSOP_GOING_FLAGS_NOLOGFLUSH		0x2	/* don't flush log nor data */
 
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
@@ -629,6 +638,7 @@ typedef struct xfs_swapext
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
+#define XFS_IOC_GET_AG_RESBLKS	     _IOR ('X', 126, struct xfs_fsop_ag_resblks)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 242e809..70b50f2 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -44,6 +44,7 @@
 #include "xfs_filestream.h"
 #include "xfs_rmap.h"
 #include "xfs_ag_resv.h"
+#include "xfs_fs.h"
 
 /*
  * File system operations
@@ -1067,3 +1068,31 @@ xfs_fs_unreserve_ag_blocks(
 
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
index f349158..91609ae 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -25,6 +25,8 @@ extern int xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
 extern int xfs_reserve_blocks(xfs_mount_t *mp, __uint64_t *inval,
 				xfs_fsop_resblks_t *outval);
 extern int xfs_fs_goingdown(xfs_mount_t *mp, __uint32_t inflags);
+extern int xfs_fs_get_ag_reserve_blocks(struct xfs_mount *mp,
+		struct xfs_fsop_ag_resblks *out);
 
 extern int xfs_fs_reserve_ag_blocks(struct xfs_mount *mp);
 extern int xfs_fs_unreserve_ag_blocks(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d39da5d..347f726 100644
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
 
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 5ba41b7..da479e9 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -555,6 +555,7 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_ERROR_INJECTION:
 	case XFS_IOC_ERROR_CLEARALL:
 	case XFS_IOC_GETFSMAP:
+	case XFS_IOC_GET_AG_RESBLKS:
 		return xfs_file_ioctl(filp, cmd, p);
 #ifndef BROKEN_X86_ALIGNMENT
 	/* These are handled fine if no alignment issues */

