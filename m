Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n082LNjv025719 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 20:21:27 -0600
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 80E446E2C0
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2009 18:21:23 -0800 (PST)
Received: from rv-out-0708.google.com (rv-out-0708.google.com
	[209.85.198.246]) by cuda.sgi.com with ESMTP id
	W5XPtQLb3vounL7X for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2009 18:21:23 -0800 (PST)
Received: by rv-out-0708.google.com with SMTP id f25so8074933rvb.32
	for <xfs@oss.sgi.com>; Wed, 07 Jan 2009 18:21:23 -0800 (PST)
Message-Id: <20090108022109.147601019@ifup.org>
Date: Wed, 07 Jan 2009 18:19:50 -0800
From: brandon@ifup.org
Subject: [patch 3/4] [PATCH] attr: add make test target and use make to run
	tests
References: <20090108021947.404730068@ifup.org>
Content-Disposition: inline;
	filename=attr-add-make-test-target-and-use-make-to-run-tests.patch
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: Brandon Philips <bphilips@suse.de>

The tests are difficult to run. So, this patch adds a Make target that
sets up the path and runs *.test files in the test/ directory.

ext specific tests can be ran from the test directory by running 
`make ext`

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
 Makefile      |    6 +++++-
 test/Makefile |   22 +++++++++++++---------
 test/README   |    4 ++++
 3 files changed, 22 insertions(+), 10 deletions(-)

Index: attr-2.4.43/test/README
===================================================================
--- attr-2.4.43.orig/test/README
+++ attr-2.4.43/test/README
@@ -1,3 +1,7 @@
+Run `make test` in the root source tree to build the tree and run
+FS-independent tests.
+
+Run `cd test; make ext` to run ext specific tests.
 
 Andreas Gruenbacher's tests for the ext2 filesystem extended attributes
 support.  Most of these tests should work for any filesystem type, and
Index: attr-2.4.43/test/Makefile
===================================================================
--- attr-2.4.43.orig/test/Makefile
+++ attr-2.4.43/test/Makefile
@@ -1,16 +1,20 @@
 #
-# Copyright (c) 2001-2002 Silicon Graphics, Inc.  All Rights Reserved.
+# Copyright (c) 2008 Novell, Inc.
 #
 
-TOPDIR = ..
-include $(TOPDIR)/include/builddefs
+TEST = $(wildcard *.test)
+EXT = $(wildcard ext/*.test)
 
-# ensure we pick these up in the source tarball
-LSRCFILES = attr.test run README
+PATH := $(abspath ../getfattr/):$(abspath ../setfattr):$(abspath ../chattr):$(PATH)
 
-default:
+all: $(TEST)
+ext: $(EXT)
 
-include $(BUILDRULES)
+$(TEST):
+	@echo "*** $@ ***"; perl run $@
 
-install:
-install-dev install-lib:
+$(EXT):
+	@echo "EXT specific tests"; @echo "*** $@ ***"; perl run $@
+
+.PHONY: $(TEST) $(EXT) default
+.NOTPARALLEL:
Index: attr-2.4.43/Makefile
===================================================================
--- attr-2.4.43.orig/Makefile
+++ attr-2.4.43/Makefile
@@ -17,7 +17,7 @@ LDIRT = config.log .dep config.status co
 	Logs/* built .census install.* install-dev.* install-lib.* *.gz
 
 SUBDIRS = include libmisc libattr attr getfattr setfattr \
-	  examples test m4 man doc po debian build
+	  examples m4 man doc po debian build
 
 default: $(CONFIGURE)
 ifeq ($(HAVE_BUILDDEFS), no)
@@ -62,3 +62,7 @@ install-dev install-lib: default
 realclean distclean: clean
 	rm -f $(LDIRT) $(CONFIGURE)
 	rm -rf autom4te.cache Logs
+
+.PHONY: test
+test: default
+	$(MAKE) -C test/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
