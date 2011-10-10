Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9AIMIf5195155 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 13:22:18 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8EEA51C7CAA6
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 11:22:17 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	7SAeYAomBNW4NBxX for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 11:22:17 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RDKUS-0000La-4h
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 18:22:16 +0000
Date: Mon, 10 Oct 2011 14:22:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] xfstests: split mapped writes vs direct I/O tests from 091
Message-ID: <20111010182216.GA1335@infradead.org>
References: <20111010182156.GA1323@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111010182156.GA1323@infradead.org>
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

This effectively reverts

	xfstests: add mapped write fsx operations to 091

and adds a new test case for it.  It tests something slightly different, and
regressions in existing tests due to new features are pretty nasty in a
test suite.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/263
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfstests-dev/263	2011-10-10 18:06:59.000000000 +0000
@@ -0,0 +1,64 @@
+#! /bin/bash
+# FS QA Test No. 263
+#
+# fsx exercising direct IO vs sub-block buffered I/O
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2000-2004 Silicon Graphics, Inc.  All Rights Reserved.
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
+owner=nathans@sgi.com
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
+. ./common.filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+rm -f $seq.full
+
+run_fsx()
+{
+	echo fsx $@ | tee -a $seq.full
+	args=`echo $@ | sed -e "s/ BSIZE / $bsize /g" -e "s/ PSIZE / $psize /g"`
+	rm -f $TEST_DIR/junk
+	$here/ltp/fsx $args $TEST_DIR/junk >>$seq.full 2>&1
+	if [ $? -ne 0 ]; then
+		cat $seq.full
+		exit 1
+	fi
+}
+
+psize=`$here/src/feature -s`
+bsize=`blockdev --getss $TEST_DEV`
+
+run_fsx -N 10000  -o 8192   -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
+run_fsx -N 10000  -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
+
+status=0
+exit
Index: xfstests-dev/group
===================================================================
--- xfstests-dev.orig/group	2011-10-10 18:04:52.000000000 +0000
+++ xfstests-dev/group	2011-10-10 18:05:02.000000000 +0000
@@ -376,3 +376,4 @@ deprecated
 260 auto quick trim
 261 auto quick quota
 262 auto quick quota
+263 rw auto quick
Index: xfstests-dev/263.out
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfstests-dev/263.out	2011-10-10 18:07:16.000000000 +0000
@@ -0,0 +1,3 @@
+QA output created by 263
+fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
+fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
Index: xfstests-dev/091
===================================================================
--- xfstests-dev.orig/091	2011-10-10 18:07:46.000000000 +0000
+++ xfstests-dev/091	2011-10-10 18:07:51.000000000 +0000
@@ -88,11 +88,5 @@ kernel=`uname -r  | sed -e 's/\(2\..\).*
 #run_fsx -N 10000  -o 128000 -l 500000 -r PSIZE -t PSIZE -w PSIZE -Z -W
  run_fsx -N 10000  -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
 
- run_fsx -N 10000  -o 8192   -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
- run_fsx -N 10000  -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
-
-# Commented out calls above are less likely to pick up issues, so
-# save time by commenting them out (leave 'em for manual testing).
-
 status=0
 exit
Index: xfstests-dev/091.out
===================================================================
--- xfstests-dev.orig/091.out	2011-10-10 18:07:53.000000000 +0000
+++ xfstests-dev/091.out	2011-10-10 18:07:55.000000000 +0000
@@ -5,5 +5,3 @@ fsx -N 10000 -o 32768 -l 500000 -r PSIZE
 fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
 fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
 fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
-fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
-fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
