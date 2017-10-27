Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25298 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932447AbdJ0UYL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Oct 2017 16:24:11 -0400
Date: Fri, 27 Oct 2017 13:24:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 8/6] xfs/333: fix errors with new inode pointer verifiers
Message-ID: <20171027202407.GJ5486@magnolia>
References: <150899709935.18389.17266737014565285073.stgit@magnolia>
 <20171027004401.GF5486@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171027004401.GF5486@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Fix test failures with new inode pointer verifiers... and also make sure
that the running xfs actually supports realtime rmap.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: remove the rest of the test after the mount failure
---
 tests/xfs/333     |   18 ++++--------------
 tests/xfs/333.out |    7 ++-----
 2 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/tests/xfs/333 b/tests/xfs/333
index f7f233d..bf0c811 100755
--- a/tests/xfs/333
+++ b/tests/xfs/333
@@ -51,6 +51,8 @@ unset SCRATCH_RTDEV
 
 echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
+rrmapino="$(_scratch_xfs_db -c 'sb 0' -c 'p rrmapino' 2>&1)"
+test "${rrmapino}" = "field rrmapino not found" && _notrun "realtime rmapbt not supported"
 _scratch_mount
 
 echo "Create some files"
@@ -62,21 +64,9 @@ _scratch_unmount
 
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
+echo "Test done, mount should have failed"
 
 # success, all done
 status=0
diff --git a/tests/xfs/333.out b/tests/xfs/333.out
index bee9bbc..f7518f4 100644
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
+Test done, mount should have failed
