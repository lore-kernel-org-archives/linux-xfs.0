Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37451 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752464AbcJJNiX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 09:38:23 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/9] xfs: don't bother looking at the refcount tree for reads
Date: Mon, 10 Oct 2016 15:38:00 +0200
Message-Id: <1476106685-29048-5-git-send-email-hch@lst.de>
In-Reply-To: <1476106685-29048-1-git-send-email-hch@lst.de>
References: <1476106685-29048-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com

There is no need to trim an extent into a shared or non-shared one, or
report any flags for plain old reads.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index d907eb9..1dabf2e 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -996,11 +996,14 @@ xfs_file_iomap_begin(
 		return error;
 	}
 
-	/* Trim the mapping to the nearest shared extent boundary. */
-	error = xfs_reflink_trim_around_shared(ip, &imap, &shared, &trimmed);
-	if (error) {
-		xfs_iunlock(ip, lockmode);
-		return error;
+	if (flags & (IOMAP_WRITE | IOMAP_ZERO | IOMAP_REPORT)) {
+		/* Trim the mapping to the nearest shared extent boundary. */
+		error = xfs_reflink_trim_around_shared(ip, &imap, &shared,
+				&trimmed);
+		if (error) {
+			xfs_iunlock(ip, lockmode);
+			return error;
+		}
 	}
 
 	if ((flags & IOMAP_WRITE) && imap_needs_alloc(inode, &imap, nimaps)) {
-- 
2.10.1.382.ga23ca1b

