Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31253 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750918AbdFBTv4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2017 15:51:56 -0400
Subject: [PATCH 06/10] xfs_spaceman: add FITRIM support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Jun 2017 12:51:51 -0700
Message-ID: <149643311135.15899.9680513857399078950.stgit@birch.djwong.org>
In-Reply-To: <149643307433.15899.922559884171553380.stgit@birch.djwong.org>
References: <149643307433.15899.922559884171553380.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

From: Dave Chinner <dchinner@redhat.com>

Add support for discarding free space extents via the FITRIM
command. Make it easy to discard a single range, an entire AG or all
the freespace in the filesystem.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 spaceman/Makefile |    2 -
 spaceman/init.c   |    1 
 spaceman/space.h  |    1 
 spaceman/trim.c   |  127 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 130 insertions(+), 1 deletion(-)
 create mode 100644 spaceman/trim.c


diff --git a/spaceman/Makefile b/spaceman/Makefile
index df59edf..c63a4fc 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -7,7 +7,7 @@ include $(TOPDIR)/include/builddefs
 
 LTCOMMAND = xfs_spaceman
 HFILES = init.h space.h
-CFILES = init.c file.c
+CFILES = init.c file.c trim.c
 
 LLDLIBS = $(LIBXCMD)
 LTDEPENDENCIES = $(LIBXCMD)
diff --git a/spaceman/init.c b/spaceman/init.c
index 5dbaef2..0958377 100644
--- a/spaceman/init.c
+++ b/spaceman/init.c
@@ -40,6 +40,7 @@ init_commands(void)
 	file_init();
 	help_init();
 	quit_init();
+	trim_init();
 }
 
 static int
diff --git a/spaceman/space.h b/spaceman/space.h
index 6e1bc52..7b4f034 100644
--- a/spaceman/space.h
+++ b/spaceman/space.h
@@ -34,3 +34,4 @@ extern int	addfile(char *, int , xfs_fsop_geom_t *, int);
 extern void	file_init(void);
 extern void	help_init(void);
 extern void	quit_init(void);
+extern void	trim_init(void);
diff --git a/spaceman/trim.c b/spaceman/trim.c
new file mode 100644
index 0000000..d58f6d1
--- /dev/null
+++ b/spaceman/trim.c
@@ -0,0 +1,127 @@
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
+#include "libxfs.h"
+#include <linux/fs.h>
+#include "command.h"
+#include "init.h"
+#include "space.h"
+#include "input.h"
+
+static cmdinfo_t trim_cmd;
+
+/*
+ * Trim unused space in xfs filesystem.
+ */
+static int
+trim_f(
+	int		argc,
+	char		**argv)
+{
+	struct fstrim_range trim = {0};
+	xfs_agnumber_t	agno = 0;
+	off64_t		offset = 0;
+	ssize_t		length = 0;
+	ssize_t		minlen = 0;
+	int		aflag = 0;
+	int		fflag = 0;
+	int		ret;
+	int		c;
+
+	while ((c = getopt(argc, argv, "a:fm:")) != EOF) {
+		switch (c) {
+		case 'a':
+			aflag = 1;
+			agno = atoi(optarg);
+			break;
+		case 'f':
+			fflag = 1;
+			break;
+		case 'm':
+			minlen = cvtnum(file->geom.blocksize,
+					file->geom.sectsize, argv[optind]);
+			break;
+		default:
+			return command_usage(&trim_cmd);
+		}
+	}
+
+	if (aflag && fflag)
+		return command_usage(&trim_cmd);
+
+	if (optind != argc - 2 && !(aflag || fflag))
+		return command_usage(&trim_cmd);
+	if (optind != argc) {
+		offset = cvtnum(file->geom.blocksize, file->geom.sectsize,
+				argv[optind]);
+		length = cvtnum(file->geom.blocksize, file->geom.sectsize,
+				argv[optind + 1]);
+	} else if (agno) {
+		offset = agno * file->geom.agblocks * file->geom.blocksize;
+		length = file->geom.agblocks * file->geom.blocksize;
+	} else {
+		offset = 0;
+		length = file->geom.datablocks * file->geom.blocksize;
+	}
+
+	trim.start = offset;
+	trim.len = length;
+	trim.minlen = minlen;
+
+	ret = ioctl(file->fd, FITRIM, (unsigned long)&trim);
+	if (ret < 0) {
+		fprintf(stderr, "%s: ioctl(FITRIM) [\"%s\"]: "
+			"%s\n", progname, file->name, strerror(errno));
+		exitcode = 1;
+	}
+	return 0;
+}
+
+static void
+trim_help(void)
+{
+	printf(_(
+"\n"
+"Discard filesystem free space\n"
+"\n"
+"Options: [-m minlen] [-f]|[-a agno]|[offset length]\n"
+"\n"
+" -m minlen     -- skip freespace extents smaller than minlen\n"
+" -f            -- trim all the freespace in the entire filesystem\n"
+" -a agno       -- trim all the freespace in the given AG agno\n"
+" offset length -- trim the freespace in the range {offset, length}\n"
+"\n"));
+
+}
+
+void
+trim_init(void)
+{
+	trim_cmd.name = "trim";
+	trim_cmd.altname = "tr";
+	trim_cmd.cfunc = trim_f;
+	trim_cmd.argmin = 1;
+	trim_cmd.argmax = 4;
+	trim_cmd.args = "[-m minlen] [-f]|[-a agno]|[offset length]";
+	trim_cmd.flags = CMD_FLAG_ONESHOT;
+	trim_cmd.oneline = _("Discard filesystem free space");
+	trim_cmd.help = trim_help;
+
+	add_command(&trim_cmd);
+}
+

