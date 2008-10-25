Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 25 Oct 2008 11:18:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9PIIbrG015067
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 11:18:37 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A68254630E
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 11:18:36 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id tNUE0HVxdXhwv6TB for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 11:18:36 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 9D75BA9C504
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:18:35 -0500 (CDT)
Message-ID: <490362FB.5000300@sandeen.net>
Date: Sat, 25 Oct 2008 13:18:35 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: check for dmapi headers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

I'm no autoconf wizard, but I think this does the trick to allow
xfstests build to succeed when dmapi headers are missing, as
they probably will be for any distro that doesn't ship with
dmapi in the kernel, or dmapi userspace.

AFAIK the dmapi-related tests all fail gracefully with "not run."

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfstests/Makefile
===================================================================
--- xfstests.orig/Makefile
+++ xfstests/Makefile
@@ -25,8 +25,10 @@ else
 	$(SUBDIRS_MAKERULE)
 	# automake doesn't always support "default" target 
 	# so do dmapi make explicitly with "all"
+ifeq ($(HAVE_DMAPI), true)
 	cd $(TOPDIR)/dmapi; make all
 endif
+endif
 
 ifeq ($(HAVE_BUILDDEFS), yes)
 include $(BUILDRULES)
Index: xfstests/aclocal.m4
===================================================================
--- xfstests.orig/aclocal.m4
+++ xfstests/aclocal.m4
@@ -99,6 +99,11 @@ AC_DEFUN([AC_PACKAGE_WANT_AIO],
     AC_SUBST(have_aio)
   ])
 
+AC_DEFUN([AC_PACKAGE_WANT_DMAPI],
+  [ AC_CHECK_HEADERS(sys/dmapi/dmapi.h, [ have_dmapi=true ], [ have_dmapi=false ])
+    AC_SUBST(have_dmapi)
+  ])
+
 AC_DEFUN([AC_PACKAGE_NEED_ATTR_XATTR_H],
   [ AC_CHECK_HEADERS([attr/xattr.h])
     if test "$ac_cv_header_attr_xattr_h" != "yes"; then
Index: xfstests/configure.in
===================================================================
--- xfstests.orig/configure.in
+++ xfstests/configure.in
@@ -61,6 +61,7 @@ in
 
 		AC_PACKAGE_WANT_GDBM
 		AC_PACKAGE_WANT_AIO
+		AC_PACKAGE_WANT_DMAPI
 		;;
 esac
 
Index: xfstests/include/builddefs.in
===================================================================
--- xfstests.orig/include/builddefs.in
+++ xfstests/include/builddefs.in
@@ -50,6 +50,7 @@ RPM_VERSION     = @rpm_version@
 ENABLE_SHARED = @enable_shared@
 HAVE_DB = @have_db@
 HAVE_AIO = @have_aio@
+HAVE_DMAPI = @have_dmapi@
 HAVE_ATTR_LIST = @have_attr_list@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
