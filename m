Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36040 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751208AbdLATCt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Dec 2017 14:02:49 -0500
Date: Fri, 1 Dec 2017 11:02:44 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 4/5] xfs_io: provide an interface to the scrub ioctls
Message-ID: <20171201190244.GT21412@magnolia>
References: <151094860143.27182.12022983202520916281.stgit@magnolia>
 <151094862514.27182.4461761345656503324.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151094862514.27182.4461761345656503324.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a new xfs_io command to call the new XFS metadata scrub ioctl.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/Makefile       |    3 -
 io/init.c         |    1 
 io/io.h           |    2 
 io/scrub.c        |  252 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_io.8 |    8 ++
 5 files changed, 265 insertions(+), 1 deletion(-)
 create mode 100644 io/scrub.c

diff --git a/io/Makefile b/io/Makefile
index 6725936..58ae298 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -11,7 +11,8 @@ HFILES = init.h io.h
 CFILES = init.c \
 	attr.c bmap.c cowextsize.c encrypt.c file.c freeze.c fsync.c \
 	getrusage.c imap.c link.c mmap.c open.c parent.c pread.c prealloc.c \
-	pwrite.c reflink.c seek.c shutdown.c stat.c sync.c truncate.c utimes.c
+	pwrite.c reflink.c scrub.c seek.c shutdown.c stat.c sync.c truncate.c \
+	utimes.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE)
diff --git a/io/init.c b/io/init.c
index 20d5f80..9e576fe 100644
--- a/io/init.c
+++ b/io/init.c
@@ -84,6 +84,7 @@ init_commands(void)
 	readdir_init();
 	reflink_init();
 	resblks_init();
+	scrub_init();
 	seek_init();
 	sendfile_init();
 	shutdown_init();
diff --git a/io/io.h b/io/io.h
index 3862985..82e142f 100644
--- a/io/io.h
+++ b/io/io.h
@@ -185,3 +185,5 @@ extern void		fsmap_init(void);
 #else
 # define fsmap_init()	do { } while (0)
 #endif
