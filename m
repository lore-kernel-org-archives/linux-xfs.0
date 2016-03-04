Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E8A0F7CA2
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 08:40:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B94AD8F8035
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 06:40:34 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Lvi6lDJeSOfuFqAE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2016 06:40:33 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id E2FF032E890
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 14:40:32 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-186.bos.redhat.com [10.18.41.186])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u24EeWvO012671
	for <xfs@oss.sgi.com>; Fri, 4 Mar 2016 09:40:32 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 4/4] xfs: borrow indirect blocks from freed extent when
	available
Date: Fri,  4 Mar 2016 09:40:31 -0500
Message-Id: <1457102431-5215-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1457102431-5215-1-git-send-email-bfoster@redhat.com>
References: <1457102431-5215-1-git-send-email-bfoster@redhat.com>
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
except for in certain cases when the removed range creates a hole in a
single delalloc extent, thus splitting a single delalloc extent in two.

It is possible with small enough extents to split an indlen==1 extent
into two such slightly smaller extents. This leaves one extent with 0
indirect blocks and leads to assert failures in other areas (e.g.,
xfs_bunmapi() if the extent happens to be removed).

Update the indlen distribution code to steal blocks from the deleted
extent, if necessary, to satisfy the worst case total indirect
reservation for the new extents. This is safe as the caller does not
update the fdblocks counters until the extent is removed. Blocks stolen
in this manner simply remain accounted as allocated, having ownership
transferred from the data extent to an indirect reservation.

As a precaution, fall back to the original reservation algorithm if the
new indlen requirement is not met and warn if we end up with extents
without any reservation at all to detect this more easily in the future.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 46 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 27e6689..2c3080f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4727,26 +4727,43 @@ error0:
  *
  * Given the original reservation and the worst case indlen for the two new
  * extents (as calculated by xfs_bmap_worst_indlen()), split the original
- * reservation fairly across the two new extents.
+ * reservation fairly across the two new extents. If necessary, steal available
+ * blocks from a deleted extent to make up a reservation deficiency (e.g., if
+ * ores == 1). The number of stolen blocks is returned. The availability and
+ * subsequent accounting of stolen blocks is the responsibility of the caller.
  */
-static void
+static xfs_filblks_t
 xfs_bmap_split_indlen(
 	xfs_filblks_t			ores,		/* original res. */
 	xfs_filblks_t			*indlen1,	/* ext1 worst indlen */
-	xfs_filblks_t			*indlen2)	/* ext2 worst indlen */
+	xfs_filblks_t			*indlen2,	/* ext2 worst indlen */
+	xfs_filblks_t			avail)		/* stealable blocks */
 {
 	xfs_filblks_t			nres;		/* new total res. */
 	xfs_filblks_t			temp;
 	xfs_filblks_t			temp2;
+	xfs_filblks_t			stolen = 0;
 
 	temp = *indlen1;
 	temp2 = *indlen2;
 	nres = temp + temp2;
 
 	/*
-	 * The only blocks available are those reserved for the original extent.
-	 * Therefore, we have to skim blocks off each of the new reservations so
-	 * long as the new total reservation is greater than the original.
+	 * Steal as many blocks as we can to try and satisfy the worst case
+	 * indlen for both new extents.
+	 */
+	while (nres > ores && avail) {
+		nres--;
+		avail--;
+		stolen++;
+	}
+
+	/*
+	 * The only blocks available are those reserved for the original
+	 * extent and what we can steal from the extent being removed.
+	 * If this still isn't enough to satisfy the combined
+	 * requirements for the two new extents, skim blocks off of each
+	 * of the new reservations until they match what is available.
 	 */
 	while (nres > ores) {
 		if (temp) {
@@ -4763,6 +4780,8 @@ xfs_bmap_split_indlen(
 
 	*indlen1 = temp;
 	*indlen2 = temp2;
+
+	return stolen;
 }
 
 /*
@@ -5029,20 +5048,27 @@ xfs_bmap_del_extent(
 			XFS_IFORK_NEXT_SET(ip, whichfork,
 				XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
 		} else {
+			xfs_filblks_t	stolen;
 			ASSERT(whichfork == XFS_DATA_FORK);
 
 			/*
 			 * Distribute the original indlen reservation across the
-			 * two new extents.
+			 * two new extents. Steal blocks from the deleted extent
+			 * if necessary. Stealing blocks simply fudges the
+			 * fdblocks accounting in xfs_bunmapi().
 			 */
 			temp = xfs_bmap_worst_indlen(ip, got.br_blockcount);
 			temp2 = xfs_bmap_worst_indlen(ip, new.br_blockcount);
-			xfs_bmap_split_indlen(da_old, &temp, &temp2);
-			da_new = temp + temp2;
+			stolen = xfs_bmap_split_indlen(da_old, &temp, &temp2,
+						       del->br_blockcount);
+			da_new = temp + temp2 - stolen;
+			del->br_blockcount -= stolen;
 
 			/*
-			 * Set the reservation for each extent.
+			 * Set the reservation for each extent. Warn if either
+			 * is zero as this can lead to delalloc problems.
 			 */
+			WARN_ON_ONCE(!temp || !temp2);
 			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
 			new.br_startblock = nullstartblock((int)temp2);
 		}
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
