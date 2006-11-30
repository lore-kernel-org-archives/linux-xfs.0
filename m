Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Nov 2006 19:17:24 -0800 (PST)
Received: from eric-weiss.de (eric-weiss.de [212.42.235.197])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAU3HCaG029655
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 19:17:13 -0800
Date: Thu, 30 Nov 2006 03:54:59 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
Message-ID: <20061130025459.GA23869@xi.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [PATCH] libattr 2.4.32 arm eabi system call calling convention
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: agruen@suse.de, xfs@oss.sgi.com
Cc: linux-arm@lists.arm.linux.org.uk

When building for EABI, a different system call calling convention is
used where system calls are numbered starting from zero, not 0x900000
as in the old ABI.  This was causing 'ls -al' with an ls binary that
was built with xattr support to SIGILL.


--- attr-2.4.32/libattr/syscalls.c.orig	2006-11-30 03:34:25.000000000 +0100
+++ attr-2.4.32/libattr/syscalls.c	2006-11-30 03:35:12.000000000 +0100
@@ -110,7 +110,11 @@
 # define __NR_fremovexattr	235
 #elif defined (__arm__)
 # define HAVE_XATTR_SYSCALLS 1
-# define __NR_SYSCALL_BASE 0x900000
+# if defined(__ARM_EABI__) || defined(__thumb__)
+#  define __NR_SYSCALL_BASE 0
+# else
+#  define __NR_SYSCALL_BASE 0x900000
+# endif
 # define __NR_setxattr		(__NR_SYSCALL_BASE+226)
 # define __NR_lsetxattr		(__NR_SYSCALL_BASE+227)
 # define __NR_fsetxattr		(__NR_SYSCALL_BASE+228)

-------------------------------------------------------------------
List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm
FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
