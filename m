Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 442E9CA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 15:04:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 172E720684
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 15:04:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IOaPnBYY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437476AbfJYPEr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 11:04:47 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48704 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436893AbfJYPEr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 11:04:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mt1ByVmM73iZvYi/KU9TaQnw/vks+thQ64KzXyNLgcM=; b=IOaPnBYYVk4qOUl77E+itnzDM
        jhAoKQqEToFrj3DzeDh4Ai20kpO5JHiF9JafNPzJS/Vnar4msSHo+pqaImwssYz89C/CZ4wNIejwN
        1GLjkurujHP5N6BisDEuv2Nz4I969UGJi6I2HCW/natpiBpS7CkwZy/V9L7gKEzcpRnkjJujKEyjF
        oIJ9Uz8l81xBvCN1X41wFXZaahxk3U2jkKRe4jusEQfVX9NtuLhTxQ5XVWvVoOrIuN/jN0P/8/DHO
        m2be5Vi0ICCY08iWnKvqOjcdVJ3NiL1SnIjZyQONb9KM6x+37v0jpeRSEw6nE/poMY1/3MX21Bj2I
        Up9nycEsA==;
Received: from [46.189.28.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iO18v-0006mR-Oe
        for linux-xfs@vger.kernel.org; Fri, 25 Oct 2019 15:04:47 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/8] xfs: refactor xfs_bmapi_allocate
Date:   Fri, 25 Oct 2019 17:03:34 +0200
Message-Id: <20191025150336.19411-7-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025150336.19411-1-hch@lst.de>
References: <20191025150336.19411-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Avoid duplicate userdata and data fork checks by restructuring the code
so we only have a helper for userdata allocations that combines these
checks in a straight foward way.  That also helps to obsoletes the
comments explaining what the code does as it is now clearly obvious.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 93 +++++++++++++++++++---------------------
 1 file changed, 45 insertions(+), 48 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ef75e223cb70..c278eff29e82 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3641,20 +3641,6 @@ xfs_bmap_btalloc(
 	return 0;
 }
 
-/*
- * xfs_bmap_alloc is called by xfs_bmapi to allocate an extent for a file.
- * It figures out where to ask the underlying allocator to put the new extent.
- */
-STATIC int
-xfs_bmap_alloc(
-	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
-{
-	if (XFS_IS_REALTIME_INODE(ap->ip) &&
-	    xfs_alloc_is_userdata(ap->datatype))
-		return xfs_bmap_rtalloc(ap);
-	return xfs_bmap_btalloc(ap);
-}
-
 /* Trim extent to fit a logical block range. */
 void
 xfs_trim_extent(
@@ -4010,6 +3996,42 @@ xfs_bmapi_reserve_delalloc(
 	return error;
 }
 
+static int
+xfs_bmap_alloc_userdata(
+	struct xfs_bmalloca	*bma)
+{
+	struct xfs_mount	*mp = bma->ip->i_mount;
+	int			whichfork = xfs_bmapi_whichfork(bma->flags);
+	int			error;
+
+	/*
+	 * Set the data type being allocated. For the data fork, the first data
+	 * in the file is treated differently to all other allocations. For the
+	 * attribute fork, we only need to ensure the allocated range is not on
+	 * the busy list.
+	 */
+	bma->datatype = XFS_ALLOC_NOBUSY;
+	if (bma->flags & XFS_BMAPI_ZERO)
+		bma->datatype |= XFS_ALLOC_USERDATA_ZERO;
+	if (whichfork == XFS_DATA_FORK) {
+		if (bma->offset == 0)
+			bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
+		else
+			bma->datatype |= XFS_ALLOC_USERDATA;
+
+		if (mp->m_dalign && bma->length >= mp->m_dalign) {
+			error = xfs_bmap_isaeof(bma, whichfork);
+			if (error)
+				return error;
+		}
+
+		if (XFS_IS_REALTIME_INODE(bma->ip))
+			return xfs_bmap_rtalloc(bma);
+	}
+
+	return xfs_bmap_btalloc(bma);
+}
+
 static int
 xfs_bmapi_allocate(
 	struct xfs_bmalloca	*bma)
@@ -4037,43 +4059,18 @@ xfs_bmapi_allocate(
 					bma->got.br_startoff - bma->offset);
 	}
 
-	/*
-	 * Set the data type being allocated. For the data fork, the first data
-	 * in the file is treated differently to all other allocations. For the
-	 * attribute fork, we only need to ensure the allocated range is not on
-	 * the busy list.
-	 */
-	if (!(bma->flags & XFS_BMAPI_METADATA)) {
-		bma->datatype = XFS_ALLOC_NOBUSY;
-		if (whichfork == XFS_DATA_FORK) {
-			if (bma->offset == 0)
-				bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
-			else
-				bma->datatype |= XFS_ALLOC_USERDATA;
-		}
-		if (bma->flags & XFS_BMAPI_ZERO)
-			bma->datatype |= XFS_ALLOC_USERDATA_ZERO;
-	}
-
-	bma->minlen = (bma->flags & XFS_BMAPI_CONTIG) ? bma->length : 1;
-
-	/*
-	 * Only want to do the alignment at the eof if it is userdata and
-	 * allocation length is larger than a stripe unit.
-	 */
-	if (mp->m_dalign && bma->length >= mp->m_dalign &&
-	    !(bma->flags & XFS_BMAPI_METADATA) && whichfork == XFS_DATA_FORK) {
-		error = xfs_bmap_isaeof(bma, whichfork);
-		if (error)
-			return error;
-	}
+	if (bma->flags & XFS_BMAPI_CONTIG)
+		bma->minlen = bma->length;
+	else
+		bma->minlen = 1;
 
-	error = xfs_bmap_alloc(bma);
-	if (error)
+	if (bma->flags & XFS_BMAPI_METADATA)
+		error = xfs_bmap_btalloc(bma);
+	else
+		error = xfs_bmap_alloc_userdata(bma);
+	if (error || bma->blkno == NULLFSBLOCK)
 		return error;
 
-	if (bma->blkno == NULLFSBLOCK)
-		return 0;
 	if ((ifp->if_flags & XFS_IFBROOT) && !bma->cur)
 		bma->cur = xfs_bmbt_init_cursor(mp, bma->tp, bma->ip, whichfork);
 	/*
-- 
2.20.1

