Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48AF6C5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DFC4206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a9YIx32c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbfKGSZs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:25:48 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44250 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbfKGSZs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:25:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=q1jjL0dRgHCApXLV1i4Op+sGKXjsdlDOgnnVyunhAxc=; b=a9YIx32cs+a+Q10a5bPqc6MFf
        1zxYJXG3dUJpa0GKPeibpqGIGiPd8QU0aqiPqD+9QP+nw2PHWIHbyIqkrandkTaT8Dx6uNA9XkQHy
        7jvJKQo40tWep3gi+ICBN7DgNwX/VOEkxjoblM8wYb5QgXQjOKMAJfZY9YlEZQljuK9nfWm2A86SR
        mA++HbN4dmvIIGMS+HvHCeXLBJTDTsEsbbkE46H1l/PpX8X3SZLsF2KdUPbuTHYrdbQBNbkETfWSN
        nGcKmUfFHNnp1V+oeLb79oN+GnguAGYQTeJ0iejymOuFtF4XfjMcWEwXFw/iStlsxAfBIVYEZ12VH
        OWfgM2vJg==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmTb-0004SM-Nh
        for linux-xfs@vger.kernel.org; Thu, 07 Nov 2019 18:25:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 36/46] xfs: remove the now unused ->data_entry_p method
Date:   Thu,  7 Nov 2019 19:24:00 +0100
Message-Id: <20191107182410.12660-37-hch@lst.de>
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

Now that all users use the data_entry_offset field this method is
unused and can be removed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.c | 20 --------------------
 fs/xfs/libxfs/xfs_dir2.h      |  3 ---
 2 files changed, 23 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index 347092ec28ab..e70cc54d99e1 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -123,20 +123,6 @@ xfs_dir3_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
 	return ((struct xfs_dir3_data_hdr *)hdr)->best_free;
 }
 
-static struct xfs_dir2_data_entry *
-xfs_dir2_data_entry_p(struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + sizeof(struct xfs_dir2_data_hdr));
-}
-
-static struct xfs_dir2_data_entry *
-xfs_dir3_data_entry_p(struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + sizeof(struct xfs_dir3_data_hdr));
-}
-
 static const struct xfs_dir_ops xfs_dir2_ops = {
 	.data_entsize = xfs_dir2_data_entsize,
 	.data_get_ftype = xfs_dir2_data_get_ftype,
@@ -148,8 +134,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 				XFS_DIR2_DATA_ENTSIZE(1) +
 				XFS_DIR2_DATA_ENTSIZE(2),
 	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
-
-	.data_entry_p = xfs_dir2_data_entry_p,
 };
 
 static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
@@ -163,8 +147,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 				XFS_DIR3_DATA_ENTSIZE(1) +
 				XFS_DIR3_DATA_ENTSIZE(2),
 	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
-
-	.data_entry_p = xfs_dir2_data_entry_p,
 };
 
 static const struct xfs_dir_ops xfs_dir3_ops = {
@@ -178,8 +160,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 				XFS_DIR3_DATA_ENTSIZE(1) +
 				XFS_DIR3_DATA_ENTSIZE(2),
 	.data_entry_offset = sizeof(struct xfs_dir3_data_hdr),
-
-	.data_entry_p = xfs_dir3_data_entry_p,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 75aec05aae10..a160f2d4ff37 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -42,9 +42,6 @@ struct xfs_dir_ops {
 
 	xfs_dir2_data_aoff_t data_first_offset;
 	size_t	data_entry_offset;
-
-	struct xfs_dir2_data_entry *
-		(*data_entry_p)(struct xfs_dir2_data_hdr *hdr);
 };
 
 extern const struct xfs_dir_ops *
-- 
2.20.1

