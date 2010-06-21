Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5L8XRX4113439 for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 03:33:29 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B4AC015113FF
	for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 01:36:07 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id KIreF4515ihYmHCu for
	<xfs@oss.sgi.com>; Mon, 21 Jun 2010 01:36:07 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1OQcUB-0007aE-Da
	for xfs@oss.sgi.com; Mon, 21 Jun 2010 08:36:07 +0000
Message-Id: <20100621083607.340728554@bombadil.infradead.org>
Date: Mon, 21 Jun 2010 04:35:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 06/12] xfs: small cleanups for xfs_iomap / __xfs_get_blocks
References: <20100621083543.125860679@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-iomap-cleanup
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

Remove the flags argument to  __xfs_get_blocks as we can easily derive
it from the direct argument, and remove the unused BMAPI_MMAP flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-06-19 14:37:17.299004136 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-06-19 14:39:34.313254590 +0200
@@ -1295,9 +1295,9 @@ __xfs_get_blocks(
 	sector_t		iblock,
 	struct buffer_head	*bh_result,
 	int			create,
-	int			direct,
-	bmapi_flags_t		flags)
+	int			direct)
 {
+	int			flags = create ? BMAPI_WRITE : BMAPI_READ;
 	struct xfs_bmbt_irec	imap;
 	xfs_off_t		offset;
 	ssize_t			size;
@@ -1312,8 +1312,11 @@ __xfs_get_blocks(
 	if (!create && direct && offset >= i_size_read(inode))
 		return 0;
 
-	error = xfs_iomap(XFS_I(inode), offset, size,
-			     create ? flags : BMAPI_READ, &imap, &nimap, &new);
+	if (direct && create)
+		flags |= BMAPI_DIRECT;
+
+	error = xfs_iomap(XFS_I(inode), offset, size, flags, &imap, &nimap,
+			  &new);
 	if (error)
 		return -error;
 	if (nimap == 0)
@@ -1393,8 +1396,7 @@ xfs_get_blocks(
 	struct buffer_head	*bh_result,
 	int			create)
 {
-	return __xfs_get_blocks(inode, iblock,
-				bh_result, create, 0, BMAPI_WRITE);
+	return __xfs_get_blocks(inode, iblock, bh_result, create, 0);
 }
 
 STATIC int
@@ -1404,8 +1406,7 @@ xfs_get_blocks_direct(
 	struct buffer_head	*bh_result,
 	int			create)
 {
-	return __xfs_get_blocks(inode, iblock,
-				bh_result, create, 1, BMAPI_WRITE|BMAPI_DIRECT);
+	return __xfs_get_blocks(inode, iblock, bh_result, create, 1);
 }
 
 STATIC void
Index: xfs/fs/xfs/xfs_iomap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.c	2010-06-19 14:38:03.535254031 +0200
+++ xfs/fs/xfs/xfs_iomap.c	2010-06-19 14:39:34.313254590 +0200
@@ -133,7 +133,7 @@ xfs_iomap(
 			break;
 		}
 
-		if (flags & (BMAPI_DIRECT|BMAPI_MMAP)) {
+		if (flags & BMAPI_DIRECT) {
 			error = xfs_iomap_write_direct(ip, offset, count, flags,
 						       imap, nimaps);
 		} else {
Index: xfs/fs/xfs/xfs_iomap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.h	2010-06-19 14:37:17.318004066 +0200
+++ xfs/fs/xfs/xfs_iomap.h	2010-06-19 14:39:34.318254380 +0200
@@ -26,7 +26,6 @@ typedef enum {
 	/* modifiers */
 	BMAPI_IGNSTATE = (1 << 4),	/* ignore unwritten state on read */
 	BMAPI_DIRECT = (1 << 5),	/* direct instead of buffered write */
-	BMAPI_MMAP = (1 << 6),		/* allocate for mmap write */
 	BMAPI_TRYLOCK = (1 << 7),	/* non-blocking request */
 } bmapi_flags_t;
 
@@ -36,7 +35,6 @@ typedef enum {
 	{ BMAPI_ALLOCATE,	"ALLOCATE" }, \
 	{ BMAPI_IGNSTATE,	"IGNSTATE" }, \
 	{ BMAPI_DIRECT,		"DIRECT" }, \
-	{ BMAPI_MMAP,		"MMAP" }, \
 	{ BMAPI_TRYLOCK,	"TRYLOCK" }
 
 struct xfs_inode;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
