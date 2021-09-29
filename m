Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88418C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Sep 2021 21:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DD08615A7
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Sep 2021 21:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344094AbhI2V0D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Sep 2021 17:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbhI2V0C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Sep 2021 17:26:02 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AF7C06161C;
        Wed, 29 Sep 2021 14:24:21 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id e7so4061500pgk.2;
        Wed, 29 Sep 2021 14:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fpo01N+lyyScDWgq92D1/O48N99YsmZj4WQK3k5r6Mo=;
        b=HM4oHczu6gs2h9KK3RI3VcgQwjbssZtyx7Vv2BcE3kGpF4b1QJ0oRybxE9aBl2GH1x
         /w43iWh5gjuSTpKtS8sxxcG9Nx1wNNO85Qtxd5GGBEa/2A2cjwEOni8csuVK8ApBzBN7
         kcxxhWAMjMt2ooGQ/7ZnOuMcCK7C46xyz4lCqBfF52Ejh88yWXA+xBfTqPqT0/dW+PG3
         bQFC3uszdafIr55L58NftLtzImjQfyIUEWtjQDdW8NYZYz4etC4EQ67Ze1hEImGxVg2A
         bkf6prnLYNE30FAdNKNU1zCSJ9zwkwQ9qh2FgxfoaemFCoKNbtsNS/X8reqnf8LZObtt
         p8qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fpo01N+lyyScDWgq92D1/O48N99YsmZj4WQK3k5r6Mo=;
        b=Z2o1r0B8rpGehp5xZoU874etkbQezOM54I/mrOFGvtDTpUYESiQVb6CBfRT5snagQg
         WC/ifWY7WmVsepgIotxuzjXpsGFCUqKkS1WuLiKb8Fhee1ClJ28Q3De12ZXwvwaRGYDE
         +PhINpoD9/j0kWvOtlWw47ocQuPagrbzMI6Q/XoDeyYjiZFV2bJ7Jp8jXFlCCVCQjsSz
         oncrndIsj/P7wPbQRf2c9rUWvv/5Utjpg1pSqFlYTDdlClx7lZeV7o9LqnwwvcSQs8x9
         kF9qary1Vv2vX1mJY2qfkK5JUxpAukK3Ks3KpBmkyJOq4xsw1BqvXAK2UlcCgy6N+i7b
         K82A==
X-Gm-Message-State: AOAM530mB8HyTVYyxto/YBQRt3mjB+8zZoCh+bntmKiGjb+2QZT2Nauo
        Cl3I+ZGdejzpeZ8b9X7uysA=
X-Google-Smtp-Source: ABdhPJz+Twh3I6xWm488muRPTJARlQ/8j0JckJWLWy34bu13dAChLYGq4WwFW2WNKGjs5i0N0T5qew==
X-Received: by 2002:a63:fb58:: with SMTP id w24mr1718437pgj.327.1632950660735;
        Wed, 29 Sep 2021 14:24:20 -0700 (PDT)
Received: from nuc10.aws.cis.local (d50-92-229-34.bchsia.telus.net. [50.92.229.34])
        by smtp.gmail.com with ESMTPSA id i5sm2689322pjk.47.2021.09.29.14.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 14:24:20 -0700 (PDT)
From:   Rustam Kovhaev <rkovhaev@gmail.com>
To:     djwong@kernel.org, linux-xfs@vger.kernel.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com,
        akpm@linux-foundation.org, vbabka@suse.cz
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        gregkh@linuxfoundation.org, Rustam Kovhaev <rkovhaev@gmail.com>
Subject: [PATCH] xfs: use kmem_cache_free() for kmem_cache objects
Date:   Wed, 29 Sep 2021 14:23:47 -0700
Message-Id: <20210929212347.1139666-1-rkovhaev@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

For kmalloc() allocations SLOB prepends the blocks with a 4-byte header,
and it puts the size of the allocated blocks in that header.
Blocks allocated with kmem_cache_alloc() allocations do not have that
header.

SLOB explodes when you allocate memory with kmem_cache_alloc() and then
try to free it with kfree() instead of kmem_cache_free().
SLOB will assume that there is a header when there is none, read some
garbage to size variable and corrupt the adjacent objects, which
eventually leads to hang or panic.

Let's make XFS work with SLOB by using proper free function.

Fixes: 9749fee83f38 ("xfs: enable the xfs_defer mechanism to process extents to free")
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
---
 fs/xfs/xfs_extfree_item.c | 6 +++---
 mm/slob.c                 | 6 ++++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 3f8a0713573a..a4b8caa2c601 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -482,7 +482,7 @@ xfs_extent_free_finish_item(
 			free->xefi_startblock,
 			free->xefi_blockcount,
 			&free->xefi_oinfo, free->xefi_skip_discard);
-	kmem_free(free);
+	kmem_cache_free(xfs_bmap_free_item_zone, free);
 	return error;
 }
 
@@ -502,7 +502,7 @@ xfs_extent_free_cancel_item(
 	struct xfs_extent_free_item	*free;
 
 	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-	kmem_free(free);
+	kmem_cache_free(xfs_bmap_free_item_zone, free);
 }
 
 const struct xfs_defer_op_type xfs_extent_free_defer_type = {
@@ -564,7 +564,7 @@ xfs_agfl_free_finish_item(
 	extp->ext_len = free->xefi_blockcount;
 	efdp->efd_next_extent++;
 
-	kmem_free(free);
+	kmem_cache_free(xfs_bmap_free_item_zone, free);
 	return error;
 }
 
diff --git a/mm/slob.c b/mm/slob.c
index 74d3f6e60666..d2d859ded5f8 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -389,7 +389,6 @@ static void slob_free(void *block, int size)
 
 	if (unlikely(ZERO_OR_NULL_PTR(block)))
 		return;
-	BUG_ON(!size);
 
 	sp = virt_to_page(block);
 	units = SLOB_UNITS(size);
@@ -556,6 +555,7 @@ void kfree(const void *block)
 	if (PageSlab(sp)) {
 		int align = max_t(size_t, ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
 		unsigned int *m = (unsigned int *)(block - align);
+		BUG_ON(!*m || *m > (PAGE_SIZE - align));
 		slob_free(m, *m + align);
 	} else {
 		unsigned int order = compound_order(sp);
@@ -649,8 +649,10 @@ EXPORT_SYMBOL(kmem_cache_alloc_node);
 
 static void __kmem_cache_free(void *b, int size)
 {
-	if (size < PAGE_SIZE)
+	if (size < PAGE_SIZE) {
+		BUG_ON(!size);
 		slob_free(b, size);
+	}
 	else
 		slob_free_pages(b, get_order(size));
 }
-- 
2.30.2

