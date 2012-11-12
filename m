Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qACBs33D217944 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 05:54:04 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	udr6u0obbbinEwVS for <xfs@oss.sgi.com>;
	Mon, 12 Nov 2012 03:56:04 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TXsbm-00054w-Rm
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 22:55:18 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TXsbm-00013y-OU
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 22:55:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 26/32] xfs: Add verifiers to dir2 data readahead.
Date: Mon, 12 Nov 2012 22:54:18 +1100
Message-Id: <1352721264-3700-27-git-send-email-david@fromorbit.com>
In-Reply-To: <1352721264-3700-1-git-send-email-david@fromorbit.com>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Phil White <pwhite@sgi.com>
---
 fs/xfs/xfs_da_btree.c  |    4 ++--
 fs/xfs/xfs_da_btree.h  |    4 ++--
 fs/xfs/xfs_dir2_data.c |   13 ++++++++++++-
 fs/xfs/xfs_dir2_leaf.c |   11 +++++------
 fs/xfs/xfs_dir2_priv.h |    2 ++
 fs/xfs/xfs_file.c      |    4 +++-
 6 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 1b84fc5..93ebc0f 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -2285,10 +2285,10 @@ xfs_da_reada_buf(
 	struct xfs_trans	*trans,
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
+	xfs_daddr_t		mappedbno,
 	int			whichfork,
 	xfs_buf_iodone_t	verifier)
 {
-	xfs_daddr_t		mappedbno = -1;
 	struct xfs_buf_map	map;
 	struct xfs_buf_map	*mapp;
 	int			nmap;
@@ -2296,7 +2296,7 @@ xfs_da_reada_buf(
 
 	mapp = &map;
 	nmap = 1;
-	error = xfs_dabuf_map(trans, dp, bno, -1, whichfork,
+	error = xfs_dabuf_map(trans, dp, bno, mappedbno, whichfork,
 				&mapp, &nmap);
 	if (error) {
 		/* mapping a hole is not an error, but we don't continue */
diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
index 2d1bec4..521b008 100644
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
@@ -231,8 +231,8 @@ int	xfs_da_read_buf(struct xfs_trans *trans, struct xfs_inode *dp,
 			       struct xfs_buf **bpp, int whichfork,
 			       xfs_buf_iodone_t verifier);
 xfs_daddr_t	xfs_da_reada_buf(struct xfs_trans *trans, struct xfs_inode *dp,
-				xfs_dablk_t bno, int whichfork,
-				xfs_buf_iodone_t verifier);
+				xfs_dablk_t bno, xfs_daddr_t mapped_bno,
+				int whichfork, xfs_buf_iodone_t verifier);
 int	xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
 					  struct xfs_buf *dead_buf);
 
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index 0ef04f1..1a43c85 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -185,7 +185,7 @@ __xfs_dir2_data_check(
 	return 0;
 }
 
-static void
+void
 xfs_dir2_data_verify(
 	struct xfs_buf		*bp)
 {
@@ -217,6 +217,17 @@ xfs_dir2_data_read(
 					XFS_DATA_FORK, xfs_dir2_data_verify);
 }
 
+int
+xfs_dir2_data_readahead(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	xfs_dablk_t		bno,
+	xfs_daddr_t		mapped_bno)
+{
+	return xfs_da_reada_buf(tp, dp, bno, mapped_bno,
+					XFS_DATA_FORK, xfs_dir2_data_verify);
+}
+
 /*
  * Given a data block and an unused entry from that block,
  * return the bestfree entry if any that corresponds to it.
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 67cc21c..8a95547 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -972,11 +972,11 @@ xfs_dir2_leaf_readbuf(
 		 */
 		if (i > mip->ra_current &&
 		    map[mip->ra_index].br_blockcount >= mp->m_dirblkfsbs) {
-			xfs_buf_readahead(mp->m_ddev_targp,
+			xfs_dir2_data_readahead(NULL, dp,
+				map[mip->ra_index].br_startoff + mip->ra_offset,
 				XFS_FSB_TO_DADDR(mp,
 					map[mip->ra_index].br_startblock +
-							mip->ra_offset),
-				(int)BTOBB(mp->m_dirblksize), NULL);
+							mip->ra_offset));
 			mip->ra_current = i;
 		}
 
@@ -985,10 +985,9 @@ xfs_dir2_leaf_readbuf(
 		 * use our mapping, but this is a very rare case.
 		 */
 		else if (i > mip->ra_current) {
-			xfs_da_reada_buf(NULL, dp,
+			xfs_dir2_data_readahead(NULL, dp,
 					map[mip->ra_index].br_startoff +
-							mip->ra_offset,
-					XFS_DATA_FORK, NULL);
+							mip->ra_offset, -1);
 			mip->ra_current = i;
 		}
 
diff --git a/fs/xfs/xfs_dir2_priv.h b/fs/xfs/xfs_dir2_priv.h
index e0b96e7..daf5d0f 100644
--- a/fs/xfs/xfs_dir2_priv.h
+++ b/fs/xfs/xfs_dir2_priv.h
@@ -48,6 +48,8 @@ extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
 extern int __xfs_dir2_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
 extern int xfs_dir2_data_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t bno, xfs_daddr_t mapped_bno, struct xfs_buf **bpp);
+extern int xfs_dir2_data_readahead(struct xfs_trans *tp, struct xfs_inode *dp,
+		xfs_dablk_t bno, xfs_daddr_t mapped_bno);
 
 extern struct xfs_dir2_data_free *
 xfs_dir2_data_freeinsert(struct xfs_dir2_data_hdr *hdr,
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f6dab7d..400b187 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -31,6 +31,8 @@
 #include "xfs_error.h"
 #include "xfs_vnodeops.h"
 #include "xfs_da_btree.h"
+#include "xfs_dir2_format.h"
+#include "xfs_dir2_priv.h"
 #include "xfs_ioctl.h"
 #include "xfs_trace.h"
 
@@ -891,7 +893,7 @@ xfs_dir_open(
 	 */
 	mode = xfs_ilock_map_shared(ip);
 	if (ip->i_d.di_nextents > 0)
-		xfs_da_reada_buf(NULL, ip, 0, XFS_DATA_FORK, NULL);
+		xfs_dir2_data_readahead(NULL, ip, 0, -1);
 	xfs_iunlock(ip, mode);
 	return 0;
 }
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
