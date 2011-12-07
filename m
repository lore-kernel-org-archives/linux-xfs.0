Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB76Isv9046626 for <xfs@oss.sgi.com>; Wed, 7 Dec 2011 00:18:54 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D51E61F46686
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 22:18:52 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Yl0hY1qpqASKOPUp for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 22:18:52 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1RYAq0-0003nz-9M
	for xfs@oss.sgi.com; Wed, 07 Dec 2011 17:18:40 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1RYApz-0003Um-Kn
	for xfs@oss.sgi.com; Wed, 07 Dec 2011 17:18:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/12] xfs: convert xfs_da_do_buf to use irec buffer interface
Date: Wed,  7 Dec 2011 17:18:17 +1100
Message-Id: <1323238703-13198-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1323238703-13198-1-git-send-email-david@fromorbit.com>
References: <1323238703-13198-1-git-send-email-david@fromorbit.com>
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

Convert xfs_da_do_buf to use ithe new irec buffer interface. This is
just a simple 1:1 conversion as the irec interface only support
single maps at this point in time.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_da_btree.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 77c7425..4f2370b 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -2025,22 +2025,24 @@ xfs_da_do_buf(
 
 		mappedbno = XFS_FSB_TO_DADDR(mp, mapp[i].br_startblock);
 		if (i == 0)
-			*mappedbnop = mappedbno;
+			*mappedbnop = XFS_FSB_TO_DADDR(mp,
+						       mapp[i].br_startblock);
 		nmapped = (int)XFS_FSB_TO_BB(mp, mapp[i].br_blockcount);
 		switch (caller) {
 		case 0:
-			bp = xfs_trans_get_buf(trans, mp->m_ddev_targp,
-				mappedbno, nmapped, 0);
+			bp = xfs_trans_get_buf_irec(trans, mp->m_ddev_targp,
+						    &mapp[i], 1, 0);
 			error = bp ? bp->b_error : XFS_ERROR(EIO);
 			break;
 		case 1:
 		case 2:
 			bp = NULL;
-			error = xfs_trans_read_buf(mp, trans, mp->m_ddev_targp,
-				mappedbno, nmapped, 0, &bp);
+			error = xfs_trans_read_buf_irec(mp, trans,
+						mp->m_ddev_targp, &mapp[i], 1,
+						0, &bp);
 			break;
 		case 3:
-			xfs_buf_readahead(mp->m_ddev_targp, mappedbno, nmapped);
+			xfs_buf_readahead_irec(mp->m_ddev_targp, &mapp[i], 1);
 			error = 0;
 			bp = NULL;
 			break;
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
