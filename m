Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55152 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405251AbfFKPj2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 11:39:28 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 2/2] generic/554: test only copy to active swap file
Date: Tue, 11 Jun 2019 18:39:16 +0300
Message-Id: <20190611153916.13360-2-amir73il@gmail.com>
In-Reply-To: <20190611153916.13360-1-amir73il@gmail.com>
References: <20190611153916.13360-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

Depending on filesystem, copying from active swapfile may be allowed,
just as read from swapfile may be allowed.

Note the kernel fix commit in test description.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

Per your and Ted's request, I've documented the kernel fix commit
in the new copy_range tests. Those commits are now on Darrick's
copy-file-range-fixes branch, which is on its way to linux-next
and to kernel 5.3.

Thanks,
Amir.


Changes from v1:
- Document kernel fix commit

 tests/generic/554     | 6 ++++--
 tests/generic/554.out | 1 -
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tests/generic/554 b/tests/generic/554
index 10ae4035..fa19d580 100755
--- a/tests/generic/554
+++ b/tests/generic/554
@@ -4,7 +4,10 @@
 #
 # FS QA Test No. 554
 #
-# Check that we cannot copy_file_range() to/from a swapfile
+# Check that we cannot copy_file_range() to a swapfile
+#
+# This is a regression test for kernel commit:
+#   a31713517dac ("vfs: introduce generic_file_rw_checks()")
 #
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
@@ -46,7 +49,6 @@ echo swap files return ETXTBUSY
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
