Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5SFXNt2236220 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 10:33:24 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1CAA414F95EB
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 08:33:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dqdGokJkCvPfIw09 for
	<xfs@oss.sgi.com>; Tue, 28 Jun 2011 08:33:22 -0700 (PDT)
From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 1/4] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Tue, 28 Jun 2011 11:33:15 -0400
Message-Id: <1309275199-10801-1-git-send-email-josef@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, viro@ZenIV.linux.org.uk

This just gets us ready to support the SEEK_HOLE and SEEK_DATA flags.  Turns out
using fiemap in things like cp cause more problems than it solves, so lets try
and give userspace an interface that doesn't suck.  We need to match solaris
here, and the definitions are

*o* If /whence/ is SEEK_HOLE, the offset of the start of the
next hole greater than or equal to the supplied offset
is returned. The definition of a hole is provided near
the end of the DESCRIPTION.

*o* If /whence/ is SEEK_DATA, the file pointer is set to the
start of the next non-hole file region greater than or
equal to the supplied offset.

So in the generic case the entire file is data and there is a virtual hole at
the end.  That means we will just return i_size for SEEK_HOLE and will return
the same offset for SEEK_DATA.  This is how Solaris does it so we have to do it
the same way.

Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/read_write.c    |   44 +++++++++++++++++++++++++++++++++++++++++---
 include/linux/fs.h |    4 +++-
 2 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 5520f8a..5907b49 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -64,6 +64,23 @@ generic_file_llseek_unlocked(struct file *file, loff_t offset, int origin)
 			return file->f_pos;
 		offset += file->f_pos;
 		break;
+	case SEEK_DATA:
+		/*
+		 * In the generic case the entire file is data, so as long as
+		 * offset isn't at the end of the file then the offset is data.
+		 */
+		if (offset >= inode->i_size)
+			return -ENXIO;
+		break;
+	case SEEK_HOLE:
+		/*
+		 * There is a virtual hole at the end of the file, so as long as
+		 * offset isn't i_size or larger, return i_size.
+		 */
+		if (offset >= inode->i_size)
+			return -ENXIO;
+		offset = inode->i_size;
+		break;
 	}
 
 	if (offset < 0 && !unsigned_offsets(file))
@@ -128,12 +145,13 @@ EXPORT_SYMBOL(no_llseek);
 
 loff_t default_llseek(struct file *file, loff_t offset, int origin)
 {
+	struct inode *inode = file->f_path.dentry->d_inode;
 	loff_t retval;
 
-	mutex_lock(&file->f_dentry->d_inode->i_mutex);
+	mutex_lock(&inode->i_mutex);
 	switch (origin) {
 		case SEEK_END:
-			offset += i_size_read(file->f_path.dentry->d_inode);
+			offset += i_size_read(inode);
 			break;
 		case SEEK_CUR:
 			if (offset == 0) {
@@ -141,6 +159,26 @@ loff_t default_llseek(struct file *file, loff_t offset, int origin)
 				goto out;
 			}
 			offset += file->f_pos;
+			break;
+		case SEEK_DATA:
+			/*
+			 * In the generic case the entire file is data, so as
+			 * long as offset isn't at the end of the file then the
+			 * offset is data.
+			 */
+			if (offset >= inode->i_size)
+				return -ENXIO;
+			break;
+		case SEEK_HOLE:
+			/*
+			 * There is a virtual hole at the end of the file, so
+			 * as long as offset isn't i_size or larger, return
+			 * i_size.
+			 */
+			if (offset >= inode->i_size)
+				return -ENXIO;
+			offset = inode->i_size;
+			break;
 	}
 	retval = -EINVAL;
 	if (offset >= 0 || unsigned_offsets(file)) {
@@ -151,7 +189,7 @@ loff_t default_llseek(struct file *file, loff_t offset, int origin)
 		retval = offset;
 	}
 out:
-	mutex_unlock(&file->f_dentry->d_inode->i_mutex);
+	mutex_unlock(&inode->i_mutex);
 	return retval;
 }
 EXPORT_SYMBOL(default_llseek);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b5b9792..c9156f3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -32,7 +32,9 @@
 #define SEEK_SET	0	/* seek relative to beginning of file */
 #define SEEK_CUR	1	/* seek relative to current file position */
 #define SEEK_END	2	/* seek relative to end of file */
-#define SEEK_MAX	SEEK_END
+#define SEEK_DATA	3	/* seek to the next data */
+#define SEEK_HOLE	4	/* seek to the next hole */
+#define SEEK_MAX	SEEK_HOLE
 
 struct fstrim_range {
 	__u64 start;
-- 
1.7.5.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
