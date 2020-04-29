Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18BA0C83004
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:05:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED59121973
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:05:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nUVLq8ir"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbgD2PFn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 11:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgD2PFn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 11:05:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD96C03C1AD
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 08:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=A0S/UfA6GN6hlspuUUWhsIjGpJkYsZFPxv30ND+fBwQ=; b=nUVLq8iraVlZ6WBtN9jQ7snBHk
        tNGjJ/E1tyo6bJHLJ+1ARx143EMNTL4BK8akp5lfLri4e01AiTDUWkMDt8Tof81zmaQ224LoYiX2x
        7AG9ODdP3ywnP2yNX8fliAr7kZobbYhmpfBiYTIuUf+V2LX0+s8lh2JhKuOf8+WFf5EkvrSpH9pDC
        UouwltplpI3UFux+DNuxwo6oxO7U1HmJANexCsRRk7Og3MIsA+PnRODgyDQ96ry+GM/yU/SE1U86e
        sH1N17psL13K1/MTcypi5H0cwPxnxK7BFxSFkEiX0PeS77ecr4kwAI5ofiVabMjVoRGFzzxaVbkwF
        FfaIlRpQ==;
Received: from [2001:4bb8:184:1b25:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jToHO-0000Ee-TV
        for linux-xfs@vger.kernel.org; Wed, 29 Apr 2020 15:05:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/11] xfs: spell out the parameter name for ->cancel_item
Date:   Wed, 29 Apr 2020 17:05:11 +0200
Message-Id: <20200429150511.2191150-12-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200429150511.2191150-1-hch@lst.de>
References: <20200429150511.2191150-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_defer.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index f2b65981bace4..3bf7c2c4d8514 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -53,7 +53,7 @@ struct xfs_defer_op_type {
 			struct list_head *item, struct xfs_btree_cur **state);
 	void (*finish_cleanup)(struct xfs_trans *tp,
 			struct xfs_btree_cur *state, int error);
-	void (*cancel_item)(struct list_head *);
+	void (*cancel_item)(struct list_head *item);
 	unsigned int		max_items;
 };
 
-- 
2.26.2

