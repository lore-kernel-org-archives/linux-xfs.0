Return-Path: <SRS0=l9EO=4S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 853CAC3F2D1
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Mar 2020 14:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F27A222C4
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Mar 2020 14:49:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UFx6EqO6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgCAOtZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Mar 2020 09:49:25 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:36980 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgCAOtZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Mar 2020 09:49:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=80k9d0sIP5BQ0ug3nQTjhEVnrYzd3GWYIYyMs8qas/k=; b=UFx6EqO6/5TNaR2xN+ek+xVMgm
        1Xt18Gual5Ih9uuHP6j2J+XxAK/l3Dauopch+4sBZH8Hkn+qNJF/JaOvPSgJP6dFxvAsjf/VrS5ST
        +1BD/0rm/yOeCuhRB5IMp3Ks5KyQWFK/bc4K1Tmqnzpw3QOpYCUY4h3XFkm4UY2oTvV8sYbhRsHFp
        m9UN5Z4x6fg3jmXN4M8ppf+Zo1/dStrDFHRvAKQX0q+0VIUAoe2sHT4ImlvrRLkqJiUupMClgdZYz
        NCbwRSuq+zfRxBPGzSF4cq2bI6J5BVQ4cPC+q8avWI0DqTQ5JWi0NZArModwHtsH88ikLCxKoWryX
        Suy+39MQ==;
Received: from 216-129-237-83.3rivers.net ([216.129.237.83] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j8PuH-0004cC-Az
        for linux-xfs@vger.kernel.org; Sun, 01 Mar 2020 14:49:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] iomap: don't override sis->bdev in xfs_iomap_swapfile_activate
Date:   Sun,  1 Mar 2020 07:49:25 -0700
Message-Id: <20200301144925.48343-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The swapon code itself sets sis->bdev up early, and performs various check
on the block devices.  Changing it later in the fact thus will cause a
mismatch of capabilities and must be avoided.  The practical implication
of this change is that it forbids swapping to the RT subvolume, which might
have had all kinds of issues anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 58e937be24ce..f9929a952ef1 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -637,7 +637,6 @@ xfs_iomap_swapfile_activate(
 	struct file			*swap_file,
 	sector_t			*span)
 {
-	sis->bdev = xfs_inode_buftarg(XFS_I(file_inode(swap_file)))->bt_bdev;
 	return iomap_swapfile_activate(sis, swap_file, span,
 			&xfs_read_iomap_ops);
 }
-- 
2.24.1

