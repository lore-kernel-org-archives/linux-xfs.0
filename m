Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3DFF07F81
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2014 04:28:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2015C304075
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2014 02:28:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ILmj1daDF6dun5DL for
	<xfs@oss.sgi.com>; Wed, 19 Mar 2014 02:28:49 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2J9SmK2030312
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2014 05:28:48 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] shared: new test to use up free inodes
Date: Wed, 19 Mar 2014 17:27:49 +0800
Message-Id: <1395221269-11085-1-git-send-email-eguan@redhat.com>
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
To: xfs@oss.sgi.com
Cc: Eryu Guan <eguan@redhat.com>

Stress test fs by using up all inodes and check fs.

Also a regression test for xfsprogs commit
d586858 xfs_repair: fix sibling pointer tests in verify_dir2_path()

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/shared/006     | 96 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/shared/006.out |  2 ++
 tests/shared/group   |  1 +
 3 files changed, 99 insertions(+)
 create mode 100755 tests/shared/006
 create mode 100644 tests/shared/006.out

diff --git a/tests/shared/006 b/tests/shared/006
new file mode 100755
index 0000000..a3b13b6
--- /dev/null
+++ b/tests/shared/006
@@ -0,0 +1,96 @@
+#! /bin/bash
+# FS QA Test No. shared/006
+#
+# Stress test fs by using up all inodes and check fs.
+#
+# Also a regression test for xfsprogs commit
+# d586858 xfs_repair: fix sibling pointer tests in verify_dir2_path()
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Red Hat Inc.  All Rights Reserved.
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
+create_file()
+{
+	local dir=$1
+	local nr_file=$2
+	local prefix=$3
+	local i=0
+
+	while [ $i -lt $nr_file ]; do
+		touch $dir/${prefix}_${i}
+		let i=$i+1
+	done
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs ext4 ext3 ext2 xfs
+_supported_os Linux
+
+_require_scratch
+
+rm -f $seqres.full
+echo "Silence is golden"
+
+_scratch_mkfs_sized $((1024 * 1024 * 1024)) >>$seqres.full 2>&1
+_scratch_mount
+
+i=0
+free_inode=`df -iP $SCRATCH_MNT | tail -1 | awk '{print $2}'`
+loop=$((free_inode / 1000 + 1))
+mkdir -p $SCRATCH_MNT/testdir
+
+echo "Create $((loop * 1000)) files in $SCRATCH_MNT/testdir" >>$seqres.full
+while [ $i -lt $loop ]; do
+	create_file $SCRATCH_MNT/testdir 1000 $i >>$seqres.full 2>&1 &
+	let i=$i+1
+done
+wait
+
+# log inode status in $seqres.full for debug purpose
+echo "Inode status after taking all inodes" >>$seqres.full
+df -i $SCRATCH_MNT >>$seqres.full
+
+_check_scratch_fs
+
+# Check again after removing all the files
+rm -rf $SCRATCH_MNT/testdir
+echo "Inode status after deleting all test files" >>$seqres.full
+df -i $SCRATCH_MNT >>$seqres.full
+_check_scratch_fs
+
+status=0
+exit
diff --git a/tests/shared/006.out b/tests/shared/006.out
new file mode 100644
index 0000000..675c1b7
--- /dev/null
+++ b/tests/shared/006.out
@@ -0,0 +1,2 @@
+QA output created by 006
+Silence is golden
diff --git a/tests/shared/group b/tests/shared/group
index 29f17b0..230e560 100644
--- a/tests/shared/group
+++ b/tests/shared/group
@@ -8,6 +8,7 @@
 003 auto quick prealloc
 004 auto quick prealloc
 005 auto prealloc
+006 auto stress enospc
 032 mkfs auto quick
 051 acl udf auto quick
 218 auto fsr quick
-- 
1.8.5.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
