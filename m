Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C989C29E05
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 08:29:34 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3164DAC007
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 06:29:33 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id H2p3cAeybv7lMtXa (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Feb 2016 06:29:32 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 1F024C0B78A5
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 14:29:32 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-22.bos.redhat.com [10.18.41.22])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u1TETVEq019294
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 09:29:31 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/3] xfs: borrow indirect blocks from freed extent when
	available
Date: Mon, 29 Feb 2016 09:29:30 -0500
Message-Id: <1456756170-51248-4-git-send-email-bfoster@redhat.com>
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

Refactor the indirect reservation code into a new helper function
invoked by xfs_bunmapi(). Allow the helper to steal blocks from the
deleted extent if necessary to satisfy the worst case indirect
reservation of the new extents. This is safe now that the caller does
not update icsb counters until the extent is removed (such stolen blocks
simply remain accounted as allocated). Fall back to the original
reservation using the existing algorithm and warn if we end up with
extents without any reservation at all to detect this more easily in the
future.

This allows generic/033 to run on XFS without assert failures.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 100 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 81 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7180104..79688a6 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4721,6 +4721,68 @@ error0:
 }
 
 /*
+ * When a delalloc extent is split (e.g., due to a hole punch), the original
+ * indlen reservation must be shared across the two new extents that are left
+ * behind.
+ *
+ * Provided the worst case indlen for two extents, limit the total reservation
+ * against that of the original extent. We may want to steal blocks from any
+ * extra that might be available according to the caller to make up a deficiency
+ * (e.g., if the original reservation consists of one block). The number of such
+ * stolen blocks is returned. The availability and accounting of stealable
+ * blocks is the responsibility of the caller.
+ */
+static xfs_filblks_t
+xfs_bmap_limit_indlen(
+	xfs_filblks_t			ores,		/* original res. */
+	xfs_filblks_t			*indlen1,	/* ext1 worst indlen */
+	xfs_filblks_t			*indlen2,	/* ext2 worst indlen */
+	xfs_filblks_t			avail)		/* stealable blocks */
+{
+	xfs_filblks_t			nres;		/* new total res. */
+	xfs_filblks_t			temp;
+	xfs_filblks_t			temp2;
+	xfs_filblks_t			stolen = 0;
+
+	temp = *indlen1;
+	temp2 = *indlen2;
+	nres = temp + temp2;
+
+	/*
+	 * Steal as many blocks as we can to try and satisfy the worst case
+	 * indlen of both new extents.
+	 */
+	while (nres > ores && avail) {
+		nres--;
+		avail--;
+		stolen++;
+	}
+
+	/*
+	 * If we've exhausted stealable blocks and still haven't satisfied the
+	 * worst case reservation, we have no choice but to pare back until
+	 * covered by the original reservation.
+	 */
+	while (nres > ores) {
+		if (temp) {
+			temp--;
+			nres--;
+		}
+		if (nres == ores)
+			break;
+		if (temp2) {
+			temp2--;
+			nres--;
+		}
+	}
+
+	*indlen1 = temp;
+	*indlen2 = temp2;
+
+	return stolen;
+}
+
+/*
  * Called by xfs_bmapi to update file extent records and the btree
  * after removing space (or undoing a delayed allocation).
  */
@@ -4984,28 +5046,28 @@ xfs_bmap_del_extent(
 			XFS_IFORK_NEXT_SET(ip, whichfork,
 				XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
 		} else {
+			xfs_filblks_t	stolen;
 			ASSERT(whichfork == XFS_DATA_FORK);
-			temp = xfs_bmap_worst_indlen(ip, temp);
+
+			/*
+			 * Fix up the indlen reservations. We can safely steal
+			 * blocks from the deleted extent as this simply fudges
+			 * the icsb fdblocks accounting in xfs_bunmapi().
+			 */
+			temp = xfs_bmap_worst_indlen(ip, got.br_blockcount);
+			temp2 = xfs_bmap_worst_indlen(ip, new.br_blockcount);
+			stolen = xfs_bmap_limit_indlen(da_old, &temp, &temp2,
+						       del->br_blockcount);
+			da_new = temp + temp2 - stolen;
+			del->br_blockcount -= stolen;
+
+			/*
+			 * Set the reservation for each extent. Warn if either
+			 * is zero as this can lead to delalloc problems.
+			 */
+			WARN_ON_ONCE(!temp || !temp2);
 			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
-			temp2 = xfs_bmap_worst_indlen(ip, temp2);
 			new.br_startblock = nullstartblock((int)temp2);
-			da_new = temp + temp2;
-			while (da_new > da_old) {
-				if (temp) {
-					temp--;
-					da_new--;
-					xfs_bmbt_set_startblock(ep,
-						nullstartblock((int)temp));
-				}
-				if (da_new == da_old)
-					break;
-				if (temp2) {
-					temp2--;
-					da_new--;
-					new.br_startblock =
-						nullstartblock((int)temp2);
-				}
-			}
 		}
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 		xfs_iext_insert(ip, *idx + 1, 1, &new, state);
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
