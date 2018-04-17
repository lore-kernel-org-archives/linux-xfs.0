Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34854 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750764AbeDQE0N (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Apr 2018 00:26:13 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: set format back to extents if xfs_bmap_extents_to_btree
 fails
Message-ID: <0add6e45-4382-c16b-3bb1-1d4eaee1adc3@redhat.com>
Date: Mon, 16 Apr 2018 23:26:12 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: wen.xu@gatech.edu

If xfs_bmap_extents_to_btree fails in a mode where we call
xfs_iroot_realloc(-1) to de-allocate the root, set the
format back to extents.

Otherwise we can assume we can dereference ifp->if_broot
based on the XFS_DINODE_FMT_BTREE format, and crash.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=199423
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6a7c2f0..040eeda 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -725,12 +725,16 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 	*logflagsp = 0;
 	if ((error = xfs_alloc_vextent(&args))) {
 		xfs_iroot_realloc(ip, -1, whichfork);
+		ASSERT(ifp->if_broot == NULL);
+		XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
 		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 		return error;
 	}
 
 	if (WARN_ON_ONCE(args.fsbno == NULLFSBLOCK)) {
 		xfs_iroot_realloc(ip, -1, whichfork);
+		ASSERT(ifp->if_broot == NULL);
+		XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
 		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 		return -ENOSPC;
 	}

