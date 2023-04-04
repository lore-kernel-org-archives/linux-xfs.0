Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E612C761A6
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 14:57:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235481AbjDDO5e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 10:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235067AbjDDO4s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 10:56:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C524237
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 07:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680620158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vAR4IqzKft1FulbfGVumK2HKMhiXaE7ZaLXEvaQK8Qc=;
        b=QR6ESbHwlARK4SYu81E2wSZoC064+cXn7S8M0jI/H7cZjBM4yEX4bbW3y7jNX5vtBbk7c+
        Q7iLTc2CDZhf2iTDD9Glsvp1r9xUjrhjHWUtOoYjSQ0fbkDw5DX1WIBRUzgmA9/HyWPdkZ
        pVLdmB3KyS4zch3//S1KyCBjEFEBaRE=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-416-gCqAQUNnOTGM1hkmLMBPFw-1; Tue, 04 Apr 2023 10:55:57 -0400
X-MC-Unique: gCqAQUNnOTGM1hkmLMBPFw-1
Received: by mail-qv1-f69.google.com with SMTP id f3-20020a0cc303000000b005c9966620daso14611802qvi.4
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 07:55:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680620153;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vAR4IqzKft1FulbfGVumK2HKMhiXaE7ZaLXEvaQK8Qc=;
        b=UX0e+1YZj4h6qv0+AfkL4SrmWXZpdryrRFvZYfO+BB0agv1QuSOCusEAWk0QZvdRnt
         Lf+lY4wt0hiNwda+6EaBFGk8Y8MCTt2MRkGKXS8YjFfExM0fDmHiupsFwg94pamI7XxY
         w9XjdiFDy2AKwD649R8SaLPOfQbtfo0wApIwsOz5ZZ90FkPLdH5I7lLv+zwjNo9CkJwC
         H7NQgoPrpOPMIozonB8a0tA8vZVjRJAj2bYZVsfT+l5lQWW50UE1WKy0UQgRdNPpM7CM
         hJ5gw9EMBrH7UtdGXpS1a3WtQC8UIS99lbrEvFdATVnuBmx2vXDU/bhDOSF0lVHo+gKn
         sIGQ==
X-Gm-Message-State: AAQBX9deKyc0pU0cKA0UAyMDHBn7k1/4SDU5APciMnuLaAYjFJwb8K8B
        ynU/g2rzHSsaZbd/L+KhxhQ2mvIR5aOqOJbclrqvCNPsgpPi3JdA7PCk/2CQReO4HqZLEtwdy2Y
        L5asTfQBlBoLfsLJtL04=
X-Received: by 2002:a05:6214:da8:b0:5c5:471a:1e2f with SMTP id h8-20020a0562140da800b005c5471a1e2fmr3781908qvh.51.1680620152505;
        Tue, 04 Apr 2023 07:55:52 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y+CJdy2zuw3OclTHQicHY+1y6liC+cgVxTA4alT47Sc9E4dbJpC4DNw4j3Dv/W+hf5PybB+w==
X-Received: by 2002:a05:6214:da8:b0:5c5:471a:1e2f with SMTP id h8-20020a0562140da800b005c5471a1e2fmr3781877qvh.51.1680620152126;
        Tue, 04 Apr 2023 07:55:52 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id j4-20020ac86644000000b003e6387431dcsm3296539qtp.7.2023.04.04.07.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 07:55:51 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     djwong@kernel.org, dchinner@redhat.com, ebiggers@kernel.org,
        hch@infradead.org, linux-xfs@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     rpeterso@redhat.com, agruenba@redhat.com, xiang@kernel.org,
        chao@kernel.org, damien.lemoal@opensource.wdc.com, jth@kernel.org,
        linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 21/23] xfs: handle merkle tree block size != fs blocksize != PAGE_SIZE
Date:   Tue,  4 Apr 2023 16:53:17 +0200
Message-Id: <20230404145319.2057051-22-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230404145319.2057051-1-aalbersh@redhat.com>
References: <20230404145319.2057051-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In case of different Merkle tree block size fs-verity expects
->read_merkle_tree_page() to return Merkle tree page filled with
Merkle tree blocks. The XFS stores each merkle tree block under
extended attribute. Those attributes are addressed by block offset
into Merkle tree.

This patch make ->read_merkle_tree_page() to fetch multiple merkle
tree blocks based on size ratio. Also the reference to each xfs_buf
is passed with page->private to ->drop_page().

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_verity.c | 74 +++++++++++++++++++++++++++++++++++----------
 fs/xfs/xfs_verity.h |  8 +++++
 2 files changed, 66 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_verity.c b/fs/xfs/xfs_verity.c
