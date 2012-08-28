Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7SCwqXF097525 for <xfs@oss.sgi.com>; Tue, 28 Aug 2012 07:58:52 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	vUkHQdoDbQj0orIg (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Aug 2012 05:59:43 -0700 (PDT)
Received: by obbwd18 with SMTP id wd18so8034918obb.26
	for <xfs@oss.sgi.com>; Tue, 28 Aug 2012 05:59:42 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 28 Aug 2012 14:59:42 +0200
Message-ID: <CAFZPdfg+5kRfUuVOtRk1pqKrRai6CZBxisvXnuPUr-_SNAmGTg@mail.gmail.com>
Subject: [PATCH v2] xfstests: Add test case to test xfs projid32bit
	functionality a bit more extensively.
From: Boris Ranto <ranto.boris@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>

 The test covers several areas including enabling projid32bit
functionality dynamically by xfs_admin, dumping, restoring, quota
reporting and xfs_db projid values reporting.
 This test case hits two bugs: one for broken xfsdump/xfsrestore
functionality and one for enabling projid32bit functionality with
xfs_admin on a LVM device (SCRATCH_DEV must be an LVM device to hit
this).
 This version does not create/handle any loop devices.

Signed-off-by: Boris Ranto <ranto.boris@gmail.com>
---
 285     |  138 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 285.out |   27 ++++++++++++
 group   |    1 +
 3 files changed, 166 insertions(+), 0 deletions(-)
 create mode 100644 285
 create mode 100644 285.out

diff --git a/285 b/285
new file mode 100644
index 0000000..ad96aa6
--- /dev/null
+++ b/285
@@ -0,0 +1,138 @@
+#! /bin/bash
+# FS QA Test No. 285
+#
+# Test to verify project quota xfs_admin, xfsdump/xfsrestore and
+# xfs_db functionality
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2012 Boris Ranto.  All Rights Reserved.
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
+# creator
+owner=ranto.boris@gmail.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+tmp=/tmp/$$
+here=`pwd`
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+rm -f $seq.full
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.quota
+
+_cleanup()
+{
+    cd /
+    umount $SCRATCH_MNT 2>/dev/null
+    rm -rf $tmp.*
+}
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_quota
+_require_scratch
+_require_projid32bit
+
+export MOUNT_OPTIONS="-opquota"
+
+# create xfs fs without projid32bit ability, will be gained by xfs_admin
+_scratch_mkfs_xfs -i projid32bit=0 -d size=200m >> $seq.full || _fail
"mkfs failed"
+_qmount
+# require project quotas
+_require_prjquota $SCRATCH_DEV
+
+dir=$SCRATCH_MNT/pquota
+
+status=1
+
+mkdir -p $dir
+touch $dir/{16,32}less
+inode16a=$(ls -i $dir/16less|cut -d ' ' -f 1)
+inode32a=$(ls -i $dir/32less|cut -d ' ' -f 1)
+$XFS_QUOTA_PROG -x -c "project -s -p $dir/16less 1234" $SCRATCH_DEV \
+        >> $seq.full
+$XFS_QUOTA_PROG -x -c "project -s -p $dir/32less 2123456789" $SCRATCH_DEV \
+        >> $seq.full 2>&1
+# These will be checked by $seq.out
+echo "No 32bit project quotas:"
+$XFS_IO_PROG -r -c "lsproj" $dir/16less
+$XFS_IO_PROG -r -c "lsproj" $dir/32less
+
+umount $SCRATCH_MNT
+
+# Now, enable projid32bit support by xfs_admin
+xfs_admin -p $SCRATCH_DEV > /dev/null 2>&1
+echo "xfs_admin returned $?"
+
+# Now mount the fs, 32bit project quotas shall be supported, now
+_qmount
+$XFS_QUOTA_PROG -x -c "project -s -p $dir/32less 2123456789" $SCRATCH_DEV \
+        >> $seq.full
+
+# These will be checked by $seq.out
+echo "With 32bit project quota support:"
+$XFS_IO_PROG -r -c "lsproj" $dir/16less
+$XFS_IO_PROG -r -c "lsproj" $dir/32less
+
+# Dump the fs to a temporary file
+rm -f $tmp.dump.img
+$XFSDUMP_PROG -f $tmp.dump -L label -M media -l 0 $SCRATCH_MNT >>
$seq.full  || _fail "dump failed"
+echo "xfsdump returned $?"
+
+# Prepare the device to restore the dumped file system
+dir=$SCRATCH_MNT/restore/pquota
+
+# Just make the restore dir, the pquota dir will be created by xfsrestore
+mkdir -p $SCRATCH_MNT/restore
+
+# Restore
+$XFSRESTORE_PROG -f $tmp.dump $SCRATCH_MNT/restore > /dev/null 2>&1
+echo "xfsrestore returned $?"
+
+# Check that they are the same
+diff -urpN $SCRATCH_MNT/{,restore}/pquota
+echo "diff returned $?"
+touch $dir/32lessv2
+inode16b=$(ls -i $dir/16less|cut -d ' ' -f 1)
+inode32b=$(ls -i $dir/32less|cut -d ' ' -f 1)
+inode32v2=$(ls -i $dir/32lessv2|cut -d ' ' -f 1)
+$XFS_QUOTA_PROG -x -c "project -s -p $dir/32lessv2 2123456789" $SCRATCH_MNT \
+        >> $seq.full
+echo "The restored file system + one additional file:"
+$XFS_IO_PROG -r -c "lsproj" $dir/16less
+$XFS_IO_PROG -r -c "lsproj" $dir/32less
+$XFS_IO_PROG -r -c "lsproj" $dir/32lessv2
+
+umount $SCRATCH_MNT
+
+# Now, we can examine the file systems with xfs_db
+# These two should report the same values
+echo "These two values of 16bit project quota ids shall be the same"
+$XFS_DB_PROG -c "inode $inode16a" -c "print core.projid_lo" -c "print
core.projid_hi" $SCRATCH_DEV
+$XFS_DB_PROG -c "inode $inode16b" -c "print core.projid_lo" -c "print
core.projid_hi" $SCRATCH_DEV
+
+# These three should report the same values
+echo "These three values of 32bit project quota ids shall be the same"
+$XFS_DB_PROG -c "inode $inode32a" -c "print core.projid_lo" -c "print
core.projid_hi" $SCRATCH_DEV
+$XFS_DB_PROG -c "inode $inode32b" -c "print core.projid_lo" -c "print
core.projid_hi" $SCRATCH_DEV
+$XFS_DB_PROG -c "inode $inode32v2" -c "print core.projid_lo" -c
"print core.projid_hi" $SCRATCH_DEV
+
+status=0
+exit
diff --git a/285.out b/285.out
new file mode 100644
index 0000000..a601452
--- /dev/null
+++ b/285.out
@@ -0,0 +1,27 @@
+QA output created by 285
+No 32bit project quotas:
+projid = 1234
+projid = 0
+xfs_admin returned 0
+With 32bit project quota support:
+projid = 1234
+projid = 2123456789
+xfsdump returned 0
+xfsrestore returned 0
+diff returned 0
+The restored file system + one additional file:
+projid = 1234
+projid = 2123456789
+projid = 2123456789
+These two values of 16bit project quota ids shall be the same
+core.projid_lo = 1234
+core.projid_hi = 0
+core.projid_lo = 1234
+core.projid_hi = 0
+These three values of 32bit project quota ids shall be the same
+core.projid_lo = 24853
+core.projid_hi = 32401
+core.projid_lo = 24853
+core.projid_hi = 32401
+core.projid_lo = 24853
+core.projid_hi = 32401
diff --git a/group b/group
index 104ed35..bbc74fe 100644
--- a/group
+++ b/group
@@ -403,3 +403,4 @@ deprecated
 282 dump ioctl auto quick
 283 dump ioctl auto quick
 284 auto
+285 auto dump quota
--
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
