Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8E34B7F66
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 13:42:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6DA998F808F
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 11:42:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id O5OVp3zO9CiEiCED (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 11:42:05 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 5582A19F99B
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 18:42:05 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t52Ig4Ss019888
	for <xfs@oss.sgi.com>; Tue, 2 Jun 2015 14:42:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 23/28] repair: do not account sparse inodes in phase 5 cursor
	init.
Date: Tue,  2 Jun 2015 14:41:56 -0400
Message-Id: <1433270521-62026-24-git-send-email-bfoster@redhat.com>
In-Reply-To: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
References: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
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

The inode btrees are reconstructed in phase 5 of xfs_repair. The btree
cursor initialization counts the allocated and free inodes in the
in-core records and calculates the expected geometry of the resulting
btree. The free and total inode counts for each AG are also ultimately
aggregated to update the associated superblock counts.

Update init_ino_cursor() to not assume 64 inode records and not account
sparse inodes into the total or free inode count for each AG.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/phase5.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/repair/phase5.c b/repair/phase5.c
index 04bf049..30f2d05 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -899,7 +899,8 @@ init_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 {
 	__uint64_t		ninos;
 	__uint64_t		nfinos;
-	__uint64_t		rec_nfinos;
+	int			rec_nfinos;
+	int			rec_ninos;
 	ino_tree_node_t		*ino_rec;
 	int			num_recs;
 	int			level;
@@ -919,11 +920,19 @@ init_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 	 */
 	ino_rec = findfirst_inode_rec(agno);
 	for (num_recs = 0; ino_rec != NULL; ino_rec = next_ino_rec(ino_rec))  {
+		rec_ninos = 0;
 		rec_nfinos = 0;
 		for (i = 0; i < XFS_INODES_PER_CHUNK; i++)  {
 			ASSERT(is_inode_confirmed(ino_rec, i));
+			/*
+			 * sparse inodes are not factored into superblock (free)
+			 * inode counts
+			 */
+			if (is_inode_sparse(ino_rec, i))
+				continue;
 			if (is_inode_free(ino_rec, i))
 				rec_nfinos++;
+			rec_ninos++;
 		}
 
 		/*
@@ -933,7 +942,7 @@ init_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 			continue;
 
 		nfinos += rec_nfinos;
-		ninos += XFS_INODES_PER_CHUNK;
+		ninos += rec_ninos;
 		num_recs++;
 	}
 
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
