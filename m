Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 55FAE7F6C
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 00:16:52 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 197518F8052
	for <xfs@oss.sgi.com>; Sun, 23 Nov 2014 22:16:51 -0800 (PST)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33]) by
	cuda.sgi.com with ESMTP id ALfnRCEgau8o3tFl (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 23 Nov 2014 22:16:49 -0800 (PST)
Received: from epcpsbgr1.samsung.com
	(u141.gpu120.samsung.co.kr [203.254.230.141])
	by mailout3.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0NFJ00LRG5G0H990@mailout3.samsung.com> for
	xfs@oss.sgi.com; Mon, 24 Nov 2014 15:16:48 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v6 5/10] xfstests: generic/038: Standard insert range tests
Date: Mon, 24 Nov 2014 15:16:48 +0900
Message-id: <002e01d007ae$3a8f7b10$afae7130$@samsung.com>
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
To: Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>, linux-kernel@vger.kernel.org, Ashish Sangwan <a.sangwan@samsung.com>, xfs@oss.sgi.com

This testcase(038) tries to test various corner cases for finsert range
functionality over different type of extents.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 common/punch          |  5 ++++
 common/rc             |  2 +-
 tests/generic/038     | 65 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/038.out | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/group   |  1 +
 5 files changed, 150 insertions(+), 1 deletion(-)
 create mode 100644 tests/generic/038
 create mode 100644 tests/generic/038.out

diff --git a/common/punch b/common/punch
index 237b4d8..a75f4cf 100644
--- a/common/punch
+++ b/common/punch
@@ -527,6 +527,11 @@ _test_generic_punch()
 		return
 	fi
 
+	# If zero_cmd is finsert, don't check unaligned offsets
+	if [ "$zero_cmd" == "finsert" ]; then
+		return
+	fi
+
 	echo "	16. data -> cache cold ->hole"
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
diff --git a/common/rc b/common/rc
index d5e3aff..ca4177f 100644
--- a/common/rc
+++ b/common/rc
@@ -1486,7 +1486,7 @@ _require_xfs_io_command()
 	"falloc" )
 		testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $testfile 2>&1`
 		;;
-	"fpunch" | "fcollapse" | "zero" | "fzero" )
+	"fpunch" | "fcollapse" | "zero" | "fzero" | "finsert" )
 		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
 			-c "$command 4k 8k" $testfile 2>&1`
 		;;
diff --git a/tests/generic/038 b/tests/generic/038
new file mode 100644
index 0000000..0ce0e61
--- /dev/null
+++ b/tests/generic/038
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. generic/038
+#
+# Standard insert range tests
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
+_test_generic_punch falloc fpunch finsert fiemap _filter_hole_fiemap $testfile
+_check_test_fs
+
+status=0
+exit
diff --git a/tests/generic/038.out b/tests/generic/038.out
new file mode 100644
index 0000000..3ebdb43
--- /dev/null
+++ b/tests/generic/038.out
@@ -0,0 +1,78 @@
+QA output created by 038
+	1. into a hole
+cf845a781c107ec1346e849c9dd1b7e8
+	2. into allocated space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..55]: extent
+64e72217eebcbdf31b1b058f9f5f476a
+	3. into unwritten space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..55]: extent
+cf845a781c107ec1346e849c9dd1b7e8
+	4. hole -> data
+0: [0..31]: hole
+1: [32..47]: extent
+2: [48..55]: hole
+adb08a6d94a3b5eff90fdfebb2366d31
+	5. hole -> unwritten
+0: [0..31]: hole
+1: [32..47]: extent
+2: [48..55]: hole
+cf845a781c107ec1346e849c9dd1b7e8
+	6. data -> hole
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..31]: extent
+3: [32..55]: hole
+be0f35d4292a20040766d87883b0abd1
+	7. data -> unwritten
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..47]: extent
+3: [48..55]: hole
+be0f35d4292a20040766d87883b0abd1
+	8. unwritten -> hole
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..31]: extent
+3: [32..55]: hole
+cf845a781c107ec1346e849c9dd1b7e8
+	9. unwritten -> data
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..47]: extent
+3: [48..55]: hole
+adb08a6d94a3b5eff90fdfebb2366d31
+	10. hole -> data -> hole
+0: [0..39]: hole
+1: [40..47]: extent
+2: [48..63]: hole
+0487b3c52810f994c541aa166215375f
+	11. data -> hole -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+3: [40..47]: hole
+4: [48..63]: extent
+e3a8d52acc4d91a8ed19d7b6f4f26a71
+	12. unwritten -> data -> unwritten
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..63]: extent
+0487b3c52810f994c541aa166215375f
+	13. data -> unwritten -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..63]: extent
+2b22165f4a24a2c36fd05ef00b41df88
+	14. data -> hole @ EOF
+0: [0..23]: extent
+1: [24..39]: hole
+2: [40..55]: extent
+aa0f20d1edcdbce60d8ef82700ba30c3
+	15. data -> hole @ 0
+0: [0..15]: hole
+1: [16..55]: extent
+86c9d033be2761385c9cfa203c426bb2
diff --git a/tests/generic/group b/tests/generic/group
index 9f355fc..7d6f227 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -40,6 +40,7 @@
 035 auto quick
 036 auto aio rw stress
 037 metadata auto quick
+038 auto quick prealloc
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.7.11-rc0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
