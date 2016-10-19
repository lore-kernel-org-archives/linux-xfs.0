Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60692 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941686AbcJSOVC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Oct 2016 10:21:02 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/5] xfs: remove xfs_file_wait_for_io
Date: Wed, 19 Oct 2016 14:47:27 +0200
Message-Id: <1476881248-18669-5-git-send-email-hch@lst.de>
In-Reply-To: <1476881248-18669-1-git-send-email-hch@lst.de>
References: <1476881248-18669-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com

filemap_write_and_wait_range operates on full pages, so there is no need
for the rounding operations.  Additionally this allows us to micro-optimize
by skipping the second inode_dio_wait for a intra-file clone.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 39 ++++++++++-----------------------------
 1 file changed, 10 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 0960264..a61be33 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -947,32 +947,6 @@ xfs_file_fallocate(
 	return error;
 }
 
-/*
- * Flush all file writes out to disk.
- */
-static int
-xfs_file_wait_for_io(
-	struct inode	*inode,
-	loff_t		offset,
-	size_t		len)
-{
-	loff_t		rounding;
-	loff_t		ioffset;
-	loff_t		iendoffset;
-	loff_t		bs;
-	int		ret;
-
-	bs = inode->i_sb->s_blocksize;
-	inode_dio_wait(inode);
-
-	rounding = max_t(xfs_off_t, bs, PAGE_SIZE);
-	ioffset = round_down(offset, rounding);
-	iendoffset = round_up(offset + len, rounding) - 1;
-	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset,
-					   iendoffset);
-	return ret;
-}
-
 /* Hook up to the VFS reflink function */
 STATIC int
 xfs_file_share_range(
@@ -1069,11 +1043,18 @@ xfs_file_share_range(
 	if (same_inode && pos_out + blen > pos_in && pos_out < pos_in + blen)
 		goto out_unlock;
 
-	/* Wait for the completion of any pending IOs on srcfile */
-	ret = xfs_file_wait_for_io(inode_in, pos_in, len);
+	/* Wait for the completion of any pending IOs on both files */
+	inode_dio_wait(inode_in);
+	if (!same_inode)
+		inode_dio_wait(inode_out);
+
+	ret = filemap_write_and_wait_range(inode_in->i_mapping,
+			pos_in, pos_in + len - 1);
 	if (ret)
 		goto out_unlock;
-	ret = xfs_file_wait_for_io(inode_out, pos_out, len);
+
+	ret = filemap_write_and_wait_range(inode_out->i_mapping,
+			pos_out, pos_out + len - 1);
 	if (ret)
 		goto out_unlock;
 
-- 
2.1.4

