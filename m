Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49074 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935186AbdGTPGN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jul 2017 11:06:13 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5D2FAC059739
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2017 15:06:13 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E0397F6C6
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2017 15:06:13 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] libxfs: init ->b_maps on contig buffers for uncached compatibility
Date: Thu, 20 Jul 2017 11:06:12 -0400
Message-Id: <20170720150612.37494-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

There is a bit of an inconsistency in how ->b_maps is used for
contiguous buffers between kernel libxfs and xfsprogs due to the
independent buffer implementations. In the kernel, ->b_maps[0] is
always intialized to a valid range and in xfsprogs, ->b_maps is only
allocated for discontiguous buffers.

This can lead to confusion when dealing with uncached kernel buffers
in common libxfs code because xfsprogs has no concept of uncached
buffers. Kernel uncached buffers have ->b_bn == XFS_BUF_DADDR_NULL
and ->b_maps[0] points to the physical block address. Block address
checks in common code for kernel uncached buffers, such as in
xfs_sb_verify(), therefore would need to check both places for an
address or risk broken logic or userspace segfaults.

This problem currently manifests as an xfs_repair segfault due to a
NULL ->b_maps access in xfs_sb_verify(). Note that this problem is
only reproducible on builds with (-O2) optimization disabled, as the
affected parameter is currently unused and thus optimization
eliminates the problematic access.

To fix this problem and eliminate the incompatibility, update the
userspace xfs_buf with an internal ->__b_map field and point
->b_maps to it for contiguous buffers, similar to the kernel buffer
implementation. Set valid values in ->b_maps0] for contiguous
buffers so common code will continue to work regardless of whether a
buffer is uncached in the kernel.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This replaces the previous rfc[1] with an xfsprogs only patch that
resolves the crash by setting a valid ->b_maps on all userspace buffers
(covering the uncached kernel buffer case).

Brian

[1] http://marc.info/?l=linux-xfs&m=150038722013638&w=2

 libxfs/libxfs_io.h |  1 +
 libxfs/rdwr.c      | 10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 6612d8f..1209e52 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -76,6 +76,7 @@ typedef struct xfs_buf {
 	const struct xfs_buf_ops *b_ops;
 	struct xfs_perag	*b_pag;
 	struct xfs_buf_map	*b_maps;
+	struct xfs_buf_map	__b_map;
 	int			b_nmaps;
 #ifdef XFS_BUF_TRACING
 	struct list_head	b_lock_list;
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 6c8a192..21c42f1 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -591,6 +591,13 @@ __initbuf(xfs_buf_t *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
 	bp->b_holder = 0;
 	bp->b_recur = 0;
 	bp->b_ops = NULL;
+
+	if (!bp->b_maps) {
+		bp->b_nmaps = 1;
+		bp->b_maps = &bp->__b_map;
+		bp->b_maps[0].bm_bn = bp->b_bn;
+		bp->b_maps[0].bm_len = bp->b_length;
+	}
 }
 
 static void
@@ -654,7 +661,8 @@ __libxfs_getbufr(int blen)
 			list_del_init(&bp->b_node.cn_mru);
 			free(bp->b_addr);
 			bp->b_addr = NULL;
-			free(bp->b_maps);
+			if (bp->b_maps != &bp->__b_map)
+				free(bp->b_maps);
 			bp->b_maps = NULL;
 		}
 	} else
-- 
2.9.4

