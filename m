Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47506 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbeI0CAG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Sep 2018 22:00:06 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EF3FDC049D65
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 19:45:33 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B3D9D6A6B2
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 19:45:33 +0000 (UTC)
Subject: [PATCH 3/4] xfsprogs: remove darwin platform files
References: <395ba7bd-74b1-be1a-2eb6-32099b8eeb94@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <34492e0f-c274-77b3-49b0-52effd0e4ca3@redhat.com>
Date: Wed, 26 Sep 2018 14:45:32 -0500
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
remove the darwin platform files.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/Makefile b/Makefile
index 6774825..4f6435c 100644
--- a/Makefile
+++ b/Makefile
@@ -48,13 +48,9 @@ HDR_SUBDIRS = include libxfs
 LIBFROG_SUBDIR = libfrog
 DLIB_SUBDIRS = libxlog libxcmd libhandle
 LIB_SUBDIRS = libxfs $(DLIB_SUBDIRS)
-TOOL_SUBDIRS = copy db estimate fsck growfs io logprint mkfs quota \
+TOOL_SUBDIRS = copy db estimate fsck fsr growfs io logprint mkfs quota \
 		mdrestore repair rtcp m4 man doc debian spaceman scrub
 
-ifneq ("$(PKG_PLATFORM)","darwin")
-TOOL_SUBDIRS += fsr
-endif
-
 ifneq ("$(XGETTEXT)","")
 TOOL_SUBDIRS += po
 endif
diff --git a/configure.ac b/configure.ac
index 5fdf78e..6b3eb05 100644
--- a/configure.ac
+++ b/configure.ac
@@ -157,7 +157,6 @@ AC_HAVE_MADVISE
 AC_HAVE_MINCORE
 AC_HAVE_SENDFILE
 AC_HAVE_GETMNTENT
-AC_HAVE_GETMNTINFO
 AC_HAVE_FALLOCATE
 AC_HAVE_FIEMAP
 AC_HAVE_PWRITEV2
diff --git a/doc/INSTALL b/doc/INSTALL
index f667628..d4395ee 100644
--- a/doc/INSTALL
+++ b/doc/INSTALL
@@ -46,57 +46,3 @@ Linux Instructions
 	DEBUG=-DNDEBUG
 
    before running make or Makepkgs.
-
-
-Mac OS X Instructions
-=====================
-
-0. Note:  since there is no XFS implementation on Mac OS X, you are
-   severely limited in what you can do.  mkfs.xfs(8), xfs_db(8) and
-   xfs_repair(8) are the only functional tools on this platform, as
-   they do not interact with the XFS kernel code at all.  Still, it
-   can be useful to have access to these utilities from Mac OS X in
-   a dual boot configuration, for example.
-
-   However, keep on mind that mkfs.xfs on Mac OS X has disabled
-   device access, although you can create a filesystem in a file.
-   Also note that existing filesystem detection is disabled.
-
-1. Configure, build and install the package
-
-   The xfsprogs package uses autoconf/configure and expects a GNU build
-   environment (your platform must at least have both autoconf, make,
-   and glibtool). 
-
-   You will also need to have built and installed the UUID library which
-   is provided by the e2fsprogs source package. (Or use Homebrew, Macports
-   or any other 3rd party package manager.)
-
-   Building libuuid:
-
-	[download; unzip/untar e2fsprogs; cd e2fsprogs]
-	$ ./configure --prefix=/usr --mandir=/usr/share/man
-	$ make lib/ext2fs/ext2_types.h
-	$ cd lib/uuid
-	$ make
-	$ su root
-	# make install
-	[verify that you now have a /usr/lib/libuuid.a]
-
-   Building xfsprogs:
-
-	[firstly set these environment variables to these values]
-	TAR=/usr/bin/gnutar
-	LIBTOOL=/usr/bin/glibtool
-	INSTALL_GROUP=wheel
-	LOCAL_CONFIGURE_OPTIONS="\
-				 --enable-gettext=no\
-				 --enable-blkid=no\
-				 --enable-librt=no\
-				 "
-
-	$ make
-	$ su root
-	# make install
-	[and optionally, for the development libraries and headers]
-	# make install-dev
diff --git a/fsr/Makefile b/fsr/Makefile
index 1da44d3..86486fc 100644
--- a/fsr/Makefile
+++ b/fsr/Makefile
@@ -15,10 +15,6 @@ ifeq ($(HAVE_GETMNTENT),yes)
 LCFLAGS += -DHAVE_GETMNTENT
 endif
 
