Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51572 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750962AbdKTJB6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 Nov 2017 04:01:58 -0500
From: shuwang@redhat.com
Subject: [PATCH] xfs: fix memory leak in xfs_iext_free_last_leaf
Date: Mon, 20 Nov 2017 17:01:28 +0800
Message-Id: <20171120090128.11320-1-shuwang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com, hch@lst.de
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, bfoster@redhat.com, sandeen@redhat.com, chuhu@redhat.com, liwang@redhat.com, yizhan@redhat.com, Shu Wang <shuwang@redhat.com>

From: Shu Wang <shuwang@redhat.com>

found the issue by kmemleak.
unreferenced object 0xffff8800674611c0 (size 16):
    xfs_iext_insert+0x82a/0xa90 [xfs]
    xfs_bmap_add_extent_hole_delay+0x1e5/0x5b0 [xfs]
    xfs_bmapi_reserve_delalloc+0x483/0x530 [xfs]
    xfs_file_iomap_begin+0xac8/0xd40 [xfs]
    iomap_apply+0xb8/0x1b0
    iomap_file_buffered_write+0xac/0xe0
    xfs_file_buffered_aio_write+0x198/0x420 [xfs]
    xfs_file_write_iter+0x23f/0x2a0 [xfs]
    __vfs_write+0x23e/0x340
    vfs_write+0xe9/0x240
    SyS_write+0xa1/0x120
    do_syscall_64+0xda/0x260

Signed-off-by: Shu Wang <shuwang@redhat.com>
---
 fs/xfs/libxfs/xfs_iext_tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index 19e546a41251..89bf16b4d937 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -850,9 +850,9 @@ static void
 xfs_iext_free_last_leaf(
 	struct xfs_ifork	*ifp)
 {
-	ifp->if_u1.if_root = NULL;
 	ifp->if_height--;
 	kmem_free(ifp->if_u1.if_root);
+	ifp->if_u1.if_root = NULL;
 }
 
 void
-- 
2.13.5

