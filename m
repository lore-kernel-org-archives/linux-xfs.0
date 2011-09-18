Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IKfl87200957 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 15:41:47 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B36EE172069
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 13:41:46 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	CgY2eLlXlebs0CUH for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2011 13:41:46 -0700 (PDT)
Message-Id: <20110918204146.168111527@bombadil.infradead.org>
Date: Sun, 18 Sep 2011 16:40:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 19/27] xfs: do not keep local copies of allocation ranges in
	xfs_bmapi_allocate
References: <20110918204040.266805129@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-bmapi_allocate-cleanup
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-09-11 08:45:11.126455817 -0400
+++ xfs/fs/xfs/xfs_bmap.c	2011-09-11 08:45:12.276455812 -0400
@@ -4617,9 +4617,6 @@ xfs_bmapi_allocate(
 	int			whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
 						XFS_ATTR_FORK : XFS_DATA_FORK;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(bma->ip, whichfork);
-	xfs_fsblock_t		abno;
-	xfs_extlen_t		alen;
-	xfs_fileoff_t		aoff;
 	int			error;
 	int			rt;
 
@@ -4630,18 +4627,17 @@ xfs_bmapi_allocate(
 	 * for in this bmap call but that wouldn't be as good.
 	 */
 	if (bma->wasdel) {
-		alen = (xfs_extlen_t)bma->got.br_blockcount;
-		aoff = bma->got.br_startoff;
+		bma->length = (xfs_extlen_t)bma->got.br_blockcount;
+		bma->offset = bma->got.br_startoff;
 		if (*lastx != NULLEXTNUM && *lastx) {
 			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *lastx - 1),
 					 &bma->prev);
 		}
 	} else {
-		alen = (xfs_extlen_t)XFS_FILBLKS_MIN(bma->length, MAXEXTLEN);
+		bma->length = XFS_FILBLKS_MIN(bma->length, MAXEXTLEN);
 		if (!bma->eof)
-			alen = (xfs_extlen_t)XFS_FILBLKS_MIN(alen,
+			bma->length = XFS_FILBLKS_MIN(bma->length,
 					bma->got.br_startoff - bma->offset);
-		aoff = bma->offset;
 	}
 
 	/*
@@ -4649,23 +4645,17 @@ xfs_bmapi_allocate(
 	 * user data.
 	 */
 	if (!(flags & XFS_BMAPI_METADATA)) {
-		bma->userdata = (aoff == 0) ?
+		bma->userdata = (bma->offset == 0) ?
 			XFS_ALLOC_INITIAL_USER_DATA : XFS_ALLOC_USERDATA;
 	}
 
-	/*
-	 * Fill in changeable bma fields.
-	 */
-	bma->length = alen;
-	bma->offset = aoff;
-	bma->minlen = (flags & XFS_BMAPI_CONTIG) ? alen : 1;
-	bma->aeof = 0;
+	bma->minlen = (flags & XFS_BMAPI_CONTIG) ? bma->length : 1;
 
 	/*
 	 * Only want to do the alignment at the eof if it is userdata and
 	 * allocation length is larger than a stripe unit.
 	 */
-	if (mp->m_dalign && alen >= mp->m_dalign &&
+	if (mp->m_dalign && bma->length >= mp->m_dalign &&
 	    !(flags & XFS_BMAPI_METADATA) && whichfork == XFS_DATA_FORK) {
 		error = xfs_bmap_isaeof(bma, whichfork);
 		if (error)
@@ -4676,17 +4666,11 @@ xfs_bmapi_allocate(
 	if (error)
 		return error;
 
-	/*
-	 * Copy out result fields.
-	 */
-	abno = bma->blkno;
-	alen = bma->length;
-	aoff = bma->offset;
 	if (bma->flist->xbf_low)
 		bma->minleft = 0;
 	if (*cur)
 		(*cur)->bc_private.b.firstblock = *bma->firstblock;
-	if (abno == NULLFSBLOCK)
+	if (bma->blkno == NULLFSBLOCK)
 		return 0;
 	if ((ifp->if_flags & XFS_IFBROOT) && !*cur) {
 		(*cur) = xfs_bmbt_init_cursor(mp, bma->tp, bma->ip, whichfork);
@@ -4703,9 +4687,9 @@ xfs_bmapi_allocate(
 		(*cur)->bc_private.b.flags =
 			bma->wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
 
-	bma->got.br_startoff = aoff;
-	bma->got.br_startblock = abno;
-	bma->got.br_blockcount = alen;
+	bma->got.br_startoff = bma->offset;
+	bma->got.br_startblock = bma->blkno;
+	bma->got.br_blockcount = bma->length;
 	bma->got.br_state = XFS_EXT_NORM;
 
 	/*
@@ -4736,8 +4720,9 @@ xfs_bmapi_allocate(
 	 */
 	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *lastx), &bma->got);
 
-	ASSERT(bma->got.br_startoff <= aoff);
-	ASSERT(bma->got.br_startoff + bma->got.br_blockcount >= aoff + alen);
+	ASSERT(bma->got.br_startoff <= bma->offset);
+	ASSERT(bma->got.br_startoff + bma->got.br_blockcount >=
+	       bma->offset + bma->length);
 	ASSERT(bma->got.br_state == XFS_EXT_NORM ||
 	       bma->got.br_state == XFS_EXT_UNWRITTEN);
 	return 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
