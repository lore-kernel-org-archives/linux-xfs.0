Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CEFBE7CD7
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 18:47:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8775A8F8033
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 16:47:40 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id SxK6frBSLQPVphj1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2016 16:47:37 -0700 (PDT)
Subject: [PATCH 12/17] reflink: test cross-mountpoint reflink and dedupe
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 21 Jul 2016 16:47:32 -0700
Message-ID: <146914485237.11762.2526971565060691741.stgit@birch.djwong.org>
In-Reply-To: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
References: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Test sharing blocks via reflink and dedupe between two different
mountpoints of the same filesystem.  This shouldn't work, since
we don't allow cross-mountpoint functions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/927     |   88 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/927.out |    9 +++++
 tests/generic/928     |   86 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/928.out |   10 ++++++
 tests/generic/group   |    2 +
 5 files changed, 195 insertions(+)
 create mode 100755 tests/generic/927
 create mode 100644 tests/generic/927.out
 create mode 100755 tests/generic/928
 create mode 100644 tests/generic/928.out


diff --git a/tests/generic/927 b/tests/generic/927
new file mode 100755
index 0000000..c7d82b7
--- /dev/null
+++ b/tests/generic/927
@@ -0,0 +1,88 @@
+#! /bin/bash
+# FS QA Test No. 927
+#
+# Check that cross-mountpoint reflink doesn't work.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
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
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+	wait
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_cp_reflink
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+otherdir=/tmp/m.$seq
+othertestdir=$otherdir/test-$seq
+rm -rf $otherdir
+mkdir $otherdir
+
+blocks=1
+blksz=65536
+sz=$((blksz * blocks))
+
+echo "Mount otherdir"
+SCRATCH_MNT=$otherdir _scratch_mount
+
+echo "Create file"
+_pwrite_byte 0x61 0 $sz $testdir/file >> $seqres.full
+
+filter_md5() {
+	_filter_scratch | sed -e "s,$otherdir,OTHER_DIR,g"
+}
+
+echo "Reflink one file to another"
+_cp_reflink $testdir/file $othertestdir/otherfiles 2>&1 | filter_md5
+
+echo "Check output"
+md5sum $testdir/file | _filter_scratch
+test -e $othertestdir/otherfile && echo "otherfile should not exist"
+
+echo "Unmount otherdir"
+SCRATCH_MNT=$otherdir _scratch_unmount
+rm -rf $otherdir
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/927.out b/tests/generic/927.out
new file mode 100644
index 0000000..3ef3057
--- /dev/null
+++ b/tests/generic/927.out
@@ -0,0 +1,9 @@
+QA output created by 927
+Format and mount
+Mount otherdir
+Create file
+Reflink one file to another
+cp: failed to clone 'OTHER_DIR/test-927/otherfiles' from 'SCRATCH_MNT/test-927/file': Invalid cross-device link
+Check output
+2d61aa54b58c2e94403fb092c3dbc027  SCRATCH_MNT/test-927/file
+Unmount otherdir
diff --git a/tests/generic/928 b/tests/generic/928
new file mode 100755
index 0000000..86268e7
--- /dev/null
+++ b/tests/generic/928
@@ -0,0 +1,86 @@
+#! /bin/bash
+# FS QA Test No. 928
+#
+# Check that cross-mountpoint dedupe doesn't work.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
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
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+	wait
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_dedupe
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+otherdir=/tmp/m.$seq
+othertestdir=$otherdir/test-$seq
+rm -rf $otherdir
+mkdir $otherdir
+
+blocks=1
+blksz=65536
+sz=$((blocks * blksz))
+
+echo "Mount otherdir"
+SCRATCH_MNT=$otherdir _scratch_mount
+
+echo "Create file"
+_pwrite_byte 0x61 0 $sz $testdir/file >> $seqres.full
+_pwrite_byte 0x61 0 $sz $testdir/otherfile >> $seqres.full
+
+echo "Dedupe one file to another"
+_dedupe_range $testdir/file 0 $othertestdir/otherfile 0 $sz >> $seqres.full
+
+filter_md5() {
+	_filter_scratch | sed -e "s,$otherdir,OTHER_DIR,g"
+}
+echo "Check output"
+md5sum $testdir/file $othertestdir/otherfile | filter_md5
+
+echo "Unmount otherdir"
+SCRATCH_MNT=$otherdir _scratch_unmount
+rm -rf $otherdir
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/928.out b/tests/generic/928.out
new file mode 100644
index 0000000..ef35c5b
--- /dev/null
+++ b/tests/generic/928.out
@@ -0,0 +1,10 @@
+QA output created by 928
+Format and mount
+Mount otherdir
+Create file
+Dedupe one file to another
+dedupe: Invalid cross-device link
+Check output
+2d61aa54b58c2e94403fb092c3dbc027  SCRATCH_MNT/test-928/file
+2d61aa54b58c2e94403fb092c3dbc027  OTHER_DIR/test-928/otherfile
+Unmount otherdir
diff --git a/tests/generic/group b/tests/generic/group
index 97ecb65..18b9775 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -373,3 +373,5 @@
 368 auto quick richacl
 369 auto quick richacl
 370 auto quick richacl
+927 auto quick clone
+928 auto quick clone dedupe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
