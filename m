Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 May 2007 13:04:07 -0700 (PDT)
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4FK40fB023066
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 13:04:03 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l4FK3umn028133
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 16:03:56 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4FK3uXw270492
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 14:03:56 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4FK3tN8001616
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 14:03:56 -0600
Date: Wed, 16 May 2007 01:33:59 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH 1/5][TAKE3] fallocate() implementation on i86, x86_64 and powerpc
Message-ID: <20070515200359.GA5834@amitarora.in.ibm.com>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070515193722.GA3487@amitarora.in.ibm.com> <20070515195421.GA2948@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515195421.GA2948@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

This patch implements sys_fallocate() and adds support on i386, x86_64
and powerpc platforms.

Changelog:
---------
Note: The changes below are from the initial post (dated 26th April,
2007) and _not_ from TAKE2. The only difference from TAKE2 is the kernel
version on which this patch is based. TAKE2 was based on 2.6.21 and this
is based on 2.6.22-rc1.

Following changes were made to the previous version:
 1) Added description before sys_fallocate() definition.
 2) Return EINVAL for len<=0 (With new draft that Ulrich pointed to,
    posix_fallocate should return EINVAL for len <= 0.
 3) Return EOPNOTSUPP if mode is not one of FA_ALLOCATE or FA_DEALLOCATE
 4) Do not return ENODEV for dirs (let individual file systems decide if
    they want to support preallocation to directories or not.
 5) Check for wrap through zero.
 6) Update c/mtime if fallocate() succeeds.
 7) Added mode descriptions in fs.h
 8) Added variable names to function definition (fallocate inode op)

Here is the new patch:

Signed-off-by: Amit Arora <aarora@in.ibm.com>
---
 arch/i386/kernel/syscall_table.S |    1 
 arch/powerpc/kernel/sys_ppc32.c  |    7 +++
 arch/x86_64/ia32/ia32entry.S     |    1 
 fs/open.c                        |   89 +++++++++++++++++++++++++++++++++++++++
 include/asm-i386/unistd.h        |    3 -
 include/asm-powerpc/systbl.h     |    1 
 include/asm-powerpc/unistd.h     |    3 -
 include/asm-x86_64/unistd.h      |    2 
 include/linux/fs.h               |   13 +++++
 include/linux/syscalls.h         |    1 
 10 files changed, 119 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc1/arch/i386/kernel/syscall_table.S
===================================================================
--- linux-2.6.22-rc1.orig/arch/i386/kernel/syscall_table.S
+++ linux-2.6.22-rc1/arch/i386/kernel/syscall_table.S
@@ -323,3 +323,4 @@ ENTRY(sys_call_table)
 	.long sys_signalfd
 	.long sys_timerfd
 	.long sys_eventfd
+	.long sys_fallocate
Index: linux-2.6.22-rc1/arch/powerpc/kernel/sys_ppc32.c
===================================================================
--- linux-2.6.22-rc1.orig/arch/powerpc/kernel/sys_ppc32.c
+++ linux-2.6.22-rc1/arch/powerpc/kernel/sys_ppc32.c
@@ -773,6 +773,13 @@ asmlinkage int compat_sys_truncate64(con
 	return sys_truncate(path, (high << 32) | low);
 }
 
