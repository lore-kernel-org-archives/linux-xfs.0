Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:57194 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbfCTApF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Mar 2019 20:45:05 -0400
Subject: [PATCH 04/12] generic/032: fix unwritten extent checks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 19 Mar 2019 17:45:01 -0700
Message-ID: <155304270155.31707.5574383689968895450.stgit@magnolia>
In-Reply-To: <155304267647.31707.14180452399822113095.stgit@magnolia>
References: <155304267647.31707.14180452399822113095.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix the unwritten extent detector in this test to ignore post-eof
allocations because those are harmless.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/032 |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)


diff --git a/tests/generic/032 b/tests/generic/032
index affde4b7..38352a21 100755
--- a/tests/generic/032
+++ b/tests/generic/032
@@ -69,18 +69,21 @@ do
 
 	# preallocate the first 64k and overwite, writing past 64k to contend
 	# with writeback
+	file_len=0x100000
 	$XFS_IO_PROG \
 		-c "falloc 0 0x10000"	\
-		-c "pwrite 0 0x100000"	\
+		-c "pwrite 0 $file_len"	\
 		-c "fsync"		\
 		$SCRATCH_MNT/file >> $seqres.full 2>&1
 
-	# Check for unwritten extents. We should have none since we wrote over
-	# the entire preallocated region and ran fsync.
-	$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/file | \
-		tee -a $seqres.full | \
-		_filter_fiemap | grep unwritten
-	[ $? == 0 ] && _fail "Unwritten extents found!"
+	# Check for unwritten extents. We should have none before EOF since we
+	# wrote over the entire preallocated region and ran fsync.
+	eof_sector=$(( file_len / 512 ))
+	$XFS_IO_PROG -c 'fiemap -v' $SCRATCH_MNT/file | \
+		_filter_fiemap | \
+		tr '[.]:' '    ' | \
+		awk "{if (\$2 < $eof_sector) {print \$0}}" | \
+		grep -q unwritten && _fail "Unwritten extents found!"
 done
 
 echo $iters iterations
