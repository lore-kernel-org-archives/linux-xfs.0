Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 511BE7F5E
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 09:42:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4120030409A
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 07:42:10 -0700 (PDT)
Received: from mail-pb0-f41.google.com (mail-pb0-f41.google.com
	[209.85.160.41]) by cuda.sgi.com with ESMTP id rtQbXF1adyZ5nbFS
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 31 Jul 2013 07:42:09 -0700 (PDT)
Received: by mail-pb0-f41.google.com with SMTP id rp2so360274pbb.28
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 07:42:08 -0700 (PDT)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH 1/3] fs: Introduce new flag FALLOC_FL_COLLAPSE_RANGE
Date: Wed, 31 Jul 2013 23:42:00 +0900
Message-Id: <1375281721-15840-1-git-send-email-linkinjeon@gmail.com>
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
To: tytso@mit.edu, adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org, hch@infradead.org, david@fromorbit.com
Cc: Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Fallocate now supports new FALLOC_FL_COLLAPSE_RANGE flag.
The semantics of this flag are following:
1) It collapses the range lying between offset and length by removing any data
   blocks which are present in this range and than updates all the logical
   offsets of extents beyond "offset + len" to nullify the hole created by
   removing blocks. In short, it does not leave a hole.
1) It should be used exclusively. No other fallocate flag in combination.
2) Offset and length supplied to fallocate should be fs block size aligned.
3) It wokrs beyond "EOF", so the extents which are pre-allocated beyond "EOF"
   are also updated.
4) It reduces the i_size of inode by the amount of collapse range which lies
   within i_size. So, if offset >= i_size, i_size won't be changed at all.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/open.c                   |   19 ++++++++++++++++---
 include/uapi/linux/falloc.h |    5 +++--
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index d53e298..e076390 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -225,12 +225,15 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 {
 	struct inode *inode = file_inode(file);
 	long ret;
+	unsigned i_blkbits = ACCESS_ONCE(inode->i_blkbits);
+	unsigned blksize_mask = (1 << i_blkbits) - 1;
 
 	if (offset < 0 || len <= 0)
 		return -EINVAL;
 
 	/* Return error if mode is not supported */
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
+		     FALLOC_FL_COLLAPSE_RANGE))
 		return -EOPNOTSUPP;
 
 	/* Punch hole must have keep size set */
@@ -241,8 +244,12 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
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
@@ -270,6 +277,12 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (((offset + len) > inode->i_sb->s_maxbytes) || ((offset + len) < 0))
 		return -EFBIG;
 
+	 /* Collapse range works only on fs block size aligned offsets */
+	if ((mode & FALLOC_FL_COLLAPSE_RANGE) &&
+	    (offset & blksize_mask || len & blksize_mask ||
+	     mode & ~FALLOC_FL_COLLAPSE_RANGE))
+			return -EINVAL;
+
 	if (!file->f_op->fallocate)
 		return -EOPNOTSUPP;
 
diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
index 990c4cc..7567c8c 100644
--- a/include/uapi/linux/falloc.h
+++ b/include/uapi/linux/falloc.h
@@ -1,9 +1,10 @@
 #ifndef _UAPI_FALLOC_H_
 #define _UAPI_FALLOC_H_
 
-#define FALLOC_FL_KEEP_SIZE	0x01 /* default is extend size */
-#define FALLOC_FL_PUNCH_HOLE	0x02 /* de-allocates range */
+#define FALLOC_FL_KEEP_SIZE		0x01 /* default is extend size */
+#define FALLOC_FL_PUNCH_HOLE		0x02 /* de-allocates range */
 #define FALLOC_FL_NO_HIDE_STALE	0x04 /* reserved codepoint */
+#define FALLOC_FL_COLLAPSE_RANGE	0x08 /* it does not leave a hole */
 
 
 #endif /* _UAPI_FALLOC_H_ */
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
