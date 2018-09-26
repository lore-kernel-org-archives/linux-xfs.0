Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39108 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbeI0B5X (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Sep 2018 21:57:23 -0400
Received: from smtp.corp.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 486EF30820DD
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 19:42:52 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 11B0486210
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 19:42:51 +0000 (UTC)
Subject: [PATCH 2/4] xfsprogs: remove bsd platform files
References: <395ba7bd-74b1-be1a-2eb6-32099b8eeb94@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <62618be2-169b-d674-3b18-0be9b9fb324a@redhat.com>
Date: Wed, 26 Sep 2018 14:42:51 -0500
MIME-Version: 1.0
In-Reply-To: <395ba7bd-74b1-be1a-2eb6-32099b8eeb94@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

As promised in April 2018 with:
a8502cc libxfs: warn about deprecation of irix, freebsd, darwin
remove the bsd platform files.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/include/Makefile b/include/Makefile
index e0ce938..3a76b4f 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -40,7 +40,7 @@ HFILES = handle.h \
 	xqm.h \
 	xfs_arch.h
 
-PHFILES = darwin.h freebsd.h linux.h gnukfreebsd.h
+PHFILES = darwin.h linux.h
 LSRCFILES = $(shell echo $(PHFILES) | sed -e "s/$(PKG_PLATFORM).h//g")
 LSRCFILES += platform_defs.h.in builddefs.in buildmacros buildrules install-sh
 LSRCFILES += $(DKHFILES) $(LIBHFILES)
diff --git a/include/builddefs.in b/include/builddefs.in
index f7d39a4..e3612cd 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -129,18 +129,10 @@ PCFLAGS += -DHAVE_UMODE_T
 endif
 DEPENDFLAGS = -D__linux__
 endif
-ifeq ($(PKG_PLATFORM),gnukfreebsd)
-PCFLAGS = -D_GNU_SOURCE $(GCCFLAGS)
-endif
 ifeq ($(PKG_PLATFORM),darwin)
 PCFLAGS = $(GCCFLAGS)
 DEPENDFLAGS = -D__APPLE__ -D_DARWIN_FEATURE_64_BIT_INODE
 endif
-ifeq ($(PKG_PLATFORM),freebsd)
-PLDLIBS = -L/usr/local/lib -lintl
-PCFLAGS = -I/usr/local/include $(GCCFLAGS)
-DEPENDFLAGS = -D__FreeBSD__
-endif
 ifeq ($(HAVE_FLS),yes)
 LCFLAGS+= -DHAVE_FLS
 endif
diff --git a/include/freebsd.h b/include/freebsd.h
deleted file mode 100644
index 9539e51..0000000
--- a/include/freebsd.h
+++ /dev/null
@@ -1,198 +0,0 @@
-// SPDX-License-Identifier: LGPL-2.1
-/*
- * Copyright (c) 2004-2006 Silicon Graphics, Inc.
- * All Rights Reserved.
- */
-#ifndef __XFS_FREEBSD_H__
-#define __XFS_FREEBSD_H__
-
-#include <sys/stat.h>
-#include <sys/param.h>
-#include <sys/ioccom.h>
-#include <sys/mount.h>
-#include <ctype.h>
-#include <libgen.h>
-#include <paths.h>
-#include <uuid.h>
-#include <mntent.h>
-
-#include <sys/endian.h>
-#define __BYTE_ORDER	BYTE_ORDER
-#define __BIG_ENDIAN	BIG_ENDIAN
-#define __LITTLE_ENDIAN	LITTLE_ENDIAN
-
-/* FreeBSD file API is 64-bit aware */
-#define fdatasync	fsync
-#define memalign(a,sz)	valloc(sz)
-
-#define EFSCORRUPTED	990	/* Filesystem is corrupted */
-#define EFSBADCRC	991	/* Bad CRC detected */
-
-typedef unsigned char		__u8;
-typedef signed char		__s8;
-typedef unsigned short		__u16;
-typedef signed short		__s16;
-typedef unsigned int		__u32;
-typedef signed int		__s32;
-typedef unsigned long long int	__u64;
-typedef signed long long int	__s64;
-
-typedef off_t		xfs_off_t;
-typedef uint64_t	xfs_ino_t;
-typedef uint32_t	xfs_dev_t;
-typedef int64_t		xfs_daddr_t;
-typedef __u32		xfs_nlink_t;
-
-#define	O_LARGEFILE	0
-
-#define HAVE_FID	1
-
-static __inline__ int xfsctl(const char *path, int fd, int cmd, void *p)
-{
-	return ioctl(fd, cmd, p);
-}
-
-static __inline__ int platform_test_xfs_fd(int fd)
-{
-	struct statfs buf;
-	if (fstatfs(fd, &buf) < 0)
-		return 0;
-	return strncmp(buf.f_fstypename, "xfs", 4) == 0;
-}
-
-static __inline__ int platform_test_xfs_path(const char *path)
-{
-	struct statfs buf;
-	if (statfs(path, &buf) < 0)
-		return 0;
-	return strncmp(buf.f_fstypename, "xfs", 4) == 0;
-}
-
-static __inline__ int platform_fstatfs(int fd, struct statfs *buf)
-{
-	return fstatfs(fd, buf);
-}
-
-static __inline__ void platform_getoptreset(void)
-{
-	extern int optind;
-	optind = 0;
-}
-
-static __inline__ int platform_uuid_compare(uuid_t *uu1, uuid_t *uu2)
-{
-	return uuid_compare(uu1, uu2, NULL);
-}
-
-static __inline__ void platform_uuid_unparse(uuid_t *uu, char *buffer)
-{
-	uint32_t status;
-	char *s;
-	uuid_to_string(uu, &s, &status);
-	if (status == uuid_s_ok)
-		strcpy(buffer, s);
-	else buffer[0] = '\0';
-	free(s);
-}
-
-static __inline__ int platform_uuid_parse(char *buffer, uuid_t *uu)
-{
-	uint32_t status;
-	uuid_from_string(buffer, uu, &status);
-	return (status == uuid_s_ok);
-}
-
-static __inline__ int platform_uuid_is_null(uuid_t *uu)
-{
-	return uuid_is_nil(uu, NULL);
-}
-
-static __inline__ void platform_uuid_generate(uuid_t *uu)
-{
-	uuid_create(uu, NULL);
-}
-
-static __inline__ void platform_uuid_clear(uuid_t *uu)
-{
-	uuid_create_nil(uu, NULL);
-}
-
-static __inline__ void platform_uuid_copy(uuid_t *dst, uuid_t *src)
-{
-	memcpy(dst, src, sizeof(uuid_t));
-}
-
-static __inline__ int
-platform_discard_blocks(int fd, uint64_t start, uint64_t len)
-{
-	return 0;
-}
-
-/**
- * Abstraction of mountpoints.
- */
-struct mntent_cursor {
-	FILE *mtabp;
-};
-
-static inline int platform_mntent_open(struct mntent_cursor * cursor, char *mtab)
-{
-	cursor->mtabp = setmntent(mtab, "r");
-	if (!cursor->mtabp) {
-		fprintf(stderr, "Error: cannot read %s\n", mtab);
-		return 1;
-	}
-	return 0;
-}
-
-static inline  struct mntent * platform_mntent_next(struct mntent_cursor * cursor)
-{
-	return getmntent(cursor->mtabp);
-}
-
-static inline void platform_mntent_close(struct mntent_cursor * cursor)
-{
-	endmntent(cursor->mtabp);
-}
-
-/* check whether we have to define FS_IOC_FS[GS]ETXATTR ourselves */
-#ifndef HAVE_FSXATTR
-struct fsxattr {
-	__u32		fsx_xflags;	/* xflags field value (get/set) */
-	__u32		fsx_extsize;	/* extsize field value (get/set)*/
-	__u32		fsx_nextents;	/* nextents field value (get)	*/
-	__u32		fsx_projid;	/* project identifier (get/set) */
-	__u32		fsx_cowextsize;	/* cow extsize field value (get/set) */
-	unsigned char	fsx_pad[8];
-};
-
-/*
- * Flags for the fsx_xflags field
- */
-#define FS_XFLAG_REALTIME	0x00000001	/* data in realtime volume */
-#define FS_XFLAG_PREALLOC	0x00000002	/* preallocated file extents */
-#define FS_XFLAG_IMMUTABLE	0x00000008	/* file cannot be modified */
-#define FS_XFLAG_APPEND		0x00000010	/* all writes append */
-#define FS_XFLAG_SYNC		0x00000020	/* all writes synchronous */
-#define FS_XFLAG_NOATIME	0x00000040	/* do not update access time */
-#define FS_XFLAG_NODUMP		0x00000080	/* do not include in backups */
-#define FS_XFLAG_RTINHERIT	0x00000100	/* create with rt bit set */
-#define FS_XFLAG_PROJINHERIT	0x00000200	/* create with parents projid */
-#define FS_XFLAG_NOSYMLINKS	0x00000400	/* disallow symlink creation */
-#define FS_XFLAG_EXTSIZE	0x00000800	/* extent size allocator hint */
-#define FS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
-#define FS_XFLAG_NODEFRAG	0x00002000	/* do not defragment */
-#define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
-#define FS_XFLAG_DAX		0x00008000	/* use DAX for IO */
-#define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
-
-#define FS_IOC_FSGETXATTR     _IOR ('X', 31, struct fsxattr)
-#define FS_IOC_FSSETXATTR     _IOW ('X', 32, struct fsxattr)
-
-#endif
-
-#ifndef FS_XFLAG_COWEXTSIZE
-#define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
-#endif
-
-#endif	/* __XFS_FREEBSD_H__ */
diff --git a/include/gnukfreebsd.h b/include/gnukfreebsd.h
deleted file mode 100644
index 49ff25f..0000000
--- a/include/gnukfreebsd.h
+++ /dev/null
@@ -1,144 +0,0 @@
-// SPDX-License-Identifier: LGPL-2.1
-/*
- * Copyright (c) 2004-2006 Silicon Graphics, Inc.
- * All Rights Reserved.
- */
-#ifndef __XFS_KFREEBSD_H__
-#define __XFS_KFREEBSD_H__
-
-#include <uuid/uuid.h>
-#include <sys/vfs.h>
-#include <sys/ioctl.h>
-#include <sys/sysmacros.h>
-#include <malloc.h>
-#include <getopt.h>
-#include <endian.h>
-#include <sys/stat.h>
-#include <sys/param.h>
-#include <sys/mount.h>
-#include <ctype.h>
-#include <libgen.h>
-#include <paths.h>
-#include <mntent.h>
-
-#define EFSCORRUPTED	990	/* Filesystem is corrupted */
-#define EFSBADCRC	991	/* Bad CRC detected */
-
-typedef unsigned char		__u8;
-typedef signed char		__s8;
-typedef unsigned short		__u16;
-typedef signed short		__s16;
-typedef unsigned int		__u32;
-typedef signed int		__s32;
-typedef unsigned long long int	__u64;
-typedef signed long long int	__s64;
-
-typedef off_t		xfs_off_t;
-typedef uint64_t	xfs_ino_t;
-typedef uint32_t	xfs_dev_t;
-typedef int64_t		xfs_daddr_t;
-typedef __u32		xfs_nlink_t;
-
-#define HAVE_FID	1
-
-static __inline__ int xfsctl(const char *path, int fd, int cmd, void *p)
-{
-	return ioctl(fd, cmd, p);
-}
-
-static __inline__ int platform_test_xfs_fd(int fd)
-{
-	struct statfs buf;
-	if (fstatfs(fd, &buf) < 0)
-		return 0;
-	return strncmp(buf.f_fstypename, "xfs", 4) == 0;
-}
-
-static __inline__ int platform_test_xfs_path(const char *path)
-{
-	struct statfs buf;
-	if (statfs(path, &buf) < 0)
-		return 0;
-	return strncmp(buf.f_fstypename, "xfs", 4) == 0;
-}
-
-static __inline__ int platform_fstatfs(int fd, struct statfs *buf)
-{
-	return fstatfs(fd, buf);
-}
-
-static __inline__ void platform_getoptreset(void)
-{
-	extern int optind;
-	optind = 0;
-}
-
-static __inline__ int platform_uuid_compare(uuid_t *uu1, uuid_t *uu2)
-{
-	return uuid_compare(*uu1, *uu2);
-}
-
-static __inline__ void platform_uuid_unparse(uuid_t *uu, char *buffer)
-{
-	uuid_unparse(*uu, buffer);
-}
-
-static __inline__ int platform_uuid_parse(char *buffer, uuid_t *uu)
-{
-	return uuid_parse(buffer, *uu);
-}
-
-static __inline__ int platform_uuid_is_null(uuid_t *uu)
-{
-	return uuid_is_null(*uu);
-}
-
-static __inline__ void platform_uuid_generate(uuid_t *uu)
-{
-	uuid_generate(*uu);
-}
-
-static __inline__ void platform_uuid_clear(uuid_t *uu)
-{
-	uuid_clear(*uu);
-}
-
-static __inline__ void platform_uuid_copy(uuid_t *dst, uuid_t *src)
-{
-	uuid_copy(*dst, *src);
-}
-
-static __inline__ int
-platform_discard_blocks(int fd, uint64_t start, uint64_t len)
-{
-	return 0;
-}
-
-/**
- * Abstraction of mountpoints.
- */
-struct mntent_cursor {
-	FILE *mtabp;
-};
-
-static inline int platform_mntent_open(struct mntent_cursor * cursor, char *mtab)
-{
-	cursor->mtabp = setmntent(mtab, "r");
-	if (!cursor->mtabp) {
-		fprintf(stderr, "Error: cannot read %s\n", mtab);
-		return 1;
-	}
-	return 0;
-}
-
-static inline struct mntent * platform_mntent_next(struct mntent_cursor * cursor)
-{
-	return getmntent(cursor->mtabp);
-}
-
-static inline void platform_mntent_close(struct mntent_cursor * cursor)
-{
-	endmntent(cursor->mtabp);
-}
-
-#endif	/* __XFS_KFREEBSD_H__ */
diff --git a/include/xfs.h b/include/xfs.h
index 4368a19..d265800 100644
--- a/include/xfs.h
+++ b/include/xfs.h
@@ -7,10 +7,6 @@
 
 #if defined(__linux__)
 #include <xfs/linux.h>
-#elif defined(__FreeBSD__)
-#include <xfs/freebsd.h>
-#elif defined(__FreeBSD_kernel__)
-#include <xfs/gnukfreebsd.h>
 #elif defined(__APPLE__)
 #include <xfs/darwin.h>
 #else
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 02a9cbc..5379871 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -31,7 +31,7 @@ crc32table.h
 LSRCFILES += gen_crc32table.c
 
 CFILES += $(PKG_PLATFORM).c
-PCFILES = darwin.c freebsd.c linux.c
+PCFILES = darwin.c linux.c
 LSRCFILES = $(shell echo $(PCFILES) | sed -e "s/$(PKG_PLATFORM).c//g")
 
 ifeq ($(HAVE_GETMNTENT),yes)
diff --git a/libfrog/freebsd.c b/libfrog/freebsd.c
deleted file mode 100644
index 9a8b8d2..0000000
--- a/libfrog/freebsd.c
+++ /dev/null
@@ -1,193 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2003,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- */
-
-#include "libxfs.h"
-#include <sys/stat.h>
-#include <sys/disk.h>
-#include <sys/mount.h>
-#include <sys/ioctl.h>
-#include <sys/sysctl.h>
-
-int platform_has_uuid = 1;
-extern char *progname;
-
-#warning "FreeBSD support is deprecated and planned for removal in July 2018"
-#warning "Contact linux-xfs@vger.kernel.org if you'd like to maintain this port"
-#error   "Remove this line if you'd like to continue the build"
-
-int
-platform_check_ismounted(char *name, char *block, struct stat *s, int verbose)
-{
-	struct stat	st;
-        int cnt, i;
-        struct statfs *fsinfo;
-
-	if (!s) {
-		if (stat(block, &st) < 0)
-			return 0;
-		s = &st;
-	}
-
-	/* Remember, FreeBSD can now mount char devices! -- adrian */
-	if (((st.st_mode & S_IFMT) != S_IFBLK) &&
-	    ((st.st_mode & S_IFMT) != S_IFCHR))
-		return 0;
-
-	if ((cnt = getmntinfo(&fsinfo, MNT_NOWAIT)) == 0) {
-		fprintf(stderr,
-		    _("%s: %s possibly contains a mounted filesystem\n"),
-		    progname, name);
-		return 1;
-	}
-
-        for (i = 0; i < cnt; i++) {
-                if (strcmp (name, fsinfo[i].f_mntfromname) != 0)
-			continue;
-
-		if (verbose)
-			fprintf(stderr,
-			    _("%s: %s contains a mounted filesystem\n"),
-			    progname, name);
-		break;
-	}
-
-        return i < cnt;
-}
-
-int
-platform_check_iswritable(char *name, char *block, struct stat *s)
-{
-        int cnt, i;
-        struct statfs *fsinfo;
-
-        if ((cnt = getmntinfo(&fsinfo, MNT_NOWAIT)) == 0) {
-		fprintf(stderr, _("%s: %s contains a possibly writable, "
-				"mounted filesystem\n"), progname, name);
-			return 1;
-	}
-
-        for (i = 0; i < cnt; i++) {
-                if (strcmp (name, fsinfo[i].f_mntfromname) != 0)
-			continue;
-
-		if (fsinfo[i].f_flags &= MNT_RDONLY)
-			break;
-	}
-
-        if (i == cnt) {
-		fprintf(stderr, _("%s: %s contains a mounted and writable "
-				"filesystem\n"), progname, name);
-		return 1;
-	}
-	return 0;
-}
-
-int
-platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fatal)
-{
-	return fatal;
-}
-
-void
-platform_flush_device(int fd, dev_t device)
-{
-	return;
-}
-
-void
-platform_findsizes(char *path, int fd, long long *sz, int *bsz)
-{
-	struct stat	st;
-	int64_t		size;
-	uint		ssize;
-
-	if (fstat(fd, &st) < 0) {
-		fprintf(stderr, _("%s: "
-			"cannot stat the device file \"%s\": %s\n"),
-			progname, path, strerror(errno));
-		exit(1);
-	}
-
-	if ((st.st_mode & S_IFMT) == S_IFREG) {
-		*sz = (long long)(st.st_size >> 9);
-		*bsz = 512;
-		return;
-	}
-
-	if ((st.st_mode & S_IFMT) != S_IFCHR) {
-		fprintf(stderr, _("%s: Not a device or file: \"%s\"\n"),
-			progname, path);
-		exit(1);
-	}
-
-	if (ioctl(fd, DIOCGMEDIASIZE, &size) != 0) {
-		fprintf(stderr, _("%s: DIOCGMEDIASIZE failed on \"%s\": %s\n"),
-			progname, path, strerror(errno));
-		exit(1);
-	}
-
-	if (ioctl(fd, DIOCGSECTORSIZE, &ssize) != 0) {
-		fprintf(stderr, _("%s: "
-			"DIOCGSECTORSIZE failed on \"%s\": %s\n"),
-			progname, path, strerror(errno));
-		exit(1);
-	}
-
-	*sz = (long long) (size / ssize);
-	*bsz = (int)ssize;
-}
-
-char *
-platform_findrawpath(char *path)
-{
-	return path;
-}
-
-char *
-platform_findblockpath(char *path)
-{
-	return path;
-}
-
-int
-platform_direct_blockdev(void)
-{
-	return 0;
-}
-
-int
-platform_align_blockdev(void)
-{
-	return sizeof(void *);
-}
-
-int
-platform_nproc(void)
-{
-	int		ncpu;
-	size_t		len = sizeof(ncpu);
-	static int	mib[2] = {CTL_HW, HW_NCPU};
-
-	if (sysctl(mib, 2, &ncpu, &len, NULL, 0) < 0)
-		ncpu = 1;
-
-	return ncpu;
-}
-
-unsigned long
-platform_physmem(void)
-{
-	unsigned long	physmem;
-	size_t		len = sizeof(physmem);
-	static int	mib[2] = {CTL_HW, HW_PHYSMEM};
-
-	if (sysctl(mib, 2, &physmem, &len, NULL, 0) < 0) {
-		fprintf(stderr, _("%s: can't determine memory size\n"),
-			progname);
-		exit(1);
-	}
-	return physmem >> 10;
-}
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 0c146f9..847d429 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -79,7 +79,7 @@ AC_DEFUN([AC_HAVE_GETMNTENT],
   ])
 
 #
