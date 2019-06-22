Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59506 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726290AbfFVPie (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 22 Jun 2019 11:38:34 -0400
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH v2] xfs: test xfs_info on block device and mountpoint
Date: Sat, 22 Jun 2019 23:38:27 +0800
Message-Id: <20190622153827.4448-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

There was a bug, xfs_info fails on a mounted block device:

  # xfs_info /dev/mapper/testdev
  xfs_info: /dev/mapper/testdev contains a mounted filesystem

  fatal error -- couldn't initialize XFS library

xfsprogs has fixed it by:

  bbb43745 xfs_info: use findmnt to handle mounted block devices

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Thanks the reviewing from Darrick and Eryu,

V2 did below changes:
1) Compare the contents between the two xfs_info invocations in test_xfs_info()
2) document the commit that the case cover
3) Add more comments
4) Move the test on unmounted device to the end

Sorry Eryu, I'll keep the case number next time :)

Thanks,
Zorro

 tests/xfs/1000     | 82 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1000.out |  2 ++
 tests/xfs/group    |  1 +
 3 files changed, 85 insertions(+)
 create mode 100755 tests/xfs/1000
 create mode 100644 tests/xfs/1000.out

diff --git a/tests/xfs/1000 b/tests/xfs/1000
new file mode 100755
index 00000000..721bcdf2
--- /dev/null
+++ b/tests/xfs/1000
@@ -0,0 +1,82 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 1000
+#
+# test xfs_info on block device and mountpoint, uncover xfsprogs commit:
+#    bbb43745 xfs_info: use findmnt to handle mounted block devices
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
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_scratch
+
+info_file=$tmp.$seq.info
+
+test_xfs_info()
+{
+	local target="$1"
+	local tmpfile=$tmp.$seq.info.tmp
+	local need_cmp=0
+
+	# save the *old* xfs_info file, to compare with the new one later
+	if [ -f $info_file ]; then
+		cat $info_file > $tmpfile
+		need_cmp=1
+	fi
+
+	$XFS_INFO_PROG $target > $info_file 2>&1
+	if [ $? -ne 0 ];then
+		echo "$XFS_INFO_PROG $target fails:"
+		cat $info_file
+	else
+		cat $info_file >> $seqres.full
+	fi
+	# compare the contents between the two xfs_info invocations
+	if [ $need_cmp -eq 1 ]; then
+		diff $tmpfile $info_file
+	fi
+}
+
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount
+# test mounted block device and mountpoint
+test_xfs_info $SCRATCH_DEV
+test_xfs_info $SCRATCH_MNT
+
+# test on unmounted block device
+_scratch_unmount
+# Due to new xfsprogs use xfs_db 'info' command to get the information of
+# offline XFS, it supports running on a unmounted device. But old xfsprogs
+# doesn't support it, so skip that.
+$XFS_DB_PROG -c "info" $SCRATCH_DEV | grep -q "command info not found"
+if [ $? -ne 0 ]; then
+	test_xfs_info $SCRATCH_DEV
+fi
+
+echo "Silence is golden"
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1000.out b/tests/xfs/1000.out
new file mode 100644
index 00000000..681b3b48
--- /dev/null
+++ b/tests/xfs/1000.out
@@ -0,0 +1,2 @@
+QA output created by 1000
+Silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index ffe4ae12..047fe332 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -504,3 +504,4 @@
 504 auto quick mkfs label
 505 auto quick spaceman
 506 auto quick health
+1000 auto quick
-- 
2.17.2
