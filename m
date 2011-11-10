Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAAKZfCI127002 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 14:35:41 -0600
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 8/8] xfsprogs: xfs_db: add new "resvsp" command
Date: Thu, 10 Nov 2011 14:35:18 -0600
Message-Id: <122161c271ee994b758daafe4e0756cae784950b.1320955676.git.aelder@sgi.com>
In-Reply-To: <1320957318-16269-1-git-send-email-aelder@sgi.com>
References: <1320957318-16269-1-git-send-email-aelder@sgi.com>
In-Reply-To: <3ed89446f6dc1231ec1de712f242522052952b7e.1320955675.git.aelder@sgi.com>
References: <3ed89446f6dc1231ec1de712f242522052952b7e.1320955675.git.aelder@sgi.com>
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
Cc: Kevan Rehm <kfr@sgi.com>, Alex Elder <aelder@sgi.com>

From: Kevan Rehm <kfr@sgi.com>

This patch adds a new "resvsp" command to xfs_db.  The command
provides access to the xfsctl(3) XFS_IOC_RESVSP64 operation, which
allocates space in an ordinary file.  Blocks are allocated but not
zeroed, and the file size does not change.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 db/Makefile  |    2 +-
 db/command.c |    2 +
 db/resvsp.c  |  184 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/resvsp.h  |   19 ++++++
 4 files changed, 206 insertions(+), 1 deletions(-)
 create mode 100644 db/resvsp.c
 create mode 100644 db/resvsp.h

diff --git a/db/Makefile b/db/Makefile
index 5c7d054..797ff52 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -12,7 +12,7 @@ HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
 	dir.h dir2.h dir2sf.h dirshort.h dquot.h echo.h faddr.h field.h \
 	flist.h fprint.h frag.h freesp.h hash.h help.h init.h inode.h input.h \
 	io.h malloc.h metadump.h output.h print.h quit.h sb.h sig.h strvec.h \
-	text.h type.h write.h attrset.h
+	text.h type.h write.h attrset.h resvsp.h
 CFILES = $(HFILES:.h=.c)
 LSRCFILES = xfs_admin.sh xfs_check.sh xfs_ncheck.sh xfs_metadump.sh
 
diff --git a/db/command.c b/db/command.c
index b7e3165..b70e1ef 100644
--- a/db/command.c
+++ b/db/command.c
@@ -43,6 +43,7 @@
 #include "metadump.h"
 #include "output.h"
 #include "print.h"
+#include "resvsp.h"
 #include "quit.h"
 #include "sb.h"
 #include "write.h"
@@ -121,6 +122,7 @@ init_commands(void)
 	attrset_init();
 	block_init();
 	bmap_init();
+	resvsp_init();
 	check_init();
 	convert_init();
 	debug_init();
