Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0A4DE7FC7
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 11:26:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DE34C304059
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 09:26:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id e2IQzFBPVKFTcaNg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 09:26:36 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] generic/033: add xfs delalloc indirect block depletion
	reproducer
Date: Thu, 25 Sep 2014 12:26:31 -0400
Message-Id: <1411662391-56463-1-git-send-email-bfoster@redhat.com>
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
To: fstests@vger.kernel.org
Cc: xfs@oss.sgi.com

XFS allocates extra indirect blocks for delayed allocation extents at
write time. When delalloc extents are split, the existing indirect block
reservation was historically divided up evenly among the new extents
even though the overall requirement for two extents could exceed the
requirement for the original. Repeated delalloc extent splits ultimately
leads to extents with 0 indirect blocks and in turn leads to assert
failures in XFS.

Add a test to stress indirect block reservation for delayed allocation
extents. The test converts a single delalloc extent to many and operates
on the remaining extents to detect or trigger potential problems.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Eryu Guan <eguan@redhat.com>
---

v2:
- Remove xfs_io output filter from output to $seqres.full.
v1: http://oss.sgi.com/archives/xfs/2014-09/msg00371.html

 tests/generic/033     | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/033.out |  4 +++
 tests/generic/group   |  1 +
 3 files changed, 89 insertions(+)
 create mode 100755 tests/generic/033
 create mode 100644 tests/generic/033.out

diff --git a/tests/generic/033 b/tests/generic/033
new file mode 100755
index 0000000..d221fcd
--- /dev/null
+++ b/tests/generic/033
@@ -0,0 +1,84 @@
+#! /bin/bash
+# FS QA Test No. 033
+#
+# This test stresses indirect block reservation for delayed allocation extents.
+# XFS reserves extra blocks for deferred allocation of delalloc extents. These
+# reserved blocks can be divided among more extents than anticipated if the
+# original extent for which the blocks were reserved is split into multiple
+# delalloc extents. If this scenario repeats, eventually some extents are left
+# without any indirect block reservation whatsoever. This leads to assert
+# failures and possibly other problems in XFS.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Red Hat, Inc.  All Rights Reserved.
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
+
+# real QA test starts here
+rm -f $seqres.full
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_xfs_io_command "fzero"
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+file=$SCRATCH_MNT/file.$seq
+bytes=$((64 * 1024))
+
+# create sequential delayed allocation
+$XFS_IO_PROG -f -c "pwrite 0 $bytes" $file >> $seqres.full 2>&1
+
+# Zero every other 4k range to split the larger delalloc extent into many more
+# smaller extents. Use zero instead of hole punch because the former does not
+# force writeback (and hence delalloc conversion). It can simply discard
+# delalloc blocks and convert the ranges to unwritten.
+endoff=$((bytes - 4096))
+for i in $(seq 0 8192 $endoff); do
+	$XFS_IO_PROG -c "fzero -k $i 4k" $file >> $seqres.full 2>&1
+done
+
+# now zero the opposite set to remove remaining delalloc extents
+for i in $(seq 4096 8192 $endoff); do
+	$XFS_IO_PROG -c "fzero -k $i 4k" $file >> $seqres.full 2>&1
+done
+
+_scratch_remount
+hexdump $file
+
+status=0
+exit
diff --git a/tests/generic/033.out b/tests/generic/033.out
new file mode 100644
index 0000000..419d831
--- /dev/null
+++ b/tests/generic/033.out
@@ -0,0 +1,4 @@
+QA output created by 033
+0000000 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0010000
diff --git a/tests/generic/group b/tests/generic/group
index 8e0c22a..1227408 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -32,6 +32,7 @@
 027 auto enospc
 028 auto quick
 032 auto quick rw
+033 auto quick rw
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
