Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n91IwFQk113300 for <xfs@oss.sgi.com>; Thu, 1 Oct 2009 13:58:15 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0064B14BC2BC
	for <xfs@oss.sgi.com>; Thu,  1 Oct 2009 11:59:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CpnINorfZlbtGksY for
	<xfs@oss.sgi.com>; Thu, 01 Oct 2009 11:59:36 -0700 (PDT)
Message-ID: <4AC4FC13.3050505@redhat.com>
Date: Thu, 01 Oct 2009 13:59:31 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfststests 220: test for prealloc/delalloc/reserved space
	recapture
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>

Test writing and removing a file in a loop; filesize is 64m,
filesystem size is 256m.  Loop 16 times each for buffered and
direct.

ext4 hits enospc after a couple loops.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

(note this has the sized mkfs infra from the previous patch this week
since that patch needed more work w.r.t. modifying existing tests)

diff --git a/common.rc b/common.rc
index 761170d..8d0cd4e 100644
--- a/common.rc
+++ b/common.rc
@@ -237,6 +237,27 @@ _scratch_mkfs_options()
     echo $SCRATCH_OPTIONS $MKFS_OPTIONS $* $SCRATCH_DEV
 }
 
+# arg 1 is size in bytes, arg 2 is (optional) blocksize
+_scratch_mkfs_sized()
+{
+    fssz=$1
+    bsz=$2
+    [ -z "$bsz" ] && bsz=4096
+    let blocks=$fssz/$bsz
+
+    case $FSTYP in
+    xfs)
+        _scratch_mkfs_xfs -d size=$fssz -b size=$bsz 2>&1 >>$here/$seq.full
+    ;;
+    ext2|ext3|ext4)
+        /sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS -b $bsz $SCRATCH_DEV $blocks  2>&1>>$here/$seq.full
+    ;;
+    *)
+    _notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized"
+    ;;
+    esac
+}
+
 _scratch_mkfs_xfs()
 {
     # extra mkfs options can be added by tests

diff --git a/220 b/220
new file mode 100755
index 0000000..55982b7
--- /dev/null
+++ b/220
@@ -0,0 +1,76 @@
+#! /bin/sh
+# FS QA Test No. 220
+#
+# Test for prealloc space leaks by rewriting the same file in a loop
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2009 Eric Sandeen.  All Rights Reserved.
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
+owner=sandeen@sandeen.net
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux IRIX
+_require_scratch
+
+# real QA test starts here
+rm -f $seq.full
+
+umount $SCRATCH_DEV 2>/dev/null
+let fssize=256*1024*1024
+echo "--> mkfs 256m filesystem"
+_scratch_mkfs_sized $fssize >> $seq.full 2>&1
+_scratch_mount
+
+loops=16
+
+echo "--> $loops buffered 64m writes in a loop"
+for I in `seq 1 $loops`; do
+	echo -n "$I "
+	xfs_io -F -f -c 'pwrite 0 64m' $SCRATCH_MNT/test >> $seq.full
+	rm -f $SCRATCH_MNT/test
+done
+
+echo
+umount $SCRATCH_DEV
+_scratch_mount
+
+echo "--> $loops direct 64m writes in a loop"
+for I in `seq 1 $loops`; do
+	echo -n "$I "
+	xfs_io -F -f -d -c 'pwrite 0 64m' $SCRATCH_MNT/test >> $seq.full
+	rm -f $SCRATCH_MNT/test 
+done
+
+echo
+umount $SCRATCH_DEV
+
+status=0
+exit
diff --git a/220.out b/220.out
new file mode 100644
index 0000000..497a585
--- /dev/null
+++ b/220.out
@@ -0,0 +1,6 @@
+QA output created by 220
+--> mkfs 256m filesystem
+--> 16 buffered 64m writes in a loop
+1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 
+--> 16 direct 64m writes in a loop
+1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 
diff --git a/group b/group
index 7cea01d..9b8a401 100644
--- a/group
+++ b/group
@@ -329,3 +329,4 @@ prealloc
 217 log metadata auto
 218 auto fsr quick
 219 auto quota quick
+220 enospc auto quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
