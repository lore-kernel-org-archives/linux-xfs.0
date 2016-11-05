Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40234 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754403AbcKEA2n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:28:43 -0400
Subject: [PATCH 38/39] xfs_io: provide an interface to the scrub ioctls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:28:38 -0700
Message-ID: <147830571833.4165.522807818750212319.stgit@birch.djwong.org>
In-Reply-To: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
References: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Create a new xfs_io command to call the new XFS metadata scrub ioctl.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/Makefile       |    2 
 io/init.c         |    2 
 io/inject.c       |    4 -
 io/io.h           |    2 
 io/scrub.c        |  325 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_io.8 |    8 +
 6 files changed, 341 insertions(+), 2 deletions(-)
 create mode 100644 io/scrub.c


diff --git a/io/Makefile b/io/Makefile
index d65bafc..1e1bc6a 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -11,7 +11,7 @@ HFILES = init.h io.h
 CFILES = init.c \
 	attr.c bmap.c file.c freeze.c fsync.c getrusage.c imap.c link.c \
 	mmap.c open.c parent.c pread.c prealloc.c pwrite.c seek.c shutdown.c \
-	sync.c truncate.c reflink.c cowextsize.c fsmap.c
+	sync.c truncate.c reflink.c cowextsize.c fsmap.c scrub.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE)
diff --git a/io/init.c b/io/init.c
index 27c4a16..ccb1a95 100644
--- a/io/init.c
+++ b/io/init.c
@@ -89,6 +89,8 @@ init_commands(void)
 	truncate_init();
 	reflink_init();
 	cowextsize_init();
+	scrub_init();
+	repair_init();
 }
 
 static int
diff --git a/io/inject.c b/io/inject.c
index 5d5e4ae..ea0d3b0 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -86,7 +86,9 @@ error_tag(char *name)
 		{ XFS_ERRTAG_BMAP_FINISH_ONE,		"bmap_finish_one" },
 #define XFS_ERRTAG_AG_RESV_CRITICAL			27
 		{ XFS_ERRTAG_AG_RESV_CRITICAL,		"ag_resv_critical" },
-#define XFS_ERRTAG_MAX                                  28
+#define XFS_ERRTAG_FORCE_REPAIR				28
+		{ XFS_ERRTAG_FORCE_REPAIR,		"force_repair" },
+#define XFS_ERRTAG_MAX                                  29
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/io/io.h b/io/io.h
index 0ee2c41..3c53e0e 100644
--- a/io/io.h
+++ b/io/io.h
@@ -172,3 +172,5 @@ extern void		readdir_init(void);
 extern void		reflink_init(void);
 
 extern void		cowextsize_init(void);
