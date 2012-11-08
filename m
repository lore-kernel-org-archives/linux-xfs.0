Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA8MNUQJ027534 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 16:23:30 -0600
Received: from cxfsxe19.americas.sgi.com (cxfsxe19.americas.sgi.com
	[128.162.240.35])
	by estes.americas.sgi.com (Postfix) with ESMTP id 7809E700263D;
	Thu,  8 Nov 2012 16:25:25 -0600 (CST)
Received: by cxfsxe19.americas.sgi.com (Postfix, from userid 0)
	id 66109BA0C2; Thu,  8 Nov 2012 16:25:25 -0600 (CST)
Message-Id: <20121108222315.709683665@sgi.com>
Date: Thu, 08 Nov 2012 16:23:17 -0600
From: Andrew Dahl <adahl@sgi.com>
Subject: [patch 2/2] xfstests: xfs_tosspages() test addition
References: <20121108222315.505370321@sgi.com>
Content-Disposition: inline; filename=xfstests_tosspages_addition
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Andrew Dahl <adahl@sgi.com>

Tests xfs_tosspages() to ensure the expected output of tossing various 
ranges. It uses the XFS_IOC_ZERO_RANGE ioctl by way of "xfs_io zero"

The ranges tested are [0,4095], [0,4096], [4096,8192], [1024,5120]

Signed-off-by: Andrew Dahl <adahl@sgi.com>

--- 

Index: xfstests/290
===================================================================
--- /dev/null
+++ xfstests/290
@@ -0,0 +1,86 @@
+#! /bin/bash
+# FS QA Test No. 290
+#
+# check xfs_tosspages to ensure it's tossing proper pages
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
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    rm -f $TEST_DIR/290.*
+}
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
+_test_io_zero()
+{
+        $XFS_IO_PROG -c "zero help" 2>&1 | \
+                        grep 'command "zero" not found' > /dev/null
+        echo $?
+}
+
+[ $(_test_io_zero) -eq 0 ] && _notrun "zero command not supported"
+
+testfile=$TEST_DIR/290.$$
+
+$XFS_IO_PROG -F -f -t -c "pwrite -S 0x41 0 4096" \
+                      -c "pwrite -S 0x42 4096 4096" \
+                      -c "zero 0 4095" \
+                      -c "pread -v 0 8192" \
+                      $testfile | _filter_xfs_io_unique
+
+$XFS_IO_PROG -F -f -t -c "pwrite -S 0x41 0 4096" \
+                      -c "pwrite -S 0x42 4096 4096" \
+                      -c "zero 0 4096" \
+                      -c "pread -v 0 8192" \
+                      $testfile | _filter_xfs_io_unique
+
+$XFS_IO_PROG -F -f -t -c "pwrite -S 0x41 0 4096" \
+                      -c "pwrite -S 0x42 4096 4096" \
+                      -c "zero 4096 4096" \
+                      -c "pread -v 0 8192" \
+                      $testfile | _filter_xfs_io_unique
+
+$XFS_IO_PROG -F -f -t -c "pwrite -S 0x41 0 4096" \
+                      -c "pwrite -S 0x42 4096 4096" \
+                      -c "zero 1024 4096" \
+                      -c "pread -v 0 8192" \
+                      $testfile | _filter_xfs_io_unique
+
+# success, all done
+status=0
+exit
Index: xfstests/290.out
===================================================================
--- /dev/null
+++ xfstests/290.out
@@ -0,0 +1,43 @@
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
+290 auto quick ioctl



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
