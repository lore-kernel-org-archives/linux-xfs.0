Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3SCSAto232800 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 07:28:10 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3298A154E9C0
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 05:30:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id mMVebQCbd6VmZcwz for
	<xfs@oss.sgi.com>; Wed, 28 Apr 2010 05:30:15 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1O76P8-0000l7-Kd
	for xfs@oss.sgi.com; Wed, 28 Apr 2010 12:30:14 +0000
Message-Id: <20100428123014.517888577@bombadil.infradead.org>
Date: Wed, 28 Apr 2010 08:28:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 01/11] xfs: limit xfs_imap_to_bmap to a single mapping
References: <20100428122850.075189557@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-iomap-cleanup-1
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

We only call xfs_iomap for single mappings anyway, so remove all code
dealing with multiple mappings from xfs_imap_to_bmap and add asserts
that we never get results that we do not expect.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_iomap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.c	2010-04-28 14:06:53.000000000 +0200
+++ xfs/fs/xfs/xfs_iomap.c	2010-04-28 14:14:38.708003332 +0200
@@ -55,49 +55,41 @@
 #define XFS_STRAT_WRITE_IMAPS	2
 #define XFS_WRITE_IMAPS		XFS_BMAP_MAX_NMAP
 
-STATIC int
+STATIC void
 xfs_imap_to_bmap(
 	xfs_inode_t	*ip,
 	xfs_off_t	offset,
 	xfs_bmbt_irec_t *imap,
 	xfs_iomap_t	*iomapp,
 	int		imaps,			/* Number of imap entries */
-	int		iomaps,			/* Number of iomap entries */
 	int		flags)
 {
 	xfs_mount_t	*mp = ip->i_mount;
-	int		pbm;
 	xfs_fsblock_t	start_block;
 
-
-	for (pbm = 0; imaps && pbm < iomaps; imaps--, iomapp++, imap++, pbm++) {
-		iomapp->iomap_offset = XFS_FSB_TO_B(mp, imap->br_startoff);
-		iomapp->iomap_delta = offset - iomapp->iomap_offset;
-		iomapp->iomap_bsize = XFS_FSB_TO_B(mp, imap->br_blockcount);
-		iomapp->iomap_flags = flags;
-
-		if (XFS_IS_REALTIME_INODE(ip)) {
-			iomapp->iomap_flags |= IOMAP_REALTIME;
-			iomapp->iomap_target = mp->m_rtdev_targp;
-		} else {
-			iomapp->iomap_target = mp->m_ddev_targp;
-		}
-		start_block = imap->br_startblock;
-		if (start_block == HOLESTARTBLOCK) {
-			iomapp->iomap_bn = IOMAP_DADDR_NULL;
-			iomapp->iomap_flags |= IOMAP_HOLE;
-		} else if (start_block == DELAYSTARTBLOCK) {
-			iomapp->iomap_bn = IOMAP_DADDR_NULL;
-			iomapp->iomap_flags |= IOMAP_DELAY;
-		} else {
-			iomapp->iomap_bn = xfs_fsb_to_db(ip, start_block);
-			if (ISUNWRITTEN(imap))
-				iomapp->iomap_flags |= IOMAP_UNWRITTEN;
-		}
-
-		offset += iomapp->iomap_bsize - iomapp->iomap_delta;
+	iomapp->iomap_offset = XFS_FSB_TO_B(mp, imap->br_startoff);
+	iomapp->iomap_delta = offset - iomapp->iomap_offset;
+	iomapp->iomap_bsize = XFS_FSB_TO_B(mp, imap->br_blockcount);
+	iomapp->iomap_flags = flags;
+
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		iomapp->iomap_flags |= IOMAP_REALTIME;
+		iomapp->iomap_target = mp->m_rtdev_targp;
+	} else {
+		iomapp->iomap_target = mp->m_ddev_targp;
+	}
+	start_block = imap->br_startblock;
+	if (start_block == HOLESTARTBLOCK) {
+		iomapp->iomap_bn = IOMAP_DADDR_NULL;
+		iomapp->iomap_flags |= IOMAP_HOLE;
+	} else if (start_block == DELAYSTARTBLOCK) {
+		iomapp->iomap_bn = IOMAP_DADDR_NULL;
+		iomapp->iomap_flags |= IOMAP_DELAY;
+	} else {
+		iomapp->iomap_bn = xfs_fsb_to_db(ip, start_block);
+		if (ISUNWRITTEN(imap))
+			iomapp->iomap_flags |= IOMAP_UNWRITTEN;
 	}
-	return pbm;	/* Return the number filled */
 }
 
 int
@@ -119,6 +111,7 @@ xfs_iomap(
 	int		iomap_flags = 0;
 
 	ASSERT((ip->i_d.di_mode & S_IFMT) == S_IFREG);
+	ASSERT(niomaps && *niomaps == 1);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
@@ -203,12 +196,11 @@ xfs_iomap(
 		break;
 	}
 
-	if (nimaps) {
-		*niomaps = xfs_imap_to_bmap(ip, offset, &imap,
-					    iomapp, nimaps, *niomaps, iomap_flags);
-	} else if (niomaps) {
-		*niomaps = 0;
-	}
+	ASSERT(nimaps <= 1);
+
+	if (nimaps)
+		xfs_imap_to_bmap(ip, offset, &imap, iomapp, nimaps, iomap_flags);
+	*niomaps = nimaps;
 
 out:
 	if (lockmode)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
