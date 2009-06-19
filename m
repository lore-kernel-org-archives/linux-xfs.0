Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5JIS0Zk075623 for <xfs@oss.sgi.com>; Fri, 19 Jun 2009 13:28:01 -0500
Date: Fri, 19 Jun 2009 14:28:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fs: Add new pre-allocation ioctls to vfs for
	compatibility with legacy xfs ioctls
Message-ID: <20090619182807.GA32683@infradead.org>
References: <4980C71F.1010804@ankitjain.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4980C71F.1010804@ankitjain.org>
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
To: Ankit Jain <me@ankitjain.org>
Cc: mfasheh@suse.com, joel.becker@oracle.com, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

On Thu, Jan 29, 2009 at 02:29:11AM +0530, Ankit Jain wrote:
> Al, Could this be included in the vfs queue?
> 
> This patch adds ioctls to vfs for compatibility with legacy XFS
> pre-allocation ioctls (XFS_IOC_*RESVP*). The implementation
> effectively invokes sys_fallocate for the new ioctls.
> Also handles the compat_ioctl case.
> Note: These legacy ioctls are also implemented by OCFS2.

Still not in, but I remember Al pinged me because it broke on 64bit
architectures due issues in the compat_ioctl support.

Below is a version with that fixed and the ioctl renamed to FS_IOC_*
instead of F_IOC_* to match other generic filesystem ioctls.

--

Subject: fs: Add new pre-allocation ioctls to vfs for compatibility  with legacy xfs ioctls
From: Ankit Jain <me@ankitjain.org>

This patch adds ioctls to vfs for compatibility with legacy XFS
pre-allocation ioctls (XFS_IOC_*RESVP*). The implementation
effectively invokes sys_fallocate for the new ioctls.
Also handles the compat_ioctl case.
Note: These legacy ioctls are also implemented by OCFS2.

Signed-off-by: Ankit Jain <me@ankitjain.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>


Index: linux-2.6/fs/compat_ioctl.c
===================================================================
--- linux-2.6.orig/fs/compat_ioctl.c	2009-06-18 13:23:44.842814582 +0200
+++ linux-2.6/fs/compat_ioctl.c	2009-06-19 10:45:22.061840838 +0200
@@ -31,6 +31,7 @@
 #include <linux/skbuff.h>
 #include <linux/netlink.h>
 #include <linux/vt.h>
+#include <linux/falloc.h>
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <linux/ppp_defs.h>
@@ -1820,6 +1821,41 @@ lp_timeout_trans(unsigned int fd, unsign
 	return sys_ioctl(fd, cmd, (unsigned long)tn);
 }
 
+/* on ia32 l_start is on a 32-bit boundary */
+#if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
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
+#define FS_IOC_RESVSP_32		_IOW ('X', 40, struct space_resv_32)
+#define FS_IOC_RESVSP64_32	_IOW ('X', 42, struct space_resv_32)
+
+/* just account for different alignment */
+static int compat_ioctl_preallocate(struct file *file, unsigned long arg)
+{
+	struct space_resv_32	__user *p32 = (void __user *)arg;
+	struct space_resv	__user *p = compat_alloc_user_space(sizeof(*p));
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
+	return ioctl_preallocate(file, p);
+}
+#endif
+
 
 typedef int (*ioctl_trans_handler_t)(unsigned int, unsigned int,
 					unsigned long, struct file *);
@@ -2808,6 +2844,18 @@ asmlinkage long compat_sys_ioctl(unsigne
 	case FIOQSIZE:
 		break;
 
+#if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
+	case FS_IOC_RESVSP_32:
+	case FS_IOC_RESVSP64_32:
+		error = compat_ioctl_preallocate(filp, arg);
+		goto out_fput;
+#else
+	case FS_IOC_RESVSP:
+	case FS_IOC_RESVSP64:
+		error = ioctl_preallocate(filp, (void __user *)arg);
+		goto out_fput;
+#endif
+
 	case FIBMAP:
 	case FIGETBSZ:
 	case FIONREAD:
Index: linux-2.6/fs/ioctl.c
===================================================================
--- linux-2.6.orig/fs/ioctl.c	2009-06-18 13:23:44.864813328 +0200
+++ linux-2.6/fs/ioctl.c	2009-06-19 10:45:22.065891285 +0200
@@ -15,6 +15,7 @@
 #include <linux/uaccess.h>
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>
+#include <linux/falloc.h>
 
 #include <asm/ioctls.h>
 
@@ -403,6 +404,37 @@ EXPORT_SYMBOL(generic_block_fiemap);
 
 #endif  /*  CONFIG_BLOCK  */
 
+/*
+ * This provides compatibility with legacy XFS pre-allocation ioctls
+ * which predate the fallocate syscall.
+ *
+ * Only the l_start, l_len and l_whence fields of the 'struct space_resv'
+ * are used here, rest are ignored.
+ */
+int ioctl_preallocate(struct file *filp, void __user *argp)
+{
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct space_resv sr;
+
+	if (copy_from_user(&sr, argp, sizeof(sr)))
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
@@ -414,6 +446,9 @@ static int file_ioctl(struct file *filp,
 		return ioctl_fibmap(filp, p);
 	case FIONREAD:
 		return put_user(i_size_read(inode) - filp->f_pos, p);
+	case FS_IOC_RESVSP:
+	case FS_IOC_RESVSP64:
+		return ioctl_preallocate(filp, p);
 	}
 
 	return vfs_ioctl(filp, cmd, arg);
Index: linux-2.6/fs/open.c
===================================================================
--- linux-2.6.orig/fs/open.c	2009-06-15 06:52:46.423947558 +0200
+++ linux-2.6/fs/open.c	2009-06-19 10:45:22.071891142 +0200
@@ -378,63 +378,63 @@ SYSCALL_ALIAS(sys_ftruncate64, SyS_ftrun
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
Index: linux-2.6/include/linux/falloc.h
===================================================================
--- linux-2.6.orig/include/linux/falloc.h	2009-06-15 06:52:46.427939617 +0200
+++ linux-2.6/include/linux/falloc.h	2009-06-19 10:45:22.077973761 +0200
@@ -3,4 +3,25 @@
 
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
+	__s32		l_pad[4];	/* reserved area */
+};
+
+#define FS_IOC_RESVSP		_IOW('X', 40, struct space_resv)
+#define FS_IOC_RESVSP64		_IOW('X', 42, struct space_resv)
+
+#endif /* __KERNEL__ */
+
 #endif /* _FALLOC_H_ */
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2009-06-17 11:49:42.162814358 +0200
+++ linux-2.6/include/linux/fs.h	2009-06-19 10:45:22.081962259 +0200
@@ -1905,6 +1905,8 @@ static inline int break_lease(struct ino
 
 extern int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
 		       struct file *filp);
+extern int do_fallocate(struct file *file, int mode, loff_t offset,
+			loff_t len);
 extern long do_sys_open(int dfd, const char __user *filename, int flags,
 			int mode);
 extern struct file *filp_open(const char *, int, int);
@@ -1913,6 +1915,10 @@ extern struct file * dentry_open(struct 
 extern int filp_close(struct file *, fl_owner_t id);
 extern char * getname(const char __user *);
 
+/* fs/ioctl.c */
+
+extern int ioctl_preallocate(struct file *filp, void __user *argp);
+
 /* fs/dcache.c */
 extern void __init vfs_caches_init_early(void);
 extern void __init vfs_caches_init(unsigned long);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
