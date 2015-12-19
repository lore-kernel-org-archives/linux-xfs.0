Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 913267F50
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:55:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 16629AC005
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:55:28 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id YO9HvX738vLonYXb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:55:23 -0800 (PST)
Subject: [PATCH 1/9] vfs: add copy_file_range syscall and vfs helper
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:55:11 -0800
Message-ID: <20151219085511.12478.7606.stgit@birch.djwong.org>
In-Reply-To: <20151219085505.12478.71157.stgit@birch.djwong.org>
References: <20151219085505.12478.71157.stgit@birch.djwong.org>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: Zach Brown <zab@redhat.com>, linux-api@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, Anna Schumaker <Anna.Schumaker@Netapp.com>

>From : Anna Schumaker <Anna.Schumaker@Netapp.com>
>From : Zach Brown <zab@redhat.com>

Add a copy_file_range() system call for offloading copies between
regular files.

This gives an interface to underlying layers of the storage stack which
can copy without reading and writing all the data.  There are a few
candidates that should support copy offloading in the nearer term:

- btrfs shares extent references with its clone ioctl
- NFS has patches to add a COPY command which copies on the server
- SCSI has a family of XCOPY commands which copy in the device

This system call avoids the complexity of also accelerating the creation
of the destination file by operating on an existing destination file
descriptor, not a path.

Currently the high level vfs entry point limits copy offloading to files
on the same mount and super (and not in the same file).  This can be
relaxed if we get implementations which can copy between file systems
safely.

Signed-off-by: Zach Brown <zab@redhat.com>
[Anna Schumaker: Change -EINVAL to -EBADF during file verification,
                 Change flags parameter from int to unsigned int,
                 Add function to include/linux/syscalls.h,
                 Check copy len after file open mode,
                 Don't forbid ranges inside the same file,
                 Use rw_verify_area() to veriy ranges,
                 Use file_out rather than file_in,
                 Add COPY_FR_REFLINK flag]
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/read_write.c                   |  120 +++++++++++++++++++++++++++++++++++++
 include/linux/fs.h                |    3 +
 include/linux/syscalls.h          |    3 +
 include/uapi/asm-generic/unistd.h |    4 +
 kernel/sys_ni.c                   |    1 
 5 files changed, 130 insertions(+), 1 deletion(-)


diff --git a/fs/read_write.c b/fs/read_write.c
index 819ef3f..97c15ca 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -16,6 +16,7 @@
 #include <linux/pagemap.h>
 #include <linux/splice.h>
 #include <linux/compat.h>
+#include <linux/mount.h>
 #include "internal.h"
 
 #include <asm/uaccess.h>
@@ -1327,3 +1328,122 @@ COMPAT_SYSCALL_DEFINE4(sendfile64, int, out_fd, int, in_fd,
 	return do_sendfile(out_fd, in_fd, NULL, count, 0);
 }
 #endif
