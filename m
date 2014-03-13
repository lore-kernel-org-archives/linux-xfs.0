Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DC99D7F93
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 07:10:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B32668F8081
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 05:10:25 -0700 (PDT)
Received: from mail-wg0-f52.google.com (mail-wg0-f52.google.com
	[74.125.82.52]) by cuda.sgi.com with ESMTP id lMbKKPx9cYPIyoWs
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 13 Mar 2014 05:10:20 -0700 (PDT)
Received: by mail-wg0-f52.google.com with SMTP id k14so752350wgh.11
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 05:10:19 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH RESEND] xfstests: add test for btrfs send issuing premature
	rmdir operations
Date: Thu, 13 Mar 2014 12:09:53 +0000
Message-Id: <1394712593-9212-1-git-send-email-fdmanana@gmail.com>
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

Regression test for btrfs incremental send issue where a rmdir instruction
is sent against an orphan directory inode which is not empty yet, causing
btrfs receive to fail when it attempts to remove the directory.

This issue is fixed by the following linux kernel btrfs patch:

    Btrfs: fix send attempting to rmdir non-empty directories

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---

Resending since Dave Chinner asked to do it for any patches he might have
missed in his last merge.

 tests/btrfs/043     |  149 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/043.out |    1 +
 tests/btrfs/group   |    1 +
 3 files changed, 151 insertions(+)
 create mode 100644 tests/btrfs/043
 create mode 100644 tests/btrfs/043.out

diff --git a/tests/btrfs/043 b/tests/btrfs/043
new file mode 100644
index 0000000..b1fef96
--- /dev/null
+++ b/tests/btrfs/043
@@ -0,0 +1,149 @@
+#! /bin/bash
+# FS QA Test No. btrfs/043
+#
+# Regression test for btrfs incremental send issue where a rmdir instruction
+# is sent against an orphan directory inode which is not empty yet, causing
+# btrfs receive to fail when it attempts to remove the directory.
+#
+# This issue is fixed by the following linux kernel btrfs patch:
+#
+#   Btrfs: fix send attempting to rmdir non-empty directories
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
+mkdir $SCRATCH_MNT/0
+mkdir $SCRATCH_MNT/1
+mkdir $SCRATCH_MNT/a/b/c
+mv $SCRATCH_MNT/0 $SCRATCH_MNT/a/b/c
+mv $SCRATCH_MNT/1 $SCRATCH_MNT/a/b/c
+echo 'ola mundo' > $SCRATCH_MNT/a/b/c/foo.txt
+mkdir $SCRATCH_MNT/a/b/c/x
+mkdir $SCRATCH_MNT/a/b/c/x2
+mkdir $SCRATCH_MNT/a/b/y
+mkdir $SCRATCH_MNT/a/b/z
+mkdir -p $SCRATCH_MNT/a/b/d1/d2/d3
+mkdir $SCRATCH_MNT/a/b/d4
+
+# Filesystem looks like:
+#
+# .                        (ino 256)
+# |-- a/                   (ino 257)
+#     |-- b/               (ino 258)
+#         |-- c/           (ino 261)
+#         |   |-- foo.txt  (ino 262)
+#         |   |-- 0/       (ino 259)
+#         |   |-- 1/       (ino 260)
+#         |   |-- x/       (ino 263)
+#         |   |-- x2/      (ino 264)
+#         |
+#         |-- y/           (ino 265)
+#         |-- z/           (ino 266)
+#         |-- d1/          (ino 267)
+#         |   |-- d2/      (ino 268)
+#         |       |-- d3/  (ino 269)
+#         |
+#         |-- d4/          (ino 270)
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
+
+rm -f $SCRATCH_MNT/a/b/c/foo.txt
+mv $SCRATCH_MNT/a/b/y $SCRATCH_MNT/a/b/YY
+mv $SCRATCH_MNT/a/b/z $SCRATCH_MNT/a
+mv $SCRATCH_MNT/a/b/c/x $SCRATCH_MNT/a/b/YY
+mv $SCRATCH_MNT/a/b/c/0 $SCRATCH_MNT/a/b/YY/00
+mv $SCRATCH_MNT/a/b/c/x2 $SCRATCH_MNT/a/z/X_2
+mv $SCRATCH_MNT/a/b/c/1 $SCRATCH_MNT/a/z/X_2
+rmdir $SCRATCH_MNT/a/b/c
+mv $SCRATCH_MNT/a/b/d4 $SCRATCH_MNT/a/d44
+mv $SCRATCH_MNT/a/b/d1/d2 $SCRATCH_MNT/a/d44
+rmdir $SCRATCH_MNT/a/b/d1
+
+# Filesystem now looks like:
+#
+# .                        (ino 256)
+# |-- a/                   (ino 257)
+#     |-- b/               (ino 258)
+#     |   |-- YY/          (ino 265)
+#     |        |-- x/      (ino 263)
+#     |        |-- 00/     (ino 259)
+#     |
+#     |-- z/               (ino 266)
+#     |   |-- X_2/         (ino 264)
+#     |        |-- 1/      (ino 260)
+#     |
+#     |-- d44/             (ino 270)
+#          |-- d2/         (ino 268)
+#              |-- d3/     (ino 269)
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2
+
+run_check $FSSUM_PROG -A -f -w $tmp/1.fssum $SCRATCH_MNT/mysnap1
+run_check $FSSUM_PROG -A -f -w $tmp/2.fssum -x $SCRATCH_MNT/mysnap2/mysnap1 \
+	$SCRATCH_MNT/mysnap2
+
+_run_btrfs_util_prog send $SCRATCH_MNT/mysnap1 -f $tmp/1.snap
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
diff --git a/tests/btrfs/043.out b/tests/btrfs/043.out
new file mode 100644
index 0000000..7851fbe
--- /dev/null
+++ b/tests/btrfs/043.out
@@ -0,0 +1 @@
+QA output created by 043
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 1037761..fabe3b5 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -45,3 +45,4 @@
 040 auto quick
 041 auto quick
 042 auto quick
+043 auto quick
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
