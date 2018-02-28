Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60922 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934465AbeB1Rp7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Feb 2018 12:45:59 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] xfs: don't allocate COW blocks for zeroing holes or unwritten extents
Date: Wed, 28 Feb 2018 09:45:50 -0800
Message-Id: <20180228174552.31919-2-hch@lst.de>
In-Reply-To: <20180228174552.31919-1-hch@lst.de>
References: <20180228174552.31919-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com

The iomap zeroing interface is smart enough to skip zeroing holes or
unwritten extents.  Don't subvert this logic for reflink files.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 66e1edbfb2b2..4e771e0f1170 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -955,6 +955,13 @@ static inline bool imap_needs_alloc(struct inode *inode,
 		(IS_DAX(inode) && imap->br_state == XFS_EXT_UNWRITTEN);
 }
 
+static inline bool needs_cow_for_zeroing(struct xfs_bmbt_irec *imap, int nimaps)
+{
+	return nimaps &&
+		imap->br_startblock != HOLESTARTBLOCK &&
+		imap->br_state != XFS_EXT_UNWRITTEN;
+}
+
 static inline bool need_excl_ilock(struct xfs_inode *ip, unsigned flags)
 {
 	/*
@@ -1024,7 +1031,9 @@ xfs_file_iomap_begin(
 			goto out_unlock;
 	}
 
-	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && xfs_is_reflink_inode(ip)) {
+	if (xfs_is_reflink_inode(ip) &&
+	    ((flags & IOMAP_WRITE) ||
+	     ((flags & IOMAP_ZERO) && needs_cow_for_zeroing(&imap, nimaps)))) {
 		if (flags & IOMAP_DIRECT) {
 			/*
 			 * A reflinked inode will result in CoW alloc.
-- 
2.14.2

