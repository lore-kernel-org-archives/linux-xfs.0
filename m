Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D284F7F37
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 23:27:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5C4E5AC003
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 21:27:11 -0700 (PDT)
Received: from mail-qe0-f43.google.com (mail-qe0-f43.google.com
	[209.85.128.43]) by cuda.sgi.com with ESMTP id nJFWNEjxkZs0YIJ1
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Apr 2013 21:27:09 -0700 (PDT)
Received: by mail-qe0-f43.google.com with SMTP id f6so1330034qej.16
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 21:27:09 -0700 (PDT)
Message-ID: <51678D0D.1070002@gmail.com>
Date: Fri, 12 Apr 2013 12:26:53 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
Subject: [PATCH v2] xfstests: make install support common/ and tests/ dirs
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <dchinner@redhat.com>, Rich Johnston <rjohnston@sgi.com>, xfstests <xfs@oss.sgi.com>

xfstests have some change on the organization of the testcases
and common* files:
     * The common* scripts have been reorganized into the common/ dir.
     * The testcases have been reorganized into sub test dirs under tests/.
     * The run.* scripts have been removed.

This patch uses the simple way to make install support above changes:
     Make up one Makefile for each newly created subdirs, which can control
     'make install' separately.

v2 introduces the following changes compared with v1:
     * Ignore the file 'group' under the top dir, for it's useless in the new
       structures.
     * Remove the redundant comments in the Makefiles.
     * Use XXX_DIR instead of XXX_SUBDIR in the Makefiles under common/ and tests/.
     * Export TESTS_DIR in teh top level Makefile instead of tests/Makefile.
     * Obtain the names of dirs for testcases by iterating sub dirs under /tests,
       not by enumeration in tests/Makefile.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
  Makefile               | 12 +++++-------
  common/Makefile        | 16 ++++++++++++++++
  tests/Makefile         | 19 +++++++++++++++++++
  tests/btrfs/Makefile   | 20 ++++++++++++++++++++
  tests/ext4/Makefile    | 20 ++++++++++++++++++++
  tests/generic/Makefile | 20 ++++++++++++++++++++
  tests/shared/Makefile  | 20 ++++++++++++++++++++
  tests/udf/Makefile     | 20 ++++++++++++++++++++
  tests/xfs/Makefile     | 20 ++++++++++++++++++++
  9 files changed, 160 insertions(+), 7 deletions(-)
  create mode 100644 common/Makefile
  create mode 100644 tests/Makefile
  create mode 100644 tests/btrfs/Makefile
  create mode 100644 tests/ext4/Makefile
  create mode 100644 tests/generic/Makefile
  create mode 100644 tests/shared/Makefile
  create mode 100644 tests/udf/Makefile
  create mode 100644 tests/xfs/Makefile

diff --git a/Makefile b/Makefile
index 6edd55c..611b36d 100644
--- a/Makefile
+++ b/Makefile
@@ -52,12 +52,15 @@ LDIRT += $(SRCTAR)
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
+
+SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS) $(TESTS_DIR)

  default: include/builddefs $(DMAPI_MAKEFILE) $(TESTS)
  ifeq ($(HAVE_BUILDDEFS), no)
@@ -91,12 +94,7 @@ depend: include/builddefs $(addsuffix -depend,$(SUBDIRS))
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
diff --git a/common/Makefile b/common/Makefile
new file mode 100644
index 0000000..5f91e8c
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
diff --git a/tests/Makefile b/tests/Makefile
new file mode 100644
index 0000000..254dd48
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
+TESTS_SUBDIRS = $(shell find . -maxdepth 1 -type d | sed -n -e 's/\.\///gp')
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
diff --git a/tests/btrfs/Makefile b/tests/btrfs/Makefile
new file mode 100644
index 0000000..e1a5be1
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
diff --git a/tests/ext4/Makefile b/tests/ext4/Makefile
new file mode 100644
index 0000000..7a3c8e1
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
diff --git a/tests/generic/Makefile b/tests/generic/Makefile
new file mode 100644
index 0000000..9529fb8
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
diff --git a/tests/shared/Makefile b/tests/shared/Makefile
new file mode 100644
index 0000000..cbd87f9
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
diff --git a/tests/udf/Makefile b/tests/udf/Makefile
new file mode 100644
index 0000000..1d96658
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
diff --git a/tests/xfs/Makefile b/tests/xfs/Makefile
new file mode 100644
index 0000000..db94be0
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
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
