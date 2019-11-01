Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E5ABCA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:09:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CC13217D9
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:09:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jaf4NsLU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbfKAWJa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 18:09:30 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53776 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbfKAWJa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 18:09:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HJUgkpXA6IF588XLbXSYM2jaBuOA6x2hielT8hcBS6Q=; b=jaf4NsLUt9PfYF0XAdg9VE1HW
        EYwORPykAQN2sAT0aO32mwlm0RdeqdzCNcYmlsece1q0KpcxFUb1Ml5yo7mVkt9TDHg8VS8+KBMYV
        e8FPD2iEe9nvMJOx5YfXLl2CN/Rn8jlNhkRx9pg+tmrErUo15BJU2cobe+uCnMBZ5N3Yt1M1NDA0f
        4BrcwFjBXZiiB2HUEPbSjdNInuscZdZSXeq6+LwlHGn3EPrcgWNoJHEb8lSVVrC1qP6SG1p9EZ55X
        CsYihEoj1iQBdmBUfvRiuaduzVp+DFfzqrHZ7eE0rnqYyAJSkyzC814ukSZZ10zryEg9E4Z1Oo6U/
        kWDfT2QxA==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQf6o-00067p-HJ
        for linux-xfs@vger.kernel.org; Fri, 01 Nov 2019 22:09:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 23/34] xfs: remove the ->data_dot_entry_p and ->data_dotdot_entry_p methods
Date:   Fri,  1 Nov 2019 15:07:08 -0700
Message-Id: <20191101220719.29100-24-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191101220719.29100-1-hch@lst.de>
References: <20191101220719.29100-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Replace the only user of the ->data_dot_entry_p and ->data_dotdot_entry_p
dir ops methods with direct calculations using ->data_dot_offset and
->data_dotdot_offset.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.c  | 52 ----------------------------------
 fs/xfs/libxfs/xfs_dir2.h       |  4 ---
 fs/xfs/libxfs/xfs_dir2_block.c |  4 +--
 3 files changed, 2 insertions(+), 58 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index 1c72b46344d6..84f8355072b4 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -111,26 +111,6 @@ xfs_dir3_data_entry_tag_p(
 		xfs_dir3_data_entsize(dep->namelen) - sizeof(__be16));
 }
 
-/*
- * location of . and .. in data space (always block 0)
- */
-static struct xfs_dir2_data_entry *
-xfs_dir2_data_dot_entry_p(
-	struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + sizeof(struct xfs_dir2_data_hdr));
-}
-
-static struct xfs_dir2_data_entry *
-xfs_dir2_data_dotdot_entry_p(
-	struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + sizeof(struct xfs_dir2_data_hdr) +
-				XFS_DIR2_DATA_ENTSIZE(1));
-}
-
 static struct xfs_dir2_data_entry *
 xfs_dir2_data_first_entry_p(
 	struct xfs_dir2_data_hdr *hdr)
@@ -141,15 +121,6 @@ xfs_dir2_data_first_entry_p(
 				XFS_DIR2_DATA_ENTSIZE(2));
 }
 
-static struct xfs_dir2_data_entry *
-xfs_dir2_ftype_data_dotdot_entry_p(
-	struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + sizeof(struct xfs_dir2_data_hdr) +
-				XFS_DIR3_DATA_ENTSIZE(1));
-}
-
 static struct xfs_dir2_data_entry *
 xfs_dir2_ftype_data_first_entry_p(
 	struct xfs_dir2_data_hdr *hdr)
@@ -160,23 +131,6 @@ xfs_dir2_ftype_data_first_entry_p(
 				XFS_DIR3_DATA_ENTSIZE(2));
 }
 
-static struct xfs_dir2_data_entry *
-xfs_dir3_data_dot_entry_p(
-	struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + sizeof(struct xfs_dir3_data_hdr));
-}
-
-static struct xfs_dir2_data_entry *
-xfs_dir3_data_dotdot_entry_p(
-	struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + sizeof(struct xfs_dir3_data_hdr) +
-				XFS_DIR3_DATA_ENTSIZE(1));
-}
-
 static struct xfs_dir2_data_entry *
 xfs_dir3_data_first_entry_p(
 	struct xfs_dir2_data_hdr *hdr)
@@ -242,8 +196,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 				XFS_DIR2_DATA_ENTSIZE(2),
 	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
 
-	.data_dot_entry_p = xfs_dir2_data_dot_entry_p,
-	.data_dotdot_entry_p = xfs_dir2_data_dotdot_entry_p,
 	.data_first_entry_p = xfs_dir2_data_first_entry_p,
 	.data_entry_p = xfs_dir2_data_entry_p,
 	.data_unused_p = xfs_dir2_data_unused_p,
@@ -264,8 +216,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 				XFS_DIR3_DATA_ENTSIZE(2),
 	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
 
-	.data_dot_entry_p = xfs_dir2_data_dot_entry_p,
-	.data_dotdot_entry_p = xfs_dir2_ftype_data_dotdot_entry_p,
 	.data_first_entry_p = xfs_dir2_ftype_data_first_entry_p,
 	.data_entry_p = xfs_dir2_data_entry_p,
 	.data_unused_p = xfs_dir2_data_unused_p,
@@ -286,8 +236,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 				XFS_DIR3_DATA_ENTSIZE(2),
 	.data_entry_offset = sizeof(struct xfs_dir3_data_hdr),
 
-	.data_dot_entry_p = xfs_dir3_data_dot_entry_p,
-	.data_dotdot_entry_p = xfs_dir3_data_dotdot_entry_p,
 	.data_first_entry_p = xfs_dir3_data_first_entry_p,
 	.data_entry_p = xfs_dir3_data_entry_p,
 	.data_unused_p = xfs_dir3_data_unused_p,
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 61cc9ae837d5..0198887a1c54 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -45,10 +45,6 @@ struct xfs_dir_ops {
 	xfs_dir2_data_aoff_t data_first_offset;
 	size_t	data_entry_offset;
 
-	struct xfs_dir2_data_entry *
-		(*data_dot_entry_p)(struct xfs_dir2_data_hdr *hdr);
-	struct xfs_dir2_data_entry *
-		(*data_dotdot_entry_p)(struct xfs_dir2_data_hdr *hdr);
 	struct xfs_dir2_data_entry *
 		(*data_first_entry_p)(struct xfs_dir2_data_hdr *hdr);
 	struct xfs_dir2_data_entry *
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 5877272dc63e..34e0cdf03950 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -1148,7 +1148,7 @@ xfs_dir2_sf_to_block(
 	/*
 	 * Create entry for .
 	 */
-	dep = dp->d_ops->data_dot_entry_p(hdr);
+	dep = (void *)hdr + dp->d_ops->data_dot_offset;
 	dep->inumber = cpu_to_be64(dp->i_ino);
 	dep->namelen = 1;
 	dep->name[0] = '.';
@@ -1162,7 +1162,7 @@ xfs_dir2_sf_to_block(
 	/*
 	 * Create entry for ..
 	 */
-	dep = dp->d_ops->data_dotdot_entry_p(hdr);
+	dep = (void *)hdr + dp->d_ops->data_dotdot_offset;
 	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_parent_ino(sfp));
 	dep->namelen = 2;
 	dep->name[0] = dep->name[1] = '.';
-- 
2.20.1