+extern void		scrub_init(void);
+extern void		repair_init(void);
diff --git a/io/scrub.c b/io/scrub.c
new file mode 100644
index 0000000..65cafff
--- /dev/null
+++ b/io/scrub.c
@@ -0,0 +1,325 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
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
+#include "io.h"
+
+static struct cmdinfo scrub_cmd;
+static struct cmdinfo repair_cmd;
+
+/* Type info and names for the scrub types. */
+enum scrub_type {
+	ST_NONE,	/* disabled */
+	ST_PERAG,	/* per-AG metadata */
+	ST_FS,		/* per-FS metadata */
+	ST_INODE,	/* per-inode metadata */
+};
+
+/* These must correspond with XFS_SCRUB_TYPE_ */
+struct scrub_descr {
+	const char	*name;
+	enum scrub_type	type;
+};
+
+static const struct scrub_descr scrubbers[] = {
+	{"dummy",	ST_NONE},
+	{"sb",		ST_PERAG},
+	{"agf",		ST_PERAG},
+	{"agfl",	ST_PERAG},
+	{"agi",		ST_PERAG},
+	{"bnobt",	ST_PERAG},
+	{"cntbt",	ST_PERAG},
+	{"inobt",	ST_PERAG},
+	{"finobt",	ST_PERAG},
+	{"rmapbt",	ST_PERAG},
+	{"refcountbt",	ST_PERAG},
+	{"inode",	ST_INODE},
+	{"bmapbtd",	ST_INODE},
+	{"bmapbta",	ST_INODE},
+	{"bmapbtc",	ST_INODE},
+	{"directory",	ST_INODE},
+	{"xattr",	ST_INODE},
+	{"symlink",	ST_INODE},
+	{"rtbitmap",	ST_FS},
+	{"rtsummary",	ST_FS},
+	{NULL,		ST_NONE},
+};
+
+static void
+scrub_help(void)
+{
+	const struct scrub_descr	*d;
+
+	printf(_("\n\
+ Scrubs a piece of XFS filesystem metadata.  The first argument is the type\n\
+ of metadata to examine.  Allocation group number(s) can be specified to\n\
+ restrict the scrub operation to a subset of allocation groups.\n\
+ Certain metadata types do not take AG numbers.\n\
+\n\
+ Example:\n\
+ 'scrub inobt 3' - scrub the inode btree in AG 3.\n\
+ 'scrub bmapbtd 128 13525' - scrubs the extent map of inode 128 gen 13525.\n\
+\n\
+ Known metadata scrub types are:"));
+	for (d = scrubbers; d->name; d++)
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
+	if (meta.sm_flags & XFS_SCRUB_FLAG_CORRUPT)
+		printf("Corruption detected.\n");
+	if (meta.sm_flags & XFS_SCRUB_FLAG_PREEN)
+		printf("Optimization possible.\n");
+	if (meta.sm_flags & XFS_SCRUB_FLAG_XREF_FAIL)
+		printf("Cross-referencing failed.\n");
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
+	for (i = 0, d = scrubbers; d->name; i++, d++) {
+		if (strcmp(d->name, argv[optind]) == 0) {
+			type = i;
+			break;
+		}
+	}
+	optind++;
+
+	if (type < 0)
+		return command_usage(cmdinfo);
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
+					_("Bad inode number %s.\n"), argv[i]);
+				return 0;
+			}
+			control2 = strtoul(argv[optind + 1], &p, 0);
+			if (*p != '\0') {
+				fprintf(stderr,
+					_("Bad generation number %s.\n"), argv[i]);
+				return 0;
+			}
+		} else {
+			fprintf(stderr,
+				_("Must specify inode number and generation.\n"));
+			return 0;
+		}
+		break;
+	case ST_PERAG:
+	case ST_NONE:
+		if (optind != argc - 1) {
+			fprintf(stderr,
+				_("Must specify AG number.\n"));
+			return 0;
+		}
+		control = strtoul(argv[optind], &p, 0);
+		if (*p != '\0') {
+			fprintf(stderr,
+				_("Bad AG number %s.\n"), argv[i]);
+			return 0;
+		}
+		break;
+	default:
+		if (optind != argc) {
+			fprintf(stderr,
+				_("No parameters allowed.\n"));
+			return 0;
+		}
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
+	scrub_cmd.args =
+_("type [agno...]");
+	scrub_cmd.oneline =
+		_("scrubs filesystem metadata");
+	scrub_cmd.help = scrub_help;
+
+	add_command(&scrub_cmd);
+}
+
+static void
+repair_help(void)
+{
+	const struct scrub_descr	*d;
+
+	printf(_("\n\
+ Repairs a piece of XFS filesystem metadata.  The first argument is the type\n\
+ of metadata to examine.  Allocation group number(s) can be specified to\n\
+ restrict the scrub operation to a subset of allocation groups.\n\
+ Certain metadata types do not take AG numbers.\n\
+\n\
+ Example:\n\
+ 'repair inobt 3 5 7' - repairs the inode btree in groups 3, 5, and 7.\n\
+\n\
+ Known metadata repairs types are:"));
+	for (d = scrubbers; d->name; d++)
+		printf(" %s", d->name);
+	printf("\n");
+}
+
+static void
+repair_ioctl(
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
+	meta.sm_flags = XFS_SCRUB_FLAG_REPAIR;
+
+	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, &meta);
+	if (error)
+		perror("scrub");
+	if (meta.sm_flags & XFS_SCRUB_FLAG_CORRUPT)
+		printf("Corruption remains.\n");
+	if (meta.sm_flags & XFS_SCRUB_FLAG_PREEN)
+		printf("Optimization possible.\n");
+	if (meta.sm_flags & XFS_SCRUB_FLAG_XREF_FAIL)
+		printf("Cross-referencing failed.\n");
+}
+
+static int
+repair_f(
+	int				argc,
+	char				**argv)
+{
+	return parse_args(argc, argv, &repair_cmd, repair_ioctl);
+}
+
+void
+repair_init(void)
+{
+	if (!expert)
+		return;
+	repair_cmd.name = "repair";
+	repair_cmd.altname = "fix";
+	repair_cmd.cfunc = repair_f;
+	repair_cmd.argmin = 1;
+	repair_cmd.argmax = -1;
+	repair_cmd.flags = CMD_NOMAP_OK;
+	repair_cmd.args =
+_("type [agno...]");
+	repair_cmd.oneline =
+		_("repairs filesystem metadata");
+	repair_cmd.help = repair_help;
+
+	add_command(&repair_cmd);
+}
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index f7edcab..f5e89ab 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -937,6 +937,14 @@ verbose output will be printed.
 .IP
 .B [NOTE: Not currently operational on Linux.]
 .PD
+.TP
+.BI "scrub " type " [ " agnumber... " ]"
+Scrub internal XFS filesystem metadata.  The
+.BI type
+parameter specifies which type of metadata to scrub.
+AG numbers can optionally be specified to restrict the scrub operation
+to a particular set of allocation groups.
+By default, all allocation groups are scrubbed.
 
 .SH SEE ALSO
 .BR mkfs.xfs (8),

