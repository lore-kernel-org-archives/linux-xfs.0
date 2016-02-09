Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CE3327CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 19:12:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5279CAC004
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 17:12:09 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id c3T3mTJMt2DxCPOk (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 17:12:07 -0800 (PST)
Subject: [PATCH 02/23] xfstests: filter whitespace in 128 and 132
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 08 Feb 2016 17:11:58 -0800
Message-ID: <20160209011158.23099.47980.stgit@birch.djwong.org>
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

Seems either I have a different lsattr version, or different mount points
cause differences in the golden output.  Send the lsattr output through
the whitespaces filter so that it works everywhere.

The lsattr output /does/ change depending on mountpoints.  Ick.  I'd
actually changed it to the long format output because line length in
the short format changes every time the flags change.

Signed-off-by: Christoph Hellwig <hch@lst.de>
[darrick.wong@oracle.com: update changelog]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/128     |    2 +-
 tests/xfs/128.out |    8 ++++----
 tests/xfs/132     |   10 +++++-----
 tests/xfs/132.out |   40 ++++++++++++++++++++--------------------
 4 files changed, 30 insertions(+), 30 deletions(-)


diff --git a/tests/xfs/128 b/tests/xfs/128
index a96291a..c9547fb 100755
--- a/tests/xfs/128
+++ b/tests/xfs/128
@@ -97,7 +97,7 @@ c13=$(_md5_checksum "$testdir/file3")
 c14=$(_md5_checksum "$testdir/file4")
 
 echo "Defragment"
-lsattr -l "$testdir/" | _filter_scratch
+lsattr -l "$testdir/" | _filter_scratch | _filter_spaces
 xfs_fsr -v -d "$testdir/file1" >> "$seqres.full"
 xfs_fsr -v -d "$testdir/file2" >> "$seqres.full" # fsr probably breaks the link
 xfs_fsr -v -d "$testdir/file3" >> "$seqres.full" # fsr probably breaks the link
diff --git a/tests/xfs/128.out b/tests/xfs/128.out
index 7e72dcd..0ac06db 100644
--- a/tests/xfs/128.out
+++ b/tests/xfs/128.out
@@ -11,10 +11,10 @@ c650f1cf6c9f07b22e3e21ec7d49ded5  SCRATCH_MNT/test-128/file2
 56ed2f712c91e035adeeb26ed105a982  SCRATCH_MNT/test-128/file3
 b81534f439aac5c34ce3ed60a03eba70  SCRATCH_MNT/test-128/file4
 Defragment
-SCRATCH_MNT/test-128/file1          ---
-SCRATCH_MNT/test-128/file2          ---
-SCRATCH_MNT/test-128/file3          ---
-SCRATCH_MNT/test-128/file4          ---
+SCRATCH_MNT/test-128/file1 ---
+SCRATCH_MNT/test-128/file2 ---
+SCRATCH_MNT/test-128/file3 ---
+SCRATCH_MNT/test-128/file4 ---
 b81534f439aac5c34ce3ed60a03eba70  SCRATCH_MNT/test-128/file1
 c650f1cf6c9f07b22e3e21ec7d49ded5  SCRATCH_MNT/test-128/file2
 56ed2f712c91e035adeeb26ed105a982  SCRATCH_MNT/test-128/file3
diff --git a/tests/xfs/132 b/tests/xfs/132
index 79a6d57..9c57c3b 100755
--- a/tests/xfs/132
+++ b/tests/xfs/132
@@ -87,32 +87,32 @@ for i in `seq 2 $nr`; do
 done
 _test_remount
 free_blocks1=$(stat -f "$testdir" -c '%f')
-lsattr -l $testdir/ | _filter_test_dir
+lsattr -l $testdir/ | _filter_test_dir | _filter_spaces
 
 echo "funshare part of a file"
 "$XFS_IO_PROG" -f -c "falloc 0 $((sz / 2))" "$testdir/file2"
 _test_remount
-lsattr -l $testdir/ | _filter_test_dir
+lsattr -l $testdir/ | _filter_test_dir | _filter_spaces
 
 echo "funshare some of the copies"
 "$XFS_IO_PROG" -f -c "falloc 0 $sz" "$testdir/file2"
 "$XFS_IO_PROG" -f -c "falloc 0 $sz" "$testdir/file3"
 _test_remount
 free_blocks2=$(stat -f "$testdir" -c '%f')
-lsattr -l $testdir/ | _filter_test_dir
+lsattr -l $testdir/ | _filter_test_dir | _filter_spaces
 
 echo "funshare the rest of the files"
 "$XFS_IO_PROG" -f -c "falloc 0 $sz" "$testdir/file4"
 "$XFS_IO_PROG" -f -c "falloc 0 $sz" "$testdir/file1"
 _test_remount
 free_blocks3=$(stat -f "$testdir" -c '%f')
-lsattr -l $testdir/ | _filter_test_dir
+lsattr -l $testdir/ | _filter_test_dir | _filter_spaces
 
 echo "Rewrite the original file"
 _pwrite_byte 0x65 0 $sz "$testdir/file1" >> "$seqres.full"
 _test_remount
 free_blocks4=$(stat -f "$testdir" -c '%f')
-lsattr -l $testdir/ | _filter_test_dir
+lsattr -l $testdir/ | _filter_test_dir | _filter_spaces
 #echo $free_blocks0 $free_blocks1 $free_blocks2 $free_blocks3 $free_blocks4
 
 _within_tolerance "free blocks after reflinking" $free_blocks1 $((free_blocks0 - blks)) $margin -v
diff --git a/tests/xfs/132.out b/tests/xfs/132.out
index fd2b7bd..f32db7d 100644
--- a/tests/xfs/132.out
+++ b/tests/xfs/132.out
@@ -1,30 +1,30 @@
 QA output created by 132
 Create the original file blocks
 Create the reflink copies
-TEST_DIR/test-132/file1          ---
-TEST_DIR/test-132/file2          ---
-TEST_DIR/test-132/file3          ---
-TEST_DIR/test-132/file4          ---
+TEST_DIR/test-132/file1 ---
+TEST_DIR/test-132/file2 ---
+TEST_DIR/test-132/file3 ---
+TEST_DIR/test-132/file4 ---
 funshare part of a file
-TEST_DIR/test-132/file1          ---
-TEST_DIR/test-132/file2          ---
-TEST_DIR/test-132/file3          ---
-TEST_DIR/test-132/file4          ---
+TEST_DIR/test-132/file1 ---
+TEST_DIR/test-132/file2 ---
+TEST_DIR/test-132/file3 ---
+TEST_DIR/test-132/file4 ---
 funshare some of the copies
-TEST_DIR/test-132/file1          ---
-TEST_DIR/test-132/file2          No_COW
-TEST_DIR/test-132/file3          No_COW
-TEST_DIR/test-132/file4          ---
+TEST_DIR/test-132/file1 ---
+TEST_DIR/test-132/file2 No_COW
+TEST_DIR/test-132/file3 No_COW
+TEST_DIR/test-132/file4 ---
 funshare the rest of the files
-TEST_DIR/test-132/file1          No_COW
-TEST_DIR/test-132/file2          No_COW
-TEST_DIR/test-132/file3          No_COW
-TEST_DIR/test-132/file4          No_COW
+TEST_DIR/test-132/file1 No_COW
+TEST_DIR/test-132/file2 No_COW
+TEST_DIR/test-132/file3 No_COW
+TEST_DIR/test-132/file4 No_COW
 Rewrite the original file
-TEST_DIR/test-132/file1          No_COW
-TEST_DIR/test-132/file2          No_COW
-TEST_DIR/test-132/file3          No_COW
-TEST_DIR/test-132/file4          No_COW
+TEST_DIR/test-132/file1 No_COW
+TEST_DIR/test-132/file2 No_COW
+TEST_DIR/test-132/file3 No_COW
+TEST_DIR/test-132/file4 No_COW
 free blocks after reflinking is in range
 free blocks after nocow'ing some copies is in range
 free blocks after nocow'ing all copies is in range

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
