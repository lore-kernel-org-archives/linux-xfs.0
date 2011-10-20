Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9KE9egX005155 for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 09:09:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A8E2B1DF05A
	for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 07:09:36 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	3NLEivNxVDQi09IY for <xfs@oss.sgi.com>;
	Thu, 20 Oct 2011 07:09:36 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RGtJP-0006Xq-T1
	for xfs@oss.sgi.com; Thu, 20 Oct 2011 14:09:35 +0000
Message-Id: <20111020140935.854691231@bombadil.infradead.org>
Date: Thu, 20 Oct 2011 10:07:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/4] xfs: cleanup xfs_iomap_eof_align_last_fsb
References: <20111020140701.547662473@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-xfs_iomap_eof_align_last_fsb
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

Replace the nasty if, else if, elseif condition with more natural C flow
that expressed the logic we want here better.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_iomap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.c	2011-10-20 10:54:46.556555806 +0200
+++ xfs/fs/xfs/xfs_iomap.c	2011-10-20 11:01:07.216121183 +0200
@@ -57,26 +57,26 @@ xfs_iomap_eof_align_last_fsb(
 	xfs_fileoff_t	*last_fsb)
 {
 	xfs_fileoff_t	new_last_fsb = 0;
-	xfs_extlen_t	align;
+	xfs_extlen_t	align = 0;
 	int		eof, error;
 
-	if (XFS_IS_REALTIME_INODE(ip))
-		;
-	/*
-	 * If mounted with the "-o swalloc" option, roundup the allocation
-	 * request to a stripe width boundary if the file size is >=
-	 * stripe width and we are allocating past the allocation eof.
-	 */
-	else if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC) &&
-	        (ip->i_size >= XFS_FSB_TO_B(mp, mp->m_swidth)))
-		new_last_fsb = roundup_64(*last_fsb, mp->m_swidth);
-	/*
-	 * Roundup the allocation request to a stripe unit (m_dalign) boundary
-	 * if the file size is >= stripe unit size, and we are allocating past
-	 * the allocation eof.
-	 */
-	else if (mp->m_dalign && (ip->i_size >= XFS_FSB_TO_B(mp, mp->m_dalign)))
-		new_last_fsb = roundup_64(*last_fsb, mp->m_dalign);
+	if (!XFS_IS_REALTIME_INODE(ip)) {
+		/*
+		 * Round up the allocation request to a stripe unit
+		 * (m_dalign) boundary if the file size is >= stripe unit
+		 * size, and we are allocating past the allocation eof.
+		 *
+		 * If mounted with the "-o swalloc" option the alignment is
+		 * increased from the strip unit size to the stripe width.
+		 */
+		if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
+			align = mp->m_swidth;
+		else if (mp->m_dalign)
+			align = mp->m_dalign;
+
+		if (align && ip->i_size >= XFS_FSB_TO_B(mp, align))
+			new_last_fsb = roundup_64(*last_fsb, align);
+	}
 
 	/*
 	 * Always round up the allocation request to an extent boundary

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
