Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40244 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754442AbcKEA2x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:28:53 -0400
Subject: [PATCH 39/39] xfs_scrub: create online filesystem scrub program
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:28:44 -0700
Message-ID: <147830572454.4165.18074642184555452652.stgit@birch.djwong.org>
In-Reply-To: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
References: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

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

Note also that the scrub tool can shut down the filesystem if errors
are found.  This is not a default option since scrubbing is very
immature at this time.  It can also ask the XFS driver in the kernel
to optimize or repair metadata, though this may not be successful.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 Makefile              |    3 
 configure.ac          |   13 
 include/builddefs.in  |   13 
 m4/Makefile           |    1 
 m4/package_attrdev.m4 |   29 +
 m4/package_libcdev.m4 |  140 +++
 man/man8/xfs_scrub.8  |  127 +++
 scrub/Makefile        |   47 +
 scrub/bitmap.c        |  425 ++++++++
 scrub/bitmap.h        |   42 +
 scrub/disk.c          |  278 ++++++
 scrub/disk.h          |   41 +
 scrub/generic.c       | 1151 +++++++++++++++++++++++
 scrub/iocmd.c         |  412 ++++++++
 scrub/iocmd.h         |   50 +
 scrub/non_xfs.c       |  185 ++++
 scrub/read_verify.c   |  314 ++++++
 scrub/read_verify.h   |   59 +
 scrub/scrub.c         | 1009 ++++++++++++++++++++
 scrub/scrub.h         |  197 ++++
 scrub/xfs.c           | 2465 +++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/xfs_ioctl.c     |  767 +++++++++++++++
 scrub/xfs_ioctl.h     |   84 ++
 23 files changed, 7851 insertions(+), 1 deletion(-)
 create mode 100644 m4/package_attrdev.m4
 create mode 100644 man/man8/xfs_scrub.8
 create mode 100644 scrub/Makefile
 create mode 100644 scrub/bitmap.c
 create mode 100644 scrub/bitmap.h
 create mode 100644 scrub/disk.c
 create mode 100644 scrub/disk.h
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
index 84dc62c..eb41be3 100644
--- a/Makefile
+++ b/Makefile
@@ -46,7 +46,7 @@ HDR_SUBDIRS = include libxfs
 DLIB_SUBDIRS = libxlog libxcmd libhandle
 LIB_SUBDIRS = libxfs $(DLIB_SUBDIRS)
 TOOL_SUBDIRS = copy db estimate fsck growfs io logprint mkfs quota \
-		mdrestore repair rtcp m4 man doc debian
+		mdrestore repair rtcp m4 man doc debian scrub
 
 ifneq ("$(PKG_PLATFORM)","darwin")
 TOOL_SUBDIRS += fsr
@@ -87,6 +87,7 @@ quota: libxcmd
 repair: libxlog libxcmd
 copy: libxlog
 mkfs: libxcmd
+scrub: libhandle libxcmd repair
 
 ifeq ($(HAVE_BUILDDEFS), yes)
 include $(BUILDRULES)
diff --git a/configure.ac b/configure.ac
index b88ab7f..6d6cb11 100644
--- a/configure.ac
+++ b/configure.ac
@@ -131,8 +131,21 @@ AC_HAVE_MNTENT
 AC_HAVE_FLS
 AC_HAVE_READDIR
 AC_HAVE_FSETXATTR
+AC_HAVE_FGETXATTR
+AC_HAVE_FLISTXATTR
+AC_HAVE_LLISTXATTR
 AC_HAVE_MREMAP
 AC_NEED_INTERNAL_FSXATTR
+AC_HAVE_MALLINFO
+AC_HAVE_SG_IO
+AC_HAVE_HDIO_GETGEO
+AC_HAVE_ATTRIBUTES_H
+AC_HAVE_ATTRIBUTES_MACROS
+AC_HAVE_ATTRIBUTES_STRUCTS
+AC_HAVE_OPENAT
+AC_HAVE_READLINKAT
+AC_HAVE_SYNCFS
+AC_HAVE_FSTATAT
 
 if test "$enable_blkid" = yes; then
 AC_HAVE_BLKID_TOPO
diff --git a/include/builddefs.in b/include/builddefs.in
index aeb2905..a8ebd68 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -108,8 +108,21 @@ HAVE_READDIR = @have_readdir@
 HAVE_MNTENT = @have_mntent@
 HAVE_FLS = @have_fls@
 HAVE_FSETXATTR = @have_fsetxattr@
+HAVE_FGETXATTR = @have_fgetxattr@
+HAVE_FLISTXATTR = @have_flistxattr@
+HAVE_LLISTXATTR = @have_llistxattr@
 HAVE_MREMAP = @have_mremap@
 NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
