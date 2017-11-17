Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24708 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752687AbdKQUNf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 15:13:35 -0500
Subject: [PATCH 01/12] libfrog: move all the userspace support stuff into a
 new library
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 12:13:31 -0800
Message-ID: <151094961128.29763.13534033801335747939.stgit@magnolia>
In-Reply-To: <151094960522.29763.11622891165765932168.stgit@magnolia>
References: <151094960522.29763.11622891165765932168.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This library is meant to contain all the Funny Random Other Gunk that
the xfsprogs utilities rely on.  Move all that stuff into this library
to reduce the pollution in the other libraries.

Ribbit!  Ribbit!

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 Makefile             |    2 +-
 debian/rules         |    2 +-
 include/builddefs.in |    1 +
 libfrog/Makefile     |   21 +++++++++++++++++++++
 4 files changed, 24 insertions(+), 2 deletions(-)
 create mode 100644 libfrog/Makefile


diff --git a/Makefile b/Makefile
index 72d0044..4146473 100644
--- a/Makefile
+++ b/Makefile
@@ -44,7 +44,7 @@ endif
 # header install rules to populate include/xfs correctly
 HDR_SUBDIRS = include libxfs
 
-DLIB_SUBDIRS = libxlog libxcmd libhandle
+DLIB_SUBDIRS = libfrog libxlog libxcmd libhandle
 LIB_SUBDIRS = libxfs $(DLIB_SUBDIRS)
 TOOL_SUBDIRS = copy db estimate fsck growfs io logprint mkfs quota \
 		mdrestore repair rtcp m4 man doc debian spaceman
diff --git a/debian/rules b/debian/rules
index f186d79..baefdba 100755
--- a/debian/rules
+++ b/debian/rules
@@ -48,7 +48,7 @@ dibuild:
 		for dir in include libxfs; do \
 			$(MAKE) -C $$dir NODEP=1 install-headers; \
 		done; \
-		for dir in include libxfs libxcmd mkfs; do \
+		for dir in include libxfs libxcmd libfrog mkfs; do \
 			$(MAKE) -C $$dir; \
 		done; \
 		mv mkfs/mkfs.xfs mkfs/mkfs.xfs-$(bootpkg); \
diff --git a/include/builddefs.in b/include/builddefs.in
index 1d454b6..2d7b199 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -36,6 +36,7 @@ LIBEDITLINE = @libeditline@
 LIBREADLINE = @libreadline@
 LIBBLKID = @libblkid@
 LIBXFS = $(TOPDIR)/libxfs/libxfs.la
+LIBFROG = $(TOPDIR)/libfrog/libfrog.la
 LIBXCMD = $(TOPDIR)/libxcmd/libxcmd.la
 LIBXLOG = $(TOPDIR)/libxlog/libxlog.la
 LIBHANDLE = $(TOPDIR)/libhandle/libhandle.la
diff --git a/libfrog/Makefile b/libfrog/Makefile
new file mode 100644
index 0000000..231a734
--- /dev/null
+++ b/libfrog/Makefile
@@ -0,0 +1,21 @@
+#
+# Copyright (c) 2017 Oracle.  All Rights Reserved.
+#
+
+TOPDIR = ..
+include $(TOPDIR)/include/builddefs
+
+LTLIBRARY = libfrog.la
+LT_CURRENT = 0
+LT_REVISION = 0
+LT_AGE = 0
+
+CFILES =
+
+default: ltdepend $(LTLIBRARY)
+
+include $(BUILDRULES)
+
+install install-dev: default
+
+-include .ltdep

