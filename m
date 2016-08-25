Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 85F778243
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:52:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3B1888F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:52:19 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id ZRMOForUgDKuytAE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:52:16 -0700 (PDT)
Subject: [PATCH 52/71] xfs_io: get and set the CoW extent size hint
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:52:06 -0700
Message-ID: <147216912656.4420.10505137543136479814.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
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

Enable administrators to get or set the CoW extent size hint.
Report the hint when we run stat.  This also requires some
autoconf magic to detect whether or not fsx_cowextsize exists.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure.ac          |    1 
 include/builddefs.in  |    4 +
 io/Makefile           |    5 +
 io/attr.c             |    8 ++
 io/cowextsize.c       |  202 +++++++++++++++++++++++++++++++++++++++++++++++++
 io/init.c             |    1 
 io/io.h               |    6 +
 io/open.c             |    3 +
 m4/package_libcdev.m4 |   26 ++++++
 man/man8/xfs_io.8     |   16 ++++
 10 files changed, 271 insertions(+), 1 deletion(-)
 create mode 100644 io/cowextsize.c


diff --git a/configure.ac b/configure.ac
index 66a562f..875d4bb 100644
--- a/configure.ac
+++ b/configure.ac
@@ -134,6 +134,7 @@ AC_HAVE_FLS
 AC_HAVE_READDIR
 AC_HAVE_FSETXATTR
 AC_HAVE_MREMAP
+AC_HAVE_FSXATTR_COWEXTSIZE
 
 if test "$enable_blkid" = yes; then
 AC_HAVE_BLKID_TOPO
diff --git a/include/builddefs.in b/include/builddefs.in
index fd7eb74..165fa78 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -109,6 +109,7 @@ HAVE_MNTENT = @have_mntent@
 HAVE_FLS = @have_fls@
 HAVE_FSETXATTR = @have_fsetxattr@
 HAVE_MREMAP = @have_mremap@
+HAVE_FSXATTR_COWEXTSIZE = @have_fsxattr_cowextsize@
 ENABLE_INTERNAL_FSXATTR = @enable_internal_fsxattr@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
@@ -149,6 +150,9 @@ endif
 ifeq ($(ENABLE_BLKID),yes)
 PCFLAGS+= -DENABLE_BLKID
 endif
+ifeq ($(HAVE_FSXATTR_COWEXTSIZE),yes)
+PCFLAGS+= -DHAVE_FSXATTR_COWEXTSIZE
+endif
 ifeq ($(ENABLE_INTERNAL_FSXATTR),yes)
 PCFLAGS+= -DOVERRIDE_SYSTEM_FSXATTR
 endif
diff --git a/io/Makefile b/io/Makefile
index 62bc03b..1997ca9 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -99,6 +99,11 @@ ifeq ($(HAVE_MREMAP),yes)
 LCFLAGS += -DHAVE_MREMAP
 endif
 
+ifeq ($(HAVE_FSXATTR_COWEXTSIZE),yes)
+CFILES += cowextsize.c
+# -DHAVE_FSXATTR_COWEXTSIZE already set in PCFLAGS
+endif
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/io/attr.c b/io/attr.c
index 0186b1d..13bec73 100644
--- a/io/attr.c
+++ b/io/attr.c
@@ -48,9 +48,11 @@ static struct xflags {
 	{ FS_XFLAG_NODEFRAG,		"f", "no-defrag"	},
 	{ FS_XFLAG_FILESTREAM,		"S", "filestream"	},
 	{ FS_XFLAG_DAX,			"x", "dax"		},
+	{ FS_XFLAG_REFLINK,		"R", "reflink"		},
+	{ FS_XFLAG_COWEXTSIZE,		"C", "cowextsize"	},
 	{ 0, NULL, NULL }
 };
-#define CHATTR_XFLAG_LIST	"r"/*p*/"iasAdtPneEfSx"
+#define CHATTR_XFLAG_LIST	"r"/*p*/"iasAdtPneEfSxRC"
 
 static void
 lsattr_help(void)
@@ -75,6 +77,8 @@ lsattr_help(void)
 " f -- do not include this file when defragmenting the filesystem\n"
 " S -- enable filestreams allocator for this directory\n"
 " x -- Use direct access (DAX) for data in this file\n"
+" R -- file data blocks may be shared with another file\n"
+" C -- for files with shared blocks, observe the inode CoW extent size value\n"
 "\n"
 " Options:\n"
 " -R -- recursively descend (useful when current file is a directory)\n"
@@ -111,6 +115,8 @@ chattr_help(void)
 " +/-f -- set/clear the no-defrag flag\n"
 " +/-S -- set/clear the filestreams allocator flag\n"
 " +/-x -- set/clear the direct access (DAX) flag\n"
+" +/-R -- set/clear the reflink flag\n"
+" +/-C -- set/clear the CoW extent-size flag\n"
 " Note1: user must have certain capabilities to modify immutable/append-only.\n"
 " Note2: immutable/append-only files cannot be deleted; removing these files\n"
 "        requires the immutable/append-only flag to be cleared first.\n"
