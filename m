Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3130729E41
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 19:07:48 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 204BB30405F
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 17:07:48 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	tmPZz7VYvVC7h7HJ for <xfs@oss.sgi.com>;
	Tue, 05 Nov 2013 17:07:46 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vdrak-0003On-Ha
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vdrak-0008WK-H8
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 30/37] libxfs: work around do_div() not handling 32 bit
	numerators
Date: Wed,  6 Nov 2013 12:07:16 +1100
Message-Id: <1383700043-32305-31-git-send-email-david@fromorbit.com>
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

The libxfs dquot buffer code uses do_div() with a 32 bit numerator.
This gives incorrect results as do_div() passes the numerator by
reference as a pointer to a 64 bit value. Hence it does the division
using 32 bits of garbage gives the wrong result.

As per Christoph's suggestion, we can kill the usage of do_div()
here completely and just do the division directly, both in userspace
and kernel space.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
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
