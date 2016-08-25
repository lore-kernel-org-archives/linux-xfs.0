Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5656983A6
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:57:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 19D088F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:57:53 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id mVRwCexNP2hLZsyT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:57:50 -0700 (PDT)
Subject: [PATCH 23/24] xfs_io: provide an interface to the scrub ioctls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:57:46 -0700
Message-ID: <147216946601.6398.16187695052276931699.stgit@birch.djwong.org>
In-Reply-To: <147216931783.6398.1716678878794493264.stgit@birch.djwong.org>
References: <147216931783.6398.1716678878794493264.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Create a new xfs_io command to call the new XFS metadata scrub ioctl.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/Makefile       |    2 -
 io/init.c         |    1 
 io/io.h           |    2 +
 io/scrub.c        |  174 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_io.8 |    8 ++
 5 files changed, 186 insertions(+), 1 deletion(-)
 create mode 100644 io/scrub.c


diff --git a/io/Makefile b/io/Makefile
index cc27dba..c430418 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -11,7 +11,7 @@ HFILES = init.h io.h
 CFILES = init.c \
 	attr.c bmap.c file.c freeze.c fsync.c getrusage.c imap.c link.c \
 	mmap.c open.c parent.c pread.c prealloc.c pwrite.c seek.c shutdown.c \
-	sync.c truncate.c reflink.c fsmap.c
+	sync.c truncate.c reflink.c fsmap.c scrub.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE)
diff --git a/io/init.c b/io/init.c
index 9c0da0e..c16bc69 100644
--- a/io/init.c
+++ b/io/init.c
@@ -87,6 +87,7 @@ init_commands(void)
 	truncate_init();
 	reflink_init();
 	cowextsize_init();
+	scrub_init();
 }
 
 static int
diff --git a/io/io.h b/io/io.h
index 83a8366..10be081 100644
--- a/io/io.h
+++ b/io/io.h
@@ -176,3 +176,5 @@ extern void		cowextsize_init(void);
 #else
 #define cowextsize_init()	do { } while (0)
 #endif
+
+extern void		scrub_init(void);
diff --git a/io/scrub.c b/io/scrub.c
new file mode 100644
index 0000000..8b93121
--- /dev/null
+++ b/io/scrub.c
@@ -0,0 +1,174 @@
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
+static cmdinfo_t scrub_cmd;
+
+/* These must correspond with XFS_SCRUB_TYPE_ */
+struct scrub_descr {
+	const char	*name;
+	bool		is_ag;
+};
+
+static const struct scrub_descr scrubbers[] = {
+	{"sb",		true},
+	{"agf",		true},
+	{"agfl",	true},
+	{"agi",		true},
+	{"bnobt",	true},
+	{"cntbt",	true},
+	{"inobt",	true},
+	{"finobt",	true},
+	{"rmapbt",	true},
+	{"refcountbt",	true},
+	{"inode",	false},
+	{"bmapbtd",	false},
+	{"bmapbta",	false},
+	{"bmapbtc",	false},
+	{"rtbitmap",	false},
+	{"rtsummary",	false},
+	{NULL, false},
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
+ 'scrub inobt 3 5 7' - scrubs the inode btree in groups 3, 5, and 7.\n\
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
+	unsigned long long		control)
+{
+	struct xfs_scrub_metadata	meta;
+	int				error;
+
+	memset(&meta, 0, sizeof(meta));
+	meta.type = type;
+	meta.control = control;
+
+	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, &meta);
+	if (error)
+		perror("scrub");
+}
+
+static int
+scrub_f(
+	int				argc,
+	char				**argv)
+{
+	char				*p;
+	int				type = -1;
+	int				i, c;
+	unsigned long long		control;
+	bool				is_ag;
+	struct xfs_fsop_geom		geom;
+	const struct scrub_descr	*d;
+
+	while ((c = getopt(argc, argv, "")) != EOF) {
+		switch (c) {
+		default:
+			return command_usage(&scrub_cmd);
+		}
+	}
+	if (optind > argc - 1)
+		return command_usage(&scrub_cmd);
+
+	for (i = 0, d = scrubbers; d->name; i++, d++) {
+		if (strcmp(d->name, argv[optind]) == 0) {
+			type = i;
+			is_ag = d->is_ag;
+		}
+	}
+	optind++;
+
+	if (type < 0)
+		return command_usage(&scrub_cmd);
+
+	if (!is_ag)
+		geom.agcount = 1;
+	else {
+		i = xfsctl(file->name, file->fd, XFS_IOC_FSGEOMETRY_V1, &geom);
+		if (i < 0) {
+			fprintf(stderr,
+				_("%s: can't get geometry [\"%s\"]: %s\n"),
+				progname, file->name, strerror(errno));
+			exitcode = 1;
+			return 0;
+		}
+	}
+
+	if (optind == argc) {
+		for (control = 0; control < geom.agcount; control++)
+			scrub_ioctl(file->fd, type, control);
+		return 0;
+	}
+
+	for (i = optind; i < argc; i++) {
+		control = strtoull(argv[i], &p, 0);
+		if (*p != '\0') {
+			fprintf(stderr,
+				_("bad control number %s\n"), argv[i]);
+			return 0;
+		}
+
+		scrub_ioctl(file->fd, type, control);
+	}
+	return 0;
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
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index a275a63..884db2a 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -926,6 +926,14 @@ verbose output will be printed.
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
