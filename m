Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N53VEJ135127 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:31 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Amx0zGzdF8hO5QnZ for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:16 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PaK-0003GR-O7
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:00 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PaA-0003e2-LF
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 035/102] xfs: xfs_trans_add_item() - don't assign in ASSERT()
	when compare is intended
Date: Thu, 23 Aug 2012 15:01:53 +1000
Message-Id: <1345698180-13612-36-git-send-email-david@fromorbit.com>
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

From: Jesper Juhl <jj@chaosbits.net>

Upstream commit: f65020a83ad570c1788f7d8ece67f3487166576b

It looks to me like the two ASSERT()s in xfs_trans_add_item() really
want to do a compare (==) rather than assignment (=).
This patch changes it from the latter to the former.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Ben Myers <bpm@sgi.com>

(cherry picked from commit 05293485a0b6b1f803e8a3c0ff188c38f6969985)
---
 fs/xfs/xfs_trans.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index efc147f..9b4437d 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1151,8 +1151,8 @@ xfs_trans_add_item(
 {
 	struct xfs_log_item_desc *lidp;
 
-	ASSERT(lip->li_mountp = tp->t_mountp);
-	ASSERT(lip->li_ailp = tp->t_mountp->m_ail);
+	ASSERT(lip->li_mountp == tp->t_mountp);
+	ASSERT(lip->li_ailp == tp->t_mountp->m_ail);
 
 	lidp = kmem_zone_zalloc(xfs_log_item_desc_zone, KM_SLEEP | KM_NOFS);
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
