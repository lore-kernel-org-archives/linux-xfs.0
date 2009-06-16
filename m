Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5G3CqGX140196 for <xfs@oss.sgi.com>; Mon, 15 Jun 2009 22:12:53 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B23BC2FAC47
	for <xfs@oss.sgi.com>; Mon, 15 Jun 2009 20:13:15 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id sdyk73T6VSFn4PDe for
	<xfs@oss.sgi.com>; Mon, 15 Jun 2009 20:13:15 -0700 (PDT)
Message-ID: <4A370DD2.6080204@sandeen.net>
Date: Mon, 15 Jun 2009 22:13:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 3/3] xfstests: fallocate + read/write tests, ext4 regression
	tests
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>

New test to test basic mixed fallocate + read & write,
includes a couple regression tests for bugs that ext4
hit.  Uses xfs_io to generate fallocate calls, so requires
git xfsprogs and very recent glibc at this point.

Ext4 folks, this is hopefully a reasonable example of
how to add a new test.  :)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/214 b/214
new file mode 100755
index 0000000..98cfc3a
--- /dev/null
+++ b/214
@@ -0,0 +1,131 @@
+#! /bin/sh
+# FS QA Test No. 214
+#
+# Basic unwritten extent sanity checks
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2009 Red Hat, Inc. All Rights Reserved.
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
+# creator
+owner=sandeen@sandeen.net
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+here=`pwd`
+tmp=$TEST_DIR/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+# generic, but xfs_io's fallocate must work
+_supported_fs generic
+# only Linux supports fallocate
+_supported_os Linux
+
+[ -n "$XFS_IO_PROG" ] || _notrun "xfs_io executable not found"
+
+rm -f $seq.full
+
+testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $TEST_DIR/$tmp.io 2>&1`
+
+# Old xfs_io doesn't have fallocate support
+echo $testio | grep -q "not found" && \
+	_notrun "xfs_io fallocate support is missing"
+# Old glibc, old kernels, and some filesystems don't have fallocate support
+echo $testio | grep -q "Operation not supported" && \
+	_notrun "xfs_io fallocate command failed (old kernel? wrong fs?)"
+
+# Ok, off we go.
+
+# Super-trivial; preallocate a region and read it; get 0s.
+echo "=== falloc & read  ==="
+$XFS_IO_PROG -F -f 		\
+	-c 'falloc 0 4096'	\
+	-c 'pread -v 0 4096'	\
+	$TEST_DIR/ouch | _filter_xfs_io_unique
+rm -f $TEST_DIR/ouch
+
+# Preallocate a chunk, write 1 byte, read it all back.
+# Should get no stale data.  Early ext4 bug.
+
+echo "=== falloc, write beginning, read ==="
+$XFS_IO_PROG -F -f 		\
+	-c 'falloc 0 512'	\
+	-c 'pwrite 0 1'		\
+	-c 'pread -v 0 512'	\
+	$TEST_DIR/ouch | _filter_xfs_io_unique
+rm -f $TEST_DIR/ouch
+
+# Same but write in the middle of the region
+echo "=== falloc, write middle, read ==="
+$XFS_IO_PROG -F -f 		\
+	-c 'falloc 0 512'	\
+	-c 'pwrite 256 1'	\
+	-c 'pread -v 0 512'	\
+	$TEST_DIR/ouch | _filter_xfs_io_unique
+rm -f $TEST_DIR/ouch
+
+# Same but write the end of the region
+echo "=== falloc, write end, read ==="
+$XFS_IO_PROG -F -f		\
+	-c 'falloc 0 512'	\
+	-c 'pwrite 511 1'	\
+	-c 'pread -v 0 512'	\
+	$TEST_DIR/ouch | _filter_xfs_io_unique
+rm -f $TEST_DIR/ouch
+
+# Reported by IBM on ext4.
+#
+# Fixed by commit a41f20716975910d9beb90b7efc61107901492b8
+#
+# The file was previously preallocated, and then initialized the middle of
+# the preallocation area using Direct IO write, then overwrite part of
+# initialized area. Later after truncate the file (to the middle of the
+# initialized data), the initialized data *before* the new file size was
+# gone after remount the filesystem.
+
+echo "=== falloc, write, sync, truncate, read ==="
+# Allocate, write, sync, truncate (buffered)
+$XFS_IO_PROG -F -f				\
+	-c 'falloc         0x0     0x65C00'	\
+	-c 'pwrite -S 0xAA 0x12000 0x10000'	\
+	-c 'fsync'				\
+	-c 'truncate 0x16000'			\
+	$TEST_DIR/ouch | _filter_xfs_io_unique
+
+# now do a direct read and see what's on-disk
+$XFS_IO_PROG -F -f -d				\
+	-c 'pread -v 0 0x16000'			\
+	$TEST_DIR/ouch | _filter_xfs_io_unique
+
+rm -f $TEST_DIR/ouch
+
+# success, all done
+status=0
+exit
diff --git a/214.out b/214.out
new file mode 100644
index 0000000..b6344c2
--- /dev/null
+++ b/214.out
@@ -0,0 +1,41 @@
+QA output created by 214
+=== falloc & read  ===
+00000000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+read 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+=== falloc, write beginning, read ===
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  cd 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+00000010:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+read 512/512 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+=== falloc, write middle, read ===
+wrote 1/1 bytes at offset 256
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+00000100:  cd 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+00000110:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+read 512/512 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+=== falloc, write end, read ===
+wrote 1/1 bytes at offset 511
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+000001f0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 cd  ................
+read 512/512 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+=== falloc, write, sync, truncate, read ===
+wrote 65536/65536 bytes at offset 73728
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+00012000:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+*
+read 90112/90112 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/group b/group
index 578fa05..c0ad793 100644
--- a/group
+++ b/group
@@ -322,3 +322,4 @@ prealloc
 211 auto aio quick
 212 auto aio quick
 213 rw auto prealloc quick
+214 rw auto prealloc quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
