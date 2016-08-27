Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7487A7CA2
	for <xfs@oss.sgi.com>; Sat, 27 Aug 2016 09:51:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D7E24AC002
	for <xfs@oss.sgi.com>; Sat, 27 Aug 2016 07:51:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HKWrMKIL3WtV1ruT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 27 Aug 2016 07:51:51 -0700 (PDT)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] fstests: test xfs rw remount with unknown ro-compat features
Date: Sat, 27 Aug 2016 22:51:37 +0800
Message-Id: <1472309497-11351-1-git-send-email-zlang@redhat.com>
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

This bug has been fix on linux kernel (d0a58e8 xfs: disallow rw
remount on fs with unknown ro-compat features), this case is
the regression testcase of that bug.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 tests/xfs/263     | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/263.out |  6 ++++
 tests/xfs/group   |  1 +
 3 files changed, 106 insertions(+)
 create mode 100755 tests/xfs/263
 create mode 100644 tests/xfs/263.out

diff --git a/tests/xfs/263 b/tests/xfs/263
new file mode 100755
index 0000000..b934e9f
--- /dev/null
+++ b/tests/xfs/263
@@ -0,0 +1,99 @@
+#! /bin/bash
+# FS QA Test 263
+#
+# Test upstream d0a58e8:
+#   xfs: disallow rw remount on fs with unknown ro-compat features
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
+	# Due to we've broken the superblock of SCRATCH_DEV by
+	# xfs_db, so clean bad superblock at the end
+	_scratch_unmount
+	_scratch_mkfs >/dev/null 2>&1
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
+_require_scratch
+_require_xfs_crc
+
+# Only V5 XFS disallow rw mount/remount with unknown ro-compat
+# features
+MKFS_OPTIONS="-m crc=1"
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
+# Generally this mount failed as bad superblock
+# But still keep testing this
+MOUNT_OPTIONS="-o rw"
+_scratch_mount 2>>$seqres.full
+if [ $? -eq 0 ]; then
+	_fail "rw mount test failed"
+fi
+
+echo "ro mount test"
+MOUNT_OPTIONS="-o ro"
+_scratch_mount
+if [ $? -ne 0 ]; then
+	_fail "ro mount test failed"
+else
+	# no hang/panic is fine
+	$FSSTRESS_PROG -d $SCRATCH_MNT -p 4 -n 400 >>$seqres.full 2>&1
+fi
+
+dmesg -c >/dev/null
+echo "rw remount test"
+MOUNT_OPTIONS="-o rw,remount"
+_scratch_mount 2>>$seqres.full
+if [ $? -eq 0 ]; then
+	_fail "rw,remount test failed"
+fi
+dmesg -c | sed -n -e "s/.*XFS.*: \(ro->rw transition prohibited.*\)/\1/p"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/263.out b/tests/xfs/263.out
new file mode 100644
index 0000000..974e02f
--- /dev/null
+++ b/tests/xfs/263.out
@@ -0,0 +1,6 @@
+QA output created by 263
+features_ro_compat = 0x80000000
+rw mount test
+ro mount test
+rw remount test
+mount: cannot remount LOOP_IMG read-write, is write-protected
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
