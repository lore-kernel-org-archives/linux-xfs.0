Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B3B2B7F53
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 07:13:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 945AA304053
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 05:13:47 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	PhiEilpxOnSBo54S for <xfs@oss.sgi.com>;
	Thu, 05 Sep 2013 05:13:46 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VHYRM-0001GZ-QT
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 22:13:36 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VHYRM-0004F1-PE
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 22:13:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC PATCH 12/12] db: re-enable write support for v5 filesystems.
Date: Thu,  5 Sep 2013 22:13:33 +1000
Message-Id: <1378383213-16155-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1378383213-16155-1-git-send-email-david@fromorbit.com>
References: <1378383213-16155-1-git-send-email-david@fromorbit.com>
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
---
 db/init.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/db/init.c b/db/init.c
index b1cddca..a9b357b 100644
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
 				LIBXFS_MOUNT_ROOTINOS | LIBXFS_MOUNT_DEBUGGER);
 	if (!mp) {
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
