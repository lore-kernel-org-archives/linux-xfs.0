Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44994 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161154AbeCATOa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Mar 2018 14:14:30 -0500
Subject: [PATCH 13/16] xfs_spaceman: add a superblock info command
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 01 Mar 2018 11:14:25 -0800
Message-ID: <151993166571.22223.1007045632935827956.stgit@magnolia>
In-Reply-To: <151993157539.22223.6269629008244777191.stgit@magnolia>
References: <151993157539.22223.6269629008244777191.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add an 'info' command to pretty-print the superblock geometry.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/xfs_spaceman.8 |    6 +++
 spaceman/Makefile       |    2 +
 spaceman/info.c         |   90 +++++++++++++++++++++++++++++++++++++++++++++++
 spaceman/init.c         |    1 +
 spaceman/space.h        |    1 +
 5 files changed, 99 insertions(+), 1 deletion(-)
 create mode 100644 spaceman/info.c


diff --git a/man/man8/xfs_spaceman.8 b/man/man8/xfs_spaceman.8
index e4a9137..95c241c 100644
--- a/man/man8/xfs_spaceman.8
+++ b/man/man8/xfs_spaceman.8
@@ -84,6 +84,12 @@ Display a summary of the free space information found.
 .PD
 .RE
 .TP
+.B info
+Displays selected geometry information about the filesystem.
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
diff --git a/spaceman/info.c b/spaceman/info.c
new file mode 100644
index 0000000..6557b54
--- /dev/null
+++ b/spaceman/info.c
@@ -0,0 +1,90 @@
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
+" The output has the same format as mkfs.\n"
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

