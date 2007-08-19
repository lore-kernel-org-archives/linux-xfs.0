Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Aug 2007 12:40:23 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7JJeIbm016778
	for <xfs@oss.sgi.com>; Sun, 19 Aug 2007 12:40:20 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l7JJeNA5002257
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 19 Aug 2007 21:40:23 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l7JJeNBl002255
	for xfs@oss.sgi.com; Sun, 19 Aug 2007 21:40:23 +0200
Date: Sun, 19 Aug 2007 21:40:23 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill unused IOMAP_EOF flag
Message-ID: <20070819194023.GB2185@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_iomap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iomap.c	2007-08-13 18:34:23.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_iomap.c	2007-08-13 18:34:49.000000000 +0200
@@ -135,14 +135,10 @@ xfs_imap_to_bmap(
 	int		flags)
 {
 	xfs_mount_t	*mp;
-	xfs_fsize_t	nisize;
 	int		pbm;
 	xfs_fsblock_t	start_block;
 
 	mp = io->io_mount;
-	nisize = XFS_SIZE(mp, io);
-	if (io->io_new_size > nisize)
-		nisize = io->io_new_size;
 
 	for (pbm = 0; imaps && pbm < iomaps; imaps--, iomapp++, imap++, pbm++) {
 		iomapp->iomap_offset = XFS_FSB_TO_B(mp, imap->br_startoff);
@@ -169,10 +165,6 @@ xfs_imap_to_bmap(
 				iomapp->iomap_flags |= IOMAP_UNWRITTEN;
 		}
 
-		if ((iomapp->iomap_offset + iomapp->iomap_bsize) >= nisize) {
-			iomapp->iomap_flags |= IOMAP_EOF;
-		}
-
 		offset += iomapp->iomap_bsize - iomapp->iomap_delta;
 	}
 	return pbm;	/* Return the number filled */
Index: linux-2.6-xfs/fs/xfs/xfs_iomap.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iomap.h	2007-08-13 18:34:23.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_iomap.h	2007-08-13 18:34:29.000000000 +0200
@@ -23,7 +23,6 @@
 
 typedef enum {				/* iomap_flags values */
 	IOMAP_READ =		0,	/* mapping for a read */
-	IOMAP_EOF =		0x01,	/* mapping contains EOF   */
 	IOMAP_HOLE =		0x02,	/* mapping covers a hole  */
 	IOMAP_DELAY =		0x04,	/* mapping covers delalloc region  */
 	IOMAP_REALTIME =	0x10,	/* mapping on the realtime device  */
