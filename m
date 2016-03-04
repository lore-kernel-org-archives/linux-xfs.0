Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E01EF7CA1
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 08:40:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A26F68F8033
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 06:40:37 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FBKdydNiT036UBsm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2016 06:40:33 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id CAC6329B37D
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 14:40:32 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-186.bos.redhat.com [10.18.41.186])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u24EeW8I031470
	for <xfs@oss.sgi.com>; Fri, 4 Mar 2016 09:40:32 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/4] xfs: refactor delalloc indlen reservation split into
	helper
Date: Fri,  4 Mar 2016 09:40:30 -0500
Message-Id: <1457102431-5215-4-git-send-email-bfoster@redhat.com>
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

The delayed allocation indirect reservation splitting code is not
sufficient in some cases where a delalloc extent is split in two. In
preparation for enhancements to this code, refactor the current indlen
distribution algorithm into a new helper function.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 77 ++++++++++++++++++++++++++++++++++++------------
 1 file changed, 58 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f57a9e9..27e6689 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4721,6 +4721,51 @@ error0:
 }
 
 /*
+ * When a delalloc extent is split (e.g., due to a hole punch), the original
+ * indlen reservation must be shared across the two new extents that are left
+ * behind.
+ *
+ * Given the original reservation and the worst case indlen for the two new
+ * extents (as calculated by xfs_bmap_worst_indlen()), split the original
+ * reservation fairly across the two new extents.
+ */
+static void
+xfs_bmap_split_indlen(
+	xfs_filblks_t			ores,		/* original res. */
+	xfs_filblks_t			*indlen1,	/* ext1 worst indlen */
+	xfs_filblks_t			*indlen2)	/* ext2 worst indlen */
+{
+	xfs_filblks_t			nres;		/* new total res. */
+	xfs_filblks_t			temp;
+	xfs_filblks_t			temp2;
+
+	temp = *indlen1;
+	temp2 = *indlen2;
+	nres = temp + temp2;
+
+	/*
+	 * The only blocks available are those reserved for the original extent.
+	 * Therefore, we have to skim blocks off each of the new reservations so
+	 * long as the new total reservation is greater than the original.
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
+}
+
+/*
  * Called by xfs_bmapi to update file extent records and the btree
  * after removing space (or undoing a delayed allocation).
  */
@@ -4985,27 +5030,21 @@ xfs_bmap_del_extent(
 				XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
 		} else {
 			ASSERT(whichfork == XFS_DATA_FORK);
-			temp = xfs_bmap_worst_indlen(ip, temp);
+
+			/*
+			 * Distribute the original indlen reservation across the
+			 * two new extents.
+			 */
+			temp = xfs_bmap_worst_indlen(ip, got.br_blockcount);
+			temp2 = xfs_bmap_worst_indlen(ip, new.br_blockcount);
+			xfs_bmap_split_indlen(da_old, &temp, &temp2);
+			da_new = temp + temp2;
+
+			/*
+			 * Set the reservation for each extent.
+			 */
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
