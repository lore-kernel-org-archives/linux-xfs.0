Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 339857F53
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 03:00:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DE1CDAC003
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 01:00:01 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id IasLMdL0h6H0xT1U (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 Apr 2014 00:59:55 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WYsqv-0006GC-Hp
	for xfs@oss.sgi.com; Sat, 12 Apr 2014 07:59:53 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/9] xfs: split xfs_bmap_btalloc_nullfb
Date: Sat, 12 Apr 2014 10:01:56 +0200
Message-Id: <1397289723-26243-3-git-send-email-hch@lst.de>
In-Reply-To: <1397289723-26243-1-git-send-email-hch@lst.de>
References: <1397289723-26243-1-git-send-email-hch@lst.de>
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

Split xfs_bmap_btalloc_nullfb into one function for filestream allocations
and one for everything else that share a few helpers.  This dramatically
simplifies the control flow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap.c |  200 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 117 insertions(+), 83 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 3340f0e..d5d52df 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -3517,6 +3517,67 @@ xfs_bmap_adjacent(
 #undef ISVALID
 }
 
+static int
+xfs_bmap_longest_free_extent(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		ag,
+	xfs_extlen_t		*blen,
+	int			*notinit)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_perag	*pag;
+	xfs_extlen_t		longest;
+	int			error = 0;
+
+	pag = xfs_perag_get(mp, ag);
+	if (!pag->pagf_init) {
+		error = xfs_alloc_pagf_init(mp, tp, ag, XFS_ALLOC_FLAG_TRYLOCK);
+		if (error)
+			goto out;
+
+		if (!pag->pagf_init) {
+			*notinit = 1;
+			goto out;
+		}
+	}
+
+	longest = xfs_alloc_longest_free_extent(mp, pag);
+	if (*blen < longest)
+		*blen = longest;
+
+out:
+	xfs_perag_put(pag);
+	return error;
+}
+
+static void
+xfs_bmap_fix_args(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	xfs_extlen_t		*blen,
+	int			notinit)
+{
+	if (notinit || *blen < ap->minlen) {
+		/*
+		 * Since we did a BUF_TRYLOCK above, it is possible that
+		 * there is space for this request.
+		 */
+		args->minlen = ap->minlen;
+	} else if (*blen < args->maxlen) {
+		/*
+		 * If the best seen length is less than the request length,
+		 * use the best as the minimum.
+		 */
+		args->minlen = *blen;
+	} else {
+		/*
+		 * Otherwise we've seen an extent as big as maxlen, use that
+		 * as the minimum.
+		 */
+		args->minlen = args->maxlen;
+	}
+}
+
 STATIC int
 xfs_bmap_btalloc_nullfb(
 	struct xfs_bmalloca	*ap,
@@ -3524,109 +3585,74 @@ xfs_bmap_btalloc_nullfb(
 	xfs_extlen_t		*blen)
 {
 	struct xfs_mount	*mp = ap->ip->i_mount;
-	struct xfs_perag	*pag;
 	xfs_agnumber_t		ag, startag;
 	int			notinit = 0;
 	int			error;
 
-	if (ap->userdata && xfs_inode_is_filestream(ap->ip))
-		args->type = XFS_ALLOCTYPE_NEAR_BNO;
-	else
-		args->type = XFS_ALLOCTYPE_START_BNO;
+	args->type = XFS_ALLOCTYPE_START_BNO;
 	args->total = ap->total;
 
-	/*
-	 * Search for an allocation group with a single extent large enough
-	 * for the request.  If one isn't found, then adjust the minimum
-	 * allocation size to the largest space found.
-	 */
 	startag = ag = XFS_FSB_TO_AGNO(mp, args->fsbno);
 	if (startag == NULLAGNUMBER)
 		startag = ag = 0;
 
-	pag = xfs_perag_get(mp, ag);
 	while (*blen < args->maxlen) {
-		if (!pag->pagf_init) {
-			error = xfs_alloc_pagf_init(mp, args->tp, ag,
-						    XFS_ALLOC_FLAG_TRYLOCK);
-			if (error) {
-				xfs_perag_put(pag);
-				return error;
-			}
-		}
-
-		/*
-		 * See xfs_alloc_fix_freelist...
-		 */
-		if (pag->pagf_init) {
-			xfs_extlen_t	longest;
-			longest = xfs_alloc_longest_free_extent(mp, pag);
-			if (*blen < longest)
-				*blen = longest;
-		} else
-			notinit = 1;
-
-		if (xfs_inode_is_filestream(ap->ip) && ap->userdata) {
-			if (*blen >= args->maxlen)
-				break;
-
-			/*
-			 * If startag is an invalid AG, we've
-			 * come here once before and
-			 * xfs_filestream_new_ag picked the
-			 * best currently available.
-			 *
-			 * Don't continue looping, since we
-			 * could loop forever.
-			 */
-			if (startag == NULLAGNUMBER)
-				break;
-
-			error = xfs_filestream_new_ag(ap, &ag);
-			xfs_perag_put(pag);
-			if (error)
-				return error;
+		error = xfs_bmap_longest_free_extent(args->tp, ag, blen,
+						     &notinit);
+		if (error)
+			return error;
 
-			/* loop again to set 'blen'*/
-			startag = NULLAGNUMBER;
-			pag = xfs_perag_get(mp, ag);
-			continue;
-		}
 		if (++ag == mp->m_sb.sb_agcount)
 			ag = 0;
 		if (ag == startag)
 			break;
-		xfs_perag_put(pag);
-		pag = xfs_perag_get(mp, ag);
 	}
-	xfs_perag_put(pag);
 
-	/*
-	 * Since the above loop did a BUF_TRYLOCK, it is
-	 * possible that there is space for this request.
-	 */
-	if (notinit || *blen < ap->minlen)
-		args->minlen = ap->minlen;
-	/*
-	 * If the best seen length is less than the request
-	 * length, use the best as the minimum.
-	 */
-	else if (*blen < args->maxlen)
-		args->minlen = *blen;
-	/*
-	 * Otherwise we've seen an extent as big as maxlen,
-	 * use that as the minimum.
-	 */
-	else
-		args->minlen = args->maxlen;
+	xfs_bmap_fix_args(ap, args, blen, notinit);
+	return 0;
+}
+
+STATIC int
+xfs_bmap_btalloc_filestreams(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	xfs_extlen_t		*blen)
+{
+	struct xfs_mount	*mp = ap->ip->i_mount;
+	xfs_agnumber_t		ag;
+	int			notinit = 0;
+	int			error;
+
+	args->type = XFS_ALLOCTYPE_NEAR_BNO;
+	args->total = ap->total;
+
+	ag = XFS_FSB_TO_AGNO(mp, args->fsbno);
+	if (ag == NULLAGNUMBER)
+		ag = 0;
+
+	error = xfs_bmap_longest_free_extent(args->tp, ag, blen, &notinit);
+	if (error)
+		return error;
+
+	if (*blen < args->maxlen) {
+		error = xfs_filestream_new_ag(ap, &ag);
+		if (error)
+			return error;
+
+		error = xfs_bmap_longest_free_extent(args->tp, ag, blen,
+						     &notinit);
+		if (error)
+			return error;
+
+	}
+
+	xfs_bmap_fix_args(ap, args, blen, notinit);
 
 	/*
-	 * set the failure fallback case to look in the selected
-	 * AG as the stream may have moved.
+	 * Set the failure fallback case to look in the selected AG as stream
+	 * may have moved.
 	 */
-	if (xfs_inode_is_filestream(ap->ip))
-		ap->blkno = args->fsbno = XFS_AGB_TO_FSB(mp, ag, 0);
-
+	ap->blkno = args->fsbno = XFS_AGB_TO_FSB(mp, ag, 0);
 	return 0;
 }
 
@@ -3706,7 +3732,15 @@ xfs_bmap_btalloc(
 	args.firstblock = *ap->firstblock;
 	blen = 0;
 	if (nullfb) {
-		error = xfs_bmap_btalloc_nullfb(ap, &args, &blen);
+		/*
+		 * Search for an allocation group with a single extent large
+		 * enough for the request.  If one isn't found, then adjust
+		 * the minimum allocation size to the largest space found.
+		 */
+		if (ap->userdata && xfs_inode_is_filestream(ap->ip))
+			error = xfs_bmap_btalloc_filestreams(ap, &args, &blen);
+		else
+			error = xfs_bmap_btalloc_nullfb(ap, &args, &blen);
 		if (error)
 			return error;
 	} else if (ap->flist->xbf_low) {
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
