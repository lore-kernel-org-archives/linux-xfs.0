Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58524CA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 17:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26A1620684
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 17:42:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Quui3oSn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502620AbfJYRmR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 13:42:17 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39622 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393902AbfJYRmR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 13:42:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=U8hSuIb3/layaozFvCisdDDTKC2Oj7XbDvn4ulPQF/k=; b=Quui3oSn+yyxfgdFdx+P7WXt6
        gB9pR/TSh1UYCOOJrpottnj/upnGL2ijuFVCtptId/o9X+MHzR8ZuR+pnbIg9i4V6a+f7vB72A/rG
        EbALyU/s+ETRZzbiYraA8kWABX5PQ8MuJPSIy6keVopeTf0UG8OYHfxQA4mW5ZeN0sVIFXvbIkcU0
        F/PT6IwIeMfXPsFgknTCHZBbm0cyPxXmyylSZjh30/Euw5kyvl4Nb+ayf5D0kFhn7szxWaJfBauZ0
        BenB37CVRRKKzTd94FvYnH6fxWUHUuh1DYG+RUlMdpPKErsXB7DdpuFdzWpezGUkK59AxkqOxgkOW
        fF2yCa8sA==;
Received: from [88.128.80.25] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iO3bM-0005fR-TK
        for linux-xfs@vger.kernel.org; Fri, 25 Oct 2019 17:42:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: simplify setting bio flags
Date:   Fri, 25 Oct 2019 19:42:13 +0200
Message-Id: <20191025174213.32143-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Stop using the deprecated bio_set_op_attrs helper, and use a single
argument to xfs_buf_ioapply_map for the operation and flags.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9640e4174552..1e63dd3d1257 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1261,8 +1261,7 @@ xfs_buf_ioapply_map(
 	int		map,
 	int		*buf_offset,
 	int		*count,
-	int		op,
-	int		op_flags)
+	int		op)
 {
 	int		page_index;
 	int		total_nr_pages = bp->b_page_count;
@@ -1297,7 +1296,7 @@ xfs_buf_ioapply_map(
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_end_io = xfs_buf_bio_end_io;
 	bio->bi_private = bp;
-	bio_set_op_attrs(bio, op, op_flags);
+	bio->bi_opf = op;
 
 	for (; size && nr_pages; nr_pages--, page_index++) {
 		int	rbytes, nbytes = PAGE_SIZE - offset;
@@ -1342,7 +1341,6 @@ _xfs_buf_ioapply(
 {
 	struct blk_plug	plug;
 	int		op;
-	int		op_flags = 0;
 	int		offset;
 	int		size;
 	int		i;
@@ -1384,15 +1382,14 @@ _xfs_buf_ioapply(
 				dump_stack();
 			}
 		}
-	} else if (bp->b_flags & XBF_READ_AHEAD) {
-		op = REQ_OP_READ;
-		op_flags = REQ_RAHEAD;
 	} else {
 		op = REQ_OP_READ;
+		if (bp->b_flags & XBF_READ_AHEAD)
+			op |= REQ_RAHEAD;
 	}
 
 	/* we only use the buffer cache for meta-data */
-	op_flags |= REQ_META;
+	op |= REQ_META;
 
 	/*
 	 * Walk all the vectors issuing IO on them. Set up the initial offset
@@ -1404,7 +1401,7 @@ _xfs_buf_ioapply(
 	size = BBTOB(bp->b_length);
 	blk_start_plug(&plug);
 	for (i = 0; i < bp->b_map_count; i++) {
-		xfs_buf_ioapply_map(bp, i, &offset, &size, op, op_flags);
+		xfs_buf_ioapply_map(bp, i, &offset, &size, op);
 		if (bp->b_error)
 			break;
 		if (size <= 0)
-- 
2.20.1

