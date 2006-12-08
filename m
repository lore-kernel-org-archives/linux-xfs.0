Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Dec 2006 19:29:26 -0800 (PST)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB83THaG012604
	for <xfs@oss.sgi.com>; Thu, 7 Dec 2006 19:29:18 -0800
Subject: [PATCH] update attr package
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
Content-Type: multipart/mixed; boundary="=-gEoE8o8ACRhJs/HoFpFX"
Date: Fri, 08 Dec 2006 14:28:19 +1100
Message-Id: <1165548500.30459.75.camel@edge>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: agruen@suse.de

--=-gEoE8o8ACRhJs/HoFpFX
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Remove system call stubs from libattr, we always defer to
the libc interfaces in this day and age.  Removes a SIGILL
delivery from the ARM EABI, reported by Lennert Buytenhek.
Also updates Debian packaging.

-- 
Nathan

--=-gEoE8o8ACRhJs/HoFpFX
Content-Disposition: attachment; filename=remove-syscalls
Content-Type: text/x-patch; name=remove-syscalls; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: attr/libattr/Makefile
===================================================================
--- attr.orig/libattr/Makefile	2006-12-08 13:50:25.299558000 +1100
+++ attr/libattr/Makefile	2006-12-08 13:50:38.096357750 +1100
@@ -15,12 +15,6 @@ LT_AGE = 1
 CFILES = libattr.c attr_copy_fd.c attr_copy_file.c attr_copy_check.c
 HFILES = libattr.h
 
-ifeq ($(PKG_PLATFORM),linux)
-CFILES += syscalls.c
-else
-LSRCFILES = syscalls.c
-endif
-
 LCFLAGS = -include libattr.h
 
 default: $(LTLIBRARY)
