Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 611847F3F
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2014 08:08:17 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 004DAAC007
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2014 06:08:13 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ENEjkdCiLPTkN2J5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 18 Nov 2014 06:08:13 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sAIE8BkJ024155
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Tue, 18 Nov 2014 09:08:12 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sAIE8BUg024007
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2014 09:08:11 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfsprogs/repair: fix crash on zero record finobt
	reconstruction
Date: Tue, 18 Nov 2014 09:08:10 -0500
Message-Id: <1416319690-27776-1-git-send-email-bfoster@redhat.com>
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

The inode btrees are reconstructed in phase 5. init_ino_cursor() helps
determine the block requirements of the tree based on the number of
records. If the finobt is empty, we can crash in the btree blocks
calculation code due to a divide-by-zero error in the following line:

	lptr->modulo = num_recs % lptr->num_blocks;

This occurs if num_recs and in-turn lptr->num_blocks evaluate to zero.

We already have an execution path for the zero record btree scenario.
However, it is only invoked when no records are found in the in-core
tree. The finobt zero-record scenario can occur with a populated in-core
tree provided that none of the existing records contain free inodes.

Move the zero-record handling code after the loop and use the record
count to trigger it. This is safe because the loop iterator checks for
ino_rec != NULL. This allows reuse of the same code regardless of
whether the in-core tree is empty or non-empty but contains no records
that meet the requirements for the particular on-disk tree under
reconstruction (e.g., finobt).

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/phase5.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/repair/phase5.c b/repair/phase5.c
index 3d58936..3a2cdbb 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -914,26 +914,10 @@ init_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 	lptr = &btree_curs->level[0];
 	btree_curs->init = 1;
 
-	if ((ino_rec = findfirst_inode_rec(agno)) == NULL)  {
-		/*
-		 * easy corner-case -- no inode records
-		 */
-		lptr->num_blocks = 1;
-		lptr->modulo = 0;
-		lptr->num_recs_pb = 0;
-		lptr->num_recs_tot = 0;
-
-		btree_curs->num_levels = 1;
-		btree_curs->num_tot_blocks = btree_curs->num_free_blocks = 1;
-
-		setup_cursor(mp, agno, btree_curs);
-
-		return;
-	}
-
 	/*
 	 * build up statistics
 	 */
+	ino_rec = findfirst_inode_rec(agno);
 	for (num_recs = 0; ino_rec != NULL; ino_rec = next_ino_rec(ino_rec))  {
 		rec_nfinos = 0;
 		for (i = 0; i < XFS_INODES_PER_CHUNK; i++)  {
@@ -953,6 +937,23 @@ init_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 		num_recs++;
 	}
 
+	if (num_recs == 0) {
+		/*
+		 * easy corner-case -- no inode records
+		 */
+		lptr->num_blocks = 1;
+		lptr->modulo = 0;
+		lptr->num_recs_pb = 0;
+		lptr->num_recs_tot = 0;
+
+		btree_curs->num_levels = 1;
+		btree_curs->num_tot_blocks = btree_curs->num_free_blocks = 1;
+
+		setup_cursor(mp, agno, btree_curs);
+
+		return;
+	}
+
 	blocks_allocated = lptr->num_blocks = howmany(num_recs,
 					XR_INOBT_BLOCK_MAXRECS(mp, 0));
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
