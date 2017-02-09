Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33084 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752697AbdBIUiA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Feb 2017 15:38:00 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/3] tests/xfs: update indlen res. test to include larger write pattern
Date: Thu,  9 Feb 2017 14:43:44 -0500
Message-Id: <1486669424-45274-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1486669424-45274-1-git-send-email-bfoster@redhat.com>
References: <1486669424-45274-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

The indirect blocks reservation test originally reproduced a problem
with smaller delalloc extents being split into separate extents with
insufficient indlen blocks. This was ultimately resolved by allowing to
borrow blocks from the freed extent.

Since then, similar problems have been reproduced when larger delalloc
extents are repeatedly split and merged with new writes. These repeated
splits exposed a problem in the old indlen reservation split algorithm
when dealing with extents that are already under-reserved from previous
splits. This resulted in unfair distribution of existing reservation and
fairly large delalloc extents without any indlen reservation whatsoever.

Enhance the original indlen reservation test to include a pattern that
reproduces this behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tests/xfs/289 | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/tests/xfs/289 b/tests/xfs/289
index 3aa53b9..5839a24 100755
--- a/tests/xfs/289
+++ b/tests/xfs/289
@@ -85,10 +85,25 @@ done
 
 echo 0 > /sys/fs/xfs/$sdev/drop_writes
 
-echo "Silence is golden."
-
 _scratch_cycle_mount
 $XFS_IO_PROG -c 'bmap -vp' $file | _filter_bmap
 
+# Now test a buffered write workload with larger extents. Write a 100m extent,
+# split it at the 3/4 mark, then write another 100m extent that is contiguous
+# with the 1/4 portion of the split extent. Repeat several times. This pattern
+# is known to prematurely exhaust indirect reservations and cause warnings and
+# assert failures.
+rm -f $file
+for offset in $(seq 0 100 500); do
+	$XFS_IO_PROG -fc "pwrite ${offset}m 100m" $file >> $seqres.full 2>&1
+
+	punchoffset=$((offset + 75))
+	echo 1 > /sys/fs/xfs/$sdev/drop_writes
+	$XFS_IO_PROG -c "pwrite ${punchoffset}m 4k" $file >> $seqres.full 2>&1
+	echo 0 > /sys/fs/xfs/$sdev/drop_writes
+done
+
+echo "Silence is golden."
+
 status=0
 exit
-- 
2.7.4

