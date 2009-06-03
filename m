Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n53IlCpd189542 for <xfs@oss.sgi.com>; Wed, 3 Jun 2009 13:47:13 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D8572CD5CF
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2009 11:47:29 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id meBlWQ0EgtuQntWn for <xfs@oss.sgi.com>;
	Wed, 03 Jun 2009 11:47:29 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n53IlTBG017019
	for <xfs@oss.sgi.com>; Wed, 3 Jun 2009 14:47:29 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n53IlS44018252
	for <xfs@oss.sgi.com>; Wed, 3 Jun 2009 14:47:28 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n53IlR9K030330
	for <xfs@oss.sgi.com>; Wed, 3 Jun 2009 14:47:27 -0400
Message-ID: <4A26C53F.5080105@redhat.com>
Date: Wed, 03 Jun 2009 13:47:27 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: Check for xlog_assign_lsn in xfs headers
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
To: xfs mailing list <xfs@oss.sgi.com>

Check for xlog_assign_lsn in xfs headers

Checking for libxfs.h isn't enough; some debian installs
have libxfs.h but no xlog_assign_lsn, and the loggen build still
fails.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---

diff --git a/aclocal.m4 b/aclocal.m4
index ac616d1..8a61e39 100644
--- a/aclocal.m4
+++ b/aclocal.m4
@@ -421,6 +421,13 @@ AC_DEFUN([AC_PACKAGE_WANT_XFS_LIBXFS_H],
     AC_SUBST(have_libxfs)
   ])
 
+AC_DEFUN([AC_PACKAGE_WANT_XLOG_ASSIGN_LSN],
+  [
+    AC_CHECK_DECL(xlog_assign_lsn,
+      [ have_xlog_assign_lsn=true ], [ have_xlog_assign_lsn=false ],
+      [[#include <xfs/libxfs.h>]])
+  ])
+
 AC_DEFUN([AC_PACKAGE_NEED_XFS_XQM_H],
   [ AC_CHECK_HEADERS([xfs/xqm.h])
     if test "$ac_cv_header_xfs_xqm_h" != "yes"; then
diff --git a/configure.in b/configure.in
index 210a91e..6c2afe7 100644
--- a/configure.in
+++ b/configure.in
@@ -46,6 +46,7 @@ in
 		AC_MULTILIB($enable_lib64)
 		AC_PACKAGE_NEED_XFS_XFS_H
 		AC_PACKAGE_WANT_XFS_LIBXFS_H
+		AC_PACKAGE_WANT_XLOG_ASSIGN_LSN
 		AC_PACKAGE_NEED_XFS_XQM_H
 		AC_PACKAGE_NEED_XFSCTL_MACRO
 		AC_PACKAGE_NEED_XFS_HANDLE_H
diff --git a/include/builddefs.in b/include/builddefs.in
index e8f4b6b..7827ed5 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -15,6 +15,7 @@ CFLAGS = @CFLAGS@
 CPPFLAGS = @CPPFLAGS@
 
 HAVE_LIBXFS = @have_libxfs@
+HAVE_XLOG_ASSIGN_LSN = @have_xlog_assign_lsn@
 LIBXFS = @libxfs@
 LIBACL = @libacl@
 LIBATTR = @libattr@
diff --git a/m4/package_xfslibs.m4 b/m4/package_xfslibs.m4
index 903e4a7..870882f 100644
--- a/m4/package_xfslibs.m4
+++ b/m4/package_xfslibs.m4
@@ -13,6 +13,14 @@ AC_DEFUN([AC_PACKAGE_WANT_LIBXFS_H],
     AC_SUBST(have_libxfs)
   ])
 
+AC_DEFUN([AC_PACKAGE_WANT_XLOG_ASSIGN_LSN],
+  [
+    AC_CHECK_DECL(xlog_assign_lsn,
+      [ have_xlog_assign_lsn=true ], [ have_xlog_assign_lsn=false ],
+      [[#include <xfs/libxfs.h>]])
+    AC_SUBST(have_have_xlog_assign_lsn)
+  ])
+
 AC_DEFUN([AC_PACKAGE_NEED_XFS_XQM_H],
   [ AC_CHECK_HEADERS([xfs/xqm.h])
     if test "$ac_cv_header_xfs_xqm_h" != "yes"; then
diff --git a/src/Makefile b/src/Makefile
index 515e16e..7b01754 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -17,7 +17,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize \
 	fs_perms testx looptest locktest unwritten_mmap \
 	bulkstat_unlink_test bulkstat_unlink_test_modified t_dir_offset
 
-ifeq ($(HAVE_LIBXFS), true)
+ifeq ($(HAVE_XLOG_ASSIGN_LSN), true)
 LINUX_TARGETS += loggen
 endif
 




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
