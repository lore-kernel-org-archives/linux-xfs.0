Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78C6DCA9EAF
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 02:19:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41C0C21928
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 02:19:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iIiaAtTW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389834AbfJYCTC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 22:19:02 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37824 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389816AbfJYCTC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 22:19:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=p03q7FZpoHOwFH5UX68UZOGS730FW1YHorDWwyWhnRU=; b=iIiaAtTW1TLhF/rwpOH9rIju/
        ypHRqDE31pr47pn86DZr1ZORDHzL69KVUGpnhUo2u8MXoWNnN6uZV40RptaRJ/GdbQ9E/HQWKI8l9
        8vm0BjJMfRFSpHEgE8FfAbM0vd3fZXlcgZwgTouKeRfjU57yF+v6QWHYHiFHuOw8cd4RjM6I1ownr
        2CUiZPMiH6kua/IwigfA8Ohm1iu/jhq9EizX4Dq+Wcemz2CuBQsi7Bjfyu3YFLl4FpBkm/4WaEasz
        LANN3PRxpANmdNTWcOeTMWgBzzgZH5vrXIOh0NzI5xmmpRLcYVQ9ZOL470gR95vSpjEaK1YouB9f8
        IbhRHbZ4Q==;
Received: from p91006-ipngnfx01marunouchi.tokyo.ocn.ne.jp ([153.156.43.6] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iNpBu-0005Vh-1I
        for linux-xfs@vger.kernel.org; Fri, 25 Oct 2019 02:19:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: use xfs_inode_buftarg in xfs_file_ioctl
Date:   Fri, 25 Oct 2019 11:18:52 +0900
Message-Id: <20191025021852.20172-4-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025021852.20172-1-hch@lst.de>
References: <20191025021852.20172-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index b7b5c17131cd..0fed56d3175c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -2135,10 +2135,8 @@ xfs_file_ioctl(
 		return xfs_ioc_space(filp, cmd, &bf);
 	}
 	case XFS_IOC_DIOINFO: {
-		struct dioattr	da;
-		xfs_buftarg_t	*target =
-			XFS_IS_REALTIME_INODE(ip) ?
-			mp->m_rtdev_targp : mp->m_ddev_targp;
+		struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
+		struct dioattr		da;
 
 		da.d_mem =  da.d_miniosz = target->bt_logical_sectorsize;
 		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
-- 
2.20.1

