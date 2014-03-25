Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0C5047F3F
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 18:44:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F29F8304075
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 16:44:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 18ptclEs2BDx5kUH for
	<xfs@oss.sgi.com>; Tue, 25 Mar 2014 16:44:05 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2PNi41H007116
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 19:44:05 -0400
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/2 v2] xfstests: Make some shared tests generic
Date: Wed, 26 Mar 2014 00:43:57 +0100
Message-Id: <1395791038-22468-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>

There are couple of tests in shared directory which really should be
made generic, so move it. It is mostly collapse range tests, which
really can be generic to make super we test every file system which adds
collapse range support.

Here is what we're moving in this commit.

shared/001 -> generic/004
shared/002 -> generic/009
shared/003 -> generic/012
shared/004 -> generic/016
shared/005 -> generic/017
shared/218 -> generic/018
shared/305 -> generic/019

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
v2: Set missing executable bit on some tests

 tests/generic/004     |  65 ++++++++++++++++++
 tests/generic/004.out |  49 +++++++++++++
 tests/generic/009     |  65 ++++++++++++++++++
 tests/generic/009.out |  49 +++++++++++++
 tests/generic/012     |  65 ++++++++++++++++++
 tests/generic/012.out |  49 +++++++++++++
 tests/generic/016     |  65 ++++++++++++++++++
 tests/generic/016.out |  49 +++++++++++++
 tests/generic/017     |  90 ++++++++++++++++++++++++
 tests/generic/017.out |   4 ++
 tests/generic/018     |  93 +++++++++++++++++++++++++
 tests/generic/018.out |  19 +++++
 tests/generic/019     | 187 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/019.out |   9 +++
 tests/generic/group   |   7 ++
 tests/shared/001      |  65 ------------------
 tests/shared/001.out  |  49 -------------
 tests/shared/002      |  65 ------------------
 tests/shared/002.out  |  49 -------------
 tests/shared/003      |  65 ------------------
 tests/shared/003.out  |  49 -------------
 tests/shared/004      |  65 ------------------
 tests/shared/004.out  |  49 -------------
 tests/shared/005      |  90 ------------------------
 tests/shared/005.out  |   4 --
 tests/shared/218      |  93 -------------------------
 tests/shared/218.out  |  19 -----
 tests/shared/305      | 187 --------------------------------------------------
 tests/shared/305.out  |   9 ---
 tests/shared/group    |   8 ---
 30 files changed, 865 insertions(+), 866 deletions(-)
 create mode 100755 tests/generic/004
 create mode 100644 tests/generic/004.out
 create mode 100755 tests/generic/009
 create mode 100644 tests/generic/009.out
 create mode 100755 tests/generic/012
 create mode 100644 tests/generic/012.out
 create mode 100755 tests/generic/016
 create mode 100644 tests/generic/016.out
 create mode 100755 tests/generic/017
 create mode 100644 tests/generic/017.out
 create mode 100755 tests/generic/018
 create mode 100644 tests/generic/018.out
 create mode 100755 tests/generic/019
 create mode 100644 tests/generic/019.out
 delete mode 100755 tests/shared/001
 delete mode 100644 tests/shared/001.out
 delete mode 100644 tests/shared/002
 delete mode 100644 tests/shared/002.out
 delete mode 100644 tests/shared/003
 delete mode 100644 tests/shared/003.out
 delete mode 100644 tests/shared/004
 delete mode 100644 tests/shared/004.out
 delete mode 100644 tests/shared/005
 delete mode 100644 tests/shared/005.out
 delete mode 100755 tests/shared/218
 delete mode 100644 tests/shared/218.out
 delete mode 100755 tests/shared/305
 delete mode 100644 tests/shared/305.out

