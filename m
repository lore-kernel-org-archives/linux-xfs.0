Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0C9xadd255419 for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 03:59:36 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EEC1215C2FD
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 02:00:31 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id hyUnGFsiFiePbC3U for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2010 02:00:31 -0800 (PST)
Date: Tue, 12 Jan 2010 05:00:31 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] xfsqa: make unmounting loop devices in 073 work again
Message-ID: <20100112100031.GA8749@infradead.org>
References: <1263271269-18997-1-git-send-email-david@fromorbit.com>
	<1263271269-18997-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263271269-18997-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 12, 2010 at 03:41:07PM +1100, Dave Chinner wrote:
> Loop devices are now created and destroyed on demand, and
> the existing hacks to do this no longer work. Remove them.

Just noticed that I had not been running this test at all for a long
time as it doesn't work with external logs.

Seems like the current code indeed fails reliably for me and this
patch fixes it.

The only problem is that the loop device autodestruct features is only
available since Linux 2.6.25 and also needs a recent util-linux.  Is
this old enough to simply go with the auto destruct version, or do
we need to support either one?

What about the patch below?  This adds the -d argument to the umount
calls for the loop images, which destroys the loop images in older
kernels and is a no-op for modern kernels that have the loop
auto-destruct feature:


Loop devices are now created and destroyed on demand, and
the existing hacks to do this no longer work. Remove them.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 073 |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

Index: xfstests-dev/073
===================================================================
--- xfstests-dev.orig/073	2009-05-28 18:29:58.000000000 +0000
+++ xfstests-dev/073	2010-01-12 09:53:37.000000000 +0000
@@ -3,15 +3,6 @@
 #
 # Test xfs_copy
 #
-# HACK WARNING:
-#
-# Due to the severe brokenness of mount's handling of loopback devices, we
-# hardcode the loop devices we use for this test. This enables us to clean up
-# the pieces when we remount the loop device because mount loses all trace of
-# the fact this is a loop device. Hence to enable us to unmount the hosting
-# filesystem, we need to manually tear down the relevant loop device. If
-# mount ever gets fixed then this hack can be removed.
-#
 #-----------------------------------------------------------------------
 # Copyright (c) 2000-2003,2008 Silicon Graphics, Inc.  All Rights Reserved.
 #
@@ -51,7 +42,7 @@ _cleanup()
 {
 	cd /
 	umount $SCRATCH_MNT 2>/dev/null
-	umount $imgs.loop 2>/dev/null
+	umount -d $imgs.loop 2>/dev/null
 	[ -d $imgs.loop ] && rmdir $imgs.loop
 	[ -d $imgs.source_dir ] && rm -rf $imgs.source_dir
 	rm -f $imgs.* $tmp.* /var/tmp/xfs_copy.log.*
@@ -127,9 +118,7 @@ _verify_copy()
 	diff -u $tmp.geometry1 $tmp.geometry2
 
 	echo unmounting and removing new image
-	loop=`mount | grep $target | grep -o -e 'loop=.*[^),]' | grep -o -e '/.*$'`
-	umount $source $target
-	losetup -d $loop > /dev/null 2>&1
+	umount -d $source_dir $target_dir
 	rm -f $target
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
