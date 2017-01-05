Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42134 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761556AbdAEBFI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jan 2017 20:05:08 -0500
Subject: [PATCH 4/7] reflink: fix quota tests to work properly
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 04 Jan 2017 17:05:01 -0800
Message-ID: <148357830178.7677.13949115107817848755.stgit@birch.djwong.org>
In-Reply-To: <148357827617.7677.15595044775254927245.stgit@birch.djwong.org>
References: <148357827617.7677.15595044775254927245.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Fix the reflink quota tests to su to the fsgqa user so that we actually
test enforcement of quotas.  Seems that XFS enforces user quotas even
if root is writing to a user file, whereas everything else lets root
writes through.  Also clean up some of the variable usage and
_require_user.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: Refactor the quota block reporting into a helper function and
port all the existing tests.  Fix "fsgqa"/$qa_user usage too.
---
 common/quota          |   10 ++++++++++
 tests/generic/305     |   22 ++++++++++------------
 tests/generic/305.out |   30 +++++++++++++++---------------
 tests/generic/326     |   22 ++++++++++------------
 tests/generic/326.out |   30 +++++++++++++++---------------
 tests/generic/327     |   19 +++++++++----------
 tests/generic/327.out |   12 ++++++------
 tests/generic/328     |   29 ++++++++++++++---------------
 tests/generic/328.out |   28 ++++++++++++++--------------
 tests/xfs/213         |   22 ++++++++++------------
 tests/xfs/213.out     |   30 +++++++++++++++---------------
 tests/xfs/214         |   22 ++++++++++------------
 tests/xfs/214.out     |   30 +++++++++++++++---------------
 13 files changed, 153 insertions(+), 153 deletions(-)


diff --git a/common/quota b/common/quota
index d4ae861..5c6e680 100644
--- a/common/quota
+++ b/common/quota
@@ -302,5 +302,15 @@ _check_quota_usage()
 	}
 }
 
+# Report the block usage of root, $qa_user, and nobody
+_report_quota_blocks() {
+	repquota $SCRATCH_MNT | egrep "^($qa_user|root|nobody)" | awk '{print $1, $3, $4, $5}'
+}
+
+# Report the inode usage of root, $qa_user, and nobody
+_report_quota_inodes() {
+	repquota $SCRATCH_MNT | egrep "^($qa_user|root|nobody)" | awk '{print $1, $6, $7, $8}'
+}
+
 # make sure this script returns success
 /bin/true
diff --git a/tests/generic/305 b/tests/generic/305
index d73d87f..f0799eb 100755
--- a/tests/generic/305
+++ b/tests/generic/305
@@ -49,10 +49,8 @@ _require_cp_reflink
 _require_fiemap
 _require_quota
 _require_nobody
+_require_user
 
-_repquota() {
-	repquota $SCRATCH_MNT | egrep '^(fsgqa|root|nobody)'
-}
 rm -f $seqres.full
 
 echo "Format and mount"
@@ -73,27 +71,27 @@ _cp_reflink $testdir/file1 $testdir/file3 >> $seqres.full
 touch $testdir/urk
 chown nobody $testdir/urk
 touch $testdir/erk
-chown fsgqa $testdir/erk
-_repquota
+chown $qa_user $testdir/erk
+_report_quota_blocks
 _scratch_cycle_mount
 
 echo "Change file ownership"
-chown fsgqa $testdir/file1
-chown fsgqa $testdir/file2
-chown fsgqa $testdir/file3
-_repquota
+chown $qa_user $testdir/file1
+chown $qa_user $testdir/file2
+chown $qa_user $testdir/file3
+_report_quota_blocks
 
 echo "CoW one of the files"
 $XFS_IO_PROG -f -c "pwrite -S 0x63 -b $((sz/2)) 0 $((sz/2))" -c "fsync" $testdir/file2 >> $seqres.full
-_repquota
+_report_quota_blocks
 
 echo "Remount the FS to see if accounting changes"
 _scratch_cycle_mount
-_repquota
+_report_quota_blocks
 
 echo "Chown one of the files"
 chown nobody $testdir/file3
-_repquota
+_report_quota_blocks
 
 # success, all done
 status=0
diff --git a/tests/generic/305.out b/tests/generic/305.out
index 0bfd620..fbd4e24 100644
--- a/tests/generic/305.out
+++ b/tests/generic/305.out
@@ -1,22 +1,22 @@
 QA output created by 305
 Format and mount
 Create the original files