-ifeq ($(HAVE_GETMNTINFO),yes)
-LCFLAGS += -DHAVE_GETMNTINFO
-endif
-
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/include/Makefile b/include/Makefile
index 3a76b4f..e6aa9b2 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -40,7 +40,7 @@ HFILES = handle.h \
 	xqm.h \
 	xfs_arch.h
 
-PHFILES = darwin.h linux.h
+PHFILES = linux.h
 LSRCFILES = $(shell echo $(PHFILES) | sed -e "s/$(PKG_PLATFORM).h//g")
 LSRCFILES += platform_defs.h.in builddefs.in buildmacros buildrules install-sh
 LSRCFILES += $(DKHFILES) $(LIBHFILES)
diff --git a/include/builddefs.in b/include/builddefs.in
index e3612cd..261ae5e 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -89,7 +89,6 @@ HAVE_MADVISE = @have_madvise@
 HAVE_MINCORE = @have_mincore@
 HAVE_SENDFILE = @have_sendfile@
 HAVE_GETMNTENT = @have_getmntent@
-HAVE_GETMNTINFO = @have_getmntinfo@
 HAVE_FALLOCATE = @have_fallocate@
 HAVE_FIEMAP = @have_fiemap@
 HAVE_PREADV = @have_preadv@
@@ -129,10 +128,6 @@ PCFLAGS += -DHAVE_UMODE_T
 endif
 DEPENDFLAGS = -D__linux__
 endif
-ifeq ($(PKG_PLATFORM),darwin)
-PCFLAGS = $(GCCFLAGS)
-DEPENDFLAGS = -D__APPLE__ -D_DARWIN_FEATURE_64_BIT_INODE
-endif
 ifeq ($(HAVE_FLS),yes)
 LCFLAGS+= -DHAVE_FLS
 endif
