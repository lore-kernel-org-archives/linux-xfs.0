Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q562TpuA151185 for <xfs@oss.sgi.com>; Tue, 5 Jun 2012 21:29:52 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id FgAVMlswpzegtFI5 for <xfs@oss.sgi.com>;
	Tue, 05 Jun 2012 19:29:50 -0700 (PDT)
Message-ID: <4FCEC09D.70504@sandeen.net>
Date: Tue, 05 Jun 2012 21:29:49 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfstest 287: userspace vs. fragmented multiblock dir2
References: <4FBABC41.5040001@redhat.com>
In-Reply-To: <4FBABC41.5040001@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Current xfs_repair is unhappy with fragmented multiblock
v2 directories.  This test shows it ... patches to fix
it soon to follow.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Renumbered, now with even more 287.out-ness.
(hand-renamed to 287, should apply...)
((we need to merge the 2 git trees ... ))

diff --git a/287 b/287
new file mode 100755
index 0000000..11a66f6
--- /dev/null
+++ b/287
@@ -0,0 +1,128 @@
+#! /bin/bash
+# FS QA Test No. 287
+#
+# Test xfs_repair on fragmented multi-block dir2 fs
+#
+#-----------------------------------------------------------------------
+# Copyright (c) Red Hat, Inc.  All Rights Reserved.
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
+# creator
+owner=sandeen@sandeen.net
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+_supported_fs xfs
+_supported_os IRIX Linux
+
+# real QA test starts here
+rm -f $seq.full
+_require_scratch
+_scratch_mkfs_xfs -n size=16k -d size=128m >> $seq.full 2>&1
+_scratch_mount
+
+# First we cause very badly fragmented freespace, then
+# make some multiblock directories in the filesystem, which
+# should come out very fragmented as a result
+
+# Step 1: Cause badly fragmented free space
+mkdir $SCRATCH_MNT/fragdir
+for I in `seq 0 27200`; do
+        (echo data > $SCRATCH_MNT/fragdir/f$I) >> $seq.full 2>&1
+done
+sync
+
+for I in `seq 0 2 27200`; do
+        rm -f $SCRATCH_MNT/fragdir/f$I >> $seq.full 2>&1
+done
+sync
+
+# Soak up any remaining freespace
+xfs_io -f -c "pwrite 0 16m" -c "fsync" $SCRATCH_MNT/space_file.large >> $seq.full 2>&1
+
+# Take a look at freespace for any post-mortem on the test
+_scratch_unmount
+xfs_db -c freesp $SCRATCH_DEV >> $seq.full 2>&1
+_scratch_mount
+
+# Step 2: Make a bunch of (hopefully fragmented) multiblock
+# dir2 directories
+
+# - FMT_LOCAL
+mkdir $SCRATCH_MNT/S_IFDIR.FMT_LOCAL
+touch $SCRATCH_MNT/S_IFDIR.FMT_LOCAL/localdirfile
+
+# - FMT_EXTENTS
+mkdir $SCRATCH_MNT/S_IFDIR.FMT_EXTENTS
+for I in `seq 1 100`; do
+	touch $SCRATCH_MNT/S_IFDIR.FMT_EXTENTS/extent_dir_file_$I
+done
+# With a few missing
+for I in `seq 10 2 20` 100; do
+	rm -f $SCRATCH_MNT/S_IFDIR.FMT_EXTENTS/extent_dir_file_$I
+done
+
+# - FMT_BTREE
+mkdir $SCRATCH_MNT/S_IFDIR.FMT_BTREE
+for I in `seq 1 1000`; do
+	touch $SCRATCH_MNT/S_IFDIR.FMT_BTREE/btree_dir_file_$I
+done
+# With a few missing
+for I in `seq 10 2 20` 1000; do
+	rm -f $SCRATCH_MNT/S_IFDIR.FMT_BTREE/btree_dir_file_$I
+done
+
+# Dave's special hack - grow freespace tree
+mkdir $SCRATCH_MNT/S_IFDIR.FMT_BTREE2
+for I in `seq 1 5000`; do
+	touch $SCRATCH_MNT/S_IFDIR.FMT_BTREE2/btree2_dir_file_$I
+done
+# Remove every other (odds)
+for I in `seq 1 2 5000`; do
+	rm -f $SCRATCH_MNT/S_IFDIR.FMT_BTREE2/btree2_dir_file_$I
+done
+
+_scratch_unmount
+# Can xfs_repair and xfs_check cope with this monster?
+_scratch_xfs_repair >> $seq.full 2>&1 || _fail "xfs_repair failed"
+xfs_check $SCRATCH_DEV >> $seq.full 2>&1 || _fail "xfs_check failed"
+
+# Yes they can!  Now...
+# Can xfs_metadump cope with this monster?
+xfs_metadump $SCRATCH_DEV $tmp.metadump || _fail "xfs_metadump failed"
+xfs_mdrestore $tmp.metadump $tmp.img || _fail "xfs_mdrestore failed"
+xfs_repair $tmp.img >> $seq.full 2>&1 || _fail "xfs_repair of metadump failed"
+
+# Yes it can; success, all done
+status=0
+exit
+
diff --git a/287.out b/287.out
new file mode 100644
index 0000000..58759aa
--- /dev/null
+++ b/287.out
@@ -0,0 +1 @@
+QA output created by 287
diff --git a/group b/group
index 104ed35..17afdcd 100644
--- a/group
+++ b/group
@@ -403,3 +403,4 @@ deprecated
 284 auto
 285 auto rw
 286 other
+287 repair


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
