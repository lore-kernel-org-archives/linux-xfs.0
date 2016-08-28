Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B66127CA0
	for <xfs@oss.sgi.com>; Sun, 28 Aug 2016 07:50:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5CE8E304048
	for <xfs@oss.sgi.com>; Sun, 28 Aug 2016 05:50:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id yzDxkiSHcvy3UklF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 28 Aug 2016 05:50:29 -0700 (PDT)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH v3] fstests: test xfs rw remount with unknown ro-compat
	features
Date: Sun, 28 Aug 2016 20:50:25 +0800
Message-Id: <1472388625-28049-1-git-send-email-zlang@redhat.com>
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
Cc: Zorro Lang <zlang@redhat.com>, xfs@oss.sgi.com

Although ro-compat features cannot be mounted rw, a bug allows
an ro->rw remount transition, and this will corrupt the filesystem
if it contains ro-compat features unknown to the running kernel.

This bug has been fixed on linux kernel (d0a58e8 xfs: disallow rw
remount on fs with unknown ro-compat features), this case is
the regression testcase of that bug.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

V2 fix some mistakes of golden image(.out) file.
V3 did below things:
  - Write more case description
  - Change _require_scratch to _require_scratch_nocheck
  - Change _require_xfs_crc to _require_scratch_xfs_crc
  - Abandon overwriting MKFS_OPTIONS
  - Give up dmesg output
  - Change .out file, due to case is changed

Thanks,
Zorro

 tests/xfs/263     | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/263.out |  5 +++
 tests/xfs/group   |  1 +
 3 files changed, 99 insertions(+)
 create mode 100755 tests/xfs/263
 create mode 100644 tests/xfs/263.out

diff --git a/tests/xfs/263 b/tests/xfs/263
new file mode 100755
index 0000000..bcad627
--- /dev/null
+++ b/tests/xfs/263
@@ -0,0 +1,93 @@
+#! /bin/bash
+# FS QA Test 263
+#
+# Today ro-compat features can't be mounted rw, but a bug allows
+# an ro->rw remount transition. This bug has been fixed on linux
+# kernel (d0a58e8 xfs: disallow rw remount on fs with unknown
+# ro-compat features), and this case is the regression testcase.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Red Hat, Inc.  All Rights Reserved.
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
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_scratch_nocheck
+# Only V5 XFS disallow rw mount/remount with unknown ro-compat features
+_require_scratch_xfs_crc
+
+_scratch_mkfs_xfs >>$seqres.full 2>&1
+
+# set the highest bit of features_ro_compat, use it as an unknown
+# feature bit. If one day this bit become known feature, please
+# change this case.
+$XFS_DB_PROG -x -c "sb 0" \
+                -c "write features_ro_compat $((2**31))" \
+		$SCRATCH_DEV
+
+echo "rw mount test"
+# Maybe this mount will failed on bad superblock
+# But keep testing this anyway
+_scratch_mount 2>>$seqres.full
+if [ $? -eq 0 ]; then
+	_fail "rw mount test failed"
+fi
+
+echo "ro mount test"
+_scratch_mount -o ro
+if [ $? -ne 0 ]; then
+	_fail "ro mount test failed"
+else
+	# no hang/panic is fine
+	$FSSTRESS_PROG -d $SCRATCH_MNT -p 4 -n 400 >>$seqres.full 2>&1
+fi
+
+echo "rw remount test"
+_scratch_remount rw 2>>$seqres.full
+if [ $? -eq 0 ]; then
+	dmesg | tail -n 15 >> $seqres.full
+	_fail "rw remount test failed"
+fi
+
+_scratch_unmount
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/263.out b/tests/xfs/263.out
new file mode 100644
index 0000000..15364d9
--- /dev/null
+++ b/tests/xfs/263.out
@@ -0,0 +1,5 @@
+QA output created by 263
+features_ro_compat = 0x80000000
+rw mount test
+ro mount test
+rw remount test
diff --git a/tests/xfs/group b/tests/xfs/group
index 6905a62..ec3c022 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -260,6 +260,7 @@
 260 auto quick quota
 261 auto quick quota
 262 auto quick quota
+263 auto quick mount
 265 auto clone
 266 dump ioctl auto quick
 267 dump ioctl tape
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
