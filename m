Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ED18829DFA
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 19:13:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DDEDD8F804B
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 17:13:27 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id DGpA69Uu2Ci3A433 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 17:13:25 -0800 (PST)
Subject: [PATCH 14/23] reflink: high offset reflink and dedupe tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 08 Feb 2016 17:13:16 -0800
Message-ID: <20160209011316.23099.62123.stgit@birch.djwong.org>
In-Reply-To: <20160209011145.23099.95354.stgit@birch.djwong.org>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Ensure that we can pass absurdly enormous offsets and lengths to
reflink/dedupe and it'll survive.

v2: Ask for dedupe in the dedupe test.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[hch@lst.de: call _require_test_dedupe]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/303     |   99 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/303.out |   21 ++++++++++
 tests/generic/304     |  100 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/304.out |   22 +++++++++++
 tests/generic/group   |    2 +
 5 files changed, 244 insertions(+)
 create mode 100755 tests/generic/303
 create mode 100644 tests/generic/303.out
 create mode 100755 tests/generic/304
 create mode 100644 tests/generic/304.out


diff --git a/tests/generic/303 b/tests/generic/303
new file mode 100755
index 0000000..c337483
--- /dev/null
+++ b/tests/generic/303
@@ -0,0 +1,99 @@
+#! /bin/bash
+# FS QA Test No. 303
+#
+# Check that high-offset reflinks work.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
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
+
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf "$tmp".* "$testdir"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_test_reflink
+_require_cp_reflink
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
+
+echo "Create the original files"
+bigoff=9223372036854775806
+len=9223372036854775807
+bigoff_64k=9223372036854710272	# bigoff rounded down to 64k
+"$XFS_IO_PROG" -f -c "truncate $len" "$testdir/file0" >> "$seqres.full"
+test -s "$testdir/file0" || _notrun "High offset ftruncate failed"
+_pwrite_byte 0x61 $bigoff 1 "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 1048575 1 "$testdir/file2" >> "$seqres.full"
+
+echo "Reflink large single byte file"
+_cp_reflink "$testdir/file1" "$testdir/file3" >> "$seqres.full"
+
+echo "Reflink large empty file"
+_cp_reflink "$testdir/file0" "$testdir/file4" >> "$seqres.full"
+
+echo "Reflink past maximum file size in dest file (should fail)"
+_reflink_range "$testdir/file1" 0 "$testdir/file5" 4611686018427322368 $len >> "$seqres.full"
+
+echo "Reflink high offset to low offset"
+_reflink_range "$testdir/file1" $bigoff_64k "$testdir/file6" 1048576 65535 >> "$seqres.full"
+
+echo "Reflink past source file EOF (should fail)"
+_reflink_range "$testdir/file2" 524288 "$testdir/file7" 0 1048576 >> "$seqres.full"
+
+echo "Reflink max size at nonzero offset (should fail)"
+_reflink_range "$testdir/file2" 524288 "$testdir/file8" 0 $len >> "$seqres.full"
+
+echo "Reflink with huge off/len (should fail)"
+_reflink_range "$testdir/file2" $bigoff_64k "$testdir/file9" 0 $bigoff_64k >> "$seqres.full"
+
+echo "Check file creation"
+_test_remount
+echo "file3"
+"$XFS_IO_PROG" -c "pread -v -q $bigoff 1" "$testdir/file3"
+echo "file4"
+"$XFS_IO_PROG" -c "pread -v -q $bigoff 1" "$testdir/file4"
+# file5 should fail above
+echo "file6"
+"$XFS_IO_PROG" -c "pread -v -q 1114110 1" "$testdir/file6"
+# file7 should fail above
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/303.out b/tests/generic/303.out
new file mode 100644
index 0000000..39a8803
--- /dev/null
+++ b/tests/generic/303.out
@@ -0,0 +1,21 @@
+QA output created by 303
+Format and mount
+Create the original files
+Reflink large single byte file
+Reflink large empty file
+Reflink past maximum file size in dest file (should fail)
+XFS_IOC_CLONE_RANGE: Invalid argument
+Reflink high offset to low offset
+Reflink past source file EOF (should fail)
+XFS_IOC_CLONE_RANGE: Invalid argument
+Reflink max size at nonzero offset (should fail)
+XFS_IOC_CLONE_RANGE: Invalid argument
+Reflink with huge off/len (should fail)
+XFS_IOC_CLONE_RANGE: Invalid argument
+Check file creation
+file3
+7ffffffffffffffe:  61  a
+file4
+7ffffffffffffffe:  00  .
+file6
+0010fffe:  61  a
diff --git a/tests/generic/304 b/tests/generic/304
new file mode 100755
index 0000000..443ed21
--- /dev/null
+++ b/tests/generic/304
@@ -0,0 +1,100 @@
+#! /bin/bash
+# FS QA Test No. 304
+#
+# Check that high-offset dedupes work.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
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
+
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf "$tmp".* "$testdir"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_test_dedupe
+_require_cp_reflink
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
+
+echo "Create the original files"
+bigoff=9223372036854775806
+len=9223372036854775807
+bigoff_64k=9223372036854710272	# bigoff rounded down to 64k
+"$XFS_IO_PROG" -f -c "truncate $len" "$testdir/file0" >> "$seqres.full"
+test -s "$testdir/file0" || _notrun "High offset ftruncate failed"
+_pwrite_byte 0x61 $bigoff 1 "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 $bigoff 1 "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x61 1048575 1 "$testdir/file2" >> "$seqres.full"
+
+echo "Dedupe large single byte file"
+_dedupe_range "$testdir/file1" 0 "$testdir/file3" 0 $len >> "$seqres.full"
+
+echo "Dedupe large empty file"
+_dedupe_range "$testdir/file0" 0 "$testdir/file4" 0 $len >> "$seqres.full"
+
+echo "Dedupe past maximum file size in dest file (should fail)"
+_dedupe_range "$testdir/file1" 0 "$testdir/file5" 4611686018427322368 $len >> "$seqres.full"
+
+echo "Dedupe high offset to low offset"
+_dedupe_range "$testdir/file1" $bigoff_64k "$testdir/file6" 1048576 65535 >> "$seqres.full"
+
+echo "Dedupe past source file EOF (should fail)"
+_dedupe_range "$testdir/file2" 524288 "$testdir/file7" 0 1048576 >> "$seqres.full"
+
+echo "Dedupe max size at nonzero offset (should fail)"
+_dedupe_range "$testdir/file2" 524288 "$testdir/file8" 0 $len >> "$seqres.full"
+
+echo "Dedupe with huge off/len (should fail)"
+_dedupe_range "$testdir/file2" $bigoff_64k "$testdir/file9" 0 $bigoff_64k >> "$seqres.full"
+
+echo "Check file creation"
+_test_remount
+echo "file3"
+"$XFS_IO_PROG" -c "pread -v -q $bigoff 1" "$testdir/file3"
+echo "file4"
+"$XFS_IO_PROG" -c "pread -v -q $bigoff 1" "$testdir/file4"
+# file5 should fail above
+echo "file6"
+"$XFS_IO_PROG" -c "pread -v -q 1114110 1" "$testdir/file6"
+# file7 should fail above
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/304.out b/tests/generic/304.out
new file mode 100644
index 0000000..4af2a39
--- /dev/null
+++ b/tests/generic/304.out
@@ -0,0 +1,22 @@
+QA output created by 304
+Format and mount
+Create the original files
+Dedupe large single byte file
+dedupe: Invalid argument
+Dedupe large empty file
+dedupe: Invalid argument
+Dedupe past maximum file size in dest file (should fail)
+dedupe: Invalid argument
+Dedupe high offset to low offset
+dedupe: Extents did not match.
+Dedupe past source file EOF (should fail)
+dedupe: Invalid argument
+Dedupe max size at nonzero offset (should fail)
+dedupe: Invalid argument
+Dedupe with huge off/len (should fail)
+XFS_IOC_FILE_EXTENT_SAME: Invalid argument
+Check file creation
+file3
+7ffffffffffffffe:  61  a
+file4
+file6
diff --git a/tests/generic/group b/tests/generic/group
index 7e1ea72..3229dad 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -305,6 +305,8 @@
 300 auto aio enospc preallocrw stress
 301 auto quick clone
 302 auto quick clone
+303 auto quick clone
+304 auto quick clone
 306 auto quick rw
 307 auto quick
 308 auto quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
