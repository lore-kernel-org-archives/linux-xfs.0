Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E7B1E7F98
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 22:16:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D97BC8F8035
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 20:16:00 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	yPHOCwhHYpPyM7af for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 20:15:59 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQTxa-0006PW-BQ
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:46 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQTxa-0002H6-Ai
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 26/32] db: re-enable write support for v5 filesystems.
Date: Mon, 30 Sep 2013 13:15:38 +1000
Message-Id: <1380510944-8571-27-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510944-8571-1-git-send-email-david@fromorbit.com>
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
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
