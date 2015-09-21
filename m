Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D3A767F37
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 03:56:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B59158F8049
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 01:56:15 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nKdvimWGFVVFlh0D (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Sep 2015 01:56:14 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 36A3224B
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 08:56:14 +0000 (UTC)
Received: from zion.usersys.redhat.com (vpn-225-125.phx2.redhat.com
	[10.3.225.125])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8L8uCUv011786
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 04:56:13 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] xfs_io: Implement inodes64 command
Date: Mon, 21 Sep 2015 10:56:08 +0200
Message-Id: <1442825768-5793-1-git-send-email-cmaiolino@redhat.com>
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

Implement an easy way to check a filesystem for the existence of 64bit inodes.

Based on XFS_IOC_FSINUMBERS, and starting with a lastip of XFS_MAXINUMBER_32, it
returns a string saying if there is or there isn't 64bit inodes in the
filesystem.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 io/open.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/io/open.c b/io/open.c
index ac5a5e0..b25b09d 100644
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
+static cmdinfo_t inodes64_cmd;
 static prid_t prid;
 static long extsize;
 
@@ -750,6 +752,36 @@ statfs_f(
 	return 0;
 }
 
+static int
+inodes64_f(
+	  int			argc,
+	  char			**argv)
+{
+	int			i;
+	__s32			count;
+	__u64			last = XFS_MAXINUMBER_32;
+	xfs_inogrp_t		igroup;
+	xfs_fsop_bulkreq_t	bulkreq;
+
+	bulkreq.lastip = &last;
+	bulkreq.icount = 1;
+	bulkreq.ubuffer = &igroup;
+	bulkreq.ocount = &count;
+
+	if (!xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS, &bulkreq)) {
+		if (count > 0) {
+			printf("Filesystem does have 64bit inodes\n");
+			return 0;
+		} else {
+			printf("Filesystem does not have 64bit inodes\n");
+			return 0;
+		}
+	}
+	perror("xfsctl(XFS_IOC_FSINUMBERS)");
+	exitcode = 1;
+	return 0;
+}
+
 void
 open_init(void)
 {
@@ -815,6 +847,12 @@ open_init(void)
 		_("get/set preferred extent size (in bytes) for the open file");
 	extsize_cmd.help = extsize_help;
 
+	inodes64_cmd.name = "inodes64";
+	inodes64_cmd.cfunc = inodes64_f;
+	inodes64_cmd.flags = CMD_NOMAP_OK;
+	inodes64_cmd.oneline =
+		_("Checks if filesyste contais 64bit inodes");
+
 	add_command(&open_cmd);
 	add_command(&stat_cmd);
 	add_command(&close_cmd);
@@ -822,4 +860,5 @@ open_init(void)
 	add_command(&chproj_cmd);
 	add_command(&lsproj_cmd);
 	add_command(&extsize_cmd);
+	add_command(&inodes64_cmd);
 }
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
