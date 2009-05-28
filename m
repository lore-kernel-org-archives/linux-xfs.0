Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4SGGPnC262143 for <xfs@oss.sgi.com>; Thu, 28 May 2009 11:16:26 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 64B612B8007
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 09:16:40 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id di8W3MEDyMyn1Ao9 for <xfs@oss.sgi.com>;
	Thu, 28 May 2009 09:16:40 -0700 (PDT)
Message-ID: <4A1EB8DE.40108@sandeen.net>
Date: Thu, 28 May 2009 11:16:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/9 V2] Use xfs.h rather than libxfs.h
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>	<1243450413-12681-2-git-send-email-sandeen@sandeen.net>
	<20090528095657.GA651@infradead.org>
In-Reply-To: <20090528095657.GA651@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Use xfs/xfs.h when possible rather than xfs/libxfs.h,
now that libxfs.h isn't part of a normal xfsprogs-devel
install.

v2: take the MAXNAMELEN changes out of the mix and
remove redefinitions of ioctls easily available from xfs.h

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/aclocal.m4 b/aclocal.m4
index 52f1c7d..6cc5dce 100644
--- a/aclocal.m4
+++ b/aclocal.m4
@@ -405,6 +405,17 @@ AC_DEFUN([AC_PACKAGE_NEED_UUIDCOMPARE],
     AC_SUBST(libuuid)
   ])
 
