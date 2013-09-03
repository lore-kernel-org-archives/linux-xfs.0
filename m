Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1AC5D7F69
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 13:25:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ADEC3AC006
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 11:25:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tFmqiGD3k9vvLBiv for
	<xfs@oss.sgi.com>; Tue, 03 Sep 2013 11:25:48 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r83IPlF9031734
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 3 Sep 2013 14:25:47 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r83IPkwR009498
	for <xfs@oss.sgi.com>; Tue, 3 Sep 2013 14:25:47 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 08/11] xfs: insert newly allocated inode chunks into the
	finobt
Date: Tue,  3 Sep 2013 14:25:05 -0400
Message-Id: <1378232708-57156-9-git-send-email-bfoster@redhat.com>
In-Reply-To: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
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

A newly allocated inode chunk, by definition, has at least one
free inode, so a record is always inserted into the finobt.

Create the xfs_inobt_insert() helper from existing code to insert
a record in an inobt based on the provided BTNUM. Update
xfs_ialloc_ag_alloc() to invoke the helper for the existing
XFS_BTNUM_INO tree and XFS_BTNUM_FINO tree, if enabled.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_ialloc.c | 79 +++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 56 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 5ced506..e64a728 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -152,6 +152,52 @@ xfs_check_agi_freecount(
 #endif
 
 /*
+ * Insert records describing a newly allocated inode chunk into the inobt.
+ */
+STATIC int
+xfs_inobt_insert(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agino_t		newino,
+	xfs_agino_t		newlen,
+	xfs_btnum_t		btnum)
+{
+	struct xfs_btree_cur	*cur;
+	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
+	xfs_agnumber_t		agno = be32_to_cpu(agi->agi_seqno);
+	xfs_agino_t		thisino;
+	int			i;
+	int			error;
+
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, btnum);
+
+	for (thisino = newino;
+	     thisino < newino + newlen;
+	     thisino += XFS_INODES_PER_CHUNK) {
+		cur->bc_rec.i.ir_startino = thisino;
+		cur->bc_rec.i.ir_freecount = XFS_INODES_PER_CHUNK;
+		cur->bc_rec.i.ir_free = XFS_INOBT_ALL_FREE;
+		error = xfs_btree_lookup(cur, XFS_LOOKUP_EQ, &i);
+		if (error) {
+			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+			return error;
+		}
+		ASSERT(i == 0);
+		error = xfs_btree_insert(cur, &i);
+		if (error) {
+			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+			return error;
+		}
+		ASSERT(i == 1);
+	}
+
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+
+	return 0;
+}
+
+/*
  * Initialise a new set of inodes. When called without a transaction context
  * (e.g. from recovery) we initiate a delayed write of the inode buffers rather
  * than logging them (which in a transaction context puts them into the AIL
@@ -309,13 +355,10 @@ xfs_ialloc_ag_alloc(
 {
 	xfs_agi_t	*agi;		/* allocation group header */
 	xfs_alloc_arg_t	args;		/* allocation argument structure */
-	xfs_btree_cur_t	*cur;		/* inode btree cursor */
 	xfs_agnumber_t	agno;
 	int		error;
-	int		i;
 	xfs_agino_t	newino;		/* new first inode's number */
 	xfs_agino_t	newlen;		/* new number of inodes */
-	xfs_agino_t	thisino;	/* current inode number, for loop */
 	int		isaligned = 0;	/* inode allocation at stripe unit */
 					/* boundary */
 	struct xfs_perag *pag;
@@ -453,29 +496,19 @@ xfs_ialloc_ag_alloc(
 	agi->agi_newino = cpu_to_be32(newino);
 
 	/*
-	 * Insert records describing the new inode chunk into the btree.
+	 * Insert records describing the new inode chunk into the btrees.
 	 */
-	cur = xfs_inobt_init_cursor(args.mp, tp, agbp, agno, XFS_BTNUM_INO);
-	for (thisino = newino;
-	     thisino < newino + newlen;
-	     thisino += XFS_INODES_PER_CHUNK) {
-		cur->bc_rec.i.ir_startino = thisino;
-		cur->bc_rec.i.ir_freecount = XFS_INODES_PER_CHUNK;
-		cur->bc_rec.i.ir_free = XFS_INOBT_ALL_FREE;
-		error = xfs_btree_lookup(cur, XFS_LOOKUP_EQ, &i);
-		if (error) {
-			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-			return error;
-		}
-		ASSERT(i == 0);
-		error = xfs_btree_insert(cur, &i);
-		if (error) {
-			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	error = xfs_inobt_insert(args.mp, tp, agbp, newino, newlen,
+				 XFS_BTNUM_INO);
+	if (error)
+		return error;
+
+	if (xfs_sb_version_hasfinobt(&args.mp->m_sb)) {
+		error = xfs_inobt_insert(args.mp, tp, agbp, newino, newlen,
+					 XFS_BTNUM_FINO);
+		if (error)
 			return error;
-		}
-		ASSERT(i == 1);
 	}
-	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 	/*
 	 * Log allocation group header fields
 	 */
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
