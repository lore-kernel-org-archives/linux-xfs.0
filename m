Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CCEBB7F37
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 06:06:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0B66BAC00E
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 04:06:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ZVFxSCqASsxWAaph for
	<xfs@oss.sgi.com>; Fri, 30 Aug 2013 04:06:21 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7UB6KIv023550
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 07:06:21 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfstests ext4/306: regression test for ext4 resize with
	non-extent files
Date: Fri, 30 Aug 2013 19:06:07 +0800
Message-Id: <1377860767-13304-1-git-send-email-eguan@redhat.com>
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
Cc: Eric Sandeen <esandeen@redhat.com>, Eryu Guan <eguan@redhat.com>

From: Eric Sandeen <esandeen@redhat.com>

Regression test for:

c5c72d8 ext4: fix online resizing for ext3-compat file systems

Signed-off-by: Eric Sandeen <esandeen@redhat.com>
Signed-off-by: Eryu Guan <eguan@redhat.com>
---

This test is originally written by Eric and doesn't get merged. I did
minor update and resent.

V2: s/dangerous/auto/
V3: remove "Silence is golden" output since it's not silent

 tests/ext4/306     | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/306.out | 13 +++++++++
 tests/ext4/group   |  1 +
 3 files changed, 96 insertions(+)
 create mode 100755 tests/ext4/306
 create mode 100644 tests/ext4/306.out

diff --git a/tests/ext4/306 b/tests/ext4/306
new file mode 100755
index 0000000..398c4c0
--- /dev/null
+++ b/tests/ext4/306
@@ -0,0 +1,82 @@
+#! /bin/bash
+# FS QA Test No. ext4/306
+#
+# Test that blocks are available to non-extent files after a resize2fs
+# Regression test for commit:
+# c5c72d8 ext4: fix online resizing for ext3-compat file systems
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
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
+PIDS=""
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    _scratch_unmount
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs ext4
+_supported_os Linux
+
+_require_scratch
+
+# This needs to mount ext3; might require ext3 driver, or ext4
+# might handle it itself.  Find out if we have it one way or another.
+modprobe ext3 > /dev/null 2>&1
+grep -q ext3 /proc/filesystems || _notrun "This test requires ext3 support"
+
+rm -f $seqres.full
+
+# Make a small ext3 fs, (extents disabled) & mount it
+yes | mkfs.ext3 $SCRATCH_DEV 512m >> $seqres.full 2>&1
+_scratch_mount -t ext3 || _fail "couldn't mount fs as ext3"
+# Create a small non-extent-based file
+echo "Create 1m testfile1"
+$XFS_IO_PROG -f $SCRATCH_MNT/testfile1 -c "pwrite 0 1m" | _filter_xfs_io
+echo "Create testfile2 to fill the fs"
+# A large non-extent-based file filling the fs; this will run out & fail
+$XFS_IO_PROG -f $SCRATCH_MNT/testfile2 -c "pwrite 0 512m" | _filter_xfs_io
+
+# Remount as ext4
+_scratch_unmount
+_scratch_mount -t ext4 || _fail "couldn't remount fs as ext4"
+df -h $SCRATCH_MNT >> $seqres.full
+
+# Grow it by 512m
+echo "Resize to 1g"
+resize2fs $SCRATCH_DEV 1g >> $seqres.full 2>&1 || _fail "Could not resize to 1g"
+df -h $SCRATCH_MNT >> $seqres.full
+
+# See if we can add more blocks to the files
+echo "append 2m to testfile1"
+$XFS_IO_PROG -f $SCRATCH_MNT/testfile1 -c "pwrite 1m 2m" | _filter_xfs_io
+echo "append 2m to testfile2"
+$XFS_IO_PROG -f $SCRATCH_MNT/testfile1 -c "pwrite 512m 2m" | _filter_xfs_io
+
+status=0
+exit
diff --git a/tests/ext4/306.out b/tests/ext4/306.out
new file mode 100644
index 0000000..ee6c90c
--- /dev/null
+++ b/tests/ext4/306.out
@@ -0,0 +1,13 @@
+QA output created by 306
+Create 1m testfile1
+wrote 1048576/1048576 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Create testfile2 to fill the fs
+pwrite64: No space left on device
+Resize to 1g
+append 2m to testfile1
+wrote 2097152/2097152 bytes at offset 1048576
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+append 2m to testfile2
+wrote 2097152/2097152 bytes at offset 536870912
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/ext4/group b/tests/ext4/group
index 53af708..7e1a68b 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -9,3 +9,4 @@
 303 aio dangerous ioctl rw stress
 304 aio dangerous ioctl rw stress
 305 auto
+306 auto rw resize quick
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
