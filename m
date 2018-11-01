Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53364 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727749AbeKBIYz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Nov 2018 04:24:55 -0400
Subject: [PATCH 7/8] misc: force the exact quota options coded into the test
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 01 Nov 2018 16:19:46 -0700
Message-ID: <154111438630.6577.12698243646066699280.stgit@magnolia>
In-Reply-To: <154111434286.6577.15010861884505931015.stgit@magnolia>
References: <154111434286.6577.15010861884505931015.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Several tests require setting exactly the quota mount options that are
encoded in the test.  Unfortunately, quota mount options set by the user
in MOUNT_OPTIONS can turn on other quota types, which causes the golden
outputs to be off for various reasons (quota report output, behavior
changes, etc.)

So use _qmount_option to delete all the quota mount options in these
tests so that the test itself can run with exactly the config for which
it was written.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/230 |    3 +++
 tests/xfs/075     |    4 ++++
 tests/xfs/116     |    3 +++
 tests/xfs/132     |    5 +++++
 tests/xfs/220     |    3 +++
 5 files changed, 18 insertions(+)


diff --git a/tests/generic/230 b/tests/generic/230
index 66b12d2f..e0a876ba 100755
--- a/tests/generic/230
+++ b/tests/generic/230
@@ -99,6 +99,9 @@ rm -f $seqres.full
 
 grace=2
 
+# Test only the quota type specified in each _scratch_mount clause below.
+_qmount_option 'defaults'
+
 _scratch_mkfs >> $seqres.full 2>&1
 _scratch_mount "-o usrquota,grpquota"
 BLOCK_SIZE=$(_get_file_block_size $SCRATCH_MNT)
diff --git a/tests/xfs/075 b/tests/xfs/075
index caf612bb..dee01462 100755
--- a/tests/xfs/075
+++ b/tests/xfs/075
@@ -25,12 +25,16 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/quota
 
 # real QA test starts here
 _supported_fs xfs
 _supported_os Linux
 _require_scratch
 
+# norecovery mounts do not succeed with quotas eanbled, so shut them off
+_qmount_option "defaults"
+
 echo "Silence is golden"
 _scratch_mkfs_sized $((512 * 1024 * 1024)) >$seqres.full
 
diff --git a/tests/xfs/116 b/tests/xfs/116
index 6887d7e5..4422eb50 100755
--- a/tests/xfs/116
+++ b/tests/xfs/116
@@ -36,6 +36,9 @@ _supported_os Linux
 _require_scratch
 _require_xfs_quota
 
+# Only mount with the quota options we specify below
+_qmount_option "defaults"
+
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount "-o uquota"
 _scratch_unmount
diff --git a/tests/xfs/132 b/tests/xfs/132
index c5fe8b5a..a421f727 100755
--- a/tests/xfs/132
+++ b/tests/xfs/132
@@ -24,6 +24,7 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/quota
 
 # remove previous $seqres.full before test
 rm -f $seqres.full
@@ -43,6 +44,10 @@ _disable_dmesg_check
 _require_xfs_mkfs_crc
 _scratch_mkfs -m crc=0 > $seqres.full 2>&1
 
+# The files that EIO in the golden output changes if we have quotas enabled
+# so leave it off.
+_qmount_option "defaults"
+
 # corrupt an inode in the root inode chunk
 root_ino=$(_scratch_xfs_get_metadata_field 'rootino' 'sb 0')
 corrupt_ino=$((root_ino + 15))
diff --git a/tests/xfs/220 b/tests/xfs/220
index 227d5452..61319c9d 100755
--- a/tests/xfs/220
+++ b/tests/xfs/220
@@ -36,6 +36,9 @@ _supported_os Linux
 _require_scratch
 _require_quota
 
+# Only mount with the specific quota options mentioned below
+_qmount_option "defaults"
+
 echo "Silence is golden."
 
 # create scratch filesystem
