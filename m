Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:56262 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729281AbeHMO4s (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Aug 2018 10:56:48 -0400
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] generic: add FIBMAP basic testing
Date: Mon, 13 Aug 2018 20:14:39 +0800
Message-Id: <20180813121439.19667-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

xfstests doesn't cover FIBMAP test, it cause we brought in a
regression bug fixed by "79b3dbe4adb3 fs: fix iomap_bmap position
calculation".

Although FIBMAP is old, there're still some programs use it, likes
LILO. So test FIBMAP basic function in this case.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 tests/generic/505     | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/505.out | 21 +++++++++++++
 tests/generic/group   |  1 +
 3 files changed, 106 insertions(+)
 create mode 100755 tests/generic/505
 create mode 100644 tests/generic/505.out

diff --git a/tests/generic/505 b/tests/generic/505
new file mode 100755
index 00000000..9a4fd0c8
--- /dev/null
+++ b/tests/generic/505
@@ -0,0 +1,84 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Red Hat Inc.  All Rights Reserved.
+#
+# FS QA Test 505
+#
+# FIBMAP basic test, cover 79b3dbe4adb3 fs: fix iomap_bmap position calculation
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_command "$FILEFRAG_PROG" filefrag
+
+TESTFILE="$SCRATCH_MNT/$seq-testfile"
+
+# Use filefrag -B option to force the use of the older FIBMAP ioctl instead of
+# the FIEMAP ioctl.
+verify_filefrag()
+{
+	local frag_info
+	local paddr
+
+	# record details in .full file
+	${FILEFRAG_PROG} -Bes -v $TESTFILE >> $seqres.full
+
+	# Due to physical things can't be golden image, so only output logical
+	# information at here
+	frag_info=`${FILEFRAG_PROG} -Be $TESTFILE | _filter_filefrag`
+	echo "$frag_info" | cut -d# -f3-
+
+	# Then verify physical data by physical address
+	_scratch_unmount
+	for i in $frag_info; do
+		paddr=`echo $i | cut -d# -f 1`
+		od -j $paddr -N 1048576 -t x1 $SCRATCH_DEV | \
+			sed -e 's/^[0-9a-f]\+/XXXX /'
+	done
+	_scratch_mount
+}
+
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount
+
+echo "== FIBMAP on an empty file =="
+$XFS_IO_PROG -f -c "truncate 0" $TESTFILE > /dev/null
+verify_filefrag
+
+echo "== FIBMAP on 1M general file =="
+$XFS_IO_PROG -f -t -c "pwrite -S 0xaa 0 1m" $TESTFILE > /dev/null
+verify_filefrag
+
+echo "== FIBMAP on 5M sparse file =="
+$XFS_IO_PROG -f -t -c "pwrite -S 0xaa 0 1m" \
+	     -c "pwrite -S 0xaa 2m 1m" \
+	     -c "pwrite -S 0xaa 4m 1m" \
+	     $TESTFILE > /dev/null
+verify_filefrag
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/505.out b/tests/generic/505.out
new file mode 100644
index 00000000..2a310ee8
--- /dev/null
+++ b/tests/generic/505.out
@@ -0,0 +1,21 @@
+QA output created by 505
+== FIBMAP on an empty file ==
+
+== FIBMAP on 1M general file ==
+0#merged,eof
+XXXX  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+XXXX 
+== FIBMAP on 5M sparse file ==
+0#merged
+2097152#merged
+4194304#merged,eof
+XXXX  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+XXXX 
+XXXX  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+XXXX 
+XXXX  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+XXXX 
diff --git a/tests/generic/group b/tests/generic/group
index 55155de8..018c5d2d 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -507,3 +507,4 @@
 502 auto quick log
 503 auto quick dax punch collapse zero
 504 auto quick locks
+505 auto quick
-- 
2.14.4
