Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77FBBC5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52477206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iVhpoJIP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbfKGSZS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:25:18 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44152 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfKGSZR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:25:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uOn6cxy0j6W0OqesY9/rRazeJrWdyrlkkjFDJ49U9kM=; b=iVhpoJIP3KIYCYpzRnAWrCeVEN
        7XsM6lRAyHUhUKE2sSVRjWHQRGUKMQvOSoIkKUJnQwZG67X9NQlBueeU7IzYYWPKFkJYKWthUA5yP
        ujz6XHSh28U0ILiKorll9BE9GRjy2HdvdqL83wJ6zNrQORQLZTqb9R6W2WrjPkrcD5Xm4T1/NeN6m
        KFiCkFrcU1eRd/nl0ng2Ps8hMWKLkLE6dTkIafv8/cVgiV4leuQ6XiQOI49a+RuU8uPdPbbgIdSWF
        Aq4zPC5ULXL/+1wQLH2pqGrKv+c++EkCz5vnLR8zciwYEcENHhEWBp2Ise6zsHYkRH36MmUnfRWUX
        hrpaH9Iw==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmT7-0004Mj-8W; Thu, 07 Nov 2019 18:25:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 24/46] xfs: remove the unused ->data_first_entry_p method
Date:   Thu,  7 Nov 2019 19:23:48 +0100
Message-Id: <20191107182410.12660-25-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_format.c | 33 ---------------------------------
 fs/xfs/libxfs/xfs_dir2.h      |  2 --
 2 files changed, 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index 1c72b46344d6..19343c65be91 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -131,16 +131,6 @@ xfs_dir2_data_dotdot_entry_p(
 				XFS_DIR2_DATA_ENTSIZE(1));
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
 static struct xfs_dir2_data_entry *
 xfs_dir2_ftype_data_dotdot_entry_p(
 	struct xfs_dir2_data_hdr *hdr)
@@ -150,16 +140,6 @@ xfs_dir2_ftype_data_dotdot_entry_p(
 				XFS_DIR3_DATA_ENTSIZE(1));
 }
 
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
 static struct xfs_dir2_data_entry *
 xfs_dir3_data_dot_entry_p(
 	struct xfs_dir2_data_hdr *hdr)
@@ -177,16 +157,6 @@ xfs_dir3_data_dotdot_entry_p(
 				XFS_DIR3_DATA_ENTSIZE(1));
 }
 
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
@@ -244,7 +214,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 
 	.data_dot_entry_p = xfs_dir2_data_dot_entry_p,
 	.data_dotdot_entry_p = xfs_dir2_data_dotdot_entry_p,
-	.data_first_entry_p = xfs_dir2_data_first_entry_p,
 	.data_entry_p = xfs_dir2_data_entry_p,
 	.data_unused_p = xfs_dir2_data_unused_p,
 };
@@ -266,7 +235,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 
 	.data_dot_entry_p = xfs_dir2_data_dot_entry_p,
 	.data_dotdot_entry_p = xfs_dir2_ftype_data_dotdot_entry_p,
-	.data_first_entry_p = xfs_dir2_ftype_data_first_entry_p,
 	.data_entry_p = xfs_dir2_data_entry_p,
 	.data_unused_p = xfs_dir2_data_unused_p,
 };
@@ -288,7 +256,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 
 	.data_dot_entry_p = xfs_dir3_data_dot_entry_p,
 	.data_dotdot_entry_p = xfs_dir3_data_dotdot_entry_p,
-	.data_first_entry_p = xfs_dir3_data_first_entry_p,
 	.data_entry_p = xfs_dir3_data_entry_p,
 	.data_unused_p = xfs_dir3_data_unused_p,
 };
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 61cc9ae837d5..9169da84065a 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -49,8 +49,6 @@ struct xfs_dir_ops {
 		(*data_dot_entry_p)(struct xfs_dir2_data_hdr *hdr);
 	struct xfs_dir2_data_entry *
 		(*data_dotdot_entry_p)(struct xfs_dir2_data_hdr *hdr);
-	struct xfs_dir2_data_entry *
-		(*data_first_entry_p)(struct xfs_dir2_data_hdr *hdr);
 	struct xfs_dir2_data_entry *
 		(*data_entry_p)(struct xfs_dir2_data_hdr *hdr);
 	struct xfs_dir2_data_unused *
-- 
2.20.1

