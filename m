Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60168 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCq2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:46:28 -0400
Subject: [PATCH 6/9] xfs_spaceman: add a superblock info command
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:46:09 -0700
Message-ID: <152401956907.13048.9916119316995542280.stgit@magnolia>
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

Add an 'info' command to pretty-print the superblock geometry.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/xfs_spaceman.8 |    7 +++
 spaceman/Makefile       |    2 -
 spaceman/file.c         |    2 +
 spaceman/info.c         |   96 +++++++++++++++++++++++++++++++++++++++++++++++
 spaceman/init.c         |    1 
 spaceman/space.h        |    1 
 6 files changed, 108 insertions(+), 1 deletion(-)
 create mode 100644 spaceman/info.c


diff --git a/man/man8/xfs_spaceman.8 b/man/man8/xfs_spaceman.8
index e4a9137..12dd04e 100644
--- a/man/man8/xfs_spaceman.8
+++ b/man/man8/xfs_spaceman.8
@@ -84,6 +84,13 @@ Display a summary of the free space information found.
 .PD
 .RE
 .TP
+.B info
+Displays selected geometry information about the filesystem.
+The opened file must be a mount point of a XFS filesystem.
+The output will have the same format that
+.BR "xfs_info" "(8)"
+prints when querying a filesystem.
+.TP
 .BR "help [ " command " ]"
 Display a brief description of one or all commands.
 .TP
diff --git a/spaceman/Makefile b/spaceman/Makefile
index 8b31030..c1d903b 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -7,7 +7,7 @@ include $(TOPDIR)/include/builddefs
 
 LTCOMMAND = xfs_spaceman
 HFILES = init.h space.h
-CFILES = init.c file.c prealloc.c trim.c
+CFILES = info.c init.c file.c prealloc.c trim.c
 
 LLDLIBS = $(LIBXCMD) $(LIBFROG)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)
diff --git a/spaceman/file.c b/spaceman/file.c
index 4f9f66c..6adb4f5 100644
--- a/spaceman/file.c
+++ b/spaceman/file.c
@@ -84,6 +84,8 @@ openfile(
 			return -1;
 		}
 		memcpy(fs_path, fsp, sizeof(struct fs_path));
+	} else {
+		memset(fs_path, 0, sizeof(struct fs_path));
 	}
 	return fd;
 }
diff --git a/spaceman/info.c b/spaceman/info.c
new file mode 100644
index 0000000..b8b8133
--- /dev/null
+++ b/spaceman/info.c
@@ -0,0 +1,96 @@
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
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
+#include "command.h"
+#include "init.h"
+#include "path.h"
+#include "space.h"
+#include "fsgeom.h"
+
+static void
+info_help(void)
+{
+	printf(_(
+"\n"
+" Pretty-prints the filesystem geometry as derived from the superblock.\n"
+" The output has the same format as mkfs.  The opened file must be a XFS\n"
+" mount point.\n"
+"\n"
+));
+
+}
+
+static int
+info_f(
+	int			argc,
+	char			**argv)
+{
+	struct xfs_fsop_geom	geo;
+	int			error;
+
+	if (fs_table_lookup_mount(file->name) == NULL) {
+		fprintf(stderr, _("%s: Not a XFS mount point.\n"), file->name);
+		return 1;
+	}
+
+	/* get the current filesystem size & geometry */
+	error = ioctl(file->fd, XFS_IOC_FSGEOMETRY, &geo);
+	if (error) {
+		/*
+		 * OK, new xfsctl barfed - back off and try earlier version
+		 * as we're probably running an older kernel version.
+		 * Only field added in the v2 geometry xfsctl is "logsunit"
+		 * so we'll zero that out for later display (as zero).
+		 */
+		geo.logsunit = 0;
+		error = ioctl(file->fd, XFS_IOC_FSGEOMETRY_V1, &geo);
+		if (error) {
+			fprintf(stderr, _(
+				"%s: cannot determine geometry of filesystem"
+				" mounted at %s: %s\n"),
+				progname, file->name, strerror(errno));
+			exitcode = 1;
+			return 0;
+		}
+	}
+
+	xfs_report_geom(&geo, file->fs_path.fs_name, file->fs_path.fs_log,
+			file->fs_path.fs_rt);
+	return 0;
+}
+
+static const struct cmdinfo info_cmd = {
+	.name =		"info",
+	.altname =	"i",
+	.cfunc =	info_f,
+	.argmin =	0,
+	.argmax =	0,
+	.canpush =	0,
+	.args =		NULL,
+	.flags =	CMD_FLAG_ONESHOT,
+	.oneline =	N_("dump superblock info"),
+	.help =		info_help,
+};
+
+void
+info_init(void)
+{
+	add_command(&info_cmd);
+}
diff --git a/spaceman/init.c b/spaceman/init.c
index b3eface..895504f 100644
--- a/spaceman/init.c
+++ b/spaceman/init.c
@@ -40,6 +40,7 @@ init_commands(void)
 {
 	print_init();
 	help_init();
+	info_init();
 	prealloc_init();
 	quit_init();
 	trim_init();
diff --git a/spaceman/space.h b/spaceman/space.h
index 5f4a8a0..d2a2543 100644
--- a/spaceman/space.h
+++ b/spaceman/space.h
@@ -42,5 +42,6 @@ extern void	freesp_init(void);
 #else
 # define freesp_init()	do { } while (0)
 #endif
+extern void	info_init(void);
 
 #endif /* XFS_SPACEMAN_SPACE_H_ */

