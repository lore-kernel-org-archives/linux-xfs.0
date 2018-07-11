Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53480 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387759AbeGKQyf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jul 2018 12:54:35 -0400
Date: Wed, 11 Jul 2018 09:49:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] generic/499: add bfoster's alternate reproducer
Message-ID: <20180711164919.GD5703@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Add Brian Foster's alternate reproducer code for this problem so that we
increase the chances that one of them will reproduce the race problem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/499 |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tests/generic/499 b/tests/generic/499
index 99d6d308..e0b95871 100755
--- a/tests/generic/499
+++ b/tests/generic/499
@@ -33,6 +33,7 @@ _require_xfs_io_command "fzero"
 
 rm -f $seqres.full
 
+# djwong's reproducer
 _scratch_mkfs >>$seqres.full 2>&1
 _scratch_mount
 
@@ -52,6 +53,24 @@ victim=$SCRATCH_MNT/a
 touch $victim
 $here/ltp/fsx --replay-ops $tmp.fsxops $victim > $tmp.output || cat $tmp.output
 
+# bfoster/hch reproducer
+_scratch_unmount
+_scratch_mkfs_sized $((1024 * 1024 * 100)) >>$seqres.full 2>&1
+_scratch_mount
+
+$XFS_IO_PROG -fc "pwrite 0 100m" -c fsync $SCRATCH_MNT/file >>$seqres.full 2>&1
+rm -f $SCRATCH_MNT/file
+
+cat >> $tmp.fsxops << ENDL
+truncate 0x0 0x1f0d6 0x380e1
+write 0x1ad87 0x6c99 0x180d6
+zero_range 0x14426 0xd3aa 0x21a20 keep_size
+mapread 0x1f69a 0x2386 0x21a20
+ENDL
+
+touch $victim
+$here/ltp/fsx --replay-ops $tmp.fsxops $victim > $tmp.output || cat $tmp.output
+
 echo "Silence is golden"
 status=0
 exit
