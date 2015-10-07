Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7A69829E59
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:05:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4D180304039
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:05:32 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id OdUVVHUAA6BmT9jz (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:05:30 -0700 (PDT)
Subject: [PATCH 02/51] libxfs: add reflink and dedupe ioctls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:05:27 -0700
Message-ID: <20151007050527.1504.88163.stgit@birch.djwong.org>
In-Reply-To: <20151007050513.1504.28089.stgit@birch.djwong.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

This is a port of the reflink and dedupe ioctl definitions from the
kernel.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_fs.h |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 89689c6..8f7014f 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -559,6 +559,47 @@ typedef struct xfs_swapext
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
+/* reflink ioctls; these MUST match the btrfs ioctl definitions */
+/* from struct btrfs_ioctl_clone_range_args */
+struct xfs_clone_args {
+	__s64 src_fd;
+	__u64 src_offset;
+	__u64 src_length;
+	__u64 dest_offset;
+};
+
+/* extent-same (dedupe) ioctls; these MUST match the btrfs ioctl definitions */
+#define XFS_EXTENT_DATA_SAME	0
+#define XFS_EXTENT_DATA_DIFFERS	1
+
+/* from struct btrfs_ioctl_file_extent_same_info */
+struct xfs_extent_data_info {
+	__s64 fd;		/* in - destination file */
+	__u64 logical_offset;	/* in - start of extent in destination */
+	__u64 bytes_deduped;	/* out - total # of bytes we were able
+				 * to dedupe from this file */
+	/* status of this dedupe operation:
+	 * 0 if dedup succeeds
+	 * < 0 for error
+	 * == XFS_SAME_DATA_DIFFERS if data differs
+	 */
+	__s32 status;		/* out - see above description */
+	__u32 reserved;
+};
+
+/* from struct btrfs_ioctl_file_extent_same_args */
+struct xfs_extent_data {
+	__u64 logical_offset;	/* in - start of extent in source */
+	__u64 length;		/* in - length of extent */
+	__u16 dest_count;	/* in - total elements in info array */
+	__u16 reserved1;
+	__u32 reserved2;
+	struct xfs_extent_data_info info[0];
+};
+
+#define XFS_IOC_CLONE		 _IOW (0x94, 9, int)
+#define XFS_IOC_CLONE_RANGE	 _IOW (0x94, 13, struct xfs_clone_args)
+#define XFS_IOC_FILE_EXTENT_SAME _IOWR(0x94, 54, struct xfs_extent_data)
 
 #ifndef HAVE_BBMACROS
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
