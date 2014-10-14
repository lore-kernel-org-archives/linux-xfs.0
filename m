Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A92527F3F
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2014 16:59:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 993438F8035
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2014 14:59:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cqzj1zihQGIEQGAH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Oct 2014 14:59:18 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9ELxHr9022311
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Tue, 14 Oct 2014 17:59:18 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s9ELxHNE027025
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2014 17:59:17 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/2] xfs: update icsb freeblocks counter after extent deletion
Date: Tue, 14 Oct 2014 17:59:14 -0400
Message-Id: <1413323955-19976-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1413323955-19976-1-git-send-email-bfoster@redhat.com>
References: <1413323955-19976-1-git-send-email-bfoster@redhat.com>
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
 fs/xfs/libxfs/xfs_bmap.c | 59 ++++++++++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 79c9819..5abd22b 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5277,9 +5277,37 @@ xfs_bunmapi(
 				goto nodelete;
 			}
 		}
+
+		/*
+		 * If it's the case where the directory code is running
+		 * with no block reservation, and the deleted block is in
+		 * the middle of its extent, and the resulting insert
+		 * of an extent would cause transformation to btree format,
+		 * then reject it.  The calling code will then swap
+		 * blocks around instead.
+		 * We have to do this now, rather than waiting for the
+		 * conversion to btree format, since the transaction
+		 * will be dirty.
+		 */
+		if (!wasdel && xfs_trans_get_block_res(tp) == 0 &&
+		    XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
+		    XFS_IFORK_NEXTENTS(ip, whichfork) >= /* Note the >= */
+			XFS_IFORK_MAXEXT(ip, whichfork) &&
+		    del.br_startoff > got.br_startoff &&
+		    del.br_startoff + del.br_blockcount <
+		    got.br_startoff + got.br_blockcount) {
+			error = -ENOSPC;
+			goto error0;
+		}
+
+		/*
+		 * Unreserve quota and update realtime free space, if
+		 * appropriate. If delayed allocation, update the inode delalloc
+		 * counter now and wait to update the sb counters as
+		 * xfs_bmap_del_extent() might need to borrow some blocks.
+		 */
 		if (wasdel) {
 			ASSERT(startblockval(del.br_startblock) > 0);
-			/* Update realtime/data freespace, unreserve quota */
 			if (isrt) {
 				xfs_filblks_t rtexts;
 
@@ -5291,8 +5319,6 @@ xfs_bunmapi(
 					ip, -((long)del.br_blockcount), 0,
 					XFS_QMOPT_RES_RTBLKS);
 			} else {
-				xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
-						(int64_t)del.br_blockcount, 0);
 				(void)xfs_trans_reserve_quota_nblks(NULL,
 					ip, -((long)del.br_blockcount), 0,
 					XFS_QMOPT_RES_REGBLKS);
@@ -5303,32 +5329,17 @@ xfs_bunmapi(
 					XFS_BTCUR_BPRV_WASDEL;
 		} else if (cur)
 			cur->bc_private.b.flags &= ~XFS_BTCUR_BPRV_WASDEL;
-		/*
-		 * If it's the case where the directory code is running
-		 * with no block reservation, and the deleted block is in
-		 * the middle of its extent, and the resulting insert
-		 * of an extent would cause transformation to btree format,
-		 * then reject it.  The calling code will then swap
-		 * blocks around instead.
-		 * We have to do this now, rather than waiting for the
-		 * conversion to btree format, since the transaction
-		 * will be dirty.
-		 */
-		if (!wasdel && xfs_trans_get_block_res(tp) == 0 &&
-		    XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
-		    XFS_IFORK_NEXTENTS(ip, whichfork) >= /* Note the >= */
-			XFS_IFORK_MAXEXT(ip, whichfork) &&
-		    del.br_startoff > got.br_startoff &&
-		    del.br_startoff + del.br_blockcount <
-		    got.br_startoff + got.br_blockcount) {
-			error = -ENOSPC;
-			goto error0;
-		}
+
 		error = xfs_bmap_del_extent(ip, tp, &lastx, flist, cur, &del,
 				&tmp_logflags, whichfork);
 		logflags |= tmp_logflags;
 		if (error)
 			goto error0;
+
+		if (!isrt && wasdel)
+			xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
+				(int64_t) del.br_blockcount, 0);
+
 		bno = del.br_startoff - 1;
 nodelete:
 		/*
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
