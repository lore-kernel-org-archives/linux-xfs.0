Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC514C43460
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 08:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8BA761159
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 08:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhDSI2m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Apr 2021 04:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235023AbhDSI2l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Apr 2021 04:28:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2735FC061760
        for <linux-xfs@vger.kernel.org>; Mon, 19 Apr 2021 01:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Sender:Reply-To:Content-ID:Content-Description;
        bh=K3RppyekugL1PaMFujNwLOEUJzJd6NyyQgLRyTzaotY=; b=dgRTF7bk2MgDczbZ5wgJG5T+gy
        V04C5hSGhsUpFvVxFkunFXnY/L6YySDGRv+PnyrkFYuBn9kFrWJY8H6kQrWnCzSFD7PQi/h8qdbJ+
        /Nlkd+NhXwJQEAp2vXEzPMFA7MaReMkDZQLI58zogsxfWa5LWRXapiKpVOH1CouvDq1TB8KX87bNS
        5YyjQ424Y0Fbw+5BQFPSoB6+yehIQpPezwcQFpy5rYs3AuyW2xPSM0zI79DEtxKELtm8ruM9ZqWdz
        G6h3y2rSdfx51hxIQ8GjlMTual1tccofwg6Zz7gH0dHzvtq/v+QbXbJAVrkMgz6sydooR8xulecpo
        4+/DFZxQ==;
Received: from [2001:4bb8:19b:f845:9ac9:3ef5:afc7:c325] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lYPGM-00BBdE-DW; Mon, 19 Apr 2021 08:28:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: [PATCH 1/7] xfs: remove the EFD size asserts in xlog_recover_efd_commit_pass2
Date:   Mon, 19 Apr 2021 10:27:58 +0200
Message-Id: <20210419082804.2076124-2-hch@lst.de>
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

We never actually look at the extent array in the efd items, and should
eventually stop writing them out at all when it is time for a incompat
log change.  Ѕo don't bother with the asserts at all, and thus with the
the structures defined just to be used with it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h | 20 ++------------------
 fs/xfs/xfs_extfree_item.c      | 10 ++--------
 fs/xfs/xfs_extfree_item.h      |  2 +-
 fs/xfs/xfs_ondisk.h            |  2 --
 4 files changed, 5 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 8bd00da6d2a40f..ea0fe9f121adff 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -598,29 +598,13 @@ typedef struct xfs_efi_log_format_64 {
  * log.  The efd_extents array is a variable size array whose
  * size is given by efd_nextents;
  */
-typedef struct xfs_efd_log_format {
+struct xfs_efd_log_format {
 	uint16_t		efd_type;	/* efd log item type */
 	uint16_t		efd_size;	/* size of this item */
 	uint32_t		efd_nextents;	/* # of extents freed */
 	uint64_t		efd_efi_id;	/* id of corresponding efi */
 	xfs_extent_t		efd_extents[1];	/* array of extents freed */
-} xfs_efd_log_format_t;
-
-typedef struct xfs_efd_log_format_32 {
-	uint16_t		efd_type;	/* efd log item type */
-	uint16_t		efd_size;	/* size of this item */
-	uint32_t		efd_nextents;	/* # of extents freed */
-	uint64_t		efd_efi_id;	/* id of corresponding efi */
-	xfs_extent_32_t		efd_extents[1];	/* array of extents freed */
-} __attribute__((packed)) xfs_efd_log_format_32_t;
-
-typedef struct xfs_efd_log_format_64 {
-	uint16_t		efd_type;	/* efd log item type */
-	uint16_t		efd_size;	/* size of this item */
-	uint32_t		efd_nextents;	/* # of extents freed */
-	uint64_t		efd_efi_id;	/* id of corresponding efi */
-	xfs_extent_64_t		efd_extents[1];	/* array of extents freed */
-} xfs_efd_log_format_64_t;
+};
 
 /*
  * RUI/RUD (reverse mapping) log format definitions
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 93223ebb33721e..ac17fdb9283489 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -253,7 +253,7 @@ static inline int
 xfs_efd_item_sizeof(
 	struct xfs_efd_log_item *efdp)
 {
-	return sizeof(xfs_efd_log_format_t) +
+	return sizeof(struct xfs_efd_log_format) +
 	       (efdp->efd_format.efd_nextents - 1) * sizeof(xfs_extent_t);
 }
 
@@ -743,13 +743,7 @@ xlog_recover_efd_commit_pass2(
 	struct xlog_recover_item	*item,
 	xfs_lsn_t			lsn)
 {
-	struct xfs_efd_log_format	*efd_formatp;
-
-	efd_formatp = item->ri_buf[0].i_addr;
-	ASSERT((item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_32_t) +
-		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_32_t)))) ||
-	       (item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_64_t) +
-		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_64_t)))));
+	struct xfs_efd_log_format	*efd_formatp = item->ri_buf[0].i_addr;
 
 	xlog_recover_release_intent(log, XFS_LI_EFI, efd_formatp->efd_efi_id);
 	return 0;
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index cd2860c875bf50..6b80452ad2a71b 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -61,7 +61,7 @@ struct xfs_efd_log_item {
 	struct xfs_log_item	efd_item;
 	struct xfs_efi_log_item *efd_efip;
 	uint			efd_next_extent;
-	xfs_efd_log_format_t	efd_format;
+	struct xfs_efd_log_format efd_format;
 };
 
 /*
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 0aa87c2101049c..7328ff92e0ee8a 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -118,8 +118,6 @@ xfs_check_ondisk_structs(void)
 	/* log structures */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dq_logformat,		24);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_32,	28);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_64,	32);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_32,	28);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_64,	32);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_32,		12);
-- 
2.30.1

