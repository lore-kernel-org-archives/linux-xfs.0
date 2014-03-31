Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6740829E10
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2014 09:54:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 446D3304059
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2014 07:54:24 -0700 (PDT)
Received: from mail-pb0-f48.google.com (mail-pb0-f48.google.com
	[209.85.160.48]) by cuda.sgi.com with ESMTP id jBskHG88Y3V8bgEE
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 31 Mar 2014 07:54:23 -0700 (PDT)
Received: by mail-pb0-f48.google.com with SMTP id md12so8249462pbc.7
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2014 07:54:22 -0700 (PDT)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH 1/3] fs: Add FALLOC_FL_INSERT_RANGE flags for fallocate
Date: Mon, 31 Mar 2014 23:54:13 +0900
Message-Id: <1396277653-10827-1-git-send-email-linkinjeon@gmail.com>
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
To: viro@zeniv.linux.org.uk, david@fromorbit.com, hch@infradead.org, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, lczerner@redhat.com
Cc: Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

FALLOC_FL_INSERT_RANGE command is the opposite command of
FALLOC_FL_COLLAPSE_RANGE that is needed for advertisers or someone who want to
add some data in the middle of file. FALLOC_FL_INSERT_RANGE will insert a range
of a file after shifting extents to right as given length.
and this command also has same limitation as FALLOC_FL_COLLAPSE_RANGE,
block boundary and use ftruncate(2) for crosses EOF.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/open.c                   | 21 ++++++++++++++++++---
 include/uapi/linux/falloc.h | 17 +++++++++++++++++
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 631aea8..34727ba 100644
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
 
@@ -257,8 +263,8 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	 * It's not possible to punch hole or perform collapse range
 	 * on append only file
 	 */
-	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE)
-	    && IS_APPEND(inode))
+	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE |
+	    FALLOC_FL_INSERT_RANGE) && IS_APPEND(inode))
 		return -EPERM;
 
 	if (IS_IMMUTABLE(inode))
@@ -286,6 +292,11 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (((offset + len) > inode->i_sb->s_maxbytes) || ((offset + len) < 0))
 		return -EFBIG;
 
+	/* Check for wrap through zero in case of insert range. */
+	if ((mode & FALLOC_FL_INSERT_RANGE) && (inode->i_size + len) >
+	    inode->i_sb->s_maxbytes)
+		return -EFBIG;
+
 	/*
 	 * There is no need to overlap collapse range with EOF, in which case
 	 * it is effectively a truncate operation
@@ -294,6 +305,10 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	    (offset + len >= i_size_read(inode)))
 		return -EINVAL;
 
+	/* Offset should be less than i_size in case of insert range. */
+	if ((mode & FALLOC_FL_INSERT_RANGE) && (offset >= i_size_read(inode)))
+		return -EINVAL;
+
 	if (!file->f_op->fallocate)
 		return -EOPNOTSUPP;
 
diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
index d1197ae..f4d12eb 100644
--- a/include/uapi/linux/falloc.h
+++ b/include/uapi/linux/falloc.h
@@ -41,4 +41,21 @@
  */
 #define FALLOC_FL_ZERO_RANGE		0x10
 
+/*
+ * FALLOC_FL_INSERT_RANGE is use to allocate disk space within the file size
+ * without overwriting any existing data. The contents of the file beyond offset
+ * are shifted towards right by len bytes to create space for inserting
+ * new disk blocks and in this space new zeroed out disk blocks are inserted.
+ * As such, this operation will increase the size of the file by len bytes.
+ * Different filesystems may implement different limitations on the granularity
+ * of the operation. Most will limit operations to filesystem block size
+ * boundaries, but this boundary may be larger or smaller depending on
+ * the filesystem and/or the configuration of the filesystem or file.
+ *
+ * Attempting to allocate new blocks using this flag at OR beyond the end of
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