+HAVE_MALLINFO = @have_mallinfo@
+HAVE_SG_IO = @have_sg_io@
+HAVE_HDIO_GETGEO = @have_hdio_getgeo@
+HAVE_ATTRIBUTES_H = @have_attributes_h@
+HAVE_ATTRIBUTES_MACROS = @have_attributes_macros@
+HAVE_ATTRIBUTES_STRUCTS = @have_attributes_structs@
+HAVE_OPENAT = @have_openat@
+HAVE_READLINKAT = @have_readlinkat@
+HAVE_SYNCFS = @have_syncfs@
+HAVE_FSTATAT = @have_fstatat@
 
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
index e3c59d8..64c3171 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -236,6 +236,45 @@ AC_DEFUN([AC_HAVE_FSETXATTR],
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
@@ -293,3 +332,104 @@ AC_DEFUN([AC_NEED_INTERNAL_FSXATTR],
     )
     AC_SUBST(need_internal_fsxattr)
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
+# Check if we have the HDIO_GETGEO ioctl
+#
+AC_DEFUN([AC_HAVE_HDIO_GETGEO],
+  [ AC_MSG_CHECKING([for struct hd_geometry ])
+    AC_TRY_COMPILE([#include <linux/hdreg.h>],
+    [
+         struct hd_geometry hdr;
+         ioctl(0, HDIO_GETGEO, &hdr);
+    ], have_hdio_getgeo=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_hdio_getgeo)
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
+
+#
+# Check if we have a fstatat call
+#
+AC_DEFUN([AC_HAVE_FSTATAT],
+  [ AC_CHECK_DECL([fstatat],
+       have_fstatat=yes,
+       [],
+       [#define _GNU_SOURCE
+       #include <sys/types.h>
+       #include <sys/stat.h>
+       #include <unistd.h>])
+    AC_SUBST(have_fstatat)
+  ])
diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
new file mode 100644
index 0000000..0ad1fb8
--- /dev/null
+++ b/man/man8/xfs_scrub.8
@@ -0,0 +1,127 @@
+.TH xfs_scrub 8
+.SH NAME
+xfs_scrub \- scrub the contents of an XFS filesystem
+.SH SYNOPSIS
+.B xfs_scrub
+[
+.B \-ademntTvVxy
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
+will ask the kernel to perform more rigorous scrubbing of the
+internal metadata.
+The in-kernel scrubbers also cross-reference each data structure's
+records against the other filesystem metadata.
+.PP
+This utility does not know how to correct all errors.
+If the tool cannot fix the detected errors, you must unmount the
+filesystem and run the appropriate repair tool.
+if this tool is run without either of the
+.B \-n
+or
+.B \-y
+options, then it will preen and optimize the filesystem when possible,
+though it will not try to fix errors.
+.SH OPTIONS
+.TP
+.BI \-a " errors"
+Abort if more than this many errors are found on the filesystem.
+.TP
+.B \-d
+Enable debugging mode, which augments error reports with the exact file
+and line where the scrub failure occurred.
+This also enables verbose mode.
+.TP
+.B \-e
+Specifies what happens when errors are detected.
+If
+.IR shutdown
+is given, the filesystem will be taken offline if errors are found.
+Not all backends can shut down a filesystem.
+If
+.IR continue
+is given, no action taken if errors are found.
+This is the default.
+.TP
+.BI \-m " file"
+Search this file for mounted filesystems instead of /etc/mtab.
+.TP
+.B \-n
+Dry run, do not modify anything in the filesystem.  This disables
+all preening and optimization behaviors, and disables calling
+FITRIM on the free space after a successful run.
+.TP
+.BI \-t " fstype"
+Force the use of a particular type of filesystem scrubber.
+The current backends are:
+.IR xfs , " ext4" , " ext3", " ext2", " btrfs" ", and " generic "."
+Most filesystems will work just fine with the generic backend.
+.TP
+.BI \-T
+Print timing and memory usage information for each phase.
+.TP
+.B \-v
+Enable verbose mode, which prints periodic status updates.
+.TP
+.B \-V
+Prints the version number and exits.
+.TP
+.B \-x
+Scrub file data.  This reads every block of every file on disk.
+If the filesystem reports file extent mappings or physical extent
+mappings and is backed by a block device,
+.TP
+.B \-y
+Try to repair all filesystem errors.  If the errors cannot be fixed
+online, then the filesystem must be taken offline for repair.
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
index 0000000..c6cdaf5
--- /dev/null
+++ b/scrub/Makefile
@@ -0,0 +1,47 @@
+#
+# Copyright (c) 2016 Oracle.  All Rights Reserved.
+#
+
+TOPDIR = ..
+include $(TOPDIR)/include/builddefs
+
+SCRUB_PREREQS=$(HAVE_FIEMAP)$(HAVE_ATTRIBUTES_H)$(HAVE_ATTRIBUTES_MACROS)$(HAVE_ATTRIBUTES_STRUCTS)$(HAVE_FGETXATTR)$(HAVE_FLISTXATTR)$(HAVE_LLISTXATTR)$(HAVE_OPENAT)$(HAVE_READLINKAT)$(HAVE_FSTATAT)
+
+ifeq ($(SCRUB_PREREQS),yesyesyesyesyesyesyesyesyesyes)
+LTCOMMAND = xfs_scrub
+endif
+
+HFILES = scrub.h ../repair/threads.h xfs_ioctl.h read_verify.h iocmd.h
+CFILES = ../repair/avl64.c disk.c bitmap.c generic.c iocmd.c non_xfs.c \
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
+ifeq ($(HAVE_HDIO_GETGEO),yes)
+LCFLAGS += -DHAVE_HDIO_GETGEO
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
diff --git a/scrub/bitmap.c b/scrub/bitmap.c
new file mode 100644
index 0000000..96ea745
--- /dev/null
+++ b/scrub/bitmap.c
@@ -0,0 +1,425 @@
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
+#include "bitmap.h"
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
+struct bitmap_node {
+	struct avl64node	btn_node;
+	uint64_t		btn_start;
+	uint64_t		btn_length;
+};
+
+static __uint64_t
+extent_start(
+	struct avl64node	*node)
+{
+	struct bitmap_node	*btn;
+
+	btn = container_of(node, struct bitmap_node, btn_node);
+	return btn->btn_start;
+}
+
+static __uint64_t
+extent_end(
+	struct avl64node	*node)
+{
+	struct bitmap_node	*btn;
+
+	btn = container_of(node, struct bitmap_node, btn_node);
+	return btn->btn_start + btn->btn_length;
+}
+
+static struct avl64ops bitmap_ops = {
+	extent_start,
+	extent_end,
+};
+
+/* Initialize an extent tree. */
+bool
+bitmap_init(
+	struct bitmap		*tree)
+{
+	tree->bt_tree = malloc(sizeof(struct avl64tree_desc));
+	if (!tree->bt_tree)
+		return false;
+
+	pthread_mutex_init(&tree->bt_lock, NULL);
+	avl64_init_tree(tree->bt_tree, &bitmap_ops);
+
+	return true;
+}
+
+/* Free an extent tree. */
+void
+bitmap_free(
+	struct bitmap		*tree)
+{
+	struct avl64node	*node;
+	struct avl64node	*n;
+	struct bitmap_node	*ext;
+
+	if (!tree->bt_tree)
+		return;
+
+	avl_for_each_safe(tree->bt_tree, node, n) {
+		ext = container_of(node, struct bitmap_node, btn_node);
+		free(ext);
+	}
+	free(tree->bt_tree);
+	tree->bt_tree = NULL;
+}
+
+/* Create a new extent. */
+static struct bitmap_node *
+bitmap_node_init(
+	uint64_t		start,
+	uint64_t		len)
+{
+	struct bitmap_node	*ext;
+
+	ext = malloc(sizeof(struct bitmap_node));
+	if (!ext)
+		return NULL;
+
+	ext->btn_node.avl_nextino = NULL;
+	ext->btn_start = start;
+	ext->btn_length = len;
+
+	return ext;
+}
+
+/* Add an extent (locked). */
+static bool
+__bitmap_add(
+	struct bitmap		*tree,
+	uint64_t		start,
+	uint64_t		length)
+{
+	struct avl64node	*firstn;
+	struct avl64node	*lastn;
+	struct avl64node	*pos;
+	struct avl64node	*n;
+	struct avl64node	*l;
+	struct bitmap_node	*ext;
+	uint64_t		new_start;
+	uint64_t		new_length;
+	struct avl64node	*node;
+	bool			res = true;
+
+	/* Find any existing nodes adjacent or within that range. */
+	avl64_findranges(tree->bt_tree, start - 1, start + length + 1,
+			&firstn, &lastn);
+
+	/* Nothing, just insert a new extent. */
+	if (firstn == NULL && lastn == NULL) {
+		ext = bitmap_node_init(start, length);
+		if (!ext)
+			return false;
+
+		node = avl64_insert(tree->bt_tree, &ext->btn_node);
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
+		ext = container_of(pos, struct bitmap_node, btn_node);
+
+		/* Bail if the new extent is contained within an old one. */
+		if (ext->btn_start <= start &&
+		    ext->btn_start + ext->btn_length >= start + length)
+			return res;
+
+		/* Check for overlapping and adjacent extents. */
+		if (ext->btn_start + ext->btn_length >= start ||
+		    ext->btn_start <= start + length) {
+			if (ext->btn_start < start) {
+				new_start = ext->btn_start;
+				new_length += ext->btn_length;
+			}
+
+			if (ext->btn_start + ext->btn_length >
+			    new_start + new_length)
+				new_length = ext->btn_start + ext->btn_length -
+						new_start;
+
+			avl64_delete(tree->bt_tree, pos);
+			free(ext);
+		}
+	}
+
+	ext = bitmap_node_init(new_start, new_length);
+	if (!ext)
+		return false;
+
+	node = avl64_insert(tree->bt_tree, &ext->btn_node);
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
+bitmap_add(
+	struct bitmap		*tree,
+	uint64_t		start,
+	uint64_t		length)
+{
+	bool			res;
+
+	pthread_mutex_lock(&tree->bt_lock);
+	res = __bitmap_add(tree, start, length);
+	pthread_mutex_unlock(&tree->bt_lock);
+
+	return res;
+}
+
+/* Remove an extent. */
+bool
+bitmap_remove(
+	struct bitmap		*tree,
+	uint64_t		start,
+	uint64_t		len)
+{
+	struct avl64node	*firstn;
+	struct avl64node	*lastn;
+	struct avl64node	*pos;
+	struct avl64node	*n;
+	struct avl64node	*l;
+	struct bitmap_node	*ext;
+	uint64_t		new_start;
+	uint64_t		new_length;
+	struct avl64node	*node;
+	int			stat;
+
+	pthread_mutex_lock(&tree->bt_lock);
+	/* Find any existing nodes over that range. */
+	avl64_findranges(tree->bt_tree, start, start + len, &firstn, &lastn);
+
+	/* Nothing, we're done. */
+	if (firstn == NULL && lastn == NULL) {
+		pthread_mutex_unlock(&tree->bt_lock);
+		return true;
+	}
+
+	ASSERT(firstn != NULL && lastn != NULL);
+
+	/* Delete or truncate everything in sight. */
+	avl_for_each_range_safe(pos, n, l, firstn, lastn) {
+		ext = container_of(pos, struct bitmap_node, btn_node);
+
+		stat = 0;
+		if (ext->btn_start < start)
+			stat |= 1;
+		if (ext->btn_start + ext->btn_length > start + len)
+			stat |= 2;
+		switch (stat) {
+		case 0:
+			/* Extent totally within range; delete. */
+			avl64_delete(tree->bt_tree, pos);
+			free(ext);
+			break;
+		case 1:
+			/* Extent is left-adjacent; truncate. */
+			ext->btn_length = start - ext->btn_start;
+			break;
+		case 2:
+			/* Extent is right-adjacent; move it. */
+			ext->btn_length = ext->btn_start + ext->btn_length -
+					(start + len);
+			ext->btn_start = start + len;
+			break;
+		case 3:
+			/* Extent overlaps both ends. */
+			ext->btn_length = start - ext->btn_start;
+			new_start = start + len;
+			new_length = ext->btn_start + ext->btn_length -
+					new_start;
+
+			ext = bitmap_node_init(new_start, new_length);
+			if (!ext)
+				return false;
+
+			node = avl64_insert(tree->bt_tree, &ext->btn_node);
+			if (node == NULL) {
+				errno = EEXIST;
+				return false;
+			}
+			break;
+		}
+	}
+
+	pthread_mutex_unlock(&tree->bt_lock);
+	return true;
+}
+
+/* Iterate an extent tree. */
+bool
+bitmap_iterate(
+	struct bitmap		*tree,
+	bool			(*fn)(uint64_t, uint64_t, void *),
+	void			*arg)
+{
+	struct avl64node	*node;
+	struct bitmap_node	*ext;
+	bool			moveon = true;
+
+	pthread_mutex_lock(&tree->bt_lock);
+	avl_for_each(tree->bt_tree, node) {
+		ext = container_of(node, struct bitmap_node, btn_node);
+		moveon = fn(ext->btn_start, ext->btn_length, arg);
+		if (!moveon)
+			break;
+	}
+	pthread_mutex_unlock(&tree->bt_lock);
+
+	return moveon;
+}
+
+/* Do any extents overlap the given one?  (locked) */
+static bool
+__bitmap_has_extent(
+	struct bitmap		*tree,
+	uint64_t		start,
+	uint64_t		len)
+{
+	struct avl64node	*firstn;
+	struct avl64node	*lastn;
+
+	/* Find any existing nodes over that range. */
+	avl64_findranges(tree->bt_tree, start, start + len, &firstn, &lastn);
+
+	return firstn != NULL && lastn != NULL;
+}
+
+/* Do any extents overlap the given one? */
+bool
+bitmap_has_extent(
+	struct bitmap		*tree,
+	uint64_t		start,
+	uint64_t		len)
+{
+	bool			res;
+
+	pthread_mutex_lock(&tree->bt_lock);
+	res = __bitmap_has_extent(tree, start, len);
+	pthread_mutex_unlock(&tree->bt_lock);
+
+	return res;
+}
+
+/* Ensure that the extent is set, and return the old value. */
+bool
+bitmap_test_and_set(
+	struct bitmap		*tree,
+	uint64_t		start,
+	bool			*was_set)
+{
+	bool			res = true;
+
+	pthread_mutex_lock(&tree->bt_lock);
+	*was_set = __bitmap_has_extent(tree, start, 1);
+	if (!(*was_set))
+		res = __bitmap_add(tree, start, 1);
+	pthread_mutex_unlock(&tree->bt_lock);
+
+	return res;
+}
+
+/* Is it empty? */
+bool
+bitmap_empty(
+	struct bitmap		*tree)
+{
+	return tree->bt_tree->avl_firstino == NULL;
+}
+
+static bool
+merge_helper(
+	uint64_t		start,
+	uint64_t		length,
+	void			*arg)
+{
+	struct bitmap		*thistree = arg;
+
+	return __bitmap_add(thistree, start, length);
+}
+
+/* Merge another tree with this one. */
+bool
+bitmap_merge(
+	struct bitmap		*thistree,
+	struct bitmap		*tree)
+{
+	bool			res;
+
+	assert(thistree != tree);
+
+	pthread_mutex_lock(&thistree->bt_lock);
+	res = bitmap_iterate(tree, merge_helper, thistree);
+	pthread_mutex_unlock(&thistree->bt_lock);
+
+	return res;
+}
+
+static bool
+bitmap_dump_fn(
+	uint64_t		startblock,
+	uint64_t		blockcount,
+	void			*arg)
+{
+	printf("%"PRIu64":%"PRIu64"\n", startblock, blockcount);
+	return true;
+}
+
+/* Dump extent tree. */
+void
+bitmap_dump(
+	struct bitmap		*tree)
+{
+	printf("BITMAP DUMP %p\n", tree);
+	bitmap_iterate(tree, bitmap_dump_fn, NULL);
+	printf("BITMAP DUMP DONE\n");
+}
diff --git a/scrub/bitmap.h b/scrub/bitmap.h
new file mode 100644
index 0000000..1c0a8a8
--- /dev/null
+++ b/scrub/bitmap.h
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
+#ifndef BITMAP_H_
+#define BITMAP_H_
+
+struct bitmap {
+	pthread_mutex_t		bt_lock;
+	struct avl64tree_desc	*bt_tree;
+};
+
+bool bitmap_init(struct bitmap *tree);
+void bitmap_free(struct bitmap *tree);
+bool bitmap_add(struct bitmap *tree, uint64_t start, uint64_t length);
+bool bitmap_remove(struct bitmap *tree, uint64_t start,
+		uint64_t len);
+bool bitmap_iterate(struct bitmap *tree,
+		bool (*fn)(uint64_t, uint64_t, void *), void *arg);
+bool bitmap_has_extent(struct bitmap *tree, uint64_t start,
+		uint64_t len);
+bool bitmap_test_and_set(struct bitmap *tree, uint64_t start, bool *was_set);
+bool bitmap_empty(struct bitmap *tree);
+bool bitmap_merge(struct bitmap *thistree, struct bitmap *tree);
+void bitmap_dump(struct bitmap *tree);
+
+#endif /* BITMAP_H_ */
diff --git a/scrub/disk.c b/scrub/disk.c
new file mode 100644
index 0000000..8343a3c
--- /dev/null
+++ b/scrub/disk.c
@@ -0,0 +1,278 @@
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
+#ifdef HAVE_HDIO_GETGEO
+# include <linux/hdreg.h>
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
+	if (debug_tweak_on("XFS_SCRUB_NO_THREADS"))
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
+		return min(libxfs_nproc(), max(1, ioopt / iomin));
+	}
+
+	/* Rotating device?  I guess? */
+	return 2;
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
+static int
+disk_scsi_verify(
+	struct disk		*disk,
+	uint64_t		startblock, /* lba */
+	uint64_t		blockcount) /* lba */
+{
+	struct sg_io_hdr	iohdr;
+	unsigned char		cdb[VERIFY16_CMDLEN];
+	unsigned char		sense[SENSE_BUF_LEN];
+	uint64_t		llba;
+	uint64_t		veri_len = blockcount;
+	int			error;
+
+	assert(!debug_tweak_on("XFS_SCRUB_NO_SCSI_VERIFY"));
+
+	llba = startblock + (disk->d_start >> BBSHIFT);
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
+	error = ioctl(disk->d_fd, SG_IO, &iohdr);
+	if (error)
+		return error;
+
+	dbg_printf("VERIFY(16) fd %d lba %"PRIu64" len %"PRIu64" info %x "
+			"status %d masked %d msg %d host %d driver %d "
+			"duration %d resid %d\n",
+			disk->d_fd, startblock, blockcount, iohdr.info,
+			iohdr.status, iohdr.masked_status, iohdr.msg_status,
+			iohdr.host_status, iohdr.driver_status, iohdr.duration,
+			iohdr.resid);
+
+	if (iohdr.info & SG_INFO_CHECK) {
+		dbg_printf("status: msg %x host %x driver %x\n",
+				iohdr.msg_status, iohdr.host_status,
+				iohdr.driver_status);
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
+static bool
+disk_can_scsi_verify(
+	struct disk		*disk)
+{
+	int			error;
+
+	if (debug_tweak_on("XFS_SCRUB_NO_SCSI_VERIFY"))
+		return false;
+
+	error = disk_scsi_verify(disk, 0, 1);
+	return error == 0;
+}
+
+/* Open a disk device and discover its geometry. */
+int
+disk_open(
+	const char		*pathname,
+	struct disk		*disk)
+{
+#ifdef HAVE_HDIO_GETGEO
+	struct hd_geometry	bdgeo;
+#endif
+	bool			suspicious_disk = false;
+	int			lba_sz;
+	int			error;
+
+	disk->d_fd = open(pathname, O_RDONLY | O_DIRECT | O_NOATIME);
+	if (disk->d_fd < 0)
+		return -1;
+
+	/* Try to get LBA size. */
+	error = ioctl(disk->d_fd, BLKSSZGET, &lba_sz);
+	if (error)
+		lba_sz = 512;
+	disk->d_lbalog = libxfs_log2_roundup(lba_sz);
+
+	/* Obtain disk's stat info. */
+	error = fstat(disk->d_fd, &disk->d_sb);
+	if (error) {
+		error = errno;
+		close(disk->d_fd);
+		errno = error;
+		disk->d_fd = -1;
+		return -1;
+	}
+
+	/* Determine bdev size, block size, and offset. */
+	if (S_ISBLK(disk->d_sb.st_mode)) {
+		error = ioctl(disk->d_fd, BLKGETSIZE64, &disk->d_size);
+		if (error)
+			disk->d_size = 0;
+		error = ioctl(disk->d_fd, BLKBSZGET, &disk->d_blksize);
+		if (error)
+			disk->d_blksize = 0;
+#ifdef HAVE_HDIO_GETGEO
+		error = ioctl(disk->d_fd, HDIO_GETGEO, &bdgeo);
+		if (!error) {
+			/*
+			 * dm devices will pass through ioctls, which means
+			 * we can't use SCSI VERIFY unless the start is 0.
+			 * Most dm devices don't set geometry (unlike scsi
+			 * and nvme) so use a zeroed out CHS to screen them
+			 * out.
+			 */
+			if (bdgeo.start != 0 &&
+			    (unsigned long long)bdgeo.heads * bdgeo.sectors *
+					bdgeo.sectors == 0)
+				suspicious_disk = true;
+			disk->d_start = bdgeo.start << BBSHIFT;
+		} else
+#endif
+			disk->d_start = 0;
+	} else {
+		disk->d_size = disk->d_sb.st_size;
+		disk->d_blksize = disk->d_sb.st_blksize;
+		disk->d_start = 0;
+	}
+
+	/* Can we issue SCSI VERIFY? */
+	if (!suspicious_disk && disk_can_scsi_verify(disk))
+		disk->d_flags |= DISK_FLAG_SCSI_VERIFY;
+
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
+#define BTOLBAT(d, bytes)	((uint64_t)(bytes) >> (d)->d_lbalog)
+#define LBASIZE(d)		(1ULL << (d)->d_lbalog)
+#define BTOLBA(d, bytes)	(((uint64_t)(bytes) + LBASIZE(d) - 1) >> (d)->d_lbalog)
+
+/* Read-verify an extent of a disk device. */
+ssize_t
+disk_read_verify(
+	struct disk		*disk,
+	void			*buf,
+	uint64_t		start,
+	uint64_t		length)
+{
+	/* Convert to logical block size. */
+	if (disk->d_flags & DISK_FLAG_SCSI_VERIFY)
+		return disk_scsi_verify(disk, BTOLBAT(disk, start),
+				BTOLBA(disk, length));
+
+	return pread(disk->d_fd, buf, length, start);
+}
diff --git a/scrub/disk.h b/scrub/disk.h
new file mode 100644
index 0000000..915907d
--- /dev/null
+++ b/scrub/disk.h
@@ -0,0 +1,41 @@
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
+	struct stat	d_sb;
+	int		d_fd;
+	int		d_lbalog;
+	unsigned int	d_flags;
+	unsigned int	d_blksize;	/* bytes */
+	uint64_t	d_size;		/* bytes */
+	uint64_t	d_start;	/* bytes */
+};
+
+unsigned int disk_heads(struct disk *disk);
+bool disk_is_open(struct disk *disk);
+int disk_open(const char *pathname, struct disk *disk);
+int disk_close(struct disk *disk);
+ssize_t disk_read_verify(struct disk *disk, void *buf, uint64_t startblock,
+		uint64_t blockcount);
+
+#endif /* DISK_H_ */
diff --git a/scrub/generic.c b/scrub/generic.c
new file mode 100644
index 0000000..bcec07c
--- /dev/null
+++ b/scrub/generic.c
@@ -0,0 +1,1151 @@
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
+#include "bitmap.h"
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
+	struct bitmap	*tree = arg;
+
+	/* Skip non-real/non-aligned extents. */
+	if (extent->fe_flags & (FIEMAP_EXTENT_UNKNOWN |
+				FIEMAP_EXTENT_DELALLOC |
+				FIEMAP_EXTENT_ENCODED |
+				FIEMAP_EXTENT_NOT_ALIGNED |
+				FIEMAP_EXTENT_UNWRITTEN))
+		return true;
+
+	if (!bitmap_has_extent(tree, extent->fe_physical,
+			extent->fe_length))
+		return true;
+
+	str_error(ctx, descr,
+_("offset %llu failed read verification."), extent->fe_logical);
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
+	struct stat		*sb,
+	void			*arg)
+{
+	bool			moveon;
+	int			fd;
+
+	/* Ignore things we can't open. */
+	if (!S_ISREG(sb->st_mode))
+		return true;
+	/* Ignore . and .. */
+	if (dirent && (!strcmp(".", dirent->d_name) ||
+		       !strcmp("..", dirent->d_name)))
+		return true;
+
+	/* Open the file */
+	fd = dirent_open(dir_fd, dirent);
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
+	struct bitmap		*d_bad)
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
+	/* If there's no disk device, forget FIEMAP. */
+	if (!disk_is_open(&ctx->datadev))
+		ctx->quirks &= ~(SCRUB_QUIRK_FIEMAP_WORKS |
+				 SCRUB_QUIRK_FIEMAP_ATTR_WORKS |
+				 SCRUB_QUIRK_FIBMAP_WORKS);
+
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
+
+	if (!disk_is_open(&ctx->datadev))
+		return true;
+	eofs = ctx->datadev.d_size;
+
+	if (extent->fe_length == 0)
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) has zero length."),
+			extent->fe_physical,
+			extent->fe_logical,
+			extent->fe_length);
+	if (extent->fe_physical > eofs)
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) starts past end of filesystem at %llu."),
+			extent->fe_physical,
+			extent->fe_logical,
+			extent->fe_length,
+			eofs);
+	if (extent->fe_physical + extent->fe_length > eofs ||
+	    extent->fe_physical + extent->fe_length < extent->fe_physical)
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) ends past end of filesystem at %llu."),
+			extent->fe_physical,
+			extent->fe_logical,
+			extent->fe_length,
+			eofs);
+	if (extent->fe_logical + extent->fe_length < extent->fe_logical)
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) overflows file offset."),
+			extent->fe_physical,
+			extent->fe_logical,
+			extent->fe_length);
+	return true;
+}
+
+/* Check an inode's extents. */
+bool
+generic_scan_extents(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	int			fd,
+	struct stat		*sb,
+	bool			attr_fork)
+{
+	/* FIEMAP only works for files. */
+	if (!S_ISREG(sb->st_mode))
+		return true;
+
+	/* Don't invoke FIEMAP if we don't support it. */
+	if (attr_fork && !scrub_has_fiemap_attr(ctx))
+		return true;
+	if (!attr_fork && !(scrub_has_fiemap(ctx) || scrub_has_fibmap(ctx)))
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
+	struct stat		*sb)
+{
+	if (sb->st_nlink == 0)
+		str_error(ctx, descr,
+_("nlinks should not be 0."));
+
+	return true;
+}
+
+/* Does this file have extended attributes? */
+bool
+file_has_xattrs(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	int			fd)
+{
+	ssize_t			buf_sz;
+
+	buf_sz = flistxattr(fd, NULL, 0);
+	if (buf_sz == 0)
+		return false;
+	else if (buf_sz < 0) {
+		if (errno == EOPNOTSUPP || errno == ENODATA)
+			return false;
+		str_errno(ctx, descr);
+		return false;
+	}
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
+	if (buf_sz == 0)
+		return true;
+	else if (buf_sz < 0) {
+		if (errno == EOPNOTSUPP || errno == ENODATA)
+			return true;
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
+			if (errno != EOPNOTSUPP && errno != ENODATA)
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
+
+		if (xfs_scrub_excessive_errors(ctx)) {
+			moveon = false;
+			break;
+		}
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
+	struct stat		*sb)
+{
+	if (!scrub_has_unstable_inums(ctx) && dirent->d_ino != sb->st_ino) {
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
+	struct stat		*sb,
+	void			*arg)
+{
+	struct stat		fd_sb;
+	static char		linkbuf[PATH_MAX + 1];
+	ssize_t			len;
+	bool			moveon;
+	int			fd;
+	int			error;
+
+	/* No dirent for the rootdir; skip it. */
+	if (!dirent)
+		return true;
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
+		else if (len > sb->st_size)
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
+	if (fstat(fd, &fd_sb) < 0) {
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
+	if (file_has_xattrs(ctx, path, fd)) {
+		moveon = ctx->ops->scan_extents(ctx, path, fd, &fd_sb, true);
+		if (!moveon)
+			goto close;
+	}
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
+	struct stat		sb;
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
+		error = fstatat(fd, dirent->d_name, &sb,
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
+
+		if (xfs_scrub_excessive_errors(ctx)) {
+			moveon = false;
+			break;
+		}
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
+struct read_verify_files {
+	struct scrub_ctx	*ctx;
+	struct bitmap		good;		/* bytes */
+	struct bitmap		bad;		/* bytes */
+	struct read_verify_pool	rvp;
+	struct read_verify	rv;
+	bool			use_fiemap;
+};
+
+/* Handle an io error while read verifying an extent. */
+void
+read_verify_fiemap_ioerr(
+	struct read_verify_pool		*rvp,
+	struct disk			*disk,
+	uint64_t			start,
+	uint64_t			length,
+	int				error,
+	void				*arg)
+{
+	struct read_verify_files	*rvf = arg;
+
+	bitmap_add(&rvf->bad, start, length);
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
+	struct read_verify_files	*rvf = arg;
+
+	/* Skip non-real/non-aligned extents. */
+	if (extent->fe_flags & (FIEMAP_EXTENT_UNKNOWN |
+				FIEMAP_EXTENT_DELALLOC |
+				FIEMAP_EXTENT_ENCODED |
+				FIEMAP_EXTENT_NOT_ALIGNED |
+				FIEMAP_EXTENT_UNWRITTEN))
+		return true;
+
+	return bitmap_add(&rvf->good, extent->fe_physical,
+			extent->fe_length);
+}
+
+/* Scan the inode associated with a directory entry. */
+static bool
+read_verify_dirent(
+	struct scrub_ctx		*ctx,
+	const char			*path,
+	int				dir_fd,
+	struct dirent			*dirent,
+	struct stat			*sb,
+	void				*arg)
+{
+	struct stat			fd_sb;
+	struct read_verify_files	*rvf = arg;
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
+	if (fstat(fd, &fd_sb) < 0) {
+		str_errno(ctx, path);
+		goto close;
+	}
+	if (fd_sb.st_ino != sb->st_ino || fd_sb.st_dev != sb->st_dev)
+		str_warn(ctx, path,
+_("inode changed out from under us!"));
+
+	/*
+	 * Either record the file extent map data for one big push later,
+	 * or read the file data the regular way.
+	 */
+	if (rvf->use_fiemap)
+		moveon = fiemap(ctx, path, fd, false, false,
+				read_verify_fiemap_extent, rvf);
+	else
+		moveon = ctx->ops->read_file(ctx, path, fd, &fd_sb);
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
+	struct read_verify_files	*rvf = arg;
+
+	read_verify_schedule(&rvf->rvp, &rvf->rv, &rvf->ctx->datadev,
+			start, length, rvf);
+	return true;
+}
+
+/* Can we FIEMAP every block in a file? */
+static bool
+can_fiemap_all_file_blocks(
+	struct scrub_ctx		*ctx)
+{
+	return disk_is_open(&ctx->datadev) &&
+		scrub_has_fiemap(ctx) && scrub_has_fiemap_attr(ctx);
+}
+
+/* Scan all the data blocks, using FIEMAP to figure out what to verify. */
+bool
+generic_scan_blocks(
+	struct scrub_ctx		*ctx)
+{
+	struct read_verify_files	rvf = {0};
+	bool				moveon;
+
+	if (!scrub_data)
+		return true;
+
+	rvf.ctx = ctx;
+
+	/* If FIEMAP is unavailable, just use regular file pread. */
+	if (!can_fiemap_all_file_blocks(ctx))
+		return scan_fs_tree(ctx, NULL, read_verify_dirent, &rvf);
+
+	rvf.use_fiemap = true;
+	moveon = bitmap_init(&rvf.good);
+	if (!moveon) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	moveon = bitmap_init(&rvf.bad);
+	if (!moveon) {
+		str_errno(ctx, ctx->mntpoint);
+		goto out_good;
+	}
+
+	/* Collect all the extent maps. */
+	moveon = scan_fs_tree(ctx, NULL, read_verify_dirent, &rvf);
+	if (!moveon)
+		goto out_bad;
+
+	/* Run all the IO in batches. */
+	moveon = read_verify_pool_init(&rvf.rvp, ctx, ctx->readbuf, IO_MAX_SIZE,
+			ctx->mnt_sf.f_frsize, read_verify_fiemap_ioerr,
+			disk_heads(&ctx->datadev));
+	if (!moveon)
+		goto out_bad;
+	moveon = bitmap_iterate(&rvf.good, schedule_read_verify, &rvf);
+	if (!moveon)
+		goto out_pool;
+	read_verify_force(&rvf.rvp, &rvf.rv);
+	read_verify_pool_destroy(&rvf.rvp);
+
+	/* Scan the whole dir tree to see what matches the bad extents. */
+	if (!bitmap_empty(&rvf.bad))
+		moveon = report_verify_errors(ctx, &rvf.bad);
+
+	bitmap_free(&rvf.bad);
+	bitmap_free(&rvf.good);
+	return moveon;
+
+out_pool:
+	read_verify_pool_destroy(&rvf.rvp);
+out_bad:
+	bitmap_free(&rvf.bad);
+out_good:
+	bitmap_free(&rvf.good);
+
+	return moveon;
+}
+
+/* Phase 6 */
+struct summary_counts {
+	pthread_mutex_t		lock;
+	struct bitmap	dext;
+	struct bitmap	inob;	/* inode bitmap */
+	unsigned long long	inodes;	/* number of inodes */
+	unsigned long long	bytes;	/* bytes used */
+};
+
+struct inode_fork_summary {
+	struct bitmap	*tree;
+	unsigned long long	bytes;
+};
+
+/* Record data block extents in a bitmap. */
+bool
+generic_record_inode_summary_fiemap(
+	struct scrub_ctx		*ctx,
+	const char			*descr,
+	struct fiemap_extent		*extent,
+	void				*arg)
+{
+	struct inode_fork_summary	*ifs = arg;
+
+	/* Skip non-real/non-aligned extents. */
+	if (extent->fe_flags & (FIEMAP_EXTENT_UNKNOWN |
+				FIEMAP_EXTENT_DELALLOC |
+				FIEMAP_EXTENT_ENCODED |
+				FIEMAP_EXTENT_NOT_ALIGNED))
+		return true;
+
+	bitmap_add(ifs->tree, extent->fe_physical, extent->fe_length);
+	ifs->bytes += extent->fe_length;
+
+	return true;
+}
+
+/* Record the presence of an inode and its block usage. */
+static bool
+generic_record_inode_summary(
+	struct scrub_ctx		*ctx,
+	const char			*descr,
+	int				dir_fd,
+	struct dirent			*dirent,
+	struct stat			*sb,
+	void				*arg)
+{
+	struct summary_counts		*summary = arg;
+	struct stat			fd_sb;
+	struct inode_fork_summary	ifs;
+	unsigned long long		bs_bytes;
+	int				fd;
+	bool				has;
+	bool				moveon = true;
+
+	if (dirent && (strcmp(dirent->d_name, ".") == 0 ||
+		       strcmp(dirent->d_name, "..") == 0))
+		return true;
+
+	/* Detect hardlinked files. */
+	moveon = bitmap_test_and_set(&summary->inob, sb->st_ino, &has);
+	if (!moveon)
+		return moveon;
+	if (has)
+		return true;
+
+	bs_bytes = sb->st_blocks << BBSHIFT;
+
+	/* Record the inode.  If it's not a file, record the data usage too. */
+	pthread_mutex_lock(&summary->lock);
+	summary->inodes++;
+
+	/*
+	 * We can use fiemap and dext to figure out the correct block usage
+	 * for files that might share blocks.  If any of those conditions
+	 * are not met (non-file, fs doesn't support reflink, fiemap doesn't
+	 * work) then we just assume that the inode is the sole owner of its
+	 * blocks and use that to calculate the block usage.
+	 */
+	if (!can_fiemap_all_file_blocks(ctx) || !scrub_has_shared_blocks(ctx) ||
+	    !S_ISREG(sb->st_mode)) {
+		summary->bytes += bs_bytes;
+		pthread_mutex_unlock(&summary->lock);
+		return true;
+	}
+	pthread_mutex_unlock(&summary->lock);
+
+	/* Open the file */
+	fd = dirent_open(dir_fd, dirent);
+	if (fd < 0) {
+		if (errno != ENOENT)
+			str_errno(ctx, descr);
+		return true;
+	}
+
+	/* Did the fstatat and the open race? */
+	if (fstat(fd, &fd_sb) < 0) {
+		str_errno(ctx, descr);
+		goto close;
+	}
+
+	if (fd_sb.st_ino != sb->st_ino || fd_sb.st_dev != sb->st_dev)
+		str_warn(ctx, descr,
+_("inode changed out from under us!"));
+
+	ifs.tree = &summary->dext;
+	ifs.bytes = 0;
+	moveon = fiemap(ctx, descr, fd, false, false,
+			generic_record_inode_summary_fiemap, &ifs);
+	if (!moveon)
+		goto out_nofiemap;
+	if (file_has_xattrs(ctx, descr, fd)) {
+		moveon = fiemap(ctx, descr, fd, true, false,
+				generic_record_inode_summary_fiemap, &ifs);
+		if (!moveon)
+			goto out_nofiemap;
+	}
+
+	/*
+	 * bs_bytes tracks the number of bytes assigned to this file
+	 * for data, xattrs, and block mapping metadata.  ifs.bytes tracks
+	 * the data and xattr storage space used, so the diff between the
+	 * two is the space used for block mapping metadata.  Add that to
+	 * the data usage.
+	 */
+out_nofiemap:
+	pthread_mutex_lock(&summary->lock);
+	summary->bytes += bs_bytes - ifs.bytes;
+	pthread_mutex_unlock(&summary->lock);
+
+close:
+	close(fd);
+	return moveon;
+}
+
+/* Sum the bytes in each extent. */
+static bool
+generic_summary_count_helper(
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
+/* Traverse the directory tree, counting inodes & blocks. */
+bool
+generic_check_summary(
+	struct scrub_ctx	*ctx)
+{
+	struct summary_counts	summary = {0};
+	struct stat		sb;
+	struct statvfs		sfs;
+	unsigned long long	fd;
+	unsigned long long	fi;
+	unsigned long long	sd;
+	unsigned long long	si;
+	unsigned long long	absdiff;
+	bool			complain = false;
+	bool			moveon;
+	int			error;
+
+	pthread_mutex_init(&summary.lock, NULL);
+
+	/* Flush everything out to disk before we start counting. */
+	error = syncfs(ctx->mnt_fd);
+	if (error) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	/* Get the rootdir's summary stats. */
+	error = fstat(ctx->mnt_fd, &sb);
+	if (error) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	moveon = bitmap_init(&summary.dext);
+	if (!moveon)
+		return moveon;
+
+	moveon = bitmap_init(&summary.inob);
+	if (!moveon)
+		return moveon;
+
+	/* Scan the rest of the filesystem. */
+	moveon = scan_fs_tree(ctx, NULL, generic_record_inode_summary,
+			&summary);
+	if (!moveon)
+		return moveon;
+
+	/* Summarize extent tree results. */
+	moveon = bitmap_iterate(&summary.dext,
+			generic_summary_count_helper, &summary.bytes);
+	if (!moveon)
+		return moveon;
+
+	bitmap_free(&summary.inob);
+	bitmap_free(&summary.dext);
+
+	/* Compare to statfs results. */
+	error = fstatvfs(ctx->mnt_fd, &sfs);
+	if (error) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	/* Report on what we found. */
+	fd = (sfs.f_blocks - sfs.f_bfree) * sfs.f_frsize;
+	fi = sfs.f_files - sfs.f_ffree;
+	sd = summary.bytes;
+	si = summary.inodes;
+
+	/*
+	 * Complain if the counts are off by more than 10%, unless
+	 * the inaccuracy is less than 32MB worth of blocks or 100 inodes.
+	 * Ignore zero counters.
+	 */
+	absdiff = 1ULL << 25;
+	if (fd)
+		complain = !within_range(ctx, sd, fd, absdiff, 1, 10,
+				_("data blocks"));
+	if (fi)
+		complain |= !within_range(ctx, si, fi, 100, 1, 10, _("inodes"));
+
+	if (complain || verbose) {
+		double		b, i;
+		char		*bu, *iu;
+
+		b = auto_space_units(fd, &bu);
+		i = auto_units(fi, &iu);
+		printf(_("%.1f%s data used;  %.1f%s inodes used.\n"),
+				b, bu, i, iu);
+		b = auto_space_units(sd, &bu);
+		i = auto_units(si, &iu);
+		printf(_("%.1f%s data found; %.1f%s inodes found.\n"),
+				b, bu, i, iu);
+	}
+
+	return true;
+}
+
+/* Phase 7: Preening filesystem. */
+bool
+generic_preen_fs(
+	struct scrub_ctx		*ctx)
+{
+	fstrim(ctx);
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
+	.read_file		= read_verify_file,
+	.scan_blocks		= generic_scan_blocks,
+	.scan_fs_tree		= generic_scan_fs_tree,
+	.preen_fs		= generic_preen_fs,
+};
diff --git a/scrub/iocmd.c b/scrub/iocmd.c
new file mode 100644
index 0000000..d8a769d
--- /dev/null
+++ b/scrub/iocmd.c
@@ -0,0 +1,412 @@
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
+	struct stat		root_sb;
+	bool			moveon;
+	bool			(*dir_fn)(struct scrub_ctx *, const char *,
+					  int, void *);
+	bool			(*dirent_fn)(struct scrub_ctx *, const char *,
+					     int, struct dirent *,
+					     struct stat *, void *);
+	void			*arg;
+};
+
+/* Per-work-item scan context. */
+struct scan_fs_tree_dir {
+	char			*path;
+	struct scan_fs_tree	*sft;
+	bool			rootdir;
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
+	struct stat		sb;
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
+	/* Caller-specific directory entry function on the rootdir. */
+	if (sftd->rootdir) {
+		/* Get the stat info for this directory entry. */
+		error = fstat(dir_fd, &sb);
+		if (error) {
+			str_errno(ctx, sftd->path);
+			goto out;
+		}
+		if (!sft->dirent_fn(ctx, sftd->path, dir_fd, NULL, &sb,
+				sft->arg)) {
+			sft->moveon = false;
+			goto out;
+		}
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
+		error = fstatat(dir_fd, dirent->d_name, &sb,
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
+		if (xfs_scrub_excessive_errors(ctx)) {
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
+			new_sftd->rootdir = false;
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
+						struct stat *, void *),
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
+	sftd->rootdir = true;
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
+	struct stat		sb;
+	struct fiemap_extent	extent = {0};
+	unsigned int		blk;
+	unsigned int		b;
+	unsigned int		blksz;
+	unsigned long long	physical;
+	off_t			numblocks;
+	bool			moveon = true;
+	int			error;
+
+	assert(scrub_has_fibmap(ctx));
+
+	error = fstat(fd, &sb);
+	if (error) {
+		str_errno(ctx, descr);
+		return false;
+	}
+
+	blksz = ctx->datadev.d_blksize;
+	numblocks = (sb.st_size + blksz - 1) / blksz;
+	if (numblocks > UINT_MAX)
+		numblocks = UINT_MAX;
+	extent.fe_flags = FIEMAP_EXTENT_MERGED;
+	for (blk = 0; blk < numblocks; blk++) {
+		b = blk;
+		error = ioctl(fd, FIBMAP, &b);
+		if (error) {
+			if (errno == EOPNOTSUPP || errno == EINVAL) {
+				str_warn(ctx, descr,
+_("data block FIEMAP/FIBMAP not supported, will not check extent map."));
+				ctx->quirks &= ~SCRUB_QUIRK_FIBMAP_WORKS;
+				return true;
+			}
+			str_errno(ctx, descr);
+			continue;
+		}
+
+		physical = b * blksz;
+		if (extent.fe_length > 0 &&
+		    physical == extent.fe_physical + extent.fe_length) {
+			/* Physically contiguous, just merge. */
+			extent.fe_length += blksz;
+		} else {
+			/* Emit extent if there is one. */
+			if (extent.fe_length > 0) {
+				moveon = fn(ctx, descr, &extent, arg);
+				if (!moveon)
+					break;
+			}
+			if (physical == 0) {
+				/* b == 0 means a hole... */
+				extent.fe_length = 0;
+			} else {
+				/* Start a new extent. */
+				extent.fe_physical = physical;
+				extent.fe_logical = blk * blksz;
+				extent.fe_length = blksz;
+			}
+		}
+
+		if (xfs_scrub_excessive_errors(ctx)) {
+			moveon = false;
+			break;
+		}
+	}
+
+	/* If there's an extent left over, emit it. */
+	if (moveon && extent.fe_length > 0) {
+		extent.fe_flags |= FIEMAP_EXTENT_LAST;
+		moveon = fn(ctx, descr, &extent, arg);
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
+	bool			moveon = true;
+	bool			last = false;
+	unsigned int		i;
+	int			error;
+
+	assert(attr_fork || (scrub_has_fiemap(ctx) || scrub_has_fibmap(ctx)));
+	assert(!attr_fork || scrub_has_fiemap_attr(ctx));
+
+	if (!attr_fork && !scrub_has_fiemap(ctx))
+		return use_fibmap ? fibmap(ctx, descr, fd, fn, arg) : false;
+	else if (attr_fork && !scrub_has_fiemap_attr(ctx))
+		return true;
+
+	sz = sizeof(struct fiemap) + sizeof(struct fiemap_extent) * NR_EXTENTS;
+	fiemap = calloc(1, sz);
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
+				ctx->quirks &= ~SCRUB_QUIRK_FIEMAP_ATTR_WORKS;
+			} else {
+				ctx->quirks &= ~SCRUB_QUIRK_FIEMAP_WORKS;
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
+			if (xfs_scrub_excessive_errors(ctx)) {
+				moveon = false;
+				goto out;
+			}
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
+
+#ifndef FITRIM
+struct fstrim_range {
+	__u64 start;
+	__u64 len;
+	__u64 minlen;
+};
+#define FITRIM		_IOWR('X', 121, struct fstrim_range)	/* Trim */
+#endif
+
+/* Call FITRIM to trim all the unused space in a filesystem. */
+void
+fstrim(
+	struct scrub_ctx	*ctx)
+{
+	struct fstrim_range	range = {0};
+	int			error;
+
+	range.len = ULLONG_MAX;
+	error = ioctl(ctx->mnt_fd, FITRIM, &range);
+	if (error && errno != EOPNOTSUPP && errno != ENOTTY)
+		perror(_("fstrim"));
+}
diff --git a/scrub/iocmd.h b/scrub/iocmd.h
new file mode 100644
index 0000000..c6cf2c4
--- /dev/null
+++ b/scrub/iocmd.h
@@ -0,0 +1,50 @@
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
+						struct stat *, void *),
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
+void
+fstrim(
+	struct scrub_ctx	*ctx);
+
+#endif /* IOCMD_H_ */
diff --git a/scrub/non_xfs.c b/scrub/non_xfs.c
new file mode 100644
index 0000000..47fef92
--- /dev/null
+++ b/scrub/non_xfs.c
@@ -0,0 +1,185 @@
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
+#include <dirent.h>
+#include <sys/statvfs.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include "disk.h"
+#include "scrub.h"
+
+/* Stub scrubbers for non-XFS filesystems. */
+
+/* Read the btrfs geometry. */
+static bool
+btrfs_scan_fs(
+	struct scrub_ctx		*ctx)
+{
+	/*
+	 * btrfs is a volume manager, so we can't get meaningful block numbers
+	 * out of FIEMAP/FIBMAP.  It also checksums data, so raw device access
+	 * for file verify is impossible.  btrfs also supports reflink.
+	 */
+	ctx->quirks |= SCRUB_QUIRK_SHARED_BLOCKS;
+	disk_close(&ctx->datadev);
+	return generic_scan_fs(ctx);
+}
+
+/* Scrub all disk blocks using the btrfs scrub command. */
+static bool
+btrfs_scan_blocks(
+	struct scrub_ctx		*ctx)
+{
+	pid_t				pid;
+	pid_t				rpid;
+	char				*args[] = {"btrfs", "scrub", "start",
+						   "-B", "-f", "-q",
+						   ctx->mntpoint, NULL, NULL};
+	int				status;
+	int				err;
+
+	if (ctx->mode == SCRUB_MODE_DRY_RUN) {
+		args[6] = "-n";
+		args[7] = ctx->mntpoint;
+	}
+
+	pid = fork();
+	if (pid < 0)
+		str_errno(ctx, ctx->mntpoint);
+	else if (pid == 0) {
+		status = execvp(args[0], args);
+		exit(255);
+	} else {
+		rpid = waitpid(pid, &status, 0);
+		while (rpid >= 0 && rpid != pid && !WIFEXITED(status) &&
+				!WIFSIGNALED(status)) {
+			rpid = waitpid(pid, &status, 0);
+		}
+		if (rpid < 0)
+			str_errno(ctx, ctx->mntpoint);
+		else if (WIFSIGNALED(status))
+			str_error(ctx, ctx->mntpoint,
+_("btrfs scrub died, signal %d"),
+					WTERMSIG(status));
+		else if (WIFEXITED(status)) {
+			err = WEXITSTATUS(status);
+			if (err == 0)
+				return true;
+			else if (err == 255)
+				str_error(ctx, ctx->mntpoint,
+_("btrfs scrub failed to run."));
+			else
+				str_error(ctx, ctx->mntpoint,
+_("btrfs scrub signalled corruption, error %d"),
+						err);
+		}
+	}
+
+	return true;
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
+	.read_file		= read_verify_file,
+	.scan_blocks		= btrfs_scan_blocks,
+	.scan_fs_tree		= generic_scan_fs_tree,
+	.preen_fs		= generic_preen_fs,
+};
+
+/*
+ * Generic FS scanner for filesystems that support shared blocks.
+ */
+static bool
+scan_fs_shared_blocks(
+	struct scrub_ctx		*ctx)
+{
+	ctx->quirks |= SCRUB_QUIRK_SHARED_BLOCKS;
+	return generic_scan_fs(ctx);
+}
+
+/* shared block filesystem profiles */
+struct scrub_ops shared_block_fs_scrub_ops = {
+	.name			= "shared block generic",
+	.aliases		= "ocfs2\0",
+	.cleanup		= generic_cleanup,
+	.scan_fs		= scan_fs_shared_blocks,
+	.scan_inodes		= generic_scan_inodes,
+	.check_dir		= generic_check_dir,
+	.check_inode		= generic_check_inode,
+	.scan_extents		= generic_scan_extents,
+	.scan_xattrs		= generic_scan_xattrs,
+	.scan_special_xattrs	= generic_scan_special_xattrs,
+	.scan_metadata		= generic_scan_metadata,
+	.check_summary		= generic_check_summary,
+	.read_file		= read_verify_file,
+	.scan_blocks		= generic_scan_blocks,
+	.scan_fs_tree		= generic_scan_fs_tree,
+	.preen_fs		= generic_preen_fs,
+};
+
+/*
+ * Generic FS scan for filesystems that don't present stable inode numbers
+ * between the directory entry and the stat buffer.
+ */
+static bool
+scan_fs_unstable_inum(
+	struct scrub_ctx		*ctx)
+{
+	/*
+	 * HFS+ implements hard links by creating a special hidden file
+	 * that redirects to the real file, so the inode numbers reported
+	 * in the dirent and the fstat buffers don't necessarily match.
+	 *
+	 * iso9660/vfat don't have stable dirent -> inode numbers.
+	 */
+	ctx->quirks |= SCRUB_QUIRK_UNSTABLE_INUM;
+	return generic_scan_fs(ctx);
+}
+
+/* unstable inum filesystem profile */
+struct scrub_ops unstable_inum_fs_scrub_ops = {
+	.name			= "unstable inum generic",
+	.aliases		= "hfsplus\0iso9660\0vfat\0",
+	.cleanup		= generic_cleanup,
+	.scan_fs		= scan_fs_unstable_inum,
+	.scan_inodes		= generic_scan_inodes,
+	.check_dir		= generic_check_dir,
+	.check_inode		= generic_check_inode,
+	.scan_extents		= generic_scan_extents,
+	.scan_xattrs		= generic_scan_xattrs,
+	.scan_special_xattrs	= generic_scan_special_xattrs,
+	.scan_metadata		= generic_scan_metadata,
+	.check_summary		= generic_check_summary,
+	.read_file		= read_verify_file,
+	.scan_blocks		= generic_scan_blocks,
+	.scan_fs_tree		= generic_scan_fs_tree,
+	.preen_fs		= generic_preen_fs,
+};
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
new file mode 100644
index 0000000..8433012
--- /dev/null
+++ b/scrub/read_verify.c
@@ -0,0 +1,314 @@
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
+/* How many bytes have we verified? */
+static pthread_mutex_t		verified_lock = PTHREAD_MUTEX_INITIALIZER;
+static unsigned long long	verified_bytes;
+
+/* Tolerate 64k holes in adjacent read verify requests. */
+#define IO_BATCH_LOCALITY	(65536)
+
+/* Create a thread pool to run read verifiers. */
+bool
+read_verify_pool_init(
+	struct read_verify_pool		*rvp,
+	struct scrub_ctx		*ctx,
+	void				*readbuf,
+	size_t				readbufsz,
+	size_t				min_io_sz,
+	read_verify_ioend_fn_t		ioend_fn,
+	unsigned int			nproc)
+{
+	rvp->rvp_readbuf = readbuf;
+	rvp->rvp_readbufsz = readbufsz;
+	rvp->rvp_ctx = ctx;
+	rvp->rvp_min_io_size = min_io_sz;
+	rvp->ioend_fn = ioend_fn;
+	rvp->rvp_nproc = nproc;
+	create_work_queue(&rvp->rvp_wq, (struct xfs_mount *)rvp, nproc);
+	return true;
+}
+
+/* How many bytes has this process verified? */
+unsigned long long
+read_verify_bytes(void)
+{
+	return verified_bytes;
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
+	unsigned long long		verified = 0;
+	ssize_t				sz;
+	ssize_t				len;
+
+	rvp = (struct read_verify_pool *)wq->mp;
+	while (rv->io_length > 0) {
+		len = min(rv->io_length, rvp->rvp_readbufsz);
+		dbg_printf("diskverify %d %"PRIu64" %zu\n", rv->io_disk->d_fd,
+				rv->io_start, len);
+		sz = disk_read_verify(rv->io_disk, rvp->rvp_readbuf,
+				rv->io_start, len);
+		if (sz < 0) {
+			dbg_printf("IOERR %d %"PRIu64" %zu\n",
+					rv->io_disk->d_fd,
+					rv->io_start, len);
+			rvp->ioend_fn(rvp, rv->io_disk, rv->io_start,
+					rvp->rvp_min_io_size,
+					errno, rv->io_end_arg);
+			len = rvp->rvp_min_io_size;
+		}
+
+		verified += len;
+		rv->io_start += len;
+		rv->io_length -= len;
+	}
+
+	free(rv);
+	pthread_mutex_lock(&verified_lock);
+	verified_bytes += verified;
+	pthread_mutex_unlock(&verified_lock);
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
+	dbg_printf("verify fd %d start %"PRIu64" len %"PRIu64"\n",
+			rv->io_disk->d_fd, rv->io_start, rv->io_length);
+
+	tmp = malloc(sizeof(struct read_verify));
+	if (!tmp) {
+		rvp->ioend_fn(rvp, rv->io_disk, rv->io_start, rv->io_length,
+				errno, rv->io_end_arg);
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
+	uint64_t			start,
+	uint64_t			length,
+	void				*end_arg)
+{
+	uint64_t			ve_end;
+	uint64_t			io_end;
+
+	assert(rvp->rvp_readbuf);
+	ve_end = start + length;
+	io_end = rv->io_start + rv->io_length;
+
+	/*
+	 * If we have a stashed IO, we haven't changed fds, the error
+	 * reporting is the same, and the two extents are close,
+	 * we can combine them.
+	 */
+	if (rv->io_length > 0 && disk == rv->io_disk &&
+	    end_arg == rv->io_end_arg &&
+	    ((start >= rv->io_start && start <= io_end + IO_BATCH_LOCALITY) ||
+	     (rv->io_start >= start &&
+	      rv->io_start <= ve_end + IO_BATCH_LOCALITY))) {
+		rv->io_start = min(rv->io_start, start);
+		rv->io_length = max(ve_end, io_end) - rv->io_start;
+	} else  {
+		/* Otherwise, issue the stashed IO (if there is one) */
+		if (rv->io_length > 0)
+			read_verify_queue(rvp, rv);
+
+		/* Stash the new IO. */
+		rv->io_disk = disk;
+		rv->io_start = start;
+		rv->io_length = length;
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
+	if (rv->io_length == 0)
+		return;
+
+	read_verify_queue(rvp, rv);
+	rv->io_length = 0;
+}
+
+/* Read all the data in a file. */
+bool
+read_verify_file(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	int			fd,
+	struct stat		*sb)
+{
+	off_t			data_end = 0;
+	off_t			data_start;
+	off_t			start;
+	ssize_t			sz;
+	size_t			count;
+	unsigned long long	verified = 0;
+	bool			reports_holes = true;
+	bool			direct_io = false;
+	bool			moveon = true;
+	int			flags;
+	int			error;
+
+	/*
+	 * Try to force the kernel to read file data from disk.  First
+	 * we try to set O_DIRECT.  If that fails, try to purge the page
+	 * cache.
+	 */
+	flags = fcntl(fd, F_GETFL);
+	error = fcntl(fd, F_SETFL, flags | O_DIRECT);
+	if (error)
+		posix_fadvise(fd, 0, sb->st_size, POSIX_FADV_DONTNEED);
+	else
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
+		sz = pread(fd, ctx->readbuf, count, start);
+		if (sz < 0) {
+			str_errno(ctx, descr);
+			break;
+		} else if (sz == 0) {
+			str_error(ctx, descr,
+_("Read zero bytes, expected %zu."),
+					count);
+			break;
+		} else if (sz != count && start + sz != data_end) {
+			str_warn(ctx, descr,
+_("Short read of %zu bytes, expected %zu."),
+					sz, count);
+		}
+		verified += sz;
+		data_start = start + sz;
+
+		if (xfs_scrub_excessive_errors(ctx)) {
+			moveon = false;
+			break;
+		}
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
+	pthread_mutex_lock(&verified_lock);
+	verified_bytes += verified;
+	pthread_mutex_unlock(&verified_lock);
+
+	return moveon;
+}
diff --git a/scrub/read_verify.h b/scrub/read_verify.h
new file mode 100644
index 0000000..01f712b
--- /dev/null
+++ b/scrub/read_verify.h
@@ -0,0 +1,59 @@
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
+		struct disk *disk, uint64_t start, uint64_t length,
+		int error, void *arg);
+typedef void (*read_verify_ioend_arg_free_fn_t)(void *arg);
+
+struct read_verify_pool {
+	struct work_queue	rvp_wq;
+	struct scrub_ctx	*rvp_ctx;
+	void			*rvp_readbuf;
+	read_verify_ioend_fn_t	ioend_fn;
+	read_verify_ioend_arg_free_fn_t	ioend_arg_free_fn;
+	size_t			rvp_readbufsz;		/* bytes */
+	size_t			rvp_min_io_size;	/* bytes */
+	int			rvp_nproc;
+};
+
+bool read_verify_pool_init(struct read_verify_pool *rvp, struct scrub_ctx *ctx,
+		void *readbuf, size_t readbufsz, size_t min_io_sz,
+		read_verify_ioend_fn_t ioend_fn, unsigned int nproc);
+void read_verify_pool_destroy(struct read_verify_pool *rvp);
+
+struct read_verify {
+	void			*io_end_arg;
+	struct disk		*io_disk;
+	uint64_t		io_start;	/* bytes */
+	uint64_t		io_length;	/* bytes */
+};
+
+void read_verify_schedule(struct read_verify_pool *rvp, struct read_verify *rv,
+		struct disk *disk, uint64_t start, uint64_t length,
+		void *end_arg);
+void read_verify_force(struct read_verify_pool *rvp, struct read_verify *rv);
+unsigned long long read_verify_bytes(void);
+
+#endif /* READ_VERIFY_H_ */
diff --git a/scrub/scrub.c b/scrub/scrub.c
new file mode 100644
index 0000000..d9b8687
--- /dev/null
+++ b/scrub/scrub.c
@@ -0,0 +1,1009 @@
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
+#include "../../repair/threads.h"
+#include "read_verify.h"
+
+#define _PATH_PROC_MOUNTS	"/proc/mounts"
+
+bool				verbose;
+int				debug;
+bool				scrub_data;
+bool				dumpcore;
+bool				display_rusage;
+long				page_size;
+enum errors_action		error_action = ERRORS_CONTINUE;
+static unsigned long		max_errors;
+
+static void __attribute__((noreturn))
+usage(void)
+{
+	fprintf(stderr, _("Usage: %s [OPTIONS] mountpoint\n"), progname);
+	fprintf(stderr, _("-a:\tStop after this many errors are found.\n"));
+	fprintf(stderr, _("-d:\tRun program in debug mode.\n"));
+	fprintf(stderr, _("-e:\tWhat to do if errors are found.\n"));
+	fprintf(stderr, _("-m:\tPath to /etc/mtab.\n"));
+	fprintf(stderr, _("-n:\tDry run.  Do not modify anything.\n"));
+	fprintf(stderr, _("-t:\tUse this filesystem backend for scrubbing.\n"));
+	fprintf(stderr, _("-T:\tDisplay timing/usage information.\n"));
+	fprintf(stderr, _("-v:\tVerbose output.\n"));
+	fprintf(stderr, _("-V:\tPrint version.\n"));
+	fprintf(stderr, _("-x:\tScrub file data too.\n"));
+	fprintf(stderr, _("-y:\tRepair all errors.\n"));
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
+	struct stat		*sb,
+	struct mntent		*t)
+{
+	struct stat		ms;
+
+	if (S_ISDIR(sb->st_mode)) {		/* mount point */
+		if (stat(t->mnt_dir, &ms) < 0)
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
+		if (stat(t->mnt_fsname, &ms) < 0)
+			return false;
+		if (sb->st_rdev != ms.st_rdev)
+			return false;
+		/*
+		 * Make sure the mountpoint given by mtab is accessible
+		 * before using it.
+		 */
+		if (stat(t->mnt_dir, &ms) < 0)
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
+/* Too many errors? Bail out. */
+bool
+xfs_scrub_excessive_errors(
+	struct scrub_ctx	*ctx)
+{
+	bool			ret;
+
+	pthread_mutex_lock(&ctx->lock);
+	ret = max_errors > 0 && ctx->errors_found >= max_errors;
+	pthread_mutex_unlock(&ctx->lock);
+
+	return ret;
+}
+
+/* Get the name of the repair tool. */
+const char *
+repair_tool(
+	struct scrub_ctx	*ctx)
+{
+	if (ctx->ops->repair_tool)
+		return ctx->ops->repair_tool;
+
+	return "fsck";
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
+	printf("%s: ", str);
+	va_start(args, format);
+	vprintf(format, args);
+	va_end(args);
+	if (debug)
+		printf(" (%s line %d)", file, line);
+	printf("\n");
+	pthread_mutex_unlock(&ctx->lock);
+}
+
+/* Increment the repair count. */
+void
+__record_repair(
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
+	ctx->repairs++;
+	pthread_mutex_unlock(&ctx->lock);
+}
+
+/* Increment the optimization (preening) count. */
+void
+__record_preen(
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
+	if (debug || verbose) {
+		printf("%s: ", str);
+		va_start(args, format);
+		vprintf(format, args);
+		va_end(args);
+		if (debug)
+			printf(" (%s line %d)", file, line);
+		printf("\n");
+	}
+	ctx->preens++;
+	pthread_mutex_unlock(&ctx->lock);
+}
+
+static struct scrub_ops *scrub_impl[] = {
+	&xfs_scrub_ops,
+	&btrfs_scrub_ops,
+	&shared_block_fs_scrub_ops,
+	&unstable_inum_fs_scrub_ops,
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
+#define SCRUB_QUIRK_FNS(name, flagname) \
+bool \
+scrub_has_##name( \
+	struct scrub_ctx		*ctx) \
+{ \
+	return ctx->quirks & SCRUB_QUIRK_##flagname; \
+}
+SCRUB_QUIRK_FNS(fiemap,		FIEMAP_WORKS)
+SCRUB_QUIRK_FNS(fiemap_attr,	FIEMAP_ATTR_WORKS)
+SCRUB_QUIRK_FNS(fibmap,		FIBMAP_WORKS)
+SCRUB_QUIRK_FNS(shared_blocks,	SHARED_BLOCKS)
+SCRUB_QUIRK_FNS(unstable_inums,	UNSTABLE_INUM)
+
+/* How many threads to kick off? */
+unsigned int
+scrub_nproc(
+	struct scrub_ctx	*ctx)
+{
+	if (debug_tweak_on("XFS_SCRUB_NO_THREADS"))
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
+static double
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
+	unsigned long long	bytes,
+	char			**units)
+{
+	if (debug > 1)
+		goto no_prefix;
+	if (bytes > (1ULL << 40)) {
+		*units = "TiB";
+		return (double)bytes / (1ULL << 40);
+	} else if (bytes > (1ULL << 30)) {
+		*units = "GiB";
+		return (double)bytes / (1ULL << 30);
+	} else if (bytes > (1ULL << 20)) {
+		*units = "MiB";
+		return (double)bytes / (1ULL << 20);
+	} else if (bytes > (1ULL << 10)) {
+		*units = "KiB";
+		return (double)bytes / (1ULL << 10);
+	} else {
+no_prefix:
+		*units = "B";
+		return bytes;
+	}
+}
+
+/* Produce human readable discrete number output. */
+double
+auto_units(
+	unsigned long long	number,
+	char			**units)
+{
+	if (debug > 1)
+		goto no_prefix;
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
+no_prefix:
+		*units = "";
+		return number;
+	}
+}
+
+/*
+ * Given a directory fd and (possibly) a dirent, open the file associated
+ * with the entry.  If the entry is null, just duplicate the dir_fd.
+ */
+int
+dirent_open(
+	int			dir_fd,
+	struct dirent		*dirent)
+{
+	if (!dirent)
+		return dup(dir_fd);
+	return openat(dir_fd, dirent->d_name,
+			O_RDONLY | O_NOATIME | O_NOFOLLOW | O_NOCTTY);
+}
+
+#ifndef RUSAGE_BOTH
+# define RUSAGE_BOTH		(-2)
+#endif
+
+/* Get resource usage for ourselves and all children. */
+int
+scrub_getrusage(
+	struct rusage		*usage)
+{
+	struct rusage		cusage;
+	int			err;
+
+	err = getrusage(RUSAGE_BOTH, usage);
+	if (!err)
+		return err;
+
+	err = getrusage(RUSAGE_SELF, usage);
+	if (err)
+		return err;
+
+	err = getrusage(RUSAGE_CHILDREN, &cusage);
+	if (err)
+		return err;
+
+	usage->ru_minflt += cusage.ru_minflt;
+	usage->ru_majflt += cusage.ru_majflt;
+	usage->ru_nswap += cusage.ru_nswap;
+	usage->ru_inblock += cusage.ru_inblock;
+	usage->ru_oublock += cusage.ru_oublock;
+	usage->ru_msgsnd += cusage.ru_msgsnd;
+	usage->ru_msgrcv += cusage.ru_msgrcv;
+	usage->ru_nsignals += cusage.ru_nsignals;
+	usage->ru_nvcsw += cusage.ru_nvcsw;
+	usage->ru_nivcsw += cusage.ru_nivcsw;
+	return 0;
+}
+
+struct phase_info {
+	struct rusage		ruse;
+	struct timeval		time;
+	unsigned long long	verified_bytes;
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
+	error = scrub_getrusage(&pi->ruse); //getrusage(RUSAGE_SELF, &pi->ruse);
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
+	pi->verified_bytes = read_verify_bytes();
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
+	double			dt;
+	unsigned long long	verified;
+	long			in, out;
+	long			io;
+	double			i, o, t;
+	double			din, dout, dtot;
+	char			*iu, *ou, *tu, *dinu, *doutu, *dtotu;
+	double			v, dv;
+	char			*vu, *dvu;
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
+	dt = timeval_subtract(&time_now, &pi->time);
+
+	error = scrub_getrusage(&ruse_now); //getrusage(RUSAGE_SELF, &ruse_now);
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
+	printf(_("time: %5.2f/%5.2f/%5.2fs\n"),
+		timeval_subtract(&time_now, &pi->time),
+		timeval_subtract(&ruse_now.ru_utime, &pi->ruse.ru_utime),
+		timeval_subtract(&ruse_now.ru_stime, &pi->ruse.ru_stime));
+
+	/* I/O usage */
+	in =  (ruse_now.ru_inblock - pi->ruse.ru_inblock) << BBSHIFT;
+	out = (ruse_now.ru_oublock - pi->ruse.ru_oublock) << BBSHIFT;
+	io = in + out;
+	if (io) {
+		i = auto_space_units(in, &iu);
+		o = auto_space_units(out, &ou);
+		t = auto_space_units(io, &tu);
+		din = auto_space_units(in / dt, &dinu);
+		dout = auto_space_units(out / dt, &doutu);
+		dtot = auto_space_units(io / dt, &dtotu);
+		printf(
+_("%sI/O: %.1f%s in, %.1f%s out, %.1f%s tot\n"),
+			pi->tag, i, iu, o, ou, t, tu);
+		printf(
+_("%sI/O rate: %.1f%s/s in, %.1f%s/s out, %.1f%s/s tot\n"),
+			pi->tag, din, dinu, dout, doutu, dtot, dtotu);
+	}
+
+	/* How many bytes were read-verified? */
+	verified = read_verify_bytes() - pi->verified_bytes;
+	if (verified) {
+		v = auto_space_units(verified, &vu);
+		dv = auto_space_units(verified / dt, &dvu);
+		printf(_("%sVerify: %.1f%s, rate: %.1f%s/s\n"), pi->tag,
+			v, vu, dv, dvu);
+	}
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
+	/*
+	 * Open the directory with O_NOATIME.  For mountpoints owned
+	 * by root, this should be sufficient to ensure that we have
+	 * CAP_SYS_ADMIN, which we probably need to do anything fancy
+	 * with the (XFS driver) kernel.
+	 */
+	ctx->mnt_fd = open(ctx->mntpoint, O_RDONLY | O_NOATIME | O_DIRECTORY);
+	if (ctx->mnt_fd < 0) {
+		if (errno == EPERM)
+			str_info(ctx, ctx->mntpoint,
+_("Must be root to run scrub."));
+		else
+			str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+	error = disk_open(ctx->blkdev, &ctx->datadev);
+	if (error && errno != ENOENT)
+		str_errno(ctx, ctx->blkdev);
+
+	error = fstat(ctx->mnt_fd, &ctx->mnt_sb);
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
+/* Run the preening phase if there are no errors. */
+static bool
+preen(
+	struct scrub_ctx	*ctx)
+{
+	if (ctx->errors_found) {
+		str_info(ctx, ctx->mntpoint,
+_("Errors found, please re-run with -y."));
+		return true;
+	}
+
+	return ctx->ops->preen_fs(ctx);
+}
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
+#define REPAIR_PHASE	(ARRAY_SIZE(phases) - 2)
+		{NULL, NULL}, /* fill this in if we're preening or fixing. */
+		{NULL, NULL},
+	};
+	struct phase_info	pi;
+	char			buf[DESCR_BUFSZ];
+	struct scrub_phase	*phase;
+	bool			moveon;
+	int			c;
+
+	/* Phase 7 can be turned into preening or fixing the filesystem. */
+	phase = &phases[REPAIR_PHASE];
+	if (ctx->mode == SCRUB_MODE_PREEN) {
+		phase->descr = _("Preen filesystem.");
+		phase->fn = preen;
+	} else if (ctx->mode == SCRUB_MODE_REPAIR) {
+		phase->descr = _("Repair filesystem.");
+		phase->fn = ctx->ops->repair_fs;
+	}
+
+	/* Run all phases of the scrub tool. */
+	for (c = 1, phase = phases; phase->fn; phase++, c++) {
+		if (phase->descr)
+			snprintf(buf, DESCR_BUFSZ, _("Phase %d: "), c);
+		else
+			buf[0] = 0;
+		moveon = phase_start(&pi, buf, phase->descr);
+		if (!moveon)
+			return false;
+		moveon = phase->fn(ctx);
+		if (!moveon)
+			return false;
+		moveon = phase_end(&pi);
+		if (!moveon)
+			return false;
+
+		/* Too many errors? */
+		if (xfs_scrub_excessive_errors(ctx))
+			return false;
+	}
+
+	return true;
+}
+
+/* Find an appropriate scrub backend. */
+static struct scrub_ops *
+find_ops(
+	const char		*mnt_type)
+{
+	struct scrub_ops	**ops;
+	struct scrub_ops	*op;
+	const char		*p;
+
+	for (ops = scrub_impl; *ops; ops++) {
+		op = *ops;
+		if (op->aliases) {
+			for (p = op->aliases; *p != 0; p += strlen(p) + 1) {
+				if (!strcmp(mnt_type, p))
+					return op;
+			}
+		}
+		if (!strcmp(mnt_type, op->name))
+			return op;
+	}
+
+	return &generic_scrub_ops;
+}
+
+int
+main(
+	int			argc,
+	char			**argv)
+{
+	int			c;
+	char			*mtab = NULL;
+	struct scrub_ctx	ctx = {0};
+	struct phase_info	all_pi;
+	bool			ismnt;
+	bool			moveon = true;
+	static bool		injected;
+	int			ret;
+	int			error;
+
+	progname = basename(argv[0]);
+	setlocale(LC_ALL, "");
+	bindtextdomain(PACKAGE, LOCALEDIR);
+	textdomain(PACKAGE);
+
+	pthread_mutex_init(&ctx.lock, NULL);
+	ctx.datadev.d_fd = -1;
+	ctx.mode = SCRUB_MODE_DEFAULT;
+	while ((c = getopt(argc, argv, "a:de:m:nTt:vxVy")) != EOF) {
+		switch (c) {
+		case 'a':
+			max_errors = strtoull(optarg, NULL, 10);
+			if (errno) {
+				perror("max_errors");
+				usage();
+			}
+			break;
+		case 'd':
+			debug++;
+			dumpcore = true;
+			break;
+		case 'e':
+			if (!strcmp("continue", optarg))
+				error_action = ERRORS_CONTINUE;
+			else if (!strcmp("shutdown", optarg))
+				error_action = ERRORS_SHUTDOWN;
+			else
+				usage();
+			break;
+		case 'm':
+			mtab = optarg;
+			break;
+		case 'n':
+			if (ctx.mode != SCRUB_MODE_DEFAULT) {
+				fprintf(stderr,
+_("Only one of the options -n or -y may be specified.\n"));
+				return 1;
+			}
+			ctx.mode = SCRUB_MODE_DRY_RUN;
+			break;
+		case 't':
+			ctx.ops = find_ops(optarg);
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
+		case 'y':
+			if (ctx.mode != SCRUB_MODE_DEFAULT) {
+				fprintf(stderr,
+_("Only one of the options -n or -y may be specified.\n"));
+				return 1;
+			}
+			ctx.mode = SCRUB_MODE_REPAIR;
+			break;
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
+	if (!debug_tweak_on("XFS_SCRUB_NO_FIEMAP"))
+		ctx.quirks |= SCRUB_QUIRK_FIEMAP_WORKS |
+			      SCRUB_QUIRK_FIEMAP_ATTR_WORKS;
+	if (!debug_tweak_on("XFS_SCRUB_NO_FIBMAP"))
+		ctx.quirks |= SCRUB_QUIRK_FIBMAP_WORKS;
+
+	/* Find the mount record for the passed-in argument. */
+
+	if (stat(argv[optind], &ctx.mnt_sb) < 0) {
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
+	if (!ctx.ops)
+		ctx.ops = find_ops(ctx.mnt_type);
+	if (verbose)
+		printf(_("%s: scrubbing %s filesystem with %s driver.\n"),
+			ctx.mntpoint, ctx.mnt_type, ctx.ops->name);
+
+	/* Initialize overall phase stats. */
+	moveon = phase_start(&all_pi, "", NULL);
+	if (!moveon)
+		goto out;
+
+	/*
+	 * Does our backend support shutting down, if the user
+	 * wants errors=shutdown?
+	 */
+	if (error_action == ERRORS_SHUTDOWN && ctx.ops->shutdown_fs == NULL) {
+		fprintf(stderr,
+_("%s: %s driver does not support error shutdown!\n"),
+			ctx.mntpoint, ctx.ops->name);
+		goto out;
+	}
+
+	/* Does our backend support preen, if the user so requests? */
+	if (ctx.mode == SCRUB_MODE_PREEN && ctx.ops->preen_fs == NULL) {
+		fprintf(stderr,
+_("%s: %s driver does not support preening filesystem!\n"),
+			ctx.mntpoint, ctx.ops->name);
+		goto out;
+	}
+
+	/* Does our backend support repair, if the user so requests? */
+	if (ctx.mode == SCRUB_MODE_REPAIR && ctx.ops->repair_fs == NULL) {
+		fprintf(stderr,
+_("%s: %s driver does not support repairing filesystem!\n"),
+			ctx.mntpoint, ctx.ops->name);
+		goto out;
+	}
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
+	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !injected) {
+		ctx.mode = SCRUB_MODE_REPAIR;
+		injected = true;
+	}
+
+	/* Scrub a filesystem. */
+	moveon = run_scrub_phases(&ctx);
+	if (!moveon)
+		goto out;
+
+out:
+	if (xfs_scrub_excessive_errors(&ctx))
+		str_info(&ctx, ctx.mntpoint, _("Too many errors; aborting."));
+
+	ret = 0;
+	if (!moveon)
+		ret |= 8;
+
+	/* Clean up scan data. */
+	moveon = ctx.ops->cleanup(&ctx);
+	if (!moveon)
+		ret |= 8;
+
+	if (ctx.errors_found && ctx.warnings_found)
+		fprintf(stderr,
+_("%s: %lu errors and %lu warnings found.  Unmount and run %s.\n"),
+			ctx.mntpoint, ctx.errors_found, ctx.warnings_found,
+			repair_tool(&ctx));
+	else if (ctx.errors_found && ctx.warnings_found == 0)
+		fprintf(stderr,
+_("%s: %lu errors found.  Unmount and run %s.\n"),
+			ctx.mntpoint, ctx.errors_found, repair_tool(&ctx));
+	else if (ctx.errors_found == 0 && ctx.warnings_found)
+		fprintf(stderr,
+_("%s: %lu warnings found.\n"),
+			ctx.mntpoint, ctx.warnings_found);
+	if (ctx.errors_found) {
+		if (error_action == ERRORS_SHUTDOWN)
+			ctx.ops->shutdown_fs(&ctx);
+		ret |= 4;
+	}
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
index 0000000..27df9a6
--- /dev/null
+++ b/scrub/scrub.h
@@ -0,0 +1,197 @@
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
+ * Perform all IO in 32M chunks.  This cannot exceed 65536 sectors
+ * because that's the biggest SCSI VERIFY(16) we dare to send.
+ */
+#define IO_MAX_SIZE		33554432
+#define IO_MAX_SECTORS		(IO_MAX_SIZE >> BBSHIFT)
+
+struct scrub_ctx;
+
+struct scrub_ops {
+	const char	*name;
+	const char	*repair_tool;
+	const char	*aliases; /* null-separated string, end w/ two nulls */
+	bool (*cleanup)(struct scrub_ctx *ctx);
+	bool (*scan_fs)(struct scrub_ctx *ctx);
+	bool (*scan_inodes)(struct scrub_ctx *ctx);
+	bool (*check_dir)(struct scrub_ctx *ctx, const char *descr, int dir_fd);
+	bool (*check_inode)(struct scrub_ctx *ctx, const char *descr, int fd,
+			    struct stat *sb);
+	bool (*scan_extents)(struct scrub_ctx *ctx, const char *descr, int fd,
+			     struct stat *sb, bool attr_fork);
+	bool (*scan_xattrs)(struct scrub_ctx *ctx, const char *descr, int fd);
+	bool (*scan_special_xattrs)(struct scrub_ctx *ctx, const char *path);
+	bool (*scan_metadata)(struct scrub_ctx *ctx);
+	bool (*check_summary)(struct scrub_ctx *ctx);
+	bool (*scan_blocks)(struct scrub_ctx *ctx);
+	bool (*read_file)(struct scrub_ctx *ctx, const char *descr, int fd,
+			  struct stat *sb);
+	bool (*scan_fs_tree)(struct scrub_ctx *ctx);
+	bool (*preen_fs)(struct scrub_ctx *ctx);
+	bool (*repair_fs)(struct scrub_ctx *ctx);
+	void (*shutdown_fs)(struct scrub_ctx *ctx);
+};
+
+enum scrub_mode {
+	SCRUB_MODE_DRY_RUN,
+	SCRUB_MODE_PREEN,
+	SCRUB_MODE_REPAIR,
+};
+#define SCRUB_MODE_DEFAULT			SCRUB_MODE_PREEN
+
+#define SCRUB_QUIRK_FIEMAP_WORKS	(1UL << 0)
+#define SCRUB_QUIRK_FIEMAP_ATTR_WORKS	(1UL << 1)
+#define SCRUB_QUIRK_FIBMAP_WORKS	(1UL << 2)
+#define SCRUB_QUIRK_SHARED_BLOCKS	(1UL << 3)
+/* dirent/stat inode numbers do not match */
+#define SCRUB_QUIRK_UNSTABLE_INUM	(1UL << 4)
+
+bool scrub_has_fiemap(struct scrub_ctx *ctx);
+bool scrub_has_fiemap_attr(struct scrub_ctx *ctx);
+bool scrub_has_fibmap(struct scrub_ctx *ctx);
+bool scrub_has_shared_blocks(struct scrub_ctx *ctx);
+bool scrub_has_unstable_inums(struct scrub_ctx *ctx);
+
+struct scrub_ctx {
+	/* Immutable scrub state. */
+	struct scrub_ops	*ops;
+	char			*mntpoint;
+	char			*blkdev;
+	char			*mnt_type;
+	void			*readbuf;
+	int			mnt_fd;
+	enum scrub_mode		mode;
+	unsigned int		nr_io_threads;
+	struct disk		datadev;
+	struct stat		mnt_sb;
+	struct statvfs		mnt_sv;
+	struct statfs		mnt_sf;
+
+	/* Mutable scrub state; use lock. */
+	pthread_mutex_t		lock;
+	unsigned long		errors_found;
+	unsigned long		warnings_found;
+	unsigned long		repairs;
+	unsigned long		preens;
+	unsigned long		quirks;
+
+	void			*priv;
+};
+
+enum errors_action {
+	ERRORS_CONTINUE,
+	ERRORS_SHUTDOWN,
+};
+
+extern bool			verbose;
+extern int			debug;
+extern bool			scrub_data;
+extern long			page_size;
+extern enum errors_action	error_action;
+
+bool xfs_scrub_excessive_errors(struct scrub_ctx *ctx);
+
+void __str_errno(struct scrub_ctx *, const char *, const char *, int);
+void __str_error(struct scrub_ctx *, const char *, const char *, int,
+		 const char *, ...);
+void __str_warn(struct scrub_ctx *, const char *, const char *, int,
+		const char *, ...);
+void __str_info(struct scrub_ctx *, const char *, const char *, int,
+		const char *, ...);
+void __record_repair(struct scrub_ctx *, const char *, const char *, int,
+		const char *, ...);
+void __record_preen(struct scrub_ctx *, const char *, const char *, int,
+		const char *, ...);
+
+#define str_errno(ctx, str)		__str_errno(ctx, str, __FILE__, __LINE__)
+#define str_error(ctx, str, ...)	__str_error(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
+#define str_warn(ctx, str, ...)		__str_warn(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
+#define str_info(ctx, str, ...)		__str_info(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
+#define record_repair(ctx, str, ...)	__record_repair(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
+#define record_preen(ctx, str, ...)	__record_preen(ctx, str, __FILE__, __LINE__, __VA_ARGS__)
+#define dbg_printf(fmt, ...)		{if (debug > 1) {printf(fmt, __VA_ARGS__);}}
+
+#ifndef container_of
+# define container_of(ptr, type, member) ({			\
+	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
+		(type *)( (char *)__mptr - offsetof(type,member) );})
+#endif
+
+/* Is this debug tweak enabled? */
+static inline bool
+debug_tweak_on(
+	const char		*name)
+{
+	return debug && getenv(name) != NULL;
+}
+
+extern struct scrub_ops	generic_scrub_ops;
+extern struct scrub_ops	xfs_scrub_ops;
+extern struct scrub_ops	btrfs_scrub_ops;
+extern struct scrub_ops	shared_block_fs_scrub_ops;
+extern struct scrub_ops	unstable_inum_fs_scrub_ops;
+
+/* Generic implementations of the ops functions */
+bool generic_cleanup(struct scrub_ctx *ctx);
+bool generic_scan_fs(struct scrub_ctx *ctx);
+bool generic_scan_inodes(struct scrub_ctx *ctx);
+bool generic_check_dir(struct scrub_ctx *ctx, const char *descr, int dir_fd);
+bool generic_check_inode(struct scrub_ctx *ctx, const char *descr, int fd,
+			 struct stat *sb);
+bool generic_scan_extents(struct scrub_ctx *ctx, const char *descr, int fd,
+			  struct stat *sb, bool attr_fork);
+bool generic_scan_xattrs(struct scrub_ctx *ctx, const char *descr, int fd);
+bool generic_scan_special_xattrs(struct scrub_ctx *ctx, const char *path);
+bool generic_scan_metadata(struct scrub_ctx *ctx);
+bool generic_check_summary(struct scrub_ctx *ctx);
+bool read_verify_file(struct scrub_ctx *ctx, const char *descr, int fd,
+		      struct stat *sb);
+bool generic_scan_blocks(struct scrub_ctx *ctx);
+bool generic_scan_fs_tree(struct scrub_ctx *ctx);
+bool generic_preen_fs(struct scrub_ctx *ctx);
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
+const char *repair_tool(struct scrub_ctx *ctx);
+int dirent_open(int dir_fd, struct dirent *dirent);
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
index 0000000..47c6f11
--- /dev/null
+++ b/scrub/xfs.c
@@ -0,0 +1,2465 @@
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
+#include "bitmap.h"
+#include "iocmd.h"
+#include "xfs_fs.h"
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
+	unsigned long long	capabilities;	/* see below */
+	struct read_verify_pool	rvp;
+	enum data_scrub_type	data_scrubber;
+	struct list_head	repair_list;
+};
+
+#define XFS_SCRUB_CAP_KSCRUB_FS		(1ULL << 0)	/* can scrub fs meta? */
+#define XFS_SCRUB_CAP_GETFSMAP		(1ULL << 1)	/* have getfsmap? */
+#define XFS_SCRUB_CAP_BULKSTAT		(1ULL << 2)	/* have bulkstat? */
+#define XFS_SCRUB_CAP_BMAPX		(1ULL << 3)	/* have bmapx? */
+#define XFS_SCRUB_CAP_KSCRUB_INODE	(1ULL << 4)	/* can scrub inode? */
+#define XFS_SCRUB_CAP_KSCRUB_BMAP	(1ULL << 5)	/* can scrub bmap? */
+#define XFS_SCRUB_CAP_KSCRUB_DIR	(1ULL << 6)	/* can scrub dirs? */
+#define XFS_SCRUB_CAP_KSCRUB_XATTR	(1ULL << 7)	/* can scrub attrs?*/
+#define XFS_SCRUB_CAP_PARENT_PTR	(1ULL << 8)	/* can find parent? */
+/* If the fast xattr checks fail, we have to use the slower generic scan. */
+#define XFS_SCRUB_CAP_SKIP_SLOW_XATTR	(1ULL << 9)
+#define XFS_SCRUB_CAP_KSCRUB_SYMLINK	(1ULL << 10)	/* can scrub symlink? */
+
+#define XFS_SCRUB_CAPABILITY_FUNCS(name, flagname) \
+static inline bool \
+xfs_scrub_can_##name(struct xfs_scrub_ctx *xctx) \
+{ \
+	return xctx->capabilities & XFS_SCRUB_CAP_##flagname; \
+} \
+static inline void \
+xfs_scrub_set_##name(struct xfs_scrub_ctx *xctx) \
+{ \
+	xctx->capabilities |= XFS_SCRUB_CAP_##flagname; \
+} \
+static inline void \
+xfs_scrub_clear_##name(struct xfs_scrub_ctx *xctx) \
+{ \
+	xctx->capabilities &= ~(XFS_SCRUB_CAP_##flagname); \
+}
+XFS_SCRUB_CAPABILITY_FUNCS(kscrub_fs,		KSCRUB_FS)
+XFS_SCRUB_CAPABILITY_FUNCS(getfsmap,		GETFSMAP)
+XFS_SCRUB_CAPABILITY_FUNCS(bulkstat,		BULKSTAT)
+XFS_SCRUB_CAPABILITY_FUNCS(bmapx,		BMAPX)
+XFS_SCRUB_CAPABILITY_FUNCS(kscrub_inode,	KSCRUB_INODE)
+XFS_SCRUB_CAPABILITY_FUNCS(kscrub_bmap,		KSCRUB_BMAP)
+XFS_SCRUB_CAPABILITY_FUNCS(kscrub_dir,		KSCRUB_DIR)
+XFS_SCRUB_CAPABILITY_FUNCS(kscrub_xattr,	KSCRUB_XATTR)
+XFS_SCRUB_CAPABILITY_FUNCS(getparent,		PARENT_PTR)
+XFS_SCRUB_CAPABILITY_FUNCS(skip_slow_xattr,	SKIP_SLOW_XATTR)
+XFS_SCRUB_CAPABILITY_FUNCS(kscrub_symlink,	KSCRUB_SYMLINK)
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
+/* Shortcut to creating a read-verify thread pool. */
+static inline bool
+xfs_read_verify_pool_init(
+	struct scrub_ctx	*ctx,
+	read_verify_ioend_fn_t	ioend_fn)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+
+	return read_verify_pool_init(&xctx->rvp, ctx, ctx->readbuf,
+			IO_MAX_SIZE, xctx->geo.blocksize, ioend_fn,
+			disk_heads(&xctx->datadev));
+}
+
+struct owner_decode {
+	uint64_t		owner;
+	const char		*descr;
+};
+
+static const struct owner_decode special_owners[] = {
+	{FMR_OWN_FREE,		"free space"},
+	{FMR_OWN_UNKNOWN,	"unknown owner"},
+	{FMR_OWN_FS,		"static FS metadata"},
+	{FMR_OWN_LOG,		"journalling log"},
+	{FMR_OWN_AG,		"per-AG metadata"},
+	{FMR_OWN_INOBT,		"inode btree blocks"},
+	{FMR_OWN_INODES,	"inodes"},
+	{FMR_OWN_REFC,		"refcount btree"},
+	{FMR_OWN_COW,		"CoW staging"},
+	{FMR_OWN_DEFECTIVE,	"bad blocks"},
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
+struct xfs_scan_inodes {
+	xfs_inode_iter_fn	fn;
+	void			*arg;
+	size_t			array_arg_size;
+	bool			moveon;
+};
+
+/* Scan all the inodes in an AG. */
+static void
+xfs_scan_ag_inodes(
+	struct work_queue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
+{
+	struct xfs_scan_inodes	*si = arg;
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->mp;
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	void			*fn_arg;
+	char			descr[DESCR_BUFSZ];
+	uint64_t		ag_ino;
+	uint64_t		next_ag_ino;
+	bool			moveon;
+
+	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d AG %u inodes"),
+				major(xctx->fsinfo.fs_datadev),
+				minor(xctx->fsinfo.fs_datadev),
+				agno);
+
+	ag_ino = (__u64)agno << (xctx->inopblog + xctx->agblklog);
+	next_ag_ino = (__u64)(agno + 1) << (xctx->inopblog + xctx->agblklog);
+
+	fn_arg = ((char *)si->arg) + si->array_arg_size * agno;
+	moveon = xfs_iterate_inodes(ctx, descr, xctx->fshandle, ag_ino,
+			next_ag_ino - 1, si->fn, fn_arg);
+	if (!moveon)
+		si->moveon = false;
+}
+
+/* How many array elements should we create to scan all the inodes? */
+static inline size_t
+xfs_scan_all_inodes_array_size(
+	struct xfs_scrub_ctx	*xctx)
+{
+	return xctx->geo.agcount;
+}
+
+/* Scan all the inodes in a filesystem. */
+static bool
+xfs_scan_all_inodes_array_arg(
+	struct scrub_ctx	*ctx,
+	xfs_inode_iter_fn	fn,
+	void			*arg,
+	size_t			array_arg_size)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	struct xfs_scan_inodes	si;
+	xfs_agnumber_t		agno;
+	struct work_queue	wq;
+
+	if (!xfs_scrub_can_bulkstat(xctx))
+		return true;
+
+	si.moveon = true;
+	si.fn = fn;
+	si.arg = arg;
+	si.array_arg_size = array_arg_size;
+
+	create_work_queue(&wq, (struct xfs_mount *)ctx, scrub_nproc(ctx));
+	for (agno = 0; agno < xctx->geo.agcount; agno++)
+		queue_work(&wq, xfs_scan_ag_inodes, agno, &si);
+	destroy_work_queue(&wq);
+
+	return si.moveon;
+}
+#define xfs_scan_all_inodes(ctx, fn) \
+	xfs_scan_all_inodes_array_arg((ctx), (fn), NULL, 0)
+#define xfs_scan_all_inodes_arg(ctx, fn, arg) \
+	xfs_scan_all_inodes_array_arg((ctx), (fn), (arg), 0)
+
+/* GETFSMAP wrappers routines. */
+struct xfs_scan_blocks {
+	xfs_fsmap_iter_fn	fn;
+	void			*arg;
+	size_t			array_arg_size;
+	bool			moveon;
+};
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
+	struct xfs_scan_blocks	*sbx = arg;
+	void			*fn_arg;
+	char			descr[DESCR_BUFSZ];
+	struct fsmap		keys[2];
+	off64_t			bperag;
+	bool			moveon;
+
+	bperag = (off64_t)xctx->geo.agblocks *
+		 (off64_t)xctx->geo.blocksize;
+
+	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d AG %u fsmap"),
+				major(xctx->fsinfo.fs_datadev),
+				minor(xctx->fsinfo.fs_datadev),
+				agno);
+
+	memset(keys, 0, sizeof(struct fsmap) * 2);
+	keys->fmr_device = xctx->fsinfo.fs_datadev;
+	keys->fmr_physical = agno * bperag;
+	(keys + 1)->fmr_device = xctx->fsinfo.fs_datadev;
+	(keys + 1)->fmr_physical = ((agno + 1) * bperag) - 1;
+	(keys + 1)->fmr_owner = ULLONG_MAX;
+	(keys + 1)->fmr_offset = ULLONG_MAX;
+	(keys + 1)->fmr_flags = UINT_MAX;
+
+	fn_arg = ((char *)sbx->arg) + sbx->array_arg_size * agno;
+	moveon = xfs_iterate_fsmap(ctx, descr, keys, sbx->fn, fn_arg);
+	if (!moveon)
+		sbx->moveon = false;
+}
+
+/* Iterate all the reverse mappings of a standalone device. */
+static void
+xfs_scan_dev_blocks(
+	struct scrub_ctx	*ctx,
+	int			idx,
+	dev_t			dev,
+	struct xfs_scan_blocks	*sbx)
+{
+	struct fsmap		keys[2];
+	char			descr[DESCR_BUFSZ];
+	void			*fn_arg;
+	bool			moveon;
+
+	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d fsmap"),
+			major(dev), minor(dev));
+
+	memset(keys, 0, sizeof(struct fsmap) * 2);
+	keys->fmr_device = dev;
+	(keys + 1)->fmr_device = dev;
+	(keys + 1)->fmr_physical = ULLONG_MAX;
+	(keys + 1)->fmr_owner = ULLONG_MAX;
+	(keys + 1)->fmr_offset = ULLONG_MAX;
+	(keys + 1)->fmr_flags = UINT_MAX;
+
+	fn_arg = ((char *)sbx->arg) + sbx->array_arg_size * idx;
+	moveon = xfs_iterate_fsmap(ctx, descr, keys, sbx->fn, fn_arg);
+	if (!moveon)
+		sbx->moveon = false;
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
+
+	xfs_scan_dev_blocks(ctx, agno, xctx->fsinfo.fs_rtdev, arg);
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
+
+	xfs_scan_dev_blocks(ctx, agno, xctx->fsinfo.fs_logdev, arg);
+}
+
+/* How many array elements should we create to scan all the blocks? */
+static size_t
+xfs_scan_all_blocks_array_size(
+	struct xfs_scrub_ctx	*xctx)
+{
+	return xctx->geo.agcount + 2;
+}
+
+/* Scan all the blocks in a filesystem. */
+static bool
+xfs_scan_all_blocks_array_arg(
+	struct scrub_ctx	*ctx,
+	xfs_fsmap_iter_fn	fn,
+	void			*arg,
+	size_t			array_arg_size)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	xfs_agnumber_t		agno;
+	struct work_queue	wq;
+	struct xfs_scan_blocks	sbx;
+
+	sbx.moveon = true;
+	sbx.fn = fn;
+	sbx.arg = arg;
+	sbx.array_arg_size = array_arg_size;
+
+	create_work_queue(&wq, (struct xfs_mount *)ctx, scrub_nproc(ctx));
+	if (xctx->fsinfo.fs_rt)
+		queue_work(&wq, xfs_scan_rt_blocks, xctx->geo.agcount + 1,
+				&sbx);
+	if (xctx->fsinfo.fs_log)
+		queue_work(&wq, xfs_scan_log_blocks, xctx->geo.agcount + 2,
+				&sbx);
+	for (agno = 0; agno < xctx->geo.agcount; agno++)
+		queue_work(&wq, xfs_scan_ag_blocks, agno, &sbx);
+	destroy_work_queue(&wq);
+
+	return sbx.moveon;
+}
+
+/* Routines to translate bad physical extents into file paths and offsets. */
+
+struct xfs_verify_error_info {
+	struct bitmap			*d_bad;		/* bytes */
+	struct bitmap			*r_bad;		/* bytes */
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
+	struct xfs_bmap			*bmap,
+	void				*arg)
+{
+	struct xfs_verify_error_info	*vei = arg;
+	struct bitmap			*tree;
+
+	/*
+	 * Only do data scrubbing if the extent is neither unwritten nor
+	 * delalloc.
+	 */
+	if (bmap->bm_flags & (BMV_OF_PREALLOC | BMV_OF_DELALLOC))
+		return true;
+
+	if (fsx->fsx_xflags & FS_XFLAG_REALTIME)
+		tree = vei->r_bad;
+	else
+		tree = vei->d_bad;
+
+	if (!bitmap_has_extent(tree, bmap->bm_physical, bmap->bm_length))
+		return true;
+
+	str_error(ctx, descr,
+_("offset %llu failed read verification."), bmap->bm_offset);
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
+	struct xfs_bmap			key = {0};
+	bool				moveon;
+
+	/* data fork */
+	moveon = xfs_iterate_bmap(ctx, descr, fd, XFS_DATA_FORK, &key,
+			xfs_report_verify_inode_bmap, arg);
+	if (!moveon)
+		return false;
+
+	/* attr fork */
+	moveon = xfs_iterate_bmap(ctx, descr, fd, XFS_ATTR_FORK, &key,
+			xfs_report_verify_inode_bmap, arg);
+	if (!moveon)
+		return false;
+	return true;
+}
+
+/* Report read verify errors in unlinked (but still open) files. */
+static bool
+xfs_report_verify_inode(
+	struct scrub_ctx		*ctx,
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
+	struct stat		*sb,
+	void			*arg)
+{
+	bool			moveon;
+	int			fd;
+
+	/* Ignore things we can't open. */
+	if (!S_ISREG(sb->st_mode) && !S_ISDIR(sb->st_mode))
+		return true;
+	/* Ignore . and .. */
+	if (dirent && (!strcmp(".", dirent->d_name) ||
+		       !strcmp("..", dirent->d_name)))
+		return true;
+
+	/* Open the file */
+	fd = dirent_open(dir_fd, dirent);
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
+	struct bitmap			*d_bad,
+	struct bitmap			*r_bad)
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
+	return xfs_scan_all_inodes_arg(ctx, xfs_report_verify_inode, &vei);
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
+/* Test what kernel functions we can call for this filesystem. */
+static void
+xfs_test_capability(
+	struct scrub_ctx		*ctx,
+	bool				(*test_fn)(struct scrub_ctx *),
+	void				(*set_fn)(struct xfs_scrub_ctx *),
+	const char			*errmsg)
+{
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
+
+	if (test_fn(ctx))
+		set_fn(xctx);
+	else
+		str_info(ctx, ctx->mntpoint, errmsg);
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
+	/*
+	 * Flush everything out to disk before we start checking.
+	 * This seems to reduce the incidence of stale file handle
+	 * errors when we open things by handle.
+	 */
+	error = syncfs(ctx->mnt_fd);
+	if (error) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	xctx = calloc(1, sizeof(struct xfs_scrub_ctx));
+	if (!xctx) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+	INIT_LIST_HEAD(&xctx->repair_list);
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
+	xfs_test_capability(ctx, xfs_can_iterate_inodes, xfs_scrub_set_bulkstat,
+_("Kernel lacks BULKSTAT; scrub will be incomplete."));
+
+	/* Do we have getbmapx? */
+	xfs_test_capability(ctx, xfs_can_iterate_bmap, xfs_scrub_set_bmapx,
+_("Kernel lacks GETBMAPX; scrub will be less efficient."));
+
+	/* Do we have getfsmap? */
+	xfs_test_capability(ctx, xfs_can_iterate_fsmap, xfs_scrub_set_getfsmap,
+_("Kernel lacks GETFSMAP; scrub will be less efficient."));
+
+	/* Do we have kernel-assisted metadata scrubbing? */
+	xfs_test_capability(ctx, xfs_can_scrub_fs_metadata,
+			xfs_scrub_set_kscrub_fs,
+_("Kernel cannot help scrub metadata; scrub will be incomplete."));
+
+	/* Do we have kernel-assisted inode scrubbing? */
+	xfs_test_capability(ctx, xfs_can_scrub_inode,
+			xfs_scrub_set_kscrub_inode,
+_("Kernel cannot help scrub inodes; scrub will be incomplete."));
+
+	/* Do we have kernel-assisted bmap scrubbing? */
+	xfs_test_capability(ctx, xfs_can_scrub_bmap,
+			xfs_scrub_set_kscrub_bmap,
+_("Kernel cannot help scrub extent map; scrub will be less efficient."));
+
+	/* Do we have kernel-assisted dir scrubbing? */
+	xfs_test_capability(ctx, xfs_can_scrub_dir,
+			xfs_scrub_set_kscrub_dir,
+_("Kernel cannot help scrub directories; scrub will be less efficient."));
+
+	/* Do we have kernel-assisted xattr scrubbing? */
+	xfs_test_capability(ctx, xfs_can_scrub_attr,
+			xfs_scrub_set_kscrub_xattr,
+_("Kernel cannot help scrub extended attributes; scrub will be less efficient."));
+
+	/* Do we have kernel-assisted symlink scrubbing? */
+	xfs_test_capability(ctx, xfs_can_scrub_symlink,
+			xfs_scrub_set_kscrub_symlink,
+_("Kernel cannot help scrub symbolic links; scrub will be less efficient."));
+
+	/*
+	 * We don't need to use the slow generic xattr scan unless all
+	 * of the fast scanners fail.
+	 */
+	xfs_scrub_set_skip_slow_xattr(xctx);
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
+		xfs_scrub_clear_getfsmap(xctx);
+	}
+	ctx->nr_io_threads = libxfs_nproc();
+
+	if (xctx->fsinfo.fs_log) {
+		error = disk_open(xctx->fsinfo.fs_log, &xctx->logdev);
+		if (error) {
+			str_errno(ctx, xctx->fsinfo.fs_name);
+			xfs_scrub_clear_getfsmap(xctx);
+		}
+	}
+	if (xctx->fsinfo.fs_rt) {
+		error = disk_open(xctx->fsinfo.fs_rt, &xctx->rtdev);
+		if (error) {
+			str_errno(ctx, xctx->fsinfo.fs_name);
+			xfs_scrub_clear_getfsmap(xctx);
+		}
+	}
+
+	/* Figure out who gets to scrub data extents... */
+	if (scrub_data) {
+		if (xfs_scrub_can_getfsmap(xctx))
+			xctx->data_scrubber = DS_FSMAP;
+		else if (xfs_scrub_can_bmapx(xctx))
+			xctx->data_scrubber = DS_BMAPX;
+		else  if (xfs_scrub_can_bulkstat(xctx))
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
+	struct list_head		repairs;
+	bool				moveon;
+
+	if (!xfs_scrub_can_kscrub_fs(xctx))
+		return;
+
+	INIT_LIST_HEAD(&repairs);
+	moveon = xfs_scrub_ag_metadata(ctx, agno, &repairs);
+	if (!moveon) {
+		*pmoveon = false;
+		return;
+	}
+
+	pthread_mutex_lock(&ctx->lock);
+	list_splice_tail_init(&repairs, &xctx->repair_list);
+	pthread_mutex_unlock(&ctx->lock);
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
+	struct list_head		repairs;
+	bool				moveon;
+
+	if (!xfs_scrub_can_kscrub_fs(xctx))
+		return;
+
+	INIT_LIST_HEAD(&repairs);
+	moveon = xfs_scrub_fs_metadata(ctx, &repairs);
+	if (!moveon)
+		*pmoveon = false;
+
+	pthread_mutex_lock(&ctx->lock);
+	list_splice_tail_init(&repairs, &xctx->repair_list);
+	pthread_mutex_unlock(&ctx->lock);
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
+	struct xfs_bmap			*bmap,
+	void				*arg)
+{
+	unsigned long long		*nextoff = arg;		/* bytes */
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
+	unsigned long long		eofs;
+	bool				badmap = false;
+
+	if (fsx->fsx_xflags & FS_XFLAG_REALTIME)
+		eofs = xctx->geo.rtblocks;
+	else
+		eofs = xctx->geo.datablocks;
+	eofs <<= xctx->blocklog;
+
+	if (bmap->bm_length == 0) {
+		badmap = true;
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) has zero length."),
+				bmap->bm_physical, bmap->bm_offset,
+				bmap->bm_length);
+	}
+
+	if (bmap->bm_physical >= eofs) {
+		badmap = true;
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) starts past end of filesystem at %llu."),
+				bmap->bm_physical, bmap->bm_offset,
+				bmap->bm_length, eofs);
+	}
+
+	if (bmap->bm_offset < *nextoff) {
+		badmap = true;
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) overlaps another extent."),
+				bmap->bm_physical, bmap->bm_offset,
+				bmap->bm_length);
+	}
+
+	if (bmap->bm_physical + bmap->bm_length < bmap->bm_physical ||
+	    bmap->bm_physical + bmap->bm_length >= eofs) {
+		badmap = true;
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) ends past end of filesystem at %llu."),
+				bmap->bm_physical, bmap->bm_offset,
+				bmap->bm_length, eofs);
+	}
+
+	if (bmap->bm_offset + bmap->bm_length < bmap->bm_offset) {
+		badmap = true;
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) overflows file offset."),
+				bmap->bm_physical, bmap->bm_offset,
+				bmap->bm_length);
+	}
+
+	if ((bmap->bm_flags & BMV_OF_SHARED) &&
+	    (bmap->bm_flags & (BMV_OF_PREALLOC | BMV_OF_DELALLOC))) {
+		badmap = true;
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) has conflicting flags 0x%x."),
+				bmap->bm_physical, bmap->bm_offset,
+				bmap->bm_length,
+				bmap->bm_flags);
+	}
+
+	if ((bmap->bm_flags & BMV_OF_SHARED) &&
+	    !(xctx->geo.flags & XFS_FSOP_GEOM_FLAGS_REFLINK)) {
+		badmap = true;
+		str_error(ctx, descr,
+_("extent (%llu/%llu/%llu) is shared but filesystem does not support sharing."),
+				bmap->bm_physical, bmap->bm_offset,
+				bmap->bm_length);
+	}
+
+	if (!badmap)
+		*nextoff = bmap->bm_offset + bmap->bm_length;
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
+	struct xfs_bmap			key = {0};
+	bool				moveon;
+	unsigned long long		nextoff;	/* bytes */
+
+	/* data fork */
+	nextoff = 0;
+	moveon = xfs_iterate_bmap(ctx, descr, fd, XFS_DATA_FORK, &key,
+			xfs_scrub_inode_extent, &nextoff);
+	if (!moveon)
+		return false;
+
+	/* attr fork */
+	nextoff = 0;
+	return xfs_iterate_bmap(ctx, descr, fd, XFS_ATTR_FORK, &key,
+			xfs_scrub_inode_extent, &nextoff);
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
+/*
+ * Read all the extended attributes of a file handle.
+ * This function can return false if the get-attr-by-handle function
+ * does not work correctly; callers must be able to work around that.
+ */
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
+			if (i == 0 && xfs_scrub_can_skip_slow_xattr(xctx)) {
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
+/*
+ * Scrub part of a file.  If the user passes in a valid fd we assume
+ * that's the file to check; otherwise, pass in the inode number and
+ * let the kernel sort it out.
+ */
+static bool
+xfs_scrub_fd(
+	struct scrub_ctx	*ctx,
+	bool			(*fn)(struct scrub_ctx *, uint64_t,
+				      uint32_t, int),
+	struct xfs_bstat	*bs,
+	int			fd)
+{
+	if (fd >= 0)
+		return fn(ctx, 0, 0, fd);
+	return fn(ctx, bs->bs_ino, bs->bs_gen, ctx->mnt_fd);
+}
+
+/* Verify the contents, xattrs, and extent maps of an inode. */
+static bool
+xfs_scrub_inode(
+	struct scrub_ctx	*ctx,
+	struct xfs_handle	*handle,
+	struct xfs_bstat	*bstat,
+	void			*arg)
+{
+	struct stat		fd_sb;
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	static char		linkbuf[PATH_MAX];
+	char			descr[DESCR_BUFSZ];
+	bool			moveon = true;
+	int			fd = -1;
+	int			i;
+	int			error;
+
+	snprintf(descr, DESCR_BUFSZ, _("inode %llu/%u"), bstat->bs_ino,
+			bstat->bs_gen);
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
+
+	/* Try to open the inode to pin it. */
+	if (S_ISREG(bstat->bs_mode) || S_ISDIR(bstat->bs_mode)) {
+		fd = open_by_fshandle(handle, sizeof(*handle),
+				O_RDONLY | O_NOATIME | O_NOFOLLOW | O_NOCTTY);
+		if (debug && fd < 0) {
+			char buf[DESCR_BUFSZ];
+
+			str_warn(ctx, descr, "%s", strerror_r(errno,
+					buf, DESCR_BUFSZ));
+		}
+	}
+
+	/* Scrub the inode. */
+	if (xfs_scrub_can_kscrub_inode(xctx)) {
+		moveon = xfs_scrub_fd(ctx, xfs_scrub_inode_fields, bstat, fd);
+		if (!moveon)
+			goto out;
+	}
+
+	/* Scrub all block mappings. */
+	if (xfs_scrub_can_kscrub_bmap(xctx)) {
+		/* Use the kernel scrubbers. */
+		moveon = xfs_scrub_fd(ctx, xfs_scrub_data_fork, bstat, fd);
+		if (!moveon)
+			goto out;
+		moveon = xfs_scrub_fd(ctx, xfs_scrub_attr_fork, bstat, fd);
+		if (!moveon)
+			goto out;
+		moveon = xfs_scrub_fd(ctx, xfs_scrub_cow_fork, bstat, fd);
+		if (!moveon)
+			goto out;
+	} else if (fd >= 0 && xfs_scrub_can_bmapx(xctx)) {
+		/* Scan the extent maps with GETBMAPX. */
+		moveon = xfs_scan_inode_extents(ctx, descr, fd);
+		if (!moveon)
+			goto out;
+	} else if (fd >= 0) {
+		/* Fall back to the FIEMAP scanner. */
+		error = fstat(fd, &fd_sb);
+		if (error) {
+			str_errno(ctx, descr);
+			goto out;
+		}
+
+		moveon = generic_scan_extents(ctx, descr, fd, &fd_sb, false);
+		if (!moveon)
+			goto out;
+		moveon = generic_scan_extents(ctx, descr, fd, &fd_sb, true);
+		if (!moveon)
+			goto out;
+	} else {
+		/*
+		 * If this is a file or dir, we have no way to scan the
+		 * extent maps.  Complain.
+		 */
+		if (S_ISREG(bstat->bs_mode) || S_ISDIR(bstat->bs_mode))
+			str_error(ctx, descr,
+_("Unable to open inode to scrub extent maps."));
+	}
+
+	/* XXX: Some day, check child -> parent dir -> child. */
+
+	if (S_ISLNK(bstat->bs_mode)) {
+		/* Check symlink contents. */
+		if (xfs_scrub_can_kscrub_symlink(xctx))
+			moveon = xfs_scrub_symlink(ctx, bstat->bs_ino,
+					bstat->bs_gen, ctx->mnt_fd);
+		else {
+			error = readlink_by_handle(handle, sizeof(*handle),
+					linkbuf, PATH_MAX);
+			if (error < 0)
+				str_errno(ctx, descr);
+		}
+		if (!moveon)
+			goto out;
+	} else if (S_ISDIR(bstat->bs_mode)) {
+		/* Check the directory entries. */
+		if (xfs_scrub_can_kscrub_dir(xctx))
+			moveon = xfs_scrub_fd(ctx, xfs_scrub_dir, bstat, fd);
+		else if (fd >= 0)
+			moveon = generic_check_directory(ctx, descr, &fd);
+		else {
+			str_error(ctx, descr,
+_("Unable to open directory to scrub."));
+			moveon = true;
+		}
+		if (!moveon)
+			goto out;
+	}
+
+	/*
+	 * Read all the extended attributes.  If any of the read
+	 * functions decline to move on, we can try again with the
+	 * VFS functions if we have a file descriptor.
+	 */
+	if (xfs_scrub_can_kscrub_xattr(xctx))
+		moveon = xfs_scrub_fd(ctx, xfs_scrub_attr, bstat, fd);
+	else {
+		moveon = true;
+		for (i = 0; i < RXT_MAX; i++) {
+			moveon = xfs_read_handle_xattrs(ctx, descr, handle,
+					known_attr_ns[i]);
+			if (!moveon)
+				break;
+		}
+		if (!moveon && fd >= 0) {
+			moveon = generic_scan_xattrs(ctx, descr, fd);
+			if (!moveon)
+				goto out;
+		}
+		if (!moveon)
+			xfs_scrub_clear_skip_slow_xattr(xctx);
+		moveon = true;
+	}
+	if (!moveon)
+		goto out;
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
+	if (!xfs_scrub_can_bulkstat(xctx))
+		return generic_scan_inodes(ctx);
+
+	return xfs_scan_all_inodes(ctx, xfs_scrub_inode);
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
+	struct stat		*sb,
+	bool			attr_fork)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+
+	/*
+	 * If we have bulkstat and either bmap or kernel scrubbing,
+	 * we already checked the extents.
+	 */
+	if (xfs_scrub_can_bulkstat(xctx) &&
+	    (xfs_scrub_can_bmapx(xctx) || xfs_scrub_can_kscrub_fs(xctx)))
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
+	if (xfs_scrub_can_bulkstat(xctx) && xfs_scrub_can_skip_slow_xattr(xctx))
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
+	if (xfs_scrub_can_bulkstat(xctx) && xfs_scrub_can_skip_slow_xattr(xctx))
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
+	if (xfs_scrub_can_bulkstat(xctx) && xfs_scrub_can_skip_slow_xattr(xctx))
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
+	struct bitmap		*d_bad;		/* bytes */
+	struct bitmap		*r_bad;		/* bytes */
+
+	/* Track the last extent we saw. */
+	uint64_t		laststart;	/* bytes */
+	uint64_t		lastlength;	/* bytes */
+	bool			lastshared;	/* bytes */
+};
+
+/* Report an IO error resulting from read-verify based off getfsmap. */
+static bool
+xfs_check_rmap_error_report(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	struct fsmap		*map,
+	void			*arg)
+{
+	const char		*type;
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	char			buf[32];
+	uint64_t		err_physical = *(uint64_t *)arg;
+	uint64_t		err_off;
+
+	if (err_physical > map->fmr_physical)
+		err_off = err_physical - map->fmr_physical;
+	else
+		err_off = 0;
+
+	snprintf(buf, 32, _("disk offset %llu"),
+			BTOBB(map->fmr_physical + err_off));
+
+	if (map->fmr_flags & FMR_OF_SPECIAL_OWNER) {
+		type = xfs_decode_special_owner(map->fmr_owner);
+		str_error(ctx, buf,
+_("%s failed read verification."),
+				type);
+	} else if (xfs_scrub_can_getparent(xctx)) {
+		/* XXX: go find the parent path */
+		str_error(ctx, buf,
+_("XXX: inode %lld offset %llu failed read verification."),
+				map->fmr_owner, map->fmr_offset + err_off);
+	}
+	return true;
+}
+
+/* Handle a read error in the rmap-based read verify. */
+void
+xfs_check_rmap_ioerr(
+	struct read_verify_pool	*rvp,
+	struct disk		*disk,
+	uint64_t		start,
+	uint64_t		length,
+	int			error,
+	void			*arg)
+{
+	struct fsmap		keys[2];
+	char			descr[DESCR_BUFSZ];
+	struct scrub_ctx	*ctx = rvp->rvp_ctx;
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+	struct xfs_verify_extent	*ve;
+	struct bitmap		*tree;
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
+	if (!xfs_scrub_can_getparent(xctx)) {
+		if (dev == xctx->fsinfo.fs_datadev)
+			tree = ve->d_bad;
+		else if (dev == xctx->fsinfo.fs_rtdev)
+			tree = ve->r_bad;
+		else
+			tree = NULL;
+		if (tree) {
+			moveon = bitmap_add(tree, start, length);
+			if (!moveon)
+				str_errno(ctx, ctx->mntpoint);
+		}
+	}
+
+	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d ioerr @ %"PRIu64":%"PRIu64" "),
+			major(dev), minor(dev), start, length);
+
+	/* Go figure out which blocks are bad from the fsmap. */
+	memset(keys, 0, sizeof(struct fsmap) * 2);
+	keys->fmr_device = dev;
+	keys->fmr_physical = start;
+	(keys + 1)->fmr_device = dev;
+	(keys + 1)->fmr_physical = start + length - 1;
+	(keys + 1)->fmr_owner = ULLONG_MAX;
+	(keys + 1)->fmr_offset = ULLONG_MAX;
+	(keys + 1)->fmr_flags = UINT_MAX;
+	xfs_iterate_fsmap(ctx, descr, keys, xfs_check_rmap_error_report,
+			&start);
+}
+
+/* Read verify a (data block) extent. */
+static bool
+xfs_check_rmap(
+	struct scrub_ctx		*ctx,
+	const char			*descr,
+	struct fsmap			*map,
+	void				*arg)
+{
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
+	struct xfs_verify_extent	*ve = arg;
+	struct disk			*disk;
+	uint64_t			eofs;
+	uint64_t			min_physical;
+	bool				badflags = false;
+	bool				badmap = false;
+
+	dbg_printf("rmap dev %d:%d phys %llu owner %lld offset %llu "
+			"len %llu flags 0x%x\n", major(map->fmr_device),
+			minor(map->fmr_device), map->fmr_physical,
+			map->fmr_owner, map->fmr_offset,
+			map->fmr_length, map->fmr_flags);
+
+	/* If kernel already checked this... */
+	if (xfs_scrub_can_kscrub_fs(xctx))
+		goto skip_check;
+
+	if (map->fmr_device == xctx->fsinfo.fs_datadev)
+		eofs = xctx->geo.datablocks;
+	else if (map->fmr_device == xctx->fsinfo.fs_rtdev)
+		eofs = xctx->geo.rtblocks;
+	else if (map->fmr_device == xctx->fsinfo.fs_logdev)
+		eofs = xctx->geo.logblocks;
+	else
+		assert(0);
+	eofs <<= xctx->blocklog;
+
+	/* Don't go past EOFS */
+	if (map->fmr_physical >= eofs) {
+		badmap = true;
+		str_error(ctx, descr,
+_("rmap (%llu/%llu/%llu) starts past end of filesystem at %llu."),
+				map->fmr_physical, map->fmr_offset,
+				map->fmr_length, eofs);
+	}
+
+	if (map->fmr_physical + map->fmr_length < map->fmr_physical ||
+	    map->fmr_physical + map->fmr_length >= eofs) {
+		badmap = true;
+		str_error(ctx, descr,
+_("rmap (%llu/%llu/%llu) ends past end of filesystem at %llu."),
+				map->fmr_physical, map->fmr_offset,
+				map->fmr_length, eofs);
+	}
+
+	/* Check for illegal overlapping. */
+	if (ve->lastshared && (map->fmr_flags & FMR_OF_SHARED))
+		min_physical = ve->laststart;
+	else
+		min_physical = ve->laststart + ve->lastlength;
+
+	if (map->fmr_physical < min_physical) {
+		badmap = true;
+		str_error(ctx, descr,
+_("rmap (%llu/%llu/%llu) overlaps another rmap."),
+				map->fmr_physical, map->fmr_offset,
+				map->fmr_length);
+	}
+
+	/* can't have shared on non-reflink */
+	if ((map->fmr_flags & FMR_OF_SHARED) &&
+	    !(xctx->geo.flags & XFS_FSOP_GEOM_FLAGS_REFLINK))
+		badflags = true;
+
+	/* unwritten can't have any of the other flags */
+	if ((map->fmr_flags & FMR_OF_PREALLOC) &&
+	     (map->fmr_flags & (FMR_OF_ATTR_FORK | FMR_OF_EXTENT_MAP |
+				 FMR_OF_SHARED | FMR_OF_SPECIAL_OWNER)))
+		badflags = true;
+
+	/* attr fork can't be shared or uwnritten or special */
+	if ((map->fmr_flags & FMR_OF_ATTR_FORK) &&
+	     (map->fmr_flags & (FMR_OF_PREALLOC | FMR_OF_SHARED |
+				 FMR_OF_SPECIAL_OWNER)))
+		badflags = true;
+
+	/* extent maps can only have attrfork */
+	if ((map->fmr_flags & FMR_OF_EXTENT_MAP) &&
+	     (map->fmr_flags & (FMR_OF_PREALLOC | FMR_OF_SHARED |
+				 FMR_OF_SPECIAL_OWNER)))
+		badflags = true;
+
+	/* shared maps can't have any of the other flags */
+	if ((map->fmr_flags & FMR_OF_SHARED) &&
+	    (map->fmr_flags & (FMR_OF_PREALLOC | FMR_OF_ATTR_FORK |
+				FMR_OF_EXTENT_MAP | FMR_OF_SPECIAL_OWNER)))
+
+	/* special owners can't have any of the other flags */
+	if ((map->fmr_flags & FMR_OF_SPECIAL_OWNER) &&
+	     (map->fmr_flags & (FMR_OF_PREALLOC | FMR_OF_ATTR_FORK |
+				 FMR_OF_EXTENT_MAP | FMR_OF_SHARED)))
+		badflags = true;
+
+	if (badflags) {
+		badmap = true;
+		str_error(ctx, descr,
+_("rmap (%llu/%llu/%llu) has conflicting flags 0x%x."),
+				map->fmr_physical, map->fmr_offset,
+				map->fmr_length, map->fmr_flags);
+	}
+
+	/* If this rmap is suspect, don't bother verifying it. */
+	if (badmap)
+		goto out;
+
+skip_check:
+	/* Remember this extent. */
+	ve->lastshared = (map->fmr_flags & FMR_OF_SHARED);
+	ve->laststart = map->fmr_physical;
+	ve->lastlength = map->fmr_length;
+
+	/* "Unknown" extents should be verified; they could be data. */
+	if ((map->fmr_flags & FMR_OF_SPECIAL_OWNER) &&
+			map->fmr_owner == FMR_OWN_UNKNOWN)
+		map->fmr_flags &= ~FMR_OF_SPECIAL_OWNER;
+
+	/*
+	 * We only care about read-verifying data extents that have been
+	 * written to disk.  This means we can skip "special" owners
+	 * (metadata), xattr blocks, unwritten extents, and extent maps.
+	 * These should all get checked elsewhere in the scrubber.
+	 */
+	if (map->fmr_flags & (FMR_OF_PREALLOC | FMR_OF_ATTR_FORK |
+			       FMR_OF_EXTENT_MAP | FMR_OF_SPECIAL_OWNER))
+		goto out;
+
+	/* XXX: Filter out directory data blocks. */
+
+	/* Schedule the read verify command for (eventual) running. */
+	disk = xfs_dev_to_disk(xctx, map->fmr_device);
+
+	read_verify_schedule(&xctx->rvp, &ve->rv, disk, map->fmr_physical,
+			map->fmr_length, ve);
+
+out:
+	/* Is this the last extent?  Fire off the read. */
+	if (map->fmr_flags & FMR_OF_LAST)
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
+	struct bitmap			d_bad;
+	struct bitmap			r_bad;
+	struct xfs_verify_extent	*ve;
+	struct xfs_verify_extent	*v;
+	int				i;
+	unsigned int			groups;
+	bool				moveon;
+
+	/*
+	 * Initialize our per-thread context.  By convention,
+	 * the log device comes first, then the rt device, and then
+	 * the AGs.
+	 */
+	groups = xfs_scan_all_blocks_array_size(xctx);
+	ve = calloc(groups, sizeof(struct xfs_verify_extent));
+	if (!ve) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	moveon = bitmap_init(&d_bad);
+	if (!moveon) {
+		str_errno(ctx, ctx->mntpoint);
+		goto out_ve;
+	}
+
+	moveon = bitmap_init(&r_bad);
+	if (!moveon) {
+		str_errno(ctx, ctx->mntpoint);
+		goto out_dbad;
+	}
+
+	for (i = 0, v = ve; i < groups; i++, v++) {
+		v->d_bad = &d_bad;
+		v->r_bad = &r_bad;
+	}
+
+	moveon = xfs_read_verify_pool_init(ctx, xfs_check_rmap_ioerr);
+	if (!moveon)
+		goto out_rbad;
+	moveon = xfs_scan_all_blocks_array_arg(ctx, xfs_check_rmap,
+			ve, sizeof(*ve));
+	if (!moveon)
+		goto out_pool;
+
+	for (i = 0, v = ve; i < groups; i++, v++)
+		read_verify_force(&xctx->rvp, &v->rv);
+	read_verify_pool_destroy(&xctx->rvp);
+
+	/* Scan the whole dir tree to see what matches the bad extents. */
+	if (!bitmap_empty(&d_bad) || !bitmap_empty(&r_bad))
+		moveon = xfs_report_verify_errors(ctx, &d_bad, &r_bad);
+
+	bitmap_free(&r_bad);
+	bitmap_free(&d_bad);
+	free(ve);
+	return moveon;
+
+out_pool:
+	read_verify_pool_destroy(&xctx->rvp);
+out_rbad:
+	bitmap_free(&r_bad);
+out_dbad:
+	bitmap_free(&d_bad);
+out_ve:
+	free(ve);
+	return moveon;
+}
+
+/* Read-verify with BULKSTAT + GETBMAPX */
+struct xfs_verify_inode {
+	struct bitmap			d_good;		/* bytes */
+	struct bitmap			r_good;		/* bytes */
+	struct bitmap			*d_bad;		/* bytes */
+	struct bitmap			*r_bad;		/* bytes */
+};
+
+struct xfs_verify_submit {
+	struct read_verify_pool		*rvp;
+	struct bitmap			*bad;
+	struct disk			*disk;
+	struct read_verify		rv;
+};
+
+/* Finish a inode block scan. */
+void
+xfs_verify_inode_bmap_ioerr(
+	struct read_verify_pool		*rvp,
+	struct disk			*disk,
+	uint64_t			start,
+	uint64_t			length,
+	int				error,
+	void				*arg)
+{
+	struct bitmap			*tree = arg;
+
+	bitmap_add(tree, start, length);
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
+	struct xfs_bmap			*bmap,
+	void				*arg)
+{
+	struct bitmap			*tree = arg;
+
+	/*
+	 * Only do data scrubbing if the extent is neither unwritten nor
+	 * delalloc.
+	 */
+	if (bmap->bm_flags & (BMV_OF_PREALLOC | BMV_OF_DELALLOC))
+		return true;
+
+	return bitmap_add(tree, bmap->bm_physical, bmap->bm_length);
+}
+
+/* Read-verify the data blocks of a file via BMAP. */
+static bool
+xfs_verify_inode(
+	struct scrub_ctx		*ctx,
+	struct xfs_handle		*handle,
+	struct xfs_bstat		*bstat,
+	void				*arg)
+{
+	struct stat			fd_sb;
+	struct xfs_bmap			key = {0};
+	struct xfs_verify_inode		*vi = arg;
+	struct bitmap			*tree;
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
+	if (vi) {
+		/* Use BMAPX */
+		if (bstat->bs_xflags & FS_XFLAG_REALTIME)
+			tree = &vi->r_good;
+		else
+			tree = &vi->d_good;
+
+		/* data fork */
+		moveon = xfs_iterate_bmap(ctx, descr, fd, XFS_DATA_FORK, &key,
+				xfs_verify_inode_bmap, tree);
+	} else {
+		error = fstat(fd, &fd_sb);
+		if (error) {
+			str_errno(ctx, descr);
+			goto out;
+		}
+
+		/* Use generic_file_read */
+		moveon = read_verify_file(ctx, descr, fd, &fd_sb);
+	}
+
+out:
+	if (fd >= 0)
+		close(fd);
+	return moveon;
+}
+
+/* Schedule a read verification from an extent tree record. */
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
+	struct bitmap		d_good;
+	struct bitmap		d_bad;
+	struct bitmap		r_good;
+	struct bitmap		r_bad;
+	struct xfs_verify_inode	*vi;
+	struct xfs_verify_inode	*v;
+	struct xfs_verify_submit	vs;
+	int			i;
+	unsigned int		groups;
+	bool			moveon;
+
+	groups = xfs_scan_all_inodes_array_size(xctx);
+	vi = calloc(groups, sizeof(struct xfs_verify_inode));
+	if (!vi) {
+		str_errno(ctx, ctx->mntpoint);
+		return false;
+	}
+
+	moveon = bitmap_init(&d_good);
+	if (!moveon) {
+		str_errno(ctx, ctx->mntpoint);
+		goto out_vi;
+	}
+
+	moveon = bitmap_init(&d_bad);
+	if (!moveon) {
+		str_errno(ctx, ctx->mntpoint);
+		goto out_dgood;
+	}
+
+	moveon = bitmap_init(&r_good);
+	if (!moveon) {
+		str_errno(ctx, ctx->mntpoint);
+		goto out_dbad;
+	}
+
+	moveon = bitmap_init(&r_bad);
+	if (!moveon) {
+		str_errno(ctx, ctx->mntpoint);
+		goto out_rgood;
+	}
+
+	for (i = 0, v = vi; i < groups; i++, v++) {
+		v->d_bad = &d_bad;
+		v->r_bad = &r_bad;
+
+		moveon = bitmap_init(&v->d_good);
+		if (!moveon) {
+			str_errno(ctx, ctx->mntpoint);
+			goto out_varray;
+		}
+
+		moveon = bitmap_init(&v->r_good);
+		if (!moveon) {
+			str_errno(ctx, ctx->mntpoint);
+			goto out_varray;
+		}
+	}
+
+	/* Scan all the inodes for extent information. */
+	moveon = xfs_scan_all_inodes_array_arg(ctx, xfs_verify_inode,
+			vi, sizeof(*vi));
+	if (!moveon)
+		goto out_varray;
+
+	/* Merge all the IOs. */
+	for (i = 0, v = vi; i < groups; i++, v++) {
+		bitmap_merge(&d_good, &v->d_good);
+		bitmap_free(&v->d_good);
+		bitmap_merge(&r_good, &v->r_good);
+		bitmap_free(&v->r_good);
+	}
+
+	/* Run all the IO in batches. */
+	memset(&vs, 0, sizeof(struct xfs_verify_submit));
+	vs.rvp = &xctx->rvp;
+	moveon = xfs_read_verify_pool_init(ctx, xfs_verify_inode_bmap_ioerr);
+	if (!moveon)
+		goto out_varray;
+	vs.disk = &xctx->datadev;
+	vs.bad = &d_bad;
+	moveon = bitmap_iterate(&d_good, xfs_schedule_read_verify, &vs);
+	if (!moveon)
+		goto out_pool;
+	vs.disk = &xctx->rtdev;
+	vs.bad = &r_bad;
+	moveon = bitmap_iterate(&r_good, xfs_schedule_read_verify, &vs);
+	if (!moveon)
+		goto out_pool;
+	read_verify_force(&xctx->rvp, &vs.rv);
+	read_verify_pool_destroy(&xctx->rvp);
+
+	/* Re-scan the file bmaps to see if they match the bad. */
+	if (!bitmap_empty(&d_bad) || !bitmap_empty(&r_bad))
+		moveon = xfs_report_verify_errors(ctx, &d_bad, &r_bad);
+
+	goto out_varray;
+
+out_pool:
+	read_verify_pool_destroy(&xctx->rvp);
+out_varray:
+	for (i = 0, v = vi; i < xctx->geo.agcount; i++, v++) {
+		bitmap_free(&v->d_good);
+		bitmap_free(&v->r_good);
+	}
+	bitmap_free(&r_bad);
+out_rgood:
+	bitmap_free(&r_good);
+out_dbad:
+	bitmap_free(&d_bad);
+out_dgood:
+	bitmap_free(&d_good);
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
+	return xfs_scan_all_inodes(ctx, xfs_verify_inode);
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
+	struct stat		*sb)
+{
+	struct xfs_scrub_ctx	*xctx = ctx->priv;
+
+	if (xctx->data_scrubber != DS_READ)
+		return true;
+
+	return read_verify_file(ctx, descr, fd, sb);
+}
+
+/* Phase 6 */
+
+struct xfs_summary_counts {
+	unsigned long long	inodes;		/* number of inodes */
+	unsigned long long	dbytes;		/* data dev bytes */
+	unsigned long long	rbytes;		/* rt dev bytes */
+	unsigned long long	next_phys;	/* next phys bytes we see? */
+	unsigned long long	agbytes;	/* freespace bytes */
+	struct bitmap		dext;		/* data block extent bitmap */
+	struct bitmap		rext;		/* rt block extent bitmap */
+};
+
+struct xfs_inode_fork_summary {
+	struct bitmap		*tree;
+	unsigned long long	bytes;
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
+	struct xfs_bmap			*bmap,
+	void				*arg)
+{
+	struct xfs_inode_fork_summary	*ifs = arg;
+
+	/* Only record real extents. */
+	if (bmap->bm_flags & BMV_OF_DELALLOC)
+		return true;
+
+	bitmap_add(ifs->tree, bmap->bm_physical, bmap->bm_length);
+	ifs->bytes += bmap->bm_length;
+
+	return true;
+}
+
+/* Record inode and block usage. */
+static bool
+xfs_record_inode_summary(
+	struct scrub_ctx		*ctx,
+	struct xfs_handle		*handle,
+	struct xfs_bstat		*bstat,
+	void				*arg)
+{
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
+	struct xfs_summary_counts	*counts = arg;
+	struct xfs_inode_fork_summary	ifs = {0};
+	struct xfs_bmap			key = {0};
+	char				descr[DESCR_BUFSZ];
+	int				fd;
+	bool				moveon;
+
+	counts->inodes++;
+	if (xfs_scrub_can_getfsmap(xctx) || bstat->bs_blocks == 0)
+		return true;
+
+	if (!xfs_scrub_can_bmapx(xctx) || !S_ISREG(bstat->bs_mode)) {
+		counts->dbytes += (bstat->bs_blocks << xctx->blocklog);
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
+	/* data fork */
+	if (bstat->bs_xflags & FS_XFLAG_REALTIME)
+		ifs.tree = &counts->rext;
+	else
+		ifs.tree = &counts->dext;
+	moveon = xfs_iterate_bmap(ctx, descr, fd, XFS_DATA_FORK, &key,
+			xfs_record_inode_summary_bmap, &ifs);
+	if (!moveon)
+		goto out;
+
+	/* attr fork */
+	ifs.tree = &counts->dext;
+	moveon = xfs_iterate_bmap(ctx, descr, fd, XFS_ATTR_FORK, &key,
+			xfs_record_inode_summary_bmap, &ifs);
+	if (!moveon)
+		goto out;
+
+	/*
+	 * bs_blocks tracks the number of sectors assigned to this file
+	 * for data, xattrs, and block mapping metadata.  ifs.bytes tracks
+	 * the data and xattr storage space used, so the diff between the
+	 * two is the space used for block mapping metadata.  Add that to
+	 * the data usage.
+	 */
+	counts->dbytes += (bstat->bs_blocks << xctx->blocklog) - ifs.bytes;
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
+	struct fsmap			*fsmap,
+	void				*arg)
+{
+	struct xfs_summary_counts	*counts = arg;
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
+	unsigned long long		len;
+
+	if (fsmap->fmr_device == xctx->fsinfo.fs_logdev)
+		return true;
+	if ((fsmap->fmr_flags & FMR_OF_SPECIAL_OWNER) &&
+	    fsmap->fmr_owner == FMR_OWN_FREE)
+		return true;
+
+	len = fsmap->fmr_length;
+
+	/* freesp btrees live in free space, need to adjust counters later. */
+	if ((fsmap->fmr_flags & FMR_OF_SPECIAL_OWNER) &&
+	    fsmap->fmr_owner == FMR_OWN_AG) {
+		counts->agbytes += fsmap->fmr_length;
+	}
+	if (fsmap->fmr_device == xctx->fsinfo.fs_rtdev) {
+		/* Count realtime extents. */
+		counts->rbytes += len;
+	} else {
+		/* Count data extents. */
+		if (counts->next_phys >= fsmap->fmr_physical + len)
+			return true;
+		else if (counts->next_phys > fsmap->fmr_physical)
+			len = counts->next_phys - fsmap->fmr_physical;
+			
+		counts->dbytes += len;
+		counts->next_phys = fsmap->fmr_physical + fsmap->fmr_length;
+	}
+
+	return true;
+}
+
+/* Sum the bytes in each extent. */
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
+	unsigned int			groups;
+	int				error;
+
+	if (!xfs_scrub_can_bulkstat(xctx))
+		return generic_check_summary(ctx);
+
+	groups = xfs_scan_all_blocks_array_size(xctx);
+	summary = calloc(groups, sizeof(struct xfs_summary_counts));
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
+	if (xfs_scrub_can_getfsmap(xctx)) {
+		/* Use fsmap to count blocks. */
+		moveon = xfs_scan_all_blocks_array_arg(ctx,
+				xfs_record_block_summary,
+				summary, sizeof(*summary));
+		if (!moveon)
+			goto out;
+	} else {
+		/* Reflink w/o rmap; have to collect extents in a bitmap. */
+		for (agno = 0; agno < groups; agno++) {
+			moveon = bitmap_init(&summary[agno].dext);
+			if (!moveon) {
+				str_errno(ctx, ctx->mntpoint);
+				goto out;
+			}
+			moveon = bitmap_init(&summary[agno].rext);
+			if (!moveon) {
+				str_errno(ctx, ctx->mntpoint);
+				goto out;
+			}
+		}
+	}
+
+	/* Scan the whole fs. */
+	moveon = xfs_scan_all_inodes_array_arg(ctx, xfs_record_inode_summary,
+			summary, sizeof(*summary));
+	if (!moveon)
+		goto out;
+
+	if (!xfs_scrub_can_getfsmap(xctx)) {
+		/* Reflink w/o rmap; merge the bitmaps. */
+		for (agno = 1; agno < groups; agno++) {
+			bitmap_merge(&summary[0].dext, &summary[agno].dext);
+			bitmap_free(&summary[agno].dext);
+			bitmap_merge(&summary[0].rext, &summary[agno].rext);
+			bitmap_free(&summary[agno].rext);
+		}
+		moveon = bitmap_iterate(&summary[0].dext,
+				xfs_summary_count_helper, &summary[0].dbytes);
+		moveon = bitmap_iterate(&summary[0].rext,
+				xfs_summary_count_helper, &summary[0].rbytes);
+		bitmap_free(&summary[0].dext);
+		bitmap_free(&summary[0].rext);
+		if (!moveon)
+			goto out;
+	}
+
+	/* Sum the counts. */
+	for (agno = 1; agno < groups; agno++) {
+		summary[0].inodes += summary[agno].inodes;
+		summary[0].dbytes += summary[agno].dbytes;
+		summary[0].rbytes += summary[agno].rbytes;
+		summary[0].agbytes += summary[agno].agbytes;
+	}
+
+	/* Account for an internal log, if present. */
+	if (!xfs_scrub_can_getfsmap(xctx) && xctx->fsinfo.fs_log == NULL)
+		summary[0].dbytes += (unsigned long long)xctx->geo.logblocks <<
+				xctx->blocklog;
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
+	sfs.f_bfree -= summary[0].agbytes >> xctx->blocklog;
+
+	/* Report on what we found. */
+	fd = (xctx->geo.datablocks - sfs.f_bfree) << xctx->blocklog;
+	fr = (xctx->geo.rtblocks - fc.freertx) << xctx->blocklog;
+	fi = sfs.f_files - sfs.f_ffree;
+	sd = summary[0].dbytes;
+	sr = summary[0].rbytes;
+	si = summary[0].inodes;
+
+	/*
+	 * Complain if the counts are off by more than 10% unless
+	 * the inaccuracy is less than 32MB worth of blocks or 100 inodes.
+	 */
+	absdiff = 1ULL << 25;
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
+_("%.1f%s data used;  %.1f%s realtime data used;  %.2f%s inodes used.\n"),
+					d, du, r, ru, i, iu);
+			d = auto_space_units(sd, &du);
+			r = auto_space_units(sr, &ru);
+			i = auto_units(si, &iu);
+			printf(
+_("%.1f%s data found; %.1f%s realtime data found; %.2f%s inodes found.\n"),
+					d, du, r, ru, i, iu);
+		} else {
+			d = auto_space_units(fd, &du);
+			i = auto_units(fi, &iu);
+			printf(
+_("%.1f%s data used;  %.1f%s inodes used.\n"),
+					d, du, i, iu);
+			d = auto_space_units(sd, &du);
+			i = auto_units(si, &iu);
+			printf(
+_("%.1f%s data found; %.1f%s inodes found.\n"),
+					d, du, i, iu);
+		}
+	}
+	moveon = true;
+
+out:
+	for (agno = 0; agno < groups; agno++) {
+		bitmap_free(&summary[agno].dext);
+		bitmap_free(&summary[agno].rext);
+	}
+	free(summary);
+	return moveon;
+}
+
+/* Phase 7: Preen filesystem. */
+
+static bool
+xfs_repair_fs(
+	struct scrub_ctx		*ctx)
+{
+	struct xfs_scrub_ctx		*xctx = ctx->priv;
+	bool				moveon;
+
+	/* Repair anything broken. */
+	moveon = xfs_repair_metadata_list(ctx, &xctx->repair_list);
+	if (!moveon)
+		return false;
+
+	fstrim(ctx);
+	return true;
+}
+
+/* Shut down the filesystem. */
+static void
+xfs_shutdown_fs(
+	struct scrub_ctx		*ctx)
+{
+	int				flag;
+
+	flag = XFS_FSOP_GOING_FLAGS_LOGFLUSH;
+	if (xfsctl(ctx->mntpoint, ctx->mnt_fd, XFS_IOC_GOINGDOWN, &flag))
+		str_errno(ctx, ctx->mntpoint);
+}
+
+struct scrub_ops xfs_scrub_ops = {
+	.name			= "xfs",
+	.repair_tool		= "xfs_repair",
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
+	.shutdown_fs		= xfs_shutdown_fs,
+	.preen_fs		= xfs_repair_fs,
+	.repair_fs		= xfs_repair_fs,
+};
diff --git a/scrub/xfs_ioctl.c b/scrub/xfs_ioctl.c
new file mode 100644
index 0000000..397755b
--- /dev/null
+++ b/scrub/xfs_ioctl.c
@@ -0,0 +1,767 @@
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
+	const char		*descr,
+	void			*fshandle,
+	uint64_t		first_ino,
+	uint64_t		last_ino,
+	xfs_inode_iter_fn	fn,
+	void			*arg)
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
+	assert(!debug_tweak_on("XFS_SCRUB_NO_BULKSTAT"));
+
+	bstatbuf = calloc(BSTATBUF_NR, sizeof(struct xfs_bstat));
+	if (!bstatbuf) {
+		str_errno(ctx, descr);
+		return false;
+	}
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
+			moveon = fn(ctx, &handle, p, arg);
+			if (!moveon)
+				goto out;
+			if (xfs_scrub_excessive_errors(ctx)) {
+				moveon = false;
+				goto out;
+			}
+		}
+	}
+
+	if (error) {
+		str_errno(ctx, descr);
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
+	if (debug_tweak_on("XFS_SCRUB_NO_BULKSTAT"))
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
+	const char		*descr,
+	int			fd,
+	int			whichfork,
+	struct xfs_bmap		*key,
+	xfs_bmap_iter_fn	fn,
+	void			*arg)
+{
+	struct fsxattr		fsx;
+	struct getbmapx		*map;
+	struct getbmapx		*p;
+	struct xfs_bmap		bmap;
+	char			bmap_descr[DESCR_BUFSZ];
+	bool			moveon = true;
+	xfs_off_t		new_off;
+	int			getxattr_type;
+	int			i;
+	int			error;
+
+	assert(!debug_tweak_on("XFS_SCRUB_NO_BMAP"));
+
+	switch (whichfork) {
+	case XFS_ATTR_FORK:
+		snprintf(bmap_descr, DESCR_BUFSZ, _("%s attr"), descr);
+		break;
+	case XFS_COW_FORK:
+		snprintf(bmap_descr, DESCR_BUFSZ, _("%s CoW"), descr);
+		break;
+	case XFS_DATA_FORK:
+		snprintf(bmap_descr, DESCR_BUFSZ, _("%s data"), descr);
+		break;
+	default:
+		assert(0);
+	}
+
+	map = calloc(BMAP_NR, sizeof(struct getbmapx));
+	if (!map) {
+		str_errno(ctx, bmap_descr);
+		return false;
+	}
+
+	map->bmv_offset = BTOBB(key->bm_offset);
+	map->bmv_block = BTOBB(key->bm_physical);
+	if (key->bm_length == 0)
+		map->bmv_length = ULLONG_MAX;
+	else
+		map->bmv_length = BTOBB(key->bm_length);
+	map->bmv_count = BMAP_NR;
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
+		str_errno(ctx, bmap_descr);
+		moveon = false;
+		goto out;
+	}
+
+	while ((error = xfsctl(bmap_descr, fd, XFS_IOC_GETBMAPX, map)) == 0) {
+
+		for (i = 0, p = &map[i + 1]; i < map->bmv_entries; i++, p++) {
+			bmap.bm_offset = BBTOB(p->bmv_offset);
+			bmap.bm_physical = BBTOB(p->bmv_block);
+			bmap.bm_length = BBTOB(p->bmv_length);
+			bmap.bm_flags = p->bmv_oflags;
+			moveon = fn(ctx, bmap_descr, fd, whichfork, &fsx,
+					&bmap, arg);
+			if (!moveon)
+				goto out;
+			if (xfs_scrub_excessive_errors(ctx)) {
+				moveon = false;
+				goto out;
+			}
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
+		str_errno(ctx, bmap_descr);
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
+	if (debug_tweak_on("XFS_SCRUB_NO_BMAP"))
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
+	const char		*descr,
+	struct fsmap		*keys,
+	xfs_fsmap_iter_fn	fn,
+	void			*arg)
+{
+	struct fsmap_head	*head;
+	struct fsmap		*p;
+	bool			moveon = true;
+	int			i;
+	int			error;
+
+	assert(!debug_tweak_on("XFS_SCRUB_NO_FSMAP"));
+
+	head = malloc(fsmap_sizeof(FSMAP_NR));
+	if (!head) {
+		str_errno(ctx, descr);
+		return false;
+	}
+
+	memset(head, 0, sizeof(*head));
+	memcpy(head->fmh_keys, keys, sizeof(struct fsmap) * 2);
+	head->fmh_count = FSMAP_NR;
+
+	while ((error = xfsctl(ctx->mntpoint, ctx->mnt_fd, XFS_IOC_GETFSMAP,
+				head)) == 0) {
+
+		for (i = 0, p = head->fmh_recs; i < head->fmh_entries; i++, p++) {
+			moveon = fn(ctx, descr, p, arg);
+			if (!moveon)
+				goto out;
+			if (xfs_scrub_excessive_errors(ctx)) {
+				moveon = false;
+				goto out;
+			}
+		}
+
+		if (head->fmh_entries == 0)
+			break;
+		p = &head->fmh_recs[head->fmh_entries - 1];
+		if (p->fmr_flags & FMR_OF_LAST)
+			break;
+
+		head->fmh_keys[0] = *p;
+	}
+
+	if (error) {
+		str_errno(ctx, descr);
+		moveon = false;
+	}
+out:
+	free(head);
+	return moveon;
+}
+
+/* Does the kernel support getfsmap? */
+bool
+xfs_can_iterate_fsmap(
+	struct scrub_ctx	*ctx)
+{
+	struct fsmap_head	head;
+	int			error;
+
+	if (debug_tweak_on("XFS_SCRUB_NO_FSMAP"))
+		return false;
+
+	memset(&head, 0, sizeof(struct fsmap_head));
+	head.fmh_keys[1].fmr_device = UINT_MAX;
+	head.fmh_keys[1].fmr_physical = ULLONG_MAX;
+	head.fmh_keys[1].fmr_owner = ULLONG_MAX;
+	head.fmh_keys[1].fmr_offset = ULLONG_MAX;
+	error = xfsctl(ctx->mntpoint, ctx->mnt_fd, XFS_IOC_GETFSMAP, &head);
+	return error == 0 && (head.fmh_oflags & FMH_OF_DEV_T);
+}
+
+/* Online scrub and repair. */
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
+/* These must correspond to XFS_SCRUB_TYPE_ */
+static const struct scrub_descr scrubbers[] = {
+	{"dummy",				ST_NONE},
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
+	{"record",				ST_INODE},
+	{"data block map",			ST_INODE},
+	{"attr block map",			ST_INODE},
+	{"CoW block map",			ST_INODE},
+	{"directory entries",			ST_INODE},
+	{"extended attributes",			ST_INODE},
+	{"symbolic link",			ST_INODE},
+	{"realtime bitmap",			ST_FS},
+	{"realtime summary",			ST_FS},
+};
+
+/* Format a scrub description. */
+static void
+format_scrub_descr(
+	char				*buf,
+	size_t				buflen,
+	int				fd,
+	unsigned long long		ctl,
+	const struct scrub_descr	*sc)
+{
+	struct stat			sb;
+
+	switch (sc->type) {
+	case ST_PERAG:
+		snprintf(buf, buflen, _("AG %llu %s"), ctl, _(sc->name));
+		break;
+	case ST_INODE:
+		if (ctl == 0 && fd >= 0) {
+			fstat(fd, &sb);
+			ctl = sb.st_ino;
+		}
+		snprintf(buf, buflen, _("inode %llu %s"), ctl, _(sc->name));
+		break;
+	case ST_FS:
+		snprintf(buf, buflen, _("%s"), _(sc->name));
+		break;
+	case ST_NONE:
+		assert(0);
+		break;
+	}
+}
+
+/* Do we need to repair something? */
+static inline bool
+xfs_scrub_needs_repair(
+	struct xfs_scrub_metadata	*sm)
+{
+	return sm->sm_flags & XFS_SCRUB_FLAG_CORRUPT;
+}
+
+/* Can we optimize something? */
+static inline bool
+xfs_scrub_needs_preen(
+	struct xfs_scrub_metadata	*sm)
+{
+	return sm->sm_flags & XFS_SCRUB_FLAG_PREEN;
+}
+
+enum check_outcome {
+	CHECK_OK,
+	CHECK_REPAIR,
+	CHECK_PREEN,
+};
+
+/* Do a read-only check of some metadata. */
+static bool
+xfs_check_metadata(
+	struct scrub_ctx		*ctx,
+	int				fd,
+	unsigned int			type,
+	unsigned long long		ctl,
+	unsigned long			ctl2,
+	enum check_outcome		*outcome)
+{
+	struct xfs_scrub_metadata	meta = {0};
+	const struct scrub_descr	*sc;
+	char				buf[DESCR_BUFSZ];
+	int				error;
+
+	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
+
+	sc = &scrubbers[type];
+	*outcome = CHECK_OK;
+	switch (sc->type) {
+	case ST_PERAG:
+		meta.sm_agno = ctl;
+		break;
+	case ST_INODE:
+		meta.sm_ino = ctl;
+		meta.sm_gen = ctl2;
+		break;
+	case ST_NONE:
+	case ST_FS:
+		/* nothing */
+		break;
+	}
+	meta.sm_type = type;
+	meta.sm_flags = 0;
+	format_scrub_descr(buf, DESCR_BUFSZ, fd, ctl, sc);
+
+	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, &meta);
+	dbg_printf("check %s fd %d type %s ctl %llu error %d errno %d flags %xh\n",
+			buf, fd, sc->name, ctl, error, errno, meta.sm_flags);
+	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !error)
+		meta.sm_flags |= XFS_SCRUB_FLAG_PREEN;
+	if (error) {
+		/* Metadata not present, just skip it. */
+		if (errno == ENOENT)
+			return true;
+
+		/* Operational error. */
+		str_errno(ctx, buf);
+		return true;
+	} else if (!xfs_scrub_needs_repair(&meta) &&
+		   !xfs_scrub_needs_preen(&meta)) {
+		/* Clean operation, no corruption or preening detected. */
+		return true;
+	} else if (xfs_scrub_needs_repair(&meta) &&
+		   ctx->mode < SCRUB_MODE_REPAIR) {
+		/* Corrupt, but we're not in repair mode. */
+		str_error(ctx, buf, _("Repairs are required."));
+		return true;
+	} else if (xfs_scrub_needs_preen(&meta) &&
+		   ctx->mode < SCRUB_MODE_PREEN) {
+		/* Preenable, but we're not in preen mode. */
+		str_info(ctx, buf, _("Optimization is possible."));
+		return true;
+	}
+
+	/* Save for later. */
+	if (xfs_scrub_needs_repair(&meta))
+		*outcome = CHECK_REPAIR;
+	else
+		*outcome = CHECK_PREEN;
+	return true;
+}
+
+/* Repair some metadata. */
+static bool
+xfs_repair_metadata(
+	struct scrub_ctx		*ctx,
+	int				fd,
+	int				type,
+	unsigned long long		ctl,
+	unsigned long			ctl2,
+	enum check_outcome		fix)
+{
+	struct xfs_scrub_metadata	meta = {0};
+	const struct scrub_descr	*sc;
+	char				buf[DESCR_BUFSZ];
+	int				error;
+
+	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
+	assert(fix != CHECK_OK);
+
+	sc = &scrubbers[type];
+	switch (sc->type) {
+	case ST_PERAG:
+		meta.sm_agno = ctl;
+		break;
+	case ST_INODE:
+		meta.sm_ino = ctl;
+		meta.sm_gen = ctl2;
+		break;
+	case ST_NONE:
+	case ST_FS:
+		/* nothing */
+		break;
+	}
+	meta.sm_type = type;
+	meta.sm_flags |= XFS_SCRUB_FLAG_REPAIR;
+	format_scrub_descr(buf, DESCR_BUFSZ, fd, ctl, sc);
+
+	if (fix == CHECK_REPAIR)
+		record_repair(ctx, buf, _("Attempting repair."));
+	else
+		record_preen(ctx, buf, _("Attempting optimization."));
+	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, &meta);
+	if (error) {
+		switch (errno) {
+		case ENOTTY:
+		case EOPNOTSUPP:
+			/*
+			 * If we forced repairs, don't complain if kernel
+			 * doesn't know how to fix.
+			 */
+			if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
+				return true;
+			/* fall through */
+		case EINVAL:
+			/* Kernel doesn't know how to repair this. */
+			goto fix_offline;
+		case EROFS:
+			/* Read-only filesystem, can't fix. */
+			if (verbose || debug || fix == CHECK_REPAIR)
+				str_info(ctx, buf,
+_("Read-only filesystem; cannot make changes."));
+			/* fall through */
+		case ENOENT:
+			/* Metadata not present, just skip it. */
+			return true;
+		default:
+			/* Operational error. */
+			str_errno(ctx, buf);
+			return true;
+		}
+	} else if (xfs_scrub_needs_repair(&meta)) {
+fix_offline:
+		/* Corrupt, must fix offline. */
+		str_error(ctx, buf, _("Offline repair required."));
+		return true;
+	} else {
+		/* Clean operation, no corruption detected. */
+		return true;
+	}
+}
+
+struct repair_item {
+	struct list_head	list;
+	unsigned int		type;
+	unsigned long long	ctl;
+	enum check_outcome	fix;
+};
+
+/* Scrub metadata, saving corruption reports for later. */
+static bool
+xfs_scrub_metadata(
+	struct scrub_ctx		*ctx,
+	enum scrub_type			scrub_type,
+	xfs_agnumber_t			agno,
+	struct list_head		*repair_list)
+{
+	const struct scrub_descr	*sc;
+	struct repair_item		*ri;
+	enum check_outcome		fix;
+	int				type;
+	bool				moveon;
+
+	sc = scrubbers;
+	for (type = 0; type <= XFS_SCRUB_TYPE_MAX; type++, sc++) {
+		if (sc->type != scrub_type)
+			continue;
+
+		/* Check the item. */
+		moveon = xfs_check_metadata(ctx, ctx->mnt_fd, type, agno,
+				0, &fix);
+		if (!moveon)
+			return false;
+		if (fix == CHECK_OK)
+			continue;
+
+		/* Schedule this item for later repairs. */
+		ri = malloc(sizeof(struct repair_item));
+		if (!ri) {
+			str_errno(ctx, _("repair list"));
+			return false;
+		}
+		ri->type = type;
+		ri->ctl = agno;
+		ri->fix = fix;
+		list_add_tail(&ri->list, repair_list);
+	}
+
+	return true;
+}
+
+/* Scrub each AG's metadata btrees. */
+bool
+xfs_scrub_ag_metadata(
+	struct scrub_ctx		*ctx,
+	xfs_agnumber_t			agno,
+	struct list_head		*repair_list)
+{
+	return xfs_scrub_metadata(ctx, ST_PERAG, agno, repair_list);
+}
+
+/* Scrub whole-FS metadata btrees. */
+bool
+xfs_scrub_fs_metadata(
+	struct scrub_ctx		*ctx,
+	struct list_head		*repair_list)
+{
+	return xfs_scrub_metadata(ctx, ST_FS, 0, repair_list);
+}
+
+/* Repair everything on this list. */
+bool
+xfs_repair_metadata_list(
+	struct scrub_ctx		*ctx,
+	struct list_head		*repair_list)
+{
+	struct repair_item		*ri;
+	struct repair_item		*n;
+	bool				moveon;
+
+	list_for_each_entry(ri, repair_list, list) {
+		moveon = xfs_repair_metadata(ctx, ctx->mnt_fd, ri->type,
+				ri->ctl, 0, ri->fix);
+		if (!moveon)
+			break;
+	}
+
+	list_for_each_entry_safe(ri, n, repair_list, list) {
+		list_del(&ri->list);
+		free(ri);
+	}
+
+	return !xfs_scrub_excessive_errors(ctx);
+}
+
+/* Scrub inode metadata. */
+static bool
+__xfs_scrub_file(
+	struct scrub_ctx		*ctx,
+	uint64_t			ino,
+	uint32_t			gen,
+	int				fd,
+	unsigned int			type)
+{
+	const struct scrub_descr	*sc;
+	enum check_outcome		fix;
+	bool				moveon;
+
+	assert(type <= XFS_SCRUB_TYPE_MAX);
+	sc = &scrubbers[type];
+	assert(sc->type == ST_INODE);
+
+	/* Scrub the piece of metadata. */
+	moveon = xfs_check_metadata(ctx, fd, type, ino, gen, &fix);
+	if (!moveon || xfs_scrub_excessive_errors(ctx))
+		return false;
+	else if (fix == CHECK_OK)
+		return true;
+
+	/* Repair the metadata. */
+	moveon = xfs_repair_metadata(ctx, fd, type, ino, gen, fix);
+	if (!moveon)
+		return false;
+	return !xfs_scrub_excessive_errors(ctx);
+}
+
+#define XFS_SCRUB_FILE_PART(name, flagname) \
+bool \
+xfs_scrub_##name( \
+	struct scrub_ctx		*ctx, \
+	uint64_t			ino, \
+	uint32_t			gen, \
+	int				fd) \
+{ \
+	return __xfs_scrub_file(ctx, ino, gen, fd, XFS_SCRUB_TYPE_##flagname); \
+}
+XFS_SCRUB_FILE_PART(inode_fields,	INODE)
+XFS_SCRUB_FILE_PART(data_fork,		BMBTD)
+XFS_SCRUB_FILE_PART(attr_fork,		BMBTA)
+XFS_SCRUB_FILE_PART(cow_fork,		BMBTC)
+XFS_SCRUB_FILE_PART(dir,		DIR)
+XFS_SCRUB_FILE_PART(attr,		XATTR)
+XFS_SCRUB_FILE_PART(symlink,		SYMLINK)
+
+/* Test the availability of a kernel scrub command. */
+static bool
+__xfs_scrub_test(
+	struct scrub_ctx		*ctx,
+	unsigned int			type)
+{
+	struct xfs_scrub_metadata	meta = {0};
+	struct xfs_error_injection	inject;
+	static bool			injected;
+	int				error;
+
+	if (debug_tweak_on("XFS_SCRUB_NO_KERNEL"))
+		return false;
+	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !injected) {
+		inject.fd = ctx->mnt_fd;
+#define XFS_ERRTAG_FORCE_REPAIR	28
+		inject.errtag = XFS_ERRTAG_FORCE_REPAIR;
+		error = xfsctl(ctx->mntpoint, ctx->mnt_fd,
+				XFS_IOC_ERROR_INJECTION, &inject);
+		if (error == 0)
+			injected = true;
+	}
+
+	meta.sm_type = type;
+	error = xfsctl(ctx->mntpoint, ctx->mnt_fd, XFS_IOC_SCRUB_METADATA,
+			&meta);
+	return error == 0 || errno == ENOENT;
+}
+
+#define XFS_CAN_SCRUB_TEST(name, flagname) \
+bool \
+xfs_can_scrub_##name( \
+	struct scrub_ctx		*ctx) \
+{ \
+	return __xfs_scrub_test(ctx, XFS_SCRUB_TYPE_##flagname); \
+}
+XFS_CAN_SCRUB_TEST(fs_metadata,		SB)
+XFS_CAN_SCRUB_TEST(inode,		INODE)
+XFS_CAN_SCRUB_TEST(bmap,		BMBTD)
+XFS_CAN_SCRUB_TEST(dir,			DIR)
+XFS_CAN_SCRUB_TEST(attr,		XATTR)
+XFS_CAN_SCRUB_TEST(symlink,		SYMLINK)
diff --git a/scrub/xfs_ioctl.h b/scrub/xfs_ioctl.h
new file mode 100644
index 0000000..c9c2504
--- /dev/null
+++ b/scrub/xfs_ioctl.h
@@ -0,0 +1,84 @@
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
+/* inode iteration */
+typedef bool (*xfs_inode_iter_fn)(struct scrub_ctx *ctx,
+		struct xfs_handle *handle, struct xfs_bstat *bs, void *arg);
+bool xfs_iterate_inodes(struct scrub_ctx *ctx, const char *descr,
+		void *fshandle, uint64_t first_ino, uint64_t last_ino,
+		xfs_inode_iter_fn fn, void *arg);
+bool xfs_can_iterate_inodes(struct scrub_ctx *ctx);
+
+/* inode fork block mapping */
+struct xfs_bmap {
+	uint64_t	bm_offset;	/* file offset of segment in bytes */
+	uint64_t	bm_physical;	/* physical starting byte  */
+	uint64_t	bm_length;	/* length of segment, bytes */
+	uint32_t	bm_flags;	/* output flags */
+};
+
+typedef bool (*xfs_bmap_iter_fn)(struct scrub_ctx *ctx, const char *descr,
+		int fd, int whichfork, struct fsxattr *fsx,
+		struct xfs_bmap *bmap, void *arg);
+
+bool xfs_iterate_bmap(struct scrub_ctx *ctx, const char *descr, int fd,
+		int whichfork, struct xfs_bmap *key, xfs_bmap_iter_fn fn,
+		void *arg);
+bool xfs_can_iterate_bmap(struct scrub_ctx *ctx);
+
+/* filesystem reverse mapping */
+typedef bool (*xfs_fsmap_iter_fn)(struct scrub_ctx *ctx, const char *descr,
+		struct fsmap *fsr, void *arg);
+bool xfs_iterate_fsmap(struct scrub_ctx *ctx, const char *descr,
+		struct fsmap *keys, xfs_fsmap_iter_fn fn, void *arg);
+bool xfs_can_iterate_fsmap(struct scrub_ctx *ctx);
+
+/* Online scrub and repair. */
+
+bool xfs_scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
+		struct list_head *repair_list);
+bool xfs_scrub_fs_metadata(struct scrub_ctx *ctx,
+		struct list_head *repair_list);
+bool xfs_repair_metadata_list(struct scrub_ctx *ctx,
+		struct list_head *repair_list);
+
+bool xfs_can_scrub_fs_metadata(struct scrub_ctx *ctx);
+bool xfs_can_scrub_inode(struct scrub_ctx *ctx);
+bool xfs_can_scrub_bmap(struct scrub_ctx *ctx);
+bool xfs_can_scrub_dir(struct scrub_ctx *ctx);
+bool xfs_can_scrub_attr(struct scrub_ctx *ctx);
+bool xfs_can_scrub_symlink(struct scrub_ctx *ctx);
+
+bool xfs_scrub_inode_fields(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+		int fd);
+bool xfs_scrub_data_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+		 int fd);
+bool xfs_scrub_attr_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+		 int fd);
+bool xfs_scrub_cow_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+		 int fd);
+bool xfs_scrub_dir(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen, int fd);
+bool xfs_scrub_attr(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen, int fd);
+bool xfs_scrub_symlink(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+		 int fd);
+
+#endif /* XFS_IOCTL_H_ */

