Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BA7A87FF3
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 01:36:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 31FB3AC003
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 23:36:29 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id bsbkqJMpwqNzbfNU (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 23:36:28 -0800 (PST)
Message-Id: <20131211073627.430108854@bombadil.infradead.org>
Date: Tue, 10 Dec 2013 23:34:54 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 09/12] 132: use TEST_DIR instead of a SCRATCH_DEV
References: <20131211073445.353655850@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0009-132-use-TEST_DIR-instead-of-a-SCRATCH_DEV.patch
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
 tests/generic/132 |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/tests/generic/132 b/tests/generic/132
index aa52c7d..3053e67 100755
--- a/tests/generic/132
+++ b/tests/generic/132
@@ -40,10 +40,9 @@ trap "exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux IRIX
 
-_require_scratch
-
-_scratch_mkfs >/dev/null 2>&1
-_scratch_mount
+testdir="$TEST_DIR/dir.$seq"
+rm -rf $testdir
+mkdir $testdir
 
 $XFS_IO_PROG -f -t -c "pwrite -S 0x63 0 512" \
     -c "pwrite -S 0x64 512 512" \
@@ -61,7 +60,7 @@ $XFS_IO_PROG -f -t -c "pwrite -S 0x63 0 512" \
     -c "pread -v 2560 512" \
     -c "pread -v 3072 512" \
     -c "pread -v 3584 512" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
+    $testdir/aligned_vector_rw | _filter_xfs_io_unique
 
 $XFS_IO_PROG -f -c "pwrite -S 0x63 4096 1024" \
     -c "pwrite -S 0x6B 5120 1024" \
@@ -75,7 +74,7 @@ $XFS_IO_PROG -f -c "pwrite -S 0x63 4096 1024" \
     -c "pread -v 5120 1024" \
     -c "pread -v 6144 1024" \
     -c "pread -v 7168 1024" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
+    $testdir/aligned_vector_rw | _filter_xfs_io_unique
 
 $XFS_IO_PROG -f -c "pwrite -S 0x6E 8192 2048" \
     -c "pwrite -S 0x6F 10240 2048" \
@@ -85,14 +84,14 @@ $XFS_IO_PROG -f -c "pwrite -S 0x6E 8192 2048" \
     -c "pread -v 6144 2048" \
     -c "pread -v 8192 2048" \
     -c "pread -v 10240 2048" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
+    $testdir/aligned_vector_rw | _filter_xfs_io_unique
 
 $XFS_IO_PROG -f -c "pwrite -S 0x70 12288 4096" \
     -c "pread -v 0 4096" \
     -c "pread -v 4096 4096" \
     -c "pread -v 8192 4096" \
     -c "pread -v 12288 4096" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
+    $testdir/aligned_vector_rw | _filter_xfs_io_unique
 
 $XFS_IO_PROG -f -c "pwrite -S 0x71 16384 8192" \
     -c "pwrite -S 0x72 24576 8192" \
@@ -100,7 +99,7 @@ $XFS_IO_PROG -f -c "pwrite -S 0x71 16384 8192" \
     -c "pread -v 8192 8192" \
     -c "pread -v 8192 8192" \
     -c "pread -v 16384 8192" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
+    $testdir/aligned_vector_rw | _filter_xfs_io_unique
 
 $XFS_IO_PROG -f -c "pwrite -S 0x73 32768 16384" \
     -c "pwrite -S 0x74 49152 16384" \
@@ -108,7 +107,7 @@ $XFS_IO_PROG -f -c "pwrite -S 0x73 32768 16384" \
     -c "pread -v 16384 16384" \
     -c "pread -v 32768 16384" \
     -c "pread -v 49152 16384" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
+    $testdir/aligned_vector_rw | _filter_xfs_io_unique
 
 $XFS_IO_PROG -f -c "pwrite -S 0x75 65536 32768" \
     -c "pwrite -S 0x76 98304 32768" \
@@ -116,7 +115,7 @@ $XFS_IO_PROG -f -c "pwrite -S 0x75 65536 32768" \
     -c "pread -v 32768 32768" \
     -c "pread -v 65536 32768" \
     -c "pread -v 98304 32768" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
+    $testdir/aligned_vector_rw | _filter_xfs_io_unique
 
 $XFS_IO_PROG -f -c "pwrite -S 0x76 131072 65536" \
     -c "pwrite -S 0x77 196608 65536" \
@@ -124,7 +123,7 @@ $XFS_IO_PROG -f -c "pwrite -S 0x76 131072 65536" \
     -c "pread -v 65536 65536" \
     -c "pread -v 131072 65536" \
     -c "pread -v 196608 65536" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
+    $testdir/aligned_vector_rw | _filter_xfs_io_unique
 
 $XFS_IO_PROG -f -c "pwrite -S 0x76 262144 131072" \
     -c "pwrite -S 0x77 393216 131072" \
@@ -132,14 +131,14 @@ $XFS_IO_PROG -f -c "pwrite -S 0x76 262144 131072" \
     -c "pread -v 131072 131072" \
     -c "pread -v 262144 131072" \
     -c "pread -v 393216 131072" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
+    $testdir/aligned_vector_rw | _filter_xfs_io_unique
 
 $XFS_IO_PROG -f -c "pwrite -S 0x76 524288 524288" \
     -c "pwrite -S 0x77 1048576 524288" \
     -c "pread -v 0 524288" \
     -c "pread -v 524288 524288" \
     -c "pread -v 1048576 524288" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
+    $testdir/aligned_vector_rw | _filter_xfs_io_unique
 
 $XFS_IO_PROG -f -c "pwrite -S 0x32 1048576 1048576" \
     -c "pwrite -S 0x33 2097152 1048576" \
@@ -158,7 +157,7 @@ $XFS_IO_PROG -f -c "pwrite -S 0x32 1048576 1048576" \
     -c "pread -v 6291456 1048576" \
     -c "pread -v 7340032 1048576" \
     -c "pread -v 8388608 1048576" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
+    $testdir/aligned_vector_rw | _filter_xfs_io_unique
 
 $XFS_IO_PROG -f -c "pwrite -S 0x32 1048576 1048576" \
     -c "pwrite -S 0x33 2097152 1048576" \
@@ -179,7 +178,7 @@ $XFS_IO_PROG -f -c "pwrite -S 0x32 1048576 1048576" \
     -c "pread -v 7340032 1048576" \
     -c "pread -v 8388608 1048576" \
     -c "pread -v 9437184 1048576" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
+    $testdir/aligned_vector_rw | _filter_xfs_io_unique
 
 $XFS_IO_PROG -f -c "pwrite -S 0x92 10485760 10485760" \
     -c "pwrite -S 0x93 20971520 10485760" \
@@ -200,7 +199,7 @@ $XFS_IO_PROG -f -c "pwrite -S 0x92 10485760 10485760" \
     -c "pread -v 73400320 10485760" \
     -c "pread -v 83886080 10485760" \
     -c "pread -v 94371840 10485760" \
-    $SCRATCH_MNT/aligned_vector_rw | _filter_xfs_io_unique
+    $testdir/aligned_vector_rw | _filter_xfs_io_unique
 
 status=0
 exit
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
