Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BDD7E7FF0
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 00:41:32 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 93CE730406A
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 22:41:32 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	M7g6GzoAqpjMDmn1 for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 22:41:27 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VgU8O-0005bR-0H
	for xfs@oss.sgi.com; Wed, 13 Nov 2013 17:41:04 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VgU8N-0006hy-VU
	for xfs@oss.sgi.com; Wed, 13 Nov 2013 17:41:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/36] libxfs: xfs_rtalloc.c becomes xfs_rtbitmap.c
Date: Wed, 13 Nov 2013 17:40:32 +1100
Message-Id: <1384324860-25677-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1384324860-25677-1-git-send-email-david@fromorbit.com>
References: <1384324860-25677-1-git-send-email-david@fromorbit.com>
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

To match the split-up of the kernel xfs_rtalloc.c file, convert the
libxfs version of xfs_rtalloc.c to match the newly shared kernel
source file with all the realtime bitmap functions in it,
xfs_rtbitmap.c.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/Makefile       |   2 +-
 libxfs/xfs_rtalloc.c  | 776 ----------------------------------------
 libxfs/xfs_rtbitmap.c | 951 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 952 insertions(+), 777 deletions(-)
 delete mode 100644 libxfs/xfs_rtalloc.c
 create mode 100644 libxfs/xfs_rtbitmap.c

diff --git a/libxfs/Makefile b/libxfs/Makefile
index 4522218..ae15a5d 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -35,7 +35,7 @@ CFILES = cache.c \
 	xfs_inode_fork.c \
 	xfs_ialloc_btree.c \
 	xfs_log_rlimit.c \
-	xfs_rtalloc.c \
+	xfs_rtbitmap.c \
 	xfs_sb.c \
 	xfs_symlink_remote.c \
 	xfs_trans_resv.c
diff --git a/libxfs/xfs_rtalloc.c b/libxfs/xfs_rtalloc.c
deleted file mode 100644
index f5a90b2..0000000
--- a/libxfs/xfs_rtalloc.c
+++ /dev/null
@@ -1,776 +0,0 @@
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-#include <xfs.h>
-
-/*
- * Prototypes for internal functions.
- */
-
-
-STATIC int xfs_rtfind_back(xfs_mount_t *, xfs_trans_t *, xfs_rtblock_t,
-		xfs_rtblock_t, xfs_rtblock_t *);
-STATIC int xfs_rtfind_forw(xfs_mount_t *, xfs_trans_t *, xfs_rtblock_t,
-		xfs_rtblock_t, xfs_rtblock_t *);
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
-	xfs_rtblock_t	postblock = 0;	/* first block freed > end */
-	xfs_rtblock_t	preblock = 0;	/* first block freed < start */
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
-	}
-	bufp = bp->b_addr;
-	/*
-	 * Compute the starting word's address, and starting bit.
-	 */
-	word = XFS_BITTOWORD(mp, start);
-	first = b = &bufp[word];
-	bit = (int)(start & (XFS_NBWORD - 1));
-	/*
-	 * 0 (allocated) => all zeroes; 1 (free) => all ones.
-	 */
-	val = -val;
-	/*
-	 * If not starting on a word boundary, deal with the first
-	 * (partial) word.
-	 */
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
-		/*
-		 * Go on to the next block if that's where the next word is
-		 * and we need the next word.
-		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
-			/*
-			 * Log the changed part of this block.
-			 * Get the next one.
-			 */
-			xfs_trans_log_buf(tp, bp,
-				(uint)((char *)first - (char *)bufp),
-				(uint)((char *)b - (char *)bufp));
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
-			if (error) {
-				return error;
-			}
-			first = b = bufp = bp->b_addr;
-			word = 0;
-		} else {
-			/*
-			 * Go on to the next word in the buffer
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
-		 * Set the word value correctly.
-		 */
-		*b = val;
-		i += XFS_NBWORD;
-		/*
-		 * Go on to the next block if that's where the next word is
-		 * and we need the next word.
-		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
-			/*
-			 * Log the changed part of this block.
-			 * Get the next one.
-			 */
-			xfs_trans_log_buf(tp, bp,
-				(uint)((char *)first - (char *)bufp),
-				(uint)((char *)b - (char *)bufp));
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
-			if (error) {
-				return error;
-			}
-			first = b = bufp = bp->b_addr;
-			word = 0;
-		} else {
-			/*
-			 * Go on to the next word in the buffer
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
-	 */
-	if (b > first)
-		xfs_trans_log_buf(tp, bp, (uint)((char *)first - (char *)bufp),
-			(uint)((char *)b - (char *)bufp - 1));
-	return 0;
-}
-
-/*
- * Read and modify the summary information for a given extent size,
- * bitmap block combination.
- * Keeps track of a current summary block, so we don't keep reading
- * it from the buffer cache.
- */
-STATIC int				/* error */
-xfs_rtmodify_summary(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	int		log,		/* log2 of extent size */
-	xfs_rtblock_t	bbno,		/* bitmap block number */
-	int		delta,		/* change to make to summary info */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
-{
-	xfs_buf_t	*bp;		/* buffer for the summary block */
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
-	 * Point to the summary information, modify and log it.
-	 */
-	sp = XFS_SUMPTR(mp, bp, so);
-	*sp += delta;
-	xfs_trans_log_buf(tp, bp, (uint)((char *)sp - (char *)bp->b_addr),
-		(uint)((char *)sp - (char *)bp->b_addr + sizeof(*sp) - 1));
-	return 0;
-}
-
-/*
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
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
new file mode 100644
index 0000000..f24b9bd
--- /dev/null
+++ b/libxfs/xfs_rtbitmap.c
@@ -0,0 +1,951 @@
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
+	xfs_buf_t	*sumbp = NULL;	/* summary file block buffer */
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
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