diff --git a/tests/generic/004 b/tests/generic/004
new file mode 100755
index 0000000..36dcdea
--- /dev/null
+++ b/tests/generic/004
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. generic/004
+#
+# Standard collapse range tests 
+# This testcase is one of the 4 testcases which tries to
+# test various corner cases for fcollapse range functionality over different
+# type of extents. These tests are based on generic/255 test case.
+# For the type of tests, check the description of _test_generic_punch
+# in common/rc.
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Samsung Electronics.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_cleanup()
+{
+    rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+# we need to include common/punch to get defination fo filter functions
+. ./common/rc
+. ./common/filter
+. ./common/punch
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+_require_xfs_io_falloc_punch
+_require_xfs_io_falloc
+_require_xfs_io_fiemap
+_require_xfs_io_falloc_collapse
+
+testfile=$TEST_DIR/$seq.$$
+
+_test_generic_punch falloc fpunch fcollapse fiemap _filter_hole_fiemap $testfile
+_check_test_fs
+
+status=0
+exit
diff --git a/tests/generic/004.out b/tests/generic/004.out
new file mode 100644
index 0000000..befcabd
--- /dev/null
+++ b/tests/generic/004.out
@@ -0,0 +1,49 @@
+QA output created by 004
+	1. into a hole
+f4f35d60b3cc18aaa6d8d92f0cd3708a
+	2. into allocated space
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
+	3. into unwritten space
+0: [0..95]: extent
+f4f35d60b3cc18aaa6d8d92f0cd3708a
+	4. hole -> data
+0: [0..31]: hole
+1: [32..63]: extent
+2: [64..95]: hole
+d8f51c20223dbce5c7c90db87bc221b0
+	5. hole -> unwritten
+0: [0..31]: hole
+1: [32..63]: extent
+2: [64..95]: hole
+f4f35d60b3cc18aaa6d8d92f0cd3708a
+	6. data -> hole
+0: [0..31]: extent
+1: [32..95]: hole
+f07217d5ac7ffa15dd8910c4aa912674
+	7. data -> unwritten
+0: [0..63]: extent
+1: [64..95]: hole
+f07217d5ac7ffa15dd8910c4aa912674
+	8. unwritten -> hole
+0: [0..31]: extent
+1: [32..95]: hole
+f4f35d60b3cc18aaa6d8d92f0cd3708a
+	9. unwritten -> data
+0: [0..63]: extent
+1: [64..95]: hole
+d8f51c20223dbce5c7c90db87bc221b0
+	10. hole -> data -> hole
+bb7df04e1b0a2570657527a7e108ae23
+	11. data -> hole -> data
+0: [0..63]: extent
+0f0151cbed83e4bf6e5bde26e82ab115
+	12. unwritten -> data -> unwritten
+0: [0..63]: extent
+bb7df04e1b0a2570657527a7e108ae23
+	13. data -> unwritten -> data
+0: [0..63]: extent
+0f0151cbed83e4bf6e5bde26e82ab115
+	14. data -> hole @ 0
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
diff --git a/tests/generic/009 b/tests/generic/009
new file mode 100755
index 0000000..fa0814b
--- /dev/null
+++ b/tests/generic/009
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. generic/009
+#
+# Delayed allocation collapse range tests
+# This testcase is one of the 4 testcases which tries to
+# test various corner cases for fcollapse range functionality over different
+# type of extents. These tests are based on generic/255 test case.
+# For the type of tests, check the description of _test_generic_punch
+# in common/rc.
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Samsung Electronics.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_cleanup()
+{
+    rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+# we need to include common/punch to get defination fo filter functions
+. ./common/rc
+. ./common/filter
+. ./common/punch
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+_require_xfs_io_falloc_punch
+_require_xfs_io_falloc
+_require_xfs_io_fiemap
+_require_xfs_io_falloc_collapse
+
+testfile=$TEST_DIR/$seq.$$
+
+_test_generic_punch -d falloc fpunch fcollapse fiemap _filter_hole_fiemap $testfile
+_check_test_fs
+
+status=0
+exit
diff --git a/tests/generic/009.out b/tests/generic/009.out
new file mode 100644
index 0000000..96c2d33
--- /dev/null
+++ b/tests/generic/009.out
@@ -0,0 +1,49 @@
+QA output created by 009
+	1. into a hole
+f4f35d60b3cc18aaa6d8d92f0cd3708a
+	2. into allocated space
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
+	3. into unwritten space
+0: [0..95]: extent
+f4f35d60b3cc18aaa6d8d92f0cd3708a
+	4. hole -> data
+0: [0..31]: hole
+1: [32..63]: extent
+2: [64..95]: hole
+d8f51c20223dbce5c7c90db87bc221b0
+	5. hole -> unwritten
+0: [0..31]: hole
+1: [32..63]: extent
+2: [64..95]: hole
+f4f35d60b3cc18aaa6d8d92f0cd3708a
+	6. data -> hole
+0: [0..31]: extent
+1: [32..95]: hole
+f07217d5ac7ffa15dd8910c4aa912674
+	7. data -> unwritten
+0: [0..63]: extent
+1: [64..95]: hole
+f07217d5ac7ffa15dd8910c4aa912674
+	8. unwritten -> hole
+0: [0..31]: extent
+1: [32..95]: hole
+f4f35d60b3cc18aaa6d8d92f0cd3708a
+	9. unwritten -> data
+0: [0..63]: extent
+1: [64..95]: hole
+d8f51c20223dbce5c7c90db87bc221b0
+	10. hole -> data -> hole
+bb7df04e1b0a2570657527a7e108ae23
+	11. data -> hole -> data
+0: [0..63]: extent
+0f0151cbed83e4bf6e5bde26e82ab115
+	12. unwritten -> data -> unwritten
+0: [0..63]: extent
+bb7df04e1b0a2570657527a7e108ae23
+	13. data -> unwritten -> data
+0: [0..63]: extent
+0f0151cbed83e4bf6e5bde26e82ab115
+	14. data -> hole @ 0
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
diff --git a/tests/generic/012 b/tests/generic/012
new file mode 100755
index 0000000..e689299
--- /dev/null
+++ b/tests/generic/012
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. generic/012
+#
+# Multi collapse range tests
+# This testcase is one of the 4 testcases which tries to
+# test various corner cases for fcollapse range functionality over different
+# type of extents. These tests are based on generic/255 test case.
+# For the type of tests, check the description of _test_generic_punch
+# in common/rc.
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Samsung Electronics.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_cleanup()
+{
+    rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+# we need to include common/punch to get defination fo filter functions
+. ./common/rc
+. ./common/filter
+. ./common/punch
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+_require_xfs_io_falloc_punch
+_require_xfs_io_falloc
+_require_xfs_io_fiemap
+_require_xfs_io_falloc_collapse
+
+testfile=$TEST_DIR/$seq.$$
+
+_test_generic_punch -k falloc fpunch fcollapse fiemap _filter_hole_fiemap $testfile
+_check_test_fs
+
+status=0
+exit
diff --git a/tests/generic/012.out b/tests/generic/012.out
new file mode 100644
index 0000000..ffbf8a3
--- /dev/null
+++ b/tests/generic/012.out
@@ -0,0 +1,49 @@
+QA output created by 012
+	1. into a hole
+f4f35d60b3cc18aaa6d8d92f0cd3708a
+	2. into allocated space
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
+	3. into unwritten space
+0: [0..95]: extent
+f07217d5ac7ffa15dd8910c4aa912674
+	4. hole -> data
+0: [0..63]: extent
+1: [64..95]: hole
+e5c94f6299822646f9f57aeacd8bdc01
+	5. hole -> unwritten
+0: [0..63]: extent
+1: [64..95]: hole
+f07217d5ac7ffa15dd8910c4aa912674
+	6. data -> hole
+0: [0..31]: extent
+1: [32..95]: hole
+f07217d5ac7ffa15dd8910c4aa912674
+	7. data -> unwritten
+0: [0..63]: extent
+1: [64..95]: hole
+f07217d5ac7ffa15dd8910c4aa912674
+	8. unwritten -> hole
+0: [0..31]: extent
+1: [32..95]: hole
+f07217d5ac7ffa15dd8910c4aa912674
+	9. unwritten -> data
+0: [0..63]: extent
+1: [64..95]: hole
+e5c94f6299822646f9f57aeacd8bdc01
+	10. hole -> data -> hole
+0: [0..31]: extent
+1: [32..63]: hole
+76cc863b386460b228a493933813a6a0
+	11. data -> hole -> data
+0: [0..63]: extent
+0f0151cbed83e4bf6e5bde26e82ab115
+	12. unwritten -> data -> unwritten
+0: [0..63]: extent
+76cc863b386460b228a493933813a6a0
+	13. data -> unwritten -> data
+0: [0..63]: extent
+0f0151cbed83e4bf6e5bde26e82ab115
+	14. data -> hole @ 0
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
diff --git a/tests/generic/016 b/tests/generic/016
new file mode 100755
index 0000000..13a4488
--- /dev/null
+++ b/tests/generic/016
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. generic/016
+#
+# Delayed allocation multi collapse range tests
+# This testcase is one of the 4 testcases which tries to
+# test various corner cases for fcollapse range functionality over different
+# type of extents. These tests are based on generic/255 test case.
+# For the type of tests, check the description of _test_generic_punch
+# in common/rc.
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Samsung Electronics.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_cleanup()
+{
+    rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+# we need to include common/punch to get defination fo filter functions
+. ./common/rc
+. ./common/filter
+. ./common/punch
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+_require_xfs_io_falloc_punch
+_require_xfs_io_falloc
+_require_xfs_io_fiemap
+_require_xfs_io_falloc_collapse
+
+testfile=$TEST_DIR/$seq.$$
+
+_test_generic_punch -d -k falloc fpunch fcollapse fiemap _filter_hole_fiemap $testfile
+_check_test_fs
+
+status=0
+exit
diff --git a/tests/generic/016.out b/tests/generic/016.out
new file mode 100644
index 0000000..c45a44a
--- /dev/null
+++ b/tests/generic/016.out
@@ -0,0 +1,49 @@
+QA output created by 016
+	1. into a hole
+f4f35d60b3cc18aaa6d8d92f0cd3708a
+	2. into allocated space
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
+	3. into unwritten space
+0: [0..95]: extent
+f07217d5ac7ffa15dd8910c4aa912674
+	4. hole -> data
+0: [0..63]: extent
+1: [64..95]: hole
+e5c94f6299822646f9f57aeacd8bdc01
+	5. hole -> unwritten
+0: [0..63]: extent
+1: [64..95]: hole
+f07217d5ac7ffa15dd8910c4aa912674
+	6. data -> hole
+0: [0..31]: extent
+1: [32..95]: hole
+f07217d5ac7ffa15dd8910c4aa912674
+	7. data -> unwritten
+0: [0..63]: extent
+1: [64..95]: hole
+f07217d5ac7ffa15dd8910c4aa912674
+	8. unwritten -> hole
+0: [0..31]: extent
+1: [32..95]: hole
+f07217d5ac7ffa15dd8910c4aa912674
+	9. unwritten -> data
+0: [0..63]: extent
+1: [64..95]: hole
+e5c94f6299822646f9f57aeacd8bdc01
+	10. hole -> data -> hole
+0: [0..31]: extent
+1: [32..63]: hole
+76cc863b386460b228a493933813a6a0
+	11. data -> hole -> data
+0: [0..63]: extent
+0f0151cbed83e4bf6e5bde26e82ab115
+	12. unwritten -> data -> unwritten
+0: [0..63]: extent
+76cc863b386460b228a493933813a6a0
+	13. data -> unwritten -> data
+0: [0..63]: extent
+0f0151cbed83e4bf6e5bde26e82ab115
+	14. data -> hole @ 0
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
diff --git a/tests/generic/017 b/tests/generic/017
new file mode 100755
index 0000000..93a4045
--- /dev/null
+++ b/tests/generic/017
@@ -0,0 +1,90 @@
+#! /bin/bash
+# FS QA Test No. generci/017
+#
+# Test multiple fallocate collapse range calls on same file.
+# For different blocksizes, collapse a single alternate block multiple times
+# until the file is left with 80 blocks and as much number of extents.
+# Also check for file system consistency after completing this operation
+# for each blocksize.
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Samsung Electronics.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+_require_scratch
+_require_xfs_io_fiemap
+_require_xfs_io_falloc_collapse
+_do_die_on_error=y
+testfile=$SCRATCH_MNT/$seq.$$
+BLOCKS=10240
+
+for (( BSIZE = 1024; BSIZE <= 4096; BSIZE *= 2 )); do
+
+	length=$(($BLOCKS * $BSIZE))
+	case $FSTYP in
+	xfs)
+	_scratch_mkfs -b size=$BSIZE >> $seqres.full 2>&1
+	;;
+	ext4)
+	_scratch_mkfs -b $BSIZE >> $seqres.full 2>&1
+	;;
+	esac
+	_scratch_mount >> $seqres.full 2>&1
+
+	# Write file
+	$XFS_IO_PROG -f -c "pwrite 0 $length" -c fsync $testfile > /dev/null
+
+	# Collapse alternate blocks 
+	for (( i = 1; i <= 7; i++ )); do
+		for (( j=0; j < $(($BLOCKS/(2**$i))); j++ )); do
+			offset=$(($j*$BSIZE))
+			$XFS_IO_PROG -c "fcollapse $offset $BSIZE" $testfile > /dev/null
+		done
+	done
+
+	# Check if 80 extents are present
+	$XFS_IO_PROG -c "fiemap -v" $testfile | grep "^ *[0-9]*:" |wc -l
+
+	_check_scratch_fs
+	if [ $? -ne 0 ]; then
+		status=1
+		exit
+	fi
+
+	umount $SCRATCH_MNT
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/017.out b/tests/generic/017.out
new file mode 100644
index 0000000..cc524ac
--- /dev/null
+++ b/tests/generic/017.out
@@ -0,0 +1,4 @@
+QA output created by 017
+80
+80
+80
diff --git a/tests/generic/018 b/tests/generic/018
new file mode 100755
index 0000000..2544391
--- /dev/null
+++ b/tests/generic/018
@@ -0,0 +1,93 @@
+#! /bin/bash
+# FS QA Test No. generic/018
+#
+# Basic defragmentation sanity tests
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2009 Eric Sandeen.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/defrag
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+# We require scratch so that we'll have free contiguous space
+_require_scratch
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+_require_defrag
+
+fragfile=$SCRATCH_MNT/fragfile.$$
+
+rm -f $fragfile
+
+# Craft some fragmented files, defrag them, check the result.
+
+echo "zero-length file:" | tee -a $seqres.full
+touch $fragfile
+_defrag $fragfile
+
+echo "Sparse file (no blocks):" | tee -a $seqres.full
+$XFS_IO_PROG -f -c "truncate 1m" $fragfile
+_defrag $fragfile
+
+echo "Contiguous file:" | tee -a $seqres.full
+dd if=/dev/zero of=$fragfile bs=4k count=4 &>/dev/null
+_defrag $fragfile
+
+echo "Write backwards sync, but contiguous - should defrag to 1 extent" | tee -a $seqres.full
+for I in `seq 9 -1 0`; do
+	dd if=/dev/zero of=$fragfile bs=4k count=1 conv=notrunc seek=$I oflag=sync &>/dev/null
+done
+_defrag $fragfile
+
+echo "Write backwards sync leaving holes - defrag should do nothing" | tee -a $seqres.full
+for I in `seq 31 -2 0`; do
+	dd if=/dev/zero of=$fragfile bs=4k count=1 conv=notrunc seek=$I oflag=sync &>/dev/null
+done
+_defrag $fragfile
+
+echo "Write forwards sync leaving holes - defrag should do nothing" | tee -a $seqres.full
+for I in `seq 0 2 31`; do
+	dd if=/dev/zero of=$fragfile bs=4k count=1 conv=notrunc seek=$I oflag=sync &>/dev/null
+done
+_defrag $fragfile
+
+rm -f $seqres.full
+status=0
+exit
diff --git a/tests/generic/018.out b/tests/generic/018.out
new file mode 100644
index 0000000..5f265d1
--- /dev/null
+++ b/tests/generic/018.out
@@ -0,0 +1,19 @@
+QA output created by 018
+zero-length file:
+Before: 0
+After: 0
+Sparse file (no blocks):
+Before: 0
+After: 0
+Contiguous file:
+Before: 1
+After: 1
+Write backwards sync, but contiguous - should defrag to 1 extent
+Before: 10
+After: 1
+Write backwards sync leaving holes - defrag should do nothing
+Before: 16
+After: 16
+Write forwards sync leaving holes - defrag should do nothing
+Before: 16
+After: 16
diff --git a/tests/generic/019 b/tests/generic/019
new file mode 100755
index 0000000..1208c49
--- /dev/null
+++ b/tests/generic/019
@@ -0,0 +1,187 @@
+#! /bin/bash
+# FSQA Test No. generic/019
+#
+# Run fsstress and fio(dio/aio and mmap) and simulate disk failure
+# check filesystem consistency at the end.
+#
+#-----------------------------------------------------------------------
+# (c) 2013 Dmitry Monakhov
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+fio_config=$tmp.fio
+status=1	# failure is the default!
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+_supported_fs generic
+_supported_os Linux
+_need_to_be_root
+_require_scratch
+_require_fail_make_request
+
+# TODO: Function are common enough to be moved to common/blkdev
+SCRATCH_REAL_DEV=`readlink -f $SCRATCH_DEV`
+SCRATCH_BDEV=`basename $SCRATCH_REAL_DEV`
+
+allow_fail_make_request()
+{
+    echo "Allow global fail_make_request feature"
+    echo 100 > $DEBUGFS_MNT/fail_make_request/probability
+    echo 9999999 > $DEBUGFS_MNT/fail_make_request/times
+    echo 0 >  /sys/kernel/debug/fail_make_request/verbose
+}
+
+disallow_fail_make_request()
+{
+    echo "Disallow global fail_make_request feature"
+    echo 0 > $DEBUGFS_MNT/fail_make_request/probability
+    echo 0 > $DEBUGFS_MNT/fail_make_request/times
+}
+
+start_fail_scratch_dev()
+{
+    echo "Force SCRATCH_DEV device failure"
+    echo " echo 1 > /sys/block/$SCRATCH_BDEV/make-it-fail" >> $seqres.full
+    echo 1 > /sys/block/$SCRATCH_BDEV/make-it-fail
+
+}
+
+stop_fail_scratch_dev()
+{
+    echo "Make SCRATCH_DEV device operable again"
+    echo " echo 0 > /sys/block/$SCRATCH_BDEV/make-it-fail" >> $seqres.full
+    echo 0 > /sys/block/$SCRATCH_BDEV/make-it-fail
+
+}
+
+_cleanup()
+{
+    poweron_scratch_dev
+    disallow_fail_make_request
+    rm -f $tmp.*
+}
+trap "_cleanup; exit \$status" 1 2 3 15
+
+RUN_TIME=$((20+10*$TIME_FACTOR))
+NUM_JOBS=$((4*LOAD_FACTOR))
+BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
+FILE_SIZE=$((BLK_DEV_SIZE * 512))
+
+cat >$fio_config <<EOF
+###########
+# $seq test's fio activity
+# Filenames derived from jobsname and jobid like follows:
+# ${JOB_NAME}.${JOB_ID}.${ITERATION_ID}
+[global]
+ioengine=libaio
+bs=4k
+directory=${SCRATCH_MNT}
+filesize=${FILE_SIZE}
+size=9999T
+continue_on_error=write
+ignore_error=EIO,ENOSPC:EIO
+error_dump=0
+
+[stress_dio_aio_activity]
+create_on_open=1
+fallocate=none
+iodepth=128*${LOAD_FACTOR}
+direct=1
+buffered=0
+numjobs=${NUM_JOBS}
+rw=randwrite
+runtime=40+${RUN_TIME}
+time_based
+
+[stress_mmap_activity]
+ioengine=mmap
+create_on_open=0
+fallocate=1
+fdatasync=40960
+filesize=8M
+size=9999T
+numjobs=${NUM_JOBS}
+rw=randwrite
+runtime=40+${RUN_TIME}
+time_based
+
+EOF
+
+_require_fio $fio_config
+
+# Disable all sync operations to get higher load
+FSSTRESS_AVOID="$FSSTRESS_AVOID -ffsync=0 -fsync=0 -ffdatasync=0 -f setattr=1"
+
+_workout()
+{
+	out=$SCRATCH_MNT/fsstress.$$
+	args=`_scale_fsstress_args -p 1 -n999999999 -f setattr=0 $FSSTRESS_AVOID -d $out`
+	echo ""
+	echo "Start fsstress.."
+	echo ""
+	echo "fsstress $args" >> $seqres.full
+	$FSSTRESS_PROG $args > /dev/null 2>&1 &
+	fs_pid=$!
+	echo "Start fio.."
+	cat $fio_config >>  $seqres.full
+	$FIO_PROG $fio_config >> $seqres.full 2>&1 &
+	fio_pid=$!
+
+	# Let's it work for awhile, and force device failure
+	sleep $RUN_TIME
+	start_fail_scratch_dev
+	# After device turns in to failed state filesystem may yet not know about
+	# that so buffered write(2) may succeed, but any integrity operations
+	# such as (sync, fsync, fdatasync, direct-io) should fail.
+	dd if=/dev/zero of=$SCRATCH_MNT/touch_failed_filesystem count=1 bs=4k conv=fsync \
+	    >> $seqres.full 2>&1 && \
+	    _fail "failed: still able to perform integrity fsync on $SCRATCH_MNT"
+
+	kill $fs_pid
+	wait $fs_pid
+	wait $fio_pid
+
+	# We expect that broken FS still can be umounted
+	run_check umount $SCRATCH_DEV
+	# Once filesystem was umounted no one is able to write to block device
+	# It is now safe to bring device back to normal state
+	stop_fail_scratch_dev
+
+	# In order to check that filesystem is able to recover journal on mount(2)
+	# perform mount/umount, after that all errors should be fixed
+	run_check _scratch_mount
+	run_check _scratch_unmount
+	_check_scratch_fs
+}
+
+# real QA test starts here
+
+_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount || _fail "mount failed"
+allow_fail_make_request
+_workout
+status=$?
+disallow_fail_make_request
+exit
diff --git a/tests/generic/019.out b/tests/generic/019.out
new file mode 100644
index 0000000..36c2af8
--- /dev/null
+++ b/tests/generic/019.out
@@ -0,0 +1,9 @@
+QA output created by 019
+Allow global fail_make_request feature
+
+Start fsstress..
+
+Start fio..
+Force SCRATCH_DEV device failure
+Make SCRATCH_DEV device operable again
+Disallow global fail_make_request feature
diff --git a/tests/generic/group b/tests/generic/group
index a99b6a1..5065780 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -6,15 +6,22 @@
 001 rw dir udf auto quick
 002 metadata udf auto quick
 003 atime auto quick
+004 auto quick prealloc
 005 dir udf auto quick
 006 dir udf auto quick
 007 dir udf auto quick
 008 auto quick prealloc
+009 auto quick prealloc
 010 other udf auto
 011 dir udf auto quick
+012 auto quick prealloc
 013 other ioctl udf auto quick
 014 rw udf auto quick
 015 other auto quick
+016 auto quick prealloc
+017 auto prealloc
+018 auto fsr quick
+019 aio dangerous enospc rw stress
 020 metadata attr udf auto quick
 053 acl repair auto quick
 062 attr udf auto quick
diff --git a/tests/shared/001 b/tests/shared/001
deleted file mode 100755
index 9383ccb..0000000
--- a/tests/shared/001
+++ /dev/null
@@ -1,65 +0,0 @@
-#! /bin/bash
-# FS QA Test No. shared/001
-#
-# Standard collapse range tests 
-# This testcase is one of the 4 testcases (shared 001 - 004) which tries to
-# test various corner cases for fcollapse range functionality over different
-# type of extents. These tests are based on generic/255 test case.
-# For the type of tests, check the description of _test_generic_punch
-# in common/rc.
-#-----------------------------------------------------------------------
-# Copyright (c) 2013 Samsung Electronics.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-#-----------------------------------------------------------------------
-#
-
-seq=`basename $0`
-seqres=$RESULT_DIR/$seq
-echo "QA output created by $seq"
-
-here=`pwd`
-tmp=/tmp/$$
-status=1	# failure is the default!
-
-_cleanup()
-{
-    rm -f $tmp.*
-}
-
-trap "_cleanup ; exit \$status" 0 1 2 3 15
-
-# get standard environment, filters and checks
-# we need to include common/punch to get defination fo filter functions
-. ./common/rc
-. ./common/filter
-. ./common/punch
-
-# real QA test starts here
-_supported_fs xfs ext4
-_supported_os Linux
-
-_require_xfs_io_falloc_punch
-_require_xfs_io_falloc
-_require_xfs_io_fiemap
-_require_xfs_io_falloc_collapse
-
-testfile=$TEST_DIR/$seq.$$
-
-_test_generic_punch falloc fpunch fcollapse fiemap _filter_hole_fiemap $testfile
-_check_test_fs
-
-status=0
-exit
diff --git a/tests/shared/001.out b/tests/shared/001.out
deleted file mode 100644
index 919dd12..0000000
--- a/tests/shared/001.out
+++ /dev/null
@@ -1,49 +0,0 @@
-QA output created by 001
-	1. into a hole
-f4f35d60b3cc18aaa6d8d92f0cd3708a
-	2. into allocated space
-0: [0..95]: extent
-f1894a71ac539f6f90426d98a4990a47
-	3. into unwritten space
-0: [0..95]: extent
-f4f35d60b3cc18aaa6d8d92f0cd3708a
-	4. hole -> data
-0: [0..31]: hole
-1: [32..63]: extent
-2: [64..95]: hole
-d8f51c20223dbce5c7c90db87bc221b0
-	5. hole -> unwritten
-0: [0..31]: hole
-1: [32..63]: extent
-2: [64..95]: hole
-f4f35d60b3cc18aaa6d8d92f0cd3708a
-	6. data -> hole
-0: [0..31]: extent
-1: [32..95]: hole
-f07217d5ac7ffa15dd8910c4aa912674
-	7. data -> unwritten
-0: [0..63]: extent
-1: [64..95]: hole
-f07217d5ac7ffa15dd8910c4aa912674
-	8. unwritten -> hole
-0: [0..31]: extent
-1: [32..95]: hole
-f4f35d60b3cc18aaa6d8d92f0cd3708a
-	9. unwritten -> data
-0: [0..63]: extent
-1: [64..95]: hole
-d8f51c20223dbce5c7c90db87bc221b0
-	10. hole -> data -> hole
-bb7df04e1b0a2570657527a7e108ae23
-	11. data -> hole -> data
-0: [0..63]: extent
-0f0151cbed83e4bf6e5bde26e82ab115
-	12. unwritten -> data -> unwritten
-0: [0..63]: extent
-bb7df04e1b0a2570657527a7e108ae23
-	13. data -> unwritten -> data
-0: [0..63]: extent
-0f0151cbed83e4bf6e5bde26e82ab115
-	14. data -> hole @ 0
-0: [0..95]: extent
-f1894a71ac539f6f90426d98a4990a47
diff --git a/tests/shared/002 b/tests/shared/002
deleted file mode 100644
index a9e54ba..0000000
--- a/tests/shared/002
+++ /dev/null
@@ -1,65 +0,0 @@
-#! /bin/bash
-# FS QA Test No. shared/002
-#
-# Delayed allocation collapse range tests
-# This testcase is one of the 4 testcases (shared 001 - 004) which tries to
-# test various corner cases for fcollapse range functionality over different
-# type of extents. These tests are based on generic/255 test case.
-# For the type of tests, check the description of _test_generic_punch
-# in common/rc.
-#-----------------------------------------------------------------------
-# Copyright (c) 2013 Samsung Electronics.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-#-----------------------------------------------------------------------
-#
-
-seq=`basename $0`
-seqres=$RESULT_DIR/$seq
-echo "QA output created by $seq"
-
-here=`pwd`
-tmp=/tmp/$$
-status=1	# failure is the default!
-
-_cleanup()
-{
-    rm -f $tmp.*
-}
-
-trap "_cleanup ; exit \$status" 0 1 2 3 15
-
-# get standard environment, filters and checks
-# we need to include common/punch to get defination fo filter functions
-. ./common/rc
-. ./common/filter
-. ./common/punch
-
-# real QA test starts here
-_supported_fs xfs ext4
-_supported_os Linux
-
-_require_xfs_io_falloc_punch
-_require_xfs_io_falloc
-_require_xfs_io_fiemap
-_require_xfs_io_falloc_collapse
-
-testfile=$TEST_DIR/$seq.$$
-
-_test_generic_punch -d falloc fpunch fcollapse fiemap _filter_hole_fiemap $testfile
-_check_test_fs
-
-status=0
-exit
diff --git a/tests/shared/002.out b/tests/shared/002.out
deleted file mode 100644
index 60aaadc..0000000
--- a/tests/shared/002.out
+++ /dev/null
@@ -1,49 +0,0 @@
-QA output created by 002
-	1. into a hole
-f4f35d60b3cc18aaa6d8d92f0cd3708a
-	2. into allocated space
-0: [0..95]: extent
-f1894a71ac539f6f90426d98a4990a47
-	3. into unwritten space
-0: [0..95]: extent
-f4f35d60b3cc18aaa6d8d92f0cd3708a
-	4. hole -> data
-0: [0..31]: hole
-1: [32..63]: extent
-2: [64..95]: hole
-d8f51c20223dbce5c7c90db87bc221b0
-	5. hole -> unwritten
-0: [0..31]: hole
-1: [32..63]: extent
-2: [64..95]: hole
-f4f35d60b3cc18aaa6d8d92f0cd3708a
-	6. data -> hole
-0: [0..31]: extent
-1: [32..95]: hole
-f07217d5ac7ffa15dd8910c4aa912674
-	7. data -> unwritten
-0: [0..63]: extent
-1: [64..95]: hole
-f07217d5ac7ffa15dd8910c4aa912674
-	8. unwritten -> hole
-0: [0..31]: extent
-1: [32..95]: hole
-f4f35d60b3cc18aaa6d8d92f0cd3708a
-	9. unwritten -> data
-0: [0..63]: extent
-1: [64..95]: hole
-d8f51c20223dbce5c7c90db87bc221b0
-	10. hole -> data -> hole
-bb7df04e1b0a2570657527a7e108ae23
-	11. data -> hole -> data
-0: [0..63]: extent
-0f0151cbed83e4bf6e5bde26e82ab115
-	12. unwritten -> data -> unwritten
-0: [0..63]: extent
-bb7df04e1b0a2570657527a7e108ae23
-	13. data -> unwritten -> data
-0: [0..63]: extent
-0f0151cbed83e4bf6e5bde26e82ab115
-	14. data -> hole @ 0
-0: [0..95]: extent
-f1894a71ac539f6f90426d98a4990a47
diff --git a/tests/shared/003 b/tests/shared/003
deleted file mode 100644
index b6e9fd4..0000000
--- a/tests/shared/003
+++ /dev/null
@@ -1,65 +0,0 @@
-#! /bin/bash
-# FS QA Test No. shared/003
-#
-# Multi collapse range tests
-# This testcase is one of the 4 testcases (shared 001 - 004) which tries to
-# test various corner cases for fcollapse range functionality over different
-# type of extents. These tests are based on generic/255 test case.
-# For the type of tests, check the description of _test_generic_punch
-# in common/rc.
-#-----------------------------------------------------------------------
-# Copyright (c) 2013 Samsung Electronics.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-#-----------------------------------------------------------------------
-#
-
-seq=`basename $0`
-seqres=$RESULT_DIR/$seq
-echo "QA output created by $seq"
-
-here=`pwd`
-tmp=/tmp/$$
-status=1	# failure is the default!
-
-_cleanup()
-{
-    rm -f $tmp.*
-}
-
-trap "_cleanup ; exit \$status" 0 1 2 3 15
-
-# get standard environment, filters and checks
-# we need to include common/punch to get defination fo filter functions
-. ./common/rc
-. ./common/filter
-. ./common/punch
-
-# real QA test starts here
-_supported_fs xfs ext4
-_supported_os Linux
-
-_require_xfs_io_falloc_punch
-_require_xfs_io_falloc
-_require_xfs_io_fiemap
-_require_xfs_io_falloc_collapse
-
-testfile=$TEST_DIR/$seq.$$
-
-_test_generic_punch -k falloc fpunch fcollapse fiemap _filter_hole_fiemap $testfile
-_check_test_fs
-
-status=0
-exit
diff --git a/tests/shared/003.out b/tests/shared/003.out
deleted file mode 100644
index 0a786c9..0000000
--- a/tests/shared/003.out
+++ /dev/null
@@ -1,49 +0,0 @@
-QA output created by 003
-	1. into a hole
-f4f35d60b3cc18aaa6d8d92f0cd3708a
-	2. into allocated space
-0: [0..95]: extent
-f1894a71ac539f6f90426d98a4990a47
-	3. into unwritten space
-0: [0..95]: extent
-f07217d5ac7ffa15dd8910c4aa912674
-	4. hole -> data
-0: [0..63]: extent
-1: [64..95]: hole
-e5c94f6299822646f9f57aeacd8bdc01
-	5. hole -> unwritten
-0: [0..63]: extent
-1: [64..95]: hole
-f07217d5ac7ffa15dd8910c4aa912674
-	6. data -> hole
-0: [0..31]: extent
-1: [32..95]: hole
-f07217d5ac7ffa15dd8910c4aa912674
-	7. data -> unwritten
-0: [0..63]: extent
-1: [64..95]: hole
-f07217d5ac7ffa15dd8910c4aa912674
-	8. unwritten -> hole
-0: [0..31]: extent
-1: [32..95]: hole
-f07217d5ac7ffa15dd8910c4aa912674
-	9. unwritten -> data
-0: [0..63]: extent
-1: [64..95]: hole
-e5c94f6299822646f9f57aeacd8bdc01
-	10. hole -> data -> hole
-0: [0..31]: extent
-1: [32..63]: hole
-76cc863b386460b228a493933813a6a0
-	11. data -> hole -> data
-0: [0..63]: extent
-0f0151cbed83e4bf6e5bde26e82ab115
-	12. unwritten -> data -> unwritten
-0: [0..63]: extent
-76cc863b386460b228a493933813a6a0
-	13. data -> unwritten -> data
-0: [0..63]: extent
-0f0151cbed83e4bf6e5bde26e82ab115
-	14. data -> hole @ 0
-0: [0..95]: extent
-f1894a71ac539f6f90426d98a4990a47
diff --git a/tests/shared/004 b/tests/shared/004
deleted file mode 100644
index f55aae4..0000000
--- a/tests/shared/004
+++ /dev/null
@@ -1,65 +0,0 @@
-#! /bin/bash
-# FS QA Test No. shared/004
-#
-# Delayed allocation multi collapse range tests
-# This testcase is one of the 4 testcases (shared 001 - 004) which tries to
-# test various corner cases for fcollapse range functionality over different
-# type of extents. These tests are based on generic/255 test case.
-# For the type of tests, check the description of _test_generic_punch
-# in common/rc.
-#-----------------------------------------------------------------------
-# Copyright (c) 2013 Samsung Electronics.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-#-----------------------------------------------------------------------
-#
-
-seq=`basename $0`
-seqres=$RESULT_DIR/$seq
-echo "QA output created by $seq"
-
-here=`pwd`
-tmp=/tmp/$$
-status=1	# failure is the default!
-
-_cleanup()
-{
-    rm -f $tmp.*
-}
-
-trap "_cleanup ; exit \$status" 0 1 2 3 15
-
-# get standard environment, filters and checks
-# we need to include common/punch to get defination fo filter functions
-. ./common/rc
-. ./common/filter
-. ./common/punch
-
-# real QA test starts here
-_supported_fs xfs ext4
-_supported_os Linux
-
-_require_xfs_io_falloc_punch
-_require_xfs_io_falloc
-_require_xfs_io_fiemap
-_require_xfs_io_falloc_collapse
-
-testfile=$TEST_DIR/$seq.$$
-
-_test_generic_punch -d -k falloc fpunch fcollapse fiemap _filter_hole_fiemap $testfile
-_check_test_fs
-
-status=0
-exit
diff --git a/tests/shared/004.out b/tests/shared/004.out
deleted file mode 100644
index 9ccffd7..0000000
--- a/tests/shared/004.out
+++ /dev/null
@@ -1,49 +0,0 @@
-QA output created by 004
-	1. into a hole
-f4f35d60b3cc18aaa6d8d92f0cd3708a
-	2. into allocated space
-0: [0..95]: extent
-f1894a71ac539f6f90426d98a4990a47
-	3. into unwritten space
-0: [0..95]: extent
-f07217d5ac7ffa15dd8910c4aa912674
-	4. hole -> data
-0: [0..63]: extent
-1: [64..95]: hole
-e5c94f6299822646f9f57aeacd8bdc01
-	5. hole -> unwritten
-0: [0..63]: extent
-1: [64..95]: hole
-f07217d5ac7ffa15dd8910c4aa912674
-	6. data -> hole
-0: [0..31]: extent
-1: [32..95]: hole
-f07217d5ac7ffa15dd8910c4aa912674
-	7. data -> unwritten
-0: [0..63]: extent
-1: [64..95]: hole
-f07217d5ac7ffa15dd8910c4aa912674
-	8. unwritten -> hole
-0: [0..31]: extent
-1: [32..95]: hole
-f07217d5ac7ffa15dd8910c4aa912674
-	9. unwritten -> data
-0: [0..63]: extent
-1: [64..95]: hole
-e5c94f6299822646f9f57aeacd8bdc01
-	10. hole -> data -> hole
-0: [0..31]: extent
-1: [32..63]: hole
-76cc863b386460b228a493933813a6a0
-	11. data -> hole -> data
-0: [0..63]: extent
-0f0151cbed83e4bf6e5bde26e82ab115
-	12. unwritten -> data -> unwritten
-0: [0..63]: extent
-76cc863b386460b228a493933813a6a0
-	13. data -> unwritten -> data
-0: [0..63]: extent
-0f0151cbed83e4bf6e5bde26e82ab115
-	14. data -> hole @ 0
-0: [0..95]: extent
-f1894a71ac539f6f90426d98a4990a47
diff --git a/tests/shared/005 b/tests/shared/005
deleted file mode 100644
index c6d4bb6..0000000
--- a/tests/shared/005
+++ /dev/null
@@ -1,90 +0,0 @@
-#! /bin/bash
-# FS QA Test No. shared/005
-#
-# Test multiple fallocate collapse range calls on same file.
-# For different blocksizes, collapse a single alternate block multiple times
-# until the file is left with 80 blocks and as much number of extents.
-# Also check for file system consistency after completing this operation
-# for each blocksize.
-#-----------------------------------------------------------------------
-# Copyright (c) 2013 Samsung Electronics.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-#-----------------------------------------------------------------------
-#
-
-seq=`basename $0`
-seqres=$RESULT_DIR/$seq
-echo "QA output created by $seq"
-
-here=`pwd`
-tmp=/tmp/$$
-status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
-
-# get standard environment, filters and checks
-. ./common/rc
-. ./common/filter
-
-# real QA test starts here
-_supported_fs xfs ext4
-_supported_os Linux
-
-_require_scratch
-_require_xfs_io_fiemap
-_require_xfs_io_falloc_collapse
-_do_die_on_error=y
-testfile=$SCRATCH_MNT/$seq.$$
-BLOCKS=10240
-
-for (( BSIZE = 1024; BSIZE <= 4096; BSIZE *= 2 )); do
-
-	length=$(($BLOCKS * $BSIZE))
-	case $FSTYP in
-	xfs)
-	_scratch_mkfs -b size=$BSIZE >> $seqres.full 2>&1
-	;;
-	ext4)
-	_scratch_mkfs -b $BSIZE >> $seqres.full 2>&1
-	;;
-	esac
-	_scratch_mount >> $seqres.full 2>&1
-
-	# Write file
-	$XFS_IO_PROG -f -c "pwrite 0 $length" -c fsync $testfile > /dev/null
-
-	# Collapse alternate blocks 
-	for (( i = 1; i <= 7; i++ )); do
-		for (( j=0; j < $(($BLOCKS/(2**$i))); j++ )); do
-			offset=$(($j*$BSIZE))
-			$XFS_IO_PROG -c "fcollapse $offset $BSIZE" $testfile > /dev/null
-		done
-	done
-
-	# Check if 80 extents are present
-	$XFS_IO_PROG -c "fiemap -v" $testfile | grep "^ *[0-9]*:" |wc -l
-
-	_check_scratch_fs
-	if [ $? -ne 0 ]; then
-		status=1
-		exit
-	fi
-
-	umount $SCRATCH_MNT
-done
-
-# success, all done
-status=0
-exit
diff --git a/tests/shared/005.out b/tests/shared/005.out
deleted file mode 100644
index 8d30b9d..0000000
--- a/tests/shared/005.out
+++ /dev/null
@@ -1,4 +0,0 @@
-QA output created by 005
-80
-80
-80
diff --git a/tests/shared/218 b/tests/shared/218
deleted file mode 100755
index cd2076e..0000000
--- a/tests/shared/218
+++ /dev/null
@@ -1,93 +0,0 @@
-#! /bin/bash
-# FS QA Test No. 218
-#
-# Basic defragmentation sanity tests
-#
-#-----------------------------------------------------------------------
-# Copyright (c) 2009 Eric Sandeen.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#-----------------------------------------------------------------------
-#
-
-seq=`basename $0`
-seqres=$RESULT_DIR/$seq
-echo "QA output created by $seq"
-
-here=`pwd`
-tmp=tmp/$$
-status=1	# failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    cd /
-    rm -f $tmp.*
-}
-
-# get standard environment, filters and checks
-. ./common/rc
-. ./common/filter
-. ./common/defrag
-
-# real QA test starts here
-_supported_fs xfs ext4 btrfs
-_supported_os Linux
-
-# We require scratch so that we'll have free contiguous space
-_require_scratch
-_scratch_mkfs >/dev/null 2>&1
-_scratch_mount
-
-_require_defrag
-
-fragfile=$SCRATCH_MNT/fragfile.$$
-
-rm -f $fragfile
-
-# Craft some fragmented files, defrag them, check the result.
-
-echo "zero-length file:" | tee -a $seqres.full
-touch $fragfile
-_defrag $fragfile
-
-echo "Sparse file (no blocks):" | tee -a $seqres.full
-$XFS_IO_PROG -f -c "truncate 1m" $fragfile
-_defrag $fragfile
-
-echo "Contiguous file:" | tee -a $seqres.full
-dd if=/dev/zero of=$fragfile bs=4k count=4 &>/dev/null
-_defrag $fragfile
-
-echo "Write backwards sync, but contiguous - should defrag to 1 extent" | tee -a $seqres.full
-for I in `seq 9 -1 0`; do
-	dd if=/dev/zero of=$fragfile bs=4k count=1 conv=notrunc seek=$I oflag=sync &>/dev/null
-done
-_defrag $fragfile
-
-echo "Write backwards sync leaving holes - defrag should do nothing" | tee -a $seqres.full
-for I in `seq 31 -2 0`; do
-	dd if=/dev/zero of=$fragfile bs=4k count=1 conv=notrunc seek=$I oflag=sync &>/dev/null
-done
-_defrag $fragfile
-
-echo "Write forwards sync leaving holes - defrag should do nothing" | tee -a $seqres.full
-for I in `seq 0 2 31`; do
-	dd if=/dev/zero of=$fragfile bs=4k count=1 conv=notrunc seek=$I oflag=sync &>/dev/null
-done
-_defrag $fragfile
-
-rm -f $seqres.full
-status=0
-exit
diff --git a/tests/shared/218.out b/tests/shared/218.out
deleted file mode 100644
index 7559cdd..0000000
--- a/tests/shared/218.out
+++ /dev/null
@@ -1,19 +0,0 @@
-QA output created by 218
-zero-length file:
-Before: 0
-After: 0
-Sparse file (no blocks):
-Before: 0
-After: 0
-Contiguous file:
-Before: 1
-After: 1
-Write backwards sync, but contiguous - should defrag to 1 extent
-Before: 10
-After: 1
-Write backwards sync leaving holes - defrag should do nothing
-Before: 16
-After: 16
-Write forwards sync leaving holes - defrag should do nothing
-Before: 16
-After: 16
diff --git a/tests/shared/305 b/tests/shared/305
deleted file mode 100755
index 8e8b0cb..0000000
--- a/tests/shared/305
+++ /dev/null
@@ -1,187 +0,0 @@
-#! /bin/bash
-# FSQA Test No. 305
-#
-# Run fsstress and fio(dio/aio and mmap) and simulate disk failure
-# check filesystem consistency at the end.
-#
-#-----------------------------------------------------------------------
-# (c) 2013 Dmitry Monakhov
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-#-----------------------------------------------------------------------
-#
-
-seq=`basename $0`
-seqres=$RESULT_DIR/$seq
-echo "QA output created by $seq"
-
-here=`pwd`
-tmp=/tmp/$$
-fio_config=$tmp.fio
-status=1	# failure is the default!
-
-# get standard environment, filters and checks
-. ./common/rc
-. ./common/filter
-_supported_fs ext3 ext4 xfs btrfs reiserfs
-_supported_os Linux
-_need_to_be_root
-_require_scratch
-_require_fail_make_request
-
-# TODO: Function are common enough to be moved to common/blkdev
-SCRATCH_REAL_DEV=`readlink -f $SCRATCH_DEV`
-SCRATCH_BDEV=`basename $SCRATCH_REAL_DEV`
-
-allow_fail_make_request()
-{
-    echo "Allow global fail_make_request feature"
-    echo 100 > $DEBUGFS_MNT/fail_make_request/probability
-    echo 9999999 > $DEBUGFS_MNT/fail_make_request/times
-    echo 0 >  /sys/kernel/debug/fail_make_request/verbose
-}
-
-disallow_fail_make_request()
-{
-    echo "Disallow global fail_make_request feature"
-    echo 0 > $DEBUGFS_MNT/fail_make_request/probability
-    echo 0 > $DEBUGFS_MNT/fail_make_request/times
-}
-
-start_fail_scratch_dev()
-{
-    echo "Force SCRATCH_DEV device failure"
-    echo " echo 1 > /sys/block/$SCRATCH_BDEV/make-it-fail" >> $seqres.full
-    echo 1 > /sys/block/$SCRATCH_BDEV/make-it-fail
-
-}
-
-stop_fail_scratch_dev()
-{
-    echo "Make SCRATCH_DEV device operable again"
-    echo " echo 0 > /sys/block/$SCRATCH_BDEV/make-it-fail" >> $seqres.full
-    echo 0 > /sys/block/$SCRATCH_BDEV/make-it-fail
-
-}
-
-_cleanup()
-{
-    poweron_scratch_dev
-    disallow_fail_make_request
-    rm -f $tmp.*
-}
-trap "_cleanup; exit \$status" 1 2 3 15
-
-RUN_TIME=$((20+10*$TIME_FACTOR))
-NUM_JOBS=$((4*LOAD_FACTOR))
-BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
-FILE_SIZE=$((BLK_DEV_SIZE * 512))
-
-cat >$fio_config <<EOF
-###########
-# $seq test's fio activity
-# Filenames derived from jobsname and jobid like follows:
-# ${JOB_NAME}.${JOB_ID}.${ITERATION_ID}
-[global]
-ioengine=libaio
-bs=4k
-directory=${SCRATCH_MNT}
-filesize=${FILE_SIZE}
-size=9999T
-continue_on_error=write
-ignore_error=EIO,ENOSPC:EIO
-error_dump=0
-
-[stress_dio_aio_activity]
-create_on_open=1
-fallocate=none
-iodepth=128*${LOAD_FACTOR}
-direct=1
-buffered=0
-numjobs=${NUM_JOBS}
-rw=randwrite
-runtime=40+${RUN_TIME}
-time_based
-
-[stress_mmap_activity]
-ioengine=mmap
-create_on_open=0
-fallocate=1
-fdatasync=40960
-filesize=8M
-size=9999T
-numjobs=${NUM_JOBS}
-rw=randwrite
-runtime=40+${RUN_TIME}
-time_based
-
-EOF
-
-_require_fio $fio_config
-
-# Disable all sync operations to get higher load
-FSSTRESS_AVOID="$FSSTRESS_AVOID -ffsync=0 -fsync=0 -ffdatasync=0 -f setattr=1"
-
-_workout()
-{
-	out=$SCRATCH_MNT/fsstress.$$
-	args=`_scale_fsstress_args -p 1 -n999999999 -f setattr=0 $FSSTRESS_AVOID -d $out`
-	echo ""
-	echo "Start fsstress.."
-	echo ""
-	echo "fsstress $args" >> $seqres.full
-	$FSSTRESS_PROG $args > /dev/null 2>&1 &
-	fs_pid=$!
-	echo "Start fio.."
-	cat $fio_config >>  $seqres.full
-	$FIO_PROG $fio_config >> $seqres.full 2>&1 &
-	fio_pid=$!
-
-	# Let's it work for awhile, and force device failure
-	sleep $RUN_TIME
-	start_fail_scratch_dev
-	# After device turns in to failed state filesystem may yet not know about
-	# that so buffered write(2) may succeed, but any integrity operations
-	# such as (sync, fsync, fdatasync, direct-io) should fail.
-	dd if=/dev/zero of=$SCRATCH_MNT/touch_failed_filesystem count=1 bs=4k conv=fsync \
-	    >> $seqres.full 2>&1 && \
-	    _fail "failed: still able to perform integrity fsync on $SCRATCH_MNT"
-
-	kill $fs_pid
-	wait $fs_pid
-	wait $fio_pid
-
-	# We expect that broken FS still can be umounted
-	run_check umount $SCRATCH_DEV
-	# Once filesystem was umounted no one is able to write to block device
-	# It is now safe to bring device back to normal state
-	stop_fail_scratch_dev
-
-	# In order to check that filesystem is able to recover journal on mount(2)
-	# perform mount/umount, after that all errors should be fixed
-	run_check _scratch_mount
-	run_check _scratch_unmount
-	_check_scratch_fs
-}
-
-# real QA test starts here
-
-_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
-_scratch_mount || _fail "mount failed"
-allow_fail_make_request
-_workout
-status=$?
-disallow_fail_make_request
-exit
diff --git a/tests/shared/305.out b/tests/shared/305.out
deleted file mode 100644
index 1e8cfd6..0000000
--- a/tests/shared/305.out
+++ /dev/null
@@ -1,9 +0,0 @@
-QA output created by 305
-Allow global fail_make_request feature
-
-Start fsstress..
-
-Start fio..
-Force SCRATCH_DEV device failure
-Make SCRATCH_DEV device operable again
-Disallow global fail_make_request feature
diff --git a/tests/shared/group b/tests/shared/group
index 29f17b0..1c6fffb 100644
--- a/tests/shared/group
+++ b/tests/shared/group
@@ -3,17 +3,9 @@
 # - do not start group names with a digit
 # - comment line before each group is "new" description
 #
-001 auto quick prealloc
-002 auto quick prealloc
-003 auto quick prealloc
-004 auto quick prealloc
-005 auto prealloc
 032 mkfs auto quick
 051 acl udf auto quick
-218 auto fsr quick
 243 auto quick prealloc
 272 auto enospc rw
 289 auto quick
 298 auto trim
-305 aio dangerous enospc rw stress
-
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
