Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37079 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755752AbcI3CXd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 22:23:33 -0400
Subject: [PATCH 4/9] misc: fix fallocate commands that need the unshare
 switch
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 19:23:28 -0700
Message-ID: <147520220822.26891.4328794307942674258.stgit@birch.djwong.org>
In-Reply-To: <147520218309.26891.10856487889060965097.stgit@birch.djwong.org>
References: <147520218309.26891.10856487889060965097.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/156 |   12 ++++++------
 tests/generic/264 |    4 ++--
 tests/xfs/132     |   12 ++++++------
 tests/xfs/184     |    2 +-
 tests/xfs/192     |    2 +-
 tests/xfs/200     |    2 +-
 tests/xfs/204     |    2 +-
 7 files changed, 18 insertions(+), 18 deletions(-)


diff --git a/tests/generic/156 b/tests/generic/156
index 52ac11f..7bfe7d8 100755
--- a/tests/generic/156
+++ b/tests/generic/156
@@ -62,7 +62,7 @@ fi
 _supported_os Linux
 _require_test_reflink
 _require_cp_reflink
-_require_xfs_io_command "falloc"
+_require_xfs_io_command "falloc" "-u"
 
 rm -f $seqres.full
 
@@ -89,18 +89,18 @@ _test_cycle_mount
 free_blocks1=$(stat -f $testdir -c '%f')
 
 echo "funshare part of a file"
-$XFS_IO_PROG -f -c "falloc 0 $((sz / 2))" $testdir/file2
+$XFS_IO_PROG -f -c "falloc -u 0 $((sz / 2))" $testdir/file2
 _test_cycle_mount
 
 echo "funshare some of the copies"
-$XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file2
-$XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file3
+$XFS_IO_PROG -f -c "falloc -u 0 $sz" $testdir/file2
+$XFS_IO_PROG -f -c "falloc -u 0 $sz" $testdir/file3
 _test_cycle_mount
 free_blocks2=$(stat -f $testdir -c '%f')
 
 echo "funshare the rest of the files"
-$XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file4
-$XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file1
+$XFS_IO_PROG -f -c "falloc -u 0 $sz" $testdir/file4
+$XFS_IO_PROG -f -c "falloc -u 0 $sz" $testdir/file1
 _test_cycle_mount
 free_blocks3=$(stat -f $testdir -c '%f')
 
diff --git a/tests/generic/264 b/tests/generic/264
index 631184c..bc2f7e6 100755
--- a/tests/generic/264
+++ b/tests/generic/264
@@ -47,7 +47,7 @@ _cleanup()
 _supported_os Linux
 _require_scratch_reflink
 _require_cp_reflink
-_require_xfs_io_command "falloc"
+_require_xfs_io_command "falloc" "-u"
 
 rm -f $seqres.full
 
@@ -75,7 +75,7 @@ md5sum $testdir/file2 | _filter_scratch
 md5sum $testdir/file2.chk | _filter_scratch
 
 echo "CoW and unmount"
-$XFS_IO_PROG -f -c "pwrite -S 0x62 -b $((blksz * 3)) $blksz $((blksz * 3))" -c "falloc $((blksz * 2)) $blksz" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 -b $((blksz * 3)) $blksz $((blksz * 3))" -c "falloc -u $((blksz * 2)) $blksz" $testdir/file2 >> $seqres.full
 _scratch_cycle_mount
 $XFS_IO_PROG -f -c "pwrite -S 0x62 -b $((blksz * 3)) $blksz $((blksz * 3))" $testdir/file2.chk >> $seqres.full
 _scratch_cycle_mount
diff --git a/tests/xfs/132 b/tests/xfs/132
index b09ccb6..5abcf30 100755
--- a/tests/xfs/132
+++ b/tests/xfs/132
@@ -63,7 +63,7 @@ _supported_os Linux
 _require_test_reflink
 _require_test_lsattr
 _require_cp_reflink
-_require_xfs_io_command "falloc"
+_require_xfs_io_command "falloc" "-u"
 
 rm -f $seqres.full
 
@@ -90,18 +90,18 @@ _test_cycle_mount
 free_blocks1=$(stat -f $testdir -c '%f')
 
 echo "funshare part of a file"
