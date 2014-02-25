Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 676B57F72
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 13:15:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4AAE6304075
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 11:15:40 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XPwrOTtG4O2IgRW2 for
	<xfs@oss.sgi.com>; Tue, 25 Feb 2014 11:15:39 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/6] generic/290: Add test for fallocate zero range
Date: Tue, 25 Feb 2014 20:15:23 +0100
Message-Id: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
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
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 common/rc             |  14 +++++++
 tests/generic/290     |  92 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/290.out | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/group   |   1 +
 4 files changed, 216 insertions(+)
 create mode 100755 tests/generic/290
 create mode 100644 tests/generic/290.out

diff --git a/common/rc b/common/rc
index f2c3c3a..d3ec4db 100644
--- a/common/rc
+++ b/common/rc
@@ -1359,6 +1359,20 @@ _require_xfs_io_fiemap()
 		_notrun "xfs_io fiemap command failed (no fs support?)"
 }
 
+# check that xfs_io, kernel and filesystem all support fallocate with zero
+# range
+_require_xfs_io_falloc_zero()
+{
+	testfile=$TEST_DIR/$$.falloc
+	testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
+		-c "fzero 4k 8k" $testfile 2>&1`
+	rm -f $testfile 2>&1 > /dev/null
+	echo $testio | grep -q "not found" && \
+		_notrun "xfs_io fallocate zero range support is missing"
+	echo $testio | grep -q "Operation not supported" && \
+		_notrun "xfs_io fallocate fzero command failed (no fs support?)"
+}
+
 # Check that a fs has enough free space (in 1024b blocks)
 #
 _require_fs_space()
diff --git a/tests/generic/290 b/tests/generic/290
new file mode 100755
index 0000000..90f560a
--- /dev/null
+++ b/tests/generic/290
@@ -0,0 +1,92 @@
+#! /bin/bash
+# FS QA Test No. 290
+#
+# Makes calls to fallocate zero range and checks tossed ranges
+#
+# Nothing should be tossed unless the range includes a page boundry
+#
+# Primarily tests page boundries and boundries that are
+#  off-by-one to ensure we're only tossing what's expected
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2012 SGI.  All Rights Reserved.
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
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_os Linux
+
+_require_xfs_io_falloc_zero
+
+testfile=$TEST_DIR/290.$$
+
+test_zero()
+{
+	zero_start=$1
+	zero_len=$2
+
+	$XFS_IO_PROG -f -t -c "pwrite -S 0x41 0 4096" \
+                      -c "pwrite -S 0x42 4096 4096" \
+                      -c "fzero $zero_start $zero_len" \
+                      -c "pread -v 0 8192" \
+                      $testfile | _filter_xfs_io_unique
+}
+
+echo "[0,1] -- Shouldn't toss anything"
+test_zero    0    1
+
+echo "[0,4095] -- Shouldn't toss anything"
+test_zero    0 4095
+
+echo "[0,4096] -- Should toss first page"
+test_zero    0 4096
+
+echo "[0,4097] -- Should toss first page"
+test_zero    0 4097
+
+echo "[4095,8191] -- Should toss last byte of first page"
+test_zero 4095 4096
+
+echo "[4095,8192] -- Should toss second page & last byte of first page"
+test_zero 4095 4097
+
+echo "[4095,8193] -- Should toss second page & last byte of first page"
+test_zero 4095 4098
+
+echo "[4096,8192] -- Should toss second page"
+test_zero 4096 4096
+
+echo "[1024,5120] -- Should toss from 1024 to end of first page"
+test_zero 1024 4096
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/290.out b/tests/generic/290.out
new file mode 100644
index 0000000..4614540
--- /dev/null
+++ b/tests/generic/290.out
@@ -0,0 +1,109 @@
+QA output created by 290
+[0,1] -- Shouldn't toss anything
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  00 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  .AAAAAAAAAAAAAAA
+00000010:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+00001000:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+[0,4095] -- Shouldn't toss anything
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+00000ff0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41  ...............A
+00001000:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+[0,4096] -- Should toss first page
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+00001000:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+[0,4097] -- Should toss first page
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+00001000:  00 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  .BBBBBBBBBBBBBBB
+00001010:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+[4095,8191] -- Should toss last byte of first page
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+00000ff0:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 00  AAAAAAAAAAAAAAA.
+00001000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+00001ff0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42  ...............B
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+[4095,8192] -- Should toss second page & last byte of first page
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+00000ff0:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 00  AAAAAAAAAAAAAAA.
+00001000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+[4095,8193] -- Should toss second page & last byte of first page
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+00000ff0:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 00  AAAAAAAAAAAAAAA.
+00001000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+[4096,8192] -- Should toss second page
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+00001000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+[1024,5120] -- Should toss from 1024 to end of first page
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+00000400:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+00001400:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/generic/group b/tests/generic/group
index 34bd118..f3b2dc7 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -106,6 +106,7 @@
 285 auto rw
 286 auto quick other
 288 auto quick ioctl trim
+290 auto quick prealloc
 294 auto quick
 299 auto aio enospc rw stress
 300 auto aio enospc preallocrw stress
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
