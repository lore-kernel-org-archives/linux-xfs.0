Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4865B7F9F
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 14:59:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A8EEFAC017
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 12:59:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id jdlXxQYJ6ryENHuT for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 12:59:09 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 13/19] xfs: remove unused length arg from alloc_block ops
Date: Mon,  7 Apr 2014 14:59:00 -0500
Message-Id: <1396900746-22201-14-git-send-email-sandeen@redhat.com>
In-Reply-To: <1396900746-22201-1-git-send-email-sandeen@redhat.com>
References: <1396900746-22201-1-git-send-email-sandeen@redhat.com>
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

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_alloc_btree.c  |    1 -
 fs/xfs/xfs_bmap_btree.c   |    1 -
 fs/xfs/xfs_btree.c        |    6 +++---
 fs/xfs/xfs_btree.h        |    2 +-
 fs/xfs/xfs_ialloc_btree.c |    1 -
 5 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_alloc_btree.c b/fs/xfs/xfs_alloc_btree.c
index 1308542..1abd9c3 100644
--- a/fs/xfs/xfs_alloc_btree.c
+++ b/fs/xfs/xfs_alloc_btree.c
@@ -70,7 +70,6 @@ xfs_allocbt_alloc_block(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*start,
 	union xfs_btree_ptr	*new,
-	int			length,
 	int			*stat)
 {
 	int			error;
diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
index a9d6b7b..8bdbd11 100644
--- a/fs/xfs/xfs_bmap_btree.c
+++ b/fs/xfs/xfs_bmap_btree.c
@@ -519,7 +519,6 @@ xfs_bmbt_alloc_block(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*start,
 	union xfs_btree_ptr	*new,
-	int			length,
 	int			*stat)
 {
 	xfs_alloc_arg_t		args;		/* block allocation args */
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index e20d61b..752b735 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -2373,7 +2373,7 @@ xfs_btree_split(
 	xfs_btree_buf_to_ptr(cur, lbp, &lptr);
 
 	/* Allocate the new block. If we can't do it, we're toast. Give up. */
-	error = cur->bc_ops->alloc_block(cur, &lptr, &rptr, 1, stat);
+	error = cur->bc_ops->alloc_block(cur, &lptr, &rptr, stat);
 	if (error)
 		goto error0;
 	if (*stat == 0)
@@ -2546,7 +2546,7 @@ xfs_btree_new_iroot(
 	pp = xfs_btree_ptr_addr(cur, 1, block);
 
 	/* Allocate the new block. If we can't do it, we're toast. Give up. */
-	error = cur->bc_ops->alloc_block(cur, pp, &nptr, 1, stat);
+	error = cur->bc_ops->alloc_block(cur, pp, &nptr, stat);
 	if (error)
 		goto error0;
 	if (*stat == 0) {
@@ -2650,7 +2650,7 @@ xfs_btree_new_root(
 	cur->bc_ops->init_ptr_from_cur(cur, &rptr);
 
 	/* Allocate the new block. If we can't do it, we're toast. Give up. */
-	error = cur->bc_ops->alloc_block(cur, &rptr, &lptr, 1, stat);
+	error = cur->bc_ops->alloc_block(cur, &rptr, &lptr, stat);
 	if (error)
 		goto error0;
 	if (*stat == 0)
diff --git a/fs/xfs/xfs_btree.h b/fs/xfs/xfs_btree.h
index 91e34f2..875f687 100644
--- a/fs/xfs/xfs_btree.h
+++ b/fs/xfs/xfs_btree.h
@@ -129,7 +129,7 @@ struct xfs_btree_ops {
 	int	(*alloc_block)(struct xfs_btree_cur *cur,
 			       union xfs_btree_ptr *start_bno,
 			       union xfs_btree_ptr *new_bno,
-			       int length, int *stat);
+			       int *stat);
 	int	(*free_block)(struct xfs_btree_cur *cur, struct xfs_buf *bp);
 
 	/* update last record information */
diff --git a/fs/xfs/xfs_ialloc_btree.c b/fs/xfs/xfs_ialloc_btree.c
index c8fa5bb..5121ec5 100644
--- a/fs/xfs/xfs_ialloc_btree.c
+++ b/fs/xfs/xfs_ialloc_btree.c
@@ -71,7 +71,6 @@ xfs_inobt_alloc_block(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*start,
 	union xfs_btree_ptr	*new,
-	int			length,
 	int			*stat)
 {
 	xfs_alloc_arg_t		args;		/* block allocation args */
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
