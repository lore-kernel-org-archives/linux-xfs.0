Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49782 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbdH3Ek4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 00:40:56 -0400
Subject: [PATCH 1/4] xfs/{319,323}: don't checksum files after log recovery
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 29 Aug 2017 21:40:50 -0700
Message-ID: <150406805060.31349.16766271336969357123.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

These two tests simulate log failure during a reflink operation.
However, the contents of the target of the reflink operation depend on
the block size, so we cannot hardcode md5 hashes in this test.  Since
the whole point of the test is to ensure that the the complex chain of
transactions actually finishes no matter where the interruption, it is
sufficient simply to run the usual end-of-test fsck to look for corrupt
metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/319     |    5 -----
 tests/xfs/319.out |    4 ----
 tests/xfs/323     |    4 ----
 tests/xfs/323.out |    3 ---
 4 files changed, 16 deletions(-)


diff --git a/tests/xfs/319 b/tests/xfs/319
index bbe21df..457f181 100755
--- a/tests/xfs/319
+++ b/tests/xfs/319
@@ -82,11 +82,6 @@ touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
 echo "Remount to replay log"
 _scratch_inject_logprint >> $seqres.full
 
-echo "Check files"
-md5sum $SCRATCH_MNT/file1 | _filter_scratch
-md5sum $SCRATCH_MNT/file2 | _filter_scratch
-md5sum $SCRATCH_MNT/file3 | _filter_scratch
-
 echo "FS should be online, touch should succeed"
 touch $SCRATCH_MNT/goodfs
 
diff --git a/tests/xfs/319.out b/tests/xfs/319.out
index bccde84..160f5fd 100644
--- a/tests/xfs/319.out
+++ b/tests/xfs/319.out
@@ -11,9 +11,5 @@ XFS_IOC_CLONE_RANGE: Input/output error
 FS should be shut down, touch will fail
 touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
 Remount to replay log
-Check files
-2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file1
-2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file2
-2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file3
 FS should be online, touch should succeed
 Done
diff --git a/tests/xfs/323 b/tests/xfs/323
index c124f25..18893f2 100755
--- a/tests/xfs/323
+++ b/tests/xfs/323
@@ -80,10 +80,6 @@ touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
 echo "Remount to replay log"
 _scratch_inject_logprint >> $seqres.full
 
-echo "Check files"
-md5sum $SCRATCH_MNT/file1 | _filter_scratch
-md5sum $SCRATCH_MNT/file3 | _filter_scratch
-
 echo "FS should be online, touch should succeed"
 touch $SCRATCH_MNT/goodfs
 
diff --git a/tests/xfs/323.out b/tests/xfs/323.out
index be41b7e..99b9688 100644
--- a/tests/xfs/323.out
+++ b/tests/xfs/323.out
@@ -10,8 +10,5 @@ XFS_IOC_CLONE_RANGE: Input/output error
 FS should be shut down, touch will fail
 touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
 Remount to replay log
-Check files
-2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file1
-2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file3
 FS should be online, touch should succeed
 Done

