Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB66FC433B4
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 08:28:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FF9B61151
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 08:28:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbhDSI2q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Apr 2021 04:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237793AbhDSI2p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Apr 2021 04:28:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA31AC06174A
        for <linux-xfs@vger.kernel.org>; Mon, 19 Apr 2021 01:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=FqBsQpEwwDFf47/L/QYdNz4FeQbApUMOflynF/ZTZuA=; b=e5d2ADtCoZKpjw7KkgYRc/N4nU
        XUSa2mov2S5MwUvJbvHtQnrPMF87NItz51YqJihyctwEkKaeDDN9cKwCWIXVzLRowHLHnagUIcdSA
        Xd2xXNm+m3O/hyRi/XkWkEG5XoNjyyVfvcw/fOobkfhQ1xELZSCdDfV65zVT7VwkutzTQJuDTq2vF
        07cPjAk7sCa9g/nqU/MU+35s55CrlBo5kG5g9ulu3kW+3MuxebsqbEq8vSVk69C86VIEttBRPZgcH
        wPKDuWe4t4lV3J5UW+hhVwD8A4ON42Vmx37ELqjH8sUnsxbtfvuyxADCnpSGKUbe89VLA3vhjs3gS
        rzYUKBeg==;
Received: from [2001:4bb8:19b:f845:9ac9:3ef5:afc7:c325] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lYPGR-00BBdh-Up; Mon, 19 Apr 2021 08:28:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: [PATCH 3/7] xfs: pass a xfs_efi_log_item to xfs_efi_item_sizeof
Date:   Mon, 19 Apr 2021 10:28:00 +0200
Message-Id: <20210419082804.2076124-4-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210419082804.2076124-1-hch@lst.de>
References: <20210419082804.2076124-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_efi_log_item only looks at the embedded xfs_efi_log_item structure,
so pass that directly and rename the function to xfs_efi_log_item_sizeof.
This allows using the helper in xlog_recover_efi_commit_pass2 as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_extfree_item.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index ed8d0790908ea7..7ae570d1944590 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -70,11 +70,11 @@ xfs_efi_release(
  * structure.
  */
 static inline int
-xfs_efi_item_sizeof(
-	struct xfs_efi_log_item *efip)
+xfs_efi_log_item_sizeof(
+	struct xfs_efi_log_format *elf)
 {
-	return sizeof(struct xfs_efi_log_format) +
-	       (efip->efi_format.efi_nextents - 1) * sizeof(struct xfs_extent);
+	return sizeof(*elf) +
+	       (elf->efi_nextents - 1) * sizeof(struct xfs_extent);
 }
 
 STATIC void
@@ -84,7 +84,7 @@ xfs_efi_item_size(
 	int			*nbytes)
 {
 	*nvecs += 1;
-	*nbytes += xfs_efi_item_sizeof(EFI_ITEM(lip));
+	*nbytes += xfs_efi_log_item_sizeof(&EFI_ITEM(lip)->efi_format);
 }
 
 /*
@@ -110,7 +110,7 @@ xfs_efi_item_format(
 
 	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_EFI_FORMAT,
 			&efip->efi_format,
-			xfs_efi_item_sizeof(efip));
+			xfs_efi_log_item_sizeof(&efip->efi_format));
 }
 
 
@@ -684,8 +684,7 @@ xlog_recover_efi_commit_pass2(
 
 	efip = xfs_efi_init(mp, src->efi_nextents);
 
-	if (buf->i_len != sizeof(*src) +
-	    (src->efi_nextents - 1) * sizeof(struct xfs_extent)) {
+	if (buf->i_len != xfs_efi_log_item_sizeof(src)) {
 		error = xfs_efi_copy_format_32(&efip->efi_format, buf);
 		if (error)
 			goto out_free_efi;
-- 
2.30.1

