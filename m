Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CA0AE7F52
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 05:34:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6AD19AC003
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 03:34:27 -0700 (PDT)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24]) by
	cuda.sgi.com with ESMTP id hKADGtuS2jndIT3B (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 03:34:26 -0700 (PDT)
Received: from epcpsbgr3.samsung.com
	(u143.gpu120.samsung.co.kr [203.254.230.143])
	by mailout1.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0N5900ICL41C5M80@mailout1.samsung.com> for
	xfs@oss.sgi.com; Thu, 08 May 2014 19:34:24 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v2 7/10] xfstests: generic/029: Multi insert range tests
Date: Thu, 08 May 2014 19:34:24 +0900
Message-id: <003d01cf6aa9$14808ce0$3d81a6a0$@samsung.com>
MIME-version: 1.0
Content-language: ko
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: 'Dave Chinner' <david@fromorbit.com>, 'Theodore Ts'o' <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, 'linux-ext4' <linux-ext4@vger.kernel.org>, linux-kernel@vger.kernel.org, 'Ashish Sangwan' <a.sangwan@samsung.com>, xfs@oss.sgi.com

This testcase(029) tries to test various corner cases with pre-existing holes
for finsert range functionality over different type of extents.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 tests/generic/029     | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/029.out | 50 +++++++++++++++++++++++++++++++++++++++
 tests/generic/group   |  1 +
 3 files changed, 116 insertions(+)
 create mode 100755 tests/generic/029
 create mode 100644 tests/generic/029.out

diff --git a/tests/generic/029 b/tests/generic/029
new file mode 100755
index 0000000..13d7164
--- /dev/null
+++ b/tests/generic/029
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. generic/029
+#
+# Multi insert range tests
+# This testcase is one of the 4 testcases which tries to
+# test various corner cases for finsert range functionality over different
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
+_require_xfs_io_command "fpunch"
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "finsert"
+
+testfile=$TEST_DIR/$seq.$$
+
+_test_generic_punch -k falloc fpunch finsert fiemap _filter_hole_fiemap $testfile
+_check_test_fs
+
+status=0
+exit
diff --git a/tests/generic/029.out b/tests/generic/029.out
new file mode 100644
index 0000000..0a2b659
--- /dev/null
+++ b/tests/generic/029.out
@@ -0,0 +1,50 @@
+QA output created by 029
+	1. into a hole
+0: [0..7]: hole
+1: [8..23]: extent
+2: [24..55]: hole
+cf845a781c107ec1346e849c9dd1b7e8
+	2. into allocated space
+0: [0..55]: extent
+64e72217eebcbdf31b1b058f9f5f476a
+	3. into unwritten space
+0: [0..55]: extent
+22b7303d274481990b5401b6263effe0
+	4. hole -> data
+0: [0..55]: extent
+c4fef62ba1de9d91a977cfeec6632f19
+	5. hole -> unwritten
+0: [0..55]: extent
+1ca74f7572a0f4ab477fdbb5682e5f61
+	6. data -> hole
+0: [0..55]: extent
+be0f35d4292a20040766d87883b0abd1
+	7. data -> unwritten
+0: [0..55]: extent
+bddb1f3895268acce30d516a99cb0f2f
+	8. unwritten -> hole
+0: [0..55]: extent
+f8fc47adc45b7cf72f988b3ddf5bff64
+	9. unwritten -> data
+0: [0..55]: extent
+c4fef62ba1de9d91a977cfeec6632f19
+	10. hole -> data -> hole
+0: [0..63]: extent
+52af1bfcbf43f28af2328de32e0567e5
+	11. data -> hole -> data
+0: [0..39]: extent
+1: [40..47]: hole
+2: [48..63]: extent
+e3a8d52acc4d91a8ed19d7b6f4f26a71
+	12. unwritten -> data -> unwritten
+0: [0..63]: extent
+52af1bfcbf43f28af2328de32e0567e5
+	13. data -> unwritten -> data
+0: [0..63]: extent
+2b22165f4a24a2c36fd05ef00b41df88
+	14. data -> hole @ EOF
+0: [0..55]: extent
+aa0f20d1edcdbce60d8ef82700ba30c3
+	15. data -> hole @ 0
+0: [0..55]: extent
+86c9d033be2761385c9cfa203c426bb2
diff --git a/tests/generic/group b/tests/generic/group
index 0ef13be..f5fe53c 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -31,6 +31,7 @@
 026 acl quick auto
 027 auto quick prealloc
 028 auto quick prealloc
+029 auto quick prealloc
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.7.11-rc0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
