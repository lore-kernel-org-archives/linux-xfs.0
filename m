Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2027AC43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDC7D214D8
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EHss15Ru"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbfKGSZU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:25:20 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44162 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfKGSZU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:25:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3N7fms4OuZYUyCymZ/3ARE2+MPXSKnLfw2TqP83kn6A=; b=EHss15RuraB3NlS5L//MhJKbb
        Cv6U/Wh5zJjk40MCvaR/0ST9X0eAvfkRb+duZRpRIllkfqWEGOFv/FxqbLx8gBh8CtlHzosZ8ZEfK
        lGIIsr1SWH8thx7ORgRSUM5nUP6TW80TMcY9u6ARz0K3tsm686Lc9c8cohqhnKCkGuRBLxHzDPGjX
        b9QrobbENJw14HX3SqIq9eT1wOCGqtPKswdNfUpS3BmZNPNuuFFoMYbIbS8yhV5jaS9K1r9QWtjfk
        A/EZy7HUfpt8Jsvb0tQaoKC6z51/Gr7GvH/M+uR+C43kXopT3HdqcjQbI9fxHAO4eomo2d0D1QuWZ
        DO8j93X/g==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmT9-0004NE-Py
        for linux-xfs@vger.kernel.org; Thu, 07 Nov 2019 18:25:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 25/46] xfs: remove the data_dot_offset field in struct xfs_dir_ops
Date:   Thu,  7 Nov 2019 19:23:49 +0100
Message-Id: <20191107182410.12660-26-hch@lst.de>
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

The data_dot_offset value is always equal to data_entry_offset given
that "." is always the first entry in the directory.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.c | 3 ---
 fs/xfs/libxfs/xfs_dir2.h      | 1 -
 fs/xfs/xfs_dir2_readdir.c     | 9 ++++-----
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index 19343c65be91..54754eef2437 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -204,7 +204,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 	.data_entry_tag_p = xfs_dir2_data_entry_tag_p,
 	.data_bestfree_p = xfs_dir2_data_bestfree_p,
 
-	.data_dot_offset = sizeof(struct xfs_dir2_data_hdr),
 	.data_dotdot_offset = sizeof(struct xfs_dir2_data_hdr) +
 				XFS_DIR2_DATA_ENTSIZE(1),
 	.data_first_offset =  sizeof(struct xfs_dir2_data_hdr) +
@@ -225,7 +224,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.data_entry_tag_p = xfs_dir3_data_entry_tag_p,
 	.data_bestfree_p = xfs_dir2_data_bestfree_p,
 
-	.data_dot_offset = sizeof(struct xfs_dir2_data_hdr),
 	.data_dotdot_offset = sizeof(struct xfs_dir2_data_hdr) +
 				XFS_DIR3_DATA_ENTSIZE(1),
 	.data_first_offset =  sizeof(struct xfs_dir2_data_hdr) +
@@ -246,7 +244,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 	.data_entry_tag_p = xfs_dir3_data_entry_tag_p,
 	.data_bestfree_p = xfs_dir3_data_bestfree_p,
 
-	.data_dot_offset = sizeof(struct xfs_dir3_data_hdr),
 	.data_dotdot_offset = sizeof(struct xfs_dir3_data_hdr) +
 				XFS_DIR3_DATA_ENTSIZE(1),
 	.data_first_offset =  sizeof(struct xfs_dir3_data_hdr) +
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 9169da84065a..94e8c40a7d19 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -40,7 +40,6 @@ struct xfs_dir_ops {
 	struct xfs_dir2_data_free *
 		(*data_bestfree_p)(struct xfs_dir2_data_hdr *hdr);
 
-	xfs_dir2_data_aoff_t data_dot_offset;
 	xfs_dir2_data_aoff_t data_dotdot_offset;
 	xfs_dir2_data_aoff_t data_first_offset;
 	size_t	data_entry_offset;
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index e18045465455..39985ca6ae2d 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -70,13 +70,12 @@ xfs_dir2_sf_getdents(
 		return 0;
 
 	/*
-	 * Precalculate offsets for . and .. as we will always need them.
-	 *
-	 * XXX(hch): the second argument is sometimes 0 and sometimes
-	 * geo->datablk
+	 * Precalculate offsets for "." and ".." as we will always need them.
+	 * This relies on the fact that directories always start with the
+	 * entries for "." and "..".
 	 */
 	dot_offset = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
-						dp->d_ops->data_dot_offset);
+			dp->d_ops->data_entry_offset);
 	dotdot_offset = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
 						dp->d_ops->data_dotdot_offset);
 
-- 
2.20.1

