Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55476 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932457AbcLIRR6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Dec 2016 12:17:58 -0500
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] fstests: xfs_fsr SWAPEXT fails when temp forkoff smaller than target
Date: Sat, 10 Dec 2016 01:17:53 +0800
Message-Id: <1481303873-11981-1-git-send-email-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

If there's a file under a parent dir, but before running xfs_fsr the
parent dir's attr is changed(grown), and these attrs will be inherited
by new files. Then xfs_fsr's temp file and target file will have
different attrs.

At this moment, if the data already fill whole data area, then there
is not enough space to move di_forkoff to data direction, swap the
extents between temp and target file will fail.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

The original case use SELinux to test. For common test, I change to use
ACL. As my test, when inode size is 512 bytes(or more), it'll increase
enough bytes to attr area, if add new default ACL attr.

The "enough bytes" I expect is 16+ bytes. Because an extent is 128 bits,
I keep using extent data format, so the growing step is 16 bytes. When I
try to fill whole data area, at last (di_forkoff - size of di_u) will be
in [0, 16).

As my test, 256 bytes inode size can't always reproduce this bug(especially
in RHEL-6). But 512 (or more) inode size can help that.

Thanks,
Zorro

 tests/xfs/999     | 115 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/999.out |   2 +
 tests/xfs/group   |   1 +
 3 files changed, 118 insertions(+)
 create mode 100755 tests/xfs/999
 create mode 100644 tests/xfs/999.out

diff --git a/tests/xfs/999 b/tests/xfs/999
new file mode 100755
index 0000000..d896287
--- /dev/null
+++ b/tests/xfs/999
@@ -0,0 +1,115 @@
+#! /bin/bash
+# FS QA Test 999
+#
+# Test xfs_fsr when temp's attr is larger than the target attr area, and
+# without enough room to move di_forkoff to date direction. Then it'll fail
+# to swap extents between temp and target files.
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
+. ./common/attr
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_scratch
+# need a user to set ACL
+_require_user
+_require_acls
+_require_xfs_io_command "falloc"
+
+# use fixed attr test parameters, 512+ bytes inode size is helpful
+# to alloc more default ACL space
+_scratch_mkfs_xfs -i size=512,attr=2 >> $seqres.full 2>&1
+# Manually mount to avoid effect from some mount options
+mount $SCRATCH_DEV $SCRATCH_MNT
+
+rm -f $SCRATCH_MNT/$seq.test 2>/dev/null
+# remove all default ACL
+setfacl -k $SCRATCH_MNT
+sync
+touch $SCRATCH_MNT/$seq.test
+INODE_NUM=`ls -i $SCRATCH_MNT/$seq.test | awk '{print $1}'`
+
+# unmount SCRATCH_DEV to get the di_forkoff size
+_scratch_unmount
+FORK_OFF=`_scratch_xfs_db -c "inode $INODE_NUM" -c "print core.forkoff" | awk -F "=" '{print $2}'`
+# the attributes are stored in the inode’s literal area starting a forkoff * 8
+FORK_OFF=$((FORK_OFF * 8))
+# an on-disk extent takes 128 bits = 16 bytes, get the max in-fork extents to
+# keep using extent data format
+MAX_EXTENTS=$((FORK_OFF / 16))
+
+mount $SCRATCH_DEV $SCRATCH_MNT
+
+# fragment the file by writing backwards, and alloc MAX_EXTENTS extents to
+# make the di_u nearly/already touch the di_forkoff
+for i in `seq $((MAX_EXTENTS - 1)) -1 0`; do
+	$XFS_IO_PROG -f -c "falloc $((i * 262144)) 262144" \
+		$SCRATCH_MNT/$seq.test >> $seqres.full
+done
+
+# add new default ACL to $SCRATCH_MNT, for xfs_fsr will use a *temp* file
+# which takes more di_a field (smaller di_forkoff than *target* file)
+# Generally this operation need to grow attr area ~32 bytes
+setfacl --set d:u:fsgqa:rwx,d:g:fsgqa:rwx,d:o:rwx $SCRATCH_MNT
+sync
+
+# At this moment, xfs_fsr will hit below situation:
+#
+# target:         forkoff
+#                    |
+# +------------------v--------+
+# |       di_u       |  di_a  |
+# +------------------^--------+
+#
+# temp:       forkoff
+#                |
+# +--------------v------------+
+# |       di_u   |     di_a   |
+# +--------------^------------+
+$XFS_FSR_PROG $SCRATCH_MNT/$seq.test
+
+dmesg | tail -10 >> $seqres.full
+echo "Silence is golden"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/999.out b/tests/xfs/999.out
new file mode 100644
index 0000000..3b276ca
--- /dev/null
+++ b/tests/xfs/999.out
@@ -0,0 +1,2 @@
+QA output created by 999
+Silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index c237b50..ad01b8e 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -334,3 +334,4 @@
 345 auto quick clone
 346 auto quick clone
 347 auto quick clone
+999 auto quick fsr
-- 
2.7.4

