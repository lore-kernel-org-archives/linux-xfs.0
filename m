Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4OKQQOK094478 for <xfs@oss.sgi.com>; Tue, 24 May 2011 15:26:26 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 187A047BDF4
	for <xfs@oss.sgi.com>; Tue, 24 May 2011 13:26:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id m6GJw9CAMMD6bv7K for
	<xfs@oss.sgi.com>; Tue, 24 May 2011 13:26:25 -0700 (PDT)
From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] xfstests: add test 254 for testing basic btrfs volume
	functionality
Date: Tue, 24 May 2011 16:26:03 -0400
Message-Id: <1306268763-7932-1-git-send-email-josef@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org

This test just runs through all of the basic btrfs commands that manipulate our
subvolume stuff.  It creates a snapshot, a subvolume, sets the subvolume as a
default, lists the volumes and deletes the snapshot.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 254     |  107 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 254.out |   40 +++++++++++++++++++++++
 group   |    1 +
 3 files changed, 148 insertions(+), 0 deletions(-)
 create mode 100755 254
 create mode 100644 254.out

diff --git a/254 b/254
new file mode 100755
index 0000000..3c1a5a1
--- /dev/null
+++ b/254
@@ -0,0 +1,107 @@
+#! /bin/bash
+# FS QA Test No. 254
+#
+# Test btrfs's subvolume and snapshot support
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011 Red Hat.  All Rights Reserved.
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
+owner=josef@redhat.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_cleanup()
+{
+    rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+
+# First test basic snapshotting
+echo "Creating file foo in root dir"
+dd if=/dev/zero of=$SCRATCH_MNT/foo bs=1M count=1 &> /dev/null
+echo "List root dir"
+ls $SCRATCH_MNT
+echo "Creating snapshot of root dir"
+btrfs subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/snap
+echo "List root dir after snapshot"
+ls $SCRATCH_MNT
+echo "List snapshot dir"
+ls $SCRATCH_MNT/snap
+rm -f $SCRATCH_MNT/foo
+echo "List root dir after rm of foo"
+ls $SCRATCH_MNT
+echo "List snapshot dir"
+ls $SCRATCH_MNT/snap
+
+# Test creating a normal subvolme
+btrfs subvolume create $SCRATCH_MNT/subvol
+echo "Listing root dir"
+ls $SCRATCH_MNT
+echo "Listing subvol"
+ls $SCRATCH_MNT/subvol
+
+# Test setting a default mount
+echo "Creating file bar in subvol"
+dd if=/dev/zero of=$SCRATCH_MNT/subvol/bar bs=1M count=1 &> /dev/null
+echo "Setting subvol to the default"
+btrfs subvolume set-default $SCRATCH_MNT/subvol $SCRATCH_MNT/subvol
+_scratch_remount
+echo "List root dir which is now subvol"
+ls $SCRATCH_MNT
+_scratch_unmount
+echo "Mounting sbuvolid=0 for the root dir"
+_scratch_mount "-o subvolid=0"
+echo "List root dir"
+ls $SCRATCH_MNT
+echo "Setting the root dir as the default again"
+btrfs subvolume set-default $SCRATCH_MNT $SCRATCH_MNT
+_scratch_remount
+echo "List root dir"
+ls $SCRATCH_MNT
+
+# Test listing the subvolumes
+echo "Listing subvolumes"
+btrfs subvolume list $SCRATCH_MNT
+
+# Delete the snapshot
+btrfs subvolume delete $SCRATCH_MNT/snap
+echo "List root dir"
+ls $SCRATCH_MNT
+_scratch_remount
+echo "List root dir"
+ls $SCRATCH_MNT
+
+status=0 ; exit
diff --git a/254.out b/254.out
new file mode 100644
index 0000000..e1c19ee
--- /dev/null
+++ b/254.out
@@ -0,0 +1,40 @@
+QA output created by 254
+Creating file foo in root dir
+List root dir
+foo
+Creating snapshot of root dir
+Create a snapshot of '/mnt/scratch' in '/mnt/scratch/snap'
+List root dir after snapshot
+foo
+snap
+List snapshot dir
+foo
+List root dir after rm of foo
+snap
+List snapshot dir
+foo
+Create subvolume '/mnt/scratch/subvol'
+Listing root dir
+snap
+subvol
+Listing subvol
+Creating file bar in subvol
+Setting subvol to the default
+List root dir which is now subvol
+bar
+Mounting sbuvolid=0 for the root dir
+List root dir
+snap
+subvol
+Setting the root dir as the default again
+List root dir
+snap
+subvol
+Listing subvolumes
+ID 256 top level 5 path snap
+ID 257 top level 5 path subvol
+Delete subvolume '/mnt/scratch/snap'
+List root dir
+subvol
+List root dir
+subvol
diff --git a/group b/group
index 9f88e75..1f86075 100644
--- a/group
+++ b/group
@@ -367,3 +367,4 @@ deprecated
 251 ioctl trim
 252 auto quick prealloc
 253 auto quick
+254 auto quick
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