diff --git a/include/darwin.h b/include/darwin.h
deleted file mode 100644
index 1a85e05..0000000
--- a/include/darwin.h
+++ /dev/null
@@ -1,303 +0,0 @@
-// SPDX-License-Identifier: LGPL-2.1
-/*
- * Copyright (c) 2004-2006 Silicon Graphics, Inc.
- * All Rights Reserved.
- */
-#ifndef __XFS_DARWIN_H__
-#define __XFS_DARWIN_H__
-
-#include <unistd.h>
-#include <sys/types.h>
-#include <string.h>
-#include <uuid/uuid.h>
-#include <libgen.h>
-#include <sys/vm.h>
-#include <sys/stat.h>
-#include <sys/ioctl.h>
-#include <sys/mount.h>
-#include <sys/types.h>
-#include <sys/time.h>
-#include <ftw.h>
-#include <mach/mach_time.h>
-#include <inttypes.h>
-#include <stdio.h>
-#include <sys/mman.h>
-
-#include <machine/endian.h>
-#define __BYTE_ORDER	BYTE_ORDER
-#define __BIG_ENDIAN	BIG_ENDIAN
-#define __LITTLE_ENDIAN	LITTLE_ENDIAN
-
-#include <sys/syscall.h>
-# ifndef SYS_fsctl
-#  define SYS_fsctl	242
-# endif
-
-#ifndef XATTR_LIST_MAX
-#define XATTR_LIST_MAX  65536
-#endif
-
-static __inline__ int xfsctl(const char *path, int fd, int cmd, void *p)
-{
-	return syscall(SYS_fsctl, path, cmd, p, 0);
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
-	extern int optreset;
-	optreset = 0;
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
-typedef unsigned char		__u8;
-typedef signed char		__s8;
-typedef unsigned short		__u16;
-typedef signed short		__s16;
-typedef unsigned int		__u32;
-typedef signed int		__s32;
-typedef unsigned long long int	__u64;
-typedef signed long long int	__s64;
-
-#define int8_t		int8_t
-#define int16_t		int16_t
-#define int32_t		int32_t
-#define int32_t		int32_t
-#define int64_t		int64_t
-
-typedef off_t		xfs_off_t;
-typedef uint64_t	xfs_ino_t;
-typedef uint32_t	xfs_dev_t;
-typedef int64_t		xfs_daddr_t;
-typedef __u32		xfs_nlink_t;
-
-#define fdatasync	fsync
-#define memalign(a,sz)	valloc(sz)
-
-#define O_LARGEFILE     0
-#ifndef O_DIRECT
-#define O_DIRECT        0
-#endif
-#ifndef O_SYNC
-#define O_SYNC          0
-#endif
-
-#define EFSCORRUPTED	990	/* Filesystem is corrupted */
-#define EFSBADCRC	991	/* Bad CRC detected */
-
-#define HAVE_FID	1
-
-static __inline__ int
-platform_discard_blocks(int fd, uint64_t start, uint64_t len)
-{
-	return 0;
-}
-
-/*
- * POSIX timer replacement.
- * It really just do the minimum we need for xfs_repair.
- * Also, as setitimer can't create multiple timers,
- * the timerid things are useless - we have only one ITIMER_REAL
- * timer.
- */
-#define CLOCK_REALTIME ITIMER_REAL
-#define itimerspec itimerval
-typedef uint64_t timer_t;
-typedef double   timer_c;
-typedef clock_id_t clockid_t;
-
-
-static inline int timer_create (clockid_t __clock_id,
-                         struct sigevent *__restrict __evp,
-                         timer_t *__restrict timer)
-{
-	// set something, to initialize the variable, just in case
-	*timer = 0;
-	return 0;
-}
-
-static inline int timer_settime (timer_t timerid, int flags,
-                          const struct itimerspec *__restrict timerspec,
-                          struct itimerspec *__restrict ovalue)
-{
-	return setitimer(ITIMER_REAL, timerspec, ovalue);
-}
-
-static inline int timer_delete (timer_t timerid)
-{
-	struct itimerspec timespec;
-
-	timespec.it_interval.tv_sec=0;
-	timespec.it_interval.tv_usec=0;
-	timespec.it_value.tv_sec=0;
-	timespec.it_value.tv_usec=0;
-
-	return setitimer(ITIMER_REAL, &timespec, NULL);
-}
-
-static inline int timer_gettime (timer_t timerid, struct itimerspec *value)
-{
-	return getitimer(ITIMER_REAL, value);
-}
-
-/* FSR */
-
-#  include <sys/mount.h>
-#  include <sys/param.h>
-#include <sys/ucred.h>
-#include <errno.h>
-#define		_PATH_MOUNTED   "/etc/mtab"
-
-struct mntent
-{
-	char *mnt_fsname;
-	char *mnt_dir;
-	char *mnt_type;
-	char *mnt_opts;
-	int mnt_freq;
-	int mnt_passno;
-};
-
-static inline void mntinfo2mntent (struct statfs * stats, struct mntent * mnt) {
-	mnt->mnt_fsname = stats->f_mntfromname;
-	mnt->mnt_dir = stats->f_mntonname;
-	mnt->mnt_type = stats->f_fstypename;
-}
-
-
-
-/**
- * Abstraction of mountpoints.
- */
-struct mntent_cursor {
-	FILE *mtabp;
-	struct statfs *stats;
-	int count;
-	int i;
-};
-
-/**
- * OS X uses getmntinfo, which doesn't use a mtab file. So we just ignore it.
- */
-static inline int platform_mntent_open(struct mntent_cursor * cursor, char *mtab)
-{
-	if ((cursor->count = getmntinfo(&cursor->stats, 0)) < 0) {
-		fprintf(stderr, "Error: getmntinfo() failed: %s\n", strerror(errno));
-		return 1;
-	}
-	cursor->i = 0;
-	return 0;
-}
-
-static inline struct mntent * platform_mntent_next(struct mntent_cursor * cursor)
-{
-	struct mntent * t = NULL;
-	if (cursor->i >= cursor->count){
-		return NULL;
-	}
-	mntinfo2mntent(&cursor->stats[cursor->i], t);
-	cursor->i++;
-	return t;
-}
-
-static inline void platform_mntent_close(struct mntent_cursor * cursor)
-{
-	cursor->count = 0;
-	cursor->i = 0;
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
-#endif	/* __XFS_DARWIN_H__ */
diff --git a/include/xfs.h b/include/xfs.h
index d265800..f2f675d 100644
--- a/include/xfs.h
+++ b/include/xfs.h
@@ -7,8 +7,6 @@
 
 #if defined(__linux__)
 #include <xfs/linux.h>
-#elif defined(__APPLE__)
-#include <xfs/darwin.h>
 #else
 # error unknown platform... have fun porting!
 #endif
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 5379871..8e4daed 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -31,17 +31,13 @@ crc32table.h
 LSRCFILES += gen_crc32table.c
 
 CFILES += $(PKG_PLATFORM).c
-PCFILES = darwin.c linux.c
+PCFILES = linux.c
 LSRCFILES = $(shell echo $(PCFILES) | sed -e "s/$(PKG_PLATFORM).c//g")
 
 ifeq ($(HAVE_GETMNTENT),yes)
 LCFLAGS += -DHAVE_GETMNTENT
 endif
 
-ifeq ($(HAVE_GETMNTINFO),yes)
-LCFLAGS += -DHAVE_GETMNTINFO
-endif
-
 LDIRT = gen_crc32table crc32table.h crc32selftest
 
 default: crc32selftest ltdepend $(LTLIBRARY)
diff --git a/libfrog/darwin.c b/libfrog/darwin.c
deleted file mode 100644
index 504adc7..0000000
--- a/libfrog/darwin.c
+++ /dev/null
@@ -1,136 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2003,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- */
-
-#include <sys/disk.h>
-#include <sys/stat.h>
-#include <sys/mount.h>
-#include <sys/ioctl.h>
-#include <sys/sysctl.h>
-#include "libxfs.h"
-
-int platform_has_uuid = 1;
-extern char *progname;
-
-#warning "Darwin support is deprecated and planned for removal in July 2018"
-#warning "Contact linux-xfs@vger.kernel.org if you'd like to maintain this port"
-#error   "Remove this line if you'd like to continue the build"
-
-int
-platform_check_ismounted(char *name, char *block, struct stat *s, int verbose)
-{
-	return 0;
-}
-
-int
-platform_check_iswritable(char *name, char *block, struct stat *s)
-{
-	int	fd, writable;
-
-	if ((fd = open(block, O_RDONLY, 0)) < 0) {
-		fprintf(stderr, _("%s: "
-			"error opening the device special file \"%s\": %s\n"),
-			progname, block, strerror(errno));
-		exit(1);
-	}
-
-	if (ioctl(fd, DKIOCISWRITABLE, &writable) < 0) {
-		fprintf(stderr, _("%s: can't tell if \"%s\" is writable: %s\n"),
-			progname, block, strerror(errno));
-		exit(1);
-	}
-	close(fd);
-	return writable == 0;
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
-	ioctl(fd, DKIOCSYNCHRONIZECACHE, NULL);
-}
-
-void
-platform_findsizes(char *path, int fd, long long *sz, int *bsz)
-{
-	uint64_t	size;
-	struct stat	st;
-
-	if (fstat(fd, &st) < 0) {
-		fprintf(stderr,
-			_("%s: cannot stat the device file \"%s\": %s\n"),
-			progname, path, strerror(errno));
-		exit(1);
-	}
-	if ((st.st_mode & S_IFMT) == S_IFREG) {
-		*sz = (long long)(st.st_size >> 9);
-		*bsz = BBSIZE;
-		return;
-	}
-	if (ioctl(fd, DKIOCGETBLOCKCOUNT, &size) < 0) {
-		fprintf(stderr, _("%s: can't determine device size: %s\n"),
-			progname, strerror(errno));
-		exit(1);
-	}
-	*sz = (long long)size;
-	*bsz = BBSIZE;
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
diff --git a/libfrog/paths.c b/libfrog/paths.c
index 2379ea4..6e26665 100644
--- a/libfrog/paths.c
+++ b/libfrog/paths.c
@@ -415,61 +415,6 @@ fs_table_initialise_mounts(
 	return error;
 }
 
-#elif defined(HAVE_GETMNTINFO)
-#include <sys/mount.h>
-
-/*
- * If *path is NULL, initialize the fs table with all xfs mount points in mtab
- * If *path is specified, search for that path in mtab
- *
- * Everything - path, devices, and mountpoints - are boiled down to realpath()
- * for comparison, but fs_table is populated with what comes from getmntinfo.
- */
-static int
-fs_table_initialise_mounts(
-	char		*path)
-{
-	struct statfs	*stats;
-	int		i, count, error, found;
-	char		rpath[PATH_MAX], rmntfromname[PATH_MAX], rmntonname[PATH_MAX];
-
-	error = found = 0;
-	if ((count = getmntinfo(&stats, 0)) < 0) {
-		fprintf(stderr, _("%s: getmntinfo() failed: %s\n"),
-				progname, strerror(errno));
-		return 0;
-	}
-
-	/* Use realpath to resolve symlinks, relative paths, etc */
-	if (path)
-		if (!realpath(path, rpath))
-			return errno;
-
-	for (i = 0; i < count; i++) {
-		if (!realpath(stats[i].f_mntfromname, rmntfromname))
-			continue;
-		if (!realpath(stats[i].f_mntonname, rmntonname))
-			continue;
-
-		if (path &&
-		    ((strcmp(rpath, rmntonname) != 0) &&
-		     (strcmp(rpath, rmntfromname) != 0)))
-			continue;
-		/* TODO: external log and realtime device? */
-		(void) fs_table_insert(stats[i].f_mntonname, 0,
-					FS_MOUNT_POINT, stats[i].f_mntfromname,
-					NULL, NULL);
-		if (path) {
-			found = 1;
-			break;
-		}
-	}
-	if (path && !found)
-		error = ENXIO;
-
-	return error;
-}
-
 #else
 # error "How do I extract info about mounted filesystems on this platform?"
 #endif
diff --git a/libhandle/Makefile b/libhandle/Makefile
index 998081b..f297a59 100644
--- a/libhandle/Makefile
+++ b/libhandle/Makefile
@@ -10,11 +10,7 @@ LT_CURRENT = 1
 LT_REVISION = 3
 LT_AGE = 0
 
-ifeq ($(PKG_PLATFORM),darwin)
-LTLDFLAGS += -Wl,libhandle.sym
-else
 LTLDFLAGS += -Wl,--version-script,libhandle.sym
-endif
 
 CFILES = handle.c jdm.c
 LSRCFILES = libhandle.sym
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 847d429..268193d 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -79,23 +79,6 @@ AC_DEFUN([AC_HAVE_GETMNTENT],
   ])
 
 #
-# Check if we have a getmntinfo libc call (Mac OS X)
-#
-AC_DEFUN([AC_HAVE_GETMNTINFO],
-  [ AC_MSG_CHECKING([for getmntinfo ])
-    AC_TRY_COMPILE([
-#include <sys/param.h>
-#include <sys/ucred.h>
-#include <sys/mount.h>
-    ], [
-         getmntinfo(0, 0);
-    ], have_getmntinfo=yes
-       AC_MSG_RESULT(yes),
-       AC_MSG_RESULT(no))
-    AC_SUBST(have_getmntinfo)
-  ])
-
-#
 # Check if we have a fallocate libc call (Linux)
 #
 AC_DEFUN([AC_HAVE_FALLOCATE],
diff --git a/quota/Makefile b/quota/Makefile
index 41ed234..85e279b 100644
--- a/quota/Makefile
+++ b/quota/Makefile
@@ -11,7 +11,7 @@ CFILES = init.c util.c \
 	edit.c free.c path.c project.c quot.c quota.c report.c state.c
 
 CFILES += $(PKG_PLATFORM).c
-PCFILES = darwin.c linux.c
+PCFILES = linux.c
 LSRCFILES = $(shell echo $(PCFILES) | sed -e "s/$(PKG_PLATFORM).c//g")
 
 LLDLIBS = $(LIBXCMD) $(LIBFROG)
diff --git a/quota/darwin.c b/quota/darwin.c
deleted file mode 100644
index 250c9c7..0000000
--- a/quota/darwin.c
+++ /dev/null
@@ -1,21 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- */
-
-#include "quota.h"
-#include <sys/quota.h>
-
-int
-xfsquotactl(
-	int		command,
-	const char	*device,
-	uint		type,
-	uint		id,
-	void		*addr)
-{
-	/* return quotactl(device, QCMD(command, type), id, addr); */
-	errno = -ENOSYS;
-	return -1;
-}
