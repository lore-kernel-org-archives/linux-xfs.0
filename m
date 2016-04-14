Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 369AB7CA0
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 12:15:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BA713AC007
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 10:15:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NGEa3Tf3qxDdOIA1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Apr 2016 10:15:06 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 9385C2202D
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 17:15:05 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH] build: make librt optional for some platforms
Date: Thu, 14 Apr 2016 19:14:59 +0200
Message-Id: <1460654099-6397-1-git-send-email-jtulak@redhat.com>
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
Cc: Jan Tulak <jtulak@redhat.com>

The functions that we use from librt on Linux are in other libraries
on OS X. So make it possible to disable librt.

The hardcoded librt dependency was added in 0caa2bae.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 configure.ac     |  7 +++++--
 doc/INSTALL      |  6 +++++-
 m4/package_rt.m4 | 12 ++++++++++++
 3 files changed, 22 insertions(+), 3 deletions(-)
 create mode 100644 m4/package_rt.m4

diff --git a/configure.ac b/configure.ac
index 6d012ce..ed67e74 100644
--- a/configure.ac
+++ b/configure.ac
@@ -56,8 +56,10 @@ AC_ARG_ENABLE(lib64,
 	enable_lib64=yes)
 AC_SUBST(enable_lib64)
 
-librt="-lrt"
-AC_SUBST(librt)
+AC_ARG_ENABLE(librt,
+[ --enable-librt=[yes/no] Enable librt support [default=yes]],,
+	enable_librt=yes)
+AC_SUBST(enable_librt)
 
 #
 # If the user specified a libdir ending in lib64 do not append another
@@ -103,6 +105,7 @@ AC_SUBST(LOCALIZED_FILES)
 AC_PACKAGE_GLOBALS(xfsprogs)
 AC_PACKAGE_UTILITIES(xfsprogs)
 AC_MULTILIB($enable_lib64)
+AC_RT($enable_librt)
 
 AC_PACKAGE_NEED_UUID_H
 AC_PACKAGE_NEED_UUIDCOMPARE
diff --git a/doc/INSTALL b/doc/INSTALL
index b0443a3..0879612 100644
--- a/doc/INSTALL
+++ b/doc/INSTALL
@@ -89,7 +89,11 @@ Mac OS X Instructions
 	TAR=/usr/bin/gnutar
 	LIBTOOL=/usr/bin/glibtool
 	INSTALL_GROUP=wheel
-	LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no --enable-blkid=no"
+	LOCAL_CONFIGURE_OPTIONS="\
+				 --enable-gettext=no\
+				 --enable-blkid=no\
+				 --enable-librt=no\
+				 "
 
 	$ make
 	$ su root
diff --git a/m4/package_rt.m4 b/m4/package_rt.m4
new file mode 100644
index 0000000..9ad1009
--- /dev/null
+++ b/m4/package_rt.m4
@@ -0,0 +1,12 @@
+# Check if the platform has librt
+#
+
+AC_DEFUN([AC_RT],
+[
+  if test "$enable_librt" = "yes"; then
+    librt="-lrt"
+  else
+    librt=""
+  fi
+  AC_SUBST(librt)
+])
-- 
2.6.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