+AC_DEFUN([AC_PACKAGE_NEED_XFS_XFS_H],
+  [ AC_CHECK_HEADERS([xfs/xfs.h])
+    if test "$ac_cv_header_xfs_xfs_h" != "yes"; then
+        echo
+        echo 'FATAL ERROR: cannot find a valid <xfs/xfs.h> header file.'
+        echo 'Install or upgrade the XFS development package.'
+        echo 'Alternatively, run "make install-dev" from the xfsprogs source.'
+        exit 1
+    fi
+  ])
+
 AC_DEFUN([AC_PACKAGE_NEED_XFS_LIBXFS_H],
   [ AC_CHECK_HEADERS([xfs/libxfs.h])
     if test "$ac_cv_header_xfs_libxfs_h" != "yes"; then
@@ -500,8 +511,8 @@ AC_DEFUN([AC_PACKAGE_NEED_IRIX_LIBHANDLE],
   ])
 
 AC_DEFUN([AC_PACKAGE_NEED_XFSCTL_MACRO],
-  [ AC_MSG_CHECKING([xfsctl from xfs/libxfs.h])
-    AC_TRY_LINK([#include <xfs/libxfs.h>], [ int x = xfsctl(0, 0, 0, 0); ],
+  [ AC_MSG_CHECKING([xfsctl from xfs/xfs.h])
+    AC_TRY_LINK([#include <xfs/xfs.h>], [ int x = xfsctl(0, 0, 0, 0); ],
       [ echo ok ],
       [ echo
         echo 'FATAL ERROR: cannot find required macros in the XFS headers.'
diff --git a/configure.in b/configure.in
index 32a2496..f087454 100644
--- a/configure.in
+++ b/configure.in
@@ -44,6 +44,7 @@ in
 		;;
 	*)
 		AC_MULTILIB($enable_lib64)
+		AC_PACKAGE_NEED_XFS_XFS_H
 		AC_PACKAGE_NEED_XFS_LIBXFS_H
 		AC_PACKAGE_NEED_XFS_XQM_H
 		AC_PACKAGE_NEED_XFSCTL_MACRO
diff --git a/m4/package_xfslibs.m4 b/m4/package_xfslibs.m4
index cafd959..2c8d694 100644
--- a/m4/package_xfslibs.m4
+++ b/m4/package_xfslibs.m4
@@ -1,3 +1,13 @@
+AC_DEFUN([AC_PACKAGE_NEED_XFS_XFS_H],
+  [ AC_CHECK_HEADERS([xfs/xfs.h])
+    if test "$ac_cv_header_xfs_xfs_h" != "yes"; then
+        echo
+        echo 'FATAL ERROR: cannot find a valid <xfs/xfs.h> header file.'
+        echo 'Run "make install-qa" from the xfsprogs source.'
+        exit 1
+    fi
+  ])
+
 AC_DEFUN([AC_PACKAGE_NEED_XFS_LIBXFS_H],
   [ AC_CHECK_HEADERS([xfs/libxfs.h])
     if test "$ac_cv_header_xfs_libxfs_h" != "yes"; then
diff --git a/src/global.h b/src/global.h
index 158c1fa..61862f6 100644
--- a/src/global.h
+++ b/src/global.h
@@ -26,6 +26,10 @@
 #include <../../xfsprogs/include/irix.h>
 #endif
 
+#ifdef HAVE_XFS_XFS_H
+#include <xfs/xfs.h>
+#endif
+
 #ifdef HAVE_XFS_LIBXFS_H
 #include <xfs/libxfs.h>
 #endif
diff --git a/src/godown.c b/src/godown.c
index 4105aee..07b6980 100644
--- a/src/godown.c
+++ b/src/godown.c
@@ -18,20 +18,6 @@
 
 #include "global.h"
 
-/* These should be in libxfs.h */
-#ifndef XFS_IOC_GOINGDOWN
-#define XFS_IOC_GOINGDOWN           _IOR ('X', 125, __uint32_t)
-#endif
-#ifndef XFS_FSOP_GOING_FLAGS_DEFAULT
-#define XFS_FSOP_GOING_FLAGS_DEFAULT    0x0     /* going down */
-#endif
-#ifndef XFS_FSOP_GOING_FLAGS_LOGFLUSH
-#define XFS_FSOP_GOING_FLAGS_LOGFLUSH    0x1     /* flush log */
-#endif
-#ifndef XFS_FSOP_GOING_FLAGS_NOLOGFLUSH
-#define XFS_FSOP_GOING_FLAGS_NOLOGFLUSH  0x2     /* don't flush log */
-#endif
-
 static char *xprogname;
 
 
diff --git a/src/iopat.c b/src/iopat.c
index 1e7d61b..c06071f 100644
--- a/src/iopat.c
+++ b/src/iopat.c
@@ -18,7 +18,7 @@
 
 #include <fcntl.h>
 #include <sys/ioctl.h>
-#include <xfs/libxfs.h>
+#include <xfs/xfs.h>
 struct xfs_flock64 f;
 
 int main(int argc, char **argv)
diff --git a/src/t_immutable.c b/src/t_immutable.c
index 667355b..07a36cd 100644
--- a/src/t_immutable.c
+++ b/src/t_immutable.c
@@ -38,7 +38,7 @@
 #include <libgen.h>
 #include <sys/acl.h>
 #include <attr/xattr.h>
-#include <xfs/libxfs.h>
+#include <xfs/xfs.h>
 #include <xfs/handle.h>
 #include <xfs/jdm.h>
 
@@ -47,6 +47,10 @@
 #define EXT2_APPEND_FL          0x00000020
 #define EXT2_IOC_SETFLAGS	_IOW('f', 2, long)
 
+#ifndef XFS_SUPER_MAGIC
+#define XFS_SUPER_MAGIC 0x58465342
+#endif
+
 extern const char *__progname;
 
 static int fsetflag(const char *path, int fd, int on, int immutable)
diff --git a/src/unwritten_mmap.c b/src/unwritten_mmap.c
index 5e63486..aec6a69 100644
--- a/src/unwritten_mmap.c
+++ b/src/unwritten_mmap.c
@@ -2,7 +2,7 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <fcntl.h>
-#include <xfs/libxfs.h>
+#include <xfs/xfs.h>
 #include <sys/mman.h>
 
 /*
diff --git a/src/xfsctl.c b/src/xfsctl.c
index f8afb16..8fa3348 100644
--- a/src/xfsctl.c
+++ b/src/xfsctl.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/libxfs.h>
+#include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
 /* simple test program to try out a bunch of xfsctls:


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
