Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F36347F6B
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 23:52:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D3EF3304032
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 21:52:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cnz0ErZr5wkSS5tC for
	<xfs@oss.sgi.com>; Wed, 09 Oct 2013 21:52:33 -0700 (PDT)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfstests btrfs/012: test balance while creating and deleting
	subvolumes
Date: Thu, 10 Oct 2013 12:52:13 +0800
Message-Id: <1381380733-27117-1-git-send-email-eguan@redhat.com>
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
Cc: Eryu Guan <eguan@redhat.com>, linux-btrfs@vger.kernel.org

Do subvolume create/delete in loop at back ground and do filesystem
balance at the same time could trigger

kernel BUG at fs/btrfs/relocation.c:2255!

on 3.12-rc4 kernel.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/btrfs/012     | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/012.out | 11 ++++++++
 tests/btrfs/group   |  1 +
 3 files changed, 86 insertions(+)
 create mode 100755 tests/btrfs/012
 create mode 100644 tests/btrfs/012.out

diff --git a/tests/btrfs/012 b/tests/btrfs/012
new file mode 100755
index 0000000..3f72a9b
--- /dev/null
+++ b/tests/btrfs/012
@@ -0,0 +1,74 @@
+#! /bin/bash
+# FS QA Test No. btrfs/012
+#
+# Test btrfs balance while creating and deleting subvolumes
+#
+# On buggy kernel this could trigger:
+# kernel BUG at fs/btrfs/relocation.c:2255!
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
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_scratch_dev_pool
+
+subvolume=subvol_$seq
+rm -f $seqres.full
+
+subvolume_create_delete()
+{
+	while true; do
+		$BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/$subvolume >/dev/null
+		$BTRFS_UTIL_PROG subvolume delete $SCRATCH_MNT/$subvolume >/dev/null
+	done
+}
+
+_scratch_pool_mkfs >> $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+subvolume_create_delete &
+
+for i in `seq 1 10`;do
+	$BTRFS_UTIL_PROG filesystem balance start $SCRATCH_MNT >>$seqres.full 2>&1
+	echo "Done balance loop $i"
+done
+kill $!
+wait
+
+# No crash, test passed
+status=0
+exit
diff --git a/tests/btrfs/012.out b/tests/btrfs/012.out
new file mode 100644
index 0000000..9604f1b
--- /dev/null
+++ b/tests/btrfs/012.out
@@ -0,0 +1,11 @@
+QA output created by 012
+Done balance loop 1
+Done balance loop 2
+Done balance loop 3
+Done balance loop 4
+Done balance loop 5
+Done balance loop 6
+Done balance loop 7
+Done balance loop 8
+Done balance loop 9
+Done balance loop 10
diff --git a/tests/btrfs/group b/tests/btrfs/group
index d2fe030..c12b9e9 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -14,3 +14,4 @@
 009 auto quick
 010 auto quick
 011 auto
+012 auto quick
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
