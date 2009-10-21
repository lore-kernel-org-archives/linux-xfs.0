Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9L3V1rb200766 for <xfs@oss.sgi.com>; Tue, 20 Oct 2009 22:31:01 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 656A611B9B99
	for <xfs@oss.sgi.com>; Tue, 20 Oct 2009 20:32:34 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id IPokQxfyob02im5c for
	<xfs@oss.sgi.com>; Tue, 20 Oct 2009 20:32:34 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 4AF02AAE3B9
	for <xfs@oss.sgi.com>; Tue, 20 Oct 2009 22:32:34 -0500 (CDT)
Message-ID: <4ADE80D1.7080408@sandeen.net>
Date: Tue, 20 Oct 2009 22:32:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: fix up have_xlog_assign_lsn config test
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Without this we weren't building src/loggen

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/aclocal.m4 b/aclocal.m4
index 8a61e39..6e1e672 100644
--- a/aclocal.m4
+++ b/aclocal.m4
@@ -422,10 +422,10 @@ AC_DEFUN([AC_PACKAGE_WANT_XFS_LIBXFS_H],
   ])
 
 AC_DEFUN([AC_PACKAGE_WANT_XLOG_ASSIGN_LSN],
-  [
-    AC_CHECK_DECL(xlog_assign_lsn,
+  [ AC_CHECK_DECL(xlog_assign_lsn,
       [ have_xlog_assign_lsn=true ], [ have_xlog_assign_lsn=false ],
       [[#include <xfs/libxfs.h>]])
+    AC_SUBST(have_xlog_assign_lsn)
   ])
 
 AC_DEFUN([AC_PACKAGE_NEED_XFS_XQM_H],
diff --git a/m4/package_xfslibs.m4 b/m4/package_xfslibs.m4
index 870882f..f5167a2 100644
--- a/m4/package_xfslibs.m4
+++ b/m4/package_xfslibs.m4
@@ -14,11 +14,10 @@ AC_DEFUN([AC_PACKAGE_WANT_LIBXFS_H],
   ])
 
 AC_DEFUN([AC_PACKAGE_WANT_XLOG_ASSIGN_LSN],
-  [
-    AC_CHECK_DECL(xlog_assign_lsn,
+  [ AC_CHECK_DECL(xlog_assign_lsn,
       [ have_xlog_assign_lsn=true ], [ have_xlog_assign_lsn=false ],
       [[#include <xfs/libxfs.h>]])
-    AC_SUBST(have_have_xlog_assign_lsn)
+    AC_SUBST(have_xlog_assign_lsn)
   ])
 
 AC_DEFUN([AC_PACKAGE_NEED_XFS_XQM_H],


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
