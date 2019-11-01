Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1CECCA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81EA62085B
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:09:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LHaBDF/+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfKAWJg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 18:09:36 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53782 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbfKAWJg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 18:09:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hWZNweXLRWS7dFjTHJqBlIuPJnMEebbmeqBdGcKv0vQ=; b=LHaBDF/+G+oMytleMeqj9QCa7
        VMtT6Xy9sBV/W3TwrfWWLM1NHwKjh+D14exCXZrJcs27oxZ75R7Ugi+Ipw+6c2CNQ8+qTc7z2W6K4
        1K4snNqLsCmK5Vc6vRN7y/6HyBoBjzmhspVonDxG/GOeXxPEVykw7AW9Re1hpiRKc4NcbD2RwqirI
        J4bsmMGYIwfq5x9Pe964dT1TlPxj7ffesvH6WkicW6PZPLwB0WINdf2Gq2jaoviIwFb56EGqN0zFH
        9fCFKZORaOWKEAHuk6Z+x/IcoI7y5a1Sdpu/rIpaNpcprAVZlqsF1VGjJAqSYGqwopn40Vw+VBmHf
        uae3raoyg==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQf6t-00068R-P7
        for linux-xfs@vger.kernel.org; Fri, 01 Nov 2019 22:09:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 24/34] xfs: remove the unused ->data_first_entry_p method
Date:   Fri,  1 Nov 2019 15:07:09 -0700
Message-Id: <20191101220719.29100-25-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.c | 33 ---------------------------------
 fs/xfs/libxfs/xfs_dir2.h      |  2 --
 2 files changed, 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index 84f8355072b4..35edf470efc8 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -111,36 +111,6 @@ xfs_dir3_data_entry_tag_p(
 		xfs_dir3_data_entsize(dep->namelen) - sizeof(__be16));
 }
 
-static struct xfs_dir2_data_entry *
-xfs_dir2_data_first_entry_p(
-	struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + sizeof(struct xfs_dir2_data_hdr) +
-				XFS_DIR2_DATA_ENTSIZE(1) +
-				XFS_DIR2_DATA_ENTSIZE(2));
-}
-
-static struct xfs_dir2_data_entry *
-xfs_dir2_ftype_data_first_entry_p(
-	struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + sizeof(struct xfs_dir2_data_hdr) +
-				XFS_DIR3_DATA_ENTSIZE(1) +
-				XFS_DIR3_DATA_ENTSIZE(2));
-}
-
-static struct xfs_dir2_data_entry *
-xfs_dir3_data_first_entry_p(
-	struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + sizeof(struct xfs_dir3_data_hdr) +
-				XFS_DIR3_DATA_ENTSIZE(1) +
-				XFS_DIR3_DATA_ENTSIZE(2));
-}
-
 static struct xfs_dir2_data_free *
 xfs_dir2_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
 {
@@ -196,7 +166,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 				XFS_DIR2_DATA_ENTSIZE(2),
 	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
 
-	.data_first_entry_p = xfs_dir2_data_first_entry_p,
 	.data_entry_p = xfs_dir2_data_entry_p,
 	.data_unused_p = xfs_dir2_data_unused_p,
 };
@@ -216,7 +185,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 				XFS_DIR3_DATA_ENTSIZE(2),
 	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
 
-	.data_first_entry_p = xfs_dir2_ftype_data_first_entry_p,
 	.data_entry_p = xfs_dir2_data_entry_p,
 	.data_unused_p = xfs_dir2_data_unused_p,
 };
@@ -236,7 +204,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 				XFS_DIR3_DATA_ENTSIZE(2),
 	.data_entry_offset = sizeof(struct xfs_dir3_data_hdr),
 
-	.data_first_entry_p = xfs_dir3_data_first_entry_p,
 	.data_entry_p = xfs_dir3_data_entry_p,
 	.data_unused_p = xfs_dir3_data_unused_p,
 };
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 0198887a1c54..20417c42ca6f 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -45,8 +45,6 @@ struct xfs_dir_ops {
 	xfs_dir2_data_aoff_t data_first_offset;
 	size_t	data_entry_offset;
 
-	struct xfs_dir2_data_entry *
-		(*data_first_entry_p)(struct xfs_dir2_data_hdr *hdr);
 	struct xfs_dir2_data_entry *
 		(*data_entry_p)(struct xfs_dir2_data_hdr *hdr);
 	struct xfs_dir2_data_unused *
-- 
2.20.1

