Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AA0B37F5F
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 00:02:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6D85F304062
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 22:02:53 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	x7W5o2odI5G5NexA for <xfs@oss.sgi.com>;
	Wed, 23 Apr 2014 22:02:51 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WdBnQ-0006xv-QM
	for xfs@oss.sgi.com; Thu, 24 Apr 2014 15:02:04 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WdBnQ-0005gC-PC
	for xfs@oss.sgi.com; Thu, 24 Apr 2014 15:02:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/9] repair: detect and correct CRC errors in directory blocks
Date: Thu, 24 Apr 2014 15:01:57 +1000
Message-Id: <1398315722-20870-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1398315722-20870-1-git-send-email-david@fromorbit.com>
References: <1398315722-20870-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

repair doesn't currently verifier errors in directory blocks - they
cause repair to ignore blocks and hence fail because it can't read
critical blocks from the directory.

Fix this by having the directory buffer read code detect a verifier
error and retry the read without the verifier if the verifier has
detected an error. Then pass the verifer error with the successfully
read buffer back to the caller, so the caller can handle the error
appropriately. In most cases, this is simply marking the directory
as needing a rebuild, so once the directory entries have been
checked and repaired, it will rewrite all the directory buffers
(including the clean ones) and in the process recalculate all the
the CRC on the directory blocks.

Hence pure CRC errors in directory blocks are now handled correctly
by xfs_repair.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/rdwr.c   |  3 +-
 repair/phase6.c | 94 +++++++++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 76 insertions(+), 21 deletions(-)

diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 92b1182..f0bc040 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -731,9 +731,9 @@ libxfs_readbuf(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len, int flags,
 	 * here because it's dirty and unchecked indicates we've screwed up
 	 * somewhere else.
 	 */
+	bp->b_error = 0;
 	if ((bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY))) {
 		if (ops && (bp->b_flags & LIBXFS_B_UNCHECKED)) {
-			bp->b_error = 0;
 			bp->b_ops = ops;
 			bp->b_ops->verify_read(bp);
 			bp->b_flags &= ~LIBXFS_B_UNCHECKED;
@@ -748,7 +748,6 @@ libxfs_readbuf(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len, int flags,
 	 * it again, but it won't get called again and set to match the buffer
 	 * contents. *cough* xfs_da_node_buf_ops *cough*.
 	 */
-	bp->b_error = 0;
 	bp->b_ops = ops;
 	error = libxfs_readbufr(btp, blkno, bp, len, flags);
 	if (error)
diff --git a/repair/phase6.c b/repair/phase6.c
index 0c35e1c..5ae6a3d 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -125,6 +125,45 @@ typedef struct freetab {
 #define	DIR_HASH_CK_TOTAL	6
 
 /*
+ * Need to handle CRC and validation errors specially here. If there is a
+ * validator error, re-read without the verifier so that we get a buffer we can
+ * check and repair. Re-attach the ops to the buffer after the read so that when
+ * it is rewritten the CRC is recalculated.
+ *
+ * If the buffer was not read, we return an error. If the buffer was read but
+ * had a CRC or corruption error, we reread it without the verifier and if it is
+ * read successfully we increment *crc_error and return 0. Otherwise we
+ * return the read error.
+ */
+static int
+dir_read_buf(
+	struct xfs_inode	*ip,
+	xfs_dablk_t		bno,
+	xfs_daddr_t		mappedbno,
+	struct xfs_buf		**bpp,
+	const struct xfs_buf_ops *ops,
+	int			*crc_error)
+{
+	int error;
+	int error2;
+
+	error = libxfs_da_read_buf(NULL, ip, bno, mappedbno, bpp,
+				   XFS_DATA_FORK, ops);
+
+	if (error != EFSBADCRC && error != EFSCORRUPTED)
+		return error;
+
+	error2 = libxfs_da_read_buf(NULL, ip, bno, mappedbno, bpp,
+				   XFS_DATA_FORK, NULL);
+	if (error2)
+		return error2;
+
+	(*crc_error)++;
+	(*bpp)->b_ops = ops;
+	return 0;
+}
+
+/*
  * Returns 0 if the name already exists (ie. a duplicate)
  */
 static int
@@ -1906,15 +1945,19 @@ longform_dir2_check_leaf(
 	int			seeval;
 	struct xfs_dir2_leaf_entry *ents;
 	struct xfs_dir3_icleaf_hdr leafhdr;
+	int			error;
+	int			fixit = 0;
 
 	da_bno = mp->m_dirleafblk;
-	if (libxfs_da_read_buf(NULL, ip, da_bno, -1, &bp, XFS_DATA_FORK,
-				&xfs_dir3_leaf1_buf_ops)) {
+	error = dir_read_buf(ip, da_bno, -1, &bp, &xfs_dir3_leaf1_buf_ops,
+			     &fixit);
+	if (error) {
 		do_error(
-	_("can't read block %u for directory inode %" PRIu64 "\n"),
-			da_bno, ip->i_ino);
+	_("can't read block %u for directory inode %" PRIu64 ", error %d\n"),
+			da_bno, ip->i_ino, error);
 		/* NOTREACHED */
 	}
+
 	leaf = bp->b_addr;
 	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
 	ents = xfs_dir3_leaf_ents_p(leaf);
@@ -1951,7 +1994,7 @@ longform_dir2_check_leaf(
 		return 1;
 	}
 	libxfs_putbuf(bp);
-	return 0;
+	return fixit;
 }
 
 /*
@@ -1978,6 +2021,8 @@ longform_dir2_check_node(
 	struct xfs_dir3_icleaf_hdr leafhdr;
 	struct xfs_dir3_icfree_hdr freehdr;
 	__be16			*bests;
+	int			error;
+	int			fixit = 0;
 
 	for (da_bno = mp->m_dirleafblk, next_da_bno = 0;
 			next_da_bno != NULLFILEOFF && da_bno < mp->m_dirfreeblk;
@@ -1993,11 +2038,12 @@ longform_dir2_check_node(
 		 * a node block, then we'll skip it below based on a magic
 		 * number check.
 		 */
-		if (libxfs_da_read_buf(NULL, ip, da_bno, -1, &bp,
-				XFS_DATA_FORK, &xfs_da3_node_buf_ops)) {
+		error = dir_read_buf(ip, da_bno, -1, &bp,
+				     &xfs_da3_node_buf_ops, &fixit);
+		if (error) {
 			do_warn(
-	_("can't read leaf block %u for directory inode %" PRIu64 "\n"),
-				da_bno, ip->i_ino);
+	_("can't read leaf block %u for directory inode %" PRIu64 ", error %d\n"),
+				da_bno, ip->i_ino, error);
 			return 1;
 		}
 		leaf = bp->b_addr;
@@ -2016,6 +2062,12 @@ longform_dir2_check_node(
 			libxfs_putbuf(bp);
 			return 1;
 		}
+
+		/*
+		 * If there's a validator error, we need to ensure that we got
+		 * the right ops on the buffer for when we write it back out.
+		 */
+		bp->b_ops = &xfs_dir3_leafn_buf_ops;
 		if (leafhdr.count > xfs_dir3_max_leaf_ents(mp, leaf) ||
 		    leafhdr.count < leafhdr.stale) {
 			do_warn(
@@ -2039,11 +2091,13 @@ longform_dir2_check_node(
 		next_da_bno = da_bno + mp->m_dirblkfsbs - 1;
 		if (bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK))
 			break;
-		if (libxfs_da_read_buf(NULL, ip, da_bno, -1, &bp,
-				XFS_DATA_FORK, &xfs_dir3_free_buf_ops)) {
+
+		error = dir_read_buf(ip, da_bno, -1, &bp,
+				     &xfs_dir3_free_buf_ops, &fixit);
+		if (error) {
 			do_warn(
-	_("can't read freespace block %u for directory inode %" PRIu64 "\n"),
-				da_bno, ip->i_ino);
+	_("can't read freespace block %u for directory inode %" PRIu64 ", error %d\n"),
+				da_bno, ip->i_ino, error);
 			return 1;
 		}
 		free = bp->b_addr;
@@ -2093,7 +2147,7 @@ longform_dir2_check_node(
 			return 1;
 		}
 	}
-	return 0;
+	return fixit;
 }
 
 /*
@@ -2148,6 +2202,7 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 	     next_da_bno != NULLFILEOFF && da_bno < mp->m_dirleafblk;
 	     da_bno = (xfs_dablk_t)next_da_bno) {
 		const struct xfs_buf_ops *ops;
+		int			 error;
 
 		next_da_bno = da_bno + mp->m_dirblkfsbs - 1;
 		if (bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK))
@@ -2167,11 +2222,12 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 			ops = &xfs_dir3_block_buf_ops;
 		else
 			ops = &xfs_dir3_data_buf_ops;
-		if (libxfs_da_read_buf(NULL, ip, da_bno, -1, &bplist[db],
-				       XFS_DATA_FORK, ops)) {
+
+		error = dir_read_buf(ip, da_bno, -1, &bplist[db], ops, &fixit);
+		if (error) {
 			do_warn(
-	_("can't read data block %u for directory inode %" PRIu64 "\n"),
-				da_bno, ino);
+	_("can't read data block %u for directory inode %" PRIu64 " error %d\n"),
+				da_bno, ino, error);
 			*num_illegal += 1;
 
 			/*
@@ -2189,7 +2245,7 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 				irec, ino_offset, &bplist[db], hashtab,
 				&freetab, da_bno, isblock);
 	}
-	fixit = (*num_illegal != 0) || dir2_is_badino(ino) || *need_dot;
+	fixit |= (*num_illegal != 0) || dir2_is_badino(ino) || *need_dot;
 
 	if (!dotdot_update) {
 		/* check btree and freespace */
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
