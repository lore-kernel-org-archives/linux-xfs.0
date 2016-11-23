Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44400 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755461AbcKWCLO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Nov 2016 21:11:14 -0500
Subject: [PATCH 3/3] ocfs2: test reflinking to inline data files
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 22 Nov 2016 18:11:06 -0800
Message-ID: <147986706651.27133.4210661621329152871.stgit@birch.djwong.org>
In-Reply-To: <147986705412.27133.3961713804630246198.stgit@birch.djwong.org>
References: <147986705412.27133.3961713804630246198.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Make sure that we can handle reflinking from and to inline-data files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/ocfs2/001     |   88 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ocfs2/001.out |   14 ++++++++
 tests/ocfs2/group   |    1 +
 3 files changed, 103 insertions(+)
 create mode 100755 tests/ocfs2/001
 create mode 100644 tests/ocfs2/001.out
 create mode 100644 tests/ocfs2/group


diff --git a/tests/ocfs2/001 b/tests/ocfs2/001
new file mode 100755
index 0000000..973682d
--- /dev/null
+++ b/tests/ocfs2/001
@@ -0,0 +1,88 @@
+#! /bin/bash
+# FS QA Test No. 001
+#
+# Ensure that reflink works correctly with inline-data files.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs ocfs2
+_require_scratch_reflink
+_require_cp_reflink
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+tunefs.ocfs2 --query '%H' $SCRATCH_DEV | grep -q 'inline-data' || \
+	_notrun "Inline data is not supported."
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+sz=65536
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $sz 0 $sz" $testdir/file1 >> $seqres.full
+echo x > $testdir/file2
+echo x > $testdir/file3
+echo y > $testdir/file4
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $sz 0 $sz" $testdir/file5 >> $seqres.full
+echo a > $testdir/file6
+_scratch_cycle_mount
+
+echo "reflink into the start of file2"
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+
+echo "reflink past the stuff in file3"
+_reflink_range $testdir/file1 0 $testdir/file3 $sz $sz >> $seqres.full
+
+echo "reflink an inline-data file to a regular one"
+_cp_reflink $testdir/file4 $testdir/file5 >> $seqres.full
+
+echo "reflink an inline-data file to another inline-data file"
+_cp_reflink $testdir/file4 $testdir/file6 >> $seqres.full
+
+echo "Verify the whole mess"
+_scratch_cycle_mount
+md5sum $testdir/file* | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/ocfs2/001.out b/tests/ocfs2/001.out
new file mode 100644
index 0000000..99fa43a
--- /dev/null
+++ b/tests/ocfs2/001.out
@@ -0,0 +1,14 @@
+QA output created by 001
+Format and mount
+Create the original files
+reflink into the start of file2
+reflink past the stuff in file3
+reflink an inline-data file to a regular one
+reflink an inline-data file to another inline-data file
+Verify the whole mess
+2d61aa54b58c2e94403fb092c3dbc027  SCRATCH_MNT/test-001/file1
+2d61aa54b58c2e94403fb092c3dbc027  SCRATCH_MNT/test-001/file2
+4e68a2e24b6b0f386ab39d01d902293d  SCRATCH_MNT/test-001/file3
+009520053b00386d1173f3988c55d192  SCRATCH_MNT/test-001/file4
+009520053b00386d1173f3988c55d192  SCRATCH_MNT/test-001/file5
+009520053b00386d1173f3988c55d192  SCRATCH_MNT/test-001/file6
diff --git a/tests/ocfs2/group b/tests/ocfs2/group
new file mode 100644
index 0000000..28e6807
--- /dev/null
+++ b/tests/ocfs2/group
@@ -0,0 +1 @@
+001 auto quick clone

