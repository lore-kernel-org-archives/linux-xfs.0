Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 988B07F5A
	for <xfs@oss.sgi.com>; Fri,  2 Jan 2015 03:40:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 86E84304039
	for <xfs@oss.sgi.com>; Fri,  2 Jan 2015 01:40:37 -0800 (PST)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33]) by
	cuda.sgi.com with ESMTP id BFPY5lPGqm6XHDS2 (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 Jan 2015 01:40:35 -0800 (PST)
Received: from epcpsbgr4.samsung.com
	(u144.gpu120.samsung.co.kr [203.254.230.144])
	by mailout3.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0NHJ00CYPMVMENB0@mailout3.samsung.com> for
	xfs@oss.sgi.com; Fri, 02 Jan 2015 18:40:34 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v7 1/11] fs: Add support FALLOC_FL_INSERT_RANGE for fallocate
Date: Fri, 02 Jan 2015 18:40:33 +0900
Message-id: <003f01d02670$27a5e300$76f1a900$@samsung.com>
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
To: Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>
Cc: Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>

FALLOC_FL_INSERT_RANGE command is the opposite command of
FALLOC_FL_COLLAPSE_RANGE that is needed for advertisers or someone who want to
add some data in the middle of file. FALLOC_FL_INSERT_RANGE will create space
for writing new data within a file after shifting extents to right as given
length. and this command also has same limitation as FALLOC_FL_COLLAPSE_RANGE,
that is block boundary and use ftruncate(2) for crosses EOF.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/open.c                   |  8 +++++++-
 include/uapi/linux/falloc.h | 15 +++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/open.c b/fs/open.c
index 36662d0..74ed498 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -232,7 +232,8 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 
 	/* Return error if mode is not supported */
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
-		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
+		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |
+		     FALLOC_FL_INSERT_RANGE))
 		return -EOPNOTSUPP;
 
 	/* Punch hole and zero range are mutually exclusive */
@@ -250,6 +251,11 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	    (mode & ~FALLOC_FL_COLLAPSE_RANGE))
 		return -EINVAL;
 
+	/* Insert range should only be used exclusively. */
+	if ((mode & FALLOC_FL_INSERT_RANGE) &&
+	    (mode & ~FALLOC_FL_INSERT_RANGE))
+		return -EINVAL;
+
 	if (!(file->f_mode & FMODE_WRITE))
 		return -EBADF;
 
diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
index d1197ae..1f20723 100644
--- a/include/uapi/linux/falloc.h
+++ b/include/uapi/linux/falloc.h
@@ -41,4 +41,19 @@
  */
 #define FALLOC_FL_ZERO_RANGE		0x10
 
+/*
+ * FALLOC_FL_INSERT_RANGE is use to insert space within the file size without
+ * overwriting any existing data. The contents of the file beyond offset are
+ * shifted towards right by len bytes to create a hole.  As such, this
+ * operation will increase the size of the file by len bytes.
+ * Different filesystems may implement different limitations on the granularity
+ * of the operation. Most will limit operations to filesystem block size
+ * boundaries, but this boundary may be larger or smaller depending on
+ * the filesystem and/or the configuration of the filesystem or file.
+ * Attempting to insert space using this flag at OR beyond the end of
+ * the file is considered an illegal operation - just use ftruncate(2) or
+ * fallocate(2) with mode 0 for such type of operations.
+ */
+#define FALLOC_FL_INSERT_RANGE		0x20
+
 #endif /* _UAPI_FALLOC_H_ */
-- 
1.7.11-rc0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
