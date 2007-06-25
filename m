Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Jun 2007 06:42:49 -0700 (PDT)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5PDgjdo006046
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 06:42:46 -0700
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l5PDboiw001955
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 09:37:50 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5PDgkbl215560
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 07:42:46 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5PDgjAb018279
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 07:42:46 -0600
Date: Mon, 25 Jun 2007 19:12:55 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH 2/7][TAKE5] fallocate() on s390(x)
Message-ID: <20070625134255.GC1951@amitarora.in.ibm.com>
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

This is the patch suggested by Martin Schwidefsky to support
sys_fallocate() on s390(x) platform.

He also suggested a wrapper in glibc to handle this system call on
s390. Posting it here so that we get feedback for this too.

.globl __fallocate
ENTRY(__fallocate)
        stm     %r6,%r7,28(%r15)        /* save %r6/%r7 on stack */
        cfi_offset (%r7, -68)
        cfi_offset (%r6, -72)
        lm      %r6,%r7,96(%r15)        /* load loff_t len from stack */
        svc     SYS_ify(fallocate)
        lm      %r6,%r7,28(%r15)        /* restore %r6/%r7 from stack */
        br      %r14
PSEUDO_END(__fallocate)


Here are the comments and the patch to linux kernel from him.

-------------
From: Martin Schwidefsky <schwidefsky@de.ibm.com>

This patch implements support of fallocate system call on s390(x)
platform. A wrapper is added to address the issue which s390 ABI has
with the arguments of this system call.


Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

Index: linux-2.6.22-rc4/arch/s390/kernel/compat_wrapper.S
===================================================================
--- linux-2.6.22-rc4.orig/arch/s390/kernel/compat_wrapper.S	2007-06-11 16:16:01.000000000 -0700
+++ linux-2.6.22-rc4/arch/s390/kernel/compat_wrapper.S	2007-06-11 16:27:29.000000000 -0700
@@ -1683,6 +1683,16 @@
 	llgtr	%r3,%r3			# struct compat_timeval *
 	jg	compat_sys_utimes
 
+	.globl  sys_fallocate_wrapper
+sys_fallocate_wrapper:
+	lgfr	%r2,%r2			# int
+	lgfr	%r3,%r3			# int
+	sllg    %r4,%r4,32		# get high word of 64bit loff_t
+	lr      %r4,%r5			# get low word of 64bit loff_t
+	sllg    %r5,%r6,32		# get high word of 64bit loff_t
+	l	%r5,164(%r15)		# get low word of 64bit loff_t
+	jg	sys_fallocate
+
 	.globl	compat_sys_utimensat_wrapper
 compat_sys_utimensat_wrapper:
 	llgfr	%r2,%r2			# unsigned int
Index: linux-2.6.22-rc4/arch/s390/kernel/sys_s390.c
===================================================================
--- linux-2.6.22-rc4.orig/arch/s390/kernel/sys_s390.c	2007-06-11 16:16:01.000000000 -0700
+++ linux-2.6.22-rc4/arch/s390/kernel/sys_s390.c	2007-06-11 16:27:29.000000000 -0700
@@ -265,3 +265,32 @@
 		return -EFAULT;
 	return sys_fadvise64_64(a.fd, a.offset, a.len, a.advice);
 }
+
+#ifndef CONFIG_64BIT
+/*
+ * This is a wrapper to call sys_fallocate(). For 31 bit s390 the last
+ * 64 bit argument "len" is split into the upper and lower 32 bits. The
+ * system call wrapper in the user space loads the value to %r6/%r7.
+ * The code in entry.S keeps the values in %r2 - %r6 where they are and
+ * stores %r7 to 96(%r15). But the standard C linkage requires that
+ * the whole 64 bit value for len is stored on the stack and doesn't
+ * use %r6 at all. So s390_fallocate has to convert the arguments from
+ *   %r2: fd, %r3: mode, %r4/%r5: offset, %r6/96(%r15)-99(%r15): len
+ * to
+ *   %r2: fd, %r3: mode, %r4/%r5: offset, 96(%r15)-103(%r15): len
+ */
+asmlinkage long s390_fallocate(int fd, int mode, loff_t offset,
+			       u32 len_high, u32 len_low)
+{
+	union {
+		u64 len;
+		struct {
+			u32 high;
+			u32 low;
+		};
+	} cv;
+	cv.high = len_high;
+	cv.low = len_low;
+	return sys_fallocate(fd, mode, offset, cv.len);
+}
+#endif
Index: linux-2.6.22-rc4/arch/s390/kernel/syscalls.S
===================================================================
--- linux-2.6.22-rc4.orig/arch/s390/kernel/syscalls.S	2007-06-11 16:16:01.000000000 -0700
+++ linux-2.6.22-rc4/arch/s390/kernel/syscalls.S	2007-06-11 16:27:29.000000000 -0700
@@ -322,6 +322,7 @@
 SYSCALL(sys_getcpu,sys_getcpu,sys_getcpu_wrapper)
 SYSCALL(sys_epoll_pwait,sys_epoll_pwait,compat_sys_epoll_pwait_wrapper)
 SYSCALL(sys_utimes,sys_utimes,compat_sys_utimes_wrapper)
+SYSCALL(s390_fallocate,sys_fallocate,sys_fallocate_wrapper)
 NI_SYSCALL							/* 314 sys_fallocate */
 SYSCALL(sys_utimensat,sys_utimensat,compat_sys_utimensat_wrapper)	/* 315 */
 SYSCALL(sys_signalfd,sys_signalfd,compat_sys_signalfd_wrapper)
Index: linux-2.6.22-rc4/include/asm-s390/unistd.h
===================================================================
--- linux-2.6.22-rc4.orig/include/asm-s390/unistd.h	2007-06-11 16:16:01.000000000 -0700
+++ linux-2.6.22-rc4/include/asm-s390/unistd.h	2007-06-11 16:27:29.000000000 -0700
@@ -256,7 +256,8 @@
 #define __NR_signalfd		316
 #define __NR_timerfd		317
 #define __NR_eventfd		318
-#define NR_syscalls 319
+#define __NR_fallocate		319
+#define NR_syscalls 320
 
 /* 
  * There are some system calls that are not present on 64 bit, some
