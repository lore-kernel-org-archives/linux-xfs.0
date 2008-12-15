Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBF84t2L008048 for <xfs@oss.sgi.com>; Mon, 15 Dec 2008 02:04:55 -0600
Received: from po-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B6E5172EC7E
	for <xfs@oss.sgi.com>; Mon, 15 Dec 2008 00:04:53 -0800 (PST)
Received: from po-out-1718.google.com (po-out-1718.google.com [72.14.252.156])
	by cuda.sgi.com with ESMTP id KoAM6d6cNRBAyvu8 for
	<xfs@oss.sgi.com>; Mon, 15 Dec 2008 00:04:53 -0800 (PST)
Received: by po-out-1718.google.com with SMTP id b23so6842558poe.2
	for <xfs@oss.sgi.com>; Mon, 15 Dec 2008 00:04:53 -0800 (PST)
Message-ID: <49460F88.2080408@ankitjain.org>
Date: Mon, 15 Dec 2008 13:34:24 +0530
From: Ankit Jain <me@ankitjain.org>
MIME-Version: 1.0
Subject: [PATCH][RFC] fs: Add new pre-allocation ioctls to vfs for
	compatibility with legacy xfs ioctls
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: mfasheh@suse.com, linux-kernel@vger.kernel.org, joel.becker@oracle.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

This patch adds ioctls to vfs for compatibility with legacy XFS
pre-allocation ioctls (XFS_IOC_*RESVP*). The implementation
effectively invokes sys_fallocate for the new ioctls.
Note: These legacy ioctls are also implemented by OCFS2.

There are some things that I'm not sure about:
1. Should the struct space_resv be exposed to user-space? If not,
then what would be the right place to put it? And the ioctl
definitions?
2. Should the corresponding ioctls be removed from ocfs2?

Signed-off-by: Ankit Jain <me@ankitjain.org>
---
 fs/ioctl.c             |   37 +++++++++++++++++++++++++++
 fs/open.c              |   51 ++++++++++++++++++-------------------
 include/linux/falloc.h |   19 ++++++++++++++
 include/linux/fs.h     |    2 +
 4 files changed, 83 insertions(+), 26 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 43e8b2c..5e565c8 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -15,6 +15,7 @@
 #include <linux/uaccess.h>
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>
+#include <linux/falloc.h>
 
 #include <asm/ioctls.h>
 
@@ -346,6 +347,37 @@ EXPORT_SYMBOL(generic_block_fiemap);
 
 #endif  /*  CONFIG_BLOCK  */
 
