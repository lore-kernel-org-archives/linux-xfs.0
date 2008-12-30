Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBUIEmYH000562 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 12:14:48 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 05B7653135
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 10:14:47 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id LcXyAeUkOm0zp0Yy for
	<xfs@oss.sgi.com>; Tue, 30 Dec 2008 10:14:47 -0800 (PST)
Message-Id: <20081230181447.028003436@sandeen.net>
References: <20081230181413.518122170@sandeen.net>
Date: Tue, 30 Dec 2008 12:14:17 -0600
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [patch 4/4] acl: fix setfacl for long utf8 filenames
Content-Disposition: inline; filename=acl-2.2.39-path_max.patch
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

Resolves Red Hat bugs:
 Bug 183181 -  Bad: utf8 long filenames - invalid argument
 Bug 287701 -  PATH_MAX patch seems incomplete

From: Andrey <afletdinov@dc.baikal.ru>
From: Thomas Woerner <twoerner@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: xfs-cmds/acl/setfacl/parse.c
===================================================================
--- xfs-cmds.orig/acl/setfacl/parse.c
+++ xfs-cmds/acl/setfacl/parse.c
@@ -24,6 +24,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <errno.h>
+#include <limits.h>
 
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -412,7 +413,12 @@ read_acl_comments(
 	gid_t *gid_p)
 {
 	int c;
-	char linebuf[1024];
+	/*
+	  Max PATH_MAX bytes even for UTF-8 path names and additional 9 
+	  bytes for "# file: ".Not a good solution but for now it is the 
+	  best I can do without too much impact on the code. [tw]
+	*/
+	char linebuf[(4*PATH_MAX)+9];
 	char *cp;
 	char *p;
 	int comments_read = 0;

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
