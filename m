Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 96EFC7F47
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 20:39:56 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 770CC304039
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 18:39:53 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	YPk3dZAAKdxns4y8 for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 18:39:50 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YQ5PY-0002cO-CG
	for xfs@oss.sgi.com; Tue, 24 Feb 2015 13:39:48 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YQ5PY-0004GU-B3
	for xfs@oss.sgi.com; Tue, 24 Feb 2015 13:39:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] mkfs: log stripe unit fails to influence default log size
Date: Tue, 24 Feb 2015 13:39:48 +1100
Message-Id: <1424745588-16361-1-git-send-email-david@fromorbit.com>
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

This fails:

# mkfs.xfs -f -l version=2,su=256k /dev/ram1
log size 2560 blocks too small, minimum size is 3264 blocks
....

We should be automatically calculating an appropriate, valid log
size when the user does not specify it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 66711cb..5e10c4e 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2441,9 +2441,11 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			 */
 			logblocks = (dblocks << blocklog) / 2048;
 			logblocks = logblocks >> blocklog;
-			logblocks = MAX(min_logblocks, logblocks);
 		}
 
+		/* Log size must exceed the minimum the geometry requires. */
+		logblocks = MAX(min_logblocks, logblocks);
+
 		/* make sure the log fits wholly within an AG */
 		if (logblocks >= agsize)
 			logblocks = min_logblocks;
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