-# Check if we have a getmntinfo libc call (FreeBSD, Mac OS X)
+# Check if we have a getmntinfo libc call (Mac OS X)
 #
 AC_DEFUN([AC_HAVE_GETMNTINFO],
   [ AC_MSG_CHECKING([for getmntinfo ])
diff --git a/quota/Makefile b/quota/Makefile
index 45d327a..41ed234 100644
--- a/quota/Makefile
+++ b/quota/Makefile
@@ -11,7 +11,7 @@ CFILES = init.c util.c \
 	edit.c free.c path.c project.c quot.c quota.c report.c state.c
 
 CFILES += $(PKG_PLATFORM).c
-PCFILES = darwin.c freebsd.c linux.c
+PCFILES = darwin.c linux.c
 LSRCFILES = $(shell echo $(PCFILES) | sed -e "s/$(PKG_PLATFORM).c//g")
 
 LLDLIBS = $(LIBXCMD) $(LIBFROG)
diff --git a/quota/freebsd.c b/quota/freebsd.c
deleted file mode 100644
index 52e0120..0000000
--- a/quota/freebsd.c
+++ /dev/null
@@ -1,19 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- */
-
-#include "quota.h"
-
-int
-xfsquotactl(
-	int		command,
-	const char	*device,
-	uint		type,
-	uint		id,
-	void		*addr)
-{
-	errno = -ENOSYS;
-	return -1;
-}
