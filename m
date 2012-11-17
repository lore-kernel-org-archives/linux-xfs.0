Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAH20UHY181723 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 20:00:30 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	T43TYdPwfWMp2phc for <xfs@oss.sgi.com>;
	Fri, 16 Nov 2012 18:02:34 -0800 (PST)
Date: Sat, 17 Nov 2012 13:02:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfsprogs: Introduce a new subcommand agstate to
	xfs_fio
Message-ID: <20121117020231.GP14281@dastard>
References: <50A5E258.3000509@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50A5E258.3000509@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

On Fri, Nov 16, 2012 at 02:51:04PM +0800, Jeff Liu wrote:
> Introduce a new xfs_io command: agstate.
> 
> This command is used to get/set state for a given allocation group.

xfs_io is not the place for this command. 

A couple of weeks ago I started writing an xfs_spaceman module and
an ioctl interface for exactly this purpose, I just hadn't got
around to completing it and the kernel patch to test it so I hadn't
posted it.  Once the userspace release is out of the way, I'll post
the patches to get xfs_spaceman into xfs_progs, and we can use that
for this AG control from the start.

The reason for this is that the AG state in future is going to be a
lot more complex than just enabling/disabling allocation, and the
ioctl interface I prototyped supports a lot of that future
functionality. 

The patch is below so you can see what sort of AG control/state
functionality I think we'll be needing sooner rather than later, and
the interface I think we should be using...

> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  include/xfs_ag.h |   32 ++++++++++++++++++++++++++++----
>  include/xfs_fs.h |    2 ++
>  io/Makefile      |    2 +-
>  io/init.c        |    1 +
>  4 files changed, 32 insertions(+), 5 deletions(-)

FWIW, I think you forgot to include the file that introduces the
command in the patch :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


spaceman: AG state control

From: Dave Chinner <dchinner@redhat.com>

Add support for a new allocation group state control ioctl. This
allows control of various AG parameters, such as whether inode
allocation is allowed in the AG, metadata preference, whether new
allocations are allowed, etc. This requires a new ioctl.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 spaceman/Makefile |    2 +-
 spaceman/ag.c     |  221 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 222 insertions(+), 1 deletion(-)

diff --git a/spaceman/Makefile b/spaceman/Makefile
index 4743ad8..dd19cb0 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -8,7 +8,7 @@ include $(TOPDIR)/include/builddefs
 LTCOMMAND = xfs_spaceman
 HFILES = init.h space.h
 CFILES = init.c \
-	file.c freesp.c prealloc.c trim.c
+	ag.c file.c freesp.c prealloc.c trim.c
 
 LLDLIBS = $(LIBXCMD)
 LTDEPENDENCIES = $(LIBXCMD)
