Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LDqm8d146619 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 08:52:48 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 335011C2D4FC
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 06:52:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id l29t5ToCQAPj6gcK for
	<xfs@oss.sgi.com>; Wed, 21 Sep 2011 06:52:47 -0700 (PDT)
Subject: xfstests 258: Test xfs fs creation with fs size close to 4 TB
From: Boris Ranto <branto@redhat.com>
Date: Wed, 21 Sep 2011 15:52:40 +0200
Message-ID: <1316613160.781.8.camel@dhcp-26-208.brq.redhat.com>
Mime-Version: 1.0
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
To: xfs-oss <xfs@oss.sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>

mkfs.xfs failed to create xfs filesystems with 4 TB minus few bytes due
to round up error in mkfs.xfs code.

This test case is a regression test for the fs creation problem.

I've tested the test case with mkfs.xfs patch (in the form posted by
Eric Sandeen) and the test passed (and therefore the patch fixed the
issue for me).

Signed-off-by: Boris Ranto <branto@redhat.com>


diff --git a/258 b/258
new file mode 100755
index 0000000..b881626
--- /dev/null
+++ b/258
@@ -0,0 +1,60 @@
+#! /bin/bash
+# FS QA Test No. 258
+#
+# Test fs creation on 4 TB minus few bytes partition
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
+owner=branto@redhat.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+status=1	# failure is the default!
+
+_cleanup()
+{
+    rm -f "$testfile"
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+testfile=$TEST_DIR/258.image
+
+fourtb=4398046511104
+for sub in 1 512 1024 1025 2048 4096;
+do
+	echo "Trying to make $fourtb - $sub B long xfs fs image"
+	rm -f "$testfile"
+	dd if=/dev/zero "of=$testfile" bs=1 count=0 seek=$(($fourtb - $sub))
>/dev/null 2>&1 || echo "dd failed"
+	lofile=$(losetup -f)
+	losetup $lofile "$testfile"
+	"$MKFS_XFS_PROG" -b size=512 $lofile >/dev/null || echo "mkfs failed!"
+	losetup -d $lofile
+done
+
+status=0 ; exit
diff --git a/258.out b/258.out
new file mode 100644
index 0000000..22e9652
--- /dev/null
+++ b/258.out
@@ -0,0 +1,7 @@
+QA output created by 258
+Trying to make 4398046511104 - 1 B long xfs fs image
+Trying to make 4398046511104 - 512 B long xfs fs image
+Trying to make 4398046511104 - 1024 B long xfs fs image
+Trying to make 4398046511104 - 1025 B long xfs fs image
+Trying to make 4398046511104 - 2048 B long xfs fs image
+Trying to make 4398046511104 - 4096 B long xfs fs image
diff --git a/group b/group
index 84c45da..739f806 100644
--- a/group
+++ b/group
@@ -371,3 +371,4 @@ deprecated
 255 auto quick prealloc
 256 auto quick
 257 auto quick
+258 auto quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
