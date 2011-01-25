Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0P8ojXE224416 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 02:50:45 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4534D28DDA6
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 00:53:07 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	A7n64nVUjRBSOam6 for <xfs@oss.sgi.com>;
	Tue, 25 Jan 2011 00:53:07 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Phee9-0003xW-4N
	for xfs@oss.sgi.com; Tue, 25 Jan 2011 19:53:05 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Phebw-0007gb-Ss
	for xfs@oss.sgi.com; Tue, 25 Jan 2011 19:50:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/8] xfs: fix dquot shaker deadlock
Date: Tue, 25 Jan 2011 19:50:44 +1100
Message-Id: <1295945444-29488-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1295945444-29488-1-git-send-email-david@fromorbit.com>
References: <1295945444-29488-1-git-send-email-david@fromorbit.com>
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

Commit 368e136 ("xfs: remove duplicate code from dquot reclaim") fails
to unlock the dquot freelist when the number of loop restarts is
exceeded in xfs_qm_dqreclaim_one(). This causes hangs in memory
reclaim. Remove the bogus loop exit check that causes the problem.

Reported-by: Malcolm Scott <lkml@malc.org.uk>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/quota/xfs_qm.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/quota/xfs_qm.c b/fs/xfs/quota/xfs_qm.c
index f8e854b..9431c56 100644
--- a/fs/xfs/quota/xfs_qm.c
+++ b/fs/xfs/quota/xfs_qm.c
@@ -1992,8 +1992,6 @@ dqfunlock:
 		xfs_dqunlock(dqp);
 		if (dqpout)
 			break;
-		if (restarts >= XFS_QM_RECLAIM_MAX_RESTARTS)
-			return NULL;
 	}
 	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
 	return dqpout;
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
