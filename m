Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7F43C54E8B
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 06:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90F2321582
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 06:34:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PvUTFQhi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgEHGeb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 02:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726099AbgEHGea (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 02:34:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845BAC05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 23:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=palTktfBIsRrqkga8MutOjrIsnHLVSB9A5YPe83m07E=; b=PvUTFQhiYt+nmOvlCHOxj5HW5C
        LurCa2xD1l7FugBMMcb56p+5rLq3ioMubV2hf/NNjj63jBv/AfFrPBe+6Z0Fpl7xwMA8Hk99wy9XK
        AIsS1ZAbuFoHp1xja2BO+kYn2yY0hMgWDKARi685pCDIQTej/vUKRekloDOfWFWUZlProznd1aMeO
        5POXl53W2qDn758gfwtb/8nycaYxmuYyz0OmfbOm31xdXx74AmGFYtFJrStQDqXK9hb3V31yfN7Ux
        5qGpkNQoLbFyUXjcKLKX/B1HafmXhQfdMrRFrZ7ig2Fk1ZNMHZnFaJF27N+TbXz9HhDV9k5E2Quup
        4CU4t7Hg==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWwac-0002tn-2J; Fri, 08 May 2020 06:34:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>
Subject: [PATCH 02/12] xfs: call xfs_iformat_fork from xfs_inode_from_disk
Date:   Fri,  8 May 2020 08:34:13 +0200
Message-Id: <20200508063423.482370-3-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508063423.482370-1-hch@lst.de>
References: <20200508063423.482370-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We always need to fill out the fork structures when reading the inode,
so call xfs_iformat_fork from the tail of xfs_inode_from_disk.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 7 ++++---
 fs/xfs/libxfs/xfs_inode_buf.h | 2 +-
 fs/xfs/xfs_log_recover.c      | 4 +---
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 81a010422bea3..dc00ce6fc4a2f 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -180,7 +180,7 @@ xfs_imap_to_bp(
 	return 0;
 }
 
-void
+int
 xfs_inode_from_disk(
 	struct xfs_inode	*ip,
 	struct xfs_dinode	*from)
@@ -241,6 +241,8 @@ xfs_inode_from_disk(
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
 		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
 	}
+
+	return xfs_iformat_fork(ip, from);
 }
 
 void
@@ -641,8 +643,7 @@ xfs_iread(
 	 * Otherwise, just get the truly permanent information.
 	 */
 	if (dip->di_mode) {
-		xfs_inode_from_disk(ip, dip);
-		error = xfs_iformat_fork(ip, dip);
+		error = xfs_inode_from_disk(ip, dip);
 		if (error)  {
 #ifdef DEBUG
 			xfs_alert(mp, "%s: xfs_iformat() returned error %d",
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index d9b4781ac9fd4..0fbb99224ec73 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -54,7 +54,7 @@ int	xfs_iread(struct xfs_mount *, struct xfs_trans *,
 void	xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
 void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to,
 			  xfs_lsn_t lsn);
-void	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
+int	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
 void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
 			       struct xfs_dinode *to);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 3207851158332..3960caf51c9f7 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2874,9 +2874,7 @@ xfs_recover_inode_owner_change(
 
 	/* instantiate the inode */
 	ASSERT(dip->di_version >= 3);
-	xfs_inode_from_disk(ip, dip);
-
-	error = xfs_iformat_fork(ip, dip);
+	error = xfs_inode_from_disk(ip, dip);
 	if (error)
 		goto out_free_ip;
 
-- 
2.26.2

