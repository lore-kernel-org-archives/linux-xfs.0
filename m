Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41684 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbeJXClI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Oct 2018 22:41:08 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] tests/xfs: writepage map error unmount test
Date: Tue, 23 Oct 2018 14:16:38 -0400
Message-Id: <20181023181638.43407-1-bfoster@redhat.com>
In-Reply-To: <20181023181543.43315-1-bfoster@redhat.com>
References: <20181023181543.43315-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org

Certain failures in the page writeback codepath can cause a broader
writeback (i.e., a sync) sequence to exit prematurely. If this
occurs during an unmount, it's likely the filesystem will reclaim
inodes without having cleared all delayed allocation blocks. This
produces a warning and leaves the filesystem inconsistent.

This test reproduces this scenario using the 'writepage_map'
errortag. It performs delayed allocation, injects writeback errors
and immediately unmounts the filesystem.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Note that this depends on a not yet available error tag.

Brian

 tests/xfs/494     | 57 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/494.out |  2 ++
 tests/xfs/group   |  1 +
 3 files changed, 60 insertions(+)
 create mode 100755 tests/xfs/494
 create mode 100644 tests/xfs/494.out

diff --git a/tests/xfs/494 b/tests/xfs/494
new file mode 100755
index 00000000..30877d38
--- /dev/null
+++ b/tests/xfs/494
@@ -0,0 +1,57 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test 494
+#
+# Simulate a serialization problem between page writeback error handling and
+# unmount. If ->writepages() fails and returns an error back to the mm
+# subsystem, writeback of subsequent pages is interrupted and the filesystem
+# unmounts before processing all dirty pages. This results in unmounting a
+# filesystem with dirty+delalloc pages, which in turn causes unmount time
+# warnings and filesystem inconsistency.
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
+. ./common/inject
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_error_injection
+_require_xfs_io_error_injection "writepage_map"
+_require_scratch
+
+_scratch_mkfs >> $seqres.full 2>&1
+
+_scratch_mount
+_scratch_inject_error "writepage_map" 1
+# use 512k to dirty multiple pages on large page size systems
+$XFS_IO_PROG -fc "pwrite 0 512k" $SCRATCH_MNT/file >> $seqres.full 2>&1
+_scratch_unmount
+
+echo Silence is golden
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/494.out b/tests/xfs/494.out
new file mode 100644
index 00000000..827c239a
--- /dev/null
+++ b/tests/xfs/494.out
@@ -0,0 +1,2 @@
+QA output created by 494
+Silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index 2cec0585..136d3707 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -491,3 +491,4 @@
 491 auto quick fuzz
 492 auto quick fuzz
 493 auto quick fuzz
+494 auto quick
-- 
2.17.2
