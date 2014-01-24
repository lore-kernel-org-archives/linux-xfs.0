Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4714A7FEF
	for <xfs@oss.sgi.com>; Fri, 24 Jan 2014 03:12:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2A79F8F8037
	for <xfs@oss.sgi.com>; Fri, 24 Jan 2014 01:12:21 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id qOmISWAc0ELXm12T for
	<xfs@oss.sgi.com>; Fri, 24 Jan 2014 01:12:19 -0800 (PST)
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH] Btrfs: add regression test for iterating backrefs
Date: Fri, 24 Jan 2014 17:09:57 +0800
Message-Id: <1390554597-11076-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1390554597-11076-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1390554597-11076-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
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
Cc: linux-btrfs@vger.kernel.org

Btrfs send/scrub/defrag/qgroup need to walk backrefs,this test
is to make sure iterating backrefs with ulist is working and don't
cause a kernel panic here.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 tests/btrfs/033     | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/033.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 74 insertions(+)
 create mode 100755 tests/btrfs/033
 create mode 100644 tests/btrfs/033.out

diff --git a/tests/btrfs/033 b/tests/btrfs/033
new file mode 100755
index 0000000..c6ddcdc
--- /dev/null
+++ b/tests/btrfs/033
@@ -0,0 +1,71 @@
+#!/bin/bash
+# FS QA Test No. btrfs/033
+#
+# Regression test for iterating backrefs
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Fujitsu.  All Rights Reserved.
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
+#
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
+
+_cleanup()
+{
+    rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+
+touch $SCRATCH_MNT/foo
+
+# get file with fragments by using backwards writes.
+for i in `seq 10240 -1 1`; do
+	$XFS_IO_PROG -f -d -c "pwrite $(($i * 4096)) 4096" \
+	$SCRATCH_MNT/foo > /dev/null | _filter_xfs_io
+done
+
+# get some snapshots here to make sure we are really
+# suffering from walking backrefs.
+for i in `seq 0 50`; do
+	$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
+	$SCRATCH_MNT/snap_$i >> $seqres.full 2>&1
+done
+
+$BTRFS_UTIL_PROG send -f $SCRATCH_MNT/send_file \
+	$SCRATCH_MNT/snap_1 >> $seqres.full 2>&1
+
+echo "Silence is golden"
+status=0 ; exit
diff --git a/tests/btrfs/033.out b/tests/btrfs/033.out
new file mode 100644
index 0000000..c5d2914
--- /dev/null
+++ b/tests/btrfs/033.out
@@ -0,0 +1,2 @@
+QA output created by 033
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 7f48b04..b29236c 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -35,3 +35,4 @@
 030 auto quick
 031 auto quick
 032 auto quick
+033 auto quick
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
