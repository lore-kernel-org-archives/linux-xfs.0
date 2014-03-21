Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 972A47F69
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 07:51:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4706E8F8064
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 05:50:58 -0700 (PDT)
Received: from mail-wg0-f42.google.com (mail-wg0-f42.google.com
	[74.125.82.42]) by cuda.sgi.com with ESMTP id M3kN2PjuWJScd9G6
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 21 Mar 2014 05:50:56 -0700 (PDT)
Received: by mail-wg0-f42.google.com with SMTP id y10so1557051wgg.25
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 05:50:54 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v4] xfstests: add test for btrfs send regarding directory
	moves/renames
Date: Fri, 21 Mar 2014 12:50:41 +0000
Message-Id: <1395406241-8624-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1394983466-20497-1-git-send-email-fdmanana@gmail.com>
References: <1394983466-20497-1-git-send-email-fdmanana@gmail.com>
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

Regression test for a btrfs incremental send issue where the kernel failed
to build paths strings. This resulted either in sending a wrong path string
to the send stream or entering an infinite loop when building it.
This happened in the following scenarios:

1) A directory was made a child of another directory which has a lower inode
   number and has a pending move/rename operation. This made the incremental
   send code go into an infinite loop when building a path string;

2) A directory was made a child of another directory which has a higher inode
   number, but the new parent wasn't moved nor renamed. Instead some other
   ancestor higher in the hierarchy, with an higher inode number too, was
   moved/renamed too. This made the incremental send code go into an infinite
   loop when building a path string;

3) An orphan directory is created and at least one of its non-immediate
   descendent directories have a pending move/rename operation. This made
   an incremental send issue to the send stream an invalid path string that
   didn't account for the orphan ancestor directory.

This issue is fixed by the following linux kernel btrfs patches:

   Btrfs: fix incremental send's decision to delay a dir move/rename
   Btrfs: part 2, fix incremental send's decision to delay a dir move/rename
   Btrfs: send, account for orphan directories when building path strings

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Added more tests.
V3: Added more tests for more complex cases.
V4: Added more tests, related to case 3) mentioned above.

 tests/btrfs/045     |  254 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/045.out |    1 +
 tests/btrfs/group   |    1 +
 3 files changed, 256 insertions(+)
 create mode 100755 tests/btrfs/045
 create mode 100644 tests/btrfs/045.out

