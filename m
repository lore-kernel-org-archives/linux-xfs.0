Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1EGewSj003319 for <xfs@oss.sgi.com>; Sat, 14 Feb 2009 10:40:59 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A8739BEED8F
	for <xfs@oss.sgi.com>; Sat, 14 Feb 2009 08:40:24 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 6kNTN1Sbbr1Z3FXx for
	<xfs@oss.sgi.com>; Sat, 14 Feb 2009 08:40:24 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LYNZ2-0005bv-5a
	for xfs@oss.sgi.com; Sat, 14 Feb 2009 16:40:24 +0000
Date: Sat, 14 Feb 2009 11:40:24 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] test 199: test features2 fixup for the regular case, too
Message-ID: <20090214164024.GB19813@infradead.org>
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

Eric Sandeen noted that we should not only test the mount ro first, then
remount rw case in 199 but also the regular mount rw case.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/199
===================================================================
--- xfstests-dev.orig/199	2009-02-14 15:08:08.000000000 +0000
+++ xfstests-dev/199	2009-02-14 15:10:53.000000000 +0000
@@ -1,8 +1,10 @@
 #! /bin/sh
 # FS QA Test No. 199
 #
-# Check that a filesystem first mounted read-only and then remounted
-# performs the features2 fixup properly.
+# Check that the features2 localtion fixups work correctly.  We check both
+# a regualar read-write mount of a filesystem and the case where the
+# filesystem is first mounted read-only and then later remounted read-write,
+# which is the usual case for the root filesystem.
 #
 #-----------------------------------------------------------------------
 # Copyright (c) 2008 Christoph Hellwig.
@@ -51,8 +53,20 @@
 echo "Clearing features2:"
 xfs_db -x $SCRATCH_DEV -c 'sb' -c 'write features2 0'
 
+_scratch_mount
+umount $SCRATCH_MNT
+echo "Features 2 after mount rw:"
+xfs_db -x $SCRATCH_DEV -c 'sb' -c 'print features2'
+
+#
+# Clear the normal flags again for the second rount.
+#
+echo "Clearing features2:"
+xfs_db -x $SCRATCH_DEV -c 'sb' -c 'write features2 0'
+
 #
 # And print the flags after a mount ro and remount rw
+#
 _scratch_mount -o ro
 _scratch_mount -o remount,rw
 umount $SCRATCH_MNT
Index: xfstests-dev/199.out
===================================================================
--- xfstests-dev.orig/199.out	2009-02-14 15:11:18.000000000 +0000
+++ xfstests-dev/199.out	2009-02-14 15:11:26.000000000 +0000
@@ -4,6 +4,10 @@
 bad_features2 = 0x8
 Clearing features2:
 features2 = 0
+Features 2 after mount rw:
+features2 = 0x8
+Clearing features2:
+features2 = 0
 Features 2 after mount ro and remount rw:
 features2 = 0x8
 *** done

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