+
+extern void		scrub_init(void);
diff --git a/io/scrub.c b/io/scrub.c
new file mode 100644
index 0000000..cd26997
--- /dev/null
+++ b/io/scrub.c
@@ -0,0 +1,252 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
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
+#include <sys/uio.h>
+#include <xfs/xfs.h>
+#include "command.h"
+#include "input.h"
+#include "init.h"
+#include "path.h"
+#include "io.h"
+
+static struct cmdinfo scrub_cmd;
+
+/* Type info and names for the scrub types. */
+enum scrub_type {
+	ST_NONE,	/* disabled */
+	ST_PERAG,	/* per-AG metadata */
+	ST_FS,		/* per-FS metadata */
+	ST_INODE,	/* per-inode metadata */
+};
+
+struct scrub_descr {
+	const char	*name;
+	enum scrub_type	type;
+};
+
+static const struct scrub_descr scrubbers[XFS_SCRUB_TYPE_NR] = {
+	[XFS_SCRUB_TYPE_PROBE]		= {"probe",		ST_NONE},
+	[XFS_SCRUB_TYPE_SB]		= {"sb",		ST_PERAG},
+	[XFS_SCRUB_TYPE_AGF]		= {"agf",		ST_PERAG},
+	[XFS_SCRUB_TYPE_AGFL]		= {"agfl",		ST_PERAG},
+	[XFS_SCRUB_TYPE_AGI]		= {"agi",		ST_PERAG},
+	[XFS_SCRUB_TYPE_BNOBT]		= {"bnobt",		ST_PERAG},
+	[XFS_SCRUB_TYPE_CNTBT]		= {"cntbt",		ST_PERAG},
+	[XFS_SCRUB_TYPE_INOBT]		= {"inobt",		ST_PERAG},
+	[XFS_SCRUB_TYPE_FINOBT]		= {"finobt",		ST_PERAG},
+	[XFS_SCRUB_TYPE_RMAPBT]		= {"rmapbt",		ST_PERAG},
+	[XFS_SCRUB_TYPE_REFCNTBT]	= {"refcountbt",	ST_PERAG},
+	[XFS_SCRUB_TYPE_INODE]		= {"inode",		ST_INODE},
+	[XFS_SCRUB_TYPE_BMBTD]		= {"bmapbtd",		ST_INODE},
+	[XFS_SCRUB_TYPE_BMBTA]		= {"bmapbta",		ST_INODE},
+	[XFS_SCRUB_TYPE_BMBTC]		= {"bmapbtc",		ST_INODE},
+	[XFS_SCRUB_TYPE_DIR]		= {"directory",		ST_INODE},
+	[XFS_SCRUB_TYPE_XATTR]		= {"xattr",		ST_INODE},
+	[XFS_SCRUB_TYPE_SYMLINK]	= {"symlink",		ST_INODE},
+	[XFS_SCRUB_TYPE_PARENT]		= {"parent",		ST_INODE},
+	[XFS_SCRUB_TYPE_RTBITMAP]	= {"rtbitmap",		ST_FS},
+	[XFS_SCRUB_TYPE_RTSUM]		= {"rtsummary",		ST_FS},
+	[XFS_SCRUB_TYPE_UQUOTA]		= {"usrquota",		ST_FS},
+	[XFS_SCRUB_TYPE_GQUOTA]		= {"grpquota",		ST_FS},
+	[XFS_SCRUB_TYPE_PQUOTA]		= {"prjquota",		ST_FS},
+};
+
+static void
+scrub_help(void)
+{
+	const struct scrub_descr	*d;
+	int				i;
+
+	printf(_(
+"\n"
+" Scrubs a piece of XFS filesystem metadata.  The first argument is the type\n"
+" of metadata to examine.  Allocation group metadata types take one AG number\n"
+" as the second parameter.  Inode metadata types act on the currently open file\n"
+" or (optionally) take an inode number and generation number to act upon as\n"
+" the second and third parameters.\n"
+"\n"
+" Example:\n"
+" 'scrub inobt 3' - scrub the inode btree in AG 3.\n"
+" 'scrub bmapbtd 128 13525' - scrubs the extent map of inode 128 gen 13525.\n"
+"\n"
+" Known metadata scrub types are:"));
+	for (i = 0, d = scrubbers; i < XFS_SCRUB_TYPE_NR; i++, d++)
+		printf(" %s", d->name);
+	printf("\n");
+}
+
+static void
+scrub_ioctl(
+	int				fd,
+	int				type,
+	uint64_t			control,
+	uint32_t			control2)
+{
+	struct xfs_scrub_metadata	meta;
+	const struct scrub_descr	*sc;
+	int				error;
+
+	sc = &scrubbers[type];
+	memset(&meta, 0, sizeof(meta));
+	meta.sm_type = type;
+	switch (sc->type) {
+	case ST_PERAG:
+		meta.sm_agno = control;
+		break;
+	case ST_INODE:
+		meta.sm_ino = control;
+		meta.sm_gen = control2;
+		break;
+	case ST_NONE:
+	case ST_FS:
+		/* no control parameters */
+		break;
+	}
+	meta.sm_flags = 0;
+
+	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, &meta);
+	if (error)
+		perror("scrub");
+	if (meta.sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		printf(_("Corruption detected.\n"));
+	if (meta.sm_flags & XFS_SCRUB_OFLAG_PREEN)
+		printf(_("Optimization possible.\n"));
+	if (meta.sm_flags & XFS_SCRUB_OFLAG_XFAIL)
+		printf(_("Cross-referencing failed.\n"));
+	if (meta.sm_flags & XFS_SCRUB_OFLAG_XCORRUPT)
+		printf(_("Corruption detected during cross-referencing.\n"));
+	if (meta.sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE)
+		printf(_("Scan was not complete.\n"));
+}
+
+static int
+parse_args(
+	int				argc,
+	char				**argv,
+	struct cmdinfo			*cmdinfo,
+	void				(*fn)(int, int, uint64_t, uint32_t))
+{
+	char				*p;
+	int				type = -1;
+	int				i, c;
+	uint64_t			control = 0;
+	uint32_t			control2 = 0;
+	const struct scrub_descr	*d = NULL;
+
+	while ((c = getopt(argc, argv, "")) != EOF) {
+		switch (c) {
+		default:
+			return command_usage(cmdinfo);
+		}
+	}
+	if (optind > argc - 1)
+		return command_usage(cmdinfo);
+
+	for (i = 0, d = scrubbers; i < XFS_SCRUB_TYPE_NR; i++, d++) {
+		if (strcmp(d->name, argv[optind]) == 0) {
+			type = i;
+			break;
+		}
+	}
+	optind++;
+
+	if (type < 0) {
+		printf(_("Unknown type '%s'.\n"), argv[optind]);
+		return command_usage(cmdinfo);
+	}
+
+	switch (d->type) {
+	case ST_INODE:
+		if (optind == argc) {
+			control = 0;
+			control2 = 0;
+		} else if (optind == argc - 2) {
+			control = strtoull(argv[optind], &p, 0);
+			if (*p != '\0') {
+				fprintf(stderr,
+					_("Bad inode number '%s'.\n"),
+					argv[optind]);
+				return 0;
+			}
+			control2 = strtoul(argv[optind + 1], &p, 0);
+			if (*p != '\0') {
+				fprintf(stderr,
+					_("Bad generation number '%s'.\n"),
+					argv[optind + 1]);
+				return 0;
+			}
+		} else {
+			fprintf(stderr,
+				_("Must specify inode number and generation.\n"));
+			return 0;
+		}
+		break;
+	case ST_PERAG:
+		if (optind != argc - 1) {
+			fprintf(stderr,
+				_("Must specify one AG number.\n"));
+			return 0;
+		}
+		control = strtoul(argv[optind], &p, 0);
+		if (*p != '\0') {
+			fprintf(stderr,
+				_("Bad AG number '%s'.\n"), argv[optind]);
+			return 0;
+		}
+		break;
+	case ST_FS:
+	case ST_NONE:
+		if (optind != argc) {
+			fprintf(stderr,
+				_("No parameters allowed.\n"));
+			return 0;
+		}
+		break;
+	default:
+		ASSERT(0);
+		break;
+	}
+	fn(file->fd, type, control, control2);
+
+	return 0;
+}
+
+static int
+scrub_f(
+	int				argc,
+	char				**argv)
+{
+	return parse_args(argc, argv, &scrub_cmd, scrub_ioctl);
+}
+
+void
+scrub_init(void)
+{
+	scrub_cmd.name = "scrub";
+	scrub_cmd.altname = "sc";
+	scrub_cmd.cfunc = scrub_f;
+	scrub_cmd.argmin = 1;
+	scrub_cmd.argmax = -1;
+	scrub_cmd.flags = CMD_NOMAP_OK;
+	scrub_cmd.args = _("type [agno|ino gen]");
+	scrub_cmd.oneline = _("scrubs filesystem metadata");
+	scrub_cmd.help = scrub_help;
+
+	add_command(&scrub_cmd);
+}
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 9bf1a47..2c594b1 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1119,6 +1119,14 @@ version of policy structure (numeric)
 .BR get_encpolicy
 On filesystems that support encryption, display the encryption policy of the
 current file.
+.TP
+.BI "scrub " type " [ " agnumber " | " "ino" " " "gen" " ]"
+Scrub internal XFS filesystem metadata.  The
+.BI type
+parameter specifies which type of metadata to scrub.
+For AG metadata, one AG number must be specified.
+For file metadata, the scrub is applied to the open file unless the
+inode number and generation number are specified.
 
 .SH SEE ALSO
 .BR mkfs.xfs (8),
