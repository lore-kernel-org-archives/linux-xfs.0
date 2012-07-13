Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6DCRHZ7153319 for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 07:27:17 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 821C230405F
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 05:27:14 -0700 (PDT)
Received: from [134.15.68.149] (cf-vpn-sw-corp-68-149.corp.sgi.com
	[134.15.68.149])
	by estes.americas.sgi.com (Postfix) with ESMTP id C3A2970018B3
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 07:27:13 -0500 (CDT)
Message-ID: <50001420.9020001@sgi.com>
Date: Fri, 13 Jul 2012 14:27:12 +0200
From: Alain Renaud <arenaud@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] xfstest: preallocate file space greater then MAXEXTLEN
References: <20120713122520.837966548@sgi.com>
In-Reply-To: <20120713122520.837966548@sgi.com>
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
To: xfs@oss.sgi.com

xfstest: preallocate file space greater then MAXEXTLEN

This test is trying to reserve file space greater then the maximum size 
allow per extent, this also using extsize to see if the extsize
alignment does not overflow MAXEXTLEN.

You need to make sure that you are AG that are big enough to
contain the entire extent.

Signed-off-by: Alain Renaud <arenaud@sgi.com>
---
  288     |   88 	88 +	0 -	0 !
  288.out |    2 	2 +	0 -	0 !
  group   |    1 	1 +	0 -	0 !
  3 files changed, 91 insertions(+)
  create mode 100755 288
  create mode 100644 288.out

Index: b/288
===================================================================
--- /dev/null
+++ b/288
@@ -0,0 +1,88 @@
+#! /bin/bash
+# FS QA Test No. 288
+#
+# test preallocation using value greater the maximum size for extent.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2012 SGI.  All Rights Reserved.
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
+owner=arenaud@sgi.com
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
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+
+rm -f $seq.full
+# Use a small block size so we do not need to much disk
+# space to get more the 2^21 block. Since the AG size
+# also need to be bigger then 2^21 block. let's create
+# a 4Gig filesystem with 1 AG.
+if ! _scratch_mkfs_xfs -b size=512 \
+    -d agcount=1,size=4294967296 >> $seq.full 2>&1
+then
+    echo "!!! failed to mkfs on $SCRATCH_DEV"
+    exit ${status}
+fi
+
+_scratch_mount
+
+if ! cd ${SCRATCH_MNT}
+then
+    echo "!!! failed to cd in SCRATCH_MNT"
+    exit ${status}
+fi
+
+mkdir testdir
+cd testdir
+xfs_io -c 'extsize 1m' .
+xfs_io -f -c 'resvsp 0 1g' testfile
+rm testfile
+xfs_io -f -c 'resvsp 512 1g' testfile
+rm testfile
+
+
+xfs_io -c 'extsize 4m' .
+xfs_io -f -c 'resvsp 0 1g' testfile
+rm testfile
+xfs_io -f -c 'resvsp 512 1g' testfile
+rm testfile
+
+
+cd "$here"
+
+_scratch_unmount
+echo "Silence is golden"
+
+# success, all done
+status=0
+exit
Index: b/288.out
===================================================================
--- /dev/null
+++ b/288.out
@@ -0,0 +1,2 @@
+QA output created by 288
+Silence is golden
Index: b/group
===================================================================
--- a/group
+++ b/group
@@ -406,3 +406,4 @@
  285 auto rw
  286 other
  287 auto rw
+288 auto quick rw

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