-root      --    3072       0       0              7     0     0       
-nobody    --       0       0       0              1     0     0       
-fsgqa     --       0       0       0              1     0     0       
+root 3072 0 0
+nobody 0 0 0
+fsgqa 0 0 0
 Change file ownership
-root      --       0       0       0              4     0     0       
-nobody    --       0       0       0              1     0     0       
-fsgqa     --    3072       0       0              4     0     0       
+root 0 0 0
+nobody 0 0 0
+fsgqa 3072 0 0
 CoW one of the files
-root      --       0       0       0              4     0     0       
-nobody    --       0       0       0              1     0     0       
-fsgqa     --    3072       0       0              4     0     0       
+root 0 0 0
+nobody 0 0 0
+fsgqa 3072 0 0
 Remount the FS to see if accounting changes
-root      --       0       0       0              4     0     0       
-nobody    --       0       0       0              1     0     0       
-fsgqa     --    3072       0       0              4     0     0       
+root 0 0 0
+nobody 0 0 0
+fsgqa 3072 0 0
 Chown one of the files
-root      --       0       0       0              4     0     0       
-nobody    --    1024       0       0              2     0     0       
-fsgqa     --    2048       0       0              3     0     0       
+root 0 0 0
+nobody 1024 0 0
+fsgqa 2048 0 0
diff --git a/tests/generic/326 b/tests/generic/326
index 8afc6a2..a41e0cf 100755
--- a/tests/generic/326
+++ b/tests/generic/326
@@ -50,10 +50,8 @@ _require_fiemap
 _require_quota
 _require_nobody
 _require_odirect
+_require_user
 
-_repquota() {
-	repquota $SCRATCH_MNT | egrep '^(fsgqa|root|nobody)'
-}
 rm -f $seqres.full
 
 echo "Format and mount"
@@ -74,27 +72,27 @@ _cp_reflink $testdir/file1 $testdir/file3 >> $seqres.full
 touch $testdir/urk
 chown nobody $testdir/urk
 touch $testdir/erk
-chown fsgqa $testdir/erk
-_repquota
+chown $qa_user $testdir/erk
+_report_quota_blocks
 _scratch_cycle_mount
 
 echo "Change file ownership"
-chown fsgqa $testdir/file1
-chown fsgqa $testdir/file2
-chown fsgqa $testdir/file3
-_repquota
+chown $qa_user $testdir/file1
+chown $qa_user $testdir/file2
+chown $qa_user $testdir/file3
+_report_quota_blocks
 
 echo "CoW one of the files"
 $XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $((sz/2)) 0 $((sz/2))" -c "fsync" $testdir/file2 >> $seqres.full
-_repquota
+_report_quota_blocks
 
 echo "Remount the FS to see if accounting changes"
 _scratch_cycle_mount
-_repquota
+_report_quota_blocks
 
 echo "Chown one of the files"
 chown nobody $testdir/file3
-_repquota
+_report_quota_blocks
 
 # success, all done
 status=0
diff --git a/tests/generic/326.out b/tests/generic/326.out
index e771eb7..de7f20b 100644
--- a/tests/generic/326.out
+++ b/tests/generic/326.out
@@ -1,22 +1,22 @@
 QA output created by 326
 Format and mount
 Create the original files
-root      --    3072       0       0              7     0     0       
-nobody    --       0       0       0              1     0     0       
-fsgqa     --       0       0       0              1     0     0       
+root 3072 0 0
+nobody 0 0 0
+fsgqa 0 0 0
 Change file ownership
-root      --       0       0       0              4     0     0       
-nobody    --       0       0       0              1     0     0       
-fsgqa     --    3072       0       0              4     0     0       
+root 0 0 0
+nobody 0 0 0
+fsgqa 3072 0 0
 CoW one of the files
-root      --       0       0       0              4     0     0       
-nobody    --       0       0       0              1     0     0       
-fsgqa     --    3072       0       0              4     0     0       
+root 0 0 0
+nobody 0 0 0
+fsgqa 3072 0 0
 Remount the FS to see if accounting changes
-root      --       0       0       0              4     0     0       
-nobody    --       0       0       0              1     0     0       
-fsgqa     --    3072       0       0              4     0     0       
+root 0 0 0
+nobody 0 0 0
+fsgqa 3072 0 0
 Chown one of the files
-root      --       0       0       0              4     0     0       
-nobody    --    1024       0       0              2     0     0       
-fsgqa     --    2048       0       0              3     0     0       
+root 0 0 0
+nobody 1024 0 0
+fsgqa 2048 0 0
diff --git a/tests/generic/327 b/tests/generic/327
index c165ad5..2f132fe 100755
--- a/tests/generic/327
+++ b/tests/generic/327
@@ -48,10 +48,8 @@ _require_cp_reflink
 _require_fiemap
 _require_quota
 _require_nobody
