Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0P94pH1226549 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 03:04:53 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC74B1DC1648
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 01:07:14 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 57qW9866RZnwwD0a for
	<xfs@oss.sgi.com>; Tue, 25 Jan 2011 01:07:14 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Pherq-0006Av-6N
	for xfs@oss.sgi.com; Tue, 25 Jan 2011 09:07:14 +0000
Message-Id: <20110125090714.153042343@bombadil.infradead.org>
Date: Tue, 25 Jan 2011 04:06:20 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/3] xfs: fix xfs_get_extsz_hint for a zero extent size hint
References: <20110125090618.432370964@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-zero-extent-size-hint
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

We can easily set the extsize flag without setting an extent size
hint, or one that evaluates to zero.  Historically the di_extsize
field was only used when it was non-zero, but the commit

	"Cleanup inode extent size hint extraction"

broke this.  Restore the old behaviour, thus fixing xfsqa 090 with
a debug kernel.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_rw.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rw.c	2011-01-24 14:42:50.432004339 +0100
+++ xfs/fs/xfs/xfs_rw.c	2011-01-24 15:03:17.211016282 +0100
@@ -173,17 +173,9 @@ xfs_extlen_t
 xfs_get_extsz_hint(
 	struct xfs_inode	*ip)
 {
-	xfs_extlen_t		extsz;
-
-	if (unlikely(XFS_IS_REALTIME_INODE(ip))) {
-		extsz = (ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)
-				? ip->i_d.di_extsize
-				: ip->i_mount->m_sb.sb_rextsize;
-		ASSERT(extsz);
-	} else {
-		extsz = (ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)
-				? ip->i_d.di_extsize : 0;
-	}
-
-	return extsz;
+	if ((ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE) && ip->i_d.di_extsize)
+		return ip->i_d.di_extsize;
+	if (XFS_IS_REALTIME_INODE(ip))
+		return ip->i_mount->m_sb.sb_rextsize;
+	return 0;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
