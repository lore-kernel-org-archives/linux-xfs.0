Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F31497FE2
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 01:36:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E09C7304066
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 23:36:28 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id y4HaZuCEyHljAPhQ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 23:36:27 -0800 (PST)
Message-Id: <20131211073627.256859075@bombadil.infradead.org>
Date: Tue, 10 Dec 2013 23:34:53 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 08/12] 130: use TEST_DIR instead of a SCRATCH_DEV
References: <20131211073445.353655850@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0008-130-use-TEST_DIR-instead-of-a-SCRATCH_DEV.patch
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
Cc: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>

The test does not require a fresh file system.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/130 |   47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/tests/generic/130 b/tests/generic/130
index 8367dc7..833474d 100755
--- a/tests/generic/130
+++ b/tests/generic/130
@@ -48,37 +48,38 @@ trap "exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux IRIX
 
-_require_scratch
 _require_sparse_files
 
-_scratch_mkfs >/dev/null 2>&1
-_scratch_mount
+testdir=$TEST_DIR/dir.$seq
+
+rm -rf $testdir
+mkdir $testdir
 
 echo "End-of-file zeroing with direct I/O"
 $XFS_IO_PROG -f -d -t -c "pwrite -S 0x63 0 65536" \
     -c "truncate 1" \
     -c "pwrite -S 0x41 65536 65536" \
     -c "pread -v 0 131072" \
-    $SCRATCH_MNT/eof-zeroing_direct | _filter_xfs_io_unique
+    $testdir/eof-zeroing_direct | _filter_xfs_io_unique
 
 echo
 echo "Basic Block Hole test"
 $XFS_IO_PROG -f -t -c "truncate 8192" \
     -c "pread -v 5000 3000" \
-    $SCRATCH_MNT/blackhole | _filter_xfs_io_unique
+    $testdir/blackhole | _filter_xfs_io_unique
 
 echo
 echo "Test buffered and direct IO coherency"
 $XFS_IO_PROG -f -t -c "pwrite -S 0x41 8000 1000" \
     -c "pwrite -S 0x57 4000 1000" \
-    $SCRATCH_MNT/buff_direct_coherency | _filter_xfs_io_unique
+    $testdir/buff_direct_coherency | _filter_xfs_io_unique
 
 $XFS_IO_PROG -d -c "pwrite -S 0x78 20480 4096"\
     -c "pwrite -S 0x79 4096 4096"\
-    $SCRATCH_MNT/buff_direct_coherency | _filter_xfs_io_unique
+    $testdir/buff_direct_coherency | _filter_xfs_io_unique
 
 $XFS_IO_PROG -c "pread -v 0 9000"\
-    $SCRATCH_MNT/buff_direct_coherency | _filter_xfs_io_unique
+    $testdir/buff_direct_coherency | _filter_xfs_io_unique
 
 echo
 echo "Test direct read and write"
@@ -86,19 +87,19 @@ $XFS_IO_PROG -f -d -t -c "pwrite -S 0x78 0 65536"\
     -c "pread -v 0 65536"\
     -c "pwrite -S 0x46 65536 6553600"\
     -c "pread -v 0 6619136"\
-    $SCRATCH_MNT/direct_io | _filter_xfs_io_unique
+    $testdir/direct_io | _filter_xfs_io_unique
 
 $XFS_IO_PROG -d -c "pread -v 0 6619136"\
-    $SCRATCH_MNT/direct_io | _filter_xfs_io_unique
+    $testdir/direct_io | _filter_xfs_io_unique
 
 $XFS_IO_PROG -f -d -t -c "pwrite -S 0x61 0 65536"\
     -c "pread -v 0 65536"\
     -c "pwrite -S 0x62 65536 131072"\
     -c "pread -v 0 131072"\
-    $SCRATCH_MNT/async_direct_io | _filter_xfs_io_unique
+    $testdir/async_direct_io | _filter_xfs_io_unique
 
 $XFS_IO_PROG -d -c "pread -v 0 131072"\
-    $SCRATCH_MNT/async_direct_io | _filter_xfs_io_unique
+    $testdir/async_direct_io | _filter_xfs_io_unique
 
 echo
 echo "FSB Edge test"
@@ -108,30 +109,30 @@ $XFS_IO_PROG -f -t -c "truncate 131072"\
     -c "truncate 131072"\
     -c "pwrite -S 0x61 65535 2"\
     -c "pread -v 0 131072"\
-    $SCRATCH_MNT/fsb_edge_test | _filter_xfs_io_unique
+    $testdir/fsb_edge_test | _filter_xfs_io_unique
 
 echo
 echo "Open Trunk test (O_TRUNC)"
 for n in 0 1 2 3 4
 do
-    $XFS_IO_PROG -f -t -c "pread -v 0 100" $SCRATCH_MNT/$n | _filter_xfs_io_unique
+    $XFS_IO_PROG -f -t -c "pread -v 0 100" $testdir/$n | _filter_xfs_io_unique
 
-    echo "Test" > $SCRATCH_MNT/$n
-    $XFS_IO_PROG -f -t -c "pread -v 0 100" $SCRATCH_MNT/$n | _filter_xfs_io_unique
-    cat $SCRATCH_MNT/$n
+    echo "Test" > $testdir/$n
+    $XFS_IO_PROG -f -t -c "pread -v 0 100" $testdir/$n | _filter_xfs_io_unique
+    cat $testdir/$n
 done
 echo "DONE"
 
 echo
 echo "Append test"
-echo "append to me" > $SCRATCH_MNT/append
+echo "append to me" > $testdir/append
 $XFS_IO_PROG -a -c "pwrite -S 0x61 0 10" \
     -c "pread -v 0 24"\
-    $SCRATCH_MNT/append | _filter_xfs_io_unique
+    $testdir/append | _filter_xfs_io_unique
 
 echo
 echo "Small Vector Async"
-echo "abcdefghijklmnopqrstuvwxyz" > $SCRATCH_MNT/small_vector_async
+echo "abcdefghijklmnopqrstuvwxyz" > $testdir/small_vector_async
 $XFS_IO_PROG -f -c "pread -v 0 1"\
     -c "pread -v 1 1"\
     -c "pread -v 2 1"\
@@ -186,11 +187,11 @@ $XFS_IO_PROG -f -c "pread -v 0 1"\
     -c "pread -v 10000000004 4"\
     -c "pread -v 10000000008 4"\
     -c "pread -v 10000000012 4"\
-    $SCRATCH_MNT/small_vector_async | _filter_xfs_io_unique
+    $testdir/small_vector_async | _filter_xfs_io_unique
 
 echo
 echo "Small Vector Sync"
-echo "abcdefghijklmnopqrstuvwxyz" > $SCRATCH_MNT/small_vector_async
+echo "abcdefghijklmnopqrstuvwxyz" > $testdir/small_vector_async
 $XFS_IO_PROG -f -s -c "pread -v 0 1"\
     -c "pread -v 1 1"\
     -c "pread -v 2 1"\
@@ -245,7 +246,7 @@ $XFS_IO_PROG -f -s -c "pread -v 0 1"\
     -c "pread -v 10000000004 4"\
     -c "pread -v 10000000008 4"\
     -c "pread -v 10000000012 4"\
-    $SCRATCH_MNT/small_vector_async | _filter_xfs_io_unique
+    $testdir/small_vector_async | _filter_xfs_io_unique
 
 status=0
 exit
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
