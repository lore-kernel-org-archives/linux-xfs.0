Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51648 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCqG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:46:06 -0400
Subject: [PATCH 1/9] libfrog: move platform specific runtime support code
 out of libxfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:45:30 -0700
Message-ID: <152401953013.13048.5503819449572585211.stgit@magnolia>
In-Reply-To: <152401952391.13048.15040850425873030425.stgit@magnolia>
References: <152401952391.13048.15040850425873030425.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the platform support code to libfrog, which should remove the final
dependency of libfrog on libxfs.  libfrog is the runtime support
library, and these files provide platform support.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/Makefile  |    4 +
 libfrog/darwin.c  |  148 ++++++++++++++++++++++++++++++
 libfrog/freebsd.c |  205 +++++++++++++++++++++++++++++++++++++++++
 libfrog/irix.c    |  115 +++++++++++++++++++++++
 libfrog/linux.c   |  265 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/Makefile   |    3 -
 libxfs/darwin.c   |  148 ------------------------------
 libxfs/freebsd.c  |  205 -----------------------------------------
 libxfs/irix.c     |  115 -----------------------
 libxfs/linux.c    |  265 -----------------------------------------------------
 10 files changed, 737 insertions(+), 736 deletions(-)
 create mode 100644 libfrog/darwin.c
 create mode 100644 libfrog/freebsd.c
 create mode 100644 libfrog/irix.c
 create mode 100644 libfrog/linux.c
 delete mode 100644 libxfs/darwin.c
 delete mode 100644 libxfs/freebsd.c
 delete mode 100644 libxfs/irix.c
 delete mode 100644 libxfs/linux.c


diff --git a/libfrog/Makefile b/libfrog/Makefile
index 230b08f..21bb5b7 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -22,6 +22,10 @@ topology.c \
 util.c \
 workqueue.c
 
+CFILES += $(PKG_PLATFORM).c
+PCFILES = darwin.c freebsd.c irix.c linux.c
+LSRCFILES = $(shell echo $(PCFILES) | sed -e "s/$(PKG_PLATFORM).c//g")
+
 ifeq ($(HAVE_GETMNTENT),yes)
 LCFLAGS += -DHAVE_GETMNTENT
 endif
