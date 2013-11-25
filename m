Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 13EB17F3F
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 04:27:43 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F0658304048
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 02:27:42 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id 4pbpqupzULaBNLiM for
	<xfs@oss.sgi.com>; Mon, 25 Nov 2013 02:27:41 -0800 (PST)
From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH] xfstests,btrfs: add wrong compress type regression test
Date: Mon, 25 Nov 2013 18:28:44 +0800
Message-Id: <1385375324-11019-1-git-send-email-miaox@cn.fujitsu.com>
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
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

A test to check if the oops will happen when the users write some
data into the files whose compress flag is set but the compression
of the fs is disabled.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 tests/btrfs/022     | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/022.out |  5 ++++
 tests/btrfs/group   |  1 +
 3 files changed, 88 insertions(+)
 create mode 100755 tests/btrfs/022
 create mode 100644 tests/btrfs/022.out

diff --git a/tests/btrfs/022 b/tests/btrfs/022
new file mode 100755
index 0000000..0755fb5
--- /dev/null
+++ b/tests/btrfs/022
@@ -0,0 +1,82 @@
+#! /bin/bash
+# FS QA Test No. btrfs/008
+#
+# btrfs wrong compression type regression test, from a user report on
+# linux-btrfs.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Fujitsu.  All Rights Reserved.
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
+
+status=1	# failure is the default!
+
+_cleanup()
+{
+	rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+__workout()
+{
+	work_file="$SCRATCH_MNT/tmpfile"
+
+	touch $work_file || _fail "failed create test file"
+	chattr =c $work_file || _fail "failed change attribute of test file"
+	dd if=/dev/zero of=$work_file bs=1M count=1 oflag=sync &> /dev/null
+	if [ $? -ne 0 ]; then
+		_fail "failed write data into the test file"
+	fi
+}
+
+echo "*** test nodatacow"
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount "-o nodatacow"
+__workout
+_scratch_unmount
+
+echo "*** test compress=no"
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount "-o compress=no"
+__workout
+_scratch_unmount
+
+echo "*** test compress-force=no"
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount "-o compress-force=no"
+__workout
+_scratch_unmount
+
+echo "*** done"
+status=0 ; exit
diff --git a/tests/btrfs/022.out b/tests/btrfs/022.out
new file mode 100644
index 0000000..611fd67
--- /dev/null
+++ b/tests/btrfs/022.out
@@ -0,0 +1,5 @@
+QA output created by 022
+*** test nodatacow
+*** test compress=no
+*** test compress-force=no
+*** done
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 410f8ed..c2adb2f 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -24,3 +24,4 @@
 019 auto quick
 020 auto quick
 021 auto quick
+022 auto quick
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
