Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 Mar 2007 07:59:30 -0700 (PDT)
Received: from over.ny.us.ibm.com (over.ny.us.ibm.com [32.97.182.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2GExI6p027300
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 07:59:20 -0700
Received: from e2.ny.us.ibm.com ([192.168.1.102])
	by pokfb.esmtp.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l2GEXglR001095
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 10:33:42 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2GEXbbF007386
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 10:33:37 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2GEV5B9211774
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 10:31:05 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2GEV4sC017776
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 10:31:04 -0400
Date: Fri, 16 Mar 2007 20:01:01 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [RFC][PATCH] sys_fallocate() system call
Message-ID: <20070316143101.GA10152@amitarora.in.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301183445.GA7911@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
Cc: Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com

First of all, thanks for the overwhelming response!

Based on the suggestions received, I have added a new parameter to the
sys_fallocate() system call - an interger called "mode", just after the
"fd". Now the system call looks like this:

 asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)

Currently we have two modes FA_ALLOCATE and FA_DEALLOCATE, for
preallocation and deallocation of preallocated blocks respectively. More
modes can be added, when required. And these modes can be renamed, since
I am sure these are no way the best ones ! :)

Attached below is the patch which implements this system call. It has
been currently implemented and tested on i386, ppc64 and x86_64
architectures. I am facing some problems while trying to implement this
on s390, and thus the delay. While I try to get it right on s390(x), we
thought of posting this patch, so that we can save some time. Parallely
we will work on getting the patch work on s390, and probably it will
come as a separate patch.

ToDos:
=====
Following is pending:
1>   Implementation on other architectures (other than i386, x86_64 and
ppc64) like s390(x)
2>   A generic file system operation to handle fallocate
(generic_fallocate), for filesystems that do _not_ have the fallocate
inode operation implemented.
3>   ext4 patches that support fallocate inode operation are ready. I
plan to submit those separately to just ext4 mailing list.
4>   Changes to glibc, so that posix_fallocate() and posix_fallocate64()
call fallocate() system call
5>   Changes to XFS to implement the fallocate inode operation


Signed-off-by: Amit K Arora <aarora@in.ibm.com>
---
 arch/i386/kernel/syscall_table.S |    1 
 arch/x86_64/kernel/functionlist  |    1 
 fs/open.c                        |   41 +++++++++++++++++++++++++++++++++++++++
 include/asm-i386/unistd.h        |    3 +-
 include/asm-powerpc/systbl.h     |    1 
 include/asm-powerpc/unistd.h     |    3 +-
 include/asm-x86_64/unistd.h      |    4 ++-
 include/linux/fs.h               |    7 ++++++
 include/linux/syscalls.h         |    1 
 9 files changed, 59 insertions(+), 3 deletions(-)

Index: linux-2.6.20.1/arch/i386/kernel/syscall_table.S
===================================================================
--- linux-2.6.20.1.orig/arch/i386/kernel/syscall_table.S
+++ linux-2.6.20.1/arch/i386/kernel/syscall_table.S
@@ -319,3 +319,4 @@ ENTRY(sys_call_table)
 	.long sys_move_pages
 	.long sys_getcpu
 	.long sys_epoll_pwait
+	.long sys_fallocate		/* 320 */
Index: linux-2.6.20.1/fs/open.c
===================================================================
--- linux-2.6.20.1.orig/fs/open.c
+++ linux-2.6.20.1/fs/open.c
@@ -350,6 +350,47 @@ asmlinkage long sys_ftruncate64(unsigned
 }
 #endif
 
+asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)
+{
+	struct file *file;
+	struct inode *inode;
+	long ret = -EINVAL;
+
+	if (len == 0 || offset < 0)
+		goto out;
+
+	ret = -EBADF;
+	file = fget(fd);
+	if (!file)
+		goto out;
+	if (!(file->f_mode & FMODE_WRITE))
+		goto out_fput;
+
+	inode = file->f_path.dentry->d_inode;
+
+	ret = -ESPIPE;
+	if (S_ISFIFO(inode->i_mode))
+		goto out_fput;
+
+	ret = -ENODEV;
+	if (!S_ISREG(inode->i_mode))
+		goto out_fput;
+
+	ret = -EFBIG;
+	if (offset + len > inode->i_sb->s_maxbytes)
+		goto out_fput;
+
+	if (inode->i_op && inode->i_op->fallocate)
+		ret = inode->i_op->fallocate(inode, mode, offset, len);
+	else
+		ret = -ENOSYS;
+out_fput:
+	fput(file);
+out:
+	return ret;
+}
+EXPORT_SYMBOL(sys_fallocate);
+
 /*
  * access() needs to use the real uid/gid, not the effective uid/gid.
  * We do this by temporarily clearing all FS-related capabilities and
Index: linux-2.6.20.1/include/asm-i386/unistd.h
===================================================================
--- linux-2.6.20.1.orig/include/asm-i386/unistd.h
+++ linux-2.6.20.1/include/asm-i386/unistd.h
@@ -325,10 +325,11 @@
 #define __NR_move_pages		317
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
+#define __NR_fallocate		320
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 320
+#define NR_syscalls 321
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
Index: linux-2.6.20.1/include/linux/fs.h
===================================================================
--- linux-2.6.20.1.orig/include/linux/fs.h
+++ linux-2.6.20.1/include/linux/fs.h
@@ -263,6 +263,12 @@ extern int dir_notify_enable;
 #define SYNC_FILE_RANGE_WRITE		2
 #define SYNC_FILE_RANGE_WAIT_AFTER	4
 
+/*
+ * fallocate() modes
+ */
+#define FA_ALLOCATE	0x1
+#define FA_DEALLOCATE	0x2
+
 #ifdef __KERNEL__
 
 #include <linux/linkage.h>
@@ -1124,6 +1130,7 @@ struct inode_operations {
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*removexattr) (struct dentry *, const char *);
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
+	int (*fallocate)(struct inode *, int, loff_t, loff_t);
 };
 
 struct seq_file;
Index: linux-2.6.20.1/include/linux/syscalls.h
===================================================================
--- linux-2.6.20.1.orig/include/linux/syscalls.h
+++ linux-2.6.20.1/include/linux/syscalls.h
@@ -602,6 +602,7 @@ asmlinkage long sys_get_robust_list(int 
 asmlinkage long sys_set_robust_list(struct robust_list_head __user *head,
 				    size_t len);
 asmlinkage long sys_getcpu(unsigned __user *cpu, unsigned __user *node, struct getcpu_cache __user *cache);
+asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
Index: linux-2.6.20.1/include/asm-x86_64/unistd.h
===================================================================
--- linux-2.6.20.1.orig/include/asm-x86_64/unistd.h
+++ linux-2.6.20.1/include/asm-x86_64/unistd.h
@@ -619,8 +619,10 @@ __SYSCALL(__NR_sync_file_range, sys_sync
 __SYSCALL(__NR_vmsplice, sys_vmsplice)
 #define __NR_move_pages		279
 __SYSCALL(__NR_move_pages, sys_move_pages)
+#define __NR_fallocate		280
+__SYSCALL(__NR_fallocate, sys_fallocate)
 
-#define __NR_syscall_max __NR_move_pages
+#define __NR_syscall_max __NR_fallocate
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
Index: linux-2.6.20.1/include/asm-powerpc/unistd.h
===================================================================
--- linux-2.6.20.1.orig/include/asm-powerpc/unistd.h
+++ linux-2.6.20.1/include/asm-powerpc/unistd.h
@@ -324,10 +324,11 @@
 #define __NR_get_robust_list	299
 #define __NR_set_robust_list	300
 #define __NR_move_pages		301
+#define __NR_fallocate		302
 
 #ifdef __KERNEL__
 
-#define __NR_syscalls		302
+#define __NR_syscalls		303
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
Index: linux-2.6.20.1/arch/x86_64/kernel/functionlist
===================================================================
--- linux-2.6.20.1.orig/arch/x86_64/kernel/functionlist
+++ linux-2.6.20.1/arch/x86_64/kernel/functionlist
@@ -932,6 +932,7 @@
 *(.text.sys_getitimer)
 *(.text.sys_getgroups)
 *(.text.sys_ftruncate)
+*(.text.sys_fallocate)
 *(.text.sysfs_lookup)
 *(.text.sys_exit_group)
 *(.text.stub_fork)
Index: linux-2.6.20.1/include/asm-powerpc/systbl.h
===================================================================
--- linux-2.6.20.1.orig/include/asm-powerpc/systbl.h
+++ linux-2.6.20.1/include/asm-powerpc/systbl.h
@@ -305,3 +305,4 @@ SYSCALL_SPU(faccessat)
 COMPAT_SYS_SPU(get_robust_list)
 COMPAT_SYS_SPU(set_robust_list)
 COMPAT_SYS(move_pages)
+SYSCALL(fallocate)
--
Regards,
Amit Arora
