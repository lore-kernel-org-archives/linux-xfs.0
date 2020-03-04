Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D3ACC3F2CD
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 14:23:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72DD221775
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 14:23:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IIcJhveN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbgCDOW7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 09:22:59 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:41146 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbgCDOW7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 09:22:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Type:MIME-Version:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=AnbrYHfpg3ftWazDwotORReAOaIVQFxlC0lPYzO9Yq8=; b=IIcJhveN6A4+vTmO7IuKo+YtEO
        Y2gwjm6u8Yu2uWohjfQUqTGadI6U92dDBfsVWpS2yJAtT/L/IevjKw8lDK0j5siO++lIwZu67R+0t
        RiaBM9PScHuj+6VbI7+ih1UPTh4iJqVjvGRCdQfZoZQtYfGoLYja12Aoe/qe8wGOgNeIq9sHTTK48
        quQWCNVpBeRWBU6N1HPxQNAtjbXhEGBFCg7mkg/Onertb2gYdklEXkQ7J0lwkWyTfW3IMypKk5bH8
        UtxmAEoHagsFl1vOMBGHuJq66oreUNJZMB2ji7xEkjwvawyiHH4mRwFzBUkZYZepWHjQoVr1k7kfT
        xj5dy3VA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j9UvL-0004Na-Cr; Wed, 04 Mar 2020 14:22:59 +0000
Date:   Wed, 4 Mar 2020 06:22:59 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     linux-xfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] iomap: Fix writepage tracepoint pgoff
Message-ID: <20200304142259.GF29971@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

page_offset() confusingly returns the number of bytes from the
beginning of the file and not the pgoff, which the tracepoint claims
to be returning.  We're already returning the number of bytes from the
beginning of the file in the 'offset' parameter, so correct the pgoff
to be what was apparently intended.

Fixes: 0b1b213fcf3a ("xfs: event tracing support")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

diff --git a/fs/iomap/trace.h b/fs/iomap/trace.h
index d6ba705f938a..ebc89ec5e6c7 100644
--- a/fs/iomap/trace.h
+++ b/fs/iomap/trace.h
@@ -56,7 +56,7 @@ DECLARE_EVENT_CLASS(iomap_page_class,
 	TP_fast_assign(
 		__entry->dev = inode->i_sb->s_dev;
 		__entry->ino = inode->i_ino;
-		__entry->pgoff = page_offset(page);
+		__entry->pgoff = page->index;
 		__entry->size = i_size_read(inode);
 		__entry->offset = off;
 		__entry->length = len;

