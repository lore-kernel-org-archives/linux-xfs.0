Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29723 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752624AbdJ0Mzs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Oct 2017 08:55:48 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 2/2] generic: ensure that mmap read doesn't see non-zero past EOF
Date: Fri, 27 Oct 2017 20:53:57 +0800
Message-Id: <20171027125357.25222-2-eguan@redhat.com>
In-Reply-To: <20171027125357.25222-1-eguan@redhat.com>
References: <20171027125357.25222-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

>From mmap(2) manpage, "a file is mapped in multiples of the page
size. For a file that is not a multiple of the page size, the
remaining memory is zeroed when mapped", this test is to test this
behavior.

This is inspired by an XFS bug that truncate down fails to zero
partial block beyond new EOF because it sees unwritten extent and
skipped zeroing wrongly. But the fact is the unwritten extent has
been overwritten by a buffer write, just hasn't been converted to
real allocation yet.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/generic/466     | 121 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/466.out |   9 ++++
 tests/generic/group   |   1 +
 3 files changed, 131 insertions(+)
 create mode 100755 tests/generic/466
 create mode 100644 tests/generic/466.out

diff --git a/tests/generic/466 b/tests/generic/466
new file mode 100755
index 000000000000..0c67bbd27484
--- /dev/null
+++ b/tests/generic/466
@@ -0,0 +1,121 @@
+#! /bin/bash
+# FS QA Test 466
+#
+# Test that mmap read doesn't see non-zero data past EOF.
+#
+# This is inspired by an XFS bug that truncate down fails to zero partial block
+# beyond new EOF because it sees unwritten extent and skipped zeroing wrongly.
+# But the fact is the unwritten extent has been overwritten by a buffer write,
+# just hasn't been converted to real allocation yet.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Red Hat Inc., All Rights Reserved.
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
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_test
+
+# run fsx with and without fsync(2) after write to get more coverage
+do_fsx()
+{
+	echo "fsx --replay-ops ${1#*.}"
+	run_fsx --replay-ops $1 >>$seqres.full
+	echo "fsx -y --replay-ops ${1#*.}"
+	run_fsx -y --replay-ops $1 >>$seqres.full
+}
+
+# simplified fsx operations that work on small and not blocksize-aligned
+# offsets, so filesystems with small block size could reproduce too
+cat >$tmp.fsxops.0 <<EOF
+# create file with unwritten extent, KEEP_SIZE flag is required, otherwise page
+# straddles i_size in the writeback triggered by truncate, range [i_size,
+# page_boundary] will be zeroed there, and bug won't be reproduced
+fallocate 0x0 0x1000 0x0 keep_size
+
+# overwrite the unwritten extents with non-zeros, but extent will stay in
+# unwritten till I/O completion
+write 0x0 0x1000 0x0
+
+# truncate down the file, which should zero range [0x10, blocksize_boundary]
+# but a buggy kernel won't, because it sees unwritten extent and skip zeroing
+truncate 0x0 0x10 0x1000
+
+# unmap the file and invalidate the pagecache of the block
+punch_hole 0x0 0x10 0x10
+
+# mmap reads the whole block from disk, and fsx will check page range beyond
+# EOF to make sure we only see zeros there
+mapread 0x0 0x10 0x10
+EOF
+
+# to get a bit more test coverage, try other operation combinations too
+# same as fsxops.0, but skip punch_hole to keep the pagecache before mapread
+cat >$tmp.fsxops.1 <<EOF
+fallocate 0x0 0x1000 0x0 keep_size
+write 0x0 0x1000 0x0
+truncate 0x0 0x10 0x1000
+mapread 0x0 0x10 0x10
+EOF
+
+# same as fsxops.0, but fallocate without KEEP_SIZE flag
+cat >$tmp.fsxops.2 <<EOF
+fallocate 0x0 0x1000 0x0
+write 0x0 0x1000 0x0
+truncate 0x0 0x10 0x1000
+mapread 0x0 0x10 0x10
+EOF
+
+# this is from the original fsxops when bug was first hit
+cat >$tmp.fsxops.3 <<EOF
+fallocate 0x35870 0xa790 0x0 keep_size
+write 0x2aa50 0xc37f 0x0
+truncate 0x0 0x36dcd 0x36dcf
+zero_range 0x35849 0x1584 0x36dcd
+mapread 0x361c8 0xc05 0x36dcd
+EOF
+
+for i in 0 1 2 3; do
+	do_fsx $tmp.fsxops.$i
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/466.out b/tests/generic/466.out
new file mode 100644
index 000000000000..8430bb462ad1
--- /dev/null
+++ b/tests/generic/466.out
@@ -0,0 +1,9 @@
+QA output created by 466
+fsx --replay-ops fsxops.0
+fsx -y --replay-ops fsxops.0
+fsx --replay-ops fsxops.1
+fsx -y --replay-ops fsxops.1
+fsx --replay-ops fsxops.2
+fsx -y --replay-ops fsxops.2
+fsx --replay-ops fsxops.3
+fsx -y --replay-ops fsxops.3
diff --git a/tests/generic/group b/tests/generic/group
index fbe0a7f4a717..b71644008b55 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -468,3 +468,4 @@
 463 auto quick clone dangerous
 464 auto rw
 465 auto rw quick aio
+466 auto quick
-- 
2.13.6

