Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4RIrMT0204145 for <xfs@oss.sgi.com>; Wed, 27 May 2009 13:53:22 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5B69E2B394E
	for <xfs@oss.sgi.com>; Wed, 27 May 2009 11:53:34 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id FufpPXHu4FbZAJdM for
	<xfs@oss.sgi.com>; Wed, 27 May 2009 11:53:34 -0700 (PDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 2/9] Make libxfs.h optional
Date: Wed, 27 May 2009 13:53:26 -0500
Message-Id: <1243450413-12681-3-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>

libxfs.h is really only needed for the loggen test;
make it config-time optional.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 044                   |    2 ++
 aclocal.m4            |   12 +++---------
 configure.in          |    2 +-
 include/builddefs.in  |    1 +
 m4/package_xfslibs.m4 |   11 +++--------
 src/Makefile          |    6 +++++-
 6 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/044 b/044
index 7975db4..ba2d33b 100755
--- a/044
+++ b/044
@@ -108,6 +108,8 @@ _filter_mkfs <$tmp.mkfs0 2>$tmp.mkfs1
 [ $lversion -ne 1 ] && \
     _notrun "Cannot run this test yet using MKFS_OPTIONS specified"
 
+[ $here/src/loggen ] || _notrun "loggen not built, skipping test"
+
 _check_mount
 _check_require_logdev
 
diff --git a/aclocal.m4 b/aclocal.m4
index 6cc5dce..ac616d1 100644
--- a/aclocal.m4
+++ b/aclocal.m4
@@ -416,15 +416,9 @@ AC_DEFUN([AC_PACKAGE_NEED_XFS_XFS_H],
     fi
   ])
 
-AC_DEFUN([AC_PACKAGE_NEED_XFS_LIBXFS_H],
-  [ AC_CHECK_HEADERS([xfs/libxfs.h])
-    if test "$ac_cv_header_xfs_libxfs_h" != "yes"; then
-        echo
-        echo 'FATAL ERROR: cannot find a valid <xfs/libxfs.h> header file.'
-        echo 'Install or upgrade the XFS development package.'
-        echo 'Alternatively, run "make install-dev" from the xfsprogs source.'
-        exit 1
-    fi
+AC_DEFUN([AC_PACKAGE_WANT_XFS_LIBXFS_H],
+  [ AC_CHECK_HEADERS([xfs/libxfs.h], [ have_libxfs=true ], [ have_libxfs=false ])
+    AC_SUBST(have_libxfs)
   ])
 
 AC_DEFUN([AC_PACKAGE_NEED_XFS_XQM_H],
diff --git a/configure.in b/configure.in
index f087454..210a91e 100644
--- a/configure.in
+++ b/configure.in
@@ -45,7 +45,7 @@ in
 	*)
 		AC_MULTILIB($enable_lib64)
 		AC_PACKAGE_NEED_XFS_XFS_H
-		AC_PACKAGE_NEED_XFS_LIBXFS_H
+		AC_PACKAGE_WANT_XFS_LIBXFS_H
 		AC_PACKAGE_NEED_XFS_XQM_H
 		AC_PACKAGE_NEED_XFSCTL_MACRO
 		AC_PACKAGE_NEED_XFS_HANDLE_H
diff --git a/include/builddefs.in b/include/builddefs.in
index 636f632..e8f4b6b 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -14,6 +14,7 @@ LOADERFLAGS = @LDFLAGS@
 CFLAGS = @CFLAGS@
 CPPFLAGS = @CPPFLAGS@
 
+HAVE_LIBXFS = @have_libxfs@
 LIBXFS = @libxfs@
 LIBACL = @libacl@
 LIBATTR = @libattr@
diff --git a/m4/package_xfslibs.m4 b/m4/package_xfslibs.m4
index 2c8d694..903e4a7 100644
--- a/m4/package_xfslibs.m4
+++ b/m4/package_xfslibs.m4
@@ -8,14 +8,9 @@ AC_DEFUN([AC_PACKAGE_NEED_XFS_XFS_H],
     fi
   ])
 
-AC_DEFUN([AC_PACKAGE_NEED_XFS_LIBXFS_H],
-  [ AC_CHECK_HEADERS([xfs/libxfs.h])
-    if test "$ac_cv_header_xfs_libxfs_h" != "yes"; then
-        echo
-        echo 'FATAL ERROR: cannot find a valid <xfs/libxfs.h> header file.'
-        echo 'Run "make install-qa" from the xfsprogs source.'
-        exit 1
-    fi
+AC_DEFUN([AC_PACKAGE_WANT_LIBXFS_H],
+  [ AC_CHECK_HEADERS([xfs/libxfs.h], [ have_libxfs=true ], [ have_libxfs=false ])
+    AC_SUBST(have_libxfs)
   ])
 
 AC_DEFUN([AC_PACKAGE_NEED_XFS_XQM_H],
diff --git a/src/Makefile b/src/Makefile
index 634e1b3..2a09488 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -12,11 +12,15 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 	godown resvtest writemod makeextents itrash rename \
 	multi_open_unlink dmiperf unwritten_sync genhashnames
 
-LINUX_TARGETS = loggen xfsctl bstat t_mtab getdevicesize \
+LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize \
 	preallo_rw_pattern_reader preallo_rw_pattern_writer ftrunc trunc \
 	fs_perms testx looptest locktest unwritten_mmap \
 	bulkstat_unlink_test bulkstat_unlink_test_modified t_dir_offset
 
+ifeq ($(HAVE_LIBXFS), true)
+LINUX_TARGETS += loggen
+endif
+
 IRIX_TARGETS = open_unlink
 
 ifeq ($(PKG_PLATFORM),linux)
-- 
1.5.5.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
