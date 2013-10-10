Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 992307F57
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 10:51:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 87EBB304051
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 08:51:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FUY5iIUnIrqP0VLb for
	<xfs@oss.sgi.com>; Thu, 10 Oct 2013 08:51:49 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9AFpman023479
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 11:51:49 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r9AFpmsT023060
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 11:51:48 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 01/12] xfsprogs: refactor xfs_ialloc_btree.c to support
	multiple inobt numbers
Date: Thu, 10 Oct 2013 11:51:01 -0400
Message-Id: <1381420272-13249-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1381420272-13249-1-git-send-email-bfoster@redhat.com>
References: <1381420272-13249-1-git-send-email-bfoster@redhat.com>
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
---
 include/xfs_ialloc_btree.h | 3 ++-
 libxfs/xfs_ialloc.c        | 8 ++++----
 libxfs/xfs_ialloc_btree.c  | 8 +++++---
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/xfs_ialloc_btree.h b/include/xfs_ialloc_btree.h
index 3ac36b7..ce7a62b 100644
--- a/include/xfs_ialloc_btree.h
+++ b/include/xfs_ialloc_btree.h
@@ -107,7 +107,8 @@ typedef __be32 xfs_inobt_ptr_t;
 		 ((index) - 1) * sizeof(xfs_inobt_ptr_t)))
 
 extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *,
-		struct xfs_trans *, struct xfs_buf *, xfs_agnumber_t);
+		struct xfs_trans *, struct xfs_buf *, xfs_agnumber_t,
+		xfs_btnum_t);
 extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
 
 extern const struct xfs_buf_ops xfs_inobt_buf_ops;
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 4683287..45a5692 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -432,7 +432,7 @@ xfs_ialloc_ag_alloc(
 	/*
 	 * Insert records describing the new inode chunk into the btree.
 	 */
-	cur = xfs_inobt_init_cursor(args.mp, tp, agbp, agno);
+	cur = xfs_inobt_init_cursor(args.mp, tp, agbp, agno, XFS_BTNUM_INO);
 	for (thisino = newino;
 	     thisino < newino + newlen;
 	     thisino += XFS_INODES_PER_CHUNK) {
@@ -678,7 +678,7 @@ xfs_dialloc_ag(
 	ASSERT(pag->pagi_freecount > 0);
 
  restart_pagno:
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno);
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO);
 	/*
 	 * If pagino is 0 (this is the root inode allocation) use newino.
 	 * This must work because we've just allocated some.
@@ -1140,7 +1140,7 @@ xfs_difree(
 	/*
 	 * Initialize the cursor.
 	 */
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno);
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO);
 
 	error = xfs_check_agi_freecount(cur, agi);
 	if (error)
@@ -1271,7 +1271,7 @@ xfs_imap_lookup(
 	 * we have a record, we need to ensure it contains the inode number
 	 * we are looking up.
 	 */
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno);
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO);
 	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &i);
 	if (!error) {
 		if (i)
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 27a5dd9..0b9b91a 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -30,7 +30,8 @@ xfs_inobt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
 	return xfs_inobt_init_cursor(cur->bc_mp, cur->bc_tp,
-			cur->bc_private.a.agbp, cur->bc_private.a.agno);
+			cur->bc_private.a.agbp, cur->bc_private.a.agno,
+			cur->bc_btnum);
 }
 
 STATIC void
@@ -377,7 +378,8 @@ xfs_inobt_init_cursor(
 	struct xfs_mount	*mp,		/* file system mount point */
 	struct xfs_trans	*tp,		/* transaction pointer */
 	struct xfs_buf		*agbp,		/* buffer for agi structure */
-	xfs_agnumber_t		agno)		/* allocation group number */
+	xfs_agnumber_t		agno,		/* allocation group number */
+	xfs_btnum_t		btnum)		/* ialloc or free ino btree */
 {
 	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
 	struct xfs_btree_cur	*cur;
@@ -387,7 +389,7 @@ xfs_inobt_init_cursor(
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_nlevels = be32_to_cpu(agi->agi_level);
-	cur->bc_btnum = XFS_BTNUM_INO;
+	cur->bc_btnum = btnum;
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 
 	cur->bc_ops = &xfs_inobt_ops;
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
