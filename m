Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5C4KVpH178848 for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 23:20:31 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	CsnKJzk76hDmMGg6 for <xfs@oss.sgi.com>;
	Mon, 11 Jun 2012 21:20:30 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SeIag-0005Yh-Kg
	for xfs@oss.sgi.com; Tue, 12 Jun 2012 14:20:26 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SeIag-0002iW-Ge
	for xfs@oss.sgi.com; Tue, 12 Jun 2012 14:20:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix allocbt cursor leak in xfs_alloc_ag_vextent_near
Date: Tue, 12 Jun 2012 14:20:26 +1000
Message-Id: <1339474826-10414-1-git-send-email-david@fromorbit.com>
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

When we fail to find an matching extent near the requested extent
specification during a left-right distance search in
xfs_alloc_ag_vextent_near, we fail to free the original cursor that
we used to look up the XFS_BTNUM_CNT tree and hence leak it.

Reported-by: Chris J Arges <chris.j.arges@canonical.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_alloc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 229641f..70878aa 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -1080,6 +1080,7 @@ restart:
 			goto restart;
 		}
 
+		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 		trace_xfs_alloc_size_neither(args);
 		args->agbno = NULLAGBLOCK;
 		return 0;
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
