Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1D3907F56
	for <xfs@oss.sgi.com>; Sun,  6 Oct 2013 15:13:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 94219AC004
	for <xfs@oss.sgi.com>; Sun,  6 Oct 2013 13:12:59 -0700 (PDT)
Received: from mail-pa0-f53.google.com (mail-pa0-f53.google.com
	[209.85.220.53]) by cuda.sgi.com with ESMTP id yNtMofsqIdVO9gxo
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 06 Oct 2013 13:12:58 -0700 (PDT)
Received: by mail-pa0-f53.google.com with SMTP id kq14so6423440pab.12
	for <xfs@oss.sgi.com>; Sun, 06 Oct 2013 13:12:57 -0700 (PDT)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH RESEND 1/7] fs: add new flag(FALLOC_FL_COLLAPSE_RANGE) for
	fallocate
Date: Mon,  7 Oct 2013 05:12:46 +0900
Message-Id: <1381090366-2727-1-git-send-email-linkinjeon@gmail.com>
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
To: viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, tytso@mit.edu, adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org, hch@infradead.org, david@fromorbit.com
Cc: Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add new flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate.
updated detailed semantics in comments.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/open.c                   |   24 +++++++++++++++++++++---
 include/uapi/linux/falloc.h |   17 +++++++++++++++++
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 7931f76..85d243a 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -225,12 +225,14 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 {
 	struct inode *inode = file_inode(file);
 	long ret;
+	unsigned blksize_mask = (1 << inode->i_blkbits) - 1;
 
 	if (offset < 0 || len <= 0)
 		return -EINVAL;
 
 	/* Return error if mode is not supported */
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
+		     FALLOC_FL_COLLAPSE_RANGE))
 		return -EOPNOTSUPP;
 
 	/* Punch hole must have keep size set */
@@ -241,8 +243,12 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
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
@@ -270,6 +276,18 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (((offset + len) > inode->i_sb->s_maxbytes) || ((offset + len) < 0))
 		return -EFBIG;
 
+	/*
+	 * Collapse range works only on fs block size aligned offsets.
+	 * Check if collapse range is contained within (aligned)i_size.
+	 * Collapse range can only be used exclusively.
+	 */
+	if ((mode & FALLOC_FL_COLLAPSE_RANGE) &&
+	    (offset & blksize_mask || len & blksize_mask ||
+	     mode & ~FALLOC_FL_COLLAPSE_RANGE ||
+	     (offset + len >
+	      round_up(i_size_read(inode), (blksize_mask + 1)))))
+		return -EINVAL;
+
 	if (!file->f_op->fallocate)
 		return -EOPNOTSUPP;
 
diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
index 990c4cc..9614b72 100644
--- a/include/uapi/linux/falloc.h
+++ b/include/uapi/linux/falloc.h
@@ -4,6 +4,23 @@
 #define FALLOC_FL_KEEP_SIZE	0x01 /* default is extend size */
 #define FALLOC_FL_PUNCH_HOLE	0x02 /* de-allocates range */
 #define FALLOC_FL_NO_HIDE_STALE	0x04 /* reserved codepoint */
+/*
+ * FALLOC_FL_COLLAPSE_RANGE:
+ * This flag works in 2 steps.
+ * Firstly, it deallocates any data blocks present between [offset, offset+len)
+ * This step is same as punch hole and leaves a hole in the place from where
+ * the blocks are removed.
+ * Next, it eliminates the hole created by moving data blocks into it.
+ * For extent based file systems, we achieve this functionality simply by
+ * updating the starting logical offset of each extent which appears beyond
+ * the hole. As this flag works on blocks of filesystem, the offset and len
+ * provided to fallocate should be aligned with block size of filesystem.
+ * The semantics of this flag are:
+ * 1) It should be used exclusively. No other fallocate flag in combination.
+ * 2) Offset and len supplied to fallocate should be aligned with block size.
+ * 3) (offset + len) could not be greater than file size.
+ */
+#define FALLOC_FL_COLLAPSE_RANGE	0x08 /* it does not leave a hole */
 
 
 #endif /* _UAPI_FALLOC_H_ */
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
