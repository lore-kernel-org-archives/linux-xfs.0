Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99005E81E1E
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 18:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbjJFSyA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 14:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233294AbjJFSxy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 14:53:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5045DE
        for <linux-xfs@vger.kernel.org>; Fri,  6 Oct 2023 11:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696618348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nu0z1c/0eDrJgBAtNTkFM1hnZGQ4PO6Tjoiby57zXqo=;
        b=Cys0aEujxFjb8+tZ86eFszpmg+8QCubbli8thVxvqyH8V+/kvN89LNG7sqtbAqSSLWJqQa
        A59j93peAxRDob2qqTJDwPaNP5dJK9sy/yz6UIuPsNiI5m7TvreN+R6IWrAPzWq9DMSl3N
        sxboPXSNj+Iu0ZqjlNh42opzESou7/Y=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-y5vxNRP3OXWW99dMM_3Ulg-1; Fri, 06 Oct 2023 14:52:26 -0400
X-MC-Unique: y5vxNRP3OXWW99dMM_3Ulg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-9adad8f306fso197833566b.0
        for <linux-xfs@vger.kernel.org>; Fri, 06 Oct 2023 11:52:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696618345; x=1697223145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nu0z1c/0eDrJgBAtNTkFM1hnZGQ4PO6Tjoiby57zXqo=;
        b=RHgLBoPntaW+ANYhNSZKEwdh96tYBjupS1eBJxHyXdzeirBwyqAI9LJaWg71AHEEIV
         iVyQYi/HGXvec+QrssGEaDbgR3OlKmZHcBfiCUrnKXXb/q01To3mO1q/xG6un90hlBS0
         3zvtUQZgEAsWfUieZAa50+TYmWi31miphNiJmslTbyhihHi35jkrSRf4dAo5u5sPr3Xm
         ax2xMc9DUTr6EJlsbmMvqzmRdsbhIsBNWQWMBXnT6L/aYqEnqMc3VD7G60TLCpQpzqEY
         MjK9dTYpgAOBS7/Blwkpg4qsGKpNgzdqTNL+n9QihQYoLkpMSqhzLzxf9mluijGS4G5Z
         M2Sg==
X-Gm-Message-State: AOJu0Ywaax6xfNijFLwL8nGYg33BZmbLTV0WH7tYH7RaqHAj75rStLpF
        OY8CHixdCj0yXFI2Jj7zTZ5yO8O9W1ffUrC25ulTvFjQOw+VHWY2gEkgwLd2+sg4UA2v4Yrcqmr
        ysRir2dZIbhvrI6w1TfKvcP5n+j24L+GiekuYx2wqZZUCEreXWhzVnR7WZl8FPvXjAZQIj4M4dp
        HZVeY=
X-Received: by 2002:a17:907:763b:b0:9b6:582e:be5e with SMTP id jy27-20020a170907763b00b009b6582ebe5emr8346633ejc.60.1696618345117;
        Fri, 06 Oct 2023 11:52:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IENatGxYpE7Tp1bpesC4eUgkJNnUC/i6HuVX71rQKaEwcb3B5NgFaf4ClmswaYc3r8y8XAfKA==
X-Received: by 2002:a17:907:763b:b0:9b6:582e:be5e with SMTP id jy27-20020a170907763b00b009b6582ebe5emr8346617ejc.60.1696618344867;
        Fri, 06 Oct 2023 11:52:24 -0700 (PDT)
Received: from localhost.localdomain ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id os5-20020a170906af6500b009b947f81c4asm3304741ejb.155.2023.10.06.11.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 11:52:24 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     djwong@kernel.org, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v3 07/28] fsverity: always use bitmap to track verified status
Date:   Fri,  6 Oct 2023 20:49:01 +0200
Message-Id: <20231006184922.252188-8-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231006184922.252188-1-aalbersh@redhat.com>
References: <20231006184922.252188-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The bitmap is used to track verified status of the Merkle tree
blocks which are smaller than a PAGE. Blocks which fits exactly in a
page - use PageChecked() for tracking "verified" status.

