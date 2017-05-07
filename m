Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:50548 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754429AbdEGVkK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 May 2017 17:40:10 -0400
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v47Fup20008934
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 7 May 2017 15:56:51 GMT
Subject: [PATCH 5/9] xfs_spaceman: add new speculative prealloc control
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 07 May 2017 08:56:47 -0700
Message-ID: <149417260794.24656.14942047048435557523.stgit@birch.djwong.org>
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

Add an control interface for purging speculative
preallocation via the new ioctls.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[darrick: change xfsctl to ioctl]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 spaceman/Makefile   |    2 -
 spaceman/init.c     |    1 
 spaceman/prealloc.c |  135 +++++++++++++++++++++++++++++++++++++++++++++++++++
 spaceman/space.h    |    1 
 4 files changed, 138 insertions(+), 1 deletion(-)
 create mode 100644 spaceman/prealloc.c


diff --git a/spaceman/Makefile b/spaceman/Makefile
index 9fb9142..b1f1136 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -8,7 +8,7 @@ include $(TOPDIR)/include/builddefs
 LTCOMMAND = xfs_spaceman
 HFILES = init.h space.h
 CFILES = init.c \
-	file.c trim.c
+	file.c prealloc.c trim.c
 
 LLDLIBS = $(LIBXCMD)
 LTDEPENDENCIES = $(LIBXCMD)
diff --git a/spaceman/init.c b/spaceman/init.c
index ae5cfb5..08b5a33 100644
--- a/spaceman/init.c
+++ b/spaceman/init.c
@@ -39,6 +39,7 @@ init_commands(void)
 {
 	file_init();
 	help_init();
+	prealloc_init();
 	quit_init();
 	trim_init();
 }
diff --git a/spaceman/prealloc.c b/spaceman/prealloc.c
new file mode 100644
index 0000000..b93f909
--- /dev/null
+++ b/spaceman/prealloc.c
@@ -0,0 +1,135 @@
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
+#include "command.h"
+#include "input.h"
+#include "init.h"
+#include "space.h"
+
+#ifndef XFS_IOC_FREE_EOFBLOCKS
+#define XFS_IOC_FREE_EOFBLOCKS _IOR ('X', 58, struct xfs_eofblocks)
+
+#define XFS_EOFBLOCKS_VERSION           1
+struct xfs_fs_eofblocks {
+	__u32		eof_version;
+	__u32		eof_flags;
+	uid_t		eof_uid;
+	gid_t		eof_gid;
+	prid_t		eof_prid;
+	__u32		pad32;
+	__u64		eof_min_file_size;
+	__u64		pad64[12];
+};
+
+/* eof_flags values */
+#define XFS_EOF_FLAGS_SYNC		(1 << 0) /* sync/wait mode scan */
+#define XFS_EOF_FLAGS_UID		(1 << 1) /* filter by uid */
+#define XFS_EOF_FLAGS_GID		(1 << 2) /* filter by gid */
+#define XFS_EOF_FLAGS_PRID		(1 << 3) /* filter by project id */
+#define XFS_EOF_FLAGS_MINFILESIZE	(1 << 4) /* filter by min file size */
+
+#endif
+
+static cmdinfo_t prealloc_cmd;
+
+/*
+ * Control preallocation amounts.
+ */
+static int
+prealloc_f(
+	int	argc,
+	char	**argv)
+{
+	struct xfs_fs_eofblocks eofb = {0};
+	int	c;
+
+	eofb.eof_version = XFS_EOFBLOCKS_VERSION;
+
+	while ((c = getopt(argc, argv, "g:m:p:su:")) != EOF) {
+		switch (c) {
+		case 'g':
+			eofb.eof_flags |= XFS_EOF_FLAGS_GID;
+			eofb.eof_gid = atoi(optarg);
+			break;
+		case 'u':
+			eofb.eof_flags |= XFS_EOF_FLAGS_UID;
+			eofb.eof_uid = atoi(optarg);
+			break;
+		case 'p':
+			eofb.eof_flags |= XFS_EOF_FLAGS_PRID;
+			eofb.eof_prid = atoi(optarg);
+			break;
+		case 's':
+			eofb.eof_flags |= XFS_EOF_FLAGS_SYNC;
+			break;
+		case 'm':
+			eofb.eof_flags |= XFS_EOF_FLAGS_MINFILESIZE;
+			eofb.eof_min_file_size = cvtnum(file->geom.blocksize,
+							file->geom.sectsize,
+							optarg);
+			break;
+		case '?':
+		default:
+			return command_usage(&prealloc_cmd);
+		}
+	}
+	if (optind != argc)
+		return command_usage(&prealloc_cmd);
+
+	if (ioctl(file->fd, XFS_IOC_FREE_EOFBLOCKS, &eofb) < 0) {
+		fprintf(stderr, _("%s: XFS_IOC_FREE_EOFBLOCKS on %s: %s\n"),
+			progname, file->name, strerror(errno));
+	}
+	return 0;
+}
+
+static void
+prealloc_help(void)
+{
+	printf(_(
+"\n"
+"Control speculative preallocation\n"
+"\n"
+"Options: [-s] [-ugp id] [-m minlen]\n"
+"\n"
+" -s -- synchronous flush - wait for flush to complete\n"
+" -u uid -- remove prealloc on files matching user <uid>\n"
+" -g gid -- remove prealloc on files matching group <gid>\n"
+" -p prid -- remove prealloc on files matching project <prid>\n"
+" -m minlen -- only consider files larger than <minlen>\n"
+"\n"));
+
+}
+
+void
+prealloc_init(void)
+{
+	prealloc_cmd.name = "prealloc";
+	prealloc_cmd.altname = "prealloc";
+	prealloc_cmd.cfunc = prealloc_f;
+	prealloc_cmd.argmin = 1;
+	prealloc_cmd.argmax = -1;
+	prealloc_cmd.args = "[-s] [-ugp id] [-m minlen]\n";
+	prealloc_cmd.flags = CMD_FLAG_ONESHOT;
+	prealloc_cmd.oneline = _("Control speculative preallocation");
+	prealloc_cmd.help = prealloc_help;
+
+	add_command(&prealloc_cmd);
+}
+
diff --git a/spaceman/space.h b/spaceman/space.h
index 7b4f034..0ae3116 100644
--- a/spaceman/space.h
+++ b/spaceman/space.h
@@ -33,5 +33,6 @@ extern int	addfile(char *, int , xfs_fsop_geom_t *, int);
 
 extern void	file_init(void);
 extern void	help_init(void);
+extern void	prealloc_init(void);
 extern void	quit_init(void);
 extern void	trim_init(void);

