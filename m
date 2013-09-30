Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 747717F53
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 22:07:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6604C8F8039
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 20:07:38 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	k10x96HSoKYEZkIB for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 20:07:31 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQTpO-0006LX-ND
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:07:18 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQTpO-0002Bx-M6
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:07:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/16] xfs: split xfs_rtalloc.c for userspace sanity
Date: Mon, 30 Sep 2013 13:07:03 +1000
Message-Id: <1380510433-8353-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510433-8353-1-git-send-email-david@fromorbit.com>
References: <1380510433-8353-1-git-send-email-david@fromorbit.com>
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

xfs_rtalloc.c is partially shared with userspace. Split the file up
into two parts - one that is kernel private and the other which is
wholly shared with userspace.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/Makefile       |    6 +-
 fs/xfs/xfs_rtalloc.c  | 1845 ++++++++++++-------------------------------------
 fs/xfs/xfs_rtalloc.h  |   24 +
 fs/xfs/xfs_rtbitmap.c |  973 ++++++++++++++++++++++++++
 4 files changed, 1446 insertions(+), 1402 deletions(-)
 create mode 100644 fs/xfs/xfs_rtbitmap.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 08f11bb..33a69fa 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -104,7 +104,11 @@ xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o \
 				   xfs_qm_bhv.o \
 				   xfs_qm.o \
 				   xfs_quotaops.o
-xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o
+
+# xfs_rtbitmap is shared with libxfs
+xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o \
+				   xfs_rtbitmap.o
+
 xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
 xfs-$(CONFIG_PROC_FS)		+= xfs_stats.o
 xfs-$(CONFIG_SYSCTL)		+= xfs_sysctl.o
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index d5da155..a6a76b2 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -37,247 +37,336 @@
 #include "xfs_buf.h"
 #include "xfs_icache.h"
 #include "xfs_dinode.h"
+#include "xfs_rtalloc.h"
 
 
 /*
- * Prototypes for internal functions.
- */
-
-
-STATIC int xfs_rtallocate_range(xfs_mount_t *, xfs_trans_t *, xfs_rtblock_t,
-		xfs_extlen_t, xfs_buf_t **, xfs_fsblock_t *);
-STATIC int xfs_rtany_summary(xfs_mount_t *, xfs_trans_t *, int, int,
-		xfs_rtblock_t, xfs_buf_t **, xfs_fsblock_t *, int *);
-STATIC int xfs_rtcheck_range(xfs_mount_t *, xfs_trans_t *, xfs_rtblock_t,
-		xfs_extlen_t, int, xfs_rtblock_t *, int *);
-STATIC int xfs_rtfind_back(xfs_mount_t *, xfs_trans_t *, xfs_rtblock_t,
-		xfs_rtblock_t, xfs_rtblock_t *);
-STATIC int xfs_rtfind_forw(xfs_mount_t *, xfs_trans_t *, xfs_rtblock_t,
-		xfs_rtblock_t, xfs_rtblock_t *);
-STATIC int xfs_rtget_summary( xfs_mount_t *, xfs_trans_t *, int,
-		xfs_rtblock_t, xfs_buf_t **, xfs_fsblock_t *, xfs_suminfo_t *);
-STATIC int xfs_rtmodify_range(xfs_mount_t *, xfs_trans_t *, xfs_rtblock_t,
-		xfs_extlen_t, int);
-STATIC int xfs_rtmodify_summary(xfs_mount_t *, xfs_trans_t *, int,
-		xfs_rtblock_t, int, xfs_buf_t **, xfs_fsblock_t *);
-
-/*
- * Internal functions.
- */
-
-/*
- * Allocate space to the bitmap or summary file, and zero it, for growfs.
+ * Read and return the summary information for a given extent size,
+ * bitmap block combination.
+ * Keeps track of a current summary block, so we don't keep reading
+ * it from the buffer cache.
  */
 STATIC int				/* error */
-xfs_growfs_rt_alloc(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_extlen_t	oblocks,	/* old count of blocks */
-	xfs_extlen_t	nblocks,	/* new count of blocks */
-	xfs_inode_t	*ip)		/* inode (bitmap/summary) */
+xfs_rtget_summary(
+	xfs_mount_t	*mp,		/* file system mount structure */
+	xfs_trans_t	*tp,		/* transaction pointer */
+	int		log,		/* log2 of extent size */
+	xfs_rtblock_t	bbno,		/* bitmap block number */
+	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
+	xfs_suminfo_t	*sum)		/* out: summary info for this block */
 {
-	xfs_fileoff_t	bno;		/* block number in file */
-	xfs_buf_t	*bp;		/* temporary buffer for zeroing */
-	int		committed;	/* transaction committed flag */
-	xfs_daddr_t	d;		/* disk block address */
-	int		error;		/* error return value */
-	xfs_fsblock_t	firstblock;	/* first block allocated in xaction */
-	xfs_bmap_free_t	flist;		/* list of freed blocks */
-	xfs_fsblock_t	fsbno;		/* filesystem block for bno */
-	xfs_bmbt_irec_t	map;		/* block map output */
-	int		nmap;		/* number of block maps */
-	int		resblks;	/* space reservation */
+	xfs_buf_t	*bp;		/* buffer for summary block */
+	int		error;		/* error value */
+	xfs_fsblock_t	sb;		/* summary fsblock */
+	int		so;		/* index into the summary file */
+	xfs_suminfo_t	*sp;		/* pointer to returned data */
 
 	/*
-	 * Allocate space to the file, as necessary.
+	 * Compute entry number in the summary file.
 	 */
-	while (oblocks < nblocks) {
-		int		cancelflags = 0;
-		xfs_trans_t	*tp;
-
-		tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFSRT_ALLOC);
-		resblks = XFS_GROWFSRT_SPACE_RES(mp, nblocks - oblocks);
-		/*
-		 * Reserve space & log for one extent added to the file.
-		 */
-		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_growdata,
-					  resblks, 0);
-		if (error)
-			goto error_cancel;
-		cancelflags = XFS_TRANS_RELEASE_LOG_RES;
-		/*
-		 * Lock the inode.
-		 */
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-
-		xfs_bmap_init(&flist, &firstblock);
-		/*
-		 * Allocate blocks to the bitmap file.
-		 */
-		nmap = 1;
-		cancelflags |= XFS_TRANS_ABORT;
-		error = xfs_bmapi_write(tp, ip, oblocks, nblocks - oblocks,
-					XFS_BMAPI_METADATA, &firstblock,
-					resblks, &map, &nmap, &flist);
-		if (!error && nmap < 1)
-			error = XFS_ERROR(ENOSPC);
-		if (error)
-			goto error_cancel;
-		/*
-		 * Free any blocks freed up in the transaction, then commit.
-		 */
-		error = xfs_bmap_finish(&tp, &flist, &committed);
-		if (error)
-			goto error_cancel;
-		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-		if (error)
-			goto error;
+	so = XFS_SUMOFFS(mp, log, bbno);
+	/*
+	 * Compute the block number in the summary file.
+	 */
+	sb = XFS_SUMOFFSTOBLOCK(mp, so);
+	/*
+	 * If we have an old buffer, and the block number matches, use that.
+	 */
+	if (rbpp && *rbpp && *rsb == sb)
+		bp = *rbpp;
+	/*
+	 * Otherwise we have to get the buffer.
+	 */
+	else {
 		/*
-		 * Now we need to clear the allocated blocks.
-		 * Do this one block per transaction, to keep it simple.
+		 * If there was an old one, get rid of it first.
 		 */
-		cancelflags = 0;
-		for (bno = map.br_startoff, fsbno = map.br_startblock;
-		     bno < map.br_startoff + map.br_blockcount;
-		     bno++, fsbno++) {
-			tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFSRT_ZERO);
-			/*
-			 * Reserve log for one block zeroing.
-			 */
-			error = xfs_trans_reserve(tp, &M_RES(mp)->tr_growrtzero,
-						  0, 0);
-			if (error)
-				goto error_cancel;
-			/*
-			 * Lock the bitmap inode.
-			 */
-			xfs_ilock(ip, XFS_ILOCK_EXCL);
-			xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-			/*
-			 * Get a buffer for the block.
-			 */
-			d = XFS_FSB_TO_DADDR(mp, fsbno);
-			bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
-				mp->m_bsize, 0);
-			if (bp == NULL) {
-				error = XFS_ERROR(EIO);
-error_cancel:
-				xfs_trans_cancel(tp, cancelflags);
-				goto error;
-			}
-			memset(bp->b_addr, 0, mp->m_sb.sb_blocksize);
-			xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
-			/*
-			 * Commit the transaction.
-			 */
-			error = xfs_trans_commit(tp, 0);
-			if (error)
-				goto error;
+		if (rbpp && *rbpp)
+			xfs_trans_brelse(tp, *rbpp);
+		error = xfs_rtbuf_get(mp, tp, sb, 1, &bp);
+		if (error) {
+			return error;
 		}
 		/*
-		 * Go on to the next extent, if any.
+		 * Remember this buffer and block for the next call.
 		 */
-		oblocks = map.br_startoff + map.br_blockcount;
+		if (rbpp) {
+			*rbpp = bp;
+			*rsb = sb;
+		}
 	}
+	/*
+	 * Point to the summary information & copy it out.
+	 */
+	sp = XFS_SUMPTR(mp, bp, so);
+	*sum = *sp;
+	/*
+	 * Drop the buffer if we're not asked to remember it.
+	 */
+	if (!rbpp)
+		xfs_trans_brelse(tp, bp);
 	return 0;
-
-error:
-	return error;
 }
 
+
 /*
- * Attempt to allocate an extent minlen<=len<=maxlen starting from
- * bitmap block bbno.  If we don't get maxlen then use prod to trim
- * the length, if given.  Returns error; returns starting block in *rtblock.
- * The lengths are all in rtextents.
+ * Return whether there are any free extents in the size range given
+ * by low and high, for the bitmap block bbno.
  */
 STATIC int				/* error */