diff --git a/libfrog/darwin.c b/libfrog/darwin.c
new file mode 100644
index 0000000..396477e
--- /dev/null
+++ b/libfrog/darwin.c
@@ -0,0 +1,148 @@
+/*
+ * Copyright (c) 2003,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <sys/disk.h>
+#include <sys/stat.h>
+#include <sys/mount.h>
+#include <sys/ioctl.h>
+#include <sys/sysctl.h>
+#include "libxfs.h"
+
+int platform_has_uuid = 1;
+extern char *progname;
+
+#warning "Darwin support is deprecated and planned for removal in July 2018"
+#warning "Contact linux-xfs@vger.kernel.org if you'd like to maintain this port"
+#error   "Remove this line if you'd like to continue the build"
+
+int
+platform_check_ismounted(char *name, char *block, struct stat *s, int verbose)
+{
+	return 0;
+}
+
+int
+platform_check_iswritable(char *name, char *block, struct stat *s)
+{
+	int	fd, writable;
+
+	if ((fd = open(block, O_RDONLY, 0)) < 0) {
+		fprintf(stderr, _("%s: "
+			"error opening the device special file \"%s\": %s\n"),
+			progname, block, strerror(errno));
+		exit(1);
+	}
+
+	if (ioctl(fd, DKIOCISWRITABLE, &writable) < 0) {
+		fprintf(stderr, _("%s: can't tell if \"%s\" is writable: %s\n"),
+			progname, block, strerror(errno));
+		exit(1);
+	}
+	close(fd);
+	return writable == 0;
+}
+
+int
+platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fatal)
+{
+	return fatal;
+}
+
+void
+platform_flush_device(int fd, dev_t device)
+{
+	ioctl(fd, DKIOCSYNCHRONIZECACHE, NULL);
+}
+
+void
+platform_findsizes(char *path, int fd, long long *sz, int *bsz)
+{
+	uint64_t	size;
+	struct stat	st;
+
+	if (fstat(fd, &st) < 0) {
+		fprintf(stderr,
+			_("%s: cannot stat the device file \"%s\": %s\n"),
+			progname, path, strerror(errno));
+		exit(1);
+	}
+	if ((st.st_mode & S_IFMT) == S_IFREG) {
+		*sz = (long long)(st.st_size >> 9);
+		*bsz = BBSIZE;
+		return;
+	}
+	if (ioctl(fd, DKIOCGETBLOCKCOUNT, &size) < 0) {
+		fprintf(stderr, _("%s: can't determine device size: %s\n"),
+			progname, strerror(errno));
+		exit(1);
+	}
+	*sz = (long long)size;
+	*bsz = BBSIZE;
+}
+
+char *
+platform_findrawpath(char *path)
+{
+	return path;
+}
+
+char *
+platform_findblockpath(char *path)
+{
+	return path;
+}
+
+int
+platform_direct_blockdev(void)
+{
+	return 0;
+}
+
+int
+platform_align_blockdev(void)
+{
+	return sizeof(void *);
+}
+
+int
+platform_nproc(void)
+{
+	int		ncpu;
+	size_t		len = sizeof(ncpu);
+	static int	mib[2] = {CTL_HW, HW_NCPU};
+
+	if (sysctl(mib, 2, &ncpu, &len, NULL, 0) < 0)
+		ncpu = 1;
+
+	return ncpu;
+}
+
+unsigned long
+platform_physmem(void)
+{
+	unsigned long	physmem;
+	size_t		len = sizeof(physmem);
+	static int	mib[2] = {CTL_HW, HW_PHYSMEM};
+
+	if (sysctl(mib, 2, &physmem, &len, NULL, 0) < 0) {
+		fprintf(stderr, _("%s: can't determine memory size\n"),
+			progname);
+		exit(1);
+	}
+	return physmem >> 10;
+}
diff --git a/libfrog/freebsd.c b/libfrog/freebsd.c
new file mode 100644
index 0000000..d9fc837
--- /dev/null
+++ b/libfrog/freebsd.c
@@ -0,0 +1,205 @@
+/*
+ * Copyright (c) 2003,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include "libxfs.h"
+#include <sys/stat.h>
+#include <sys/disk.h>
+#include <sys/mount.h>
+#include <sys/ioctl.h>
+#include <sys/sysctl.h>
+
+int platform_has_uuid = 1;
+extern char *progname;
+
+#warning "FreeBSD support is deprecated and planned for removal in July 2018"
+#warning "Contact linux-xfs@vger.kernel.org if you'd like to maintain this port"
+#error   "Remove this line if you'd like to continue the build"
+
+int
+platform_check_ismounted(char *name, char *block, struct stat *s, int verbose)
+{
+	struct stat	st;
+        int cnt, i;
+        struct statfs *fsinfo;
+
+	if (!s) {
+		if (stat(block, &st) < 0)
+			return 0;
+		s = &st;
+	}
+
+	/* Remember, FreeBSD can now mount char devices! -- adrian */
+	if (((st.st_mode & S_IFMT) != S_IFBLK) &&
+	    ((st.st_mode & S_IFMT) != S_IFCHR))
+		return 0;
+
+	if ((cnt = getmntinfo(&fsinfo, MNT_NOWAIT)) == 0) {
+		fprintf(stderr,
+		    _("%s: %s possibly contains a mounted filesystem\n"),
+		    progname, name);
+		return 1;
+	}
+
+        for (i = 0; i < cnt; i++) {
+                if (strcmp (name, fsinfo[i].f_mntfromname) != 0)
+			continue;
+
+		if (verbose)
+			fprintf(stderr,
+			    _("%s: %s contains a mounted filesystem\n"),
+			    progname, name);
+		break;
+	}
+
+        return i < cnt;
+}
+
+int
+platform_check_iswritable(char *name, char *block, struct stat *s)
+{
+        int cnt, i;
+        struct statfs *fsinfo;
+
+        if ((cnt = getmntinfo(&fsinfo, MNT_NOWAIT)) == 0) {
+		fprintf(stderr, _("%s: %s contains a possibly writable, "
+				"mounted filesystem\n"), progname, name);
+			return 1;
+	}
+
+        for (i = 0; i < cnt; i++) {
+                if (strcmp (name, fsinfo[i].f_mntfromname) != 0)
+			continue;
+
+		if (fsinfo[i].f_flags &= MNT_RDONLY)
+			break;
+	}
+
+        if (i == cnt) {
+		fprintf(stderr, _("%s: %s contains a mounted and writable "
+				"filesystem\n"), progname, name);
+		return 1;
+	}
+	return 0;
+}
+
+int
+platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fatal)
+{
+	return fatal;
+}
+
+void
+platform_flush_device(int fd, dev_t device)
+{
+	return;
+}
+
+void
+platform_findsizes(char *path, int fd, long long *sz, int *bsz)
+{
+	struct stat	st;
+	int64_t		size;
+	uint		ssize;
+
+	if (fstat(fd, &st) < 0) {
+		fprintf(stderr, _("%s: "
+			"cannot stat the device file \"%s\": %s\n"),
+			progname, path, strerror(errno));
+		exit(1);
+	}
+
+	if ((st.st_mode & S_IFMT) == S_IFREG) {
+		*sz = (long long)(st.st_size >> 9);
+		*bsz = 512;
+		return;
+	}
+
+	if ((st.st_mode & S_IFMT) != S_IFCHR) {
+		fprintf(stderr, _("%s: Not a device or file: \"%s\"\n"),
+			progname, path);
+		exit(1);
+	}
+
+	if (ioctl(fd, DIOCGMEDIASIZE, &size) != 0) {
+		fprintf(stderr, _("%s: DIOCGMEDIASIZE failed on \"%s\": %s\n"),
+			progname, path, strerror(errno));
+		exit(1);
+	}
+
+	if (ioctl(fd, DIOCGSECTORSIZE, &ssize) != 0) {
+		fprintf(stderr, _("%s: "
+			"DIOCGSECTORSIZE failed on \"%s\": %s\n"),
+			progname, path, strerror(errno));
+		exit(1);
+	}
+
+	*sz = (long long) (size / ssize);
+	*bsz = (int)ssize;
+}
+
+char *
+platform_findrawpath(char *path)
+{
+	return path;
+}
+
+char *
+platform_findblockpath(char *path)
+{
+	return path;
+}
+
+int
+platform_direct_blockdev(void)
+{
+	return 0;
+}
+
+int
+platform_align_blockdev(void)
+{
+	return sizeof(void *);
+}
+
+int
+platform_nproc(void)
+{
+	int		ncpu;
+	size_t		len = sizeof(ncpu);
+	static int	mib[2] = {CTL_HW, HW_NCPU};
+
+	if (sysctl(mib, 2, &ncpu, &len, NULL, 0) < 0)
+		ncpu = 1;
+
+	return ncpu;
+}
+
+unsigned long
+platform_physmem(void)
+{
+	unsigned long	physmem;
+	size_t		len = sizeof(physmem);
+	static int	mib[2] = {CTL_HW, HW_PHYSMEM};
+
+	if (sysctl(mib, 2, &physmem, &len, NULL, 0) < 0) {
+		fprintf(stderr, _("%s: can't determine memory size\n"),
+			progname);
+		exit(1);
+	}
+	return physmem >> 10;
+}
diff --git a/libfrog/irix.c b/libfrog/irix.c
new file mode 100644
index 0000000..4ad68d5
--- /dev/null
+++ b/libfrog/irix.c
@@ -0,0 +1,115 @@
+/*
+ * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include "libxfs.h"
+#include <diskinfo.h>
+#include <sys/sysmp.h>
+
+int platform_has_uuid = 0;
+extern char *progname;
+extern int64_t findsize(char *);
+
+#warning "IRIX support is deprecated and planned for removal in July 2018"
+#warning "Contact linux-xfs@vger.kernel.org if you'd like to maintain this port"
+#error   "Remove this line if you'd like to continue the build"
+
+int
+platform_check_ismounted(char *name, char *block, struct stat *s, int verbose)
+{
+	return 0;
+}
+
+int
+platform_check_iswritable(char *name, char *block, struct stat *s)
+{
+	return 1;
+}
+
+int
+platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fatal)
+{
+	return fatal;
+}
+
+void
+platform_flush_device(int fd, dev_t device)
+{
+	return;
+}
+
+void
+platform_findsizes(char *path, int fd, long long *sz, int *bsz)
+{
+	struct stat		st;
+
+	if (fstat(fd, &st) < 0) {
+		fprintf(stderr,
+			_("%s: cannot stat the device file \"%s\": %s\n"),
+			progname, path, strerror(errno));
+		exit(1);
+	}
+	if ((st.st_mode & S_IFMT) == S_IFREG) {
+		*sz = (long long)(st.st_size >> 9);
+	} else {
+		*sz = findsize(path);
+	}
+	*bsz = BBSIZE;
+}
+
+char *
+platform_findrawpath(char *path)
+{
+	return findrawpath(path);
+}
+
+char *
+platform_findblockpath(char *path)
+{
+	return findblockpath(path);
+}
+
+int
+platform_direct_blockdev(void)
+{
+	return 0;
+}
+
+int
+platform_align_blockdev(void)
+{
+	return sizeof(void *);
+}
+
+int
+platform_nproc(void)
+{
+	return sysmp(MP_NPROCS);
+}
+
+unsigned long
+platform_physmem(void)
+{
+	struct rminfo ri;
+
+	if (sysmp(MP_SAGET, MPSA_RMINFO, &ri, sizeof(ri)) < 0)
+		fprintf(stderr, _("%s: can't determine memory size\n"),
+			progname);
+		exit(1);
+	}
+	return (ri.physmem >> 10) * getpagesize();	/* kilobytes */
+}
diff --git a/libfrog/linux.c b/libfrog/linux.c
new file mode 100644
index 0000000..0bace3e
--- /dev/null
+++ b/libfrog/linux.c
@@ -0,0 +1,265 @@
+/*
+ * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <mntent.h>
+#include <sys/stat.h>
+#include <sys/mount.h>
+#include <sys/ioctl.h>
+#include <sys/sysinfo.h>
+
+#include "libxfs_priv.h"
+#include "xfs_fs.h"
+
+int platform_has_uuid = 1;
+extern char *progname;
+static int max_block_alignment;
+
+#ifndef BLKGETSIZE64
+# define BLKGETSIZE64	_IOR(0x12,114,size_t)
+#endif
+#ifndef BLKBSZSET
+# define BLKBSZSET	_IOW(0x12,113,size_t)
+#endif
+#ifndef BLKSSZGET
+# define BLKSSZGET	_IO(0x12,104)
+#endif
+
+#ifndef RAMDISK_MAJOR
+#define RAMDISK_MAJOR	1	/* ramdisk major number */
+#endif
+
+#define PROC_MOUNTED	"/proc/mounts"
+
+/*
+ * Check if the filesystem is mounted.  Be verbose if asked, and
+ * optionally restrict check to /writable/ mounts (i.e. RO is OK)
+ */
+#define	CHECK_MOUNT_VERBOSE	0x1
+#define	CHECK_MOUNT_WRITABLE	0x2
+
+static int
+platform_check_mount(char *name, char *block, struct stat *s, int flags)
+{
+	FILE		*f;
+	struct stat	st, mst;
+	struct mntent	*mnt;
+	char		mounts[MAXPATHLEN];
+
+	if (!s) {
+		/* If either fails we are not mounted */
+		if (stat(block, &st) < 0)
+			return 0;
+		if ((st.st_mode & S_IFMT) != S_IFBLK)
+			return 0;
+		s = &st;
+	}
+
+	strcpy(mounts, (!access(PROC_MOUNTED, R_OK)) ? PROC_MOUNTED : MOUNTED);
+	if ((f = setmntent(mounts, "r")) == NULL) {
+		/* Unexpected failure, warn unconditionally */
+		fprintf(stderr,
+		    _("%s: %s possibly contains a mounted filesystem\n"),
+		    progname, name);
+		return 1;
+	}
+	while ((mnt = getmntent(f)) != NULL) {
+		if (stat(mnt->mnt_dir, &mst) < 0)
+			continue;
+		if (mst.st_dev != s->st_rdev)
+			continue;
+		/* Found our device, is RO OK? */
+		if ((flags & CHECK_MOUNT_WRITABLE) && hasmntopt(mnt, MNTOPT_RO))
+			continue;
+		else
+			break;
+	}
+	endmntent(f);
+
+	/* No mounts contained the condition we were looking for */
+	if (mnt == NULL)
+		return 0;
+
+	if (flags & CHECK_MOUNT_VERBOSE) {
+		if (flags & CHECK_MOUNT_WRITABLE) {
+			fprintf(stderr,
+_("%s: %s contains a mounted and writable filesystem\n"),
+				progname, name);
+		} else {
+			fprintf(stderr,
+_("%s: %s contains a mounted filesystem\n"),
+				progname, name);
+		}
+	}
+	return 1;
+}
+
+int
+platform_check_ismounted(char *name, char *block, struct stat *s, int verbose)
+{
+	int flags;
+
+	flags = verbose ? CHECK_MOUNT_VERBOSE : 0;
+	return platform_check_mount(name, block, s, flags);
+}
+
+int
+platform_check_iswritable(char *name, char *block, struct stat *s)
+{
+	int flags;
+
+	/* Writable checks are always verbose */
+	flags = CHECK_MOUNT_WRITABLE | CHECK_MOUNT_VERBOSE;
+	return platform_check_mount(name, block, s, flags);
+}
+
+int
+platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fatal)
+{
+	int error = 0;
+
+	if (major(device) != RAMDISK_MAJOR) {
+		if ((error = ioctl(fd, BLKBSZSET, &blocksize)) < 0) {
+			fprintf(stderr, _("%s: %s - cannot set blocksize "
+					"%d on block device %s: %s\n"),
+				progname, fatal ? "error": "warning",
+				blocksize, path, strerror(errno));
+		}
+	}
+	return error;
+}
+
+void
+platform_flush_device(int fd, dev_t device)
+{
+	struct stat	st;
+	if (major(device) == RAMDISK_MAJOR)
+		return;
+
+	if (fstat(fd, &st) < 0)
+		return;
+
+	if (S_ISREG(st.st_mode))
+		fsync(fd);
+	else
+		ioctl(fd, BLKFLSBUF, 0);
+}
+
+void
+platform_findsizes(char *path, int fd, long long *sz, int *bsz)
+{
+	struct stat	st;
+	uint64_t	size;
+	int		error;
+
+	if (fstat(fd, &st) < 0) {
+		fprintf(stderr, _("%s: "
+			"cannot stat the device file \"%s\": %s\n"),
+			progname, path, strerror(errno));
+		exit(1);
+	}
+
+	if ((st.st_mode & S_IFMT) == S_IFREG) {
+		struct dioattr	da;
+
+		*sz = (long long)(st.st_size >> 9);
+
+		if (ioctl(fd, XFS_IOC_DIOINFO, &da) < 0) {
+			/*
+			 * fall back to BBSIZE; mkfs might fail if there's a
+			 * size mismatch between the image & the host fs...
+			 */
+			*bsz = BBSIZE;
+		} else
+			*bsz = da.d_miniosz;
+
+		if (*bsz > max_block_alignment)
+			max_block_alignment = *bsz;
+		return;
+	}
+
+	error = ioctl(fd, BLKGETSIZE64, &size);
+	if (error >= 0) {
+		/* BLKGETSIZE64 returns size in bytes not 512-byte blocks */
+		*sz = (long long)(size >> 9);
+	} else {
+		/* If BLKGETSIZE64 fails, try BLKGETSIZE */
+		unsigned long tmpsize;
+
+		error = ioctl(fd, BLKGETSIZE, &tmpsize);
+		if (error < 0) {
+			fprintf(stderr, _("%s: can't determine device size\n"),
+				progname);
+			exit(1);
+		}
+		*sz = (long long)tmpsize;
+	}
+
+	if (ioctl(fd, BLKSSZGET, bsz) < 0) {
+		fprintf(stderr, _("%s: warning - cannot get sector size "
+				"from block device %s: %s\n"),
+			progname, path, strerror(errno));
+		*bsz = BBSIZE;
+	}
+	if (*bsz > max_block_alignment)
+		max_block_alignment = *bsz;
+}
+
+char *
+platform_findrawpath(char *path)
+{
+	return path;
+}
+
+char *
+platform_findblockpath(char *path)
+{
+	return path;
+}
+
+int
+platform_direct_blockdev(void)
+{
+	return 1;
+}
+
+int
+platform_align_blockdev(void)
+{
+	if (!max_block_alignment)
+		return getpagesize();
+	return max_block_alignment;
+}
+
+int
+platform_nproc(void)
+{
+	return sysconf(_SC_NPROCESSORS_ONLN);
+}
+
+unsigned long
+platform_physmem(void)
+{
+	struct sysinfo  si;
+
+	if (sysinfo(&si) < 0) {
+		fprintf(stderr, _("%s: can't determine memory size\n"),
+			progname);
+		exit(1);
+	}
+	return (si.totalram >> 10) * si.mem_unit;	/* kilobytes */
+}
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 0470f5f..7cde18d 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -97,9 +97,6 @@ CFILES = cache.c \
 	xfs_symlink_remote.c \
 	xfs_trans_resv.c
 
