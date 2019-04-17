Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53930 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbfDQGYz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Apr 2019 02:24:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3H6OStS088917
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 06:24:53 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2rvwk3rwam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 06:24:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3H6NJrc073264
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 06:24:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2ru4vtkvyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 06:24:52 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3H6OpTE021856
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 06:24:51 GMT
Date: Tue, 16 Apr 2019 23:24:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 3/2] xfstests: check for COW overflows in i_delayed_blks
Message-ID: <20190417062450.GD114154@magnolia>
References: <155546518260.176148.16583864799178682873.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155546518260.176148.16583864799178682873.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

With the new copy on write functionality it's possible to reserve so
much COW space for a file that we end up overflowing i_delayed_blks.
The only user-visible effect of this is to cause totally wrong i_blocks
output in stat, so check for that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/907     |  128 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/907.out |    7 +++
 tests/xfs/group   |    1 
 3 files changed, 136 insertions(+)
 create mode 100755 tests/xfs/907
 create mode 100644 tests/xfs/907.out

diff --git a/tests/xfs/907 b/tests/xfs/907
new file mode 100755
index 00000000..5791f835
--- /dev/null
+++ b/tests/xfs/907
@@ -0,0 +1,128 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
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
+	if [ "${cowblocks}" -lt "$((2 ** 32))" ]; then
+		echo "cowblocks (${cowblocks}) is more than 2^32, your system has overflowed!!!"
+	fi
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
index 5a4ef4bf..e0c7fc97 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -504,3 +504,4 @@
 739 auto quick mkfs label
 742 auto quick spaceman
 743 auto quick health
+907 clone
