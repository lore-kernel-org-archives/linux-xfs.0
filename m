Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7E60629E33
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 19:07:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 711D0304051
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 17:07:47 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ojcIQsdgDJRgzrFt for <xfs@oss.sgi.com>;
	Tue, 05 Nov 2013 17:07:46 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vdrak-0003Oj-Fq
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vdrak-0008W5-Es
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 27/37] db: re-enable write support for v5 filesystems.
Date: Wed,  6 Nov 2013 12:07:13 +1100
Message-Id: <1383700043-32305-28-git-send-email-david@fromorbit.com>
In-Reply-To: <1383700043-32305-1-git-send-email-david@fromorbit.com>
References: <1383700043-32305-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

As we can now verify and recalculate CRCs on IO, we can modify the
on-disk structures without corrupting the filesyste, This makes it
safe to turn write support on for v5 filesystems for the first time.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/init.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/db/init.c b/db/init.c
index 48b8dd1..838ea3c 100644
--- a/db/init.c
+++ b/db/init.c
@@ -143,21 +143,6 @@ init(
 			exit(EXIT_FAILURE);
 	}
 
-	/*
-	 * Don't allow modifications to CRC enabled filesystems until we support
-	 * CRC recalculation in the IO path. Unless, of course, the user is in
-	 * the process of hitting us with a big hammer.
-	 */
-	if (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_5 &&
-	    !(x.isreadonly & LIBXFS_ISREADONLY)) {
-		fprintf(stderr, 
-	_("%s: modifications to %s are not supported in thi version.\n"
-	"Use \"-r\" to run %s in read-only mode on this filesystem .\n"),
-			progname, fsdevice, progname);
-		if (!force)
-			exit(EXIT_FAILURE);
-	}
-
 	mp = libxfs_mount(&xmount, sbp, x.ddev, x.logdev, x.rtdev,
 			  LIBXFS_MOUNT_DEBUGGER);
 	if (!mp) {
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
