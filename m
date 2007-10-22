Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Oct 2007 02:59:29 -0700 (PDT)
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.227])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9M9xLbp005643
	for <xfs@oss.sgi.com>; Mon, 22 Oct 2007 02:59:24 -0700
Received: by wr-out-0506.google.com with SMTP id c48so785209wra
        for <xfs@oss.sgi.com>; Mon, 22 Oct 2007 02:59:24 -0700 (PDT)
Message-ID: <495eb0390710220232n419353bagfc8b0f879fa5e4a2@mail.gmail.com>
Date: Mon, 22 Oct 2007 11:32:01 +0200
From: "Gideon Stupp" <gideon.stupp@gmail.com>
Subject: [PATCH] support static linking for xfsprogs.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Fix the make files to test --enable-shared and link accordingly.

You get some annoying warnings when linked statically, but they all
seem to come from known issues related to how glibc handles
nsswitch.conf.

Signed-off-by: Gideon Stupp <gideon.stupp@gmail.com>

Index: xfsprogs/copy/Makefile
===================================================================
RCS file: /cvs/xfs-cmds/xfsprogs/copy/Makefile,v
retrieving revision 1.4
diff -u -r1.4 Makefile
--- xfsprogs/copy/Makefile	30 Jun 2006 14:38:12 -0000	1.4
+++ xfsprogs/copy/Makefile	22 Oct 2007 08:46:25 -0000
@@ -11,7 +11,13 @@

 LLDLIBS = $(LIBXFS) $(LIBUUID) $(LIBPTHREAD) $(LIBRT)
 LTDEPENDENCIES = $(LIBXFS)
+
+ifeq ($(ENABLE_SHARED),yes)
 LLDFLAGS = -static
+else
+LLDFLAGS = -all-static
+endif
+

 default: $(LTCOMMAND)

Index: xfsprogs/db/Makefile
===================================================================
RCS file: /cvs/xfs-cmds/xfsprogs/db/Makefile,v
retrieving revision 1.18
diff -u -r1.18 Makefile
--- xfsprogs/db/Makefile	7 Sep 2007 06:12:37 -0000	1.18
+++ xfsprogs/db/Makefile	22 Oct 2007 08:46:25 -0000
@@ -18,7 +18,13 @@
 LSRCFILES = xfs_admin.sh xfs_check.sh xfs_ncheck.sh xfs_metadump.sh
 LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
-LLDFLAGS += -static
+
+ifeq ($(ENABLE_SHARED),yes)
+LLDFLAGS = -static
+else
+LLDFLAGS = -all-static
+endif
+

 ifeq ($(ENABLE_READLINE),yes)
 LLDLIBS += $(LIBREADLINE) $(LIBTERMCAP)
Index: xfsprogs/growfs/Makefile
===================================================================
RCS file: /cvs/xfs-cmds/xfsprogs/growfs/Makefile,v
retrieving revision 1.15
diff -u -r1.15 Makefile
--- xfsprogs/growfs/Makefile	7 Sep 2007 06:12:37 -0000	1.15
+++ xfsprogs/growfs/Makefile	22 Oct 2007 08:46:25 -0000
@@ -11,7 +11,13 @@

 LLDLIBS = $(LIBXFS) $(LIBXCMD) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXCMD)
+
+ifeq ($(ENABLE_SHARED),yes)
 LLDFLAGS = -static
+else
+LLDFLAGS = -all-static
+endif
+
 LSRCFILES = xfs_info.sh

 default: $(LTCOMMAND)
Index: xfsprogs/io/Makefile
===================================================================
RCS file: /cvs/xfs-cmds/xfsprogs/io/Makefile,v
retrieving revision 1.19
diff -u -r1.19 Makefile
--- xfsprogs/io/Makefile	17 Jun 2006 06:12:23 -0000	1.19
+++ xfsprogs/io/Makefile	22 Oct 2007 08:46:25 -0000
@@ -14,7 +14,13 @@

 LLDLIBS = $(LIBXCMD) $(LIBHANDLE)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE)
+
+ifeq ($(ENABLE_SHARED),yes)
 LLDFLAGS = -static
+else
+LLDFLAGS = -all-static
+endif
+

 ifeq ($(HAVE_FADVISE),yes)
 CFILES += fadvise.c
