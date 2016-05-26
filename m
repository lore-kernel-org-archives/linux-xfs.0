Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CE4C07CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 00:57:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A0C738F8054
	for <xfs@oss.sgi.com>; Wed, 25 May 2016 22:57:46 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 8DiHH1cHCZKCLXZS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 May 2016 22:57:44 -0700 (PDT)
Subject: [PATCH 4/7] xfs: test per-ag allocation accounting during
	truncate-caused refcountbt expansion
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 25 May 2016 22:57:29 -0700
Message-ID: <146424224949.6278.1122385565512290875.stgit@birch.djwong.org>
In-Reply-To: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Ensure that refcountbt allocations during truncate operations come
from the per-AG reservation and are not charged to the transaction.

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/855     |   95 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/855.out |   10 ++++++
 tests/xfs/group   |    1 +
 3 files changed, 106 insertions(+)
 create mode 100755 tests/xfs/855
 create mode 100644 tests/xfs/855.out


diff --git a/tests/xfs/855 b/tests/xfs/855
new file mode 100755
index 0000000..93bd286
--- /dev/null
+++ b/tests/xfs/855
@@ -0,0 +1,95 @@
+#! /bin/bash
+# FS QA Test No. 855
+#
+# Ensure that we can create enough distinct reflink entries to force creation
+# of a multi-level refcount btree by reflinking a file a number of times and
+# truncating the copies at successively lower sizes.  Delete and recreate a few
+# times to exercise the refcount btree grow/shrink functions.
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
+    umount $SCRATCH_MNT > /dev/null 2>&1
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
+_supported_fs xfs
+_require_scratch_reflink
+_require_cp_reflink
+
+rm -f $seqres.full
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+echo "Create the original file blocks"
+blksz="$(stat -f $testdir -c '%S')"
+nr_blks=$((2 * blksz / 12))
+
+for i in 1 2 x; do
+	_pwrite_byte 0x61 0 $((blksz * nr_blks)) $testdir/file1 >> $seqres.full
+
+	echo "$i: Reflink a bunch of times"
+	seq 1 $nr_blks | while read nr; do
+		_cp_reflink $testdir/file1 $testdir/file1.$nr >> $seqres.full
+	done
+	sync
+
+	echo "$i: Truncate files"
+	seq 1 $nr_blks | while read nr; do
+		truncate -s $((blksz * (nr_blks - nr))) $testdir/file1.$nr >> $seqres.full
+	done
+
+	umount $SCRATCH_MNT
+	_check_scratch_fs
+	_scratch_mount
+
+	test $i = "x" && break
+
+	echo "$i: Delete both files"
+	rm -rf $testdir
+	mkdir -p $testdir
+	umount $SCRATCH_MNT
+	_check_scratch_fs
+	_scratch_mount
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/855.out b/tests/xfs/855.out
new file mode 100644
index 0000000..d196352
--- /dev/null
+++ b/tests/xfs/855.out
@@ -0,0 +1,10 @@
+QA output created by 855
+Create the original file blocks
+1: Reflink a bunch of times
+1: Truncate files
+1: Delete both files
+2: Reflink a bunch of times
+2: Truncate files
+2: Delete both files
+x: Reflink a bunch of times
+x: Truncate files
diff --git a/tests/xfs/group b/tests/xfs/group
index 4ac62c1..f0ca410 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -287,3 +287,4 @@
 305 auto quota
 853 auto quick clone
 854 auto quick clone
+855 auto clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
