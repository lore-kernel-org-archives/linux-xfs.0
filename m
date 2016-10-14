Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40047 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753935AbcJNSNI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Oct 2016 14:13:08 -0400
Subject: [PATCH 2/3] misc: fix fallocate commands that need the unshare
 switch
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 14 Oct 2016 11:13:02 -0700
Message-ID: <147646878237.19627.11366131824882808123.stgit@birch.djwong.org>
In-Reply-To: <147646876990.19627.5046740854955682441.stgit@birch.djwong.org>
References: <147646876990.19627.5046740854955682441.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

We re-added the UNSHARE flag to fallocate, so go make sure that all
the unshare tests actually check that the xfs_io falloc command
supports that flag.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/156 |   16 ++++++----------
 tests/generic/264 |    4 ++--
 tests/xfs/132     |   12 ++++++------
 tests/xfs/184     |    3 ++-
 tests/xfs/192     |    3 ++-
 tests/xfs/200     |    3 ++-
 tests/xfs/204     |    3 ++-
 tests/xfs/344     |    1 +
 tests/xfs/345     |    1 +
 tests/xfs/346     |    1 +
 tests/xfs/347     |    1 +
 11 files changed, 26 insertions(+), 22 deletions(-)


diff --git a/tests/generic/156 b/tests/generic/156
index 9e22a02..b1b354b 100755
--- a/tests/generic/156
+++ b/tests/generic/156
@@ -54,15 +54,11 @@ _cleanup()
 . ./common/attr
 . ./common/reflink
 
-if [ $FSTYP = "btrfs" ]; then
-	_notrun "btrfs doesn't handle unshare on fallocate"
-fi
-
 # real QA test starts here
 _supported_os Linux
 _require_test_reflink
 _require_cp_reflink
-_require_xfs_io_command "falloc"
+_require_xfs_io_command "falloc" "-u"
 
 rm -f $seqres.full
 
@@ -89,18 +85,18 @@ _test_cycle_mount
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
index 7f7ebaa..6b8c05c 100755
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
index e843b4e..af416e5 100755
--- a/tests/xfs/184
+++ b/tests/xfs/184
@@ -51,6 +51,7 @@ _require_scratch_reflink
 _require_cp_reflink
 _require_fiemap
 _require_xfs_io_command "cowextsize"
+_require_xfs_io_command "falloc" "-u"
 
 rm -f $seqres.full
 
@@ -84,7 +85,7 @@ md5sum $testdir/file2 | _filter_scratch
 echo "CoW and unmount"
 $XFS_IO_PROG -f -c "cowextsize" $testdir/file2 >> $seqres.full
 $XFS_IO_PROG -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $((filesize + 1))" -c "fdatasync" $testdir/file2 >> $seqres.full
-$XFS_IO_PROG -f -c "falloc 0 $((filesize + 1))" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "falloc -u 0 $((filesize + 1))" $testdir/file2 >> $seqres.full
 _scratch_cycle_mount
 
 echo "Compare files"
diff --git a/tests/xfs/192 b/tests/xfs/192
index 01f5e1c..691b0a1 100755
--- a/tests/xfs/192
+++ b/tests/xfs/192
@@ -51,6 +51,7 @@ _require_scratch_reflink
 _require_cp_reflink
 _require_fiemap
 _require_xfs_io_command "cowextsize"
+_require_xfs_io_command "falloc" "-u"
 _require_odirect
 
 rm -f $seqres.full
@@ -85,7 +86,7 @@ md5sum $testdir/file2 | _filter_scratch
 echo "CoW and unmount"
 $XFS_IO_PROG -f -c "cowextsize" $testdir/file2 >> $seqres.full
 $XFS_IO_PROG -d -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $filesize" $testdir/file2 >> $seqres.full
-$XFS_IO_PROG -d -f -c "falloc 0 $filesize" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -d -f -c "falloc -u 0 $filesize" $testdir/file2 >> $seqres.full
 _scratch_cycle_mount
 
 echo "Compare files"
