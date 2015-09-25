Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3FE4C7F56
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 08:08:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EF90230404E
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 06:07:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ofi5nQMZq9bdal6t (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 25 Sep 2015 06:07:56 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 1F2ED19F20B
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 13:07:56 +0000 (UTC)
Received: from zion.usersys.redhat.com (dhcp-26-103.brq.redhat.com
	[10.34.26.103])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8PD7paa000474
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 09:07:55 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 1/3] xfs_io: Add inode '-s' command to query physical size of
	largest inode
Date: Fri, 25 Sep 2015 15:07:45 +0200
Message-Id: <1443186467-20110-2-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1443186467-20110-1-git-send-email-cmaiolino@redhat.com>
References: <1443186467-20110-1-git-send-email-cmaiolino@redhat.com>
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

Add a new inode command to xfs_io, which aims to implement a tool for query
information about inode usage of the filesystem.

This patch implements '-s' inode option, which query the filesystem for the
physical size of the largest filesystem inode

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 io/open.c | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/io/open.c b/io/open.c
index ac5a5e0..6a794ba 100644
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
 
@@ -750,6 +752,74 @@ statfs_f(
 	return 0;
 }
 
+static void
+inode_help(void)
+{
+	printf(_(
+"\n"
+"Query physical information about the inode"
+"\n"
+" -s	-- Returns the physical size (in bits) of the\n"
+"	   largest inode number in the filesystem\n"
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
+	struct xfs_inogrp	igroup[1024];
+	struct xfs_fsop_bulkreq	bulkreq;
+	int			c;
+	int			ret_lsize = 0;
+
+	bulkreq.lastip = &last;
+	bulkreq.icount = 1024; /* maybe an user-defined value!? */
+	bulkreq.ubuffer = &igroup;
+	bulkreq.ocount = &count;
+
+	while ((c = getopt(argc, argv, "s")) != EOF) {
+		switch (c) {
+		case 's':
+			ret_lsize = 1;
+			break;
+		default:
+			return command_usage(&inode_cmd);
+		}
+	}
+
+	if (ret_lsize) {
+		for (;;) {
+			if (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS,
+					&bulkreq)) {
+				perror("XFS_IOC_FSINUMBERS");
+				exitcode = 1;
+				return 0;
+			}
+			if (count < XFS_INODES_PER_CHUNK && count > 0)
+				lastgrp = count;
+			if (!count)
+				break;
+		}
+
+		lastgrp--;
+		lastino = igroup[lastgrp].xi_startino +
+			  xfs_highbit64(igroup[lastgrp].xi_allocmask);
+
+		printf (_("Largest inode size: %d\n"),
+			 lastino > XFS_MAXINUMBER_32 ? 64 : 32);
+
+	}
+
+
+	return 0;
+}
+
 void
 open_init(void)
 {
@@ -815,6 +885,16 @@ open_init(void)
 		_("get/set preferred extent size (in bytes) for the open file");
 	extsize_cmd.help = extsize_help;
 
+	inode_cmd.name = "inode";
+	inode_cmd.cfunc = inode_f;
+	inode_cmd.args = _("[-s]");
+	inode_cmd.argmin = 1;
+	inode_cmd.argmax = 1;
+	inode_cmd.flags = CMD_NOMAP_OK;
+	inode_cmd.oneline =
+		_("Query inode number usage in the filesystem");
+	inode_cmd.help = inode_help;
+
 	add_command(&open_cmd);
 	add_command(&stat_cmd);
 	add_command(&close_cmd);
@@ -822,4 +902,5 @@ open_init(void)
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
