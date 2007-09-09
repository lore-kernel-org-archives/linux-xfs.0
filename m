Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 09 Sep 2007 08:41:08 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l89Ff34p015515
	for <xfs@oss.sgi.com>; Sun, 9 Sep 2007 08:41:05 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l89Ff3A5020062
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 9 Sep 2007 17:41:03 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l89Ff3Qm020060
	for xfs@oss.sgi.com; Sun, 9 Sep 2007 17:41:03 +0200
Date: Sun, 9 Sep 2007 17:41:03 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill BMAPI_UNWRITTEN
Message-ID: <20070909154103.GB19986@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

There is no reason to go through xfs_iomap for the BMAPI_UNWRITTEN
because it has nothing in common with the other cases.  Instead
check for the shutdown filesystem in xfs_end_bio_unwritten and perform
a direct call to xfs_iomap_write_unwritten (which should be renamed
to something more sensible one day)


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2007-09-06 10:18:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c	2007-09-06 10:18:05.000000000 +0200
@@ -237,12 +237,13 @@ xfs_end_bio_unwritten(
 {
 	xfs_ioend_t		*ioend =
 		container_of(work, xfs_ioend_t, io_work);
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
 	xfs_off_t		offset = ioend->io_offset;
 	size_t			size = ioend->io_size;
 
 	if (likely(!ioend->io_error)) {
-		xfs_bmap(XFS_I(ioend->io_inode), offset, size,
-				BMAPI_UNWRITTEN, NULL, NULL);
+		if (!XFS_FORCED_SHUTDOWN(ip->i_mount))
+			xfs_iomap_write_unwritten(ip, offset, size);
 		xfs_setfilesize(ioend);
 	}
 	xfs_destroy_ioend(ioend);
Index: linux-2.6-xfs/fs/xfs/xfs_iomap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iomap.c	2007-09-06 10:18:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_iomap.c	2007-09-06 10:18:05.000000000 +0200
@@ -191,9 +191,7 @@ xfs_iomap(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
-	switch (flags &
-		(BMAPI_READ | BMAPI_WRITE | BMAPI_ALLOCATE |
-		 BMAPI_UNWRITTEN)) {
+	switch (flags & (BMAPI_READ | BMAPI_WRITE | BMAPI_ALLOCATE)) {
 	case BMAPI_READ:
 		xfs_iomap_enter_trace(XFS_IOMAP_READ_ENTER, io, offset, count);
 		lockmode = XFS_LCK_MAP_SHARED(mp, io);
@@ -218,8 +216,6 @@ xfs_iomap(
 			XFS_ILOCK(mp, io, lockmode);
 		}
 		break;
-	case BMAPI_UNWRITTEN:
-		goto phase2;
 	default:
 		BUG();
 	}
@@ -238,8 +234,7 @@ xfs_iomap(
 	if (error)
 		goto out;
 
-phase2:
-	switch (flags & (BMAPI_WRITE|BMAPI_ALLOCATE|BMAPI_UNWRITTEN)) {
+	switch (flags & (BMAPI_WRITE|BMAPI_ALLOCATE)) {
 	case BMAPI_WRITE:
 		/* If we found an extent, return it */
 		if (nimaps &&
@@ -277,11 +272,6 @@ phase2:
 		error = XFS_IOMAP_WRITE_ALLOCATE(mp, io, offset, count,
 						 &imap, &nimaps);
 		break;
-	case BMAPI_UNWRITTEN:
-		lockmode = 0;
-		error = XFS_IOMAP_WRITE_UNWRITTEN(mp, io, offset, count);
-		nimaps = 0;
-		break;
 	}
 
 	if (nimaps) {
Index: linux-2.6-xfs/fs/xfs/xfs_iomap.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iomap.h	2007-09-06 10:18:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_iomap.h	2007-09-06 10:18:05.000000000 +0200
@@ -36,7 +36,6 @@ typedef enum {
 	BMAPI_READ = (1 << 0),		/* read extents */
 	BMAPI_WRITE = (1 << 1),		/* create extents */
 	BMAPI_ALLOCATE = (1 << 2),	/* delayed allocate to real extents */
-	BMAPI_UNWRITTEN  = (1 << 3),	/* unwritten extents to real extents */
 	/* modifiers */
 	BMAPI_IGNSTATE = (1 << 4),	/* ignore unwritten state on read */
 	BMAPI_DIRECT = (1 << 5),	/* direct instead of buffered write */
