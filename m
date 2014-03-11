Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 25CCC7F3F
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2014 08:41:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 96B41AC004
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2014 06:41:06 -0700 (PDT)
Received: from mail-wg0-f52.google.com (mail-wg0-f52.google.com
	[74.125.82.52]) by cuda.sgi.com with ESMTP id PTJ5yN0onpSNgc1f
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 11 Mar 2014 06:41:04 -0700 (PDT)
Received: by mail-wg0-f52.google.com with SMTP id k14so10104296wgh.23
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2014 06:41:03 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v4] xfstests: add test for btrfs-progs restore feature
Date: Tue, 11 Mar 2014 13:40:39 +0000
Message-Id: <1394545239-7060-1-git-send-email-fdmanana@gmail.com>
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
Cc: jbacik@fb.com, Filipe David Borba Manana <fdmanana@gmail.com>, linux-btrfs@vger.kernel.org

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
V4: Use a dedicated directory to place the restore files, as suggested by
    Josef.

 tests/btrfs/043     |  113 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/043.out |   40 ++++++++++++++++++
 tests/btrfs/group   |    1 +
 3 files changed, 154 insertions(+)
 create mode 100755 tests/btrfs/043
 create mode 100644 tests/btrfs/043.out

diff --git a/tests/btrfs/043 b/tests/btrfs/043
new file mode 100755
index 0000000..d0a7152
--- /dev/null
+++ b/tests/btrfs/043
@@ -0,0 +1,113 @@
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
+restore_dir=$TEST_DIR/btrfs-test-$seq
+
+_cleanup()
+{
+	rm -fr $tmp
+	rm -fr $restore_dir
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
+mkdir $restore_dir
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
+	rm -f $restore_dir/foo
+	# Now that the fs is unmounted, call btrfs restore to read the file
+	# from disk and save it in the test directory. It used to incorrectly
+	# read compressed file extents that have a non-zero data offset field,
+	# resulting either in decompression failure or reading a wrong section
+	# of the extent.
+	_run_btrfs_util_prog restore $SCRATCH_DEV $restore_dir
+	md5sum $restore_dir/foo | cut -d ' ' -f 1
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
