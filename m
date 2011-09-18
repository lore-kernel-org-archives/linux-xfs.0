Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IKfi5L200881 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 15:41:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D1281C234FD
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 13:41:43 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	umVUHU6Rvq1xQ4nD for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2011 13:41:43 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1R5OBL-0004f5-2K
	for xfs@oss.sgi.com; Sun, 18 Sep 2011 20:41:43 +0000
Message-Id: <20110918204143.017253403@bombadil.infradead.org>
Date: Sun, 18 Sep 2011 16:40:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 03/27] xfs: remove the nextents variable in xfs_bmapi
References: <20110918204040.266805129@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-bmapi-cleanup-nextents
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

Instead of using a local variable that needs to updated when we modify
the extent map just check ifp->if_bytes directly where we use it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-08-23 21:07:50.707607838 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2011-08-23 21:07:51.327604480 +0200
@@ -4294,7 +4294,6 @@ xfs_bmapi(
 	xfs_mount_t	*mp;		/* xfs mount structure */
 	int		n;		/* current extent index */
 	int		nallocs;	/* number of extents alloc'd */
-	xfs_extnum_t	nextents;	/* number of extents in file */
 	xfs_fileoff_t	obno;		/* old block number (offset) */
 	xfs_bmbt_irec_t	prev;		/* previous file extent record */
 	int		tmp_logflags;	/* temp flags holder */
@@ -4380,7 +4379,6 @@ xfs_bmapi(
 		goto error0;
 	ep = xfs_bmap_search_extents(ip, bno, whichfork, &eof, &lastx, &got,
 		&prev);
-	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
 	n = 0;
 	end = bno + len;
 	obno = bno;
@@ -4622,7 +4620,6 @@ xfs_bmapi(
 			if (error)
 				goto error0;
 			ep = xfs_iext_get_ext(ifp, lastx);
-			nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
 			xfs_bmbt_get_all(ep, &got);
 			ASSERT(got.br_startoff <= aoff);
 			ASSERT(got.br_startoff + got.br_blockcount >=
@@ -4723,7 +4720,6 @@ xfs_bmapi(
 			if (error)
 				goto error0;
 			ep = xfs_iext_get_ext(ifp, lastx);
-			nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
 			xfs_bmbt_get_all(ep, &got);
 			/*
 			 * We may have combined previously unwritten
@@ -4781,7 +4777,7 @@ xfs_bmapi(
 		 * Else go on to the next record.
 		 */
 		prev = got;
-		if (++lastx < nextents) {
+		if (++lastx < ifp->if_bytes / sizeof(xfs_bmbt_rec_t)) {
 			ep = xfs_iext_get_ext(ifp, lastx);
 			xfs_bmbt_get_all(ep, &got);
 		} else {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