+_require_user
 
-_repquota() {
-	repquota $SCRATCH_MNT | egrep '^(fsgqa|root|nobody)'
-}
 rm -f $seqres.full
 
 echo "Format and mount"
@@ -67,20 +65,21 @@ mkdir $testdir
 sz=1048576
 echo "Create the original files"
 $XFS_IO_PROG -f -c "pwrite -S 0x61 -b $sz 0 $sz" $testdir/file1 >> $seqres.full
-chown fsgqa $testdir/file1
+chown $qa_user $testdir/file1
 _cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
-_repquota
+_report_quota_blocks
 _scratch_cycle_mount
+quotaon $SCRATCH_MNT 2> /dev/null
 
 echo "Set hard quota to prevent third reflink"
-setquota -u fsgqa 0 1024 0 0 $SCRATCH_MNT
-_repquota
+setquota -u $qa_user 0 1024 0 0 $SCRATCH_MNT
+_report_quota_blocks
 
 echo "Try to reflink again"
 touch $testdir/file3
-chown fsgqa $testdir/file3
-_cp_reflink $testdir/file1 $testdir/file3 2>&1 | _filter_scratch
-_repquota
+chown $qa_user $testdir/file3
+su $qa_user -c "cp --reflink=always -f $testdir/file1 $testdir/file3" 2>&1 | _filter_scratch
+_report_quota_blocks
 
 # success, all done
 status=0
diff --git a/tests/generic/327.out b/tests/generic/327.out
index 7160ff2..f4e145a 100644
--- a/tests/generic/327.out
+++ b/tests/generic/327.out
@@ -1,12 +1,12 @@
 QA output created by 327
 Format and mount
 Create the original files
-root      --       0       0       0              4     0     0       
-fsgqa     --    2048       0       0              2     0     0       
+root 0 0 0
+fsgqa 2048 0 0
 Set hard quota to prevent third reflink
-root      --       0       0       0              4     0     0       
-fsgqa     +-    2048       0    1024              2     0     0       
+root 0 0 0
+fsgqa 2048 0 1024
 Try to reflink again
 cp: failed to clone 'SCRATCH_MNT/test-327/file3' from 'SCRATCH_MNT/test-327/file1': Disk quota exceeded
-root      --       0       0       0              4     0     0       
-fsgqa     +-    2048       0    1024              3     0     0       
+root 0 0 0
+fsgqa 2048 0 1024
diff --git a/tests/generic/328 b/tests/generic/328
index 705368e..dbf094f 100755
--- a/tests/generic/328
+++ b/tests/generic/328
@@ -49,10 +49,8 @@ _require_fiemap
 _require_quota
 _require_nobody
 _require_odirect
+_require_user
 
-_repquota() {
-	repquota $SCRATCH_MNT | egrep '^(fsgqa|root|nobody)'
-}
 rm -f $seqres.full
 
 echo "Format and mount"
@@ -68,39 +66,40 @@ mkdir $testdir
 sz=1048576
 echo "Create the original files"
 $XFS_IO_PROG -f -c "pwrite -S 0x61 -b $sz 0 $sz" $testdir/file1 >> $seqres.full
-chown fsgqa $testdir/file1
+chown $qa_user $testdir/file1
 _cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
 _cp_reflink $testdir/file1 $testdir/file3 >> $seqres.full
-_repquota
+_report_quota_blocks
 _scratch_cycle_mount
+quotaon $SCRATCH_MNT 2> /dev/null
 
 echo "Set hard quota to prevent rewrite"
-setquota -u fsgqa 0 1024 0 0 $SCRATCH_MNT
-_repquota
+setquota -u $qa_user 0 1024 0 0 $SCRATCH_MNT
+_report_quota_blocks
 
 echo "Try to dio write the whole file"
-_pwrite_byte 0x62 0 $sz $testdir/file1 -d 2>&1 >> $seqres.full | \
+su $qa_user -c '$XFS_IO_PROG -d -c "pwrite 0 '$((sz+65536))'" '$testdir'/file1' 2>&1 >> $seqres.full | \
 	_filter_xfs_io_error
-_repquota
+_report_quota_blocks
 
 echo "Try to write the whole file"
-_pwrite_byte 0x62 0 $sz $testdir/file1 2>&1 >> $seqres.full | \
+su $qa_user -c '$XFS_IO_PROG -c "pwrite 0 '$((sz+65536))'" '$testdir'/file1' 2>&1 >> $seqres.full | \
 	_filter_xfs_io_error
