Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35466 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729217AbeIXXKH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Sep 2018 19:10:07 -0400
Received: from smtp.corp.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A230EC04BD4D
        for <linux-xfs@vger.kernel.org>; Mon, 24 Sep 2018 17:07:01 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D58230A6055
        for <linux-xfs@vger.kernel.org>; Mon, 24 Sep 2018 17:07:01 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfsprogs: make scrub build config-optional
Message-ID: <832c69f6-4cd4-224d-0d58-5a387f2ae9fa@redhat.com>
Date: Mon, 24 Sep 2018 12:07:00 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This lets us do:

# ./configure --enable-scrub=no
or
# ./configure --disable-scrub

for any distros that may not want to ship the experimental scrub utility.

The default is still to build scrub.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(skipping libicu checks is maybe overkill, I can drop that
if preferred; checking but not using is harmless)

diff --git a/Makefile b/Makefile
index 6774825..dd6ad16 100644
--- a/Makefile
+++ b/Makefile
@@ -49,7 +49,11 @@ LIBFROG_SUBDIR = libfrog
 DLIB_SUBDIRS = libxlog libxcmd libhandle
 LIB_SUBDIRS = libxfs $(DLIB_SUBDIRS)
 TOOL_SUBDIRS = copy db estimate fsck growfs io logprint mkfs quota \
-		mdrestore repair rtcp m4 man doc debian spaceman scrub
+		mdrestore repair rtcp m4 man doc debian spaceman
+
+ifeq ("$(ENABLE_SCRUB)","yes")
+TOOL_SUBDIRS += scrub
+endif
 
 ifneq ("$(PKG_PLATFORM)","darwin")
 TOOL_SUBDIRS += fsr
diff --git a/configure.ac b/configure.ac
index 5fdf78e..467ca2d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -95,9 +95,15 @@ AC_ARG_ENABLE(lto,
 	enable_lto=probe)
 AC_SUBST(enable_lto)
 
+# Enable xfs_scrub build
+AC_ARG_ENABLE(scrub,
+[ --enable-scrub=[yes/no]    Enable build of xfs_scrub utility [default=yes]],,
+	enable_scrub=yes)
+AC_SUBST(enable_scrub)
+
 # Enable libicu for xfs_scrubbing of malicious unicode sequences in names
 AC_ARG_ENABLE(libicu,
-[ --enable-libicu=[yes/no]   Enable Unicode name scanning (libicu) [default=probe]],,
+[ --enable-libicu=[yes/no]   Enable Unicode name scanning in xfs_scrub (libicu) [default=probe]],,
 	enable_libicu=probe)
 
 #
@@ -178,11 +184,13 @@ AC_HAVE_DEVMAPPER
 AC_HAVE_MALLINFO
 AC_PACKAGE_WANT_ATTRIBUTES_H
 AC_HAVE_LIBATTR
-if test "$enable_libicu" = "yes" || test "$enable_libicu" = "probe"; then
-	AC_HAVE_LIBICU
-fi
-if test "$enable_libicu" = "yes" && test "$have_libicu" != "yes"; then
-        AC_MSG_ERROR([libicu not found.])
+if test "$enable_scrub" = "yes"; then
+        if test "$enable_libicu" = "yes" || test "$enable_libicu" = "probe"; then
+                AC_HAVE_LIBICU
+        fi
+        if test "$enable_libicu" = "yes" && test "$have_libicu" != "yes"; then
+                AC_MSG_ERROR([libicu not found.])
+        fi
 fi
 AC_HAVE_OPENAT
 AC_HAVE_FSTATAT
diff --git a/include/builddefs.in b/include/builddefs.in
index f7d39a4..f3fc187 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -81,6 +81,7 @@ ENABLE_GETTEXT	= @enable_gettext@
 ENABLE_EDITLINE	= @enable_editline@
 ENABLE_READLINE	= @enable_readline@
 ENABLE_BLKID	= @enable_blkid@
+ENABLE_SCRUB	= @enable_scrub@
 
 HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
 
