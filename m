Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0C4ijmN217443 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 22:44:46 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 71B1A1C44455
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 20:45:39 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	Z9UTXNuvV7XjLPFz for <xfs@oss.sgi.com>;
	Mon, 11 Jan 2010 20:45:39 -0800 (PST)
Received: from discord (unverified [121.44.168.156])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11326441-1927428
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 15:15:37 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NUYdL-0004g6-OA
	for xfs@oss.sgi.com; Tue, 12 Jan 2010 15:45:35 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NUYZJ-0005za-8j
	for xfs@oss.sgi.com; Tue, 12 Jan 2010 15:41:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/4] xfsqa: make unmounting loop devices in 073 work again
Date: Tue, 12 Jan 2010 15:41:07 +1100
Message-Id: <1263271269-18997-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1263271269-18997-1-git-send-email-david@fromorbit.com>
References: <1263271269-18997-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Loop devices are now created and destroyed on demand, and
the existing hacks to do this no longer work. Remove them.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 073 |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/073 b/073
index 5059448..ac4c64f 100755
--- a/073
+++ b/073
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
@@ -127,9 +118,7 @@ _verify_copy()
 	diff -u $tmp.geometry1 $tmp.geometry2
 
 	echo unmounting and removing new image
-	loop=`mount | grep $target | grep -o -e 'loop=.*[^),]' | grep -o -e '/.*$'`
-	umount $source $target
-	losetup -d $loop > /dev/null 2>&1
+	umount $source_dir $target_dir
 	rm -f $target
 }
 
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
