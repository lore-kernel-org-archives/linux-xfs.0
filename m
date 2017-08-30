Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34796 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751405AbdH3PxX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 11:53:23 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: remove unused flags arg from xfs_file_iomap_begin_delay
Message-ID: <8f1f6b47-988f-6cba-181d-d0be01fa3aa2@redhat.com>
Date: Wed, 30 Aug 2017 10:53:22 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 1b625d0..79cb5b3 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -520,7 +520,6 @@
 	struct inode		*inode,
 	loff_t			offset,
 	loff_t			count,
-	unsigned		flags,
 	struct iomap		*iomap)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
@@ -984,8 +983,7 @@ static inline bool need_excl_ilock(struct xfs_inode *ip, unsigned flags)
 	if (((flags & (IOMAP_WRITE | IOMAP_DIRECT)) == IOMAP_WRITE) &&
 			!IS_DAX(inode) && !xfs_get_extsz_hint(ip)) {
 		/* Reserve delalloc blocks for regular writeback. */
-		return xfs_file_iomap_begin_delay(inode, offset, length, flags,
-				iomap);
+		return xfs_file_iomap_begin_delay(inode, offset, length, iomap);
 	}
 
 	if (need_excl_ilock(ip, flags)) {

