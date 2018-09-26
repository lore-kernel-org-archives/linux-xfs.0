Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38976 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbeI0B4u (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Sep 2018 21:56:50 -0400
Received: from smtp.corp.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9048E308FB8E
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 19:42:18 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 296E230912F5
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 19:42:18 +0000 (UTC)
Subject: [PATCH 1/4] xfsprogs: remove irix platform files
References: <395ba7bd-74b1-be1a-2eb6-32099b8eeb94@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <40ed6de6-e07b-c707-7f38-bb01d575ac01@redhat.com>
Date: Wed, 26 Sep 2018 14:42:16 -0500
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
remove the irix platform files. 

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/io/Makefile b/io/Makefile
index 00ede48..1498fc5 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -10,9 +10,9 @@ LSRCFILES = xfs_bmap.sh xfs_freeze.sh xfs_mkfile.sh
 HFILES = init.h io.h
 CFILES = init.c \
 	attr.c bmap.c cowextsize.c encrypt.c file.c freeze.c fsync.c \
-	getrusage.c imap.c label.c link.c mmap.c open.c parent.c pread.c \
-	prealloc.c pwrite.c reflink.c scrub.c seek.c shutdown.c stat.c \
-	swapext.c sync.c truncate.c utimes.c
+	getrusage.c imap.c inject.c label.c link.c mmap.c open.c parent.c \
+	pread.c prealloc.c pwrite.c reflink.c resblks.c scrub.c seek.c \
+	shutdown.c stat.c swapext.c sync.c truncate.c utimes.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
@@ -53,13 +53,6 @@ else
 LSRCFILES += fiemap.c
 endif
 
-ifeq ($(PKG_PLATFORM),irix)
-LSRCFILES += inject.c resblks.c
-else
-CFILES += inject.c resblks.c
-LCFLAGS += -DHAVE_INJECT -DHAVE_RESBLKS
-endif
-
 ifeq ($(HAVE_COPY_FILE_RANGE),yes)
 CFILES += copy_file_range.c
 LCFLAGS += -DHAVE_COPY_FILE_RANGE
diff --git a/io/io.h b/io/io.h
index e1f3d95..9278ad0 100644
--- a/io/io.h
+++ b/io/io.h
@@ -107,6 +107,7 @@ extern void		pread_init(void);
 extern void		prealloc_init(void);
 extern void		pwrite_init(void);
 extern void		quit_init(void);
+extern void		resblks_init(void);
 extern void		seek_init(void);
 extern void		shutdown_init(void);
 extern void		stat_init(void);
@@ -121,12 +122,6 @@ extern void		fadvise_init(void);
 #define fadvise_init()	do { } while (0)
 #endif
 
-#ifdef HAVE_RESBLKS
-extern void		resblks_init(void);
-#else
-#define resblks_init()	do { } while (0)
-#endif
-
 #ifdef HAVE_SENDFILE
 extern void		sendfile_init(void);
 #else
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 707666e..02a9cbc 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -31,7 +31,7 @@ crc32table.h
 LSRCFILES += gen_crc32table.c
 
 CFILES += $(PKG_PLATFORM).c
-PCFILES = darwin.c freebsd.c irix.c linux.c
+PCFILES = darwin.c freebsd.c linux.c
 LSRCFILES = $(shell echo $(PCFILES) | sed -e "s/$(PKG_PLATFORM).c//g")
 
 ifeq ($(HAVE_GETMNTENT),yes)
diff --git a/libfrog/irix.c b/libfrog/irix.c
deleted file mode 100644
index 7241b57..0000000
--- a/libfrog/irix.c
+++ /dev/null
@@ -1,103 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- */
-
-#include "libxfs.h"
-#include <diskinfo.h>
-#include <sys/sysmp.h>
-
-int platform_has_uuid = 0;
-extern char *progname;
-extern int64_t findsize(char *);
-
-#warning "IRIX support is deprecated and planned for removal in July 2018"
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
-	return 1;
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
-	struct stat		st;
-
-	if (fstat(fd, &st) < 0) {
-		fprintf(stderr,
-			_("%s: cannot stat the device file \"%s\": %s\n"),
-			progname, path, strerror(errno));
-		exit(1);
-	}
-	if ((st.st_mode & S_IFMT) == S_IFREG) {
-		*sz = (long long)(st.st_size >> 9);
-	} else {
-		*sz = findsize(path);
-	}
-	*bsz = BBSIZE;
-}
-
-char *
-platform_findrawpath(char *path)
-{
-	return findrawpath(path);
-}
-
-char *
-platform_findblockpath(char *path)
-{
-	return findblockpath(path);
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
-	return sysmp(MP_NPROCS);
-}
-
-unsigned long
-platform_physmem(void)
-{
-	struct rminfo ri;
-
-	if (sysmp(MP_SAGET, MPSA_RMINFO, &ri, sizeof(ri)) < 0)
-		fprintf(stderr, _("%s: can't determine memory size\n"),
-			progname);
-		exit(1);
-	}
-	return (ri.physmem >> 10) * getpagesize();	/* kilobytes */
-}
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 0a6b514..0c146f9 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -63,7 +63,7 @@ AC_DEFUN([AC_HAVE_SENDFILE],
   ])
 
 #
