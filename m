Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0E86C29DF5
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 08:30:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 814B7AC005
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 06:30:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id r4z6sH5qwC0Vxbq2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 31 Aug 2015 06:30:10 -0700 (PDT)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] generic: test partial block device failure
Date: Mon, 31 Aug 2015 21:28:24 +0800
Message-Id: <1441027704-25185-1-git-send-email-eguan@redhat.com>
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
Cc: djeffery@redhat.com, Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com

Calls like fsync() should report failure on partial I/O failure, e.g. a
single failed disk in a raid 0 stripe.

This test is motivated by an XFS bug, and this commit fixed the issue
xfs: return errors from partial I/O failures to files

This case is written by David Jeffery <djeffery@redhat.com> originally.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---

Tested this case on 4.2-rc7 kernel and test failed as expected, and test passed
on 4.2-rc7+patch kernel. ExtN and btrfs all passed the test.

 tests/generic/107     | 98 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/107.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 101 insertions(+)
 create mode 100755 tests/generic/107
 create mode 100644 tests/generic/107.out

diff --git a/tests/generic/107 b/tests/generic/107
new file mode 100755
index 0000000..84e9354
--- /dev/null
+++ b/tests/generic/107
@@ -0,0 +1,98 @@
+#! /bin/bash
+# FS QA Test 107
+#
+# Test partial block device failure. Calls like fsync() should report failure
+# on partial I/O failure, e.g. a single failed disk in a raid 0 stripe.
+#
+# Test motivated by an XFS bug, and this commit fixed the issue
+# xfs: return errors from partial I/O failures to files
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Red Hat Inc. All Rights Reserved.
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
+	echo running > /sys/block/`_short_dev $SCSI_DEBUG_DEV`/device/state
+	$UMOUNT_PROG $SCRATCH_MNT >>$seqres.full 2>&1
+	$LVM_PROG vgremove -f $vgname >>$seqres.full 2>&1
+	$LVM_PROG pvremove -f $SCRATCH_DEV $SCSI_DEBUG_DEV >>$seqres.full 2>&1
+	_put_scsi_debug_dev
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/scsi_debug
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch_nocheck
+_require_block_device $SCRATCH_DEV
+_require_scsi_debug
+_require_command "$LVM_PROG" lvm
+
+lvname=lv_$seq
+vgname=vg_$seq
+rm -f $seqres.full
+
+# _get_scsi_debug_dev returns a scsi debug device with 128M in size by default
+SCSI_DEBUG_DEV=`_get_scsi_debug_dev`
+if [ "$SCSI_DEBUG_DEV" == "" ]; then
+	_fail "Failed to initialize scsi debug device"
+fi
+echo "SCSI debug device $SCSI_DEBUG_DEV" >>$seqres.full
+
+# create striped volume with 4MB stripe size
+$LVM_PROG pvcreate -f $SCSI_DEBUG_DEV $SCRATCH_DEV >>$seqres.full 2>&1
+$LVM_PROG vgcreate -f $vgname $SCSI_DEBUG_DEV $SCRATCH_DEV >>$seqres.full 2>&1
+$LVM_PROG lvcreate --yes -i 2 -I 4m -l 100%FREE -n $lvname $vgname \
+	>>$seqres.full 2>&1
+# wait for lv creation to fully complete
+$UDEV_SETTLE_PROG >>$seqres.full 2>&1
+
+# _mkfs_dev exits the test on failure, this makes sure test lv is created by
+# above vgcreate/lvcreate operations
+_mkfs_dev /dev/mapper/$vgname-$lvname
+
+_mount /dev/mapper/$vgname-$lvname $SCRATCH_MNT
+
+# create a test file with contiguous blocks which will span across the 2 disks
+$XFS_IO_PROG -f -c "pwrite 0 16M" -c fsync $SCRATCH_MNT/testfile >>$seqres.full
+
+# offline the scsi debug device
+echo offline > /sys/block/`_short_dev $SCSI_DEBUG_DEV`/device/state
+
+# write to an allocated area of the test file with writes which spans both disks
+# and call fsync, the fsync should report failure
+$XFS_IO_PROG -c "pwrite -b 1M 0 6M" -c fsync $SCRATCH_MNT/testfile \
+	>>$seqres.full
+
+status=0
+exit
diff --git a/tests/generic/107.out b/tests/generic/107.out
new file mode 100644
index 0000000..9d57184
--- /dev/null
+++ b/tests/generic/107.out
@@ -0,0 +1,2 @@
+QA output created by 107
+fsync: Input/output error
diff --git a/tests/generic/group b/tests/generic/group
index a33536e..4ccbb09 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -109,6 +109,7 @@
 104 auto quick metadata
 105 acl auto quick
 106 auto quick metadata
+107 auto quick rw
 112 rw aio auto quick
 113 rw aio auto quick
 117 attr auto quick
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
