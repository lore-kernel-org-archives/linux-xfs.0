Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBUIElsM000558 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 12:14:48 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E0695312C
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 10:14:47 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id oZjB9e5z7tUyht1B for
	<xfs@oss.sgi.com>; Tue, 30 Dec 2008 10:14:47 -0800 (PST)
Message-Id: <20081230181446.544536013@sandeen.net>
References: <20081230181413.518122170@sandeen.net>
Date: Tue, 30 Dec 2008 12:14:16 -0600
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [patch 3/4] acl: Return error status on setfacl failures
Content-Disposition: inline; filename=acl-2.2.45-exitcode.patch
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

Resolves Red Hat bug:
 Bug 368451 -  setfacl returns 0 even though it fails

From: Jiri Moskovcak <jmoskovc@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: xfs-cmds/acl/setfacl/setfacl.c
===================================================================
--- xfs-cmds.orig/acl/setfacl/setfacl.c
+++ xfs-cmds/acl/setfacl/setfacl.c
@@ -137,7 +137,7 @@ restore(
 		if (error < 0)
 			goto fail;
 		if (error == 0)
-			return 0;
+			return status;
 
 		if (path_p == NULL) {
 			if (filename) {
@@ -151,6 +151,7 @@ restore(
 						 "aborting\n"),
 					progname, backup_line);
 			}
+			status = 1;
 			goto getout;
 		}
 
@@ -169,6 +170,7 @@ restore(
 			fprintf(stderr, _("%s: %s: %s in line %d\n"),
 			        progname, xquote(filename), strerror(errno),
 				line);
+			status = 1;
 			goto getout;
 		}
 

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
