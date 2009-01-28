Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0SL0ZHl152885 for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 15:00:36 -0600
Message-ID: <4980C71F.1010804@ankitjain.org>
Date: Thu, 29 Jan 2009 02:29:11 +0530
From: Ankit Jain <me@ankitjain.org>
MIME-Version: 1.0
Subject: [PATCH] fs: Add new pre-allocation ioctls to vfs for compatibility
	with legacy xfs ioctls
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: mfasheh@suse.com, linux-kernel@vger.kernel.org, joel.becker@oracle.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

Al, Could this be included in the vfs queue?

This patch adds ioctls to vfs for compatibility with legacy XFS
pre-allocation ioctls (XFS_IOC_*RESVP*). The implementation
effectively invokes sys_fallocate for the new ioctls.
Also handles the compat_ioctl case.
Note: These legacy ioctls are also implemented by OCFS2.

Signed-off-by: Ankit Jain <me@ankitjain.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Christoph Hellwig <hch@lst.de>
---
 fs/compat_ioctl.c      |   29 +++++++++++++++++++++++++++
 fs/ioctl.c             |   35 ++++++++++++++++++++++++++++++++
 fs/open.c              |   51 +++++++++++++++++++++++------------------------
 include/linux/falloc.h |   44 +++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h     |    6 +++++
 5 files changed, 139 insertions(+), 26 deletions(-)

Index: xfs/fs/compat_ioctl.c
===================================================================
--- xfs.orig/fs/compat_ioctl.c	2009-01-21 21:03:26.217449883 +0100
+++ xfs/fs/compat_ioctl.c	2009-01-27 20:36:59.189424147 +0100
@@ -2765,6 +2765,26 @@ static void compat_ioctl_error(struct fi
 		free_page((unsigned long)path);
 }
 
