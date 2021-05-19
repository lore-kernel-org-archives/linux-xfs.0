Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0424BC433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 19:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D224F61355
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 19:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbhESTKa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 15:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbhESTK3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 15:10:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB78DC06175F
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 12:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=sEvN4wbnrNGuJC8KyW2G4QemhIYm0FE4LiU5k5c0EM8=; b=RCfGk7x8FNfpCg3S/m7AaOB4BS
        ug2murqwqAAkmkHh8fHWMGriKWsNS+oQOKFc8dGUIr95EBcJMoL2LHPfB5jY+DJKbHew6aFI0IHpI
        URB2oOwEayD6x5uU43OPiLT0Br4EnMZnRaxWkNxNTuyyju6Jt4e0IDPbneHN1UTNSDJ37BCIRZLlS
        s/Thwudf5s+7mErbaEM9AjVdOnOKBNt2MlFgrPe0Ow1CEK3t9dxi9B7ly0LhmQJuj/3Xk4w//GOOG
        ZmvCJWRjRo4xlHX1uKt7Z9c/SmpKW2/FqbzNuRjaZuLRjOQ4rvMvPIoLmFxV09aEMXldAjmp66dO9
        40ESmN8Q==;
Received: from [2001:4bb8:180:5add:9e44:3522:a0e8:f6e] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ljRZ5-00Fis8-VZ; Wed, 19 May 2021 19:09:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/11] xfs: cleanup error handling in xfs_buf_get_map
Date:   Wed, 19 May 2021 21:08:50 +0200
Message-Id: <20210519190900.320044-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210519190900.320044-1-hch@lst.de>
References: <20210519190900.320044-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use a single goto label for freeing the buffer and returning an error.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 592800c8852f45..80be0333f077c0 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -721,16 +721,12 @@ xfs_buf_get_map(
 		return error;
 
 	error = xfs_buf_allocate_memory(new_bp, flags);
-	if (error) {
-		xfs_buf_free(new_bp);
-		return error;
-	}
+	if (error)
+		goto out_free_buf;
 
 	error = xfs_buf_find(target, map, nmaps, flags, new_bp, &bp);
-	if (error) {
-		xfs_buf_free(new_bp);
-		return error;
-	}
+	if (error)
+		goto out_free_buf;
 
 	if (bp != new_bp)
 		xfs_buf_free(new_bp);
@@ -758,6 +754,9 @@ xfs_buf_get_map(
 	trace_xfs_buf_get(bp, flags, _RET_IP_);
 	*bpp = bp;
 	return 0;
+out_free_buf:
+	xfs_buf_free(new_bp);
+	return error;
 }
 
 int
-- 
2.30.2

