Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 73CD283AE
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:58:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D2ED2304051
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:58:16 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 1cXuD3D6ueOwdWfD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:57:58 -0700 (PDT)
Subject: [PATCH 24/24] xfs_scrub: create online filesystem scrub program
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:57:52 -0700
Message-ID: <147216947223.6398.13955653425302662945.stgit@birch.djwong.org>
In-Reply-To: <147216931783.6398.1716678878794493264.stgit@birch.djwong.org>
References: <147216931783.6398.1716678878794493264.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Create a filesystem scrubbing tool that walks the directory tree,
queries every file's extents, extended attributes, and stat data.  For
generic (non-XFS) filesystems this depends on the kernel to do nearly
all the validation.  Optionally, we can (try to) read all the file
data.

For XFS, we perform sequential scans of each AG's metadata, inodes,
extent maps, and file data.  Being XFS specific, we can work with
the in-kernel scrubbers to perform much stronger
metadata checking and cross-referencing.  We can also take advantage
of newer ioctls such as GETFSMAP to perform faster read verification.

In the future we will be able to take advantage of (still unwritten)
features such as parent directory pointers to fully validate all
metadata.  However, this tool /should/ work for most non-XFS
filesystems such as ext4 and btrfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 Makefile              |    3 
 configure.ac          |   11 
 include/builddefs.in  |   11 
 m4/Makefile           |    1 
 m4/package_attrdev.m4 |   29 +
 m4/package_libcdev.m4 |  111 ++
 man/man8/xfs_scrub.8  |   96 ++
 scrub/Makefile        |   43 +
 scrub/disk.c          |  234 +++++
 scrub/disk.h          |   42 +
 scrub/extent.c        |  383 ++++++++
 scrub/extent.h        |   53 +
 scrub/generic.c       | 1057 +++++++++++++++++++++++
 scrub/iocmd.c         |  342 +++++++
 scrub/iocmd.h         |   46 +
 scrub/non_xfs.c       |  122 +++
 scrub/read_verify.c   |  182 ++++
 scrub/read_verify.h   |   58 +
 scrub/scrub.c         |  698 +++++++++++++++
 scrub/scrub.h         |  147 +++
 scrub/xfs.c           | 2272 +++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/xfs_ioctl.c     |  465 ++++++++++
 scrub/xfs_ioctl.h     |   89 ++
 23 files changed, 6494 insertions(+), 1 deletion(-)
 create mode 100644 m4/package_attrdev.m4
 create mode 100644 man/man8/xfs_scrub.8
 create mode 100644 scrub/Makefile
 create mode 100644 scrub/disk.c
 create mode 100644 scrub/disk.h
 create mode 100644 scrub/extent.c
 create mode 100644 scrub/extent.h
 create mode 100644 scrub/generic.c
 create mode 100644 scrub/iocmd.c
 create mode 100644 scrub/iocmd.h
 create mode 100644 scrub/non_xfs.c
 create mode 100644 scrub/read_verify.c
 create mode 100644 scrub/read_verify.h
 create mode 100644 scrub/scrub.c
 create mode 100644 scrub/scrub.h
 create mode 100644 scrub/xfs.c
 create mode 100644 scrub/xfs_ioctl.c
 create mode 100644 scrub/xfs_ioctl.h


diff --git a/Makefile b/Makefile
index 7bdc670..70c1cab 100644
--- a/Makefile
+++ b/Makefile
@@ -46,7 +46,7 @@ HDR_SUBDIRS = include libxfs
 DLIB_SUBDIRS = libxlog libxcmd libhandle
 LIB_SUBDIRS = libxfs $(DLIB_SUBDIRS)
 TOOL_SUBDIRS = copy db estimate fsck fsr growfs io logprint mkfs quota \
-		mdrestore repair rtcp m4 man doc debian
+		mdrestore repair rtcp m4 man doc debian scrub
 
 ifneq ("$(XGETTEXT)","")
 TOOL_SUBDIRS += po
@@ -83,6 +83,7 @@ quota: libxcmd
 repair: libxlog libxcmd
 copy: libxlog
 mkfs: libxcmd
+scrub: libhandle libxcmd repair
 
 ifeq ($(HAVE_BUILDDEFS), yes)
 include $(BUILDRULES)
diff --git a/configure.ac b/configure.ac
index 875d4bb..86d8304 100644
--- a/configure.ac
+++ b/configure.ac
@@ -133,8 +133,19 @@ AC_HAVE_MNTENT
 AC_HAVE_FLS
 AC_HAVE_READDIR
 AC_HAVE_FSETXATTR
+AC_HAVE_FGETXATTR
+AC_HAVE_FLISTXATTR
+AC_HAVE_LLISTXATTR
 AC_HAVE_MREMAP
 AC_HAVE_FSXATTR_COWEXTSIZE
+AC_HAVE_MALLINFO
+AC_HAVE_SG_IO
+AC_HAVE_ATTRIBUTES_H
+AC_HAVE_ATTRIBUTES_MACROS
+AC_HAVE_ATTRIBUTES_STRUCTS
+AC_HAVE_OPENAT
+AC_HAVE_READLINKAT
+AC_HAVE_SYNCFS
 
 if test "$enable_blkid" = yes; then
 AC_HAVE_BLKID_TOPO
diff --git a/include/builddefs.in b/include/builddefs.in
index 165fa78..f480658 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -108,9 +108,20 @@ HAVE_READDIR = @have_readdir@
 HAVE_MNTENT = @have_mntent@
 HAVE_FLS = @have_fls@
 HAVE_FSETXATTR = @have_fsetxattr@
+HAVE_FGETXATTR = @have_fgetxattr@
+HAVE_FLISTXATTR = @have_flistxattr@
+HAVE_LLISTXATTR = @have_llistxattr@
 HAVE_MREMAP = @have_mremap@
 HAVE_FSXATTR_COWEXTSIZE = @have_fsxattr_cowextsize@
 ENABLE_INTERNAL_FSXATTR = @enable_internal_fsxattr@
+HAVE_MALLINFO = @have_mallinfo@
+HAVE_SG_IO = @have_sg_io@
+HAVE_ATTRIBUTES_H = @have_attributes_h@
+HAVE_ATTRIBUTES_MACROS = @have_attributes_macros@
+HAVE_ATTRIBUTES_STRUCTS = @have_attributes_structs@
+HAVE_OPENAT = @have_openat@
+HAVE_READLINKAT = @have_readlinkat@
+HAVE_SYNCFS = @have_syncfs@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/m4/Makefile b/m4/Makefile
index d282f0a..0c73f35 100644
--- a/m4/Makefile
+++ b/m4/Makefile
@@ -14,6 +14,7 @@ CONFIGURE = \
 
 LSRCFILES = \
 	manual_format.m4 \
+	package_attrdev.m4 \
 	package_blkid.m4 \
 	package_globals.m4 \
 	package_libcdev.m4 \
