Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 20B377FEE
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 10:37:54 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B74BFAC002
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 08:37:53 -0800 (PST)
Received: from mail-pa0-f54.google.com (mail-pa0-f54.google.com
	[209.85.220.54]) by cuda.sgi.com with ESMTP id w2yynwRWcJraArR3
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 18 Feb 2014 08:37:52 -0800 (PST)
Received: by mail-pa0-f54.google.com with SMTP id fa1so17066794pad.27
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 08:37:52 -0800 (PST)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v5 1/10] fs: Add new flag(FALLOC_FL_COLLAPSE_RANGE) for
	fallocate
Date: Wed, 19 Feb 2014 01:37:43 +0900
Message-Id: <1392741464-20029-1-git-send-email-linkinjeon@gmail.com>
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
To: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com, lczerner@redhat.com
Cc: Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This patch is in response of the following post:
http://lwn.net/Articles/556136/
"ext4: introduce two new ioctls"

Dave chinner suggested that truncate_block_range
(which was one of the ioctls name) should be a fallocate operation
and not any fs specific ioctl, hence we add this functionality to new flags of fallocate.

This new functionality of collapsing range could be used by media editing tools
which does non linear editing to quickly purge and edit parts of a media file.
This will immensely improve the performance of these operations.
The limitation of fs block size aligned offsets can be easily handled
by media codecs which are encapsulated in a conatiner as they have to
just change the offset to next keyframe value to match the proper alignment.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---

Changelog
v4:
- Move block size aligned check from VFS layer to FS specific layer
- update comments for FALLOC_FL_COLLAPSE_RANGE in user visible header file.
- separate individual checks.
- collapse range don't permit to overlap the end of file.

 fs/open.c                   | 24 +++++++++++++++++++++---
 include/uapi/linux/falloc.h | 21 +++++++++++++++++++++
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
index 990c4cc..5ff562d 100644
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
1.7.11-rc0


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
