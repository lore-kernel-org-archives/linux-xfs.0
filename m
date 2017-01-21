Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20630 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751050AbdAUIJs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Jan 2017 03:09:48 -0500
Subject: [PATCH 13/17] xfs_scrub: create online filesystem scrub program
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 21 Jan 2017 00:09:35 -0800
Message-ID: <148498617585.16675.3947066446614315279.stgit@birch.djwong.org>
In-Reply-To: <148498608472.16675.14848042961636871812.stgit@birch.djwong.org>
References: <148498608472.16675.14848042961636871812.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Create a filesystem scrubbing tool that walks the directory tree,
queries every file's extents, extended attributes, and stat data.  For
generic (non-XFS) filesystems this depends on the kernel to do nearly
all the validation.  Optionally, we can (try to) read all the file
data.

This patch provides some helper components that will be used by the
various backends to walk the metadata, perform media scans, etc.  Actual
filesystem drivers will be in subsequent patches.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 Makefile              |    3 
 configure.ac          |   13 +
 include/builddefs.in  |   13 +
 m4/Makefile           |    1 
 m4/package_attrdev.m4 |   29 +
 m4/package_libcdev.m4 |  140 +++++++
 man/man8/xfs_scrub.8  |  127 ++++++
 scrub/Makefile        |   51 ++
 scrub/bitmap.c        |  425 ++++++++++++++++++++
 scrub/bitmap.h        |   42 ++
 scrub/disk.c          |  285 +++++++++++++
 scrub/disk.h          |   41 ++
 scrub/iocmd.c         |  412 +++++++++++++++++++
 scrub/iocmd.h         |   50 ++
 scrub/read_verify.c   |  314 +++++++++++++++
 scrub/read_verify.h   |   59 +++
 scrub/scrub.c         | 1055 +++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/scrub.h         |  192 +++++++++
 18 files changed, 3251 insertions(+), 1 deletion(-)
 create mode 100644 m4/package_attrdev.m4
 create mode 100644 man/man8/xfs_scrub.8
 create mode 100644 scrub/Makefile
 create mode 100644 scrub/bitmap.c
 create mode 100644 scrub/bitmap.h
 create mode 100644 scrub/disk.c
 create mode 100644 scrub/disk.h
 create mode 100644 scrub/iocmd.c
 create mode 100644 scrub/iocmd.h
 create mode 100644 scrub/read_verify.c
 create mode 100644 scrub/read_verify.h
 create mode 100644 scrub/scrub.c
 create mode 100644 scrub/scrub.h


diff --git a/Makefile b/Makefile
index 3a4872a..e6d79af 100644
--- a/Makefile
+++ b/Makefile
@@ -47,7 +47,7 @@ HDR_SUBDIRS = include libxfs
 DLIB_SUBDIRS = libxlog libxcmd libhandle
 LIB_SUBDIRS = libxfs $(DLIB_SUBDIRS)
 TOOL_SUBDIRS = copy db estimate fsck growfs io logprint mkfs quota \
-		mdrestore repair rtcp m4 man doc debian spaceman
+		mdrestore repair rtcp m4 man doc debian spaceman scrub
 
 ifneq ("$(PKG_PLATFORM)","darwin")
 TOOL_SUBDIRS += fsr
@@ -89,6 +89,7 @@ repair: libxlog libxcmd
 copy: libxlog
 mkfs: libxcmd
 spaceman: libxcmd
+scrub: libhandle libxcmd repair
 
 ifeq ($(HAVE_BUILDDEFS), yes)
 include $(BUILDRULES)
