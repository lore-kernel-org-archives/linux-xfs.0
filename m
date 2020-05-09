Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE9ECC28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:01:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93FA921775
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:01:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SgRwWHsk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgEIRBd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 13:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbgEIRBd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:01:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05155C061A0C
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 10:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=/STfsfv1NYUsCa7XzMc4HQKvRRCmwXrYWaLCjCgbPC4=; b=SgRwWHsk9yf+4NM33/phtRbxot
        2aKMCSKDCgxtm7ZNZngRP8dYUEnhjuV6qPhJnPSqJF/JkKMryArVtO1SsssC3uLE1pDH2pE5z3H0H
        DHE6+KUQSZkbojGulu2t4lZv1n4Hq/pZ1a8s9p7zb7c8v3kmnPgAPcYOb7bs/bFIOg43R8CeHZVir
        bSLmfhWHpcpdzxuTFYjKBTGR14pqAg9v/I5gBIgpJpakFdRzVf4jt8/GpomQZrPrvNa8eBuLc3zWh
        505djy+pkq9R81Oi6O9m01x4rm6k9PluEGFoiRn8zmPtE9gDD8scLLMizrr/6PDyPpWL/yVWMQXie
        NLLeFgDA==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXSqy-00063p-Ho; Sat, 09 May 2020 17:01:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/8] db: fix a comment in scan_freelist
Date:   Sat,  9 May 2020 19:01:19 +0200
Message-Id: <20200509170125.952508-3-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200509170125.952508-1-hch@lst.de>
References: <20200509170125.952508-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS_BUF_TO_AGFL_BNO has been renamed to open coded xfs_buf_to_agfl_bno.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db/check.c b/db/check.c
index c9bafa8e..09f8f6c9 100644
--- a/db/check.c
+++ b/db/check.c
@@ -4075,7 +4075,7 @@ scan_freelist(
 		return;
 	}
 
-	/* open coded XFS_BUF_TO_AGFL_BNO */
+	/* open coded xfs_buf_to_agfl_bno */
 	state.count = 0;
 	state.agno = seqno;
 	libxfs_agfl_walk(mp, agf, iocur_top->bp, scan_agfl, &state);
-- 
2.26.2