diff --git a/tests/xfs/200 b/tests/xfs/200
index ebb6e73..b9f2685 100755
--- a/tests/xfs/200
+++ b/tests/xfs/200
@@ -53,6 +53,7 @@ _require_scratch_reflink
 _require_cp_reflink
 _require_fiemap
 _require_xfs_io_command "cowextsize"
+_require_xfs_io_command "falloc" "-u"
 
 rm -f $seqres.full
 
@@ -88,7 +89,7 @@ $XFS_IO_PROG -f -c "cowextsize" $testdir/file2 >> $seqres.full
 cat $testdir/file2 > /dev/null
 $XFS_IO_PROG -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $filesize" -c "fdatasync" $testdir/file2 >> $seqres.full
 $XFS_IO_PROG -f -c "fadvise -d 0 $filesize" -c "fsync" $testdir/file2 >> $seqres.full
-$XFS_IO_PROG -f -c "falloc 0 $filesize" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "falloc -u 0 $filesize" $testdir/file2 >> $seqres.full
 _scratch_cycle_mount
 
 echo "Compare files"
diff --git a/tests/xfs/204 b/tests/xfs/204
index 6e5b896..4917fc0 100755
--- a/tests/xfs/204
+++ b/tests/xfs/204
@@ -53,6 +53,7 @@ _require_scratch_reflink
 _require_cp_reflink
 _require_fiemap
 _require_xfs_io_command "cowextsize"
+_require_xfs_io_command "falloc" "-u"
 _require_odirect
 
 rm -f $seqres.full
@@ -89,7 +90,7 @@ $XFS_IO_PROG -f -c "cowextsize" $testdir/file2 >> $seqres.full
 cat $testdir/file2 > /dev/null
 $XFS_IO_PROG -d -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $filesize" -c "fdatasync" $testdir/file2 >> $seqres.full
 $XFS_IO_PROG -f -c "fadvise -d 0 $filesize" -c "fsync" $testdir/file2 >> $seqres.full
-$XFS_IO_PROG -f -c "falloc 0 $filesize" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "falloc -u 0 $filesize" $testdir/file2 >> $seqres.full
 _scratch_cycle_mount
 
 echo "Compare files"
diff --git a/tests/xfs/344 b/tests/xfs/344
index 25bff1a..8b2f6a5 100755
--- a/tests/xfs/344
+++ b/tests/xfs/344
@@ -51,6 +51,7 @@ _require_scratch_reflink
 _require_cp_reflink
 _require_fiemap
 _require_xfs_io_command "cowextsize"
+_require_xfs_io_command "falloc" "-u"
 _require_odirect
 
 rm -f $seqres.full
diff --git a/tests/xfs/345 b/tests/xfs/345
index edb4443..1bb1db3 100755
--- a/tests/xfs/345
+++ b/tests/xfs/345
@@ -50,6 +50,7 @@ _require_scratch_reflink
 _require_cp_reflink
 _require_fiemap
 _require_xfs_io_command "cowextsize"
+_require_xfs_io_command "falloc" "-u"
 
 rm -f $seqres.full
 
diff --git a/tests/xfs/346 b/tests/xfs/346
index d0463eb..17c1050 100755
--- a/tests/xfs/346
+++ b/tests/xfs/346
@@ -51,6 +51,7 @@ _require_scratch_reflink
 _require_cp_reflink
 _require_fiemap
 _require_xfs_io_command "cowextsize"
+_require_xfs_io_command "falloc" "-u"
 _require_odirect
 
 rm -f $seqres.full
diff --git a/tests/xfs/347 b/tests/xfs/347
index 1578216..94898e7 100755
--- a/tests/xfs/347
+++ b/tests/xfs/347
@@ -51,6 +51,7 @@ _require_scratch_reflink
 _require_cp_reflink
 _require_fiemap
 _require_xfs_io_command "cowextsize"
+_require_xfs_io_command "falloc" "-u"
 
 rm -f $seqres.full
 