+
+/*
+ * copy_file_range() differs from regular file read and write in that it
+ * specifically allows return partial success.  When it does so is up to
+ * the copy_file_range method.
+ */
+ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
+			    struct file *file_out, loff_t pos_out,
+			    size_t len, unsigned int flags)
+{
+	struct inode *inode_in = file_inode(file_in);
+	struct inode *inode_out = file_inode(file_out);
+	ssize_t ret;
+
+	if (flags != 0)
+		return -EINVAL;
+
+	/* copy_file_range allows full ssize_t len, ignoring MAX_RW_COUNT  */
+	ret = rw_verify_area(READ, file_in, &pos_in, len);
+	if (ret >= 0)
+		ret = rw_verify_area(WRITE, file_out, &pos_out, len);
+	if (ret < 0)
+		return ret;
+
+	if (!(file_in->f_mode & FMODE_READ) ||
+	    !(file_out->f_mode & FMODE_WRITE) ||
+	    (file_out->f_flags & O_APPEND) ||
+	    !file_out->f_op->copy_file_range)
+		return -EBADF;
+
+	/* this could be relaxed once a method supports cross-fs copies */
+	if (inode_in->i_sb != inode_out->i_sb)
+		return -EXDEV;
+
+	if (len == 0)
+		return 0;
+
+	ret = mnt_want_write_file(file_out);
+	if (ret)
+		return ret;
+
+	ret = file_out->f_op->copy_file_range(file_in, pos_in, file_out, pos_out,
+					      len, flags);
+	if (ret > 0) {
+		fsnotify_access(file_in);
+		add_rchar(current, ret);
+		fsnotify_modify(file_out);
+		add_wchar(current, ret);
+	}
+	inc_syscr(current);
+	inc_syscw(current);
+
+	mnt_drop_write_file(file_out);
+
+	return ret;
+}
+EXPORT_SYMBOL(vfs_copy_file_range);
+
+SYSCALL_DEFINE6(copy_file_range, int, fd_in, loff_t __user *, off_in,
+		int, fd_out, loff_t __user *, off_out,
+		size_t, len, unsigned int, flags)
+{
+	loff_t pos_in;
+	loff_t pos_out;
+	struct fd f_in;
+	struct fd f_out;
+	ssize_t ret = -EBADF;
+
+	f_in = fdget(fd_in);
+	if (!f_in.file)
+		goto out2;
+
+	f_out = fdget(fd_out);
+	if (!f_out.file)
+		goto out1;
+
+	ret = -EFAULT;
+	if (off_in) {
+		if (copy_from_user(&pos_in, off_in, sizeof(loff_t)))
+			goto out;
+	} else {
+		pos_in = f_in.file->f_pos;
+	}
+
+	if (off_out) {
+		if (copy_from_user(&pos_out, off_out, sizeof(loff_t)))
+			goto out;
+	} else {
+		pos_out = f_out.file->f_pos;
+	}
+
+	ret = vfs_copy_file_range(f_in.file, pos_in, f_out.file, pos_out, len,
+				  flags);
+	if (ret > 0) {
+		pos_in += ret;
+		pos_out += ret;
+
+		if (off_in) {
+			if (copy_to_user(off_in, &pos_in, sizeof(loff_t)))
+				ret = -EFAULT;
+		} else {
+			f_in.file->f_pos = pos_in;
+		}
+
+		if (off_out) {
+			if (copy_to_user(off_out, &pos_out, sizeof(loff_t)))
+				ret = -EFAULT;
+		} else {
+			f_out.file->f_pos = pos_out;
+		}
+	}
+
+out:
+	fdput(f_in);
+out1:
+	fdput(f_out);
+out2:
+	return ret;
+}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3aa5142..e8a7362 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1629,6 +1629,7 @@ struct file_operations {
 #ifndef CONFIG_MMU
 	unsigned (*mmap_capabilities)(struct file *);
 #endif
+	ssize_t (*copy_file_range)(struct file *, loff_t, struct file *, loff_t, size_t, unsigned int);
 };
 
 struct inode_operations {
@@ -1680,6 +1681,8 @@ extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
 		unsigned long, loff_t *);
 extern ssize_t vfs_writev(struct file *, const struct iovec __user *,
 		unsigned long, loff_t *);
+extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
+				   loff_t, size_t, unsigned int);
 
 struct super_operations {
    	struct inode *(*alloc_inode)(struct super_block *sb);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index c2b66a2..185815c 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -886,6 +886,9 @@ asmlinkage long sys_execveat(int dfd, const char __user *filename,
 			const char __user *const __user *envp, int flags);
 
 asmlinkage long sys_membarrier(int cmd, int flags);
+asmlinkage long sys_copy_file_range(int fd_in, loff_t __user *off_in,
+				    int fd_out, loff_t __user *off_out,
+				    size_t len, unsigned int flags);
 
 asmlinkage long sys_mlock2(unsigned long start, size_t len, int flags);
 
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 1324b02..2622b33 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -715,9 +715,11 @@ __SYSCALL(__NR_userfaultfd, sys_userfaultfd)
 __SYSCALL(__NR_membarrier, sys_membarrier)
 #define __NR_mlock2 284
 __SYSCALL(__NR_mlock2, sys_mlock2)
+#define __NR_copy_file_range 285
+__SYSCALL(__NR_copy_file_range, sys_copy_file_range)
 
 #undef __NR_syscalls
-#define __NR_syscalls 285
+#define __NR_syscalls 286
 
 /*
  * All syscalls below here should go away really,
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 0623787..2c5e3a8 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -174,6 +174,7 @@ cond_syscall(sys_setfsuid);
 cond_syscall(sys_setfsgid);
 cond_syscall(sys_capget);
 cond_syscall(sys_capset);
+cond_syscall(sys_copy_file_range);
 
 /* arch-specific weak syscall entries */
 cond_syscall(sys_pciconfig_read);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
