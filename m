Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57F18C433ED
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 08:28:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BA6D61151
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 08:28:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237800AbhDSI2v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Apr 2021 04:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237793AbhDSI2v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Apr 2021 04:28:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0956C06174A
        for <linux-xfs@vger.kernel.org>; Mon, 19 Apr 2021 01:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=2NZEJPx3bmWJdRbgGXznjR5yFVm7sffKVztDkWG5Zq8=; b=jNbNdiGM1SyK2VaRGsyv47B6wU
        zHiYmYBLtgCovYqsUKeXD32k0W+BTeNsUqntpAMh8yUq8c14TZEhTZjKt5ZuEoPmEJkoL8FVlQ797
        6jwqarZHMXooDe6p48/MqbnrAMELBUfqQnE4cIz91EQURQul1z5mtqNPDcqBlUeRHsZpWsAsyEx6m
        f4MqCJUABGZci2cqW0Hhk82FujY8+YalYsho27GoxTv8huSyHU/ylJ93APxTNGi4ICtbOQccE3cuZ
        nk1bqoBWGAADGmsaNoa8mYxhki21YQJ4gRMl48VM56UQYaqnDznhNIGRoFFsPJNlJBA3h3/rlUvaZ
        AGqdYn9g==;
Received: from [2001:4bb8:19b:f845:9ac9:3ef5:afc7:c325] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lYPGX-00BBeg-4C; Mon, 19 Apr 2021 08:28:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: [PATCH 5/7] xfs: add a xfs_efi_item_sizeof helper
Date:   Mon, 19 Apr 2021 10:28:02 +0200
Message-Id: <20210419082804.2076124-6-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210419082804.2076124-1-hch@lst.de>
References: <20210419082804.2076124-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add a helper to calculate the size of an xfs_efi_log_item structure
the specified number of extents.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_extfree_item.c | 10 +++-------
 fs/xfs/xfs_extfree_item.h |  6 ++++++
 fs/xfs/xfs_super.c        |  6 ++----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index f15d6cfca6e2f1..afd568d426c1f1 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -153,17 +153,13 @@ xfs_efi_init(
 
 {
 	struct xfs_efi_log_item	*efip;
-	uint			size;
 
 	ASSERT(nextents > 0);
-	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
-		size = (uint)(sizeof(struct xfs_efi_log_item) +
-			((nextents - 1) * sizeof(struct xfs_extent)));
-		efip = kmem_zalloc(size, 0);
-	} else {
+	if (nextents > XFS_EFI_MAX_FAST_EXTENTS)
+		efip = kmem_zalloc(xfs_efi_item_sizeof(nextents), 0);
+	else
 		efip = kmem_cache_zalloc(xfs_efi_zone,
 					 GFP_KERNEL | __GFP_NOFAIL);
-	}
 
 	xfs_log_item_init(mp, &efip->efi_item, XFS_LI_EFI, &xfs_efi_item_ops);
 	efip->efi_format.efi_nextents = nextents;
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index e09afd0f63ff59..d2577d872de771 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -52,6 +52,12 @@ struct xfs_efi_log_item {
 	struct xfs_efi_log_format efi_format;
 };
 
+static inline int xfs_efi_item_sizeof(unsigned int nextents)
+{
+	return sizeof(struct xfs_efi_log_item) +
+		(nextents - 1) * sizeof(struct xfs_extent);
+}
+
 /*
  * This is the "extent free done" log item.  It is used to log
  * the fact that some extents earlier mentioned in an efi item
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index a2dab05332ac27..c93710cb5ce3f0 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1961,10 +1961,8 @@ xfs_init_zones(void)
 		goto out_destroy_buf_item_zone;
 
 	xfs_efi_zone = kmem_cache_create("xfs_efi_item",
-					 (sizeof(struct xfs_efi_log_item) +
-					 (XFS_EFI_MAX_FAST_EXTENTS - 1) *
-					 sizeof(struct xfs_extent)),
-					 0, 0, NULL);
+			xfs_efi_item_sizeof(XFS_EFI_MAX_FAST_EXTENTS),
+			0, 0, NULL);
 	if (!xfs_efi_zone)
 		goto out_destroy_efd_zone;
 
-- 
2.30.1

