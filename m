Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6PMV97w179617 for <xfs@oss.sgi.com>; Wed, 25 Jul 2012 17:31:09 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Z76F7qhyC6G8qaoV for <xfs@oss.sgi.com>;
	Wed, 25 Jul 2012 15:31:07 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuA6X-0006Zs-Sm
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 08:30:53 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuA6X-0007Rd-MS
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 08:30:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] xfs_io: add sync_file_range support
Date: Thu, 26 Jul 2012 08:30:48 +1000
Message-Id: <1343255450-28559-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1343255450-28559-1-git-send-email-david@fromorbit.com>
References: <1343255450-28559-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Add sync_file_range support to xfs_io to allow fine grained control
of data writeback and syncing on a given file.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 io/Makefile          |    5 +++
 io/init.c            |    1 +
 io/io.h              |    6 +++
 io/sync_file_range.c |  107 ++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_io.8    |   19 +++++++++
 5 files changed, 138 insertions(+)
 create mode 100644 io/sync_file_range.c

diff --git a/io/Makefile b/io/Makefile
index 9d79dca..bf46d56 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -58,6 +58,11 @@ CFILES += inject.c resblks.c
 LCFLAGS += -DHAVE_INJECT -DHAVE_RESBLKS
 endif
 
+ifeq ($(PKG_PLATFORM),linux)
+CFILES += sync_file_range.c
+LCFLAGS += -DHAVE_SYNC_FILE_RANGE
+endif
+
 ifeq ($(ENABLE_READLINE),yes)
 LLDLIBS += $(LIBREADLINE) $(LIBTERMCAP)
 endif
diff --git a/io/init.c b/io/init.c
index f416acf..fb93082 100644
--- a/io/init.c
+++ b/io/init.c
@@ -78,6 +78,7 @@ init_commands(void)
 	sendfile_init();
 	shutdown_init();
 	truncate_init();
+	sync_range_init();
 }
 
 static int
diff --git a/io/io.h b/io/io.h
index 2923362..8151b7b 100644
--- a/io/io.h
+++ b/io/io.h
@@ -141,3 +141,9 @@ extern void		fiemap_init(void);
 #else
 #define fiemap_init()	do { } while (0)
 #endif
+
+#ifdef HAVE_SYNC_FILE_RANGE
+extern void		sync_range_init(void);
+#else
+#define sync_range_init()	do { } while (0)
+#endif
diff --git a/io/sync_file_range.c b/io/sync_file_range.c
new file mode 100644
index 0000000..35d8cc5
--- /dev/null
+++ b/io/sync_file_range.c
@@ -0,0 +1,107 @@
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
+#include <xfs/xfs.h>
+#include <xfs/command.h>
+#include <xfs/input.h>
+#include "init.h"
+#include "io.h"
+
+static cmdinfo_t sync_range_cmd;
+
+static void
+sync_range_help(void)
+{
+	printf(_(
+"\n"
+" Trigger specific writeback commands on a range of the current file\n"
+"\n"
+" With no options, the SYNC_FILE_RANGE_WRITE is implied.\n"
+" -a -- wait for IO to finish after writing (SYNC_FILE_RANGE_WAIT_AFTER).\n"
+" -b -- wait for IO to finish before writing (SYNC_FILE_RANGE_WAIT_BEFORE).\n"
+" -w -- write dirty data in range (SYNC_FILE_RANGE_WRITE).\n"
+"\n"));
+}
+
+static int
+sync_range_f(
+	int		argc,
+	char		**argv)
+{
+	off64_t		offset = 0, length = 0;
+	int		c, sync_mode = 0;
+	size_t		blocksize, sectsize;
+
+	while ((c = getopt(argc, argv, "abw")) != EOF) {
+		switch (c) {
+		case 'a':
+			sync_mode = SYNC_FILE_RANGE_WAIT_AFTER;
+			break;
+		case 'b':
+			sync_mode = SYNC_FILE_RANGE_WAIT_BEFORE;
+			break;
+		case 'w':
+			sync_mode = SYNC_FILE_RANGE_WRITE;
+			break;
+		default:
+			return command_usage(&sync_range_cmd);
+		}
+	}
+
+	/* default to just starting writeback on the range */
+	if (!sync_mode)
+		sync_mode = SYNC_FILE_RANGE_WRITE;
+
+	if (optind != argc - 2)
+		return command_usage(&sync_range_cmd);
+	init_cvtnum(&blocksize, &sectsize);
+	offset = cvtnum(blocksize, sectsize, argv[optind]);
+	if (offset < 0) {
+		printf(_("non-numeric offset argument -- %s\n"),
+			argv[optind]);
+		return 0;
+	}
+	optind++;
+	length = cvtnum(blocksize, sectsize, argv[optind]);
+	if (length < 0) {
+		printf(_("non-numeric length argument -- %s\n"),
+			argv[optind]);
+		return 0;
+	}
+
+	if (sync_file_range(file->fd, offset, length, sync_mode) < 0) {
+		perror("sync_file_range");
+		return 0;
+	}
+	return 0;
+}
+
+void
+sync_range_init(void)
+{
+	sync_range_cmd.name = "sync_range";
+	sync_range_cmd.cfunc = sync_range_f;
+	sync_range_cmd.argmin = 2;
+	sync_range_cmd.argmax = -1;
+	sync_range_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	sync_range_cmd.args = _("[-abw] off len");
+	sync_range_cmd.oneline = _("Control writeback on a range of a file");
+	sync_range_cmd.help = sync_range_help;
+
+	add_command(&sync_range_cmd);
+}
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index ebbfdec..a185798 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -273,6 +273,25 @@ See the
 .B fsync
 command.
 .TP
+.BI "sync_range [ \-a | \-b | \-w ] offset length "
+On platforms which support it, allows control of syncing a range of the file to
+disk. With no options, SYNC_FILE_RANGE_WRITE is implied on the range supplied.
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.B \-a
+wait for IO in the given range to finish after writing
+(SYNC_FILE_RANGE_WAIT_AFTER).
+.TP
+.B \-b
+wait for IO in the given range to finish before writing
+(SYNC_FILE_RANGE_WAIT_BEFORE).
+.TP
+.B \-w
+start writeback of dirty data in the given range (SYNC_FILE_RANGE_WRITE).
+.RE
+.PD
+.TP
 .BI resvsp " offset length"
 Allocates reserved, unwritten space for part of a file using the
 XFS_IOC_RESVSP system call described in the
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
