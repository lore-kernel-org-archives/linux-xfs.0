Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13761C433B4
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 08:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE0C261185
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 08:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237811AbhDSI24 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Apr 2021 04:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237570AbhDSI24 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Apr 2021 04:28:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1DEDC06174A
        for <linux-xfs@vger.kernel.org>; Mon, 19 Apr 2021 01:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Sender:Reply-To:Content-ID:Content-Description;
        bh=waW56BsVk68kwt+U2O/qRm3HCqG2X+jJpjmUvEiiONs=; b=IbK5EuPOFWkwMizgT+Ae2ISspe
        MJPwUqJ64F5uMFrXW5rXO2wzLPrae8j9OBzWPJeTYfOfdRWj4sCaw+FQ7OAuQFGD3YT0K1tPruUNW
        vOCn0+2MxJX2P06Jdkqb4AFXEr59rGsI6pAsY7z4aNCcujYmF8MKicFYIlBe8wtRm5asM3rTX5gcp
        G5kuthR6TOQjcfMTfyF+sY7qnC8uhKQ5+24kHzNnvUeEOW3gcANkMPeTpGkD0OCfR5I61GerBzalE
        WOxNgRMLZS83Z9eOuemcSgEBh31QrNj0z3Zp/8anVp5lCHB1MnIo+RYwa7P4tTzrH1s9yR6JMd71f
        RFN1HuDQ==;
Received: from [2001:4bb8:19b:f845:9ac9:3ef5:afc7:c325] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lYPGc-00BBew-8A; Mon, 19 Apr 2021 08:28:26 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: [PATCH 7/7] xfs: Replace one-element arrays with flexible-array members
Date:   Mon, 19 Apr 2021 10:28:04 +0200
Message-Id: <20210419082804.2076124-8-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210419082804.2076124-1-hch@lst.de>
References: <20210419082804.2076124-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

Refactor the code according to the use of flexible-array members in
multiple structures, instead of one-element arrays. Also, make use of
the new struct_size() helper to properly calculate the size of some
structures that contain flexible-array members.

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.9/process/deprecated.html#zero-length-and-one-element-arrays

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
[hch: rebased on top of the previous cleanups]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h | 6 +++---
 fs/xfs/xfs_extfree_item.c      | 9 +++------
 fs/xfs/xfs_extfree_item.h      | 4 ++--
 fs/xfs/xfs_ondisk.h            | 6 +++---
 4 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 639035052b4f65..9b218c30659ad7 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -559,7 +559,7 @@ struct xfs_efi_log_format {
 	uint16_t		efi_size;	/* size of this item */
 	uint32_t		efi_nextents;	/* # extents to free */
 	uint64_t		efi_id;		/* efi identifier */
-	struct xfs_extent	efi_extents[1];	/* array of extents to free */
+	struct xfs_extent	efi_extents[];	/* array of extents to free */
 };
 
 /*
@@ -577,7 +577,7 @@ struct xfs_efi_log_format_32 {
 	uint16_t		efi_size;	/* size of this item */
 	uint32_t		efi_nextents;	/* # extents to free */
 	uint64_t		efi_id;		/* efi identifier */
-	struct xfs_extent_32	efi_extents[1];	/* array of extents to free */
+	struct xfs_extent_32	efi_extents[];	/* array of extents to free */
 } __attribute__((packed));
 
 /*
@@ -590,7 +590,7 @@ struct xfs_efd_log_format {
 	uint16_t		efd_size;	/* size of this item */
 	uint32_t		efd_nextents;	/* # of extents freed */
 	uint64_t		efd_efi_id;	/* id of corresponding efi */
-	struct xfs_extent	efd_extents[1];	/* array of extents freed */
+	struct xfs_extent	efd_extents[];	/* array of extents freed */
 };
 
 /*
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index a2abdfd3d076bf..8bea9c9ecf2042 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -73,8 +73,7 @@ static inline int
 xfs_efi_log_item_sizeof(
 	struct xfs_efi_log_format *elf)
 {
-	return sizeof(*elf) +
-	       (elf->efi_nextents - 1) * sizeof(struct xfs_extent);
+	return struct_size(elf, efi_extents, elf->efi_nextents);
 }
 
 STATIC void
@@ -194,8 +193,7 @@ static inline int
 xfs_efd_log_item_sizeof(
 	struct xfs_efd_log_format *elf)
 {
-	return sizeof(struct xfs_efd_log_format) +
-	       (elf->efd_nextents - 1) * sizeof(struct xfs_extent);
+	return struct_size(elf, efd_extents, elf->efd_nextents);
 }
 
 STATIC void
@@ -636,8 +634,7 @@ xfs_efi_copy_format_32(
 	struct xfs_efi_log_format_32	*src = buf->i_addr;
 	unsigned int			i;
 
-	if (buf->i_len != sizeof(*src) +
-	    (src->efi_nextents - 1) * sizeof(struct xfs_extent_32)) {
+	if (buf->i_len != struct_size(src, efi_extents, src->efi_nextents)) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
 		return -EFSCORRUPTED;
 	}
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index 3bb62ef525f2e0..a01ce86145bb64 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -55,7 +55,7 @@ struct xfs_efi_log_item {
 static inline int xfs_efi_item_sizeof(unsigned int nextents)
 {
 	return sizeof(struct xfs_efi_log_item) +
-		(nextents - 1) * sizeof(struct xfs_extent);
+		nextents * sizeof(struct xfs_extent);
 }
 
 /*
@@ -73,7 +73,7 @@ struct xfs_efd_log_item {
 static inline int xfs_efd_item_sizeof(unsigned int nextents)
 {
 	return sizeof(struct xfs_efd_log_item) +
-		(nextents - 1) * sizeof(struct xfs_extent);
+		nextents * sizeof(struct xfs_extent);
 }
 
 /*
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 739476f7dffa21..fa4b590671bf58 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -118,9 +118,9 @@ xfs_check_ondisk_structs(void)
 	/* log structures */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dq_logformat,		24);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format,	32);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format,	32);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_32,	28);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_32,	16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_extent,		16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_32,		12);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_log_dinode,		176);
-- 
2.30.1

