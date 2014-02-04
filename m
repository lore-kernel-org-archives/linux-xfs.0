Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B555C7F52
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 11:49:46 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AA9438F8039
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 09:49:46 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id M8fQzRcI4W438sDD for
	<xfs@oss.sgi.com>; Tue, 04 Feb 2014 09:49:45 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s14HnjsK004573
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 4 Feb 2014 12:49:45 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id s14HniS9011541
	for <xfs@oss.sgi.com>; Tue, 4 Feb 2014 12:49:45 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 05/11] xfs: insert newly allocated inode chunks into the
	finobt
Date: Tue,  4 Feb 2014 12:49:36 -0500
Message-Id: <1391536182-9048-6-git-send-email-bfoster@redhat.com>
In-Reply-To: <1391536182-9048-1-git-send-email-bfoster@redhat.com>
References: <1391536182-9048-1-git-send-email-bfoster@redhat.com>
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
 fs/xfs/xfs_ialloc.c | 93 ++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 70 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index d99eb09..bdaab76 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -112,6 +112,66 @@ xfs_inobt_get_rec(
 }
 
 /*
+ * Insert a single inobt record. Cursor must already point to desired location.
+ */
+STATIC int
+xfs_inobt_insert_rec(
+	struct xfs_btree_cur	*cur,
+	__int32_t		freecount,
+	xfs_inofree_t		free,
+	int			*stat)
+{
+	cur->bc_rec.i.ir_freecount = freecount;
+	cur->bc_rec.i.ir_free = free;
+	return xfs_btree_insert(cur, stat);
+}
+
+/*
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
+		error = xfs_inobt_lookup(cur, thisino, XFS_LOOKUP_EQ, &i);
+		if (error) {
+			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+			return error;
+		}
+		ASSERT(i == 0);
+
+		error = xfs_inobt_insert_rec(cur, XFS_INODES_PER_CHUNK,
+					     XFS_INOBT_ALL_FREE, &i);
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
  * Verify that the number of free inodes in the AGI is correct.
  */
 #ifdef DEBUG
@@ -310,13 +370,10 @@ xfs_ialloc_ag_alloc(
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
@@ -454,29 +511,19 @@ xfs_ialloc_ag_alloc(
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
