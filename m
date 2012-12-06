Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB6LxeGa160042 for <xfs@oss.sgi.com>; Thu, 6 Dec 2012 15:59:40 -0600
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id clFpLs7MlmGr0LcW for <xfs@oss.sgi.com>;
	Thu, 06 Dec 2012 14:02:05 -0800 (PST)
Message-ID: <50C115E8.9090106@sandeen.net>
Date: Thu, 06 Dec 2012 16:02:16 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: Ensure cmdline geometry puts mkfs.xfs into multidisk
	mode
References: <50ABB115.9070905@sandeen.net>
	<20121121095636.GC23339@infradead.org>
In-Reply-To: <20121121095636.GC23339@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Ben England <bengland@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Ensure that when mkfs.xfs is invoked with commandline geometry, it
triggers multidisk mode and creates more AGs.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Maybe this should also test device-specified geometry, but not sure
how to do that easily within xfstests, any ideas?

diff --git a/291 b/291
new file mode 100755
index 0000000..045d2a0
--- /dev/null
+++ b/291
@@ -0,0 +1,63 @@
+#! /bin/bash
+# FS QA Test No. 291
+#
+# Ensure mkfs with stripe geometry goes into multidisk mode
+# which results in more AGs
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2012 Red Hat, Inc.  All Rights Reserved.
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
+_supported_fs xfs
+_supported_os IRIX Linux
+
+fsfile=$TEST_DIR/fsfile.$seq
+
+rm -f $fsfile
+$XFS_IO_PROG -f -c "truncate 256g" $fsfile
+
+echo "mkfs.xfs without geometry"
+mkfs.xfs -f $fsfile 2>&1 | sed -e "s:$fsfile:FILENAME:g" | grep meta-data
+echo "mkfs.xfs with cmdline geometry"
+mkfs.xfs -f -d su=16k,sw=5 $fsfile 2>&1 | sed -e "s:$fsfile:FILENAME:g" | grep meta-data
+
+# success, all done
+status=0
+exit
diff --git a/291.out b/291.out
new file mode 100644
index 0000000..fd702c0
--- /dev/null
+++ b/291.out
@@ -0,0 +1,5 @@
+QA output created by 291
+mkfs.xfs without geometry
+meta-data=FILENAME   isize=256    agcount=4, agsize=16777216 blks
+mkfs.xfs with cmdline geometry
+meta-data=FILENAME   isize=256    agcount=16, agsize=4194304 blks
diff --git a/group b/group
index dacdb56..2ddb047 100644
--- a/group
+++ b/group
@@ -409,3 +409,4 @@ deprecated
 288 auto quick ioctl trim
 289 auto quick
 290 auto rw prealloc quick ioctl
+291 auto mkfs quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
