Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CE7388021
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 13:32:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BDB2E304053
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 11:32:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KZAPmhHoy4CEpRtE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Sep 2014 11:32:32 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs/053: test for stale data exposure via falloc/writeback
	interaction
Date: Fri, 26 Sep 2014 14:32:29 -0400
Message-Id: <1411756349-4537-1-git-send-email-bfoster@redhat.com>
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
To: fstests@vger.kernel.org
Cc: xfs@oss.sgi.com

XFS buffered I/O writeback has a subtle race condition that leads to
stale data exposure if the filesystem happens to crash after delayed
allocation blocks are converted on disk and before data is written back
to said blocks.

Use file allocation commands to attempt to reproduce a related, but
slightly different variant of this problem. The associated falloc
commands can lead to partial writeback that converts an extent larger
than the range affected by falloc. If the filesystem crashes after the
extent conversion but before all other cached data is written to the
extent, stale data can be exposed.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This fell out of a combination of a conversation with Dave about XFS
writeback and buffer/cache coherency and some hacking I'm doing on the
XFS zero range implementation. Note that fpunch currently fails the
test. Also, this test is XFS specific primarily due to the use of
godown.

Brian

 tests/xfs/053     | 101 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/053.out |  10 ++++++
 tests/xfs/group   |   1 +
 3 files changed, 112 insertions(+)
 create mode 100755 tests/xfs/053
 create mode 100644 tests/xfs/053.out

diff --git a/tests/xfs/053 b/tests/xfs/053
new file mode 100755
index 0000000..4fba127
--- /dev/null
+++ b/tests/xfs/053
@@ -0,0 +1,101 @@
+#! /bin/bash
+# FS QA Test No. 053
+#
+# Test stale data exposure via writeback using various file allocation
+# modification commands. The presumption is that such commands result in partial
+# writeback and can convert a delayed allocation extent, that might be larger
+# than the ranged affected by fallocate, to a normal extent. If the fs happens
+# to crash sometime between when the extent modification is logged and writeback
+# occurs for dirty pages within the extent but outside of the fallocated range,
+# stale data exposure can occur.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Red Hat, Inc.  All Rights Reserved.
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
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/punch
+
+# real QA test starts here
+rm -f $seqres.full
+
+_crashtest()
+{
+	cmd=$1
+	img=$SCRATCH_MNT/$seq.img
+	mnt=$SCRATCH_MNT/$seq.mnt
+	file=$mnt/file
+
+	# Create an fs on a small, initialized image. The pattern is written to
+	# the image to detect stale data exposure.
+	$XFS_IO_PROG -f -c "truncate 0" -c "pwrite 0 25M" $img \
+		>> $seqres.full 2>&1
+	$MKFS_XFS_PROG $MKFS_OPTIONS $img >> $seqres.full 2>&1
+
+	mkdir -p $mnt
+	mount $img $mnt
+
+	echo $cmd
+
+	# write, run the test command and shutdown the fs
+	$XFS_IO_PROG -f -c "pwrite -S 1 0 64k" -c "$cmd 60k 4k" $file | \
+		_filter_xfs_io
+	./src/godown -f $mnt
+
+	umount $mnt
+	mount $img $mnt
+
+	# we generally expect a zero-sized file (this should be silent)
+	hexdump $file
+
+	umount $mnt
+}
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_scratch
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fpunch"
+_require_xfs_io_command "fzero"
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+_crashtest "falloc -k"
+_crashtest "fpunch"
+_crashtest "fzero -k"
+
+status=0
+exit
diff --git a/tests/xfs/053.out b/tests/xfs/053.out
new file mode 100644
index 0000000..c777fe2
--- /dev/null
+++ b/tests/xfs/053.out
@@ -0,0 +1,10 @@
+QA output created by 053
+falloc -k
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+fpunch
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+fzero -k
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/xfs/group b/tests/xfs/group
index 09bce15..408e617 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -49,6 +49,7 @@
 050 quota auto quick
 051 auto log metadata
 052 quota db auto quick
+053 auto quick rw
 054 quota auto quick
 055 dump ioctl remote tape
 056 dump ioctl auto quick
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