diff --git a/db/resvsp.c b/db/resvsp.c
new file mode 100644
index 0000000..c7206e2
--- /dev/null
+++ b/db/resvsp.c
@@ -0,0 +1,184 @@
+
+/*
+ * Copyright (c) 2011 SGI
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
+#include <xfs/libxfs.h>
+#include "command.h"
+#include "type.h"
+#include "fprint.h"
+#include "faddr.h"
+#include "field.h"
+#include "bmap.h"
+#include "io.h"
+#include "inode.h"
+#include "output.h"
+#include "init.h"
+#include "resvsp.h"
+
+static int	resvsp_f(int argc, char **argv);
+static void	resvsp_help(void);
+
+static const cmdinfo_t	resvsp_cmd =
+	{ "resvsp", NULL, resvsp_f, 0, -1, 0,
+	N_("[-w] [-o offset] [-l length] [inode#]"),
+	N_("allocate space in a file"), resvsp_help };
+
+static void
+resvsp_help(void)
+{
+	dbprintf(_(
+"\n"
+"The resvsp function is essentially an implementation of the xfsctl(3)\n"
+"file operation XFS_IOC_RESVSP64 which allocates space in an ordinary\n"
+"file.  Blocks are allocated but not zeroed, and the file size does not\n"
+"change.  The -o option is the starting offset for the allocation (default 0)\n"
+"and the -l option gives the length of the allocation in bytes (default to\n"
+"end of file).  Both offset and length values will be rounded to a filesystem\n"
+"block boundary.  'inode#' is the inode number of the file in which to\n"
+"perform the allocation.  If none is specified, the current inode is used.\n"
+"If the -w option is specified, the allocated extents will not be flagged as\n"
+"unwritten.  Use this option with care, as someone with read permission\n"
+"to the file can then read whatever is written in those blocks.\n"
+"\n"
+" Example:\n"
+"\n"
+" 'resvsp'                  - allocate blocks in the current inode's entire byte range\n"
+" 'resvsp 76'               - allocate blocks in the entire byte range of inode 76\n"
+" 'resvsp -o 8192 -l 4096'  - allocate 4096 bytes at offset 8192 in the current inode\n"
+"\n"
+));
+}
+
+static int
+resvsp_f(
+	int		argc,
+	char		**argv)
+{
+	xfs_inode_t	*ip;
+	int		error;
+	int		c;
+	char		*p;
+	xfs_ino_t	ino;
+	xfs_off_t	offset = 0;	/* allocate from start of file */
+	xfs_off_t	len = 0;	/* allocate to EOF */
+	int		alloc_type = 1;	/* flag extents as unwritten */
+
+	if (x.isreadonly & LIBXFS_ISREADONLY) {
+		dbprintf(_("%s started in read only mode, resvsp disabled\n"),
+			progname);
+		return 0;
+	}
+
+	optind = 0;
+	while ((c = getopt(argc, argv, "l:o:w")) != EOF) {
+		switch (c) {
+		case 'l':
+			len = strtoull(optarg, &p, 0);
+			if (*p != '\0') {
+				dbprintf(_("bad length %s specified for "
+					"-l option\n"), optarg);
+				return 0;
+			}
+			break;
+
+		case 'o':
+			offset = strtoull(optarg, &p, 0);
+			if (*p != '\0') {
+				dbprintf(_("bad offset %s specified for "
+					"-o option\n"), optarg);
+				return 0;
+			}
+			break;
+
+		case 'w':
+			alloc_type = 0;	/* do not flag extents as unwritten */
+			break;
+
+		default:
+			/* getopt() provides the error message */
+			return 0;
+		}
+	}
+	if (optind < argc) {
+		ino = strtoull(argv[optind], &p, 0);
+		if (*p != '\0') {
+			dbprintf(_("bad value %s specified for inode number\n"),
+				argv[optind]);
+			return 0;
+		}
+		optind++;
+	} else if (iocur_top->ino != NULLFSINO) {
+		ino = iocur_top->ino;
+	} else {
+		dbprintf(_("no current inode, and no inode number provided\n"));
+		return 0;
+	}
+	if (optind < argc) {
+		dbprintf(_("only one inode number allowed\n"));
+		return 0;
+	}
+
+	if (libxfs_iget(mp, NULL, ino, 0, &ip, 0)) {
+		dbprintf(_("failed to iget inode %llu\n"), ino);
+		return 0;
+	}
+
+	if ((ip->i_d.di_mode & S_IFMT) != S_IFREG) {
+		dbprintf(_("inode %llu is not an ordinary file\n"), ino);
+		goto fail;
+	}
+
+	if (offset >= ip->i_size) {
+		dbprintf(_("offset %llu must be <= file length %llu\n"),
+			offset, ip->i_size);
+		goto fail;
+	}
+	if (offset + len > ip->i_size) {
+		len = ip->i_size - offset;
+		dbprintf(_("length trimmed to %llu bytes\n"), len);
+	}
+	if (len == 0) {
+		len = ip->i_size - offset;
+	}
+
+	error = libxfs_alloc_file_space(ip, offset, len, alloc_type, 0);
+
+	if (error) {
+		dbprintf(_("error reserving space for a file, %d\n"), error);
+		return 0;
+	}
+
+	/* refresh with updated inode contents */
+	if (iocur_top->ino == ino) {
+		set_cur_inode(iocur_top->ino);
+	}
+
+fail:
+	libxfs_iput(ip, 0);
+
+	return 0;
+}
+
+void
+resvsp_init(void)
+{
+	if (!expert_mode)
+		return;
+
+	add_command(&resvsp_cmd);
+}
diff --git a/db/resvsp.h b/db/resvsp.h
new file mode 100644
index 0000000..b98da8b
--- /dev/null
+++ b/db/resvsp.h
@@ -0,0 +1,19 @@
+/*
+ * Copyright (c) 2011 SGI
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
+extern void	resvsp_init(void);
-- 
1.7.6.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
