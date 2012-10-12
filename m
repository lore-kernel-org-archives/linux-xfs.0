Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9C5ihnm072604 for <xfs@oss.sgi.com>; Fri, 12 Oct 2012 00:44:43 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	K1FDBCzGoO5qfUzW for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 22:46:14 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TMY37-0003Zn-W6
	for xfs@oss.sgi.com; Fri, 12 Oct 2012 16:44:42 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TMY37-00056e-Rg
	for xfs@oss.sgi.com; Fri, 12 Oct 2012 16:44:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 14/23] xfs: verify dir2 block format buffers
Date: Fri, 12 Oct 2012 16:44:20 +1100
Message-Id: <1350020669-19504-15-git-send-email-david@fromorbit.com>
In-Reply-To: <1350020669-19504-1-git-send-email-david@fromorbit.com>
References: <1350020669-19504-1-git-send-email-david@fromorbit.com>
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

Add a dir2 block format read verifier. To fully verify every block
when read, call xfs_dir2_data_check() on them. Change
xfs_dir2_data_check() to do runtime checking, convert ASSERT()
checks to XFS_WANT_CORRUPTED_RETURN(), which will trigger an ASSERT
failure on debug kernels, but on production kernels will dump an
error to dmesg and return EFSCORRUPTED to the caller.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dir2_block.c |   22 +++++++++++++-
 fs/xfs/xfs_dir2_data.c  |   73 ++++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_dir2_priv.h  |    4 ++-
 3 files changed, 68 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 25ce409..57351b8 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -56,6 +56,26 @@ xfs_dir_startup(void)
 	xfs_dir_hash_dotdot = xfs_da_hashname((unsigned char *)"..", 2);
 }
 
+static void
+xfs_dir2_block_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_dir2_data_hdr *hdr = bp->b_addr;
+	int			block_ok = 0;
+
+	block_ok = hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC);
+	block_ok = block_ok && __xfs_dir2_data_check(NULL, bp) == 0;
+
+	if (!block_ok) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, hdr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	}
+
+	bp->b_iodone = NULL;
+	xfs_buf_ioend(bp, 0);
+}
+
 static int
 xfs_dir2_block_read(
 	struct xfs_trans	*tp,
@@ -65,7 +85,7 @@ xfs_dir2_block_read(
 	struct xfs_mount	*mp = dp->i_mount;
 
 	return xfs_da_read_buf(tp, dp, mp->m_dirdatablk, -1, bpp,
-					XFS_DATA_FORK, NULL);
+					XFS_DATA_FORK, xfs_dir2_block_verify);
 }
 
 static void
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index 44ffd4d..c45107d 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -34,14 +34,13 @@
 STATIC xfs_dir2_data_free_t *
 xfs_dir2_data_freefind(xfs_dir2_data_hdr_t *hdr, xfs_dir2_data_unused_t *dup);
 
-#ifdef DEBUG
 /*
  * Check the consistency of the data block.
  * The input can also be a block-format directory.
- * Pop an assert if we find anything bad.
+ * Return 0 is the buffer is good, otherwise an error.
  */
-void
-xfs_dir2_data_check(
+bool
+__xfs_dir2_data_check(
 	struct xfs_inode	*dp,		/* incore inode pointer */
 	struct xfs_buf		*bp)		/* data block's buffer */
 {
@@ -64,18 +63,23 @@ xfs_dir2_data_check(
 	int			stale;		/* count of stale leaves */
 	struct xfs_name		name;
 
-	mp = dp->i_mount;
+	mp = bp->b_target->bt_mount;
 	hdr = bp->b_addr;
 	bf = hdr->bestfree;
 	p = (char *)(hdr + 1);
 
-	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC)) {
+	switch (hdr->magic) {
+	case cpu_to_be32(XFS_DIR2_BLOCK_MAGIC):
 		btp = xfs_dir2_block_tail_p(mp, hdr);
 		lep = xfs_dir2_block_leaf_p(btp);
 		endp = (char *)lep;
-	} else {
-		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC));
+		break;
+	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
 		endp = (char *)hdr + mp->m_dirblksize;
+		break;
+	default:
+		XFS_ERROR_REPORT("Bad Magic", XFS_ERRLEVEL_LOW, mp);
+		return EFSCORRUPTED;
 	}
 
 	count = lastfree = freeseen = 0;
