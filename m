Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 486757F50
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 07:31:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 167028F8049
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 05:31:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rOP5kMYrvqzA7l70 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 19 Oct 2015 05:31:27 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 99E4619F223
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 12:31:26 +0000 (UTC)
Received: from zion.usersys.redhat.com (dhcp-26-103.brq.redhat.com
	[10.34.26.103])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t9JCVPvi026933
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 08:31:26 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] xfs_io: implement 'inode' command V3
Date: Mon, 19 Oct 2015 14:31:20 +0200
Message-Id: <1445257880-30797-1-git-send-email-cmaiolino@redhat.com>
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

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 io/open.c | 161 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 161 insertions(+)

diff --git a/io/open.c b/io/open.c
index ac5a5e0..59b5c94 100644
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
 
@@ -750,6 +752,154 @@ statfs_f(
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
+" -n	-- Return the next valid inode after [num]"
+"[num]	   Check if the inode [num] exists in the filesystem"
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
+	struct xfs_inogrp	igroup[1024], igrp_rec[1024];
+	struct xfs_fsop_bulkreq	bulkreq;
+	struct xfs_bstat	bstat;
+
+
+	while ((c = getopt(argc, argv, "sln:")) != EOF) {
+		switch (c) {
+		case 's':
+			ret_lsize = 1;
+			break;
+		case 'l':
+			ret_largest = 1;
+			break;
+		case 'n':
+			ret_next = 1;
+			userino = strtoull(optarg, &p, 10);
+			break;
+		default:
+			return command_usage(&inode_cmd);
+		}
+	}
+
+	if (((optind < argc) || ret_next) &&
+	     !(ret_lsize || ret_largest)) {
+
+		/* Setup bulkreq for -n or [num] only */
+		bulkreq.lastip = &last;
+		bulkreq.icount = 1;
+		bulkreq.ubuffer = &bstat;
+		bulkreq.ocount = &count;
+
+		if (ret_next) {
+				if ((*p != '\0')) {
+					printf(_("[num] must be a numeric value\n"));
+					exitcode = 1;
+					return 0;
+				}
+			last = userino;
+			if (xfsctl(file->name, file->fd, XFS_IOC_FSBULKSTAT,
+					&bulkreq)) {
+				if (errno == EINVAL)
+					printf(_("Invalid or non-existent inode\n"));
+				else
+					perror("XFS_IOC_FSBULKSTAT");
+				exitcode = 1;
+				return 0;
+			}
+
+			if (!count) {
+			printf(_("There are no further inodes in the filesystem\n"));
+			return 0;
+			}
+
+			printf(_("Next inode: %llu\n"), bstat.bs_ino);
+			return 0;
+		} else {
+			userino = strtoull(argv[optind], &p, 10);
+				if ((*p != '\0')) {
+					printf(_("[num] must be a numeric value\n"));
+					exitcode = 1;
+					return 0;
+				}
+			last = userino;
+			if (xfsctl(file->name, file->fd, XFS_IOC_FSBULKSTAT_SINGLE,
+					&bulkreq)) {
+				if (errno == EINVAL) {
+					printf(_("Invalid or non-existent inode number\n"));
+				} else
+					perror("XFS_IOC_FSBULKSTAT_SINGLE");
+				exitcode = 1;
+				return 0;
+			}
+			printf(_("Valid inode: %llu\n"), bstat.bs_ino);
+			return 0;
+
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
+			memcpy(igrp_rec, igroup,
+				sizeof(struct xfs_inogrp) * 1024);
+		}
+
+		lastgrp--;
+		lastino = igrp_rec[lastgrp].xi_startino +
+			  xfs_highbit64(igrp_rec[lastgrp].xi_allocmask);
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
@@ -815,6 +965,16 @@ open_init(void)
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
@@ -822,4 +982,5 @@ open_init(void)
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
