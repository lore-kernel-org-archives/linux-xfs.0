Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Feb 2007 21:03:37 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1753O3c023824
	for <xfs@oss.sgi.com>; Tue, 6 Feb 2007 21:03:25 -0800
Received: from [10.0.0.4] (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 914E118003EF5
	for <xfs@oss.sgi.com>; Tue,  6 Feb 2007 23:03:24 -0600 (CST)
Message-ID: <45C95D9C.7080904@sandeen.net>
Date: Tue, 06 Feb 2007 23:03:24 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] remove unused "aendp" arg to xfs_dir2_data_freescan
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

the "aendp" arg to xfs_dir2_data_freescan is always NULL, remove it.

 xfs_dir2_block.c |   14 +++++---------
 xfs_dir2_data.c  |    7 ++-----
 xfs_dir2_data.h  |    2 +-
 xfs_dir2_leaf.c  |    7 +++----
 xfs_dir2_node.c  |    4 ++--
 5 files changed, 13 insertions(+), 21 deletions(-)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux/fs/xfs/xfs_dir2_block.c
===================================================================
--- linux/fs/xfs.orig/xfs_dir2_block.c
+++ linux/fs/xfs/xfs_dir2_block.c
@@ -282,8 +282,7 @@ xfs_dir2_block_addname(
 		 * This needs to happen before the next call to use_free.
 		 */
 		if (needscan) {
-			xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)block,
-				&needlog, NULL);
+			xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)block, &needlog);
 			needscan = 0;
 		}
 	}
@@ -333,7 +332,7 @@ xfs_dir2_block_addname(
 		 */
 		if (needscan) {
 			xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)block,
-				&needlog, NULL);
+				&needlog);
 			needscan = 0;
 		}
 		/*
@@ -418,8 +417,7 @@ xfs_dir2_block_addname(
 	 * Clean up the bestfree array and log the header, tail, and entry.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)block, &needlog,
-			NULL);
+		xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)block, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(tp, bp);
 	xfs_dir2_block_log_tail(tp, bp);
@@ -798,8 +796,7 @@ xfs_dir2_block_removename(
 	 * Fix up bestfree, log the header if necessary.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)block, &needlog,
-			NULL);
+		xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)block, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(tp, bp);
 	xfs_dir2_data_check(dp, bp);
@@ -996,8 +993,7 @@ xfs_dir2_leaf_to_block(
 	 * Scan the bestfree if we need it and log the data block header.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)block, &needlog,
-			NULL);
+		xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)block, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(tp, dbp);
 	/*
Index: linux/fs/xfs/xfs_dir2_data.c
===================================================================
--- linux/fs/xfs.orig/xfs_dir2_data.c
+++ linux/fs/xfs/xfs_dir2_data.c
@@ -324,8 +324,7 @@ void
 xfs_dir2_data_freescan(
 	xfs_mount_t		*mp,		/* filesystem mount point */
 	xfs_dir2_data_t		*d,		/* data block pointer */
-	int			*loghead,	/* out: log data header */
-	char			*aendp)		/* in: caller's endp */
+	int			*loghead)	/* out: log data header */
 {
 	xfs_dir2_block_tail_t	*btp;		/* block tail */
 	xfs_dir2_data_entry_t	*dep;		/* active data entry */
@@ -346,9 +345,7 @@ xfs_dir2_data_freescan(
 	 * Set up pointers.
 	 */
 	p = (char *)d->u;
-	if (aendp)
-		endp = aendp;
-	else if (be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC) {
+	if (be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC) {
 		btp = XFS_DIR2_BLOCK_TAIL_P(mp, (xfs_dir2_block_t *)d);
 		endp = (char *)XFS_DIR2_BLOCK_LEAF_P(btp);
 	} else
Index: linux/fs/xfs/xfs_dir2_data.h
===================================================================
--- linux/fs/xfs.orig/xfs_dir2_data.h
+++ linux/fs/xfs/xfs_dir2_data.h
@@ -166,7 +166,7 @@ extern xfs_dir2_data_free_t *xfs_dir2_da
 extern xfs_dir2_data_free_t *xfs_dir2_data_freeinsert(xfs_dir2_data_t *d,
 				xfs_dir2_data_unused_t *dup, int *loghead);
 extern void xfs_dir2_data_freescan(struct xfs_mount *mp, xfs_dir2_data_t *d,
-				int *loghead, char *aendp);
+				int *loghead);
 extern int xfs_dir2_data_init(struct xfs_da_args *args, xfs_dir2_db_t blkno,
 				struct xfs_dabuf **bpp);
 extern void xfs_dir2_data_log_entry(struct xfs_trans *tp, struct xfs_dabuf *bp,
Index: linux/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- linux/fs/xfs.orig/xfs_dir2_leaf.c
+++ linux/fs/xfs/xfs_dir2_leaf.c
@@ -133,8 +133,7 @@ xfs_dir2_block_to_leaf(
 	 */
 	block->hdr.magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
 	if (needscan)
-		xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)block, &needlog,
-			NULL);
+		xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)block, &needlog);
 	/*
 	 * Set up leaf tail and bests table.
 	 */
@@ -414,7 +413,7 @@ xfs_dir2_leaf_addname(
 	 * Need to scan fix up the bestfree table.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(mp, data, &needlog, NULL);
+		xfs_dir2_data_freescan(mp, data, &needlog);
 	/*
 	 * Need to log the data block's header.
 	 */
@@ -1496,7 +1495,7 @@ xfs_dir2_leaf_removename(
 	 * log the data block header if necessary.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(mp, data, &needlog, NULL);
+		xfs_dir2_data_freescan(mp, data, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(tp, dbp);
 	/*
Index: linux/fs/xfs/xfs_dir2_node.c
===================================================================
--- linux/fs/xfs.orig/xfs_dir2_node.c
+++ linux/fs/xfs/xfs_dir2_node.c
@@ -904,7 +904,7 @@ xfs_dir2_leafn_remove(
 	 * Log the data block header if needed.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(mp, data, &needlog, NULL);
+		xfs_dir2_data_freescan(mp, data, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(tp, dbp);
 	xfs_dir2_data_check(dp, dbp);
@@ -1705,7 +1705,7 @@ xfs_dir2_node_addname_int(
 	 * Rescan the block for bestfree if needed.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(mp, data, &needlog, NULL);
+		xfs_dir2_data_freescan(mp, data, &needlog);
 	/*
 	 * Log the data block header if needed.
 	 */
