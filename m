Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8JIdLDh007124 for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 13:39:22 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B1A413FE843
	for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 11:44:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8U9FUvomrtE2cstg for
	<xfs@oss.sgi.com>; Mon, 19 Sep 2011 11:44:34 -0700 (PDT)
Message-ID: <4E778C51.7040100@redhat.com>
Date: Mon, 19 Sep 2011 13:39:13 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: test timestamps before the epoch
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
Cc: Christoph Hellwig <hch@infradead.org>

ext2/3/4 was sign-extending times before the timestamp when read
from disk on 64-bit systems.  This was fixed by:

4d7bf11d649c72621ca31b8ea12b9c94af380e63
ext2/3/4: fix file date underflow on ext2 3 filesystems on 64 bit systems

Here's a generic regression test.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/257 b/257
new file mode 100644
index 0000000..e837bef
--- /dev/null
+++ b/257
@@ -0,0 +1,68 @@
+#! /bin/bash
+# FS QA Test No. 257
+#
+# Test timestamps prior to epoch
+# On 64-bit, ext2/3/4 was sign-extending when read from disk
+# See also commit 4d7bf11d649c72621ca31b8ea12b9c94af380e63
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011 Red Hat, Inc.  All Rights Reserved.
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
+owner=sandeen@redhat.com
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
+_supported_fs generic
+_supported_os Linux
+
+TESTFILE=$TEST_DIR/timestamp-test.txt
+
+# Create a file with a timestamp prior to the epoch
+echo "Creating file with timestamp of Jan 1, 1960"
+touch -t 196001010101 $TESTFILE
+# Should yield -315593940 (prior to epoch)
+echo -n "Stat of file yields: "
+stat -c %X $TESTFILE
+
+# unmount, remount, and check the timestamp
+echo "Remounting to flush cache"
+umount $TEST_DEV
+mount $TEST_DEV $TEST_DIR
+
+# Should yield -315593940 (prior to epoch)
+echo -n "Stat of file yields: "
+stat -c %X $TESTFILE
+
+status=0 ; exit
diff --git a/257.out b/257.out
new file mode 100644
index 0000000..c584b70
--- /dev/null
+++ b/257.out
@@ -0,0 +1,5 @@
+QA output created by 257
+Creating file with timestamp of Jan 1, 1960
+Stat of file yields: -315593940
+Remounting to flush cache
+Stat of file yields: -315593940
diff --git a/group b/group
index 0c746c8..84c45da 100644
--- a/group
+++ b/group
@@ -370,3 +370,4 @@ deprecated
 254 auto quick
 255 auto quick prealloc
 256 auto quick
+257 auto quick


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
