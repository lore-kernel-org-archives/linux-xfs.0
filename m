Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0KNNFBg023864 for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 17:23:15 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A36E182CD0D
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 15:23:15 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ODgca7ialcFcHlKO for
	<xfs@oss.sgi.com>; Tue, 20 Jan 2009 15:23:15 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LPPwA-000707-WC
	for xfs@oss.sgi.com; Tue, 20 Jan 2009 23:23:15 +0000
Date: Tue, 20 Jan 2009 18:23:14 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstest: add test 201: btree corruption without CONFIG_LBD
Message-ID: <20090120232314.GB16776@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

Index: xfstests-dev/201
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfstests-dev/201	2009-01-20 23:20:49.000000000 +0000
@@ -0,0 +1,87 @@
+#! /bin/sh
+# FS QA Test No. 201
+#
+# Test out the infamout xfs_btree_delrec corruption.
+#
+# Only happens on 32-bit kernels without CONFIG_LBD, but it should be harmless
+# to run this everywhere.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2001 Christoph Hellwig.
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
+do_pwrite()
+{
+	offset=`expr $1 \* 512`
+	end=`expr $2 \* 512`
+	length=`expr $end - $offset`
+
+	xfs_io -d -f $file -c "pwrite $offset $length" >/dev/null
+}
+
+
+
+_cleanup()
+{
+	umount $SCRATCH_MNT
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+file=$SCRATCH_MNT/f
+
+_require_scratch
+
+_scratch_mkfs_xfs >/dev/null 2>&1
+_scratch_mount
+
+# Create a fragmented file
+do_pwrite 30792 31039
+do_pwrite 30320 30791
+do_pwrite 29688 30319
+do_pwrite 29536 29687
+do_pwrite 27216 29535
+do_pwrite 24368 27215
+do_pwrite 21616 24367
+do_pwrite 20608 21615
+do_pwrite 19680 20607
+do_pwrite 19232 19679
+do_pwrite 17840 19231
+do_pwrite 16928 17839
+do_pwrite 15168 16927
+do_pwrite 14048 15167
+do_pwrite 12152 14047
+do_pwrite 11344 12151
+do_pwrite 8792 11343
+do_pwrite 6456 8791
+do_pwrite 5000 6455
+do_pwrite 1728 4999
+do_pwrite 0 1727
+
+sync
+sync
+
+# and truncate it again
+> $SCRATCH_MNT/bigfile
+
+# success, all done
+echo "*** done"
+rm -f $seq.full
+status=0
Index: xfstests-dev/201.out
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfstests-dev/201.out	2009-01-20 23:17:30.000000000 +0000
@@ -0,0 +1,2 @@
+QA output created by 201
+*** done
Index: xfstests-dev/group
===================================================================
--- xfstests-dev.orig/group	2009-01-20 23:11:54.000000000 +0000
+++ xfstests-dev/group	2009-01-20 23:12:04.000000000 +0000
@@ -302,3 +302,4 @@
 197 dir auto
 199 mount auto
 200 mount auto
+201 metadata auto

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
