Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36818 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753981AbeD3Psz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Apr 2018 11:48:55 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id F2B654C1515
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 10:47:42 -0500 (CDT)
Subject: [PATCH 5/5] xfs_io: add label command
References: <eb592fc3-3165-5ec7-3896-b798fc7f6502@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ef880401-b4ab-56ae-8f94-c13ca8239a73@sandeen.net>
Date: Mon, 30 Apr 2018 10:48:54 -0500
MIME-Version: 1.0
In-Reply-To: <eb592fc3-3165-5ec7-3896-b798fc7f6502@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This adds a get/set label command to xfs_io.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/io/Makefile b/io/Makefile
index 88e4751..b40156d 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -10,9 +10,9 @@ LSRCFILES = xfs_bmap.sh xfs_freeze.sh xfs_mkfile.sh
 HFILES = init.h io.h
 CFILES = init.c \
 	attr.c bmap.c cowextsize.c encrypt.c file.c freeze.c fsync.c \
-	getrusage.c imap.c link.c mmap.c open.c parent.c pread.c prealloc.c \
-	pwrite.c reflink.c scrub.c seek.c shutdown.c stat.c swapext.c sync.c \
-	truncate.c utimes.c
+	getrusage.c imap.c label.c link.c mmap.c open.c parent.c pread.c \
+	prealloc.c pwrite.c reflink.c scrub.c seek.c shutdown.c stat.c \
+	swapext.c sync.c truncate.c utimes.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
diff --git a/io/init.c b/io/init.c
index 0336c96..612962e 100644
--- a/io/init.c
+++ b/io/init.c
@@ -72,6 +72,7 @@ init_commands(void)
 	help_init();
 	imap_init();
 	inject_init();
+	label_init();
 	log_writes_init();
 	madvise_init();
 	mincore_init();
diff --git a/io/io.h b/io/io.h
index a267636..7f8197c 100644
--- a/io/io.h
+++ b/io/io.h
@@ -109,6 +109,7 @@ extern void		getrusage_init(void);
 extern void		help_init(void);
 extern void		imap_init(void);
 extern void		inject_init(void);
+extern void		label_init(void);
 extern void		mmap_init(void);
 extern void		open_init(void);
 extern void		parent_init(void);
diff --git a/io/label.c b/io/label.c
new file mode 100644
index 0000000..acab67f
--- /dev/null
+++ b/io/label.c
@@ -0,0 +1,74 @@
+/*
+ * Copyright (c) 2018 Red Hat, Inc.
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
+#include <sys/ioctl.h>
+#include <sys/mount.h>
+#include "platform_defs.h"
+#include "libxfs.h"
+#include "path.h"
+#include "command.h"
+#include "init.h"
+#include "io.h"
+
+#ifndef FS_IOC_GET_FSLABEL
+/* Max chars for the interface; fs limits may differ */
+#define FSLABEL_MAX 256
+#define FS_IOC_GET_FSLABEL		_IOR(0x94, 49, char[FSLABEL_MAX])
+#define FS_IOC_SET_FSLABEL		_IOW(0x94, 50, char[FSLABEL_MAX])
+#endif
+
+static cmdinfo_t label_cmd;
+
+static int
+label_f(
+	int		argc,
+	char		**argv)
+{
+	int		error;
+	char		label[FSLABEL_MAX];
+
+	if (argc == 1) {
+		memset(&label, 0, sizeof(label));
+		error = ioctl(file->fd, FS_IOC_GET_FSLABEL, &label);
+	} else {
+		strncpy(label, argv[1], sizeof(label));
+		error = ioctl(file->fd, FS_IOC_SET_FSLABEL, &label);
+	}
+
+	if (error)
+		perror("label");
+	else
+		printf("label = \"%s\"\n", label);
+
+	return error;
+}
+
+void
+label_init(void)
+{
+	label_cmd.name = "label";
+	label_cmd.cfunc = label_f;
+	label_cmd.argmin = 0;
+	label_cmd.argmax = 1;
+	label_cmd.args = _("[label]");
+	label_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	label_cmd.oneline =
+		_("query or set the filesystem label while mounted");
+
+	add_command(&label_cmd);
+}
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index c3ab532..52b983d 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1175,6 +1175,16 @@ This is intended to be equivalent to the shell command:
 See the
 .B log_writes
 command.
+.TP
+.BI "label" " " [ " label " ]
+On  filesystems  that  support  online label manipulation, set or get the
+filesystem label.  With no options, get the current filesystem label.
+With one option, set the filesystem label to
+.IR label .
+If the label is longer than the filesystem will accept,
+.B xfs_io
+will print an error message.  XFS filesystem labels can be at most 12
+characters long.
 .SH SEE ALSO
 .BR mkfs.xfs (8),
 .BR xfsctl (3),

