Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52C2DC4BA21
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19F5524656
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:26:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oUQ1t8dQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbgBZU0C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 15:26:02 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:36514 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727260AbgBZU0C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 15:26:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=FbTDfEku8X3sYEROnPmmi7MHgFo6VxbiNSURZ/ir73Y=; b=oUQ1t8dQUUweyoWB1zNTzKhZep
        42AyF3doegAq31fyyBnxtuQDiEijel4Y77hBOUTTMTCbDHf7Uvrnxlp83zRW1cx4cFOg4xr2UC68e
        IHy3bQD9Wjyd/Wn+7ovxYwpNV3ZrnmKi+wJlanGW45noQHiHb+ILMm/j1etO5YlrzS87W+sRrcrAI
        CNHB7cXUI79Z0gf1QF22EhUC2XDXwfLerth2c5g9z1kLiuzcFmAJOfEUGmixDw/DxdOBPAlpyqsDD
        zc0Zc8cyzrBa43QUc743QD2edq4B53DtmQvVPZMP0El9Mf2MVELr8X3Ux2oce1IMuIeP4t0NNVVzJ
        gFynLBYA==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j73Fq-0001cf-Bp; Wed, 26 Feb 2020 20:26:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 32/32] xfs: switch xfs_attrmulti_attr_get to lazy attr buffer allocation
Date:   Wed, 26 Feb 2020 12:23:06 -0800
Message-Id: <20200226202306.871241-33-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226202306.871241-1-hch@lst.de>
References: <20200226202306.871241-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Let the low-level attr code only allocate the needed buffer size
for xfs_attrmulti_attr_get instead of allocating the upper bound
at the top of the call chain.

Suggested-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index c805fdf4ea39..47a92400929b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -481,10 +481,6 @@ xfs_attrmulti_attr_get(
 	if (*len > XFS_XATTR_SIZE_MAX)
 		return -EINVAL;
 
-	args.value = kmem_zalloc_large(*len, 0);
-	if (!args.value)
-		return -ENOMEM;
-
 	error = xfs_attr_get(&args);
 	if (error)
 		goto out_kfree;
-- 
2.24.1

