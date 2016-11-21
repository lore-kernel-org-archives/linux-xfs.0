Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59093 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754386AbcKUQjs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Nov 2016 11:39:48 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c8rdD-0001oJ-HR
        for linux-xfs@vger.kernel.org; Mon, 21 Nov 2016 16:39:48 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/14] xfs: remove NULLEXTNUM
Date: Mon, 21 Nov 2016 17:38:56 +0100
Message-Id: <1479746336-10986-15-git-send-email-hch@lst.de>
In-Reply-To: <1479746336-10986-1-git-send-email-hch@lst.de>
References: <1479746336-10986-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We only ever set a field to this constant for an impossible to reach
error case in xfs_bmap_search_extents.  That functions has been removed,
so we can remove the constant as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c  | 2 +-
 fs/xfs/libxfs/xfs_types.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 23cf045..4a5b335 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4260,7 +4260,7 @@ xfs_bmapi_allocate(
 	if (bma->wasdel) {
 		bma->length = (xfs_extlen_t)bma->got.br_blockcount;
 		bma->offset = bma->got.br_startoff;
-		if (bma->idx != NULLEXTNUM && bma->idx) {
+		if (bma->idx) {
 			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, bma->idx - 1),
 					 &bma->prev);
 		}
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index cf044c0..717909f 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -57,7 +57,6 @@ typedef __int64_t	xfs_sfiloff_t;	/* signed block number in a file */
 
 #define	NULLAGBLOCK	((xfs_agblock_t)-1)
 #define	NULLAGNUMBER	((xfs_agnumber_t)-1)
-#define	NULLEXTNUM	((xfs_extnum_t)-1)
 
 #define NULLCOMMITLSN	((xfs_lsn_t)-1)
 
-- 
2.1.4

