Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3959D7FB2
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 00:41:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BFEE5AC003
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 22:41:25 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	srvFnpWhaEhGxhUa for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 22:41:24 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VgU8O-0005c9-EQ
	for xfs@oss.sgi.com; Wed, 13 Nov 2013 17:41:04 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VgU8O-0006jk-D7
	for xfs@oss.sgi.com; Wed, 13 Nov 2013 17:41:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 30/36] libxfs: work around do_div() not handling 32 bit
	numerators
Date: Wed, 13 Nov 2013 17:40:54 +1100
Message-Id: <1384324860-25677-31-git-send-email-david@fromorbit.com>
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

The libxfs dquot buffer code uses do_div() with a 32 bit numerator.
This gives incorrect results as do_div() passes the numerator by
reference as a pointer to a 64 bit value. Hence it does the division
using 32 bits of garbage gives the wrong result.

As per Christoph's suggestion, we can kill the usage of do_div()
here completely and just do the division directly, both in userspace
and kernel space.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_dquot_buf.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index 620d9d3..6bbb0ff 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -23,13 +23,8 @@ xfs_calc_dquots_per_chunk(
 	struct xfs_mount	*mp,
 	unsigned int		nbblks)	/* basic block units */
 {
-	unsigned int	ndquots;
-
 	ASSERT(nbblks > 0);
-	ndquots = BBTOB(nbblks);
-	do_div(ndquots, sizeof(xfs_dqblk_t));
-
-	return ndquots;
+	return BBTOB(nbblks) / sizeof(xfs_dqblk_t);
 }
 
 /*
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
