Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 216617F4E
	for <xfs@oss.sgi.com>; Fri,  3 May 2013 12:54:51 -0500 (CDT)
Message-Id: <20130503173918.138615197@cxfsxe4.americas.sgi.com>
Date: Fri, 03 May 2013 12:39:18 -0500
From: rjohnston@sgi.com
Subject: [PATCH V4] xfstests: make install support common/ and tests/ dirs
Content-Disposition: inline;
	filename=v4-xfstests-make-install-support-common-and-tests-dirs.patch
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
Cc: Wang Sheng-Hui <shhuiw@gmail.com>

xfstests have some change on the organization of the testcases
and common* files:
     * The common* scripts have been reorganized into the common/ dir.
     * The testcases have been reorganized into sub test dirs under tests/.
     * The run.* scripts have been removed.

This patch uses the simple way to make install support above changes:
     Make up one Makefile for each newly created subdirs, which can control
     'make install' separately.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
[rjohnston@sgi.com Reposted for current top of tree changes]
---
v4 introduces the following change compared with v3:
     * reposted for current top of tree changes. [rjohnston@sgi.com]

v3 introduces the following change compared with v2:
     * use the neater way by Dave to get the TESTS_SUBDIRS in tests/Makefile.

v2 introduces the following changes compared with v1:
     * Ingore the file 'group' under the topdir, for it's useless in the new
       structures.
     * Remove the redundant comments in the Makefiles.
     * Use XXX_DIR instead of XXX_SUBDIR in the Makefiles under common/ and tests/.
     * Export TESTS_DIR in the top level Makefile instead of tests/Makefile.
     * Obtain the names of dirs for testcases by interating sub dirs under /tests,
       not by enumeration in tests/Makefile.

 Makefile               |   11 ++++-------
 common/Makefile        |   16 ++++++++++++++++
 tests/Makefile         |   19 +++++++++++++++++++
 tests/btrfs/Makefile   |   20 ++++++++++++++++++++
 tests/ext4/Makefile    |   20 ++++++++++++++++++++
 tests/generic/Makefile |   20 ++++++++++++++++++++
 tests/shared/Makefile  |   20 ++++++++++++++++++++
 tests/udf/Makefile     |   20 ++++++++++++++++++++
 tests/xfs/Makefile     |   20 ++++++++++++++++++++
 9 files changed, 159 insertions(+), 7 deletions(-)

Index: b/Makefile
===================================================================
--- a/Makefile
+++ b/Makefile
@@ -52,12 +52,14 @@ LDIRT += $(SRCTAR)
 endif
 
 LIB_SUBDIRS = include lib
-TOOL_SUBDIRS = ltp src m4
+TOOL_SUBDIRS = ltp src m4 common
 ifeq ($(HAVE_DMAPI), true)
 TOOL_SUBDIRS += dmapi
 endif
 
-SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
+TESTS_DIR = tests
+export TESTS_DIR
+SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS) $(TESTS_DIR)
 
 default: include/builddefs $(DMAPI_MAKEFILE) $(TESTS)
 ifeq ($(HAVE_BUILDDEFS), no)
@@ -91,12 +93,7 @@ depend: include/builddefs $(addsuffix -d
 install: default $(addsuffix -install,$(SUBDIRS))
 	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)
 	$(INSTALL) -m 755 check $(PKG_LIB_DIR)
-	$(INSTALL) -m 755 [0-9]?? $(PKG_LIB_DIR)
-	$(INSTALL) -m 755 run.* $(PKG_LIB_DIR)
-	$(INSTALL) -m 644 group $(PKG_LIB_DIR)
 	$(INSTALL) -m 644 randomize.awk $(PKG_LIB_DIR)
-	$(INSTALL) -m 644 [0-9]??.* $(PKG_LIB_DIR)
-	$(INSTALL) -m 644 common* $(PKG_LIB_DIR)
 
 # Nothing.
 install-dev install-lib:
