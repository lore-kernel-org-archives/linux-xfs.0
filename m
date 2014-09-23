Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7B61929DF9
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 14:29:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5A28C8F8039
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 12:29:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id s6N2I42zC6bWDsPz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Sep 2014 12:29:02 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s8NJT04E028479
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 15:29:01 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s8NJT0ri020635
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 15:29:00 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH] xfs: borrow indirect blocks from freed extent when
	available
Date: Tue, 23 Sep 2014 15:28:58 -0400
Message-Id: <1411500538-6831-1-git-send-email-bfoster@redhat.com>
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

xfs_bmap_del_extent() handles extent removal from the in-core and
on-disk extent lists. When removing a delalloc range, it updates the
indirect block reservation appropriately based on the removal. It
currently enforces that the new indirect block reservation is less than
or equal to the original. This is normally the case in all situations
except for when the removed range creates a hole in a single delalloc
extent, thus splitting a single delalloc extent in two.

The indirect block reservation is divided evenly between the two new
extents in this scenario. However, it is possible with small enough
extents to split an indlen==1 extent into two such slightly smaller
extents. This leaves one extent with 0 indirect blocks and leads to
assert failures in other areas (e.g., xfs_bunmapi() if the extent
happens to be removed).

Refactor xfs_bunmapi() to make the updates that must be consistent
against the inode (e.g., delalloc block counter, quota reservation)
right before the extent is deleted. Move the sb block counter update
after the extent is deleted and update xfs_bmap_del_extent() to steal
some blocks from the freed extent if a larger overall indirect
reservation is required by the extent removal.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi all,

I'm seeing the following assert more frequently with fsx and the recent
xfs_free_file_space() changes (at least on 1k fsb fs'):

XFS: Assertion failed: startblockval(del.br_startblock) > 0, file: fs/xfs/libxfs/xfs_bmap.c, line: 5281

This occurs for the reason described in the commit log description. This
is a quick experiment I wanted to test to verify the problem goes away
(so far, so good). Very lightly tested so far.

I'm not too fond of changing br_blockcount like this. It seems like a
potential landmine. Alternative approaches could be to kill the assert
if we think indlen==0 extents is not a huge problem in this scenario,
update the counters independently in xfs_bmap_del_extent() to get the
needed blocks or pass a separate output parameter rather than messing
with br_blockcount (e.g., '*ofreedblks'). The latter might mean we could
just move the entire hunk that updates the inode/quota and whatnot
rather than splitting it up.

I wanted to put this on the list for comments. Thoughts? Other ideas?
Thanks.

Brian

 fs/xfs/libxfs/xfs_bmap.c | 64 ++++++++++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 86df952..1858e6b 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4969,6 +4969,11 @@ xfs_bmap_del_extent(
 			temp2 = xfs_bmap_worst_indlen(ip, temp2);
 			new.br_startblock = nullstartblock((int)temp2);
 			da_new = temp + temp2;
+			/* pull blocks from extent to make up the difference */
+			while (da_new > da_old && del->br_blockcount) {
+				del->br_blockcount--;
+				da_new--;
+			}
 			while (da_new > da_old) {
 				if (temp) {
 					temp--;
@@ -5277,9 +5282,37 @@ xfs_bunmapi(
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
 
@@ -5291,8 +5324,6 @@ xfs_bunmapi(
 					ip, -((long)del.br_blockcount), 0,
 					XFS_QMOPT_RES_RTBLKS);
 			} else {
-				xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
-						(int64_t)del.br_blockcount, 0);
 				(void)xfs_trans_reserve_quota_nblks(NULL,
 					ip, -((long)del.br_blockcount), 0,
 					XFS_QMOPT_RES_REGBLKS);
@@ -5303,32 +5334,17 @@ xfs_bunmapi(
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
