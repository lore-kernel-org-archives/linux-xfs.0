Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0N053YB124558 for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 18:05:03 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84BB2AE7EF
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 16:04:19 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Vdt8EhxEgQG5CNHB for
	<xfs@oss.sgi.com>; Thu, 22 Jan 2009 16:04:19 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LQ9X0-0002d1-6x
	for xfs@oss.sgi.com; Fri, 23 Jan 2009 00:04:18 +0000
Date: Thu, 22 Jan 2009 19:04:18 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: add test 202, xfs_repair handling of single-AG
	filesystems
Message-ID: <20090123000418.GA4970@infradead.org>
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


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/202
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfstests-dev/202	2009-01-22 23:14:28.000000000 +0000
@@ -0,0 +1,42 @@
+#! /bin/sh
+# FS QA Test No. 202
+#
+# Test out the xfs_repair -o force_geometry option on single-AG filesystems.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2009 Christoph Hellwig.
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
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+
+echo "== Creating single-AG filesystem =="
+_scratch_mkfs_xfs -d agcount=1 >/dev/null 2>&1
+
+echo "== Trying to repair it (should fail) =="
+xfs_repair $SCRATCH_DEV
+
+echo "== Trying to repair it with -o force_geometry =="
+xfs_repair -o force_geometry $SCRATCH_DEV
+
+# success, all done
+echo "*** done"
+rm -f $seq.full
+status=0
Index: xfstests-dev/202.out
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfstests-dev/202.out	2009-01-22 23:15:43.000000000 +0000
@@ -0,0 +1,31 @@
+QA output created by 202
+== Creating single-AG filesystem ==
+== Trying to repair it (should fail) ==
+Phase 1 - find and verify superblock...
+Only one AG detected - cannot validate filesystem geometry.
+Use the -o force_geometry option to proceed.
+== Trying to repair it with -o force_geometry ==
+Phase 1 - find and verify superblock...
+Phase 2 - using internal log
+        - zero log...
+        - scan filesystem freespace and inode maps...
+        - found root inode chunk
+Phase 3 - for each AG...
+        - scan and clear agi unlinked lists...
+        - process known inodes and perform inode discovery...
+        - agno = 0
+        - process newly discovered inodes...
+Phase 4 - check for duplicate blocks...
+        - setting up duplicate extent list...
+        - check for inodes claiming duplicate blocks...
+        - agno = 0
+Phase 5 - rebuild AG headers and trees...
+        - reset superblock...
+Phase 6 - check inode connectivity...
+        - resetting contents of realtime bitmap and summary inodes
+        - traversing filesystem ...
+        - traversal finished ...
+        - moving disconnected inodes to lost+found ...
+Phase 7 - verify and correct link counts...
+done
+*** done
Index: xfstests-dev/group
===================================================================
--- xfstests-dev.orig/group	2009-01-22 22:52:48.000000000 +0000
+++ xfstests-dev/group	2009-01-22 22:52:53.000000000 +0000
@@ -303,3 +303,4 @@
 199 mount auto
 200 mount auto
 201 metadata auto
+202 repair auto

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
