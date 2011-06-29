Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5TE3cRV104728 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 09:03:39 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E1281D7DD2A
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 07:03:37 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ABoAl8QYgEXMLgOa for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 07:03:37 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QbvMe-0008Aw-OE
	for xfs@oss.sgi.com; Wed, 29 Jun 2011 14:03:36 +0000
Message-Id: <20110629140336.717434334@bombadil.infradead.org>
Date: Wed, 29 Jun 2011 10:01:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 02/27] xfs: remove the unused ilock_nowait codepath in
	writepage
References: <20110629140109.003209430@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-writepage-remove-nonblock
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

wbc->nonblocking is never set, so this whole code has been unreachable
for a long time.  I'm also not sure it would make a lot of sense -
we'd rather finish our writeout after a short wait for the ilock
instead of cancelling the whole ioend.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c	2011-04-27 20:54:19.763046444 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c	2011-04-27 20:54:41.922926393 +0200
@@ -305,8 +305,7 @@ xfs_map_blocks(
 	struct inode		*inode,
 	loff_t			offset,
 	struct xfs_bmbt_irec	*imap,
-	int			type,
-	int			nonblocking)
+	int			type)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
@@ -322,11 +321,7 @@ xfs_map_blocks(
 	if (type == IO_UNWRITTEN)
 		bmapi_flags |= XFS_BMAPI_IGSTATE;
 
-	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED)) {
-		if (nonblocking)
-			return -XFS_ERROR(EAGAIN);
-		xfs_ilock(ip, XFS_ILOCK_SHARED);
-	}
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
 
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       (ip->i_df.if_flags & XFS_IFEXTENTS));
@@ -916,7 +911,6 @@ xfs_vm_writepage(
 	ssize_t			len;
 	int			err, imap_valid = 0, uptodate = 1;
 	int			count = 0;
-	int			nonblocking = 0;
 
 	trace_xfs_writepage(inode, page, 0);
 
@@ -964,9 +958,6 @@ xfs_vm_writepage(
 	offset = page_offset(page);
 	type = IO_OVERWRITE;
 
-	if (wbc->sync_mode == WB_SYNC_NONE && wbc->nonblocking)
-		nonblocking = 1;
-
 	do {
 		int new_ioend = 0;
 
@@ -1021,8 +1012,7 @@ xfs_vm_writepage(
 			 * time.
 			 */
 			new_ioend = 1;
-			err = xfs_map_blocks(inode, offset, &imap, type,
-					     nonblocking);
+			err = xfs_map_blocks(inode, offset, &imap, type);
 			if (err)
 				goto error;
 			imap_valid = xfs_imap_valid(inode, &imap, offset);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
