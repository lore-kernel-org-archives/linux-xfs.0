Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B866C43603
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D70B2173E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:54:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iitOZEPF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbfLLKy7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Dec 2019 05:54:59 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53220 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728832AbfLLKy6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Dec 2019 05:54:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YlvSjXxFwoJ5P13N2WGDqvpgvTEwdBcflC5X1Xf9n78=; b=iitOZEPFkorrS9e4GsZFzqBPSx
        K2RME3C8NY02snC/O7x4snxSn/8cJeVfc4JR0INso8VJNTyNehjT0IYhghfQpAHKFtktJnnW9vNyG
        L2wiohviYtEgt5M9x8eh1IGyaMDuz2NPAH6XNQ0KfzND2YNXffoiShy1CuAWo4FfrQ2qa5rwYGUkQ
        Oh7mQ0o9+ufmiUAxQBn69FemMKd8xpKpGudTNXYVxXRIF+rwnDaWfJhHG8I1pGDRyaKP+cPgI8/HP
        TaojSb3MXDFh73BesPR7EuvjjDDBOpYm/h6KFwvgsoEWsGvMRo8FzCDrauh9uf14sIyILW5hr4IOo
        Gfe6JH0A==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ifM7W-0001AP-AX; Thu, 12 Dec 2019 10:54:58 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 10/33] xfs: remove the name == NULL check from xfs_attr_args_init
Date:   Thu, 12 Dec 2019 11:54:10 +0100
Message-Id: <20191212105433.1692-11-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191212105433.1692-1-hch@lst.de>
References: <20191212105433.1692-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

All callers provide a valid name pointer, remove the redundant check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1ac0d6f0560c..4a120a6483ee 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -64,10 +64,6 @@ xfs_attr_args_init(
 	const unsigned char	*name,
 	int			flags)
 {
-
-	if (!name)
-		return -EINVAL;
-
 	memset(args, 0, sizeof(*args));
 	args->geo = dp->i_mount->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
-- 
2.20.1

