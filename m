Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19893 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933451AbdKAVrD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2017 17:47:03 -0400
Subject: [PATCH 05/14] xfs/333: fix errors with new inode pointer verifiers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 01 Nov 2017 14:46:59 -0700
Message-ID: <150957281946.18388.17450507009952179533.stgit@magnolia>
In-Reply-To: <150957278824.18388.17975162441125293654.stgit@magnolia>
References: <150957278824.18388.17975162441125293654.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix test failures with new inode pointer verifiers... and also make sure
that the running xfs actually supports realtime rmap.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/333     |   20 ++++++--------------
 tests/xfs/333.out |    7 ++-----
 2 files changed, 8 insertions(+), 19 deletions(-)


diff --git a/tests/xfs/333 b/tests/xfs/333
index f7f233d..57aae09 100755
--- a/tests/xfs/333
+++ b/tests/xfs/333
@@ -51,6 +51,8 @@ unset SCRATCH_RTDEV
 
 echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
+rrmapino="$(_scratch_xfs_db -c 'sb 0' -c 'p rrmapino' 2>&1)"
+test "${rrmapino}" = "field rrmapino not found" && _notrun "realtime rmapbt not supported"
 _scratch_mount
 
 echo "Create some files"
@@ -62,21 +64,11 @@ _scratch_unmount
 
 echo "Corrupt fs"
 _scratch_xfs_db -x -c 'sb 0' -c "write rrmapino $ino" >> $seqres.full
-_scratch_mount
-
-echo "Check files"
-md5sum $SCRATCH_MNT/f1 2>&1 | _filter_scratch
-
-echo "Try to create more files"
-$XFS_IO_PROG -f -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f3 >> $seqres.full 2>&1
+_scratch_mount 2>&1 | _filter_scratch
 
-echo "Repair fs"
-_scratch_unmount 2>&1 | _filter_scratch
-_repair_scratch_fs >> $seqres.full 2>&1
-
-echo "Try to create more files (again)"
-_scratch_mount
-$XFS_IO_PROG -f -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f4 >> $seqres.full
+echo "Repair, mount again"
+_repair_scratch_fs >> $seqres.full
+_scratch_mount 2>&1 | _filter_scratch
 
 # success, all done
 status=0
diff --git a/tests/xfs/333.out b/tests/xfs/333.out
index bee9bbc..5cac447 100644
--- a/tests/xfs/333.out
+++ b/tests/xfs/333.out
@@ -2,8 +2,5 @@ QA output created by 333
 Format and mount
 Create some files
 Corrupt fs
-Check files
-8f27047948255cb84872e2dd7c0bc56d  SCRATCH_MNT/f1
-Try to create more files
-Repair fs
-Try to create more files (again)
+mount: mount SCRATCH_DEV on SCRATCH_MNT failed: Structure needs cleaning
+Repair, mount again

