Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7C3CF7F9C
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 22:15:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 65687304053
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 20:15:56 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	sD6ZLwyG7ziNoqgq for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 20:15:55 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQTxa-0006Pf-DL
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:46 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQTxa-0002HL-CW
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 29/32] libxfs: work around do_div() not handling 32 bit
	numerators
Date: Mon, 30 Sep 2013 13:15:41 +1000
Message-Id: <1380510944-8571-30-git-send-email-david@fromorbit.com>
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
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
