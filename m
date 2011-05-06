Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p462otX3173116 for <xfs@oss.sgi.com>; Thu, 5 May 2011 21:50:55 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 93A271E1F008
	for <xfs@oss.sgi.com>; Thu,  5 May 2011 19:54:33 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	H0KhYoEHbvIDFlNq for <xfs@oss.sgi.com>;
	Thu, 05 May 2011 19:54:33 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1QIBBV-00017z-Qs
	for xfs@oss.sgi.com; Fri, 06 May 2011 12:54:29 +1000
Received: from dave by disappointment with local (Exim 4.75)
	(envelope-from <dave@disappointment.disaster>) id 1QIBBO-0007PR-ME
	for xfs@oss.sgi.com; Fri, 06 May 2011 12:54:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/5] xfs: always push the AIL to the target
Date: Fri,  6 May 2011 12:54:06 +1000
Message-Id: <1304650448-28438-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1304650448-28438-1-git-send-email-david@fromorbit.com>
References: <1304650448-28438-1-git-send-email-david@fromorbit.com>
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

The recent conversion of the xfsaild functionality to a work queue
introduced a hard-to-hit log space grant hang. One of the problems
discovered is a target mismatch between the item pushing loop and
the target itself.

The push trigger checks for the target increasing (i.e. new target >
current) while the push loop only pushes items that have a LSN <
current. As a result, we can get the situation where the push target
is X, the items at the tail of the AIL have LSN X and they don't get
pushed. The push work then completes thinking it is done, and cannot
be restarted until the push target increases to >= X + 1. If the
push target then never increases (because the tail is not moving),
then we never run the push work again and we stall.

Fix it by making sure log items with a LSN that matches the target
exactly are pushed during the loop.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans_ail.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 226c58b..9f427c2 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -387,7 +387,7 @@ xfs_ail_worker(
 	 * lots of contention on the AIL lists.
 	 */
 	lsn = lip->li_lsn;
-	while ((XFS_LSN_CMP(lip->li_lsn, target) < 0)) {
+	while ((XFS_LSN_CMP(lip->li_lsn, target) <= 0)) {
 		int	lock_result;
 		/*
 		 * If we can lock the item without sleeping, unlock the AIL
-- 
1.7.4.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
