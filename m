Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5KHZTQ1127917 for <xfs@oss.sgi.com>; Sat, 20 Jun 2009 12:35:29 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A329112A83E4
	for <xfs@oss.sgi.com>; Sat, 20 Jun 2009 10:35:54 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id E1u6xX3OV62cfGuP for
	<xfs@oss.sgi.com>; Sat, 20 Jun 2009 10:35:54 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MI4Tq-0006tq-M2
	for xfs@oss.sgi.com; Sat, 20 Jun 2009 17:35:54 +0000
Date: Sat, 20 Jun 2009 13:35:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: don't print scratch mkfs and mount options
	without scratch device
Message-ID: <20090620173554.GA26470@infradead.org>
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

Also clean up the way the test configuration is printed.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/check
===================================================================
--- xfstests-dev.orig/check	2009-06-20 17:31:00.000000000 +0000
+++ xfstests-dev/check	2009-06-20 17:33:46.000000000 +0000
@@ -161,18 +161,15 @@
 
 [ -f check.time ] || touch check.time
 
-FULL_FSTYP_DETAILS=`_full_fstyp_details`
-FULL_HOST_DETAILS=`_full_platform_details`
-FULL_MKFS_OPTIONS=`_scratch_mkfs_options`
-FULL_MOUNT_OPTIONS=`_scratch_mount_options`
-
-cat <<EOF
-FSTYP         -- $FULL_FSTYP_DETAILS
-PLATFORM      -- $FULL_HOST_DETAILS
-MKFS_OPTIONS  -- $FULL_MKFS_OPTIONS
-MOUNT_OPTIONS -- $FULL_MOUNT_OPTIONS
+# print out our test configuration
+echo "FSTYP         -- `_full_fstyp_details`"
+echo "PLATFORM      -- `_full_platform_details`"
+if [ ! -z "$SCRATCH_DEV" ]; then
+  echo "MKFS_OPTIONS  -- `_scratch_mkfs_options`"
+  echo "MOUNT_OPTIONS -- `_scratch_mount_options`"
+fi
+echo
 
-EOF
 
 if [ ! -z "$SCRATCH_DEV" ]; then
   umount $SCRATCH_DEV 2>/dev/null

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
