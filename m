Return-Path: <SRS0=7N5F=AB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35533C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Jun 2020 07:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0430B224DF
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Jun 2020 07:11:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Fcyq4cVJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgFTHLL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Jun 2020 03:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgFTHLL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Jun 2020 03:11:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085AFC06174E
        for <linux-xfs@vger.kernel.org>; Sat, 20 Jun 2020 00:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=s08CNxfQbDYwMpeNCAY8xGzDD3UIcTw768uLtAWmwzI=; b=Fcyq4cVJCtDI0F/VtVsAmvex/F
        rWV/1hQqv7ZUPKrdgD6GqusWqimzNjKnLlzQKIoKKRtp1z9c4qQ84ZfOU7mRM8AUCM0jprIQH/k1r
        Rs9bTdsVg9gHs/NxCTW1tKKReu13X6L7fk8qUoLGaeZcSadwvAQawIYTrhwShGMm4w8Kqztao/IPh
        O5RFMZVcRCA2m3NndytkyiTIxwB/jt3R0dySg2Ieq4/qLPdjqlYa+SGMKi/SXskZYUM6bZghMcz0u
        O3yp5ar0EBDPzwshY/O87+zszvsHCd3oY1mEzrkxI4hyrPXgw5KulTM+I1I3jqHjzWBHm6nmN7J2i
        YLUj9DrQ==;
Received: from 195-192-102-148.dyn.cablelink.at ([195.192.102.148] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jmXee-0000xN-8u
        for linux-xfs@vger.kernel.org; Sat, 20 Jun 2020 07:11:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/15] xfs: don't clear the "dinode core" in xfs_inode_alloc
Date:   Sat, 20 Jun 2020 09:10:48 +0200
Message-Id: <20200620071102.462554-2-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200620071102.462554-1-hch@lst.de>
References: <20200620071102.462554-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The xfs_icdinode structure just contains a random mix of inode field,
which are all read from the on-disk inode and mostly not looked at
before reading the inode or initializing a new inode cluster.  The
only exceptions are the forkoff and blocks field, which are used
in sanity checks for freshly allocated inodes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 0a5ac6f9a58349..660e7abd4e8b76 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -66,7 +66,8 @@ xfs_inode_alloc(
 	memset(&ip->i_df, 0, sizeof(ip->i_df));
 	ip->i_flags = 0;
 	ip->i_delayed_blks = 0;
-	memset(&ip->i_d, 0, sizeof(ip->i_d));
+	ip->i_d.di_nblocks = 0;
+	ip->i_d.di_forkoff = 0;
 	ip->i_sick = 0;
 	ip->i_checked = 0;
 	INIT_WORK(&ip->i_ioend_work, xfs_end_io);
-- 
2.26.2

