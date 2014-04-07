Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5BF337F94
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 14:59:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 38A5A304039
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 12:59:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id UXV3wzPVrVs0DNsE for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 12:59:09 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 10/19] xfs: remove unused tp arg from xfs_da_reada_buf &
	callers
Date: Mon,  7 Apr 2014 14:58:57 -0500
Message-Id: <1396900746-22201-11-git-send-email-sandeen@redhat.com>
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

This one hits a few functions as we unravel the unused arg
up through the callers.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_da_btree.c     |    8 +++-----
 fs/xfs/xfs_da_btree.h     |    6 +++---
 fs/xfs/xfs_dir2_data.c    |    3 +--
 fs/xfs/xfs_dir2_priv.h    |    4 ++--
 fs/xfs/xfs_dir2_readdir.c |    4 ++--
 fs/xfs/xfs_file.c         |    2 +-
 6 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 796272a..da4692e 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -2461,7 +2461,6 @@ xfs_buf_map_from_irec(
  */
 static int
 xfs_dabuf_map(
-	struct xfs_trans	*trans,
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
 	xfs_daddr_t		mappedbno,
@@ -2557,7 +2556,7 @@ xfs_da_get_buf(
 	*bpp = NULL;
 	mapp = &map;
 	nmap = 1;
-	error = xfs_dabuf_map(trans, dp, bno, mappedbno, whichfork,
+	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork,
 				&mapp, &nmap);
 	if (error) {
 		/* mapping a hole is not an error, but we don't continue */
@@ -2605,7 +2604,7 @@ xfs_da_read_buf(
 	*bpp = NULL;
 	mapp = &map;
 	nmap = 1;
-	error = xfs_dabuf_map(trans, dp, bno, mappedbno, whichfork,
+	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork,
 				&mapp, &nmap);
 	if (error) {
 		/* mapping a hole is not an error, but we don't continue */
@@ -2678,7 +2677,6 @@ out_free:
  */
 xfs_daddr_t
 xfs_da_reada_buf(
-	struct xfs_trans	*trans,
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
 	xfs_daddr_t		mappedbno,
@@ -2692,7 +2690,7 @@ xfs_da_reada_buf(
 
 	mapp = &map;
 	nmap = 1;
-	error = xfs_dabuf_map(trans, dp, bno, mappedbno, whichfork,
+	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork,
 				&mapp, &nmap);
 	if (error) {
 		/* mapping a hole is not an error, but we don't continue */
diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
index 6e95ea7..4cc6a46 100644
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
@@ -183,9 +183,9 @@ int	xfs_da_read_buf(struct xfs_trans *trans, struct xfs_inode *dp,
 			       xfs_dablk_t bno, xfs_daddr_t mappedbno,
 			       struct xfs_buf **bpp, int whichfork,
 			       const struct xfs_buf_ops *ops);
-xfs_daddr_t	xfs_da_reada_buf(struct xfs_trans *trans, struct xfs_inode *dp,
-				xfs_dablk_t bno, xfs_daddr_t mapped_bno,
-				int whichfork, const struct xfs_buf_ops *ops);
+xfs_daddr_t	xfs_da_reada_buf(struct xfs_inode *dp, xfs_dablk_t bno,
+				xfs_daddr_t mapped_bno, int whichfork,
+				const struct xfs_buf_ops *ops);
 int	xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
 					  struct xfs_buf *dead_buf);
 
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index 70acff4..b00df36 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -329,12 +329,11 @@ xfs_dir3_data_read(
 
 int
 xfs_dir3_data_readahead(
-	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
 	xfs_daddr_t		mapped_bno)
 {
-	return xfs_da_reada_buf(tp, dp, bno, mapped_bno,
+	return xfs_da_reada_buf(dp, bno, mapped_bno,
 				XFS_DATA_FORK, &xfs_dir3_data_reada_buf_ops);
 }
 
diff --git a/fs/xfs/xfs_dir2_priv.h b/fs/xfs/xfs_dir2_priv.h
index 8b9d228..2429960 100644
--- a/fs/xfs/xfs_dir2_priv.h
+++ b/fs/xfs/xfs_dir2_priv.h
@@ -54,8 +54,8 @@ extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
 extern int __xfs_dir3_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
 extern int xfs_dir3_data_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t bno, xfs_daddr_t mapped_bno, struct xfs_buf **bpp);
-extern int xfs_dir3_data_readahead(struct xfs_trans *tp, struct xfs_inode *dp,
-		xfs_dablk_t bno, xfs_daddr_t mapped_bno);
+extern int xfs_dir3_data_readahead(struct xfs_inode *dp, xfs_dablk_t bno,
+		xfs_daddr_t mapped_bno);
 
 extern struct xfs_dir2_data_free *
 xfs_dir2_data_freeinsert(struct xfs_dir2_data_hdr *hdr,
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index a18000f..a99967b 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -434,7 +434,7 @@ xfs_dir2_leaf_readbuf(
 		 */
 		if (i > mip->ra_current &&
 		    map[mip->ra_index].br_blockcount >= mp->m_dirblkfsbs) {
-			xfs_dir3_data_readahead(NULL, dp,
+			xfs_dir3_data_readahead(dp,
 				map[mip->ra_index].br_startoff + mip->ra_offset,
 				XFS_FSB_TO_DADDR(mp,
 					map[mip->ra_index].br_startblock +
@@ -447,7 +447,7 @@ xfs_dir2_leaf_readbuf(
 		 * use our mapping, but this is a very rare case.
 		 */
 		else if (i > mip->ra_current) {
-			xfs_dir3_data_readahead(NULL, dp,
+			xfs_dir3_data_readahead(dp,
 					map[mip->ra_index].br_startoff +
 							mip->ra_offset, -1);
 			mip->ra_current = i;
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 64b48ea..340f2af 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -917,7 +917,7 @@ xfs_dir_open(
 	 */
 	mode = xfs_ilock_data_map_shared(ip);
 	if (ip->i_d.di_nextents > 0)
-		xfs_dir3_data_readahead(NULL, ip, 0, -1);
+		xfs_dir3_data_readahead(ip, 0, -1);
 	xfs_iunlock(ip, mode);
 	return 0;
 }
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