@@ -83,19 +87,22 @@ xfs_dir2_data_check(
 	 * Account for zero bestfree entries.
 	 */
 	if (!bf[0].length) {
-		ASSERT(!bf[0].offset);
+		XFS_WANT_CORRUPTED_RETURN(!bf[0].offset);
 		freeseen |= 1 << 0;
 	}
 	if (!bf[1].length) {
-		ASSERT(!bf[1].offset);
+		XFS_WANT_CORRUPTED_RETURN(!bf[1].offset);
 		freeseen |= 1 << 1;
 	}
 	if (!bf[2].length) {
-		ASSERT(!bf[2].offset);
+		XFS_WANT_CORRUPTED_RETURN(!bf[2].offset);
 		freeseen |= 1 << 2;
 	}
-	ASSERT(be16_to_cpu(bf[0].length) >= be16_to_cpu(bf[1].length));
-	ASSERT(be16_to_cpu(bf[1].length) >= be16_to_cpu(bf[2].length));
+
+	XFS_WANT_CORRUPTED_RETURN(be16_to_cpu(bf[0].length) >=
+						be16_to_cpu(bf[1].length));
+	XFS_WANT_CORRUPTED_RETURN(be16_to_cpu(bf[1].length) >=
+						be16_to_cpu(bf[2].length));
 	/*
 	 * Loop over the data/unused entries.
 	 */
@@ -107,17 +114,20 @@ xfs_dir2_data_check(
 		 * doesn't need to be there.
 		 */
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
-			ASSERT(lastfree == 0);
-			ASSERT(be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) ==
-			       (char *)dup - (char *)hdr);
+			XFS_WANT_CORRUPTED_RETURN(lastfree == 0);
+			XFS_WANT_CORRUPTED_RETURN(
+				be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) ==
+					       (char *)dup - (char *)hdr);
 			dfp = xfs_dir2_data_freefind(hdr, dup);
 			if (dfp) {
 				i = (int)(dfp - bf);
-				ASSERT((freeseen & (1 << i)) == 0);
+				XFS_WANT_CORRUPTED_RETURN(
+					(freeseen & (1 << i)) == 0);
 				freeseen |= 1 << i;
 			} else {
-				ASSERT(be16_to_cpu(dup->length) <=
-				       be16_to_cpu(bf[2].length));
+				XFS_WANT_CORRUPTED_RETURN(
+					be16_to_cpu(dup->length) <=
+						be16_to_cpu(bf[2].length));
 			}
 			p += be16_to_cpu(dup->length);
 			lastfree = 1;
@@ -130,10 +140,12 @@ xfs_dir2_data_check(
 		 * The linear search is crude but this is DEBUG code.
 		 */
 		dep = (xfs_dir2_data_entry_t *)p;
-		ASSERT(dep->namelen != 0);
-		ASSERT(xfs_dir_ino_validate(mp, be64_to_cpu(dep->inumber)) == 0);
-		ASSERT(be16_to_cpu(*xfs_dir2_data_entry_tag_p(dep)) ==
-		       (char *)dep - (char *)hdr);
+		XFS_WANT_CORRUPTED_RETURN(dep->namelen != 0);
+		XFS_WANT_CORRUPTED_RETURN(
+			!xfs_dir_ino_validate(mp, be64_to_cpu(dep->inumber)));
+		XFS_WANT_CORRUPTED_RETURN(
+			be16_to_cpu(*xfs_dir2_data_entry_tag_p(dep)) ==
+					       (char *)dep - (char *)hdr);
 		count++;
 		lastfree = 0;
 		if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC)) {
@@ -148,27 +160,30 @@ xfs_dir2_data_check(
 				    be32_to_cpu(lep[i].hashval) == hash)
 					break;
 			}
-			ASSERT(i < be32_to_cpu(btp->count));
+			XFS_WANT_CORRUPTED_RETURN(i < be32_to_cpu(btp->count));
 		}
 		p += xfs_dir2_data_entsize(dep->namelen);
 	}
 	/*
 	 * Need to have seen all the entries and all the bestfree slots.
 	 */
-	ASSERT(freeseen == 7);
+	XFS_WANT_CORRUPTED_RETURN(freeseen == 7);
 	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC)) {
 		for (i = stale = 0; i < be32_to_cpu(btp->count); i++) {
 			if (lep[i].address ==
 			    cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
 				stale++;
 			if (i > 0)
-				ASSERT(be32_to_cpu(lep[i].hashval) >= be32_to_cpu(lep[i - 1].hashval));
+				XFS_WANT_CORRUPTED_RETURN(
+					be32_to_cpu(lep[i].hashval) >=
+						be32_to_cpu(lep[i - 1].hashval));
 		}
-		ASSERT(count == be32_to_cpu(btp->count) - be32_to_cpu(btp->stale));
-		ASSERT(stale == be32_to_cpu(btp->stale));
+		XFS_WANT_CORRUPTED_RETURN(count ==
+			be32_to_cpu(btp->count) - be32_to_cpu(btp->stale));
+		XFS_WANT_CORRUPTED_RETURN(stale == be32_to_cpu(btp->stale));
 	}
+	return 0;
 }
-#endif
 
 /*
  * Given a data block and an unused entry from that block,
diff --git a/fs/xfs/xfs_dir2_priv.h b/fs/xfs/xfs_dir2_priv.h
index 3523d3e..e1c02ca 100644
--- a/fs/xfs/xfs_dir2_priv.h
+++ b/fs/xfs/xfs_dir2_priv.h
@@ -41,10 +41,12 @@ extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
 
 /* xfs_dir2_data.c */
 #ifdef DEBUG
-extern void xfs_dir2_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
+#define	xfs_dir2_data_check(dp,bp) __xfs_dir2_data_check(dp, bp);
 #else
 #define	xfs_dir2_data_check(dp,bp)
 #endif
+extern bool __xfs_dir2_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
+
 extern struct xfs_dir2_data_free *
 xfs_dir2_data_freeinsert(struct xfs_dir2_data_hdr *hdr,
 		struct xfs_dir2_data_unused *dup, int *loghead);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
