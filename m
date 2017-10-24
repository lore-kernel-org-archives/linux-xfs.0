Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42650 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751334AbdJXRqe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Oct 2017 13:46:34 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B0A18C056786
        for <linux-xfs@vger.kernel.org>; Tue, 24 Oct 2017 17:46:34 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 837015D9CB
        for <linux-xfs@vger.kernel.org>; Tue, 24 Oct 2017 17:46:34 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC] tests/xfs: test writepage cached mapping validity
Date: Tue, 24 Oct 2017 13:46:33 -0400
Message-Id: <20171024174633.58874-1-bfoster@redhat.com>
In-Reply-To: <20171024174527.58767-1-bfoster@redhat.com>
References: <20171024174527.58767-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

XFS has a bug where page writeback can end up sending data to the
wrong location due to a stale, cached file mapping. Add a test to
trigger this problem using the DEBUG mode error injection tag that
is available to widen the race window.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tests/xfs/999     | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/999.out |   2 ++
 tests/xfs/group   |   1 +
 3 files changed, 105 insertions(+)
 create mode 100755 tests/xfs/999
 create mode 100644 tests/xfs/999.out

diff --git a/tests/xfs/999 b/tests/xfs/999
new file mode 100755
index 0000000..ef0c0d2
--- /dev/null
+++ b/tests/xfs/999
@@ -0,0 +1,102 @@
+#! /bin/bash
+# FS QA Test 999
+#
+# Test XFS page writeback code for races with the cached file mapping. XFS
+# caches the file -> block mapping for a full extent once it is initially looked
+# up. The cached mapping is used for all subsequent pages in the same writeback
+# cycle that cover the associated extent. Under certain conditions, it is
+# possible for concurrent operations on the file to invalidate the cached
+# mapping without the knowledge of writeback. Writeback ends up sending I/O to a
+# partly stale mapping and potentially leaving delalloc blocks in the current
+# mapping unconverted.
+#
+# Note that this test depends on XFS DEBUG mode error injection to widen the
+# race window long enough to reproduce.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Red Hat, Inc.  All Rights Reserved.
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
+_require_scratch
+_require_xfs_io_error_injection writepage_delay
+
+_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount || _fail "mount failed"
+
+file=$SCRATCH_MNT/file
+
+# First truncate the file and fsync to get the file size on-disk. This is
+# necessary so the subsequent truncate down won't wait on writeback. We want the
+# next truncate to race with writeback and truncate on XFS will actually flush
+# and wait if the current in-core size doesn't match the on-disk inode size.
+$XFS_IO_PROG -fc "truncate 64k" -c fsync $file >> $seqres.full 2>&1
+
+# Create an initial delalloc mapping. We use 64k because reproducing the problem
+# requires the affected page to be part of a subsequent pagevec scan than the
+# one where we will block. The pagevec size is 14 pages (or 56k with a typical
+# 4k page sized system), so 64k ensures that writeback will require two pagevec
+# lookups.
+$XFS_IO_PROG -c "pwrite -b 64k 0 64k" $file >> $seqres.full 2>&1
+
+_scratch_inject_error writepage_delay 1
+
+# Now that the writepage delay is enabled, issue writeback and a racing truncate
+# and rewrite of the final page. Note that 'sync' is required to reproduce this
+# reliably.
+sync &
+$XFS_IO_PROG -c "truncate 60k" \
+	     -c "pwrite -S 0xef 60k 4k" $file >> $seqres.full 2>&1
+
+wait
+
+_scratch_inject_error writepage_delay 0
+
+# If the test fails, the most likely outcome is an sb_fdblocks mismatch and an
+# associated lingering delalloc assert failure.
+
+echo Silence is golden
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/999.out b/tests/xfs/999.out
new file mode 100644
index 0000000..3b276ca
--- /dev/null
+++ b/tests/xfs/999.out
@@ -0,0 +1,2 @@
+QA output created by 999
+Silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index b439842..a109bbb 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -431,3 +431,4 @@
 431 auto quick dangerous
 432 auto quick dir metadata
 433 auto quick attr
+999 auto quick
-- 
2.9.5

