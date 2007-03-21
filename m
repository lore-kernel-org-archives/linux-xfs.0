Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Mar 2007 05:05:49 -0700 (PDT)
Received: from e6.ny.us.ibm.com (e6.ny.us.ibm.com [32.97.182.146])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2LC5h6p025464
	for <xfs@oss.sgi.com>; Wed, 21 Mar 2007 05:05:44 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2LC6TDf003617
	for <xfs@oss.sgi.com>; Wed, 21 Mar 2007 08:06:29 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2LC4OPI233464
	for <xfs@oss.sgi.com>; Wed, 21 Mar 2007 08:04:24 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2LC4NuI032560
	for <xfs@oss.sgi.com>; Wed, 21 Mar 2007 08:04:24 -0400
Date: Wed, 21 Mar 2007 17:34:25 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] sys_fallocate() system call
Message-ID: <20070321120425.GA27273@amitarora.in.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <20070317111036.GC29931@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070317111036.GC29931@parisc-linux.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matthew Wilcox <matthew@wil.cx>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com

On Sat, Mar 17, 2007 at 05:10:37AM -0600, Matthew Wilcox wrote:
> How about:
> 
> asmlinkage long sys_fallocate(int fd, int mode, u32 off_low, u32 off_high,
> 				u32 len_low, u32 len_high);
> 
> That way we all suffer equally ...

As suggested by you and Russel, I have made this change to the patch.
Here is how it looks like now. Please let me know if anyone has concerns
about passing arguments this way (breaking each "loff_t" into two "u32"s).

Signed-off-by: Amit K Arora <aarora@in.ibm.com>
---
 arch/i386/kernel/syscall_table.S |    1 
 arch/x86_64/kernel/functionlist  |    1 
 fs/open.c                        |   46 +++++++++++++++++++++++++++++++++++++++
 include/asm-i386/unistd.h        |    3 +-
 include/asm-powerpc/systbl.h     |    1 
 include/asm-powerpc/unistd.h     |    3 +-
 include/asm-x86_64/unistd.h      |    4 ++-
 include/linux/fs.h               |    7 +++++
 include/linux/syscalls.h         |    2 +
 9 files changed, 65 insertions(+), 3 deletions(-)

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
@@ -350,6 +350,52 @@ asmlinkage long sys_ftruncate64(unsigned
 }
 #endif
 
+asmlinkage long sys_fallocate(int fd, int mode, u32 off_low, u32 off_high,
+				u32 len_low, u32 len_high)
+{
+	struct file *file;
+	struct inode *inode;
+	loff_t offset, len;
+	long ret = -EINVAL;
+
+	offset = (off_high << 32) + off_low;
+	len = (len_high << 32) + len_low;
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
@@ -602,6 +602,8 @@ asmlinkage long sys_get_robust_list(int 
 asmlinkage long sys_set_robust_list(struct robust_list_head __user *head,
 				    size_t len);
 asmlinkage long sys_getcpu(unsigned __user *cpu, unsigned __user *node, struct getcpu_cache __user *cache);
+asmlinkage long sys_fallocate(int fd, int mode, u32 off_low, u32 off_high,
+				u32 len_low, u32 len_high);
 
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
