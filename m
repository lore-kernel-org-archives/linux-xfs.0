Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 960F67FA9
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 21:37:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2FB77AC005
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 19:37:36 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id zrXJdCVOey6uO8Vu for <xfs@oss.sgi.com>;
	Thu, 14 Mar 2013 19:37:35 -0700 (PDT)
Message-ID: <5142896E.9060609@sandeen.net>
Date: Thu, 14 Mar 2013 21:37:34 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfstests: test writing to device node on an RO filesystem
References: <514243C0.1000309@redhat.com>
In-Reply-To: <514243C0.1000309@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

We should be able to open device nodes for writing even
if they live on a readonly filesytem.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: fix typos, use XFS_IO_PROG, fix c&p error on echo,
remember _scratch_mkfs

diff --git a/315 b/315
new file mode 100755
index 0000000..0443d9f
--- /dev/null
+++ b/315
@@ -0,0 +1,81 @@
+#! /bin/bash
+# FS QA Test No. 315
+#
+# Test RW open of a device on a RO fs
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
+#
+# creator
+owner=sandeen@redhat.com	
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
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+
+DEVNULL=$SCRATCH_MNT/devnull
+DEVZERO=$SCRATCH_MNT/devzero
+
+rm -f $seq.full
+_scratch_mkfs > $seq.full 2>&1
+_scratch_mount
+
+rm -f $DEVNULL $DEVZERO
+
+mknod $DEVNULL c 1 3 || _fail "Could not create devnull device"
+mknod $DEVZERO c 1 5 || _fail "Could not create devzero device"
+
+_scratch_unmount || _fail "Could not unmount scratch device"
+_scratch_mount -o ro || _fail "Could notemount scratch readonly"
+
+# We should be able to read & write to/from these devices even on an RO fs
+echo "== try to create new file"
+touch $SCRATCH_MNT/this_should_fail 2>&1 | _filter_scratch
+echo "== pwrite to null device"
+$XFS_IO_PROG -c "pwrite 0 512" /dev/null | _filter_xfs_io
+echo "== pread from zero device"
+$XFS_IO_PROG -c "pread 0 512" /dev/zero | _filter_xfs_io
+
+echo "== truncating write to null device"
+echo foo > $DEVNULL 2>&1 | _filter_scratch
+echo "== appending write to null device"
+echo foo >> $DEVNULL 2>&1 | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/315.out b/315.out
new file mode 100644
index 0000000..19791ed
--- /dev/null
+++ b/315.out
@@ -0,0 +1,11 @@
+QA output created by 315
+== try to create new file
+touch: cannot touch `SCRATCH_MNT/this_should_fail': Read-only file system
+== pwrite to null device
+wrote 512/512 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+== pread from zero device
+read 512/512 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+== truncating write to null device
+== appending write to null device
diff --git a/group b/group
index fcbdfb6..1c53068 100644
--- a/group
+++ b/group
@@ -423,3 +423,4 @@ stress
 305 aio dangerous enospc rw stress
 313 auto quick
 314 auto
+315 auto rw


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