Index: b/common/Makefile
===================================================================
--- /dev/null
+++ b/common/Makefile
@@ -0,0 +1,16 @@
+#
+# Copyright (c) 2003-2006 Silicon Graphics, Inc.  All Rights Reserved.
+#
+
+TOPDIR = ..
+include $(TOPDIR)/include/builddefs
+
+COMMON_DIR = common
+
+include $(BUILDRULES)
+
+install:
+	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/$(COMMON_DIR)
+	$(INSTALL) -m 644 * $(PKG_LIB_DIR)/$(COMMON_DIR)
+
+install-dev install-lib:
Index: b/tests/Makefile
===================================================================
--- /dev/null
+++ b/tests/Makefile
@@ -0,0 +1,19 @@
+#
+# Copyright (c) 2003-2005 Silicon Graphics, Inc.  All Rights Reserved.
+#
+
+TOPDIR = ..
+include $(TOPDIR)/include/builddefs
+
+TESTS_SUBDIRS = $(sort $(dir $(wildcard $(PWD)/$(TESTS_DIR)/[a-z]*/)))
+
+include $(BUILDRULES)
+
+install: $(addsuffix -install,$(TESTS_SUBDIRS))
+	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/$(TESTS_DIR)
+
+# Nothing.
+install-dev install-lib:
+
+%-install:
+	$(MAKE) $(MAKEOPTS) -C $* install
Index: b/tests/btrfs/Makefile
===================================================================
--- /dev/null
+++ b/tests/btrfs/Makefile
@@ -0,0 +1,20 @@
+#
+# Copyright (c) 2003-2005 Silicon Graphics, Inc.  All Rights Reserved.
+#
+
+TOPDIR = ../..
+include $(TOPDIR)/include/builddefs
+
+BTRFS_DIR = btrfs
+TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(BTRFS_DIR)
+
+include $(BUILDRULES)
+
+install:
+	$(INSTALL) -m 755 -d $(TARGET_DIR)
+	$(INSTALL) -m 755 [0-9]?? $(TARGET_DIR)
+	$(INSTALL) -m 644 group $(TARGET_DIR)
+	$(INSTALL) -m 644 [0-9]??.* $(TARGET_DIR)
+
+# Nothing.
+install-dev install-lib:
Index: b/tests/ext4/Makefile
===================================================================
--- /dev/null
+++ b/tests/ext4/Makefile
@@ -0,0 +1,20 @@
+#
+# Copyright (c) 2003-2005 Silicon Graphics, Inc.  All Rights Reserved.
+#
+
+TOPDIR = ../..
+include $(TOPDIR)/include/builddefs
+
+EXT4_DIR = ext4
+TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(EXT4_DIR)
+
+include $(BUILDRULES)
+
+install:
+	$(INSTALL) -m 755 -d $(TARGET_DIR)
+	$(INSTALL) -m 755 [0-9]?? $(TARGET_DIR)
+	$(INSTALL) -m 644 group $(TARGET_DIR)
+	$(INSTALL) -m 644 [0-9]??.* $(TARGET_DIR)
+
+# Nothing.
+install-dev install-lib:
Index: b/tests/generic/Makefile
===================================================================
--- /dev/null
+++ b/tests/generic/Makefile
@@ -0,0 +1,20 @@
+#
+# Copyright (c) 2003-2005 Silicon Graphics, Inc.  All Rights Reserved.
+#
+
+TOPDIR = ../..
+include $(TOPDIR)/include/builddefs
+
+GENERIC_DIR = generic
+TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(GENERIC_DIR)
+
+include $(BUILDRULES)
+
+install:
+	$(INSTALL) -m 755 -d $(TARGET_DIR)
+	$(INSTALL) -m 755 [0-9]?? $(TARGET_DIR)
+	$(INSTALL) -m 644 group $(TARGET_DIR)
+	$(INSTALL) -m 644 [0-9]??.* $(TARGET_DIR)
+
+# Nothing.
+install-dev install-lib:
Index: b/tests/shared/Makefile
===================================================================
--- /dev/null
+++ b/tests/shared/Makefile
@@ -0,0 +1,20 @@
+#
+# Copyright (c) 2003-2005 Silicon Graphics, Inc.  All Rights Reserved.
+#
+
+TOPDIR = ../..
+include $(TOPDIR)/include/builddefs
+
+SHARED_DIR = shared
+TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(SHARED_DIR)
+
+include $(BUILDRULES)
+
+install:
+	$(INSTALL) -m 755 -d $(TARGET_DIR)
+	$(INSTALL) -m 755 [0-9]?? $(TARGET_DIR)
+	$(INSTALL) -m 644 group $(TARGET_DIR)
+	$(INSTALL) -m 644 [0-9]??.* $(TARGET_DIR)
+
+# Nothing.
+install-dev install-lib:
Index: b/tests/udf/Makefile
===================================================================
--- /dev/null
+++ b/tests/udf/Makefile
@@ -0,0 +1,20 @@
+#
+# Copyright (c) 2003-2005 Silicon Graphics, Inc.  All Rights Reserved.
+#
+
+TOPDIR = ../..
+include $(TOPDIR)/include/builddefs
+
+UDF_DIR = udf
+TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(UDF_DIR)
+
+include $(BUILDRULES)
+
+install:
+	$(INSTALL) -m 755 -d $(TARGET_DIR)
+	$(INSTALL) -m 755 [0-9]?? $(TARGET_DIR)
+	$(INSTALL) -m 644 group $(TARGET_DIR)
+	$(INSTALL) -m 644 [0-9]??.* $(TARGET_DIR)
+
+# Nothing.
+install-dev install-lib:
Index: b/tests/xfs/Makefile
===================================================================
--- /dev/null
+++ b/tests/xfs/Makefile
@@ -0,0 +1,20 @@
+#
+# Copyright (c) 2003-2005 Silicon Graphics, Inc.  All Rights Reserved.
+#
+
+TOPDIR = ../..
+include $(TOPDIR)/include/builddefs
+
+XFS_DIR = xfs
+TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(XFS_DIR)
+
+include $(BUILDRULES)
+
+install:
+	$(INSTALL) -m 755 -d $(TARGET_DIR)
+	$(INSTALL) -m 755 [0-9]?? $(TARGET_DIR)
+	$(INSTALL) -m 644 group $(TARGET_DIR)
+	$(INSTALL) -m 644 [0-9]??.* $(TARGET_DIR)
+
+# Nothing.
+install-dev install-lib:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
