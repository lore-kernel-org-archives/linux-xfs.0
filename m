Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46606 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753851AbeEAPkI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 May 2018 11:40:08 -0400
Subject: [PATCH 7/9] xfs/422: add fsstress to the freeze-and-rmap-repair
 race test
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 01 May 2018 08:40:03 -0700
Message-ID: <152518920390.23023.633707441886698447.stgit@magnolia>
In-Reply-To: <152518916007.23023.4793255395982876953.stgit@magnolia>
References: <152518916007.23023.4793255395982876953.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add fsstress to the pile of things that we race with rmap repair to
ensure that the rmap repair isolates the filesystem correctly while it
is doing its repairs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/422 |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/422 b/tests/xfs/422
index a8fa5d5a..b2db713c 100755
--- a/tests/xfs/422
+++ b/tests/xfs/422
@@ -51,6 +51,8 @@ _supported_fs xfs
 _require_xfs_scratch_rmapbt
 _require_xfs_io_command "scrub"
 _require_xfs_io_error_injection "force_repair"
+_require_command "$KILLALL_PROG" killall
+_require_command "$FSSTRESS_PROG" fsstress
 
 echo "Format and populate"
 _scratch_mkfs > "$seqres.full" 2>&1
@@ -89,18 +91,33 @@ repair_loop() {
 		$XFS_IO_PROG -x -c 'repair rmapbt 0' -c 'repair rmapbt 1' $SCRATCH_MNT 2>&1 | filter_output
 	done
 }
+stress_loop() {
+	end="$1"
+
+	FSSTRESS_ARGS=$(_scale_fsstress_args -p 4 -d $SCRATCH_MNT -n 2000 $FSSTRESS_AVOID)
+	while [ "$(date +%s)" -lt $end ]; do
+		$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full
+	done
+}
 $XFS_IO_PROG -x -c 'inject force_repair' $SCRATCH_MNT
 
 start=$(date +%s)
 end=$((start + (30 * TIME_FACTOR) ))
 
 echo "Loop started at $(date --date="@${start}"), ending at $(date --date="@${end}")" >> $seqres.full
+stress_loop $end &
 freeze_loop $end &
 repair_loop $end &
 
-while [ "$(date +%s)" -lt $end ]; do
+# Wait until 2 seconds after the loops should have finished...
+while [ "$(date +%s)" -lt $((end + 2)) ]; do
 	sleep 1
 done
+
+# ...and clean up after the loops in case they didn't do it themselves.
+$KILLALL_PROG -TERM xfs_io fsstress >> $seqres.full 2>&1
+$XFS_IO_PROG -x -c 'thaw' $SCRATCH_MNT >> $seqres.full 2>&1
+
 echo "Loop finished at $(date)" >> $seqres.full
 echo "Test done"
 

