Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86144C5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CECF206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MVZexWAs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbfKGSZX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:25:23 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44178 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfKGSZW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:25:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=F4QYpxqBrB/qAGu/B/StkTAhHgkxI4G25RdcagqEybE=; b=MVZexWAsnPhjS+0y03LQbIZkN
        O85Gn90bSw5Q+nqfX/U/xuS2kPN2oUnW1awGrPa5SxnL9TSF4NetAtdbyxoTMNbfd2UEqW01NqfUz
        nhnaAStlmLYTJ7xxZR83Beb+X4SY5sKLkrKIUSj5OM05b2M2lKs1KOjBs3jXrWJ9usHh76aQ72Ubb
        hl7XhrbEZN/fenHFDCCk0aDT11Pvtx2IAPTevOsTmjwc6hQhnu9uHwxGPUuKyD9Eo20M8ENqZVyML
        i5rXaUXmNh2VEpq7NqRd5E6upFCvalUhnDLU0OdxsXPKKlYkMWcrgVbd12Guoc5Syy3hJeJEYtPSU
        x3U4JZKyQ==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmTC-0004Nl-A8
        for linux-xfs@vger.kernel.org; Thu, 07 Nov 2019 18:25:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 26/46] xfs: remove the data_dotdot_offset field in struct xfs_dir_ops
Date:   Thu,  7 Nov 2019 19:23:50 +0100
Message-Id: <20191107182410.12660-27-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191107182410.12660-1-hch@lst.de>
References: <20191107182410.12660-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The data_dotdot_offset value is always equal to data_entry_offset plus
the fixed size of the "." entry.  Right now calculating that fixed size
requires an indirect call, but by the end of this series it will be
an inline function that can be constant folded.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.c | 6 ------
 fs/xfs/libxfs/xfs_dir2.h      | 1 -
 fs/xfs/xfs_dir2_readdir.c     | 3 ++-
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index 54754eef2437..7b783b11790d 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -204,8 +204,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 	.data_entry_tag_p = xfs_dir2_data_entry_tag_p,
 	.data_bestfree_p = xfs_dir2_data_bestfree_p,
 
-	.data_dotdot_offset = sizeof(struct xfs_dir2_data_hdr) +
-				XFS_DIR2_DATA_ENTSIZE(1),
 	.data_first_offset =  sizeof(struct xfs_dir2_data_hdr) +
 				XFS_DIR2_DATA_ENTSIZE(1) +
 				XFS_DIR2_DATA_ENTSIZE(2),
@@ -224,8 +222,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.data_entry_tag_p = xfs_dir3_data_entry_tag_p,
 	.data_bestfree_p = xfs_dir2_data_bestfree_p,
 
-	.data_dotdot_offset = sizeof(struct xfs_dir2_data_hdr) +
-				XFS_DIR3_DATA_ENTSIZE(1),
 	.data_first_offset =  sizeof(struct xfs_dir2_data_hdr) +
 				XFS_DIR3_DATA_ENTSIZE(1) +
 				XFS_DIR3_DATA_ENTSIZE(2),
@@ -244,8 +240,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 	.data_entry_tag_p = xfs_dir3_data_entry_tag_p,
 	.data_bestfree_p = xfs_dir3_data_bestfree_p,
 
-	.data_dotdot_offset = sizeof(struct xfs_dir3_data_hdr) +
-				XFS_DIR3_DATA_ENTSIZE(1),
 	.data_first_offset =  sizeof(struct xfs_dir3_data_hdr) +
 				XFS_DIR3_DATA_ENTSIZE(1) +
 				XFS_DIR3_DATA_ENTSIZE(2),
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 94e8c40a7d19..8b937993263d 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -40,7 +40,6 @@ struct xfs_dir_ops {
 	struct xfs_dir2_data_free *
 		(*data_bestfree_p)(struct xfs_dir2_data_hdr *hdr);
 
-	xfs_dir2_data_aoff_t data_dotdot_offset;
 	xfs_dir2_data_aoff_t data_first_offset;
 	size_t	data_entry_offset;
 
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 39985ca6ae2d..187bb51875c2 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -77,7 +77,8 @@ xfs_dir2_sf_getdents(
 	dot_offset = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
 			dp->d_ops->data_entry_offset);
 	dotdot_offset = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
-						dp->d_ops->data_dotdot_offset);
+			dp->d_ops->data_entry_offset +
+			dp->d_ops->data_entsize(sizeof(".") - 1));
 
 	/*
 	 * Put . entry unless we're starting past it.
-- 
2.20.1