diff --git a/io/cowextsize.c b/io/cowextsize.c
new file mode 100644
index 0000000..b4a1c2e
--- /dev/null
+++ b/io/cowextsize.c
@@ -0,0 +1,202 @@
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
+/*
+ * If configure didn't find a struct fsxattr with fsx_cowextsize,
+ * disable the only other source (so far) of struct fsxattr.  Thus,
+ * build with the internal definition of struct fsxattr, which has
+ * fsx_cowextsize.
+ */
+#include "platform_defs.h"
+#include "command.h"
+#include "init.h"
+#include "io.h"
+#include "input.h"
+#include "path.h"
+
+static cmdinfo_t cowextsize_cmd;
+static long cowextsize;
+
+static void
+cowextsize_help(void)
+{
+	printf(_(
+"\n"
+" report or modify preferred CoW extent size (in bytes) for the current path\n"
+"\n"
+" -R -- recursively descend (useful when current path is a directory)\n"
+" -D -- recursively descend, only modifying cowextsize on directories\n"
+"\n"));
+}
+
+static int
+get_cowextsize(const char *path, int fd)
+{
+	struct fsxattr	fsx;
+
+	if ((xfsctl(path, fd, XFS_IOC_FSGETXATTR, &fsx)) < 0) {
+		printf("%s: XFS_IOC_FSGETXATTR %s: %s\n",
+			progname, path, strerror(errno));
+		return 0;
+	}
+	printf("[%u] %s\n", fsx.fsx_cowextsize, path);
+	return 0;
+}
+
+static int
+set_cowextsize(const char *path, int fd, long extsz)
+{
+	struct fsxattr	fsx;
+	struct stat64	stat;
+
+	if (fstat64(fd, &stat) < 0) {
+		perror("fstat64");
+		return 0;
+	}
+	if ((xfsctl(path, fd, XFS_IOC_FSGETXATTR, &fsx)) < 0) {
+		printf("%s: XFS_IOC_FSGETXATTR %s: %s\n",
+			progname, path, strerror(errno));
+		return 0;
+	}
+
+	if (S_ISREG(stat.st_mode) || S_ISDIR(stat.st_mode)) {
+		fsx.fsx_xflags |= FS_XFLAG_COWEXTSIZE;
+	} else {
+		printf(_("invalid target file type - file %s\n"), path);
+		return 0;
+	}
+	fsx.fsx_cowextsize = extsz;
+
+	if ((xfsctl(path, fd, XFS_IOC_FSSETXATTR, &fsx)) < 0) {
+		printf("%s: XFS_IOC_FSSETXATTR %s: %s\n",
+			progname, path, strerror(errno));
+		return 0;
+	}
+
+	return 0;
+}
+
+static int
+get_cowextsize_callback(
+	const char		*path,
+	const struct stat	*stat,
+	int			status,
+	struct FTW		*data)
+{
+	int			fd;
+
+	if (recurse_dir && !S_ISDIR(stat->st_mode))
+		return 0;
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0) {
+		fprintf(stderr, _("%s: cannot open %s: %s\n"),
+			progname, path, strerror(errno));
+	} else {
+		get_cowextsize(path, fd);
+		close(fd);
+	}
+	return 0;
+}
+
+static int
+set_cowextsize_callback(
+	const char		*path,
+	const struct stat	*stat,
+	int			status,
+	struct FTW		*data)
+{
+	int			fd;
+
+	if (recurse_dir && !S_ISDIR(stat->st_mode))
+		return 0;
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0) {
+		fprintf(stderr, _("%s: cannot open %s: %s\n"),
+			progname, path, strerror(errno));
+	} else {
+		set_cowextsize(path, fd, cowextsize);
+		close(fd);
+	}
+	return 0;
+}
+
+static int
+cowextsize_f(
+	int		argc,
+	char		**argv)
+{
+	size_t			blocksize, sectsize;
+	int			c;
+
+	recurse_all = recurse_dir = 0;
+	init_cvtnum(&blocksize, &sectsize);
+	while ((c = getopt(argc, argv, "DR")) != EOF) {
+		switch (c) {
+		case 'D':
+			recurse_all = 0;
+			recurse_dir = 1;
+			break;
+		case 'R':
+			recurse_all = 1;
+			recurse_dir = 0;
+			break;
+		default:
+			return command_usage(&cowextsize_cmd);
+		}
+	}
+
+	if (optind < argc) {
+		cowextsize = (long)cvtnum(blocksize, sectsize, argv[optind]);
+		if (cowextsize < 0) {
+			printf(_("non-numeric cowextsize argument -- %s\n"),
+				argv[optind]);
+			return 0;
+		}
+	} else {
+		cowextsize = -1;
+	}
+
+	if (recurse_all || recurse_dir)
+		nftw(file->name, (cowextsize >= 0) ?
+			set_cowextsize_callback : get_cowextsize_callback,
+			100, FTW_PHYS | FTW_MOUNT | FTW_DEPTH);
+	else if (cowextsize >= 0)
+		set_cowextsize(file->name, file->fd, cowextsize);
+	else
+		get_cowextsize(file->name, file->fd);
+	return 0;
+}
+
+void
+cowextsize_init(void)
+{
+	cowextsize_cmd.name = "cowextsize";
+	cowextsize_cmd.cfunc = cowextsize_f;
+	cowextsize_cmd.args = _("[-D | -R] [cowextsize]");
+	cowextsize_cmd.argmin = 0;
+	cowextsize_cmd.argmax = -1;
+	cowextsize_cmd.flags = CMD_NOMAP_OK;
+	cowextsize_cmd.oneline =
+		_("get/set preferred CoW extent size (in bytes) for the open file");
+	cowextsize_cmd.help = cowextsize_help;
+
+	add_command(&cowextsize_cmd);
+}
diff --git a/io/init.c b/io/init.c
index efe7390..6b88cc6 100644
--- a/io/init.c
+++ b/io/init.c
@@ -85,6 +85,7 @@ init_commands(void)
 	sync_range_init();
 	truncate_init();
 	reflink_init();
