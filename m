Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p376HjPc081021 for <xfs@oss.sgi.com>; Thu, 7 Apr 2011 01:17:45 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 659631E0653F
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 23:21:01 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	v9V4m1RJSx19AEcM for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2011 23:21:01 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Q7iaR-0006RT-N7
	for xfs@oss.sgi.com; Thu, 07 Apr 2011 16:20:59 +1000
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Q7iaU-0000hD-GU
	for xfs@oss.sgi.com; Thu, 07 Apr 2011 16:21:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix xfs_itruncate_start tracing
Date: Thu,  7 Apr 2011 16:21:02 +1000
Message-Id: <1302157262-2646-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Variables are ordered incorrectly in trace call.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 742c833..c785a55 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1354,7 +1354,7 @@ xfs_itruncate_start(
 		return 0;
 	}
 	last_byte = xfs_file_last_byte(ip);
-	trace_xfs_itruncate_start(ip, flags, new_size, toss_start, last_byte);
+	trace_xfs_itruncate_start(ip, new_size, flags, toss_start, last_byte);
 	if (last_byte > toss_start) {
 		if (flags & XFS_ITRUNC_DEFINITE) {
 			xfs_tosspages(ip, toss_start,
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