Index: attr/libattr/syscalls.c
===================================================================
--- attr.orig/libattr/syscalls.c	2006-12-08 13:50:45.660830500 +1100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,259 +0,0 @@
-/*
- * Copyright (c) 2001-2002 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-/*
- * The use of the syscall() function is an additional level of
- * indirection.  This avoids the dependency on kernel sources.
- */
-
-#include <errno.h>
-#include <unistd.h>
-
-#if defined (__i386__)
-# define HAVE_XATTR_SYSCALLS 1
-# define __NR_setxattr		226
-# define __NR_lsetxattr		227
-# define __NR_fsetxattr		228
-# define __NR_getxattr		229
-# define __NR_lgetxattr		230
-# define __NR_fgetxattr		231
-# define __NR_listxattr		232
-# define __NR_llistxattr	233
-# define __NR_flistxattr	234
-# define __NR_removexattr	235
-# define __NR_lremovexattr	236
-# define __NR_fremovexattr	237
-#elif defined (__sparc__)
-# define HAVE_XATTR_SYSCALLS 1
-# define __NR_setxattr		169
-# define __NR_lsetxattr		170
-# define __NR_fsetxattr		171
-# define __NR_getxattr		172
-# define __NR_lgetxattr		173
-# define __NR_fgetxattr		177
-# define __NR_listxattr		178
-# define __NR_llistxattr	179
-# define __NR_flistxattr	180
-# define __NR_removexattr	181
-# define __NR_lremovexattr	182
-# define __NR_fremovexattr	186
-#elif defined (__ia64__)
-# define HAVE_XATTR_SYSCALLS 1
-# define __NR_setxattr		1217
-# define __NR_lsetxattr		1218
-# define __NR_fsetxattr		1219
-# define __NR_getxattr		1220
-# define __NR_lgetxattr		1221
-# define __NR_fgetxattr		1222
-# define __NR_listxattr		1223
-# define __NR_llistxattr	1224
-# define __NR_flistxattr	1225
-# define __NR_removexattr	1226
-# define __NR_lremovexattr	1227
-# define __NR_fremovexattr	1228
-#elif defined (__powerpc__)
-# define HAVE_XATTR_SYSCALLS 1
-# define __NR_setxattr		209
-# define __NR_lsetxattr		210
-# define __NR_fsetxattr		211
-# define __NR_getxattr		212
-# define __NR_lgetxattr		213
-# define __NR_fgetxattr		214
-# define __NR_listxattr		215
-# define __NR_llistxattr	216
-# define __NR_flistxattr	217
-# define __NR_removexattr	218
-# define __NR_lremovexattr	219
-# define __NR_fremovexattr	220
-#elif defined (__x86_64__)
-# define HAVE_XATTR_SYSCALLS 1
-# define __NR_setxattr		188
-# define __NR_lsetxattr		189
-# define __NR_fsetxattr		190
-# define __NR_getxattr		191
-# define __NR_lgetxattr		192
-# define __NR_fgetxattr		193
-# define __NR_listxattr		194
-# define __NR_llistxattr	195
-# define __NR_flistxattr	196
-# define __NR_removexattr	197
-# define __NR_lremovexattr	198
-# define __NR_fremovexattr	199
-#elif defined (__s390__)
-# define HAVE_XATTR_SYSCALLS 1
-# define __NR_setxattr		224
-# define __NR_lsetxattr		225
-# define __NR_fsetxattr		226
-# define __NR_getxattr		227
-# define __NR_lgetxattr		228
-# define __NR_fgetxattr		229
-# define __NR_listxattr		230
-# define __NR_llistxattr	231
-# define __NR_flistxattr	232
-# define __NR_removexattr	233
-# define __NR_lremovexattr	234
-# define __NR_fremovexattr	235
-#elif defined (__arm__)
-# define HAVE_XATTR_SYSCALLS 1
-# define __NR_SYSCALL_BASE 0x900000
-# define __NR_setxattr		(__NR_SYSCALL_BASE+226)
-# define __NR_lsetxattr		(__NR_SYSCALL_BASE+227)
-# define __NR_fsetxattr		(__NR_SYSCALL_BASE+228)
-# define __NR_getxattr		(__NR_SYSCALL_BASE+229)
-# define __NR_lgetxattr		(__NR_SYSCALL_BASE+230)
-# define __NR_fgetxattr		(__NR_SYSCALL_BASE+231)
-# define __NR_listxattr		(__NR_SYSCALL_BASE+232)
-# define __NR_llistxattr	(__NR_SYSCALL_BASE+233)
-# define __NR_flistxattr	(__NR_SYSCALL_BASE+234)
-# define __NR_removexattr	(__NR_SYSCALL_BASE+235)
-# define __NR_lremovexattr	(__NR_SYSCALL_BASE+236)
-# define __NR_fremovexattr	(__NR_SYSCALL_BASE+237)
-#elif defined (__mips64__)
-# define HAVE_XATTR_SYSCALLS 1
-# define __NR_Linux 5000
-# define __NR_setxattr		(__NR_Linux + 217)
-# define __NR_lsetxattr		(__NR_Linux + 218)
-# define __NR_fsetxattr		(__NR_Linux + 219)
-# define __NR_getxattr		(__NR_Linux + 220)
-# define __NR_lgetxattr		(__NR_Linux + 221)
-# define __NR_fgetxattr		(__NR_Linux + 222)
-# define __NR_listxattr		(__NR_Linux + 223)
-# define __NR_llistxattr	(__NR_Linux + 224)
-# define __NR_flistxattr	(__NR_Linux + 225)
-# define __NR_removexattr	(__NR_Linux + 226)
-# define __NR_lremovexattr	(__NR_Linux + 227)
-# define __NR_fremovexattr	(__NR_Linux + 228)
-#elif defined (__mips__)
-# define HAVE_XATTR_SYSCALLS 1
-# define __NR_Linux 4000
-# define __NR_setxattr		(__NR_Linux + 224)
-# define __NR_lsetxattr		(__NR_Linux + 225)
-# define __NR_fsetxattr		(__NR_Linux + 226)
-# define __NR_getxattr		(__NR_Linux + 227)
-# define __NR_lgetxattr		(__NR_Linux + 228)
-# define __NR_fgetxattr		(__NR_Linux + 229)
-# define __NR_listxattr		(__NR_Linux + 230)
-# define __NR_llistxattr	(__NR_Linux + 231)
-# define __NR_flistxattr	(__NR_Linux + 232)
-# define __NR_removexattr	(__NR_Linux + 233)
-# define __NR_lremovexattr	(__NR_Linux + 234)
-# define __NR_fremovexattr	(__NR_Linux + 235)
-#elif defined (__alpha__)
-# define HAVE_XATTR_SYSCALLS 1
-# define __NR_setxattr		382
-# define __NR_lsetxattr		383
-# define __NR_fsetxattr		384
-# define __NR_getxattr		385
-# define __NR_lgetxattr		386
-# define __NR_fgetxattr		387
-# define __NR_listxattr		388
-# define __NR_llistxattr	389
-# define __NR_flistxattr	390
-# define __NR_removexattr	391
-# define __NR_lremovexattr	392
-# define __NR_fremovexattr	393
-#elif defined (__mc68000__)
-# define HAVE_XATTR_SYSCALLS 1
-# define __NR_setxattr		223
-# define __NR_lsetxattr		224
-# define __NR_fsetxattr		225
-# define __NR_getxattr		226
-# define __NR_lgetxattr		227
-# define __NR_fgetxattr		228
-# define __NR_listxattr		229
-# define __NR_llistxattr	230
-# define __NR_flistxattr	231
-# define __NR_removexattr	232
-# define __NR_lremovexattr	233
-# define __NR_fremovexattr	234
-#else
-# warning "Extended attribute syscalls undefined for this architecture"
-# define HAVE_XATTR_SYSCALLS 0
-#endif
-
-#if HAVE_XATTR_SYSCALLS
-# define SYSCALL(args...)	syscall(args)
-#else
-# define SYSCALL(args...)	( errno = ENOSYS, -1 )
-#endif
-
-int setxattr (const char *path, const char *name,
-			void *value, size_t size, int flags)
-{
-	return SYSCALL(__NR_setxattr, path, name, value, size, flags);
-}
-
-int lsetxattr (const char *path, const char *name,
-			void *value, size_t size, int flags)
-{
-	return SYSCALL(__NR_lsetxattr, path, name, value, size, flags);
-}
-
-int fsetxattr (int filedes, const char *name,
-			void *value, size_t size, int flags)
-{
-	return SYSCALL(__NR_fsetxattr, filedes, name, value, size, flags);
-}
-
-ssize_t getxattr (const char *path, const char *name,
-				void *value, size_t size)
-{
-	return SYSCALL(__NR_getxattr, path, name, value, size);
-}
-
-ssize_t lgetxattr (const char *path, const char *name,
-				void *value, size_t size)
-{
-	return SYSCALL(__NR_lgetxattr, path, name, value, size);
-}
-
-ssize_t fgetxattr (int filedes, const char *name,
-				void *value, size_t size)
-{
-	return SYSCALL(__NR_fgetxattr, filedes, name, value, size);
-}
-
-ssize_t listxattr (const char *path, char *list, size_t size)
-{
-	return SYSCALL(__NR_listxattr, path, list, size);
-}
-
-ssize_t llistxattr (const char *path, char *list, size_t size)
-{
-	return SYSCALL(__NR_llistxattr, path, list, size);
-}
-
-ssize_t flistxattr (int filedes, char *list, size_t size)
-{
-	return SYSCALL(__NR_flistxattr, filedes, list, size);
-}
-
-int removexattr (const char *path, const char *name)
-{
-	return SYSCALL(__NR_removexattr, path, name);
-}
-
-int lremovexattr (const char *path, const char *name)
-{
-	return SYSCALL(__NR_lremovexattr, path, name);
-}
-
-int fremovexattr (int filedes, const char *name)
-{
-	return SYSCALL(__NR_fremovexattr, filedes, name);
-}
Index: attr/VERSION
===================================================================
--- attr.orig/VERSION	2006-12-08 14:09:37.019536000 +1100
+++ attr/VERSION	2006-12-08 14:09:43.027911500 +1100
@@ -3,5 +3,5 @@
 #
 PKG_MAJOR=2
 PKG_MINOR=4