-xfs_rtallocate_extent_block(
-	xfs_mount_t	*mp,		/* file system mount point */
+xfs_rtany_summary(
+	xfs_mount_t	*mp,		/* file system mount structure */
 	xfs_trans_t	*tp,		/* transaction pointer */
+	int		low,		/* low log2 extent size */
+	int		high,		/* high log2 extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
-	xfs_extlen_t	minlen,		/* minimum length to allocate */
-	xfs_extlen_t	maxlen,		/* maximum length to allocate */
-	xfs_extlen_t	*len,		/* out: actual length allocated */
-	xfs_rtblock_t	*nextp,		/* out: next block to try */
 	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
-	xfs_extlen_t	prod,		/* extent product factor */
-	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
+	int		*stat)		/* out: any good extents here? */
 {
-	xfs_rtblock_t	besti;		/* best rtblock found so far */
-	xfs_rtblock_t	bestlen;	/* best length found so far */
-	xfs_rtblock_t	end;		/* last rtblock in chunk */
 	int		error;		/* error value */
-	xfs_rtblock_t	i;		/* current rtblock trying */
-	xfs_rtblock_t	next;		/* next rtblock to try */
-	int		stat;		/* status from internal calls */
+	int		log;		/* loop counter, log2 of ext. size */
+	xfs_suminfo_t	sum;		/* summary data */
 
 	/*
-	 * Loop over all the extents starting in this bitmap block,
-	 * looking for one that's long enough.
+	 * Loop over logs of extent sizes.  Order is irrelevant.
 	 */
-	for (i = XFS_BLOCKTOBIT(mp, bbno), besti = -1, bestlen = 0,
-		end = XFS_BLOCKTOBIT(mp, bbno + 1) - 1;
-	     i <= end;
-	     i++) {
+	for (log = low; log <= high; log++) {
 		/*
-		 * See if there's a free extent of maxlen starting at i.
-		 * If it's not so then next will contain the first non-free.
+		 * Get one summary datum.
 		 */
-		error = xfs_rtcheck_range(mp, tp, i, maxlen, 1, &next, &stat);
+		error = xfs_rtget_summary(mp, tp, log, bbno, rbpp, rsb, &sum);
 		if (error) {
 			return error;
 		}
-		if (stat) {
-			/*
-			 * i for maxlen is all free, allocate and return that.
-			 */
-			error = xfs_rtallocate_range(mp, tp, i, maxlen, rbpp,
-				rsb);
-			if (error) {
-				return error;
-			}
-			*len = maxlen;
-			*rtblock = i;
-			return 0;
-		}
 		/*
-		 * In the case where we have a variable-sized allocation
-		 * request, figure out how big this free piece is,
-		 * and if it's big enough for the minimum, and the best
-		 * so far, remember it.
+		 * If there are any, return success.
 		 */
-		if (minlen < maxlen) {
-			xfs_rtblock_t	thislen;	/* this extent size */
-
-			thislen = next - i;
-			if (thislen >= minlen && thislen > bestlen) {
-				besti = i;
-				bestlen = thislen;
-			}
+		if (sum) {
+			*stat = 1;
+			return 0;
 		}
-		/*
-		 * If not done yet, find the start of the next free space.
-		 */
-		if (next < end) {
-			error = xfs_rtfind_forw(mp, tp, next, end, &i);
-			if (error) {
-				return error;
-			}
-		} else
-			break;
 	}
 	/*
-	 * Searched the whole thing & didn't find a maxlen free extent.
+	 * Found nothing, return failure.
 	 */
-	if (minlen < maxlen && besti != -1) {
-		xfs_extlen_t	p;	/* amount to trim length by */
+	*stat = 0;
+	return 0;
+}
 
-		/*
-		 * If size should be a multiple of prod, make that so.
-		 */
-		if (prod > 1 && (p = do_mod(bestlen, prod)))
+
+/*
+ * Copy and transform the summary file, given the old and new
+ * parameters in the mount structures.
+ */
+STATIC int				/* error */
+xfs_rtcopy_summary(
+	xfs_mount_t	*omp,		/* old file system mount point */
+	xfs_mount_t	*nmp,		/* new file system mount point */
+	xfs_trans_t	*tp)		/* transaction pointer */
+{
+	xfs_rtblock_t	bbno;		/* bitmap block number */
+	xfs_buf_t	*bp;		/* summary buffer */
+	int		error;		/* error return value */
+	int		log;		/* summary level number (log length) */
+	xfs_suminfo_t	sum;		/* summary data */
+	xfs_fsblock_t	sumbno;		/* summary block number */
+
+	bp = NULL;
+	for (log = omp->m_rsumlevels - 1; log >= 0; log--) {
+		for (bbno = omp->m_sb.sb_rbmblocks - 1;
+		     (xfs_srtblock_t)bbno >= 0;
+		     bbno--) {
+			error = xfs_rtget_summary(omp, tp, log, bbno, &bp,
+				&sumbno, &sum);
+			if (error)
+				return error;
+			if (sum == 0)
+				continue;
+			error = xfs_rtmodify_summary(omp, tp, log, bbno, -sum,
+				&bp, &sumbno);
+			if (error)
+				return error;
+			error = xfs_rtmodify_summary(nmp, tp, log, bbno, sum,
+				&bp, &sumbno);
+			if (error)
+				return error;
+			ASSERT(sum > 0);
+		}
+	}
+	return 0;
+}
+/*
+ * Mark an extent specified by start and len allocated.
+ * Updates all the summary information as well as the bitmap.
+ */
+STATIC int				/* error */
+xfs_rtallocate_range(
+	xfs_mount_t	*mp,		/* file system mount point */
+	xfs_trans_t	*tp,		/* transaction pointer */
+	xfs_rtblock_t	start,		/* start block to allocate */
+	xfs_extlen_t	len,		/* length to allocate */
+	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
+{
+	xfs_rtblock_t	end;		/* end of the allocated extent */
+	int		error;		/* error value */
+	xfs_rtblock_t	postblock = 0;	/* first block allocated > end */
+	xfs_rtblock_t	preblock = 0;	/* first block allocated < start */
+
+	end = start + len - 1;
+	/*
+	 * Assume we're allocating out of the middle of a free extent.
+	 * We need to find the beginning and end of the extent so we can
+	 * properly update the summary.
+	 */
+	error = xfs_rtfind_back(mp, tp, start, 0, &preblock);
+	if (error) {
+		return error;
+	}
+	/*
+	 * Find the next allocated block (end of free extent).
+	 */
+	error = xfs_rtfind_forw(mp, tp, end, mp->m_sb.sb_rextents - 1,
+		&postblock);
+	if (error) {
+		return error;
+	}
+	/*
+	 * Decrement the summary information corresponding to the entire
+	 * (old) free extent.
+	 */
+	error = xfs_rtmodify_summary(mp, tp,
+		XFS_RTBLOCKLOG(postblock + 1 - preblock),
+		XFS_BITTOBLOCK(mp, preblock), -1, rbpp, rsb);
+	if (error) {
+		return error;
+	}
+	/*
+	 * If there are blocks not being allocated at the front of the
+	 * old extent, add summary data for them to be free.
+	 */
+	if (preblock < start) {
+		error = xfs_rtmodify_summary(mp, tp,
+			XFS_RTBLOCKLOG(start - preblock),
+			XFS_BITTOBLOCK(mp, preblock), 1, rbpp, rsb);
+		if (error) {
+			return error;
+		}
+	}
+	/*
+	 * If there are blocks not being allocated at the end of the
+	 * old extent, add summary data for them to be free.
+	 */
+	if (postblock > end) {
+		error = xfs_rtmodify_summary(mp, tp,
+			XFS_RTBLOCKLOG(postblock - end),
+			XFS_BITTOBLOCK(mp, end + 1), 1, rbpp, rsb);
+		if (error) {
+			return error;
+		}
+	}
+	/*
+	 * Modify the bitmap to mark this extent allocated.
+	 */
+	error = xfs_rtmodify_range(mp, tp, start, len, 0);
+	return error;
+}
+
+/*
+ * Attempt to allocate an extent minlen<=len<=maxlen starting from
+ * bitmap block bbno.  If we don't get maxlen then use prod to trim
+ * the length, if given.  Returns error; returns starting block in *rtblock.
+ * The lengths are all in rtextents.
+ */
+STATIC int				/* error */
+xfs_rtallocate_extent_block(
+	xfs_mount_t	*mp,		/* file system mount point */
+	xfs_trans_t	*tp,		/* transaction pointer */
+	xfs_rtblock_t	bbno,		/* bitmap block number */
+	xfs_extlen_t	minlen,		/* minimum length to allocate */
+	xfs_extlen_t	maxlen,		/* maximum length to allocate */
+	xfs_extlen_t	*len,		/* out: actual length allocated */
+	xfs_rtblock_t	*nextp,		/* out: next block to try */
+	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
+	xfs_extlen_t	prod,		/* extent product factor */
+	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
+{
+	xfs_rtblock_t	besti;		/* best rtblock found so far */
+	xfs_rtblock_t	bestlen;	/* best length found so far */
+	xfs_rtblock_t	end;		/* last rtblock in chunk */
+	int		error;		/* error value */
+	xfs_rtblock_t	i;		/* current rtblock trying */
+	xfs_rtblock_t	next;		/* next rtblock to try */
+	int		stat;		/* status from internal calls */
+
+	/*
+	 * Loop over all the extents starting in this bitmap block,
+	 * looking for one that's long enough.
+	 */
+	for (i = XFS_BLOCKTOBIT(mp, bbno), besti = -1, bestlen = 0,
+		end = XFS_BLOCKTOBIT(mp, bbno + 1) - 1;
+	     i <= end;
+	     i++) {
+		/*
+		 * See if there's a free extent of maxlen starting at i.
+		 * If it's not so then next will contain the first non-free.
+		 */
+		error = xfs_rtcheck_range(mp, tp, i, maxlen, 1, &next, &stat);
+		if (error) {
+			return error;
+		}
+		if (stat) {
+			/*
+			 * i for maxlen is all free, allocate and return that.
+			 */
+			error = xfs_rtallocate_range(mp, tp, i, maxlen, rbpp,
+				rsb);
+			if (error) {
+				return error;
+			}
+			*len = maxlen;
+			*rtblock = i;
+			return 0;
+		}
+		/*
+		 * In the case where we have a variable-sized allocation
+		 * request, figure out how big this free piece is,
+		 * and if it's big enough for the minimum, and the best
+		 * so far, remember it.
+		 */
+		if (minlen < maxlen) {
+			xfs_rtblock_t	thislen;	/* this extent size */
+
+			thislen = next - i;
+			if (thislen >= minlen && thislen > bestlen) {
+				besti = i;
+				bestlen = thislen;
+			}
+		}
+		/*
+		 * If not done yet, find the start of the next free space.
+		 */
+		if (next < end) {
+			error = xfs_rtfind_forw(mp, tp, next, end, &i);
+			if (error) {
+				return error;
+			}
+		} else
+			break;
+	}
+	/*
+	 * Searched the whole thing & didn't find a maxlen free extent.
+	 */
+	if (minlen < maxlen && besti != -1) {
+		xfs_extlen_t	p;	/* amount to trim length by */
+
+		/*
+		 * If size should be a multiple of prod, make that so.
+		 */
+		if (prod > 1 && (p = do_mod(bestlen, prod)))
 			bestlen -= p;
 		/*
 		 * Allocate besti for bestlen & return that.
@@ -638,1191 +727,205 @@ xfs_rtallocate_extent_size(
 			 */
 			if (r != NULLRTBLOCK) {
 				*rtblock = r;
-				return 0;
-			}
-			/*
-			 * If the "next block to try" returned from the
-			 * allocator is beyond the next bitmap block,
-			 * skip to that bitmap block.
-			 */
-			if (XFS_BITTOBLOCK(mp, n) > i + 1)
-				i = XFS_BITTOBLOCK(mp, n) - 1;
-		}
-	}
-	/*
-	 * Didn't find any maxlen blocks.  Try smaller ones, unless
-	 * we're asking for a fixed size extent.
-	 */
-	if (minlen > --maxlen) {
-		*rtblock = NULLRTBLOCK;
-		return 0;
-	}
-	ASSERT(minlen != 0);
-	ASSERT(maxlen != 0);
-
-	/*
-	 * Loop over sizes, from maxlen down to minlen.
-	 * This time, when we do the allocations, allow smaller ones
-	 * to succeed.
-	 */
-	for (l = xfs_highbit32(maxlen); l >= xfs_highbit32(minlen); l--) {
-		/*
-		 * Loop over all the bitmap blocks, try an allocation
-		 * starting in that block.
-		 */
-		for (i = 0; i < mp->m_sb.sb_rbmblocks; i++) {
-			/*
-			 * Get the summary information for this level/block.
-			 */
-			error =	xfs_rtget_summary(mp, tp, l, i, rbpp, rsb,
-						  &sum);
-			if (error) {
-				return error;
-			}
-			/*
-			 * If nothing there, go on to next.
-			 */
-			if (!sum)
-				continue;
-			/*
-			 * Try the allocation.  Make sure the specified
-			 * minlen/maxlen are in the possible range for
-			 * this summary level.
-			 */
-			error = xfs_rtallocate_extent_block(mp, tp, i,
-					XFS_RTMAX(minlen, 1 << l),
-					XFS_RTMIN(maxlen, (1 << (l + 1)) - 1),
-					len, &n, rbpp, rsb, prod, &r);
-			if (error) {
-				return error;
-			}
-			/*
-			 * If it worked, return that extent.
-			 */
-			if (r != NULLRTBLOCK) {
-				*rtblock = r;
-				return 0;
-			}
-			/*
-			 * If the "next block to try" returned from the
-			 * allocator is beyond the next bitmap block,
-			 * skip to that bitmap block.
-			 */
-			if (XFS_BITTOBLOCK(mp, n) > i + 1)
-				i = XFS_BITTOBLOCK(mp, n) - 1;
-		}
-	}
-	/*
-	 * Got nothing, return failure.
-	 */
-	*rtblock = NULLRTBLOCK;
-	return 0;
-}
-
-/*
- * Mark an extent specified by start and len allocated.
- * Updates all the summary information as well as the bitmap.
- */
-STATIC int				/* error */
-xfs_rtallocate_range(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	start,		/* start block to allocate */
-	xfs_extlen_t	len,		/* length to allocate */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
-{
-	xfs_rtblock_t	end;		/* end of the allocated extent */
-	int		error;		/* error value */
-	xfs_rtblock_t	postblock = 0;	/* first block allocated > end */
-	xfs_rtblock_t	preblock = 0;	/* first block allocated < start */
-
-	end = start + len - 1;
-	/*
-	 * Assume we're allocating out of the middle of a free extent.
-	 * We need to find the beginning and end of the extent so we can
-	 * properly update the summary.
-	 */
-	error = xfs_rtfind_back(mp, tp, start, 0, &preblock);
-	if (error) {
-		return error;
-	}
-	/*
-	 * Find the next allocated block (end of free extent).
-	 */
-	error = xfs_rtfind_forw(mp, tp, end, mp->m_sb.sb_rextents - 1,
-		&postblock);
-	if (error) {
-		return error;
-	}
-	/*
-	 * Decrement the summary information corresponding to the entire
-	 * (old) free extent.
-	 */
-	error = xfs_rtmodify_summary(mp, tp,
-		XFS_RTBLOCKLOG(postblock + 1 - preblock),
-		XFS_BITTOBLOCK(mp, preblock), -1, rbpp, rsb);
-	if (error) {
-		return error;
-	}
-	/*
-	 * If there are blocks not being allocated at the front of the
-	 * old extent, add summary data for them to be free.
-	 */
-	if (preblock < start) {
-		error = xfs_rtmodify_summary(mp, tp,
-			XFS_RTBLOCKLOG(start - preblock),
-			XFS_BITTOBLOCK(mp, preblock), 1, rbpp, rsb);
-		if (error) {
-			return error;
-		}
-	}
-	/*
-	 * If there are blocks not being allocated at the end of the
-	 * old extent, add summary data for them to be free.
-	 */
-	if (postblock > end) {
-		error = xfs_rtmodify_summary(mp, tp,
-			XFS_RTBLOCKLOG(postblock - end),
-			XFS_BITTOBLOCK(mp, end + 1), 1, rbpp, rsb);
-		if (error) {
-			return error;
-		}
-	}
-	/*
-	 * Modify the bitmap to mark this extent allocated.
-	 */
-	error = xfs_rtmodify_range(mp, tp, start, len, 0);
-	return error;
-}
-
-/*
- * Return whether there are any free extents in the size range given
- * by low and high, for the bitmap block bbno.
- */
-STATIC int				/* error */
-xfs_rtany_summary(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	int		low,		/* low log2 extent size */
-	int		high,		/* high log2 extent size */
-	xfs_rtblock_t	bbno,		/* bitmap block number */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
-	int		*stat)		/* out: any good extents here? */
-{
-	int		error;		/* error value */
-	int		log;		/* loop counter, log2 of ext. size */
-	xfs_suminfo_t	sum;		/* summary data */
-
-	/*
-	 * Loop over logs of extent sizes.  Order is irrelevant.
-	 */
-	for (log = low; log <= high; log++) {
-		/*
-		 * Get one summary datum.
-		 */
-		error = xfs_rtget_summary(mp, tp, log, bbno, rbpp, rsb, &sum);
-		if (error) {
-			return error;
-		}
-		/*
-		 * If there are any, return success.
-		 */
-		if (sum) {
-			*stat = 1;
-			return 0;
-		}
-	}
-	/*
-	 * Found nothing, return failure.
-	 */
-	*stat = 0;
-	return 0;
-}
-
-/*
- * Get a buffer for the bitmap or summary file block specified.
- * The buffer is returned read and locked.
- */
-STATIC int				/* error */
-xfs_rtbuf_get(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	block,		/* block number in bitmap or summary */
-	int		issum,		/* is summary not bitmap */
-	xfs_buf_t	**bpp)		/* output: buffer for the block */
-{
-	xfs_buf_t	*bp;		/* block buffer, result */
-	xfs_inode_t	*ip;		/* bitmap or summary inode */
-	xfs_bmbt_irec_t	map;
-	int		nmap = 1;
-	int		error;		/* error value */
-
-	ip = issum ? mp->m_rsumip : mp->m_rbmip;
-
-	error = xfs_bmapi_read(ip, block, 1, &map, &nmap, XFS_DATA_FORK);
-	if (error)
-		return error;
-
-	ASSERT(map.br_startblock != NULLFSBLOCK);
-	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
-				   XFS_FSB_TO_DADDR(mp, map.br_startblock),
-				   mp->m_bsize, 0, &bp, NULL);
-	if (error)
-		return error;
-	ASSERT(!xfs_buf_geterror(bp));
-	*bpp = bp;
-	return 0;
-}
-
-#ifdef DEBUG
-/*
- * Check that the given extent (block range) is allocated already.
- */
-STATIC int				/* error */
-xfs_rtcheck_alloc_range(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	bno,		/* starting block number of extent */
-	xfs_extlen_t	len,		/* length of extent */
-	int		*stat)		/* out: 1 for allocated, 0 for not */
-{
-	xfs_rtblock_t	new;		/* dummy for xfs_rtcheck_range */
-
-	return xfs_rtcheck_range(mp, tp, bno, len, 0, &new, stat);
-}
-#endif
-
-/*
- * Check that the given range is either all allocated (val = 0) or
- * all free (val = 1).
- */
-STATIC int				/* error */
-xfs_rtcheck_range(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	start,		/* starting block number of extent */
-	xfs_extlen_t	len,		/* length of extent */
-	int		val,		/* 1 for free, 0 for allocated */
-	xfs_rtblock_t	*new,		/* out: first block not matching */
-	int		*stat)		/* out: 1 for matches, 0 for not */
-{
-	xfs_rtword_t	*b;		/* current word in buffer */
-	int		bit;		/* bit number in the word */
-	xfs_rtblock_t	block;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* buf for the block */
-	xfs_rtword_t	*bufp;		/* starting word in buffer */
-	int		error;		/* error value */
-	xfs_rtblock_t	i;		/* current bit number rel. to start */
-	xfs_rtblock_t	lastbit;	/* last useful bit in word */
-	xfs_rtword_t	mask;		/* mask of relevant bits for value */
-	xfs_rtword_t	wdiff;		/* difference from wanted value */
-	int		word;		/* word number in the buffer */
-
-	/*
-	 * Compute starting bitmap block number
-	 */
-	block = XFS_BITTOBLOCK(mp, start);
-	/*
-	 * Read the bitmap block.
-	 */
-	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
-	if (error) {
-		return error;
-	}
-	bufp = bp->b_addr;
-	/*
-	 * Compute the starting word's address, and starting bit.
-	 */
-	word = XFS_BITTOWORD(mp, start);
-	b = &bufp[word];
-	bit = (int)(start & (XFS_NBWORD - 1));
-	/*
-	 * 0 (allocated) => all zero's; 1 (free) => all one's.
-	 */
-	val = -val;
-	/*
-	 * If not starting on a word boundary, deal with the first
-	 * (partial) word.
-	 */
-	if (bit) {
-		/*
-		 * Compute first bit not examined.
-		 */
-		lastbit = XFS_RTMIN(bit + len, XFS_NBWORD);
-		/*
-		 * Mask of relevant bits.
-		 */
-		mask = (((xfs_rtword_t)1 << (lastbit - bit)) - 1) << bit;
-		/*
-		 * Compute difference between actual and desired value.
-		 */
-		if ((wdiff = (*b ^ val) & mask)) {
-			/*
-			 * Different, compute first wrong bit and return.
-			 */
-			xfs_trans_brelse(tp, bp);
-			i = XFS_RTLOBIT(wdiff) - bit;
-			*new = start + i;
-			*stat = 0;
-			return 0;
-		}
-		i = lastbit - bit;
-		/*
-		 * Go on to next block if that's where the next word is
-		 * and we need the next word.
-		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
-			/*
-			 * If done with this block, get the next one.
-			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
-			if (error) {
-				return error;
-			}
-			b = bufp = bp->b_addr;
-			word = 0;
-		} else {
-			/*
-			 * Go on to the next word in the buffer.
-			 */
-			b++;
-		}
-	} else {
-		/*
-		 * Starting on a word boundary, no partial word.
-		 */
-		i = 0;
-	}
-	/*
-	 * Loop over whole words in buffers.  When we use up one buffer
-	 * we move on to the next one.
-	 */
-	while (len - i >= XFS_NBWORD) {
-		/*
-		 * Compute difference between actual and desired value.
-		 */
-		if ((wdiff = *b ^ val)) {
-			/*
-			 * Different, compute first wrong bit and return.
-			 */
-			xfs_trans_brelse(tp, bp);
-			i += XFS_RTLOBIT(wdiff);
-			*new = start + i;
-			*stat = 0;
-			return 0;
-		}
-		i += XFS_NBWORD;
-		/*
-		 * Go on to next block if that's where the next word is
-		 * and we need the next word.
-		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
-			/*
-			 * If done with this block, get the next one.
-			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
-			if (error) {
-				return error;
-			}
-			b = bufp = bp->b_addr;
-			word = 0;
-		} else {
-			/*
-			 * Go on to the next word in the buffer.
-			 */
-			b++;
-		}
-	}
-	/*
-	 * If not ending on a word boundary, deal with the last
-	 * (partial) word.
-	 */
-	if ((lastbit = len - i)) {
-		/*
-		 * Mask of relevant bits.
-		 */
-		mask = ((xfs_rtword_t)1 << lastbit) - 1;
-		/*
-		 * Compute difference between actual and desired value.
-		 */
-		if ((wdiff = (*b ^ val) & mask)) {
-			/*
-			 * Different, compute first wrong bit and return.
-			 */
-			xfs_trans_brelse(tp, bp);
-			i += XFS_RTLOBIT(wdiff);
-			*new = start + i;
-			*stat = 0;
-			return 0;
-		} else
-			i = len;
-	}
-	/*
-	 * Successful, return.
-	 */
-	xfs_trans_brelse(tp, bp);
-	*new = start + i;
-	*stat = 1;
-	return 0;
-}
-
-/*
- * Copy and transform the summary file, given the old and new
- * parameters in the mount structures.
- */
-STATIC int				/* error */
-xfs_rtcopy_summary(
-	xfs_mount_t	*omp,		/* old file system mount point */
-	xfs_mount_t	*nmp,		/* new file system mount point */
-	xfs_trans_t	*tp)		/* transaction pointer */
-{
-	xfs_rtblock_t	bbno;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* summary buffer */
-	int		error;		/* error return value */
-	int		log;		/* summary level number (log length) */
-	xfs_suminfo_t	sum;		/* summary data */
-	xfs_fsblock_t	sumbno;		/* summary block number */
-
-	bp = NULL;
-	for (log = omp->m_rsumlevels - 1; log >= 0; log--) {
-		for (bbno = omp->m_sb.sb_rbmblocks - 1;
-		     (xfs_srtblock_t)bbno >= 0;
-		     bbno--) {
-			error = xfs_rtget_summary(omp, tp, log, bbno, &bp,
-				&sumbno, &sum);
-			if (error)
-				return error;
-			if (sum == 0)
-				continue;
-			error = xfs_rtmodify_summary(omp, tp, log, bbno, -sum,
-				&bp, &sumbno);
-			if (error)
-				return error;
-			error = xfs_rtmodify_summary(nmp, tp, log, bbno, sum,
-				&bp, &sumbno);
-			if (error)
-				return error;
-			ASSERT(sum > 0);
-		}
-	}
-	return 0;
-}
-
-/*
- * Searching backward from start to limit, find the first block whose
- * allocated/free state is different from start's.
- */
-STATIC int				/* error */
-xfs_rtfind_back(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	start,		/* starting block to look at */
-	xfs_rtblock_t	limit,		/* last block to look at */
-	xfs_rtblock_t	*rtblock)	/* out: start block found */
-{
-	xfs_rtword_t	*b;		/* current word in buffer */
-	int		bit;		/* bit number in the word */
-	xfs_rtblock_t	block;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* buf for the block */
-	xfs_rtword_t	*bufp;		/* starting word in buffer */
-	int		error;		/* error value */
-	xfs_rtblock_t	firstbit;	/* first useful bit in the word */
-	xfs_rtblock_t	i;		/* current bit number rel. to start */
-	xfs_rtblock_t	len;		/* length of inspected area */
-	xfs_rtword_t	mask;		/* mask of relevant bits for value */
-	xfs_rtword_t	want;		/* mask for "good" values */
-	xfs_rtword_t	wdiff;		/* difference from wanted value */
-	int		word;		/* word number in the buffer */
-
-	/*
-	 * Compute and read in starting bitmap block for starting block.
-	 */
-	block = XFS_BITTOBLOCK(mp, start);
-	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
-	if (error) {
-		return error;
-	}
-	bufp = bp->b_addr;
-	/*
-	 * Get the first word's index & point to it.
-	 */
-	word = XFS_BITTOWORD(mp, start);
-	b = &bufp[word];
-	bit = (int)(start & (XFS_NBWORD - 1));
-	len = start - limit + 1;
-	/*
-	 * Compute match value, based on the bit at start: if 1 (free)
-	 * then all-ones, else all-zeroes.
-	 */
-	want = (*b & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
-	/*
-	 * If the starting position is not word-aligned, deal with the
-	 * partial word.
-	 */
-	if (bit < XFS_NBWORD - 1) {
-		/*
-		 * Calculate first (leftmost) bit number to look at,
-		 * and mask for all the relevant bits in this word.
-		 */
-		firstbit = XFS_RTMAX((xfs_srtblock_t)(bit - len + 1), 0);
-		mask = (((xfs_rtword_t)1 << (bit - firstbit + 1)) - 1) <<
-			firstbit;
-		/*
-		 * Calculate the difference between the value there
-		 * and what we're looking for.
-		 */
-		if ((wdiff = (*b ^ want) & mask)) {
-			/*
-			 * Different.  Mark where we are and return.
-			 */
-			xfs_trans_brelse(tp, bp);
-			i = bit - XFS_RTHIBIT(wdiff);
-			*rtblock = start - i + 1;
-			return 0;
-		}
-		i = bit - firstbit + 1;
-		/*
-		 * Go on to previous block if that's where the previous word is
-		 * and we need the previous word.
-		 */
-		if (--word == -1 && i < len) {
-			/*
-			 * If done with this block, get the previous one.
-			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, --block, 0, &bp);
-			if (error) {
-				return error;
-			}
-			bufp = bp->b_addr;
-			word = XFS_BLOCKWMASK(mp);
-			b = &bufp[word];
-		} else {
-			/*
-			 * Go on to the previous word in the buffer.
-			 */
-			b--;
-		}
-	} else {
-		/*
-		 * Starting on a word boundary, no partial word.
-		 */
-		i = 0;
-	}
-	/*
-	 * Loop over whole words in buffers.  When we use up one buffer
-	 * we move on to the previous one.
-	 */
-	while (len - i >= XFS_NBWORD) {
-		/*
-		 * Compute difference between actual and desired value.
-		 */
-		if ((wdiff = *b ^ want)) {
-			/*
-			 * Different, mark where we are and return.
-			 */
-			xfs_trans_brelse(tp, bp);
-			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
-			*rtblock = start - i + 1;
-			return 0;
-		}
-		i += XFS_NBWORD;
-		/*
-		 * Go on to previous block if that's where the previous word is
-		 * and we need the previous word.
-		 */
-		if (--word == -1 && i < len) {
-			/*
-			 * If done with this block, get the previous one.
-			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, --block, 0, &bp);
-			if (error) {
-				return error;
-			}
-			bufp = bp->b_addr;
-			word = XFS_BLOCKWMASK(mp);
-			b = &bufp[word];
-		} else {
-			/*
-			 * Go on to the previous word in the buffer.
-			 */
-			b--;
-		}
-	}
-	/*
-	 * If not ending on a word boundary, deal with the last
-	 * (partial) word.
-	 */
-	if (len - i) {
-		/*
-		 * Calculate first (leftmost) bit number to look at,
-		 * and mask for all the relevant bits in this word.
-		 */
-		firstbit = XFS_NBWORD - (len - i);
-		mask = (((xfs_rtword_t)1 << (len - i)) - 1) << firstbit;
-		/*
-		 * Compute difference between actual and desired value.
-		 */
-		if ((wdiff = (*b ^ want) & mask)) {
-			/*
-			 * Different, mark where we are and return.
-			 */
-			xfs_trans_brelse(tp, bp);
-			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
-			*rtblock = start - i + 1;
-			return 0;
-		} else
-			i = len;
-	}
-	/*
-	 * No match, return that we scanned the whole area.
-	 */
-	xfs_trans_brelse(tp, bp);
-	*rtblock = start - i + 1;
-	return 0;
-}
-
-/*
- * Searching forward from start to limit, find the first block whose
- * allocated/free state is different from start's.
- */
-STATIC int				/* error */
-xfs_rtfind_forw(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	start,		/* starting block to look at */
-	xfs_rtblock_t	limit,		/* last block to look at */
-	xfs_rtblock_t	*rtblock)	/* out: start block found */
-{
-	xfs_rtword_t	*b;		/* current word in buffer */
-	int		bit;		/* bit number in the word */
-	xfs_rtblock_t	block;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* buf for the block */
-	xfs_rtword_t	*bufp;		/* starting word in buffer */
-	int		error;		/* error value */
-	xfs_rtblock_t	i;		/* current bit number rel. to start */
-	xfs_rtblock_t	lastbit;	/* last useful bit in the word */
-	xfs_rtblock_t	len;		/* length of inspected area */
-	xfs_rtword_t	mask;		/* mask of relevant bits for value */
-	xfs_rtword_t	want;		/* mask for "good" values */
-	xfs_rtword_t	wdiff;		/* difference from wanted value */
-	int		word;		/* word number in the buffer */
-
-	/*
-	 * Compute and read in starting bitmap block for starting block.
-	 */
-	block = XFS_BITTOBLOCK(mp, start);
-	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
-	if (error) {
-		return error;
-	}
-	bufp = bp->b_addr;
-	/*
-	 * Get the first word's index & point to it.
-	 */
-	word = XFS_BITTOWORD(mp, start);
-	b = &bufp[word];
-	bit = (int)(start & (XFS_NBWORD - 1));
-	len = limit - start + 1;
-	/*
-	 * Compute match value, based on the bit at start: if 1 (free)
-	 * then all-ones, else all-zeroes.
-	 */
-	want = (*b & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
-	/*
-	 * If the starting position is not word-aligned, deal with the
-	 * partial word.
-	 */
-	if (bit) {
-		/*
-		 * Calculate last (rightmost) bit number to look at,
-		 * and mask for all the relevant bits in this word.
-		 */
-		lastbit = XFS_RTMIN(bit + len, XFS_NBWORD);
-		mask = (((xfs_rtword_t)1 << (lastbit - bit)) - 1) << bit;
-		/*
-		 * Calculate the difference between the value there
-		 * and what we're looking for.
-		 */
-		if ((wdiff = (*b ^ want) & mask)) {
-			/*
-			 * Different.  Mark where we are and return.
-			 */
-			xfs_trans_brelse(tp, bp);
-			i = XFS_RTLOBIT(wdiff) - bit;
-			*rtblock = start + i - 1;
-			return 0;
-		}
-		i = lastbit - bit;
-		/*
-		 * Go on to next block if that's where the next word is
-		 * and we need the next word.
-		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
-			/*
-			 * If done with this block, get the previous one.
-			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
-			if (error) {
-				return error;
-			}
-			b = bufp = bp->b_addr;
-			word = 0;
-		} else {
-			/*
-			 * Go on to the previous word in the buffer.
-			 */
-			b++;
-		}
-	} else {
-		/*
-		 * Starting on a word boundary, no partial word.
-		 */
-		i = 0;
-	}
-	/*
-	 * Loop over whole words in buffers.  When we use up one buffer
-	 * we move on to the next one.
-	 */
-	while (len - i >= XFS_NBWORD) {
-		/*
-		 * Compute difference between actual and desired value.
-		 */
-		if ((wdiff = *b ^ want)) {
-			/*
-			 * Different, mark where we are and return.
-			 */
-			xfs_trans_brelse(tp, bp);
-			i += XFS_RTLOBIT(wdiff);
-			*rtblock = start + i - 1;
-			return 0;
-		}
-		i += XFS_NBWORD;
-		/*
-		 * Go on to next block if that's where the next word is
-		 * and we need the next word.
-		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
-			/*
-			 * If done with this block, get the next one.
-			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
-			if (error) {
-				return error;
-			}
-			b = bufp = bp->b_addr;
-			word = 0;
-		} else {
-			/*
-			 * Go on to the next word in the buffer.
-			 */
-			b++;
-		}
-	}
-	/*
-	 * If not ending on a word boundary, deal with the last
-	 * (partial) word.
-	 */
-	if ((lastbit = len - i)) {
-		/*
-		 * Calculate mask for all the relevant bits in this word.
-		 */
-		mask = ((xfs_rtword_t)1 << lastbit) - 1;
-		/*
-		 * Compute difference between actual and desired value.
-		 */
-		if ((wdiff = (*b ^ want) & mask)) {
-			/*
-			 * Different, mark where we are and return.
-			 */
-			xfs_trans_brelse(tp, bp);
-			i += XFS_RTLOBIT(wdiff);
-			*rtblock = start + i - 1;
-			return 0;
-		} else
-			i = len;
-	}
-	/*
-	 * No match, return that we scanned the whole area.
-	 */
-	xfs_trans_brelse(tp, bp);
-	*rtblock = start + i - 1;
-	return 0;
-}
-
-/*
- * Mark an extent specified by start and len freed.
- * Updates all the summary information as well as the bitmap.
- */
-STATIC int				/* error */
-xfs_rtfree_range(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	start,		/* starting block to free */
-	xfs_extlen_t	len,		/* length to free */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
-{
-	xfs_rtblock_t	end;		/* end of the freed extent */
-	int		error;		/* error value */
-	xfs_rtblock_t	postblock;	/* first block freed > end */
-	xfs_rtblock_t	preblock;	/* first block freed < start */
-
-	end = start + len - 1;
-	/*
-	 * Modify the bitmap to mark this extent freed.
-	 */
-	error = xfs_rtmodify_range(mp, tp, start, len, 1);
-	if (error) {
-		return error;
-	}
-	/*
-	 * Assume we're freeing out of the middle of an allocated extent.
-	 * We need to find the beginning and end of the extent so we can
-	 * properly update the summary.
-	 */
-	error = xfs_rtfind_back(mp, tp, start, 0, &preblock);
-	if (error) {
-		return error;
-	}
-	/*
-	 * Find the next allocated block (end of allocated extent).
-	 */
-	error = xfs_rtfind_forw(mp, tp, end, mp->m_sb.sb_rextents - 1,
-		&postblock);
-	if (error)
-		return error;
-	/*
-	 * If there are blocks not being freed at the front of the
-	 * old extent, add summary data for them to be allocated.
-	 */
-	if (preblock < start) {
-		error = xfs_rtmodify_summary(mp, tp,
-			XFS_RTBLOCKLOG(start - preblock),
-			XFS_BITTOBLOCK(mp, preblock), -1, rbpp, rsb);
-		if (error) {
-			return error;
-		}
-	}
-	/*
-	 * If there are blocks not being freed at the end of the
-	 * old extent, add summary data for them to be allocated.
-	 */
-	if (postblock > end) {
-		error = xfs_rtmodify_summary(mp, tp,
-			XFS_RTBLOCKLOG(postblock - end),
-			XFS_BITTOBLOCK(mp, end + 1), -1, rbpp, rsb);
-		if (error) {
-			return error;
-		}
-	}
-	/*
-	 * Increment the summary information corresponding to the entire
-	 * (new) free extent.
-	 */
-	error = xfs_rtmodify_summary(mp, tp,
-		XFS_RTBLOCKLOG(postblock + 1 - preblock),
-		XFS_BITTOBLOCK(mp, preblock), 1, rbpp, rsb);
-	return error;
-}
-
-/*
- * Read and return the summary information for a given extent size,
- * bitmap block combination.
- * Keeps track of a current summary block, so we don't keep reading
- * it from the buffer cache.
- */
-STATIC int				/* error */
-xfs_rtget_summary(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	int		log,		/* log2 of extent size */
-	xfs_rtblock_t	bbno,		/* bitmap block number */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
-	xfs_suminfo_t	*sum)		/* out: summary info for this block */
-{
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
-}
-
-/*
- * Set the given range of bitmap bits to the given value.
- * Do whatever I/O and logging is required.
- */
-STATIC int				/* error */
-xfs_rtmodify_range(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	start,		/* starting block to modify */
-	xfs_extlen_t	len,		/* length of extent to modify */
-	int		val)		/* 1 for free, 0 for allocated */
-{
-	xfs_rtword_t	*b;		/* current word in buffer */
-	int		bit;		/* bit number in the word */
-	xfs_rtblock_t	block;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* buf for the block */
-	xfs_rtword_t	*bufp;		/* starting word in buffer */
-	int		error;		/* error value */
-	xfs_rtword_t	*first;		/* first used word in the buffer */
-	int		i;		/* current bit number rel. to start */
-	int		lastbit;	/* last useful bit in word */
-	xfs_rtword_t	mask;		/* mask o frelevant bits for value */
-	int		word;		/* word number in the buffer */
-
-	/*
-	 * Compute starting bitmap block number.
-	 */
-	block = XFS_BITTOBLOCK(mp, start);
-	/*
-	 * Read the bitmap block, and point to its data.
-	 */
-	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
-	if (error) {
-		return error;
+				return 0;
+			}
+			/*
+			 * If the "next block to try" returned from the
+			 * allocator is beyond the next bitmap block,
+			 * skip to that bitmap block.
+			 */
+			if (XFS_BITTOBLOCK(mp, n) > i + 1)
+				i = XFS_BITTOBLOCK(mp, n) - 1;
+		}
 	}
-	bufp = bp->b_addr;
-	/*
-	 * Compute the starting word's address, and starting bit.
-	 */
-	word = XFS_BITTOWORD(mp, start);
-	first = b = &bufp[word];
-	bit = (int)(start & (XFS_NBWORD - 1));
 	/*
-	 * 0 (allocated) => all zeroes; 1 (free) => all ones.
+	 * Didn't find any maxlen blocks.  Try smaller ones, unless
+	 * we're asking for a fixed size extent.
 	 */
-	val = -val;
+	if (minlen > --maxlen) {
+		*rtblock = NULLRTBLOCK;
+		return 0;
+	}
+	ASSERT(minlen != 0);
+	ASSERT(maxlen != 0);
+
 	/*
-	 * If not starting on a word boundary, deal with the first
-	 * (partial) word.
+	 * Loop over sizes, from maxlen down to minlen.
+	 * This time, when we do the allocations, allow smaller ones
+	 * to succeed.
 	 */
-	if (bit) {
-		/*
-		 * Compute first bit not changed and mask of relevant bits.
-		 */
-		lastbit = XFS_RTMIN(bit + len, XFS_NBWORD);
-		mask = (((xfs_rtword_t)1 << (lastbit - bit)) - 1) << bit;
-		/*
-		 * Set/clear the active bits.
-		 */
-		if (val)
-			*b |= mask;
-		else
-			*b &= ~mask;
-		i = lastbit - bit;
+	for (l = xfs_highbit32(maxlen); l >= xfs_highbit32(minlen); l--) {
 		/*
-		 * Go on to the next block if that's where the next word is
-		 * and we need the next word.
+		 * Loop over all the bitmap blocks, try an allocation
+		 * starting in that block.
 		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+		for (i = 0; i < mp->m_sb.sb_rbmblocks; i++) {
 			/*
-			 * Log the changed part of this block.
-			 * Get the next one.
+			 * Get the summary information for this level/block.
 			 */
-			xfs_trans_log_buf(tp, bp,
-				(uint)((char *)first - (char *)bufp),
-				(uint)((char *)b - (char *)bufp));
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			error =	xfs_rtget_summary(mp, tp, l, i, rbpp, rsb,
+						  &sum);
 			if (error) {
 				return error;
 			}
-			first = b = bufp = bp->b_addr;
-			word = 0;
-		} else {
 			/*
-			 * Go on to the next word in the buffer
+			 * If nothing there, go on to next.
 			 */
-			b++;
-		}
-	} else {
-		/*
-		 * Starting on a word boundary, no partial word.
-		 */
-		i = 0;
-	}
-	/*
-	 * Loop over whole words in buffers.  When we use up one buffer
-	 * we move on to the next one.
-	 */
-	while (len - i >= XFS_NBWORD) {
-		/*
-		 * Set the word value correctly.
-		 */
-		*b = val;
-		i += XFS_NBWORD;
-		/*
-		 * Go on to the next block if that's where the next word is
-		 * and we need the next word.
-		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+			if (!sum)
+				continue;
 			/*
-			 * Log the changed part of this block.
-			 * Get the next one.
+			 * Try the allocation.  Make sure the specified
+			 * minlen/maxlen are in the possible range for
+			 * this summary level.
 			 */
-			xfs_trans_log_buf(tp, bp,
-				(uint)((char *)first - (char *)bufp),
-				(uint)((char *)b - (char *)bufp));
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			error = xfs_rtallocate_extent_block(mp, tp, i,
+					XFS_RTMAX(minlen, 1 << l),
+					XFS_RTMIN(maxlen, (1 << (l + 1)) - 1),
+					len, &n, rbpp, rsb, prod, &r);
 			if (error) {
 				return error;
 			}
-			first = b = bufp = bp->b_addr;
-			word = 0;
-		} else {
 			/*
-			 * Go on to the next word in the buffer
+			 * If it worked, return that extent.
+			 */
+			if (r != NULLRTBLOCK) {
+				*rtblock = r;
+				return 0;
+			}
+			/*
+			 * If the "next block to try" returned from the
+			 * allocator is beyond the next bitmap block,
+			 * skip to that bitmap block.
 			 */
-			b++;
+			if (XFS_BITTOBLOCK(mp, n) > i + 1)
+				i = XFS_BITTOBLOCK(mp, n) - 1;
 		}
 	}
 	/*
-	 * If not ending on a word boundary, deal with the last
-	 * (partial) word.
-	 */
-	if ((lastbit = len - i)) {
-		/*
-		 * Compute a mask of relevant bits.
-		 */
-		bit = 0;
-		mask = ((xfs_rtword_t)1 << lastbit) - 1;
-		/*
-		 * Set/clear the active bits.
-		 */
-		if (val)
-			*b |= mask;
-		else
-			*b &= ~mask;
-		b++;
-	}
-	/*
-	 * Log any remaining changed bytes.
+	 * Got nothing, return failure.
 	 */
-	if (b > first)
-		xfs_trans_log_buf(tp, bp, (uint)((char *)first - (char *)bufp),
-			(uint)((char *)b - (char *)bufp - 1));
+	*rtblock = NULLRTBLOCK;
 	return 0;
 }
 
 /*
- * Read and modify the summary information for a given extent size,
- * bitmap block combination.
- * Keeps track of a current summary block, so we don't keep reading
- * it from the buffer cache.
+ * Allocate space to the bitmap or summary file, and zero it, for growfs.
  */
 STATIC int				/* error */
-xfs_rtmodify_summary(
+xfs_growfs_rt_alloc(
 	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	int		log,		/* log2 of extent size */
-	xfs_rtblock_t	bbno,		/* bitmap block number */
-	int		delta,		/* change to make to summary info */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
+	xfs_extlen_t	oblocks,	/* old count of blocks */
+	xfs_extlen_t	nblocks,	/* new count of blocks */
+	xfs_inode_t	*ip)		/* inode (bitmap/summary) */
 {
-	xfs_buf_t	*bp;		/* buffer for the summary block */
-	int		error;		/* error value */
-	xfs_fsblock_t	sb;		/* summary fsblock */
-	int		so;		/* index into the summary file */
-	xfs_suminfo_t	*sp;		/* pointer to returned data */
+	xfs_fileoff_t	bno;		/* block number in file */
+	xfs_buf_t	*bp;		/* temporary buffer for zeroing */
+	int		committed;	/* transaction committed flag */
+	xfs_daddr_t	d;		/* disk block address */
+	int		error;		/* error return value */
+	xfs_fsblock_t	firstblock;	/* first block allocated in xaction */
+	xfs_bmap_free_t	flist;		/* list of freed blocks */
+	xfs_fsblock_t	fsbno;		/* filesystem block for bno */
+	xfs_bmbt_irec_t	map;		/* block map output */
+	int		nmap;		/* number of block maps */
+	int		resblks;	/* space reservation */
 
 	/*
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
+	 * Allocate space to the file, as necessary.
 	 */
-	else {
+	while (oblocks < nblocks) {
+		int		cancelflags = 0;
+		xfs_trans_t	*tp;
+
+		tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFSRT_ALLOC);
+		resblks = XFS_GROWFSRT_SPACE_RES(mp, nblocks - oblocks);
 		/*
-		 * If there was an old one, get rid of it first.
+		 * Reserve space & log for one extent added to the file.
 		 */
-		if (rbpp && *rbpp)
-			xfs_trans_brelse(tp, *rbpp);
-		error = xfs_rtbuf_get(mp, tp, sb, 1, &bp);
-		if (error) {
-			return error;
-		}
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_growdata,
+					  resblks, 0);
+		if (error)
+			goto error_cancel;
+		cancelflags = XFS_TRANS_RELEASE_LOG_RES;
 		/*
-		 * Remember this buffer and block for the next call.
+		 * Lock the inode.
 		 */
-		if (rbpp) {
-			*rbpp = bp;
-			*rsb = sb;
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+		xfs_bmap_init(&flist, &firstblock);
+		/*
+		 * Allocate blocks to the bitmap file.
+		 */
+		nmap = 1;
+		cancelflags |= XFS_TRANS_ABORT;
+		error = xfs_bmapi_write(tp, ip, oblocks, nblocks - oblocks,
+					XFS_BMAPI_METADATA, &firstblock,
+					resblks, &map, &nmap, &flist);
+		if (!error && nmap < 1)
+			error = XFS_ERROR(ENOSPC);
+		if (error)
+			goto error_cancel;
+		/*
+		 * Free any blocks freed up in the transaction, then commit.
+		 */
+		error = xfs_bmap_finish(&tp, &flist, &committed);
+		if (error)
+			goto error_cancel;
+		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+		if (error)
+			goto error;
+		/*
+		 * Now we need to clear the allocated blocks.
+		 * Do this one block per transaction, to keep it simple.
+		 */
+		cancelflags = 0;
+		for (bno = map.br_startoff, fsbno = map.br_startblock;
+		     bno < map.br_startoff + map.br_blockcount;
+		     bno++, fsbno++) {
+			tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFSRT_ZERO);
+			/*
+			 * Reserve log for one block zeroing.
+			 */
+			error = xfs_trans_reserve(tp, &M_RES(mp)->tr_growrtzero,
+						  0, 0);
+			if (error)
+				goto error_cancel;
+			/*
+			 * Lock the bitmap inode.
+			 */
+			xfs_ilock(ip, XFS_ILOCK_EXCL);
+			xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+			/*
+			 * Get a buffer for the block.
+			 */
+			d = XFS_FSB_TO_DADDR(mp, fsbno);
+			bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
+				mp->m_bsize, 0);
+			if (bp == NULL) {
+				error = XFS_ERROR(EIO);
+error_cancel:
+				xfs_trans_cancel(tp, cancelflags);
+				goto error;
+			}
+			memset(bp->b_addr, 0, mp->m_sb.sb_blocksize);
+			xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
+			/*
+			 * Commit the transaction.
+			 */
+			error = xfs_trans_commit(tp, 0);
+			if (error)
+				goto error;
 		}
+		/*
+		 * Go on to the next extent, if any.
+		 */
+		oblocks = map.br_startoff + map.br_blockcount;
 	}
-	/*
-	 * Point to the summary information, modify and log it.
-	 */
-	sp = XFS_SUMPTR(mp, bp, so);
-	*sp += delta;
-	xfs_trans_log_buf(tp, bp, (uint)((char *)sp - (char *)bp->b_addr),
-		(uint)((char *)sp - (char *)bp->b_addr + sizeof(*sp) - 1));
 	return 0;
+
+error:
+	return error;
 }
 
 /*
@@ -2128,66 +1231,6 @@ xfs_rtallocate_extent(
 }
 
 /*
- * Free an extent in the realtime subvolume.  Length is expressed in
- * realtime extents, as is the block number.
- */
-int					/* error */
-xfs_rtfree_extent(
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	bno,		/* starting block number to free */
-	xfs_extlen_t	len)		/* length of extent freed */
-{
-	int		error;		/* error value */
-	xfs_mount_t	*mp;		/* file system mount structure */
-	xfs_fsblock_t	sb;		/* summary file block number */
-	xfs_buf_t	*sumbp;		/* summary file block buffer */
-
-	mp = tp->t_mountp;
-
-	ASSERT(mp->m_rbmip->i_itemp != NULL);
-	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
-
-#ifdef DEBUG
-	/*
-	 * Check to see that this whole range is currently allocated.
-	 */
-	{
-		int	stat;		/* result from checking range */
-
-		error = xfs_rtcheck_alloc_range(mp, tp, bno, len, &stat);
-		if (error) {
-			return error;
-		}
-		ASSERT(stat);
-	}
-#endif
-	sumbp = NULL;
-	/*
-	 * Free the range of realtime blocks.
-	 */
-	error = xfs_rtfree_range(mp, tp, bno, len, &sumbp, &sb);
-	if (error) {
-		return error;
-	}
-	/*
-	 * Mark more blocks free in the superblock.
-	 */
-	xfs_trans_mod_sb(tp, XFS_TRANS_SB_FREXTENTS, (long)len);
-	/*
-	 * If we've now freed all the blocks, reset the file sequence
-	 * number to 0.
-	 */
-	if (tp->t_frextents_delta + mp->m_sb.sb_frextents ==
-	    mp->m_sb.sb_rextents) {
-		if (!(mp->m_rbmip->i_d.di_flags & XFS_DIFLAG_NEWRTBM))
-			mp->m_rbmip->i_d.di_flags |= XFS_DIFLAG_NEWRTBM;
-		*(__uint64_t *)&mp->m_rbmip->i_d.di_atime = 0;
-		xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
-	}
-	return 0;
-}
-
-/*
  * Initialize realtime fields in the mount structure.
  */
 int				/* error */
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index b2a1a24..752b63d 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -95,6 +95,30 @@ xfs_growfs_rt(
 	struct xfs_mount	*mp,	/* file system mount structure */
 	xfs_growfs_rt_t		*in);	/* user supplied growfs struct */
 
