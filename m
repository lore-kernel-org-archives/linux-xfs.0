Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36714 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762100AbcINRQk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Sep 2016 13:16:40 -0400
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH v3] fstests: test platform_check_ismounted do its work
Date: Thu, 15 Sep 2016 01:16:37 +0800
Message-Id: <1473873397-18178-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Zorro Lang <zlang@redhat.com>

There's a bug, the ustat() sysetm call is not implemented on someone
arch, but xfsprogs uses this to detect whether a filesystem is
mounted in platform_check_ismounted() function.

If ustat() is not implemented, platform_check_ismounted() return
"isn't mounted" if a filesystem is mounted, that's a big problem, it
will cause corruption.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

V3 removed all return status check.

Thanks,
Zorro

 tests/xfs/284     | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/284.out |   8 ++++
 tests/xfs/group   |   1 +
 3 files changed, 118 insertions(+)
 create mode 100755 tests/xfs/284
 create mode 100644 tests/xfs/284.out

diff --git a/tests/xfs/284 b/tests/xfs/284
new file mode 100755
index 0000000..a680a6a
--- /dev/null
+++ b/tests/xfs/284
@@ -0,0 +1,109 @@
+#! /bin/bash
+# FS QA Test 284
+#
+# Make sure platform_check_ismounted() do its work. A bug cause
+# platform_check_ismounted return "isn't mounted" status, even if
+# the filesystem is mounted. That maybe cause corruption, so must
+# make sure this function always do its work.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Red Hat.  All Rights Reserved.
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
+	rm -f $METADUMP_FILE 2>/dev/null
+	rm -f $COPY_FILE 2>/dev/null
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
+_supported_fs xfs
+_supported_os Linux
+_require_test
+_require_scratch
+
+function filter_mounted()
+{
+	grep "mounted" | _filter_scratch | head -1
+}
+
+METADUMP_FILE="${TEST_DIR}/${seq}_metadump"
+COPY_FILE="${TEST_DIR}/${seq}_copyfile"
+
+# Test dump a mounted device
+# xfs_metadump should refuse to dump a mounted device
+_scratch_mount
+_scratch_metadump $METADUMP_FILE 2>&1 | filter_mounted
+_scratch_unmount
+
+# Test restore to a mounted device
+# xfs_mdrestore should refuse to restore to a mounted device
+_scratch_metadump $METADUMP_FILE
+_scratch_mount
+xfs_mdrestore $METADUMP_FILE $SCRATCH_DEV 2>&1 | filter_mounted
+_scratch_unmount
+
+# Test xfs_copy to a mounted device
+# If source is mounted, xfs_copy will print a warning, but still
+# keep on copying. If target is mounted, xfs_copy should fail.
+$XFS_COPY_PROG $SCRATCH_DEV $COPY_FILE >/dev/null
+_scratch_mount
+$XFS_COPY_PROG $COPY_FILE $SCRATCH_DEV 2>&1 | filter_mounted
+_scratch_unmount
+
+# Test xfs_db a mounted device
+# xfs_db a mounted device without readonly (-r) option should fail
+_scratch_mount
+$XFS_DB_PROG -c sb $SCRATCH_DEV 2>&1 | filter_mounted
+_scratch_unmount
+
+# Test mkfs.xfs a mounted device
+# Generally mkfs will report device is mounted, but if it can't find
+# device is mounted, it'll report device busy.
+_scratch_mount
+_scratch_mkfs 2>&1 | filter_mounted
+_scratch_unmount
+
+# Test xfs_repair (with/without modify flag) a mounted device
+# xfs_repair (with/without modify flag) a mounted device should fail(don't
+# test -d option at here)
+_scratch_mount
+_scratch_xfs_repair -n 2>&1 | filter_mounted
+_scratch_xfs_repair 2>&1 | filter_mounted
+_scratch_unmount
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/284.out b/tests/xfs/284.out
new file mode 100644
index 0000000..302d75e
--- /dev/null
+++ b/tests/xfs/284.out
@@ -0,0 +1,8 @@
+QA output created by 284
+xfs_metadump: SCRATCH_DEV contains a mounted and writable filesystem
+xfs_mdrestore: a filesystem is mounted on target device "SCRATCH_DEV", cannot restore to a mounted filesystem.
+xfs_copy:  a filesystem is mounted on target device "SCRATCH_DEV".
+xfs_db: SCRATCH_DEV contains a mounted filesystem
+mkfs.xfs: SCRATCH_DEV contains a mounted filesystem
+xfs_repair: SCRATCH_DEV contains a mounted and writable filesystem
+xfs_repair: SCRATCH_DEV contains a mounted filesystem
diff --git a/tests/xfs/group b/tests/xfs/group
index baa0ff6..0156960 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -281,6 +281,7 @@
 281 dump ioctl auto quick
 282 dump ioctl auto quick
 283 dump ioctl auto quick
+284 auto quick dump copy db mkfs repair
 287 auto dump quota quick
 290 auto rw prealloc quick ioctl zero
 291 auto repair
-- 
2.7.4

