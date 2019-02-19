Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56602 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfBSF3K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Feb 2019 00:29:10 -0500
Date: Mon, 18 Feb 2019 21:29:05 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs/500: fix review comments
Message-ID: <20190219052905.GH6477@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix some problems detecting reflink support in the test.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/500   |    5 ++---
 tests/xfs/group |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/tests/xfs/500 b/tests/xfs/500
index 7a965c69..370c78ec 100755
--- a/tests/xfs/500
+++ b/tests/xfs/500
@@ -36,10 +36,9 @@ _scratch_mkfs -d extszinherit=8388608 >> $seqres.full 2>&1
 test $? -eq 1 || echo "should have failed extszinherit"
 
 # Try cow extent size hint if supported
-$MKFS_XFS_PROG -N -f $SCRATCH_DEV > $tmp.mkfs
-if grep -q 'reflink=' $tmp.mkfs ; then
+if _scratch_mkfs_xfs_supported -m crc=1,reflink=1 >> $seqres.full 2>&1; then
 	echo cowextsize >> $seqres.full
-	_scratch_mkfs -m reflink=1 -d cowextsize=8388608 >> $seqres.full 2>&1
+	_scratch_mkfs -m reflink=1,crc=1 -d cowextsize=8388608 >> $seqres.full 2>&1
 	test $? -eq 1 || echo "should have failed cowextsize"
 fi
 
diff --git a/tests/xfs/group b/tests/xfs/group
index 76b8a413..0047fb5c 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -497,6 +497,6 @@
 497 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 498 dangerous_fuzzers dangerous_norepair
 499 auto quick
-500 auto quick mkfs
+500 auto quick mkfs prealloc mkfs
 501 auto quick unlink
 502 auto quick unlink
