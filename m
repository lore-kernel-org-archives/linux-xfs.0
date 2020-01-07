Return-Path: <SRS0=eQYP=24=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3CA9C33C8C
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 16:54:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C3D824679
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 16:54:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WWExcu9x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgAGQyw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 11:54:52 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52224 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728478AbgAGQyw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 11:54:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=XpoEisxqNSAGBrb+u1AqyRI5z7tK8Mb8j9qM37grzvg=; b=WWExcu9xJr2Is39KQzdu5FN8/
        +mTGHnHpfGieo0ICZZLnD96qMz+QmY++Y4maBcbJ8DKpPc/+Idbw8GnQWA9rwVVC0CuMZbJVldBPV
        kE78vRkKtYhnHGlojgfnD0cbZrSf0+IpzjJAtnCcQ9PyAATd1I2AI/XFxbjadHchU5MTirQ3c+uHX
        Dbn0uZIZjZvtsnDOmLO9waKmhBt9xtncnLJEOIsx3fhCKPmdqgpOC110N8l+gY+1oqcb2UsjifRQM
        /dMqjd5ky3Ij9WEQz1s7K+qUM92rXaQpEXXlH1Nil2oejWrXiYVCvmvwmKqxlpV56OJNlEwMm2BTf
        T0OrP/DoQ==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ios83-0002QR-4M
        for linux-xfs@vger.kernel.org; Tue, 07 Jan 2020 16:54:51 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs: also remove cached ACLs when removing the underlying attr
Date:   Tue,  7 Jan 2020 17:54:41 +0100
Message-Id: <20200107165442.262020-4-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107165442.262020-1-hch@lst.de>
References: <20200107165442.262020-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We should not just invalidate the ACL when setting the underlying
attribute, but also when removing it.  The ioctl interface gets that
right, but the normal xattr inteface skipped the xfs_forget_acl due
to an early return.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_xattr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 383f0203d103..2288f20ae282 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -74,10 +74,11 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
 	if (flags & XATTR_REPLACE)
 		xflags |= ATTR_REPLACE;
 
-	if (!value)
-		return xfs_attr_remove(ip, (unsigned char *)name, xflags);
-	error = xfs_attr_set(ip, (unsigned char *)name,
+	if (value)
+		error = xfs_attr_set(ip, (unsigned char *)name,
 				(void *)value, size, xflags);
+	else
+		error = xfs_attr_remove(ip, (unsigned char *)name, xflags);
 	if (!error)
 		xfs_forget_acl(inode, name, xflags);
 
-- 
2.24.1

