Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 07B337F3F
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 15:05:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9D9D4AC006
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 13:05:10 -0700 (PDT)
Received: from mail-we0-f169.google.com (mail-we0-f169.google.com
	[74.125.82.169]) by cuda.sgi.com with ESMTP id p0b9Z87MzXOZXjPB
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 13 May 2014 13:05:03 -0700 (PDT)
Received: by mail-we0-f169.google.com with SMTP id u56so930022wes.28
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 13:05:02 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] xfstests: btrfs, add regression test for send with extrefs
Date: Tue, 13 May 2014 22:04:41 +0100
Message-Id: <1400015081-2192-1-git-send-email-fdmanana@gmail.com>
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
Cc: Josef Bacik <jbacik@fb.com>, Filipe David Borba Manana <fdmanana@gmail.com>, linux-btrfs@vger.kernel.org

Regression for btrfs send when an inode only has extended references
associated to it (no regular references present). This used to cause
incorrect access to a b+tree leaf, where an extended reference item
was accessed as if it were a regular reference item, causing unexpected
and unpredictable behaviour such as producing a random/weird path string
or a crash.

This issue is fixed by the following linux kernel btrfs patch:

   Btrfs: send, fix incorrect ref access when using extrefs

Cc: Josef Bacik <jbacik@fb.com>
Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 tests/btrfs/050     | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/050.out |   1 +
 tests/btrfs/group   |   1 +
 3 files changed, 111 insertions(+)
 create mode 100755 tests/btrfs/050
 create mode 100644 tests/btrfs/050.out

diff --git a/tests/btrfs/050 b/tests/btrfs/050
new file mode 100755
index 0000000..6e4bd13
--- /dev/null
+++ b/tests/btrfs/050
@@ -0,0 +1,109 @@
+#! /bin/bash
+# FS QA Test No. btrfs/050
+#
+# Regression for btrfs send when an inode only has extended references
+# associated to it (no regular references present). This used to cause
+# incorrect access to a b+tree leaf, where an extended reference item
+# was accessed as if it were a regular reference item, causing unexpected
+# and unpredictable behaviour such as producing a random/weird path string
+# or a crash.
+#
+# This issue is fixed by the following linux kernel btrfs patch:
+#
+#   Btrfs: send, fix incorrect ref access when using extrefs
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
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    rm -fr $send_files_dir
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
+send_files_dir=$TEST_DIR/btrfs-test-$seq
+
+rm -f $seqres.full
+rm -fr $send_files_dir
+mkdir $send_files_dir
+
+_scratch_mkfs "-O extref" >/dev/null 2>&1
+_scratch_mount
+
+# 2550 hard links is enough to cause creation of extended references
+# even if the leaf/node size is 64Kb (largest possible).
+NUM_LINKS=2550
+TEST_PATH=$SCRATCH_MNT/home/john/files/series/qwerty
+
+mkdir -p $TEST_PATH
+touch $TEST_PATH/foobar
+
+# Create a bunch of hard links for the file, such that at least one
+# inode extended reference item is created.
+for i in `seq 1 $NUM_LINKS`; do
+	ln $TEST_PATH/foobar $TEST_PATH/foobar_link_`printf "%04d" $i`
+done
+
+# The only link we'll have alive at the end.
+ln $TEST_PATH/foobar $TEST_PATH/final_foobar_name
+
+# Now delete all previous hard links (except the last one). This will
+# remove the regular inode reference item from the b+tree, and will
+# leave only an inode extended reference item, which is the condition
+# necessary to trigger the bug.
+rm -f $TEST_PATH/foobar
+for i in `seq 1 $NUM_LINKS`; do
+	rm -f $TEST_PATH/foobar_link_`printf "%04d" $i`
+done
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
+run_check $FSSUM_PROG -A -f -w $send_files_dir/1.fssum $SCRATCH_MNT/mysnap1
+_run_btrfs_util_prog send $SCRATCH_MNT/mysnap1 -f $send_files_dir/1.snap
+
+_scratch_unmount
+_check_scratch_fs
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap
+run_check $FSSUM_PROG -r $send_files_dir/1.fssum $SCRATCH_MNT/mysnap1
+
+_check_scratch_fs
+
+status=0
+exit
diff --git a/tests/btrfs/050.out b/tests/btrfs/050.out
new file mode 100644
index 0000000..37f2cbc
--- /dev/null
+++ b/tests/btrfs/050.out
@@ -0,0 +1 @@
+QA output created by 050
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 59b0c98..69a80e0 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -52,3 +52,4 @@
 047 auto quick
 048 auto quick
 049 auto quick
+050 auto
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
