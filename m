Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8500E7FAE
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 00:41:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5B4C730406B
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 22:41:31 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	FAIwehTHY1W95NKs for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 22:41:29 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VgU8O-0005bf-42
	for xfs@oss.sgi.com; Wed, 13 Nov 2013 17:41:04 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VgU8O-0006iS-35
	for xfs@oss.sgi.com; Wed, 13 Nov 2013 17:41:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 14/36] xfs: don't emit corruption noise on fs probes
Date: Wed, 13 Nov 2013 17:40:38 +1100
Message-Id: <1384324860-25677-15-git-send-email-david@fromorbit.com>
In-Reply-To: <1384324860-25677-1-git-send-email-david@fromorbit.com>
References: <1384324860-25677-1-git-send-email-david@fromorbit.com>
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

If we get EWRONGFS due to probing of non-xfs filesystems,
there's no need to issue the scary corruption error and backtrace.

Ported from kernel commit 31625f28.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_sb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 11353bb..65ddc2f 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -574,8 +574,9 @@ xfs_sb_read_verify(
 
 out_error:
 	if (error) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
-				     mp, bp->b_addr);
+		if (error != EWRONGFS)
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
+					     mp, bp->b_addr);
 		xfs_buf_ioerror(bp, error);
 	}
 }
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