This patch switches to always use bitmap to track verified status.
This is needed to move fs-verity away from page management and work
only with Merkle tree blocks.

Also, this patch removes spinlock. The lock was used to reset bits
in bitmap belonging to one page. This patch works only with one
Merkle tree block and won't reset other blocks status.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/verity/fsverity_private.h |  1 -
 fs/verity/open.c             | 49 ++++++++++++-------------
 fs/verity/verify.c           | 71 +++++-------------------------------
 3 files changed, 33 insertions(+), 88 deletions(-)

diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index d071a6e32581..9611eeae3527 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -69,7 +69,6 @@ struct fsverity_info {
 	u8 file_digest[FS_VERITY_MAX_DIGEST_SIZE];
 	const struct inode *inode;
 	unsigned long *hash_block_verified;
-	spinlock_t hash_page_init_lock;
 };
 
 #define FS_VERITY_MAX_SIGNATURE_SIZE	(FS_VERITY_MAX_DESCRIPTOR_SIZE - \
diff --git a/fs/verity/open.c b/fs/verity/open.c
index 6c31a871b84b..dfb9fe6aaae9 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -182,6 +182,7 @@ struct fsverity_info *fsverity_create_info(const struct inode *inode,
 {
 	struct fsverity_info *vi;
 	int err;
+	unsigned long num_bits;
 
 	vi = kmem_cache_zalloc(fsverity_info_cachep, GFP_KERNEL);
 	if (!vi)
@@ -213,33 +214,29 @@ struct fsverity_info *fsverity_create_info(const struct inode *inode,
 	if (err)
 		goto fail;
 
-	if (vi->tree_params.block_size != PAGE_SIZE) {
-		/*
-		 * When the Merkle tree block size and page size differ, we use
-		 * a bitmap to keep track of which hash blocks have been
-		 * verified.  This bitmap must contain one bit per hash block,
-		 * including alignment to a page boundary at the end.
-		 *
-		 * Eventually, to support extremely large files in an efficient
-		 * way, it might be necessary to make pages of this bitmap
-		 * reclaimable.  But for now, simply allocating the whole bitmap
-		 * is a simple solution that works well on the files on which
-		 * fsverity is realistically used.  E.g., with SHA-256 and 4K
-		 * blocks, a 100MB file only needs a 24-byte bitmap, and the
-		 * bitmap for any file under 17GB fits in a 4K page.
-		 */
-		unsigned long num_bits =
-			vi->tree_params.tree_pages <<
-			vi->tree_params.log_blocks_per_page;
+	/*
+	 * We use a bitmap to keep track of which hash blocks have been
+	 * verified.  This bitmap must contain one bit per hash block,
+	 * including alignment to a page boundary at the end.
+	 *
+	 * Eventually, to support extremely large files in an efficient
+	 * way, it might be necessary to make pages of this bitmap
+	 * reclaimable.  But for now, simply allocating the whole bitmap
+	 * is a simple solution that works well on the files on which
+	 * fsverity is realistically used.  E.g., with SHA-256 and 4K
+	 * blocks, a 100MB file only needs a 24-byte bitmap, and the
+	 * bitmap for any file under 17GB fits in a 4K page.
+	 */
+	num_bits =
+		vi->tree_params.tree_pages <<
+		vi->tree_params.log_blocks_per_page;
 
-		vi->hash_block_verified = kvcalloc(BITS_TO_LONGS(num_bits),
-						   sizeof(unsigned long),
-						   GFP_KERNEL);
-		if (!vi->hash_block_verified) {
-			err = -ENOMEM;
-			goto fail;
-		}
-		spin_lock_init(&vi->hash_page_init_lock);
+	vi->hash_block_verified = kvcalloc(BITS_TO_LONGS(num_bits),
+					   sizeof(unsigned long),
+					   GFP_KERNEL);
+	if (!vi->hash_block_verified) {
+		err = -ENOMEM;
+		goto fail;
 	}
 
 	return vi;
diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index 2fe7bd57b16e..e7b13d143ae9 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -13,69 +13,18 @@
 static struct workqueue_struct *fsverity_read_workqueue;
 
 /*
- * Returns true if the hash block with index @hblock_idx in the tree, located in
- * @hpage, has already been verified.
+ * Returns true if the hash block with index @hblock_idx in the tree has
+ * already been verified.
  */
-static bool is_hash_block_verified(struct fsverity_info *vi, struct page *hpage,
-				   unsigned long hblock_idx)
+static bool is_hash_block_verified(struct fsverity_info *vi,
+				   unsigned long hblock_idx,
+				   bool block_cached)
 {
-	bool verified;
-	unsigned int blocks_per_page;
-	unsigned int i;
-
-	/*
-	 * When the Merkle tree block size and page size are the same, then the
-	 * ->hash_block_verified bitmap isn't allocated, and we use PG_checked
-	 * to directly indicate whether the page's block has been verified.
-	 *
-	 * Using PG_checked also guarantees that we re-verify hash pages that
-	 * get evicted and re-instantiated from the backing storage, as new
-	 * pages always start out with PG_checked cleared.
-	 */
-	if (!vi->hash_block_verified)
-		return PageChecked(hpage);
-
-	/*
-	 * When the Merkle tree block size and page size differ, we use a bitmap
-	 * to indicate whether each hash block has been verified.
-	 *
-	 * However, we still need to ensure that hash pages that get evicted and
-	 * re-instantiated from the backing storage are re-verified.  To do
-	 * this, we use PG_checked again, but now it doesn't really mean
-	 * "checked".  Instead, now it just serves as an indicator for whether
-	 * the hash page is newly instantiated or not.
-	 *
-	 * The first thread that sees PG_checked=0 must clear the corresponding
-	 * bitmap bits, then set PG_checked=1.  This requires a spinlock.  To
-	 * avoid having to take this spinlock in the common case of
-	 * PG_checked=1, we start with an opportunistic lockless read.
-	 */
-	if (PageChecked(hpage)) {
-		/*
-		 * A read memory barrier is needed here to give ACQUIRE
-		 * semantics to the above PageChecked() test.
-		 */
-		smp_rmb();
+	if (block_cached)
 		return test_bit(hblock_idx, vi->hash_block_verified);
-	}
-	spin_lock(&vi->hash_page_init_lock);
-	if (PageChecked(hpage)) {
-		verified = test_bit(hblock_idx, vi->hash_block_verified);
-	} else {
-		blocks_per_page = vi->tree_params.blocks_per_page;
-		hblock_idx = round_down(hblock_idx, blocks_per_page);
-		for (i = 0; i < blocks_per_page; i++)
-			clear_bit(hblock_idx + i, vi->hash_block_verified);
-		/*
-		 * A write memory barrier is needed here to give RELEASE
-		 * semantics to the below SetPageChecked() operation.
-		 */
-		smp_wmb();
-		SetPageChecked(hpage);
-		verified = false;
-	}
-	spin_unlock(&vi->hash_page_init_lock);
-	return verified;
+
+	clear_bit(hblock_idx, vi->hash_block_verified);
+	return false;
 }
 
 /*
@@ -179,7 +128,7 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 			goto error;
 		}
 		haddr = kmap_local_page(hpage) + hblock_offset_in_page;
-		if (is_hash_block_verified(vi, hpage, hblock_idx)) {
+		if (is_hash_block_verified(vi, hblock_idx, PageChecked(hpage))) {
 			memcpy(_want_hash, haddr + hoffset, hsize);
 			want_hash = _want_hash;
 			kunmap_local(haddr);
-- 
2.40.1