-$XFS_IO_PROG -f -c "falloc 0 $((sz / 2))" $testdir/file2
+$XFS_IO_PROG -f -c "falloc -u 0 $((sz / 2))" $testdir/file2
 _test_cycle_mount
 
 echo "funshare some of the copies"
-$XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file2
-$XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file3
+$XFS_IO_PROG -f -c "falloc -u 0 $sz" $testdir/file2
+$XFS_IO_PROG -f -c "falloc -u 0 $sz" $testdir/file3
 _test_cycle_mount
 free_blocks2=$(stat -f $testdir -c '%f')
 
 echo "funshare the rest of the files"
-$XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file4
-$XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file1
+$XFS_IO_PROG -f -c "falloc -u 0 $sz" $testdir/file4
+$XFS_IO_PROG -f -c "falloc -u 0 $sz" $testdir/file1
 _test_cycle_mount
 free_blocks3=$(stat -f $testdir -c '%f')
 
diff --git a/tests/xfs/184 b/tests/xfs/184
index 6d32e93..01c04c3 100755
--- a/tests/xfs/184
+++ b/tests/xfs/184
@@ -84,7 +84,7 @@ md5sum $testdir/file2 | _filter_scratch
 echo "CoW and unmount"
 $XFS_IO_PROG -f -c "cowextsize" $testdir/file2 >> $seqres.full
 $XFS_IO_PROG -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $((filesize + 1))" -c "fdatasync" $testdir/file2 >> $seqres.full
-$XFS_IO_PROG -f -c "falloc 0 $((filesize + 1))" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "falloc -u 0 $((filesize + 1))" $testdir/file2 >> $seqres.full
 _scratch_cycle_mount
 
 echo "Compare files"
diff --git a/tests/xfs/192 b/tests/xfs/192
index 8594787..244a2ec 100755
--- a/tests/xfs/192
+++ b/tests/xfs/192
@@ -85,7 +85,7 @@ md5sum $testdir/file2 | _filter_scratch
 echo "CoW and unmount"
 $XFS_IO_PROG -f -c "cowextsize" $testdir/file2 >> $seqres.full
 $XFS_IO_PROG -d -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $filesize" $testdir/file2 >> $seqres.full
-$XFS_IO_PROG -d -f -c "falloc 0 $filesize" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -d -f -c "falloc -u 0 $filesize" $testdir/file2 >> $seqres.full
 _scratch_cycle_mount
 
 echo "Compare files"
diff --git a/tests/xfs/200 b/tests/xfs/200
index a750ef6..92823b5 100755
--- a/tests/xfs/200
+++ b/tests/xfs/200
@@ -88,7 +88,7 @@ $XFS_IO_PROG -f -c "cowextsize" $testdir/file2 >> $seqres.full
 cat $testdir/file2 > /dev/null
 $XFS_IO_PROG -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $filesize" -c "fdatasync" $testdir/file2 >> $seqres.full
 $XFS_IO_PROG -f -c "fadvise -d 0 $filesize" -c "fsync" $testdir/file2 >> $seqres.full
-$XFS_IO_PROG -f -c "falloc 0 $filesize" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "falloc -u 0 $filesize" $testdir/file2 >> $seqres.full
 _scratch_cycle_mount
 
 echo "Compare files"
diff --git a/tests/xfs/204 b/tests/xfs/204
index ae21d6e..cc1683b 100755
--- a/tests/xfs/204
+++ b/tests/xfs/204
@@ -89,7 +89,7 @@ $XFS_IO_PROG -f -c "cowextsize" $testdir/file2 >> $seqres.full
 cat $testdir/file2 > /dev/null
 $XFS_IO_PROG -d -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $filesize" -c "fdatasync" $testdir/file2 >> $seqres.full
 $XFS_IO_PROG -f -c "fadvise -d 0 $filesize" -c "fsync" $testdir/file2 >> $seqres.full
-$XFS_IO_PROG -f -c "falloc 0 $filesize" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "falloc -u 0 $filesize" $testdir/file2 >> $seqres.full
 _scratch_cycle_mount
 
 echo "Compare files"

