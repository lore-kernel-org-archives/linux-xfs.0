Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAEGHf3r193821 for <xfs@oss.sgi.com>; Sat, 14 Nov 2009 10:17:43 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3CC9E1D976F2
	for <xfs@oss.sgi.com>; Sat, 14 Nov 2009 08:18:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id oNHHZyjUjttFLOxA for
	<xfs@oss.sgi.com>; Sat, 14 Nov 2009 08:18:02 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1N9LK5-0004X7-T7
	for xfs@oss.sgi.com; Sat, 14 Nov 2009 16:18:01 +0000
Message-Id: <20091114161801.818601601@bombadil.infradead.org>
Date: Sat, 14 Nov 2009 11:17:21 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/7] xfs: uninline xfs_get_extsz_hint
References: <20091114161717.233372584@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-uninline-xfs_get_extsz_hint
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

This function is too large to efficiently be inlined.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_rw.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rw.c	2009-11-12 17:14:15.278004428 +0100
+++ xfs/fs/xfs/xfs_rw.c	2009-11-12 17:18:33.311004263 +0100
@@ -336,3 +336,25 @@ xfs_bwrite(
 	}
 	return (error);
 }
+
+/*
+ * helper function to extract extent size hint from inode
+ */
+xfs_extlen_t
+xfs_get_extsz_hint(
+	struct xfs_inode	*ip)
+{
+	xfs_extlen_t		extsz;
+
+	if (unlikely(XFS_IS_REALTIME_INODE(ip))) {
+		extsz = (ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)
+				? ip->i_d.di_extsize
+				: ip->i_mount->m_sb.sb_rextsize;
+		ASSERT(extsz);
+	} else {
+		extsz = (ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)
+				? ip->i_d.di_extsize : 0;
+	}
+
+	return extsz;
+}
Index: xfs/fs/xfs/xfs_rw.h
===================================================================
--- xfs.orig/fs/xfs/xfs_rw.h	2009-11-09 17:06:46.116004228 +0100
+++ xfs/fs/xfs/xfs_rw.h	2009-11-12 17:18:33.311004263 +0100
@@ -37,27 +37,6 @@ xfs_fsb_to_db(struct xfs_inode *ip, xfs_
 }
 
 /*
- * helper function to extract extent size hint from inode
- */
-STATIC_INLINE xfs_extlen_t
-xfs_get_extsz_hint(
-	xfs_inode_t	*ip)
-{
-	xfs_extlen_t	extsz;
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
-	return extsz;
-}
-
-/*
  * Prototypes for functions in xfs_rw.c.
  */
 extern int xfs_write_clear_setuid(struct xfs_inode *ip);
@@ -69,5 +48,6 @@ extern int xfs_read_buf(struct xfs_mount
 			struct xfs_buf **bpp);
 extern void xfs_ioerror_alert(char *func, struct xfs_mount *mp,
 				xfs_buf_t *bp, xfs_daddr_t blkno);
+extern xfs_extlen_t xfs_get_extsz_hint(struct xfs_inode *ip);
 
 #endif /* __XFS_RW_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
