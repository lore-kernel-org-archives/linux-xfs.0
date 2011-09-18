Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IKfjQ2200902 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 15:41:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0283716A92EF
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 13:46:52 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	9ptzIA6JoALiIPjd for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2011 13:46:52 -0700 (PDT)
Message-Id: <20110918204143.211406288@bombadil.infradead.org>
Date: Sun, 18 Sep 2011 16:40:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 04/27] xfs: factor extent map manipulations out of xfs_bmapi
References: <20110918204040.266805129@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-bmapi-factor-map-manipulation
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
Cc: Dave Chinner <dchinner@redhat.com>

From: Dave Chinner <dchinner@redhat.com>
    
To further improve the readability of xfs_bmapi(), factor the pure
extent map manipulations out into separate functions. This removes
large blocks of logic from the xfs_bmapi() code loop and makes it
easier to see the operational logic flow for xfs_bmapi().
    
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-08-23 21:07:51.327604480 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2011-08-23 21:08:45.150646228 +0200
@@ -4249,6 +4249,107 @@ xfs_bmap_validate_ret(
 
 
 /*
+ * Trim the returned map to the required bounds
+ */
+STATIC void
+xfs_bmapi_trim_map(
+	struct xfs_bmbt_irec	*mval,
+	struct xfs_bmbt_irec	*got,
+	xfs_fileoff_t		*bno,
+	xfs_filblks_t		len,
+	xfs_fileoff_t		obno,
+	xfs_fileoff_t		end,
+	int			n,
+	int			flags)
+{
+	if ((flags & XFS_BMAPI_ENTIRE) ||
+	    got->br_startoff + got->br_blockcount <= obno) {
+		*mval = *got;
+		if (isnullstartblock(got->br_startblock))
+			mval->br_startblock = DELAYSTARTBLOCK;
+		return;
+	}
+
+	if (obno > *bno)
+		*bno = obno;
+	ASSERT((*bno >= obno) || (n == 0));
+	ASSERT(*bno < end);
+	mval->br_startoff = *bno;
+	if (isnullstartblock(got->br_startblock))
+		mval->br_startblock = DELAYSTARTBLOCK;
+	else
+		mval->br_startblock = got->br_startblock +
+					(*bno - got->br_startoff);
+	/*
+	 * Return the minimum of what we got and what we asked for for
+	 * the length.  We can use the len variable here because it is
+	 * modified below and we could have been there before coming
+	 * here if the first part of the allocation didn't overlap what
+	 * was asked for.
+	 */
+	mval->br_blockcount = XFS_FILBLKS_MIN(end - *bno,
+			got->br_blockcount - (*bno - got->br_startoff));
+	mval->br_state = got->br_state;
+	ASSERT(mval->br_blockcount <= len);
+	return;
+}
+
+/*
+ * Update and validate the extent map to return
+ */
+STATIC void
+xfs_bmapi_update_map(
+	struct xfs_bmbt_irec	**map,
+	xfs_fileoff_t		*bno,
+	xfs_filblks_t		*len,
+	xfs_fileoff_t		obno,
+	xfs_fileoff_t		end,
+	int			*n,
+	int			flags)
+{
+	xfs_bmbt_irec_t	*mval = *map;
+
+	ASSERT((flags & XFS_BMAPI_ENTIRE) ||
+	       ((mval->br_startoff + mval->br_blockcount) <= end));
+	ASSERT((flags & XFS_BMAPI_ENTIRE) || (mval->br_blockcount <= *len) ||
+	       (mval->br_startoff < obno));
+
+	*bno = mval->br_startoff + mval->br_blockcount;
+	*len = end - *bno;
+	if (*n > 0 && mval->br_startoff == mval[-1].br_startoff) {
+		/* update previous map with new information */
+		ASSERT(mval->br_startblock == mval[-1].br_startblock);
+		ASSERT(mval->br_blockcount > mval[-1].br_blockcount);
+		ASSERT(mval->br_state == mval[-1].br_state);
+		mval[-1].br_blockcount = mval->br_blockcount;
+		mval[-1].br_state = mval->br_state;
+	} else if (*n > 0 && mval->br_startblock != DELAYSTARTBLOCK &&
+		   mval[-1].br_startblock != DELAYSTARTBLOCK &&
+		   mval[-1].br_startblock != HOLESTARTBLOCK &&
+		   mval->br_startblock == mval[-1].br_startblock +
+					  mval[-1].br_blockcount &&
+		   ((flags & XFS_BMAPI_IGSTATE) ||
+			mval[-1].br_state == mval->br_state)) {
+		ASSERT(mval->br_startoff ==
+		       mval[-1].br_startoff + mval[-1].br_blockcount);
+		mval[-1].br_blockcount += mval->br_blockcount;
+	} else if (*n > 0 &&
+		   mval->br_startblock == DELAYSTARTBLOCK &&
+		   mval[-1].br_startblock == DELAYSTARTBLOCK &&
+		   mval->br_startoff ==
+		   mval[-1].br_startoff + mval[-1].br_blockcount) {
+		mval[-1].br_blockcount += mval->br_blockcount;
+		mval[-1].br_state = mval->br_state;
+	} else if (!((*n == 0) &&
+		     ((mval->br_startoff + mval->br_blockcount) <=
+		      obno))) {
+		mval++;
+		(*n)++;
+	}
+	*map = mval;
+}
+
+/*
  * Map file blocks to filesystem blocks.
  * File range is given by the bno/len pair.
  * Adds blocks to file if a write ("flags & XFS_BMAPI_WRITE" set)
@@ -4650,44 +4751,9 @@ xfs_bmapi(
 			n++;
 			continue;
 		}
-		/*
-		 * Then deal with the allocated space we found.
-		 */
-		ASSERT(ep != NULL);
-		if (!(flags & XFS_BMAPI_ENTIRE) &&
-		    (got.br_startoff + got.br_blockcount > obno)) {
-			if (obno > bno)
-				bno = obno;
-			ASSERT((bno >= obno) || (n == 0));
-			ASSERT(bno < end);
-			mval->br_startoff = bno;
-			if (isnullstartblock(got.br_startblock)) {
-				ASSERT(!wr || (flags & XFS_BMAPI_DELAY));
-				mval->br_startblock = DELAYSTARTBLOCK;
-			} else
-				mval->br_startblock =
-					got.br_startblock +
-					(bno - got.br_startoff);
-			/*
-			 * Return the minimum of what we got and what we
-			 * asked for for the length.  We can use the len
-			 * variable here because it is modified below
-			 * and we could have been there before coming
-			 * here if the first part of the allocation
-			 * didn't overlap what was asked for.
-			 */
-			mval->br_blockcount =
-				XFS_FILBLKS_MIN(end - bno, got.br_blockcount -
-					(bno - got.br_startoff));
-			mval->br_state = got.br_state;
-			ASSERT(mval->br_blockcount <= len);
-		} else {
-			*mval = got;
-			if (isnullstartblock(mval->br_startblock)) {
-				ASSERT(!wr || (flags & XFS_BMAPI_DELAY));
-				mval->br_startblock = DELAYSTARTBLOCK;
-			}
-		}
+
+		/* Deal with the allocated space we found.  */
+		xfs_bmapi_trim_map(mval, &got, &bno, len, obno, end, n, flags);
 
 		/*
 		 * Check if writing previously allocated but
@@ -4730,42 +4796,9 @@ xfs_bmapi(
 				continue;
 		}
 
-		ASSERT((flags & XFS_BMAPI_ENTIRE) ||
-		       ((mval->br_startoff + mval->br_blockcount) <= end));
-		ASSERT((flags & XFS_BMAPI_ENTIRE) ||
-		       (mval->br_blockcount <= len) ||
-		       (mval->br_startoff < obno));
-		bno = mval->br_startoff + mval->br_blockcount;
-		len = end - bno;
-		if (n > 0 && mval->br_startoff == mval[-1].br_startoff) {
-			ASSERT(mval->br_startblock == mval[-1].br_startblock);
-			ASSERT(mval->br_blockcount > mval[-1].br_blockcount);
-			ASSERT(mval->br_state == mval[-1].br_state);
-			mval[-1].br_blockcount = mval->br_blockcount;
-			mval[-1].br_state = mval->br_state;
-		} else if (n > 0 && mval->br_startblock != DELAYSTARTBLOCK &&
-			   mval[-1].br_startblock != DELAYSTARTBLOCK &&
-			   mval[-1].br_startblock != HOLESTARTBLOCK &&
-			   mval->br_startblock ==
-			   mval[-1].br_startblock + mval[-1].br_blockcount &&
-			   ((flags & XFS_BMAPI_IGSTATE) ||
-				mval[-1].br_state == mval->br_state)) {
-			ASSERT(mval->br_startoff ==
-			       mval[-1].br_startoff + mval[-1].br_blockcount);
-			mval[-1].br_blockcount += mval->br_blockcount;
-		} else if (n > 0 &&
-			   mval->br_startblock == DELAYSTARTBLOCK &&
-			   mval[-1].br_startblock == DELAYSTARTBLOCK &&
-			   mval->br_startoff ==
-			   mval[-1].br_startoff + mval[-1].br_blockcount) {
-			mval[-1].br_blockcount += mval->br_blockcount;
-			mval[-1].br_state = mval->br_state;
-		} else if (!((n == 0) &&
-			     ((mval->br_startoff + mval->br_blockcount) <=
-			      obno))) {
-			mval++;
-			n++;
-		}
+		/* update the extent map to return */
+		xfs_bmapi_update_map(&mval, &bno, &len, obno, end, &n, flags);
+
 		/*
 		 * If we're done, stop now.  Stop when we've allocated
 		 * XFS_BMAP_MAX_NMAP extents no matter what.  Otherwise

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
