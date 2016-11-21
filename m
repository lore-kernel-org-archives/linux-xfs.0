Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58235 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754386AbcKUQjN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Nov 2016 11:39:13 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c8rce-0001Nr-6e
        for linux-xfs@vger.kernel.org; Mon, 21 Nov 2016 16:39:12 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/14] xfs: use new extent lookup helpers in xfs_bmapi_write
Date: Mon, 21 Nov 2016 17:38:46 +0100
Message-Id: <1479746336-10986-5-git-send-email-hch@lst.de>
In-Reply-To: <1479746336-10986-1-git-send-email-hch@lst.de>
References: <1479746336-10986-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 1a0fee4..9a8621d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4561,7 +4561,7 @@ xfs_bmapi_write(
 	struct xfs_ifork	*ifp;
 	struct xfs_bmalloca	bma = { NULL };	/* args for xfs_bmap_alloc */
 	xfs_fileoff_t		end;		/* end of mapped file region */
-	int			eof;		/* after the end of extents */
+	bool			eof = false;	/* after the end of extents */
 	int			error;		/* error return */
 	int			n;		/* current extent index */
 	xfs_fileoff_t		obno;		/* old block number (offset) */
@@ -4639,12 +4639,14 @@ xfs_bmapi_write(
 			goto error0;
 	}
 
-	xfs_bmap_search_extents(ip, bno, whichfork, &eof, &bma.idx, &bma.got,
-				&bma.prev);
 	n = 0;
 	end = bno + len;
 	obno = bno;
 
+	if (!xfs_iext_lookup_extent(ip, ifp, bno, &bma.idx, &bma.got))
+		eof = true;
+	if (!xfs_iext_get_extent(ifp, bma.idx - 1, &bma.prev))
+		bma.prev.br_startoff = NULLFILEOFF;
 	bma.tp = tp;
 	bma.ip = ip;
 	bma.total = total;
@@ -4731,11 +4733,8 @@ xfs_bmapi_write(
 
 		/* Else go on to the next record. */
 		bma.prev = bma.got;
-		if (++bma.idx < xfs_iext_count(ifp)) {
-			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, bma.idx),
-					 &bma.got);
-		} else
-			eof = 1;
+		if (!xfs_iext_get_extent(ifp, ++bma.idx, &bma.got))
+			eof = true;
 	}
 	*nmap = n;
 
-- 
2.1.4

