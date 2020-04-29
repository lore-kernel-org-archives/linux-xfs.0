Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93134C83000
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:05:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72B8221D7E
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:05:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hf7xB7qO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgD2PFT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 11:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgD2PFS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 11:05:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B65C03C1AD
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 08:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=PoX7EHCrDV5jAAZY2NvTRnyFayjd3IzVf5jBJQvgX+M=; b=hf7xB7qOETFnF1xbw64vZYNJpL
        dCDeb4EJQ2vFvKNhGMwXq1CGC9OJgbfcgYUaLEBXW9oDJaIXRB4bjtgUmNn3OLPbgFUKYETO4klr3
        XUt1eb+0240Mq0ORo/g9mMDmt95MTzDYq2Ic1eoAJ07bTI2OFNmvdspoGgAHiAzZg2S/SNCZb0cG5
        ur9JW3vF6XnEHgOkbfNi1EnKCyVOe1cdW8Pk3Uy/tgN/iO66e3BT8VLaNIgPiR51jQyOmtjW76pvR
        Uot58csd5E0f6F0x27nZq27gqJtZivb1SvySVIA+qg1dMDQdcz/aHZofcbJ7xOYPft6asO7SkwsuC
        sn3Tbebw==;
Received: from [2001:4bb8:184:1b25:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jToH0-00008f-7g
        for linux-xfs@vger.kernel.org; Wed, 29 Apr 2020 15:05:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/11] xfs: remove the xfs_efi_log_item_t typedef
Date:   Wed, 29 Apr 2020 17:05:01 +0200
Message-Id: <20200429150511.2191150-2-hch@lst.de>
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
 fs/xfs/xfs_extfree_item.c |  2 +-
 fs/xfs/xfs_extfree_item.h | 10 +++++-----
 fs/xfs/xfs_log_recover.c  |  4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 6ea847f6e2980..00309b81607cd 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -161,7 +161,7 @@ xfs_efi_init(
 
 	ASSERT(nextents > 0);
 	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
-		size = (uint)(sizeof(xfs_efi_log_item_t) +
+		size = (uint)(sizeof(struct xfs_efi_log_item) +
 			((nextents - 1) * sizeof(xfs_extent_t)));
 		efip = kmem_zalloc(size, 0);
 	} else {
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index 16aaab06d4ecc..b9b567f355756 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -50,13 +50,13 @@ struct kmem_zone;
  * of commit failure or log I/O errors. Note that the EFD is not inserted in the
  * AIL, so at this point both the EFI and EFD are freed.
  */
-typedef struct xfs_efi_log_item {
+struct xfs_efi_log_item {
 	struct xfs_log_item	efi_item;
 	atomic_t		efi_refcount;
 	atomic_t		efi_next_extent;
 	unsigned long		efi_flags;	/* misc flags */
 	xfs_efi_log_format_t	efi_format;
-} xfs_efi_log_item_t;
+};
 
 /*
  * This is the "extent free done" log item.  It is used to log
@@ -65,7 +65,7 @@ typedef struct xfs_efi_log_item {
  */
 typedef struct xfs_efd_log_item {
 	struct xfs_log_item	efd_item;
-	xfs_efi_log_item_t	*efd_efip;
+	struct xfs_efi_log_item *efd_efip;
 	uint			efd_next_extent;
 	xfs_efd_log_format_t	efd_format;
 } xfs_efd_log_item_t;
@@ -78,10 +78,10 @@ typedef struct xfs_efd_log_item {
 extern struct kmem_zone	*xfs_efi_zone;
 extern struct kmem_zone	*xfs_efd_zone;
 
-xfs_efi_log_item_t	*xfs_efi_init(struct xfs_mount *, uint);
+struct xfs_efi_log_item	*xfs_efi_init(struct xfs_mount *, uint);
 int			xfs_efi_copy_format(xfs_log_iovec_t *buf,
 					    xfs_efi_log_format_t *dst_efi_fmt);
-void			xfs_efi_item_free(xfs_efi_log_item_t *);
+void			xfs_efi_item_free(struct xfs_efi_log_item *);
 void			xfs_efi_release(struct xfs_efi_log_item *);
 
 int			xfs_efi_recover(struct xfs_mount *mp,
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 11c3502b07b13..c81f71e2888cf 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3365,7 +3365,7 @@ xlog_recover_efd_pass2(
 	struct xlog_recover_item	*item)
 {
 	xfs_efd_log_format_t	*efd_formatp;
-	xfs_efi_log_item_t	*efip = NULL;
+	struct xfs_efi_log_item	*efip = NULL;
 	struct xfs_log_item	*lip;
 	uint64_t		efi_id;
 	struct xfs_ail_cursor	cur;
@@ -3386,7 +3386,7 @@ xlog_recover_efd_pass2(
 	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
 	while (lip != NULL) {
 		if (lip->li_type == XFS_LI_EFI) {
-			efip = (xfs_efi_log_item_t *)lip;
+			efip = (struct xfs_efi_log_item *)lip;
 			if (efip->efi_format.efi_id == efi_id) {
 				/*
 				 * Drop the EFD reference to the EFI. This
-- 
2.26.2

