Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:35407 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750815AbdHKEpw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 00:45:52 -0400
Received: by mail-pg0-f50.google.com with SMTP id v189so11190839pgd.2
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 21:45:52 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH] xfs: fix inobt inode allocation search optimization
Date: Thu, 10 Aug 2017 21:45:45 -0700
Message-Id: <a605146bb4b492462c44a5c8697533a40b9f57bb.1502426715.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: kernel-team@fb.com

From: Omar Sandoval <osandov@fb.com>

When we try to allocate a free inode by searching the inobt, we try to
find the inode nearest the parent inode by searching chunks both left
and right of the chunk containing the parent. As an optimization, we
cache the leftmost and rightmost records that we previously searched; if
we do another allocation with the same parent inode, we'll pick up the
search where it last left off.

There's a bug in the case where we found a free inode to the left of the
parent's chunk: we need to update the cached left and right records, but
because we already reassigned the right record to point to the left, we
end up assigning the left record to both the cached left and right
records.

This isn't a correctness problem strictly, but it can result in the next
allocation rechecking chunks unnecessarily or allocating inodes further
away from the parent than it needs to. Fix it by swapping the record
pointer after we update the cached left and right records.

Fixes: bd169565993b ("xfs: speed up free inode search")
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index ffd5a15d1bb6..abf5beaae907 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1246,13 +1246,13 @@ xfs_dialloc_ag_inobt(
 
 			/* free inodes to the left? */
 			if (useleft && trec.ir_freecount) {
-				rec = trec;
 				xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 				cur = tcur;
 
 				pag->pagl_leftrec = trec.ir_startino;
 				pag->pagl_rightrec = rec.ir_startino;
 				pag->pagl_pagino = pagino;
+				rec = trec;
 				goto alloc_inode;
 			}
 
-- 
2.14.0

