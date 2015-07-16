Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 38DF27F8B
	for <xfs@oss.sgi.com>; Thu, 16 Jul 2015 11:13:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A37F7AC001
	for <xfs@oss.sgi.com>; Thu, 16 Jul 2015 09:13:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mbMoJYweSrnACkFt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 Jul 2015 09:13:40 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 22F47358A14
	for <xfs@oss.sgi.com>; Thu, 16 Jul 2015 16:13:40 +0000 (UTC)
Received: from jtulak-t430.brq.redhat.com (jtulak.brq.redhat.com [10.34.1.5])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id t6GGDdrB003233
	for <xfs@oss.sgi.com>; Thu, 16 Jul 2015 12:13:39 -0400
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH v2] xfsprogs: Search path for utilities unified
Date: Thu, 16 Jul 2015 18:13:38 +0200
Message-Id: <1437063218-26143-1-git-send-email-jtulak@redhat.com>
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

UPDATE: Fixed commit message
-------------

Currently, when autoconf is checking for an utility, every utility has
its own pathes defined independently. Unify it in a single variable
used for (almost) all utilities.

Also, add /opt/local/bin to the path.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 m4/package_utilies.m4 | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/m4/package_utilies.m4 b/m4/package_utilies.m4
index 475ce0b..49f4dfb 100644
--- a/m4/package_utilies.m4
+++ b/m4/package_utilies.m4
@@ -1,3 +1,6 @@
+# Path to search an utility
+PATH=/bin:/usr/bin:/usr/local/bin:/usr/freeware/bin:/opt/local/bin
+
 #
 # Check for specified utility (env var) - if unset, fail.
 #
@@ -40,22 +43,22 @@ AC_DEFUN([AC_PACKAGE_UTILITIES],
     AC_PACKAGE_NEED_UTILITY($1, "$cc", cc, [C compiler])
 
     if test -z "$MAKE"; then
-        AC_PATH_PROG(MAKE, gmake,, /usr/bin:/usr/local/bin:/usr/freeware/bin)
+        AC_PATH_PROG(MAKE, gmake,, $PATH)
     fi
     if test -z "$MAKE"; then
-        AC_PATH_PROG(MAKE, make,, /usr/bin)
+        AC_PATH_PROG(MAKE, make,, $PATH)
     fi
     make=$MAKE
     AC_SUBST(make)
     AC_PACKAGE_NEED_UTILITY($1, "$make", make, [GNU make])
 
     if test -z "$TAR"; then
-        AC_PATH_PROG(TAR, tar,, /usr/freeware/bin:/bin:/usr/local/bin:/usr/bin)
+        AC_PATH_PROG(TAR, tar,, $PATH)
     fi
     tar=$TAR
     AC_SUBST(tar)
     if test -z "$ZIP"; then
-        AC_PATH_PROG(ZIP, gzip,, /bin:/usr/bin:/usr/local/bin:/usr/freeware/bin)
+        AC_PATH_PROG(ZIP, gzip,, $PATH)
     fi
 
     zip=$ZIP
@@ -97,21 +100,21 @@ AC_DEFUN([AC_PACKAGE_UTILITIES],
 
     if test "$enable_gettext" = yes; then
         if test -z "$MSGFMT"; then
-                AC_PATH_PROG(MSGFMT, msgfmt,, /usr/bin:/usr/local/bin:/usr/freeware/bin)
+                AC_PATH_PROG(MSGFMT, msgfmt,, $PATH)
         fi
         msgfmt=$MSGFMT
         AC_SUBST(msgfmt)
         AC_PACKAGE_NEED_UTILITY($1, "$msgfmt", msgfmt, gettext)
 
         if test -z "$MSGMERGE"; then
-                AC_PATH_PROG(MSGMERGE, msgmerge,, /usr/bin:/usr/local/bin:/usr/freeware/bin)
+                AC_PATH_PROG(MSGMERGE, msgmerge,, $PATH)
         fi
         msgmerge=$MSGMERGE
         AC_SUBST(msgmerge)
         AC_PACKAGE_NEED_UTILITY($1, "$msgmerge", msgmerge, gettext)
 
         if test -z "$XGETTEXT"; then
-                AC_PATH_PROG(XGETTEXT, xgettext,, /usr/bin:/usr/local/bin:/usr/freeware/bin)
+                AC_PATH_PROG(XGETTEXT, xgettext,, $PATH)
         fi
         xgettext=$XGETTEXT
         AC_SUBST(xgettext)
@@ -119,7 +122,7 @@ AC_DEFUN([AC_PACKAGE_UTILITIES],
     fi
 
     if test -z "$RPM"; then
-        AC_PATH_PROG(RPM, rpm,, /bin:/usr/bin:/usr/freeware/bin)
+        AC_PATH_PROG(RPM, rpm,, $PATH)
     fi
     rpm=$RPM
     AC_SUBST(rpm)
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
