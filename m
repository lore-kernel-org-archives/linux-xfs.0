Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 886177F37
	for <xfs@oss.sgi.com>; Sun, 16 Mar 2014 10:26:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ECEA6AC006
	for <xfs@oss.sgi.com>; Sun, 16 Mar 2014 08:26:03 -0700 (PDT)
Received: from mail-wi0-f174.google.com (mail-wi0-f174.google.com
	[209.85.212.174]) by cuda.sgi.com with ESMTP id
	9wQFUMGxxtIEylHQ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 16 Mar 2014 08:26:01 -0700 (PDT)
Received: by mail-wi0-f174.google.com with SMTP id d1so1216842wiv.7
	for <xfs@oss.sgi.com>; Sun, 16 Mar 2014 08:26:00 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] xfstests: add test for btrfs send regarding directory
	moves/renames
Date: Sun, 16 Mar 2014 15:24:26 +0000
Message-Id: <1394983466-20497-1-git-send-email-fdmanana@gmail.com>
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
Cc: jbacik@fb.com, Filipe David Borba Manana <fdmanana@gmail.com>, linux-btrfs@vger.kernel.org

Regression test for a btrfs incremental send issue where the kernel entered
an infinite loop building a path string. The minimal sequence of steps to
trigger this issue are:

      $ umount /mnt
      $ mkfs.btrfs -f /dev/sdd
      $ mount /dev/sdd /mnt

      $ mkdir /mnt/A
      $ mkdir /mnt/B
      $ mkdir /mnt/C
      $ mv /mnt/C /mnt/A
      $ mv /mnt/B /mnt/A/C
      $ mkdir /mnt/A/C/D

      $ btrfs subvolume snapshot -r /mnt /mnt/snap1
      $ btrfs send /mnt/snap1 -f /tmp/base.send

      $ mv /mnt/A/C/D /mnt/A/D2
      $ mv /mnt/A/C/B /mnt/A/D2/B2
      $ mv /mnt/A/C /mnt/A/D2/B2/C2

      $ btrfs subvolume snapshot -r /mnt /mnt/snap2
      $ btrfs send -p /mnt/snap1 /mnt/snap2 -f /tmp/incremental.send

The necessary conditions here are that C has an inode number higher than both
A and B, and B as an higher inode number higher than A, and D has the highest
inode number, that is:
   inode_number(A) < inode_number(B) < inode_number(C) < inode_number(D)

The same issue could happen if after the first snapshot there's any number
of intermediary parent directories between A2 and B2, and between B2 and C2.
This test covers the minimal case and more advanced scenarios, creating files
and links inside the directories to verify the incremental send is able to
deal with them.

This issue is fixed by the following linux kernel btrfs patch:

   Btrfs: fix incremental send's decision to delay a dir move/rename

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 tests/btrfs/045     |  177 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/045.out |    1 +
 tests/btrfs/group   |    1 +
 3 files changed, 179 insertions(+)
 create mode 100644 tests/btrfs/045
 create mode 100644 tests/btrfs/045.out

