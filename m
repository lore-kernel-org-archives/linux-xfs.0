Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Jun 2007 07:11:40 -0700 (PDT)
Received: from over.ny.us.ibm.com (over.ny.us.ibm.com [32.97.182.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5PEBXdo018404
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 07:11:36 -0700
Received: from e6.ny.us.ibm.com ([192.168.1.106])
	by pokfb.esmtp.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l5PDe6M0017825
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 09:40:06 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5PDfDYm028915
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 09:41:13 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5PDe4cH549482
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 09:40:04 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5PDe36v025131
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 09:40:04 -0400
Date: Mon, 25 Jun 2007 19:10:12 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH 1/7][TAKE5] fallocate() implementation on i386, x86_64 and powerpc
Message-ID: <20070625134012.GB1951@amitarora.in.ibm.com>
References: <20070510115620.GB21400@amitarora.in.ibm.com> <20070510223950.GD86004887@sgi.com> <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625132810.GA1951@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Cc: David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

This patch implements sys_fallocate() and adds support on i386, x86_64
and powerpc platforms.

Changelog:
---------
Changes from Take3 to Take4:
 1) Do not update c/mtime. Let each filesystem update ctime (update of
    mtime will not be required for allocation since we touch only
    metadata/inode and not blocks), if required.
Changes from Take2 to Take3:
 1) Patches now based on 2.6.22-rc1 kernel.
Changes from Take1(initial post on 26th April, 2007) to Take2:
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


Signed-off-by: Amit Arora <aarora@in.ibm.com>

Index: linux-2.6.22-rc4/arch/i386/kernel/syscall_table.S
===================================================================
--- linux-2.6.22-rc4.orig/arch/i386/kernel/syscall_table.S
+++ linux-2.6.22-rc4/arch/i386/kernel/syscall_table.S
@@ -323,3 +323,4 @@ ENTRY(sys_call_table)
 	.long sys_signalfd
 	.long sys_timerfd
 	.long sys_eventfd
+	.long sys_fallocate
Index: linux-2.6.22-rc4/arch/powerpc/kernel/sys_ppc32.c
===================================================================
--- linux-2.6.22-rc4.orig/arch/powerpc/kernel/sys_ppc32.c
+++ linux-2.6.22-rc4/arch/powerpc/kernel/sys_ppc32.c
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
Index: linux-2.6.22-rc4/arch/x86_64/ia32/ia32entry.S
===================================================================
--- linux-2.6.22-rc4.orig/arch/x86_64/ia32/ia32entry.S
+++ linux-2.6.22-rc4/arch/x86_64/ia32/ia32entry.S
@@ -719,4 +719,5 @@ ia32_sys_call_table:
 	.quad compat_sys_signalfd
 	.quad compat_sys_timerfd
 	.quad sys_eventfd
+	.quad sys_fallocate
 ia32_syscall_end:
Index: linux-2.6.22-rc4/fs/open.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/open.c
+++ linux-2.6.22-rc4/fs/open.c
@@ -353,6 +353,92 @@ asmlinkage long sys_ftruncate64(unsigned
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
+ * It is expected that the ->fallocate() inode operation implemented by the
+ * individual file systems will update the file size and/or ctime/mtime
+ * depending on the mode and also on the success of the operation.
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
+	if (mode != FA_ALLOCATE && mode != FA_DEALLOCATE)
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
Index: linux-2.6.22-rc4/include/asm-i386/unistd.h
===================================================================
--- linux-2.6.22-rc4.orig/include/asm-i386/unistd.h
+++ linux-2.6.22-rc4/include/asm-i386/unistd.h
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
Index: linux-2.6.22-rc4/include/asm-powerpc/systbl.h
===================================================================
--- linux-2.6.22-rc4.orig/include/asm-powerpc/systbl.h
+++ linux-2.6.22-rc4/include/asm-powerpc/systbl.h
@@ -308,6 +308,7 @@ COMPAT_SYS_SPU(move_pages)
 SYSCALL_SPU(getcpu)
 COMPAT_SYS(epoll_pwait)
 COMPAT_SYS_SPU(utimensat)
+COMPAT_SYS(fallocate)
 COMPAT_SYS_SPU(signalfd)
 COMPAT_SYS_SPU(timerfd)
 SYSCALL_SPU(eventfd)
Index: linux-2.6.22-rc4/include/asm-powerpc/unistd.h
===================================================================
--- linux-2.6.22-rc4.orig/include/asm-powerpc/unistd.h
+++ linux-2.6.22-rc4/include/asm-powerpc/unistd.h
@@ -330,10 +330,11 @@
 #define __NR_signalfd		305
 #define __NR_timerfd		306
 #define __NR_eventfd		307
+#define __NR_fallocate		308
 
 #ifdef __KERNEL__
 
-#define __NR_syscalls		308
+#define __NR_syscalls		309
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
Index: linux-2.6.22-rc4/include/asm-x86_64/unistd.h
===================================================================
--- linux-2.6.22-rc4.orig/include/asm-x86_64/unistd.h
+++ linux-2.6.22-rc4/include/asm-x86_64/unistd.h
@@ -630,6 +630,8 @@ __SYSCALL(__NR_signalfd, sys_signalfd)
 __SYSCALL(__NR_timerfd, sys_timerfd)
 #define __NR_eventfd		283
 __SYSCALL(__NR_eventfd, sys_eventfd)
+#define __NR_fallocate		284
+__SYSCALL(__NR_fallocate, sys_fallocate)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
Index: linux-2.6.22-rc4/include/linux/fs.h
===================================================================
--- linux-2.6.22-rc4.orig/include/linux/fs.h
+++ linux-2.6.22-rc4/include/linux/fs.h
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
@@ -1138,6 +1149,8 @@ struct inode_operations {
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*removexattr) (struct dentry *, const char *);
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
+	long (*fallocate)(struct inode *inode, int mode, loff_t offset,
+			  loff_t len);
 };
 
 struct seq_file;
Index: linux-2.6.22-rc4/include/linux/syscalls.h
===================================================================
--- linux-2.6.22-rc4.orig/include/linux/syscalls.h
+++ linux-2.6.22-rc4/include/linux/syscalls.h
@@ -608,6 +608,7 @@ asmlinkage long sys_signalfd(int ufd, si
 asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
 			    const struct itimerspec __user *utmr);
 asmlinkage long sys_eventfd(unsigned int count);
+asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