+asmlinkage long compat_sys_fallocate(int fd, int mode, u32 offhi, u32 offlo,
+				     u32 lenhi, u32 lenlo)
+{
+	return sys_fallocate(fd, mode, ((loff_t)offhi << 32) | offlo,
+			     ((loff_t)lenhi << 32) | lenlo);
+}
+
 asmlinkage int compat_sys_ftruncate64(unsigned int fd, u32 reg4, unsigned long high,
 				 unsigned long low)
 {
Index: linux-2.6.22-rc1/fs/open.c
===================================================================
--- linux-2.6.22-rc1.orig/fs/open.c
+++ linux-2.6.22-rc1/fs/open.c
@@ -353,6 +353,95 @@ asmlinkage long sys_ftruncate64(unsigned
 #endif
 
 /*
+ * sys_fallocate - preallocate blocks or free preallocated blocks
+ * @fd: the file descriptor
+ * @mode: mode specifies if fallocate should preallocate blocks OR free
+ *	  (unallocate) preallocated blocks. Currently only FA_ALLOCATE and
+ *	  FA_DEALLOCATE modes are supported.
+ * @offset: The offset within file, from where (un)allocation is being
+ *	    requested. It should not have a negative value.
+ * @len: The amount (in bytes) of space to be (un)allocated, from the offset.
+ *
+ * This system call, depending on the mode, preallocates or unallocates blocks
+ * for a file. The range of blocks depends on the value of offset and len
+ * arguments provided by the user/application. For FA_ALLOCATE mode, if this
+ * system call succeeds, subsequent writes to the file in the given range
+ * (specified by offset & len) should not fail - even if the file system
+ * later becomes full. Hence the preallocation done is persistent (valid
+ * even after reopen of the file and remount/reboot).
+ *
+ * Note: Incase the file system does not support preallocation,
+ * posix_fallocate() should fall back to the library implementation (i.e.
+ * allocating zero-filled new blocks to the file).
+ *
+ * Return Values
+ *	0	: On SUCCESS a value of zero is returned.
+ *	error	: On Failure, an error code will be returned.
+ * An error code of -ENOSYS or -EOPNOTSUPP should make posix_fallocate()
+ * fall back on library implementation of fallocate.
+ *
+ * <TBD> Generic fallocate to be added for file systems that do not
+ *	 support fallocate it.
+ */
+asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)
+{
+	struct file *file;
+	struct inode *inode;
+	long ret = -EINVAL;
+
+	if (offset < 0 || len <= 0)
+		goto out;
+
+	/* Return error if mode is not supported */
+	ret = -EOPNOTSUPP;
+	if (mode != FA_ALLOCATE && mode !=FA_DEALLOCATE)
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
+	/*
+	 * Let individual file system decide if it supports preallocation
+	 * for directories or not.
+	 */
+	if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
+		goto out_fput;
+
+	ret = -EFBIG;
+	/* Check for wrap through zero too */
+	if (((offset + len) > inode->i_sb->s_maxbytes) || ((offset + len) < 0))
+		goto out_fput;
+
+	if (inode->i_op && inode->i_op->fallocate)
+		ret = inode->i_op->fallocate(inode, mode, offset, len);
+	else
+		ret = -ENOSYS;
+
+	/*
+	 * Update [cm]time.
+	 * Partial allocation will not result in the time stamp changes,
+	 * since ->fallocate will return error (say, -ENOSPC) in this case.
+	 */
+	if (!ret)
+		file_update_time(file);
+out_fput:
+	fput(file);
+out:
+	return ret;
+}
+
+/*
  * access() needs to use the real uid/gid, not the effective uid/gid.
  * We do this by temporarily clearing all FS-related capabilities and
  * switching the fsuid/fsgid around to the real ones.
Index: linux-2.6.22-rc1/include/asm-i386/unistd.h
===================================================================
--- linux-2.6.22-rc1.orig/include/asm-i386/unistd.h
+++ linux-2.6.22-rc1/include/asm-i386/unistd.h
@@ -329,10 +329,11 @@
 #define __NR_signalfd		321
 #define __NR_timerfd		322
 #define __NR_eventfd		323
+#define __NR_fallocate		324
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 324
+#define NR_syscalls 325
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
Index: linux-2.6.22-rc1/include/asm-powerpc/systbl.h
===================================================================
--- linux-2.6.22-rc1.orig/include/asm-powerpc/systbl.h
+++ linux-2.6.22-rc1/include/asm-powerpc/systbl.h
@@ -308,3 +308,4 @@ COMPAT_SYS_SPU(move_pages)
 SYSCALL_SPU(getcpu)
 COMPAT_SYS(epoll_pwait)
 COMPAT_SYS_SPU(utimensat)
+COMPAT_SYS(fallocate)
Index: linux-2.6.22-rc1/include/asm-powerpc/unistd.h
===================================================================
--- linux-2.6.22-rc1.orig/include/asm-powerpc/unistd.h
+++ linux-2.6.22-rc1/include/asm-powerpc/unistd.h
@@ -327,10 +327,11 @@
 #define __NR_getcpu		302
 #define __NR_epoll_pwait	303
 #define __NR_utimensat		304
+#define __NR_fallocate		305
 
 #ifdef __KERNEL__
 
-#define __NR_syscalls		305
+#define __NR_syscalls		306
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
Index: linux-2.6.22-rc1/include/asm-x86_64/unistd.h
===================================================================
--- linux-2.6.22-rc1.orig/include/asm-x86_64/unistd.h
+++ linux-2.6.22-rc1/include/asm-x86_64/unistd.h
@@ -630,6 +630,8 @@ __SYSCALL(__NR_signalfd, sys_signalfd)
 __SYSCALL(__NR_timerfd, sys_timerfd)
 #define __NR_eventfd		283
 __SYSCALL(__NR_eventfd, sys_eventfd)
+#define __NR_fallocate		284
+__SYSCALL(__NR_fallocate, sys_fallocate)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
Index: linux-2.6.22-rc1/include/linux/fs.h
===================================================================
--- linux-2.6.22-rc1.orig/include/linux/fs.h
+++ linux-2.6.22-rc1/include/linux/fs.h
@@ -266,6 +266,17 @@ extern int dir_notify_enable;
 #define SYNC_FILE_RANGE_WRITE		2
 #define SYNC_FILE_RANGE_WAIT_AFTER	4
 
+/*
+ * sys_fallocate modes
+ * Currently sys_fallocate supports two modes:
+ * FA_ALLOCATE  : This is the preallocate mode, using which an application/user
+ *		  may request (pre)allocation of blocks.
+ * FA_DEALLOCATE: This is the deallocate mode, which can be used to free
+ *		  the preallocated blocks.
+ */
+#define FA_ALLOCATE	0x1
+#define FA_DEALLOCATE	0x2
+
 #ifdef __KERNEL__
 
 #include <linux/linkage.h>
@@ -1137,6 +1148,8 @@ struct inode_operations {
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*removexattr) (struct dentry *, const char *);
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
+	long (*fallocate)(struct inode *inode, int mode, loff_t offset,
+			  loff_t len);
 };
 
 struct seq_file;
Index: linux-2.6.22-rc1/include/linux/syscalls.h
===================================================================
--- linux-2.6.22-rc1.orig/include/linux/syscalls.h
+++ linux-2.6.22-rc1/include/linux/syscalls.h
@@ -608,6 +608,7 @@ asmlinkage long sys_signalfd(int ufd, si
 asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
 			    const struct itimerspec __user *utmr);
 asmlinkage long sys_eventfd(unsigned int count);
+asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
Index: linux-2.6.22-rc1/arch/x86_64/ia32/ia32entry.S
===================================================================
--- linux-2.6.22-rc1.orig/arch/x86_64/ia32/ia32entry.S
+++ linux-2.6.22-rc1/arch/x86_64/ia32/ia32entry.S
@@ -719,4 +719,5 @@ ia32_sys_call_table:
 	.quad compat_sys_signalfd
 	.quad compat_sys_timerfd
 	.quad sys_eventfd
+	.quad sys_fallocate
 ia32_syscall_end:
