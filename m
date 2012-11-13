Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAD1BcCP005051 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 19:11:38 -0600
Received: from xmail.sgi.com (pv-excas1-dc21-nlb.corp.sgi.com [137.38.102.126])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0F9B88F8040
	for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 17:13:38 -0800 (PST)
Message-ID: <50A19EC0.4040405@sgi.com>
Date: Mon, 12 Nov 2012 19:13:36 -0600
From: Andrew Dahl <adahl@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch 2/2 V2] xfstests: xfs_tosspages() test addition
References: <20121108222315.505370321@sgi.com>
	<20121108222315.709683665@sgi.com> <20121108232726.GV6434@dastard>
In-Reply-To: <20121108232726.GV6434@dastard>
Content-Type: multipart/mixed; boundary="------------040404060307090609090506"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--------------040404060307090609090506
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit



Tests the XFS_IOC_ZERO_RANGE ioctl by way of the "xfs_io zero" utility
to ensure it is tossing the expected ranges.

The ranges tested are [0,1] [0,4095] [0,4096] [0,4097] [4095,8191]
  [4095,8192] [4095,8193] [4096,8192] [1024,4096]

Signed-off-by: Andrew Dahl <adahl@sgi.com>

---

Index: xfstests/290
===================================================================
--- /dev/null
+++ xfstests/290
@@ -0,0 +1,94 @@
+#! /bin/bash
+# FS QA Test No. 290
+#
+# Makes calls to XFS_IOC_ZERO_RANGE and checks tossed ranges
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
+# creator
+owner=adahl@sgi.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+
+_require_xfs_io_zero
+
+testfile=$TEST_DIR/290.$$
+
+test_zero()
+{
+	zero_start=$1
+	zero_len=$2
+
+	$XFS_IO_PROG -F -f -t -c "pwrite -S 0x41 0 4096" \
+                      -c "pwrite -S 0x42 4096 4096" \
+                      -c "zero $zero_start $zero_len" \
+                      -c "pread -v 0 8192" \
+                      $testfile | _filter_xfs_io_unique
+}
+
+# [0,1] -- Shouldn't toss anything
+test_zero    0    1
+
+#[0,4095] -- Shouldn't toss anything
+test_zero    0 4095
+
+#[0,4096] -- Should toss first page
+test_zero    0 4096
+
+#[0,4097] -- Should toss first page
+test_zero    0 4097
+
+#[4095,8191] -- Should toss last byte of first page
+test_zero 4095 4096
+
+#[4095,8192] -- Should toss second page & last byte of first page
+test_zero 4095 4097
+
+#[4095,8193] -- Should toss second page & last byte of first page
+test_zero 4095 4098
+
+#[4096,8192] -- Should toss second page
+test_zero 4096 4096
+
+#[1024,5120] -- Should toss from 1024 to end of first page
+test_zero 1024 4096
+
+# success, all done
+status=0
+exit
Index: xfstests/290.out
===================================================================
--- /dev/null
+++ xfstests/290.out
@@ -0,0 +1,96 @@
+QA output created by 290
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41
AAAAAAAAAAAAAAAA
+*
+00001000:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42
BBBBBBBBBBBBBBBB
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41
AAAAAAAAAAAAAAAA
+*
+00001000:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42
BBBBBBBBBBBBBBBB
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................
+*
+00001000:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42
BBBBBBBBBBBBBBBB
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................
+*
+00001000:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42
BBBBBBBBBBBBBBBB
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41
AAAAAAAAAAAAAAAA
+*
+00000ff0:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 00
AAAAAAAAAAAAAAA.
+00001000:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42
BBBBBBBBBBBBBBBB
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41
AAAAAAAAAAAAAAAA
+*
+00000ff0:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 00
AAAAAAAAAAAAAAA.
+00001000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41
AAAAAAAAAAAAAAAA
+*
+00000ff0:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 00
AAAAAAAAAAAAAAA.
+00001000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41
AAAAAAAAAAAAAAAA
+*
+00001000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41
AAAAAAAAAAAAAAAA
+*
+00000400:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................
+*
+00001000:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42
BBBBBBBBBBBBBBBB
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
Index: xfstests/group
===================================================================
--- xfstests.orig/group
+++ xfstests/group
@@ -408,3 +408,4 @@ deprecated
 287 auto dump quota quick
 288 auto quick ioctl trim
 289 auto quick
+290 auto rw prealloc quick ioctl


--------------040404060307090609090506
Content-Type: text/plain; charset="UTF-8"; name="xfstests_zero"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="xfstests_zero"

Tests the XFS_IOC_ZERO_RANGE ioctl by way of the "xfs_io zero" utility
to ensure it is tossing the expected ranges.

The ranges tested are [0,1] [0,4095] [0,4096] [0,4097] [4095,8191]
  [4095,8192] [4095,8193] [4096,8192] [1024,4096]

Signed-off-by: Andrew Dahl <adahl@sgi.com>

---

Index: xfstests/290
===================================================================
--- /dev/null
+++ xfstests/290
@@ -0,0 +1,94 @@
+#! /bin/bash
+# FS QA Test No. 290
+#
+# Makes calls to XFS_IOC_ZERO_RANGE and checks tossed ranges
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
+# creator
+owner=adahl@sgi.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+
+_require_xfs_io_zero
+
+testfile=$TEST_DIR/290.$$
+
+test_zero()
+{
+	zero_start=$1
+	zero_len=$2
+
+	$XFS_IO_PROG -F -f -t -c "pwrite -S 0x41 0 4096" \
+                      -c "pwrite -S 0x42 4096 4096" \
+                      -c "zero $zero_start $zero_len" \
+                      -c "pread -v 0 8192" \
+                      $testfile | _filter_xfs_io_unique
+}
+
+# [0,1] -- Shouldn't toss anything
+test_zero    0    1
+
+#[0,4095] -- Shouldn't toss anything
+test_zero    0 4095
+
+#[0,4096] -- Should toss first page
+test_zero    0 4096
+
+#[0,4097] -- Should toss first page
+test_zero    0 4097
+
+#[4095,8191] -- Should toss last byte of first page
+test_zero 4095 4096
+
+#[4095,8192] -- Should toss second page & last byte of first page
+test_zero 4095 4097
+
+#[4095,8193] -- Should toss second page & last byte of first page
+test_zero 4095 4098
+
+#[4096,8192] -- Should toss second page
+test_zero 4096 4096
+
+#[1024,5120] -- Should toss from 1024 to end of first page
+test_zero 1024 4096
+
+# success, all done
+status=0
+exit
Index: xfstests/290.out
===================================================================
--- /dev/null
+++ xfstests/290.out
@@ -0,0 +1,96 @@
+QA output created by 290
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+00001000:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+00001000:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
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
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+00000ff0:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 00  AAAAAAAAAAAAAAA.
+00001000:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
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
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+00000400:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+00001000:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
Index: xfstests/group
===================================================================
--- xfstests.orig/group
+++ xfstests/group
@@ -408,3 +408,4 @@ deprecated
 287 auto dump quota quick
 288 auto quick ioctl trim
 289 auto quick
+290 auto rw prealloc quick ioctl


--------------040404060307090609090506
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------040404060307090609090506--
