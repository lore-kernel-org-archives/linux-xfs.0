Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:60018 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727192AbfEGQ5S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 May 2019 12:57:18 -0400
Subject: [PATCH 3/3] xfs/294: calculate space to reserve for fragmentation
 test
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 07 May 2019 09:57:09 -0700
Message-ID: <155724822935.2624631.18285317888168151966.stgit@magnolia>
In-Reply-To: <155724821034.2624631.4172554705843296757.stgit@magnolia>
References: <155724821034.2624631.4172554705843296757.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xuyang2018.jy@cn.fujitsu.com, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This test requires us to fragment free space, and in part accomplishes
this by fallocating 400M of a 512M filesystem, then fallocating another
70M, and then using dd to eat remaining space.  However, it's risky to
assume the 400M figure because new features such as reflink and rmap
have per-ag metadata reservations which add to overhead.  Therefore,
reserve the 70M fragment file first, then try to fallocate 95% of the
remaining free space.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/294 |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)


diff --git a/tests/xfs/294 b/tests/xfs/294
index bce4d07b..af0fc124 100755
--- a/tests/xfs/294
+++ b/tests/xfs/294
@@ -70,15 +70,16 @@ for I in `seq 1 100`; do
 	touch $SCRATCH_MNT/testdir/12345678901234567890$I;
 done
 
-# Now completely fragment freespace.
-# Consume most of it:
-$XFS_IO_PROG -f -c "falloc 0 400m" $SCRATCH_MNT/fillfile ||
-	_fail "Could not allocate space"
-
 # File to fragment:
 $XFS_IO_PROG -f -c "falloc 0 70m" $SCRATCH_MNT/fragfile ||
 	_fail "Could not allocate space"
 
+# Now completely fragment freespace.
+# Consume most of it:
+space=$(stat -f -c '%f * %S * 95 / 100' $SCRATCH_MNT | $BC_PROG)
+$XFS_IO_PROG -f -c "falloc 0 $space" $SCRATCH_MNT/fillfile ||
+	_fail "Could not allocate space"
+
 df -h $SCRATCH_MNT >> $seqres.full 2>&1
 
 # Fill remaining space; let this run to failure
