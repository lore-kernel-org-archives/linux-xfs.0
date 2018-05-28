Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:42258 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751183AbeE1Eyd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 May 2018 00:54:33 -0400
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] xfstests/shared: dedup integrity test by duperemove
Date: Mon, 28 May 2018 12:54:27 +0800
Message-Id: <20180528045427.11159-1-zlang@redhat.com>
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

There's not many softwares support XFS dedup now, duperemove is a rare one.
So I write this case by using duperemove.

I use fsstress to make many files and data randomly, I don't know if there're
better things I can use? Because fsstress only write '0xff' into files, maybe
I should add an option to make fsstress can write random character?

Please tell me, if you have better ideas:)

PS: This case test passed on XFS(with reflink=1) and btrfs. And the duperemove
can reclaim some space in the test, see below:

  Before duperemove
    Filesystem                 1K-blocks    Used Available Use% Mounted on
    /dev/mapper/xxxx-xfscratch 31441920K 583692K 30858228K   2% /mnt/scratch

  After duperemove
    Filesystem                 1K-blocks    Used Available Use% Mounted on
    /dev/mapper/xxxx-xfscratch 31441920K 345728K 31096192K   2% /mnt/scratch

Thanks,
Zorro

 common/config        |  1 +
 tests/shared/008     | 88 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/shared/008.out |  2 ++
 tests/shared/group   |  1 +
 4 files changed, 92 insertions(+)
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
index 00000000..dace5429
--- /dev/null
+++ b/tests/shared/008
@@ -0,0 +1,88 @@
+#! /bin/bash
+# FS QA Test 008
+#
+# Dedup integrity test by duperemove
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
+_require_scratch_reflink
+
+[ "$DUPEREMOVE_PROG" = "" ] && _notrun "duperemove not found"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+fsstress_opts="-w -r -f mknod=0"
+# Create some files and make a duplicate
+$FSSTRESS_PROG $fsstress_opts -d $testdir \
+	       -n $((500 * LOAD_FACTOR)) -p 10 >/dev/null 2>&1
+duptestdir=${testdir}.dup
+cp -a $testdir $duptestdir
+
+# Make some difference in two directories
+$FSSTRESS_PROG $fsstress_opts -d $testdir -n 200 -p 5 >/dev/null 2>&1
+$FSSTRESS_PROG $fsstress_opts -d $duptestdir -n 200 -p 5 >/dev/null 2>&1
+
+# Record all files' md5 checksum
+find $testdir -type f -exec md5sum {} \; > $TEST_DIR/${seq}md5.sum
+find $duptestdir -type f -exec md5sum {} \; > $TEST_DIR/dup${seq}md5.sum
+
+# Dedup
+echo "== Duperemove output ==" >> $seqres.full
+$DUPEREMOVE_PROG -dr $SCRATCH_MNT/ >>$seqres.full 2>&1
+
+# Verify all files' integrity
+md5sum -c --quiet $TEST_DIR/${seq}md5.sum
+md5sum -c --quiet $TEST_DIR/dup${seq}md5.sum
+
+echo "Silence is golden"
+
+status=0
+exit
diff --git a/tests/shared/008.out b/tests/shared/008.out
new file mode 100644
index 00000000..dd68d5a4
--- /dev/null
+++ b/tests/shared/008.out
@@ -0,0 +1,2 @@
+QA output created by 008
+Silence is golden
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