diff --git a/spaceman/ag.c b/spaceman/ag.c
new file mode 100644
index 0000000..40333c2
--- /dev/null
+++ b/spaceman/ag.c
@@ -0,0 +1,221 @@
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
+#include <xfs/xfs_types.h>
+#include <xfs/command.h>
+#include <linux/dqblk_xfs.h>
+#include "input.h"
+#include "init.h"
+#include "space.h"
+
+#ifndef XFS_IOC_AGCONTROL
+#define XFS_IOC_AGCONTROL _IOWR ('X', 60, struct xfs_agcontrol)
+
+#define XFS_AGCONTROL_VERSION		1
+struct xfs_agcontrol {
+	__u32		version;
+	__u32		flags;
+	__u32		agno;
+	__u32		state;
+	__u64		pad[8];
+};
+
+/* control flags */
+#define XFS_AGCONTROL_GETAGFSTATE	(1 << 0)	/* get AGF state */
+#define XFS_AGCONTROL_SETAGFSTATE	(1 << 1)	/* set AGF state */
+#define XFS_AGCONTROL_GETAGISTATE	(1 << 2)	/* get AGI state */
+#define XFS_AGCONTROL_SETAGISTATE	(1 << 3)	/* set AGI state */
+
+/* state flags */
+
+/*
+ * inode and allocation states are split. AGF and AGI online state will move in
+ * sync as it is really a whole AG state. No allocation flags imply no new
+ * allocations, but inodes and extents can be removed. Readonly means no
+ * modification (alloc or free) is allowed. This is to allow different
+ * operations to be performed. e.g. emptying an AG in preparation for a shrink
+ * require NOALLOC state, but an AG that has a corrupted freespace btree might
+ * be switched to READONLY until the freespace tree is rebuilt. An AGF/AGI in
+ * this corrupt/ro state will set the relevant corruption flag in the state
+ * field....
+ */
+#define XFS_AGFSTATE_ONLINE		(1 << 0)	/* AGF online */
+#define XFS_AGFSTATE_NOALLOC		(1 << 1)	/* No new allocation */
+#define XFS_AGFSTATE_READONLY		(1 << 2)	/* AGF is immutable */
+#define XFS_AGFSTATE_METADATA		(1 << 3)	/* metadata preferred */
+#define XFS_AGFSTATE_CORRUPT_BNO	(1 << 4)	/* bno freespace corrupt */
+#define XFS_AGFSTATE_CORRUPT_CNT	(1 << 5)	/* cnt freespace corrupt */
+#define XFS_AGFSTATE_CORRUPT_AGFL	(1 << 6)	/* AGFL freespace corrupt */
+
+#define XFS_AGISTATE_ONLINE		(1 << 0)	/* AGI online */
+#define XFS_AGISTATE_NOALLOC		(1 << 1)	/* No new allocation */
+#define XFS_AGISTATE_READONLY		(1 << 2)	/* AGI is immutable */
+#define XFS_AGISTATE_CORRUPT_TREE	(1 << 2)	/* AGI btree corrupt */
+
+#endif
+
+static cmdinfo_t agfctl_cmd;
+static cmdinfo_t agictl_cmd;
+
+static int
+agfctl_f(
+	int		argc,
+	char		**argv)
+{
+	struct xfs_agcontrol agctl = {0};
+	xfs_agnumber_t	agno;
+	int		gflag = 0;
+	int		c;
+
+	while ((c = getopt(argc, argv, "gs")) != EOF) {
+		switch (c) {
+		case 'g':
+			gflag = 1;
+			break;
+		default:
+			return command_usage(&agfctl_cmd);
+		}
+	}
+	if (optind != argc - 1)
+		return command_usage(&agfctl_cmd);
+
+	agno = atoi(argv[optind]);
+	if (agno >= file->geom.agcount) {
+		fprintf(stderr, _("%s: agno %d out of range (max %d)\n"),
+			progname, agno, file->geom.agcount);
+		exitcode = 1;
+		return 0;
+	}
+
+	agctl.version = XFS_AGCONTROL_VERSION;
+	agctl.agno = agno;
+	if (gflag)
+		agctl.flags = XFS_AGCONTROL_GETAGFSTATE;
+
+	if (xfsctl(file->name, file->fd, XFS_IOC_AGCONTROL, &agctl) < 0) {
+		fprintf(stderr, _("%s: XFS_IOC_AGCONTROL on %s: %s\n"),
+			progname, file->name, strerror(errno));
+	}
+	return 0;
+}
+
+static void
+agfctl_help(void)
+{
+	printf(_(
+"\n"
+"AGF state control\n"
+"\n"
+"Options: [-g] agno\n"
+"\n"
+" -g -- get state\n"
+" agno -- AG to operate on\n"
+"\n"));
+
+}
+
+void
+agfctl_init(void)
+{
+	agfctl_cmd.name = "agfctl";
+	agfctl_cmd.altname = "agfctl";
+	agfctl_cmd.cfunc = agfctl_f;
+	agfctl_cmd.argmin = 2;
+	agfctl_cmd.argmax = -1;
+	agfctl_cmd.args = "agno\n";
+	agfctl_cmd.flags = CMD_FLAG_GLOBAL;
+	agfctl_cmd.oneline = _("AGF state control");
+	agfctl_cmd.help = agfctl_help;
+
+	add_command(&agfctl_cmd);
+}
+
+static int
+agictl_f(
+	int		argc,
+	char		**argv)
+{
+	struct xfs_agcontrol agctl = {0};
+	xfs_agnumber_t	agno;
+	int		gflag = 0;
+	int		c;
+
+	while ((c = getopt(argc, argv, "gs")) != EOF) {
+		switch (c) {
+		case 'g':
+			gflag = 1;
+			break;
+		default:
+			return command_usage(&agictl_cmd);
+		}
+	}
+	if (optind != argc - 1)
+		return command_usage(&agictl_cmd);
+
+	agno = atoi(argv[optind]);
+	if (agno >= file->geom.agcount) {
+		fprintf(stderr, _("%s: agno %d out of range (max %d)\n"),
+			progname, agno, file->geom.agcount);
+		exitcode = 1;
+		return 0;
+	}
+
+	agctl.version = XFS_AGCONTROL_VERSION;
+	agctl.agno = agno;
+	if (gflag)
+		agctl.flags = XFS_AGCONTROL_GETAGISTATE;
+
+	if (xfsctl(file->name, file->fd, XFS_IOC_AGCONTROL, &agctl) < 0) {
+		fprintf(stderr, _("%s: XFS_IOC_AGCONTROL on %s: %s\n"),
+			progname, file->name, strerror(errno));
+		exitcode = 1;
+		return 0;
+	}
+	return 0;
+}
+static void
+agictl_help(void)
+{
+	printf(_(
+"\n"
+"AGI state control\n"
+"\n"
+"Options: [-g] agno\n"
+"\n"
+" -g -- get state\n"
+" agno -- AG to operate on\n"
+"\n"));
+
+}
+
+void
+agictl_init(void)
+{
+	agictl_cmd.name = "agictl";
+	agictl_cmd.altname = "agictl";
+	agictl_cmd.cfunc = agictl_f;
+	agictl_cmd.argmin = 2;
+	agictl_cmd.argmax = -1;
+	agictl_cmd.args = "agno\n";
+	agictl_cmd.flags = CMD_FLAG_GLOBAL;
+	agictl_cmd.oneline = _("AGI state control");
+	agictl_cmd.help = agictl_help;
+
+	add_command(&agictl_cmd);
+}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
