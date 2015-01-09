Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5B0E27F3F
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 03:35:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3B03D8F804B
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 01:35:02 -0800 (PST)
Received: from mail.kernel.org ([198.145.29.136]) by cuda.sgi.com with ESMTP
	id oCJT1NcUdcNokOgU for <xfs@oss.sgi.com>;
	Fri, 09 Jan 2015 01:35:01 -0800 (PST)
From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/2] xfs: introduce a generic shutdown ioctl
Date: Fri,  9 Jan 2015 01:34:35 -0800
Message-Id: <1420796076-82847-1-git-send-email-jaegeuk@kernel.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, xfs@oss.sgi.com
Cc: Jaegeuk Kim <jaegeuk@kernel.org>

This patch introduces a generic ioctl for fs shutdown used by xfs.

Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/xfs/xfs_fs.h         | 8 ++++----
 include/uapi/linux/fs.h | 8 ++++++++
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index 18dc721..fe0eeee 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -484,9 +484,9 @@ typedef struct xfs_swapext
 /*
  * Flags for going down operation
  */
-#define XFS_FSOP_GOING_FLAGS_DEFAULT		0x0	/* going down */
-#define XFS_FSOP_GOING_FLAGS_LOGFLUSH		0x1	/* flush log but not data */
-#define XFS_FSOP_GOING_FLAGS_NOLOGFLUSH		0x2	/* don't flush log nor data */
+#define XFS_FSOP_GOING_FLAGS_DEFAULT	FS_GOING_DOWN_FULLSYNC
+#define XFS_FSOP_GOING_FLAGS_LOGFLUSH	FS_GOING_DOWN_METASYNC
+#define XFS_FSOP_GOING_FLAGS_NOLOGFLUSH	FS_GOING_DOWN_NOSYNC
 
 /*
  * ioctl commands that are used by Linux filesystems
@@ -555,7 +555,7 @@ typedef struct xfs_swapext
 #define XFS_IOC_ATTRLIST_BY_HANDLE   _IOW ('X', 122, struct xfs_fsop_attrlist_handlereq)
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
-#define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
+#define XFS_IOC_GOINGDOWN	     FS_IOC_SHUTDOWN
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 3735fa0..a4e4be5 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -157,6 +157,7 @@ struct inodes_stat_t {
 #define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
 #define FITHAW		_IOWR('X', 120, int)	/* Thaw */
 #define FITRIM		_IOWR('X', 121, struct fstrim_range)	/* Trim */
+#define FS_IOC_SHUTDOWN	_IOR('X', 125, __u32)	/* Shutdown */
 
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
@@ -205,4 +206,11 @@ struct inodes_stat_t {
 #define SYNC_FILE_RANGE_WRITE		2
 #define SYNC_FILE_RANGE_WAIT_AFTER	4
 
+/*
+ * Flags for going down operation used by FS_IOC_GOINGDOWN
+ */
+#define FS_GOING_DOWN_FULLSYNC	0x0	/* going down with full sync */
+#define FS_GOING_DOWN_METASYNC	0x1	/* going down with metadata */
+#define FS_GOING_DOWN_NOSYNC	0x2	/* going down */
+
 #endif /* _UAPI_LINUX_FS_H */
-- 
2.1.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
