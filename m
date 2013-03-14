Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B60997FA4
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 16:40:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9F9FF304043
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 14:40:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QHKq7GnB8pwxKwpn for
	<xfs@oss.sgi.com>; Thu, 14 Mar 2013 14:40:18 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2ELeI5r014661
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 17:40:18 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r2ELeGtl000728
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 17:40:17 -0400
Message-ID: <514243C0.1000309@redhat.com>
Date: Thu, 14 Mar 2013 16:40:16 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: test writing to device node on an RO filesystem
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
To: xfs-oss <xfs@oss.sgi.com>

we should be able to open device nodes for writing even
if they live on a readonly filesytem.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(I may have *cough* broken this on a backport once, hence the test)

diff --git a/315 b/315
new file mode 100755
index 0000000..8b8ecc6
--- /dev/null
+++ b/315
@@ -0,0 +1,79 @@
+#! /bin/bash
+# FS QA Test No. 315
+#
+# Test that we can write to a device node residing on a RO filesystem
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
+_scratch_mount
+
+rm -f $DEVNULL $DEVZERO
+
+mknod $DEVNULL c 1 3 || _fail "Could not create devnull device"
+mknod $DEVZERO c 1 5 || _fail "Could not create devzero device"
+
+_scratch_unmount || _fail "Could not unmount scratch device"
+_scratch_mount -o ro || _fail "Could not remount scratch readonly"
+
+# We should be able to read & write to/from these devices even on an RO fs
+echo "== try to create new file"
+touch $SCRATCH_MNT/this_should_fail 2>&1 | _filter_scratch
+echo "== prite to null device"
+xfs_io -c "pwrite 0 512" /dev/null | _filter_xfs_io
+echo "== pread from zero device"
+xfs_io -c "pread 0 512" /dev/zero | _filter_xfs_io
+
+echo "== truncating write to null device"
+echo foo >> $DEVNULL 2>&1 | _filter_scratch
+echo "== appending write to null device"
+echo foo >> $DEVNULL 2>&1 | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/315.out b/315.out
new file mode 100644
index 0000000..d07c567
--- /dev/null
+++ b/315.out
@@ -0,0 +1,11 @@
+QA output created by 315
+== try to create new file
+touch: cannot touch `SCRATCH_MNT/this_should_fail': Read-only file system
+== prite to null device
+wrote 512/512 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+== pread from zero device
+read 512/512 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+== truncating write to null device
+== appending write to null device
diff --git a/group b/group
index fcbdfb6..fd838ef 100644
--- a/group
+++ b/group
@@ -430,3 +430,4 @@ stress
 305 aio dangerous enospc rw stress
 313 auto quick
 314 auto
+315 auto rw

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
