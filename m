Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35370 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751285AbdB1Atz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Feb 2017 19:49:55 -0500
Received: from [8.25.222.2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1ciVys-000613-Sr
        for linux-xfs@vger.kernel.org; Tue, 28 Feb 2017 00:49:30 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] xfs: remove the ISUNWRITTEN macro
Date: Mon, 27 Feb 2017 16:49:30 -0800
Message-Id: <20170228004930.9559-2-hch@lst.de>
In-Reply-To: <20170228004930.9559-1-hch@lst.de>
References: <20170228004930.9559-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Opencoding the trivial checks makes it much easier to read (and grep..).

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap_btree.h | 1 -
 fs/xfs/xfs_aops.c              | 4 ++--
 fs/xfs/xfs_iomap.c             | 4 ++--
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 819a8a4dee95..90347a99c6d2 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -30,7 +30,6 @@ struct xfs_trans;
 #define XFS_EXTFMT_INODE(x)	\
 	(xfs_sb_version_hasextflgbit(&((x)->i_mount->m_sb)) ? \
 		XFS_EXTFMT_HASSTATE : XFS_EXTFMT_NOSTATE)
-#define ISUNWRITTEN(x)	((x)->br_state == XFS_EXT_UNWRITTEN)
 
 /*
  * Btree block header size depends on a superblock flag.
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 582e3275bb51..b480647e00e7 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1266,8 +1266,8 @@ xfs_get_blocks(
 
 	if (nimaps) {
 		trace_xfs_get_blocks_found(ip, offset, size,
-				ISUNWRITTEN(&imap) ? XFS_IO_UNWRITTEN
-						   : XFS_IO_OVERWRITE, &imap);
+			imap.br_state == XFS_EXT_UNWRITTEN ?
+				XFS_IO_UNWRITTEN : XFS_IO_OVERWRITE, &imap);
 		xfs_iunlock(ip, lockmode);
 	} else {
 		trace_xfs_get_blocks_notfound(ip, offset, size);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 41662fb14e87..5d68b4279016 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -240,7 +240,7 @@ xfs_iomap_write_direct(
 	 */
 	if (IS_DAX(VFS_I(ip))) {
 		bmapi_flags = XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO;
-		if (ISUNWRITTEN(imap)) {
+		if (imap->br_state == XFS_EXT_UNWRITTEN) {
 			tflags |= XFS_TRANS_RESERVE;
 			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
 		}
@@ -940,7 +940,7 @@ static inline bool imap_needs_alloc(struct inode *inode,
 	return !nimaps ||
 		imap->br_startblock == HOLESTARTBLOCK ||
 		imap->br_startblock == DELAYSTARTBLOCK ||
-		(IS_DAX(inode) && ISUNWRITTEN(imap));
+		(IS_DAX(inode) && imap->br_state == XFS_EXT_UNWRITTEN);
 }
 
 static inline bool need_excl_ilock(struct xfs_inode *ip, unsigned flags)
-- 
2.11.0

