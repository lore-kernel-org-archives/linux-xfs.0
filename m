Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Dec 2006 19:32:16 -0800 (PST)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB83W6aG013184
	for <xfs@oss.sgi.com>; Thu, 7 Dec 2006 19:32:07 -0800
Subject: [PATCH] update acl package
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
Content-Type: multipart/mixed; boundary="=-KAMrNPJMMJUC1tSpyFb6"
Date: Fri, 08 Dec 2006 14:31:10 +1100
Message-Id: <1165548670.30459.80.camel@edge>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: agruen@suse.de

--=-KAMrNPJMMJUC1tSpyFb6
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Fix a build issue on GNU/kFreeBSD, thanks to Petr Salinger.
Also updates Debian packaging.

-- 
Nathan

--=-KAMrNPJMMJUC1tSpyFb6
Content-Disposition: attachment; filename=fix-kfreebsd
Content-Type: text/x-patch; name=fix-kfreebsd; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: acl/include/config.h.in
===================================================================
--- acl.orig/include/config.h.in	2006-12-08 14:14:01.800083750 +1100
+++ acl/include/config.h.in	2006-12-08 14:18:39.393432250 +1100
@@ -30,3 +30,8 @@
 #endif
 #include <locale.h>
 
+/* On GNU/kFreeBSD, ENODATA is not defined in the system headers */
+#include <errno.h>
+#ifndef ENODATA
+# define ENODATA ENOATTR
+#endif
Index: acl/libacl/acl_delete_def_file.c
===================================================================
--- acl.orig/libacl/acl_delete_def_file.c	2006-12-08 14:13:58.247861750 +1100
+++ acl/libacl/acl_delete_def_file.c	2006-12-08 14:18:55.266424250 +1100
@@ -23,6 +23,7 @@
 #include <attr/xattr.h>
 #include "byteorder.h"
 #include "acl_ea.h"
+#include "config.h"
 
 
 /* 23.4.8 */
Index: acl/VERSION
===================================================================
--- acl.orig/VERSION	2006-12-08 14:19:09.687325500 +1100
+++ acl/VERSION	2006-12-08 14:19:17.123790250 +1100
@@ -3,5 +3,5 @@
 #
 PKG_MAJOR=2
 PKG_MINOR=2
-PKG_REVISION=41
+PKG_REVISION=42
 PKG_BUILD=1
Index: acl/debian/changelog
===================================================================
--- acl.orig/debian/changelog	2006-12-08 14:19:09.759330000 +1100
+++ acl/debian/changelog	2006-12-08 14:21:50.509376250 +1100
@@ -1,3 +1,10 @@
+acl (2.2.42-1) unstable; urgency=low
+
+  * New upstream release
+  * Incorporate Petr Salinger's GNU/kFreeBSD patch (closes: #401511)
+
+ -- Nathan Scott <nathans@debian.org>  Fri, 08 Dec 2006 14:21:40 +1100
+
 acl (2.2.41-1) unstable; urgency=low
 
   * New upstream release
Index: acl/doc/CHANGES
===================================================================
--- acl.orig/doc/CHANGES	2006-12-08 14:19:09.707326750 +1100
+++ acl/doc/CHANGES	2006-12-08 14:20:30.536378250 +1100
@@ -1,3 +1,6 @@
+2.2.42 (08 December 2006)
+* Fix a build issue on GNU/kFreeBSD, thanks to Petr Salinger.
+
 2.2.41 (14 July 2006)
 * Fix issues with makedepend on libtool libraries.
 * Fix issues with install using named ids instead of numeric ones.

--=-KAMrNPJMMJUC1tSpyFb6--
