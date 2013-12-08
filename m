Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EC0707FEF
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 08:12:56 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BF0C0304032
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 06:12:56 -0800 (PST)
Received: from mail-pd0-f175.google.com (mail-pd0-f175.google.com
	[209.85.192.175]) by cuda.sgi.com with ESMTP id
	hnpoVzL9nYOFS3NS (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 08 Dec 2013 06:12:55 -0800 (PST)
Received: by mail-pd0-f175.google.com with SMTP id w10so3642696pde.34
	for <xfs@oss.sgi.com>; Sun, 08 Dec 2013 06:12:55 -0800 (PST)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v4 8/10] xfstest: shared/004: Delayed allocation multi collapse
Date: Sun,  8 Dec 2013 23:12:47 +0900
Message-Id: <1386511967-3940-1-git-send-email-linkinjeon@gmail.com>
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
To: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz
Cc: Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This testcase(004) tries to test various corner cases with delayed extents and
pre-existing holes for fcollapse range functionality
over different type of extents.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 tests/shared/004     |   65 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/shared/004.out |   53 ++++++++++++++++++++++++++++++++++++++++
 tests/shared/group   |    1 +
 3 files changed, 119 insertions(+)
 create mode 100755 tests/shared/004
 create mode 100644 tests/shared/004.out

diff --git a/tests/shared/004 b/tests/shared/004
new file mode 100755
index 0000000..5902b9f
--- /dev/null
+++ b/tests/shared/004
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 4
+#
+# Delayed allocation multi collapse range tests
+# This testcase is one of the 4 testcases (shared 001 - 004) which tries to
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
+_supported_fs xfs ext4
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
diff --git a/tests/shared/004.out b/tests/shared/004.out
new file mode 100644
index 0000000..a7d0f52
--- /dev/null
+++ b/tests/shared/004.out
@@ -0,0 +1,53 @@
+QA output created by 004
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
+	14. data -> hole @ EOF
+fallocate: Invalid argument
+0: [0..159]: extent
+7670f4830c6724a25e7c22d9eb9a6f4f
+	15. data -> hole @ 0
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
diff --git a/tests/shared/group b/tests/shared/group
index 9226032..fb1d6d0 100644
--- a/tests/shared/group
+++ b/tests/shared/group
@@ -6,6 +6,7 @@
 001 auto prealloc
 002 auto prealloc
 003 auto prealloc
+004 auto prealloc
 032 mkfs auto quick
 051 acl udf auto quick
 218 auto fsr quick
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
