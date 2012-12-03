Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3Nei5n067748 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:46 -0600
Message-Id: <20121203144311.750289577@sgi.com>
Date: Mon, 03 Dec 2012 17:42:40 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 32/36] xfs: really fix the cursor leak in
	xfs_alloc_ag_vextent_near
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=099
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
To: stable@vger.kernel.org
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Upstream commit: e3a746f5aab71f2dd0a83116772922fb37ae29d6

The current cursor is reallocated when retrying the allocation, so
the existing cursor needs to be destroyed in both the restart and
the failure cases.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Tested-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/fs/xfs/xfs_alloc.c
===================================================================
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -1080,13 +1080,13 @@ restart:
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


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
