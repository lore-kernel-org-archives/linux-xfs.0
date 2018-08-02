Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54460 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727152AbeHBTz4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Aug 2018 15:55:56 -0400
Date: Thu, 2 Aug 2018 11:03:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: check for COW overflows in i_delayed_blks
Message-ID: <20180802180335.GS30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

With the new copy on write functionality it's possible to reserve so
much COW space for a file that we end up overflowing i_delayed_blks.
The only user-visible effect of this is to cause totally wrong i_blocks
output in stat, so check for that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/907     |  125 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/907.out |    7 +++
 tests/xfs/group   |    1 
 3 files changed, 133 insertions(+)
 create mode 100755 tests/xfs/907
 create mode 100644 tests/xfs/907.out

diff --git a/tests/xfs/907 b/tests/xfs/907
new file mode 100755
index 00000000..86c3448d
--- /dev/null
+++ b/tests/xfs/907
@@ -0,0 +1,125 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2018 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 907
+#
+# Try to overflow i_delayed_blks by setting the largest cowextsize hint
+# possible, creating a sparse file with a single byte every cowextsize bytes,
+# reflinking it, and retouching every written byte to see if we can create
+# enough speculative COW reservations to overflow i_delayed_blks.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	umount $loop_mount > /dev/null 2>&1
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_reflink
+_require_loop
+_require_xfs_debug
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_require_fs_space $SCRATCH_MNT 2400000	# 100T fs requires ~2.4GB of space
+
+loop_file=$SCRATCH_MNT/a.img
+loop_mount=$SCRATCH_MNT/a
+truncate -s 100T $loop_file
+$MKFS_XFS_PROG $MKFS_OPTIONS -f $loop_file >> $seqres.full
+mkdir $loop_mount
+mount -o loop -t xfs $loop_file $loop_mount
+
+echo "Create crazy huge file"
+touch "${loop_mount}/a"
+blksz="$(stat -f -c '%S' "${loop_mount}")"
+MAXEXTLEN=2097151	# cowextsize can't be more than MAXEXTLEN
+extsize="$(( ((2 ** 32) - 1) / blksz ))"
+test "${extsize}" -gt "${MAXEXTLEN}" && extsize="${MAXEXTLEN}"
+extsize_bytes="$(( extsize * blksz ))"
+
+# Set the largest cowextsize we can
+$XFS_IO_PROG -c "cowextsize ${extsize_bytes}" "${loop_mount}/a"
+set_cowextsize="$($XFS_IO_PROG -c 'cowextsize' "${loop_mount}/a" | sed -e 's/^.\([0-9]*\).*$/\1/g')"
+test "${set_cowextsize}" -eq 0 && _fail "could not set cowextsize?"
+
+statB="$(stat -c '%B' "${loop_mount}/a")"
+
+# Write a single byte every cowextsize bytes so that we minimize the space
+# required to create maximally sized cow reservations
+nr="$(( ((2 ** 32) / extsize) + 100 ))"
+seq 0 "${nr}" | tac | while read n; do
+	off="$((n * extsize * blksz))"
+	$XFS_IO_PROG -c "pwrite ${off} 1" "${loop_mount}/a" > /dev/null
+done
+
+echo "Reflink crazy huge file"
+cp --reflink=always "${loop_mount}/a" "${loop_mount}/b"
+
+echo "COW crazy huge file"
+# Try to create enough maximally sized cow reservations to overflow
+# i_delayed_blks
+seq 0 "${nr}" | tac | while read n; do
+	off="$((n * extsize * blksz))"
+	$XFS_IO_PROG -c "pwrite ${off} 1" "${loop_mount}/a" > /dev/null
+done
+
+echo "Check crazy huge file"
+blocks="$(stat -c '%b' "${loop_mount}/a")"
+fsblocks="$((blocks * statB / blksz))"
+
+# Make sure we got enough COW reservations to overflow a 32-bit counter.
+$XFS_IO_PROG -c 'bmap -clpv' "${loop_mount}/a" > $tmp.extents
+echo "COW EXTENT STATE" >> $seqres.full
+cat $tmp.extents >> $seqres.full
+cat > $tmp.awk << ENDL
+{
+	if (\$3 == "delalloc") {
+		x += \$4;
+	} else if (\$3 == "hole") {
+		;
+	} else {
+		x += \$6;
+	}
+}
+END {
+	printf("%d\\n", x / ($blksz / 512));
+}
+ENDL
+cat $tmp.awk >> $seqres.full
+cowblocks="$(awk -f $tmp.awk $tmp.extents)"
+echo "cowblocks is ${cowblocks}" >> $seqres.full
+if [ "${cowblocks}" -lt "$((2 ** 32))" ]; then
+	echo "cowblocks (${cowblocks}) should be more than 2^32!"
+fi
+
+# And finally, see if i_delayed_blks overflowed.
+echo "stat blocks is ${fsblocks}" >> $seqres.full
+if [ "${fsblocks}" -lt "$((2 ** 32))" ]; then
+	echo "stat blocks (${fsblocks}) should be more than 2^32!"
+fi
+
+echo "Test done"
+umount $loop_mount
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/907.out b/tests/xfs/907.out
new file mode 100644
index 00000000..9778d5ed
--- /dev/null
+++ b/tests/xfs/907.out
@@ -0,0 +1,7 @@
+QA output created by 907
+Format and mount
+Create crazy huge file
+Reflink crazy huge file
+COW crazy huge file
+Check crazy huge file
+Test done
diff --git a/tests/xfs/group b/tests/xfs/group
index 280b1ba1..1142a45e 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -501,3 +501,4 @@
 723 auto quick fuzz
 724 auto quick fuzz
 903 mount auto quick stress
+907 clone