-# Check if we have a getmntent libc call (IRIX, Linux)
+# Check if we have a getmntent libc call (Linux)
 #
 AC_DEFUN([AC_HAVE_GETMNTENT],
   [ AC_MSG_CHECKING([for getmntent ])
diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
index 4ec575f..d9c5f64 100644
--- a/man/man8/xfs_quota.8
+++ b/man/man8/xfs_quota.8
@@ -305,8 +305,6 @@ limit enforcement disabled.
 .IP 4.
 Turning on quotas on the root filesystem is slightly different from
 the above.
-For IRIX XFS, refer to
-.BR quotaon (1M).
 For Linux XFS, the quota mount flags must be passed in with the
 "rootflags=" boot parameter.
 .IP 5.
@@ -732,13 +730,6 @@ Mapping of numeric project identifiers to directories trees.
 .I /etc/projid
 Mapping of numeric project identifiers to project names.
 .PD
-.SH IRIX SEE ALSO
-.BR quotaon (1M),
-.BR xfs (4).
-
-.SH LINUX SEE ALSO
-.BR warnquota (8),
-.BR xfs (5).
 
 .SH SEE ALSO
 .BR df (1),
@@ -746,3 +737,5 @@ Mapping of numeric project identifiers to project names.
 .BR sync (2),
 .BR projid (5),
 .BR projects (5).
+.BR xfs (5).
+.BR warnquota (8),
diff --git a/quota/Makefile b/quota/Makefile
index 7bff7a1..45d327a 100644
--- a/quota/Makefile
+++ b/quota/Makefile
@@ -11,7 +11,7 @@ CFILES = init.c util.c \
 	edit.c free.c path.c project.c quot.c quota.c report.c state.c
 
 CFILES += $(PKG_PLATFORM).c
-PCFILES = darwin.c freebsd.c irix.c linux.c
+PCFILES = darwin.c freebsd.c linux.c
 LSRCFILES = $(shell echo $(PCFILES) | sed -e "s/$(PKG_PLATFORM).c//g")
 
 LLDLIBS = $(LIBXCMD) $(LIBFROG)
diff --git a/quota/irix.c b/quota/irix.c
deleted file mode 100644
index a79bba8..0000000
--- a/quota/irix.c
+++ /dev/null
@@ -1,54 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- */
-
-#include "quota.h"
-#include <sys/quota.h>
-
-static int
-xcommand_to_qcommand(
-	uint		command,
-	uint		type)
-{
-	switch (command) {
-	case XFS_QUOTAON:
-		return Q_XQUOTAON;
-	case XFS_QUOTAOFF:
-		return Q_XQUOTAOFF;
-	case XFS_GETQUOTA:
-		if (type == XFS_GROUP_QUOTA)
-			return Q_XGETGQUOTA;
-		if (type == XFS_PROJ_QUOTA)
-			return Q_XGETPQUOTA;
-		return Q_XGETQUOTA;
-	case XFS_SETQLIM:
-		if (type == XFS_GROUP_QUOTA)
-			return Q_XSETGQLIM;
-		if (type == XFS_PROJ_QUOTA)
-			return Q_XSETPQLIM;
-		return Q_XSETQLIM;
-	case XFS_GETQSTAT:
-		return Q_XGETQSTAT;
-	case XFS_QUOTARM:
-		return Q_XQUOTARM;
-	case XFS_QSYNC:
-		return Q_SYNC;
-	}
-	return 0;
-}
-
-int
-xfsquotactl(
-	int		command,
-	const char	*device,
-	uint		type,
-	uint		id,
-	void		*addr)
-{
-	int		qcommand;
-
-	qcommand = xcommand_to_qcommand(command, type);
-	return quotactl(qcommand, (char *)device, id, addr);
-}
