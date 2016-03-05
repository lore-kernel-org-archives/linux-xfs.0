Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 87B9329E09
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 18:38:39 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4CD248F8033
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 16:38:39 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id pGMpp7A86FrK8sPr (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2016 16:38:37 -0800 (PST)
Subject: [PATCH 11/12] xfs: remove NOCOW_FL testing from test
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Mar 2016 16:38:30 -0800
Message-ID: <20160305003830.28738.38711.stgit@birch.djwong.org>
In-Reply-To: <20160305003717.28738.98818.stgit@birch.djwong.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
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
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Since XFS dropped support for the NOCOW_FL flag, cut it out of the tests.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/132     |    5 -----
 tests/xfs/132.out |   20 --------------------
 2 files changed, 25 deletions(-)


diff --git a/tests/xfs/132 b/tests/xfs/132
index f174b3f..b09ccb6 100755
--- a/tests/xfs/132
+++ b/tests/xfs/132
@@ -88,32 +88,27 @@ for i in `seq 2 $nr`; do
 done
 _test_cycle_mount
 free_blocks1=$(stat -f $testdir -c '%f')
-lsattr -l $testdir/ | _filter_test_dir | _filter_spaces
 
 echo "funshare part of a file"
 $XFS_IO_PROG -f -c "falloc 0 $((sz / 2))" $testdir/file2
 _test_cycle_mount
-lsattr -l $testdir/ | _filter_test_dir | _filter_spaces
 
 echo "funshare some of the copies"
 $XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file2
 $XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file3
 _test_cycle_mount
 free_blocks2=$(stat -f $testdir -c '%f')
-lsattr -l $testdir/ | _filter_test_dir | _filter_spaces
 
 echo "funshare the rest of the files"
 $XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file4
 $XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file1
 _test_cycle_mount
 free_blocks3=$(stat -f $testdir -c '%f')
-lsattr -l $testdir/ | _filter_test_dir | _filter_spaces
 
 echo "Rewrite the original file"
 _pwrite_byte 0x65 0 $sz $testdir/file1 >> $seqres.full
 _test_cycle_mount
 free_blocks4=$(stat -f $testdir -c '%f')
-lsattr -l $testdir/ | _filter_test_dir | _filter_spaces
 #echo $free_blocks0 $free_blocks1 $free_blocks2 $free_blocks3 $free_blocks4
 
 _within_tolerance "free blocks after reflinking" $free_blocks1 $((free_blocks0 - blks)) $margin -v
diff --git a/tests/xfs/132.out b/tests/xfs/132.out
index f32db7d..3d1281c 100644
--- a/tests/xfs/132.out
+++ b/tests/xfs/132.out
@@ -1,30 +1,10 @@
 QA output created by 132
 Create the original file blocks
 Create the reflink copies
-TEST_DIR/test-132/file1 ---
-TEST_DIR/test-132/file2 ---
-TEST_DIR/test-132/file3 ---
-TEST_DIR/test-132/file4 ---
 funshare part of a file
-TEST_DIR/test-132/file1 ---
-TEST_DIR/test-132/file2 ---
-TEST_DIR/test-132/file3 ---
-TEST_DIR/test-132/file4 ---
 funshare some of the copies
-TEST_DIR/test-132/file1 ---
-TEST_DIR/test-132/file2 No_COW
-TEST_DIR/test-132/file3 No_COW
-TEST_DIR/test-132/file4 ---
 funshare the rest of the files
-TEST_DIR/test-132/file1 No_COW
-TEST_DIR/test-132/file2 No_COW
-TEST_DIR/test-132/file3 No_COW
-TEST_DIR/test-132/file4 No_COW
 Rewrite the original file
-TEST_DIR/test-132/file1 No_COW
-TEST_DIR/test-132/file2 No_COW
-TEST_DIR/test-132/file3 No_COW
-TEST_DIR/test-132/file4 No_COW
 free blocks after reflinking is in range
 free blocks after nocow'ing some copies is in range
 free blocks after nocow'ing all copies is in range

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
