Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D3F277CA0
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 16:51:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A417E8F8035
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 14:51:21 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id zCjqAEcpD861GcGB (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 21 Aug 2016 14:51:19 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bbaeE-0002TQ-BA
	for xfs@oss.sgi.com; Sun, 21 Aug 2016 21:51:18 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] xfs: move xfs_bmbt_to_iomap up
Date: Sun, 21 Aug 2016 23:51:10 +0200
Message-Id: <1471816273-28940-2-git-send-email-hch@lst.de>
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

We'll need it earlier in the file soon, so the unchanged function to the
top of xfs_iomap.c

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 52 ++++++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 2af0dda..ba3592f 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -44,6 +44,32 @@
 						<< mp->m_writeio_log)
 #define XFS_WRITE_IMAPS		XFS_BMAP_MAX_NMAP
 
+void
+xfs_bmbt_to_iomap(
+	struct xfs_inode	*ip,
+	struct iomap		*iomap,
+	struct xfs_bmbt_irec	*imap)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (imap->br_startblock == HOLESTARTBLOCK) {
+		iomap->blkno = IOMAP_NULL_BLOCK;
+		iomap->type = IOMAP_HOLE;
+	} else if (imap->br_startblock == DELAYSTARTBLOCK) {
+		iomap->blkno = IOMAP_NULL_BLOCK;
+		iomap->type = IOMAP_DELALLOC;
+	} else {
+		iomap->blkno = xfs_fsb_to_db(ip, imap->br_startblock);
+		if (imap->br_state == XFS_EXT_UNWRITTEN)
+			iomap->type = IOMAP_UNWRITTEN;
+		else
+			iomap->type = IOMAP_MAPPED;
+	}
+	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
+	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
+	iomap->bdev = xfs_find_bdev_for_inode(VFS_I(ip));
+}
+
 STATIC int
 xfs_iomap_eof_align_last_fsb(
 	xfs_mount_t	*mp,
@@ -947,32 +973,6 @@ error_on_bmapi_transaction:
 	return error;
 }
 
-void
-xfs_bmbt_to_iomap(
-	struct xfs_inode	*ip,
-	struct iomap		*iomap,
-	struct xfs_bmbt_irec	*imap)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-
-	if (imap->br_startblock == HOLESTARTBLOCK) {
-		iomap->blkno = IOMAP_NULL_BLOCK;
-		iomap->type = IOMAP_HOLE;
-	} else if (imap->br_startblock == DELAYSTARTBLOCK) {
-		iomap->blkno = IOMAP_NULL_BLOCK;
-		iomap->type = IOMAP_DELALLOC;
-	} else {
-		iomap->blkno = xfs_fsb_to_db(ip, imap->br_startblock);
-		if (imap->br_state == XFS_EXT_UNWRITTEN)
-			iomap->type = IOMAP_UNWRITTEN;
-		else
-			iomap->type = IOMAP_MAPPED;
-	}
-	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
-	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
-	iomap->bdev = xfs_find_bdev_for_inode(VFS_I(ip));
-}
-
 static inline bool imap_needs_alloc(struct xfs_bmbt_irec *imap, int nimaps)
 {
 	return !nimaps ||
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