index a9874ff4efcd..ef0aff216f06 100644
--- a/fs/xfs/xfs_verity.c
+++ b/fs/xfs/xfs_verity.c
@@ -134,6 +134,10 @@ xfs_read_merkle_tree_page(
 	struct page		*page = NULL;
 	__be64			name = cpu_to_be64(index << PAGE_SHIFT);
 	uint32_t		bs = 1 << log_blocksize;
+	int			blocks_per_page =
+		(1 << (PAGE_SHIFT - log_blocksize));
+	int			n = 0;
+	int			offset = 0;
 	struct xfs_da_args	args = {
 		.dp		= ip,
 		.attr_filter	= XFS_ATTR_VERITY,
@@ -143,26 +147,59 @@ xfs_read_merkle_tree_page(
 		.valuelen	= bs,
 	};
 	int			error = 0;
+	bool			is_checked = true;
+	struct xfs_verity_buf_list	*buf_list;
 
 	page = alloc_page(GFP_KERNEL);
 	if (!page)
 		return ERR_PTR(-ENOMEM);
 
-	error = xfs_attr_get(&args);
-	if (error) {
-		kmem_free(args.value);
-		xfs_buf_rele(args.bp);
+	buf_list = kzalloc(sizeof(struct xfs_verity_buf_list), GFP_KERNEL);
+	if (!buf_list) {
 		put_page(page);
-		return ERR_PTR(-EFAULT);
+		return ERR_PTR(-ENOMEM);
 	}
 
-	if (args.bp->b_flags & XBF_VERITY_CHECKED)
+	/*
+	 * Fill the page with Merkle tree blocks. The blcoks_per_page is higher
+	 * than 1 when fs block size != PAGE_SIZE or Merkle tree block size !=
+	 * PAGE SIZE
+	 */
+	for (n = 0; n < blocks_per_page; n++) {
+		offset = bs * n;
+		name = cpu_to_be64(((index << PAGE_SHIFT) + offset));
+		args.name = (const uint8_t *)&name;
+
+		error = xfs_attr_get(&args);
+		if (error) {
+			kmem_free(args.value);
+			/*
+			 * No more Merkle tree blocks (e.g. this was the last
+			 * block of the tree)
+			 */
+			if (error == -ENOATTR)
+				break;
+			xfs_buf_rele(args.bp);
+			put_page(page);
+			kmem_free(buf_list);
+			return ERR_PTR(-EFAULT);
+		}
+
+		buf_list->bufs[buf_list->buf_count++] = args.bp;
+
+		/* One of the buffers was dropped */
+		if (!(args.bp->b_flags & XBF_VERITY_CHECKED))
+			is_checked = false;
+
+		memcpy(page_address(page) + offset, args.value, args.valuelen);
+		kmem_free(args.value);
+		args.value = NULL;
+	}
+
+	if (is_checked)
 		SetPageChecked(page);
+	page->private = (unsigned long)buf_list;
 
-	page->private = (unsigned long)args.bp;
-	memcpy(page_address(page), args.value, args.valuelen);
-
-	kmem_free(args.value);
 	return page;
 }
 
@@ -191,16 +228,21 @@ xfs_write_merkle_tree_block(
 
 static void
 xfs_drop_page(
-	struct page	*page)
+	struct page			*page)
 {
-	struct xfs_buf *buf = (struct xfs_buf *)page->private;
+	int				i = 0;
+	struct xfs_verity_buf_list	*buf_list =
+		(struct xfs_verity_buf_list *)page->private;
 
-	ASSERT(buf != NULL);
+	ASSERT(buf_list != NULL);
 
-	if (PageChecked(page))
-		buf->b_flags |= XBF_VERITY_CHECKED;
+	for (i = 0; i < buf_list->buf_count; i++) {
+		if (PageChecked(page))
+			buf_list->bufs[i]->b_flags |= XBF_VERITY_CHECKED;
+		xfs_buf_rele(buf_list->bufs[i]);
+	}
 
-	xfs_buf_rele(buf);
+	kmem_free(buf_list);
 	put_page(page);
 }
 
diff --git a/fs/xfs/xfs_verity.h b/fs/xfs/xfs_verity.h
index ae5d87ca32a8..433b2f4ae3bc 100644
--- a/fs/xfs/xfs_verity.h
+++ b/fs/xfs/xfs_verity.h
@@ -16,4 +16,12 @@ extern const struct fsverity_operations xfs_verity_ops;
 #define xfs_verity_ops NULL
 #endif	/* CONFIG_FS_VERITY */
 
+/* Minimal Merkle tree block size is 1024 */
+#define XFS_VERITY_MAX_MBLOCKS_PER_PAGE (1 << (PAGE_SHIFT - 10))
+
+struct xfs_verity_buf_list {
+	unsigned int	buf_count;
+	struct xfs_buf	*bufs[XFS_VERITY_MAX_MBLOCKS_PER_PAGE];
+};
+
 #endif	/* __XFS_VERITY_H__ */
-- 
2.38.4

