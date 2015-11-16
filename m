Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D88B37F59
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 02:43:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BA1968F8035
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 00:43:39 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OWDviytWGfvuNFZS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 16 Nov 2015 00:43:35 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id D4989C001264
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 08:43:34 +0000 (UTC)
Received: from zion.usersys.redhat.com (dhcp-26-103.brq.redhat.com
	[10.34.26.103])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tAG8hVmj008258
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 03:43:34 -0500
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 1/2] xfs_io: implement 'inode' command V4
Date: Mon, 16 Nov 2015 09:43:23 +0100
Message-Id: <1447663404-7857-2-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1447663404-7857-1-git-send-email-cmaiolino@redhat.com>
References: <1447663404-7857-1-git-send-email-cmaiolino@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Implements a new xfs_io command, named 'inode', which is supposed to be used to
query information about inode's existence and its physical size in the
filesystem.

Currently supporting three arguments:
-s       -- return physical size of the largest inode
-l       -- return the largest inode number allocated and used
-n [num] -- Return the next existing inode after [num], even if [num] is not
            allocated/used
[num]    -- Return if the inode exists or not.

I didn't send the man page patch because I'm sure I'll get some points to
improve, and I'll write the manpage for the next revision.

- Changelog

V3:
	- Merge all 3 patches from the V2 together in a single patch
	- Rework of '-n [num]' and 'num' only arguments algorithm
	- Argument -n now relies on bulkreq.count to check for next inodes, not
	  on bstat.bs_ino anymore.
	- for loop in ret_lsize or ret_largest case, now relies on count being 0
	  to break the loop

V4:
	- Refactor inode_f function to reduce its size and easier logic
	- Implement error handlers for invalid command combination (hopefully
	  all invalid combinations).
	- use a single xfs_inogrp array for keep track of inodes
	- Fix missing newline in inode_help()
	- Rewrite help message in inode_help()
	- Fix indentation

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 io/open.c | 151 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 151 insertions(+)

diff --git a/io/open.c b/io/open.c
index ac5a5e0..2fc8aab 100644
--- a/io/open.c
+++ b/io/open.c
@@ -20,6 +20,7 @@
 #include "input.h"
 #include "init.h"
 #include "io.h"
+#include "libxfs.h"
 
 #ifndef __O_TMPFILE
 #if defined __alpha__
@@ -44,6 +45,7 @@ static cmdinfo_t statfs_cmd;
 static cmdinfo_t chproj_cmd;
 static cmdinfo_t lsproj_cmd;
 static cmdinfo_t extsize_cmd;
+static cmdinfo_t inode_cmd;
 static prid_t prid;
 static long extsize;
 
@@ -750,6 +752,144 @@ statfs_f(
 	return 0;
 }
 
+static void
+inode_help(void)
+{
+	printf(_(
+"\n"
+"Query physical information about the inode"
+"\n"
+" -l	-- Returns the largest inode number in the filesystem\n"
+" -s	-- Returns the physical size (in bits) of the\n"
+"	   largest inode number in the filesystem\n"
+" -n	-- Return the next valid inode after [num]\n"
+"[num]	   Check if the inode [num] is in use\n"
+"\n"));
+}
+
+static int
+inode_f(
+	  int			argc,
+	  char			**argv)
+{
+	__s32			count = 0;
+	__s32			lastgrp = 0;
+	__u64			last = 0;
+	__u64			lastino = 0;
+	__u64			userino = 0;
+	char			*p;
+	int			c;
+	int			ret_lsize = 0;
+	int			ret_largest = 0;
+	int			ret_next = 0;
+	int			cmd = 0;
+	struct xfs_inogrp	igroup[1024], igrp_rec;
+	struct xfs_fsop_bulkreq	bulkreq;
+	struct xfs_bstat	bstat;
+
+
+	while ((c = getopt(argc, argv, "sln")) != EOF) {
+		switch (c) {
+		case 's':
+			ret_lsize = 1;
+			break;
+		case 'l':
+			ret_largest = 1;
+			break;
+		case 'n':
+			ret_next = 1;
+			break;
+		default:
+			return command_usage(&inode_cmd);
+		}
+	}
+
+	if (optind < argc) {
+		if (ret_lsize || ret_largest)
+			return command_usage(&inode_cmd);
+
+		if (ret_next) {
+			if (argc > 3)
+				return command_usage(&inode_cmd);
+			else
+				cmd = XFS_IOC_FSBULKSTAT;
+		} else {
+			if (argc > 2)
+				return command_usage(&inode_cmd);
+			else
+				cmd = XFS_IOC_FSBULKSTAT_SINGLE;
+		}
+
+
+		userino = strtoull(argv[optind], &p, 10);
+		if ((*p != '\0')) {
+			printf(_("[num] must be a numeric value\n"));
+			exitcode = 1;
+			return 0;
+		}
+
+		bulkreq.lastip = &userino;
+		bulkreq.icount = 1;
+		bulkreq.ubuffer = &bstat;
+		bulkreq.ocount = &count;
+
+		if (xfsctl(file->name, file->fd, cmd, &bulkreq)) {
+			if (errno == EINVAL)
+				printf(_("Invalid or unlinked inode\n"));
+			else
+				perror("xfsctl");
+			exitcode = 1;
+			return 0;
+		}
+
+		if (ret_next) {
+			printf(_("Next inode: %llu\n"), bstat.bs_ino);
+			return 0;
+		} else {
+			printf(_("Valid inode: %llu\n"), bstat.bs_ino);
+			return 0;
+		}
+	}
+
+	if (ret_lsize || ret_largest) {
+
+		bulkreq.lastip = &last;
+		bulkreq.icount = 1024; /* User-defined maybe!? */
+		bulkreq.ubuffer = &igroup;
+		bulkreq.ocount = &count;
+
+		for (;;) {
+
+			if (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS,
+					&bulkreq)) {
+				perror("XFS_IOC_FSINUMBERS");
+				exitcode = 1;
+				return 0;
+			}
+
+			if (count == 0)
+				break;
+
+			lastgrp = count;
+		}
+
+		lastgrp--;
+		igrp_rec = igroup[lastgrp];
+		lastino = igrp_rec.xi_startino +
+			  xfs_highbit64(igrp_rec.xi_allocmask);
+
+		if (ret_lsize)
+			printf (_("Largest inode size: %d\n"),
+				lastino > XFS_MAXINUMBER_32 ? 64 : 32);
+		else
+			printf(_("Largest inode: %llu\n"), lastino);
+
+		return 0;
+	}
+
+	return command_usage(&inode_cmd);
+}
+
 void
 open_init(void)
 {
@@ -815,6 +955,16 @@ open_init(void)
 		_("get/set preferred extent size (in bytes) for the open file");
 	extsize_cmd.help = extsize_help;
 
+	inode_cmd.name = "inode";
+	inode_cmd.cfunc = inode_f;
+	inode_cmd.args = _("[-s | -l | -n] [num]");
+	inode_cmd.argmin = 1;
+	inode_cmd.argmax = 2;
+	inode_cmd.flags = CMD_NOMAP_OK;
+	inode_cmd.oneline =
+		_("Query inode number usage in the filesystem");
+	inode_cmd.help = inode_help;
+
 	add_command(&open_cmd);
 	add_command(&stat_cmd);
 	add_command(&close_cmd);
@@ -822,4 +972,5 @@ open_init(void)
 	add_command(&chproj_cmd);
 	add_command(&lsproj_cmd);
 	add_command(&extsize_cmd);
+	add_command(&inode_cmd);
 }
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
