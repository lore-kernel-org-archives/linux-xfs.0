Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 93DE87F5A
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 17:03:55 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 73F4D8F8037
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 15:03:52 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6wf8GYMtKJOgMb3H (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Nov 2014 15:03:51 -0800 (PST)
Message-ID: <54614454.9080009@redhat.com>
Date: Mon, 10 Nov 2014 17:03:48 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: test xfs_copy for various sector and block sizes
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
To: fstests@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>

This tests xfs_copy, copying all combinations of sector
size and block size possible on the platform running the
test.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/tests/xfs/032 b/tests/xfs/032
new file mode 100755
index 0000000..edd9069
--- /dev/null
+++ b/tests/xfs/032
@@ -0,0 +1,80 @@
+#! /bin/bash
+# FS QA Test No. 032
+#
+# Test xfs_copy for all filesystem sector size / block size
+# combinations possible on this platform.
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
+status=0	# success is the default!
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os IRIX Linux
+
+_require_scratch
+
+[ $here/src/feature ] || _notrun "src/feature not built, skipping this test"
+
+[ "$USE_EXTERNAL" = yes ] && _notrun "Cannot xfs_copy with external devices"
+[ -n "$XFS_COPY_PROG" ] || _notrun "xfs_copy binary not yet installed"
+
+rm -f $seqres.full
+
+SECTORSIZE=`blockdev --getss $SCRATCH_DEV`
+PAGESIZE=`src/feature -s`
+IMGFILE=$TEST_DIR/${seq}_copy.img
+
+echo "Silence is golden."
+
+while [ $SECTORSIZE -le $PAGESIZE ]; do
+	BLOCKSIZE=$SECTORSIZE;
+
+	while [ $BLOCKSIZE -le $PAGESIZE ]; do
+
+		echo "=== Sector size $SECTORSIZE Block size $BLOCKSIZE ==" >> $seqres.full
+		_scratch_mkfs -s size=$SECTORSIZE -b size=$BLOCKSIZE -d size=1g >> $seqres.full 2>&1
+		_scratch_mount
+		# light population of the fs
+		$FSSTRESS_PROG -n 100 -d $SCRATCH_MNT >> $seqres.full 2>&1
+		_scratch_unmount
+
+		$XFS_COPY_PROG $SCRATCH_DEV $IMGFILE >> $seqres.full 2>&1 || \
+			_fail "Copy failed for Sector size $SECTORSIZE Block size $BLOCKSIZE"
+		$XFS_REPAIR_PROG $IMGFILE >> $seqres.full 2>&1 || \
+			_fail "Copy corrupted for Sector size $SECTORSIZE Block size $BLOCKSIZE"
+
+		BLOCKSIZE=$(($BLOCKSIZE * 2));
+	done
+	SECTORSIZE=$(($SECTORSIZE * 2));
+done
+
+# success, all done
+exit
diff --git a/tests/xfs/032.out b/tests/xfs/032.out
new file mode 100644
index 0000000..9265732
--- /dev/null
+++ b/tests/xfs/032.out
@@ -0,0 +1,2 @@
+QA output created by 032
+Silence is golden.
diff --git a/tests/xfs/group b/tests/xfs/group
index 4b8e51a..dd7f01f 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -29,6 +29,7 @@
 029 mkfs logprint log auto quick
 030 repair auto quick
 031 repair mkfs auto quick
+032 copy auto quick
 033 repair auto quick
 034 other auto quick
 035 dump ioctl tape auto

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