+	cowextsize_init();
 }
 
 static int
diff --git a/io/io.h b/io/io.h
index 2bc7ac4..4264e4d 100644
--- a/io/io.h
+++ b/io/io.h
@@ -169,3 +169,9 @@ extern void		readdir_init(void);
 #endif
 
 extern void		reflink_init(void);
+
+#ifdef HAVE_FSXATTR_COWEXTSIZE
+extern void		cowextsize_init(void);
+#else
+#define cowextsize_init()	do { } while (0)
+#endif
diff --git a/io/open.c b/io/open.c
index a5d465a..9a3563c 100644
--- a/io/open.c
+++ b/io/open.c
@@ -125,6 +125,9 @@ stat_f(
 		printxattr(fsx.fsx_xflags, verbose, 0, file->name, 1, 1);
 		printf(_("fsxattr.projid = %u\n"), fsx.fsx_projid);
 		printf(_("fsxattr.extsize = %u\n"), fsx.fsx_extsize);
+#if defined HAVE_FSXATTR_COWEXTSIZE
+		printf(_("fsxattr.cowextsize = %u\n"), fsx.fsx_cowextsize);
+#endif
 		printf(_("fsxattr.nextents = %u\n"), fsx.fsx_nextents);
 		printf(_("fsxattr.naextents = %u\n"), fsxa.fsx_nextents);
 	}
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 7a847e9..45954c2 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -265,3 +265,29 @@ AC_DEFUN([AC_HAVE_MREMAP],
        )
     AC_SUBST(have_mremap)
   ])
+
+#
+# Check if we have a struct fsxattr with a fsx_cowextsize field.
+# If linux/fs.h has a struct with that field, then we're ok.
+# If we can't find fsxattr in linux/fs.h at all, the internal
+# definitions provide it, and we're ok.
+#
+# The only way we won't have this is if the kernel headers don't
+# have the field.
+#
+AC_DEFUN([AC_HAVE_FSXATTR_COWEXTSIZE],
+  [ AM_CONDITIONAL([INTERNAL_FSXATTR], [test "x$enable_internal_fsxattr" = xyes])
+    AM_COND_IF([INTERNAL_FSXATTR],
+    [have_fsxattr_cowextsize=yes],
+    [ AC_CHECK_TYPE(struct fsxattr,
+	  [AC_CHECK_MEMBER(struct fsxattr.fsx_cowextsize,
+		  have_fsxattr_cowextsize=yes,
+		  have_fsxattr_cowextsize=no,
+		  [#include <linux/fs.h>]
+          )],
+	  have_fsxattr_cowextsize=yes,
+	  [#include <linux/fs.h>]
+      )
+    ])
+    AC_SUBST(have_fsxattr_cowextsize)
+  ])
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index d089524..2365550 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -283,6 +283,22 @@ The
 should be specified in bytes, or using one of the usual units suffixes
 (k, m, g, b, etc). The extent size is always reported in units of bytes.
 .TP
+.BI "cowextsize [ \-R | \-D ] [ " value " ]"
+Display and/or modify the preferred copy-on-write extent size used
+when allocating space for the currently open file. If the
+.B \-R
+option is specified, a recursive descent is performed
+for all directory entries below the currently open file
+.RB ( \-D
+can be used to restrict the output to directories only).
+If the target file is a directory, then the inherited CoW extent size
+is set for that directory (new files created in that directory
+inherit that CoW extent size).
+The
+.I value
+should be specified in bytes, or using one of the usual units suffixes
+(k, m, g, b, etc). The extent size is always reported in units of bytes.
+.TP
 .BI "allocsp " size " 0"
 Sets the size of the file to
 .I size

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
