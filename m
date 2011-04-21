Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3L4PlOd132882 for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 23:25:47 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 258C83FE525
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 21:29:14 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	8rymLGWeZcaedMsh for <xfs@oss.sgi.com>;
	Wed, 20 Apr 2011 21:29:14 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1QClVp-000315-IW
	for xfs@oss.sgi.com; Thu, 21 Apr 2011 14:29:05 +1000
Received: from dave by disappointment with local (Exim 4.75)
	(envelope-from <dave@disappointment.disaster>) id 1QClVt-0002m9-0R
	for xfs@oss.sgi.com; Thu, 21 Apr 2011 14:29:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/4] xfs: fix xfs_itruncate_start tracing
Date: Thu, 21 Apr 2011 14:29:01 +1000
Message-Id: <1303360144-10632-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1303360144-10632-1-git-send-email-david@fromorbit.com>
References: <1303360144-10632-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a37480a..da46c0f 100644
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
1.7.4.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
