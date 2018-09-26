Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38888 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726107AbeI0B67 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Sep 2018 21:58:59 -0400
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6F85D307D867
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 19:44:28 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EA754308BE75
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 19:44:27 +0000 (UTC)
Subject: [PATCH 4/4] xfsprogs: remove PKG_PLATFORM macro
References: <395ba7bd-74b1-be1a-2eb6-32099b8eeb94@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <2780aeb6-9511-f292-516f-8f6009bc9fe7@redhat.com>
Date: Wed, 26 Sep 2018 14:44:27 -0500
MIME-Version: 1.0
In-Reply-To: <395ba7bd-74b1-be1a-2eb6-32099b8eeb94@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Now that there is only one supported platform (Linux), remove
the PKG_PLATFORM macro.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/include/Makefile b/include/Makefile
index e6aa9b2..7b92242 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -35,14 +35,12 @@ LIBHFILES = libxfs.h \
 
 HFILES = handle.h \
 	jdm.h \
-	$(PKG_PLATFORM).h \
+	linux.h \
 	xfs.h \
 	xqm.h \
 	xfs_arch.h
 
-PHFILES = linux.h
-LSRCFILES = $(shell echo $(PHFILES) | sed -e "s/$(PKG_PLATFORM).h//g")
-LSRCFILES += platform_defs.h.in builddefs.in buildmacros buildrules install-sh
+LSRCFILES = platform_defs.h.in builddefs.in buildmacros buildrules install-sh
 LSRCFILES += $(DKHFILES) $(LIBHFILES)
 LDIRT = disk
 LDIRDIRT = xfs
@@ -56,7 +54,7 @@ disk:
 include $(BUILDRULES)
 
 # set up include/xfs header directory
-install-headers: $(addsuffix -hdrs, $(PHFILES) $(DKHFILES) $(HFILES))
+install-headers: $(addsuffix -hdrs, $(DKHFILES) $(HFILES))
 
 %-hdrs:
 	$(Q)$(LN_S) -f $(CURDIR)/$* xfs/$*
diff --git a/include/builddefs.in b/include/builddefs.in
index 261ae5e..7ad5b3d 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -35,7 +35,6 @@ PKG_USER	= @pkg_user@
 PKG_GROUP	= @pkg_group@
 PKG_RELEASE	= @pkg_release@
 PKG_VERSION	= @pkg_version@
-PKG_PLATFORM	= @pkg_platform@
 PKG_DISTRIBUTION= @pkg_distribution@
 
 prefix		= @prefix@
@@ -121,13 +120,11 @@ CROND_DIR = @crond_dir@
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
 
-ifeq ($(PKG_PLATFORM),linux)
 PCFLAGS = -D_GNU_SOURCE $(GCCFLAGS)
 ifeq ($(HAVE_UMODE_T),yes)
 PCFLAGS += -DHAVE_UMODE_T
 endif
 DEPENDFLAGS = -D__linux__
-endif
 ifeq ($(HAVE_FLS),yes)
 LCFLAGS+= -DHAVE_FLS
 endif
diff --git a/io/Makefile b/io/Makefile
index 1498fc5..6270fc1 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -108,11 +108,9 @@ LCFLAGS += -DHAVE_DEVMAPPER
 endif
 
 # On linux we get fsmap from the system or define it ourselves
-# so include this based on platform type.  If this reverts to only
-# the autoconf check w/o local definition, change to testing HAVE_GETFSMAP
-ifeq ($(PKG_PLATFORM),linux)
+# so include this unconditionally.  If this reverts to only
+# the autoconf check w/o local definition, test HAVE_GETFSMAP
 CFILES += fsmap.c
-endif
 
 ifeq ($(HAVE_STATFS_FLAGS),yes)
 LCFLAGS += -DHAVE_STATFS_FLAGS
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 8e4daed..dbff959 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -16,6 +16,7 @@ convert.c \
 crc32.c \
 fsgeom.c \
 list_sort.c \
+linux.c \
 paths.c \
 projects.c \
 ptvar.c \
@@ -30,10 +31,6 @@ crc32table.h
 
 LSRCFILES += gen_crc32table.c
 
-CFILES += $(PKG_PLATFORM).c
-PCFILES = linux.c
-LSRCFILES = $(shell echo $(PCFILES) | sed -e "s/$(PKG_PLATFORM).c//g")
-
 ifeq ($(HAVE_GETMNTENT),yes)
 LCFLAGS += -DHAVE_GETMNTENT
 endif
diff --git a/m4/package_globals.m4 b/m4/package_globals.m4
index e469671..892e3bd 100644
--- a/m4/package_globals.m4
+++ b/m4/package_globals.m4
@@ -40,8 +40,4 @@ AC_DEFUN([AC_PACKAGE_GLOBALS],
     pkg_distribution=`uname -s`
     test -z "$DISTRIBUTION" || pkg_distribution="$DISTRIBUTION"
     AC_SUBST(pkg_distribution)
-
-    pkg_platform=`uname -s | tr 'A-Z' 'a-z' | tr -d / | sed -e 's/irix64/irix/'`
-    test -z "$PLATFORM" || pkg_platform="$PLATFORM"
-    AC_SUBST(pkg_platform)
   ])
diff --git a/quota/Makefile b/quota/Makefile
index 85e279b..384f023 100644
--- a/quota/Makefile
+++ b/quota/Makefile
@@ -8,11 +8,7 @@ include $(TOPDIR)/include/builddefs
 LTCOMMAND = xfs_quota
 HFILES = init.h quota.h
 CFILES = init.c util.c \
-	edit.c free.c path.c project.c quot.c quota.c report.c state.c
-
-CFILES += $(PKG_PLATFORM).c
-PCFILES = linux.c
-LSRCFILES = $(shell echo $(PCFILES) | sed -e "s/$(PKG_PLATFORM).c//g")
+	edit.c free.c linux.c path.c project.c quot.c quota.c report.c state.c
 
 LLDLIBS = $(LIBXCMD) $(LIBFROG)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)
diff --git a/scrub/Makefile b/scrub/Makefile
index 4a9e36d..aebc7e4 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -8,9 +8,9 @@ include $(TOPDIR)/include/builddefs
 # On linux we get fsmap from the system or define it ourselves
 # so include this based on platform type.  If this reverts to only
 # the autoconf check w/o local definition, change to testing HAVE_GETFSMAP
-SCRUB_PREREQS=$(PKG_PLATFORM)$(HAVE_OPENAT)$(HAVE_FSTATAT)
+SCRUB_PREREQS=$(HAVE_OPENAT)$(HAVE_FSTATAT)
 
-ifeq ($(SCRUB_PREREQS),linuxyesyes)
+ifeq ($(SCRUB_PREREQS),yesyes)
 LTCOMMAND = xfs_scrub
 INSTALL_SCRUB = install-scrub
 XFS_SCRUB_ALL_PROG = xfs_scrub_all
diff --git a/spaceman/Makefile b/spaceman/Makefile
index 87614d9..b1c1b16 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -23,11 +23,9 @@ LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
 endif
 
 # On linux we get fsmap from the system or define it ourselves
-# so include this based on platform type.  If this reverts to only
-# the autoconf check w/o local definition, change to testing HAVE_GETFSMAP
-ifeq ($(PKG_PLATFORM),linux)
+# so include this unconditionally.  If this reverts to only
+# the autoconf check w/o local definition, test HAVE_GETFSMAP
 CFILES += freesp.c
-endif
 
 default: depend $(LTCOMMAND)
 
