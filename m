Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33776 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750973AbeFAIHt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Jun 2018 04:07:49 -0400
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH 2/3] xfstests: iterate dedupe integrity test
Date: Fri,  1 Jun 2018 16:07:32 +0800
Message-Id: <20180601080733.20703-2-zlang@redhat.com>
In-Reply-To: <20180601080733.20703-1-zlang@redhat.com>
References: <20180601080733.20703-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

This case does dedupe on a dir, then copy the dir to next dir. Dedupe
the next dir again, then copy this dir to next again, and dedupe
again ... At the end, verify the data in the last dir is still same
with the first one.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 tests/shared/009     | 114 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/shared/009.out |   4 ++
 tests/shared/group   |   1 +
 3 files changed, 119 insertions(+)
 create mode 100755 tests/shared/009
 create mode 100644 tests/shared/009.out

diff --git a/tests/shared/009 b/tests/shared/009
new file mode 100755
index 00000000..f1f9215f
--- /dev/null
+++ b/tests/shared/009
@@ -0,0 +1,114 @@
+#! /bin/bash
+# FS QA Test 009
+#
+# Iterate dedupe integrity test
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
+# real QA test starts here
+
+# duperemove only supports btrfs and xfs (with reflink feature).
+# Add other filesystems if it supports more later.
+_supported_fs xfs btrfs
+_supported_os Linux
+_require_scratch_dedupe
+_require_command "$DUPEREMOVE_PROG" duperemove
+
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+function iterate_dedup_verify()
+{
+	local src=$srcdir
+	local dest=$dupdir/1
+
+	for ((index = 1; index <= times; index++))
+	do
+		cp -a $src $dest
+		find $dest -type f -exec md5sum {} \; \
+			> $md5file$index
+		# Too many output, so only save error output
+		$DUPEREMOVE_PROG -dr --dedupe-options=same $dupdir \
+			>/dev/null 2>$seqres.full
+		md5sum -c --quiet $md5file$index
+		src=$dest
+		dest=$dupdir/$((index + 1))
+	done
+}
+
+srcdir=$SCRATCH_MNT/src
+dupdir=$SCRATCH_MNT/dup
+mkdir $srcdir $dupdir
+
+md5file=$TEST_DIR/${seq}md5.sum
+
+fsstress_opts="-w -r -f mknod=0"
+# Create some files to be original data
+$FSSTRESS_PROG $fsstress_opts -d $srcdir \
+	       -n 200 -p $((5 * LOAD_FACTOR)) >/dev/null 2>&1
+
+# Calculate how many test cycles will be run
+src_size=`du -ks $srcdir | awk '{print $1}'`
+free_size=`df -kP $SCRATCH_MNT | grep -v Filesystem | awk '{print $4}'`
+times=$((free_size / src_size))
+if [ $times -gt $((10 * TIME_FACTOR)) ]; then
+	times=$((10 * TIME_FACTOR))
+fi
+
+echo "= Do dedup and verify ="
+iterate_dedup_verify
+
+# Use the last checksum file to verify the original data
+sed -e s#dup/$times#src#g $md5file$times > $md5file
+echo "= Backwords verify ="
+md5sum -c --quiet $md5file
+
+# read from the disk also doesn't show mutations.
+_scratch_cycle_mount
+echo "= Verify after cycle mount ="
+for ((index = 1; index <= times; index++))
+do
+	md5sum -c --quiet $md5file$index
+done
+
+status=0
+exit
diff --git a/tests/shared/009.out b/tests/shared/009.out
new file mode 100644
index 00000000..44a78ba3
--- /dev/null
+++ b/tests/shared/009.out
@@ -0,0 +1,4 @@
+QA output created by 009
+= Do dedup and verify =
+= Backwords verify =
+= Verify after cycle mount =
diff --git a/tests/shared/group b/tests/shared/group
index de7fe79f..2255844b 100644
--- a/tests/shared/group
+++ b/tests/shared/group
@@ -11,6 +11,7 @@
 006 auto enospc
 007 dangerous_fuzzers
 008 auto quick dedupe
+009 auto dedupe
 032 mkfs auto quick
 272 auto enospc rw
 289 auto quick
-- 
2.14.3

