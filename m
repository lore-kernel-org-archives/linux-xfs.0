Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9F1727F3F
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 09:23:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1F1B2AC00A
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 07:23:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UFSoYeVaDBbsfyAg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 07:23:12 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s6OEN9N2016641
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:23:10 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s6OEN9mV030147
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:23:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 01/18] xfs: refactor xfs_inobt_insert() to eliminate loop and
	support variable count
Date: Thu, 24 Jul 2014 10:22:51 -0400
Message-Id: <1406211788-63206-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
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

Inodes are always allocated in chunks of 64 and thus the loop in
xfs_inobt_insert() is unnecessary. Also replace the use of hardcoded
constants (i.e., XFS_INODES_PER_CHUNK) with values provided by the
caller. This prepares the codepath to support sparse inode chunks, which
might have varying numbers of free inodes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index b62771f..6e2ccb3 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -134,37 +134,32 @@ xfs_inobt_insert(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
-	xfs_agino_t		newino,
-	xfs_agino_t		newlen,
+	xfs_agino_t		newino,	/* start inode of record */
+	xfs_agino_t		count,	/* inode count */
+	xfs_inofree_t		free,	/* free mask */
 	xfs_btnum_t		btnum)
 {
 	struct xfs_btree_cur	*cur;
 	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
 	xfs_agnumber_t		agno = be32_to_cpu(agi->agi_seqno);
-	xfs_agino_t		thisino;
 	int			i;
 	int			error;
 
 	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, btnum);
 
-	for (thisino = newino;
-	     thisino < newino + newlen;
-	     thisino += XFS_INODES_PER_CHUNK) {
-		error = xfs_inobt_lookup(cur, thisino, XFS_LOOKUP_EQ, &i);
-		if (error) {
-			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-			return error;
-		}
-		ASSERT(i == 0);
+	error = xfs_inobt_lookup(cur, newino, XFS_LOOKUP_EQ, &i);
+	if (error) {
+		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+		return error;
+	}
+	ASSERT(i == 0);
 
-		error = xfs_inobt_insert_rec(cur, XFS_INODES_PER_CHUNK,
-					     XFS_INOBT_ALL_FREE, &i);
-		if (error) {
-			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-			return error;
-		}
-		ASSERT(i == 1);
+	error = xfs_inobt_insert_rec(cur, count, free, &i);
+	if (error) {
+		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+		return error;
 	}
+	ASSERT(i == 1);
 
 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 
@@ -517,13 +512,13 @@ xfs_ialloc_ag_alloc(
 	 * Insert records describing the new inode chunk into the btrees.
 	 */
 	error = xfs_inobt_insert(args.mp, tp, agbp, newino, newlen,
-				 XFS_BTNUM_INO);
+				 XFS_INOBT_ALL_FREE, XFS_BTNUM_INO);
 	if (error)
 		return error;
 
 	if (xfs_sb_version_hasfinobt(&args.mp->m_sb)) {
 		error = xfs_inobt_insert(args.mp, tp, agbp, newino, newlen,
-					 XFS_BTNUM_FINO);
+					 XFS_INOBT_ALL_FREE, XFS_BTNUM_FINO);
 		if (error)
 			return error;
 	}
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
