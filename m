Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9SBpXfF015781 for <xfs@oss.sgi.com>; Thu, 28 Oct 2010 06:51:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3141912E49E
	for <xfs@oss.sgi.com>; Thu, 28 Oct 2010 04:52:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id D5vKDPoG0XEJPZOz for
	<xfs@oss.sgi.com>; Thu, 28 Oct 2010 04:52:26 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PBR1s-0000NB-Ch
	for xfs@oss.sgi.com; Thu, 28 Oct 2010 11:52:24 +0000
Date: Thu, 28 Oct 2010 07:52:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: add test for renaming over non-empty directories
Message-ID: <20101028115224.GA1429@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Per Posix renames over non-empty directories should fail, but hfsplus used to
allow this (and corrupt the filesystem while doing so).

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/245
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfstests-dev/245	2010-10-28 11:46:52.000000000 +0000
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 245
+#
+# Check that directory renames onto non-empty targets fail
+#
+# Based on a bug report and testcase from  Vlado Plaga <rechner@vlado-do.de>
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2010 Christoph Hellwig.  All Rights Reserved.
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
+owner=hch@lst.de
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+dir=$TEST_DIR/test-mv
+
+_cleanup()
+{
+	rm -rf $dir
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+
+mkdir $dir
+
+mkdir $dir/aa
+mkdir $dir/ab
+touch $dir/aa/1
+mkdir $dir/ab/aa
+touch $dir/ab/aa/2
+
+mv $dir/ab/aa/ $dir 2>&1 | _filter_test_dir
+
+status=0
+exit $status
Index: xfstests-dev/245.out
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfstests-dev/245.out	2010-10-28 11:45:48.000000000 +0000
@@ -0,0 +1,2 @@
+QA output created by 245
+mv: cannot move `TEST_DIR/test-mv/ab/aa/' to `TEST_DIR/test-mv/aa': File exists
Index: xfstests-dev/group
===================================================================
--- xfstests-dev.orig/group	2010-10-21 04:56:28.000000000 +0000
+++ xfstests-dev/group	2010-10-28 11:45:48.000000000 +0000
@@ -358,3 +358,4 @@ deprecated
 242 auto quick prealloc
 243 auto quick prealloc
 244 auto quota quick
+245 auto quick dir

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
