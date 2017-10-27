Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35593 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932402AbdJ0AoF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 20:44:05 -0400
Date: Thu, 26 Oct 2017 17:44:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 8/6] xfs/333: fix errors with new inode pointer verifiers
Message-ID: <20171027004401.GF5486@magnolia>
References: <150899709935.18389.17266737014565285073.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150899709935.18389.17266737014565285073.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Fix test failures with new inode pointer verifiers... and also make sure
that the running xfs actually supports realtime rmap.  (This should stop
the current crop of weird test failures since nobody has rtrmap yet
anyway...)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/333     |    4 +++-
 tests/xfs/333.out |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tests/xfs/333 b/tests/xfs/333
index f7f233d..af52373 100755
--- a/tests/xfs/333
+++ b/tests/xfs/333
@@ -51,6 +51,8 @@ unset SCRATCH_RTDEV
 
 echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
+rrmapino="$(_scratch_xfs_db -c 'sb 0' -c 'p rrmapino' 2>&1)"
+test "${rrmapino}" = "field rrmapino not found" && _notrun "realtime rmapbt not supported"
 _scratch_mount
 
 echo "Create some files"
@@ -62,7 +64,7 @@ _scratch_unmount
 
 echo "Corrupt fs"
 _scratch_xfs_db -x -c 'sb 0' -c "write rrmapino $ino" >> $seqres.full
-_scratch_mount
+_scratch_mount 2>&1 | _filter_scratch
 
 echo "Check files"
 md5sum $SCRATCH_MNT/f1 2>&1 | _filter_scratch
diff --git a/tests/xfs/333.out b/tests/xfs/333.out
index bee9bbc..9f81ba4 100644
--- a/tests/xfs/333.out
+++ b/tests/xfs/333.out
@@ -2,8 +2,10 @@ QA output created by 333
 Format and mount
 Create some files
 Corrupt fs
+mount: mount SCRATCH_DEV on SCRATCH_MNT failed: Structure needs cleaning
 Check files
-8f27047948255cb84872e2dd7c0bc56d  SCRATCH_MNT/f1
+md5sum: SCRATCH_MNT/f1: No such file or directory
 Try to create more files
 Repair fs
+umount: SCRATCH_DEV: not mounted
 Try to create more files (again)
