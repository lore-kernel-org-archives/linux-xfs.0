Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE73CC1975A
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:17:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B69722071B
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:17:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uIHVBojd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbgCLORZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 10:17:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44720 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbgCLORZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 10:17:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=IZjtffZt8MC15d8DmDFE9wYG7MgRMJ7WQUAUks4hKLA=; b=uIHVBojd0ZQpOnvFvKn9pqfbod
        6YRU9rOhoMuh5QPV8ljuR+G7g9RHO5xoS/DtDD/xFc/hQd/eAHN2O1FqRjRQonIKeAPdOKz6pJ/3e
        KPeFkJaZVmsARzCFxkUXhF2GRJ/nQXqK8q+aLIPlMES0waUQRgLhEpbLzpZWo1bxAOD9mXQ5QCSWL
        TipKsjJtzYpm7q8oA+MMLkUtGdOYmOnDYnbiE6m/xmFgS38y1uQlfz3qRBAQRT4ucPZz+FvylF9x6
        3VovP6aHqIyKIjJi+8ShoNdHJ+QY/a9C3yB7fDPsycgO2PkuZqciJnWUaFAulu6OcOwlGKuQb+8wh
        UCztHPsQ==;
Received: from [2001:4bb8:184:5cad:8026:d98c:a056:3e33] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jCOeK-0001xY-Kp
        for linux-xfs@vger.kernel.org; Thu, 12 Mar 2020 14:17:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] libxfs: remove xfs_buf_oneshot
Date:   Thu, 12 Mar 2020 15:17:13 +0100
Message-Id: <20200312141715.550387-3-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312141715.550387-1-hch@lst.de>
References: <20200312141715.550387-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This function doesn't exist in the kernel and is purely a stub in
xfsprogs, so remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_priv.h | 2 --
 libxfs/xfs_sb.c      | 2 --
 2 files changed, 4 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 17a0104b..723dddcd 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -375,8 +375,6 @@ static inline struct xfs_buf *xfs_buf_incore(struct xfs_buftarg *target,
 	return NULL;
 }
 
-#define xfs_buf_oneshot(bp)		((void) 0)
-
 #define XBRW_READ			LIBXFS_BREAD
 #define XBRW_WRITE			LIBXFS_BWRITE
 #define xfs_buf_zero(bp,off,len)     libxfs_iomove(bp,off,len,NULL,LIBXFS_BZERO)
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 4f750d19..b931fee7 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -982,7 +982,6 @@ xfs_update_secondary_sbs(
 		}
 
 		bp->b_ops = &xfs_sb_buf_ops;
-		xfs_buf_oneshot(bp);
 		xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
 		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
 		xfs_buf_delwri_queue(bp, &buffer_list);
@@ -1170,7 +1169,6 @@ xfs_sb_get_secondary(
 	if (!bp)
 		return -ENOMEM;
 	bp->b_ops = &xfs_sb_buf_ops;
-	xfs_buf_oneshot(bp);
 	*bpp = bp;
 	return 0;
 }
-- 
2.24.1

