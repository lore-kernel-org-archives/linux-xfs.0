Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34006 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752954AbeCUUNo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Mar 2018 16:13:44 -0400
Date: Wed, 21 Mar 2018 13:13:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5.5/4] misc: remove darwin, irix, and freebsd support
Message-ID: <20180321201334.GJ4818@magnolia>
References: <152151529988.18312.2660325658864402943.stgit@magnolia>
 <20180321031933.GO1757@magnolia>
 <5b3de5aa-9cee-6e43-5d70-beb4974eb5b9@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b3de5aa-9cee-6e43-5d70-beb4974eb5b9@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Wed, Mar 21, 2018 at 02:42:28PM -0500, Eric Sandeen wrote:
> Remove even more unsupported platform bits.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks fine to me, though we should wait a few days to see if anyone
complains...

Looking at osx again, there /was/ a readonly fuse driver.  It claims to
support OSX 10.7 (EOLd 3.5 years ago) and bundles its own copy of
xfsprogs 3.1.4 (imported 6 years ago)... so I think it's probably ok to
cut it loose.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/Makefile b/Makefile
> index 7ddfa31..4ff2cac 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -47,13 +47,9 @@ HDR_SUBDIRS = include libxfs
>  LIBFROG_SUBDIR = libfrog
>  DLIB_SUBDIRS = libxlog libxcmd libhandle
>  LIB_SUBDIRS = libxfs $(DLIB_SUBDIRS)
> -TOOL_SUBDIRS = copy db estimate fsck growfs io logprint mkfs quota \
> +TOOL_SUBDIRS = copy db estimate fsck fsr growfs io logprint mkfs quota \
>  		mdrestore repair rtcp m4 man doc debian spaceman scrub
>  
> -ifneq ("$(PKG_PLATFORM)","darwin")
> -TOOL_SUBDIRS += fsr
> -endif
> -
>  ifneq ("$(XGETTEXT)","")
>  TOOL_SUBDIRS += po
>  endif
> diff --git a/include/Makefile b/include/Makefile
> index 6077507..09fe42c 100644
> --- a/include/Makefile
> +++ b/include/Makefile
> @@ -47,14 +47,12 @@ LIBHFILES = libxfs.h \
>  
>  HFILES = handle.h \
>  	jdm.h \
> -	$(PKG_PLATFORM).h \
> +	linux.h \
>  	xfs.h \
>  	xqm.h \
>  	xfs_arch.h
>  
> -PHFILES = darwin.h freebsd.h linux.h gnukfreebsd.h
> -LSRCFILES = $(shell echo $(PHFILES) | sed -e "s/$(PKG_PLATFORM).h//g")
> -LSRCFILES += platform_defs.h.in builddefs.in buildmacros buildrules install-sh
> +LSRCFILES = platform_defs.h.in builddefs.in buildmacros buildrules install-sh
>  LSRCFILES += $(DKHFILES) $(LIBHFILES)
>  LDIRT = disk
>  LDIRDIRT = xfs
> diff --git a/include/builddefs.in b/include/builddefs.in
> index df76b2c..7f1f58c 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -48,7 +48,6 @@ PKG_USER	= @pkg_user@
>  PKG_GROUP	= @pkg_group@
>  PKG_RELEASE	= @pkg_release@
>  PKG_VERSION	= @pkg_version@
> -PKG_PLATFORM	= @pkg_platform@
>  PKG_DISTRIBUTION= @pkg_distribution@
>  
>  prefix		= @prefix@
> @@ -135,25 +134,12 @@ CROND_DIR = @crond_dir@
>  GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
>  #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
>  
> -ifeq ($(PKG_PLATFORM),linux)
>  PCFLAGS = -D_GNU_SOURCE $(GCCFLAGS)
>  ifeq ($(HAVE_UMODE_T),yes)
>  PCFLAGS += -DHAVE_UMODE_T
>  endif
>  DEPENDFLAGS = -D__linux__
> -endif
> -ifeq ($(PKG_PLATFORM),gnukfreebsd)
> -PCFLAGS = -D_GNU_SOURCE $(GCCFLAGS)
> -endif
> -ifeq ($(PKG_PLATFORM),darwin)
> -PCFLAGS = $(GCCFLAGS)
> -DEPENDFLAGS = -D__APPLE__ -D_DARWIN_FEATURE_64_BIT_INODE
> -endif
> -ifeq ($(PKG_PLATFORM),freebsd)
> -PLDLIBS = -L/usr/local/lib -lintl
> -PCFLAGS = -I/usr/local/include $(GCCFLAGS)
> -DEPENDFLAGS = -D__FreeBSD__
> -endif
> +
>  ifeq ($(HAVE_FLS),yes)
>  LCFLAGS+= -DHAVE_FLS
>  endif
> diff --git a/include/gnukfreebsd.h b/include/gnukfreebsd.h
> deleted file mode 100644
> index 1db3f4f..0000000
> --- a/include/gnukfreebsd.h
> +++ /dev/null
> @@ -1,156 +0,0 @@
> -/*
> - * Copyright (c) 2004-2006 Silicon Graphics, Inc.
> - * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU Lesser General Public License
> - * as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU Lesser General Public License for more details.
> - *
> - * You should have received a copy of the GNU Lesser General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -#ifndef __XFS_KFREEBSD_H__
> -#define __XFS_KFREEBSD_H__
> -
> -#include <uuid/uuid.h>
> -#include <sys/vfs.h>
> -#include <sys/ioctl.h>
> -#include <sys/sysmacros.h>
> -#include <malloc.h>
> -#include <getopt.h>
> -#include <endian.h>
> -#include <sys/stat.h>
> -#include <sys/param.h>
> -#include <sys/mount.h>
> -#include <ctype.h>
> -#include <libgen.h>
> -#include <paths.h>
> -#include <mntent.h>
> -
> -#define EFSCORRUPTED	990	/* Filesystem is corrupted */
> -#define EFSBADCRC	991	/* Bad CRC detected */
> -
> -typedef unsigned char		__u8;
> -typedef signed char		__s8;
> -typedef unsigned short		__u16;
> -typedef signed short		__s16;
> -typedef unsigned int		__u32;
> -typedef signed int		__s32;
> -typedef unsigned long long int	__u64;
> -typedef signed long long int	__s64;
> -
> -typedef off_t		xfs_off_t;
> -typedef uint64_t	xfs_ino_t;
> -typedef uint32_t	xfs_dev_t;
> -typedef int64_t		xfs_daddr_t;
> -typedef __u32		xfs_nlink_t;
> -
> -#define HAVE_FID	1
> -
> -static __inline__ int xfsctl(const char *path, int fd, int cmd, void *p)
> -{
> -	return ioctl(fd, cmd, p);
> -}
> -
> -static __inline__ int platform_test_xfs_fd(int fd)
> -{
> -	struct statfs buf;
> -	if (fstatfs(fd, &buf) < 0)
> -		return 0;
> -	return strncmp(buf.f_fstypename, "xfs", 4) == 0;
> -}
> -
> -static __inline__ int platform_test_xfs_path(const char *path)
> -{
> -	struct statfs buf;
> -	if (statfs(path, &buf) < 0)
> -		return 0;
> -	return strncmp(buf.f_fstypename, "xfs", 4) == 0;
> -}
> -
> -static __inline__ int platform_fstatfs(int fd, struct statfs *buf)
> -{
> -	return fstatfs(fd, buf);
> -}
> -
> -static __inline__ void platform_getoptreset(void)
> -{
> -	extern int optind;
> -	optind = 0;
> -}
> -
> -static __inline__ int platform_uuid_compare(uuid_t *uu1, uuid_t *uu2)
> -{
> -	return uuid_compare(*uu1, *uu2);
> -}
> -
> -static __inline__ void platform_uuid_unparse(uuid_t *uu, char *buffer)
> -{
> -	uuid_unparse(*uu, buffer);
> -}
> -
> -static __inline__ int platform_uuid_parse(char *buffer, uuid_t *uu)
> -{
> -	return uuid_parse(buffer, *uu);
> -}
> -
> -static __inline__ int platform_uuid_is_null(uuid_t *uu)
> -{
> -	return uuid_is_null(*uu);
> -}
> -
> -static __inline__ void platform_uuid_generate(uuid_t *uu)
> -{
> -	uuid_generate(*uu);
> -}
> -
> -static __inline__ void platform_uuid_clear(uuid_t *uu)
> -{
> -	uuid_clear(*uu);
> -}
> -
> -static __inline__ void platform_uuid_copy(uuid_t *dst, uuid_t *src)
> -{
> -	uuid_copy(*dst, *src);
> -}
> -
> -static __inline__ int
> -platform_discard_blocks(int fd, uint64_t start, uint64_t len)
> -{
> -	return 0;
> -}
> -
> -/**
> - * Abstraction of mountpoints.
> - */
> -struct mntent_cursor {
> -	FILE *mtabp;
> -};
> -
> -static inline int platform_mntent_open(struct mntent_cursor * cursor, char *mtab)
> -{
> -	cursor->mtabp = setmntent(mtab, "r");
> -	if (!cursor->mtabp) {
> -		fprintf(stderr, "Error: cannot read %s\n", mtab);
> -		return 1;
> -	}
> -	return 0;
> -}
> -
> -static inline struct mntent * platform_mntent_next(struct mntent_cursor * cursor)
> -{
> -	return getmntent(cursor->mtabp);
> -}
> -
> -static inline void platform_mntent_close(struct mntent_cursor * cursor)
> -{
> -	endmntent(cursor->mtabp);
> -}
> -
> -#endif	/* __XFS_KFREEBSD_H__ */
> diff --git a/include/xfs.h b/include/xfs.h
> index a40ca0c..1cbe3ad 100644
> --- a/include/xfs.h
> +++ b/include/xfs.h
> @@ -35,12 +35,6 @@
>  
>  #if defined(__linux__)
>  #include <xfs/linux.h>
> -#elif defined(__FreeBSD__)
> -#include <xfs/freebsd.h>
> -#elif defined(__FreeBSD_kernel__)
> -#include <xfs/gnukfreebsd.h>
> -#elif defined(__APPLE__)
> -#include <xfs/darwin.h>
>  #else
>  # error unknown platform... have fun porting!
>  #endif
> diff --git a/io/Makefile b/io/Makefile
> index 8055d4b..a251b28 100644
> --- a/io/Makefile
> +++ b/io/Makefile
> @@ -9,10 +9,10 @@ LTCOMMAND = xfs_io
>  LSRCFILES = xfs_bmap.sh xfs_freeze.sh xfs_mkfile.sh
>  HFILES = init.h io.h
>  CFILES = init.c \
> -	attr.c bmap.c cowextsize.c encrypt.c file.c freeze.c fsync.c \
> -	getrusage.c imap.c link.c mmap.c open.c parent.c pread.c prealloc.c \
> -	pwrite.c reflink.c scrub.c seek.c shutdown.c stat.c sync.c truncate.c \
> -	utimes.c
> +	attr.c bmap.c cowextsize.c encrypt.c file.c freeze.c fsmap.c fsync.c \
> +	getrusage.c imap.c inject.c link.c mmap.c open.c parent.c pread.c \
> +	prealloc.c pwrite.c reflink.c resblks.c scrub.c seek.c shutdown.c \
> +	stat.c sync.c truncate.c utimes.c
>  
>  LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD)
>  LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
> @@ -53,13 +53,6 @@ else
>  LSRCFILES += fiemap.c
>  endif
>  
> -ifeq ($(PKG_PLATFORM),irix)
> -LSRCFILES += inject.c resblks.c
> -else
> -CFILES += inject.c resblks.c
> -LCFLAGS += -DHAVE_INJECT -DHAVE_RESBLKS
> -endif
> -
>  ifeq ($(HAVE_COPY_FILE_RANGE),yes)
>  CFILES += copy_file_range.c
>  LCFLAGS += -DHAVE_COPY_FILE_RANGE
> @@ -114,13 +107,6 @@ LLDLIBS += $(LIBDEVMAPPER)
>  LCFLAGS += -DHAVE_DEVMAPPER
>  endif
>  
> -# On linux we get fsmap from the system or define it ourselves
> -# so include this based on platform type.  If this reverts to only
> -# the autoconf check w/o local definition, change to testing HAVE_GETFSMAP
> -ifeq ($(PKG_PLATFORM),linux)
> -CFILES += fsmap.c
> -endif
> -
>  ifeq ($(HAVE_STATFS_FLAGS),yes)
>  LCFLAGS += -DHAVE_STATFS_FLAGS
>  endif
> diff --git a/io/io.h b/io/io.h
> index 5cf7c30..4516554 100644
> --- a/io/io.h
> +++ b/io/io.h
> @@ -116,6 +116,7 @@ extern void		pread_init(void);
>  extern void		prealloc_init(void);
>  extern void		pwrite_init(void);
>  extern void		quit_init(void);
> +extern void		resblks_init(void);
>  extern void		seek_init(void);
>  extern void		shutdown_init(void);
>  extern void		stat_init(void);
> @@ -129,12 +130,6 @@ extern void		fadvise_init(void);
>  #define fadvise_init()	do { } while (0)
>  #endif
>  
> -#ifdef HAVE_RESBLKS
> -extern void		resblks_init(void);
> -#else
> -#define resblks_init()	do { } while (0)
> -#endif
> -
>  #ifdef HAVE_SENDFILE
>  extern void		sendfile_init(void);
>  #else
> diff --git a/libhandle/Makefile b/libhandle/Makefile
> index fe1a2af..cc4ad1d 100644
> --- a/libhandle/Makefile
> +++ b/libhandle/Makefile
> @@ -10,11 +10,7 @@ LT_CURRENT = 1
>  LT_REVISION = 3
>  LT_AGE = 0
>  
> -ifeq ($(PKG_PLATFORM),darwin)
> -LTLDFLAGS += -Wl,libhandle.sym
> -else
>  LTLDFLAGS += -Wl,--version-script,libhandle.sym
> -endif
>  
>  CFILES = handle.c jdm.c
>  LSRCFILES = libhandle.sym
> diff --git a/libxfs/Makefile b/libxfs/Makefile
> index 00df418..48f66d4 100644
> --- a/libxfs/Makefile
> +++ b/libxfs/Makefile
> @@ -58,6 +58,7 @@ CFILES = cache.c \
>  	defer_item.c \
>  	init.c \
>  	kmem.c \
> +	linux.c \
>  	logitem.c \
>  	rdwr.c \
>  	trans.c \
> @@ -97,9 +98,6 @@ CFILES = cache.c \
>  	xfs_symlink_remote.c \
>  	xfs_trans_resv.c
>  
> -CFILES += $(PKG_PLATFORM).c
> -PCFILES = linux.c
> -LSRCFILES = $(shell echo $(PCFILES) | sed -e "s/$(PKG_PLATFORM).c//g")
>  LSRCFILES += gen_crc32table.c
>  
>  #
> diff --git a/m4/package_globals.m4 b/m4/package_globals.m4
> index e469671..892e3bd 100644
> --- a/m4/package_globals.m4
> +++ b/m4/package_globals.m4
> @@ -40,8 +40,4 @@ AC_DEFUN([AC_PACKAGE_GLOBALS],
>      pkg_distribution=`uname -s`
>      test -z "$DISTRIBUTION" || pkg_distribution="$DISTRIBUTION"
>      AC_SUBST(pkg_distribution)
> -
> -    pkg_platform=`uname -s | tr 'A-Z' 'a-z' | tr -d / | sed -e 's/irix64/irix/'`
> -    test -z "$PLATFORM" || pkg_platform="$PLATFORM"
> -    AC_SUBST(pkg_platform)
>    ])
> diff --git a/quota/Makefile b/quota/Makefile
> index 120af2e..62cc8a0 100644
> --- a/quota/Makefile
> +++ b/quota/Makefile
> @@ -8,11 +8,7 @@ include $(TOPDIR)/include/builddefs
>  LTCOMMAND = xfs_quota
>  HFILES = init.h quota.h
>  CFILES = init.c util.c \
> -	edit.c free.c path.c project.c quot.c quota.c report.c state.c
> -
> -CFILES += $(PKG_PLATFORM).c
> -PCFILES = darwin.c freebsd.c irix.c linux.c
> -LSRCFILES = $(shell echo $(PCFILES) | sed -e "s/$(PKG_PLATFORM).c//g")
> +	edit.c free.c linux.c path.c project.c quot.c quota.c report.c state.c
>  
>  LLDLIBS = $(LIBXCMD) $(LIBFROG)
>  LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)
> diff --git a/quota/darwin.c b/quota/darwin.c
> deleted file mode 100644
> index fb81f7f..0000000
> --- a/quota/darwin.c
> +++ /dev/null
> @@ -1,33 +0,0 @@
> -/*
> - * Copyright (c) 2005 Silicon Graphics, Inc.
> - * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include "quota.h"
> -#include <sys/quota.h>
> -
> -int
> -xfsquotactl(
> -	int		command,
> -	const char	*device,
> -	uint		type,
> -	uint		id,
> -	void		*addr)
> -{
> -	/* return quotactl(device, QCMD(command, type), id, addr); */
> -	errno = -ENOSYS;
> -	return -1;
> -}
> diff --git a/quota/freebsd.c b/quota/freebsd.c
> deleted file mode 100644
> index 7770b3c..0000000
> --- a/quota/freebsd.c
> +++ /dev/null
> @@ -1,31 +0,0 @@
> -/*
> - * Copyright (c) 2005 Silicon Graphics, Inc.
> - * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include "quota.h"
> -
> -int
> -xfsquotactl(
> -	int		command,
> -	const char	*device,
> -	uint		type,
> -	uint		id,
> -	void		*addr)
> -{
> -	errno = -ENOSYS;
> -	return -1;
> -}
> diff --git a/quota/irix.c b/quota/irix.c
> deleted file mode 100644
> index bbbcd18..0000000
> --- a/quota/irix.c
> +++ /dev/null
> @@ -1,66 +0,0 @@
> -/*
> - * Copyright (c) 2005 Silicon Graphics, Inc.
> - * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include "quota.h"
> -#include <sys/quota.h>
> -
> -static int
> -xcommand_to_qcommand(
> -	uint		command,
> -	uint		type)
> -{
> -	switch (command) {
> -	case XFS_QUOTAON:
> -		return Q_XQUOTAON;
> -	case XFS_QUOTAOFF:
> -		return Q_XQUOTAOFF;
> -	case XFS_GETQUOTA:
> -		if (type == XFS_GROUP_QUOTA)
> -			return Q_XGETGQUOTA;
> -		if (type == XFS_PROJ_QUOTA)
> -			return Q_XGETPQUOTA;
> -		return Q_XGETQUOTA;
> -	case XFS_SETQLIM:
> -		if (type == XFS_GROUP_QUOTA)
> -			return Q_XSETGQLIM;
> -		if (type == XFS_PROJ_QUOTA)
> -			return Q_XSETPQLIM;
> -		return Q_XSETQLIM;
> -	case XFS_GETQSTAT:
> -		return Q_XGETQSTAT;
> -	case XFS_QUOTARM:
> -		return Q_XQUOTARM;
> -	case XFS_QSYNC:
> -		return Q_SYNC;
> -	}
> -	return 0;
> -}
> -
> -int
> -xfsquotactl(
> -	int		command,
> -	const char	*device,
> -	uint		type,
> -	uint		id,
> -	void		*addr)
> -{
> -	int		qcommand;
> -
> -	qcommand = xcommand_to_qcommand(command, type);
> -	return quotactl(qcommand, (char *)device, id, addr);
> -}
> diff --git a/scrub/Makefile b/scrub/Makefile
> index 0632794..94c6313 100644
> --- a/scrub/Makefile
> +++ b/scrub/Makefile
> @@ -8,9 +8,9 @@ include $(TOPDIR)/include/builddefs
>  # On linux we get fsmap from the system or define it ourselves
>  # so include this based on platform type.  If this reverts to only
>  # the autoconf check w/o local definition, change to testing HAVE_GETFSMAP
> -SCRUB_PREREQS=$(PKG_PLATFORM)$(HAVE_OPENAT)$(HAVE_FSTATAT)
> +SCRUB_PREREQS=$(HAVE_OPENAT)$(HAVE_FSTATAT)
>  
> -ifeq ($(SCRUB_PREREQS),linuxyesyes)
> +ifeq ($(SCRUB_PREREQS),yesyes)
>  LTCOMMAND = xfs_scrub
>  INSTALL_SCRUB = install-scrub
>  XFS_SCRUB_ALL_PROG = xfs_scrub_all
> diff --git a/spaceman/Makefile b/spaceman/Makefile
> index 8b31030..a137efc 100644
> --- a/spaceman/Makefile
> +++ b/spaceman/Makefile
> @@ -7,7 +7,7 @@ include $(TOPDIR)/include/builddefs
>  
>  LTCOMMAND = xfs_spaceman
>  HFILES = init.h space.h
> -CFILES = init.c file.c prealloc.c trim.c
> +CFILES = freesp.c init.c file.c prealloc.c trim.c
>  
>  LLDLIBS = $(LIBXCMD) $(LIBFROG)
>  LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)
> @@ -21,13 +21,6 @@ ifeq ($(ENABLE_EDITLINE),yes)
>  LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
>  endif
>  
> -# On linux we get fsmap from the system or define it ourselves
> -# so include this based on platform type.  If this reverts to only
> -# the autoconf check w/o local definition, change to testing HAVE_GETFSMAP
> -ifeq ($(PKG_PLATFORM),linux)
> -CFILES += freesp.c
> -endif
> -
>  default: depend $(LTCOMMAND)
>  
>  include $(BUILDRULES)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