+/*
+ * From xfs_rtbitmap.c
+ */
+int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
+		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
+int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
+		      xfs_rtblock_t start, xfs_extlen_t len, int val,
+		      xfs_rtblock_t *new, int *stat);
+int xfs_rtfind_back(struct xfs_mount *mp, struct xfs_trans *tp,
+		    xfs_rtblock_t start, xfs_rtblock_t limit,
+		    xfs_rtblock_t *rtblock);
+int xfs_rtfind_forw(struct xfs_mount *mp, struct xfs_trans *tp,
+		    xfs_rtblock_t start, xfs_rtblock_t limit,
+		    xfs_rtblock_t *rtblock);
+int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
+		       xfs_rtblock_t start, xfs_extlen_t len, int val);
+int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
+			 xfs_rtblock_t bbno, int delta, xfs_buf_t **rbpp,
+			 xfs_fsblock_t *rsb);
+int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
+		     xfs_rtblock_t start, xfs_extlen_t len,
+		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
+
+
 #else
 # define xfs_rtallocate_extent(t,b,min,max,l,a,f,p,rb)  (ENOSYS)
 # define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
diff --git a/fs/xfs/xfs_rtbitmap.c b/fs/xfs/xfs_rtbitmap.c
new file mode 100644
index 0000000..4c0c86c
--- /dev/null
+++ b/fs/xfs/xfs_rtbitmap.c
@@ -0,0 +1,973 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_alloc.h"
+#include "xfs_error.h"
+#include "xfs_trans.h"
+#include "xfs_trans_space.h"
+#include "xfs_trace.h"
+#include "xfs_buf.h"
+#include "xfs_icache.h"
+#include "xfs_dinode.h"
+
+
+/*
+ * Realtime allocator bitmap functions shared with userspace.
+ */
+
+/*
+ * Get a buffer for the bitmap or summary file block specified.
+ * The buffer is returned read and locked.
+ */
+int
+xfs_rtbuf_get(
+	xfs_mount_t	*mp,		/* file system mount structure */
+	xfs_trans_t	*tp,		/* transaction pointer */
+	xfs_rtblock_t	block,		/* block number in bitmap or summary */
+	int		issum,		/* is summary not bitmap */
+	xfs_buf_t	**bpp)		/* output: buffer for the block */
+{
+	xfs_buf_t	*bp;		/* block buffer, result */
+	xfs_inode_t	*ip;		/* bitmap or summary inode */
+	xfs_bmbt_irec_t	map;
+	int		nmap = 1;
+	int		error;		/* error value */
+
+	ip = issum ? mp->m_rsumip : mp->m_rbmip;
+
+	error = xfs_bmapi_read(ip, block, 1, &map, &nmap, XFS_DATA_FORK);
+	if (error)
+		return error;
+
+	ASSERT(map.br_startblock != NULLFSBLOCK);
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
+				   XFS_FSB_TO_DADDR(mp, map.br_startblock),
+				   mp->m_bsize, 0, &bp, NULL);
+	if (error)
+		return error;
+	ASSERT(!xfs_buf_geterror(bp));
+	*bpp = bp;
+	return 0;
+}
+
+/*
+ * Searching backward from start to limit, find the first block whose
+ * allocated/free state is different from start's.
+ */
+int
+xfs_rtfind_back(
+	xfs_mount_t	*mp,		/* file system mount point */
+	xfs_trans_t	*tp,		/* transaction pointer */
+	xfs_rtblock_t	start,		/* starting block to look at */
+	xfs_rtblock_t	limit,		/* last block to look at */
+	xfs_rtblock_t	*rtblock)	/* out: start block found */
+{
+	xfs_rtword_t	*b;		/* current word in buffer */
+	int		bit;		/* bit number in the word */
+	xfs_rtblock_t	block;		/* bitmap block number */
+	xfs_buf_t	*bp;		/* buf for the block */
+	xfs_rtword_t	*bufp;		/* starting word in buffer */
+	int		error;		/* error value */
+	xfs_rtblock_t	firstbit;	/* first useful bit in the word */
+	xfs_rtblock_t	i;		/* current bit number rel. to start */
+	xfs_rtblock_t	len;		/* length of inspected area */
+	xfs_rtword_t	mask;		/* mask of relevant bits for value */
+	xfs_rtword_t	want;		/* mask for "good" values */
+	xfs_rtword_t	wdiff;		/* difference from wanted value */
+	int		word;		/* word number in the buffer */
+
+	/*
+	 * Compute and read in starting bitmap block for starting block.
+	 */
+	block = XFS_BITTOBLOCK(mp, start);
+	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
+	if (error) {
+		return error;
+	}
+	bufp = bp->b_addr;
+	/*
+	 * Get the first word's index & point to it.
+	 */
+	word = XFS_BITTOWORD(mp, start);
+	b = &bufp[word];
+	bit = (int)(start & (XFS_NBWORD - 1));
+	len = start - limit + 1;
+	/*
+	 * Compute match value, based on the bit at start: if 1 (free)
+	 * then all-ones, else all-zeroes.
+	 */
+	want = (*b & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
+	/*
+	 * If the starting position is not word-aligned, deal with the
+	 * partial word.
+	 */
+	if (bit < XFS_NBWORD - 1) {
+		/*
+		 * Calculate first (leftmost) bit number to look at,
+		 * and mask for all the relevant bits in this word.
+		 */
+		firstbit = XFS_RTMAX((xfs_srtblock_t)(bit - len + 1), 0);
+		mask = (((xfs_rtword_t)1 << (bit - firstbit + 1)) - 1) <<
+			firstbit;
+		/*
+		 * Calculate the difference between the value there
+		 * and what we're looking for.
+		 */
+		if ((wdiff = (*b ^ want) & mask)) {
+			/*
+			 * Different.  Mark where we are and return.
+			 */
+			xfs_trans_brelse(tp, bp);
+			i = bit - XFS_RTHIBIT(wdiff);
+			*rtblock = start - i + 1;
+			return 0;
+		}
+		i = bit - firstbit + 1;
+		/*
+		 * Go on to previous block if that's where the previous word is
+		 * and we need the previous word.
+		 */
+		if (--word == -1 && i < len) {
+			/*
+			 * If done with this block, get the previous one.
+			 */
+			xfs_trans_brelse(tp, bp);
+			error = xfs_rtbuf_get(mp, tp, --block, 0, &bp);
+			if (error) {
+				return error;
+			}
+			bufp = bp->b_addr;
+			word = XFS_BLOCKWMASK(mp);
+			b = &bufp[word];
+		} else {
+			/*
+			 * Go on to the previous word in the buffer.
+			 */
+			b--;
+		}
+	} else {
+		/*
+		 * Starting on a word boundary, no partial word.
+		 */
+		i = 0;
+	}
+	/*
+	 * Loop over whole words in buffers.  When we use up one buffer
+	 * we move on to the previous one.
+	 */
+	while (len - i >= XFS_NBWORD) {
+		/*
+		 * Compute difference between actual and desired value.
+		 */
+		if ((wdiff = *b ^ want)) {
+			/*
+			 * Different, mark where we are and return.
+			 */
+			xfs_trans_brelse(tp, bp);
+			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
+			*rtblock = start - i + 1;
+			return 0;
+		}
+		i += XFS_NBWORD;
+		/*
+		 * Go on to previous block if that's where the previous word is
+		 * and we need the previous word.
+		 */
+		if (--word == -1 && i < len) {
+			/*
+			 * If done with this block, get the previous one.
+			 */
+			xfs_trans_brelse(tp, bp);
+			error = xfs_rtbuf_get(mp, tp, --block, 0, &bp);
+			if (error) {
+				return error;
+			}
+			bufp = bp->b_addr;
+			word = XFS_BLOCKWMASK(mp);
+			b = &bufp[word];
+		} else {
+			/*
+			 * Go on to the previous word in the buffer.
+			 */
+			b--;
+		}
+	}
+	/*
+	 * If not ending on a word boundary, deal with the last
+	 * (partial) word.
+	 */
+	if (len - i) {
+		/*
+		 * Calculate first (leftmost) bit number to look at,
+		 * and mask for all the relevant bits in this word.
+		 */
+		firstbit = XFS_NBWORD - (len - i);
+		mask = (((xfs_rtword_t)1 << (len - i)) - 1) << firstbit;
+		/*
+		 * Compute difference between actual and desired value.
+		 */
+		if ((wdiff = (*b ^ want) & mask)) {
+			/*
+			 * Different, mark where we are and return.
+			 */
+			xfs_trans_brelse(tp, bp);
+			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
+			*rtblock = start - i + 1;
+			return 0;
+		} else
+			i = len;
+	}
+	/*
+	 * No match, return that we scanned the whole area.
+	 */
+	xfs_trans_brelse(tp, bp);
+	*rtblock = start - i + 1;
+	return 0;
+}
+
+/*
+ * Searching forward from start to limit, find the first block whose
+ * allocated/free state is different from start's.
+ */
+int
+xfs_rtfind_forw(
+	xfs_mount_t	*mp,		/* file system mount point */
+	xfs_trans_t	*tp,		/* transaction pointer */
+	xfs_rtblock_t	start,		/* starting block to look at */
+	xfs_rtblock_t	limit,		/* last block to look at */
+	xfs_rtblock_t	*rtblock)	/* out: start block found */
+{
+	xfs_rtword_t	*b;		/* current word in buffer */
+	int		bit;		/* bit number in the word */
+	xfs_rtblock_t	block;		/* bitmap block number */
+	xfs_buf_t	*bp;		/* buf for the block */
+	xfs_rtword_t	*bufp;		/* starting word in buffer */
+	int		error;		/* error value */
+	xfs_rtblock_t	i;		/* current bit number rel. to start */
+	xfs_rtblock_t	lastbit;	/* last useful bit in the word */
+	xfs_rtblock_t	len;		/* length of inspected area */
+	xfs_rtword_t	mask;		/* mask of relevant bits for value */
+	xfs_rtword_t	want;		/* mask for "good" values */
+	xfs_rtword_t	wdiff;		/* difference from wanted value */
+	int		word;		/* word number in the buffer */
+
+	/*
+	 * Compute and read in starting bitmap block for starting block.
+	 */
+	block = XFS_BITTOBLOCK(mp, start);
+	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
+	if (error) {
+		return error;
+	}
+	bufp = bp->b_addr;
+	/*
+	 * Get the first word's index & point to it.
+	 */
+	word = XFS_BITTOWORD(mp, start);
+	b = &bufp[word];
+	bit = (int)(start & (XFS_NBWORD - 1));
+	len = limit - start + 1;
+	/*
+	 * Compute match value, based on the bit at start: if 1 (free)
+	 * then all-ones, else all-zeroes.
+	 */
+	want = (*b & ((xfs_rtword_t)1 << bit)) ? -1 : 0;
+	/*
+	 * If the starting position is not word-aligned, deal with the
+	 * partial word.
+	 */
+	if (bit) {
+		/*
+		 * Calculate last (rightmost) bit number to look at,
+		 * and mask for all the relevant bits in this word.
+		 */
+		lastbit = XFS_RTMIN(bit + len, XFS_NBWORD);
+		mask = (((xfs_rtword_t)1 << (lastbit - bit)) - 1) << bit;
+		/*
+		 * Calculate the difference between the value there
+		 * and what we're looking for.
+		 */
+		if ((wdiff = (*b ^ want) & mask)) {
+			/*
+			 * Different.  Mark where we are and return.
+			 */
+			xfs_trans_brelse(tp, bp);
+			i = XFS_RTLOBIT(wdiff) - bit;
+			*rtblock = start + i - 1;
+			return 0;
+		}
+		i = lastbit - bit;
+		/*
+		 * Go on to next block if that's where the next word is
+		 * and we need the next word.
+		 */
+		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+			/*
+			 * If done with this block, get the previous one.
+			 */
+			xfs_trans_brelse(tp, bp);
+			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			if (error) {
+				return error;
+			}
+			b = bufp = bp->b_addr;
+			word = 0;
+		} else {
+			/*
+			 * Go on to the previous word in the buffer.
+			 */
+			b++;
+		}
+	} else {
+		/*
+		 * Starting on a word boundary, no partial word.
+		 */
+		i = 0;
+	}
+	/*
+	 * Loop over whole words in buffers.  When we use up one buffer
+	 * we move on to the next one.
+	 */
+	while (len - i >= XFS_NBWORD) {
+		/*
+		 * Compute difference between actual and desired value.
+		 */
+		if ((wdiff = *b ^ want)) {
+			/*
+			 * Different, mark where we are and return.
+			 */
+			xfs_trans_brelse(tp, bp);
+			i += XFS_RTLOBIT(wdiff);
+			*rtblock = start + i - 1;
+			return 0;
+		}
+		i += XFS_NBWORD;
+		/*
+		 * Go on to next block if that's where the next word is
+		 * and we need the next word.
+		 */
+		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+			/*
+			 * If done with this block, get the next one.
+			 */
+			xfs_trans_brelse(tp, bp);
+			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			if (error) {
+				return error;
+			}
+			b = bufp = bp->b_addr;
+			word = 0;
+		} else {
+			/*
+			 * Go on to the next word in the buffer.
+			 */
+			b++;
+		}
+	}
+	/*
+	 * If not ending on a word boundary, deal with the last
+	 * (partial) word.
+	 */
+	if ((lastbit = len - i)) {
+		/*
+		 * Calculate mask for all the relevant bits in this word.
+		 */
+		mask = ((xfs_rtword_t)1 << lastbit) - 1;
+		/*
+		 * Compute difference between actual and desired value.
+		 */
+		if ((wdiff = (*b ^ want) & mask)) {
+			/*
+			 * Different, mark where we are and return.
+			 */
+			xfs_trans_brelse(tp, bp);
+			i += XFS_RTLOBIT(wdiff);
+			*rtblock = start + i - 1;
+			return 0;
+		} else
+			i = len;
+	}
+	/*
+	 * No match, return that we scanned the whole area.
+	 */
+	xfs_trans_brelse(tp, bp);
+	*rtblock = start + i - 1;
+	return 0;
+}
+
+/*
+ * Read and modify the summary information for a given extent size,
+ * bitmap block combination.
+ * Keeps track of a current summary block, so we don't keep reading
+ * it from the buffer cache.
+ */
+int
+xfs_rtmodify_summary(
+	xfs_mount_t	*mp,		/* file system mount point */
+	xfs_trans_t	*tp,		/* transaction pointer */
+	int		log,		/* log2 of extent size */
+	xfs_rtblock_t	bbno,		/* bitmap block number */
+	int		delta,		/* change to make to summary info */
+	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
+{
+	xfs_buf_t	*bp;		/* buffer for the summary block */
+	int		error;		/* error value */
+	xfs_fsblock_t	sb;		/* summary fsblock */
+	int		so;		/* index into the summary file */
+	xfs_suminfo_t	*sp;		/* pointer to returned data */
+
+	/*
+	 * Compute entry number in the summary file.
+	 */
+	so = XFS_SUMOFFS(mp, log, bbno);
+	/*
+	 * Compute the block number in the summary file.
+	 */
+	sb = XFS_SUMOFFSTOBLOCK(mp, so);
+	/*
+	 * If we have an old buffer, and the block number matches, use that.
+	 */
+	if (rbpp && *rbpp && *rsb == sb)
+		bp = *rbpp;
+	/*
+	 * Otherwise we have to get the buffer.
+	 */
+	else {
+		/*
+		 * If there was an old one, get rid of it first.
+		 */
+		if (rbpp && *rbpp)
+			xfs_trans_brelse(tp, *rbpp);
+		error = xfs_rtbuf_get(mp, tp, sb, 1, &bp);
+		if (error) {
+			return error;
+		}
+		/*
+		 * Remember this buffer and block for the next call.
+		 */
+		if (rbpp) {
+			*rbpp = bp;
+			*rsb = sb;
+		}
+	}
+	/*
+	 * Point to the summary information, modify and log it.
+	 */
+	sp = XFS_SUMPTR(mp, bp, so);
+	*sp += delta;
+	xfs_trans_log_buf(tp, bp, (uint)((char *)sp - (char *)bp->b_addr),
+		(uint)((char *)sp - (char *)bp->b_addr + sizeof(*sp) - 1));
+	return 0;
+}
+
+/*
+ * Set the given range of bitmap bits to the given value.
+ * Do whatever I/O and logging is required.
+ */
+int
+xfs_rtmodify_range(
+	xfs_mount_t	*mp,		/* file system mount point */
+	xfs_trans_t	*tp,		/* transaction pointer */
+	xfs_rtblock_t	start,		/* starting block to modify */
+	xfs_extlen_t	len,		/* length of extent to modify */
+	int		val)		/* 1 for free, 0 for allocated */
+{
+	xfs_rtword_t	*b;		/* current word in buffer */
+	int		bit;		/* bit number in the word */
+	xfs_rtblock_t	block;		/* bitmap block number */
+	xfs_buf_t	*bp;		/* buf for the block */
+	xfs_rtword_t	*bufp;		/* starting word in buffer */
+	int		error;		/* error value */
+	xfs_rtword_t	*first;		/* first used word in the buffer */
+	int		i;		/* current bit number rel. to start */
+	int		lastbit;	/* last useful bit in word */
+	xfs_rtword_t	mask;		/* mask o frelevant bits for value */
+	int		word;		/* word number in the buffer */
+
+	/*
+	 * Compute starting bitmap block number.
+	 */
+	block = XFS_BITTOBLOCK(mp, start);
+	/*
+	 * Read the bitmap block, and point to its data.
+	 */
+	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
+	if (error) {
+		return error;
+	}
+	bufp = bp->b_addr;
+	/*
+	 * Compute the starting word's address, and starting bit.
+	 */
+	word = XFS_BITTOWORD(mp, start);
+	first = b = &bufp[word];
+	bit = (int)(start & (XFS_NBWORD - 1));
+	/*
+	 * 0 (allocated) => all zeroes; 1 (free) => all ones.
+	 */
+	val = -val;
+	/*
+	 * If not starting on a word boundary, deal with the first
+	 * (partial) word.
+	 */
+	if (bit) {
+		/*
+		 * Compute first bit not changed and mask of relevant bits.
+		 */
+		lastbit = XFS_RTMIN(bit + len, XFS_NBWORD);
+		mask = (((xfs_rtword_t)1 << (lastbit - bit)) - 1) << bit;
+		/*
+		 * Set/clear the active bits.
+		 */
+		if (val)
+			*b |= mask;
+		else
+			*b &= ~mask;
+		i = lastbit - bit;
+		/*
+		 * Go on to the next block if that's where the next word is
+		 * and we need the next word.
+		 */
+		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+			/*
+			 * Log the changed part of this block.
+			 * Get the next one.
+			 */
+			xfs_trans_log_buf(tp, bp,
+				(uint)((char *)first - (char *)bufp),
+				(uint)((char *)b - (char *)bufp));
+			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			if (error) {
+				return error;
+			}
+			first = b = bufp = bp->b_addr;
+			word = 0;
+		} else {
+			/*
+			 * Go on to the next word in the buffer
+			 */
+			b++;
+		}
+	} else {
+		/*
+		 * Starting on a word boundary, no partial word.
+		 */
+		i = 0;
+	}
+	/*
+	 * Loop over whole words in buffers.  When we use up one buffer
+	 * we move on to the next one.
+	 */
+	while (len - i >= XFS_NBWORD) {
+		/*
+		 * Set the word value correctly.
+		 */
+		*b = val;
+		i += XFS_NBWORD;
+		/*
+		 * Go on to the next block if that's where the next word is
+		 * and we need the next word.
+		 */
+		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+			/*
+			 * Log the changed part of this block.
+			 * Get the next one.
+			 */
+			xfs_trans_log_buf(tp, bp,
+				(uint)((char *)first - (char *)bufp),
+				(uint)((char *)b - (char *)bufp));
+			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			if (error) {
+				return error;
+			}
+			first = b = bufp = bp->b_addr;
+			word = 0;
+		} else {
+			/*
+			 * Go on to the next word in the buffer
+			 */
+			b++;
+		}
+	}
+	/*
+	 * If not ending on a word boundary, deal with the last
+	 * (partial) word.
+	 */
+	if ((lastbit = len - i)) {
+		/*
+		 * Compute a mask of relevant bits.
+		 */
+		bit = 0;
+		mask = ((xfs_rtword_t)1 << lastbit) - 1;
+		/*
+		 * Set/clear the active bits.
+		 */
+		if (val)
+			*b |= mask;
+		else
+			*b &= ~mask;
+		b++;
+	}
+	/*
+	 * Log any remaining changed bytes.
+	 */
+	if (b > first)
+		xfs_trans_log_buf(tp, bp, (uint)((char *)first - (char *)bufp),
+			(uint)((char *)b - (char *)bufp - 1));
+	return 0;
+}
+
+/*
+ * Mark an extent specified by start and len freed.
+ * Updates all the summary information as well as the bitmap.
+ */
+int
+xfs_rtfree_range(
+	xfs_mount_t	*mp,		/* file system mount point */
+	xfs_trans_t	*tp,		/* transaction pointer */
+	xfs_rtblock_t	start,		/* starting block to free */
+	xfs_extlen_t	len,		/* length to free */
+	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
+{
+	xfs_rtblock_t	end;		/* end of the freed extent */
+	int		error;		/* error value */
+	xfs_rtblock_t	postblock;	/* first block freed > end */
+	xfs_rtblock_t	preblock;	/* first block freed < start */
+
+	end = start + len - 1;
+	/*
+	 * Modify the bitmap to mark this extent freed.
+	 */
+	error = xfs_rtmodify_range(mp, tp, start, len, 1);
+	if (error) {
+		return error;
+	}
+	/*
+	 * Assume we're freeing out of the middle of an allocated extent.
+	 * We need to find the beginning and end of the extent so we can
+	 * properly update the summary.
+	 */
+	error = xfs_rtfind_back(mp, tp, start, 0, &preblock);
+	if (error) {
+		return error;
+	}
+	/*
+	 * Find the next allocated block (end of allocated extent).
+	 */
+	error = xfs_rtfind_forw(mp, tp, end, mp->m_sb.sb_rextents - 1,
+		&postblock);
+	if (error)
+		return error;
+	/*
+	 * If there are blocks not being freed at the front of the
+	 * old extent, add summary data for them to be allocated.
+	 */
+	if (preblock < start) {
+		error = xfs_rtmodify_summary(mp, tp,
+			XFS_RTBLOCKLOG(start - preblock),
+			XFS_BITTOBLOCK(mp, preblock), -1, rbpp, rsb);
+		if (error) {
+			return error;
+		}
+	}
+	/*
+	 * If there are blocks not being freed at the end of the
+	 * old extent, add summary data for them to be allocated.
+	 */
+	if (postblock > end) {
+		error = xfs_rtmodify_summary(mp, tp,
+			XFS_RTBLOCKLOG(postblock - end),
+			XFS_BITTOBLOCK(mp, end + 1), -1, rbpp, rsb);
+		if (error) {
+			return error;
+		}
+	}
+	/*
+	 * Increment the summary information corresponding to the entire
+	 * (new) free extent.
+	 */
+	error = xfs_rtmodify_summary(mp, tp,
+		XFS_RTBLOCKLOG(postblock + 1 - preblock),
+		XFS_BITTOBLOCK(mp, preblock), 1, rbpp, rsb);
+	return error;
+}
+
+/*
+ * Check that the given range is either all allocated (val = 0) or
+ * all free (val = 1).
+ */
+int
+xfs_rtcheck_range(
+	xfs_mount_t	*mp,		/* file system mount point */
+	xfs_trans_t	*tp,		/* transaction pointer */
+	xfs_rtblock_t	start,		/* starting block number of extent */
+	xfs_extlen_t	len,		/* length of extent */
+	int		val,		/* 1 for free, 0 for allocated */
+	xfs_rtblock_t	*new,		/* out: first block not matching */
+	int		*stat)		/* out: 1 for matches, 0 for not */
+{
+	xfs_rtword_t	*b;		/* current word in buffer */
+	int		bit;		/* bit number in the word */
+	xfs_rtblock_t	block;		/* bitmap block number */
+	xfs_buf_t	*bp;		/* buf for the block */
+	xfs_rtword_t	*bufp;		/* starting word in buffer */
+	int		error;		/* error value */
+	xfs_rtblock_t	i;		/* current bit number rel. to start */
+	xfs_rtblock_t	lastbit;	/* last useful bit in word */
+	xfs_rtword_t	mask;		/* mask of relevant bits for value */
+	xfs_rtword_t	wdiff;		/* difference from wanted value */
+	int		word;		/* word number in the buffer */
+
+	/*
+	 * Compute starting bitmap block number
+	 */
+	block = XFS_BITTOBLOCK(mp, start);
+	/*
+	 * Read the bitmap block.
+	 */
+	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
+	if (error) {
+		return error;
+	}
+	bufp = bp->b_addr;
+	/*
+	 * Compute the starting word's address, and starting bit.
+	 */
+	word = XFS_BITTOWORD(mp, start);
+	b = &bufp[word];
+	bit = (int)(start & (XFS_NBWORD - 1));
+	/*
+	 * 0 (allocated) => all zero's; 1 (free) => all one's.
+	 */
+	val = -val;
+	/*
+	 * If not starting on a word boundary, deal with the first
+	 * (partial) word.
+	 */
+	if (bit) {
+		/*
+		 * Compute first bit not examined.
+		 */
+		lastbit = XFS_RTMIN(bit + len, XFS_NBWORD);
+		/*
+		 * Mask of relevant bits.
+		 */
+		mask = (((xfs_rtword_t)1 << (lastbit - bit)) - 1) << bit;
+		/*
+		 * Compute difference between actual and desired value.
+		 */
+		if ((wdiff = (*b ^ val) & mask)) {
+			/*
+			 * Different, compute first wrong bit and return.
+			 */
+			xfs_trans_brelse(tp, bp);
+			i = XFS_RTLOBIT(wdiff) - bit;
+			*new = start + i;
+			*stat = 0;
+			return 0;
+		}
+		i = lastbit - bit;
+		/*
+		 * Go on to next block if that's where the next word is
+		 * and we need the next word.
+		 */
+		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+			/*
+			 * If done with this block, get the next one.
+			 */
+			xfs_trans_brelse(tp, bp);
+			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			if (error) {
+				return error;
+			}
+			b = bufp = bp->b_addr;
+			word = 0;
+		} else {
+			/*
+			 * Go on to the next word in the buffer.
+			 */
+			b++;
+		}
+	} else {
+		/*
+		 * Starting on a word boundary, no partial word.
+		 */
+		i = 0;
+	}
+	/*
+	 * Loop over whole words in buffers.  When we use up one buffer
+	 * we move on to the next one.
+	 */
+	while (len - i >= XFS_NBWORD) {
+		/*
+		 * Compute difference between actual and desired value.
+		 */
+		if ((wdiff = *b ^ val)) {
+			/*
+			 * Different, compute first wrong bit and return.
+			 */
+			xfs_trans_brelse(tp, bp);
+			i += XFS_RTLOBIT(wdiff);
+			*new = start + i;
+			*stat = 0;
+			return 0;
+		}
+		i += XFS_NBWORD;
+		/*
+		 * Go on to next block if that's where the next word is
+		 * and we need the next word.
+		 */
+		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+			/*
+			 * If done with this block, get the next one.
+			 */
+			xfs_trans_brelse(tp, bp);
+			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			if (error) {
+				return error;
+			}
+			b = bufp = bp->b_addr;
+			word = 0;
+		} else {
+			/*
+			 * Go on to the next word in the buffer.
+			 */
+			b++;
+		}
+	}
+	/*
+	 * If not ending on a word boundary, deal with the last
+	 * (partial) word.
+	 */
+	if ((lastbit = len - i)) {
+		/*
+		 * Mask of relevant bits.
+		 */
+		mask = ((xfs_rtword_t)1 << lastbit) - 1;
+		/*
+		 * Compute difference between actual and desired value.
+		 */
+		if ((wdiff = (*b ^ val) & mask)) {
+			/*
+			 * Different, compute first wrong bit and return.
+			 */
+			xfs_trans_brelse(tp, bp);
+			i += XFS_RTLOBIT(wdiff);
+			*new = start + i;
+			*stat = 0;
+			return 0;
+		} else
+			i = len;
+	}
+	/*
+	 * Successful, return.
+	 */
+	xfs_trans_brelse(tp, bp);
+	*new = start + i;
+	*stat = 1;
+	return 0;
+}
+
+#ifdef DEBUG
+/*
+ * Check that the given extent (block range) is allocated already.
+ */
+STATIC int				/* error */
+xfs_rtcheck_alloc_range(
+	xfs_mount_t	*mp,		/* file system mount point */
+	xfs_trans_t	*tp,		/* transaction pointer */
+	xfs_rtblock_t	bno,		/* starting block number of extent */
+	xfs_extlen_t	len)		/* length of extent */
+{
+	xfs_rtblock_t	new;		/* dummy for xfs_rtcheck_range */
+	int		stat;
+	int		error;
+
+	error = xfs_rtcheck_range(mp, tp, bno, len, 0, &new, &stat);
+	if (error)
+		return error;
+	ASSERT(stat);
+	return 0;
+}
+#else
+#define xfs_rtcheck_alloc_range(m,t,b,l)	(0)
+#endif
+/*
+ * Free an extent in the realtime subvolume.  Length is expressed in
+ * realtime extents, as is the block number.
+ */
+int					/* error */
+xfs_rtfree_extent(
+	xfs_trans_t	*tp,		/* transaction pointer */
+	xfs_rtblock_t	bno,		/* starting block number to free */
+	xfs_extlen_t	len)		/* length of extent freed */
+{
+	int		error;		/* error value */
+	xfs_mount_t	*mp;		/* file system mount structure */
+	xfs_fsblock_t	sb;		/* summary file block number */
+	xfs_buf_t	*sumbp= NULL;	/* summary file block buffer */
+
+	mp = tp->t_mountp;
+
+	ASSERT(mp->m_rbmip->i_itemp != NULL);
+	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
+
+	error = xfs_rtcheck_alloc_range(mp, tp, bno, len);
+	if (error)
+		return error;
+
+	/*
+	 * Free the range of realtime blocks.
+	 */
+	error = xfs_rtfree_range(mp, tp, bno, len, &sumbp, &sb);
+	if (error) {
+		return error;
+	}
+	/*
+	 * Mark more blocks free in the superblock.
+	 */
+	xfs_trans_mod_sb(tp, XFS_TRANS_SB_FREXTENTS, (long)len);
+	/*
+	 * If we've now freed all the blocks, reset the file sequence
+	 * number to 0.
+	 */
+	if (tp->t_frextents_delta + mp->m_sb.sb_frextents ==
+	    mp->m_sb.sb_rextents) {
+		if (!(mp->m_rbmip->i_d.di_flags & XFS_DIFLAG_NEWRTBM))
+			mp->m_rbmip->i_d.di_flags |= XFS_DIFLAG_NEWRTBM;
+		*(__uint64_t *)&mp->m_rbmip->i_d.di_atime = 0;
+		xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
+	}
+	return 0;
+}
+
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
