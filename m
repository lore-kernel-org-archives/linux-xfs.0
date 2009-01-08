Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n082bHh2026659 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 20:37:18 -0600
Received: from wf-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 743BB6E255
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2009 18:37:16 -0800 (PST)
Received: from wf-out-1314.google.com (wf-out-1314.google.com
	[209.85.200.172]) by cuda.sgi.com with ESMTP id
	Cere4ty6dgQFf40o for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2009 18:37:16 -0800 (PST)
Received: by wf-out-1314.google.com with SMTP id 26so10964798wfd.32
	for <xfs@oss.sgi.com>; Wed, 07 Jan 2009 18:37:13 -0800 (PST)
Message-Id: <20090108015418.504806823@ifup.org>
Date: Wed, 07 Jan 2009 17:53:56 -0800
From: brandon@ifup.org
Subject: [patch 1/5] [PATCH] acl: add make test target and use make to run
	tests
References: <20090108015355.613058570@ifup.org>
Content-Disposition: inline;
	filename=acl-add-make-test-target-and-use-make-to-run-tests.patch
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
To: tes@sgi.com
Cc: Brandon Philips <bphilips@suse.de>, xfs@oss.sgi.com

The tests are difficult to run. So, this patch adds a Make target that
sets up the path and runs *.test files in the test/ directory.

nfs specific tests can be ran from the test directory by running
`make nfs`

tests requiring root can be ran from the test directory by running
`make nfs`

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
 Makefile      |    6 +++++-
 test/Makefile |   26 +++++++++++++++++++-------
 2 files changed, 24 insertions(+), 8 deletions(-)

Index: acl-2.2.47/test/Makefile
===================================================================
--- acl-2.2.47.orig/test/Makefile
+++ acl-2.2.47/test/Makefile
@@ -2,13 +2,25 @@
 # Copyright (c) 2001-2002 Silicon Graphics, Inc.  All Rights Reserved.
 #
 
-TOPDIR = ..
-include $(TOPDIR)/include/builddefs
+TEST = $(wildcard *.test)
+ROOT = $(wildcard root/*.test)
+NFS = $(wildcard nfs/*.test)
 
-LSRCFILES = run make-tree \
-	    cp.test getfacl-noacl.test misc.test nfs-dir.test \
-	    nfsacl.test permissions.test setfacl.test
+PATH := $(abspath ../getfacl/):$(abspath ../setfacl/):$(abspath ../chacl/):$(PATH)
 
-include $(BUILDRULES)
+all: $(TEST)
+root: $(ROOT)
+nfs: $(NFS)
 
-default install install-dev install-lib:
+
+$(TEST):
+	@echo "*** $@ ***"; perl run $@
+
+$(NFS):
+	@echo "NFS specific tests"; @echo "*** $@ ***"; perl run $@
+
+$(ROOT):
+	@echo "Note: Tests must run as root"; @echo "*** $@ ***"; perl run $@
+
+.PHONY: $(TEST) $(ROOT) $(NFS) default
+.NOTPARALLEL:
Index: acl-2.2.47/Makefile
===================================================================
--- acl-2.2.47.orig/Makefile
+++ acl-2.2.47/Makefile
@@ -17,7 +17,7 @@ LDIRT = config.log .dep config.status co
 	Logs/* built .census install.* install-dev.* install-lib.* *.gz
 
 SUBDIRS = include libmisc libacl getfacl setfacl chacl m4 man doc po \
-	  test examples build debian
+	  examples build debian
 
 default: $(CONFIGURE)
 ifeq ($(HAVE_BUILDDEFS), no)
@@ -65,3 +65,7 @@ install-lib: default
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