-_repquota
+_report_quota_blocks
 
 echo "Set hard quota to allow rewrite"
-setquota -u fsgqa 0 8192 0 0 $SCRATCH_MNT
-_repquota
+setquota -u $qa_user 0 8192 0 0 $SCRATCH_MNT
+_report_quota_blocks
 
 echo "Try to dio write the whole file"
 _pwrite_byte 0x62 0 $sz $testdir/file1 -d >> $seqres.full
 sync
-_repquota
+_report_quota_blocks
 
 echo "Try to write the whole file"
 _pwrite_byte 0x62 0 $sz $testdir/file3 >> $seqres.full
 sync
-_repquota
+_report_quota_blocks
 
 # success, all done
 status=0
diff --git a/tests/generic/328.out b/tests/generic/328.out
index 4630151..b7fe9f8 100644
--- a/tests/generic/328.out
+++ b/tests/generic/328.out
@@ -1,25 +1,25 @@
 QA output created by 328
 Format and mount
 Create the original files
-root      --       0       0       0              4     0     0       
-fsgqa     --    3072       0       0              3     0     0       
+root 0 0 0
+fsgqa 3072 0 0
 Set hard quota to prevent rewrite
-root      --       0       0       0              4     0     0       
-fsgqa     +-    3072       0    1024              3     0     0       
+root 0 0 0
+fsgqa 3072 0 1024
 Try to dio write the whole file
 pwrite: Disk quota exceeded
-root      --       0       0       0              4     0     0       
-fsgqa     +-    3072       0    1024              3     0     0       
+root 0 0 0
+fsgqa 3072 0 1024
 Try to write the whole file
 pwrite: Disk quota exceeded
-root      --       0       0       0              4     0     0       
-fsgqa     +-    3072       0    1024              3     0     0       
+root 0 0 0
+fsgqa 3072 0 1024
 Set hard quota to allow rewrite
-root      --       0       0       0              4     0     0       
-fsgqa     --    3072       0    8192              3     0     0       
+root 0 0 0
+fsgqa 3072 0 8192
 Try to dio write the whole file
-root      --       0       0       0              4     0     0       
-fsgqa     --    3072       0    8192              3     0     0       
+root 0 0 0
+fsgqa 3072 0 8192
 Try to write the whole file
-root      --       0       0       0              4     0     0       
-fsgqa     --    3072       0    8192              3     0     0       
+root 0 0 0
+fsgqa 3072 0 8192
diff --git a/tests/xfs/213 b/tests/xfs/213
index d5cc129..8e3565e 100755
--- a/tests/xfs/213
+++ b/tests/xfs/213
@@ -52,10 +52,8 @@ _require_fiemap
 _require_quota
 _require_nobody
 _require_xfs_io_command "cowextsize"
+_require_user
 
-_repquota() {
-	repquota $SCRATCH_MNT | egrep '^(fsgqa|root|nobody)'
-}
 rm -f $seqres.full
 
 echo "Format and mount"
@@ -78,27 +76,27 @@ _cp_reflink $testdir/file1 $testdir/file3 >> $seqres.full
 touch $testdir/urk
 chown nobody $testdir/urk
 touch $testdir/erk
-chown fsgqa $testdir/erk
-_repquota
+chown $qa_user $testdir/erk
+_report_quota_blocks
 _scratch_cycle_mount
 
 echo "Change file ownership"
-chown fsgqa $testdir/file1
-chown fsgqa $testdir/file2
-chown fsgqa $testdir/file3
-_repquota
+chown $qa_user $testdir/file1
+chown $qa_user $testdir/file2
+chown $qa_user $testdir/file3
+_report_quota_blocks
 
 echo "CoW one of the files"
 $XFS_IO_PROG -f -c "pwrite -S 0x63 -b $blksz $((sz - blksz)) $blksz" -c "fsync" $testdir/file2 >> $seqres.full
-_repquota
+_report_quota_blocks
 
 echo "Remount the FS to see if accounting changes"
 _scratch_cycle_mount
-_repquota
+_report_quota_blocks
 
 echo "Chown one of the files"
 chown nobody $testdir/file3
-_repquota
+_report_quota_blocks
 
 # success, all done
 status=0
diff --git a/tests/xfs/213.out b/tests/xfs/213.out
index be8d56c..7dd30dd 100644
--- a/tests/xfs/213.out
+++ b/tests/xfs/213.out
@@ -1,22 +1,22 @@
 QA output created by 213
 Format and mount
 Create the original files
