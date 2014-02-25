Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 38B557F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 13:52:21 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 08D9C30406A
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 11:52:21 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Y5lKDtuuZxs2FFrE (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 11:52:19 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1WIO38-0003fg-IU
	for xfs@oss.sgi.com; Tue, 25 Feb 2014 19:52:18 +0000
Date: Tue, 25 Feb 2014 11:52:18 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2] xfs_io: add support for flink
Message-ID: <20140225195218.GA14110@infradead.org>
References: <20140220220000.GA17541@infradead.org>
	<20140221004933.GA9445@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140221004933.GA9445@infradead.org>
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
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/io/Makefile b/io/Makefile
index eaeb5b2..c16af87 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -9,8 +9,8 @@ LTCOMMAND = xfs_io
 LSRCFILES = xfs_bmap.sh xfs_freeze.sh xfs_mkfile.sh
 HFILES = init.h io.h
 CFILES = init.c \
-	attr.c bmap.c file.c freeze.c fsync.c getrusage.c imap.c mmap.c \
-	open.c parent.c pread.c prealloc.c pwrite.c seek.c shutdown.c \
+	attr.c bmap.c file.c freeze.c fsync.c getrusage.c imap.c link.c \
+	mmap.c open.c parent.c pread.c prealloc.c pwrite.c seek.c shutdown.c \
 	truncate.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE)
diff --git a/io/init.c b/io/init.c
index fd1a52f..7d7bb89 100644
--- a/io/init.c
+++ b/io/init.c
@@ -58,6 +58,7 @@ init_commands(void)
 	bmap_init();
 	fadvise_init();
 	file_init();
+	flink_init();
 	freeze_init();
 	fsync_init();
 	getrusage_init();
diff --git a/io/io.h b/io/io.h
index 0d2d768..1b3bca1 100644
--- a/io/io.h
+++ b/io/io.h
@@ -93,6 +93,7 @@ extern void		dump_buffer(off64_t, ssize_t);
 extern void		attr_init(void);
 extern void		bmap_init(void);
 extern void		file_init(void);
+extern void		flink_init(void);
 extern void		freeze_init(void);
 extern void		fsync_init(void);
 extern void		getrusage_init(void);
diff --git a/io/link.c b/io/link.c
new file mode 100644
index 0000000..9c2d1f8
--- /dev/null
+++ b/io/link.c
@@ -0,0 +1,70 @@
+/*
+ * Copyright (c) 2014 Christoph Hellwig.
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
+#ifndef AT_EMPTY_PATH
+#define AT_EMPTY_PATH	0x1000
+#endif
+
+static cmdinfo_t flink_cmd;
+
+static void
+flink_help(void)
+{
+	printf(_(
+"\n"
+"link the open file descriptor to the supplied filename\n"
+"\n"
+"\n"));
+}
+
+static int
+flink_f(
+	int		argc,
+	char		**argv)
+{
+	if (argc != 2)
+		return command_usage(&flink_cmd);
+
+	if (linkat(file->fd, "", AT_FDCWD, argv[1], AT_EMPTY_PATH) < 0) {
+		perror("flink");
+		return 0;
+	}
+	return 0;
+}
+
+void
+flink_init(void)
+{
+	flink_cmd.name = "flink";
+	flink_cmd.cfunc = flink_f;
+	flink_cmd.argmin = 1;
+	flink_cmd.argmax = 1;
+	flink_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	flink_cmd.args = _("filename");
+	flink_cmd.oneline =
+		_("link the open file descriptor to the supplied filename");
+	flink_cmd.help = flink_help;
+
+	add_command(&flink_cmd);
+}
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 7a92ff6..72f8210 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -638,6 +638,10 @@ Only available in expert mode and requires privileges.
 Undo the effects of a filesystem freeze operation.
 Only available in expert mode and requires privileges.
 .TP
+.BI "flink " path
+Reads a range of bytes in a specified blocksize from the given
+Link the currently open file descriptor into the filesystem namespace.
+.TP
 .BI "inject [ " tag " ]"
 Inject errors into a filesystem to observe filesystem behavior at
 specific points under adverse conditions. Without the

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
