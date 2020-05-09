Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4100AC28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:01:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1512720820
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:01:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Xn+I222U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgEIRBf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 13:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbgEIRBf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:01:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC5AC061A0C
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 10:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=AGaHilT+W82c+WhEQITFCR0mDzGojbd789W6cjR07fU=; b=Xn+I222Up29l0wXB0tIsd7COzV
        XDmbKYYiPw9Ci3ZH5kAGSKngDpyuvRrsqir919xuxsEuv030kJtTYTQdzYDrzbJSGWYSXPBcrTi1D
        8AXxSsKAbY5755EOkioWmzTYBg5UGQdrRu2g+CsP+gzArFyw1lERZxyLPy6tz9anu9tfXiAEuBd5u
        TMCWDPjABE2KeF2NR8VhQPA9HUSYvzX7JR+Xa+ecdBFiM9ejctWyHasGsw/+6OFEA/l0Xk3XikPBs
        T8ZZu255XCU4oppAMppE00upD7PZsFY8FYFBNpxjV2GAxxh1fzZpZbFSu4qNx3aP2vVUP7RzXUT9Y
        pwaO8JMA==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXSr0-00064F-VK; Sat, 09 May 2020 17:01:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/8] db: add a comment to agfl_crc_flds
Date:   Sat,  9 May 2020 19:01:20 +0200
Message-Id: <20200509170125.952508-4-hch@lst.de>
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

Explain the bno field that is not actually part of the structure
anymore.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/agfl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/db/agfl.c b/db/agfl.c
index 45e4d6f9..ce7a2548 100644
--- a/db/agfl.c
+++ b/db/agfl.c
@@ -47,6 +47,7 @@ const field_t	agfl_crc_flds[] = {
 	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
 	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
 	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
+	/* the bno array really is behind the actual structure */
 	{ "bno", FLDT_AGBLOCKNZ, OI(bitize(sizeof(struct xfs_agfl))),
 	  agfl_bno_size, FLD_ARRAY|FLD_COUNT, TYP_DATA },
 	{ NULL }
-- 
2.26.2

