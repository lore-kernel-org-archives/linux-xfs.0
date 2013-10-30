Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 012377F51
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 23:31:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D2CC78F8059
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 21:31:33 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	hBmOtGR2502DJ3wo for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 21:31:32 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VbNRG-0002z4-1H
	for xfs@oss.sgi.com; Wed, 30 Oct 2013 15:31:26 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VbNRG-0007fY-0T
	for xfs@oss.sgi.com; Wed, 30 Oct 2013 15:31:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 27/30] libxfs: work around do_div() not handling 32 bit
	numerators
Date: Wed, 30 Oct 2013 15:31:18 +1100
Message-Id: <1383107481-28937-28-git-send-email-david@fromorbit.com>
In-Reply-To: <1383107481-28937-1-git-send-email-david@fromorbit.com>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
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
using 32 bits of garbage gives the wrong result. The kernel code
handles 32 bit numerators just fine, so this patch is a temporary
workaround in the dquot buffer code until we fix do_div() to handle
32 bit numerators correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_dquot_buf.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index 620d9d3..ce6b09c 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -18,18 +18,28 @@
  */
 #include "xfs.h"
 
+/*
+ * XXX: the userspace implementation of the do_div() macro does not handle 32
+ * bit numerators properly as it passes it by reference as a pointer to a 64 bit
+ * variable and dereferences it as such. Hence the result is way, way off
+ * because it uses 32 bits of garbage for the upper 32 bits of the numerator.
+ *
+ * This is being left here as a reminder that we need to fix do_div() in
+ * userspace as every time we do a libxfs kernel/userspace diff we'll see this
+ * comment.
+ */
 int
 xfs_calc_dquots_per_chunk(
 	struct xfs_mount	*mp,
 	unsigned int		nbblks)	/* basic block units */
 {
-	unsigned int	ndquots;
+	uint64_t	ndquots;
 
 	ASSERT(nbblks > 0);
 	ndquots = BBTOB(nbblks);
 	do_div(ndquots, sizeof(xfs_dqblk_t));
 
-	return ndquots;
+	return (int)ndquots;
 }
 
 /*
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
