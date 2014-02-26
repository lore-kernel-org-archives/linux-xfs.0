Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E77707F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 18:44:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CD3F730406A
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 16:44:13 -0800 (PST)
Received: from mail-we0-f175.google.com (mail-we0-f175.google.com
	[74.125.82.175]) by cuda.sgi.com with ESMTP id RBbQXqAbmqFdP40F
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 25 Feb 2014 16:44:12 -0800 (PST)
Received: by mail-we0-f175.google.com with SMTP id q59so1085897wes.34
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 16:44:11 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v3] xfstests: add test for btrfs-progs restore feature
Date: Wed, 26 Feb 2014 00:44:04 +0000
Message-Id: <1393375444-3760-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1393352816-26065-1-git-send-email-fdmanana@gmail.com>
References: <1393352816-26065-1-git-send-email-fdmanana@gmail.com>
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
To: xfs@oss.sgi.com
Cc: Filipe David Borba Manana <fdmanana@gmail.com>, linux-btrfs@vger.kernel.org

This is a regression test to verify that the restore feature of btrfs-progs
is able to correctly recover files that have compressed extents, specially when
the respective file extent items have a non-zero data offset field.

This issue is fixed by the following btrfs-progs patch:

    Btrfs-progs: fix restore dealing with compressed extents

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Fixed title of btrfs-progs patch in the comment and commit message.
V3: Make use of TEST_DIR instead of /tmp, defined $here=`pwd` and better
    comments about the conditions necessary to make the test fail. As
    suggested by Dave Chinner.

 tests/btrfs/043     |  109 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/043.out |   40 +++++++++++++++++++
 tests/btrfs/group   |    1 +
 3 files changed, 150 insertions(+)
 create mode 100755 tests/btrfs/043
 create mode 100644 tests/btrfs/043.out

diff --git a/tests/btrfs/043 b/tests/btrfs/043
new file mode 100755
index 0000000..07eea75
--- /dev/null
+++ b/tests/btrfs/043
@@ -0,0 +1,109 @@
+#! /bin/bash
+# FS QA Test No. btrfs/043
+#
+# Test that btrfs-progs' restore command is able to correctly recover files
+# that have compressed extents, specially when the respective file extent
+# items have a non-zero data offset field.
+#
+# This issue is fixed by the following btrfs-progs patch:
+#
+#    Btrfs-progs: fix restore of files with compressed extents
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Filipe Manana.  All Rights Reserved.
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
+    rm -fr $tmp
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_need_to_be_root
+
+rm -f $seqres.full
+
+test_btrfs_restore()
+{
+	if [ -z $1 ]
+	then
+		OPTIONS=""
+	else
+		OPTIONS="-o compress-force=$1"
+	fi
+	_scratch_mkfs >/dev/null 2>&1
+	_scratch_mount $OPTIONS
+
+	# Create first file extent item, then fsync to make sure the next write
+	# won't end up in the same file extent item, so that we have 2 distinct
+	# file extent items.
+	$XFS_IO_PROG -f -c "pwrite -S 0xff -b 100000 0 100000" -c "fsync" \
+		$SCRATCH_MNT/foo | _filter_xfs_io
+
+	# This creates a second file extent item.
+	$XFS_IO_PROG -c "pwrite -S 0xaa -b 100000 100000 100000" -c "fsync" \
+		$SCRATCH_MNT/foo | _filter_xfs_io
+
+	# Now do a few writes that will cause the first extent item to be split,
+	# with some of the new smaller file extent items getting a data offset
+	# field different from 0.
+	$XFS_IO_PROG -c "pwrite -S 0x1e -b 2 10000 2" $SCRATCH_MNT/foo \
+		| _filter_xfs_io
+	$XFS_IO_PROG -c "pwrite -S 0xd0 -b 11 33000 11" $SCRATCH_MNT/foo \
+		| _filter_xfs_io
+	$XFS_IO_PROG -c "pwrite -S 0xbc -b 100 99000 100" $SCRATCH_MNT/foo \
+		| _filter_xfs_io
+
+	md5sum $SCRATCH_MNT/foo | _filter_scratch
+
+	_scratch_unmount
+
+	rm -fr $TEST_DIR/foo
+	# Now that the fs is unmounted, call btrfs restore to read the file
+	# from disk and save it in the test directory. It used to incorrectly
+	# read compressed file extents that have a non-zero data offset field,
+	# resulting either in decompression failure or reading a wrong section
+	# of the extent.
+	_run_btrfs_util_prog restore $SCRATCH_DEV $TEST_DIR
+	md5sum $TEST_DIR/foo | cut -d ' ' -f 1
+}
+
+echo "Testing restore of file compressed with lzo"
+test_btrfs_restore "lzo"
+echo "Testing restore of file compressed with zlib"
+test_btrfs_restore "zlib"
+echo "Testing restore of file without any compression"
+test_btrfs_restore
+
+status=0
+exit
diff --git a/tests/btrfs/043.out b/tests/btrfs/043.out
new file mode 100644
index 0000000..d22e4ce
--- /dev/null
+++ b/tests/btrfs/043.out
@@ -0,0 +1,40 @@
+QA output created by 043
+Testing restore of file compressed with lzo
+wrote 100000/100000 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 100000/100000 bytes at offset 100000
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2/2 bytes at offset 10000
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 11/11 bytes at offset 33000
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 100/100 bytes at offset 99000
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+67edd038aaa42adb5a1aa78f2eb1d2b6  SCRATCH_MNT/foo
+67edd038aaa42adb5a1aa78f2eb1d2b6
+Testing restore of file compressed with zlib
+wrote 100000/100000 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 100000/100000 bytes at offset 100000
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2/2 bytes at offset 10000
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 11/11 bytes at offset 33000
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 100/100 bytes at offset 99000
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+67edd038aaa42adb5a1aa78f2eb1d2b6  SCRATCH_MNT/foo
+67edd038aaa42adb5a1aa78f2eb1d2b6
+Testing restore of file without any compression
+wrote 100000/100000 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 100000/100000 bytes at offset 100000
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2/2 bytes at offset 10000
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 11/11 bytes at offset 33000
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 100/100 bytes at offset 99000
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+67edd038aaa42adb5a1aa78f2eb1d2b6  SCRATCH_MNT/foo
+67edd038aaa42adb5a1aa78f2eb1d2b6
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 1037761..fabe3b5 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -45,3 +45,4 @@
 040 auto quick
 041 auto quick
 042 auto quick
+043 auto quick
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