-CFILES += $(PKG_PLATFORM).c
-PCFILES = darwin.c freebsd.c irix.c linux.c
-LSRCFILES = $(shell echo $(PCFILES) | sed -e "s/$(PKG_PLATFORM).c//g")
 LSRCFILES += gen_crc32table.c
 
 #
diff --git a/libxfs/darwin.c b/libxfs/darwin.c
deleted file mode 100644
index 396477e..0000000
--- a/libxfs/darwin.c
+++ /dev/null
@@ -1,148 +0,0 @@
-/*
- * Copyright (c) 2003,2005 Silicon Graphics, Inc.
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
diff --git a/libxfs/freebsd.c b/libxfs/freebsd.c
deleted file mode 100644
index d9fc837..0000000
--- a/libxfs/freebsd.c
+++ /dev/null
@@ -1,205 +0,0 @@
-/*
- * Copyright (c) 2003,2005 Silicon Graphics, Inc.
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
diff --git a/libxfs/irix.c b/libxfs/irix.c
deleted file mode 100644
index 4ad68d5..0000000
--- a/libxfs/irix.c
+++ /dev/null
@@ -1,115 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
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
diff --git a/libxfs/linux.c b/libxfs/linux.c
deleted file mode 100644
index 0bace3e..0000000
--- a/libxfs/linux.c
+++ /dev/null
@@ -1,265 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
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
-#include <mntent.h>
-#include <sys/stat.h>
-#include <sys/mount.h>
-#include <sys/ioctl.h>
-#include <sys/sysinfo.h>
-
-#include "libxfs_priv.h"
-#include "xfs_fs.h"
-
-int platform_has_uuid = 1;
-extern char *progname;
-static int max_block_alignment;
-
-#ifndef BLKGETSIZE64
-# define BLKGETSIZE64	_IOR(0x12,114,size_t)
-#endif
-#ifndef BLKBSZSET
-# define BLKBSZSET	_IOW(0x12,113,size_t)
-#endif
-#ifndef BLKSSZGET
-# define BLKSSZGET	_IO(0x12,104)
-#endif
-
-#ifndef RAMDISK_MAJOR
-#define RAMDISK_MAJOR	1	/* ramdisk major number */
-#endif
-
-#define PROC_MOUNTED	"/proc/mounts"
-
-/*
- * Check if the filesystem is mounted.  Be verbose if asked, and
- * optionally restrict check to /writable/ mounts (i.e. RO is OK)
- */
-#define	CHECK_MOUNT_VERBOSE	0x1
-#define	CHECK_MOUNT_WRITABLE	0x2
-
-static int
-platform_check_mount(char *name, char *block, struct stat *s, int flags)
-{
-	FILE		*f;
-	struct stat	st, mst;
-	struct mntent	*mnt;
-	char		mounts[MAXPATHLEN];
-
-	if (!s) {
-		/* If either fails we are not mounted */
-		if (stat(block, &st) < 0)
-			return 0;
-		if ((st.st_mode & S_IFMT) != S_IFBLK)
-			return 0;
-		s = &st;
-	}
-
-	strcpy(mounts, (!access(PROC_MOUNTED, R_OK)) ? PROC_MOUNTED : MOUNTED);
-	if ((f = setmntent(mounts, "r")) == NULL) {
-		/* Unexpected failure, warn unconditionally */
-		fprintf(stderr,
-		    _("%s: %s possibly contains a mounted filesystem\n"),
-		    progname, name);
-		return 1;
-	}
-	while ((mnt = getmntent(f)) != NULL) {
-		if (stat(mnt->mnt_dir, &mst) < 0)
-			continue;
-		if (mst.st_dev != s->st_rdev)
-			continue;
-		/* Found our device, is RO OK? */
-		if ((flags & CHECK_MOUNT_WRITABLE) && hasmntopt(mnt, MNTOPT_RO))
-			continue;
-		else
-			break;
-	}
-	endmntent(f);
-
-	/* No mounts contained the condition we were looking for */
-	if (mnt == NULL)
-		return 0;
-
-	if (flags & CHECK_MOUNT_VERBOSE) {
-		if (flags & CHECK_MOUNT_WRITABLE) {
-			fprintf(stderr,
-_("%s: %s contains a mounted and writable filesystem\n"),
-				progname, name);
-		} else {
-			fprintf(stderr,
-_("%s: %s contains a mounted filesystem\n"),
-				progname, name);
-		}
-	}
-	return 1;
-}
-
-int
-platform_check_ismounted(char *name, char *block, struct stat *s, int verbose)
-{
-	int flags;
-
-	flags = verbose ? CHECK_MOUNT_VERBOSE : 0;
-	return platform_check_mount(name, block, s, flags);
-}
-
-int
-platform_check_iswritable(char *name, char *block, struct stat *s)
-{
-	int flags;
-
-	/* Writable checks are always verbose */
-	flags = CHECK_MOUNT_WRITABLE | CHECK_MOUNT_VERBOSE;
-	return platform_check_mount(name, block, s, flags);
-}
-
-int
-platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fatal)
-{
-	int error = 0;
-
-	if (major(device) != RAMDISK_MAJOR) {
-		if ((error = ioctl(fd, BLKBSZSET, &blocksize)) < 0) {
-			fprintf(stderr, _("%s: %s - cannot set blocksize "
-					"%d on block device %s: %s\n"),
-				progname, fatal ? "error": "warning",
-				blocksize, path, strerror(errno));
-		}
-	}
-	return error;
-}
-
-void
-platform_flush_device(int fd, dev_t device)
-{
-	struct stat	st;
-	if (major(device) == RAMDISK_MAJOR)
-		return;
-
-	if (fstat(fd, &st) < 0)
-		return;
-
-	if (S_ISREG(st.st_mode))
-		fsync(fd);
-	else
-		ioctl(fd, BLKFLSBUF, 0);
-}
-
-void
-platform_findsizes(char *path, int fd, long long *sz, int *bsz)
-{
-	struct stat	st;
-	uint64_t	size;
-	int		error;
-
-	if (fstat(fd, &st) < 0) {
-		fprintf(stderr, _("%s: "
-			"cannot stat the device file \"%s\": %s\n"),
-			progname, path, strerror(errno));
-		exit(1);
-	}
-
-	if ((st.st_mode & S_IFMT) == S_IFREG) {
-		struct dioattr	da;
-
-		*sz = (long long)(st.st_size >> 9);
-
-		if (ioctl(fd, XFS_IOC_DIOINFO, &da) < 0) {
-			/*
-			 * fall back to BBSIZE; mkfs might fail if there's a
-			 * size mismatch between the image & the host fs...
-			 */
-			*bsz = BBSIZE;
-		} else
-			*bsz = da.d_miniosz;
-
-		if (*bsz > max_block_alignment)
-			max_block_alignment = *bsz;
-		return;
-	}
-
-	error = ioctl(fd, BLKGETSIZE64, &size);
-	if (error >= 0) {
-		/* BLKGETSIZE64 returns size in bytes not 512-byte blocks */
-		*sz = (long long)(size >> 9);
-	} else {
-		/* If BLKGETSIZE64 fails, try BLKGETSIZE */
-		unsigned long tmpsize;
-
-		error = ioctl(fd, BLKGETSIZE, &tmpsize);
-		if (error < 0) {
-			fprintf(stderr, _("%s: can't determine device size\n"),
-				progname);
-			exit(1);
-		}
-		*sz = (long long)tmpsize;
-	}
-
-	if (ioctl(fd, BLKSSZGET, bsz) < 0) {
-		fprintf(stderr, _("%s: warning - cannot get sector size "
-				"from block device %s: %s\n"),
-			progname, path, strerror(errno));
-		*bsz = BBSIZE;
-	}
-	if (*bsz > max_block_alignment)
-		max_block_alignment = *bsz;
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
-	return 1;
-}
-
-int
-platform_align_blockdev(void)
-{
-	if (!max_block_alignment)
-		return getpagesize();
-	return max_block_alignment;
-}
-
-int
-platform_nproc(void)
-{
-	return sysconf(_SC_NPROCESSORS_ONLN);
-}
-
-unsigned long
-platform_physmem(void)
-{
-	struct sysinfo  si;
-
-	if (sysinfo(&si) < 0) {
-		fprintf(stderr, _("%s: can't determine memory size\n"),
-			progname);
-		exit(1);
-	}
-	return (si.totalram >> 10) * si.mem_unit;	/* kilobytes */
-}

