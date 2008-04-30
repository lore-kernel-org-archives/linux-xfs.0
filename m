Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Apr 2008 23:31:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3U6Uvs8005544
	for <xfs@oss.sgi.com>; Tue, 29 Apr 2008 23:31:00 -0700
Message-ID: <48181247.8010705@sgi.com>
Date: Wed, 30 Apr 2008 16:31:35 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: review: xfstests/Makefile for dmapi
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Hi,

In some tests I found that Automake 1.9.1 output a "default" target
whereas Automake 1.9.6 did not produce a "default" target - in each
case they used the "all" target.
So change the default Make to build dmapi with the "all" target
instead of using SUBDIRS_MAKERULE on default for it.
The SUBDIRS_MAKERULE in xfstests only seems to be used for the
default target.

--Tim

diff --git a/xfstests/Makefile b/xfstests/Makefile
index 99509ff..0a0fc27 100644
--- a/xfstests/Makefile
+++ b/xfstests/Makefile
@@ -1,5 +1,5 @@
  #
-# Copyright (c) 2000-2006 Silicon Graphics, Inc.  All Rights Reserved.
+# Copyright (c) 2000-2008 Silicon Graphics, Inc.  All Rights Reserved.
  #

  TOPDIR = .
@@ -16,13 +16,16 @@ LSRCFILES = configure configure.in aclocal.m4 README VERSION
  LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
  	check.log check.time

-SUBDIRS = include lib ltp src m4 dmapi
+SUBDIRS = include lib ltp src m4

  default: $(CONFIGURE) $(DMAPI_MAKEFILE) new remake check $(TESTS)
  ifeq ($(HAVE_BUILDDEFS), no)
  	$(MAKE) $@
  else
  	$(SUBDIRS_MAKERULE)
+	# automake doesn't always support "default" target
+	# so do dmapi make explicitly with "all"
+	cd $(TOPDIR)/dmapi; make all
  endif

  ifeq ($(HAVE_BUILDDEFS), yes)
