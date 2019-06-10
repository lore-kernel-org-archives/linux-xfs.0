Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37887 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389093AbfFJTxZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 15:53:25 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] generic/554: test only copy to active swap file
Date: Mon, 10 Jun 2019 22:53:17 +0300
Message-Id: <20190610195317.8516-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

Depending on filesystem, copying from active swapfile may be allowed,
just as read from swapfile may be allowed.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

Following feedback by Ted, I've decided it would be better to
remove the test case of copy from swap file.
There is no reason to deny that copy, but there is also no reason
for us to assert that filesystems must allow this functionality.

Even after removing the copy from test case, test still fails
on upstream for all filesystems I tested.
Tests passes with Darrick's copy-file-range-fixes branch.

Thanks,
Amir.

 tests/generic/554     | 3 +--
 tests/generic/554.out | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/tests/generic/554 b/tests/generic/554
index 10ae4035..c946ca17 100755
--- a/tests/generic/554
+++ b/tests/generic/554
@@ -4,7 +4,7 @@
 #
 # FS QA Test No. 554
 #
-# Check that we cannot copy_file_range() to/from a swapfile
+# Check that we cannot copy_file_range() to a swapfile
 #
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
@@ -46,7 +46,6 @@ echo swap files return ETXTBUSY
 _format_swapfile $SCRATCH_MNT/swapfile 16m
 swapon $SCRATCH_MNT/swapfile
 $XFS_IO_PROG -f -c "copy_range -l 32k $SCRATCH_MNT/file" $SCRATCH_MNT/swapfile
-$XFS_IO_PROG -f -c "copy_range -l 32k $SCRATCH_MNT/swapfile" $SCRATCH_MNT/copy
 swapoff $SCRATCH_MNT/swapfile
 
 # success, all done
diff --git a/tests/generic/554.out b/tests/generic/554.out
index ffaa7b0a..19385a05 100644
--- a/tests/generic/554.out
+++ b/tests/generic/554.out
@@ -1,4 +1,3 @@
 QA output created by 554
 swap files return ETXTBUSY
 copy_range: Text file busy
-copy_range: Text file busy
-- 
2.17.1