diff --git a/m4/package_attrdev.m4 b/m4/package_attrdev.m4
new file mode 100644
index 0000000..eb0e35b
--- /dev/null
+++ b/m4/package_attrdev.m4
@@ -0,0 +1,29 @@
+AC_DEFUN([AC_HAVE_ATTRIBUTES_H],
+  [ AC_CHECK_HEADERS(attr/attributes.h, [have_attributes_h=yes])
+    AC_SUBST(have_attributes_h)
+    if test "$have_attributes_h" != "yes"; then
+        echo
+        echo 'WARNING: attr/attributes.h does not exist.'
+        echo 'Install the extended attributes (attr) development package.'
+        echo 'Alternatively, run "make install-dev" from the attr source.'
+        echo
+    fi
+  ])
+
+AC_DEFUN([AC_HAVE_ATTRIBUTES_STRUCTS],
+  [ AC_CHECK_TYPES([struct attrlist_cursor, struct attr_multiop, struct attrlist_ent],
+    [have_attributes_structs=yes],,
+    [
+#include <sys/types.h>
+#include <attr/attributes.h>] )
+    AC_SUBST(have_attributes_structs)
+  ])
+
+AC_DEFUN([AC_HAVE_ATTRIBUTES_MACROS],
+  [ AC_TRY_LINK([
+#include <sys/types.h>
+#include <attr/attributes.h>],
+    [ int x = ATTR_SECURE; int y = ATTR_ROOT; int z = ATTR_TRUST; ATTR_ENTRY(0, 0); ],
+    [have_attributes_macros=yes])
+    AC_SUBST(have_attributes_macros)
+  ])
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 45954c2..744f826 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -245,6 +245,45 @@ AC_DEFUN([AC_HAVE_FSETXATTR],
   ])
 
 #
+# Check if we have a fgetxattr call (Mac OS X)
+#
+AC_DEFUN([AC_HAVE_FGETXATTR],
+  [ AC_CHECK_DECL([fgetxattr],
+       have_fgetxattr=yes,
+       [],
+       [#include <sys/types.h>
+        #include <attr/xattr.h>]
+       )
+    AC_SUBST(have_fgetxattr)
+  ])
+
+#
+# Check if we have a flistxattr call (Mac OS X)
+#
+AC_DEFUN([AC_HAVE_FLISTXATTR],
+  [ AC_CHECK_DECL([flistxattr],
+       have_flistxattr=yes,
+       [],
+       [#include <sys/types.h>
+        #include <attr/xattr.h>]
+       )
+    AC_SUBST(have_flistxattr)
+  ])
+
+#
+# Check if we have a llistxattr call (Mac OS X)
+#
+AC_DEFUN([AC_HAVE_LLISTXATTR],
+  [ AC_CHECK_DECL([llistxattr],
+       have_llistxattr=yes,
+       [],
+       [#include <sys/types.h>
+        #include <attr/xattr.h>]
+       )
+    AC_SUBST(have_llistxattr)
+  ])
+
+#
 # Check if there is mntent.h
 #
 AC_DEFUN([AC_HAVE_MNTENT],
@@ -291,3 +330,75 @@ AC_DEFUN([AC_HAVE_FSXATTR_COWEXTSIZE],
     ])
     AC_SUBST(have_fsxattr_cowextsize)
   ])
+
+#
+# Check if we have a mallinfo libc call
+#
+AC_DEFUN([AC_HAVE_MALLINFO],
+  [ AC_MSG_CHECKING([for mallinfo ])
+    AC_TRY_COMPILE([
+#include <malloc.h>
+    ], [
+         struct mallinfo test;
+
+         test.arena = 0; test.hblkhd = 0; test.uordblks = 0; test.fordblks = 0;
+         test = mallinfo();
+    ], have_mallinfo=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_mallinfo)
+  ])
+
+#
+# Check if we have the SG_IO ioctl
+#
+AC_DEFUN([AC_HAVE_SG_IO],
+  [ AC_MSG_CHECKING([for struct sg_io_hdr ])
+    AC_TRY_COMPILE([#include <scsi/sg.h>],
+    [
+         struct sg_io_hdr hdr;
+         ioctl(0, SG_IO, &hdr);
+    ], have_sg_io=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_sg_io)
+  ])
+
+#
+# Check if we have a openat call
+#
+AC_DEFUN([AC_HAVE_OPENAT],
+  [ AC_CHECK_DECL([openat],
+       have_openat=yes,
+       [],
+       [#include <sys/types.h>
+        #include <sys/stat.h>
+        #include <fcntl.h>]
+       )
+    AC_SUBST(have_openat)
+  ])
+
+#
+# Check if we have a readlinkat call
+#
+AC_DEFUN([AC_HAVE_READLINKAT],
+  [ AC_CHECK_DECL([readlinkat],
+       have_readlinkat=yes,
+       [],
+       [#include <unistd.h>
+        #include <fcntl.h>]
+       )
+    AC_SUBST(have_readlinkat)
+  ])
+
+#
+# Check if we have a syncfs call
+#
+AC_DEFUN([AC_HAVE_SYNCFS],
+  [ AC_CHECK_DECL([syncfs],
+       have_syncfs=yes,
+       [],
+       [#define _GNU_SOURCE
+       #include <unistd.h>])
+    AC_SUBST(have_syncfs)
+  ])
diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
new file mode 100644
index 0000000..08c70df
--- /dev/null
+++ b/man/man8/xfs_scrub.8
@@ -0,0 +1,96 @@
+.TH xfs_scrub 8
+.SH NAME
+xfs_scrub \- scrub the contents of an XFS filesystem
+.SH SYNOPSIS
+.B xfs_scrub
+[
+.B \-dvx
+] [
+.B \-t
+.I fstype
+]
+.I mountpoint
+.br
+.B xfs_scrub \-V
+.SH DESCRIPTION
+.B xfs_scrub
+attempts to read and check all the metadata in a Linux filesystem.
+.PP
+If
+.B xfs_scrub
+does not detect an XFS filesystem, it will use a generic backend to
+scrub the filesystem.
+This involves walking the directory tree, querying the data and
+extended attribute extent maps, performing limited checks of directory
+and inode data, reading all of an inode's extended attributes,
+optionally reading all data in a file, and comparing the number of
+blocks and inodes seen against the reported counters.
+.PP
+If an XFS filesystem is detected, then
+.B xfs_scrub
+will use private XFS ioctls to perform more rigorous scrubbing of the
+internal metadata.
+Currently this is limited to asking the kernel to check the per-AG
+btrees, inode data, and realtime metadata.
+The in-kernel scrubbers also cross-reference each data structure's
+records against the other filesystem metadata.
+.SH OPTIONS
+.TP
+.B \-d
+Enable debugging mode, which augments error reports with the exact file
+and line where the scrub failure occurred.
+This also enables verbose mode.
+.TP
+.B \-v
+Enable verbose mode, which prints periodic status updates.
+.TP
+.BI \-T
+Print timing and memory usage information for each phase.
+.TP
+.BI \-t " fstype"
+Force the use of a particular type of filesystem scrubber.  Currently
+supported backends are the
+.IR xfs , " ext4" , " ext3", " ext2", " btrfs" ", and " generic
+scrubbers.
+.TP
+.B \-V
+Prints the version number and exits.
+.TP
+.B \-x
+Scrub file data.  This reads every block of every file on disk.
+If the filesystem reports file extent mappings or physical extent
+mappings and is backed by a block device,
+.B xfs_scrub
+will issue O_DIRECT reads to the block device directly.
+If the block device is a SCSI disk, it will issue READ VERIFY commands
+directly to the disk.
+.SH EXIT CODE
+The exit code returned by
+.B xfs_scrub
+is the sum of the following conditions:
+.br
+\	0\	\-\ No errors
+.br
+\	4\	\-\ File system errors left uncorrected
+.br
+\	8\	\-\ Operational error
+.br
+\	16\	\-\ Usage or syntax error
+.br
+.SH CAVEATS
+.B xfs_scrub
+is an immature utility!
+The generic scrub backend walks the directory tree, reads file extents
+and data, and queries every extended attribute it can find.
+The generic scrub does not grab exclusive locks on the objects it is
+examining, nor does it have any way to cross-reference what it sees
+against the internal filesystem metadata.
+.PP
+The XFS backend takes advantage of in-kernel scrubbing to verify a
+given data structure with locks held.
+This can tie up the system for a while.
+.PP
+If errors are found, the filesystem should be taken offline and
+repaired.
+.SH SEE ALSO
+.BR xfs_repair (8).
diff --git a/scrub/Makefile b/scrub/Makefile
new file mode 100644
index 0000000..3058f3d
--- /dev/null
+++ b/scrub/Makefile
@@ -0,0 +1,43 @@
+#
+# Copyright (c) 2016 Oracle.  All Rights Reserved.
+#
+
+TOPDIR = ..
+include $(TOPDIR)/include/builddefs
+
+SCRUB_PREREQS=$(HAVE_FIEMAP)$(HAVE_ATTRIBUTES_H)$(HAVE_ATTRIBUTES_MACROS)$(HAVE_ATTRIBUTES_STRUCTS)$(HAVE_FGETXATTR)$(HAVE_FLISTXATTR)$(HAVE_LLISTXATTR)$(HAVE_OPENAT)$(HAVE_READLINKAT)
+
+ifeq ($(SCRUB_PREREQS),yesyesyesyesyesyesyesyesyes)
+LTCOMMAND = xfs_scrub
+endif
+
+HFILES = scrub.h ../repair/threads.h xfs_ioctl.h read_verify.h iocmd.h
+CFILES = ../repair/avl64.c disk.c extent.c generic.c iocmd.c non_xfs.c \
+	 read_verify.c scrub.c ../repair/threads.c xfs.c xfs_ioctl.c
+
+LLDLIBS += $(LIBBLKID) $(LIBXFS) $(LIBXCMD) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) $(LIBHANDLE)
+LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD) $(LIBHANDLE)
+LLDFLAGS = -static-libtool-libs
+
+ifeq ($(HAVE_MALLINFO),yes)
+LCFLAGS += -DHAVE_MALLINFO
+endif
+
+ifeq ($(HAVE_SG_IO),yes)
+LCFLAGS += -DHAVE_SG_IO
+endif
+
+ifeq ($(HAVE_SYNCFS),yes)
+LCFLAGS += -DHAVE_SYNCFS
+endif
+
+default: depend $(LTCOMMAND)
+
+include $(BUILDRULES)
+
+install: default
+	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
+install-dev:
+
+-include .dep
diff --git a/scrub/disk.c b/scrub/disk.c
new file mode 100644
index 0000000..0920235
--- /dev/null
+++ b/scrub/disk.c
@@ -0,0 +1,234 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "libxfs.h"
+#include <sys/statvfs.h>
+#include <sys/types.h>
+#include <dirent.h>
+#ifdef HAVE_SG_IO
+# include <scsi/sg.h>
+#endif
+#include "disk.h"
+#include "scrub.h"
+
+/* Figure out how many disk heads are available. */
+unsigned int
+disk_heads(
+	struct disk		*disk)
+{
+	int			iomin;
+	int			ioopt;
+	unsigned short		rot;
+	int			error;
+
+	if (getenv("XFS_SCRUB_NO_THREADS"))
+		return 1;
+
+	/* If it's not a block device, throw all the CPUs at it. */
+	if (!S_ISBLK(disk->d_sb.st_mode))
+		return libxfs_nproc();
+
+	/* Non-rotational device?  Throw all the CPUs. */
+	rot = 1;
+	error = ioctl(disk->d_fd, BLKROTATIONAL, &rot);
+	if (error == 0 && rot == 0)
+		return libxfs_nproc();
+
+	/*
+	 * Sometimes we can infer the number of devices from the
+	 * min/optimal IO sizes.
+	 */
+	iomin = ioopt = 0;
+	if (ioctl(disk->d_fd, BLKIOMIN, &iomin) == 0 &&
+	    ioctl(disk->d_fd, BLKIOOPT, &ioopt) == 0 &&
+            iomin > 0 && ioopt > 0) {
+		return ioopt / iomin;
+	}
+
+	/* Rotating device?  I guess? */
+	return libxfs_nproc() / 2;
+}
+
+/* Execute a SCSI VERIFY(16).  We hope. */
+#ifdef HAVE_SG_IO
+# define SENSE_BUF_LEN		64
+# define VERIFY16_CMDLEN	16
+# define VERIFY16_CMD		0x8F
+
+# ifndef SG_FLAG_Q_AT_TAIL
+#  define SG_FLAG_Q_AT_TAIL	0x10
+# endif
+int
+disk_scsi_verify(
+	int			fd,
+	uint64_t		startblock, /* lba */
+	uint64_t		blockcount) /* lba */
+{
+	struct sg_io_hdr	iohdr;
+	unsigned char		cdb[VERIFY16_CMDLEN];
+	unsigned char		sense[SENSE_BUF_LEN];
+	uint64_t		llba = startblock;
+	uint64_t		veri_len = blockcount;
+	int			error;
+
+	/* Borrowed from sg_verify */
+	cdb[0] = VERIFY16_CMD;
+	cdb[1] = 0; /* skip PI, DPO, and byte check. */
+	cdb[2] = (llba >> 56) & 0xff;
+	cdb[3] = (llba >> 48) & 0xff;
+	cdb[4] = (llba >> 40) & 0xff;
+	cdb[5] = (llba >> 32) & 0xff;
+	cdb[6] = (llba >> 24) & 0xff;
+	cdb[7] = (llba >> 16) & 0xff;
+	cdb[8] = (llba >> 8) & 0xff;
+	cdb[9] = llba & 0xff;
+	cdb[10] = (veri_len >> 24) & 0xff;
+	cdb[11] = (veri_len >> 16) & 0xff;
+	cdb[12] = (veri_len >> 8) & 0xff;
+	cdb[13] = veri_len & 0xff;
+	cdb[14] = 0;
+	cdb[15] = 0;
+	memset(sense, 0, SENSE_BUF_LEN);
+
+	/* v3 SG_IO */
+	memset(&iohdr, 0, sizeof(iohdr));
+	iohdr.interface_id = 'S';
+	iohdr.dxfer_direction = SG_DXFER_NONE;
+	iohdr.cmdp = cdb;
+	iohdr.cmd_len = VERIFY16_CMDLEN;
+	iohdr.sbp = sense;
+	iohdr.mx_sb_len = SENSE_BUF_LEN;
+	iohdr.flags |= SG_FLAG_Q_AT_TAIL;
+	iohdr.timeout = 30000; /* 30s */
+
+	error = ioctl(fd, SG_IO, &iohdr);
+	if (error)
+		return error;
+
+	dbg_printf("VERIFY(16) fd %d lba %"PRIu64" len %"PRIu64" info %x "
+			"status %d masked %d msg %d host %d driver %d "
+			"duration %d resid %d\n",
+			fd, startblock, blockcount, iohdr.info,
+			iohdr.status, iohdr.masked_status, iohdr.msg_status,
+			iohdr.host_status, iohdr.driver_status, iohdr.duration,
+			iohdr.resid);
+
+	if (iohdr.info & SG_INFO_CHECK) {
+		errno = EIO;
+		return -1;
+	}
+
+	return error;
+}
+#else
+# define disk_scsi_verify(...)		(ENOTTY)
+#endif /* HAVE_SG_IO */
+
+/* Test the availability of the kernel scrub ioctl. */
+bool
+disk_can_scsi_verify(
+	int				fd)
+{
+	int				error;
+
+	if (getenv("XFS_SCRUB_NO_SCSI_VERIFY"))
+		return false;
+
+	error = disk_scsi_verify(fd, 0, 1);
+	return error == 0;
+}
+
+/* Open a disk device and discover its geometry. */
+int
+disk_open(
+	const char		*pathname,
+	struct disk		*disk)
+{
+	int			lba_sz;
+	int			error;
+
+	disk->d_fd = open(pathname, O_RDONLY | O_DIRECT | O_NOATIME);
+	if (disk->d_fd < 0)
+		return -1;
+	error = ioctl(disk->d_fd, BLKSSZGET, &lba_sz);
+	if (error)
+		lba_sz = 512;
+	disk->d_lbalog = libxfs_log2_roundup(lba_sz);
+	if (disk_can_scsi_verify(disk->d_fd))
+		disk->d_flags |= DISK_FLAG_SCSI_VERIFY;
+	error = fstat64(disk->d_fd, &disk->d_sb);
+	if (error == 0) {
+		if (S_ISBLK(disk->d_sb.st_mode)) {
+			error = ioctl(disk->d_fd, BLKGETSIZE64,
+					&disk->d_nrsectors);
+			if (error)
+				disk->d_nrsectors = 0;
+		} else
+			disk->d_nrsectors = disk->d_sb.st_size >> BBSHIFT;
+	} else {
+		error = errno;
+		close(disk->d_fd);
+		errno = error;
+		disk->d_fd = -1;
+		return -1;
+	}
+	return 0;
+}
+
+/* Close a disk device. */
+int
+disk_close(
+	struct disk		*disk)
+{
+	int			error = 0;
+
+	if (disk->d_fd >= 0)
+		error = close(disk->d_fd);
+	disk->d_fd = -1;
+	return error;
+}
+
+/* Is this device open? */
+bool
+disk_is_open(
+	struct disk		*disk)
+{
+	return disk->d_fd >= 0;
+}
+
+/* Read-verify an extent of a disk device. */
+ssize_t
+disk_read_verify(
+	struct disk		*disk,
+	void			*buf,
+	uint64_t		startblock,
+	uint64_t		blockcount)
+{
+	uint64_t		end = startblock + blockcount;
+
+	/* Convert to logical block size. */
+	startblock = startblock >> (disk->d_lbalog - BBSHIFT);
+	end = end >> (disk->d_lbalog - BBSHIFT);
+	blockcount = end - startblock;
+	if (disk->d_flags & DISK_FLAG_SCSI_VERIFY)
+		return disk_scsi_verify(disk->d_fd, startblock, blockcount);
+
+	return pread64(disk->d_fd, buf, blockcount << disk->d_lbalog,
+			startblock << disk->d_lbalog);
+}
diff --git a/scrub/disk.h b/scrub/disk.h
new file mode 100644
index 0000000..986b83a
--- /dev/null
+++ b/scrub/disk.h
@@ -0,0 +1,42 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#ifndef DISK_H_
+#define DISK_H_
+
+#define DISK_FLAG_SCSI_VERIFY	0x1
+struct disk {
+	struct stat64	d_sb;
+	int		d_fd;
+	int		d_lbalog;
+	unsigned int	d_flags;
+	uint64_t	d_nrsectors; /* 512b */
+};
+
+int disk_scsi_verify(int fd, uint64_t startblock, uint64_t len);
+bool disk_can_scsi_verify(int fd);
+
+unsigned int disk_heads(struct disk *disk);
+bool disk_is_open(struct disk *disk);
+int disk_open(const char *pathname, struct disk *disk);
+int disk_close(struct disk *disk);
+ssize_t disk_read_verify(struct disk *disk, void *buf, uint64_t startblock,
+		uint64_t blockcount);
+
+#endif /* DISK_H_ */
diff --git a/scrub/extent.c b/scrub/extent.c
new file mode 100644
index 0000000..5d110fb
--- /dev/null
+++ b/scrub/extent.c
@@ -0,0 +1,383 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "libxfs.h"
+#include "../repair/avl64.h"
+#include "extent.h"
+
+struct extent_tree_node {
+	struct avl64node	etn_node;
+	uint64_t		etn_start;
+	uint64_t		etn_length;
+};
+
+static __uint64_t
+extent_start(
+	struct avl64node	*node)
+{
+	struct extent_tree_node	*etn;
+
+	etn = container_of(node, struct extent_tree_node, etn_node);
+	return etn->etn_start;
+}
+
+static __uint64_t
+extent_end(
+	struct avl64node	*node)
+{
+	struct extent_tree_node	*etn;
+
+	etn = container_of(node, struct extent_tree_node, etn_node);
+	return etn->etn_start + etn->etn_length;
+}
+
+static struct avl64ops extent_tree_ops = {
+	extent_start,
+	extent_end,
+};
+
+/* Initialize an extent tree. */
+bool
+extent_tree_init(
+	struct extent_tree		*tree)
+{
+	tree->et_tree = malloc(sizeof(struct avl64tree_desc));
+	if (!tree)
+		return false;
+
+	pthread_mutex_init(&tree->et_lock, NULL);
+	avl64_init_tree(tree->et_tree, &extent_tree_ops);
+
+	return true;
+}
+
+/* Free an extent tree. */
+void
+extent_tree_free(
+	struct extent_tree		*tree)
+{
+	struct avl64node		*node;
+	struct avl64node		*n;
+	struct extent_tree_node		*ext;
+
+	if (!tree->et_tree)
+		return;
+
+	avl_for_each_safe(tree->et_tree, node, n) {
+		ext = container_of(node, struct extent_tree_node, etn_node);
+		free(ext);
+	}
+	free(tree->et_tree);
+	tree->et_tree = NULL;
+}
+
+/* Create a new extent. */
+static struct extent_tree_node *
+extent_tree_node_init(
+	uint64_t		start,
+	uint64_t		len)
+{
+	struct extent_tree_node	*ext;
+
+	ext = malloc(sizeof(struct extent_tree_node));
+	if (!ext)
+		return NULL;
+
+	ext->etn_node.avl_nextino = NULL;
+	ext->etn_start = start;
+	ext->etn_length = len;
+
+	return ext;
+}
+
+/* Add an extent. */
+static bool
+__extent_tree_add(
+	struct extent_tree		*tree,
+	uint64_t			start,
+	uint64_t			length)
+{
+	struct avl64node		*firstn;
+	struct avl64node		*lastn;
+	struct avl64node		*pos;
+	struct avl64node		*n;
+	struct avl64node		*l;
+	struct extent_tree_node		*ext;
+	uint64_t			new_start;
+	uint64_t			new_length;
+	struct avl64node		*node;
+	bool				res = true;
+
+	/* Find any existing nodes over that range. */
+	avl64_findranges(tree->et_tree, start - 1, start + length,
+			&firstn, &lastn);
+
+	/* Nothing, just insert a new extent. */
+	if (firstn == NULL && lastn == NULL) {
+		ext = extent_tree_node_init(start, length);
+		if (!ext)
+			return false;
+
+		node = avl64_insert(tree->et_tree, &ext->etn_node);
+		if (node == NULL) {
+			free(ext);
+			errno = EEXIST;
+			return false;
+		}
+
+		return true;
+	}
+
+	ASSERT(firstn != NULL && lastn != NULL);
+	new_start = start;
+	new_length = length;
+
+	avl_for_each_range_safe(pos, n, l, firstn, lastn) {
+		ext = container_of(pos, struct extent_tree_node, etn_node);
+
+		/* Bail if the new extent is contained within an old one. */
+		if (ext->etn_start <= start && ext->etn_length >= length)
+			return res;
+
+		/* Check for overlapping and adjacent extents. */
+		if (ext->etn_start + ext->etn_length >= start ||
+		    ext->etn_start <= start + length) {
+			if (ext->etn_start < start)
+				new_start = ext->etn_start;
+
+			if (ext->etn_start + ext->etn_length >
+			    new_start + new_length)
+				new_length = ext->etn_start + ext->etn_length -
+						new_start;
+
+			avl64_delete(tree->et_tree, pos);
+			free(ext);
+		}
+	}
+
+	ext = extent_tree_node_init(new_start, new_length);
+	if (!ext)
+		return false;
+
+	node = avl64_insert(tree->et_tree, &ext->etn_node);
+	if (node == NULL) {
+		free(ext);
+		errno = EEXIST;
+		return false;
+	}
+
+	return res;
+}
+
+/* Add an extent. */
+bool
+extent_tree_add(
+	struct extent_tree		*tree,
+	uint64_t			start,
+	uint64_t			length)
+{
+	bool				res;
+
+	pthread_mutex_lock(&tree->et_lock);
+	res = __extent_tree_add(tree, start, length);
+	pthread_mutex_unlock(&tree->et_lock);
+
+	return res;
+}
+
+/* Remove an extent. */
+bool
+extent_tree_remove(
+	struct extent_tree		*tree,
+	uint64_t			start,
+	uint64_t			len)
+{
+	struct avl64node		*firstn;
+	struct avl64node		*lastn;
+	struct avl64node		*pos;
+	struct avl64node		*n;
+	struct avl64node		*l;
+	struct extent_tree_node		*ext;
+	uint64_t			new_start;
+	uint64_t			new_length;
+	struct avl64node		*node;
+	int				stat;
+
+	pthread_mutex_lock(&tree->et_lock);
+	/* Find any existing nodes over that range. */
+	avl64_findranges(tree->et_tree, start - 1, start + len - 1,
+			&firstn, &lastn);
+
+	/* Nothing, we're done. */
+	if (firstn == NULL && lastn == NULL) {
+		pthread_mutex_unlock(&tree->et_lock);
+		return true;
+	}
+
+	ASSERT(firstn != NULL && lastn != NULL);
+
+	/* Delete or truncate everything in sight. */
+	avl_for_each_range_safe(pos, n, l, firstn, lastn) {
+		ext = container_of(pos, struct extent_tree_node, etn_node);
+
+		stat = 0;
+		if (ext->etn_start < start)
+			stat |= 1;
+		if (ext->etn_start + ext->etn_length > start + len)
+			stat |= 2;
+		switch (stat) {
+		case 0:
+			/* Extent totally within range; delete. */
+			avl64_delete(tree->et_tree, pos);
+			free(ext);
+			break;
+		case 1:
+			/* Extent is left-adjacent; truncate. */
+			ext->etn_length = start - ext->etn_start;
+			break;
+		case 2:
+			/* Extent is right-adjacent; move it. */
+			ext->etn_length = ext->etn_start + ext->etn_length -
+					(start + len);
+			ext->etn_start = start + len;
+			break;
+		case 3:
+			/* Extent overlaps both ends. */
+			ext->etn_length = start - ext->etn_start;
+			new_start = start + len;
+			new_length = ext->etn_start + ext->etn_length -
+					new_start;
+
+			ext = extent_tree_node_init(new_start, new_length);
+			if (!ext)
+				return false;
+
+			node = avl64_insert(tree->et_tree, &ext->etn_node);
+			if (node == NULL) {
+				errno = EEXIST;
+				return false;
+			}
+			break;
+		}
+	}
+
+	pthread_mutex_unlock(&tree->et_lock);
+	return true;
+}
+
+/* Iterate an extent tree. */
+bool
+extent_tree_iterate(
+	struct extent_tree		*tree,
+	bool				(*fn)(uint64_t, uint64_t, void *),
+	void				*arg)
+{
+	struct avl64node		*node;
+	struct extent_tree_node		*ext;
+	bool				moveon = true;
+
+	pthread_mutex_lock(&tree->et_lock);
+	avl_for_each(tree->et_tree, node) {
+		ext = container_of(node, struct extent_tree_node, etn_node);
+		moveon = fn(ext->etn_start, ext->etn_length, arg);
+		if (!moveon)
+			break;
+	}
+	pthread_mutex_unlock(&tree->et_lock);
+
+	return moveon;
+}
+
+/* Do any extents overlap the given one? */
+bool
+extent_tree_has_extent(
+	struct extent_tree		*tree,
+	uint64_t			start,
+	uint64_t			len)
+{
+	struct avl64node		*firstn;
+	struct avl64node		*lastn;
+	bool				res;
+
+	pthread_mutex_lock(&tree->et_lock);
+	/* Find any existing nodes over that range. */
+	avl64_findranges(tree->et_tree, start - 1, start + len - 1,
+			&firstn, &lastn);
+
+	res = firstn != NULL && lastn != NULL;
+	pthread_mutex_unlock(&tree->et_lock);
+
+	return res;
+}
+
+/* Is it empty? */
+bool
+extent_tree_empty(
+	struct extent_tree		*tree)
+{
+	return tree->et_tree->avl_firstino == NULL;
+}
+
+static bool
+merge_helper(
+	uint64_t			start,
+	uint64_t			length,
+	void				*arg)
+{
+	struct extent_tree		*thistree = arg;
+
+	return __extent_tree_add(thistree, start, length);
+}
+
+/* Merge another tree with this one. */
+bool
+extent_tree_merge(
+	struct extent_tree		*thistree,
+	struct extent_tree		*tree)
+{
+	bool				res;
+
+	assert(thistree != tree);
+
+	pthread_mutex_lock(&thistree->et_lock);
+	res = extent_tree_iterate(tree, merge_helper, thistree);
+	pthread_mutex_unlock(&thistree->et_lock);
+
+	return res;
+}
+
+static bool
+extent_tree_dump_fn(
+	uint64_t			startblock,
+	uint64_t			blockcount,
+	void				*arg)
+{
+	printf("%"PRIu64":%"PRIu64"\n", startblock, blockcount);
+	return true;
+}
+
+/* Dump extent tree. */
+void
+extent_tree_dump(
+	struct extent_tree		*tree)
+{
+	printf("EXTENT TREE %p\n", tree);
+	extent_tree_iterate(tree, extent_tree_dump_fn, NULL);
+	printf("EXTENT DUMP DONE\n");
+}
diff --git a/scrub/extent.h b/scrub/extent.h
new file mode 100644
index 0000000..6d35a38
--- /dev/null
+++ b/scrub/extent.h
@@ -0,0 +1,53 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#ifndef EXTENT_H_
+#define EXTENT_H_
+
+struct extent_tree {
+	pthread_mutex_t			et_lock;
+	struct avl64tree_desc		*et_tree;
+};
+
+#define avl_for_each_range_safe(pos, n, l, first, last) \
+	for (pos = (first), n = pos->avl_nextino, l = (last)->avl_nextino; pos != (l); \
+			pos = n, n = pos ? pos->avl_nextino : NULL)
+
+#define avl_for_each_safe(tree, pos, n) \
+	for (pos = (tree)->avl_firstino, n = pos ? pos->avl_nextino : NULL; \
+			pos != NULL; \
+			pos = n, n = pos ? pos->avl_nextino : NULL)
+
+#define avl_for_each(tree, pos) \
+	for (pos = (tree)->avl_firstino; pos != NULL; pos = pos->avl_nextino)
+
+bool extent_tree_init(struct extent_tree *tree);
+void extent_tree_free(struct extent_tree *tree);
+bool extent_tree_add(struct extent_tree *tree, uint64_t start, uint64_t length);
+bool extent_tree_remove(struct extent_tree *tree, uint64_t start,
+		uint64_t len);
+bool extent_tree_iterate(struct extent_tree *tree,
+		bool (*fn)(uint64_t, uint64_t, void *), void *arg);
+bool extent_tree_has_extent(struct extent_tree *tree, uint64_t start,
+		uint64_t len);
+bool extent_tree_empty(struct extent_tree *tree);
+bool extent_tree_merge(struct extent_tree *thistree, struct extent_tree *tree);
+void extent_tree_dump(struct extent_tree *tree);
+
+#endif /* EXTENT_H_ */
diff --git a/scrub/generic.c b/scrub/generic.c
new file mode 100644
index 0000000..5668bd4
--- /dev/null
+++ b/scrub/generic.c
@@ -0,0 +1,1057 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "libxfs.h"
+#include <linux/fiemap.h>
+#include <sys/statvfs.h>
+#include <sys/types.h>
+#include <dirent.h>
+#include <sys/xattr.h>
+#include "disk.h"
+#include "scrub.h"
+#include "iocmd.h"
+#include "../repair/threads.h"
+#include "read_verify.h"
+#include "extent.h"
+
+/*
+ * Generic Filesystem Scrub Strategy
+ *
+ * For a generic filesystem, we can only scrub the filesystem using the
+ * generic VFS APIs that are accessible to userspace.  This requirement
+ * reduces the effectiveness of the scrub because we can only scrub that
+ * which we can find through the directory tree namespace -- we won't be
+ * able to examine open unlinked files or any directory subtree that is
+ * also a mountpoint.
+ *
+ * The "find geometry" phase collects statfs/statvfs information and
+ * opens file descriptors to the mountpoint.  If the filesystem has a
+ * block device, a file descriptor is opened to that as well.
+ *
+ * The VFS has no mechanism to scrub internal metadata or to iterate
+ * inodes by inode number, so those phases do nothing.
+ *
+ * The "check directory structure" phase walks the directory tree
+ * looking for inodes.  Each directory is processed separately by thread
+ * pool workers.  For each entry in a directory, we scrub the following
+ * pieces of metadata:
+ *
+ *     - The dirent inode number is compared against the fstatat output.
+ *     - The dirent type code is also checked against the fstatat type.
+ *     - If it's a symlink, the target is read but not validated.
+ *     - If the entry is not a file or directory, the extended
+ *       attributes names and values are read via llistxattr.
+ *     - If the entry points to a file or directory, open the inode.
+ *       If not, we're done with the entry.
+ *     - The inode stat buffer is re-checked.
+ *     - The extent maps for file data and extended attribute data are
+ *       checked.
+ *     - Extended attributes are read.
+ *
+ * The "verify data file integrity" phase re-walks the directory tree
+ * for files.  If the filesystem supports FIEMAP and we have the block
+ * device open, the data extents are read directly from disk.  This step
+ * is optimized by buffering the disk extents in a bitmap and using the
+ * bitmap to issue large IOs; if there are errors, those are recorded
+ * and cross-referenced against the metadata to identify the affected
+ * files with a second walk/FIEMAP run.  If FIEMAP is unavailable, it
+ * falls back to using SEEK_DATA and SEEK_HOLE to direct-read file
+ * contents.  If even that fails, direct-read the entire file.
+ *
+ * In the "check summary counters" phase, we tally up the blocks and
+ * inodes we saw and compare that to the statfs output.  This gives the
+ * user a rough estimate of how thorough the scrub was.
+ */
+
+#ifndef SEEK_DATA
+# define SEEK_DATA	3	/* seek to the next data */
+#endif
+
+#ifndef SEEK_HOLE
+# define SEEK_HOLE	4	/* seek to the next hole */
+#endif
+
+/* Routines to translate bad physical extents into file paths and offsets. */
+
+/* Report if this extent overlaps a bad region. */
+static bool
+report_verify_inode_fiemap(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	struct fiemap_extent	*extent,
+	void			*arg)
+{
+	struct extent_tree	*tree = arg;
+
+	/* Skip non-real/non-aligned extents. */
+	if (extent->fe_flags & (FIEMAP_EXTENT_UNKNOWN |
+				FIEMAP_EXTENT_DELALLOC |
+				FIEMAP_EXTENT_ENCODED |
+				FIEMAP_EXTENT_NOT_ALIGNED |
+				FIEMAP_EXTENT_UNWRITTEN))
+		return true;
+
+	if (!extent_tree_has_extent(tree, extent->fe_physical >> BBSHIFT,
+			extent->fe_length >> BBSHIFT))
+		return true;
+
+	str_error(ctx, descr,
+_("offset %llu failed read verification."),
+			extent->fe_logical >> BBSHIFT);
+
+	return true;
+}
+
+/* Iterate the extent mappings of a file to report errors. */
+static bool
+report_verify_fd(
+	struct scrub_ctx		*ctx,
+	const char			*descr,
+	int				fd,
+	void				*arg)
+{
+	/* data fork */
+	fiemap(ctx, descr, fd, false, false, report_verify_inode_fiemap, arg);
+
+	/* attr fork */
+	fiemap(ctx, descr, fd, true, false, report_verify_inode_fiemap, arg);
+
+	return true;
+}
+
+/* Scan the inode associated with a directory entry. */
+static bool
+report_verify_dirent(
+	struct scrub_ctx	*ctx,
+	const char		*path,
+	int			dir_fd,
+	struct dirent		*dirent,
+	struct stat64		*sb,
+	void			*arg)
+{
+	bool			moveon;
+	int			fd;
+
+	/* Ignore things we can't open. */
+	if (!S_ISREG(sb->st_mode))
+		return true;
+	/* Ignore . and .. */
+	if (!strcmp(".", dirent->d_name) || !strcmp("..", dirent->d_name))
+		return true;
+
+	/* Open the file */
+	fd = openat(dir_fd, dirent->d_name,
+			O_RDONLY | O_NOATIME | O_NOFOLLOW | O_NOCTTY);
+	if (fd < 0)
+		return true;
+
+	/* Go find the badness. */
+	moveon = report_verify_fd(ctx, path, fd, arg);
+	if (moveon)
+		goto out;
+
+out:
+	close(fd);
+
+	return moveon;
+}
+
+/* Given bad extent lists for the data device, find bad files. */
+static bool
+report_verify_errors(
+	struct scrub_ctx		*ctx,
+	struct extent_tree		*d_bad)
+{
+	/* Scan the directory tree to get file paths. */
+	return scan_fs_tree(ctx, NULL, report_verify_dirent, d_bad);
+}
+
+/* Phase 1 */
+bool
+generic_scan_fs(
+	struct scrub_ctx	*ctx)
+{
+	/* Nothing to do here. */
+	return true;
+}
+
+bool
+generic_cleanup(
+	struct scrub_ctx	*ctx)
+{
+	/* Nothing to do here. */
+	return true;
+}
+
+/* Phase 2 */
+bool
+generic_scan_metadata(
+	struct scrub_ctx	*ctx)
+{
+	/* Nothing to do here. */
+	return true;
+}
+
+/* Phase 3 */
+bool
+generic_scan_inodes(
+	struct scrub_ctx	*ctx)
+{
+	/* Nothing to do here. */
+	return true;
+}
+
+/* Phase 4 */
+
+/* Check all entries in a directory. */
+bool
+generic_check_dir(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	int			dir_fd)
+{
+	/* Nothing to do here. */
+	return true;
+}
+
+/* Check an extent for problems. */
+static bool
+check_fiemap_extent(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	struct fiemap_extent	*extent,
+	void			*arg)
+{
+	unsigned long long	eofs;
+	unsigned long		quirks;
+
+	pthread_mutex_lock(&ctx->lock);
+	quirks = ctx->quirks;
+	pthread_mutex_unlock(&ctx->lock);
+
+	if (quirks & SCRUB_QUIRK_IGNORE_STATFS_BLOCKS)
+		eofs = ctx->datadev.d_nrsectors;
+	else
+		eofs = ctx->mnt_sf.f_blocks * ctx->mnt_sf.f_frsize;
+
+	if (extent->fe_length == 0)
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) has zero length."),
+			extent->fe_physical >> BBSHIFT,
+			extent->fe_logical >> BBSHIFT,
+			extent->fe_length >> BBSHIFT);
+	if (extent->fe_physical > eofs)
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) starts past end of filesystem at %llu."),
+			extent->fe_physical >> BBSHIFT,
+			extent->fe_logical >> BBSHIFT,
+			extent->fe_length >> BBSHIFT,
+			eofs >> BBSHIFT);
+	if (extent->fe_physical + extent->fe_length > eofs ||
+	    extent->fe_physical + extent->fe_length <
+			extent->fe_physical)
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) ends past end of filesystem at %llu."),
+			extent->fe_physical >> BBSHIFT,
+			extent->fe_logical >> BBSHIFT,
+			extent->fe_length >> BBSHIFT,
+			eofs >> BBSHIFT);
+	if (extent->fe_logical + extent->fe_length <
+			extent->fe_logical)
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) overflows file offset."),
+			extent->fe_physical >> BBSHIFT,
+			extent->fe_logical >> BBSHIFT,
+			extent->fe_length >> BBSHIFT);
+	return true;
+}
+
+/* Check an inode's extents. */
+bool
+generic_scan_extents(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	int			fd,
+	struct stat64		*sb,
+	bool			attr_fork)
+{
+	/* FIEMAP only works for files. */
+	if (!S_ISREG(sb->st_mode))
+		return true;
+
+	return fiemap(ctx, descr, fd, attr_fork, true,
+			check_fiemap_extent, NULL);
+}
+
+/* Check the fields of an inode. */
+bool
+generic_check_inode(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	int			fd,
+	struct stat64		*sb)
+{
+	if (sb->st_nlink == 0)
+		str_error(ctx, descr,
+_("nlinks should not be 0."));
+
+	return true;
+}
+
+/* Try to read all the extended attributes. */
+bool
+generic_scan_xattrs(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	int			fd)
+{
+	char			*buf = NULL;
+	char			*p;
+	ssize_t			buf_sz;
+	ssize_t			sz;
+	ssize_t			val_sz;
+	ssize_t			sz2;
+	bool			moveon = true;
+
+	buf_sz = flistxattr(fd, NULL, 0);
+	if (buf_sz == -EOPNOTSUPP)
+		return true;
+	else if (buf_sz == 0)
+		return true;
+	else if (buf_sz < 0) {
+		str_errno(ctx, descr);
+		return true;
+	}
+
+	buf = malloc(buf_sz);
+	if (!buf) {
+		str_errno(ctx, descr);
+		return false;
+	}
+
+	sz = flistxattr(fd, buf, buf_sz);
+	if (sz < 0) {
+		str_errno(ctx, descr);
+		goto out;
+	} else if (sz != buf_sz) {
+		str_error(ctx, descr,
+_("read %zu bytes of xattr names, expected %zu bytes."),
+				sz, buf_sz);
+	}
+
+	/* Read all the attrs and values. */
+	for (p = buf; p < buf + sz; p += strlen(p) + 1) {
+		val_sz = fgetxattr(fd, p, NULL, 0);
+		if (val_sz < 0) {
+			if (errno != ENODATA)
+				str_errno(ctx, descr);
+			continue;
+		}
+		sz2 = fgetxattr(fd, p, ctx->readbuf, val_sz);
+		if (sz2 < 0) {
+			str_errno(ctx, descr);
+			continue;
+		} else if (sz2 != val_sz)
+			str_error(ctx, descr,
+_("read %zu bytes from xattr %s value, expected %zu bytes."),
+					sz2, p, val_sz);
+	}
+out:
+	free(buf);
+	return moveon;
+}
+
+/* Try to read all the extended attributes of things that have no fd. */
+bool
+generic_scan_special_xattrs(
+	struct scrub_ctx	*ctx,
+	const char		*path)
+{
+	char			*buf = NULL;
+	char			*p;
+	ssize_t			buf_sz;
+	ssize_t			sz;
+	ssize_t			val_sz;
+	ssize_t			sz2;
+	bool			moveon = true;
+
+	buf_sz = llistxattr(path, NULL, 0);
+	if (buf_sz == -EOPNOTSUPP)
+		return true;
+	else if (buf_sz == 0)
+		return true;
+	else if (buf_sz < 0) {
+		str_errno(ctx, path);
+		return true;
+	}
+
+	buf = malloc(buf_sz);
+	if (!buf) {
+		str_errno(ctx, path);
+		return false;
+	}
+
+	sz = llistxattr(path, buf, buf_sz);
+	if (sz < 0) {
+		str_errno(ctx, path);
+		goto out;
+	} else if (sz != buf_sz) {
+		str_error(ctx, path,
+_("read %zu bytes of xattr names, expected %zu bytes."),
+				sz, buf_sz);
+	}
+
+	/* Read all the attrs and values. */
+	for (p = buf; p < buf + sz; p += strlen(p) + 1) {
+		val_sz = lgetxattr(path, p, NULL, 0);
+		if (val_sz < 0) {
+			str_errno(ctx, path);
+			continue;
+		}
+		sz2 = lgetxattr(path, p, ctx->readbuf, val_sz);
+		if (sz2 < 0) {
+			str_errno(ctx, path);
+			continue;
+		} else if (sz2 != val_sz)
+			str_error(ctx, path,
+_("read %zu bytes from xattr %s value, expected %zu bytes."),
+					sz2, p, val_sz);
+	}
+out:
+	free(buf);
+	return moveon;
+}
+
+/* Directory checking */
+#define CHECK_TYPE(type) \
+	case DT_##type: \
+		if (!S_IS##type(sb->st_mode)) { \
+			str_error(ctx, descr, \
+_("dtype of block does not match mode 0x%x\n"), \
+				sb->st_mode & S_IFMT); \
+		} \
+		break;
+
+/* Ensure that the directory entry matches the stat info. */
+static bool
+generic_verify_dirent(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	struct dirent		*dirent,
+	struct stat64		*sb)
+{
+	if (dirent->d_ino != sb->st_ino) {
+		str_error(ctx, descr,
+_("inode numbers (%llu != %llu) do not match!"),
+			(unsigned long long)dirent->d_ino,
+			(unsigned long long)sb->st_ino);
+	}
+
+	switch (dirent->d_type) {
+	case DT_UNKNOWN:
+		break;
+	CHECK_TYPE(BLK)
+	CHECK_TYPE(CHR)
+	CHECK_TYPE(DIR)
+	CHECK_TYPE(FIFO)
+	CHECK_TYPE(LNK)
+	CHECK_TYPE(REG)
+	CHECK_TYPE(SOCK)
+	}
+
+	return true;
+}
+#undef CHECK_TYPE
+
+/* Scan the inode associated with a directory entry. */
+static bool
+check_dirent(
+	struct scrub_ctx	*ctx,
+	const char		*path,
+	int			dir_fd,
+	struct dirent		*dirent,
+	struct stat64		*sb,
+	void			*arg)
+{
+	struct stat64		fd_sb;
+	static char		linkbuf[PATH_MAX];
+	ssize_t			len;
+	bool			moveon;
+	int			fd;
+	int			error;
+
+	/* Check the directory entry itself. */
+	moveon = generic_verify_dirent(ctx, path, dirent, sb);
+	if (!moveon)
+		return moveon;
+
+	/* If symlink, read the target value. */
+	if (S_ISLNK(sb->st_mode)) {
+		len = readlinkat(dir_fd, dirent->d_name, linkbuf,
+				PATH_MAX);
+		if (len < 0)
+			str_errno(ctx, path);
+		else if (len != sb->st_size)
+			str_error(ctx, path,
+_("read %zu bytes from a %zu byte symlink?"),
+				len, sb->st_size);
+	}
+
+	/* Read the xattrs without a file descriptor. */
+	if (S_ISSOCK(sb->st_mode) || S_ISFIFO(sb->st_mode) ||
+	    S_ISBLK(sb->st_mode) || S_ISCHR(sb->st_mode) ||
+	    S_ISLNK(sb->st_mode)) {
+		moveon = ctx->ops->scan_special_xattrs(ctx, path);
+		if (!moveon)
+			return moveon;
+	}
+
+	/* If not dir or file, move on to the next dirent. */
+	if (!S_ISDIR(sb->st_mode) && !S_ISREG(sb->st_mode))
+		return true;
+
+	/* Open the file */
+	fd = openat(dir_fd, dirent->d_name,
+			O_RDONLY | O_NOATIME | O_NOFOLLOW | O_NOCTTY);
+	if (fd < 0) {
+		if (errno != ENOENT)
+			str_errno(ctx, path);
+		return true;
+	}
+
+	/* Did the fstatat and the open race? */
+	if (fstat64(fd, &fd_sb) < 0) {
+		str_errno(ctx, path);
+		goto close;
+	}
+	if (fd_sb.st_ino != sb->st_ino || fd_sb.st_dev != sb->st_dev)
+		str_warn(ctx, path,
+_("inode changed out from under us!"));
+
+	/* Check the inode. */
+	moveon = ctx->ops->check_inode(ctx, path, fd, &fd_sb);
+	if (!moveon)
+		goto close;
+
+	/* Scan the extent maps. */
+	moveon = ctx->ops->scan_extents(ctx, path, fd, &fd_sb, false);
+	if (!moveon)
+		goto close;
+	moveon = ctx->ops->scan_extents(ctx, path, fd, &fd_sb, true);
+	if (!moveon)
+		goto close;
+
+	/* Read all the extended attributes. */
+	moveon = ctx->ops->scan_xattrs(ctx, path, fd);
+	if (!moveon)
+		goto close;
+
+close:
+	/* Close file. */
+	error = close(fd);
+	if (error)
+		str_errno(ctx, path);
+
+	return moveon;
+}
+
+/*
+ * Check all the entries in a directory.
+ */
+bool
+generic_check_directory(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	int			*pfd)
+{
+	struct stat64		sb;
+	DIR			*dir;
+	struct dirent		*dirent;
+	bool			moveon = true;
+	int			fd = *pfd;
+	int			error;
+
+	/* Iterate the directory entries. */
+	dir = fdopendir(fd);
+	if (!dir) {
+		str_errno(ctx, descr);
+		return true;
+	}
+	rewinddir(dir);
+
+	/* Iterate every directory entry. */
+	for (dirent = readdir(dir);
+	     dirent != NULL;
+	     dirent = readdir(dir)) {
+		error = fstatat64(fd, dirent->d_name, &sb,
+				AT_NO_AUTOMOUNT | AT_SYMLINK_NOFOLLOW);
+		if (error) {
+			str_errno(ctx, descr);
+			break;
+		}
+
+		/* Ignore files on other filesystems. */
+		if (sb.st_dev != ctx->mnt_sb.st_dev)
+			continue;
+
+		/* Check the type codes. */
+		moveon = generic_verify_dirent(ctx, descr, dirent, &sb);
+		if (!moveon)
+			break;
+	}
+
+	/* Close dir, go away. */
+	error = closedir(dir);
+	if (error)
+		str_errno(ctx, descr);
+	*pfd = -1;
+	return moveon;
+}
+
+/* Adapter for the check_dir thing. */
+static bool
+check_dir(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	int			dir_fd,
+	void			*arg)
+{
+	return ctx->ops->check_dir(ctx, descr, dir_fd);
+}
+
+/* Traverse the directory tree. */
+bool
+generic_scan_fs_tree(
+	struct scrub_ctx	*ctx)
+{
+	return scan_fs_tree(ctx, check_dir, check_dirent, NULL);
+}
+
+/* Phase 5 */
+
+struct read_verify_fiemap {
+	struct scrub_ctx	*ctx;
+	struct extent_tree	good;
+	struct extent_tree	bad;
+	struct read_verify_pool	rvp;
+	struct read_verify	rv;
+	bool			(*fiemap_fn)(struct scrub_ctx *,
+					     const char *,
+					     struct fiemap_extent *,
+					     void *);
+};
+
+/* Handle an io error while read verifying an extent. */
+void
+read_verify_fiemap_ioerr(
+	struct read_verify_pool		*rvp,
+	struct disk			*disk,
+	uint64_t			startblock,
+	uint64_t			blockcount,
+	int				error,
+	void				*arg)
+{
+	struct read_verify_fiemap	*rvf = arg;
+
+	extent_tree_add(&rvf->bad, startblock, blockcount);
+}
+
+/* Check an extent for data integrity problems. */
+bool
+read_verify_fiemap_extent(
+	struct scrub_ctx		*ctx,
+	const char			*descr,
+	struct fiemap_extent		*extent,
+	void				*arg)
+{
+	struct read_verify_fiemap	*rvf = arg;
+
+	/* Skip non-real/non-aligned extents. */
+	if (extent->fe_flags & (FIEMAP_EXTENT_UNKNOWN |
+				FIEMAP_EXTENT_DELALLOC |
+				FIEMAP_EXTENT_ENCODED |
+				FIEMAP_EXTENT_NOT_ALIGNED |
+				FIEMAP_EXTENT_UNWRITTEN))
+		return true;
+
+	return extent_tree_add(&rvf->good, extent->fe_physical >> BBSHIFT,
+			extent->fe_length >> BBSHIFT);
+}
+
+/* Scan the inode associated with a directory entry. */
+static bool
+read_verify_dirent(
+	struct scrub_ctx		*ctx,
+	const char			*path,
+	int				dir_fd,
+	struct dirent			*dirent,
+	struct stat64			*sb,
+	void				*arg)
+{
+	struct stat64			fd_sb;
+	struct read_verify_fiemap	*rvf = arg;
+	bool				moveon = true;
+	int				fd;
+	int				error;
+
+	/* If not file, move on to the next dirent. */
+	if (!S_ISREG(sb->st_mode))
+		return true;
+
+	/* Open the file */
+	fd = openat(dir_fd, dirent->d_name,
+			O_RDONLY | O_NOATIME | O_NOFOLLOW | O_NOCTTY);
+	if (fd < 0) {
+		if (errno != ENOENT)
+			str_errno(ctx, path);
+		return true;
+	}
+
+	/* Did the fstatat and the open race? */
+	if (fstat64(fd, &fd_sb) < 0) {
+		str_errno(ctx, path);
+		goto close;
+	}
+	if (fd_sb.st_ino != sb->st_ino || fd_sb.st_dev != sb->st_dev)
+		str_warn(ctx, path,
+_("inode changed out from under us!"));
+
+	/*
+	 * Read all the file data.  If we have the block device open
+	 * we'll try to use FIEMAP data to read-verify the physical
+	 * data blocks.  If that doesn't work, we'll use the generic
+	 * seek-based read_file to verify the file data.
+	 */
+	if (disk_is_open(&ctx->datadev))
+		moveon = fiemap(ctx, path, fd, false, false, rvf->fiemap_fn,
+			rvf);
+	else
+		moveon = false;
+	if (moveon)
+		goto close;
+	moveon = ctx->ops->read_file(ctx, path, fd, &fd_sb);
+	if (!moveon)
+		goto close;
+
+close:
+	/* Close file. */
+	error = close(fd);
+	if (error)
+		str_errno(ctx, path);
+
+	return moveon;
+}
+
+static bool
+schedule_read_verify(
+	uint64_t			start,
+	uint64_t			length,
+	void				*arg)
+{
+	struct read_verify_fiemap	*rvf = arg;
+
+	read_verify_schedule(&rvf->rvp, &rvf->rv, &rvf->ctx->datadev,
+			start, length, rvf);
+	return true;
+}
+
+/* Scan all the data blocks, using FIEMAP to figure out what to verify. */
+bool
+generic_scan_blocks(
+	struct scrub_ctx		*ctx)
+{
+	struct read_verify_fiemap	rvf;
+	bool				moveon;
+
+	if (!scrub_data)
+		return true;
+
+	memset(&rvf, 0, sizeof(rvf));
+	rvf.ctx = ctx;
+	moveon = extent_tree_init(&rvf.good);
+	if (!moveon) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	moveon = extent_tree_init(&rvf.bad);
+	if (!moveon) {
+		str_errno(ctx, ctx->mntpoint);
+		goto out_good;
+	}
+
+	/* Collect all the extent maps. */
+	rvf.fiemap_fn = read_verify_fiemap_extent;
+	moveon = scan_fs_tree(ctx, NULL, read_verify_dirent, &rvf);
+	if (!moveon)
+		goto out_bad;
+
+	/* Run all the IO in batches. */
+	read_verify_pool_init(&rvf.rvp, ctx, ctx->readbuf, IO_MAX_SIZE,
+			ctx->mnt_sf.f_frsize, read_verify_fiemap_ioerr,
+			NULL, scrub_nproc(ctx));
+	moveon = extent_tree_iterate(&rvf.good, schedule_read_verify, &rvf);
+	if (!moveon)
+		goto out_pool;
+	read_verify_force(&rvf.rvp, &rvf.rv);
+	read_verify_pool_destroy(&rvf.rvp);
+
+	/* Scan the whole dir tree to see what matches the bad extents. */
+	if (!extent_tree_empty(&rvf.bad))
+		moveon = report_verify_errors(ctx, &rvf.bad);
+
+	extent_tree_free(&rvf.bad);
+	extent_tree_free(&rvf.good);
+	return moveon;
+
+out_pool:
+	read_verify_pool_destroy(&rvf.rvp);
+out_bad:
+	extent_tree_free(&rvf.bad);
+out_good:
+	extent_tree_free(&rvf.good);
+
+	return moveon;
+}
+
+/* Read all the data in a file. */
+bool
+generic_read_file(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	int			fd,
+	struct stat64		*sb)
+{
+	off_t			data_end = 0;
+	off_t			data_start;
+	off_t			start;
+	ssize_t			sz;
+	size_t			count;
+	bool			reports_holes = true;
+	bool			direct_io = false;
+	int			flags;
+	int			error;
+
+	/* Can we set O_DIRECT? */
+	flags = fcntl(fd, F_GETFL);
+	error = fcntl(fd, F_SETFL, flags | O_DIRECT);
+	if (!error)
+		direct_io = true;
+
+	/* See if SEEK_DATA/SEEK_HOLE work... */
+	data_start = lseek(fd, data_end, SEEK_DATA);
+	if (data_start < 0) {
+		/* ENXIO for SEEK_DATA means no file data anywhere. */
+		if (errno == ENXIO)
+			return true;
+		reports_holes = false;
+	}
+
+	if (reports_holes) {
+		data_end = lseek(fd, data_start, SEEK_HOLE);
+		if (data_end < 0)
+			reports_holes = false;
+	}
+
+	/* ...or just read everything if they don't. */
+	if (!reports_holes) {
+		data_start = 0;
+		data_end = sb->st_size;
+	}
+
+	if (!direct_io) {
+		posix_fadvise(fd, 0, sb->st_size, POSIX_FADV_SEQUENTIAL);
+		posix_fadvise(fd, 0, sb->st_size, POSIX_FADV_WILLNEED);
+	}
+	/* Read the non-hole areas. */
+	while (data_start < data_end) {
+		start = data_start;
+
+		if (direct_io && (start & (page_size - 1)))
+			start &= ~(page_size - 1);
+		count = min(IO_MAX_SIZE, data_end - start);
+		if (direct_io && (count & (page_size - 1)))
+			count = (count + page_size) & ~(page_size - 1);
+		sz = pread64(fd, ctx->readbuf, count, start);
+		if (sz < 0)
+			str_errno(ctx, descr);
+		else if (sz == 0) {
+			str_error(ctx, descr,
+_("Read zero bytes, expected %zu."),
+					count);
+			break;
+		} else if (sz != count && start + sz != data_end) {
+			str_warn(ctx, descr,
+_("Short read of %zu bytes, expected %zu."),
+					sz, count);
+		}
+		data_start = start + sz;
+
+		if (data_start >= data_end && reports_holes) {
+			data_start = lseek(fd, data_end, SEEK_DATA);
+			if (data_start < 0) {
+				if (errno != ENXIO)
+					str_errno(ctx, descr);
+				break;
+			}
+			data_end = lseek(fd, data_start, SEEK_HOLE);
+			if (data_end < 0) {
+				if (errno != ENXIO)
+					str_errno(ctx, descr);
+				break;
+			}
+		}
+	}
+
+	/* Turn off O_DIRECT. */
+	if (direct_io) {
+		flags = fcntl(fd, F_GETFL);
+		error = fcntl(fd, F_SETFL, flags & ~O_DIRECT);
+		if (error)
+			str_errno(ctx, descr);
+	}
+
+	return true;
+}
+
+/* Phase 6 */
+struct summary_counts {
+	pthread_mutex_t		lock;
+	unsigned long long	inodes;	/* number of inodes */
+	unsigned long long	blocks;	/* 512b blocks */
+};
+
+/* Record the presence of an inode and its block usage. */
+static bool
+record_inode_summary(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	int			dir_fd,
+	struct dirent		*dirent,
+	struct stat64		*sb,
+	void			*arg)
+{
+	struct summary_counts	*summary = arg;
+
+	if (strcmp(dirent->d_name, ".") == 0 ||
+	    strcmp(dirent->d_name, "..") == 0)
+		return true;
+
+	pthread_mutex_lock(&summary->lock);
+	summary->inodes++;
+	summary->blocks += sb->st_blocks;
+	pthread_mutex_unlock(&summary->lock);
+
+	return true;
+}
+
+/* Traverse the directory tree, counting inodes & blocks. */
+bool
+generic_check_summary(
+	struct scrub_ctx	*ctx)
+{
+	struct summary_counts	summary;
+	struct stat64		sb;
+	struct statvfs		sfs;
+	unsigned long long	fd;
+	unsigned long long	fi;
+	unsigned long long	sd;
+	unsigned long long	si;
+	unsigned long long	absdiff;
+	bool			complain;
+	bool			moveon;
+	int			error;
+
+	pthread_mutex_init(&summary.lock, NULL);
+	summary.inodes = 0;
+	summary.blocks = 0;
+
+	/* Flush everything out to disk before we start counting. */
+	error = syncfs(ctx->mnt_fd);
+	if (error) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	/* Get the rootdir's summary stats. */
+	error = fstat64(ctx->mnt_fd, &sb);
+	if (error) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	/* Scan the rest of the filesystem. */
+	moveon = scan_fs_tree(ctx, NULL, record_inode_summary, &summary);
+	if (!moveon)
+		return moveon;
+
+	/* Compare to statfs results. */
+	error = fstatvfs(ctx->mnt_fd, &sfs);
+	if (error) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	/* Report on what we found. */
+	fd = (sfs.f_blocks - sfs.f_bfree) * sfs.f_frsize >> (BBSHIFT + 1),
+	fi = sfs.f_files - sfs.f_ffree;
+	sd = summary.blocks >> 1;
+	si = summary.inodes;
+
+	/*
+	 * Complain if the counts are off by more than 10%, unless
+	 * the inaccuracy is less than 32MB worth of blocks or 100 inodes.
+	 */
+	absdiff = (1ULL << 25) / sfs.f_bsize;
+	complain = !within_range(ctx, sd, fd, absdiff, 1, 10, _("data blocks"));
+	complain |= !within_range(ctx, si, fi, 100, 1, 10, _("inodes"));
+
+	if (complain || verbose) {
+		double		b, i;
+		char		*bu, *iu;
+
+		b = auto_space_units(fd, &bu);
+		i = auto_units(fi, &iu);
+		printf(_("%.1f%s blocks used;  %.2f%s inodes used.\n"),
+				b, bu, i, iu);
+		b = auto_space_units(sd, &bu);
+		i = auto_units(si, &iu);
+		printf(_("%.1f%s blocks found; %.2f%s inodes found.\n"),
+				b, bu, i, iu);
+	}
+
+	return true;
+}
+
+struct scrub_ops generic_scrub_ops = {
+	.name			= "generic",
+	.cleanup		= generic_cleanup,
+	.scan_fs		= generic_scan_fs,
+	.scan_inodes		= generic_scan_inodes,
+	.check_dir		= generic_check_dir,
+	.check_inode		= generic_check_inode,
+	.scan_extents		= generic_scan_extents,
+	.scan_xattrs		= generic_scan_xattrs,
+	.scan_special_xattrs	= generic_scan_special_xattrs,
+	.scan_metadata		= generic_scan_metadata,
+	.check_summary		= generic_check_summary,
+	.read_file		= generic_read_file,
+	.scan_blocks		= generic_scan_blocks,
+	.scan_fs_tree		= generic_scan_fs_tree,
+};
diff --git a/scrub/iocmd.c b/scrub/iocmd.c
new file mode 100644
index 0000000..9cd7b81
--- /dev/null
+++ b/scrub/iocmd.c
@@ -0,0 +1,342 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "libxfs.h"
+#include <linux/fiemap.h>
+#include <sys/statvfs.h>
+#include <sys/types.h>
+#include <dirent.h>
+#include <sys/xattr.h>
+#include "../repair/threads.h"
+#include "disk.h"
+#include "scrub.h"
+#include "iocmd.h"
+
+#define NR_EXTENTS	512
+
+/* Scan a filesystem tree. */
+struct scan_fs_tree {
+	unsigned int		nr_dirs;
+	pthread_mutex_t		lock;
+	pthread_cond_t		wakeup;
+	struct stat64		root_sb;
+	bool			moveon;
+	bool			(*dir_fn)(struct scrub_ctx *, const char *,
+					  int, void *);
+	bool			(*dirent_fn)(struct scrub_ctx *, const char *,
+					     int, struct dirent *,
+					     struct stat64 *, void *);
+	void			*arg;
+};
+
+/* Per-work-item scan context. */
+struct scan_fs_tree_dir {
+	char			*path;
+	struct scan_fs_tree	*sft;
+};
+
+/* Scan a directory sub tree. */
+static void
+scan_fs_dir(
+	struct work_queue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
+{
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->mp;
+	struct scan_fs_tree_dir	*sftd = arg;
+	struct scan_fs_tree	*sft = sftd->sft;
+	DIR			*dir;
+	struct dirent		*dirent;
+	char			newpath[PATH_MAX];
+	struct scan_fs_tree_dir	*new_sftd;
+	struct stat64		sb;
+	int			dir_fd;
+	int			error;
+
+	/* Open the directory. */
+	dir_fd = open(sftd->path, O_RDONLY | O_NOATIME | O_NOFOLLOW | O_NOCTTY);
+	if (dir_fd < 0) {
+		if (errno != ENOENT)
+			str_errno(ctx, sftd->path);
+		goto out;
+	}
+
+	/* Caller-specific directory checks. */
+	if (sft->dir_fn && !sft->dir_fn(ctx, sftd->path, dir_fd, sft->arg)) {
+		sft->moveon = false;
+		goto out;
+	}
+
+	/* Iterate the directory entries. */
+	dir = fdopendir(dir_fd);
+	if (!dir) {
+		str_errno(ctx, sftd->path);
+		goto out;
+	}
+	rewinddir(dir);
+	for (dirent = readdir(dir); dirent != NULL; dirent = readdir(dir)) {
+		snprintf(newpath, PATH_MAX, "%s/%s", sftd->path,
+				dirent->d_name);
+
+		/* Get the stat info for this directory entry. */
+		error = fstatat64(dir_fd, dirent->d_name, &sb,
+				AT_NO_AUTOMOUNT | AT_SYMLINK_NOFOLLOW);
+		if (error) {
+			str_errno(ctx, newpath);
+			continue;
+		}
+
+		/* Ignore files on other filesystems. */
+		if (sb.st_dev != sft->root_sb.st_dev)
+			continue;
+
+		/* Caller-specific directory entry function. */
+		if (!sft->dirent_fn(ctx, newpath, dir_fd, dirent, &sb,
+				sft->arg)) {
+			sft->moveon = false;
+			break;
+		}
+
+		/* If directory, call ourselves recursively. */
+		if (S_ISDIR(sb.st_mode) && strcmp(".", dirent->d_name) &&
+		    strcmp("..", dirent->d_name)) {
+			new_sftd = malloc(sizeof(struct scan_fs_tree_dir));
+			if (!new_sftd) {
+				str_errno(ctx, newpath);
+				sft->moveon = false;
+				break;
+			}
+			new_sftd->path = strdup(newpath);
+			new_sftd->sft = sft;
+			pthread_mutex_lock(&sft->lock);
+			sft->nr_dirs++;
+			pthread_mutex_unlock(&sft->lock);
+			queue_work(wq, scan_fs_dir, 0, new_sftd);
+		}
+	}
+
+	/* Close dir, go away. */
+	error = closedir(dir);
+	if (error)
+		str_errno(ctx, sftd->path);
+
+out:
+	pthread_mutex_lock(&sft->lock);
+	sft->nr_dirs--;
+	if (sft->nr_dirs == 0)
+		pthread_cond_signal(&sft->wakeup);
+	pthread_mutex_unlock(&sft->lock);
+
+	free(sftd->path);
+	free(sftd);
+}
+
+/* Scan the entire filesystem. */
+bool
+scan_fs_tree(
+	struct scrub_ctx	*ctx,
+	bool			(*dir_fn)(struct scrub_ctx *, const char *,
+					  int, void *),
+	bool			(*dirent_fn)(struct scrub_ctx *, const char *,
+						int, struct dirent *,
+						struct stat64 *, void *),
+	void			*arg)
+{
+	struct work_queue	wq;
+	struct scan_fs_tree	sft;
+	struct scan_fs_tree_dir	*sftd;
+
+	sft.moveon = true;
+	sft.nr_dirs = 1;
+	sft.root_sb = ctx->mnt_sb;
+	sft.dir_fn = dir_fn;
+	sft.dirent_fn = dirent_fn;
+	sft.arg = arg;
+	pthread_mutex_init(&sft.lock, NULL);
+	pthread_cond_init(&sft.wakeup, NULL);
+
+	sftd = malloc(sizeof(struct scan_fs_tree_dir));
+	if (!sftd) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+	sftd->path = strdup(ctx->mntpoint);
+	sftd->sft = &sft;
+
+	create_work_queue(&wq, (struct xfs_mount *)ctx, scrub_nproc(ctx));
+	queue_work(&wq, scan_fs_dir, 0, sftd);
+
+	pthread_mutex_lock(&sft.lock);
+	pthread_cond_wait(&sft.wakeup, &sft.lock);
+	assert(sft.nr_dirs == 0);
+	pthread_mutex_unlock(&sft.lock);
+	destroy_work_queue(&wq);
+
+	return sft.moveon;
+}
+
+/* Check an inode's extents... the hard way. */
+static bool
+fibmap(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	int			fd,
+	bool			(*fn)(struct scrub_ctx *, const char *,
+				      struct fiemap_extent *, void *),
+	void			*arg)
+{
+	struct stat64		sb;
+	struct fiemap_extent	extent;
+	unsigned int		blk;
+	unsigned int		b;
+	off_t			numblocks;
+	bool			moveon = true;
+	int			error;
+
+	pthread_mutex_lock(&ctx->lock);
+	if (!(ctx->quirks & SCRUB_QUIRK_FIBMAP_WORKS)) {
+		pthread_mutex_unlock(&ctx->lock);
+		return true;
+	}
+	pthread_mutex_unlock(&ctx->lock);
+
+	error = fstat64(fd, &sb);
+	if (error) {
+		str_errno(ctx, descr);
+		return false;
+	}
+
+	numblocks = (sb.st_size + sb.st_blksize - 1) / sb.st_blksize;
+	if (numblocks > UINT_MAX)
+		numblocks = UINT_MAX;
+	for (blk = 0; blk < numblocks; blk++) {
+		b = blk;
+		error = ioctl(fd, FIBMAP, &b);
+		if (error) {
+			if (errno == EOPNOTSUPP || errno == EINVAL) {
+				str_warn(ctx, descr,
+_("data block FIEMAP/FIBMAP not supported, will not check extent map."));
+				pthread_mutex_lock(&ctx->lock);
+				ctx->quirks &= ~SCRUB_QUIRK_FIBMAP_WORKS;
+				pthread_mutex_unlock(&ctx->lock);
+				return true;
+			}
+			str_errno(ctx, descr);
+			continue;
+		}
+		extent.fe_physical = b * sb.st_blksize;
+		extent.fe_logical = blk * sb.st_blksize;
+		extent.fe_length = sb.st_blksize;
+		extent.fe_flags = 0;
+		moveon = fn(ctx, descr, &extent, arg);
+		if (!moveon)
+			break;
+	}
+
+	return moveon;
+}
+
+/* Call the FIEMAP ioctl on a file. */
+bool
+fiemap(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	int			fd,
+	bool			attr_fork,
+	bool			use_fibmap,
+	bool			(*fn)(struct scrub_ctx *, const char *,
+				      struct fiemap_extent *, void *),
+	void			*arg)
+{
+	struct fiemap		*fiemap;
+	struct fiemap_extent	*extent;
+	size_t			sz;
+	__u64			next_logical;
+	unsigned long		quirks;
+	bool			moveon = true;
+	bool			last = false;
+	unsigned int		i;
+	int			error;
+
+	pthread_mutex_lock(&ctx->lock);
+	quirks = ctx->quirks;
+	pthread_mutex_unlock(&ctx->lock);
+	if (!attr_fork && !(quirks & SCRUB_QUIRK_FIEMAP_WORKS))
+		return use_fibmap ? fibmap(ctx, descr, fd, fn, arg) : false;
+	else if (attr_fork && !(quirks & SCRUB_QUIRK_FIEMAP_ATTR_WORKS))
+		return true;
+
+	sz = sizeof(struct fiemap) + sizeof(struct fiemap_extent) * NR_EXTENTS;
+	fiemap = calloc(sz, 1);
+	if (!fiemap) {
+		str_errno(ctx, descr);
+		return false;
+	}
+
+	fiemap->fm_length = ~0ULL;
+	fiemap->fm_flags = FIEMAP_FLAG_SYNC;
+	if (attr_fork)
+		fiemap->fm_flags |= FIEMAP_FLAG_XATTR;
+	fiemap->fm_extent_count = NR_EXTENTS;
+	fiemap->fm_reserved = 0;
+	next_logical = 0;
+
+	while (!last) {
+		fiemap->fm_start = next_logical;
+		error = ioctl(fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
+		if (error < 0 && (errno == EOPNOTSUPP || errno == EBADR)) {
+			if (attr_fork) {
+				str_warn(ctx, descr,
+_("extended attribute FIEMAP not supported, will not check extent map."));
+				pthread_mutex_lock(&ctx->lock);
+				ctx->quirks &= ~SCRUB_QUIRK_FIEMAP_ATTR_WORKS;
+				pthread_mutex_unlock(&ctx->lock);
+			} else {
+				pthread_mutex_lock(&ctx->lock);
+				ctx->quirks &= ~SCRUB_QUIRK_FIEMAP_WORKS;
+				pthread_mutex_unlock(&ctx->lock);
+			}
+			break;
+		}
+		if (error < 0) {
+			str_errno(ctx, descr);
+			break;
+		}
+
+		/* No more extents to map, exit */
+		if (!fiemap->fm_mapped_extents)
+			break;
+
+		for (i = 0; i < fiemap->fm_mapped_extents; i++) {
+			extent = &fiemap->fm_extents[i];
+
+			moveon = fn(ctx, descr, extent, arg);
+			if (!moveon)
+				goto out;
+
+			next_logical = extent->fe_logical + extent->fe_length;
+			if (extent->fe_flags & FIEMAP_EXTENT_LAST)
+				last = true;
+		}
+	}
+
+out:
+	free(fiemap);
+	return moveon;
+}
diff --git a/scrub/iocmd.h b/scrub/iocmd.h
new file mode 100644
index 0000000..eb2874b
--- /dev/null
+++ b/scrub/iocmd.h
@@ -0,0 +1,46 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#ifndef IOCMD_H_
+#define IOCMD_H_
+
+struct fiemap_extent;
+
+bool
+scan_fs_tree(
+	struct scrub_ctx	*ctx,
+	bool			(*dir_fn)(struct scrub_ctx *, const char *,
+					  int, void *),
+	bool			(*dirent_fn)(struct scrub_ctx *, const char *,
+						int, struct dirent *,
+						struct stat64 *, void *),
+	void			*arg);
+
+bool
+fiemap(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	int			fd,
+	bool			attr_fork,
+	bool			fibmap,
+	bool			(*fn)(struct scrub_ctx *, const char *,
+				      struct fiemap_extent *, void *),
+	void			*arg);
+
+#endif /* IOCMD_H_ */
diff --git a/scrub/non_xfs.c b/scrub/non_xfs.c
new file mode 100644
index 0000000..b2f1b72
--- /dev/null
+++ b/scrub/non_xfs.c
@@ -0,0 +1,122 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "libxfs.h"
+#include <sys/statvfs.h>
+#include "disk.h"
+#include "scrub.h"
+
+/* Stub scrubbers for non-XFS filesystems. */
+
+/* Read the ext4 geometry. */
+static bool
+ext4_scan_fs(
+	struct scrub_ctx		*ctx)
+{
+	/*
+	 * ext* underreports the filesystem block size by the journal
+	 * length, so we can't verify FIEMAP info against the statvfs
+	 * counters.
+	 */
+	ctx->quirks |= SCRUB_QUIRK_IGNORE_STATFS_BLOCKS;
+	return generic_scan_fs(ctx);
+}
+
+/* extN profile */
+struct scrub_ops ext2_scrub_ops = {
+	.name			= "ext2",
+	.cleanup		= generic_cleanup,
+	.scan_fs		= ext4_scan_fs,
+	.scan_inodes		= generic_scan_inodes,
+	.check_dir		= generic_check_dir,
+	.check_inode		= generic_check_inode,
+	.scan_extents		= generic_scan_extents,
+	.scan_xattrs		= generic_scan_xattrs,
+	.scan_special_xattrs	= generic_scan_special_xattrs,
+	.scan_metadata		= generic_scan_metadata,
+	.check_summary		= generic_check_summary,
+	.read_file		= generic_read_file,
+	.scan_blocks		= generic_scan_blocks,
+	.scan_fs_tree		= generic_scan_fs_tree,
+};
+struct scrub_ops ext3_scrub_ops = {
+	.name			= "ext3",
+	.cleanup		= generic_cleanup,
+	.scan_fs		= ext4_scan_fs,
+	.scan_inodes		= generic_scan_inodes,
+	.check_dir		= generic_check_dir,
+	.check_inode		= generic_check_inode,
+	.scan_extents		= generic_scan_extents,
+	.scan_xattrs		= generic_scan_xattrs,
+	.scan_special_xattrs	= generic_scan_special_xattrs,
+	.scan_metadata		= generic_scan_metadata,
+	.check_summary		= generic_check_summary,
+	.read_file		= generic_read_file,
+	.scan_blocks		= generic_scan_blocks,
+	.scan_fs_tree		= generic_scan_fs_tree,
+};
+struct scrub_ops ext4_scrub_ops = {
+	.name			= "ext4",
+	.cleanup		= generic_cleanup,
+	.scan_fs		= ext4_scan_fs,
+	.scan_inodes		= generic_scan_inodes,
+	.check_dir		= generic_check_dir,
+	.check_inode		= generic_check_inode,
+	.scan_extents		= generic_scan_extents,
+	.scan_xattrs		= generic_scan_xattrs,
+	.scan_special_xattrs	= generic_scan_special_xattrs,
+	.scan_metadata		= generic_scan_metadata,
+	.check_summary		= generic_check_summary,
+	.read_file		= generic_read_file,
+	.scan_blocks		= generic_scan_blocks,
+	.scan_fs_tree		= generic_scan_fs_tree,
+};
+
+/* Read the btrfs geometry. */
+static bool
+btrfs_scan_fs(
+	struct scrub_ctx		*ctx)
+{
+	/*
+	 * btrfs is a volume manager, so we can't get meaningful block numbers
+	 * out of FIEMAP/FIBMAP.  It also checksums data, so raw device access
+	 * for file verify is impossible.
+	 */
+	ctx->quirks = SCRUB_QUIRK_IGNORE_STATFS_BLOCKS;
+	disk_close(&ctx->datadev);
+	return generic_scan_fs(ctx);
+}
+
+/* btrfs profile */
+struct scrub_ops btrfs_scrub_ops = {
+	.name			= "btrfs",
+	.cleanup		= generic_cleanup,
+	.scan_fs		= btrfs_scan_fs,
+	.scan_inodes		= generic_scan_inodes,
+	.check_dir		= generic_check_dir,
+	.check_inode		= generic_check_inode,
+	.scan_extents		= generic_scan_extents,
+	.scan_xattrs		= generic_scan_xattrs,
+	.scan_special_xattrs	= generic_scan_special_xattrs,
+	.scan_metadata		= generic_scan_metadata,
+	.check_summary		= generic_check_summary,
+	.read_file		= generic_read_file,
+	.scan_blocks		= generic_scan_blocks,
+	.scan_fs_tree		= generic_scan_fs_tree,
+};
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
new file mode 100644
index 0000000..aa485e7
--- /dev/null
+++ b/scrub/read_verify.c
@@ -0,0 +1,182 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "libxfs.h"
+#include <sys/statvfs.h>
+#include <sys/types.h>
+#include <dirent.h>
+#include "disk.h"
+#include "scrub.h"
+#include "../repair/threads.h"
+#include "read_verify.h"
+
+/* Tolerate 64k holes in adjacent read verify requests. */
+#define IO_BATCH_LOCALITY	(65536 >> BBSHIFT)
+
+/* Create a thread pool to run read verifiers. */
+void
+read_verify_pool_init(
+	struct read_verify_pool		*rvp,
+	struct scrub_ctx		*ctx,
+	void				*readbuf,
+	size_t				readbufsz,
+	size_t				min_io_sz,
+	read_verify_ioend_fn_t		ioend_fn,
+	read_verify_ioend_arg_free_fn_t	ioend_arg_free_fn,
+	int				nproc)
+{
+	rvp->rvp_readbuf = readbuf;
+	rvp->rvp_readbufsz = readbufsz;
+	rvp->rvp_ctx = ctx;
+	rvp->rvp_min_io_size = min_io_sz >> BBSHIFT;
+	rvp->ioend_fn = ioend_fn;
+	rvp->ioend_arg_free_fn = ioend_arg_free_fn;
+	create_work_queue(&rvp->rvp_wq, (struct xfs_mount *)rvp, nproc);
+}
+
+/* Finish up any read verification work and tear it down. */
+void
+read_verify_pool_destroy(
+	struct read_verify_pool		*rvp)
+{
+	destroy_work_queue(&rvp->rvp_wq);
+	memset(&rvp->rvp_wq, 0, sizeof(struct work_queue));
+}
+
+/*
+ * Issue a read-verify IO in big batches.
+ */
+static void
+read_verify(
+	struct work_queue		*wq,
+	xfs_agnumber_t			agno,
+	void				*arg)
+{
+	struct read_verify		*rv = arg;
+	struct read_verify_pool		*rvp;
+	ssize_t				sz;
+	ssize_t				len;
+
+	rvp = (struct read_verify_pool *)wq->mp;
+	while (rv->io_blockcount > 0) {
+		len = min(rv->io_blockcount, rvp->rvp_readbufsz >> BBSHIFT);
+		dbg_printf("pread %d %"PRIu64" %zu\n", rv->io_disk->d_fd,
+				rv->io_startblock, len);
+		sz = disk_read_verify(rv->io_disk, rvp->rvp_readbuf,
+				rv->io_startblock, len);
+		if (sz < 0) {
+			dbg_printf("IOERR %d %"PRIu64" %zu\n",
+					rv->io_disk->d_fd,
+					rv->io_startblock, len);
+			rvp->ioend_fn(rvp, rv->io_disk, rv->io_startblock,
+					rvp->rvp_min_io_size,
+					errno, rv->io_end_arg);
+			len = rvp->rvp_min_io_size;
+		}
+		rv->io_startblock += len;
+		rv->io_blockcount -= len;
+	}
+
+	if (rvp->ioend_arg_free_fn)
+		rvp->ioend_arg_free_fn(rv->io_end_arg);
+	free(rv);
+}
+
+/* Queue a read verify request. */
+static void
+read_verify_queue(
+	struct read_verify_pool		*rvp,
+	struct read_verify		*rv)
+{
+	struct read_verify		*tmp;
+
+	dbg_printf("verify fd %d daddr %"PRIu64" len %"PRIu64"\n",
+			rv->io_disk->d_fd, rv->io_startblock,
+			rv->io_blockcount);
+
+	tmp = malloc(sizeof(struct read_verify));
+	if (!tmp) {
+		rvp->ioend_fn(rvp, rv->io_disk, rv->io_startblock,
+				rv->io_blockcount, errno, rv->io_end_arg);
+		return;
+	}
+	*tmp = *rv;
+
+	queue_work(&rvp->rvp_wq, read_verify, 0, tmp);
+}
+
+/*
+ * Issue an IO request.  We'll batch subsequent requests if they're
+ * within 64k of each other
+ */
+void
+read_verify_schedule(
+	struct read_verify_pool		*rvp,
+	struct read_verify		*rv,
+	struct disk			*disk,
+	uint64_t			startblock,
+	uint64_t			blockcount,
+	void				*end_arg)
+{
+	uint64_t			ve_end;
+	uint64_t			io_end;
+
+	assert(rvp->rvp_readbuf);
+	ve_end = startblock + blockcount;
+	io_end = rv->io_startblock + rv->io_blockcount;
+
+	/*
+	 * If we have a stashed IO, we haven't changed fds, the error
+	 * reporting is the same, and the two extents are close,
+	 * we can combine them.
+	 */
+	if (rv->io_blockcount > 0 && disk == rv->io_disk &&
+	    end_arg == rv->io_end_arg &&
+	    ((startblock >= rv->io_startblock &&
+	      startblock <= io_end + IO_BATCH_LOCALITY) ||
+	     (rv->io_startblock >= startblock &&
+	      rv->io_startblock <= ve_end + IO_BATCH_LOCALITY))) {
+		rv->io_startblock = min(rv->io_startblock, startblock);
+		rv->io_blockcount = max(ve_end, io_end) - rv->io_startblock;
+	} else  {
+		/* Otherwise, issue the stashed IO (if there is one) */
+		if (rv->io_blockcount > 0)
+			read_verify_queue(rvp, rv);
+
+		/* Stash the new IO. */
+		rv->io_disk = disk;
+		rv->io_startblock = startblock;
+		rv->io_blockcount = blockcount;
+		rv->io_end_arg = end_arg;
+	}
+}
+
+/* Force any stashed IOs into the verifier. */
+void
+read_verify_force(
+	struct read_verify_pool		*rvp,
+	struct read_verify		*rv)
+{
+	assert(rvp->rvp_readbuf);
+	if (rv->io_blockcount == 0)
+		return;
+
+	read_verify_queue(rvp, rv);
+	rv->io_blockcount = 0;
+}
diff --git a/scrub/read_verify.h b/scrub/read_verify.h
new file mode 100644
index 0000000..cc9ab12
--- /dev/null
+++ b/scrub/read_verify.h
@@ -0,0 +1,58 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#ifndef READ_VERIFY_H_
+#define READ_VERIFY_H_
+
+struct read_verify_pool;
+
+typedef void (*read_verify_ioend_fn_t)(struct read_verify_pool *rvp,
+		struct disk *disk, uint64_t startblock, uint64_t blockcount,
+		int error, void *arg);
+typedef void (*read_verify_ioend_arg_free_fn_t)(void *arg);
+
+struct read_verify_pool {
+	struct work_queue	rvp_wq;
+	struct scrub_ctx	*rvp_ctx;
+	void			*rvp_readbuf;
+	size_t			rvp_readbufsz;
+	size_t			rvp_min_io_size;	/* 512b sectors */
+	read_verify_ioend_fn_t	ioend_fn;
+	read_verify_ioend_arg_free_fn_t	ioend_arg_free_fn;
+};
+
+void read_verify_pool_init(struct read_verify_pool *rvp, struct scrub_ctx *ctx,
+		void *readbuf, size_t readbufsz, size_t min_io_sz,
+		read_verify_ioend_fn_t ioend_fn,
+		read_verify_ioend_arg_free_fn_t ioend_arg_free_fn, int nproc);
+void read_verify_pool_destroy(struct read_verify_pool *rvp);
+
+struct read_verify {
+	void			*io_end_arg;
+	struct disk		*io_disk;
+	uint64_t		io_startblock;	/* 512b blocks */
+	uint64_t		io_blockcount;	/* 512b blocks */
+};
+
+void read_verify_schedule(struct read_verify_pool *rvp, struct read_verify *rv,
+		struct disk *disk, uint64_t startblock, uint64_t blockcount,
+		void *end_arg);
+void read_verify_force(struct read_verify_pool *rvp, struct read_verify *rv);
+
+#endif /* READ_VERIFY_H_ */
diff --git a/scrub/scrub.c b/scrub/scrub.c
new file mode 100644
index 0000000..3f220d5
--- /dev/null
+++ b/scrub/scrub.c
@@ -0,0 +1,698 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "libxfs.h"
+#include <stdio.h>
+#include <mntent.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/time.h>
+#include <sys/resource.h>
+#include <sys/statvfs.h>
+#include <sys/vfs.h>
+#include <fcntl.h>
+#include <dirent.h>
+#include "disk.h"
+#include "scrub.h"
+
+#define _PATH_PROC_MOUNTS	"/proc/mounts"
+
+bool				verbose;
+int				debug;
+bool				scrub_data;
+bool				dumpcore;
+bool				display_rusage;
+long				page_size;
+
+static void __attribute__((noreturn))
+usage(void)
+{
+	fprintf(stderr, _("Usage: %s [OPTIONS] mountpoint\n"), progname);
+	fprintf(stderr, _("-d:\tRun program in debug mode.\n"));
+	fprintf(stderr, _("-t:\tUse this filesystem backend for scrubbing.\n"));
+	fprintf(stderr, _("-T:\tDisplay timing/usage information.\n"));
+	fprintf(stderr, _("-v:\tVerbose output.\n"));
+	fprintf(stderr, _("-x:\tScrub file data too.\n"));
+
+	exit(16);
+}
+
+/*
+ * Check if the argument is either the device name or mountpoint of a mounted
+ * filesystem.
+ */
+static bool
+find_mountpoint_check(
+	struct stat64		*sb,
+	struct mntent		*t)
+{
+	struct stat64		ms;
+
+	if (S_ISDIR(sb->st_mode)) {		/* mount point */
+		if (stat64(t->mnt_dir, &ms) < 0)
+			return false;
+		if (sb->st_ino != ms.st_ino)
+			return false;
+		if (sb->st_dev != ms.st_dev)
+			return false;
+		/*
+		 * Since we can handle non-XFS filesystems, we don't
+		 * need to check that the device is accessible.
+		 * (The xfs_fsr version of this function does care.)
+		 */
+	} else {				/* device */
+		if (stat64(t->mnt_fsname, &ms) < 0)
+			return false;
+		if (sb->st_rdev != ms.st_rdev)
+			return false;
+		/*
+		 * Make sure the mountpoint given by mtab is accessible
+		 * before using it.
+		 */
+		if (stat64(t->mnt_dir, &ms) < 0)
+			return false;
+	}
+
+	return true;
+}
+
+/* Check that our alleged mountpoint is in mtab */
+static bool
+find_mountpoint(
+	char			*mtab,
+	struct scrub_ctx	*ctx)
+{
+	struct mntent_cursor	cursor;
+	struct mntent		*t = NULL;
+	bool			found = false;
+
+	if (platform_mntent_open(&cursor, mtab) != 0) {
+		fprintf(stderr, "Error: can't get mntent entries.\n");
+		exit(1);
+	}
+
+	while ((t = platform_mntent_next(&cursor)) != NULL) {
+		/*
+		 * Keep jotting down matching mount details; newer mounts are
+		 * towards the end of the file (hopefully).
+		 */
+		if (find_mountpoint_check(&ctx->mnt_sb, t)) {
+			ctx->mntpoint = strdup(t->mnt_dir);
+			ctx->mnt_type = strdup(t->mnt_type);
+			ctx->blkdev = strdup(t->mnt_fsname);
+			found = true;
+		}
+	}
+	platform_mntent_close(&cursor);
+	return found;
+}
+
+/* Print a string and whatever error is stored in errno. */
+void
+__str_errno(
+	struct scrub_ctx	*ctx,
+	const char		*str,
+	const char		*file,
+	int			line)
+{
+	char			buf[DESCR_BUFSZ];
+
+	pthread_mutex_lock(&ctx->lock);
+	fprintf(stderr, "%s: %s.", str, strerror_r(errno, buf, DESCR_BUFSZ));
+	if (debug)
+		fprintf(stderr, " (%s line %d)", file, line);
+	fprintf(stderr, "\n");
+	ctx->errors_found++;
+	pthread_mutex_unlock(&ctx->lock);
+}
+
+/* Print a string and some error text. */
+void
+__str_error(
+	struct scrub_ctx	*ctx,
+	const char		*str,
+	const char		*file,
+	int			line,
+	const char		*format,
+	...)
+{
+	va_list			args;
+
+	pthread_mutex_lock(&ctx->lock);
+	fprintf(stderr, "%s: ", str);
+	va_start(args, format);
+	vfprintf(stderr, format, args);
+	va_end(args);
+	if (debug)
+		fprintf(stderr, " (%s line %d)", file, line);
+	fprintf(stderr, "\n");
+	ctx->errors_found++;
+	pthread_mutex_unlock(&ctx->lock);
+}
+
+/* Print a string and some warning text. */
+void
+__str_warn(
+	struct scrub_ctx	*ctx,
+	const char		*str,
+	const char		*file,
+	int			line,
+	const char		*format,
+	...)
+{
+	va_list			args;
+
+	pthread_mutex_lock(&ctx->lock);
+	fprintf(stderr, "%s: ", str);
+	va_start(args, format);
+	vfprintf(stderr, format, args);
+	va_end(args);
+	if (debug)
+		fprintf(stderr, " (%s line %d)", file, line);
+	fprintf(stderr, "\n");
+	ctx->warnings_found++;
+	pthread_mutex_unlock(&ctx->lock);
+}
+
+/* Print a string and some informational text. */
+void
+__str_info(
+	struct scrub_ctx	*ctx,
+	const char		*str,
+	const char		*file,
+	int			line,
+	const char		*format,
+	...)
+{
+	va_list			args;
+
+	pthread_mutex_lock(&ctx->lock);
+	fprintf(stderr, "%s: ", str);
+	va_start(args, format);
+	vfprintf(stderr, format, args);
+	va_end(args);
+	if (debug)
+		fprintf(stderr, " (%s line %d)", file, line);
+	fprintf(stderr, "\n");
+	pthread_mutex_unlock(&ctx->lock);
+}
+
+static struct scrub_ops *scrub_impl[] = {
+	&xfs_scrub_ops,
+	&ext2_scrub_ops,
+	&ext3_scrub_ops,
+	&ext4_scrub_ops,
+	&btrfs_scrub_ops,
+	&generic_scrub_ops,
+	NULL
+};
+
+void __attribute__((noreturn))
+do_error(char const *msg, ...)
+{
+	va_list args;
+
+	fprintf(stderr, _("\nfatal error -- "));
+
+	va_start(args, msg);
+	vfprintf(stderr, msg, args);
+	if (dumpcore)
+		abort();
+	exit(1);
+}
+
+/* How many threads to kick off? */
+unsigned int
+scrub_nproc(
+	struct scrub_ctx	*ctx)
+{
+	if (getenv("XFS_SCRUB_NO_THREADS"))
+		return 1;
+	return ctx->nr_io_threads;
+}
+
+/* Decide if a value is within +/- (n/d) of a desired value. */
+bool
+within_range(
+	struct scrub_ctx	*ctx,
+	unsigned long long	value,
+	unsigned long long	desired,
+	unsigned long long	diff_threshold,
+	unsigned int		n,
+	unsigned int		d,
+	const char		*descr)
+{
+	assert(n < d);
+
+	/* Don't complain if difference does not exceed an absolute value. */
+	if (value < desired && desired - value < diff_threshold)
+		return true;
+	if (value > desired && value - desired < diff_threshold)
+		return true;
+
+	/* Complain if the difference exceeds a certain percentage. */
+	if (value < desired * (d - n) / d) {
+		str_warn(ctx, ctx->mntpoint,
+_("Found fewer %s than reported"), descr);
+		return false;
+	}
+	if (value > desired * (d + n) / d) {
+		str_warn(ctx, ctx->mntpoint,
+_("Found more %s than reported"), descr);
+		return false;
+	}
+	return true;
+}
+
+static float
+timeval_subtract(
+	struct timeval		*tv1,
+	struct timeval		*tv2)
+{
+	return ((tv1->tv_sec - tv2->tv_sec) +
+		((float) (tv1->tv_usec - tv2->tv_usec)) / 1000000);
+}
+
+/* Produce human readable disk space output. */
+double
+auto_space_units(
+	unsigned long long	kilobytes,
+	char			**units)
+{
+	if (kilobytes > 1073741824ULL) {
+		*units = "TiB";
+		return kilobytes / 1073741824.0;
+	} else if (kilobytes > 1048576ULL) {
+		*units = "GiB";
+		return kilobytes / 1048576.0;
+	} else if (kilobytes > 1024ULL) {
+		*units = "MiB";
+		return kilobytes / 1024.0;
+	} else {
+		*units = "KiB";
+		return kilobytes;
+	}
+}
+
+/* Produce human readable discrete number output. */
+double
+auto_units(
+	unsigned long long	number,
+	char			**units)
+{
+	if (number > 1000000000000ULL) {
+		*units = "T";
+		return number / 1000000000000.0;
+	} else if (number > 1000000000ULL) {
+		*units = "G";
+		return number / 1000000000.0;
+	} else if (number > 1000000ULL) {
+		*units = "M";
+		return number / 1000000.0;
+	} else if (number > 1000ULL) {
+		*units = "K";
+		return number / 1000.0;
+	} else {
+		*units = "";
+		return number;
+	}
+}
+
+struct phase_info {
+	struct rusage		ruse;
+	struct timeval		time;
+	void			*brk_start;
+	const char		*tag;
+};
+
+/* Start tracking resource usage for a phase. */
+static bool
+phase_start(
+	struct phase_info	*pi,
+	const char		*tag,
+	const char		*descr)
+{
+	int			error;
+
+	error = getrusage(RUSAGE_SELF, &pi->ruse);
+	if (error) {
+		perror(_("getrusage"));
+		return false;
+	}
+	pi->brk_start = sbrk(0);
+
+	error = gettimeofday(&pi->time, NULL);
+	if (error) {
+		perror(_("gettimeofday"));
+		return false;
+	}
+	pi->tag = tag;
+
+	if ((verbose || display_rusage) && descr)
+		printf(_("%s%s\n"), pi->tag, descr);
+	return true;
+}
+
+/* Report usage stats. */
+static bool
+phase_end(
+	struct phase_info	*pi)
+{
+	struct rusage		ruse_now;
+#ifdef HAVE_MALLINFO
+	struct mallinfo		mall_now;
+#endif
+	struct timeval		time_now;
+	long			iops;
+	int			error;
+
+	if (!display_rusage)
+		return true;
+
+	error = gettimeofday(&time_now, NULL);
+	if (error) {
+		perror(_("gettimeofday"));
+		return false;
+	}
+
+	error = getrusage(RUSAGE_SELF, &ruse_now);
+	if (error) {
+		perror(_("getrusage"));
+		return false;
+	}
+
+#define kbytes(x)	(((unsigned long)(x) + 1023) / 1024)
+#ifdef HAVE_MALLINFO
+
+	mall_now = mallinfo();
+	printf(_("%sMemory used: %luk/%luk (%luk/%luk), "), pi->tag,
+		kbytes(mall_now.arena), kbytes(mall_now.hblkhd),
+		kbytes(mall_now.uordblks), kbytes(mall_now.fordblks));
+#else
+	printf(_("%sMemory used: %luk, "), pi->tag,
+		(unsigned long) kbytes(((char *) sbrk(0)) -
+				       ((char *) pi->brk_start)));
+#endif
+#undef kbytes
+
+	printf(_("time: %5.2f/%5.2f/%5.2f\n"),
+		timeval_subtract(&time_now, &pi->time),
+		timeval_subtract(&ruse_now.ru_utime, &pi->ruse.ru_utime),
+		timeval_subtract(&ruse_now.ru_stime, &pi->ruse.ru_stime));
+	iops =  ruse_now.ru_inblock - pi->ruse.ru_inblock +
+		ruse_now.ru_oublock - pi->ruse.ru_oublock;
+	printf(_("%sI/O: %lu in/%lu out, rate: %.2f iops\n"), pi->tag,
+		ruse_now.ru_inblock - pi->ruse.ru_inblock,
+		ruse_now.ru_oublock - pi->ruse.ru_oublock,
+		(float)iops / timeval_subtract(&time_now, &pi->time));
+
+	return true;
+}
+
+/* Find filesystem geometry and perform any other setup functions. */
+static bool
+find_geo(
+	struct scrub_ctx	*ctx)
+{
+	bool			moveon;
+	int			error;
+
+	ctx->mnt_fd = open(ctx->mntpoint, O_RDONLY | O_NOATIME | O_DIRECTORY);
+	if (ctx->mnt_fd < 0) {
+		if (errno == EPERM)
+			str_error(ctx, ctx->mntpoint,
+_("Must be root to run scrub."));
+		else
+			str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+	error = disk_open(ctx->blkdev, &ctx->datadev);
+	if (error && errno != ENOENT)
+		str_errno(ctx, ctx->blkdev);
+
+	error = fstat64(ctx->mnt_fd, &ctx->mnt_sb);
+	if (error) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+	error = fstatvfs(ctx->mnt_fd, &ctx->mnt_sv);
+	if (error) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+	error = fstatfs(ctx->mnt_fd, &ctx->mnt_sf);
+	if (error) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+	if (disk_is_open(&ctx->datadev))
+		ctx->nr_io_threads = disk_heads(&ctx->datadev);
+	else
+		ctx->nr_io_threads = libxfs_nproc();
+	moveon = ctx->ops->scan_fs(ctx);
+	if (verbose)
+		printf(_("%s: using %d threads to scrub.\n"),
+				ctx->mntpoint, ctx->nr_io_threads);
+
+	return moveon;
+}
+
+struct scrub_phase {
+	char		*descr;
+	bool		(*fn)(struct scrub_ctx *);
+};
+
+/* Run all the phases of the scrubber. */
+static bool
+run_scrub_phases(
+	struct scrub_ctx	*ctx)
+{
+	struct scrub_phase	phases[] = {
+		{_("Find filesystem geometry."),   find_geo},
+		{_("Check internal metadata."),	   ctx->ops->scan_metadata},
+		{_("Scan all inodes."),		   ctx->ops->scan_inodes},
+		{_("Check directory structure."),  ctx->ops->scan_fs_tree},
+		{_("Verify data file integrity."), ctx->ops->scan_blocks},
+		{_("Check summary counters."),	   ctx->ops->check_summary},
+		{NULL, NULL, NULL},
+	};
+	struct phase_info	pi;
+	char			buf[DESCR_BUFSZ];
+	struct scrub_phase	*phase;
+	bool			moveon;
+	int			c;
+
+	/* Run all phases of the scrub tool. */
+	for (c = 1, phase = phases; phase->descr; phase++, c++) {
+		snprintf(buf, DESCR_BUFSZ, _("Phase %d: "), c);
+		moveon = phase_start(&pi, buf, phase->descr);
+		if (!moveon)
+			return false;
+		moveon = phase->fn(ctx);
+		if (!moveon)
+			return false;
+		moveon = phase_end(&pi);
+		if (!moveon)
+			return false;
+	}
+
+	return true;
+}
+
+int
+main(
+	int			argc,
+	char			**argv)
+{
+	int			c;
+	char			*mtab = NULL;
+	struct scrub_ctx	ctx;
+	struct phase_info	all_pi;
+	bool			ismnt;
+	bool			moveon = true;
+	int			ret;
+	struct scrub_ops	**ops;
+	int			error;
+
+	progname = basename(argv[0]);
+	setlocale(LC_ALL, "");
+	bindtextdomain(PACKAGE, LOCALEDIR);
+	textdomain(PACKAGE);
+
+	pthread_mutex_init(&ctx.lock, NULL);
+	memset(&ctx, 0, sizeof(struct scrub_ctx));
+	ctx.datadev.d_fd = -1;
+	while ((c = getopt(argc, argv, "dm:Tt:vxV")) != EOF) {
+		switch (c) {
+		case 'd':
+			debug++;
+			dumpcore = true;
+			break;
+		case 'm':
+			mtab = optarg;
+			break;
+		case 't':
+			for (ops = scrub_impl; *ops; ops++) {
+				if (!strcmp(optarg, (*ops)->name)) {
+					ctx.ops = *ops;
+					break;
+				}
+			}
+			if (!ctx.ops) {
+				fprintf(stderr,
+_("Unknown filesystem driver '%s'.\n"),
+						optarg);
+				return 1;
+			}
+			break;
+		case 'T':
+			display_rusage = true;
+			break;
+		case 'v':
+			verbose = true;
+			break;
+		case 'x':
+			scrub_data = true;
+			break;
+		case 'V':
+			printf(_("%s version %s\n"), progname, VERSION);
+			exit(0);
+		case '?':
+			/* fall through */
+		default:
+			usage();
+		}
+	}
+
+	if (optind != argc - 1)
+		usage();
+
+	ctx.mntpoint = argv[optind];
+	if (!getenv("XFS_SCRUB_NO_FIEMAP"))
+		ctx.quirks |= SCRUB_QUIRK_FIEMAP_WORKS |
+			      SCRUB_QUIRK_FIEMAP_ATTR_WORKS;
+	if (!getenv("XFS_SCRUB_NO_FIBMAP"))
+		ctx.quirks |= SCRUB_QUIRK_FIBMAP_WORKS;
+
+	/* Find the mount record for the passed-in argument. */
+
+	if (stat64(argv[optind], &ctx.mnt_sb) < 0) {
+		fprintf(stderr,
+			_("%s: could not stat: %s: %s\n"),
+			progname, argv[optind], strerror(errno));
+		return 16;
+	}
+
+	/*
+	 * If the user did not specify an explicit mount table, try to use
+	 * /proc/mounts if it is available, else /etc/mtab.  We prefer
+	 * /proc/mounts because it is kernel controlled, while /etc/mtab
+	 * may contain garbage that userspace tools like pam_mounts wrote
+	 * into it.
+	 */
+	if (!mtab) {
+		if (access(_PATH_PROC_MOUNTS, R_OK) == 0)
+			mtab = _PATH_PROC_MOUNTS;
+		else
+			mtab = _PATH_MOUNTED;
+	}
+
+	ismnt = find_mountpoint(mtab, &ctx);
+	if (!ismnt) {
+		fprintf(stderr, _("%s: Not a mount point or block device.\n"),
+			ctx.mntpoint);
+		return 16;
+	}
+
+	/* Find an appropriate scrub backend. */
+	for (ops = scrub_impl; !ctx.ops && *ops; ops++) {
+		if (!strcmp(ctx.mnt_type, (*ops)->name))
+			ctx.ops = *ops;
+	}
+	if (!ctx.ops)
+		ctx.ops = &generic_scrub_ops;
+	if (verbose)
+		printf(_("%s: scrubbing %s filesystem with %s driver.\n"),
+			ctx.mntpoint, ctx.mnt_type, ctx.ops->name);
+
+	/* Set up a page-aligned buffer for read verification. */
+	page_size = sysconf(_SC_PAGESIZE);
+	if (page_size < 0) {
+		str_errno(&ctx, ctx.mntpoint);
+		goto out;
+	}
+
+	/* Try to allocate a read buffer if we don't have one. */
+	error = posix_memalign((void **)&ctx.readbuf, page_size,
+			IO_MAX_SIZE);
+	if (error || !ctx.readbuf) {
+		str_errno(&ctx, ctx.mntpoint);
+		goto out;
+	}
+
+	/* Flush everything out to disk before we start. */
+	error = syncfs(ctx.mnt_fd);
+	if (error) {
+		str_errno(&ctx, ctx.mntpoint);
+		goto out;
+	}
+
+	/* Scrub a filesystem. */
+	moveon = phase_start(&all_pi, "", NULL);
+	if (!moveon)
+		goto out;
+	moveon = run_scrub_phases(&ctx);
+	if (!moveon)
+		goto out;
+
+out:
+	ret = 0;
+	if (errno || !moveon)
+		ret |= 8;
+
+	/* Clean up scan data. */
+	moveon = ctx.ops->cleanup(&ctx);
+	if (!moveon)
+		ret |= 8;
+
+	if (ctx.errors_found && ctx.warnings_found)
+		fprintf(stderr,
+_("%s: %lu errors and %lu warnings found.  Unmount and run fsck.\n"),
+			ctx.mntpoint, ctx.errors_found, ctx.warnings_found);
+	else if (ctx.errors_found && ctx.warnings_found == 0)
+		fprintf(stderr,
+_("%s: %lu errors found.  Unmount and run fsck.\n"),
+			ctx.mntpoint, ctx.errors_found);
+	else if (ctx.errors_found == 0 && ctx.warnings_found)
+		fprintf(stderr,
+_("%s: %lu warnings found.\n"),
+			ctx.mntpoint, ctx.warnings_found);
+	if (ctx.errors_found)
+		ret |= 4;
+	phase_end(&all_pi);
+	close(ctx.mnt_fd);
+	disk_close(&ctx.datadev);
+
+	free(ctx.blkdev);
+	free(ctx.readbuf);
+	free(ctx.mntpoint);
+	free(ctx.mnt_type);
+	return ret;
+}
diff --git a/scrub/scrub.h b/scrub/scrub.h
new file mode 100644
index 0000000..b0b3862
--- /dev/null
+++ b/scrub/scrub.h
@@ -0,0 +1,147 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#ifndef SCRUB_H_
+#define SCRUB_H_
+
+#define DESCR_BUFSZ		256
+
+/*
+ * Perform all IO in 8M chunks.  This cannot exceed 65536 sectors
+ * because that's the biggest SCSI VERIFY(16) we dare to send.
+ */
+#define IO_MAX_SIZE		8388608
+#define IO_MAX_SECTORS		(IO_MAX_SIZE >> BBSHIFT)
+
+struct scrub_ctx;
+
+struct scrub_ops {
+	const char	*name;
+	bool (*cleanup)(struct scrub_ctx *ctx);
+	bool (*scan_fs)(struct scrub_ctx *ctx);
+	bool (*scan_inodes)(struct scrub_ctx *ctx);
+	bool (*check_dir)(struct scrub_ctx *ctx, const char *descr, int dir_fd);
+	bool (*check_inode)(struct scrub_ctx *ctx, const char *descr, int fd,
+			    struct stat64 *sb);
+	bool (*scan_extents)(struct scrub_ctx *ctx, const char *descr, int fd,
+			     struct stat64 *sb, bool attr_fork);
+	bool (*scan_xattrs)(struct scrub_ctx *ctx, const char *descr, int fd);
+	bool (*scan_special_xattrs)(struct scrub_ctx *ctx, const char *path);
+	bool (*scan_metadata)(struct scrub_ctx *ctx);
+	bool (*check_summary)(struct scrub_ctx *ctx);
+	bool (*scan_blocks)(struct scrub_ctx *ctx);
+	bool (*read_file)(struct scrub_ctx *ctx, const char *descr, int fd,
+			  struct stat64 *sb);
+	bool (*scan_fs_tree)(struct scrub_ctx *ctx);
+};
+
+#define SCRUB_QUIRK_FIEMAP_WORKS		(1 << 0)
+#define SCRUB_QUIRK_FIEMAP_ATTR_WORKS		(1 << 1)
+#define SCRUB_QUIRK_FIBMAP_WORKS		(1 << 2)
+#define SCRUB_QUIRK_IGNORE_STATFS_BLOCKS	(1 << 3)
+struct scrub_ctx {
+	/* Immutable scrub state. */
+	struct scrub_ops	*ops;
+	char			*mntpoint;
+	int			mnt_fd;
+	char			*blkdev;
+	struct disk		datadev;
+	unsigned int		nr_io_threads;
+	char			*mnt_type;
+	struct stat64		mnt_sb;
+	struct statvfs		mnt_sv;
+	struct statfs		mnt_sf;
+	void			*readbuf;
+
+	/* Mutable scrub state; use lock. */
+	pthread_mutex_t		lock;
+	unsigned long		errors_found;
+	unsigned long		warnings_found;
+	unsigned long		quirks;
+
+	void			*priv;
+};
+
+extern bool		verbose;
+extern int		debug;
+extern bool		scrub_data;
+extern long		page_size;
+
+void __str_errno(struct scrub_ctx *, const char *, const char *, int);
+void __str_error(struct scrub_ctx *, const char *, const char *, int,
+		 const char *, ...);
+void __str_warn(struct scrub_ctx *, const char *, const char *, int,
+		const char *, ...);
+void __str_info(struct scrub_ctx *, const char *, const char *, int,
+		const char *, ...);
+
+#define str_errno(ctx, str)		__str_errno(ctx, str, __FILE__, __LINE__)
+#define str_error(ctx, str, ...)	__str_error(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
+#define str_warn(ctx, str, ...)		__str_warn(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
+#define str_info(ctx, str, ...)		__str_info(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
+#define dbg_printf(fmt, ...)		{if (debug > 1) {printf(fmt, __VA_ARGS__);}}
+
+#define container_of(ptr, type, member) ({			\
+	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
+		(type *)( (char *)__mptr - offsetof(type,member) );})
+
+extern struct scrub_ops	generic_scrub_ops;
+extern struct scrub_ops	xfs_scrub_ops;
+extern struct scrub_ops	ext2_scrub_ops;
+extern struct scrub_ops	ext3_scrub_ops;
+extern struct scrub_ops	ext4_scrub_ops;
+extern struct scrub_ops	btrfs_scrub_ops;
+
+/* Generic implementations of the ops functions */
+bool generic_cleanup(struct scrub_ctx *ctx);
+bool generic_scan_fs(struct scrub_ctx *ctx);
+bool generic_scan_inodes(struct scrub_ctx *ctx);
+bool generic_check_dir(struct scrub_ctx *ctx, const char *descr, int dir_fd);
+bool generic_check_inode(struct scrub_ctx *ctx, const char *descr, int fd,
+			 struct stat64 *sb);
+bool generic_scan_extents(struct scrub_ctx *ctx, const char *descr, int fd,
+			  struct stat64 *sb, bool attr_fork);
+bool generic_scan_xattrs(struct scrub_ctx *ctx, const char *descr, int fd);
+bool generic_scan_special_xattrs(struct scrub_ctx *ctx, const char *path);
+bool generic_scan_metadata(struct scrub_ctx *ctx);
+bool generic_check_summary(struct scrub_ctx *ctx);
+bool generic_read_file(struct scrub_ctx *ctx, const char *descr, int fd,
+		       struct stat64 *sb);
+bool generic_scan_blocks(struct scrub_ctx *ctx);
+bool generic_scan_fs_tree(struct scrub_ctx *ctx);
+
+/* Miscellaneous utility functions */
+unsigned int scrub_nproc(struct scrub_ctx *ctx);
+bool generic_check_directory(struct scrub_ctx *ctx, const char *descr,
+		int *pfd);
+bool within_range(struct scrub_ctx *ctx, unsigned long long value,
+		unsigned long long desired, unsigned long long diff_threshold,
+		unsigned int n, unsigned int d, const char *descr);
+double auto_space_units(unsigned long long kilobytes, char **units);
+double auto_units(unsigned long long number, char **units);
+
+#ifndef HAVE_SYNCFS
+static inline int syncfs(int fd)
+{
+	sync();
+	return 0;
+}
+#endif
+
+#endif /* SCRUB_H_ */
diff --git a/scrub/xfs.c b/scrub/xfs.c
new file mode 100644
index 0000000..18d9a11
--- /dev/null
+++ b/scrub/xfs.c
@@ -0,0 +1,2272 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "libxfs.h"
+#include <sys/statvfs.h>
+#include <sys/types.h>
+#include <dirent.h>
+#include <attr/attributes.h>
+#include "disk.h"
+#include "scrub.h"
+#include "../repair/threads.h"
+#include "handle.h"
+#include "path.h"
+#include "xfs_ioctl.h"
+#include "read_verify.h"
+#include "extent.h"
+#include "iocmd.h"
+
+/*
+ * XFS Scrubbing Strategy
+ *
+ * The XFS scrubber is much more thorough than the generic scrubber
+ * because we can use custom XFS ioctls to probe more deeply into the
+ * internals of the filesystem.  Furthermore, we can take advantage of
+ * scrubbing ioctls to check all the records stored in a metadata btree
+ * and cross-reference those records against the other btrees.
+ *
+ * The "find geometry" phase queries XFS for the filesystem geometry.
+ * The block devices for the data, realtime, and log devices are opened.
+ * Kernel ioctls are queried to see if they are implemented, and a data
+ * file read-verify strategy is selected.
+ *
+ * In the "check internal metadata" phase, we call the SCRUB_METADATA
+ * ioctl to check the filesystem's internal per-AG btrees.  This
+ * includes the AG superblock, AGF, AGFL, and AGI headers, freespace
+ * btrees, the regular and free inode btrees, the reverse mapping
+ * btrees, and the reference counting btrees.  If the realtime device is
+ * enabled, the realtime bitmap and reverse mapping btrees are enabled.
+ * Each AG (and the realtime device) has its metadata checked in a
+ * separate thread for better performance.
+ *
+ * The "scan inodes" phase uses BULKSTAT to scan all the inodes in an
+ * AG in disk order.  From the BULKSTAT information, a file handle is
+ * constructed and the following items are checked:
+ *
+ *     - If it's a symlink, the target is read but not validated.
+ *     - Bulkstat data is checked.
+ *     - If the inode is a file or a directory, a file descriptor is
+ *       opened to pin the inode and for further analysis.
+ *     - Extended attribute names and values are read via the file
+ *       handle.  If this fails and we have a file descriptor open, we
+ *       retry with the generic extended attribute APIs.
+ *     - If the inode is not a file or directory, we're done.
+ *     - Extent maps are scanned to ensure that the records make sense.
+ *       We also use the SCRUB_METADATA ioctl for better checking of the
+ *       block mapping records.
+ *     - If the inode is a directory, open the directory and check that
+ *       the dirent type code and inode numbers match the stat output.
+ *
+ * Multiple threads are started to check each the inodes of each AG in
+ * parallel.
+ *
+ * If BULKSTAT is available, we can skip the "check directory structure"
+ * phase because directories were checked during the inode scan.
+ * Otherwise, the generic directory structure check is used.
+ *
+ * In the "verify data file integrity" phase, we can employ multiple
+ * strategies to read-verify the data blocks:
+ *
+ *     - If GETFSMAP is available, use it to read the reverse-mappings of
+ *       all AGs and issue direct-reads of the underlying disk blocks.
+ *       We rely on the underlying storage to have checksummed the data
+ *       blocks appropriately.
+ *     - If GETBMAPX is available, we use BULKSTAT (or a directory tree
+ *       walk) to iterate all inodes and issue direct-reads of the
+ *       underlying data.  Similar to the generic read-verify, the data
+ *       extents are buffered through a bitmap, which is used to issue
+ *       larger IOs.  Errors are recorded and cross-referenced through
+ *       a second BULKSTAT/GETBMAPX run.
+ *     - Otherwise, call the generic handler to verify file data.
+ *
+ * Multiple threads are started to check each AG in parallel.  A
+ * separate thread pool is used to handle the direct reads.
+ *
+ * In the "check summary counters" phase, use GETFSMAP to tally up the
+ * blocks and BULKSTAT to tally up the inodes we saw and compare that to
+ * the statfs output.  This gives the user a rough estimate of how
+ * thorough the scrub was.
+ */
+
+/* Routines to scrub an XFS filesystem. */
+
+enum data_scrub_type {
+	DS_NOSCRUB,		/* no data scrub */
+	DS_READ,		/* generic_scan_blocks */
+	DS_BULKSTAT_READ,	/* bulkstat and generic_file_read */
+	DS_BMAPX,		/* bulkstat, getbmapx, and read_verify */
+	DS_FSMAP,		/* getfsmap and read_verify */
+};
+
+struct xfs_scrub_ctx {
+	struct xfs_fsop_geom	geo;
+	struct fs_path		fsinfo;
+	unsigned int		agblklog;
+	unsigned int		blocklog;
+	unsigned int		inodelog;
+	unsigned int		inopblog;
+	struct disk		datadev;
+	struct disk		logdev;
+	struct disk		rtdev;
+	void			*fshandle;
+	size_t			fshandle_len;
+	bool			kernel_scrub;	/* have kernel scrub assist? */
+	bool			fsmap;		/* have getfsmap ioctl? */
+	bool			bulkstat;	/* have bulkstat ioctl? */
+	bool			bmapx;		/* have bmapx ioctl? */
+	bool			checked_xattrs;	/* did we check all xattrs? */
+	bool			parent_ptrs;	/* have parent pointers? */
+	struct read_verify_pool	rvp;
+	enum data_scrub_type	data_scrubber;
+};
+
+/* Find the fd for a given device identifier. */
+static struct disk *
+xfs_dev_to_disk(
+	struct xfs_scrub_ctx	*xctx,
+	dev_t			dev)
+{
+	if (dev == xctx->fsinfo.fs_datadev)
+		return &xctx->datadev;
+	else if (dev == xctx->fsinfo.fs_logdev)
+		return &xctx->logdev;
+	else if (dev == xctx->fsinfo.fs_rtdev)
+		return &xctx->rtdev;
+	assert(0);
+}
+
+/* Find the device major/minor for a given file descriptor. */
+static dev_t
+xfs_disk_to_dev(
+	struct xfs_scrub_ctx	*xctx,
+	struct disk		*disk)
+{
+	if (disk == &xctx->datadev)
+		return xctx->fsinfo.fs_datadev;
+	else if (disk == &xctx->logdev)
+		return xctx->fsinfo.fs_logdev;
+	else if (disk == &xctx->rtdev)
+		return xctx->fsinfo.fs_rtdev;
+	assert(0);
+}
+
+struct owner_decode {
+	uint64_t		owner;
+	const char		*descr;
+};
+
+static const struct owner_decode special_owners[] = {
+	{FMV_OWN_FREE,		"free space"},
+	{FMV_OWN_UNKNOWN,	"unknown owner"},
+	{FMV_OWN_FS,		"static FS metadata"},
+	{FMV_OWN_LOG,		"journalling log"},
+	{FMV_OWN_AG,		"per-AG metadata"},
+	{FMV_OWN_INOBT,		"inode btree blocks"},
+	{FMV_OWN_INODES,	"inodes"},
+	{FMV_OWN_REFC,		"refcount btree"},
+	{FMV_OWN_COW,		"CoW staging"},
+	{FMV_OWN_DEFECTIVE,	"bad blocks"},
+	{0, NULL},
+};
+
+/* Decode a special owner. */
+static const char *
+xfs_decode_special_owner(
+	uint64_t			owner)
+{
+	const struct owner_decode	*od = special_owners;
+
+	while (od->descr) {
+		if (od->owner == owner)
+			return od->descr;
+		od++;
+	}
+
+	return NULL;
+}
+
+/* BULKSTAT wrapper routines. */
+
+/* Scan all the inodes in an AG. */
+static void
+xfs_scan_ag_inodes(
+	struct work_queue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
+{
+	struct xfs_inode_iter	*is = (struct xfs_inode_iter *)arg;
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->mp;
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	uint64_t		ag_ino;
+	uint64_t		next_ag_ino;
+	bool			moveon;
+
+	ag_ino = (__u64)agno << (xctx->inopblog + xctx->agblklog);
+	next_ag_ino = (__u64)(agno + 1) << (xctx->inopblog + xctx->agblklog);
+
+	moveon = xfs_iterate_inodes(ctx, is, agno, xctx->fshandle, ag_ino,
+			next_ag_ino - 1);
+	if (!moveon)
+		is->moveon = false;
+}
+
+/* Scan all the inodes in a filesystem. */
+static bool
+xfs_scan_all_inodes(
+	struct scrub_ctx	*ctx,
+	bool			(*fn)(struct scrub_ctx *, xfs_agnumber_t,
+				      struct xfs_handle *,
+				      struct xfs_bstat *, void *),
+	void			*arg)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	xfs_agnumber_t		agno;
+	struct work_queue	wq;
+	struct xfs_inode_iter	is;
+
+	if (!xctx->bulkstat)
+		return true;
+
+	is.moveon = true;
+	is.fn = fn;
+	is.arg = arg;
+
+	create_work_queue(&wq, (struct xfs_mount *)ctx, scrub_nproc(ctx));
+	for (agno = 0; agno < xctx->geo.agcount; agno++)
+		queue_work(&wq, xfs_scan_ag_inodes, agno, &is);
+	destroy_work_queue(&wq);
+
+	return is.moveon;
+}
+
+/* GETFSMAP wrappers routines. */
+
+/* Iterate all the reverse mappings of an AG. */
+static void
+xfs_scan_ag_blocks(
+	struct work_queue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
+{
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->mp;
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	struct xfs_fsmap_iter	*xfi = arg;
+	struct getfsmap		map[2];
+	off64_t			bbperag;
+	bool			moveon;
+
+	bbperag = (off64_t)xctx->geo.agblocks *
+		  (off64_t)xctx->geo.blocksize / BBSIZE;
+
+	memset(map, 0, sizeof(*map) * 2);
+	map->fmv_device = xctx->fsinfo.fs_datadev;
+	map->fmv_block = agno * bbperag;
+	(map + 1)->fmv_device = xctx->fsinfo.fs_datadev;
+	(map + 1)->fmv_block = ((agno + 1) * bbperag) - 1;
+	(map + 1)->fmv_owner = ULLONG_MAX;
+	(map + 1)->fmv_offset = ULLONG_MAX;
+	(map + 1)->fmv_oflags = UINT_MAX;
+
+	moveon = xfs_iterate_fsmap(ctx, xfi, agno, map);
+	if (!moveon)
+		xfi->moveon = false;
+}
+
+/* Iterate all the reverse mappings of a standalone device. */
+static void
+xfs_scan_dev_blocks(
+	struct scrub_ctx	*ctx,
+	int			idx,
+	struct xfs_fsmap_iter	*xfi,
+	dev_t			dev)
+{
+	struct getfsmap		map[2];
+	bool			moveon;
+
+	memset(map, 0, sizeof(*map) * 2);
+	map->fmv_device = dev;
+	(map + 1)->fmv_device = dev;
+	(map + 1)->fmv_block = ULLONG_MAX;
+	(map + 1)->fmv_owner = ULLONG_MAX;
+	(map + 1)->fmv_offset = ULLONG_MAX;
+	(map + 1)->fmv_oflags = UINT_MAX;
+
+	moveon = xfs_iterate_fsmap(ctx, xfi, idx, map);
+	if (!moveon)
+		xfi->moveon = false;
+}
+
+/* Iterate all the reverse mappings of the realtime device. */
+static void
+xfs_scan_rt_blocks(
+	struct work_queue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
+{
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->mp;
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	struct xfs_fsmap_iter	*xfi = arg;
+
+	xfs_scan_dev_blocks(ctx, agno, xfi, xctx->fsinfo.fs_rtdev);
+}
+
+/* Iterate all the reverse mappings of the log device. */
+static void
+xfs_scan_log_blocks(
+	struct work_queue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
+{
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->mp;
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	struct xfs_fsmap_iter	*xfi = arg;
+
+	xfs_scan_dev_blocks(ctx, agno, xfi, xctx->fsinfo.fs_logdev);
+}
+
+/* Scan all the blocks in a filesystem. */
+static bool
+xfs_scan_all_blocks(
+	struct scrub_ctx	*ctx,
+	bool			(*fn)(struct scrub_ctx *, const char *, int,
+				      struct getfsmap *, void *),
+	void			*arg)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	xfs_agnumber_t		agno;
+	struct work_queue	wq;
+	struct xfs_fsmap_iter	bs;
+
+	bs.moveon = true;
+	bs.fn = fn;
+	bs.arg = arg;
+
+	create_work_queue(&wq, (struct xfs_mount *)ctx, scrub_nproc(ctx));
+	if (xctx->fsinfo.fs_rt)
+		queue_work(&wq, xfs_scan_rt_blocks, -1, &bs);
+	if (xctx->fsinfo.fs_log)
+		queue_work(&wq, xfs_scan_log_blocks, -2, &bs);
+	for (agno = 0; agno < xctx->geo.agcount; agno++)
+		queue_work(&wq, xfs_scan_ag_blocks, agno, &bs);
+	destroy_work_queue(&wq);
+
+	return bs.moveon;
+}
+
+/* Routines to translate bad physical extents into file paths and offsets. */
+
+struct xfs_verify_error_info {
+	struct extent_tree		*d_bad;
+	struct extent_tree		*r_bad;
+};
+
+/* Report if this extent overlaps a bad region. */
+static bool
+xfs_report_verify_inode_bmap(
+	struct scrub_ctx		*ctx,
+	const char			*descr,
+	int				fd,
+	int				whichfork,
+	struct fsxattr			*fsx,
+	struct getbmapx			*bmap,
+	void				*arg)
+{
+	struct xfs_verify_error_info	*vei = arg;
+	struct extent_tree		*tree;
+
+	/*
+	 * Only do data scrubbing if the extent is neither unwritten nor
+	 * delalloc.
+	 */
+	if (bmap->bmv_oflags & (BMV_OF_PREALLOC | BMV_OF_DELALLOC))
+		return true;
+
+	if (fsx->fsx_xflags & FS_XFLAG_REALTIME)
+		tree = vei->r_bad;
+	else
+		tree = vei->d_bad;
+
+	if (!extent_tree_has_extent(tree, bmap->bmv_block, bmap->bmv_length))
+		return true;
+
+	str_error(ctx, descr,
+_("offset %llu failed read verification."),
+			bmap->bmv_offset);
+	return true;
+}
+
+/* Iterate the extent mappings of a file to report errors. */
+static bool
+xfs_report_verify_fd(
+	struct scrub_ctx		*ctx,
+	const char			*descr,
+	int				fd,
+	void				*arg)
+{
+	struct xfs_bmap_iter		xbi;
+	struct getbmapx			key;
+	bool				moveon;
+
+	xbi.moveon = true;
+	xbi.arg = arg;
+	xbi.descr = descr;
+	xbi.fn = xfs_report_verify_inode_bmap;
+
+	/* data fork */
+	memset(&key, 0, sizeof(key));
+	key.bmv_length = ULLONG_MAX;
+	moveon = xfs_iterate_bmap(ctx, &xbi, fd, XFS_DATA_FORK, &key);
+	if (!moveon || !xbi.moveon)
+		return false;
+
+	/* attr fork */
+	memset(&key, 0, sizeof(key));
+	key.bmv_length = ULLONG_MAX;
+	moveon = xfs_iterate_bmap(ctx, &xbi, fd, XFS_ATTR_FORK, &key);
+	if (!moveon || !xbi.moveon)
+		return false;
+	return true;
+}
+
+/* Report read verify errors in unlinked (but still open) files. */
+static bool
+xfs_report_verify_inode(
+	struct scrub_ctx		*ctx,
+	xfs_agnumber_t			agno,
+	struct xfs_handle		*handle,
+	struct xfs_bstat		*bstat,
+	void				*arg)
+{
+	char				descr[DESCR_BUFSZ];
+	bool				moveon;
+	int				fd;
+
+	/* Ignore linked files and things we can't open. */
+	if (bstat->bs_nlink != 0)
+		return true;
+	if (!S_ISREG(bstat->bs_mode) && !S_ISDIR(bstat->bs_mode))
+		return true;
+
+	/* Try to open the inode. */
+	fd = open_by_fshandle(handle, sizeof(*handle),
+			O_RDONLY | O_NOATIME | O_NOFOLLOW | O_NOCTTY);
+	if (fd < 0)
+		return true;
+
+	/* Go find the badness. */
+	snprintf(descr, DESCR_BUFSZ, _("inode %llu (unlinked)"), bstat->bs_ino);
+	moveon = xfs_report_verify_fd(ctx, descr, fd, arg);
+	if (moveon)
+		goto out;
+
+out:
+	close(fd);
+	return moveon;
+}
+
+/* Scan the inode associated with a directory entry. */
+static bool
+xfs_report_verify_dirent(
+	struct scrub_ctx	*ctx,
+	const char		*path,
+	int			dir_fd,
+	struct dirent		*dirent,
+	struct stat64		*sb,
+	void			*arg)
+{
+	bool			moveon;
+	int			fd;
+
+	/* Ignore things we can't open. */
+	if (!S_ISREG(sb->st_mode) && !S_ISDIR(sb->st_mode))
+		return true;
+	/* Ignore . and .. */
+	if (!strcmp(".", dirent->d_name) || !strcmp("..", dirent->d_name))
+		return true;
+
+	/* Open the file */
+	fd = openat(dir_fd, dirent->d_name,
+			O_RDONLY | O_NOATIME | O_NOFOLLOW | O_NOCTTY);
+	if (fd < 0)
+		return true;
+
+	/* Go find the badness. */
+	moveon = xfs_report_verify_fd(ctx, path, fd, arg);
+	if (moveon)
+		goto out;
+
+out:
+	close(fd);
+
+	return moveon;
+}
+
+/* Given bad extent lists for the data & rtdev, find bad files. */
+static bool
+xfs_report_verify_errors(
+	struct scrub_ctx		*ctx,
+	struct extent_tree		*d_bad,
+	struct extent_tree		*r_bad)
+{
+	struct xfs_verify_error_info	vei;
+	bool				moveon;
+
+	vei.d_bad = d_bad;
+	vei.r_bad = r_bad;
+
+	/* Scan the directory tree to get file paths. */
+	moveon = scan_fs_tree(ctx, NULL, xfs_report_verify_dirent, &vei);
+	if (!moveon)
+		return false;
+
+	/* Scan for unlinked files. */
+	return xfs_scan_all_inodes(ctx, xfs_report_verify_inode, &vei);
+}
+
+/* Phase 1 */
+
+/* Clean up the XFS-specific state data. */
+static bool
+xfs_cleanup(
+	struct scrub_ctx	*ctx)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+
+	if (!xctx)
+		goto out;
+	if (xctx->fshandle)
+		free_handle(xctx->fshandle, xctx->fshandle_len);
+	disk_close(&xctx->rtdev);
+	disk_close(&xctx->logdev);
+	disk_close(&xctx->datadev);
+	free(ctx->priv);
+	ctx->priv = NULL;
+
+out:
+	return generic_cleanup(ctx);
+}
+
+/* Read the XFS geometry. */
+static bool
+xfs_scan_fs(
+	struct scrub_ctx		*ctx)
+{
+	struct xfs_scrub_ctx		*xctx;
+	struct fs_path			*fsp;
+	int				error;
+
+	if (!platform_test_xfs_fd(ctx->mnt_fd)) {
+		str_error(ctx, ctx->mntpoint,
+_("Does not appear to be an XFS filesystem!"));
+		return false;
+	}
+
+	xctx = calloc(1, sizeof(struct xfs_scrub_ctx));
+	if (!ctx) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+	xctx->datadev.d_fd = xctx->logdev.d_fd = xctx->rtdev.d_fd = -1;
+
+	/* Retrieve XFS geometry. */
+	error = xfsctl(ctx->mntpoint, ctx->mnt_fd, XFS_IOC_FSGEOMETRY,
+			&xctx->geo);
+	if (error) {
+		str_errno(ctx, ctx->mntpoint);
+		goto err;
+	}
+	ctx->priv = xctx;
+
+	xctx->agblklog = libxfs_log2_roundup(xctx->geo.agblocks);
+	xctx->blocklog = libxfs_highbit32(xctx->geo.blocksize);
+	xctx->inodelog = libxfs_highbit32(xctx->geo.inodesize);
+	xctx->inopblog = xctx->blocklog - xctx->inodelog;
+
+	error = path_to_fshandle(ctx->mntpoint, &xctx->fshandle,
+			&xctx->fshandle_len);
+	if (error) {
+		perror(_("getting fshandle"));
+		goto err;
+	}
+
+	/* Do we have bulkstat? */
+	xctx->bulkstat = xfs_can_iterate_inodes(ctx);
+	if (!xctx->bulkstat)
+		str_info(ctx, ctx->mntpoint,
+_("Kernel lacks BULKSTAT; scrub will be incomplete."));
+
+	/* Do we have kernel-assisted scrubbing? */
+	xctx->kernel_scrub = xfs_can_scrub_metadata(ctx);
+	if (!xctx->kernel_scrub)
+		str_info(ctx, ctx->mntpoint,
+_("Kernel cannot help scrub metadata; scrub will be incomplete."));
+
+	/* Do we have getbmapx? */
+	xctx->bmapx = xfs_can_iterate_bmap(ctx);
+	if (!xctx->bmapx)
+		str_info(ctx, ctx->mntpoint,
+_("Kernel lacks GETBMAPX; scrub will be less efficient."));
+
+	/* Do we have getfsmap? */
+	xctx->fsmap = xfs_can_iterate_fsmap(ctx);
+	if (!xctx->fsmap && scrub_data)
+		str_info(ctx, ctx->mntpoint,
+_("Kernel lacks GETFSMAP; scrub will be less efficient."));
+
+	/* Do we have parent pointers? */
+	xctx->parent_ptrs = false; /* NOPE */
+
+	/* Go find the XFS devices if we have a usable fsmap. */
+	fs_table_initialise(0, NULL, 0, NULL);
+	errno = 0;
+	fsp = fs_table_lookup(ctx->mntpoint, FS_MOUNT_POINT);
+	if (!fsp) {
+		str_error(ctx, ctx->mntpoint,
+_("Unable to find XFS information."));
+		goto err;
+	}
+	memcpy(&xctx->fsinfo, fsp, sizeof(struct fs_path));
+
+	/* Did we find the log and rt devices, if they're present? */
+	if (xctx->geo.logstart == 0 && xctx->fsinfo.fs_log == NULL) {
+		str_error(ctx, ctx->mntpoint,
+_("Unable to find log device path."));
+		goto err;
+	}
+	if (xctx->geo.rtblocks && xctx->fsinfo.fs_rt == NULL) {
+		str_error(ctx, ctx->mntpoint,
+_("Unable to find realtime device path."));
+		goto err;
+	}
+
+	/* Open the raw devices. */
+	error = disk_open(xctx->fsinfo.fs_name, &xctx->datadev);
+	if (error) {
+		str_errno(ctx, xctx->fsinfo.fs_name);
+		xctx->fsmap = false;
+	}
+	ctx->nr_io_threads = disk_heads(&xctx->datadev);
+
+	if (xctx->fsinfo.fs_log) {
+		error = disk_open(xctx->fsinfo.fs_log, &xctx->logdev);
+		if (error) {
+			str_errno(ctx, xctx->fsinfo.fs_name);
+			xctx->fsmap = false;
+		}
+	}
+	if (xctx->fsinfo.fs_rt) {
+		error = disk_open(xctx->fsinfo.fs_rt, &xctx->rtdev);
+		if (error) {
+			str_errno(ctx, xctx->fsinfo.fs_name);
+			xctx->fsmap = false;
+		}
+	}
+	if (xctx->geo.sunit)
+		ctx->nr_io_threads = xctx->geo.swidth / xctx->geo.sunit;
+
+	/* Figure out who gets to scrub data extents... */
+	if (scrub_data) {
+		if (xctx->fsmap)
+			xctx->data_scrubber = DS_FSMAP;
+		else if (xctx->bmapx)
+			xctx->data_scrubber = DS_BMAPX;
+		else  if (xctx->bulkstat)
+			xctx->data_scrubber = DS_BULKSTAT_READ;
+		else
+			xctx->data_scrubber = DS_READ;
+	} else
+		xctx->data_scrubber = DS_NOSCRUB;
+
+	return generic_scan_fs(ctx);
+err:
+	xfs_cleanup(ctx);
+	return false;
+}
+
+/* Phase 2 */
+
+/* Scrub each AG's metadata btrees. */
+static void
+xfs_scan_ag_metadata(
+	struct work_queue		*wq,
+	xfs_agnumber_t			agno,
+	void				*arg)
+{
+	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->mp;
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
+	bool				*pmoveon = arg;
+	bool				moveon;
+
+	if (!xctx->kernel_scrub)
+		return;
+
+	moveon = xfs_scrub_ag_metadata(ctx, agno, arg);
+	if (!moveon)
+		*pmoveon = false;
+}
+
+/* Scrub whole-FS metadata btrees. */
+static void
+xfs_scan_fs_metadata(
+	struct work_queue		*wq,
+	xfs_agnumber_t			agno,
+	void				*arg)
+{
+	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->mp;
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
+	bool				*pmoveon = arg;
+	bool				moveon;
+
+	if (!xctx->kernel_scrub)
+		return;
+
+	moveon = xfs_scrub_fs_metadata(ctx, arg);
+	if (!moveon)
+		*pmoveon = false;
+}
+
+/* Try to scan metadata via sysfs. */
+static bool
+xfs_scan_metadata(
+	struct scrub_ctx	*ctx)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	xfs_agnumber_t		agno;
+	struct work_queue	wq;
+	bool			moveon = true;
+
+	create_work_queue(&wq, (struct xfs_mount *)ctx, scrub_nproc(ctx));
+	queue_work(&wq, xfs_scan_fs_metadata, 0, &moveon);
+	for (agno = 0; agno < xctx->geo.agcount; agno++)
+		queue_work(&wq, xfs_scan_ag_metadata, agno, &moveon);
+	destroy_work_queue(&wq);
+
+	return moveon;
+}
+
+/* Phase 3 */
+
+/* Scrub an inode extent, report if it's bad. */
+static bool
+xfs_scrub_inode_extent(
+	struct scrub_ctx		*ctx,
+	const char			*descr,
+	int				fd,
+	int				whichfork,
+	struct fsxattr			*fsx,
+	struct getbmapx			*bmap,
+	void				*arg)
+{
+	unsigned long long		*nextoff = arg;
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
+	unsigned long long		eofs;
+	bool				badmap = false;
+
+	if (fsx->fsx_xflags & FS_XFLAG_REALTIME)
+		eofs = xctx->geo.rtblocks;
+	else
+		eofs = xctx->geo.datablocks;
+	eofs <<= (xctx->blocklog - BBSHIFT);
+
+	if (bmap->bmv_length == 0) {
+		badmap = true;
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) has zero length."),
+				bmap->bmv_block, bmap->bmv_offset,
+				bmap->bmv_length);
+	}
+
+	if (bmap->bmv_block >= eofs) {
+		badmap = true;
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) starts past end of filesystem at %llu."),
+				bmap->bmv_block, bmap->bmv_offset,
+				bmap->bmv_length, eofs);
+	}
+
+	if (bmap->bmv_offset < *nextoff) {
+		badmap = true;
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) overlaps another extent."),
+				bmap->bmv_block, bmap->bmv_offset,
+				bmap->bmv_length);
+	}
+
+	if (bmap->bmv_block + bmap->bmv_length < bmap->bmv_block ||
+	    bmap->bmv_block + bmap->bmv_length >= eofs) {
+		badmap = true;
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) ends past end of filesystem at %llu."),
+				bmap->bmv_block, bmap->bmv_offset,
+				bmap->bmv_length, eofs);
+	}
+
+	if (bmap->bmv_offset + bmap->bmv_length < bmap->bmv_offset) {
+		badmap = true;
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) overflows file offset."),
+				bmap->bmv_block, bmap->bmv_offset,
+				bmap->bmv_length);
+	}
+
+	if ((bmap->bmv_oflags & BMV_OF_SHARED) &&
+	    (bmap->bmv_oflags & (BMV_OF_PREALLOC | BMV_OF_DELALLOC))) {
+		badmap = true;
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) has conflicting flags 0x%x."),
+				bmap->bmv_block, bmap->bmv_offset,
+				bmap->bmv_length, bmap->bmv_oflags);
+	}
+
+	if ((bmap->bmv_oflags & BMV_OF_SHARED) &&
+	    !(fsx->fsx_xflags & FS_XFLAG_REFLINK)) {
+		badmap = true;
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) is shared but %s is not?"),
+				bmap->bmv_block, bmap->bmv_offset,
+				bmap->bmv_length, descr);
+	}
+
+	if (!badmap)
+		*nextoff = bmap->bmv_offset + bmap->bmv_length;
+
+	return true;
+}
+
+/* Scrub an inode's data, xattr, and CoW extent records. */
+static bool
+xfs_scan_inode_extents(
+	struct scrub_ctx		*ctx,
+	const char			*descr,
+	int				fd)
+{
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
+	struct xfs_bmap_iter		xbi;
+	struct getbmapx			key;
+	bool				moveon;
+	unsigned long long		nextoff;
+
+	xbi.moveon = true;
+	xbi.fn = xfs_scrub_inode_extent;
+	xbi.arg = &nextoff;
+	xbi.descr = descr;
+
+	/* data fork */
+	memset(&key, 0, sizeof(key));
+	key.bmv_length = ULLONG_MAX;
+	nextoff = 0;
+	moveon = xfs_iterate_bmap(ctx, &xbi, fd, XFS_DATA_FORK, &key);
+	if (!moveon)
+		return false;
+
+	/* attr fork */
+	memset(&key, 0, sizeof(key));
+	key.bmv_length = ULLONG_MAX;
+	nextoff = 0;
+	moveon = xfs_iterate_bmap(ctx, &xbi, fd, XFS_ATTR_FORK, &key);
+	if (!moveon)
+		return false;
+
+	if (!(xctx->geo.flags & XFS_FSOP_GEOM_FLAGS_REFLINK))
+		return xbi.moveon;
+
+	/* cow fork */
+	memset(&key, 0, sizeof(key));
+	key.bmv_length = ULLONG_MAX;
+	nextoff = 0;
+	moveon = xfs_iterate_bmap(ctx, &xbi, fd, XFS_COW_FORK, &key);
+	if (!moveon)
+		return false;
+
+	return xbi.moveon;
+}
+
+enum xfs_xattr_ns {
+	RXT_USER	= 0,
+	RXT_ROOT	= ATTR_ROOT,
+	RXT_TRUST	= ATTR_TRUST,
+	RXT_SECURE	= ATTR_SECURE,
+	RXT_MAX		= 4,
+};
+
+static const enum xfs_xattr_ns known_attr_ns[RXT_MAX] = {
+	RXT_USER,
+	RXT_ROOT,
+	RXT_TRUST,
+	RXT_SECURE,
+};
+
+/* Read all the extended attributes of a file handle. */
+static bool
+xfs_read_handle_xattrs(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	struct xfs_handle	*handle,
+	enum xfs_xattr_ns	ns)
+{
+	struct attrlist_cursor	cur;
+	struct attr_multiop	mop;
+	char			attrbuf[XFS_XATTR_LIST_MAX];
+	char			*firstname = NULL;
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	struct attrlist		*attrlist = (struct attrlist *)attrbuf;
+	struct attrlist_ent	*ent;
+	bool			moveon = true;
+	int			i;
+	int			flags = 0;
+	int			error;
+
+	flags |= ns;
+	memset(&attrbuf, 0, XFS_XATTR_LIST_MAX);
+	memset(&cur, 0, sizeof(cur));
+	mop.am_opcode = ATTR_OP_GET;
+	mop.am_flags = flags;
+	while ((error = attr_list_by_handle(handle, sizeof(*handle),
+			attrbuf, XFS_XATTR_LIST_MAX, flags, &cur)) == 0) {
+		for (i = 0; i < attrlist->al_count; i++) {
+			ent = ATTR_ENTRY(attrlist, i);
+
+			/*
+			 * XFS has a longstanding bug where the attr cursor
+			 * never gets updated, causing an infinite loop.
+			 * Detect this and bail out.
+			 */
+			if (i == 0 && xctx->checked_xattrs) {
+				if (firstname == NULL) {
+					firstname = malloc(ent->a_valuelen);
+					memcpy(firstname, ent->a_name,
+							ent->a_valuelen);
+				} else if (memcmp(firstname, ent->a_name,
+							ent->a_valuelen) == 0) {
+					str_error(ctx, descr,
+_("duplicate extended attribute \"%s\", buggy XFS?"),
+							ent->a_name);
+					moveon = false;
+					goto out;
+				}
+			}
+
+			mop.am_attrname = ent->a_name;
+			mop.am_attrvalue = ctx->readbuf;
+			mop.am_length = IO_MAX_SIZE;
+			error = attr_multi_by_handle(handle, sizeof(*handle),
+					&mop, 1, flags);
+			if (error)
+				goto out;
+		}
+
+		if (!attrlist->al_more)
+			break;
+	}
+
+	/* ATTR_TRUST doesn't currently work on Linux... */
+	if (ns == RXT_TRUST && error && errno == EINVAL)
+		error = 0;
+
+out:
+	if (firstname)
+		free(firstname);
+	if (error)
+		str_errno(ctx, descr);
+	return moveon;
+}
+
+/* Verify the contents, xattrs, and extent maps of an inode. */
+static bool
+xfs_scrub_inode(
+	struct scrub_ctx	*ctx,
+	xfs_agnumber_t		agno,
+	struct xfs_handle	*handle,
+	struct xfs_bstat	*bstat,
+	void			*arg)
+{
+	struct stat64		fd_sb;
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	static char		linkbuf[PATH_MAX];
+	char			descr[DESCR_BUFSZ];
+	unsigned long long	eofs;
+	bool			moveon = true;
+	int			fd = -1;
+	int			i;
+	int			error;
+
+	snprintf(descr, DESCR_BUFSZ, _("inode %llu/%u"), bstat->bs_ino,
+			bstat->bs_gen);
+
+	/* Check symlink contents. */
+	if (S_ISLNK(bstat->bs_mode)) {
+		error = readlink_by_handle(handle, sizeof(*handle), linkbuf,
+				PATH_MAX);
+		if (error < 0)
+			str_errno(ctx, descr);
+		return true;
+	}
+
+	/* Check block sizes. */
+	if (!S_ISBLK(bstat->bs_mode) && !S_ISCHR(bstat->bs_mode) &&
+	    bstat->bs_blksize != xctx->geo.blocksize)
+		str_error(ctx, descr,
+_("Block size mismatch %u, expected %u"),
+				bstat->bs_blksize, xctx->geo.blocksize);
+	if (bstat->bs_xflags & FS_XFLAG_EXTSIZE) {
+		if (bstat->bs_extsize > (MAXEXTLEN << xctx->blocklog))
+			str_error(ctx, descr,
+_("Extent size hint %u too large"), bstat->bs_extsize);
+		if (!(bstat->bs_xflags & FS_XFLAG_REALTIME) &&
+		    bstat->bs_extsize > (xctx->geo.agblocks << (xctx->blocklog - 1)))
+			str_error(ctx, descr,
+_("Extent size hint %u too large for AG"), bstat->bs_extsize);
+		if (!(bstat->bs_xflags & FS_XFLAG_REALTIME) &&
+		    bstat->bs_extsize % xctx->geo.blocksize)
+			str_error(ctx, descr,
+_("Extent size hint %u not a multiple of blocksize"), bstat->bs_extsize);
+		if ((bstat->bs_xflags & FS_XFLAG_REALTIME) &&
+		    bstat->bs_extsize % (xctx->geo.rtextsize << xctx->blocklog))
+			str_error(ctx, descr,
+_("Extent size hint %u not a multiple of rt extent size"), bstat->bs_extsize);
+	}
+	if ((bstat->bs_xflags & FS_XFLAG_REFLINK) &&
+	    !(xctx->geo.flags & XFS_FSOP_GEOM_FLAGS_REFLINK))
+		str_error(ctx, descr,
+_("Is a shared inode on a non-reflink filesystem?"), 0);
+	if ((bstat->bs_xflags & FS_XFLAG_COWEXTSIZE) &&
+	    !(xctx->geo.flags & XFS_FSOP_GEOM_FLAGS_REFLINK))
+		str_error(ctx, descr,
+_("Has a CoW extent size hint on a non-reflink filesystem?"), 0);
+	if (bstat->bs_xflags & FS_XFLAG_COWEXTSIZE) {
+		if (bstat->bs_cowextsize > (MAXEXTLEN << xctx->blocklog))
+			str_error(ctx, descr,
+_("CoW Extent size hint %u too large"), bstat->bs_cowextsize);
+		if (bstat->bs_cowextsize > (xctx->geo.agblocks << (xctx->blocklog - 1)))
+			str_error(ctx, descr,
+_("CoW Extent size hint %u too large for AG"), bstat->bs_cowextsize);
+		if (bstat->bs_cowextsize % xctx->geo.blocksize)
+			str_error(ctx, descr,
+_("CoW Extent size hint %u not a multiple of blocksize"), bstat->bs_cowextsize);
+	}
+	if (bstat->bs_xflags & FS_XFLAG_REALTIME)
+		eofs = xctx->geo.rtblocks;
+	else
+		eofs = xctx->geo.datablocks;
+	if (!(bstat->bs_xflags & FS_XFLAG_REFLINK) && bstat->bs_blocks >= eofs)
+		str_error(ctx, descr,
+_("Claims having more blocks (%llu) than there are in filesystem (%llu)"),
+				bstat->bs_blocks << (xctx->blocklog - BBSHIFT),
+				eofs << (xctx->blocklog - BBSHIFT));
+
+	/* Try to open the inode to pin it. */
+	if (S_ISREG(bstat->bs_mode) || S_ISDIR(bstat->bs_mode)) {
+		fd = open_by_fshandle(handle, sizeof(*handle),
+				O_RDONLY | O_NOATIME | O_NOFOLLOW | O_NOCTTY);
+		if (fd < 0) {
+			char buf[DESCR_BUFSZ];
+
+			str_warn(ctx, descr, "%s", strerror_r(errno,
+					buf, DESCR_BUFSZ));
+			return true;
+		}
+	}
+
+	/* XXX: Some day, check child -> parent dir -> child. */
+
+	/*
+	 * Read all the extended attributes.  If any of the read
+	 * functions decline to move on, we can try again with the
+	 * VFS functions if we have a file descriptor.
+	 */
+	moveon = true;
+	for (i = 0; i < RXT_MAX; i++) {
+		moveon = xfs_read_handle_xattrs(ctx, descr, handle,
+				known_attr_ns[i]);
+		if (!moveon)
+			break;
+	}
+	if (!moveon && fd >= 0) {
+		moveon = generic_scan_xattrs(ctx, descr, fd);
+		if (!moveon)
+			goto out;
+	}
+	if (!moveon)
+		xctx->checked_xattrs = false;
+
+	/*
+	 * The rest of the scans require a file descriptor, so bail out
+	 * if we don't have one.
+	 */
+	if (fd < 0)
+		goto out;
+
+	if (xctx->kernel_scrub) {
+		/* Scan the extent maps with the kernel scrubber. */
+		moveon = xfs_scrub_inode_metadata(ctx, bstat->bs_ino, fd);
+		if (!moveon)
+			goto out;
+	} else if (xctx->bmapx) {
+		/* Scan the extent maps with GETBMAPX. */
+		moveon = xfs_scan_inode_extents(ctx, descr, fd);
+		if (!moveon)
+			goto out;
+	} else {
+		error = fstat64(fd, &fd_sb);
+		if (error) {
+			str_errno(ctx, descr);
+			goto out;
+		}
+
+		/* Fall back to the FIEMAP scanner. */
+		moveon = generic_scan_extents(ctx, descr, fd, &fd_sb, false);
+		if (!moveon)
+			goto out;
+		moveon = generic_scan_extents(ctx, descr, fd, &fd_sb, true);
+		if (!moveon)
+			goto out;
+	}
+
+	if (S_ISDIR(bstat->bs_mode)) {
+		/* XXX: Some day, check dir -> child -> parent(dir) */
+
+		/* Check the directory entries. */
+		moveon = generic_check_directory(ctx, descr, &fd);
+		if (!moveon)
+			goto out;
+	}
+
+out:
+	if (fd >= 0)
+		close(fd);
+	return moveon;
+}
+
+/* Verify all the inodes in a filesystem. */
+static bool
+xfs_scan_inodes(
+	struct scrub_ctx	*ctx)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+
+	if (!xctx->bulkstat)
+		return generic_scan_inodes(ctx);
+
+	xctx->checked_xattrs = true;
+	return xfs_scan_all_inodes(ctx, xfs_scrub_inode, NULL);
+}
+
+/* Phase 4 */
+
+/* Check an inode's extents. */
+static bool
+xfs_scan_extents(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	int			fd,
+	struct stat64		*sb,
+	bool			attr_fork)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+
+	/*
+	 * If we have bulkstat and either bmap or kernel scrubbing,
+	 * we already checked the extents.
+	 */
+	if (xctx->bulkstat && (xctx->bmapx || xctx->kernel_scrub))
+		return true;
+
+	return generic_scan_extents(ctx, descr, fd, sb, attr_fork);
+}
+
+/* Try to read all the extended attributes. */
+static bool
+xfs_scan_xattrs(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	int			fd)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+
+	/* If we have bulkstat, we already checked the attributes. */
+	if (xctx->bulkstat && xctx->checked_xattrs)
+		return true;
+
+	return generic_scan_xattrs(ctx, descr, fd);
+}
+
+/* Try to read all the extended attributes of things that have no fd. */
+static bool
+xfs_scan_special_xattrs(
+	struct scrub_ctx	*ctx,
+	const char		*path)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+
+	/* If we have bulkstat, we already checked the attributes. */
+	if (xctx->bulkstat && xctx->checked_xattrs)
+		return true;
+
+	return generic_scan_special_xattrs(ctx, path);
+}
+
+/* Traverse the directory tree. */
+static bool
+xfs_scan_fs_tree(
+	struct scrub_ctx	*ctx)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+
+	/* If we have bulkstat, we already checked the attributes. */
+	if (xctx->bulkstat && xctx->checked_xattrs)
+		return true;
+
+	return generic_scan_fs_tree(ctx);
+}
+
+/* Phase 5 */
+
+/* Verify disk blocks with GETFSMAP */
+
+struct xfs_verify_extent {
+	/* Maintain state for the lazy read verifier. */
+	struct read_verify	rv;
+
+	/* Store bad extents if we don't have parent pointers. */
+	struct extent_tree	*d_bad;
+	struct extent_tree	*r_bad;
+
+	/* Track the last extent we saw. */
+	uint64_t		laststart;
+	uint64_t		lastcount;
+	bool			lastshared;
+};
+
+/* Report an IO error resulting from read-verify based off getfsmap. */
+static bool
+xfs_check_rmap_error_report(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	int			idx,
+	struct getfsmap		*map,
+	void			*arg)
+{
+	const char		*type;
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	char			buf[32];
+	uint64_t		err_startblock = *(uint64_t *)arg;
+	uint64_t		err_off;
+
+	if (err_startblock > map->fmv_block)
+		err_off = err_startblock - map->fmv_block;
+	else
+		err_off = 0;
+
+	snprintf(buf, 32, _("sector %llu"), map->fmv_block + err_off);
+
+	if (map->fmv_oflags & FMV_OF_SPECIAL_OWNER) {
+		type = xfs_decode_special_owner(map->fmv_owner);
+		str_error(ctx, buf,
+_("%s failed read verification."),
+				type);
+	} else if (xctx->parent_ptrs) {
+		/* XXX: go find the parent path */
+		str_error(ctx, buf,
+_("XXX: inode %lld offset %llu failed read verification."),
+				map->fmv_owner, map->fmv_offset + err_off);
+	}
+	return true;
+}
+
+/* Handle a read error in the rmap-based read verify. */
+void
+xfs_check_rmap_ioerr(
+	struct read_verify_pool	*rvp,
+	struct disk		*disk,
+	uint64_t		startblock,
+	uint64_t		blockcount,
+	int			error,
+	void			*arg)
+{
+	struct getfsmap		keys[2];
+	struct xfs_fsmap_iter	xfi;
+	struct scrub_ctx	*ctx = rvp->rvp_ctx;
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	struct xfs_verify_extent	*ve;
+	struct extent_tree	*tree;
+	dev_t			dev;
+	bool			moveon;
+
+	ve = arg;
+	dev = xfs_disk_to_dev(xctx, disk);
+
+	/*
+	 * If we don't have parent pointers, save the bad extent for
+	 * later rescanning.
+	 */
+	if (!xctx->parent_ptrs) {
+		if (dev == xctx->fsinfo.fs_datadev)
+			tree = ve->d_bad;
+		else if (dev == xctx->fsinfo.fs_rtdev)
+			tree = ve->r_bad;
+		else
+			tree = NULL;
+		if (tree) {
+			moveon = extent_tree_add(tree, startblock, blockcount);
+			if (!moveon)
+				str_errno(ctx, ctx->mntpoint);
+		}
+	}
+
+	/* Go figure out which blocks are bad from the fsmap. */
+	memset(keys, 0, sizeof(struct getfsmap) * 2);
+	keys->fmv_device = dev;
+	keys->fmv_block = startblock;
+	(keys + 1)->fmv_device = dev;
+	(keys + 1)->fmv_block = startblock + blockcount - 1;
+	(keys + 1)->fmv_owner = ULLONG_MAX;
+	(keys + 1)->fmv_offset = ULLONG_MAX;
+	(keys + 1)->fmv_oflags = UINT_MAX;
+
+	xfi.fn = xfs_check_rmap_error_report;
+	xfi.arg = &startblock;
+	xfi.moveon = true;
+	xfs_iterate_fsmap(ctx, &xfi, 0, keys);
+}
+
+/* Read verify a (data block) extent. */
+static bool
+xfs_check_rmap(
+	struct scrub_ctx		*ctx,
+	const char			*descr,
+	int				idx,
+	struct getfsmap			*map,
+	void				*arg)
+{
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
+	struct xfs_verify_extent	*ve;
+	struct disk			*disk;
+	uint64_t			eofs;
+	uint64_t			min_block;
+	bool				badflags = false;
+	bool				badmap = false;
+
+	ve = ((struct xfs_verify_extent *)arg) + idx;
+
+	dbg_printf("rmap dev %d:%d block %llu owner %lld offset %llu "
+			"len %llu flags 0x%x\n", major(map->fmv_device),
+			minor(map->fmv_device), map->fmv_block,
+			map->fmv_owner, map->fmv_offset,
+			map->fmv_length, map->fmv_oflags);
+
+	/* If kernel already checked this... */
+	if (xctx->kernel_scrub)
+		goto skip_check;
+
+	if (map->fmv_device == xctx->fsinfo.fs_datadev)
+		eofs = xctx->geo.datablocks;
+	else if (map->fmv_device == xctx->fsinfo.fs_rtdev)
+		eofs = xctx->geo.rtblocks;
+	else if (map->fmv_device == xctx->fsinfo.fs_logdev)
+		eofs = xctx->geo.logblocks;
+	else
+		assert(0);
+	eofs <<= (xctx->blocklog - BBSHIFT);
+
+	/* Don't go past EOFS */
+	if (map->fmv_block >= eofs) {
+		badmap = true;
+		str_error(ctx, descr,
+_("rmap (%llu/%llu/%llu) starts past end of filesystem at %llu."),
+				map->fmv_block, map->fmv_offset,
+				map->fmv_length, eofs);
+	}
+
+	if (map->fmv_block + map->fmv_length < map->fmv_block ||
+	    map->fmv_block + map->fmv_length >= eofs) {
+		badmap = true;
+		str_error(ctx, descr,
+_("rmap (%llu/%llu/%llu) ends past end of filesystem at %llu."),
+				map->fmv_block, map->fmv_offset,
+				map->fmv_length, eofs);
+	}
+
+	/* Check for illegal overlapping. */
+	if (ve->lastshared && (map->fmv_oflags & FMV_OF_SHARED))
+		min_block = ve->laststart;
+	else
+		min_block = map->fmv_block < ve->laststart + ve->lastcount;
+
+	if (map->fmv_block < min_block) {
+		badmap = true;
+		str_error(ctx, descr,
+_("rmap (%llu/%llu/%llu) overlaps another rmap."),
+				map->fmv_block, map->fmv_offset,
+				map->fmv_length);
+	}
+
+	/* can't have shared on non-reflink */
+	if ((map->fmv_oflags & FMV_OF_SHARED) &&
+	    !(xctx->geo.flags & XFS_FSOP_GEOM_FLAGS_REFLINK))
+		badflags = true;
+
+	/* unwritten can't have any of the other flags */
+	if ((map->fmv_oflags & FMV_OF_PREALLOC) &&
+	     (map->fmv_oflags & (FMV_OF_ATTR_FORK | FMV_OF_EXTENT_MAP |
+				 FMV_OF_SHARED | FMV_OF_SPECIAL_OWNER)))
+		badflags = true;
+
+	/* attr fork can't be shared or uwnritten or special */
+	if ((map->fmv_oflags & FMV_OF_ATTR_FORK) &&
+	     (map->fmv_oflags & (FMV_OF_PREALLOC | FMV_OF_SHARED |
+				 FMV_OF_SPECIAL_OWNER)))
+		badflags = true;
+
+	/* extent maps can only have attrfork */
+	if ((map->fmv_oflags & FMV_OF_EXTENT_MAP) &&
+	     (map->fmv_oflags & (FMV_OF_PREALLOC | FMV_OF_SHARED |
+				 FMV_OF_SPECIAL_OWNER)))
+		badflags = true;
+
+	/* shared maps can't have any of the other flags */
+	if ((map->fmv_oflags & FMV_OF_SHARED) &&
+	     (map->fmv_oflags & (FMV_OF_PREALLOC | FMV_OF_ATTR_FORK |
+				 FMV_OF_EXTENT_MAP | FMV_OF_SPECIAL_OWNER)))
+
+	/* special owners can't have any of the other flags */
+	if ((map->fmv_oflags & FMV_OF_SPECIAL_OWNER) &&
+	     (map->fmv_oflags & (FMV_OF_PREALLOC | FMV_OF_ATTR_FORK |
+				 FMV_OF_EXTENT_MAP | FMV_OF_SHARED)))
+		badflags = true;
+
+	if (badflags) {
+		badmap = true;
+		str_error(ctx, descr,
+_("rmap (%llu/%llu/%llu) has conflicting flags 0x%x."),
+				map->fmv_block, map->fmv_offset,
+				map->fmv_length, map->fmv_oflags);
+	}
+
+	/* If this rmap is suspect, don't bother verifying it. */
+	if (badmap)
+		goto out;
+
+skip_check:
+	/* Remember this extent. */
+	ve->lastshared = (map->fmv_oflags & FMV_OF_SHARED);
+	ve->laststart = map->fmv_block;
+	ve->lastcount = map->fmv_length;
+
+	/* "Unknown" extents should be verified; they could be data. */
+	if ((map->fmv_oflags & FMV_OF_SPECIAL_OWNER) &&
+			map->fmv_owner == FMV_OWN_UNKNOWN)
+		map->fmv_oflags &= ~FMV_OF_SPECIAL_OWNER;
+
+	/*
+	 * We only care about read-verifying data extents that have been
+	 * written to disk.  This means we can skip "special" owners
+	 * (metadata), xattr blocks, unwritten extents, and extent maps.
+	 * These should all get checked elsewhere in the scrubber.
+	 */
+	if (map->fmv_oflags & (FMV_OF_PREALLOC | FMV_OF_ATTR_FORK |
+			       FMV_OF_EXTENT_MAP | FMV_OF_SPECIAL_OWNER))
+		goto out;
+
+	/* XXX: Filter out directory data blocks. */
+
+	/* Schedule the read verify command for (eventual) running. */
+	disk = xfs_dev_to_disk(xctx, map->fmv_device);
+
+	read_verify_schedule(&xctx->rvp, &ve->rv, disk, map->fmv_block,
+			map->fmv_length, ve);
+
+out:
+	/* Is this the last extent?  Fire off the read. */
+	if (map->fmv_oflags & FMV_OF_LAST)
+		read_verify_force(&xctx->rvp, &ve->rv);
+
+	return true;
+}
+
+/* Verify all the blocks in a filesystem. */
+static bool
+xfs_scan_rmaps(
+	struct scrub_ctx		*ctx)
+{
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
+	struct extent_tree		d_bad;
+	struct extent_tree		r_bad;
+	struct xfs_verify_extent	*ve;
+	struct xfs_verify_extent	*v;
+	int				i;
+	bool				moveon;
+
+	/*
+	 * Initialize our per-thread context.  By convention,
+	 * the log device comes first, then the rt device, and then
+	 * the AGs.
+	 */
+	ve = calloc(xctx->geo.agcount + 2, sizeof(struct xfs_verify_extent));
+	if (!ve) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	moveon = extent_tree_init(&d_bad);
+	if (!moveon) {
+		str_errno(ctx, ctx->mntpoint);
+		goto out_ve;
+	}
+
+	moveon = extent_tree_init(&r_bad);
+	if (!moveon) {
+		str_errno(ctx, ctx->mntpoint);
+		goto out_dbad;
+	}
+
+	for (i = 0, v = ve; i < xctx->geo.agcount + 2; i++, v++) {
+		v->d_bad = &d_bad;
+		v->r_bad = &r_bad;
+	}
+
+	read_verify_pool_init(&xctx->rvp, ctx, ctx->readbuf, IO_MAX_SIZE,
+			xctx->geo.blocksize, xfs_check_rmap_ioerr, NULL,
+			scrub_nproc(ctx));
+	moveon = xfs_scan_all_blocks(ctx, xfs_check_rmap, ve + 2);
+	if (!moveon)
+		goto out_pool;
+
+	for (i = 0, v = ve; i < xctx->geo.agcount + 2; i++, v++)
+		read_verify_force(&xctx->rvp, &v->rv);
+	read_verify_pool_destroy(&xctx->rvp);
+
+	/* Scan the whole dir tree to see what matches the bad extents. */
+	if (!extent_tree_empty(&d_bad) || !extent_tree_empty(&r_bad))
+		moveon = xfs_report_verify_errors(ctx, &d_bad, &r_bad);
+
+	extent_tree_free(&r_bad);
+	extent_tree_free(&d_bad);
+	free(ve);
+	return moveon;
+
+out_pool:
+	read_verify_pool_destroy(&xctx->rvp);
+	extent_tree_free(&r_bad);
+out_dbad:
+	extent_tree_free(&d_bad);
+out_ve:
+	free(ve);
+	return moveon;
+}
+
+/* Read-verify with BULKSTAT + GETBMAPX */
+struct xfs_verify_inode {
+	struct extent_tree		d_good;
+	struct extent_tree		r_good;
+	struct extent_tree		*d_bad;
+	struct extent_tree		*r_bad;
+};
+
+struct xfs_verify_submit {
+	struct read_verify_pool		*rvp;
+	struct extent_tree		*bad;
+	struct disk			*disk;
+	struct read_verify		rv;
+};
+
+/* Finish a inode block scan. */
+void
+xfs_verify_inode_bmap_ioerr(
+	struct read_verify_pool		*rvp,
+	struct disk			*disk,
+	uint64_t			startblock,
+	uint64_t			blockcount,
+	int				error,
+	void				*arg)
+{
+	struct extent_tree		*tree = arg;
+
+	extent_tree_add(tree, startblock, blockcount);
+}
+
+/* Scrub an inode extent and read-verify it. */
+bool
+xfs_verify_inode_bmap(
+	struct scrub_ctx		*ctx,
+	const char			*descr,
+	int				fd,
+	int				whichfork,
+	struct fsxattr			*fsx,
+	struct getbmapx			*bmap,
+	void				*arg)
+{
+	struct extent_tree		*tree = arg;
+
+	/*
+	 * Only do data scrubbing if the extent is neither unwritten nor
+	 * delalloc.
+	 */
+	if (bmap->bmv_oflags & (BMV_OF_PREALLOC | BMV_OF_DELALLOC))
+		return true;
+
+	return extent_tree_add(tree, bmap->bmv_block, bmap->bmv_length);
+}
+
+/* Read-verify the data blocks of a file via BMAP. */
+static bool
+xfs_verify_inode(
+	struct scrub_ctx		*ctx,
+	xfs_agnumber_t			agno,
+	struct xfs_handle		*handle,
+	struct xfs_bstat		*bstat,
+	void				*arg)
+{
+	struct stat64			fd_sb;
+	struct xfs_bmap_iter		xbi;
+	struct getbmapx			key;
+	struct xfs_verify_inode		*vi;
+	char				descr[DESCR_BUFSZ];
+	bool				moveon = true;
+	int				fd = -1;
+	int				error;
+
+	if (!S_ISREG(bstat->bs_mode))
+		return true;
+
+	snprintf(descr, DESCR_BUFSZ, _("inode %llu/%u"), bstat->bs_ino,
+			bstat->bs_gen);
+
+	/* Try to open the inode to pin it. */
+	fd = open_by_fshandle(handle, sizeof(*handle),
+			O_RDONLY | O_NOATIME | O_NOFOLLOW | O_NOCTTY);
+	if (fd < 0) {
+		char buf[DESCR_BUFSZ];
+
+		str_warn(ctx, descr, "%s", strerror_r(errno,
+				buf, DESCR_BUFSZ));
+		return true;
+	}
+
+	if (arg) {
+		/* Use BMAPX */
+		vi = ((struct xfs_verify_inode *)arg) + agno;
+
+		xbi.moveon = true;
+		xbi.fn = xfs_verify_inode_bmap;
+		xbi.descr = descr;
+		if (bstat->bs_xflags & FS_XFLAG_REALTIME)
+			xbi.arg = &vi->r_good;
+		else
+			xbi.arg = &vi->d_good;
+
+		/* data fork */
+		memset(&key, 0, sizeof(key));
+		key.bmv_length = ULLONG_MAX;
+		moveon = xfs_iterate_bmap(ctx, &xbi, fd, XFS_DATA_FORK, &key);
+		if (!moveon)
+			goto out;
+		moveon = xbi.moveon;
+	} else {
+		error = fstat64(fd, &fd_sb);
+		if (error) {
+			str_errno(ctx, descr);
+			goto out;
+		}
+
+		/* Use generic_file_read */
+		moveon = generic_read_file(ctx, descr, fd, &fd_sb);
+	}
+
+out:
+	if (fd >= 0)
+		close(fd);
+	return moveon;
+}
+
+static bool
+xfs_schedule_read_verify(
+	uint64_t			start,
+	uint64_t			length,
+	void				*arg)
+{
+	struct xfs_verify_submit	*rvs = arg;
+
+	read_verify_schedule(rvs->rvp, &rvs->rv, rvs->disk, start, length,
+			rvs->bad);
+	return true;
+}
+
+/* Verify all the file data in a filesystem. */
+static bool
+xfs_verify_inodes(
+	struct scrub_ctx	*ctx)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	struct extent_tree	d_good;
+	struct extent_tree	d_bad;
+	struct extent_tree	r_good;
+	struct extent_tree	r_bad;
+	struct xfs_verify_inode	*vi;
+	struct xfs_verify_inode	*v;
+	struct xfs_verify_submit	vs;
+	int			i;
+	bool			moveon;
+
+	vi = calloc(xctx->geo.agcount, sizeof(struct xfs_verify_inode));
+	if (!vi) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	moveon = extent_tree_init(&d_good);
+	if (!moveon) {
+		str_errno(ctx, ctx->mntpoint);
+		goto out_vi;
+	}
+
+	moveon = extent_tree_init(&d_bad);
+	if (!moveon) {
+		str_errno(ctx, ctx->mntpoint);
+		goto out_dgood;
+	}
+
+	moveon = extent_tree_init(&r_good);
+	if (!moveon) {
+		str_errno(ctx, ctx->mntpoint);
+		goto out_dbad;
+	}
+
+	moveon = extent_tree_init(&r_bad);
+	if (!moveon) {
+		str_errno(ctx, ctx->mntpoint);
+		goto out_rgood;
+	}
+
+	for (i = 0, v = vi; i < xctx->geo.agcount; i++, v++) {
+		v->d_bad = &d_bad;
+		v->r_bad = &r_bad;
+
+		moveon = extent_tree_init(&v->d_good);
+		if (!moveon) {
+			str_errno(ctx, ctx->mntpoint);
+			goto out_varray;
+		}
+
+		moveon = extent_tree_init(&v->r_good);
+		if (!moveon) {
+			str_errno(ctx, ctx->mntpoint);
+			goto out_varray;
+		}
+	}
+
+	/* Scan all the inodes for extent information. */
+	moveon = xfs_scan_all_inodes(ctx, xfs_verify_inode, vi);
+	if (!moveon)
+		goto out_varray;
+
+	/* Merge all the IOs. */
+	for (i = 0, v = vi; i < xctx->geo.agcount; i++, v++) {
+		extent_tree_merge(&d_good, &v->d_good);
+		extent_tree_free(&v->d_good);
+		extent_tree_merge(&r_good, &v->r_good);
+		extent_tree_free(&v->r_good);
+	}
+
+	/* Run all the IO in batches. */
+	memset(&vs, 0, sizeof(struct xfs_verify_submit));
+	vs.rvp = &xctx->rvp;
+	read_verify_pool_init(&xctx->rvp, ctx, ctx->readbuf, IO_MAX_SIZE,
+			xctx->geo.blocksize, xfs_verify_inode_bmap_ioerr,
+			NULL, scrub_nproc(ctx));
+	vs.disk = &xctx->datadev;
+	vs.bad = &d_bad;
+	moveon = extent_tree_iterate(&d_good, xfs_schedule_read_verify, &vs);
+	if (!moveon)
+		goto out_pool;
+	vs.disk = &xctx->rtdev;
+	vs.bad = &r_bad;
+	moveon = extent_tree_iterate(&r_good, xfs_schedule_read_verify, &vs);
+	if (!moveon)
+		goto out_pool;
+	read_verify_force(&xctx->rvp, &vs.rv);
+	read_verify_pool_destroy(&xctx->rvp);
+
+	/* Re-scan the file bmaps to see if they match the bad. */
+	if (!extent_tree_empty(&d_bad) || !extent_tree_empty(&r_bad))
+		moveon = xfs_report_verify_errors(ctx, &d_bad, &r_bad);
+
+	goto out_varray;
+
+out_pool:
+	read_verify_pool_destroy(&xctx->rvp);
+out_varray:
+	for (i = 0, v = vi; i < xctx->geo.agcount; i++, v++) {
+		extent_tree_free(&v->d_good);
+		extent_tree_free(&v->r_good);
+	}
+	extent_tree_free(&r_bad);
+out_rgood:
+	extent_tree_free(&r_good);
+out_dbad:
+	extent_tree_free(&d_bad);
+out_dgood:
+	extent_tree_free(&d_good);
+out_vi:
+	free(vi);
+	return moveon;
+}
+
+/* Verify all the file data in a filesystem with the generic verifier. */
+static bool
+xfs_verify_inodes_generic(
+	struct scrub_ctx	*ctx)
+{
+	return xfs_scan_all_inodes(ctx, xfs_verify_inode, NULL);
+}
+
+/* Scan all the blocks in a filesystem. */
+static bool
+xfs_scan_blocks(
+	struct scrub_ctx		*ctx)
+{
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
+
+	switch (xctx->data_scrubber) {
+	case DS_NOSCRUB:
+		return true;
+	case DS_READ:
+		return generic_scan_blocks(ctx);
+	case DS_BULKSTAT_READ:
+		return xfs_verify_inodes_generic(ctx);
+	case DS_BMAPX:
+		return xfs_verify_inodes(ctx);
+	case DS_FSMAP:
+		return xfs_scan_rmaps(ctx);
+	default:
+		assert(0);
+	}
+}
+
+/* Read an entire file's data. */
+static bool
+xfs_read_file(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	int			fd,
+	struct stat64		*sb)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+
+	if (xctx->data_scrubber != DS_READ)
+		return true;
+
+	return generic_read_file(ctx, descr, fd, sb);
+}
+
+/* Phase 6 */
+
+struct xfs_summary_counts {
+	unsigned long long	inodes;		/* number of inodes */
+	unsigned long long	dblocks;	/* data dev fsblocks */
+	unsigned long long	rblocks;	/* rt dev fsblocks */
+	unsigned long long	next_dsect;	/* next fs sector we see? */
+	unsigned long long	ag_owner;	/* freespace blocks */
+	struct extent_tree	dext;		/* data extent bitmap */
+	struct extent_tree	rext;		/* rt extent bitmap */
+};
+
+struct xfs_inode_fork_summary {
+	struct extent_tree	*tree;
+	unsigned long long	blocks;
+};
+
+/* Record data block extents in a bitmap. */
+bool
+xfs_record_inode_summary_bmap(
+	struct scrub_ctx		*ctx,
+	const char			*descr,
+	int				fd,
+	int				whichfork,
+	struct fsxattr			*fsx,
+	struct getbmapx			*bmap,
+	void				*arg)
+{
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
+	struct xfs_inode_fork_summary	*ifs = arg;
+	int				shift;
+
+	shift = (xctx->blocklog - BBSHIFT);
+	extent_tree_add(ifs->tree, bmap->bmv_block >> shift,
+			bmap->bmv_length >> shift);
+	ifs->blocks += bmap->bmv_length >> shift;
+	return true;
+}
+
+/* Record inode and block usage. */
+static bool
+xfs_record_inode_summary(
+	struct scrub_ctx		*ctx,
+	xfs_agnumber_t			agno,
+	struct xfs_handle		*handle,
+	struct xfs_bstat		*bstat,
+	void				*arg)
+{
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
+	struct xfs_summary_counts	*counts;
+	struct xfs_bmap_iter		xbi;
+	struct getbmapx			key;
+	struct xfs_inode_fork_summary	ifs;
+	unsigned long long		rtblocks;
+	char				descr[DESCR_BUFSZ];
+	int				fd;
+	bool				moveon;
+
+	counts = ((struct xfs_summary_counts *)arg) + agno;
+	counts->inodes++;
+	if (xctx->fsmap || bstat->bs_blocks == 0)
+		return true;
+
+	if (!S_ISREG(bstat->bs_mode)) {
+		counts->dblocks += bstat->bs_blocks;
+		return true;
+	}
+
+	/* Potentially a reflinked file, so collect the bitmap... */
+	snprintf(descr, DESCR_BUFSZ, _("inode %llu/%u"), bstat->bs_ino,
+			bstat->bs_gen);
+
+	/* Try to open the inode to pin it. */
+	fd = open_by_fshandle(handle, sizeof(*handle),
+			O_RDONLY | O_NOATIME | O_NOFOLLOW | O_NOCTTY);
+	if (fd < 0) {
+		char buf[DESCR_BUFSZ];
+
+		str_warn(ctx, descr, "%s", strerror_r(errno,
+				buf, DESCR_BUFSZ));
+		return true;
+	}
+
+	xbi.moveon = true;
+	xbi.arg = &ifs;
+	xbi.fn = xfs_record_inode_summary_bmap;
+	xbi.descr = descr;
+
+	/* data fork */
+	memset(&key, 0, sizeof(key));
+	key.bmv_length = ULLONG_MAX;
+	if (bstat->bs_xflags & FS_XFLAG_REALTIME)
+		ifs.tree = &counts->rext;
+	else
+		ifs.tree = &counts->dext;
+	ifs.blocks = 0;
+	moveon = xfs_iterate_bmap(ctx, &xbi, fd, XFS_DATA_FORK, &key);
+	if (!moveon)
+		goto out;
+	moveon = xbi.moveon;
+	rtblocks = (bstat->bs_xflags & FS_XFLAG_REALTIME) ? ifs.blocks : 0;
+
+	/* attr fork */
+	memset(&key, 0, sizeof(key));
+	key.bmv_length = ULLONG_MAX;
+	ifs.tree = &counts->dext;
+	moveon = xfs_iterate_bmap(ctx, &xbi, fd, XFS_ATTR_FORK, &key);
+	if (!moveon)
+		goto out;
+	moveon = xbi.moveon;
+
+	counts->dblocks += bstat->bs_blocks - rtblocks;
+	counts->rblocks += rtblocks;
+
+out:
+	if (fd >= 0)
+		close(fd);
+	return moveon;
+}
+
+/* Record block usage. */
+static bool
+xfs_record_block_summary(
+	struct scrub_ctx		*ctx,
+	const char			*descr,
+	int				idx,
+	struct getfsmap			*fsmap,
+	void				*arg)
+{
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
+	struct xfs_summary_counts	*counts;
+	unsigned long long		len;
+	int				shift;
+
+	if (idx < -1)
+		return true;
+	if ((fsmap->fmv_oflags & FMV_OF_SPECIAL_OWNER) &&
+	    fsmap->fmv_owner == FMV_OWN_FREE)
+		return true;
+
+	counts = ((struct xfs_summary_counts *)arg) + idx;
+	len = fsmap->fmv_length;
+	shift = xctx->blocklog - BBSHIFT;
+
+	/* freesp btrees live in free space, need to adjust counters later. */
+	if ((fsmap->fmv_oflags & FMV_OF_SPECIAL_OWNER) &&
+	    fsmap->fmv_owner == FMV_OWN_AG) {
+		counts->ag_owner += fsmap->fmv_length >> shift;
+	}
+	if (idx == -1) {
+		/* Count realtime extents. */
+		counts->rblocks += fsmap->fmv_length >> shift;
+	} else {
+		/* Count data extents. */
+		if (counts->next_dsect >= fsmap->fmv_block + fsmap->fmv_length)
+			return true;
+		else if (counts->next_dsect > fsmap->fmv_block)
+			len -= counts->next_dsect - fsmap->fmv_block;
+			
+		counts->dblocks += len >> shift;
+		counts->next_dsect = fsmap->fmv_block + fsmap->fmv_length;
+	}
+
+	return true;
+}
+
+/* Sum the blocks in each extent. */
+static bool
+xfs_summary_count_helper(
+	uint64_t			start,
+	uint64_t			length,
+	void				*arg)
+{
+	unsigned long long		*count = arg;
+
+	*count += length;
+	return true;
+}
+
+/* Count all inodes and blocks in the filesystem, compare to superblock. */
+static bool
+xfs_check_summary(
+	struct scrub_ctx		*ctx)
+{
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
+	struct xfs_fsop_counts		fc;
+	struct xfs_fsop_resblks		rb;
+	struct xfs_fsop_ag_resblks	arb;
+	struct statvfs			sfs;
+	struct xfs_summary_counts	*summary;
+	unsigned long long		fd;
+	unsigned long long		fr;
+	unsigned long long		fi;
+	unsigned long long		sd;
+	unsigned long long		sr;
+	unsigned long long		si;
+	unsigned long long		absdiff;
+	xfs_agnumber_t			agno;
+	bool				moveon;
+	bool				complain;
+	int				shift;
+	int				error;
+
+	if (!xctx->bulkstat)
+		return generic_check_summary(ctx);
+
+	summary = calloc(xctx->geo.agcount + 2,
+			sizeof(struct xfs_summary_counts));
+	if (!summary) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	/* Flush everything out to disk before we start counting. */
+	error = syncfs(ctx->mnt_fd);
+	if (error) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	if (xctx->fsmap) {
+		/* Use fsmap to count blocks. */
+		moveon = xfs_scan_all_blocks(ctx, xfs_record_block_summary,
+				summary + 2);
+		if (!moveon)
+			goto out;
+	} else {
+		/* Reflink w/o rmap; have to collect extents in a bitmap. */
+		for (agno = 0; agno < xctx->geo.agcount + 2; agno++) {
+			moveon = extent_tree_init(&summary[agno].dext);
+			if (!moveon) {
+				str_errno(ctx, ctx->mntpoint);
+				goto out;
+			}
+			moveon = extent_tree_init(&summary[agno].rext);
+			if (!moveon) {
+				str_errno(ctx, ctx->mntpoint);
+				goto out;
+			}
+		}
+	}
+
+	/* Scan the whole fs. */
+	moveon = xfs_scan_all_inodes(ctx, xfs_record_inode_summary, summary);
+	if (!moveon)
+		goto out;
+
+	if (!xctx->fsmap && (xctx->geo.flags & XFS_FSOP_GEOM_FLAGS_REFLINK)) {
+		/* Reflink w/o rmap; merge the bitmaps. */
+		for (agno = 1; agno < xctx->geo.agcount + 2; agno++) {
+			extent_tree_merge(&summary[0].dext, &summary[agno].dext);
+			extent_tree_free(&summary[agno].dext);
+			extent_tree_merge(&summary[0].rext, &summary[agno].rext);
+			extent_tree_free(&summary[agno].rext);
+		}
+		moveon = extent_tree_iterate(&summary[0].dext,
+				xfs_summary_count_helper, &summary[0].dblocks);
+		moveon = extent_tree_iterate(&summary[0].rext,
+				xfs_summary_count_helper, &summary[0].rblocks);
+		if (!moveon)
+			goto out;
+	}
+
+	/* Sum the counts. */
+	for (agno = 1; agno < xctx->geo.agcount + 2; agno++) {
+		summary[0].inodes += summary[agno].inodes;
+		summary[0].dblocks += summary[agno].dblocks;
+		summary[0].rblocks += summary[agno].rblocks;
+		summary[0].ag_owner += summary[agno].ag_owner;
+	}
+
+	/* Account for an internal log, if present. */
+	if (!xctx->fsmap && xctx->fsinfo.fs_log == NULL)
+		summary[0].dblocks += xctx->geo.logblocks;
+
+	/* Account for hidden rt metadata inodes. */
+	summary[0].inodes += 2;
+	if ((xctx->geo.flags & XFS_FSOP_GEOM_FLAGS_RMAPBT) &&
+			xctx->geo.rtblocks > 0)
+		summary[0].inodes++;
+
+	/* Fetch the filesystem counters. */
+	error = xfsctl(NULL, ctx->mnt_fd, XFS_IOC_FSCOUNTS, &fc);
+	if (error)
+		str_errno(ctx, ctx->mntpoint);
+
+	/* Grab the fstatvfs counters, since it has to report accurately. */
+	error = fstatvfs(ctx->mnt_fd, &sfs);
+	if (error) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	/*
+	 * XFS reserves some blocks to prevent hard ENOSPC, so add those
+	 * blocks back to the free data counts.
+	 */
+	error = xfsctl(NULL, ctx->mnt_fd, XFS_IOC_GET_RESBLKS, &rb);
+	if (error)
+		str_errno(ctx, ctx->mntpoint);
+	sfs.f_bfree += rb.resblks_avail;
+
+	/*
+	 * XFS with rmap or reflink reserves blocks in each AG to
+	 * prevent the AG from running out of space for metadata blocks.
+	 * Add those back to the free data counts.
+	 */
+	memset(&arb, 0, sizeof(arb));
+	error = xfsctl(NULL, ctx->mnt_fd, XFS_IOC_GET_AG_RESBLKS, &arb);
+	if (error && errno != ENOTTY)
+		str_errno(ctx, ctx->mntpoint);
+	sfs.f_bfree += arb.resblks;
+
+	/*
+	 * If we counted blocks with fsmap, then dblocks includes
+	 * blocks for the AGFL and the freespace/rmap btrees.  The
+	 * filesystem treats them as "free", but since we scanned
+	 * them, we'll consider them used.
+	 */
+	sfs.f_bfree -= summary[0].ag_owner;
+
+	/* Report on what we found. */
+	shift = xctx->blocklog - (BBSHIFT + 1);
+	fd = (xctx->geo.datablocks - sfs.f_bfree) << shift;
+	fr = (xctx->geo.rtblocks - fc.freertx) << shift;
+	fi = sfs.f_files - sfs.f_ffree;
+	sd = summary[0].dblocks << shift;
+	sr = summary[0].rblocks << shift;
+	si = summary[0].inodes;
+
+	/*
+	 * Complain if the counts are off by more than 10% unless
+	 * the inaccuracy is less than 32MB worth of blocks or 100 inodes.
+	 */
+	absdiff = 1 << (25 - xctx->blocklog);
+	complain = !within_range(ctx, sd, fd, absdiff, 1, 10, _("data blocks"));
+	complain |= !within_range(ctx, sr, fr, absdiff, 1, 10, _("realtime blocks"));
+	complain |= !within_range(ctx, si, fi, 100, 1, 10, _("inodes"));
+
+	if (complain || verbose) {
+		double		d, r, i;
+		char		*du, *ru, *iu;
+
+		if (fr || sr) {
+			d = auto_space_units(fd, &du);
+			r = auto_space_units(fr, &ru);
+			i = auto_units(fi, &iu);
+			printf(
+_("%.1f%s data blocks used;  %.1f%s rt blocks used;  %.2f%s inodes used.\n"),
+					d, du, r, ru, i, iu);
+			d = auto_space_units(sd, &du);
+			r = auto_space_units(sr, &ru);
+			i = auto_units(si, &iu);
+			printf(
+_("%.1f%s data blocks found; %.1f%s rt blocks found; %.2f%s inodes found.\n"),
+					d, du, r, ru, i, iu);
+		} else {
+			d = auto_space_units(fd, &du);
+			i = auto_units(fi, &iu);
+			printf(
+_("%.1f%s data blocks used;  %.1f%s inodes used.\n"),
+					d, du, i, iu);
+			d = auto_space_units(sd, &du);
+			i = auto_units(si, &iu);
+			printf(
+_("%.1f%s data blocks found; %.1f%s inodes found.\n"),
+					d, du, i, iu);
+		}
+	}
+	moveon = true;
+
+out:
+	for (agno = 1; agno < xctx->geo.agcount + 2; agno++) {
+		extent_tree_free(&summary[agno].dext);
+		extent_tree_free(&summary[agno].rext);
+	}
+	free(summary);
+	return moveon;
+}
+
+struct scrub_ops xfs_scrub_ops = {
+	.name			= "xfs",
+	.cleanup		= xfs_cleanup,
+	.scan_fs		= xfs_scan_fs,
+	.scan_inodes		= xfs_scan_inodes,
+	.check_dir		= generic_check_dir,
+	.check_inode		= generic_check_inode,
+	.scan_extents		= xfs_scan_extents,
+	.scan_xattrs		= xfs_scan_xattrs,
+	.scan_special_xattrs	= xfs_scan_special_xattrs,
+	.scan_metadata		= xfs_scan_metadata,
+	.check_summary		= xfs_check_summary,
+	.scan_blocks		= xfs_scan_blocks,
+	.read_file		= xfs_read_file,
+	.scan_fs_tree		= xfs_scan_fs_tree,
+};
diff --git a/scrub/xfs_ioctl.c b/scrub/xfs_ioctl.c
new file mode 100644
index 0000000..338b393
--- /dev/null
+++ b/scrub/xfs_ioctl.c
@@ -0,0 +1,465 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "libxfs.h"
+#include <sys/statvfs.h>
+#include <sys/types.h>
+#include <dirent.h>
+#include "disk.h"
+#include "scrub.h"
+#include "../repair/threads.h"
+#include "handle.h"
+#include "path.h"
+
+#include "xfs_ioctl.h"
+
+#define BSTATBUF_NR		1024
+#define FSMAP_NR		65536
+#define BMAP_NR			2048
+
+/* Iterate a range of inodes. */
+bool
+xfs_iterate_inodes(
+	struct scrub_ctx	*ctx,
+	struct xfs_inode_iter	*is,
+	xfs_agnumber_t		agno,
+	void			*fshandle,
+	uint64_t		first_ino,
+	uint64_t		last_ino)
+{
+	struct xfs_fsop_bulkreq	bulkreq;
+	struct xfs_bstat	*bstatbuf;
+	struct xfs_bstat	*p;
+	struct xfs_bstat	*endp;
+	struct xfs_handle	handle;
+	__s32			buflenout = 0;
+	bool			moveon = true;
+	int			error;
+
+	assert(!debug || !getenv("XFS_SCRUB_NO_BULKSTAT"));
+
+	bstatbuf = calloc(BSTATBUF_NR, sizeof(struct xfs_bstat));
+	if (!bstatbuf)
+		return false;
+
+	memset(&bulkreq, 0, sizeof(bulkreq));
+	bulkreq.lastip = (__u64 *)&first_ino;
+	bulkreq.icount  = BSTATBUF_NR;
+	bulkreq.ubuffer = (void *)bstatbuf;
+	bulkreq.ocount  = &buflenout;
+
+	memcpy(&handle.ha_fsid, fshandle, sizeof(handle.ha_fsid));
+	handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
+			sizeof(handle.ha_fid.fid_len);
+	handle.ha_fid.fid_pad = 0;
+	while ((error = xfsctl(ctx->mntpoint, ctx->mnt_fd, XFS_IOC_FSBULKSTAT,
+			&bulkreq)) == 0) {
+		if (buflenout == 0)
+			break;
+		for (p = bstatbuf, endp = bstatbuf + buflenout; p < endp; p++) {
+			if (p->bs_ino > last_ino)
+				goto out;
+
+			handle.ha_fid.fid_gen = p->bs_gen;
+			handle.ha_fid.fid_ino = p->bs_ino;
+			moveon = is->fn(ctx, agno, &handle, p, is->arg);
+			if (!moveon)
+				goto out;
+		}
+	}
+
+	if (error) {
+		str_errno(ctx, ctx->mntpoint);
+		moveon = false;
+	}
+out:
+	free(bstatbuf);
+	return moveon;
+}
+
+/* Does the kernel support bulkstat? */
+bool
+xfs_can_iterate_inodes(
+	struct scrub_ctx	*ctx)
+{
+	struct xfs_fsop_bulkreq	bulkreq;
+	__u64			lastino;
+	__s32			buflenout = 0;
+	int			error;
+
+	if (debug && getenv("XFS_SCRUB_NO_BULKSTAT"))
+		return false;
+
+	lastino = 0;
+	memset(&bulkreq, 0, sizeof(bulkreq));
+	bulkreq.lastip = (__u64 *)&lastino;
+	bulkreq.icount  = 0;
+	bulkreq.ubuffer = NULL;
+	bulkreq.ocount  = &buflenout;
+
+	error = xfsctl(ctx->mntpoint, ctx->mnt_fd, XFS_IOC_FSBULKSTAT,
+			&bulkreq);
+	return error == -1 && errno == EINVAL;
+}
+
+/* Iterate all the extent block mappings between the two keys. */
+bool
+xfs_iterate_bmap(
+	struct scrub_ctx	*ctx,
+	struct xfs_bmap_iter	*xbi,
+	int			fd,
+	int			whichfork,
+	struct getbmapx		*key)
+{
+	struct fsxattr		fsx;
+	struct getbmapx		*map;
+	struct getbmapx		*p;
+	char			descr[DESCR_BUFSZ];
+	bool			moveon = true;
+	xfs_off_t		new_off;
+	int			getxattr_type;
+	int			i;
+	int			error;
+
+	assert (!debug || !getenv("XFS_SCRUB_NO_BMAP"));
+
+	switch (whichfork) {
+	case XFS_ATTR_FORK:
+		snprintf(descr, DESCR_BUFSZ, _("%s attr"), xbi->descr);
+		break;
+	case XFS_COW_FORK:
+		snprintf(descr, DESCR_BUFSZ, _("%s CoW"), xbi->descr);
+		break;
+	case XFS_DATA_FORK:
+		snprintf(descr, DESCR_BUFSZ, _("%s data"), xbi->descr);
+		break;
+	default:
+		assert(0);
+	}
+
+	map = calloc(BMAP_NR, sizeof(struct getbmapx));
+	if (!map) {
+		str_errno(ctx, descr);
+		return false;
+	}
+
+	memcpy(map, key, sizeof(struct getbmapx));
+	map->bmv_count = BMAP_NR;
+
+	map->bmv_iflags = BMV_IF_NO_DMAPI_READ | BMV_IF_PREALLOC |
+			  BMV_OF_DELALLOC | BMV_IF_NO_HOLES;
+	switch (whichfork) {
+	case XFS_ATTR_FORK:
+		getxattr_type = XFS_IOC_FSGETXATTRA;
+		map->bmv_iflags |= BMV_IF_ATTRFORK;
+		break;
+	case XFS_COW_FORK:
+		map->bmv_iflags |= BMV_IF_COWFORK;
+		getxattr_type = XFS_IOC_FSGETXATTR;
+		break;
+	case XFS_DATA_FORK:
+		getxattr_type = XFS_IOC_FSGETXATTR;
+		break;
+	default:
+		assert(0);
+	}
+
+	error = xfsctl("", fd, getxattr_type, &fsx);
+	if (error < 0) {
+		str_errno(ctx, descr);
+		moveon = false;
+		goto out;
+	}
+
+	while ((error = xfsctl(descr, fd, XFS_IOC_GETBMAPX, map)) == 0) {
+
+		for (i = 0, p = &map[i + 1]; i < map->bmv_entries; i++, p++) {
+			moveon = xbi->fn(ctx, descr, fd, whichfork, &fsx,
+					p, xbi->arg);
+			if (!moveon)
+				goto out;
+		}
+
+		if (map->bmv_entries == 0)
+			break;
+		p = map + map->bmv_entries;
+		if (p->bmv_oflags & BMV_OF_LAST)
+			break;
+
+		new_off = p->bmv_offset + p->bmv_length;
+		map->bmv_length -= new_off - map->bmv_offset;
+		map->bmv_offset = new_off;
+	}
+
+	/* Pre-reflink filesystems don't know about CoW forks. */
+	if (whichfork == XFS_COW_FORK && error && errno == EINVAL)
+		error = 0;
+
+	if (error)
+		str_errno(ctx, descr);
+out:
+	memcpy(key, map, sizeof(struct getbmapx));
+	free(map);
+	return moveon;
+}
+
+/* Does the kernel support getbmapx? */
+bool
+xfs_can_iterate_bmap(
+	struct scrub_ctx	*ctx)
+{
+	struct getbmapx		bsm[2];
+	int			error;
+
+	if (debug && getenv("XFS_SCRUB_NO_BMAP"))
+		return false;
+
+	memset(bsm, 0, sizeof(struct getbmapx));
+	bsm->bmv_length = ULLONG_MAX;
+	bsm->bmv_count = 2;
+	error = xfsctl(ctx->mntpoint, ctx->mnt_fd, XFS_IOC_GETBMAPX, bsm);
+	return error == 0;
+}
+
+/* Iterate all the fs block mappings between the two keys. */
+bool
+xfs_iterate_fsmap(
+	struct scrub_ctx	*ctx,
+	struct xfs_fsmap_iter	*xfi,
+	int			idx,
+	struct getfsmap		*keys)
+{
+	struct getfsmap		*map;
+	struct getfsmap		*p;
+	char			descr[DESCR_BUFSZ];
+	bool			moveon = true;
+	int			i;
+	int			error;
+
+	assert(!debug || !getenv("XFS_SCRUB_NO_FSMAP"));
+
+	if (idx >= 0)
+		snprintf(descr, DESCR_BUFSZ, _("dev %d:%d AG %u fsmap"),
+				major(keys->fmv_device),
+				minor(keys->fmv_device),
+				idx);
+	else
+		snprintf(descr, DESCR_BUFSZ, _("dev %d:%d fsmap"),
+				major(keys->fmv_device),
+				minor(keys->fmv_device));
+
+	map = calloc(FSMAP_NR, sizeof(struct getfsmap));
+	if (!map) {
+		str_errno(ctx, descr);
+		return false;
+	}
+
+	memcpy(map, keys, sizeof(struct getfsmap) * 2);
+	map->fmv_count = FSMAP_NR;
+
+	while ((error = xfsctl(ctx->mntpoint, ctx->mnt_fd, XFS_IOC_GETFSMAP,
+				map)) == 0) {
+
+		for (i = 0, p = &map[i + 2]; i < map->fmv_entries; i++, p++) {
+			moveon = xfi->fn(ctx, descr, idx, p, xfi->arg);
+			if (!moveon)
+				goto out;
+		}
+
+		if (map->fmv_entries == 0)
+			break;
+		p = map + 1 + map->fmv_entries;
+		if (p->fmv_oflags & FMV_OF_LAST)
+			break;
+
+		map->fmv_device = p->fmv_device;
+		map->fmv_block = p->fmv_block;
+		map->fmv_owner = p->fmv_owner;
+		map->fmv_offset = p->fmv_offset;
+		map->fmv_oflags = p->fmv_oflags;
+		map->fmv_length = p->fmv_length;
+	}
+
+	if (error) {
+		str_errno(ctx, descr);
+		moveon = false;
+	}
+out:
+	memcpy(keys, map, sizeof(struct getfsmap) * 2);
+	free(map);
+	return moveon;
+}
+
+/* Does the kernel support getfsmap? */
+bool
+xfs_can_iterate_fsmap(
+	struct scrub_ctx	*ctx)
+{
+	struct getfsmap		fsm[3];
+	int			error;
+
+	if (debug && getenv("XFS_SCRUB_NO_FSMAP"))
+		return false;
+
+	memset(fsm, 0, 2 * sizeof(struct getfsmap));
+	(fsm + 1)->fmv_device = UINT_MAX;
+	(fsm + 1)->fmv_block = ULLONG_MAX;
+	(fsm + 1)->fmv_owner = ULLONG_MAX;
+	(fsm + 1)->fmv_offset = ULLONG_MAX;
+	fsm->fmv_count = 3;
+	error = xfsctl(ctx->mntpoint, ctx->mnt_fd, XFS_IOC_GETFSMAP, fsm);
+	return error == 0 && (fsm->fmv_oflags & FMV_HOF_DEV_T);
+}
+
+/* These must correspond to XFS_SCRUB_TYPE_ */
+static const struct scrub_descr scrubbers[] = {
+	{"superblock",				ST_PERAG},
+	{"AG free header",			ST_PERAG},
+	{"AG free list",			ST_PERAG},
+	{"AG inode header",			ST_PERAG},
+	{"freesp by block btree",		ST_PERAG},
+	{"freesp by length btree",		ST_PERAG},
+	{"inode btree",				ST_PERAG},
+	{"free inode btree",			ST_PERAG},
+	{"reverse mapping btree",		ST_PERAG},
+	{"reference count btree",		ST_PERAG},
+	{"inode",				ST_INODE},
+	{"inode data block map",		ST_INODE},
+	{"inode attr block map",		ST_INODE},
+	{"inode CoW block map",			ST_INODE},
+	{"realtime bitmap",			ST_FS},
+	{"realtime summary",			ST_FS},
+	{"realtime reverse mapping btree",	ST_FS},
+};
+
+/* Scrub each AG's metadata btrees. */
+bool
+xfs_scrub_ag_metadata(
+	struct scrub_ctx		*ctx,
+	xfs_agnumber_t			agno,
+	void				*arg)
+{
+	const struct scrub_descr	*scrubber;
+	char				buf[DESCR_BUFSZ];
+	struct xfs_scrub_metadata	meta;
+	int				type;
+	int				error;
+
+	assert(!debug || !getenv("XFS_SCRUB_NO_KERNEL"));
+
+	memset(&meta, 0, sizeof(meta));
+	meta.control = agno;
+	for (type = 0, scrubber = scrubbers;
+	     type <= XFS_SCRUB_TYPE_MAX;
+	     type++, scrubber++) {
+		if (scrubber->type != ST_PERAG)
+			continue;
+		snprintf(buf, DESCR_BUFSZ, _("AG %d %s"), agno,
+				_(scrubber->name));
+		if (debug)
+			printf(_("Scrubbing %s.\n"), buf);
+		meta.type = type;
+		error = ioctl(ctx->mnt_fd, XFS_IOC_SCRUB_METADATA, &meta);
+		if (error && errno != ENOENT)
+			str_errno(ctx, buf);
+	}
+
+	return true;
+}
+
+/* Scrub whole-FS metadata btrees. */
+bool
+xfs_scrub_fs_metadata(
+	struct scrub_ctx		*ctx,
+	void				*arg)
+{
+	const struct scrub_descr	*scrubber;
+	char				buf[DESCR_BUFSZ];
+	struct xfs_scrub_metadata	meta;
+	int				type;
+	int				error;
+
+	assert(!debug || !getenv("XFS_SCRUB_NO_KERNEL"));
+
+	memset(&meta, 0, sizeof(meta));
+	for (type = 0, scrubber = scrubbers;
+	     type <= XFS_SCRUB_TYPE_MAX;
+	     type++, scrubber++) {
+		if (scrubber->type != ST_FS)
+			continue;
+		snprintf(buf, DESCR_BUFSZ, _("%s"), _(scrubber->name));
+		if (debug)
+			printf(_("Scrubbing %s.\n"), buf);
+		meta.type = type;
+		error = ioctl(ctx->mnt_fd, XFS_IOC_SCRUB_METADATA, &meta);
+		if (error && errno != ENOENT)
+			str_errno(ctx, buf);
+	}
+
+	return true;
+}
+
+/* Scrub inode metadata btrees. */
+bool
+xfs_scrub_inode_metadata(
+	struct scrub_ctx		*ctx,
+	uint64_t			ino,
+	int				fd)
+{
+	const struct scrub_descr	*scrubber;
+	char				buf[DESCR_BUFSZ];
+	struct xfs_scrub_metadata	meta;
+	int				type;
+	int				error;
+
+	assert(!debug || !getenv("XFS_SCRUB_NO_KERNEL"));
+
+	memset(&meta, 0, sizeof(meta));
+	for (type = 0, scrubber = scrubbers;
+	     type <= XFS_SCRUB_TYPE_MAX;
+	     type++, scrubber++) {
+		if (scrubber->type != ST_INODE)
+			continue;
+		snprintf(buf, DESCR_BUFSZ, _("inode %"PRIu64" %s"),
+				ino, _(scrubber->name));
+		meta.type = type;
+		error = xfsctl("", fd, XFS_IOC_SCRUB_METADATA, &meta);
+		if (error && errno != ENOENT)
+			str_errno(ctx, buf);
+	}
+
+	return true;
+}
+
+/* Test the availability of the kernel scrub ioctl. */
+bool
+xfs_can_scrub_metadata(
+	struct scrub_ctx		*ctx)
+{
+	struct xfs_scrub_metadata	meta;
+	int				error;
+
+	if (debug && getenv("XFS_SCRUB_NO_KERNEL"))
+		return false;
+
+	memset(&meta, 0xFF, sizeof(meta));
+	error = xfsctl(ctx->mntpoint, ctx->mnt_fd, XFS_IOC_SCRUB_METADATA,
+			&meta);
+	return error == -1 && errno == EINVAL;
+}
diff --git a/scrub/xfs_ioctl.h b/scrub/xfs_ioctl.h
new file mode 100644
index 0000000..54645bb
--- /dev/null
+++ b/scrub/xfs_ioctl.h
@@ -0,0 +1,89 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#ifndef XFS_IOCTL_H_
+#define XFS_IOCTL_H_
+
+struct xfs_inode_iter {
+	/* Iterator function and arg. */
+	bool			(*fn)(struct scrub_ctx *, xfs_agnumber_t,
+				      struct xfs_handle *,
+				      struct xfs_bstat *, void *);
+	void			*arg;
+
+	/* Should we keep scanning? */
+	bool			moveon;
+};
+
+bool xfs_iterate_inodes(struct scrub_ctx *ctx, struct xfs_inode_iter *is,
+		xfs_agnumber_t agno, void *fshandle, uint64_t first_ino,
+		uint64_t last_ino);
+bool xfs_can_iterate_inodes(struct scrub_ctx *ctx);
+
+struct xfs_bmap_iter {
+	/* Iterator function and arg. */
+	bool			(*fn)(struct scrub_ctx *, const char *,
+				      int, int, struct fsxattr *,
+				      struct getbmapx *, void *);
+	void			*arg;
+
+	/* Description of the file descriptor. */
+	const char		*descr;
+
+	/* Should we keep scanning? */
+	bool			moveon;
+};
+
+bool xfs_iterate_bmap(struct scrub_ctx *ctx, struct xfs_bmap_iter *xbi,
+		int fd, int whichfork, struct getbmapx *key);
+bool xfs_can_iterate_bmap(struct scrub_ctx *ctx);
+
+struct xfs_fsmap_iter {
+	/* Iterator function and arg. */
+	bool			(*fn)(struct scrub_ctx *, const char *,
+				      int, struct getfsmap *, void *);
+	void			*arg;
+
+	/* Should we keep scanning? */
+	bool			moveon;
+};
+
+bool xfs_iterate_fsmap(struct scrub_ctx *ctx, struct xfs_fsmap_iter *xfi,
+		int idx, struct getfsmap *keys);
+bool xfs_can_iterate_fsmap(struct scrub_ctx *ctx);
+
+/* Type info and names for the scrub types. */
+enum scrub_type {
+	ST_NONE,	/* disabled */
+	ST_PERAG,	/* per-AG metadata */
+	ST_FS,		/* per-FS metadata */
+	ST_INODE,	/* per-inode metadata */
+};
+struct scrub_descr {
+	const char	*name;
+	enum scrub_type	type;
+};
+
+bool xfs_scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
+		void *arg);
+bool xfs_scrub_fs_metadata(struct scrub_ctx *ctx, void *arg);
+bool xfs_scrub_inode_metadata(struct scrub_ctx *ctx, uint64_t ino, int fd);
+bool xfs_can_scrub_metadata(struct scrub_ctx *ctx);
+
+#endif /* XFS_IOCTL_H_ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
