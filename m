Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 096D229E05
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 08:29:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CFD06304043
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 06:29:36 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VYFz5MDD9AlNtx6i (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Feb 2016 06:29:32 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 1AE91804E2
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 14:29:32 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-22.bos.redhat.com [10.18.41.22])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u1TETVdK001951
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 09:29:31 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/3] xfs: update icsb freeblocks counter after extent deletion
Date: Mon, 29 Feb 2016 09:29:29 -0500
Message-Id: <1456756170-51248-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1456756170-51248-1-git-send-email-bfoster@redhat.com>
References: <1456756170-51248-1-git-send-email-bfoster@redhat.com>
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

xfs_bunmapi() currently updates the icsb fdblocks counter, unreserves
quota, etc. before the extent is deleted by xfs_bmap_del_extent(). The
function has problems dividing up the indirect reserved blocks for
scenarios where a single delalloc extent is split in two. Particularly,
there aren't always enough blocks reserved for multiple extents in a
single extent reservation.

The solution to this problem is to allow the extent removal code to
steal from the deleted extent to meet indirect reservation requirements.
Move the block of code in xfs_bmapi() that updates the icsb fdblocks
counter to after the call to xfs_bmap_del_extent() to allow the codepath
to update the extent record before the free blocks are accounted. Also,
reshuffle the code slightly so the delalloc accounting occurs near the
xfs_bmap_del_extent() call to provide context for the comments.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 58 ++++++++++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6a05166..7180104 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5296,31 +5296,7 @@ xfs_bunmapi(
 				goto nodelete;
 			}
 		}
-		if (wasdel) {
-			ASSERT(startblockval(del.br_startblock) > 0);
-			/* Update realtime/data freespace, unreserve quota */
-			if (isrt) {
-				xfs_filblks_t rtexts;
 
-				rtexts = XFS_FSB_TO_B(mp, del.br_blockcount);
-				do_div(rtexts, mp->m_sb.sb_rextsize);
-				xfs_mod_frextents(mp, (int64_t)rtexts);
-				(void)xfs_trans_reserve_quota_nblks(NULL,
-					ip, -((long)del.br_blockcount), 0,
-					XFS_QMOPT_RES_RTBLKS);
-			} else {
-				xfs_mod_fdblocks(mp, (int64_t)del.br_blockcount,
-						 false);
-				(void)xfs_trans_reserve_quota_nblks(NULL,
-					ip, -((long)del.br_blockcount), 0,
-					XFS_QMOPT_RES_REGBLKS);
-			}
-			ip->i_delayed_blks -= del.br_blockcount;
-			if (cur)
-				cur->bc_private.b.flags |=
-					XFS_BTCUR_BPRV_WASDEL;
-		} else if (cur)
-			cur->bc_private.b.flags &= ~XFS_BTCUR_BPRV_WASDEL;
 		/*
 		 * If it's the case where the directory code is running
 		 * with no block reservation, and the deleted block is in
@@ -5342,11 +5318,45 @@ xfs_bunmapi(
 			error = -ENOSPC;
 			goto error0;
 		}
+
+		/*
+		 * Unreserve quota and update realtime free space, if
+		 * appropriate. If delayed allocation, update the inode delalloc
+		 * counter now and wait to update the sb counters as
+		 * xfs_bmap_del_extent() might need to borrow some blocks.
+		 */
+		if (wasdel) {
+			ASSERT(startblockval(del.br_startblock) > 0);
+			if (isrt) {
+				xfs_filblks_t rtexts;
+
+				rtexts = XFS_FSB_TO_B(mp, del.br_blockcount);
+				do_div(rtexts, mp->m_sb.sb_rextsize);
+				xfs_mod_frextents(mp, (int64_t)rtexts);
+				(void)xfs_trans_reserve_quota_nblks(NULL,
+					ip, -((long)del.br_blockcount), 0,
+					XFS_QMOPT_RES_RTBLKS);
+			} else {
+				(void)xfs_trans_reserve_quota_nblks(NULL,
+					ip, -((long)del.br_blockcount), 0,
+					XFS_QMOPT_RES_REGBLKS);
+			}
+			ip->i_delayed_blks -= del.br_blockcount;
+			if (cur)
+				cur->bc_private.b.flags |=
+					XFS_BTCUR_BPRV_WASDEL;
+		} else if (cur)
+			cur->bc_private.b.flags &= ~XFS_BTCUR_BPRV_WASDEL;
+
 		error = xfs_bmap_del_extent(ip, tp, &lastx, flist, cur, &del,
 				&tmp_logflags, whichfork);
 		logflags |= tmp_logflags;
 		if (error)
 			goto error0;
+
+		if (!isrt && wasdel)
+			xfs_mod_fdblocks(mp, (int64_t)del.br_blockcount, false);
+
 		bno = del.br_startoff - 1;
 nodelete:
 		/*
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