diff --git a/configure.ac b/configure.ac
index 3a4655f..70b5586 100644
--- a/configure.ac
+++ b/configure.ac
@@ -139,8 +139,21 @@ AC_HAVE_MNTENT
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
index 612b547..2f2b9ad 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -109,8 +109,21 @@ HAVE_READDIR = @have_readdir@
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
index 7d5a42d..5ff0713 100644
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
@@ -277,3 +316,104 @@ AC_DEFUN([AC_NEED_INTERNAL_FSXATTR],
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
index 0000000..2aa359b
--- /dev/null
+++ b/scrub/Makefile
@@ -0,0 +1,51 @@
+#
+# Copyright (c) 2017 Oracle.  All Rights Reserved.
+#
+
+TOPDIR = ..
+include $(TOPDIR)/include/builddefs
+
+SCRUB_PREREQS=$(HAVE_FIEMAP)$(HAVE_ATTRIBUTES_H)$(HAVE_ATTRIBUTES_MACROS)$(HAVE_ATTRIBUTES_STRUCTS)$(HAVE_FGETXATTR)$(HAVE_FLISTXATTR)$(HAVE_LLISTXATTR)$(HAVE_OPENAT)$(HAVE_READLINKAT)$(HAVE_FSTATAT)
+
+ifeq ($(SCRUB_PREREQS),yesyesyesyesyesyesyesyesyesyes)
+LTCOMMAND = xfs_scrub
+INSTALL_SCRUB = install-scrub
+endif
+
+HFILES = scrub.h ../repair/threads.h read_verify.h iocmd.h
+CFILES = ../repair/avl64.c disk.c bitmap.c iocmd.c \
+	 read_verify.c scrub.c ../repair/threads.c
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
+install: default $(INSTALL_SCRUB)
+
+install-scrub:
+	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
+
+install-dev:
+
+-include .dep
diff --git a/scrub/bitmap.c b/scrub/bitmap.c
new file mode 100644
index 0000000..0146c49
--- /dev/null
+++ b/scrub/bitmap.c
@@ -0,0 +1,425 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
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
index 0000000..e3702aa
--- /dev/null
+++ b/scrub/bitmap.h
@@ -0,0 +1,42 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
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
index 0000000..c2b158a
--- /dev/null
+++ b/scrub/disk.c
@@ -0,0 +1,285 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
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
+static unsigned int
+__disk_heads(
+	struct disk		*disk)
+{
+	int			iomin;
+	int			ioopt;
+	unsigned short		rot;
+	int			error;
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
+/* Figure out how many disk heads are available. */
+unsigned int
+disk_heads(
+	struct disk		*disk)
+{
+	if (nr_threads < 0)
+		return __disk_heads(disk);
+	return min(__disk_heads(disk), nr_threads);
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
index 0000000..8930075
--- /dev/null
+++ b/scrub/disk.h
@@ -0,0 +1,41 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
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
diff --git a/scrub/iocmd.c b/scrub/iocmd.c
new file mode 100644
index 0000000..de99e1b
--- /dev/null
+++ b/scrub/iocmd.c
@@ -0,0 +1,412 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
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
index 0000000..047e5fc
--- /dev/null
+++ b/scrub/iocmd.h
@@ -0,0 +1,50 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
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
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
new file mode 100644
index 0000000..7a9994e
--- /dev/null
+++ b/scrub/read_verify.c
@@ -0,0 +1,314 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
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
index 0000000..a10ba8c
--- /dev/null
+++ b/scrub/read_verify.h
@@ -0,0 +1,59 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
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
index 0000000..5ed6559
--- /dev/null
+++ b/scrub/scrub.c
@@ -0,0 +1,1055 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
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
+#include "../repair/threads.h"
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
+int				nr_threads = -1;
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
+	fprintf(stderr, _("-j:\tStart no more than this many threads.\n"));
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
+	fprintf(stdout, "%s: ", str);
+	va_start(args, format);
+	vfprintf(stdout, format, args);
+	va_end(args);
+	if (debug)
+		fprintf(stdout, " (%s line %d)", file, line);
+	fprintf(stdout, "\n");
+	fflush(stdout);
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
+		fprintf(stdout, "%s: ", str);
+		va_start(args, format);
+		vfprintf(stdout, format, args);
+		va_end(args);
+		if (debug)
+			fprintf(stdout, " (%s line %d)", file, line);
+		fprintf(stdout, "\n");
+		fflush(stdout);
+	}
+	ctx->preens++;
+	pthread_mutex_unlock(&ctx->lock);
+}
+
+/*
+ * FS-specific scrub operations profiles.
+ * generic_scrub_ops will be selected if nothing else is.
+ */
+static struct scrub_ops *scrub_impl[] = {
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
+	if (nr_threads < 0)
+		return ctx->nr_io_threads;
+	return min(ctx->nr_io_threads, nr_threads);
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
+	error = scrub_getrusage(&pi->ruse);
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
+	if ((verbose || display_rusage) && descr) {
+		fprintf(stdout, _("%s%s\n"), pi->tag, descr);
+		fflush(stdout);
+	}
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
+	error = scrub_getrusage(&ruse_now);
+	if (error) {
+		perror(_("getrusage"));
+		return false;
+	}
+
+#define kbytes(x)	(((unsigned long)(x) + 1023) / 1024)
+#ifdef HAVE_MALLINFO
+
+	mall_now = mallinfo();
+	fprintf(stdout, _("%sMemory used: %luk/%luk (%luk/%luk), "), pi->tag,
+		kbytes(mall_now.arena), kbytes(mall_now.hblkhd),
+		kbytes(mall_now.uordblks), kbytes(mall_now.fordblks));
+#else
+	fprintf(stdout, _("%sMemory used: %luk, "), pi->tag,
+		(unsigned long) kbytes(((char *) sbrk(0)) -
+				       ((char *) pi->brk_start)));
+#endif
+#undef kbytes
+
+	fprintf(stdout, _("time: %5.2f/%5.2f/%5.2fs\n"),
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
+		fprintf(stdout,
+_("%sI/O: %.1f%s in, %.1f%s out, %.1f%s tot\n"),
+			pi->tag, i, iu, o, ou, t, tu);
+		fprintf(stdout,
+_("%sI/O rate: %.1f%s/s in, %.1f%s/s out, %.1f%s/s tot\n"),
+			pi->tag, din, dinu, dout, doutu, dtot, dtotu);
+	}
+
+	/* How many bytes were read-verified? */
+	verified = read_verify_bytes() - pi->verified_bytes;
+	if (verified) {
+		v = auto_space_units(verified, &vu);
+		dv = auto_space_units(verified / dt, &dvu);
+		fprintf(stdout, _("%sVerify: %.1f%s, rate: %.1f%s/s\n"),
+			pi->tag, v, vu, dv, dvu);
+	}
+	fflush(stdout);
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
+	if (verbose) {
+		fprintf(stdout, _("%s: using %d threads to scrub.\n"),
+				ctx->mntpoint, scrub_nproc(ctx));
+		fflush(stdout);
+	}
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
+#define REPAIR_DUMMY_FN		((void *)1)
+#define DATASCAN_DUMMY_FN	((void *)2)
+static bool
+run_scrub_phases(
+	struct scrub_ctx	*ctx)
+{
+	struct scrub_phase	phases[] = {
+		{_("Find filesystem geometry."),   find_geo},
+		{_("Check internal metadata."),	   ctx->ops->scan_metadata},
+		{_("Scan all inodes."),		   ctx->ops->scan_inodes},
+		{_("Check directory structure."),  ctx->ops->scan_fs_tree},
+		{NULL, REPAIR_DUMMY_FN},
+		{_("Verify data file integrity."), DATASCAN_DUMMY_FN},
+		{_("Check summary counters."),	   ctx->ops->check_summary},
+		{NULL, NULL},
+	};
+	struct phase_info	pi;
+	char			buf[DESCR_BUFSZ];
+	struct scrub_phase	*phase;
+	bool			moveon;
+	int			c;
+
+	/* Run all phases of the scrub tool. */
+	for (c = 1, phase = phases; phase->fn; phase++, c++) {
+		/* Inject the repair/preen function. */
+		if (phase->fn == REPAIR_DUMMY_FN) {
+			if (ctx->mode == SCRUB_MODE_PREEN) {
+				phase->descr = _("Preen filesystem.");
+				phase->fn = preen;
+			} else if (ctx->mode == SCRUB_MODE_REPAIR) {
+				phase->descr = _("Repair filesystem.");
+				phase->fn = ctx->ops->repair_fs;
+			}
+		} else if (phase->fn == DATASCAN_DUMMY_FN && scrub_data)
+			phase->fn = ctx->ops->scan_blocks;
+
+		if (phase->fn == REPAIR_DUMMY_FN ||
+		    phase->fn == DATASCAN_DUMMY_FN) {
+			c--;
+			continue;
+		} else if (phase->descr)
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
+	return NULL;
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
+	long			arg;
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
+	while ((c = getopt(argc, argv, "a:de:j:m:nTt:vxVy")) != EOF) {
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
+		case 'j':
+			arg = strtol(optarg, NULL, 10);
+			if (errno || arg < 0 || arg > INT_MAX) {
+				perror("nr_threads");
+				usage();
+			}
+			nr_threads = arg;
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
+			fprintf(stdout, _("%s version %s\n"), progname,
+					VERSION);
+			fflush(stdout);
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
+		ret = 16;
+		goto end;
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
+		ret = 16;
+		goto end;
+	}
+
+	/* Find an appropriate scrub backend. */
+	if (!ctx.ops)
+		ctx.ops = find_ops(ctx.mnt_type);
+	if (verbose) {
+		fprintf(stdout,
+			_("%s: scrubbing %s filesystem with %s driver.\n"),
+			ctx.mntpoint, ctx.mnt_type, ctx.ops->name);
+		fflush(stdout);
+	}
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
+	if (ctx.repairs && ctx.preens)
+		fprintf(stdout,
+_("%s: %lu repairs and %lu optimizations made.\n"),
+			ctx.mntpoint, ctx.repairs, ctx.preens);
+	else if (ctx.repairs && ctx.preens == 0)
+		fprintf(stdout,
+_("%s: %lu repairs made.\n"),
+			ctx.mntpoint, ctx.repairs);
+	else if (ctx.repairs == 0 && ctx.preens)
+		fprintf(stdout,
+_("%s: %lu optimizations made.\n"),
+			ctx.mntpoint, ctx.preens);
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
+end:
+	return ret;
+}
diff --git a/scrub/scrub.h b/scrub/scrub.h
new file mode 100644
index 0000000..442371b
--- /dev/null
+++ b/scrub/scrub.h
@@ -0,0 +1,192 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
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
+extern int			nr_threads;
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

