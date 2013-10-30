Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CD5417F4E
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 05:39:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A39DE304048
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 03:39:08 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 7vgcFBOW9clK9PAm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 30 Oct 2013 03:39:07 -0700 (PDT)
From: Liu Bo <bo.li.liu@oracle.com>
Subject: [PATCH] xfstests: add regression test for running btrfs balance and
	defrag concurrently
Date: Wed, 30 Oct 2013 18:38:53 +0800
Message-Id: <1383129533-17043-1-git-send-email-bo.li.liu@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-btrfs@vger.kernel.org
Cc: xfs@oss.sgi.com

The test aims to trigger snapshot-aware defrag path in write endio by
running balance, which is not expected and leads to a crash.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 tests/btrfs/021     |   97 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/021.out |    2 +
 tests/btrfs/group   |    1 +
 3 files changed, 100 insertions(+), 0 deletions(-)
 create mode 100755 tests/btrfs/021
 create mode 100644 tests/btrfs/021.out

diff --git a/tests/btrfs/021 b/tests/btrfs/021
new file mode 100755
index 0000000..147ac29
--- /dev/null
+++ b/tests/btrfs/021
@@ -0,0 +1,97 @@
+#! /bin/bash
+# FS QA Test No. 021
+#
+# A regression test of running btrfs balance and defrag concurrently.
+#
+# The test aims to trigger snapshot-aware defrag path in endio by
+# running balance, which is not expected and leads to a crash.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Oracle.  All Rights Reserved.
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
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+run_test()
+{
+	$BTRFS_UTIL_PROG balance start $SCRATCH_MNT >> $seqres.full &
+
+	sleep 0.5
+
+	find $SCRATCH_MNT -type f -print0 | xargs -0 $BTRFS_UTIL_PROG filesystem defrag -f
+
+	sync
+	wait
+}
+
+# Modify as appropriate.
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+rm -f $seqres.full
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+
+
+for ((j=0; j<100; j++))
+do
+	touch $SCRATCH_MNT/padding-$j
+done
+
+for ((j=0; j<50; j++))
+do
+	for i in `seq 20 -1 1`
+	do
+		dd if=/dev/zero of=$SCRATCH_MNT/foo-$j bs=4k count=1 seek=$i oflag=direct conv=notrunc 2>/dev/null;
+	done
+done
+
+sync
+
+run_test
+
+# if error
+#exit
+
+# optional stuff if your test has verbose output to help resolve problems
+#echo
+#echo "If failure, check $seqres.full (this) and $seqres.full.ok (reference)"
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/btrfs/021.out b/tests/btrfs/021.out
new file mode 100644
index 0000000..09f4062
--- /dev/null
+++ b/tests/btrfs/021.out
@@ -0,0 +1,2 @@
+QA output created by 021
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 1159499..410f8ed 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -23,3 +23,4 @@
 018 auto quick
 019 auto quick
 020 auto quick
+021 auto quick
-- 
1.7.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