-PKG_REVISION=34
+PKG_REVISION=35
 PKG_BUILD=0
Index: attr/debian/changelog
===================================================================
--- attr.orig/debian/changelog	2006-12-08 14:09:37.095540750 +1100
+++ attr/debian/changelog	2006-12-08 14:12:56.956031250 +1100
@@ -1,3 +1,9 @@
+attr (2.4.35-1) unstable; urgency=low
+
+  * New upstream release
+
+ -- Nathan Scott <nathans@debian.org>  Fri, 08 Dec 2006 14:12:25 +1100
+
 attr (2.4.33-1) unstable; urgency=low
 
   * New upstream release
Index: attr/doc/CHANGES
===================================================================
--- attr.orig/doc/CHANGES	2006-12-08 14:09:37.039537250 +1100
+++ attr/doc/CHANGES	2006-12-08 14:25:50.284361250 +1100
@@ -1,3 +1,8 @@
+attr-2.4.35 (8 December 2006)
+	- Remove system call stubs from libattr, we always defer to
+	  the libc interfaces in this day and age.  Removes a SIGILL
+	  delivery from the ARM EABI, reported by Lennert Buytenhek.
+
 attr-2.4.34 (14 July 2006)
 	- Fix issues with makedepend on libtool libraries.
 

--=-gEoE8o8ACRhJs/HoFpFX--
