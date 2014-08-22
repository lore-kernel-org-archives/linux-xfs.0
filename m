Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E91917F53
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 20:00:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 670C7AC002
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 18:00:41 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id bIToUep8HaaYneYD for <xfs@oss.sgi.com>;
	Thu, 21 Aug 2014 18:00:39 -0700 (PDT)
Message-ID: <53F6963D.9090500@sandeen.net>
Date: Thu, 21 Aug 2014 20:00:45 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 3/4] xfs: combine xfs_rtmodify_summary and xfs_rtget_summary
References: <53F6942B.80808@redhat.com>
In-Reply-To: <53F6942B.80808@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

xfs_rtmodify_summary and xfs_rtget_summary are
almost identical; fold them into
xfs_rtmodify_summary_int(), with wrappers for
each of the original calls.

The _int function modifies if a delta is passed,
and returns a summary pointer if *sum is passed.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index f4dd697..50e3b93 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -424,20 +424,24 @@ xfs_rtfind_forw(
 }
 
 /*
- * Read and modify the summary information for a given extent size,
+ * Read and/or modify the summary information for a given extent size,
  * bitmap block combination.
  * Keeps track of a current summary block, so we don't keep reading
  * it from the buffer cache.
+ *
+ * Summary information is returned in *sum if specified.
+ * If no delta is specified, returns summary only.
  */
 int
-xfs_rtmodify_summary(
-	xfs_mount_t	*mp,		/* file system mount point */
+xfs_rtmodify_summary_int(
+	xfs_mount_t	*mp,		/* file system mount structure */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	int		log,		/* log2 of extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
 	int		delta,		/* change to make to summary info */
 	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
+	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
+	xfs_suminfo_t	*sum)		/* out: summary info for this block */
 {
 	xfs_buf_t	*bp;		/* buffer for the summary block */
 	int		error;		/* error value */
@@ -480,15 +484,40 @@ xfs_rtmodify_summary(
 		}
 	}
 	/*
-	 * Point to the summary information, modify and log it.
+	 * Point to the summary information, modify/log it, and/or copy it out.
 	 */
 	sp = XFS_SUMPTR(mp, bp, so);
-	*sp += delta;
-	xfs_trans_log_buf(tp, bp, (uint)((char *)sp - (char *)bp->b_addr),
-		(uint)((char *)sp - (char *)bp->b_addr + sizeof(*sp) - 1));
+	if (delta) {
+		uint first = (uint)((char *)sp - (char *)bp->b_addr);
+
+		*sp += delta;
+		xfs_trans_log_buf(tp, bp, first, first + sizeof(*sp) - 1);
+	}
+	if (sum) {
+		/*
+		 * Drop the buffer if we're not asked to remember it.
+		 */
+		if (!rbpp)
+			xfs_trans_brelse(tp, bp);
+		*sum = *sp;
+	}
 	return 0;
 }
 
+int
+xfs_rtmodify_summary(
+	xfs_mount_t	*mp,		/* file system mount structure */
+	xfs_trans_t	*tp,		/* transaction pointer */
+	int		log,		/* log2 of extent size */
+	xfs_rtblock_t	bbno,		/* bitmap block number */
+	int		delta,		/* change to make to summary info */
+	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
+{
+	return xfs_rtmodify_summary_int(mp, tp, log, bbno,
+					delta, rbpp, rsb, NULL);
+}
+
 /*
  * Set the given range of bitmap bits to the given value.
  * Do whatever I/O and logging is required.
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 909e143..d1160cc 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -46,7 +46,7 @@
  * Keeps track of a current summary block, so we don't keep reading
  * it from the buffer cache.
  */
-STATIC int				/* error */
+int
 xfs_rtget_summary(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	xfs_trans_t	*tp,		/* transaction pointer */
@@ -56,60 +56,9 @@ xfs_rtget_summary(
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_suminfo_t	*sum)		/* out: summary info for this block */
 {
-	xfs_buf_t	*bp;		/* buffer for summary block */
-	int		error;		/* error value */
-	xfs_fsblock_t	sb;		/* summary fsblock */
-	int		so;		/* index into the summary file */
-	xfs_suminfo_t	*sp;		/* pointer to returned data */
-
-	/*
-	 * Compute entry number in the summary file.
-	 */
-	so = XFS_SUMOFFS(mp, log, bbno);
-	/*
-	 * Compute the block number in the summary file.
-	 */
-	sb = XFS_SUMOFFSTOBLOCK(mp, so);
-	/*
-	 * If we have an old buffer, and the block number matches, use that.
-	 */
-	if (rbpp && *rbpp && *rsb == sb)
-		bp = *rbpp;
-	/*
-	 * Otherwise we have to get the buffer.
-	 */
-	else {
-		/*
-		 * If there was an old one, get rid of it first.
-		 */
-		if (rbpp && *rbpp)
-			xfs_trans_brelse(tp, *rbpp);
-		error = xfs_rtbuf_get(mp, tp, sb, 1, &bp);
-		if (error) {
-			return error;
-		}
-		/*
-		 * Remember this buffer and block for the next call.
-		 */
-		if (rbpp) {
-			*rbpp = bp;
-			*rsb = sb;
-		}
-	}
-	/*
-	 * Point to the summary information & copy it out.
-	 */
-	sp = XFS_SUMPTR(mp, bp, so);
-	*sum = *sp;
-	/*
-	 * Drop the buffer if we're not asked to remember it.
-	 */
-	if (!rbpp)
-		xfs_trans_brelse(tp, bp);
-	return 0;
+	return xfs_rtmodify_summary_int(mp, tp, log, bbno, 0, rbpp, rsb, sum);
 }
 
-
 /*
  * Return whether there are any free extents in the size range given
  * by low and high, for the bitmap block bbno.
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index c642795..76c0a4a 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -111,6 +111,10 @@ int xfs_rtfind_forw(struct xfs_mount *mp, struct xfs_trans *tp,
 		    xfs_rtblock_t *rtblock);
 int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		       xfs_rtblock_t start, xfs_extlen_t len, int val);
+int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
+			     int log, xfs_rtblock_t bbno, int delta,
+			     xfs_buf_t **rbpp, xfs_fsblock_t *rsb,
+			     xfs_suminfo_t *sum);
 int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
 			 xfs_rtblock_t bbno, int delta, xfs_buf_t **rbpp,
 			 xfs_fsblock_t *rsb);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
