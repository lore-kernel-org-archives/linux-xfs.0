Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Apr 2007 00:25:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3J7PCfB006340
	for <xfs@oss.sgi.com>; Thu, 19 Apr 2007 00:25:14 -0700
Date: Thu, 19 Apr 2007 17:25:05 +1000
From: David Chinner <dgc@sgi.com>
Subject: review: allocate bmapi args
Message-ID: <20070419072505.GS48531920@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


Save some stack space (64 bytes on 32bit systems, 80 bytes on 64bit
systems) in a critical path by allocating the xfs_bmalloca_t
structure rather than putting it on the stack.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 fs/xfs/xfs_bmap.c |   62 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 33 insertions(+), 29 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_bmap.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_bmap.c	2007-04-19 13:26:49.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_bmap.c	2007-04-19 13:47:03.161553644 +1000
@@ -4710,7 +4710,7 @@ xfs_bmapi(
 	xfs_fsblock_t	abno;		/* allocated block number */
 	xfs_extlen_t	alen;		/* allocated extent length */
 	xfs_fileoff_t	aoff;		/* allocated file offset */
-	xfs_bmalloca_t	bma;		/* args for xfs_bmap_alloc */
+	xfs_bmalloca_t	*bma;		/* args for xfs_bmap_alloc */
 	xfs_btree_cur_t	*cur;		/* bmap btree cursor */
 	xfs_fileoff_t	end;		/* end of mapped file region */
 	int		eof;		/* we've hit the end of extents */
@@ -4763,6 +4763,9 @@ xfs_bmapi(
 	}
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
+	bma = kmem_zalloc(sizeof(xfs_bmalloca_t), KM_SLEEP);
+	if (!bma)
+		return XFS_ERROR(ENOMEM);
 	rt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(ifp->if_ext_max ==
@@ -4816,7 +4819,7 @@ xfs_bmapi(
 	n = 0;
 	end = bno + len;
 	obno = bno;
-	bma.ip = NULL;
+	bma->ip = NULL;
 	if (delta) {
 		delta->xed_startoff = NULLFILEOFF;
 		delta->xed_blockcount = 0;
@@ -4960,34 +4963,34 @@ xfs_bmapi(
 				 * If first time, allocate and fill in
 				 * once-only bma fields.
 				 */
-				if (bma.ip == NULL) {
-					bma.tp = tp;
-					bma.ip = ip;
-					bma.prevp = &prev;
-					bma.gotp = &got;
-					bma.total = total;
-					bma.userdata = 0;
+				if (bma->ip == NULL) {
+					bma->tp = tp;
+					bma->ip = ip;
+					bma->prevp = &prev;
+					bma->gotp = &got;
+					bma->total = total;
+					bma->userdata = 0;
 				}
 				/* Indicate if this is the first user data
 				 * in the file, or just any user data.
 				 */
 				if (!(flags & XFS_BMAPI_METADATA)) {
-					bma.userdata = (aoff == 0) ?
+					bma->userdata = (aoff == 0) ?
 						XFS_ALLOC_INITIAL_USER_DATA :
 						XFS_ALLOC_USERDATA;
 				}
 				/*
 				 * Fill in changeable bma fields.
 				 */
-				bma.eof = eof;
-				bma.firstblock = *firstblock;
-				bma.alen = alen;
-				bma.off = aoff;
-				bma.conv = !!(flags & XFS_BMAPI_CONVERT);
-				bma.wasdel = wasdelay;
-				bma.minlen = minlen;
-				bma.low = flist->xbf_low;
-				bma.minleft = minleft;
+				bma->eof = eof;
+				bma->firstblock = *firstblock;
+				bma->alen = alen;
+				bma->off = aoff;
+				bma->conv = !!(flags & XFS_BMAPI_CONVERT);
+				bma->wasdel = wasdelay;
+				bma->minlen = minlen;
+				bma->low = flist->xbf_low;
+				bma->minleft = minleft;
 				/*
 				 * Only want to do the alignment at the
 				 * eof if it is userdata and allocation length
@@ -4997,30 +5000,30 @@ xfs_bmapi(
 				    (!(flags & XFS_BMAPI_METADATA)) &&
 				    (whichfork == XFS_DATA_FORK)) {
 					if ((error = xfs_bmap_isaeof(ip, aoff,
-							whichfork, &bma.aeof)))
+							whichfork, &bma->aeof)))
 						goto error0;
 				} else
-					bma.aeof = 0;
+					bma->aeof = 0;
 				/*
 				 * Call allocator.
 				 */
-				if ((error = xfs_bmap_alloc(&bma)))
+				if ((error = xfs_bmap_alloc(bma)))
 					goto error0;
 				/*
 				 * Copy out result fields.
 				 */
-				abno = bma.rval;
-				if ((flist->xbf_low = bma.low))
+				abno = bma->rval;
+				if ((flist->xbf_low = bma->low))
 					minleft = 0;
-				alen = bma.alen;
-				aoff = bma.off;
+				alen = bma->alen;
+				aoff = bma->off;
 				ASSERT(*firstblock == NULLFSBLOCK ||
 				       XFS_FSB_TO_AGNO(mp, *firstblock) ==
-				       XFS_FSB_TO_AGNO(mp, bma.firstblock) ||
+				       XFS_FSB_TO_AGNO(mp, bma->firstblock) ||
 				       (flist->xbf_low &&
 					XFS_FSB_TO_AGNO(mp, *firstblock) <
-					XFS_FSB_TO_AGNO(mp, bma.firstblock)));
-				*firstblock = bma.firstblock;
+					XFS_FSB_TO_AGNO(mp, bma->firstblock)));
+				*firstblock = bma->firstblock;
 				if (cur)
 					cur->bc_private.b.firstblock =
 						*firstblock;
@@ -5290,6 +5293,7 @@ error0:
 	if (!error)
 		xfs_bmap_validate_ret(orig_bno, orig_len, orig_flags, orig_mval,
 			orig_nmap, *nmap);
+	kmem_free(bma, sizeof(xfs_bmalloca_t));
 	return error;
 }
 