diff --git a/tests/btrfs/045 b/tests/btrfs/045
new file mode 100644
index 0000000..df2a1b6
--- /dev/null
+++ b/tests/btrfs/045
@@ -0,0 +1,177 @@
+#! /bin/bash
+# FS QA Test No. btrfs/045
+#
+# Regression test for a btrfs incremental send issue where the kernel entered
+# an infinite loop building a path string. The minimal sequence of steps to
+# trigger this issue are:
+#
+#      $ umount /mnt
+#      $ mkfs.btrfs -f /dev/sdd
+#      $ mount /dev/sdd /mnt
+#
+#      $ mkdir /mnt/A
+#      $ mkdir /mnt/B
+#      $ mkdir /mnt/C
+#      $ mv /mnt/C /mnt/A
+#      $ mv /mnt/B /mnt/A/C
+#      $ mkdir /mnt/A/C/D
+#
+#      $ btrfs subvolume snapshot -r /mnt /mnt/snap1
+#      $ btrfs send /mnt/snap1 -f /tmp/base.send
+#
+#      $ mv /mnt/A/C/D /mnt/A/D2
+#      $ mv /mnt/A/C/B /mnt/A/D2/B2
+#      $ mv /mnt/A/C /mnt/A/D2/B2/C2
+#
+#      $ btrfs subvolume snapshot -r /mnt /mnt/snap2
+#      $ btrfs send -p /mnt/snap1 /mnt/snap2 -f /tmp/incremental.send
+#
+# The necessary conditions here are that C has an inode number higher than both
+# A and B, and B as an higher inode number higher than A, and D has the highest
+# inode number, that is:
+#   inode_number(A) < inode_number(B) < inode_number(C) < inode_number(D)
+#
+# The same issue could happen if after the first snapshot there's any number
+# of intermediary parent directories between A2 and B2, and between B2 and C2.
+# This test covers the minimal case and more advanced scenarios, creating files
+# and links inside the directories to verify the incremental send is able to
+# deal with them.
+#
+# This issue is fixed by the following linux kernel btrfs patch:
+#
+#   Btrfs: fix incremental send's decision to delay a dir move/rename
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Filipe Manana.  All Rights Reserved.
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
+tmp=`mktemp -d`
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    rm -fr $tmp
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
+_require_fssum
+_need_to_be_root
+
+rm -f $seqres.full
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+mkdir -p $SCRATCH_MNT/a/b
+mkdir $SCRATCH_MNT/a/c
+mkdir $SCRATCH_MNT/a/b/d
+touch $SCRATCH_MNT/a/file1
+touch $SCRATCH_MNT/a/b/file2
+mv $SCRATCH_MNT/a/file1 $SCRATCH_MNT/a/b/d/file3
+ln $SCRATCH_MNT/a/b/d/file3 $SCRATCH_MNT/a/b/file4
+mkdir $SCRATCH_MNT/a/b/f
+mv $SCRATCH_MNT/a/b $SCRATCH_MNT/a/c/b2
+touch $SCRATCH_MNT/a/c/b2/d/file5
+
+# Filesystem looks like:
+#
+# .                               (ino 256)
+# |-- a/                          (ino 257)
+#     |-- c/                      (ino 259)
+#     |   |-- b2/                 (ino 258)
+#     |       |-- d/              (ino 260)
+#     |       |   |-- file3       (ino 261)
+#     |       |   |-- file5       (ino 264)
+#     |       |
+#     |       |-- file2           (ino 262)
+#     |       |-- file4           (ino 261)
+#     |       |-- f/              (ino 263)
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
+
+ln $SCRATCH_MNT/a/c/b2/file4 $SCRATCH_MNT/a/c/b2/f/file6
+mv $SCRATCH_MNT/a/c/b2/d/file5 $SCRATCH_MNT/a/c/file7
+touch $SCRATCH_MNT/a/c/b2/d/file8
+touch $SCRATCH_MNT/a/c/b2/file9
+ln $SCRATCH_MNT/a/c/b2/file9 $SCRATCH_MNT/a/c/b2/file10
+mv $SCRATCH_MNT/a/c/b2/f $SCRATCH_MNT/a/f2
+mv $SCRATCH_MNT/a/c $SCRATCH_MNT/a/c2
+mv $SCRATCH_MNT/a/c2/b2 $SCRATCH_MNT/a/f2/b3
+mv $SCRATCH_MNT/a/c2 $SCRATCH_MNT/a/f2/b3/c3
+touch $SCRATCH_MNT/a/f2/b3/c3/file11
+mv $SCRATCH_MNT/a $SCRATCH_MNT/a2
+
+# Filesystem now looks like:
+#
+# .                               (ino 256)
+# |-- a2/                         (ino 257)
+#     |
+#     |-- f2/                     (ino 263)
+#         |-- file6               (ino 261)
+#         |-- b3/                 (ino 258)
+#             |-- d/              (ino 260)
+#             |   |-- file3       (ino 261)
+#             |   |-- file8       (ino 265)
+#             |
+#             |-- file2           (ino 262)
+#             |-- file4           (ino 261)
+#             |-- file9           (ino 266)
+#             |-- file10          (ino 266)
+#             |
+#             |-- c3/             (ino 259)
+#                 |-- file7       (ino 264)
+#                 |-- file11      (ino 267)
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2
+
+run_check $FSSUM_PROG -A -f -w $tmp/1.fssum $SCRATCH_MNT/mysnap1
+run_check $FSSUM_PROG -A -f -w $tmp/2.fssum -x $SCRATCH_MNT/mysnap2/mysnap1 \
+	$SCRATCH_MNT/mysnap2
+
+_run_btrfs_util_prog send $SCRATCH_MNT/mysnap1 -f $tmp/1.snap
+
+_run_btrfs_util_prog send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
+	-f $tmp/2.snap
+
+_check_scratch_fs
+
+_scratch_unmount
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/1.snap
+run_check $FSSUM_PROG -r $tmp/1.fssum $SCRATCH_MNT/mysnap1
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/2.snap
+run_check $FSSUM_PROG -r $tmp/2.fssum $SCRATCH_MNT/mysnap2
+
+_check_scratch_fs
+
+status=0
+exit
diff --git a/tests/btrfs/045.out b/tests/btrfs/045.out
new file mode 100644
index 0000000..5b0d489
--- /dev/null
+++ b/tests/btrfs/045.out
@@ -0,0 +1 @@
+QA output created by 045
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 4589043..9b41895 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -47,3 +47,4 @@
 042 auto quick
 043 auto quick
 044 auto quick
+045 auto quick
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
