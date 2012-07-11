Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6BLexHm241009 for <xfs@oss.sgi.com>; Wed, 11 Jul 2012 16:40:59 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	TGBEfeV90jho8csz for <xfs@oss.sgi.com>;
	Wed, 11 Jul 2012 14:40:57 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: really fix the cursor leak in
	xfs_alloc_ag_vextent_near
Date: Thu, 12 Jul 2012 07:40:42 +1000
Message-Id: <1342042843-1773-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1342042843-1773-1-git-send-email-david@fromorbit.com>
References: <1342042843-1773-1-git-send-email-david@fromorbit.com>
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
Cc: bpm@sgi.com

From: Dave Chinner <dchinner@redhat.com>

The current cursor is reallocated when retrying the allocation, so
the existing cursor needs to be destroyed in both the restart and
the failure cases.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Tested-by: Mike Snitzer <snitzer@redhat.com>
---
 fs/xfs/xfs_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 9d1aeb7..f654f51 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -1074,13 +1074,13 @@ restart:
 	 * If we couldn't get anything, give up.
 	 */
 	if (bno_cur_lt == NULL && bno_cur_gt == NULL) {
+		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
+
 		if (!forced++) {
 			trace_xfs_alloc_near_busy(args);
 			xfs_log_force(args->mp, XFS_LOG_SYNC);
 			goto restart;
 		}
-
-		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 		trace_xfs_alloc_size_neither(args);
 		args->agbno = NULLAGBLOCK;
 		return 0;
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
