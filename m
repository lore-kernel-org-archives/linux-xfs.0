Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9M7X0QW060528 for <xfs@oss.sgi.com>; Mon, 22 Oct 2012 02:33:00 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Bu9wc1BbKRXsXe9m for <xfs@oss.sgi.com>;
	Mon, 22 Oct 2012 00:34:40 -0700 (PDT)
Date: Mon, 22 Oct 2012 18:34:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 06/10] xfs: add XFS_IOC_FREE_EOFBLOCKS ioctl
Message-ID: <20121022073422.GC2739@dastard>
References: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
	<1349446636-8611-7-git-send-email-bfoster@redhat.com>
	<20121011141335.GY13214@sgi.com> <507749A2.4020206@redhat.com>
	<20121015224626.GU24986@sgi.com> <20121015234902.GH2739@dastard>
	<20121016013901.GI2739@dastard> <20121017224004.GG1377@sgi.com>
	<507FF339.8020208@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <507FF339.8020208@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Thu, Oct 18, 2012 at 08:16:57AM -0400, Brian Foster wrote:
> On 10/17/2012 06:40 PM, Ben Myers wrote:
> >>> FWIW, given the background cleanup code can be trivially verified to
> >>> work (open, apend, close, repeat, wait 5 minutes) and is the
> >>> functionality that is needed in mainline, having something to test
> >>> the ioctls should not stop the patchset from being merged.
> > 
> > Can we be assured that we'll get an xfstest for it eventually?
> 
> Absolutely. Getting a command into xfs_io to support such a test is now
> the top of my todo list with regard to XFS. :)

Here's a patch to the new xfs_spaceman program I'm writing that adds
control for these ioctls.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

spaceman: add new speculative prealloc control

From: Dave Chinner <dchinner@redhat.com>

Add an control interface for purging speculative
preallocation via the new ioctls.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 spaceman/Makefile   |    2 +-
 spaceman/init.c     |    1 +
 spaceman/prealloc.c |  165 +++++++++++++++++++++++++++++++++++++++++++++++++++
 spaceman/space.h    |    1 +
 4 files changed, 168 insertions(+), 1 deletion(-)

diff --git a/spaceman/Makefile b/spaceman/Makefile
index 612d36b..b651904 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -8,7 +8,7 @@ include $(TOPDIR)/include/builddefs
 LTCOMMAND = xfs_spaceman
 HFILES = init.h space.h
 CFILES = init.c \
-	file.c freesp.c
+	file.c freesp.c prealloc.c
 
 LLDLIBS = $(LIBXCMD)
 LTDEPENDENCIES = $(LIBXCMD)
diff --git a/spaceman/init.c b/spaceman/init.c
index 108dcd7..aa53be4 100644
--- a/spaceman/init.c
+++ b/spaceman/init.c
@@ -40,6 +40,7 @@ init_commands(void)
 	file_init();
 	freesp_init();
 	help_init();
+	prealloc_init();
 	quit_init();
 }
 
diff --git a/spaceman/prealloc.c b/spaceman/prealloc.c
new file mode 100644
index 0000000..8af30a6
--- /dev/null
+++ b/spaceman/prealloc.c
@@ -0,0 +1,165 @@
+/*
+ * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
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
+#include <xfs/xfs_types.h>
+#include <xfs/command.h>
+#include <linux/dqblk_xfs.h>
+#include "init.h"
+#include "space.h"
+
+#ifndef XFS_IOC_FREE_EOFBLOCKS
+#define XFS_IOC_FREE_EOFBLOCKS _IOR ('X', 58, struct xfs_eofblocks)
+
+#define XFS_EOFBLOCKS_VERSION		1
+struct xfs_eofblocks {
+	__u32		eof_version;
+	__u32		eof_flags;
+	__u32		eof_q_id;
+	__u32		eof_q_type;
+	__u32		eof_min_file_size;
+	unsigned char	pad[12];
+};
+
+/* eof_flags values */
+#define XFS_EOF_FLAGS_SYNC		0x01	/* sync/wait mode scan */
+#define XFS_EOF_FLAGS_QUOTA		0x02	/* filter by quota id */
+#define XFS_EOF_FLAGS_MINFILESIZE	0x04	/* filter by min file size */
+#endif
+
+int gflag;
+int uflag;
+int pflag;
+int sflag;
+int qid;
+int minlen;
+
+static cmdinfo_t prealloc_cmd;
+
+/*
+ * Report on freespace usage in xfs filesystem.
+ */
+static int
+prealloc_f(
+	int	argc,
+	char	**argv)
+{
+	int	c;
+	struct xfs_eofblocks eofb = {0};
+
+	uflag = 0;
+	gflag = 0;
+	pflag = 0;
+	sflag = 0;
+	minlen = 0;
+	qid = 0;
+
+	while ((c = getopt(argc, argv, "g:m:p:su:")) != EOF) {
+		switch (c) {
+		case 'g':
+			if (uflag || pflag)
+				return command_usage(&prealloc_cmd);
+			gflag = 1;
+			qid = atoi(optarg);
+			break;
+		case 'u':
+			if (gflag || pflag)
+				return command_usage(&prealloc_cmd);
+			uflag = 1;
+			qid = atoi(optarg);
+			break;
+		case 'p':
+			if (uflag || gflag)
+				return command_usage(&prealloc_cmd);
+			pflag = 1;
+			qid = atoi(optarg);
+			break;
+		case 's':
+			sflag = 1;
+			break;
+		case 'm':
+			minlen = atoi(optarg);
+			break;
+		case '?':
+			return command_usage(&prealloc_cmd);
+		}
+	}
+	if (optind != argc)
+		return command_usage(&prealloc_cmd);
+
+	eofb.eof_version = XFS_EOFBLOCKS_VERSION;
+	if (sflag)
+		eofb.eof_flags |= XFS_EOF_FLAGS_SYNC;
+
+	if (minlen) {
+		eofb.eof_flags |= XFS_EOF_FLAGS_MINFILESIZE;
+		eofb.eof_min_file_size = minlen;
+	}
+	if (uflag || gflag || pflag) {
+		eofb.eof_flags |= XFS_EOF_FLAGS_QUOTA;
+		eofb.eof_q_id = qid;
+		if (uflag)
+			eofb.eof_q_type = XQM_USRQUOTA;
+		else if (gflag)
+			eofb.eof_q_type = XQM_GRPQUOTA;
+		else if (pflag)
+			eofb.eof_q_type = XQM_PRJQUOTA;
+	}
+
+	if (xfsctl(file->name, file->fd, XFS_IOC_FREE_EOFBLOCKS, &eofb) < 0) {
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
+" -u id -- remove prealloc on files matching user quota id <id>\n"
+" -g id -- remove prealloc on files matching group quota id <id>\n"
+" -p id -- remove prealloc on files matching project quota id <id>\n"
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
+	prealloc_cmd.flags = CMD_FLAG_GLOBAL;
+	prealloc_cmd.oneline = _("Control specualtive preallocation");
+	prealloc_cmd.help = prealloc_help;
+
+	add_command(&prealloc_cmd);
+}
+
diff --git a/spaceman/space.h b/spaceman/space.h
index c6a63fe..33789a3 100644
--- a/spaceman/space.h
+++ b/spaceman/space.h
@@ -35,3 +35,4 @@ extern void	file_init(void);
 extern void	help_init(void);
 extern void	quit_init(void);
 extern void	freesp_init(void);
+extern void	prealloc_init(void);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
