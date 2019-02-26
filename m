Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41380 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728791AbfBZSOI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Feb 2019 13:14:08 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] generic: skip dm-log-writes tests on XFS v5 superblock filesystems
Date: Tue, 26 Feb 2019 13:14:07 -0500
Message-Id: <20190226181407.44612-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

The dm-log-writes mechanism runs a workload against a filesystem,
tracks underlying FUAs and restores the filesystem to various points
in time based on FUA marks. This allows fstests to check fs
consistency at various points and verify log recovery works as
expected.

This mechanism does not play well with LSN based log recovery
ordering behavior on XFS v5 superblocks, however. For example,
generic/482 can reproduce false positive corruptions based on extent
to btree conversion of an inode if the inode and associated btree
block are written back after different checkpoints. Even though both
items are logged correctly in the extent-to-btree transaction, the
btree block can be relogged (multiple times) and only written back
once when the filesystem unmounts. If the inode was written back
after the initial conversion, recovery points between that mark and
when the btree block is ultimately written back will show corruption
because log recovery sees that the destination buffer is newer than
the recovered buffer and intentionally skips the buffer. This is a
false positive because the destination buffer was resiliently
written back after being physically relogged one or more times.

Update the dm-log-writes require checks to enforce v4 superblocks
when running against XFS and skip the test otherwise.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 common/dmlogwrites |  6 ++++++
 common/xfs         | 11 +++++++++++
 tests/generic/482  |  1 -
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/common/dmlogwrites b/common/dmlogwrites
index b9cbae7a..f2fbb733 100644
--- a/common/dmlogwrites
+++ b/common/dmlogwrites
@@ -12,6 +12,9 @@ _require_log_writes()
 	_exclude_scratch_mount_option dax
 	_require_dm_target log-writes
 	_require_test_program "log-writes/replay-log"
+	if [ "$FSTYP" == "xfs" ]; then
+		_require_scratch_xfs_nocrc
+	fi
 }
 
 # Starting from v4.15-rc1, DAX support was added to dm-log-writes, but note
@@ -30,6 +33,9 @@ _require_log_writes_dax()
 
 	_require_dm_target log-writes
 	_require_test_program "log-writes/replay-log"
+	if [ "$FSTYP" == "xfs" ]; then
+		_require_scratch_xfs_nocrc
+	fi
 
 	local ret=0
 	_log_writes_init
diff --git a/common/xfs b/common/xfs
index 24065813..525cb9cb 100644
--- a/common/xfs
+++ b/common/xfs
@@ -240,6 +240,17 @@ _require_scratch_xfs_crc()
 	_scratch_unmount
 }
 
+# this test requires the scratch dev to be formatted as v4
+#
+_require_scratch_xfs_nocrc()
+{
+	_scratch_mkfs_xfs >/dev/null 2>&1
+	_scratch_mount >/dev/null 2>&1
+	$XFS_INFO_PROG $SCRATCH_MNT | grep -q 'crc=0' ||
+		_notrun "XFS v5 superblocks not supported by this test"
+	_scratch_unmount
+}
+
 # this test requires the finobt feature to be available in mkfs.xfs
 #
 _require_xfs_mkfs_finobt()
diff --git a/tests/generic/482 b/tests/generic/482
index 7595aa59..7870ac5b 100755
--- a/tests/generic/482
+++ b/tests/generic/482
@@ -45,7 +45,6 @@ _require_scratch
 # and we need extra device as log device
 _require_log_writes
 
-
 nr_cpus=$("$here/src/feature" -o)
 # cap nr_cpus to 8 to avoid spending too much time on hosts with many cpus
 if [ $nr_cpus -gt 8 ]; then
-- 
2.17.2
