Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0J0NfiV010204 for <xfs@oss.sgi.com>; Sun, 18 Jan 2009 18:23:46 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B1FA181B9AB
	for <xfs@oss.sgi.com>; Sun, 18 Jan 2009 16:23:39 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ITzDh3YHT8Yuft5d for
	<xfs@oss.sgi.com>; Sun, 18 Jan 2009 16:23:39 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LOhvX-0001QU-FR
	for xfs@oss.sgi.com; Mon, 19 Jan 2009 00:23:39 +0000
Date: Sun, 18 Jan 2009 19:23:39 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: run 092 unconditionally
Message-ID: <20090119002339.GA317@infradead.org>
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

Now that we support inode64 filesystem on 32-bit plaforms tests 092
should be run unconditionally.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/092
===================================================================
--- xfstests-dev.orig/092	2009-01-19 00:21:40.000000000 +0000
+++ xfstests-dev/092	2009-01-19 00:22:09.000000000 +0000
@@ -1,7 +1,7 @@
 #! /bin/sh
 # FS QA Test No. 092
 #
-# Make sure that 64 bit platforms can mount inode64 filesystems
+# Make sure that we can mount inode64 filesystems
 #
 #-----------------------------------------------------------------------
 # Copyright (c) 2000-2004 Silicon Graphics, Inc.  All Rights Reserved.
@@ -36,9 +36,6 @@
 _require_scratch
 _require_nobigloopfs
 
-bitsperlong=`src/feature -w`
-[ "$bitsperlong" -ne 64 ] && _notrun "inode64 not checked on this platform"
-
 MOUNT_OPTIONS="$MOUNT_OPTIONS -o inode64"
 _scratch_mkfs_xfs | _filter_mkfs 2>/dev/null
 echo Silence is golden

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
