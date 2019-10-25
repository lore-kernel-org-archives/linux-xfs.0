Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD61CA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 15:04:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46B8820684
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 15:04:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mXh5fEOp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409499AbfJYPEG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 11:04:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48660 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408186AbfJYPEG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 11:04:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2P2Tv6ZaJV3JoGocfC3kgo4RULwynWfCCC747GP7MU4=; b=mXh5fEOpmxch0tsPnvQF0LXND
        xNoVS+XUzkYGNvJk8xumqN4fXUufDHxRxcx8BqR0Cou1pifDaG3CcDCntXq2RMl/TIdPP8H8sHvNI
        yHJrm34kEniGGofFlvrdhpi7pAI4UiFSRi1VqnuSJ9/hpi6tJjQ0vvIYtPIm1anh/t3Pe+HLb9H59
        DQk3F8Ri0uLS8RfudsEtvsZP2nWW6K9pFlwerQGpqdotRNrQcgGmpR7qTbBXslNZ5+oZz340KSEP1
        bIxyj/Gxog7vl3MC+4XdmGtK7ZMjZLhzJ2eBKzIpuEr2N9CPVJeqfFOvTTnTnv5PM9IlZIrGD3Xpa
        QDHxphTRw==;
Received: from [46.189.28.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iO18H-0006Th-2R
        for linux-xfs@vger.kernel.org; Fri, 25 Oct 2019 15:04:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/8] xfs: mark xfs_eof_alignment static
Date:   Fri, 25 Oct 2019 17:03:30 +0200
Message-Id: <20191025150336.19411-3-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025150336.19411-1-hch@lst.de>
References: <20191025150336.19411-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 2 +-
 fs/xfs/xfs_iomap.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 49fbc99c18ff..c803a8efa8ff 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -116,7 +116,7 @@ xfs_iomap_end_fsb(
 		   XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes));
 }
 
-xfs_extlen_t
+static xfs_extlen_t
 xfs_eof_alignment(
 	struct xfs_inode	*ip,
 	xfs_extlen_t		extsize)
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 7aed28275089..d5b292bdaf82 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -17,7 +17,6 @@ int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
 
 int xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
 		struct xfs_bmbt_irec *, u16);
-xfs_extlen_t xfs_eof_alignment(struct xfs_inode *ip, xfs_extlen_t extsize);
 
 static inline xfs_filblks_t
 xfs_aligned_fsb_count(
-- 
2.20.1

