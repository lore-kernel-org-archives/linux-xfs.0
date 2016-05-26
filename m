Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5E92E7CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 00:57:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 317B7304039
	for <xfs@oss.sgi.com>; Wed, 25 May 2016 22:57:53 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 3E316SGZHnMeYCy2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 May 2016 22:57:50 -0700 (PDT)
Subject: [PATCH 6/7] xfs: test rmap behavior when multiple bmbt records map
	to a single rmapbt record
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 25 May 2016 22:57:42 -0700
Message-ID: <146424226290.6278.15051221437554845000.stgit@birch.djwong.org>
In-Reply-To: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Make sure that we can handle multiple bmbt records mapping to a
single rmapbt record.  This can happen if you fallocate more than
2^21 contiguous blocks to a file.

(Also add some helpers that can create huge devices with some dm-zero
and dm-snapshot fakery.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/dmhugedisk |   61 +++++++++++++++++++++++++++
 src/t_immutable.c |    2 -
 tests/xfs/856     |  119 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/856.out |   13 ++++++
 tests/xfs/group   |    1 
 5 files changed, 195 insertions(+), 1 deletion(-)
 create mode 100644 common/dmhugedisk
 create mode 100755 tests/xfs/856
 create mode 100644 tests/xfs/856.out


diff --git a/common/dmhugedisk b/common/dmhugedisk
new file mode 100644
index 0000000..9c3c7d5
--- /dev/null
+++ b/common/dmhugedisk
@@ -0,0 +1,61 @@
+##/bin/bash
+# Routines for creating huge (fake) disks
+#-----------------------------------------------------------------------
+#  Copyright (c) 2016 Oracle.  All Rights Reserved.
+#  This program is free software; you can redistribute it and/or modify
+#  it under the terms of the GNU General Public License as published by
+#  the Free Software Foundation; either version 2 of the License, or
+#  (at your option) any later version.
+#
+#  This program is distributed in the hope that it will be useful,
+#  but WITHOUT ANY WARRANTY; without even the implied warranty of
+#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+#  GNU General Public License for more details.
+#
+#  You should have received a copy of the GNU General Public License
+#  along with this program; if not, write to the Free Software
+#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
+#  USA
+#
+#  Contact information: Oracle Corporation, 500 Oracle Parkway,
+#  Redwood Shores, CA 94065, USA, or: http://www.oracle.com/
+#-----------------------------------------------------------------------
+
+_require_dmhugedisk()
+{
+	_require_dm_target zero
+	_require_dm_target snapshot
+}
+
+_dmhugedisk_init()
+{
+	test -z "$1" && _fatal "must specify sector count to _dmhugedisk_init"
+	local dm_backing_dev=$SCRATCH_DEV
+
+	$DMSETUP_PROG remove huge-test > /dev/null 2>&1
+	$DMSETUP_PROG remove huge-test-zero > /dev/null 2>&1
+
+	local blk_dev_size=$1
+
+	DMHUGEDISK_ZERO='/dev/mapper/huge-test-zero'
+	DMHUGEDISK_DEV='/dev/mapper/huge-test'
+
+	DMHUGEDISK_ZERO_TABLE="0 $blk_dev_size zero"
+	DMHUGEDISK_DEV_TABLE="0 $blk_dev_size snapshot $DMHUGEDISK_ZERO $SCRATCH_DEV N 512"
+
+	$DMSETUP_PROG create huge-test-zero --table "$DMHUGEDISK_ZERO_TABLE" || \
+		_fatal "failed to create dm huge zero device"
+	$DMSETUP_PROG create huge-test --table "$DMHUGEDISK_DEV_TABLE" || \
+		_fatal "failed to create dm huge device"
+}
+
+_dmhugedisk_cleanup()
+{
+	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
+	# wait for device to be fully settled so that 'dmsetup remove' doesn't
+	# fail due to EBUSY
+	$UDEV_SETTLE_PROG >/dev/null 2>&1
+	$DMSETUP_PROG remove huge-test > /dev/null 2>&1
+	$DMSETUP_PROG remove huge-test-zero > /dev/null 2>&1
+}
+
diff --git a/src/t_immutable.c b/src/t_immutable.c
index 87ffc75..90b62fb 100644
--- a/src/t_immutable.c
+++ b/src/t_immutable.c
@@ -38,10 +38,10 @@
 #include <libgen.h>
 #include <sys/acl.h>
 #include <attr/xattr.h>
+#include <linux/fs.h>
 #include <xfs/xfs.h>
 #include <xfs/handle.h>
 #include <xfs/jdm.h>
-#include <linux/fs.h>
 #include <linux/magic.h>
 
 #ifndef XFS_SUPER_MAGIC
diff --git a/tests/xfs/856 b/tests/xfs/856
new file mode 100755
index 0000000..9186278
--- /dev/null
+++ b/tests/xfs/856
@@ -0,0 +1,119 @@
+#! /bin/bash
+# FS QA Test No. 856
+#
+# Create a file with more than 2^21 extents (the max length of a bmbt record).
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    umount $SCRATCH_MNT > /dev/null 2>&1
+    _dmhugedisk_cleanup
+    rm -rf $tmp.*
+    _scratch_mkfs >/dev/null 2>&1
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmhugedisk
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch
+_require_xfs_io_command "falloc"
+
+rm -f $seqres.full
+
+# Figure out block size
+echo "Figure out block size"
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount >> $seqres.full
+
+is_rmap=$(xfs_info $SCRATCH_MNT | grep -c "rmapbt=1")
+test $is_rmap -gt 0 || _notrun "rmap not supported on scratch fs"
+
+testdir=$SCRATCH_MNT/test-$seq
+blksz="$(stat -f $SCRATCH_MNT -c '%S')"
+
+umount $SCRATCH_MNT
+
+echo "Format huge device"
+_dmhugedisk_init $((blksz * 2 * 4400))	# a little over 2^22 blocks
+_mkfs_dev -d agcount=2 $DMHUGEDISK_DEV
+_mount $DMHUGEDISK_DEV $SCRATCH_MNT 
+xfs_info $SCRATCH_MNT >> $seqres.full
+
+echo "Create the original file blocks"
+mkdir $testdir
+blksz="$(stat -f $testdir -c '%S')"
+nr_blks=2100000	# 2^21 plus a little more
+$XFS_IO_PROG -f -c "falloc 0 $((nr_blks * blksz))" $testdir/file1 >> $seqres.full
+
+echo "Check extent count"
+xfs_bmap -l -p -v $testdir/file1 | grep '^[[:space:]]*1:' -q && xfs_bmap -l -p -v $testdir/file1
+inum=$(stat -c '%i' $testdir/file1)
+umount $SCRATCH_MNT
+
+echo "Check bmap count"
+nr_bmaps=$(xfs_db -c "inode $inum" -c "bmap" $DMHUGEDISK_DEV | grep 'data offset' | wc -l)
+test $nr_bmaps -gt 1 || xfs_db -c "inode $inum" -c "bmap" $DMHUGEDISK_DEV
+#xfs_db -c "agf 0" -c p -c "inode $inum" -c "bmap" $DMHUGEDISK_DEV
+
+echo "Check rmap count"
+nr_rmaps=$(xfs_db -c 'agf 0' -c 'addr rmaproot' -c 'p' $DMHUGEDISK_DEV | grep ",$inum,[0-9]*,1,0,0" | wc -l)
+test $nr_rmaps -eq 1 || xfs_db -c 'agf 0' -c 'addr rmaproot' -c 'p' $DMHUGEDISK_DEV | grep ",$inum,[0-9]*,1,0,0"
+
+echo "Check and fake-repair huge filesystem" | tee -a $seqres.full
+$XFS_DB_PROG -c 'check' $DMHUGEDISK_DEV
+$XFS_REPAIR_PROG -n $DMHUGEDISK_DEV >> $seqres.full 2>&1
+test $? -eq 0 || echo "xfs_repair -n failed, see $seqres.full"
+
+echo "Real repair huge filesystem" | tee -a $seqres.full
+$XFS_REPAIR_PROG $DMHUGEDISK_DEV >> $seqres.full 2>&1
+test $? -eq 0 || echo "xfs_repair failed, see $seqres.full"
+
+echo "Check bmap count again"
+nr_bmaps=$(xfs_db -c "inode $inum" -c "bmap" $DMHUGEDISK_DEV | grep 'data offset' | wc -l)
+test $nr_bmaps -gt 1 || xfs_db -c "inode $inum" -c "bmap" $DMHUGEDISK_DEV
+
+echo "Check rmap count again"
+nr_rmaps=$(xfs_db -c 'agf 0' -c 'addr rmaproot' -c 'p' $DMHUGEDISK_DEV | grep ",$inum,[0-9]*,1,0,0" | wc -l)
+test $nr_rmaps -eq 1 || xfs_db -c 'agf 0' -c 'addr rmaproot' -c 'p' $DMHUGEDISK_DEV | grep ",$inum,[0-9]*,1,0,0"
+
+echo "Check and fake-repair huge filesystem again" | tee -a $seqres.full
+$XFS_DB_PROG -c 'check' $DMHUGEDISK_DEV
+$XFS_REPAIR_PROG -n $DMHUGEDISK_DEV >> $seqres.full 2>&1
+_dmhugedisk_cleanup
+
+echo "Done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/856.out b/tests/xfs/856.out
new file mode 100644
index 0000000..b24ebf2
--- /dev/null
+++ b/tests/xfs/856.out
@@ -0,0 +1,13 @@
+QA output created by 856
+Figure out block size
+Format huge device
+Create the original file blocks
+Check extent count
+Check bmap count
+Check rmap count
+Check and fake-repair huge filesystem
+Real repair huge filesystem
+Check bmap count again
+Check rmap count again
+Check and fake-repair huge filesystem again
+Done
diff --git a/tests/xfs/group b/tests/xfs/group
index f0ca410..0e34f9a 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -288,3 +288,4 @@
 853 auto quick clone
 854 auto quick clone
 855 auto clone
+856 auto clone rmap reflink

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
