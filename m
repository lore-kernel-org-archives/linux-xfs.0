Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39659 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751237AbdH2Rss (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 13:48:48 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dmkd5-0007fF-CA
        for linux-xfs@vger.kernel.org; Tue, 29 Aug 2017 17:48:48 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/8] xfs: switch xfs_bmap_local_to_extents to use xfs_iext_insert
Date: Tue, 29 Aug 2017 19:48:29 +0200
Message-Id: <20170829174835.2218-3-hch@lst.de>
In-Reply-To: <20170829174835.2218-1-hch@lst.de>
References: <20170829174835.2218-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Use the helper instead of open coding it, to provide a better abstraction
for the scalable extent list work.  This also gets an additional assert
and trace point for free.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 502f531e4634..bbde43c99323 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -880,7 +880,7 @@ xfs_bmap_local_to_extents(
 	xfs_ifork_t	*ifp;		/* inode fork pointer */
 	xfs_alloc_arg_t	args;		/* allocation arguments */
 	xfs_buf_t	*bp;		/* buffer for extent block */
-	xfs_bmbt_rec_host_t *ep;	/* extent record pointer */
+	struct xfs_bmbt_irec rec;
 
 	/*
 	 * We don't want to deal with the case of keeping inode data inline yet.
@@ -943,9 +943,12 @@ xfs_bmap_local_to_extents(
 	xfs_bmap_local_to_extents_empty(ip, whichfork);
 	flags |= XFS_ILOG_CORE;
 
-	xfs_iext_add(ifp, 0, 1);
-	ep = xfs_iext_get_ext(ifp, 0);
-	xfs_bmbt_set_allf(ep, 0, args.fsbno, 1, XFS_EXT_NORM);
+	rec.br_startoff = 0;
+	rec.br_startblock = args.fsbno;
+	rec.br_blockcount = 1;
+	rec.br_state = XFS_EXT_NORM;
+	xfs_iext_insert(ip, 0, 1, &rec, 0);
+
 	trace_xfs_bmap_post_update(ip, 0,
 			whichfork == XFS_ATTR_FORK ? BMAP_ATTRFORK : 0,
 			_THIS_IP_);
-- 
2.11.0