-root      --    3072       0       0              7     0     0       
-nobody    --       0       0       0              1     0     0       
-fsgqa     --       0       0       0              1     0     0       
+root 3072 0 0
+nobody 0 0 0
+fsgqa 0 0 0
 Change file ownership
-root      --       0       0       0              4     0     0       
-nobody    --       0       0       0              1     0     0       
-fsgqa     --    3072       0       0              4     0     0       
+root 0 0 0
+nobody 0 0 0
+fsgqa 3072 0 0
 CoW one of the files
-root      --       0       0       0              4     0     0       
-nobody    --       0       0       0              1     0     0       
-fsgqa     --    3520       0       0              4     0     0       
+root 0 0 0
+nobody 0 0 0
+fsgqa 3520 0 0
 Remount the FS to see if accounting changes
-root      --       0       0       0              4     0     0       
-nobody    --       0       0       0              1     0     0       
-fsgqa     --    3072       0       0              4     0     0       
+root 0 0 0
+nobody 0 0 0
+fsgqa 3072 0 0
 Chown one of the files
-root      --       0       0       0              4     0     0       
-nobody    --    1024       0       0              2     0     0       
-fsgqa     --    2048       0       0              3     0     0       
+root 0 0 0
+nobody 1024 0 0
+fsgqa 2048 0 0
diff --git a/tests/xfs/214 b/tests/xfs/214
index 35972c6..f5234fd 100755
--- a/tests/xfs/214
+++ b/tests/xfs/214
@@ -53,10 +53,8 @@ _require_quota
 _require_nobody
 _require_xfs_io_command "cowextsize"
 _require_odirect
+_require_user
 
-_repquota() {
-	repquota $SCRATCH_MNT | egrep '^(fsgqa|root|nobody)'
-}
 rm -f $seqres.full
 
 echo "Format and mount"
@@ -79,27 +77,27 @@ _cp_reflink $testdir/file1 $testdir/file3 >> $seqres.full
 touch $testdir/urk
 chown nobody $testdir/urk
 touch $testdir/erk
-chown fsgqa $testdir/erk
-_repquota
+chown $qa_user $testdir/erk
+_report_quota_blocks
 _scratch_cycle_mount
 
 echo "Change file ownership"
-chown fsgqa $testdir/file1
-chown fsgqa $testdir/file2
-chown fsgqa $testdir/file3
-_repquota
+chown $qa_user $testdir/file1
+chown $qa_user $testdir/file2
+chown $qa_user $testdir/file3
+_report_quota_blocks
 
 echo "CoW one of the files"
 $XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $blksz $((sz - blksz)) $blksz" -c "fsync" $testdir/file2 >> $seqres.full
-_repquota
+_report_quota_blocks
 
 echo "Remount the FS to see if accounting changes"
 _scratch_cycle_mount
-_repquota
+_report_quota_blocks
 
 echo "Chown one of the files"
 chown nobody $testdir/file3
-_repquota
+_report_quota_blocks
 
 # success, all done
 status=0
diff --git a/tests/xfs/214.out b/tests/xfs/214.out
index 496a503..2c7e358 100644
--- a/tests/xfs/214.out
+++ b/tests/xfs/214.out
@@ -1,22 +1,22 @@
 QA output created by 214
 Format and mount
 Create the original files
-root      --    3072       0       0              7     0     0       
-nobody    --       0       0       0              1     0     0       
-fsgqa     --       0       0       0              1     0     0       
+root 3072 0 0
+nobody 0 0 0
+fsgqa 0 0 0
 Change file ownership
-root      --       0       0       0              4     0     0       
-nobody    --       0       0       0              1     0     0       
-fsgqa     --    3072       0       0              4     0     0       
+root 0 0 0
+nobody 0 0 0
+fsgqa 3072 0 0
 CoW one of the files
-root      --       0       0       0              4     0     0       
-nobody    --       0       0       0              1     0     0       
-fsgqa     --    3520       0       0              4     0     0       
+root 0 0 0
+nobody 0 0 0
+fsgqa 3520 0 0
 Remount the FS to see if accounting changes
-root      --       0       0       0              4     0     0       
-nobody    --       0       0       0              1     0     0       
-fsgqa     --    3072       0       0              4     0     0       
+root 0 0 0
+nobody 0 0 0
+fsgqa 3072 0 0
 Chown one of the files
-root      --       0       0       0              4     0     0       
-nobody    --    1024       0       0              2     0     0       
-fsgqa     --    2048       0       0              3     0     0       
+root 0 0 0
+nobody 1024 0 0
+fsgqa 2048 0 0

