Return-Path: <SRS0=M45Y=YE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB79ECE58C
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Oct 2019 13:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C50C2089F
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Oct 2019 13:03:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XTnfyYyQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbfJKND3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Oct 2019 09:03:29 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33156 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728002AbfJKND3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Oct 2019 09:03:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=JbwZKtVczaw5Zkj4IM7HTU7yY0pW3H1qGsxpPQ+i1FI=; b=XTnfyYyQ6kWzp0zgRKTW1WC5Z
        8HPUD8s0OJg9mppju2erhtL6VjL/k04sRfmSNjyrW9n5SknDQ/vI5EDrPcg1fg6N4RPPYzL8USyx6
        1yD4BxZ03Llta/qt3b7bCoq0/rXxOCUvBf2oqp0c+nCYNgSxwFuSas+TipsBz+t671vf5IuEBGdE9
        XjPNRGeqA1KgzezW+Ko4vD+mPXeMz2cxKGgEMz/VnZ4aMDSa9fLj/DV8IXa+rQD5RisOJDnnmJq29
        vOyoNs+ORAVBjofrZwTZWUGgN32EqoMrUU8K94f0ayhJCHxGK9pKcmry9dvHlIwL9WLL9J2y8SGxD
        QTVS+Tf7Q==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iIuZt-0007AI-0q
        for linux-xfs@vger.kernel.org; Fri, 11 Oct 2019 13:03:29 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: ignore extent size hints for always COW inodes
Date:   Fri, 11 Oct 2019 15:03:16 +0200
Message-Id: <20191011130316.13373-3-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191011130316.13373-1-hch@lst.de>
References: <20191011130316.13373-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There is no point in applying extent size hints for always COW inodes,
as we would just have to COW any extra allocation beyond the data
actually written.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 18f4b262e61c..2e94deb4610a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -55,6 +55,12 @@ xfs_extlen_t
 xfs_get_extsz_hint(
 	struct xfs_inode	*ip)
 {
+	/*
+	 * No point in aligning allocations if we need to COW to actually
+	 * write to them.
+	 */
+	if (xfs_is_always_cow_inode(ip))
+		return 0;
 	if ((ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE) && ip->i_d.di_extsize)
 		return ip->i_d.di_extsize;
 	if (XFS_IS_REALTIME_INODE(ip))
-- 
2.20.1

