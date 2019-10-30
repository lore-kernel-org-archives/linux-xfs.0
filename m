Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 014C1CA9EC5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 18:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C850D2087E
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 18:04:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d1O3BXuo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbfJ3SEn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 14:04:43 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38376 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727715AbfJ3SEn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 14:04:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=b5K8Q42Cd17bPxIdnMyp19GHexclgFFQnCwKVGOG6ss=; b=d1O3BXuokWVkGcAQFRRvzz6ks
        VFO23N/bKJYltwlGbhWfHYJJDNetKEsm7PnO6qVFvGq1yKSrF1RZI+gpYqoOaXeZbBbxjxpKf+TzU
        xRGHnJHu1NIkGeNrX85DnysMtS8CnFhwMaywzeTKWTmappqESreTaTNB2F/Ov9yRdV8UvfNEFBqIK
        EseihsWuwJyxF4SU5d9BssU/RljrOOJ7GUxrRnK2Opc8xWv0/T5Ci1la3eA+otBUojbIpGSrKpuxT
        0GrJ6d/03SRbNNcvFzKed11LOZmIJ9vbzttjxqNKrT/3GyrJGtd6HlYu7kOr8wltYJ8QwaMbk8beU
        Br7TQ49dQ==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPsKp-0005ev-4W
        for linux-xfs@vger.kernel.org; Wed, 30 Oct 2019 18:04:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/9] xfs: remove the extsize argument to xfs_eof_alignment
Date:   Wed, 30 Oct 2019 11:04:13 -0700
Message-Id: <20191030180419.13045-4-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030180419.13045-1-hch@lst.de>
References: <20191030180419.13045-1-hch@lst.de>
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
index 02526cffc5a3..c21c4f7a7389 100644
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

