Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34809 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbfEZIpq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 May 2019 04:45:46 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 1/5] generic: create copy_range group
Date: Sun, 26 May 2019 11:45:31 +0300
Message-Id: <20190526084535.999-2-amir73il@gmail.com>
In-Reply-To: <20190526084535.999-1-amir73il@gmail.com>
References: <20190526084535.999-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

Move some tests to the copy_range group so they are distinct
from the copy group which refers to xfs_copy tests.

[Amir] Revert copy past EOF behavior change

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/434   |  2 ++
 tests/generic/group | 10 +++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/tests/generic/434 b/tests/generic/434
index 032f933d..edbf49d3 100755
--- a/tests/generic/434
+++ b/tests/generic/434
@@ -46,10 +46,12 @@ $XFS_IO_PROG -f -c "copy_range -s 1000 -l 100 $testdir/file" "$testdir/copy"
 md5sum $testdir/copy | _filter_test_dir
 
 echo "Try to copy to a read-only file"
+rm -f $testdir/copy
 $XFS_IO_PROG -r -f -c "copy_range -s 0 -l 100 $testdir/file" "$testdir/copy"
 md5sum $testdir/copy | _filter_test_dir
 
 echo "Try to copy to an append-only file"
+rm -f $testdir/copy
 $XFS_IO_PROG -a -f -c "copy_range -s 0 -l 100 $testdir/file" "$testdir/copy"
 md5sum $testdir/copy | _filter_test_dir
 
diff --git a/tests/generic/group b/tests/generic/group
index 49639fc9..b498eb56 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -432,11 +432,11 @@
 427 auto quick aio rw
 428 auto quick dax
 429 auto encrypt
-430 auto quick copy
-431 auto quick copy
-432 auto quick copy
-433 auto quick copy
-434 auto quick copy
+430 auto quick copy_range
+431 auto quick copy_range
+432 auto quick copy_range
+433 auto quick copy_range
+434 auto quick copy_range
 435 auto encrypt
 436 auto quick rw seek prealloc
 437 auto quick dax
-- 
2.17.1
