Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BC8057F3F
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2015 03:22:10 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 33609AC003
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2015 01:22:06 -0800 (PST)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25]) by
	cuda.sgi.com with ESMTP id qwlt8JrDIxd8dewd (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Feb 2015 01:22:04 -0800 (PST)
Received: from epcpsbgr3.samsung.com
	(u143.gpu120.samsung.co.kr [203.254.230.143])
	by mailout2.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0NJW00FTJSOQCS80@mailout2.samsung.com> for
	xfs@oss.sgi.com; Tue, 17 Feb 2015 18:22:02 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v10 1/12] fs: Add support FALLOC_FL_INSERT_RANGE for fallocate
Date: Tue, 17 Feb 2015 18:22:02 +0900
Message-id: <003801d04a93$3026ee10$9074ca30$@samsung.com>
MIME-version: 1.0
Content-language: ko
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, Ashish Sangwan <a.sangwan@samsung.com>, xfs@oss.sgi.com

FALLOC_FL_INSERT_RANGE command is the opposite command of
FALLOC_FL_COLLAPSE_RANGE that is needed for advertisers or someone who want to
add some data in the middle of file. FALLOC_FL_INSERT_RANGE will create space
for writing new data within a file after shifting extents to right as given
length. and this command also has same limitation as FALLOC_FL_COLLAPSE_RANGE,
that is block boundary and use ftruncate(2) for crosses EOF.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/open.c                   |  8 ++++++--
 include/linux/falloc.h      |  6 ++++++
 include/uapi/linux/falloc.h | 17 +++++++++++++++++
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 33f9cbf..b724cc0 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -231,8 +231,7 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		return -EINVAL;
 
 	/* Return error if mode is not supported */
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
-		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
+	if (mode & ~FALLOC_FL_SUPPORTED_MASK)
 		return -EOPNOTSUPP;
 
 	/* Punch hole and zero range are mutually exclusive */
@@ -250,6 +249,11 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	    (mode & ~FALLOC_FL_COLLAPSE_RANGE))
 		return -EINVAL;
 
+	/* Insert range should only be used exclusively. */
+	if ((mode & FALLOC_FL_INSERT_RANGE) &&
+	    (mode & ~FALLOC_FL_INSERT_RANGE))
+		return -EINVAL;
+
 	if (!(file->f_mode & FMODE_WRITE))
 		return -EBADF;
 
diff --git a/include/linux/falloc.h b/include/linux/falloc.h
index 3159168..9961110 100644
--- a/include/linux/falloc.h
+++ b/include/linux/falloc.h
@@ -21,4 +21,10 @@ struct space_resv {
 #define FS_IOC_RESVSP		_IOW('X', 40, struct space_resv)
 #define FS_IOC_RESVSP64		_IOW('X', 42, struct space_resv)
 
+#define	FALLOC_FL_SUPPORTED_MASK	(FALLOC_FL_KEEP_SIZE |		\
+					 FALLOC_FL_PUNCH_HOLE |		\
+					 FALLOC_FL_COLLAPSE_RANGE |	\
+					 FALLOC_FL_ZERO_RANGE |		\
+					 FALLOC_FL_INSERT_RANGE)
+
 #endif /* _FALLOC_H_ */
diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
index d1197ae..3e445a7 100644
--- a/include/uapi/linux/falloc.h
+++ b/include/uapi/linux/falloc.h
@@ -41,4 +41,21 @@
  */
 #define FALLOC_FL_ZERO_RANGE		0x10
 
+/*
+ * FALLOC_FL_INSERT_RANGE is use to insert space within the file size without
+ * overwriting any existing data. The contents of the file beyond offset are
+ * shifted towards right by len bytes to create a hole.  As such, this
+ * operation will increase the size of the file by len bytes.
+ *
+ * Different filesystems may implement different limitations on the granularity
+ * of the operation. Most will limit operations to filesystem block size
+ * boundaries, but this boundary may be larger or smaller depending on
+ * the filesystem and/or the configuration of the filesystem or file.
+ *
+ * Attempting to insert space using this flag at OR beyond the end of
+ * the file is considered an illegal operation - just use ftruncate(2) or
+ * fallocate(2) with mode 0 for such type of operations.
+ */
+#define FALLOC_FL_INSERT_RANGE		0x20
+
 #endif /* _UAPI_FALLOC_H_ */
-- 
1.8.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
