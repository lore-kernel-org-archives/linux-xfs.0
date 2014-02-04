Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 79B187F51
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 11:49:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E58D2AC005
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 09:49:46 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FHaBeM1lNrU52lCs for
	<xfs@oss.sgi.com>; Tue, 04 Feb 2014 09:49:45 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s14HniXn004569
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 4 Feb 2014 12:49:45 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s14Hni1d022763
	for <xfs@oss.sgi.com>; Tue, 4 Feb 2014 12:49:44 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 01/11] xfs: refactor xfs_ialloc_btree.c to support multiple
	inobt numbers
Date: Tue,  4 Feb 2014 12:49:32 -0500
Message-Id: <1391536182-9048-2-git-send-email-bfoster@redhat.com>
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

The introduction of the free inode btree (finobt) requires that
xfs_ialloc_btree.c handle multiple trees. Refactor xfs_ialloc_btree.c
so the caller specifies the btree type on cursor initialization to
prepare for addition of the finobt.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ialloc.c       | 8 ++++----
 fs/xfs/xfs_ialloc_btree.c | 8 +++++---
 fs/xfs/xfs_ialloc_btree.h | 3 ++-
 fs/xfs/xfs_itable.c       | 6 ++++--
 4 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 7a728f9f..ef3abd1 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -456,7 +456,7 @@ xfs_ialloc_ag_alloc(
 	/*
 	 * Insert records describing the new inode chunk into the btree.
 	 */
-	cur = xfs_inobt_init_cursor(args.mp, tp, agbp, agno);
+	cur = xfs_inobt_init_cursor(args.mp, tp, agbp, agno, XFS_BTNUM_INO);
 	for (thisino = newino;
 	     thisino < newino + newlen;
 	     thisino += XFS_INODES_PER_CHUNK) {
@@ -702,7 +702,7 @@ xfs_dialloc_ag(
 	ASSERT(pag->pagi_freecount > 0);
 
  restart_pagno:
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno);
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO);
 	/*
 	 * If pagino is 0 (this is the root inode allocation) use newino.
 	 * This must work because we've just allocated some.
@@ -1164,7 +1164,7 @@ xfs_difree(
 	/*
 	 * Initialize the cursor.
 	 */
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno);
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO);
 
 	error = xfs_check_agi_freecount(cur, agi);
 	if (error)
@@ -1295,7 +1295,7 @@ xfs_imap_lookup(
 	 * we have a record, we need to ensure it contains the inode number
 	 * we are looking up.
 	 */
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno);
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO);
 	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &i);
 	if (!error) {
 		if (i)
diff --git a/fs/xfs/xfs_ialloc_btree.c b/fs/xfs/xfs_ialloc_btree.c
index c8fa5bb..2d1a398 100644
--- a/fs/xfs/xfs_ialloc_btree.c
+++ b/fs/xfs/xfs_ialloc_btree.c
@@ -49,7 +49,8 @@ xfs_inobt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
 	return xfs_inobt_init_cursor(cur->bc_mp, cur->bc_tp,
-			cur->bc_private.a.agbp, cur->bc_private.a.agno);
+			cur->bc_private.a.agbp, cur->bc_private.a.agno,
+			cur->bc_btnum);
 }
 
 STATIC void
@@ -323,7 +324,8 @@ xfs_inobt_init_cursor(
 	struct xfs_mount	*mp,		/* file system mount point */
 	struct xfs_trans	*tp,		/* transaction pointer */
 	struct xfs_buf		*agbp,		/* buffer for agi structure */
-	xfs_agnumber_t		agno)		/* allocation group number */
+	xfs_agnumber_t		agno,		/* allocation group number */
+	xfs_btnum_t		btnum)		/* ialloc or free ino btree */
 {
 	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
 	struct xfs_btree_cur	*cur;
@@ -333,7 +335,7 @@ xfs_inobt_init_cursor(
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_nlevels = be32_to_cpu(agi->agi_level);
-	cur->bc_btnum = XFS_BTNUM_INO;
+	cur->bc_btnum = btnum;
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 
 	cur->bc_ops = &xfs_inobt_ops;
diff --git a/fs/xfs/xfs_ialloc_btree.h b/fs/xfs/xfs_ialloc_btree.h
index f38b220..d7ebea72 100644
--- a/fs/xfs/xfs_ialloc_btree.h
+++ b/fs/xfs/xfs_ialloc_btree.h
@@ -58,7 +58,8 @@ struct xfs_mount;
 		 ((index) - 1) * sizeof(xfs_inobt_ptr_t)))
 
 extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *,
-		struct xfs_trans *, struct xfs_buf *, xfs_agnumber_t);
+		struct xfs_trans *, struct xfs_buf *, xfs_agnumber_t,
+		xfs_btnum_t);
 extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
 
 #endif	/* __XFS_IALLOC_BTREE_H__ */
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index c237ad1..71a8169 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -274,7 +274,8 @@ xfs_bulkstat(
 		/*
 		 * Allocate and initialize a btree cursor for ialloc btree.
 		 */
-		cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno);
+		cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno,
+					    XFS_BTNUM_INO);
 		irbp = irbuf;
 		irbufend = irbuf + nirbuf;
 		end_of_ag = 0;
@@ -625,7 +626,8 @@ xfs_inumbers(
 				agino = 0;
 				continue;
 			}
-			cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno);
+			cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno,
+						    XFS_BTNUM_INO);
 			error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_GE,
 						 &tmp);
 			if (error) {
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
