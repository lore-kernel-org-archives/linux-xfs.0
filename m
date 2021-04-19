Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD1D1C433ED
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 08:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A679C61029
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 08:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237802AbhDSI24 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Apr 2021 04:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237833AbhDSI2x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Apr 2021 04:28:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB63C06174A
        for <linux-xfs@vger.kernel.org>; Mon, 19 Apr 2021 01:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=1MI0tpVG789FEab3cKjSBzY65/U/udZVHktMUqz17X4=; b=SYC1UIkulyJnUaJ7phzo7vOaYk
        C9SMzchanJopHjK1iW86WSJ6BqfV+qMu+lr0rZSoAeGMtTmBcc1HEJDEeXQw77EisA1yNMbA1HZRJ
        RQoFyy0yjZvEWPDoqJrXOzRVGAs5xYWAUA8O6eUW4R6Mj1hOlA1GDJR76rEoKoYOHrHrn9ehnAyU/
        aiq+uYuUdo7qqAY3mLQwhHX6CrV5nfKPgnQfHwyhNijW/t+PtokcmjKvz69zA0mWFi8DjJOQC/Ty6
        FB/ih1blU6Sx0/c1i6a6qVt/3/MBnXAweVB9I6JUKUdhKpmLTUNhU4V3YNjQZhLejoB70MKZcCPIE
        Ztv+B5jQ==;
Received: from [2001:4bb8:19b:f845:9ac9:3ef5:afc7:c325] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lYPGZ-00BBem-Ld; Mon, 19 Apr 2021 08:28:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: [PATCH 6/7] xfs: add a xfs_efd_item_sizeof helper
Date:   Mon, 19 Apr 2021 10:28:03 +0200
Message-Id: <20210419082804.2076124-7-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210419082804.2076124-1-hch@lst.de>
References: <20210419082804.2076124-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add a helper to calculate the size of an xfs_efd_log_item structure
the specified number of extents.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_extfree_item.c | 10 +++-------
 fs/xfs/xfs_extfree_item.h |  6 ++++++
 fs/xfs/xfs_super.c        |  6 ++----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index afd568d426c1f1..a2abdfd3d076bf 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -268,15 +268,11 @@ xfs_trans_get_efd(
 	struct xfs_efd_log_item		*efdp;
 
 	ASSERT(nextents > 0);
-
-	if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
-		efdp = kmem_zalloc(sizeof(struct xfs_efd_log_item) +
-				(nextents - 1) * sizeof(struct xfs_extent),
-				0);
-	} else {
+	if (nextents > XFS_EFD_MAX_FAST_EXTENTS)
+		efdp = kmem_zalloc(xfs_efd_item_sizeof(nextents), 0);
+	else
 		efdp = kmem_cache_zalloc(xfs_efd_zone,
 					GFP_KERNEL | __GFP_NOFAIL);
-	}
 
 	xfs_log_item_init(tp->t_mountp, &efdp->efd_item, XFS_LI_EFD,
 			  &xfs_efd_item_ops);
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index d2577d872de771..3bb62ef525f2e0 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -70,6 +70,12 @@ struct xfs_efd_log_item {
 	struct xfs_efd_log_format efd_format;
 };
 
+static inline int xfs_efd_item_sizeof(unsigned int nextents)
+{
+	return sizeof(struct xfs_efd_log_item) +
+		(nextents - 1) * sizeof(struct xfs_extent);
+}
+
 /*
  * Max number of extents in fast allocation path.
  */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index c93710cb5ce3f0..f7f70438d98703 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1953,10 +1953,8 @@ xfs_init_zones(void)
 		goto out_destroy_trans_zone;
 
 	xfs_efd_zone = kmem_cache_create("xfs_efd_item",
-					(sizeof(struct xfs_efd_log_item) +
-					(XFS_EFD_MAX_FAST_EXTENTS - 1) *
-					sizeof(struct xfs_extent)),
-					0, 0, NULL);
+			xfs_efd_item_sizeof(XFS_EFD_MAX_FAST_EXTENTS),
+			0, 0, NULL);
 	if (!xfs_efd_zone)
 		goto out_destroy_buf_item_zone;
 
-- 
2.30.1