+/*
+ * This provides compatibility with legacy XFS pre-allocation ioctls
+ * which predate the fallocate syscall.
+ *
+ * Only the l_start, l_len and l_whence fields of the 'struct space_resv'
+ * are used here, rest are ignored.
+ */
+static int ioctl_preallocate(struct file *filp, unsigned long arg)
+{
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct space_resv sr;
+
+	if (copy_from_user(&sr, (struct space_resv __user *) arg, sizeof(sr)))
+		return -EFAULT;
+
+	switch (sr.l_whence) {
+	case SEEK_SET:
+		break;
+	case SEEK_CUR:
+		sr.l_start += filp->f_pos;
+		break;
+	case SEEK_END:
+		sr.l_start += i_size_read(inode);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return do_fallocate(filp, FALLOC_FL_KEEP_SIZE, sr.l_start, sr.l_len);
+}
+
 static int file_ioctl(struct file *filp, unsigned int cmd,
 		unsigned long arg)
 {
@@ -361,6 +393,11 @@ static int file_ioctl(struct file *filp, unsigned int cmd,
 		return put_user(inode->i_sb->s_blocksize, p);
 	case FIONREAD:
 		return put_user(i_size_read(inode) - filp->f_pos, p);
+	case F_IOC_RESVSP:
+	case F_IOC_RESVSP64:
+	case F_IOC_UNRESVSP:
+	case F_IOC_UNRESVSP64:
+		return ioctl_preallocate(filp, arg);
 	}
 
 	return vfs_ioctl(filp, cmd, arg);
diff --git a/fs/open.c b/fs/open.c
index 83cdb9d..0703bcb 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -360,62 +360,61 @@ asmlinkage long sys_ftruncate64(unsigned int fd, loff_t length)
 }
 #endif
 
-asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)
+long do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 {
-	struct file *file;
 	struct inode *inode;
-	long ret = -EINVAL;
+	long ret;
 
 	if (offset < 0 || len <= 0)
-		goto out;
+		return -EINVAL;
 
 	/* Return error if mode is not supported */
-	ret = -EOPNOTSUPP;
 	if (mode && !(mode & FALLOC_FL_KEEP_SIZE))
-		goto out;
+		return -EOPNOTSUPP;
 
-	ret = -EBADF;
-	file = fget(fd);
-	if (!file)
-		goto out;
-	if (!(file->f_mode & FMODE_WRITE))
-		goto out_fput;
+	if (!file || !(file->f_mode & FMODE_WRITE))
+		return -EBADF;
 	/*
 	 * Revalidate the write permissions, in case security policy has
 	 * changed since the files were opened.
 	 */
 	ret = security_file_permission(file, MAY_WRITE);
 	if (ret)
-		goto out_fput;
+		return ret;
 
 	inode = file->f_path.dentry->d_inode;
-
-	ret = -ESPIPE;
 	if (S_ISFIFO(inode->i_mode))
-		goto out_fput;
+		return -ESPIPE;
 
-	ret = -ENODEV;
 	/*
 	 * Let individual file system decide if it supports preallocation
 	 * for directories or not.
 	 */
 	if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
-		goto out_fput;
+		return -ENODEV;
 
-	ret = -EFBIG;
 	/* Check for wrap through zero too */
 	if (((offset + len) > inode->i_sb->s_maxbytes) || ((offset + len) < 0))
-		goto out_fput;
+		return -EFBIG;
 
 	if (inode->i_op && inode->i_op->fallocate)
-		ret = inode->i_op->fallocate(inode, mode, offset, len);
+		return inode->i_op->fallocate(inode, mode, offset, len);
 	else
-		ret = -EOPNOTSUPP;
+		return -EOPNOTSUPP;
+}
 
-out_fput:
-	fput(file);
-out:
-	return ret;
+asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)
+{
+	struct file *file;
+	int error = -EBADF;
+
+	file = fget(fd);
+	if (file) {
+		error = do_fallocate(file, mode, offset, len);
+		fput(file);
+	}
+
+	return error;
 }
 
 /*
diff --git a/include/linux/falloc.h b/include/linux/falloc.h
index 8e912ab..4f2a727 100644
--- a/include/linux/falloc.h
+++ b/include/linux/falloc.h
@@ -3,4 +3,23 @@
 
 #define FALLOC_FL_KEEP_SIZE	0x01 /* default is extend size */
 
+/*
+ * Space reservation / allocation ioctls and argument structure
+ * are designed to be compatible with the legacy XFS ioctls.
+ */
+struct space_resv {
+	__s16		l_type;
+	__s16		l_whence;
+	__s64		l_start;
+	__s64		l_len;		/* len == 0 means until end of file */
+	__s32		l_sysid;
+	__u32		l_pid;
+	__s32		l_pad[4];	/* reserve area			    */
+};
+
+#define F_IOC_RESVSP		_IOW('X', 40, struct space_resv)
+#define F_IOC_UNRESVSP	_IOW('X', 41, struct space_resv)
+#define F_IOC_RESVSP64	_IOW('X', 42, struct space_resv)
+#define F_IOC_UNRESVSP64	_IOW('X', 43, struct space_resv)
+
 #endif /* _FALLOC_H_ */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4a853ef..b1d8f12 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1671,6 +1671,8 @@ static inline int break_lease(struct inode *inode, unsigned int mode)
 
 extern int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
 		       struct file *filp);
+extern long do_fallocate(struct file *file, int mode, loff_t offset,
+			loff_t len);
 extern long do_sys_open(int dfd, const char __user *filename, int flags,
 			int mode);
 extern struct file *filp_open(const char *, int, int);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
