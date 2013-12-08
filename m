Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 485E47FD3
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 08:05:54 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 29D90304043
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 06:05:54 -0800 (PST)
Received: from mail-pb0-f51.google.com (mail-pb0-f51.google.com
	[209.85.160.51]) by cuda.sgi.com with ESMTP id Lhv0HtjyD6VF2DLd
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 08 Dec 2013 06:05:53 -0800 (PST)
Received: by mail-pb0-f51.google.com with SMTP id up15so3816171pbc.10
	for <xfs@oss.sgi.com>; Sun, 08 Dec 2013 06:05:52 -0800 (PST)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v4 1/10] fs: Add new flag(FALLOC_FL_COLLAPSE_RANGE) for
	fallocate
Date: Sun,  8 Dec 2013 23:05:44 +0900
Message-Id: <1386511544-3676-1-git-send-email-linkinjeon@gmail.com>
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
To: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz
Cc: Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add new flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate.
updated detailed semantics in comments.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/open.c                   |   24 +++++++++++++++++++++---
 include/uapi/linux/falloc.h |   21 +++++++++++++++++++++
 2 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 4b3e1ed..4a923a5 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -231,7 +231,8 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		return -EINVAL;
 
 	/* Return error if mode is not supported */
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
+		     FALLOC_FL_COLLAPSE_RANGE))
 		return -EOPNOTSUPP;
 
 	/* Punch hole must have keep size set */
@@ -239,11 +240,20 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	    !(mode & FALLOC_FL_KEEP_SIZE))
 		return -EOPNOTSUPP;
 
+	/* Collapse range should only be used exclusively. */
+	if ((mode & FALLOC_FL_COLLAPSE_RANGE) &&
+	    (mode & ~FALLOC_FL_COLLAPSE_RANGE))
+		return -EINVAL;
+
 	if (!(file->f_mode & FMODE_WRITE))
 		return -EBADF;
 
-	/* It's not possible punch hole on append only file */
-	if (mode & FALLOC_FL_PUNCH_HOLE && IS_APPEND(inode))
+	/*
+	 * It's not possible to punch hole or perform collapse range
+	 * on append only file
+	 */
+	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE)
+	    && IS_APPEND(inode))
 		return -EPERM;
 
 	if (IS_IMMUTABLE(inode))
@@ -271,6 +281,14 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (((offset + len) > inode->i_sb->s_maxbytes) || ((offset + len) < 0))
 		return -EFBIG;
 
+	/*
+	 * There is no need to overlap collapse range with EOF, in which case
+	 * it is effectively a truncate operation
+	 */
+	if ((mode & FALLOC_FL_COLLAPSE_RANGE) &&
+	    (offset + len >= i_size_read(inode)))
+		return -EINVAL;
+
 	if (!file->f_op->fallocate)
 		return -EOPNOTSUPP;
 
diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
index 990c4cc..5b214cc 100644
--- a/include/uapi/linux/falloc.h
+++ b/include/uapi/linux/falloc.h
@@ -5,5 +5,26 @@
 #define FALLOC_FL_PUNCH_HOLE	0x02 /* de-allocates range */
 #define FALLOC_FL_NO_HIDE_STALE	0x04 /* reserved codepoint */
 
+/*
+ * FALLOC_FL_COLLAPSE_RANGE is used to remove a range of a file
+ * without leaving a hole in the file. The contents of the file beyond
+ * the range being removed is appended to the start offset of the range
+ * being removed (i.e. the hole that was punched is "collapsed"),
+ * resulting in a file layout that looks like the range that was
+ * removed never existed. As such collapsing a range of a file changes
+ * the size of the file, reducing it by the same length of the range
+ * that has been removed by the operation.
+ *
+ * Different filesystems may implement different limitations on the
+ * granularity of the operation. Most will limit operations to
+ * filesystem block size boundaries, but this boundary may be larger or
+ * smaller depending on the filesystem and/or the configuration of the
+ * filesystem or file.
+ *
+ * Attempting to collapse a range that crosses the end of the file is
+ * considered an illegal operation - just use ftruncate(2) if you need
+ * to collapse a range that crosses EOF.
+ */
+#define FALLOC_FL_COLLAPSE_RANGE	0x08
 
 #endif /* _UAPI_FALLOC_H_ */
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