diff --git a/tests/btrfs/045 b/tests/btrfs/045
new file mode 100755
index 0000000..d95c493
--- /dev/null
+++ b/tests/btrfs/045
@@ -0,0 +1,254 @@
+#! /bin/bash
+# FS QA Test No. btrfs/045
+#
+# Regression test for a btrfs incremental send issue where the kernel failed
+# to build paths strings. This resulted either in sending a wrong path string
+# to the send stream or entering an infinite loop when building it.
+# This happened in the following scenarios:
+#
+# 1) A directory was made a child of another directory which has a lower inode
+#    number and has a pending move/rename operation. This made the incremental
+#    send code go into an infinite loop when building a path string;
+#
+# 2) A directory was made a child of another directory which has a higher inode
+#    number, but the new parent wasn't moved nor renamed. Instead some other
+#    ancestor higher in the hierarchy, with an higher inode number too, was
+#    moved/renamed too. This made the incremental send code go into an infinite
+#    loop when building a path string;
+#
+# 3) An orphan directory is created and at least one of its non-immediate
+#    descendent directories have a pending move/rename operation. This made
+#    an incremental send issue to the send stream an invalid path string that
+#    didn't account for the orphan ancestor directory.
+#
+# This issue is fixed by the following linux kernel btrfs patches:
+#
+#   Btrfs: fix incremental send's decision to delay a dir move/rename
+#   Btrfs: part 2, fix incremental send's decision to delay a dir move/rename
+#   Btrfs: send, account for orphan directories when building path strings
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
+# case 1), mentioned above
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
+# case 2), mentioned above
+mkdir -p $SCRATCH_MNT/a/x1/x2
+mkdir $SCRATCH_MNT/a/Z
+mkdir -p $SCRATCH_MNT/a/x1/x2/x3/x4/x5
+
+# case 2) again, but a more complex scenario
+mkdir -p $SCRATCH_MNT/_a/_b/_c/_d
+mkdir $SCRATCH_MNT/_a/_b/_c/_d/_e
+mkdir $SCRATCH_MNT/_a/_b/_c/_d/_f
+mv $SCRATCH_MNT/_a/_b/_c/_d/_e $SCRATCH_MNT/_a/_b/_c/_d/_f/_E2
+mkdir $SCRATCH_MNT/_a/_b/_c/_g
+mv $SCRATCH_MNT/_a/_b/_c/_d $SCRATCH_MNT/_a/_b/_D2
+
+# case 3), mentioned above
+mkdir -p $SCRATCH_MNT/za/zb/zc/zd
+mkdir $SCRATCH_MNT/za/zb/ze
+mv $SCRATCH_MNT/za/zb/zc $SCRATCH_MNT/za/zb/ze/zCC
+mkdir $SCRATCH_MNT/za/zb/ze/zCC/zd/zf
+mkdir $SCRATCH_MNT/za/zg
+
+# Filesystem looks like:
+#
+# .                               (ino 256)
+# |-- a/                          (ino 257)
+# |   |-- c/                      (ino 259)
+# |   |   |-- b2/                 (ino 258)
+# |   |       |-- d/              (ino 260)
+# |   |       |   |-- file3       (ino 261)
+# |   |       |   |-- file5       (ino 264)
+# |   |       |
+# |   |       |-- file2           (ino 262)
+# |   |       |-- file4           (ino 261)
+# |   |       |-- f/              (ino 263)
+# |   |
+# |   |-- x1/                     (ino 265)
+# |   |   |-- x2/                 (ino 266)
+# |   |       |-- x3/             (ino 268)
+# |   |           |-- x4/         (ino 269)
+# |   |               |-- x5/     (ino 270)
+# |   |
+# |   |-- Z/                      (ino 267)
+# |
+# |-- _a/                         (ino 271)
+# |    |-- _b/                    (ino 272)
+# |         |-- _c/               (ino 273)
+# |         |    |-- _g/          (ino 277)
+# |         |
+# |         |-- _D2/              (ino 274)
+# |              |-- _f/          (ino 276)
+# |                   |-- _E2/    (ino 275)
+# |
+# |-- za/                         (ino 278)
+#     |-- zb/                     (ino 279)
+#     |   |-- ze/                 (ino 282)
+#     |       |-- zCC/            (ino 280)
+#     |            |-- zd/        (ino 281)
+#     |                |-- zf/    (ino 283)
+#     |
+#     |-- zg/                     (ino 284)
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
+
+# case 1), mentioned above
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
+# case 2), mentioned above
+mv $SCRATCH_MNT/a2/x1/x2/x3 $SCRATCH_MNT/a2/Z/X33
+mv $SCRATCH_MNT/a2/x1/x2 $SCRATCH_MNT/a2/Z/X33/x4/x5/X22
+
+# case 2) again, but a more complex scenario
+mkdir $SCRATCH_MNT/_a/_o
+mv $SCRATCH_MNT/_a/_b/_c/_g $SCRATCH_MNT/_a/_b/_D2/_f/_G2
+mv $SCRATCH_MNT/_a/_b/_D2 $SCRATCH_MNT/_a/_b/_dd
+mv $SCRATCH_MNT/_a/_b/_c $SCRATCH_MNT/_a/_C2
+mv $SCRATCH_MNT/_a/_b/_dd/_f $SCRATCH_MNT/_a/_o/_FF
+mv $SCRATCH_MNT/_a/_b $SCRATCH_MNT/_a/_o/_FF/_E2/_BB
+
+# case 3), mentioned above
+mkdir $SCRATCH_MNT/za/zg/zh
+mv $SCRATCH_MNT/za/zb/ze $SCRATCH_MNT/za/zg/zh/zEE
+mv $SCRATCH_MNT/za/zg/zh/zEE/zCC/zd $SCRATCH_MNT/za/zg/zh/zEE/zDD
+mv $SCRATCH_MNT/za/zg/zh/zEE/zDD/zf $SCRATCH_MNT/za/zg/zh/zEE/zDD/zFF
+
+# Filesystem now looks like:
+#
+# .                                 (ino 256)
+# |-- a2/                           (ino 257)
+# |   |-- f2/                       (ino 263)
+# |   |   |-- file6                 (ino 261)
+# |   |   |-- b3/                   (ino 258)
+# |   |       |-- d/                (ino 260)
+# |   |       |   |-- file3         (ino 261)
+# |   |       |   |-- file8         (ino 285)
+# |   |       |
+# |   |       |-- file2             (ino 262)
+# |   |       |-- file4             (ino 261)
+# |   |       |-- file9             (ino 286)
+# |   |       |-- file10            (ino 286)
+# |   |       |
+# |   |       |-- c3/               (ino 259)
+# |   |           |-- file7         (ino 264)
+# |   |           |-- file11        (ino 287)
+# |   |
+# |   |-- x1/                       (ino 265)
+# |   |-- Z/                        (ino 267)
+# |       |-- X33/                  (ino 268)
+# |            |-- x4/              (ino 269)
+# |                |-- x5/          (ino 270)
+# |                    |-- X22/     (ino 266)
+# |
+# |-- _a/                           (ino 271)
+# |    |-- _o/                      (ino 288)
+# |    |    |-- _FF/                (ino 276)
+# |    |         |-- _E2/           (ino 275)
+# |    |         |    |-- _BB/      (ino 272)
+# |    |         |         |-- dd/  (ino 274)
+# |    |         |
+# |    |         |-- G2/            (ino 277)
+# |    |-- C2/                      (ino 273)
+# |
+# |-- za/                           (ino 278)
+#     |-- zb/                       (ino 279)
+#     |-- zg/                       (ino 284)
+#         |-- zh/                   (ino 289)
+#             |-- zEE/              (ino 282)
+#                  |-- zCC/         (ino 280)
+#                  |-- zDD/         (ino 281)
+#                       |-- zFF/    (ino 283)
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
