Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41872 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761967AbdKQVAU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 16:00:20 -0500
Subject: [PATCH 01/27] xfs_scrub: create online filesystem scrub program
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 13:00:15 -0800
Message-ID: <151095241570.4825.1519246213724559939.stgit@magnolia>
In-Reply-To: <151095240950.4825.6375172010231614655.stgit@magnolia>
References: <151095240950.4825.6375172010231614655.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create the foundations of a filesystem scrubbing tool that asks the
kernel to inspect all metadata in the filesystem and (ultimately) to
repair anything that's broken.  Also create the man page for the
utility.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .gitignore           |    1 
 Makefile             |    3 +
 man/man8/xfs_scrub.8 |  117 ++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/Makefile       |   42 ++++++++++++++++++
 scrub/common.c       |   20 +++++++++
 scrub/common.h       |   23 ++++++++++
 scrub/xfs_scrub.c    |  109 +++++++++++++++++++++++++++++++++++++++++++++++
 scrub/xfs_scrub.h    |   23 ++++++++++
 8 files changed, 337 insertions(+), 1 deletion(-)
 create mode 100644 man/man8/xfs_scrub.8
 create mode 100644 scrub/Makefile
 create mode 100644 scrub/common.c
 create mode 100644 scrub/common.h
 create mode 100644 scrub/xfs_scrub.c
 create mode 100644 scrub/xfs_scrub.h


diff --git a/.gitignore b/.gitignore
index e839e2a..a3db640 100644
--- a/.gitignore
+++ b/.gitignore
@@ -68,6 +68,7 @@ cscope.*
 /repair/xfs_repair
 /rtcp/xfs_rtcp
 /spaceman/xfs_spaceman
+/scrub/xfs_scrub
 
 # generated crc files
 /libxfs/crc32selftest
diff --git a/Makefile b/Makefile
index 0dce80a..3bd0796 100644
--- a/Makefile
+++ b/Makefile
@@ -48,7 +48,7 @@ LIBFROG_SUBDIR = libfrog
 DLIB_SUBDIRS = libxlog libxcmd libhandle
 LIB_SUBDIRS = libxfs $(DLIB_SUBDIRS)
 TOOL_SUBDIRS = copy db estimate fsck growfs io logprint mkfs quota \
-		mdrestore repair rtcp m4 man doc debian spaceman
+		mdrestore repair rtcp m4 man doc debian spaceman scrub
 
 ifneq ("$(PKG_PLATFORM)","darwin")
 TOOL_SUBDIRS += fsr
@@ -91,6 +91,7 @@ repair: libxlog libxcmd
 copy: libxlog
 mkfs: libxcmd
 spaceman: libxcmd
+scrub: libhandle libxcmd
 
 ifeq ($(HAVE_BUILDDEFS), yes)
 include $(BUILDRULES)
diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
new file mode 100644
index 0000000..95f4fea
--- /dev/null
+++ b/man/man8/xfs_scrub.8
@@ -0,0 +1,117 @@
+.TH xfs_scrub 8
+.SH NAME
+xfs_scrub \- scrub the contents of an XFS filesystem
+.SH SYNOPSIS
+.B xfs_scrub
+[
+.B \-abemnTvVxy
+]
+.I mount-point
+.br
+.B xfs_scrub \-V
+.SH DESCRIPTION
+.B xfs_scrub
+attempts to check and repair all metadata in a mounted XFS filesystem.
+.PP
+.B xfs_scrub
+asks the kernel to scrub all metadata objects in the filesystem.
+Metadata records are scanned for obviously bad values and then
+cross-referenced against other metadata.
+The goal is to establish a threasonable confidence about the consistency
+of the overall filesystem by examining the consistency of individual
+metadata records against the other metadata in the filesystem across the
+entire filesystem.
+Damaged metadata can be rebuilt from other metadata if there is
+sufficient redundancy (and no other corruption) in the metadata.
+.PP
+This utility does not know how to correct all errors.
+If the tool cannot fix the detected errors, you must unmount the
+filesystem and run
+.B xfs_repair
+to fix the problems.
+If this tool is not run with either of the
+.B \-n
+or
+.B \-y
+options, then it will optimize the filesystem when possible,
+but it will not try to fix errors.
+.SH OPTIONS
+.TP
+.BI \-a " errors"
+Abort if more than this many errors are found on the filesystem.
+.TP
+.B \-b
+Run in background mode.
+If the option is specified once, only run a single scrubbing thread at a
+time.
+If given more than once, an artificial delay of 100us is added to each
+scrub call to reduce CPU overhead even further.
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
+Dry run, do not modify anything in the filesystem.
+This disables all preening and optimization behaviors, and disables
+calling FITRIM on the free space after a successful run.
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
+Scrub all file data too.
+The block list will be sorted in disk order for better performance.
+.B xfs_scrub
+will issue O_DIRECT reads to the block device directly.
+If the block device is a SCSI disk, it will issue READ VERIFY commands
+directly to the disk.
+.TP
+.B \-y
+Try to repair all filesystem errors.
+If the errors cannot be fixed online, then the filesystem must be taken
+offline for repair.
+.SH EXIT CODE
+The exit code returned by
+.B xfs_scrub
+is the sum of the following conditions:
+.br
+\	0\	\-\ No errors
+.br
+\	1\	\-\ File system errors left uncorrected
+.br
+\	2\	\-\ File system optimizations possible
+.br
+\	4\	\-\ Operational error
+.br
+\	8\	\-\ Usage or syntax error
+.br
+.SH CAVEATS
+.B xfs_scrub
+is an immature utility!
+This program takes advantage of in-kernel scrubbing to verify a given
+data structure with locks held.
+The kernel must support the BULKSTAT, FSGEOMETRY, FSCOUNTS, GET_RESBLKS,
+GETBMAPX, GETFSMAP, INUMBERS, and SCRUB_METADATA ioctls.
+This can tie up the system for a while.
+.PP
+If errors are found and cannot be repaired, the filesystem must be taken
+offline and repaired.
+.SH SEE ALSO
+.BR xfs_repair (8).
diff --git a/scrub/Makefile b/scrub/Makefile
new file mode 100644
index 0000000..204b0a1
--- /dev/null
+++ b/scrub/Makefile
@@ -0,0 +1,42 @@
+#
+# Copyright (c) 2017 Oracle.  All Rights Reserved.
+#
+
+TOPDIR = ..
+include $(TOPDIR)/include/builddefs
+
+# On linux we get fsmap from the system or define it ourselves
+# so include this based on platform type.  If this reverts to only
+# the autoconf check w/o local definition, change to testing HAVE_GETFSMAP
+SCRUB_PREREQS=$(PKG_PLATFORM)
+
+ifeq ($(SCRUB_PREREQS),linux)
+LTCOMMAND = xfs_scrub
+INSTALL_SCRUB = install-scrub
+endif	# scrub_prereqs
+
+HFILES = \
+common.h \
+xfs_scrub.h
+
+CFILES = \
+common.c \
+xfs_scrub.c
+
+LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD)
+LTDEPENDENCIES += $(LIBHANDLE) $(LIBFROG)
+LLDFLAGS = -static
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
diff --git a/scrub/common.c b/scrub/common.c
new file mode 100644
index 0000000..57ad182
--- /dev/null
+++ b/scrub/common.c
@@ -0,0 +1,20 @@
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
+#include "common.h"
diff --git a/scrub/common.h b/scrub/common.h
new file mode 100644
index 0000000..f29e4d3
--- /dev/null
+++ b/scrub/common.h
@@ -0,0 +1,23 @@
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
+#ifndef XFS_SCRUB_COMMON_H_
+#define XFS_SCRUB_COMMON_H_
+
+#endif /* XFS_SCRUB_COMMON_H_ */
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
new file mode 100644
index 0000000..6344428
--- /dev/null
+++ b/scrub/xfs_scrub.c
@@ -0,0 +1,109 @@
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
+#include <stdio.h>
+#include "xfs_scrub.h"
+
+/*
+ * XFS Online Metadata Scrub (and Repair)
+ *
+ * The XFS scrubber uses custom XFS ioctls to probe more deeply into the
+ * internals of the filesystem.  It takes advantage of scrubbing ioctls
+ * to check all the records stored in a metadata object and to
+ * cross-reference those records against the other filesystem metadata.
+ *
+ * After the program gathers command line arguments to figure out
+ * exactly what the user wants the program is going to do, scrub
+ * execution is split up into several separate phases:
+ *
+ * The "find geometry" phase queries XFS for the filesystem geometry.
+ * The block devices for the data, realtime, and log devices are opened.
+ * Kernel ioctls are test-queried to see if they actually work (the scrub
+ * ioctl in particular), and any other filesystem-specific information
+ * is gathered.
+ *
+ * In the "check internal metadata" phase, we call the metadata scrub
+ * ioctl to check the filesystem's internal per-AG btrees.  This
+ * includes the AG superblock, AGF, AGFL, and AGI headers, freespace
+ * btrees, the regular and free inode btrees, the reverse mapping
+ * btrees, and the reference counting btrees.  If the realtime device is
+ * enabled, the realtime bitmap and reverse mapping btrees are enabled.
+ * Quotas, if enabled, are also checked in this phase.
+ *
+ * Each AG (and the realtime device) has its metadata checked in a
+ * separate thread for better performance.  Errors in the internal
+ * metadata can be fixed here prior to the inode scan; refer to the
+ * section about the "repair filesystem" phase for more information.
+ *
+ * The "scan all inodes" phase uses BULKSTAT to scan all the inodes in
+ * an AG in disk order.  The BULKSTAT information provides enough
+ * information to construct a file handle that is used to check the
+ * following parts of every file:
+ *
+ *  - The inode record
+ *  - All three block forks (data, attr, CoW)
+ *  - If it's a symlink, the symlink target.
+ *  - If it's a directory, the directory entries.
+ *  - All extended attributes
+ *  - The parent pointer
+ *
+ * Multiple threads are started to check each the inodes of each AG in
+ * parallel.  Errors in file metadata can be fixed here; see the section
+ * about the "repair filesystem" phase for more information.
+ *
+ * Next comes the (configurable) "repair filesystem" phase.  The user
+ * can instruct this program to fix all problems encountered; to fix
+ * only optimality problems and leave the corruptions; or not to touch
+ * the filesystem at all.  Any metadata repairs that did not succeed in
+ * the previous two phases are retried here; if there are uncorrectable
+ * errors, xfs_scrub stops here.
+ *
+ * The next phase is the "check directory tree" phase.  In this phase,
+ * every directory is opened (via file handle) to confirm that each
+ * directory is connected to the root.  Directory entries are checked
+ * for ambiguous Unicode normalization mappings, which is to say that we
+ * look for pairs of entries whose utf-8 strings normalize to the same
+ * code point sequence and map to different inodes, because that could
+ * be used to trick a user into opening the wrong file.  The names of
+ * extended attributes are checked for Unicode normalization collisions.
+ *
+ * In the "verify data file integrity" phase, we employ GETFSMAP to read
+ * the reverse-mappings of all AGs and issue direct-reads of the
+ * underlying disk blocks.  We rely on the underlying storage to have
+ * checksummed the data blocks appropriately.  Multiple threads are
+ * started to check each AG in parallel; a separate thread pool is used
+ * to handle the direct reads.
+ *
+ * In the "check summary counters" phase, use GETFSMAP to tally up the
+ * blocks and BULKSTAT to tally up the inodes we saw and compare that to
+ * the statfs output.  This gives the user a rough estimate of how
+ * thorough the scrub was.
+ */
+
+/* Program name; needed for libxcmd error reports. */
+char				*progname = "xfs_scrub";
+
+int
+main(
+	int			argc,
+	char			**argv)
+{
+	fprintf(stderr, "XXX: This program is not complete!\n");
+	return 4;
+}
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
new file mode 100644
index 0000000..f1ce4d2
--- /dev/null
+++ b/scrub/xfs_scrub.h
@@ -0,0 +1,23 @@
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
+#ifndef XFS_SCRUB_XFS_SCRUB_H_
+#define XFS_SCRUB_XFS_SCRUB_H_
+
+#endif /* XFS_SCRUB_XFS_SCRUB_H_ */

