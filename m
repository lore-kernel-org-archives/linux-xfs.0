Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33162 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751652AbeFWSAh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jun 2018 14:00:37 -0400
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH v3 1/3] xfstests: dedupe a single big file and verify integrity
Date: Sun, 24 Jun 2018 02:00:27 +0800
Message-Id: <20180623180029.24497-1-zlang@redhat.com>
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

V3 update description about SPDX-License.

Thanks,
Zorro

 common/config        |  1 +
 tests/shared/008     | 64 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/shared/008.out |  3 +++
 tests/shared/group   |  1 +
 4 files changed, 69 insertions(+)
 create mode 100755 tests/shared/008
 create mode 100644 tests/shared/008.out

diff --git a/common/config b/common/config
index 09e7ffee..d02d6ed5 100644
--- a/common/config
+++ b/common/config
@@ -192,6 +192,7 @@ export SETCAP_PROG="$(type -P setcap)"
 export GETCAP_PROG="$(type -P getcap)"
 export CHECKBASHISMS_PROG="$(type -P checkbashisms)"
 export XFS_INFO_PROG="$(type -P xfs_info)"
+export DUPEREMOVE_PROG="$(type -P duperemove)"
 
 # use 'udevadm settle' or 'udevsettle' to wait for lv to be settled.
 # newer systems have udevadm command but older systems like RHEL5 don't.
diff --git a/tests/shared/008 b/tests/shared/008
new file mode 100755
index 00000000..a7d76083
--- /dev/null
+++ b/tests/shared/008
@@ -0,0 +1,64 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Red Hat Inc.  All Rights Reserved.
+#
+# FS QA Test 008
+#
+# Dedupe a single big file and verify integrity
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
+md5sum $SCRATCH_MNT/${seq}.file > ${tmp}.md5sum
+
+echo "= before cycle mount ="
+# Dedupe with 1M blocksize
+$DUPEREMOVE_PROG -dr --dedupe-options=same -b 1048576 $SCRATCH_MNT/ >>$seqres.full 2>&1
+# Verify integrity
+md5sum -c --quiet ${tmp}.md5sum
+# Dedupe with 64k blocksize
+$DUPEREMOVE_PROG -dr --dedupe-options=same -b 65536 $SCRATCH_MNT/ >>$seqres.full 2>&1
+# Verify integrity again
+md5sum -c --quiet ${tmp}.md5sum
+
+# umount and mount again, verify pagecache contents don't mutate
+_scratch_cycle_mount
+echo "= after cycle mount ="
+md5sum -c --quiet ${tmp}.md5sum
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
index b3663a03..49ffa8dd 100644
--- a/tests/shared/group
+++ b/tests/shared/group
@@ -10,6 +10,7 @@
 005 dangerous_fuzzers
 006 auto enospc
 007 dangerous_fuzzers
+008 auto stress dedupe
 032 mkfs auto quick
 272 auto enospc rw
 289 auto quick
-- 
2.14.4

