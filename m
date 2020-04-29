Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46EFBC83004
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15FB821973
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:05:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Qfd6J4vy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgD2PFW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 11:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgD2PFW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 11:05:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74CF9C03C1AD
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 08:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=oaS46k0yHjVMU5EAdpv+J3H8uURnXBtnV59MWNFcY9I=; b=Qfd6J4vye9mLjST6HyDorhnCkT
        z5g2JTxKkIcWjyT2Gs5kkTLPey5JsKnsB0Lb7666ippiYa/oUon4A5ZRoHGfONrMqwBy9R8sBbjML
        sJItslV/TfxWfFwTPTe17N9xFh4E95/bwZQKHLG/NHmUdhyOqkdoC5c4UG1dM3OVkLvi5lgoVlg/I
        4S1lvl8NWwNYvuju58Hyt65Z2dj12wZ0Jll0c6FLrGudLq+uOOwFUUdnUXkaazJUYRHA8ATe/uRrV
        nO/0GxVB4J5usZG9scxciwSrj4rkPPXQrRoDhmskgG5fHLidRjGzpFxLEtxVwha5mSjvTVtYRoWHa
        tVqwYCDQ==;
Received: from [2001:4bb8:184:1b25:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jToH3-00009M-0F
        for linux-xfs@vger.kernel.org; Wed, 29 Apr 2020 15:05:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/11] xfs: remove the xfs_efd_log_item_t typedef
Date:   Wed, 29 Apr 2020 17:05:02 +0200
Message-Id: <20200429150511.2191150-3-hch@lst.de>
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
 fs/xfs/xfs_extfree_item.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index b9b567f355756..a2a736a77fa94 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -63,12 +63,12 @@ struct xfs_efi_log_item {
  * the fact that some extents earlier mentioned in an efi item
  * have been freed.
  */
-typedef struct xfs_efd_log_item {
+struct xfs_efd_log_item {
 	struct xfs_log_item	efd_item;
 	struct xfs_efi_log_item *efd_efip;
 	uint			efd_next_extent;
 	xfs_efd_log_format_t	efd_format;
-} xfs_efd_log_item_t;
+};
 
 /*
  * Max number of extents in fast allocation path.
-- 
2.26.2

