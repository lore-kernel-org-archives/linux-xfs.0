Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Jun 2007 23:44:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l576hxWt020613
	for <xfs@oss.sgi.com>; Wed, 6 Jun 2007 23:44:02 -0700
Date: Thu, 7 Jun 2007 16:43:52 +1000
From: David Chinner <dgc@sgi.com>
Subject: review: fix i386 build
Message-ID: <20070607064352.GN86004887@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


Don't use type-unsafe macros.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 fs/xfs/dmapi/xfs_dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6.x-xfs-new/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/dmapi/xfs_dm.c	2007-06-06 15:55:00.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/dmapi/xfs_dm.c	2007-06-06 15:56:00.613530262 +1000
@@ -2654,7 +2654,7 @@ xfs_dm_punch_hole(
 	 * make sure we punch the block and not just zero it.
 	 */
 	if (punch_to_eof)
-		len = roundup((realsize - off), bsize);
+		len = roundup_64((realsize - off), bsize);
 
 	xfs_iunlock(xip, XFS_ILOCK_EXCL);
 
