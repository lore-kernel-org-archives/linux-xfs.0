Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CB6FC7F4C
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 06:02:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B5AA08F8039
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 04:02:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BeDZhi3UTJHyBPVa for
	<xfs@oss.sgi.com>; Mon, 15 Apr 2013 04:02:17 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3FB2GL5028254
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 07:02:16 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfstests generic 311: test fallocate(2) ENOSPC when file size
	is greater than 4G
Date: Mon, 15 Apr 2013 19:02:06 +0800
Message-Id: <1366023726-6724-1-git-send-email-eguan@redhat.com>
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

ENOSPC in fallocate(2) could corrupt ext4 when file size > 4G

Regression test for commit
29ae07b ext4: Fix overflow caused by missing cast in ext4_fallocate()

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/generic/311     | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/311.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 67 insertions(+)
 create mode 100644 tests/generic/311
 create mode 100644 tests/generic/311.out

diff --git a/tests/generic/311 b/tests/generic/311
new file mode 100644
index 0000000..721d8cc
--- /dev/null
+++ b/tests/generic/311
@@ -0,0 +1,64 @@
+#! /bin/bash
+# FS QA Test No. 311
+#
+# ENOSPC in fallocate(2) could corrupt ext4 when file size > 4G
+#
+# Regression test for commit
+# 29ae07b ext4: Fix overflow caused by missing cast in ext4_fallocate()
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
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
+_supported_fs generic
+_supported_os Linux
+_require_xfs_io_falloc
+_require_scratch
+
+rm -f $seqres.full
+_scratch_mkfs_sized $((5 * 1024 * 1024 * 1024)) >>$seqres.full 2>&1
+_scratch_mount >>$seqres.full 2>&1
+
+echo "Silence is golden"
+
+# fallocate(2) a 6G(> 4G) file on a 5G fs
+$XFS_IO_PROG -f -c "falloc 0 6g" $SCRATCH_MNT/testfile.$seq >>$seqres.full 2>&1
+
+_scratch_unmount
+_check_scratch_fs
+status=0
+exit
diff --git a/tests/generic/311.out b/tests/generic/311.out
new file mode 100644
index 0000000..62f2530
--- /dev/null
+++ b/tests/generic/311.out
@@ -0,0 +1,2 @@
+QA output created by 311
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index eb52833..cb15afe 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -113,3 +113,4 @@
 308 auto quick
 309 auto quick
 310 auto
+311 auto quick prealloc enospc
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
