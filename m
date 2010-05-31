Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4VG6ZDU178990 for <xfs@oss.sgi.com>; Mon, 31 May 2010 11:06:36 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C970B387872
	for <xfs@oss.sgi.com>; Mon, 31 May 2010 09:09:02 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id e8T3Iu5LNUoxcGpO for
	<xfs@oss.sgi.com>; Mon, 31 May 2010 09:09:02 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1OJ7Xy-00019p-FJ
	for xfs@oss.sgi.com; Mon, 31 May 2010 16:09:02 +0000
Message-Id: <20100531160902.372281460@bombadil.infradead.org>
Date: Mon, 31 May 2010 12:07:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 16/17] xfs: remove unused XFS_BMAPI_ flags
References: <20100531160727.842750532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-bmapi-cleanup-flags
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

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2010-05-29 18:31:14.248017615 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2010-05-29 18:31:15.146003157 +0200
@@ -4605,19 +4605,13 @@ xfs_bmapi(
 			 * allocate the stuff asked for in this bmap call
 			 * but that wouldn't be as good.
 			 */
-			if (wasdelay && !(flags & XFS_BMAPI_EXACT)) {
+			if (wasdelay) {
 				alen = (xfs_extlen_t)got.br_blockcount;
 				aoff = got.br_startoff;
 				if (lastx != NULLEXTNUM && lastx) {
 					ep = xfs_iext_get_ext(ifp, lastx - 1);
 					xfs_bmbt_get_all(ep, &prev);
 				}
-			} else if (wasdelay) {
-				alen = (xfs_extlen_t)
-					XFS_FILBLKS_MIN(len,
-						(got.br_startoff +
-						 got.br_blockcount) - bno);
-				aoff = bno;
 			} else {
 				alen = (xfs_extlen_t)
 					XFS_FILBLKS_MIN(len, MAXEXTLEN);
Index: xfs/fs/xfs/xfs_bmap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.h	2010-05-29 18:09:00.436004974 +0200
+++ xfs/fs/xfs/xfs_bmap.h	2010-05-29 18:31:15.149023970 +0200
@@ -82,16 +82,13 @@ typedef	struct xfs_bmap_free
 #define XFS_BMAPI_DELAY		0x002	/* delayed write operation */
 #define XFS_BMAPI_ENTIRE	0x004	/* return entire extent, not trimmed */
 #define XFS_BMAPI_METADATA	0x008	/* mapping metadata not user data */
-#define XFS_BMAPI_EXACT		0x010	/* allocate only to spec'd bounds */
-#define XFS_BMAPI_ATTRFORK	0x020	/* use attribute fork not data */
-#define XFS_BMAPI_ASYNC		0x040	/* bunmapi xactions can be async */
-#define XFS_BMAPI_RSVBLOCKS	0x080	/* OK to alloc. reserved data blocks */
-#define	XFS_BMAPI_PREALLOC	0x100	/* preallocation op: unwritten space */
-#define	XFS_BMAPI_IGSTATE	0x200	/* Ignore state - */
+#define XFS_BMAPI_ATTRFORK	0x010	/* use attribute fork not data */
+#define XFS_BMAPI_RSVBLOCKS	0x020	/* OK to alloc. reserved data blocks */
+#define	XFS_BMAPI_PREALLOC	0x040	/* preallocation op: unwritten space */
+#define	XFS_BMAPI_IGSTATE	0x080	/* Ignore state - */
 					/* combine contig. space */
-#define	XFS_BMAPI_CONTIG	0x400	/* must allocate only one extent */
-/*	XFS_BMAPI_DIRECT_IO	0x800	*/
-#define XFS_BMAPI_CONVERT	0x1000	/* unwritten extent conversion - */
+#define	XFS_BMAPI_CONTIG	0x100	/* must allocate only one extent */
+#define XFS_BMAPI_CONVERT	0x200	/* unwritten extent conversion - */
 					/* need write cache flushing and no */
 					/* additional allocation alignments */
 
@@ -100,9 +97,7 @@ typedef	struct xfs_bmap_free
 	{ XFS_BMAPI_DELAY,	"DELAY" }, \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
-	{ XFS_BMAPI_EXACT,	"EXACT" }, \
 	{ XFS_BMAPI_ATTRFORK,	"ATTRFORK" }, \
-	{ XFS_BMAPI_ASYNC,	"ASYNC" }, \
 	{ XFS_BMAPI_RSVBLOCKS,	"RSVBLOCKS" }, \
 	{ XFS_BMAPI_PREALLOC,	"PREALLOC" }, \
 	{ XFS_BMAPI_IGSTATE,	"IGSTATE" }, \
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2010-05-29 18:17:15.205004416 +0200
+++ xfs/fs/xfs/xfs_inode.c	2010-05-29 18:31:15.156026205 +0200
@@ -1588,8 +1588,7 @@ xfs_itruncate_finish(
 		xfs_bmap_init(&free_list, &first_block);
 		error = xfs_bunmapi(ntp, ip,
 				    first_unmap_block, unmap_len,
-				    xfs_bmapi_aflag(fork) |
-				      (sync ? 0 : XFS_BMAPI_ASYNC),
+				    xfs_bmapi_aflag(fork),
 				    XFS_ITRUNC_MAX_EXTENTS,
 				    &first_block, &free_list,
 				    NULL, &done);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
