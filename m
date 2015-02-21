Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B96137F56
	for <xfs@oss.sgi.com>; Sat, 21 Feb 2015 09:48:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9A57E8F8039
	for <xfs@oss.sgi.com>; Sat, 21 Feb 2015 07:48:54 -0800 (PST)
Received: from mail-pd0-f170.google.com (mail-pd0-f170.google.com
	[209.85.192.170]) by cuda.sgi.com with ESMTP id
	jZ7CfKg6Aj5IIHV9 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 21 Feb 2015 07:48:53 -0800 (PST)
Received: by pdjz10 with SMTP id z10so14708474pdj.0
	for <xfs@oss.sgi.com>; Sat, 21 Feb 2015 07:48:52 -0800 (PST)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v10 1/12] fs: Add support FALLOC_FL_INSERT_RANGE for fallocate
Date: Sun, 22 Feb 2015 00:45:43 +0900
Message-Id: <1424533554-28024-2-git-send-email-linkinjeon@gmail.com>
In-Reply-To: <1424533554-28024-1-git-send-email-linkinjeon@gmail.com>
References: <1424533554-28024-1-git-send-email-linkinjeon@gmail.com>
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
To: david@fromorbit.com, tytso@mit.edu
Cc: linux-man@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-api@vger.kernel.org, bfoster@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, mtk.manpages@gmail.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

FALLOC_FL_INSERT_RANGE command is the opposite command of
FALLOC_FL_COLLAPSE_RANGE that is needed for advertisers or someone who want to
add some data in the middle of file. FALLOC_FL_INSERT_RANGE will create space
for writing new data within a file after shifting extents to right as given
length. and this command also has same limitation as FALLOC_FL_COLLAPSE_RANGE,
that is block boundary and use ftruncate(2) for crosses EOF.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/open.c                   |    8 ++++++--
 include/linux/falloc.h      |    6 ++++++
 include/uapi/linux/falloc.h |   17 +++++++++++++++++
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
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
