Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40476 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfCTAqE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Mar 2019 20:46:04 -0400
Subject: [PATCH 12/12] misc: fix broken _require_scratch usage
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 19 Mar 2019 17:46:01 -0700
Message-ID: <155304276173.31707.10078225002860661364.stgit@magnolia>
In-Reply-To: <155304267647.31707.14180452399822113095.stgit@magnolia>
References: <155304267647.31707.14180452399822113095.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

_require_scratch doesn't actually format the scratch device with
anything, which means that tests are required to format them before
using them.  Fix tests that don't do this correctly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/026 |    1 -
 tests/generic/100 |    3 ---
 tests/generic/506 |    2 +-
 tests/xfs/065     |    2 +-
 tests/xfs/108     |    1 +
 tests/xfs/109     |    2 +-
 tests/xfs/194     |    4 +++-
 tests/xfs/261     |    2 ++
 tests/xfs/284     |    1 +
 9 files changed, 10 insertions(+), 8 deletions(-)


diff --git a/tests/generic/026 b/tests/generic/026
index 6cbd2829..31cd0827 100755
--- a/tests/generic/026
+++ b/tests/generic/026
@@ -32,7 +32,6 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 _require_test
-_require_scratch
 _acl_setup_ids
 _require_acls
 _require_acl_get_max
diff --git a/tests/generic/100 b/tests/generic/100
index c2593333..927c4949 100755
--- a/tests/generic/100
+++ b/tests/generic/100
@@ -52,9 +52,6 @@ _populate_fs -n $NDIRS -f $NFILES -d $DEPTH -r $POPULATED_DIR -s $SIZE >>$seqres
 # Then tar up the directory structure
 tar -cvf $TEMP_DIR/$TAR_FILE $POPULATED_DIR >>$seqres.full 2>&1
 
-# create f/s
-_require_scratch
-
 # untar on f/s
 cd $TEST_DIR
 tar -xvf $TEMP_DIR/$TAR_FILE >>$seqres.full 2>&1
diff --git a/tests/generic/506 b/tests/generic/506
index 5d419cad..7002c00c 100755
--- a/tests/generic/506
+++ b/tests/generic/506
@@ -46,12 +46,12 @@ _supported_os Linux
 _require_command "$LSATTR_PROG" lsattr
 _require_command "$CHATTR_PROG" chattr
 
-_require_prjquota $SCRATCH_DEV
 _require_scratch
 _require_scratch_shutdown
 
 _scratch_mkfs >/dev/null 2>&1
 _require_metadata_journaling $SCRATCH_DEV
+_require_prjquota $SCRATCH_DEV
 
 testfile=$SCRATCH_MNT/testfile
 
diff --git a/tests/xfs/065 b/tests/xfs/065
index c3472486..c0d1ee93 100755
--- a/tests/xfs/065
+++ b/tests/xfs/065
@@ -55,7 +55,7 @@ _supported_os Linux
 # too much hassle to get output matching with quotas turned on
 # so don't run it
 #
-_scratch_unmount 2>/dev/null
+_scratch_mkfs_xfs >> $seqres.full
 _scratch_mount
 $here/src/feature -U $SCRATCH_DEV && \
 	_notrun "UQuota enabled, test needs controlled xfsdump output"
diff --git a/tests/xfs/108 b/tests/xfs/108
index c47f4f37..e70a1f9a 100755
--- a/tests/xfs/108
+++ b/tests/xfs/108
@@ -61,6 +61,7 @@ test_accounting()
 }
 
 export MOUNT_OPTIONS="-opquota"
+_scratch_mkfs_xfs >> $seqres.full
 _qmount
 _require_prjquota $SCRATCH_DEV
 
diff --git a/tests/xfs/109 b/tests/xfs/109
index a063dc3f..df4ec157 100755
--- a/tests/xfs/109
+++ b/tests/xfs/109
@@ -75,7 +75,7 @@ allocate()
 }
 
 # real QA test starts here
-_scratch_unmount 2>/dev/null
+_scratch_mkfs_xfs >> $seqres.full
 _scratch_mount
 rm -f $seqres.full
 
diff --git a/tests/xfs/194 b/tests/xfs/194
index 6c1eddba..3e186528 100755
--- a/tests/xfs/194
+++ b/tests/xfs/194
@@ -32,6 +32,9 @@ _supported_os Linux
 # real QA test starts here
 rm -f $seqres.full
 
+_require_scratch
+_scratch_mkfs_xfs >/dev/null 2>&1
+
 # For this test we use block size = 1/8 page size
 pgsize=`$here/src/feature -s`
 blksize=`expr $pgsize / 8`
@@ -70,7 +73,6 @@ _filter_od()
     sed -e "s/^[0-9A-Fa-f ]\{7,8\}//"
 }
 
-_require_scratch
 unset MKFS_OPTIONS
 unset XFS_MKFS_OPTIONS
 
diff --git a/tests/xfs/261 b/tests/xfs/261
index 0fabcd64..92152ace 100755
--- a/tests/xfs/261
+++ b/tests/xfs/261
@@ -47,6 +47,8 @@ _supported_os Linux
 _require_quota
 _require_scratch
 
+_scratch_mkfs >> $seqres.full 2>&1
+
 # Just use the current mount table as an example mtab file.  Odds
 # are good there's nothing wrong with it.
 _setup_my_mtab() {
diff --git a/tests/xfs/284 b/tests/xfs/284
index 07f71031..7af77634 100755
--- a/tests/xfs/284
+++ b/tests/xfs/284
@@ -50,6 +50,7 @@ COPY_FILE="${TEST_DIR}/${seq}_copyfile"
 
 # Test dump a mounted device
 # xfs_metadump should refuse to dump a mounted device
+_scratch_mkfs >> $seqres.full 2>&1
 _scratch_mount
 _scratch_metadump $METADUMP_FILE 2>&1 | filter_mounted
 _scratch_unmount
