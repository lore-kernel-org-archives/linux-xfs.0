Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N52uia134861 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:02:56 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	O0TgEQVr0E3rTTXO for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:41 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PZv-0003FH-9d
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:35 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PZq-0003cs-6W
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 021/102] xfs: fix force shutdown handling in xfs_end_io
Date: Thu, 23 Aug 2012 15:01:39 +1000
Message-Id: <1345698180-13612-22-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

Upstream commit: 810627d9a6d0e8820c798001875bc4e1b7754ebf

Ensure ioend->io_error gets propagated back to e.g. AIO completions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 4ff2404..2426ecd 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -222,7 +222,7 @@ xfs_end_io(
 	int		error = 0;
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-		error = -EIO;
+		ioend->io_error = -EIO;
 		goto done;
 	}
 	if (ioend->io_error)
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