Index: xfsprogs/logprint/Makefile
===================================================================
RCS file: /cvs/xfs-cmds/xfsprogs/logprint/Makefile,v
retrieving revision 1.14
diff -u -r1.14 Makefile
--- xfsprogs/logprint/Makefile	7 Sep 2007 06:12:37 -0000	1.14
+++ xfsprogs/logprint/Makefile	22 Oct 2007 08:46:25 -0000
@@ -14,7 +14,13 @@

 LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
+
+ifeq ($(ENABLE_SHARED),yes)
 LLDFLAGS = -static
+else
+LLDFLAGS = -all-static
+endif
+

 default: $(LTCOMMAND)

Index: xfsprogs/mdrestore/Makefile
===================================================================
RCS file: /cvs/xfs-cmds/xfsprogs/mdrestore/Makefile,v
retrieving revision 1.2
diff -u -r1.2 Makefile
--- xfsprogs/mdrestore/Makefile	7 Sep 2007 06:12:37 -0000	1.2
+++ xfsprogs/mdrestore/Makefile	22 Oct 2007 08:46:26 -0000
@@ -10,7 +10,13 @@

 LLDLIBS = $(LIBXFS) $(LIBRT) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXFS)
+
+ifeq ($(ENABLE_SHARED),yes)
 LLDFLAGS = -static
+else
+LLDFLAGS = -all-static
+endif
+

 default: $(LTCOMMAND)

Index: xfsprogs/mkfs/Makefile
===================================================================
RCS file: /cvs/xfs-cmds/xfsprogs/mkfs/Makefile,v
retrieving revision 1.18
diff -u -r1.18 Makefile
--- xfsprogs/mkfs/Makefile	7 Sep 2007 06:12:37 -0000	1.18
+++ xfsprogs/mkfs/Makefile	22 Oct 2007 08:46:26 -0000
@@ -13,7 +13,12 @@

 LLDLIBS = $(LIBXFS) $(LIBUUID) $(LIBDISK) $(LIBRT) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXFS) $(LIBDISK)
+
+ifeq ($(ENABLE_SHARED),yes)
 LLDFLAGS = -static
+else
+LLDFLAGS = -all-static
+endif

 LSRCFILES = $(FSTYP).c
 LDIRT = $(FSTYP)
Index: xfsprogs/quota/Makefile
===================================================================
RCS file: /cvs/xfs-cmds/xfsprogs/quota/Makefile,v
retrieving revision 1.2
diff -u -r1.2 Makefile
--- xfsprogs/quota/Makefile	11 Nov 2005 14:27:22 -0000	1.2
+++ xfsprogs/quota/Makefile	22 Oct 2007 08:46:26 -0000
@@ -16,7 +16,13 @@

 LLDLIBS = $(LIBXCMD)
 LTDEPENDENCIES = $(LIBXCMD)
+
+ifeq ($(ENABLE_SHARED),yes)
 LLDFLAGS = -static
+else
+LLDFLAGS = -all-static
+endif
+

 ifeq ($(ENABLE_READLINE),yes)
 LLDLIBS += $(LIBREADLINE) $(LIBTERMCAP)
Index: xfsprogs/repair/Makefile
===================================================================
RCS file: /cvs/xfs-cmds/xfsprogs/repair/Makefile,v
retrieving revision 1.20
diff -u -r1.20 Makefile
--- xfsprogs/repair/Makefile	7 Sep 2007 06:12:37 -0000	1.20
+++ xfsprogs/repair/Makefile	22 Oct 2007 08:46:26 -0000
@@ -20,7 +20,13 @@

 LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
+
+ifeq ($(ENABLE_SHARED),yes)
 LLDFLAGS = -static
+else
+LLDFLAGS = -all-static
+endif
+

 default: $(LTCOMMAND)

Index: xfsprogs/rtcp/Makefile
===================================================================
RCS file: /cvs/xfs-cmds/xfsprogs/rtcp/Makefile,v
retrieving revision 1.8
diff -u -r1.8 Makefile
--- xfsprogs/rtcp/Makefile	11 Nov 2005 14:27:22 -0000	1.8
+++ xfsprogs/rtcp/Makefile	22 Oct 2007 08:46:26 -0000
@@ -7,7 +7,13 @@

 LTCOMMAND = xfs_rtcp
 CFILES = xfs_rtcp.c
+
+ifeq ($(ENABLE_SHARED),yes)
 LLDFLAGS = -static
+else
+LLDFLAGS = -all-static
+endif
+

 default: $(LTCOMMAND)
