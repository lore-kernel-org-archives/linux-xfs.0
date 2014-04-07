Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9177D7F9A
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 14:59:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 78D618F8054
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 12:59:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id JKlj4AsoRkvcuSkD for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 12:59:08 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 05/19] xfs: remove unused level arg from
	xfs_btree_read_buf_block()
Date: Mon,  7 Apr 2014 14:58:52 -0500
Message-Id: <1396900746-22201-6-git-send-email-sandeen@redhat.com>
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
 fs/xfs/xfs_btree.c |   32 +++++++++++++-------------------
 1 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index 9adaae4..e20d61b 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -1161,7 +1161,6 @@ STATIC int
 xfs_btree_read_buf_block(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*ptr,
-	int			level,
 	int			flags,
 	struct xfs_btree_block	**block,
 	struct xfs_buf		**bpp)
@@ -1519,8 +1518,8 @@ xfs_btree_increment(
 		union xfs_btree_ptr	*ptrp;
 
 		ptrp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[lev], block);
-		error = xfs_btree_read_buf_block(cur, ptrp, --lev,
-							0, &block, &bp);
+		--lev;
+		error = xfs_btree_read_buf_block(cur, ptrp, 0, &block, &bp);
 		if (error)
 			goto error0;
 
@@ -1618,8 +1617,8 @@ xfs_btree_decrement(
 		union xfs_btree_ptr	*ptrp;
 
 		ptrp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[lev], block);
-		error = xfs_btree_read_buf_block(cur, ptrp, --lev,
-							0, &block, &bp);
+		--lev;
+		error = xfs_btree_read_buf_block(cur, ptrp, 0, &block, &bp);
 		if (error)
 			goto error0;
 		xfs_btree_setbuf(cur, lev, bp);
@@ -1669,7 +1668,7 @@ xfs_btree_lookup_get_block(
 		return 0;
 	}
 
-	error = xfs_btree_read_buf_block(cur, pp, level, 0, blkp, &bp);
+	error = xfs_btree_read_buf_block(cur, pp, 0, blkp, &bp);
 	if (error)
 		return error;
 
@@ -2020,7 +2019,7 @@ xfs_btree_lshift(
 		goto out0;
 
 	/* Set up the left neighbor as "left". */
-	error = xfs_btree_read_buf_block(cur, &lptr, level, 0, &left, &lbp);
+	error = xfs_btree_read_buf_block(cur, &lptr, 0, &left, &lbp);
 	if (error)
 		goto error0;
 
@@ -2204,7 +2203,7 @@ xfs_btree_rshift(
 		goto out0;
 
 	/* Set up the right neighbor as "right". */
-	error = xfs_btree_read_buf_block(cur, &rptr, level, 0, &right, &rbp);
+	error = xfs_btree_read_buf_block(cur, &rptr, 0, &right, &rbp);
 	if (error)
 		goto error0;
 
@@ -2472,7 +2471,7 @@ xfs_btree_split(
 	 * point back to right instead of to left.
 	 */
 	if (!xfs_btree_ptr_is_null(cur, &rrptr)) {
-		error = xfs_btree_read_buf_block(cur, &rrptr, level,
+		error = xfs_btree_read_buf_block(cur, &rrptr,
 							0, &rrblock, &rrbp);
 		if (error)
 			goto error0;
@@ -2686,8 +2685,7 @@ xfs_btree_new_root(
 		lbp = bp;
 		xfs_btree_buf_to_ptr(cur, lbp, &lptr);
 		left = block;
-		error = xfs_btree_read_buf_block(cur, &rptr,
-					cur->bc_nlevels - 1, 0, &right, &rbp);
+		error = xfs_btree_read_buf_block(cur, &rptr, 0, &right, &rbp);
 		if (error)
 			goto error0;
 		bp = rbp;
@@ -2698,8 +2696,7 @@ xfs_btree_new_root(
 		xfs_btree_buf_to_ptr(cur, rbp, &rptr);
 		right = block;
 		xfs_btree_get_sibling(cur, right, &lptr, XFS_BB_LEFTSIB);
-		error = xfs_btree_read_buf_block(cur, &lptr,
-					cur->bc_nlevels - 1, 0, &left, &lbp);
+		error = xfs_btree_read_buf_block(cur, &lptr, 0, &left, &lbp);
 		if (error)
 			goto error0;
 		bp = lbp;
@@ -3651,8 +3648,7 @@ xfs_btree_delrec(
 		rptr = cptr;
 		right = block;
 		rbp = bp;
-		error = xfs_btree_read_buf_block(cur, &lptr, level,
-							0, &left, &lbp);
+		error = xfs_btree_read_buf_block(cur, &lptr, 0, &left, &lbp);
 		if (error)
 			goto error0;
 
@@ -3669,8 +3665,7 @@ xfs_btree_delrec(
 		lptr = cptr;
 		left = block;
 		lbp = bp;
-		error = xfs_btree_read_buf_block(cur, &rptr, level,
-							0, &right, &rbp);
+		error = xfs_btree_read_buf_block(cur, &rptr, 0, &right, &rbp);
 		if (error)
 			goto error0;
 
@@ -3742,8 +3737,7 @@ xfs_btree_delrec(
 	/* If there is a right sibling, point it to the remaining block. */
 	xfs_btree_get_sibling(cur, left, &cptr, XFS_BB_RIGHTSIB);
 	if (!xfs_btree_ptr_is_null(cur, &cptr)) {
-		error = xfs_btree_read_buf_block(cur, &cptr, level,
-							0, &rrblock, &rrbp);
+		error = xfs_btree_read_buf_block(cur, &cptr, 0, &rrblock, &rrbp);
 		if (error)
 			goto error0;
 		xfs_btree_set_sibling(cur, rrblock, &lptr, XFS_BB_LEFTSIB);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
