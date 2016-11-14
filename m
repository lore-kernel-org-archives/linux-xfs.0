Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48580 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933384AbcKNRNE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2016 12:13:04 -0500
Received: from [83.175.99.196] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c6KoZ-0005Bf-5p
        for linux-xfs@vger.kernel.org; Mon, 14 Nov 2016 17:13:03 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/14] xfs: use new extent lookup helpers in xfs_bmapi_read
Date: Mon, 14 Nov 2016 18:12:34 +0100
Message-Id: <1479143565-30615-4-git-send-email-hch@lst.de>
In-Reply-To: <1479143565-30615-1-git-send-email-hch@lst.de>
References: <1479143565-30615-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 98f490b..1a0fee4 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4145,12 +4145,11 @@ xfs_bmapi_read(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp;
 	struct xfs_bmbt_irec	got;
-	struct xfs_bmbt_irec	prev;
 	xfs_fileoff_t		obno;
 	xfs_fileoff_t		end;
-	xfs_extnum_t		lastx;
+	xfs_extnum_t		idx;
 	int			error;
-	int			eof;
+	bool			eof = false;
 	int			n = 0;
 	int			whichfork = xfs_bmapi_whichfork(flags);
 
@@ -4190,7 +4189,8 @@ xfs_bmapi_read(
 			return error;
 	}
 
-	xfs_bmap_search_extents(ip, bno, whichfork, &eof, &lastx, &got, &prev);
+	if (!xfs_iext_lookup_extent(ip, ifp, bno, &idx, &got))
+		eof = true;
 	end = bno + len;
 	obno = bno;
 
@@ -4221,10 +4221,8 @@ xfs_bmapi_read(
 			break;
 
 		/* Else go on to the next record. */
-		if (++lastx < xfs_iext_count(ifp))
-			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, lastx), &got);
-		else
-			eof = 1;
+		if (!xfs_iext_get_extent(ifp, ++idx, &got))
+			eof = true;
 	}
 	*nmap = n;
 	return 0;
-- 
2.1.4

