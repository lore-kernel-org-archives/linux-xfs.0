Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C86337F62
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 04:05:42 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A7570304066
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 02:05:39 -0800 (PST)
Received: from mail-we0-f170.google.com (mail-we0-f170.google.com
	[74.125.82.170]) by cuda.sgi.com with ESMTP id 1AKd2m1nP5u7LQaC
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 22 Jan 2014 02:05:38 -0800 (PST)
Received: by mail-we0-f170.google.com with SMTP id u57so140965wes.15
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 02:05:36 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] xfstests: add test for btrfs incremental send infinite
	loop issue
Date: Wed, 22 Jan 2014 10:05:19 +0000
Message-Id: <1390385119-6998-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1390348610-8098-1-git-send-email-fdmanana@gmail.com>
References: <1390348610-8098-1-git-send-email-fdmanana@gmail.com>
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
Cc: Filipe David Borba Manana <fdmanana@gmail.com>, linux-btrfs@vger.kernel.org

Regression test for btrfs' incremental send feature:

1) Create several nested directories;

2) Create a read only snapshot;

3) Change the parentship of some of the deepest directories in a reverse
   way, so that parents become children and children become parents;

4) Create another read only snapshot and use it for an incremental send
   relative to the first snapshot.

At step 4 btrfs' send entered an infinite loop, increasing the memory it
used while building path strings until a krealloc was unable to allocate
more memory, which caused a warning dump in dmesg.

The following linux kernel patch fixes this issue.

   Btrfs: fix infinite path build loops in incremental send
   (https://patchwork.kernel.org/patch/3522361/)

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Updated test to trigger one more code path in the corresponding
    btrfs linux kernel patch that fixes this issue.

 tests/btrfs/030     |  144 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/030.out |    9 ++++
 tests/btrfs/group   |    1 +
 3 files changed, 154 insertions(+)
 create mode 100755 tests/btrfs/030
 create mode 100644 tests/btrfs/030.out

diff --git a/tests/btrfs/030 b/tests/btrfs/030
new file mode 100755
index 0000000..5e1b4fc
--- /dev/null
+++ b/tests/btrfs/030
@@ -0,0 +1,144 @@
+#! /bin/bash
+# FS QA Test No. btrfs/030
+#
+# Regression test for btrfs' incremental send feature:
+#
+# 1) Create several nested directories;
+# 2) Create a read only snapshot;
+# 3) Change the parentship of some of the deepest directories in a reverse
+#    way, so that parents become children and children become parents;
+# 4) Create another read only snapshot and use it for an incremental send
+#    relative to the first snapshot.
+#
+# At step 4 btrfs' send entered an infinite loop, increasing the memory it
+# used while building path strings until a krealloc was unable to allocate
+# more memory, which caused a warning dump in dmesg.
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
+here=`pwd`
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
+_need_to_be_root
+
+FSSUM_PROG=$here/src/fssum
+[ -x $FSSUM_PROG ] || _notrun "fssum not built"
+
+rm -f $seqres.full
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+
+mkdir -p $SCRATCH_MNT/a/b/c
+echo "hello" > $SCRATCH_MNT/a/b/c/file.txt
+mkdir $SCRATCH_MNT/a/b/c/d
+mkdir $SCRATCH_MNT/a/b/c2
+mkdir $SCRATCH_MNT/a/b/www
+mkdir -p $SCRATCH_MNT/a/b/c3/x/y
+
+# Directory tree looks like:
+#
+# .                         (ino 256)
+# |-- a/                    (ino 257)
+#     |-- b/                (ino 258)
+#         |-- c/            (ino 259)
+#         |   |-- file.txt  (ino 260)
+#         |   |-- d/        (ino 261)
+#         |
+#         |-- c2/           (ino 262)
+#         |-- www/          (ino 263)
+#         |
+#         |-- c3/           (ino 264)
+#             |-- x/        (ino 265)
+#                 |-- y/    (ino 266)
+
+$BTRFS_UTIL_PROG subvol snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1 | \
+    _filter_scratch
+
+echo " world" >> $SCRATCH_MNT/a/b/c/file.txt
+mv $SCRATCH_MNT/a/b/c/d $SCRATCH_MNT/a/b/c2/d2
+mv $SCRATCH_MNT/a/b/c $SCRATCH_MNT/a/b/c2/d2/cc
+mv $SCRATCH_MNT/a/b/c3/x/y $SCRATCH_MNT/a/b/c2/y2
+mv $SCRATCH_MNT/a/b/c3/x $SCRATCH_MNT/a/b/c2/y2/x2
+mv $SCRATCH_MNT/a/b/c3 $SCRATCH_MNT/a/b/c2/y2/x2/Z
+mv $SCRATCH_MNT/a/b/www $SCRATCH_MNT/a/b/c2/y2/x2/WWW
+ln $SCRATCH_MNT/a/b/c2/d2/cc/file.txt $SCRATCH_MNT/a/b/c2/y2/x2/Z/file_link.txt
+mv $SCRATCH_MNT/a/b/c2/d2/cc/file.txt $SCRATCH_MNT/a/b/c2/y2/x2
+
+# Directory tree now looks like:
+#
+# .                                         (ino 256)
+# |-- a/                                    (ino 257)
+#     |-- b/                                (ino 258)
+#         |-- c2/                           (ino 262)
+#             |-- d2/                       (ino 261)
+#             |   |-- cc/                   (ino 259)
+#             |        |-- file.txt         (ino 260)
+#             |-- y2/                       (ino 266)
+#                 |-- x2/                   (ino 265)
+#                     |-- WWW/              (ino 263)
+#                     |-- Z/                (ino 264)
+#                         |-- file_link.txt
+
+$BTRFS_UTIL_PROG subvol snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2 | \
+    _filter_scratch
+
+$FSSUM_PROG -A -f -w $tmp/1.fssum $SCRATCH_MNT/mysnap1
+$FSSUM_PROG -A -f -w $tmp/2.fssum -x $SCRATCH_MNT/mysnap2/mysnap1 \
+    $SCRATCH_MNT/mysnap2
+
+$BTRFS_UTIL_PROG send $SCRATCH_MNT/mysnap1 -f $tmp/1.snap 2>&1 | _filter_scratch
+$BTRFS_UTIL_PROG send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
+    -f $tmp/2.snap 2>&1 | _filter_scratch
+
+_scratch_unmount
+_check_btrfs_filesystem $SCRATCH_DEV
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+$BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/1.snap
+$FSSUM_PROG -r $tmp/1.fssum $SCRATCH_MNT/mysnap1
+$BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/2.snap
+$FSSUM_PROG -r $tmp/2.fssum $SCRATCH_MNT/mysnap2
+
+_scratch_unmount
+_check_btrfs_filesystem $SCRATCH_DEV
+
+status=0
+exit
diff --git a/tests/btrfs/030.out b/tests/btrfs/030.out
new file mode 100644
index 0000000..2999f8c
--- /dev/null
+++ b/tests/btrfs/030.out
@@ -0,0 +1,9 @@
+QA output created by 030
+Create a readonly snapshot of 'SCRATCH_MNT' in 'SCRATCH_MNT/mysnap1'
+Create a readonly snapshot of 'SCRATCH_MNT' in 'SCRATCH_MNT/mysnap2'
+At subvol SCRATCH_MNT/mysnap1
+At subvol SCRATCH_MNT/mysnap2
+At subvol mysnap1
+OK
+At snapshot mysnap2
+OK
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 8eb8c4f..3f61799 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -32,3 +32,4 @@
 027 auto quick
 028 auto quick
 029 auto quick
+030 auto quick
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
