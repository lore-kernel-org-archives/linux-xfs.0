Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9U9ViJs177543 for <xfs@oss.sgi.com>; Fri, 30 Oct 2009 04:31:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 836A2C8B45C
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2009 02:31:56 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ydZoGgVml2MgwuZh for
	<xfs@oss.sgi.com>; Fri, 30 Oct 2009 02:31:56 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1N3npr-0002bB-Vr
	for xfs@oss.sgi.com; Fri, 30 Oct 2009 09:31:56 +0000
Date: Fri, 30 Oct 2009 05:31:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: add another quotaoff testcase to 220
Message-ID: <20091030093155.GA9329@infradead.org>
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

Add the quotafile space remove regression test from Ryota Yamauchi to
testcase 220.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/220
===================================================================
--- xfstests-dev.orig/220	2009-10-30 09:16:52.000000000 +0000
+++ xfstests-dev/220	2009-10-30 09:29:19.000000000 +0000
@@ -1,10 +1,10 @@
 #! /bin/sh
 # FS QA Test No. 220
 #
-# Test that turning quotas off on a mounted filesystem doesn't crash
-# the system.
+# Test quota off handling.
 #
-# Based on a bug report from Utako Kusaka <u-kusaka@wm.jp.nec.com>.
+# Based on bug reports from Utako Kusaka <u-kusaka@wm.jp.nec.com> and
+# Ryota Yamauchi <r-yamauchi@vf.jp.nec.com>.
 #
 #-----------------------------------------------------------------------
 # Copyright (c) 2009 Christoph Hellwig.  All Rights Reserved.
@@ -67,5 +67,19 @@ xfs_quota -x -c off $SCRATCH_DEV
 # and unmount (this used to crash)
 umount $SCRATCH_DEV
 
+
+# create scratch filesystem
+_scratch_mkfs_xfs >/dev/null 2>&1
+
+# mount  with quotas enabled
+_scratch_mount -o uquota
+
+# turn off quota and remove space allocated to the quota files
+# (this used to give wrong ENOSYS returns in 2.6.31)
+xfs_quota -x -c off -c remove $SCRATCH_DEV
+
+# and unmount again
+umount $SCRATCH_DEV
+
 status=0
 exit $status

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
