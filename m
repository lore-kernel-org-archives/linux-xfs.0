Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B4C0B7F63
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 05:12:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A26918F8068
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 03:12:53 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	slOwUeTaR3w9Sm8H for <xfs@oss.sgi.com>;
	Fri, 21 Mar 2014 03:12:51 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/6] xfs: splitting delalloc extents can run out of reservation
Date: Fri, 21 Mar 2014 21:11:49 +1100
Message-Id: <1395396710-3824-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1395396710-3824-1-git-send-email-david@fromorbit.com>
References: <1395396710-3824-1-git-send-email-david@fromorbit.com>
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
Cc: Viro@disappointment.disaster, viro@ZenIV.linux.org.uk, Al@disappointment.disaster

From: Dave Chinner <dchinner@redhat.com>

When we punch a hole in a delalloc extent, we split the indirect
block reservation between the two new extents. If we repeatedly
punch holes in a large delalloc extent, that reservation will
eventually run out and we'll assert fail in xfs_bunmapi() because
the indirect block reservation for the delalloc extent is zero. This
is caused by doing a large delalloc write, then zeroing multiple
ranges of that write using fallocate to punch lots of holes in the
delayed allocation range.

To avoid this problem, if we split the reservation and require more
indirect blocks for the two new extents than we had for the old
reservation, steal the additional blocks from the hole we punched in
the extent. In most cases we only need a single extra block, so even
if we punch only single block holes we can still retain sufficient
indirect block reservations to avoid problems.

In doing this "stealing", we need to change where we account for the
delalloc blocks being freed. The block count held on the inode does
not take into account the indirect block reservation, so we still
need to do that before we free the extent. However, the accounting
ofr free space in the superblock need to be done after we've stolen
the blocks fro the freed extent so that they are accounted for
correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap.c | 65 ++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 47 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 5b6092e..4bf6a0e 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -4945,7 +4945,27 @@ xfs_bmap_del_extent(
 			temp2 = xfs_bmap_worst_indlen(ip, temp2);
 			new.br_startblock = nullstartblock((int)temp2);
 			da_new = temp + temp2;
+
+			/*
+			 * Note: if we have an odd number of blocks reserved,
+			 * then if we keep splitting the delalloc extent like
+			 * this we end up with a delalloc indlen reservation of
+			 * zero for one of the two extents. Hence if we end
+			 * up with the new indlen reservations being larger than
+			 * the old one, steal blocks from the data reservation
+			 * we just punched out. Otherwise, just reduce the
+			 * remaining indlen reservations alternately and hope
+			 * next time we come here the range getting removed is
+			 * large enough to fix this all up.
+			 */
 			while (da_new > da_old) {
+				if (del->br_blockcount) {
+					/* steal a block */
+					da_new--;
+					del->br_blockcount--;
+					continue;
+				}
+
 				if (temp) {
 					temp--;
 					da_new--;
@@ -5255,24 +5275,6 @@ xfs_bunmapi(
 		}
 		if (wasdel) {
 			ASSERT(startblockval(del.br_startblock) > 0);
-			/* Update realtime/data freespace, unreserve quota */
-			if (isrt) {
-				xfs_filblks_t rtexts;
-
-				rtexts = XFS_FSB_TO_B(mp, del.br_blockcount);
-				do_div(rtexts, mp->m_sb.sb_rextsize);
-				xfs_mod_incore_sb(mp, XFS_SBS_FREXTENTS,
-						(int64_t)rtexts, 0);
-				(void)xfs_trans_reserve_quota_nblks(NULL,
-					ip, -((long)del.br_blockcount), 0,
-					XFS_QMOPT_RES_RTBLKS);
-			} else {
-				xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
-						(int64_t)del.br_blockcount, 0);
-				(void)xfs_trans_reserve_quota_nblks(NULL,
-					ip, -((long)del.br_blockcount), 0,
-					XFS_QMOPT_RES_REGBLKS);
-			}
 			ip->i_delayed_blks -= del.br_blockcount;
 			if (cur)
 				cur->bc_private.b.flags |=
@@ -5302,6 +5304,33 @@ xfs_bunmapi(
 		}
 		error = xfs_bmap_del_extent(ip, tp, &lastx, flist, cur, &del,
 				&tmp_logflags, whichfork);
+		/*
+		 * xfs_bmap_del_extent may hand delayed alloc blocks back to the
+		 * indirect block reservations to keep extent split reservations
+		 * sane. Hence we should only decrement the delayed block count
+		 * on the inode once we know exactly the amount of delalloc
+		 * space we actually removed from the inode.
+		 */
+		if (wasdel && del.br_blockcount) {
+			/* Update realtime/data freespace, unreserve quota */
+			if (isrt) {
+				xfs_filblks_t rtexts;
+
+				rtexts = XFS_FSB_TO_B(mp, del.br_blockcount);
+				do_div(rtexts, mp->m_sb.sb_rextsize);
+				xfs_mod_incore_sb(mp, XFS_SBS_FREXTENTS,
+						(int64_t)rtexts, 0);
+				(void)xfs_trans_reserve_quota_nblks(NULL,
+					ip, -((long)del.br_blockcount), 0,
+					XFS_QMOPT_RES_RTBLKS);
+			} else {
+				xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
+						(int64_t)del.br_blockcount, 0);
+				(void)xfs_trans_reserve_quota_nblks(NULL,
+					ip, -((long)del.br_blockcount), 0,
+					XFS_QMOPT_RES_REGBLKS);
+			}
+		}
 		logflags |= tmp_logflags;
 		if (error)
 			goto error0;
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