+#ifdef BROKEN_X86_ALIGNMENT
+/* just account for different alignment */
+static unsigned long copy_to_space_resv(unsigned long arg)
+{
+	struct space_resv_32	__user *p32 = (void __user *)arg;
+	struct space_resv		__user *p = compat_alloc_user_space(sizeof(*p));
+
+	if (copy_in_user(&p->l_type,	&p32->l_type,	sizeof(s16)) ||
+	    copy_in_user(&p->l_whence,	&p32->l_whence, sizeof(s16)) ||
+	    copy_in_user(&p->l_start,	&p32->l_start,	sizeof(s64)) ||
+	    copy_in_user(&p->l_len,	&p32->l_len,	sizeof(s64)) ||
+	    copy_in_user(&p->l_sysid,	&p32->l_sysid,	sizeof(s32)) ||
+	    copy_in_user(&p->l_pid,	&p32->l_pid,	sizeof(u32)) ||
+	    copy_in_user(&p->l_pad,	&p32->l_pad,	4*sizeof(u32)))
+		return -EFAULT;
+
+	return (unsigned long)p;
+}
+#endif
+
 asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 				unsigned long arg)
 {
@@ -2795,6 +2815,15 @@ asmlinkage long compat_sys_ioctl(unsigne
 	case FIOQSIZE:
 		break;
 
+	case F_IOC_RESVSP_32:
+	case F_IOC_RESVSP64_32:
+#ifdef BROKEN_X86_ALIGNMENT
+		arg = copy_to_space_resv(arg);
+		cmd = _NATIVE_IOC(cmd, struct space_resv);
+#endif
+		error = ioctl_preallocate(filp, arg);
+		goto out_fput;
+
 	case FIBMAP:
 	case FIGETBSZ:
 	case FIONREAD:
Index: xfs/fs/ioctl.c
===================================================================
--- xfs.orig/fs/ioctl.c	2009-01-21 21:03:27.321448363 +0100
+++ xfs/fs/ioctl.c	2009-01-27 20:36:59.189424147 +0100
@@ -15,6 +15,7 @@
 #include <linux/uaccess.h>
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>
+#include <linux/falloc.h>
 
 #include <asm/ioctls.h>
 
@@ -370,6 +371,37 @@ EXPORT_SYMBOL(generic_block_fiemap);
 
 #endif  /*  CONFIG_BLOCK  */
 
+/*
+ * This provides compatibility with legacy XFS pre-allocation ioctls
+ * which predate the fallocate syscall.
+ *
+ * Only the l_start, l_len and l_whence fields of the 'struct space_resv'
+ * are used here, rest are ignored.
+ */
+int ioctl_preallocate(struct file *filp, unsigned long arg)
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
@@ -385,6 +417,9 @@ static int file_ioctl(struct file *filp,
 		return put_user(inode->i_sb->s_blocksize, p);
 	case FIONREAD:
 		return put_user(i_size_read(inode) - filp->f_pos, p);
+	case F_IOC_RESVSP:
+	case F_IOC_RESVSP64:
+		return ioctl_preallocate(filp, arg);
 	}
 
 	return vfs_ioctl(filp, cmd, arg);
Index: xfs/fs/open.c
===================================================================
--- xfs.orig/fs/open.c	2009-01-21 21:03:27.740294372 +0100
+++ xfs/fs/open.c	2009-01-27 20:41:38.208298998 +0100
@@ -377,63 +377,63 @@ SYSCALL_ALIAS(sys_ftruncate64, SyS_ftrun
 #endif
 #endif /* BITS_PER_LONG == 32 */
 
-SYSCALL_DEFINE(fallocate)(int fd, int mode, loff_t offset, loff_t len)
+
+int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 {
-	struct file *file;
-	struct inode *inode;
-	long ret = -EINVAL;
+	struct inode *inode = file->f_path.dentry->d_inode;
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
 	if (!(file->f_mode & FMODE_WRITE))
-		goto out_fput;
+		return -EBADF;
 	/*
 	 * Revalidate the write permissions, in case security policy has
 	 * changed since the files were opened.
 	 */
 	ret = security_file_permission(file, MAY_WRITE);
 	if (ret)
-		goto out_fput;
+		return ret;
 
-	inode = file->f_path.dentry->d_inode;
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
 
-	if (inode->i_op->fallocate)
-		ret = inode->i_op->fallocate(inode, mode, offset, len);
-	else
-		ret = -EOPNOTSUPP;
+	if (!inode->i_op->fallocate)
+		return -EOPNOTSUPP;
 
-out_fput:
-	fput(file);
-out:
-	return ret;
+	return inode->i_op->fallocate(inode, mode, offset, len);
 }
+
+SYSCALL_DEFINE(fallocate)(int fd, int mode, loff_t offset, loff_t len)
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
+}
+
 #ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
 asmlinkage long SyS_fallocate(long fd, long mode, loff_t offset, loff_t len)
 {
Index: xfs/include/linux/falloc.h
===================================================================
--- xfs.orig/include/linux/falloc.h	2009-01-21 21:03:28.076324621 +0100
+++ xfs/include/linux/falloc.h	2009-01-27 20:36:59.190423995 +0100
@@ -3,4 +3,48 @@
 
 #define FALLOC_FL_KEEP_SIZE	0x01 /* default is extend size */
 
+#ifdef __KERNEL__
+
+/*
+ * Space reservation ioctls and argument structure
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
+#define F_IOC_RESVSP64		_IOW('X', 42, struct space_resv)
+
+#if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
+#define BROKEN_X86_ALIGNMENT
+
+#define  _NATIVE_IOC(cmd, type) \
+	  _IOC(_IOC_DIR(cmd), _IOC_TYPE(cmd), _IOC_NR(cmd), sizeof(type))
+
+/* on ia32 l_start is on a 32-bit boundary */
+struct space_resv_32 {
+	__s16		l_type;
+	__s16		l_whence;
+	__s64		l_start	__attribute__((packed));
+			/* len == 0 means until end of file */
+	__s64		l_len __attribute__((packed));
+	__s32		l_sysid;
+	__u32		l_pid;
+	__s32		l_pad[4];	/* reserve area */
+};
+
+#define F_IOC_RESVSP_32		_IOW('X', 40, struct space_resv_32)
+#define F_IOC_RESVSP64_32	_IOW('X', 42, struct space_resv_32)
+
+#endif
+
+#endif /* __KERNEL__ */
+
 #endif /* _FALLOC_H_ */
Index: xfs/include/linux/fs.h
===================================================================
--- xfs.orig/include/linux/fs.h	2009-01-24 17:58:48.960904090 +0100
+++ xfs/include/linux/fs.h	2009-01-27 20:42:01.675299140 +0100
@@ -1694,6 +1694,8 @@ static inline int break_lease(struct ino
 
 extern int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
 		       struct file *filp);
+extern int do_fallocate(struct file *file, int mode, loff_t offset,
+			loff_t len);
 extern long do_sys_open(int dfd, const char __user *filename, int flags,
 			int mode);
 extern struct file *filp_open(const char *, int, int);
@@ -1702,6 +1704,10 @@ extern struct file * dentry_open(struct 
 extern int filp_close(struct file *, fl_owner_t id);
 extern char * getname(const char __user *);
 
+/* fs/ioctl.c */
+
+extern int ioctl_preallocate(struct file *filp, unsigned long arg);
+
 /* fs/dcache.c */
 extern void __init vfs_caches_init_early(void);
 extern void __init vfs_caches_init(unsigned long);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
