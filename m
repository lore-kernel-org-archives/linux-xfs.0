Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C74F77FB0
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 08:27:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5F6DCAC001
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 06:27:13 -0700 (PDT)
Received: from mail-pb0-f48.google.com (mail-pb0-f48.google.com
	[209.85.160.48]) by cuda.sgi.com with ESMTP id 8VCxUL6zotzqud9w
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Apr 2013 06:27:11 -0700 (PDT)
Received: by mail-pb0-f48.google.com with SMTP id xb4so851526pbc.35
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 06:27:11 -0700 (PDT)
Message-ID: <5166BA24.1060809@gmail.com>
Date: Thu, 11 Apr 2013 21:27:00 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: make install support common/ and tests/ dirs
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
To: Dave Chinner <dchinner@redhat.com>, xfstests <xfs@oss.sgi.com>

xfstests have some change on the organization of the testcases
and common* files:
     * The common* scripts have been reorganized into the common/ dir.
     * The testcases have been reorganized into sub test dirs under tests/.
     * The run.* scripts have been removed.

This patch uses the simple way to make install support above changes:
     Make up one Makefile for each newly created subdirs, which can control
     'make install' separately.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
  Makefile               | 11 +++++------
  common/Makefile        | 17 +++++++++++++++++
  tests/Makefile         | 23 +++++++++++++++++++++++
  tests/btrfs/Makefile   | 21 +++++++++++++++++++++
  tests/ext4/Makefile    | 21 +++++++++++++++++++++
  tests/generic/Makefile | 21 +++++++++++++++++++++
  tests/shared/Makefile  | 21 +++++++++++++++++++++
  tests/udf/Makefile     | 21 +++++++++++++++++++++
  tests/xfs/Makefile     | 21 +++++++++++++++++++++
  9 files changed, 171 insertions(+), 6 deletions(-)
  create mode 100644 common/Makefile
  create mode 100644 tests/Makefile
  create mode 100644 tests/btrfs/Makefile
  create mode 100644 tests/ext4/Makefile
  create mode 100644 tests/generic/Makefile
  create mode 100644 tests/shared/Makefile
  create mode 100644 tests/udf/Makefile
  create mode 100644 tests/xfs/Makefile

diff --git a/Makefile b/Makefile
index 6edd55c..95e3e5d 100644
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
+# all the tests have been put into tests/
+TESTS_SUBDIR = tests
+
+SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS) $(TESTS_SUBDIR)

  default: include/builddefs $(DMAPI_MAKEFILE) $(TESTS)
  ifeq ($(HAVE_BUILDDEFS), no)
@@ -91,12 +94,8 @@ depend: include/builddefs $(addsuffix -depend,$(SUBDIRS))
  install: default $(addsuffix -install,$(SUBDIRS))
  	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)
  	$(INSTALL) -m 755 check $(PKG_LIB_DIR)
-	$(INSTALL) -m 755 [0-9]?? $(PKG_LIB_DIR)
-	$(INSTALL) -m 755 run.* $(PKG_LIB_DIR)
  	$(INSTALL) -m 644 group $(PKG_LIB_DIR)
  	$(INSTALL) -m 644 randomize.awk $(PKG_LIB_DIR)
-	$(INSTALL) -m 644 [0-9]??.* $(PKG_LIB_DIR)
-	$(INSTALL) -m 644 common* $(PKG_LIB_DIR)

  # Nothing.
  install-dev install-lib:
