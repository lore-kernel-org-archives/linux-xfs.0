Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 744727CB0
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 16:51:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 45A7C304032
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 14:51:24 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id CiG27IdlcIw9LbBV (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 21 Aug 2016 14:51:22 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bbaeG-0002TV-Pz
	for xfs@oss.sgi.com; Sun, 21 Aug 2016 21:51:21 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/4] xfs: factor our a helper to calculate the EOF alignment
Date: Sun, 21 Aug 2016 23:51:11 +0200
Message-Id: <1471816273-28940-3-git-send-email-hch@lst.de>
In-Reply-To: <1471816273-28940-1-git-send-email-hch@lst.de>
References: <1471816273-28940-1-git-send-email-hch@lst.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

And drop the pointless mp argument to xfs_iomap_eof_align_last_fsb,
while we're at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index ba3592f..918511a 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -70,15 +70,13 @@ xfs_bmbt_to_iomap(
 	iomap->bdev = xfs_find_bdev_for_inode(VFS_I(ip));
 }
 
-STATIC int
-xfs_iomap_eof_align_last_fsb(
-	xfs_mount_t	*mp,
-	xfs_inode_t	*ip,
-	xfs_extlen_t	extsize,
-	xfs_fileoff_t	*last_fsb)
+static xfs_extlen_t
+xfs_eof_alignment(
+	struct xfs_inode	*ip,
+	xfs_extlen_t		extsize)
 {
-	xfs_extlen_t	align = 0;
-	int		eof, error;
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_extlen_t		align = 0;
 
 	if (!XFS_IS_REALTIME_INODE(ip)) {
 		/*
@@ -109,8 +107,21 @@ xfs_iomap_eof_align_last_fsb(
 			align = extsize;
 	}
 
+	return align;
+}
+
+STATIC int
+xfs_iomap_eof_align_last_fsb(
+	struct xfs_inode	*ip,
+	xfs_extlen_t		extsize,
+	xfs_fileoff_t		*last_fsb)
+{
+	xfs_extlen_t		align = xfs_eof_alignment(ip, extsize);
+
 	if (align) {
 		xfs_fileoff_t	new_last_fsb = roundup_64(*last_fsb, align);
+		int		eof, error;
+
 		error = xfs_bmap_eof(ip, new_last_fsb, XFS_DATA_FORK, &eof);
 		if (error)
 			return error;
@@ -180,7 +191,7 @@ xfs_iomap_write_direct(
 		 */
 		ASSERT(XFS_IFORK_PTR(ip, XFS_DATA_FORK)->if_flags &
 								XFS_IFEXTENTS);
-		error = xfs_iomap_eof_align_last_fsb(mp, ip, extsz, &last_fsb);
+		error = xfs_iomap_eof_align_last_fsb(ip, extsz, &last_fsb);
 		if (error)
 			goto out_unlock;
 	} else {
@@ -638,7 +649,7 @@ retry:
 	}
 
 	if (prealloc || extsz) {
-		error = xfs_iomap_eof_align_last_fsb(mp, ip, extsz, &last_fsb);
+		error = xfs_iomap_eof_align_last_fsb(ip, extsz, &last_fsb);
 		if (error)
 			return error;
 	}
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
