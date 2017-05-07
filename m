Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:30337 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751922AbdEGWml (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 May 2017 18:42:41 -0400
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v47Fue2S015528
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 7 May 2017 15:56:40 GMT
Subject: [PATCH 3/9] xfs_spaceman: space management tool
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 07 May 2017 08:56:35 -0700
Message-ID: <149417259522.24656.15381603363219279304.stgit@birch.djwong.org>
In-Reply-To: <149417257252.24656.2629280196308754994.stgit@birch.djwong.org>
References: <149417257252.24656.2629280196308754994.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

From: Dave Chinner <dchinner@redhat.com>

xfs_spaceman is intended as a diagnostic and control tool for space
management operations within XFS. Operations like examining free
space, managing allocation policies, issuing block discards on free
space, etc.

The tool is modelled on the xfs_io interface, allowing both
interactive and command line control of the tool, enabling it to be
used in scripts and automated management tools.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[darrick: change xfsctl to ioctl]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 Makefile          |    3 +
 spaceman/Makefile |   34 ++++++++++++
 spaceman/file.c   |  149 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 spaceman/init.c   |  117 ++++++++++++++++++++++++++++++++++++++++++
 spaceman/init.h   |   23 ++++++++
 spaceman/space.h  |   36 +++++++++++++
 6 files changed, 361 insertions(+), 1 deletion(-)
 create mode 100644 spaceman/Makefile
 create mode 100644 spaceman/file.c
 create mode 100644 spaceman/init.c
 create mode 100644 spaceman/init.h
 create mode 100644 spaceman/space.h


diff --git a/Makefile b/Makefile
index ba87327..72d0044 100644
--- a/Makefile
+++ b/Makefile
@@ -47,7 +47,7 @@ HDR_SUBDIRS = include libxfs
 DLIB_SUBDIRS = libxlog libxcmd libhandle
 LIB_SUBDIRS = libxfs $(DLIB_SUBDIRS)
 TOOL_SUBDIRS = copy db estimate fsck growfs io logprint mkfs quota \
-		mdrestore repair rtcp m4 man doc debian
+		mdrestore repair rtcp m4 man doc debian spaceman
 
 ifneq ("$(PKG_PLATFORM)","darwin")
 TOOL_SUBDIRS += fsr
@@ -88,6 +88,7 @@ quota: libxcmd
 repair: libxlog libxcmd
 copy: libxlog
 mkfs: libxcmd
+spaceman: libxcmd
 
 ifeq ($(HAVE_BUILDDEFS), yes)
 include $(BUILDRULES)
diff --git a/spaceman/Makefile b/spaceman/Makefile
new file mode 100644
index 0000000..ff8d23e
--- /dev/null
+++ b/spaceman/Makefile
@@ -0,0 +1,34 @@
+#
+# Copyright (c) 2012 Red Hat, Inc.  All Rights Reserved.
+#
+
+TOPDIR = ..
+include $(TOPDIR)/include/builddefs
+
+LTCOMMAND = xfs_spaceman
+HFILES = init.h space.h
+CFILES = init.c \
+	file.c
+
+LLDLIBS = $(LIBXCMD)
+LTDEPENDENCIES = $(LIBXCMD)
+LLDFLAGS = -static
+
+ifeq ($(ENABLE_READLINE),yes)
+LLDLIBS += $(LIBREADLINE) $(LIBTERMCAP)
+endif
+
+ifeq ($(ENABLE_EDITLINE),yes)
+LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
+endif
+
+default: depend $(LTCOMMAND)
+
+include $(BUILDRULES)
+
+install: default
+	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
+	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
+install-dev:
+
+-include .dep
diff --git a/spaceman/file.c b/spaceman/file.c
new file mode 100644
index 0000000..9356066
--- /dev/null
+++ b/spaceman/file.c
@@ -0,0 +1,149 @@
+/*
+ * Copyright (c) 2004-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2012 Red Hat, Inc.
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
+#include <sys/mman.h>
+#include "command.h"
+#include "input.h"
+#include "init.h"
+#include "space.h"
+
+static cmdinfo_t print_cmd;
+
+fileio_t	*filetable;
+int		filecount;
+fileio_t	*file;
+
+static void
+print_fileio(
+	fileio_t	*file,
+	int		index,
+	int		braces)
+{
+	printf(_("%c%03d%c %-14s (%s,%s,%s%s%s)\n"),
+		braces? '[' : ' ', index, braces? ']' : ' ', file->name,
+		file->flags & O_SYNC ? _("sync") : _("non-sync"),
+		file->flags & O_DIRECT ? _("direct") : _("non-direct"),
+		file->flags & O_RDONLY ? _("read-only") : _("read-write"),
+		file->flags & O_APPEND ? _(",append-only") : "",
+		file->flags & O_NONBLOCK ? _(",non-block") : "");
+}
+
+int
+filelist_f(void)
+{
+	int		i;
+
+	for (i = 0; i < filecount; i++)
+		print_fileio(&filetable[i], i, &filetable[i] == file);
+	return 0;
+}
+
+static int
+print_f(
+	int		argc,
+	char		**argv)
+{
+	filelist_f();
+	return 0;
+}
+
+int
+openfile(
+	char		*path,
+	xfs_fsop_geom_t	*geom,
+	int		flags,
+	mode_t		mode)
+{
+	int		fd;
+
+	fd = open(path, flags, mode);
+	if (fd < 0) {
+		if ((errno == EISDIR) && (flags & O_RDWR)) {
+			/* make it as if we asked for O_RDONLY & try again */
+			flags &= ~O_RDWR;
+			flags |= O_RDONLY;
+			fd = open(path, flags, mode);
+			if (fd < 0) {
+				perror(path);
+				return -1;
+			}
+		} else {
+			perror(path);
+			return -1;
+		}
+	}
+
+	if (ioctl(fd, XFS_IOC_FSGEOMETRY, geom) < 0) {
+		perror("XFS_IOC_FSGEOMETRY");
+		close(fd);
+		return -1;
+	}
+	return fd;
+}
+
+int
+addfile(
+	char		*name,
+	int		fd,
+	xfs_fsop_geom_t	*geometry,
+	int		flags)
+{
+	char		*filename;
+
+	filename = strdup(name);
+	if (!filename) {
+		perror("strdup");
+		close(fd);
+		return -1;
+	}
+
+	/* Extend the table of currently open files */
+	filetable = (fileio_t *)realloc(filetable,	/* growing */
+					++filecount * sizeof(fileio_t));
+	if (!filetable) {
+		perror("realloc");
+		filecount = 0;
+		free(filename);
+		close(fd);
+		return -1;
+	}
+
+	/* Finally, make this the new active open file */
+	file = &filetable[filecount - 1];
+	file->fd = fd;
+	file->flags = flags;
+	file->name = filename;
+	file->geom = *geometry;
+	return 0;
+}
+
+void
+file_init(void)
+{
+	print_cmd.name = "print";
+	print_cmd.altname = "p";
+	print_cmd.cfunc = print_f;
+	print_cmd.argmin = 0;
+	print_cmd.argmax = 0;
+	print_cmd.flags = CMD_FLAG_ONESHOT;
+	print_cmd.oneline = _("list current open files");
+
+	add_command(&print_cmd);
+}
diff --git a/spaceman/init.c b/spaceman/init.c
new file mode 100644
index 0000000..404b183
--- /dev/null
+++ b/spaceman/init.c
@@ -0,0 +1,117 @@
+/*
+ * Copyright (c) 2012 Red Hat, Inc
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
+#include "command.h"
+#include "input.h"
+#include "init.h"
+#include "space.h"
+
+char	*progname;
+int	exitcode;
+
+void
+usage(void)
+{
+	fprintf(stderr,
+		_("Usage: %s [-c cmd] file\n"),
+		progname);
+	exit(1);
+}
+
+static void
+init_commands(void)
+{
+	file_init();
+	help_init();
+	quit_init();
+}
+
+static int
+init_args_command(
+	int	index)
+{
+	if (index >= filecount)
+		return 0;
+	file = &filetable[index++];
+	return index;
+}
+
+static int
+init_check_command(
+	const cmdinfo_t	*ct)
+{
+	if (!(ct->flags & CMD_FLAG_ONESHOT))
+		return 0;
+	return 1;
+}
+
+void
+init(
+	int		argc,
+	char		**argv)
+{
+	int		c, flags = 0;
+	mode_t		mode = 0600;
+	xfs_fsop_geom_t	geometry = { 0 };
+
+	progname = basename(argv[0]);
+	setlocale(LC_ALL, "");
+	bindtextdomain(PACKAGE, LOCALEDIR);
+	textdomain(PACKAGE);
+
+	while ((c = getopt(argc, argv, "c:V")) != EOF) {
+		switch (c) {
+		case 'c':
+			add_user_command(optarg);
+			break;
+		case 'V':
+			printf(_("%s version %s\n"), progname, VERSION);
+			exit(0);
+		default:
+			usage();
+		}
+	}
+
+	if (optind == argc)
+		usage();
+
+	while (optind < argc) {
+		if ((c = openfile(argv[optind], &geometry, flags, mode)) < 0)
+			exit(1);
+		if (!platform_test_xfs_fd(c))
+			printf(_("Not an XFS filesystem!\n"));
+		if (addfile(argv[optind], c, &geometry, flags) < 0)
+			exit(1);
+		optind++;
+	}
+
+	init_commands();
+	add_command_iterator(init_args_command);
+	add_check_command(init_check_command);
+}
+
+int
+main(
+	int	argc,
+	char	**argv)
+{
+	init(argc, argv);
+	command_loop();
+	return exitcode;
+}
diff --git a/spaceman/init.h b/spaceman/init.h
new file mode 100644
index 0000000..165e4f5
--- /dev/null
+++ b/spaceman/init.h
@@ -0,0 +1,23 @@
+/*
+ * Copyright (c) 2012 Red Hat, Inc.
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
+extern char	*progname;
+extern int	exitcode;
+
+#define min(a,b)	(((a)<(b))?(a):(b))
+#define max(a,b)	(((a)>(b))?(a):(b))
diff --git a/spaceman/space.h b/spaceman/space.h
new file mode 100644
index 0000000..6e1bc52
--- /dev/null
+++ b/spaceman/space.h
@@ -0,0 +1,36 @@
+/*
+ * Copyright (c) 2012 Red Hat, Inc.
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
+typedef struct fileio {
+	int		fd;		/* open file descriptor */
+	int		flags;		/* flags describing file state */
+	char		*name;		/* file name at time of open */
+	xfs_fsop_geom_t	geom;		/* XFS filesystem geometry */
+} fileio_t;
+
+extern fileio_t		*filetable;	/* open file table */
+extern int		filecount;	/* number of open files */
+extern fileio_t		*file;		/* active file in file table */
+extern int filelist_f(void);
+
+extern int	openfile(char *, xfs_fsop_geom_t *, int, mode_t);
+extern int	addfile(char *, int , xfs_fsop_geom_t *, int);
+
+extern void	file_init(void);
+extern void	help_init(void);
+extern void	quit_init(void);