diff --git a/common/Makefile b/common/Makefile
new file mode 100644
index 0000000..649f55f
--- /dev/null
+++ b/common/Makefile
@@ -0,0 +1,17 @@
+#
+# Copyright (c) 2003-2006 Silicon Graphics, Inc.  All Rights Reserved.
+#
+
+TOPDIR = ..
+include $(TOPDIR)/include/builddefs
+
+# current ../common dir
+COMMON_SUBDIR = common
+
+include $(BUILDRULES)
+
+install:
+	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/$(COMMON_SUBDIR)
+	$(INSTALL) -m 644 * $(PKG_LIB_DIR)/$(COMMON_SUBDIR)
+
+install-dev install-lib:
diff --git a/tests/Makefile b/tests/Makefile
new file mode 100644
index 0000000..50e6bb3
--- /dev/null
+++ b/tests/Makefile
@@ -0,0 +1,23 @@
+#
+# Copyright (c) 2003-2005 Silicon Graphics, Inc.  All Rights Reserved.
+#
+
+TOPDIR = ..
+include $(TOPDIR)/include/builddefs
+
+# current ../tests dir
+TESTS_SUBDIR = tests
+export TESTS_SUBDIR
+
+TESTS_SUBDIRS = btrfs ext4 generic shared udf xfs
+
+include $(BUILDRULES)
+
+install: $(addsuffix -install,$(TESTS_SUBDIRS))
+	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/$(TESTS_SUBDIR)
+
+# Nothing.
+install-dev install-lib:
+
+%-install:
+	$(MAKE) $(MAKEOPTS) -C $* install
diff --git a/tests/btrfs/Makefile b/tests/btrfs/Makefile
new file mode 100644
index 0000000..35ec6ec
--- /dev/null
+++ b/tests/btrfs/Makefile
@@ -0,0 +1,21 @@
+#
+# Copyright (c) 2003-2005 Silicon Graphics, Inc.  All Rights Reserved.
+#
+
+TOPDIR = ../..
+include $(TOPDIR)/include/builddefs
+
+# ../tests/btrfs dir
+BTRFS_SUBDIR = btrfs
+TARGET_SUBDIR = $(PKG_LIB_DIR)/$(TESTS_SUBDIR)/$(BTRFS_SUBDIR)
+
+include $(BUILDRULES)
+
+install:
+	$(INSTALL) -m 755 -d $(TARGET_SUBDIR)
+	$(INSTALL) -m 755 [0-9]?? $(TARGET_SUBDIR)
+	$(INSTALL) -m 644 group $(TARGET_SUBDIR)
+	$(INSTALL) -m 644 [0-9]??.* $(TARGET_SUBDIR)
+
+# Nothing.
+install-dev install-lib:
diff --git a/tests/ext4/Makefile b/tests/ext4/Makefile
new file mode 100644
index 0000000..94b683b
--- /dev/null
+++ b/tests/ext4/Makefile
@@ -0,0 +1,21 @@
+#
+# Copyright (c) 2003-2005 Silicon Graphics, Inc.  All Rights Reserved.
+#
+
+TOPDIR = ../..
+include $(TOPDIR)/include/builddefs
+
+# ../tests/ext4 dir
+EXT4_SUBDIR = ext4
+TARGET_SUBDIR = $(PKG_LIB_DIR)/$(TESTS_SUBDIR)/$(EXT4_SUBDIR)
+
+include $(BUILDRULES)
+
+install:
+	$(INSTALL) -m 755 -d $(TARGET_SUBDIR)
+	$(INSTALL) -m 755 [0-9]?? $(TARGET_SUBDIR)
+	$(INSTALL) -m 644 group $(TARGET_SUBDIR)
+	$(INSTALL) -m 644 [0-9]??.* $(TARGET_SUBDIR)
+
+# Nothing.
+install-dev install-lib:
diff --git a/tests/generic/Makefile b/tests/generic/Makefile
new file mode 100644
index 0000000..4858b1d
--- /dev/null
+++ b/tests/generic/Makefile
@@ -0,0 +1,21 @@
+#
+# Copyright (c) 2003-2005 Silicon Graphics, Inc.  All Rights Reserved.
+#
+
+TOPDIR = ../..
+include $(TOPDIR)/include/builddefs
+
+# ../tests/generic dir
+GENERIC_SUBDIR = generic
+TARGET_SUBDIR = $(PKG_LIB_DIR)/$(TESTS_SUBDIR)/$(GENERIC_SUBDIR)
+
+include $(BUILDRULES)
+
+install:
+	$(INSTALL) -m 755 -d $(TARGET_SUBDIR)
+	$(INSTALL) -m 755 [0-9]?? $(TARGET_SUBDIR)
+	$(INSTALL) -m 644 group $(TARGET_SUBDIR)
+	$(INSTALL) -m 644 [0-9]??.* $(TARGET_SUBDIR)
+
+# Nothing.
+install-dev install-lib:
diff --git a/tests/shared/Makefile b/tests/shared/Makefile
new file mode 100644
index 0000000..d2d980e
--- /dev/null
+++ b/tests/shared/Makefile
@@ -0,0 +1,21 @@
+#
+# Copyright (c) 2003-2005 Silicon Graphics, Inc.  All Rights Reserved.
+#
+
+TOPDIR = ../..
+include $(TOPDIR)/include/builddefs
+
+# ../tests/shared dir
+SHARED_SUBDIR = shared
+TARGET_SUBDIR = $(PKG_LIB_DIR)/$(TESTS_SUBDIR)/$(SHARED_SUBDIR)
+
+include $(BUILDRULES)
+
+install:
+	$(INSTALL) -m 755 -d $(TARGET_SUBDIR)
+	$(INSTALL) -m 755 [0-9]?? $(TARGET_SUBDIR)
+	$(INSTALL) -m 644 group $(TARGET_SUBDIR)
+	$(INSTALL) -m 644 [0-9]??.* $(TARGET_SUBDIR)
+
+# Nothing.
+install-dev install-lib:
diff --git a/tests/udf/Makefile b/tests/udf/Makefile
new file mode 100644
index 0000000..bf01eef
--- /dev/null
+++ b/tests/udf/Makefile
@@ -0,0 +1,21 @@
+#
+# Copyright (c) 2003-2005 Silicon Graphics, Inc.  All Rights Reserved.
+#
+
+TOPDIR = ../..
+include $(TOPDIR)/include/builddefs
+
+# ../tests/udf dir
+UDF_SUBDIR = udf
+TARGET_SUBDIR = $(PKG_LIB_DIR)/$(TESTS_SUBDIR)/$(UDF_SUBDIR)
+
+include $(BUILDRULES)
+
+install:
+	$(INSTALL) -m 755 -d $(TARGET_SUBDIR)
+	$(INSTALL) -m 755 [0-9]?? $(TARGET_SUBDIR)
+	$(INSTALL) -m 644 group $(TARGET_SUBDIR)
+	$(INSTALL) -m 644 [0-9]??.* $(TARGET_SUBDIR)
+
+# Nothing.
+install-dev install-lib:
diff --git a/tests/xfs/Makefile b/tests/xfs/Makefile
new file mode 100644
index 0000000..e6d1b32
--- /dev/null
+++ b/tests/xfs/Makefile
@@ -0,0 +1,21 @@
+#
+# Copyright (c) 2003-2005 Silicon Graphics, Inc.  All Rights Reserved.
+#
+
+TOPDIR = ../..
+include $(TOPDIR)/include/builddefs
+
+# ../tests/xfs dir
+XFS_SUBDIR = xfs
+TARGET_SUBDIR = $(PKG_LIB_DIR)/$(TESTS_SUBDIR)/$(XFS_SUBDIR)
+
+include $(BUILDRULES)
+
+install:
+	$(INSTALL) -m 755 -d $(TARGET_SUBDIR)
+	$(INSTALL) -m 755 [0-9]?? $(TARGET_SUBDIR)
+	$(INSTALL) -m 644 group $(TARGET_SUBDIR)
+	$(INSTALL) -m 644 [0-9]??.* $(TARGET_SUBDIR)
+
+# Nothing.
+install-dev install-lib:
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
