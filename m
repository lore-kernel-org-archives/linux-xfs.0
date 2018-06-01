Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33772 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750934AbeFAIHl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Jun 2018 04:07:41 -0400
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH 1/3] xfstests: dedupe a single big file and verify integrity
Date: Fri,  1 Jun 2018 16:07:31 +0800
Message-Id: <20180601080733.20703-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

Duperemove is a tool for finding duplicated extents and submitting
them for deduplication, and it supports XFS. This case trys to
verify the integrity of XFS after running duperemove.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
Hi,

The V1 should be:
https://www.spinics.net/lists/linux-xfs/msg18982.html

This time I send 3 cases at same time.

Thanks,
Zorro

 common/config        |  1 +
 tests/shared/008     | 79 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/shared/008.out |  3 ++
 tests/shared/group   |  1 +
 4 files changed, 84 insertions(+)
 create mode 100755 tests/shared/008
 create mode 100644 tests/shared/008.out

diff --git a/common/config b/common/config
index 02c378a9..def559c1 100644
--- a/common/config
+++ b/common/config
@@ -207,6 +207,7 @@ export SQLITE3_PROG="`set_prog_path sqlite3`"
 export TIMEOUT_PROG="`set_prog_path timeout`"
 export SETCAP_PROG="`set_prog_path setcap`"
 export GETCAP_PROG="`set_prog_path getcap`"
+export DUPEREMOVE_PROG="`set_prog_path duperemove`"
 
 # use 'udevadm settle' or 'udevsettle' to wait for lv to be settled.
 # newer systems have udevadm command but older systems like RHEL5 don't.
diff --git a/tests/shared/008 b/tests/shared/008
new file mode 100755
index 00000000..74362807
--- /dev/null
+++ b/tests/shared/008
@@ -0,0 +1,79 @@
+#! /bin/bash
+# FS QA Test 008
+#
+# Dedupe a single big file and verify integrity
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2018 Red Hat Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
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
+. ./common/reflink
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# duperemove only supports btrfs and xfs (with reflink feature).
+# Add other filesystems if it supports more later.
+_supported_fs xfs btrfs
+_supported_os Linux
+_require_scratch_dedupe
+_require_command "$DUPEREMOVE_PROG" duperemove
+
+fssize=$((2 * 1024 * 1024 * 1024))
+_scratch_mkfs_sized $fssize > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+# fill the fs with a big file has same contents
+$XFS_IO_PROG -f -c "pwrite -S 0x55 0 $fssize" $SCRATCH_MNT/${seq}.file \
+	>> $seqres.full 2>&1
+md5sum $SCRATCH_MNT/${seq}.file > $TEST_DIR/${seq}md5.sum
+
+echo "= before cycle mount ="
+# Dedupe with 1M blocksize
+$DUPEREMOVE_PROG -dr --dedupe-options=same -b 1048576 $SCRATCH_MNT/ >>$seqres.full 2>&1
+# Verify integrity
+md5sum -c --quiet $TEST_DIR/${seq}md5.sum
+# Dedupe with 64k blocksize
+$DUPEREMOVE_PROG -dr --dedupe-options=same -b 65536 $SCRATCH_MNT/ >>$seqres.full 2>&1
+# Verify integrity again
+md5sum -c --quiet $TEST_DIR/${seq}md5.sum
+
+# umount and mount again, verify pagecache contents don't mutate
+_scratch_cycle_mount
+echo "= after cycle mount ="
+md5sum -c --quiet $TEST_DIR/${seq}md5.sum
+
+status=0
+exit
diff --git a/tests/shared/008.out b/tests/shared/008.out
new file mode 100644
index 00000000..f29d478f
--- /dev/null
+++ b/tests/shared/008.out
@@ -0,0 +1,3 @@
+QA output created by 008
+= before cycle mount =
+= after cycle mount =
diff --git a/tests/shared/group b/tests/shared/group
index b3663a03..de7fe79f 100644
--- a/tests/shared/group
+++ b/tests/shared/group
@@ -10,6 +10,7 @@
 005 dangerous_fuzzers
 006 auto enospc
 007 dangerous_fuzzers
+008 auto quick dedupe
 032 mkfs auto quick
 272 auto enospc rw
 289 auto quick
-- 
2.14.3

