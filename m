Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p430C7Ek253487 for <xfs@oss.sgi.com>; Mon, 2 May 2011 19:12:07 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2836FA5511C
	for <xfs@oss.sgi.com>; Mon,  2 May 2011 17:15:43 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id AjPUUlQdms19Ei5q for <xfs@oss.sgi.com>;
	Mon, 02 May 2011 17:15:43 -0700 (PDT)
Message-ID: <4DBF492E.3040400@sandeen.net>
Date: Mon, 02 May 2011 19:15:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: clean up fallocate configuration tests
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
To: xfs-oss <xfs@oss.sgi.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>

When I added fallocate support to fsx I inadvertently added
a duplicate fallocate test.

Consolidate them both into one test (the link test, not the
compile test) and make all tests use "true" rather than "yes"
to be more consistent with other tests.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/aclocal.m4 b/aclocal.m4
index 70ea0f3..168eb59 100644
--- a/aclocal.m4
+++ b/aclocal.m4
@@ -18,27 +18,14 @@ AC_DEFUN([AC_PACKAGE_WANT_LINUX_FIEMAP_H],
 
 AC_DEFUN([AC_PACKAGE_WANT_FALLOCATE],
   [ AC_MSG_CHECKING([for fallocate])
-    AC_TRY_COMPILE([
-#include <linux/falloc.h>
-    ], [
-         fallocate(0, 0, 0, 0);
-    ], have_fallocate=true
-       AC_MSG_RESULT(true),
-       AC_MSG_RESULT(false))
-    AC_SUBST(have_fallocate)
-  ])
-AC_DEFUN([AC_PACKAGE_WANT_FALLOCATE],
-  [ AC_MSG_CHECKING([for fallocate])
     AC_TRY_LINK([
 #define _GNU_SOURCE
 #define _FILE_OFFSET_BITS 64
 #include <fcntl.h>
-#include <linux/falloc.h>
-    ], [
-         fallocate(0, 0, 0, 0);
-    ], have_fallocate=yes
-       AC_MSG_RESULT(yes),
-       AC_MSG_RESULT(no))
+#include <linux/falloc.h> ],
+      [ fallocate(0, 0, 0, 0); ],
+      [ have_fallocate=true; AC_MSG_RESULT(yes) ],
+      [ have_fallocate=false; AC_MSG_RESULT(no) ])
     AC_SUBST(have_fallocate)
   ])
 m4_include([m4/multilib.m4])
diff --git a/src/Makefile b/src/Makefile
index 1162ee0..91088bf 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -31,7 +31,7 @@ ifeq ($(HAVE_FIEMAP), true)
 LINUX_TARGETS += fiemap-tester
 endif
 
-ifeq ($(HAVE_FALLOCATE),yes)
+ifeq ($(HAVE_FALLOCATE), true)
 LCFLAGS += -DHAVE_FALLOCATE
 endif
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
