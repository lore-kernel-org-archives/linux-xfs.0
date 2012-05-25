Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4PFqfnG134536 for <xfs@oss.sgi.com>; Fri, 25 May 2012 10:52:41 -0500
Received: from seven.medozas.de (seven.medozas.de [188.40.89.202]) by
	cuda.sgi.com with ESMTP id TlNvmG7HxTJHvTBC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 May 2012 08:52:40 -0700 (PDT)
From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 1/2] types.h: implement intptr_t and uintptr_t
Date: Fri, 25 May 2012 17:52:26 +0200
Message-Id: <1337961147-11668-2-git-send-email-jengelh@inai.de>
In-Reply-To: <1337961147-11668-1-git-send-email-jengelh@inai.de>
References: <20120525103758.GD1707@infradead.org>
	<1337961147-11668-1-git-send-email-jengelh@inai.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: hch@infradead.org, joe@perches.com

intptr_t and uintptr_t designate an (un)signed integer type capable of
holding void* pointers.
(http://pubs.opengroup.org/onlinepubs/000095399/basedefs/stdint.h.html )

Notes: In linux/types.h, there are a handful of guards like "#ifdef
_PTRDIFF_T", but a git grep reveals that this is never ever defined
anywhere, so I omitted a corresponding "#ifdef _INTPTR_T" guard.
Same goes for "#define __kernel_ptrdiff_t" in
arch/sh/include/asm/posix_types_64.h.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 arch/avr32/include/asm/posix_types.h    |    2 ++
 arch/blackfin/include/asm/posix_types.h |    2 ++
 arch/cris/include/asm/posix_types.h     |    2 ++
 arch/mn10300/include/asm/posix_types.h  |    2 ++
 arch/powerpc/include/asm/posix_types.h  |    2 ++
 arch/s390/include/asm/posix_types.h     |    4 ++++
 arch/sh/include/asm/posix_types_64.h    |    2 ++
 arch/sparc/include/asm/posix_types.h    |    2 ++
 arch/xtensa/include/asm/posix_types.h   |    2 ++
 include/asm-generic/posix_types.h       |    4 ++++
 include/linux/types.h                   |    5 +++--
 11 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/avr32/include/asm/posix_types.h b/arch/avr32/include/asm/posix_types.h
index 74667bf..9670c32 100644
--- a/arch/avr32/include/asm/posix_types.h
+++ b/arch/avr32/include/asm/posix_types.h
@@ -26,6 +26,8 @@ typedef unsigned short  __kernel_ipc_pid_t;
 typedef unsigned long	__kernel_size_t;
 typedef long		__kernel_ssize_t;
 typedef int             __kernel_ptrdiff_t;
+typedef int             __kernel_intptr_t;
+typedef unsigned int    __kernel_uintptr_t;
 #define __kernel_size_t __kernel_size_t
 
 typedef unsigned short  __kernel_old_uid_t;
diff --git a/arch/blackfin/include/asm/posix_types.h b/arch/blackfin/include/asm/posix_types.h
index 41bc187..b4da8fa 100644
--- a/arch/blackfin/include/asm/posix_types.h
+++ b/arch/blackfin/include/asm/posix_types.h
@@ -19,6 +19,8 @@ typedef unsigned int __kernel_ipc_pid_t;
 typedef unsigned long __kernel_size_t;
 typedef long __kernel_ssize_t;
 typedef int __kernel_ptrdiff_t;
+typedef int __kernel_intptr_t;
+typedef unsigned int __kernel_uintptr_t;
 #define __kernel_size_t __kernel_size_t
 
 typedef unsigned short __kernel_old_uid_t;
diff --git a/arch/cris/include/asm/posix_types.h b/arch/cris/include/asm/posix_types.h
index 72b3cd6..241d188 100644
--- a/arch/cris/include/asm/posix_types.h
+++ b/arch/cris/include/asm/posix_types.h
@@ -28,6 +28,8 @@ typedef unsigned short	__kernel_gid_t;
 typedef __SIZE_TYPE__	__kernel_size_t;
 typedef long		__kernel_ssize_t;
 typedef int		__kernel_ptrdiff_t;
+typedef int		__kernel_intptr_t;
+typedef unsigned int	__kernel_uintptr_t;
 #define __kernel_size_t __kernel_size_t
 
 typedef unsigned short	__kernel_old_dev_t;
diff --git a/arch/mn10300/include/asm/posix_types.h b/arch/mn10300/include/asm/posix_types.h
index ab50618..5f43928 100644
--- a/arch/mn10300/include/asm/posix_types.h
+++ b/arch/mn10300/include/asm/posix_types.h
@@ -38,6 +38,8 @@ typedef unsigned long	__kernel_size_t;
 typedef signed long	__kernel_ssize_t;
 #endif
 typedef int		__kernel_ptrdiff_t;
+typedef int		__kernel_intptr_t;
+typedef unsigned int	__kernel_uintptr_t;
 #define __kernel_size_t __kernel_size_t
 
 typedef unsigned short	__kernel_old_dev_t;
diff --git a/arch/powerpc/include/asm/posix_types.h b/arch/powerpc/include/asm/posix_types.h
index f139325..6f8d25c 100644
--- a/arch/powerpc/include/asm/posix_types.h
+++ b/arch/powerpc/include/asm/posix_types.h
@@ -14,6 +14,8 @@ typedef unsigned long	__kernel_old_dev_t;
 typedef unsigned int	__kernel_size_t;
 typedef int		__kernel_ssize_t;
 typedef long		__kernel_ptrdiff_t;
+typedef long		__kernel_intptr_t;
+typedef unsigned long	__kernel_uintptr_t;
 #define __kernel_size_t __kernel_size_t
 
 typedef unsigned short	__kernel_nlink_t;
diff --git a/arch/s390/include/asm/posix_types.h b/arch/s390/include/asm/posix_types.h
index edf8527..8c89e7a 100644
--- a/arch/s390/include/asm/posix_types.h
+++ b/arch/s390/include/asm/posix_types.h
@@ -30,6 +30,8 @@ typedef unsigned short  __kernel_uid_t;
 typedef unsigned short  __kernel_gid_t;
 typedef int             __kernel_ssize_t;
 typedef int             __kernel_ptrdiff_t;
+typedef int             __kernel_intptr_t;
+typedef unsigned int    __kernel_uintptr_t;
 
 #else /* __s390x__ */
 
@@ -41,6 +43,8 @@ typedef unsigned int    __kernel_uid_t;
 typedef unsigned int    __kernel_gid_t;
 typedef long            __kernel_ssize_t;
 typedef long            __kernel_ptrdiff_t;
+typedef long            __kernel_intptr_t;
+typedef unsigned long   __kernel_uintptr_t;
 typedef unsigned long   __kernel_sigset_t;      /* at least 32 bits */
 
 #endif /* __s390x__ */
diff --git a/arch/sh/include/asm/posix_types_64.h b/arch/sh/include/asm/posix_types_64.h
index fcda07b..0224785 100644
--- a/arch/sh/include/asm/posix_types_64.h
+++ b/arch/sh/include/asm/posix_types_64.h
@@ -17,6 +17,8 @@ typedef int		__kernel_ssize_t;
 #define __kernel_ssize_t __kernel_ssize_t
 typedef int		__kernel_ptrdiff_t;
 #define __kernel_ptrdiff_t __kernel_ptrdiff_t
+typedef int		__kernel_intptr_t;
+typedef unsigned int	__kernel_uintptr_t;
 
 typedef unsigned short	__kernel_old_uid_t;
 #define __kernel_old_uid_t __kernel_old_uid_t
diff --git a/arch/sparc/include/asm/posix_types.h b/arch/sparc/include/asm/posix_types.h
index 3070f25..2f2c90d 100644
--- a/arch/sparc/include/asm/posix_types.h
+++ b/arch/sparc/include/asm/posix_types.h
@@ -26,6 +26,8 @@ typedef int		       __kernel_suseconds_t;
 typedef unsigned int           __kernel_size_t;
 typedef int                    __kernel_ssize_t;
 typedef long int               __kernel_ptrdiff_t;
+typedef int                    __kernel_intptr_t;
+typedef unsigned int           __kernel_uintptr_t;
 #define __kernel_size_t __kernel_size_t
 
 typedef unsigned short         __kernel_ipc_pid_t;
diff --git a/arch/xtensa/include/asm/posix_types.h b/arch/xtensa/include/asm/posix_types.h
index 6e96be0..d35f53e 100644
--- a/arch/xtensa/include/asm/posix_types.h
+++ b/arch/xtensa/include/asm/posix_types.h
@@ -25,6 +25,8 @@ typedef unsigned short	__kernel_ipc_pid_t;
 typedef unsigned int	__kernel_size_t;
 typedef int		__kernel_ssize_t;
 typedef long		__kernel_ptrdiff_t;
+typedef long		__kernel_intptr_t;
+typedef unsigned long	__kernel_uintptr_t;
 #define __kernel_size_t __kernel_size_t
 
 typedef unsigned short	__kernel_old_uid_t;
diff --git a/include/asm-generic/posix_types.h b/include/asm-generic/posix_types.h
index 91d44bd..c0b9107 100644
--- a/include/asm-generic/posix_types.h
+++ b/include/asm-generic/posix_types.h
@@ -71,10 +71,14 @@ typedef unsigned int	__kernel_old_dev_t;
 typedef unsigned int	__kernel_size_t;
 typedef int		__kernel_ssize_t;
 typedef int		__kernel_ptrdiff_t;
+typedef int		__kernel_intptr_t;
+typedef unsigned int	__kernel_uintptr_t;
 #else
 typedef __kernel_ulong_t __kernel_size_t;
 typedef __kernel_long_t	__kernel_ssize_t;
 typedef __kernel_long_t	__kernel_ptrdiff_t;
+typedef __kernel_long_t __kernel_intptr_t;
+typedef __kernel_ulong_t __kernel_uintptr_t;
 #endif
 #endif
 
diff --git a/include/linux/types.h b/include/linux/types.h
index e5fa503..03c355f 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -42,8 +42,6 @@ typedef __kernel_gid32_t	gid_t;
 typedef __kernel_uid16_t        uid16_t;
 typedef __kernel_gid16_t        gid16_t;
 
-typedef unsigned long		uintptr_t;
-
 #ifdef CONFIG_UID16
 /* This is defined by include/asm-{arch}/posix_types.h */
 typedef __kernel_old_uid_t	old_uid_t;
@@ -73,6 +71,9 @@ typedef __kernel_ssize_t	ssize_t;
 typedef __kernel_ptrdiff_t	ptrdiff_t;
 #endif
 
+typedef __kernel_intptr_t	intptr_t;
+typedef __kernel_uintptr_t	uintptr_t;
+
 #ifndef _TIME_T
 #define _TIME_T
 typedef __kernel_time_t		time_t;
-- 
1.7.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
