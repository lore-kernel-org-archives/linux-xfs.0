Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4E13CA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 15:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8751E20684
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 15:04:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fJs++BWR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409504AbfJYPER (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 11:04:17 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48666 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408186AbfJYPER (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 11:04:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qC4uW+j0FwQ2S/A4/VhPzeCoGEWGIvwUxdAinLTktPw=; b=fJs++BWRu1L80oqr1LiM8lKvr
        2p+/X+z/CiqtQeg6Xz5WaxPUtuAaoG0ty3Z2pWs+Rmz1BzrZKrNIY+v9tawZJnubaGtRGR60AtTku
        1Xv+1mi74tbOPKGI87T/+pLVdxaNGTSpi1iTaGBsMrEyc8rjCVk5cxJU6Awr4hOSm+YGa+2ewYk/M
        fZBkMLc5XuHQLJ5bUhgtljP7RIQRl/LS+jssc5C2TPf5oi7KviTTdcueJaJGcKIFxudvKvUd9Ibml
        nsJwA48MT3L8l0zV81CdqKlh0Ph3E4KfcUyHJ2ZtVN7ZyIp8P3kme0AYgxfEt90uPoTE/JA51w4sq
        TOAHr/v0Q==;
Received: from [46.189.28.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iO18R-0006V8-AW
        for linux-xfs@vger.kernel.org; Fri, 25 Oct 2019 15:04:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/8] xfs: remove the extsize argument to xfs_eof_alignment
Date:   Fri, 25 Oct 2019 17:03:31 +0200
Message-Id: <20191025150336.19411-4-hch@lst.de>
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

And move the code dependent on it to the one caller that cares
instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index c803a8efa8ff..e3b11cda447e 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -118,8 +118,7 @@ xfs_iomap_end_fsb(
 
 static xfs_extlen_t
 xfs_eof_alignment(
-	struct xfs_inode	*ip,
-	xfs_extlen_t		extsize)
+	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_extlen_t		align = 0;
@@ -142,17 +141,6 @@ xfs_eof_alignment(
 			align = 0;
 	}
 
-	/*
-	 * Always round up the allocation request to an extent boundary
-	 * (when file on a real-time subvolume or has di_extsize hint).
-	 */
-	if (extsize) {
-		if (align)
-			align = roundup_64(align, extsize);
-		else
-			align = extsize;
-	}
-
 	return align;
 }
 
@@ -167,12 +155,22 @@ xfs_iomap_eof_align_last_fsb(
 {
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 	xfs_extlen_t		extsz = xfs_get_extsz_hint(ip);
-	xfs_extlen_t		align = xfs_eof_alignment(ip, extsz);
+	xfs_extlen_t		align = xfs_eof_alignment(ip);
 	struct xfs_bmbt_irec	irec;
 	struct xfs_iext_cursor	icur;
 
 	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
 
+	/*
+	 * Always round up the allocation request to the extent hint boundary.
+	 */
+	if (extsz) {
+		if (align)
+			align = roundup_64(align, extsz);
+		else
+			align = extsz;
+	}
+
 	if (align) {
 		xfs_fileoff_t	aligned_end_fsb = roundup_64(end_fsb, align);
 
@@ -992,7 +990,7 @@ xfs_buffered_write_iomap_begin(
 			p_end_fsb = XFS_B_TO_FSBT(mp, end_offset) +
 					prealloc_blocks;
 
-			align = xfs_eof_alignment(ip, 0);
+			align = xfs_eof_alignment(ip);
 			if (align)
 				p_end_fsb = roundup_64(p_end_fsb, align);
 
-- 
2.20.1

